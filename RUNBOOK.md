# RUNBOOK: **rsvp-modern** — Dev & Prod with Docker Compose

This guide explains how to run the project in **local development** and in **production** on a Debian server using Docker Compose.

---

## Prerequisites

- **Docker** & **Docker Compose v2**
  - macOS: Docker Desktop
  - Linux (Debian server): Docker Engine + compose plugin
- Git access to this repo
- (Dev only, optional) Node 20+ and Java 21 if you prefer running outside of Docker

> All instructions below assume you’re at the repository root: `rsvp-modern/`.

---

## Repo layout (relevant bits)

```
rsvp-modern/
  server/                 # Spring Boot (Java 21)
  web/                    # React + Vite
  docker-compose.yml      # PRODUCTION compose (Nginx serves web; server & db are internal)
  docker-compose.dev.yml  # DEVELOPMENT compose (Vite + Gradle bootRun)
  .env                    # PRODUCTION env (DB creds, profile)
  .env.dev                # DEVELOPMENT env (local DB creds/port)
  RUNBOOK.md              # this file
```

---

# Local Development (hot reload)

### 1) Create `.env.dev`

```env
# .env.dev
POSTGRES_DB=rsvp
POSTGRES_USER=rsvp
POSTGRES_PASSWORD=rsvp
PG_PORT=5433              # avoid clashing with a local Postgres on 5432
```

### 2) Create `docker-compose.dev.yml`

```yaml
services:
  db:
    image: postgres:16
    environment:
      POSTGRES_DB: ${POSTGRES_DB:-rsvp}
      POSTGRES_USER: ${POSTGRES_USER:-rsvp}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD:-rsvp}
    ports:
      - "${PG_PORT:-5433}:5432"
    volumes:
      - rsvp_pgdata_dev:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${POSTGRES_USER:-rsvp} -d ${POSTGRES_DB:-rsvp}"]
      interval: 5s
      timeout: 5s
      retries: 20
    restart: unless-stopped

  server:
    image: gradle:8.10.0-jdk21
    working_dir: /home/gradle/project
    volumes:
      - ./server:/home/gradle/project
      - gradle-cache:/home/gradle/.gradle
    environment:
      SPRING_PROFILES_ACTIVE: dev
      SPRING_DATASOURCE_URL: jdbc:postgresql://db:5432/${POSTGRES_DB:-rsvp}
      SPRING_DATASOURCE_USERNAME: ${POSTGRES_USER:-rsvp}
      SPRING_DATASOURCE_PASSWORD: ${POSTGRES_PASSWORD:-rsvp}
    command: sh -lc "./gradlew bootRun --no-daemon"
    ports:
      - "8080:8080"
    depends_on:
      db:
        condition: service_healthy

  web:
    image: node:20-alpine
    working_dir: /app
    volumes:
      - ./web:/app
      - web-node-modules:/app/node_modules
    environment:
      VITE_API_URL: http://localhost:8080/api
    command: sh -lc "npm install && npm run dev -- --host"
    ports:
      - "5173:5173"
    depends_on:
      - server

volumes:
  rsvp_pgdata_dev:
  gradle-cache:
  web-node-modules:
```

### 3) Run dev stack

```bash
docker compose --env-file ./.env.dev -f docker-compose.dev.yml up --build
```

- Web: [http://localhost:5173](http://localhost:5173)
- API: [http://localhost:8080/api](http://localhost:8080/api)
- DB: `psql postgresql://rsvp:rsvp@localhost:5433/rsvp`

### 4) Common dev workflows

- **Only DB** (run server/web on your host):
  ```bash
  docker compose --env-file ./.env.dev -f docker-compose.dev.yml up -d db
  ```
- **Seed a sample event**:
  ```bash
  docker compose --env-file ./.env.dev -f docker-compose.dev.yml exec db \
    psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" \
    -c "insert into events(date,start_time,capacity,notes) values (current_date,'18:00',50,'Community dinner');"
  ```
- **Stop stack (keep DB)**: `docker compose -f docker-compose.dev.yml down`
- **Start fresh DB (wipe)**: `docker compose -f docker-compose.dev.yml down -v`

> Tip: For faster Java reloads, add `org.springframework.boot:spring-boot-devtools` to the server dependencies.

---

# Production (Debian server) with Docker Compose

**What we run in prod:**

- `db` (Postgres 16) with a **bind mount** at `/srv/rsvp/pgdata` for persistence
- `server` (Spring Boot) with `SPRING_PROFILES_ACTIVE=prod`
- `web` (Nginx) that serves the React build and proxies `/api` → `server:8080`

### 1) Ensure Docker/Compose are installed on Debian

Follow Docker’s official instructions for Engine + Compose plugin, then add your user to the `docker` group (optional).

### 2) Create `.env` (prod)

```env
# .env
POSTGRES_DB=rsvp
POSTGRES_USER=rsvp
POSTGRES_PASSWORD=change-me-strong
SPRING_PROFILES_ACTIVE=prod
```

> Keep this file private: `chmod 600 .env`

### 3) Prepare the bind mount path once

```bash
sudo mkdir -p /srv/rsvp/pgdata
sudo chown -R 999:999 /srv/rsvp/pgdata   # postgres image runs as uid 999
sudo chmod 700 /srv/rsvp/pgdata
```

### 4) Production `docker-compose.yml`

```yaml
services:
  db:
    image: postgres:16
    environment:
      POSTGRES_DB: ${POSTGRES_DB}
      POSTGRES_USER: ${POSTGRES_USER}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
    volumes:
      - /srv/rsvp/pgdata:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${POSTGRES_USER} -d ${POSTGRES_DB}"]
      interval: 5s
      timeout: 5s
      retries: 20
    restart: unless-stopped

  server:
    build: ./server
    environment:
      SPRING_PROFILES_ACTIVE: ${SPRING_PROFILES_ACTIVE:-prod}
      SPRING_DATASOURCE_URL: jdbc:postgresql://db:5432/${POSTGRES_DB}
      SPRING_DATASOURCE_USERNAME: ${POSTGRES_USER}
      SPRING_DATASOURCE_PASSWORD: ${POSTGRES_PASSWORD}
    depends_on:
      db:
        condition: service_healthy
    restart: unless-stopped

  web:
    build:
      context: ./web
      dockerfile: Dockerfile.prod
    ports:
      - "80:80"
    depends_on:
      - server
    restart: unless-stopped
```

> `web/Dockerfile.prod` builds the React app and serves it via Nginx; `web/nginx.conf` proxies `/api` to `server:8080`.

### 5) First deploy / updates

```bash
# from the repo root on the server
sed -i '/^version:/d' docker-compose.yml || true  # (if present)

# build images and start
docker compose --env-file ./.env up --build -d

# check services
docker compose ps
docker compose logs -f server
```

- App: `http://<server-ip>/` (served by Nginx)
- API (proxied): `http://<server-ip>/api/events`

### 6) Backups (cron-ready script)

Create `/usr/local/bin/backup_rsvp.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail
PROJECT_DIR="/opt/rsvp-modern"   # path to your compose project
BACKUP_DIR="/var/backups/rsvp"

set -a; source "${PROJECT_DIR}/.env"; set +a
mkdir -p "${BACKUP_DIR}"
cd "${PROJECT_DIR}"

docker compose up -d db >/dev/null
STAMP="$(date +%F_%H-%M-%S)"
OUT="${BACKUP_DIR}/rsvp-${STAMP}.sql.gz"

docker compose exec -T db pg_dump -U "${POSTGRES_USER}" -d "${POSTGRES_DB}" | gzip -9 > "${OUT}"
find "${BACKUP_DIR}" -type f -name 'rsvp-*.sql.gz' -mtime +14 -delete
```

Secure it and create the backup dir:

```bash
sudo install -m 750 -o root -g root /usr/local/bin/backup_rsvp.sh /usr/local/bin/backup_rsvp.sh
sudo mkdir -p /var/backups/rsvp && sudo chown root:root /var/backups/rsvp && sudo chmod 750 /var/backups/rsvp
```

Cron entry `/etc/cron.d/backup_rsvp`:

```cron
17 2 * * * root /usr/local/bin/backup_rsvp.sh >> /var/log/backup_rsvp.log 2>&1
```

### 7) Restoring a backup

```bash
# choose a .sql.gz file under /var/backups/rsvp
zcat /var/backups/rsvp/rsvp-YYYY-MM-DD_HH-MM-SS.sql.gz | \
  docker compose exec -T db psql -U "$POSTGRES_USER" -d "$POSTGRES_DB"
```

### 8) Common prod ops

- **Rebuild/redeploy after code changes:** `docker compose --env-file ./.env up -d --build`
- **View logs:** `docker compose logs -f server` (or `web` / `db`)
- **Exec into DB:** `docker compose exec db psql -U "$POSTGRES_USER" -d "$POSTGRES_DB"`
- **Stop stack (keeps data):** `docker compose down`
- **⚠️ Wipe everything (including DB):** `docker compose down -v`

### 9) Optional hardening

- Put **Caddy** or **Nginx + certbot** in front for HTTPS (port 443)
- Restrict firewall to 80/443 (and SSH): `ufw allow 80,443/tcp` `ufw enable`
- Move secrets to a restricted location or secrets manager

---

## Troubleshooting quick hits

- **Port already in use (5432/5433/8080/5173/80):** change host ports in compose or stop the conflicting service.
- **Flyway “Unsupported Database: PostgreSQL 16.x”:** ensure `server/build.gradle.kts` includes both `flyway-core` **and** `flyway-database-postgresql` at the same version.
- **React dev server 404s to API:** check `VITE_API_URL` and that the server is reachable at `http://localhost:8080/api` (dev) or proxied `/api` (prod).
- **DB credentials changes not taking effect:** they only apply on first initialization of the PG data dir. If you need to re-init, back up, then recreate the volume/dir.

---

## Quick commands (cheat sheet)

```bash
# DEV
docker compose --env-file ./.env.dev -f docker-compose.dev.yml up --build

# PROD (on server)
docker compose --env-file ./.env up -d --build

# Logs
docker compose logs -f server

# DB shell
docker compose exec db psql -U "$POSTGRES_USER" -d "$POSTGRES_DB"
```

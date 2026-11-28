# RSVP Modern - Deployment Guide

This guide provides step-by-step instructions for deploying the RSVP application to a cloud server and migrating data from a local environment.

---

## Prerequisites

- A Debian-based cloud server (tested on IONOS, but works with AWS, DigitalOcean, Linode, etc.)
- SSH access to the server
- Git repository access
- Local development environment running (for data migration)

---

## Part 1: Server Setup

### Step 1: Install Docker and Docker Compose

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install required packages
sudo apt install -y ca-certificates curl gnupg lsb-release

# Add Docker's official GPG key
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add Docker repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add your user to docker group (so you don't need sudo)
sudo usermod -aG docker $USER

# Log out and back in, or run:
newgrp docker

# Verify installation
docker --version
docker compose version
```

### Step 2: Clone the Repository

```bash
# Navigate to home directory
cd /home/$USER

# Clone the repository
git clone https://github.com/mustafa78/rsvp-modern.git
cd rsvp-modern

# Ensure you have the latest code
git pull origin main
```

### Step 3: Create Environment File

```bash
# Copy the dev environment file
cp .env.dev .env.dev.server

# Edit if needed (defaults should work)
nano .env.dev.server
```

Default `.env.dev` contents:
```
POSTGRES_USER=rsvp
POSTGRES_PASSWORD=rsvp
POSTGRES_DB=rsvp
```

### Step 4: Start the Application

> **Security warning.** On a server, always start with `docker-compose.qa.yml`.
> Never run `docker-compose.dev.yml` on a machine other people can reach: it
> starts the Vite dev server, and a dev server reachable from the internet can
> be taken over remotely. This happened to the QA site in November 2026.
> `docker-compose.qa.yml` builds the frontend once and serves it with nginx.
> The database and API are bound to `127.0.0.1` and are not reachable from outside.

```bash
# Start the QA environment (database and backend settings come from docker-compose.dev.yml)
docker compose --env-file ./.env.dev -f docker-compose.qa.yml up -d --build

# Check if containers are running
docker compose --env-file ./.env.dev -f docker-compose.qa.yml ps

# View logs if needed
docker compose --env-file ./.env.dev -f docker-compose.qa.yml logs -f
```

After pulling new code, add `--force-recreate`:

```bash
docker compose --env-file ./.env.dev -f docker-compose.qa.yml up -d --build --force-recreate
```

Without `--force-recreate` only the frontend is rebuilt. The backend container
keeps running the code it started with, because its settings have not changed.
There is no hot reload on QA.

Elsewhere in this guide, commands that say `-f docker-compose.dev.yml` should be
run with `-f docker-compose.qa.yml` on a server.

Set a strong `POSTGRES_PASSWORD` in `.env.dev` on a server. Do not keep the
default `rsvp`.

### Step 5: Configure Firewall

#### Using UFW (Recommended)
```bash
sudo apt install -y ufw
sudo ufw allow 22/tcp    # SSH
sudo ufw allow 5173/tcp  # Frontend (nginx, static files)
# Do NOT open 8080 (API) or 5433 (database). The frontend proxies /api itself.
sudo ufw enable
sudo ufw status
```

#### Using iptables
```bash
sudo iptables -A INPUT -p tcp --dport 5173 -j ACCEPT
# Do NOT open 8080 (API) or 5433 (database).
```

### Step 6: Configure CORS for Domain Access

When accessing the application via a domain name (instead of localhost), you need to configure CORS (Cross-Origin Resource Sharing) to allow the frontend to communicate with the backend.

#### Option A: Set Environment Variable (Recommended)

Add the CORS origins to your `.env.dev` file:

```bash
# Edit your environment file
nano .env.dev

# Add this line (replace with your actual domain)
CORS_ALLOWED_ORIGINS=http://localhost:5173,http://yourdomain.com:5173
```

Example for domain `fmbqa.dcjamaat.com`:
```
POSTGRES_USER=rsvp
POSTGRES_PASSWORD=rsvp
POSTGRES_DB=rsvp
CORS_ALLOWED_ORIGINS=http://localhost:5173,http://fmbqa.dcjamaat.com:5173
```

Then start the application:
```bash
docker compose --env-file ./.env.dev -f docker-compose.dev.yml up -d --build
```

#### Option B: Inline Environment Variable

Pass the CORS origins directly when starting:

```bash
CORS_ALLOWED_ORIGINS="http://localhost:5173,http://yourdomain.com:5173" \
docker compose --env-file ./.env.dev -f docker-compose.dev.yml up -d --build
```

#### CORS Configuration Notes

- Multiple origins can be specified, separated by commas
- Always include `http://localhost:5173` for local development
- The origin must match exactly (including protocol and port)
- For HTTPS, use `https://` instead of `http://`
- If you see "Invalid CORS request" error on login, check this configuration

---

## Part 2: Data Migration

### Step 1: Backup Local Database (on your local machine)

```bash
# Navigate to project directory
cd /path/to/rsvp-modern

# Ensure local containers are running
docker compose --env-file ./.env.dev -f docker-compose.dev.yml up -d

# Create a full database backup
docker compose -f docker-compose.dev.yml exec db pg_dump -U rsvp -d rsvp > db_backup_full.sql

# Verify the backup
ls -la db_backup_full.sql
head -50 db_backup_full.sql
```

### Step 2: Transfer Backup to Server

```bash
# Replace YOUR_SERVER_IP with your server's IP address
# Replace your_user with your SSH username

# Using SCP
scp db_backup_full.sql your_user@YOUR_SERVER_IP:/home/your_user/rsvp-modern/

# Or using rsync (more reliable for large files)
rsync -avz --progress db_backup_full.sql your_user@YOUR_SERVER_IP:/home/your_user/rsvp-modern/
```

### Step 3: Restore Database on Server

```bash
# SSH into your server
ssh your_user@YOUR_SERVER_IP

# Navigate to project directory
cd ~/rsvp-modern

# Ensure containers are running
docker compose -f docker-compose.dev.yml ps

# Wait for database to be ready
docker compose -f docker-compose.dev.yml logs db | tail -20
# Look for: "database system is ready to accept connections"

# Drop existing data and restore from backup
docker compose -f docker-compose.dev.yml exec -T db psql -U rsvp -d rsvp -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;"
docker compose -f docker-compose.dev.yml exec -T db psql -U rsvp -d rsvp < db_backup_full.sql

# Alternative method if above fails
cat db_backup_full.sql | docker compose -f docker-compose.dev.yml exec -T db psql -U rsvp -d rsvp
```

### Step 4: Verify Data Restoration

```bash
# Connect to database
docker compose -f docker-compose.dev.yml exec db psql -U rsvp -d rsvp

# Run verification queries
\dt                           -- List all tables
SELECT COUNT(*) FROM persons; -- Check user count
SELECT COUNT(*) FROM events;  -- Check event count
SELECT COUNT(*) FROM dishes;  -- Check dish count
\q                            -- Exit psql
```

### Step 5: Restart Services

```bash
# Restart all containers
docker compose -f docker-compose.dev.yml down
docker compose --env-file ./.env.dev -f docker-compose.dev.yml up -d

# Check logs for errors
docker compose -f docker-compose.dev.yml logs -f server
```

---

## Part 3: Accessing the Application

Once everything is running:

| Service | URL |
|---------|-----|
| Frontend | `http://YOUR_SERVER_IP:5173` |
| Backend API | `http://YOUR_SERVER_IP:5173/api` (through the frontend; port 8080 is local only) |
| Database | `localhost:5433` (on the server only) |

Default admin credentials:
- **ITS**: 30702039
- **Password**: ***REDACTED***

---

## Part 4: Common Operations

### Starting and Stopping

```bash
# Start containers
docker compose --env-file ./.env.dev -f docker-compose.dev.yml up -d

# Stop containers
docker compose -f docker-compose.dev.yml down

# Stop and remove volumes (WARNING: deletes all data)
docker compose -f docker-compose.dev.yml down -v
```

### Viewing Logs

```bash
# All services
docker compose -f docker-compose.dev.yml logs -f

# Specific service
docker compose -f docker-compose.dev.yml logs -f server
docker compose -f docker-compose.dev.yml logs -f web
docker compose -f docker-compose.dev.yml logs -f db
```

### Updating the Application

```bash
cd ~/rsvp-modern

# Pull latest code
git pull origin main

# Rebuild and restart
docker compose -f docker-compose.dev.yml down
docker compose --env-file ./.env.dev -f docker-compose.dev.yml up -d --build
```

### Database Operations

```bash
# Access database shell
docker compose -f docker-compose.dev.yml exec db psql -U rsvp -d rsvp

# Create a backup
docker compose -f docker-compose.dev.yml exec db pg_dump -U rsvp -d rsvp > backup_$(date +%Y%m%d_%H%M%S).sql

# Restore a backup
docker compose -f docker-compose.dev.yml exec -T db psql -U rsvp -d rsvp < backup_file.sql
```

### Restarting Services

```bash
# Restart all
docker compose -f docker-compose.dev.yml restart

# Restart specific service
docker compose -f docker-compose.dev.yml restart server
docker compose -f docker-compose.dev.yml restart web
docker compose -f docker-compose.dev.yml restart db
```

### Checking Container Status

```bash
# List running containers
docker compose -f docker-compose.dev.yml ps

# Check resource usage
docker stats
```

---

## Part 5: Troubleshooting

### Container Won't Start

```bash
# Check logs for errors
docker compose -f docker-compose.dev.yml logs --tail=100

# Rebuild from scratch
docker compose -f docker-compose.dev.yml down
docker system prune -f
docker compose --env-file ./.env.dev -f docker-compose.dev.yml up -d --build
```

### Database Connection Issues

```bash
# Check if database is running
docker compose -f docker-compose.dev.yml ps db

# Check database logs
docker compose -f docker-compose.dev.yml logs db

# Test connection
docker compose -f docker-compose.dev.yml exec db pg_isready -U rsvp
```

### Port Already in Use

```bash
# Find what's using the port
sudo lsof -i :5173
sudo lsof -i :8080

# Kill the process if needed
sudo kill -9 <PID>
```

### Out of Disk Space

```bash
# Check disk usage
df -h

# Clean up Docker resources
docker system prune -a
docker volume prune
```

### Server Logs Show Permission Errors

```bash
# Fix permissions on project directory
sudo chown -R $USER:$USER ~/rsvp-modern
```

### CORS Errors on Login

If you see "Invalid CORS request" when trying to log in:

```bash
# 1. Check current CORS configuration
docker compose -f docker-compose.dev.yml exec server env | grep CORS

# 2. Update .env.dev with your domain
echo 'CORS_ALLOWED_ORIGINS=http://localhost:5173,http://yourdomain.com:5173' >> .env.dev

# 3. Restart with new configuration
docker compose -f docker-compose.dev.yml down
docker compose --env-file ./.env.dev -f docker-compose.dev.yml up -d --build
```

Common CORS issues:
- Missing port in origin (use `http://domain.com:5173` not `http://domain.com`)
- Protocol mismatch (`http` vs `https`)
- Typo in domain name
- Environment variable not being passed to container

---

## Part 6: Production Considerations

For production deployment, consider the following:

### 1. Use Production Docker Compose

```bash
# Use production config instead of dev
docker compose --env-file ./.env -f docker-compose.yml up -d --build
```

### 2. Set Up HTTPS with Let's Encrypt

```bash
# Install certbot
sudo apt install -y certbot

# Get certificate (replace with your domain)
sudo certbot certonly --standalone -d yourdomain.com

# Configure nginx to use HTTPS
# Update nginx.conf in the project
```

### 3. Secure Environment Variables

```bash
# Create production .env file with strong passwords
nano .env

# Contents:
POSTGRES_USER=rsvp
POSTGRES_PASSWORD=<STRONG_PASSWORD_HERE>
POSTGRES_DB=rsvp
CORS_ALLOWED_ORIGINS=https://yourdomain.com
```

### 4. Set Up Automatic Backups

```bash
# Create backup script
cat > ~/backup_rsvp.sh << 'EOF'
#!/bin/bash
BACKUP_DIR=~/backups
DATE=$(date +%Y%m%d_%H%M%S)
mkdir -p $BACKUP_DIR
cd ~/rsvp-modern
docker compose -f docker-compose.dev.yml exec -T db pg_dump -U rsvp -d rsvp > $BACKUP_DIR/rsvp_$DATE.sql
# Keep only last 7 days
find $BACKUP_DIR -name "rsvp_*.sql" -mtime +7 -delete
EOF

chmod +x ~/backup_rsvp.sh

# Add to crontab (daily at 2 AM)
(crontab -l 2>/dev/null; echo "0 2 * * * ~/backup_rsvp.sh") | crontab -
```

### 5. Set Up Domain Name

1. Purchase a domain or use a subdomain
2. Point DNS A record to your server IP
3. Configure nginx to use the domain
4. Set up SSL certificate

### 6. Enable Auto-Start on Reboot

```bash
# Create systemd service
sudo nano /etc/systemd/system/rsvp.service

# Contents:
[Unit]
Description=RSVP Application
Requires=docker.service
After=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
WorkingDirectory=/home/your_user/rsvp-modern
ExecStart=/usr/bin/docker compose --env-file ./.env.dev -f docker-compose.dev.yml up -d
ExecStop=/usr/bin/docker compose -f docker-compose.dev.yml down
User=your_user

[Install]
WantedBy=multi-user.target

# Enable the service
sudo systemctl enable rsvp.service
sudo systemctl start rsvp.service
```

---

## Webinars and Zoom

The webinar module lets coordinators publish Zoom sessions and give seats to members and their family members. Each seat gets its own join link, and the Zoom display name is set to the ITS number and name of the person holding the seat.

### Creating the Zoom app

Zoom is optional (see below). To use "Sync from Zoom":

1. In the Zoom App Marketplace, sign in as the Zoom account that owns the meetings.
2. Choose Develop, then Build App, then Server-to-Server OAuth.
3. Add read scopes for listing meetings and webinars. The expected scope names are:
   - `meeting:read:list_meetings:admin`
   - `webinar:read:list_webinars:admin`

   These names are not fully confirmed. The meetings scope came from a Zoom developer-forum thread, not the official reference. Confirm the exact names in the App Marketplace when creating the app.
4. Activate the app and copy the Account ID, Client ID and Client Secret.

The format of Zoom's list responses has not yet been verified against a live account. On first setup, open "Sync from Zoom" in the admin Webinars page. If the list is empty while sessions exist in Zoom, check the server log for the line reporting how many items Zoom returned versus how many were usable.

### Production environment

Add these to the production `.env` on the server. They never go in git.

```
ZOOM_ENABLED=true
ZOOM_ACCOUNT_ID=your_account_id
ZOOM_CLIENT_ID=your_client_id
ZOOM_CLIENT_SECRET=your_client_secret
ZOOM_IMPORT_USER_ID=me
# Optional: Zoom user whose webinars are imported, if different
ZOOM_WEBINAR_IMPORT_USER_ID=
FRONTEND_URL=https://fmb.dcjamaat.com
SENDGRID_ENABLED=true
```

- `ZOOM_IMPORT_USER_ID` is the Zoom user whose schedule is imported. `me` is the app owner.
- `FRONTEND_URL` must be `https://fmb.dcjamaat.com` in production, because join links are built from it.
- `SENDGRID_ENABLED` must be `true` and `SENDGRID_API_KEY` must be set before sending invites. Until both are set, Send Invites is refused (no links are reissued and nothing is written to the log); meanwhile each person's link can be copied individually from the webinar's Attendees screen.
- Both compose files pass every setting in the table below to the server container. If you add a new variable to the app, also list it under the server service, otherwise a value in `.env` is not visible to the app.

Optional settings (all have defaults, set them in `.env` only to change them):

| Variable | Default | What it does |
|---|---|---|
| `WEBINAR_JOIN_WINDOW_BEFORE_MIN` | `10` | Minutes before the start time that joining opens |
| `WEBINAR_JOIN_WINDOW_AFTER_MIN` | `15` | Minutes after the start time that joining stays open |
| `WEBINAR_DISPLAY_ZONE` | `America/New_York` | Time zone used to show webinar times in emails |
| `ZOOM_IMPORT_USER_ID` | `me` | Zoom user whose meetings are imported |
| `ZOOM_WEBINAR_IMPORT_USER_ID` | empty | Zoom user whose webinars are imported. If empty, `ZOOM_IMPORT_USER_ID` is used |
| `ZOOM_DEFAULT_HOST_NAME` | `FMB` | Host name shown when Zoom does not provide one |
| `ZOOM_OAUTH_URL` | `https://zoom.us/oauth/token` | Zoom token endpoint. Normally never needs changing |
| `ZOOM_BASE_URL` | `https://api.zoom.us` | Zoom API base URL. Normally never needs changing |

After changing `.env`, recreate the server container (`docker compose up -d server`) so it picks up the new values.

### Zoom is optional

With `ZOOM_ENABLED=false`, no Zoom API calls are made. Coordinators create webinars by hand and paste the Zoom link, and everything else works. The pasted link must be a complete `https://` URL with no spaces.

### Granting the coordinator role

Admin, then Settings, then Users, edit the user, and tick `WEBINAR_COORDINATOR`.

### Behaviour to know about

- A seat cannot be removed after its attendee has joined, so that attendance records are kept.
- When an invite email fails, that family is listed as skipped, and their previous links no longer work until invites are resent or a link is copied for them.

### Deploy note

The V37 migration is applied by both the `flyway` container and the app on start. If Flyway reports a checksum mismatch on an older migration, repair the Flyway history of the affected database. Never edit V37 or any other migration file to work around it.

Production: run repair through the compose `flyway` service, which uses the same database settings and migration location as its normal `migrate` run:

```bash
docker compose run --rm flyway -connectRetries=60 -locations=filesystem:/flyway/sql repair
```

Dev: `./gradlew flywayRepair` uses the `flyway {}` block in `server/build.gradle.kts`, which reads `SPRING_DATASOURCE_URL`, `SPRING_DATASOURCE_USERNAME` and `SPRING_DATASOURCE_PASSWORD` and otherwise falls back to `localhost:5432`. The dev database is exposed on port 5433, so point Gradle at it:

```bash
cd server
SPRING_DATASOURCE_URL=jdbc:postgresql://localhost:5433/rsvp \
SPRING_DATASOURCE_USERNAME=rsvp SPRING_DATASOURCE_PASSWORD=rsvp \
./gradlew flywayRepair
```

---

## Quick Reference

### URLs (Development)
| Service | Port | URL |
|---------|------|-----|
| Frontend | 5173 | http://SERVER_IP:5173 |
| Backend | 8080 | http://SERVER_IP:8080/api |
| Database | 5433 | localhost:5433 (internal) |

### Default Credentials
| Field | Value |
|-------|-------|
| ITS | 30702039 |
| Password | ***REDACTED*** |
| Role | ADMIN |

### Docker Compose Files
| File | Purpose |
|------|---------|
| `docker-compose.dev.yml` | Development with hot reload |
| `docker-compose.yml` | Production with nginx |

### Key Directories
| Path | Purpose |
|------|---------|
| `server/` | Spring Boot backend |
| `web/` | React frontend |
| `server/src/main/resources/db/migration/` | Flyway migrations |
| `server/src/main/resources/db/seed/` | Seed data |

---

## Support

For issues or questions:
- Check the logs first: `docker compose -f docker-compose.dev.yml logs -f`
- Review this guide's troubleshooting section
- Check the session notes in `rsvp-modern-session.md`

---

*Last updated: January 3, 2026*

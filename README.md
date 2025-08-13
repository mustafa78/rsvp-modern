# rsvp-modern

A modernized RSVP website: **Java 21 + Spring Boot** backend and **React + TypeScript (Vite)** frontend.
Includes **Flyway** migrations and **Docker Compose** for local dev.

## Prereqs
- Docker & Docker Compose
- (Optional) Java 21 and Node 20+ if running each app locally without Docker

## Quick Start (Docker Compose)
```bash
docker compose up --build
```
- Web: http://localhost:5173
- API: http://localhost:8080/api
- DB: Postgres 16 at `localhost:5432` (user: `rsvp`, password: `rsvp`, db: `rsvp`)

## Local Dev (without Docker)
Backend:
```bash
cd server
./gradlew bootRun   # if you add the Gradle wrapper
# or
./gradlew build     # to produce a jar
```

Frontend:
```bash
cd web
npm i
npm run dev
```

## Notes
- CORS is enabled in dev for `http://localhost:5173`.
- Update `server/src/main/resources/application.yml` if you change DB creds/ports.
- To use MySQL instead of Postgres, change the JDBC driver/dependency and adjust Flyway SQL if needed.

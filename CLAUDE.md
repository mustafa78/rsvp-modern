# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

RSVP system for community events with Java 21 Spring Boot backend and React TypeScript (Vite) frontend. Uses PostgreSQL with Flyway migrations.

## Common Commands

### Development (Docker Compose)
```bash
# Start full dev stack (DB + server + web with hot reload)
docker compose --env-file ./.env.dev -f docker-compose.dev.yml up --build

# Start only the database
docker compose --env-file ./.env.dev -f docker-compose.dev.yml up -d db
```

### Backend (server/)
```bash
cd server
./gradlew bootRun        # Run server (needs DB running)
./gradlew build          # Build JAR
./gradlew test           # Run tests
./gradlew flywayInfo     # Check migration status
./gradlew flywayMigrate  # Apply migrations manually
```

### Frontend (web/)
```bash
cd web
npm install
npm run dev              # Start dev server (port 5173)
npm run build            # Production build
```

### Endpoints
- Web: http://localhost:5173
- API: http://localhost:8080/api
- DB: postgresql://rsvp:rsvp@localhost:5433/rsvp (dev)

## Architecture

### Backend Structure (`server/src/main/java/com/acme/rsvp/`)
- `web/` - REST controllers (`@RestController`)
- `service/` - Business logic (AuthService, EventService, ThaaliService, NiyazService, ChefService, DishService)
- `repository/` - Spring Data JPA repositories
- `model/` - JPA entities (Person, Event, NiyazEvent, ThaaliEvent, Chef, Dish, MenuItem, etc.)
- `dto/` - Request/response DTOs
- `config/` - Security config, CORS, password encoding
- `security/` - Session-based auth filter, cookie utilities

### Frontend Structure (`web/src/`)
- `api/client.ts` - API client with fetch wrapper
- `pages/` - Route components (Login, Register, EventsPage, AdminPage, RsvpPage, etc.)
- `components/` - Reusable components (EventCard, RsvpForm)
- `lib/` - Utilities
- `types/` - TypeScript type definitions

### Key Domain Concepts
- **NiyazEvent**: Community gathering events with RSVPs
- **ThaaliEvent**: Food service events with orders
- **Chef**: Can be assigned to events with dishes
- **MenuItem**: Dishes assigned to specific events
- **Person**: User accounts with ITS number authentication

### Database
- Flyway migrations in `server/src/main/resources/db/migration/`
- Postgres 16, credentials in `.env.dev` (dev) or `.env` (prod)

### Authentication
- Session-based auth with HTTP-only cookies
- SessionAuthFilter validates tokens against session_tokens table
- Password reset flow uses time-limited tokens

## Environment Variables
Backend reads from environment or defaults to dev values:
- `SPRING_DATASOURCE_URL`, `SPRING_DATASOURCE_USERNAME`, `SPRING_DATASOURCE_PASSWORD`
- `SPRING_PROFILES_ACTIVE` (dev/prod)

Frontend uses:
- `VITE_API_URL` (defaults to empty string for same-origin)

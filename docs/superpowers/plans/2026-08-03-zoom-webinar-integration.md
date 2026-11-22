# Zoom Webinar Integration (MVP) Implementation Plan

> **SUPERSEDED on 2026-11-22. Do not execute this plan.** It models a webinar as an `Event` subtype and has no family seats. Use `docs/superpowers/plans/2026-11-22-zoom-webinar-family-seats.md` (spec: `docs/superpowers/specs/2026-11-21-zoom-webinar-family-seats-design.md`). Kept for reference only.

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add controlled, tracked Zoom webinar access to the FMB‑RSVP app — members join webinars through the portal (their Zoom URL is never exposed), admins sync/create webinars, invite via magic links, and view attendance.

**Architecture:** Re‑implement natively in the existing Spring Boot + React + Postgres stack. A webinar is a new `WEBINAR` subtype of the existing `Event` (single‑table inheritance, same pattern as `NiyazEvent`/`ThaaliEvent`), reusing `Person`/ITS auth, DB‑driven roles, the hashed‑token pattern (`PasswordResetToken`), `EmailService` (SendGrid), and the React admin shell. The only net‑new subsystems are a Zoom Server‑to‑Server OAuth client, a URL‑hiding tracked‑launch redirect, magic join tokens, and join logging/reporting. No second app, user store, or database.

**Tech Stack:** Java 21, Spring Boot 3.5.1 (spring‑web `RestClient`, Spring Security, Spring Data JPA), Flyway 11.10 on PostgreSQL 16, JUnit 5 + Mockito + AssertJ (`spring-boot-starter-test`) + Testcontainers (added in Task 0.1) for DB tests. Frontend: React + TypeScript + Vite, `@tanstack/react-query`, react‑router, the existing `src/api/client.ts` wrapper.

## Global Constraints

- Java toolchain **21**; Spring Boot **3.5.1**; do not add Spring dependencies beyond what tasks specify (Zoom uses the built‑in `RestClient` — no new HTTP client).
- Database is **PostgreSQL 16**; `spring.jpa.hibernate.ddl-auto=validate` — every JPA column MUST match the Flyway migration exactly.
- Next Flyway version is **V37**; migrations are immutable once merged. Use `V37__webinar_integration.sql` (add further `V38+` only if a later task needs a separate migration).
- `Person` primary identity is `itsNumber` (8‑digit ITS). Roles live in `person_roles` as strings. New admin role literal is **`WEBINAR_COORDINATOR`** (full admins also have access).
- **Secrets never touch git.** Zoom `ACCOUNT_ID`/`CLIENT_ID`/`CLIENT_SECRET` live only in the runtime environment / prod `.env` (already git‑ignored). `.env.example`‑style files get placeholder values only.
- **The stored Zoom `join_url` is server‑side only.** It must never appear in any DTO/JSON response or rendered HTML. Members reach Zoom exclusively via a server `302` redirect from a launch endpoint.
- **Locked display name** appended to the Zoom URL on launch is exactly: `ITS Title First Last` (space‑separated, Title omitted if blank), written to Zoom's `uname` query parameter (replace if present).
- **Join window** default: **10 minutes before** `scheduledStart` through **15 minutes after** `scheduledEnd` (configurable per webinar; app‑level defaults `app.webinar.join-window-before-minutes=10`, `app.webinar.join-window-after-minutes=15`).
- **One active webinar per member**: launching webinar B while a live launch lock for webinar A is unexpired is rejected.
- Magic join tokens: random 256‑bit token, base64url‑encoded in the link, only the **SHA‑256 hash** stored; scoped to one webinar + one ITS; expire at the webinar's join‑window end.
- Timestamps are stored/compared in UTC as `OffsetDateTime` (matches `Event.registrationOpenAt`); the frontend renders in the viewer's local timezone (existing pattern).
- Production public base URL is `https://fmb.dcjamaat.com` (`app.public-base-url`); used to build magic links.
- Webinar access does **not** require HOF (unlike Thaali/Niyaz) — webinars are per‑member. Access requires an **active, non‑expired** account plus either `access_mode=OPEN` or a row in `webinar_assignments`.

---

## File Structure

**Backend — create:**
- `server/src/main/resources/db/migration/V37__webinar_integration.sql` — schema + `WEBINAR_COORDINATOR` role seed.
- `model/WebinarEvent.java` — `@DiscriminatorValue("WEBINAR")` subtype of `Event`.
- `model/WebinarAccessMode.java` — enum `OPEN, ASSIGNED`.
- `model/WebinarAssignment.java`, `model/WebinarJoinLog.java`, `model/JoinSource.java` (`PORTAL, MAGIC_LINK`), `model/WebinarJoinToken.java`, `model/WebinarActiveLock.java`.
- `repository/WebinarEventRepository.java`, `WebinarAssignmentRepository.java`, `WebinarJoinLogRepository.java`, `WebinarJoinTokenRepository.java`, `WebinarActiveLockRepository.java`.
- `security/TokenHasher.java` — SHA‑256 hex hashing utility for magic tokens.
- `zoom/ZoomProperties.java` — `@ConfigurationProperties("app.zoom")`.
- `zoom/ZoomClient.java` — S2S OAuth token cache + REST calls; `zoom/ZoomMeeting.java` (API DTO), `zoom/ZoomTokenResponse.java`.
- `service/WebinarService.java` — CRUD, access resolution, launch/reserve, sync, tokens, reports.
- `service/WebinarLaunchService.java` — launch URL building + join logging + active‑lock (split from `WebinarService` to keep the security‑critical path small).
- `web/WebinarAdminController.java` — admin CRUD/sync/assign/report (`/api/webinars/admin/**`).
- `web/WebinarController.java` — member list + authenticated launch (`/api/webinars/**`).
- `web/WebinarPublicController.java` — magic link info + launch (`/api/webinars/public/**`).
- `dto/WebinarDtos.java` — request/response records (NEVER include `joinUrl`).

**Backend — modify:**
- `config/WebSecurityConfig.java` — permit `GET /api/webinars/public/**`.
- `security/SessionAuthFilter.java` — allow `/api/webinars/public/` prefix through as anonymous.
- `src/main/resources/application.yml` — `app.public-base-url`, `app.zoom.*`, `app.webinar.*`.
- `service/EmailService.java` — add `sendWebinarInvite(to, webinarTitle, whenText, magicLink)`.
- `server/build.gradle.kts` — add Testcontainers test dependencies (Task 0.1).
- `docker-compose.yml` — pass Zoom env into `server`.

**Frontend — create:**
- `web/src/pages/admin/webinars/WebinarList.tsx`, `CreateWebinar.tsx`, `ZoomSyncModal.tsx`, `WebinarReport.tsx`.
- `web/src/pages/WebinarsPage.tsx` (member "Authorized Sessions"), `web/src/pages/MagicJoinPage.tsx` (public `/j/:token`).

**Frontend — modify:**
- `web/src/main.tsx` — register admin + `/webinars` + `/j/:token` routes.
- `web/src/App.tsx` — add `WEBINAR_COORDINATOR` to `hasAdminRole`; add `/j` to `PUBLIC_ROUTES`; add member "Webinars" nav link.
- `web/src/pages/admin/AdminLayout.tsx` — add Webinars nav item with coordinator filtering.

---

## Phase 0 — Foundation (testing, config, role)

### Task 0.1: Testcontainers-backed integration test harness

**Files:**
- Modify: `server/build.gradle.kts`
- Create: `server/src/test/java/com/acme/rsvp/support/PostgresIntegrationTest.java`
- Create: `server/src/test/java/com/acme/rsvp/support/PostgresIntegrationTestSmokeTest.java`

**Interfaces:**
- Produces: abstract base `PostgresIntegrationTest` — annotate a test class with `@SpringBootTest` context backed by a real Postgres 16 container via `@ServiceConnection`; all Flyway migrations run against it. Later repository/service tasks extend this.

- [ ] **Step 1: Add test dependencies** to `server/build.gradle.kts` `dependencies {}`:

```kotlin
	testImplementation("org.springframework.boot:spring-boot-starter-test")
	testImplementation("org.springframework.boot:spring-boot-testcontainers")
	testImplementation("org.testcontainers:junit-jupiter")
	testImplementation("org.testcontainers:postgresql")
```

- [ ] **Step 2: Write the base class** `PostgresIntegrationTest.java`:

```java
package com.acme.rsvp.support;

import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.testcontainers.service.connection.ServiceConnection;
import org.springframework.test.context.DynamicPropertyRegistry;
import org.springframework.test.context.DynamicPropertySource;
import org.testcontainers.containers.PostgreSQLContainer;
import org.testcontainers.junit.jupiter.Container;
import org.testcontainers.junit.jupiter.Testcontainers;

@SpringBootTest
@Testcontainers
public abstract class PostgresIntegrationTest {
  @Container
  @ServiceConnection
  static PostgreSQLContainer<?> POSTGRES = new PostgreSQLContainer<>("postgres:16");

  @DynamicPropertySource
  static void props(DynamicPropertyRegistry r) {
    r.add("spring.flyway.enabled", () -> "true");
    r.add("spring.jpa.hibernate.ddl-auto", () -> "validate");
  }
}
```

- [ ] **Step 3: Write the smoke test** `PostgresIntegrationTestSmokeTest.java`:

```java
package com.acme.rsvp.support;

import org.junit.jupiter.api.Test;

class PostgresIntegrationTestSmokeTest extends PostgresIntegrationTest {
  @Test
  void contextLoadsAgainstRealPostgres() {}
}
```

- [ ] **Step 4: Run** `./gradlew test --tests "com.acme.rsvp.support.PostgresIntegrationTestSmokeTest"` — Expected: PASS (container starts, all migrations V1..V36 apply, context validates). Requires Docker running.
- [ ] **Step 5: Commit**

```bash
git add server/build.gradle.kts server/src/test/java/com/acme/rsvp/support/
git commit -m "test: add Testcontainers Postgres integration harness"
```

### Task 0.2: Zoom + webinar configuration properties

**Files:**
- Create: `zoom/ZoomProperties.java`
- Create: `service/WebinarProperties.java`
- Modify: `src/main/resources/application.yml`
- Modify: `server/src/main/java/com/acme/rsvp/RsvpApplication.java` (enable config props scanning if not already)
- Test: `server/src/test/java/com/acme/rsvp/zoom/ZoomPropertiesTest.java`

**Interfaces:**
- Produces: `ZoomProperties` getters `enabled(), accountId(), clientId(), clientSecret(), importUserId(), webinarImportUserId(), oauthUrl(), baseUrl(), defaultHostName()`. `WebinarProperties.joinWindowBeforeMinutes()`, `joinWindowAfterMinutes()`, `publicBaseUrl()`.

- [ ] **Step 1: application.yml** — append under `app:`:

```yaml
  public-base-url: ${APP_PUBLIC_BASE_URL:http://localhost:5173}
  webinar:
    join-window-before-minutes: ${WEBINAR_JOIN_WINDOW_BEFORE_MIN:10}
    join-window-after-minutes: ${WEBINAR_JOIN_WINDOW_AFTER_MIN:15}
  zoom:
    enabled: ${ZOOM_ENABLED:false}
    account-id: ${ZOOM_ACCOUNT_ID:}
    client-id: ${ZOOM_CLIENT_ID:}
    client-secret: ${ZOOM_CLIENT_SECRET:}
    import-user-id: ${ZOOM_IMPORT_USER_ID:}
    webinar-import-user-id: ${ZOOM_WEBINAR_IMPORT_USER_ID:}
    oauth-url: ${ZOOM_OAUTH_URL:https://zoom.us/oauth/token}
    base-url: ${ZOOM_BASE_URL:https://api.zoom.us}
    default-host-name: ${ZOOM_DEFAULT_HOST_NAME:FMB}
```

- [ ] **Step 2: Write `ZoomProperties.java`** as a `@ConfigurationProperties(prefix="app.zoom")` record with the fields above; annotate the application class with `@ConfigurationPropertiesScan` (add if missing). Write `WebinarProperties` as `@ConfigurationProperties(prefix="app.webinar")` plus a `publicBaseUrl` bound from `app.public-base-url` (use a small `@Value` or a second props class `AppProperties`). Keep `publicBaseUrl` on `WebinarProperties` via `@Value("${app.public-base-url}")` field for simplicity.
- [ ] **Step 3: Write the test** `ZoomPropertiesTest.java` extending `PostgresIntegrationTest`, autowire `ZoomProperties`, assert defaults (`enabled()==false`, `oauthUrl()` endsWith `/oauth/token`).
- [ ] **Step 4: Run** `./gradlew test --tests "*ZoomPropertiesTest"` — Expected: PASS.
- [ ] **Step 5: Commit** `git commit -am "feat: add Zoom + webinar configuration properties"`

### Task 0.3: Seed WEBINAR_COORDINATOR role (migration V37 — schema)

> This is the single schema migration for the feature; later phases only add Java + tests. Write the **entire** `V37` now so migrations stay immutable.

**Files:**
- Create: `server/src/main/resources/db/migration/V37__webinar_integration.sql`
- Test: `server/src/test/java/com/acme/rsvp/migration/V37MigrationTest.java`

- [ ] **Step 1: Write `V37__webinar_integration.sql`:**

```sql
-- Webinar integration: new event subtype columns, access, tokens, join logs, active lock, role.

-- 1) WebinarEvent columns on the single-table `events` (all nullable for STI compatibility)
ALTER TABLE events ADD COLUMN IF NOT EXISTS zoom_meeting_id           TEXT;
ALTER TABLE events ADD COLUMN IF NOT EXISTS join_url                  TEXT;
ALTER TABLE events ADD COLUMN IF NOT EXISTS host_name                 TEXT;
ALTER TABLE events ADD COLUMN IF NOT EXISTS scheduled_start           TIMESTAMPTZ;
ALTER TABLE events ADD COLUMN IF NOT EXISTS scheduled_end             TIMESTAMPTZ;
ALTER TABLE events ADD COLUMN IF NOT EXISTS access_mode               VARCHAR(16);
ALTER TABLE events ADD COLUMN IF NOT EXISTS managed_by_zoom           BOOLEAN;
ALTER TABLE events ADD COLUMN IF NOT EXISTS join_window_before_min    INTEGER;
ALTER TABLE events ADD COLUMN IF NOT EXISTS join_window_after_min     INTEGER;

-- Upsert key for Zoom-synced occurrences (only enforced when both present)
CREATE UNIQUE INDEX IF NOT EXISTS ux_events_zoom_occurrence
  ON events (zoom_meeting_id, scheduled_start)
  WHERE zoom_meeting_id IS NOT NULL;

-- 2) Direct assignments (who may join an ASSIGNED webinar)
CREATE TABLE IF NOT EXISTS webinar_assignments (
  event_id   BIGINT NOT NULL REFERENCES events(id) ON DELETE CASCADE,
  person_id  BIGINT NOT NULL REFERENCES persons(id) ON DELETE CASCADE,
  source     VARCHAR(24) NOT NULL DEFAULT 'DIRECT',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  PRIMARY KEY (event_id, person_id)
);

-- 3) Join logs (attendance)
CREATE TABLE IF NOT EXISTS webinar_join_logs (
  id        BIGSERIAL PRIMARY KEY,
  event_id  BIGINT NOT NULL REFERENCES events(id) ON DELETE CASCADE,
  person_id BIGINT NOT NULL REFERENCES persons(id) ON DELETE CASCADE,
  joined_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  source    VARCHAR(16) NOT NULL DEFAULT 'PORTAL'
);
CREATE INDEX IF NOT EXISTS ix_webinar_join_logs_event_person
  ON webinar_join_logs (event_id, person_id, joined_at);

-- 4) Magic join tokens (store only the hash)
CREATE TABLE IF NOT EXISTS webinar_join_tokens (
  id           UUID PRIMARY KEY,
  token_hash   TEXT NOT NULL UNIQUE,
  event_id     BIGINT NOT NULL REFERENCES events(id) ON DELETE CASCADE,
  person_id    BIGINT NOT NULL REFERENCES persons(id) ON DELETE CASCADE,
  created_at   TIMESTAMPTZ NOT NULL,
  expires_at   TIMESTAMPTZ NOT NULL,
  last_used_at TIMESTAMPTZ,
  use_count    INTEGER NOT NULL DEFAULT 0,
  revoked_at   TIMESTAMPTZ
);
CREATE INDEX IF NOT EXISTS ix_webinar_join_tokens_event_person
  ON webinar_join_tokens (event_id, person_id, expires_at);

-- 5) One-active-webinar lock (one row per person)
CREATE TABLE IF NOT EXISTS webinar_active_locks (
  person_id  BIGINT PRIMARY KEY REFERENCES persons(id) ON DELETE CASCADE,
  event_id   BIGINT NOT NULL REFERENCES events(id) ON DELETE CASCADE,
  locked_until TIMESTAMPTZ NOT NULL
);

-- 6) Seed the WEBINAR_COORDINATOR role (roles table is DB-driven; matches V11/V14/V26 pattern)
INSERT INTO roles (name, description)
SELECT 'WEBINAR_COORDINATOR', 'Manage webinars, assignments, and attendance reports'
WHERE NOT EXISTS (SELECT 1 FROM roles WHERE name = 'WEBINAR_COORDINATOR');
```

> Before writing, confirm the `roles` table column names by reading `V10__roles_table.sql`; adjust the INSERT columns to match (name/description or name only). If `roles` has different columns, use them verbatim.

- [ ] **Step 2: Write `V37MigrationTest.java`** extending `PostgresIntegrationTest`; autowire `JdbcTemplate`; assert `webinar_join_tokens`, `webinar_assignments`, `webinar_join_logs`, `webinar_active_locks` exist and `SELECT count(*) FROM roles WHERE name='WEBINAR_COORDINATOR'` == 1.
- [ ] **Step 3: Run** `./gradlew test --tests "*V37MigrationTest"` — Expected: PASS.
- [ ] **Step 4: Commit** `git commit -am "feat: V37 webinar integration schema + WEBINAR_COORDINATOR role"`

---

## Phase 1 — Domain model, admin CRUD, tracked launch

### Task 1.1: WebinarEvent entity + enums + repository

**Files:**
- Create: `model/WebinarEvent.java`, `model/WebinarAccessMode.java`
- Create: `repository/WebinarEventRepository.java`
- Test: `server/src/test/java/com/acme/rsvp/repository/WebinarEventRepositoryTest.java`

**Interfaces:**
- Produces: `WebinarEvent extends Event` with getters/setters for `zoomMeetingId, joinUrl, hostName, scheduledStart(OffsetDateTime), scheduledEnd(OffsetDateTime), accessMode(WebinarAccessMode), managedByZoom(boolean), joinWindowBeforeMin(Integer), joinWindowAfterMin(Integer)` and `boolean isJoinOpen(OffsetDateTime now)`.
- `WebinarEventRepository extends JpaRepository<WebinarEvent, Long>` with `Optional<WebinarEvent> findByZoomMeetingIdAndScheduledStart(String zoomMeetingId, OffsetDateTime start)` and `List<WebinarEvent> findAllByOrderByScheduledStartDesc()`.

- [ ] **Step 1: Write the failing test** `WebinarEventRepositoryTest.java` (extends `PostgresIntegrationTest`), autowire `WebinarEventRepository` + `PersonRepository`. Test `isJoinOpen` boundary and persistence round-trip:

```java
@Test
void joinWindowRespectsBeforeAndAfterMinutes() {
  WebinarEvent w = new WebinarEvent();
  OffsetDateTime start = OffsetDateTime.parse("2030-01-01T18:00:00Z");
  w.setScheduledStart(start);
  w.setScheduledEnd(start.plusHours(1));
  w.setJoinWindowBeforeMin(10);
  w.setJoinWindowAfterMin(15);
  assertThat(w.isJoinOpen(start.minusMinutes(11))).isFalse();
  assertThat(w.isJoinOpen(start.minusMinutes(9))).isTrue();
  assertThat(w.isJoinOpen(start.plusHours(1).plusMinutes(14))).isTrue();
  assertThat(w.isJoinOpen(start.plusHours(1).plusMinutes(16))).isFalse();
}
```

- [ ] **Step 2: Run** the test — Expected: FAIL (compile error: `WebinarEvent` missing).
- [ ] **Step 3: Implement** `WebinarAccessMode` (`OPEN, ASSIGNED`) and `WebinarEvent`:

```java
package com.acme.rsvp.model;

import jakarta.persistence.*;
import java.time.OffsetDateTime;

@Entity
@DiscriminatorValue("WEBINAR")
public class WebinarEvent extends Event {
  @Column(name = "zoom_meeting_id") private String zoomMeetingId;
  @Column(name = "join_url")        private String joinUrl;
  @Column(name = "host_name")       private String hostName;
  @Column(name = "scheduled_start") private OffsetDateTime scheduledStart;
  @Column(name = "scheduled_end")   private OffsetDateTime scheduledEnd;
  @Enumerated(EnumType.STRING) @Column(name = "access_mode")
  private WebinarAccessMode accessMode = WebinarAccessMode.OPEN;
  @Column(name = "managed_by_zoom") private boolean managedByZoom = false;
  @Column(name = "join_window_before_min") private Integer joinWindowBeforeMin;
  @Column(name = "join_window_after_min")  private Integer joinWindowAfterMin;

  @Transient
  public boolean isJoinOpen(OffsetDateTime now) {
    if (scheduledStart == null || scheduledEnd == null) return false;
    int before = joinWindowBeforeMin != null ? joinWindowBeforeMin : 10;
    int after = joinWindowAfterMin != null ? joinWindowAfterMin : 15;
    return !now.isBefore(scheduledStart.minusMinutes(before))
        && !now.isAfter(scheduledEnd.plusMinutes(after));
  }
  // getters/setters for all fields ...
}
```

Write `WebinarEventRepository` with the two query methods. **Do not** expose `joinUrl` anywhere but the entity.

- [ ] **Step 4: Run** the test — Expected: PASS.
- [ ] **Step 5: Commit** `git commit -am "feat: WebinarEvent entity + repository"`

### Task 1.2: Supporting entities + repositories (assignment, join log, active lock)

**Files:**
- Create: `model/WebinarAssignment.java` (+ `@IdClass` or embeddable composite key on event_id+person_id), `model/WebinarJoinLog.java`, `model/JoinSource.java`, `model/WebinarActiveLock.java`
- Create: `repository/WebinarAssignmentRepository.java`, `WebinarJoinLogRepository.java`, `WebinarActiveLockRepository.java`
- Test: `repository/WebinarAssignmentRepositoryTest.java`

**Interfaces:**
- Produces: `WebinarAssignmentRepository.existsByEventIdAndPersonId(Long,Long)`, `findByEventId(Long)`, `deleteByEventIdAndPersonId(Long,Long)`; `WebinarJoinLogRepository.findByEventIdOrderByJoinedAtAsc(Long)`, `countDistinctPersonByEventId(Long)`; `WebinarActiveLockRepository extends JpaRepository<WebinarActiveLock, Long>` (id = personId).

- [ ] **Step 1: Write failing test** — persist an assignment and assert `existsByEventIdAndPersonId` true; persist two join logs for one person and assert `findByEventIdOrderByJoinedAtAsc` size 2.
- [ ] **Step 2: Run** — Expected: FAIL (entities missing).
- [ ] **Step 3: Implement** the four entities (mirror column names from V37; `WebinarAssignment` uses `@IdClass` with `(Long eventId, Long personId)`; `WebinarActiveLock` `@Id personId`, fields `eventId`, `lockedUntil`) and repositories.
- [ ] **Step 4: Run** — Expected: PASS.
- [ ] **Step 5: Commit** `git commit -am "feat: webinar assignment/join-log/active-lock entities"`

### Task 1.3: WebinarService admin CRUD (create/update/list/delete + DTOs)

**Files:**
- Create: `dto/WebinarDtos.java`, `service/WebinarService.java`
- Test: `service/WebinarServiceCrudTest.java`

**Interfaces:**
- Consumes: `WebinarEventRepository`, `WebinarAssignmentRepository`, `PersonRepository`, `WebinarProperties`.
- Produces (records in `WebinarDtos`): `WebinarSummary(Long id, String title, String hostName, OffsetDateTime scheduledStart, OffsetDateTime scheduledEnd, String accessMode, boolean managedByZoom, EventStatus status)` — **no joinUrl**; `CreateWebinarRequest(String title, String description, String hostName, OffsetDateTime scheduledStart, OffsetDateTime scheduledEnd, String joinUrl, String accessMode, Integer joinWindowBeforeMin, Integer joinWindowAfterMin)`; `WebinarDetail(... same as summary + description + int assignedCount)`.
- Produces (service methods): `WebinarSummary create(CreateWebinarRequest)`, `WebinarSummary update(Long id, CreateWebinarRequest)`, `List<WebinarSummary> listAll()`, `void delete(Long id)`, `WebinarDetail get(Long id)`.

- [ ] **Step 1: Write failing test** `create` persists a webinar, `listAll` returns it, and the returned DTO **does not** carry `joinUrl` (assert via reflection that `WebinarSummary` has no `joinUrl` component, or simply that the type lacks the field — compile‑time guarantee). Assert `create` sets inherited `Event.eventDate = scheduledStart.toLocalDate()`, `status=DRAFT`, and required `registrationOpenAt/CloseAt` (set open=now, close=scheduledEnd + afterWindow) so the NOT‑NULL inherited columns are satisfied.
- [ ] **Step 2: Run** — Expected: FAIL.
- [ ] **Step 3: Implement** `WebinarService` CRUD. In `create`: build `WebinarEvent`, set title/description/hostName/scheduled*, `accessMode`, join windows (fall back to `WebinarProperties` defaults when null), `managedByZoom=false`, and the inherited `Event` required fields. Map to DTOs via a private `toSummary(WebinarEvent)` that **omits joinUrl**.
- [ ] **Step 4: Run** — Expected: PASS.
- [ ] **Step 5: Commit** `git commit -am "feat: webinar admin CRUD service + DTOs"`

### Task 1.4: Access resolution + assignment management

**Files:**
- Modify: `service/WebinarService.java`
- Test: `service/WebinarAccessTest.java`

**Interfaces:**
- Produces: `boolean canAccess(WebinarEvent w, Person p)` — true iff `p` is active & non‑expired (`p.getAccountStatus()==ACTIVE && !p.isExpired()`) AND (`w.accessMode==OPEN` OR an assignment row exists). `void assign(Long eventId, Long personId)`, `void unassign(Long eventId, Long personId)`, `List<PersonBasicDto> listAssignable(Long eventId, String search)` (reuse `RsvpDtos.PersonBasicDto`), `List<PersonBasicDto> listAssigned(Long eventId)`.

- [ ] **Step 1: Write failing test:** OPEN webinar → `canAccess` true for active member, false for expired member; ASSIGNED webinar → false until `assign`, true after; `unassign` reverses it.
- [ ] **Step 2: Run** — Expected: FAIL.
- [ ] **Step 3: Implement** the methods. For `listAssignable` reuse the existing person search approach (`PersonRepository`); exclude already‑assigned. (No HOF filter — webinars are per‑member.)
- [ ] **Step 4: Run** — Expected: PASS.
- [ ] **Step 5: Commit** `git commit -am "feat: webinar access resolution + assignments"`

### Task 1.5: WebinarLaunchService — URL hiding, display-name lock, join log, one-active lock

**Files:**
- Create: `service/WebinarLaunchService.java`
- Test: `service/WebinarLaunchServiceTest.java`

**Interfaces:**
- Consumes: `WebinarEventRepository`, `WebinarJoinLogRepository`, `WebinarActiveLockRepository`, `WebinarService.canAccess`.
- Produces: `String reserveAndBuildLaunchUrl(Long eventId, Person p, JoinSource source, OffsetDateTime now)` — validates access + `isJoinOpen` + one‑active‑lock; writes a `WebinarJoinLog`; upserts `WebinarActiveLock(personId, eventId, scheduledEnd + afterWindow)`; returns the Zoom URL with `uname` set to the locked display name. Throws `IllegalStateException` on closed window / no access / active‑lock conflict.
- Static helper `String appendDisplayName(String joinUrl, String displayName)` and `String displayName(Person p)`.

- [ ] **Step 1: Write failing tests (pure unit, no Spring needed — construct service with mocked repos via Mockito):**

```java
@Test
void appendsUnameReplacingExisting() {
  String url = WebinarLaunchService.appendDisplayName(
      "https://zoom.us/j/123?pwd=abc&uname=old", "50001234 Shk Ali Hassan");
  assertThat(url).contains("uname=50001234+Shk+Ali+Hassan");
  assertThat(url).doesNotContain("uname=old");
  assertThat(url).contains("pwd=abc");
}

@Test
void displayNameOmitsBlankTitle() {
  Person p = new Person();
  p.setItsNumber("50001234"); p.setFirstName("Ali"); p.setLastName("Hassan");
  assertThat(WebinarLaunchService.displayName(p)).isEqualTo("50001234 Ali Hassan");
}
```

- [ ] **Step 2: Run** — Expected: FAIL.
- [ ] **Step 3: Implement.** `appendDisplayName` parses/rewrites the query string using `java.net.URI`/`UriComponentsBuilder` (already available via spring‑web), URL‑encoding the value (spaces → `+` or `%20`; assert consistent with the encoder used). `reserveAndBuildLaunchUrl`: load webinar; if `!canAccess` throw; if `!isJoinOpen(now)` throw "Join window is not open"; check `WebinarActiveLock` for this person — if present, unexpired, and `eventId != this` throw "You are already in another webinar"; save join log; upsert lock; return `appendDisplayName(w.getJoinUrl(), displayName(p))`. **Add a Title field to display name only if `Person` has one — Person currently has no `title`; use `firstName lastName` (skip Title in MVP; note for future).**
- [ ] **Step 4: Run** — Expected: PASS.
- [ ] **Step 5: Commit** `git commit -am "feat: webinar launch service (URL hiding, name lock, join log, active lock)"`

### Task 1.6: Admin + member controllers (CRUD, assign, authenticated launch redirect)

**Files:**
- Create: `web/WebinarAdminController.java`, `web/WebinarController.java`
- Modify: none for security yet (all under `/api/webinars/**` → authenticated by default)
- Test: `web/WebinarControllerTest.java` (MockMvc slice or full `@SpringBootTest` + `MockMvc` extending `PostgresIntegrationTest`)

**Interfaces:**
- `WebinarAdminController` (`@RequestMapping("/api/webinars/admin")`): `POST /` create, `PUT /{id}` update, `GET /` list, `DELETE /{id}`, `GET /{id}` detail, `GET /{id}/assignable?search=`, `GET /{id}/assigned`, `POST /{id}/assign/{personId}`, `DELETE /{id}/assign/{personId}`. Guard each with `@PreAuthorize("hasAnyRole('ADMIN','WEBINAR_COORDINATOR')")` (authorities are `ROLE_<role>` per `SessionAuthFilter`). Enable method security with `@EnableMethodSecurity` on a config class if not already enabled.
- `WebinarController` (`@RequestMapping("/api/webinars")`): `GET /` member's authorized upcoming webinars (list of `WebinarSummary` filtered by `canAccess` + not past join window), `GET /{id}/launch` → **`ResponseEntity` 302 redirect** to the launch URL (calls `WebinarLaunchService.reserveAndBuildLaunchUrl(..., JoinSource.PORTAL, now)`); principal via `@AuthenticationPrincipal Person user`.

- [ ] **Step 1: Write failing test:** as an admin, `POST /api/webinars/admin` returns 200 and the body has no `joinUrl` key; `GET /api/webinars/{id}/launch` as an assigned member during the window returns `302` with `Location` starting `https://` and containing `uname=`; outside the window returns `400`. (Seed data via repositories in the test; authenticate by inserting a `SessionToken` + cookie, or by using `@WithMockUser` + a custom principal resolver — prefer seeding a real session cookie to exercise `SessionAuthFilter`.)
- [ ] **Step 2: Run** — Expected: FAIL.
- [ ] **Step 3: Implement** both controllers. The launch endpoint:

```java
@GetMapping("/{id}/launch")
public ResponseEntity<Void> launch(@PathVariable Long id, @AuthenticationPrincipal Person user) {
  String url = launchService.reserveAndBuildLaunchUrl(id, user, JoinSource.PORTAL, OffsetDateTime.now());
  return ResponseEntity.status(HttpStatus.FOUND).location(URI.create(url)).build();
}
```

Add `@EnableMethodSecurity` (new `MethodSecurityConfig` or on `WebSecurityConfig`). Ensure `IllegalStateException` → 400 via the existing `GlobalExceptionHandler`.

- [ ] **Step 4: Run** — Expected: PASS.
- [ ] **Step 5: Commit** `git commit -am "feat: webinar admin + member controllers with tracked launch redirect"`

---

## Phase 2 — Zoom Server-to-Server OAuth sync

### Task 2.1: ZoomClient — S2S OAuth token cache

**Files:**
- Create: `zoom/ZoomClient.java`, `zoom/ZoomTokenResponse.java`
- Test: `zoom/ZoomClientTokenTest.java`

**Interfaces:**
- Consumes: `ZoomProperties`, a `RestClient` bean (create `RestClient.builder().build()` inside `ZoomClient` or inject a `RestClient.Builder`).
- Produces: `String accessToken(OffsetDateTime now)` — returns a cached token, fetching a new one via `POST {oauthUrl}?grant_type=account_credentials&account_id={accountId}` with header `Authorization: Basic base64(clientId:clientSecret)` when the cache is empty/expired (refresh 60s before expiry).

- [ ] **Step 1: Write failing test** using a `MockRestServiceServer`‑style approach or inject a mock `RestClient`. Simplest: extract the HTTP call behind a package‑private `fetchToken()` and test the cache logic: first `accessToken(now)` calls `fetchToken` once; a second call 30 min later reuses it (still 1 invocation); a call after expiry refetches. Use a Mockito spy.
- [ ] **Step 2: Run** — Expected: FAIL.
- [ ] **Step 3: Implement** the token cache (store `token` + `expiresAt`; `expiresAt = now + expires_in - 60s`).
- [ ] **Step 4: Run** — Expected: PASS.
- [ ] **Step 5: Commit** `git commit -am "feat: Zoom S2S OAuth client with token cache"`

### Task 2.2: ZoomClient — list scheduled meetings & webinars

**Files:**
- Modify: `zoom/ZoomClient.java`; Create: `zoom/ZoomMeeting.java`
- Test: `zoom/ZoomClientListTest.java`

**Interfaces:**
- Produces: `List<ZoomMeeting> listScheduledMeetings()` → `GET {baseUrl}/v2/users/{importUserId}/meetings?type=scheduled&page_size=300`; `List<ZoomMeeting> listScheduledWebinars()` → `GET {baseUrl}/v2/users/{webinarImportUserId or importUserId}/webinars?page_size=300`. `ZoomMeeting(String id, String topic, OffsetDateTime start, Integer durationMinutes, String joinUrl)`.

- [ ] **Step 1: Write failing test** with `MockRestServiceServer` bound to the client's `RestClient`, returning a canned Zoom `meetings` JSON payload; assert parsed `ZoomMeeting` list (id, topic, start, joinUrl) and that the `Authorization: Bearer` header was sent.
- [ ] **Step 2: Run** — Expected: FAIL.
- [ ] **Step 3: Implement** the two list calls + JSON mapping (map Zoom `join_url`, `start_time`, `duration`). Guard: if `!zoomProperties.enabled()` throw `IllegalStateException("Zoom integration is not configured")`.
- [ ] **Step 4: Run** — Expected: PASS.
- [ ] **Step 5: Commit** `git commit -am "feat: Zoom client list scheduled meetings/webinars"`

### Task 2.3: Sync preview + confirm import (upsert by zoomMeetingId + start)

**Files:**
- Modify: `service/WebinarService.java`, `dto/WebinarDtos.java`; add endpoints to `web/WebinarAdminController.java`
- Test: `service/WebinarSyncTest.java`

**Interfaces:**
- Produces: `List<ZoomSyncRow> previewZoomSync(String kind)` (`kind` = "meetings"|"webinars") — maps `ZoomMeeting`→`ZoomSyncRow(String zoomMeetingId, String topic, OffsetDateTime start, OffsetDateTime end, String joinUrl (server‑side only — NOT returned to client; see note), boolean alreadyImported)`. `WebinarSummary confirmImport(ImportRow row, String accessMode)` — upsert `WebinarEvent` by `(zoomMeetingId, scheduledStart)`; set `managedByZoom=true`, `hostName = zoomProperties.defaultHostName()`.
- Endpoints: `GET /api/webinars/admin/zoom/preview?kind=meetings`, `POST /api/webinars/admin/zoom/import`.

> **URL‑hiding note:** `ZoomSyncRow` returned to the browser must NOT include `joinUrl`. Keep the joinUrl server‑side: preview returns a row with a stable `zoomMeetingId`+`start`; on confirm, re‑fetch or carry the joinUrl in a server‑side cache keyed by zoomMeetingId+start, or (simplest, acceptable for admin‑only) include joinUrl only in the import POST body echoed from a short‑lived server list. For MVP, `confirmImport` re‑derives joinUrl by re‑listing from Zoom and matching on `zoomMeetingId`+`start`, so the URL never round‑trips through the browser.

- [ ] **Step 1: Write failing test** (mock `ZoomClient`): preview marks a row `alreadyImported=true` when a matching `WebinarEvent` exists; `confirmImport` creates a new `WebinarEvent(managedByZoom=true)` and a second confirm of the same row updates (no duplicate).
- [ ] **Step 2: Run** — Expected: FAIL.
- [ ] **Step 3: Implement** preview + confirm with upsert via `findByZoomMeetingIdAndScheduledStart`.
- [ ] **Step 4: Run** — Expected: PASS.
- [ ] **Step 5: Commit** `git commit -am "feat: Zoom sync preview + confirm import"`

---

## Phase 3 — Magic join links

### Task 3.1: TokenHasher + WebinarJoinToken entity/repository

**Files:**
- Create: `security/TokenHasher.java`, `model/WebinarJoinToken.java`, `repository/WebinarJoinTokenRepository.java`
- Test: `security/TokenHasherTest.java`

**Interfaces:**
- Produces: `TokenHasher.randomToken()` → base64url of 32 secure‑random bytes; `TokenHasher.sha256Hex(String)` → lowercase hex. `WebinarJoinTokenRepository.findByTokenHash(String)`.

- [ ] **Step 1: Write failing test:** `sha256Hex("abc")` equals the known SHA‑256 hex of "abc"; `randomToken()` returns two different values on two calls, each ≥ 43 chars.
- [ ] **Step 2: Run** — Expected: FAIL.
- [ ] **Step 3: Implement** `TokenHasher` (`SecureRandom`, `MessageDigest.getInstance("SHA-256")`, `Base64.getUrlEncoder().withoutPadding()`), entity, repository.
- [ ] **Step 4: Run** — Expected: PASS.
- [ ] **Step 5: Commit** `git commit -am "feat: token hasher + webinar join token entity"`

### Task 3.2: Issue magic links + email delivery

**Files:**
- Modify: `service/WebinarService.java`, `service/EmailService.java`; add endpoint to `web/WebinarAdminController.java`
- Test: `service/WebinarMagicLinkTest.java`

**Interfaces:**
- Produces: `String issueMagicLink(Long eventId, Long personId)` — creates `WebinarJoinToken(id=UUID, tokenHash=sha256Hex(raw), expiresAt=scheduledEnd + afterWindow)`, returns `${publicBaseUrl}/j/{raw}` (raw token only returned here, never stored). `int sendMagicLinksToAssigned(Long eventId)` — for each accessible member, issue link + `emailService.sendWebinarInvite(...)`, return count. `EmailService.sendWebinarInvite(String to, String title, String whenText, String magicLink)`.
- Endpoint: `POST /api/webinars/admin/{id}/send-invites` → returns `{ "sent": n }`.

- [ ] **Step 1: Write failing test:** `issueMagicLink` stores exactly one token whose `tokenHash` equals `sha256Hex` of the raw token embedded in the returned URL, and the URL starts with the configured public base URL + `/j/`.
- [ ] **Step 2: Run** — Expected: FAIL.
- [ ] **Step 3: Implement**; add `sendWebinarInvite` to `EmailService` (mirror `sendPasswordResetLink` → build HTML/text, call `sendEmail`).
- [ ] **Step 4: Run** — Expected: PASS.
- [ ] **Step 5: Commit** `git commit -am "feat: issue + email webinar magic links"`

### Task 3.3: Public magic-link endpoints (info + launch) + security opening

**Files:**
- Create: `web/WebinarPublicController.java`
- Modify: `config/WebSecurityConfig.java`, `security/SessionAuthFilter.java`
- Test: `web/WebinarPublicControllerTest.java`

**Interfaces:**
- `GET /api/webinars/public/{token}` → `MagicJoinInfo(String title, String hostName, OffsetDateTime scheduledStart, OffsetDateTime scheduledEnd, boolean joinOpen)` after validating token hash/expiry/not‑revoked — **no joinUrl**. Invalid/expired → 404.
- `GET /api/webinars/public/{token}/launch` → 302 redirect to Zoom: validates token, loads its person + webinar, calls `WebinarLaunchService.reserveAndBuildLaunchUrl(eventId, person, JoinSource.MAGIC_LINK, now)`, increments `use_count`/`last_used_at`.

- [ ] **Step 1: Modify `WebSecurityConfig`** — add to the GET `permitAll` matchers: `"/api/webinars/public/**"`. **Modify `SessionAuthFilter`** — in the anonymous‑skip section add: `if (path.startsWith("/api/webinars/public/")) { chain.doFilter(req,resp); return; }`.
- [ ] **Step 2: Write failing test:** unauthenticated `GET /api/webinars/public/{validToken}` returns 200 with a body lacking `joinUrl`; `GET /api/webinars/public/{validToken}/launch` returns 302 to a `https://...uname=...` URL and bumps `use_count`; a garbage token returns 404.
- [ ] **Step 3: Run** — Expected: FAIL.
- [ ] **Step 4: Implement** `WebinarPublicController`.
- [ ] **Step 5: Run** — Expected: PASS.
- [ ] **Step 6: Commit** `git commit -am "feat: public magic-link info + launch endpoints"`

---

## Phase 4 — Attendance reports

### Task 4.1: Attendance aggregation service + endpoint

**Files:**
- Modify: `service/WebinarService.java`, `dto/WebinarDtos.java`, `web/WebinarAdminController.java`
- Test: `service/WebinarReportTest.java`

**Interfaces:**
- Produces: `AttendanceReport report(Long eventId)` = `AttendanceReport(WebinarSummary webinar, int assignedCount, int joinedCount, List<AttendeeRow> rows)`; `AttendeeRow(String itsNumber, String name, boolean joined, OffsetDateTime firstJoinedAt, int launchCount)`. Rows = union of assigned members (or all accessible for OPEN) and everyone in `webinar_join_logs`; joined flag + first/last from logs.
- Endpoint: `GET /api/webinars/admin/{id}/report`.

- [ ] **Step 1: Write failing test:** two members assigned, one has two join logs → `joinedCount==1`, that attendee `launchCount==2`, `firstJoinedAt` = earliest; the other `joined==false`.
- [ ] **Step 2: Run** — Expected: FAIL.
- [ ] **Step 3: Implement** aggregation (group `WebinarJoinLog` by personId).
- [ ] **Step 4: Run** — Expected: PASS.
- [ ] **Step 5: Commit** `git commit -am "feat: webinar attendance report service + endpoint"`

> XLSX/PDF export reuses the existing frontend jsPDF/xlsx approach (Task 5.4); no backend export endpoint needed for MVP.

---

## Phase 5 — Frontend + hardening + deploy

> React tasks follow existing patterns; **read the referenced sibling file first** and mirror its structure (React Query + `api` wrapper, Tailwind classes, admin table styling). Frontend has no automated test harness in this repo; each task's verification is a manual `npm run build` + a described manual check. Keep each task a single commit.

### Task 5.1: Route + nav wiring + role plumbing

**Files:** Modify `web/src/main.tsx`, `web/src/App.tsx`, `web/src/pages/admin/AdminLayout.tsx`

- [ ] **Step 1:** In `App.tsx` add `'WEBINAR_COORDINATOR'` to the `hasAdminRole` role array (line ~52) and add `/j` to `PUBLIC_ROUTES` (line ~22). Add a member nav `<Link to="/webinars">Webinars</Link>` inside the `user.isHof`‑style block (webinars are for all members, so gate on `user` not `isHof` — place it as its own conditional showing for any logged‑in member).
- [ ] **Step 2:** In `AdminLayout.tsx` add a "Webinars" sidebar item, visible when roles include `ADMIN` or `WEBINAR_COORDINATOR` (mirror the existing coordinator filtering used for Niyaz/Thaali).
- [ ] **Step 3:** In `main.tsx` register routes: admin `/admin/webinars` (list), `/admin/webinars/new`, `/admin/webinars/:id/edit`, `/admin/webinars/:id/report`; member `/webinars`; public `/j/:token` (outside the authenticated layout — same level as `/reset-password`).
- [ ] **Step 4:** Run `cd web && npm run build` — Expected: build succeeds (pages referenced next may be temporary stubs; create empty components first if needed to compile).
- [ ] **Step 5: Commit** `git commit -am "feat(web): webinar routes, nav, and role wiring"`

### Task 5.2: Admin — WebinarList + CreateWebinar + ZoomSyncModal

**Files:** Create `web/src/pages/admin/webinars/WebinarList.tsx`, `CreateWebinar.tsx`, `ZoomSyncModal.tsx`

- [ ] **Step 1:** `WebinarList.tsx` — `useQuery(['webinars'], () => api.get('/webinars/admin'))`, render an Excel‑style table (mirror `admin/events/EventList.tsx`): title, host, start (local time), access mode, status, actions (Edit, Report, Assign, Send Invites, Delete). "Sync from Zoom" button opens `ZoomSyncModal`.
- [ ] **Step 2:** `CreateWebinar.tsx` (create + edit by `:id`) — form: title, description, hostName, scheduledStart/End (`datetime-local`, convert to ISO with offset like `CreateNiyazEvent.tsx`), joinUrl (write‑only; on edit show a "leave blank to keep" placeholder — never populate from server), accessMode select (OPEN/ASSIGNED), join window minutes. POST/PUT `/webinars/admin`.
- [ ] **Step 3:** `ZoomSyncModal.tsx` — `GET /webinars/admin/zoom/preview?kind=meetings|webinars`, checkbox list of rows (topic, start, alreadyImported disabled), access‑mode select, "Import selected" → `POST /webinars/admin/zoom/import` per row; invalidate `['webinars']`.
- [ ] **Step 4:** Run `npm run build` — Expected: success. Manual: create a webinar, see it listed.
- [ ] **Step 5: Commit** `git commit -am "feat(web): admin webinar list, create/edit, Zoom sync"`

### Task 5.3: Admin — Assignments UI + Send Invites

**Files:** Modify `WebinarList.tsx` (or add `WebinarAssign.tsx` modal)

- [ ] **Step 1:** Assign modal: search `GET /webinars/admin/:id/assignable?search=`, list assigned `GET /webinars/admin/:id/assigned`, assign/unassign via `POST/DELETE /webinars/admin/:id/assign/:personId`. Only shown when `accessMode==ASSIGNED`.
- [ ] **Step 2:** "Send Invites" action → `POST /webinars/admin/:id/send-invites`, toast the `{sent}` count.
- [ ] **Step 3:** Run `npm run build` — Expected: success. Manual: assign a member, send invites.
- [ ] **Step 4: Commit** `git commit -am "feat(web): webinar assignments + send invites"`

### Task 5.4: Admin — Attendance report (with XLSX/PDF export)

**Files:** Create `web/src/pages/admin/webinars/WebinarReport.tsx`

- [ ] **Step 1:** `GET /webinars/admin/:id/report`; show summary (assigned/joined counts) + attendee table (ITS, name, joined ✓/✗, first joined local time, launch count). Reuse the XLSX/PDF export helpers already used in `ThaaliOrderReport.tsx`/`NiyazRsvpReport.tsx`.
- [ ] **Step 2:** Run `npm run build` — Expected: success. Manual: open report for a webinar with a join log.
- [ ] **Step 3: Commit** `git commit -am "feat(web): webinar attendance report + export"`

### Task 5.5: Member WebinarsPage + public MagicJoinPage

**Files:** Create `web/src/pages/WebinarsPage.tsx`, `web/src/pages/MagicJoinPage.tsx`

- [ ] **Step 1:** `WebinarsPage.tsx` — `GET /webinars` (member's authorized upcoming), card list with local start time + countdown (reuse existing local‑time helper). "Join" button does `window.location.href = \`${API_BASE}/api/webinars/${id}/launch\`` (browser navigation → server 302 to Zoom; URL never in JS state).
- [ ] **Step 2:** `MagicJoinPage.tsx` (route `/j/:token`, public layout) — `GET /webinars/public/:token`; render title/host/when + countdown; if `joinOpen`, "Join Zoom" button navigates to `${API_BASE}/api/webinars/public/:token/launch`; on 404 show "This link is invalid or expired."
- [ ] **Step 3:** Run `npm run build` — Expected: success. Manual: as a member, Join redirects to Zoom with your name; open a magic link in a private window.
- [ ] **Step 4: Commit** `git commit -am "feat(web): member webinars page + public magic-join page"`

### Task 5.6: Deploy config + docs

**Files:** Modify `docker-compose.yml`, create/update `.env.example`‑style docs, update `DEPLOYMENT.md`

- [ ] **Step 1:** Add Zoom env to the `server` service in `docker-compose.yml`:

```yaml
      APP_PUBLIC_BASE_URL: ${APP_PUBLIC_BASE_URL:-http://localhost:5173}
      ZOOM_ENABLED: ${ZOOM_ENABLED:-false}
      ZOOM_ACCOUNT_ID: ${ZOOM_ACCOUNT_ID:-}
      ZOOM_CLIENT_ID: ${ZOOM_CLIENT_ID:-}
      ZOOM_CLIENT_SECRET: ${ZOOM_CLIENT_SECRET:-}
      ZOOM_IMPORT_USER_ID: ${ZOOM_IMPORT_USER_ID:-}
      ZOOM_WEBINAR_IMPORT_USER_ID: ${ZOOM_WEBINAR_IMPORT_USER_ID:-}
```

- [ ] **Step 2:** Document the Zoom Server‑to‑Server OAuth app setup + required scopes (meeting:read, webinar:read) in `DEPLOYMENT.md`; note secrets go only in prod `.env`.
- [ ] **Step 3:** Run `docker compose config` locally to validate the compose file parses. 
- [ ] **Step 4: Commit** `git commit -am "chore: webinar Zoom deploy config + docs"`

### Task 5.7: End-to-end verification + security pass

- [ ] **Step 1:** `cd server && ./gradlew test` (Testcontainers) — Expected: all PASS. `cd web && npm run build` — Expected: success.
- [ ] **Step 2:** Manual E2E against the dev stack: create webinar → assign member → member Join redirects to Zoom with `uname` = ITS + name → attendance report shows the join → magic link (private window) joins and logs `MAGIC_LINK`.
- [ ] **Step 3: Security review** — invoke `/security-review` on the branch. Confirm: `joinUrl` never appears in any JSON (grep responses), tokens stored only as hashes, public endpoints limited to `/api/webinars/public/**`, method security (`@PreAuthorize`) enforced on admin endpoints, one‑active‑lock + join window enforced server‑side.
- [ ] **Step 4:** Repair the pre‑existing dev‑DB Flyway checksum drift if it blocks V37 locally (`flyway repair` on the dev DB), then re‑run migrations clean.
- [ ] **Step 5: Commit** any fixes; open PR to `main`.

---

## Self-Review

**Spec coverage** (against the MVP scope: controlled + tracked access, Zoom auto‑sync, magic links, attendance reports):
- Controlled access → Tasks 1.1–1.4 (WebinarEvent, access modes, assignments). ✅
- Tracked launch, URL hiding, display‑name lock, one‑active lock, join window → Tasks 1.5–1.6. ✅
- Zoom S2S OAuth auto‑sync → Tasks 2.1–2.3. ✅
- Magic join links (hashed, expiring, emailed, public page) → Tasks 3.1–3.3, 5.5. ✅
- Attendance reports → Task 4.1, 5.4. ✅
- Roles/coordinator scoping → Tasks 0.3, 1.6, 5.1. ✅
- Config/secrets/deploy → Tasks 0.2, 5.6. ✅
- Embedded Meeting SDK → **explicitly out of MVP scope** (deferred), no task. ✅

**Placeholder scan:** No "TBD"/"handle edge cases" steps; each backend task carries concrete test + code; frontend tasks name exact sibling files to mirror (allowed for an existing codebase with no FE test harness).

**Type consistency:** `WebinarSummary`/`WebinarDetail`/`CreateWebinarRequest` used consistently across service (1.3) and controllers (1.6); `JoinSource.PORTAL`/`MAGIC_LINK` used in 1.5/3.3; `reserveAndBuildLaunchUrl(eventId, person, source, now)` signature identical in 1.5, 1.6, 3.3; `canAccess(WebinarEvent, Person)` consistent in 1.4/1.5/4.1; `sha256Hex`/`randomToken` consistent in 3.1/3.2/3.3.

**Open design decisions carried into the plan (not blockers):**
- `Person` has no `title` field → display name is `ITS First Last` in MVP (noted in Task 1.5); adding a salutation is a future enhancement.
- Topics/subscriptions, family/group credit, WhatsApp launcher, embedded SDK are deferred (documented as out of scope).
- Confirm the `roles` table column names against `V10__roles_table.sql` before finalizing the V37 seed INSERT (noted in Task 0.3).

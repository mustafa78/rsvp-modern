# Zoom Webinar Access with Family Seats — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Let admins and webinar coordinators give members and their saved family members personal, tracked seats on Zoom webinars, with the Zoom URL hidden behind a server redirect and a per-attendee attendance report.

**Architecture:** A self-contained webinar module in the existing Spring Boot + React + Postgres app. `webinars` is its own table (not an `Event` subtype). Every attendee of a webinar, member or family member, has one `webinar_seats` row; join links, join logs and the one-webinar-at-a-time lock all resolve the attendee through the seat. Family members are a plain list under an HOF `Person` with no login.

**Tech Stack:** Java 21, Spring Boot 3.5.1 (spring-web `RestClient`, Spring Security, Spring Data JPA), Flyway 11.10 on PostgreSQL 16, JUnit 5 + AssertJ + MockMvc + Testcontainers. Frontend: React 18 + TypeScript + Vite, `@tanstack/react-query` v5, react-router v6, Tailwind, `xlsx`, `jspdf` + `jspdf-autotable`.

**Spec:** `docs/superpowers/specs/2026-11-21-zoom-webinar-family-seats-design.md`
**Supersedes:** `docs/superpowers/plans/2026-08-03-zoom-webinar-integration.md`

## Global Constraints

- Work on branch `feature/zoom-webinar-family-seats`, created from `main`. Never commit to `main`.
- Java toolchain 21; Spring Boot 3.5.1. Add no dependencies beyond the Testcontainers test dependencies in Task 1.
- `spring.jpa.hibernate.ddl-auto=validate`: every JPA column must match `V37` exactly. Use `VARCHAR(n)`, never `TEXT`.
- The only migration is `V37__webinar_integration.sql`. Do not edit V1–V36; modified old migrations have broken prod and dev before.
- Nothing is added to the `events` table.
- `Webinar.joinUrl` is server-side only. It must not appear in any DTO, JSON response, log line or email. The frontend treats it as write-only.
- Zoom display name is exactly `ITS First Last`, written to the `uname` query parameter, replacing any existing `uname`.
- Family member ITS: exactly 8 digits, unique in `family_members`, and must not exist in `persons.its_number`. Registration and admin user creation must reject an ITS that exists in `family_members`.
- A family seat's `person_id` is the family member's HOF. A family seat never requires the HOF to hold a seat.
- Role enforcement for this module is by URL rules in `WebSecurityConfig` (`hasAnyRole("ADMIN","WEBINAR_COORDINATOR")`). Do **not** add `@EnableMethodSecurity`: the app has dormant `@PreAuthorize` annotations on `AnnouncementController` and `IngredientLookupController` that would start blocking coordinators if activated. That is a separate piece of work.
- Rule violations throw `IllegalStateException` / `IllegalArgumentException` (mapped to 400 by `GlobalExceptionHandler`). Unknown tokens and ids throw `NotFoundException` (404).
- Magic links are built from the existing `app.frontend-url` property (`FRONTEND_URL`). Do not add a second base-URL variable.
- Zoom secrets live only in the runtime environment and the git-ignored prod `.env`.
- Backend tests extend `PostgresIntegrationTest` (real Postgres 16, all migrations, transaction rolled back per test) unless stated as a plain unit test. Docker must be running.
- The frontend has no test harness. Verification is `cd web && npm run build` plus the stated manual check.
- Commit messages end with the repo's standard `Co-Authored-By` trailer.

---

## File Structure

Paths under `server/src/main/java/com/acme/rsvp/` unless they start with `server/` or `web/`.

**Backend — create**
- `server/src/main/resources/db/migration/V37__webinar_integration.sql` — all schema plus the role seed.
- `model/Webinar.java`, `WebinarStatus.java`, `WebinarAccessMode.java` — webinar entity; join-window logic.
- `model/FamilyMember.java` — saved family member under an HOF.
- `model/WebinarSeat.java`, `SeatSource.java` — one attendee on one webinar; resolves ITS and name.
- `model/WebinarJoinToken.java`, `WebinarJoinLog.java`, `JoinSource.java`, `WebinarActiveLock.java`.
- `repository/WebinarRepository.java`, `FamilyMemberRepository.java`, `WebinarSeatRepository.java`, `WebinarJoinTokenRepository.java`, `WebinarJoinLogRepository.java`, `WebinarActiveLockRepository.java`.
- `exception/NotFoundException.java`.
- `config/WebinarProperties.java` — join-window defaults, display time zone.
- `dto/WebinarDtos.java` — every request/response record for the module.
- `security/TokenHasher.java` — random token + SHA-256.
- `service/WebinarService.java` — webinar CRUD and member listing.
- `service/FamilyMemberService.java` — family member CRUD and ITS rules.
- `service/WebinarSeatService.java` — give/remove/list/search/copy seats.
- `service/WebinarLaunchService.java` — launch checks, logging, lock, URL building.
- `service/WebinarInviteService.java` — issue links, send family emails.
- `service/WebinarReportService.java` — attendance aggregation.
- `zoom/ZoomProperties.java`, `ZoomClient.java`, `ZoomMeeting.java` — S2S OAuth and list calls.
- `service/WebinarZoomSyncService.java` — preview and import.
- `web/WebinarAdminController.java`, `FamilyMemberAdminController.java`, `WebinarController.java`, `WebinarPublicController.java`.

**Backend — modify**
- `server/build.gradle.kts` — Testcontainers.
- `RsvpApplication.java` — `@ConfigurationPropertiesScan`.
- `server/src/main/resources/application.yml` — `app.webinar.*`, `app.zoom.*`.
- `config/WebSecurityConfig.java`, `security/SessionAuthFilter.java` — public and role rules.
- `web/GlobalExceptionHandler.java` — 404 mapping.
- `repository/PersonRepository.java` — active-person search.
- `service/AuthService.java`, `service/AdminUserService.java` — reject family-member ITS.
- `service/EmailService.java` — `sendWebinarInvite`.
- `docker-compose.yml`, `docker-compose.dev.yml`, `DEPLOYMENT.md`.

**Backend tests — create** under `server/src/test/java/com/acme/rsvp/`
- `support/PostgresIntegrationTest.java`, `support/TestData.java`.
- One test class per task, named in the task.

**Frontend — create** under `web/src/`
- `lib/webinars.ts` — shared types and helpers.
- `pages/WebinarsPage.tsx`, `pages/MagicJoinPage.tsx`.
- `pages/admin/webinars/WebinarList.tsx`, `CreateWebinar.tsx`, `ZoomSyncModal.tsx`, `WebinarAttendees.tsx`, `FamilyMembers.tsx`, `WebinarReport.tsx`.

**Frontend — modify**
- `main.tsx`, `App.tsx`, `pages/admin/AdminLayout.tsx`, `pages/admin/settings/UserList.tsx`.

---

## Task 1: Integration test harness

The repo has one test, `RsvpApplicationTests`, which needs a database on `localhost:5432` and so cannot run in isolation. This task gives every later task a real Postgres.

**Files:**
- Modify: `server/build.gradle.kts`
- Create: `server/src/test/java/com/acme/rsvp/support/PostgresIntegrationTest.java`
- Create: `server/src/test/java/com/acme/rsvp/support/TestData.java`
- Modify: `server/src/test/java/com/acme/rsvp/RsvpApplicationTests.java`

**Interfaces:**
- Produces: abstract `PostgresIntegrationTest` (Spring context + MockMvc + rollback per test). `TestData.person(boolean hof, String... roles) : Person` (unique ITS and email, `USER` role if none given) and `TestData.session(Person) : jakarta.servlet.http.Cookie` (a valid `RSVP_SESSION` cookie).

- [ ] **Step 1: Create the branch**

```bash
git checkout main && git pull && git checkout -b feature/zoom-webinar-family-seats
```

- [ ] **Step 2: Add test dependencies** to the `dependencies {}` block of `server/build.gradle.kts`, after the existing `testImplementation` line:

```kotlin
	testImplementation("org.springframework.boot:spring-boot-testcontainers")
	testImplementation("org.testcontainers:junit-jupiter")
	testImplementation("org.testcontainers:postgresql")
```

- [ ] **Step 3: Write `PostgresIntegrationTest.java`**

```java
package com.acme.rsvp.support;

import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.DynamicPropertyRegistry;
import org.springframework.test.context.DynamicPropertySource;
import org.springframework.transaction.annotation.Transactional;
import org.testcontainers.containers.PostgreSQLContainer;

/**
 * Base class for tests that need the real schema. One Postgres 16 container is shared by the
 * whole test run (started once, never stopped) so the Spring context can be cached across classes.
 * Each test method runs in a transaction that is rolled back.
 */
@SpringBootTest
@AutoConfigureMockMvc
@Transactional
public abstract class PostgresIntegrationTest {

  static final PostgreSQLContainer<?> POSTGRES = new PostgreSQLContainer<>("postgres:16");

  static {
    POSTGRES.start();
  }

  @DynamicPropertySource
  static void datasource(DynamicPropertyRegistry r) {
    r.add("spring.datasource.url", POSTGRES::getJdbcUrl);
    r.add("spring.datasource.username", POSTGRES::getUsername);
    r.add("spring.datasource.password", POSTGRES::getPassword);
  }
}
```

- [ ] **Step 4: Write `TestData.java`**

```java
package com.acme.rsvp.support;

import java.time.OffsetDateTime;
import java.util.HashSet;
import java.util.List;
import java.util.UUID;
import java.util.concurrent.atomic.AtomicInteger;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.acme.rsvp.model.Person;
import com.acme.rsvp.model.SessionToken;
import com.acme.rsvp.repository.PersonRepository;
import com.acme.rsvp.repository.SessionTokenRepository;

import jakarta.servlet.http.Cookie;

/** Builders for test fixtures. ITS numbers start with 9 so they cannot clash with seeded users. */
@Component
public class TestData {

  private static final AtomicInteger SEQ = new AtomicInteger(1000);

  @Autowired PersonRepository persons;
  @Autowired SessionTokenRepository sessions;

  public static String nextIts() {
    return "9" + String.format("%07d", SEQ.incrementAndGet());
  }

  public Person person(boolean hof, String... roles) {
    String its = nextIts();
    Person p = new Person();
    p.setItsNumber(its);
    p.setFirstName("Test");
    p.setLastName("User" + its);
    p.setEmail("test" + its + "@example.com");
    p.setPasswordHash("x");
    p.setHof(hof);
    p.setRoles(new HashSet<>(roles.length == 0 ? List.of("USER") : List.of(roles)));
    return persons.saveAndFlush(p);
  }

  public Cookie session(Person p) {
    OffsetDateTime now = OffsetDateTime.now();
    SessionToken t = new SessionToken(UUID.randomUUID(), p, now, now.plusHours(1));
    sessions.saveAndFlush(t);
    return new Cookie("RSVP_SESSION", t.getId().toString());
  }
}
```

- [ ] **Step 5: Convert the existing test** — replace the whole of `RsvpApplicationTests.java`:

```java
package com.acme.rsvp;

import static org.assertj.core.api.Assertions.assertThat;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import com.acme.rsvp.model.Person;
import com.acme.rsvp.support.PostgresIntegrationTest;
import com.acme.rsvp.support.TestData;

class RsvpApplicationTests extends PostgresIntegrationTest {

  @Autowired TestData data;

  @Test
  void contextLoadsAndAllMigrationsApply() {
    Person p = data.person(true);
    assertThat(p.getId()).isNotNull();
    assertThat(data.session(p).getValue()).isNotBlank();
  }
}
```

- [ ] **Step 6: Run it**

Run: `cd server && ./gradlew test --tests "com.acme.rsvp.RsvpApplicationTests"`
Expected: PASS. The container starts, V1–V36 apply to an empty database, and the context validates.

If a migration fails on the empty database, stop and report which one; do not edit it. If `persons.pickup_zone_id` or another column rejects the minimal `Person`, set that field in `TestData.person` and note it.

- [ ] **Step 7: Commit**

```bash
git add server/build.gradle.kts server/src/test
git commit -m "test: add Testcontainers Postgres harness and fixtures"
```

---

## Task 2: V37 schema

**Files:**
- Create: `server/src/main/resources/db/migration/V37__webinar_integration.sql`
- Test: `server/src/test/java/com/acme/rsvp/migration/V37MigrationTest.java`

**Interfaces:**
- Produces: tables `webinars`, `family_members`, `webinar_seats`, `webinar_join_tokens`, `webinar_join_logs`, `webinar_active_locks`; role `WEBINAR_COORDINATOR`.

- [ ] **Step 1: Write the failing test**

```java
package com.acme.rsvp.migration;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.jdbc.core.JdbcTemplate;

import com.acme.rsvp.model.Person;
import com.acme.rsvp.support.PostgresIntegrationTest;
import com.acme.rsvp.support.TestData;

class V37MigrationTest extends PostgresIntegrationTest {

  @Autowired JdbcTemplate jdbc;
  @Autowired TestData data;

  @Test
  void tablesAndRoleExist() {
    for (String t : new String[] {"webinars", "family_members", "webinar_seats",
        "webinar_join_tokens", "webinar_join_logs", "webinar_active_locks"}) {
      Integer n = jdbc.queryForObject(
          "select count(*) from information_schema.tables where table_name = ?", Integer.class, t);
      assertThat(n).as(t).isEqualTo(1);
    }
    assertThat(jdbc.queryForObject(
        "select count(*) from roles where name = 'WEBINAR_COORDINATOR'", Integer.class)).isEqualTo(1);
  }

  @Test
  void eventsTableIsUntouched() {
    Integer n = jdbc.queryForObject(
        "select count(*) from information_schema.columns where table_name = 'events' "
            + "and column_name in ('join_url','zoom_meeting_id','scheduled_start')", Integer.class);
    assertThat(n).isZero();
  }

  @Test
  void aPersonCanHoldOnlyOneOwnSeatPerWebinar() {
    Person p = data.person(true);
    Long w = jdbc.queryForObject(
        "insert into webinars (title, scheduled_start, scheduled_end) "
            + "values ('T', now(), now() + interval '1 hour') returning id", Long.class);
    jdbc.update("insert into webinar_seats (webinar_id, person_id, source) values (?,?,'ASSIGNED')", w, p.getId());
    assertThatThrownBy(() -> jdbc.update(
        "insert into webinar_seats (webinar_id, person_id, source) values (?,?,'ASSIGNED')", w, p.getId()))
        .isInstanceOf(DataIntegrityViolationException.class);
  }
}
```

- [ ] **Step 2: Run it to verify it fails**

Run: `cd server && ./gradlew test --tests "*V37MigrationTest"`
Expected: FAIL — `relation "webinars" does not exist` / table count 0.

- [ ] **Step 3: Write `V37__webinar_integration.sql`**

```sql
-- Webinar module: webinars, saved family members, seats, join tokens, join logs, active locks, role.
-- Nothing here touches the events table.

CREATE TABLE webinars (
  id                      BIGSERIAL PRIMARY KEY,
  title                   VARCHAR(200)  NOT NULL,
  description             VARCHAR(2000),
  host_name               VARCHAR(200),
  scheduled_start         TIMESTAMPTZ   NOT NULL,
  scheduled_end           TIMESTAMPTZ   NOT NULL,
  status                  VARCHAR(16)   NOT NULL DEFAULT 'DRAFT',
  access_mode             VARCHAR(16)   NOT NULL DEFAULT 'ASSIGNED',
  join_url                VARCHAR(2000),
  zoom_meeting_id         VARCHAR(64),
  managed_by_zoom         BOOLEAN       NOT NULL DEFAULT FALSE,
  join_window_before_min  INTEGER       NOT NULL DEFAULT 10,
  join_window_after_min   INTEGER       NOT NULL DEFAULT 15,
  event_id                BIGINT        REFERENCES events(id) ON DELETE SET NULL,
  created_at              TIMESTAMPTZ   NOT NULL DEFAULT now(),
  updated_at              TIMESTAMPTZ   NOT NULL DEFAULT now(),
  CONSTRAINT chk_webinar_times  CHECK (scheduled_end > scheduled_start),
  CONSTRAINT chk_webinar_status CHECK (status IN ('DRAFT','PUBLISHED','CANCELLED')),
  CONSTRAINT chk_webinar_access CHECK (access_mode IN ('OPEN','ASSIGNED'))
);
CREATE UNIQUE INDEX ux_webinars_zoom_occurrence
  ON webinars (zoom_meeting_id, scheduled_start) WHERE zoom_meeting_id IS NOT NULL;
CREATE INDEX ix_webinars_status_start ON webinars (status, scheduled_start);

CREATE TABLE family_members (
  id             BIGSERIAL PRIMARY KEY,
  hof_person_id  BIGINT       NOT NULL REFERENCES persons(id) ON DELETE CASCADE,
  first_name     VARCHAR(100) NOT NULL,
  last_name      VARCHAR(100) NOT NULL,
  its_number     VARCHAR(32)  NOT NULL UNIQUE,
  active         BOOLEAN      NOT NULL DEFAULT TRUE,
  created_at     TIMESTAMPTZ  NOT NULL DEFAULT now(),
  updated_at     TIMESTAMPTZ  NOT NULL DEFAULT now()
);
CREATE INDEX ix_family_members_hof ON family_members (hof_person_id);

CREATE TABLE webinar_seats (
  id                BIGSERIAL PRIMARY KEY,
  webinar_id        BIGINT      NOT NULL REFERENCES webinars(id) ON DELETE CASCADE,
  person_id         BIGINT      NOT NULL REFERENCES persons(id) ON DELETE CASCADE,
  family_member_id  BIGINT      REFERENCES family_members(id) ON DELETE CASCADE,
  source            VARCHAR(16) NOT NULL DEFAULT 'ASSIGNED',
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT chk_seat_source CHECK (source IN ('ASSIGNED','OPEN_AUTO'))
);
-- One own seat per person per webinar; one seat per family member per webinar.
CREATE UNIQUE INDEX ux_seat_own    ON webinar_seats (webinar_id, person_id)        WHERE family_member_id IS NULL;
CREATE UNIQUE INDEX ux_seat_family ON webinar_seats (webinar_id, family_member_id) WHERE family_member_id IS NOT NULL;
CREATE INDEX ix_seat_person ON webinar_seats (person_id);

CREATE TABLE webinar_join_tokens (
  id            UUID PRIMARY KEY,
  seat_id       BIGINT      NOT NULL REFERENCES webinar_seats(id) ON DELETE CASCADE,
  token_hash    VARCHAR(64) NOT NULL UNIQUE,
  created_at    TIMESTAMPTZ NOT NULL,
  expires_at    TIMESTAMPTZ NOT NULL,
  revoked_at    TIMESTAMPTZ,
  last_used_at  TIMESTAMPTZ,
  use_count     INTEGER     NOT NULL DEFAULT 0
);
CREATE INDEX ix_join_tokens_seat ON webinar_join_tokens (seat_id);

CREATE TABLE webinar_join_logs (
  id         BIGSERIAL PRIMARY KEY,
  seat_id    BIGINT      NOT NULL REFERENCES webinar_seats(id) ON DELETE CASCADE,
  joined_at  TIMESTAMPTZ NOT NULL,
  source     VARCHAR(16) NOT NULL,
  CONSTRAINT chk_join_source CHECK (source IN ('PORTAL','MAGIC_LINK'))
);
CREATE INDEX ix_join_logs_seat ON webinar_join_logs (seat_id, joined_at);

CREATE TABLE webinar_active_locks (
  id                BIGSERIAL PRIMARY KEY,
  person_id         BIGINT      NOT NULL REFERENCES persons(id) ON DELETE CASCADE,
  family_member_id  BIGINT      REFERENCES family_members(id) ON DELETE CASCADE,
  webinar_id        BIGINT      NOT NULL REFERENCES webinars(id) ON DELETE CASCADE,
  locked_until      TIMESTAMPTZ NOT NULL
);
-- One lock per attendee: the member themselves, or each family member independently.
CREATE UNIQUE INDEX ux_lock_own    ON webinar_active_locks (person_id)        WHERE family_member_id IS NULL;
CREATE UNIQUE INDEX ux_lock_family ON webinar_active_locks (family_member_id) WHERE family_member_id IS NOT NULL;

INSERT INTO roles (name, description)
SELECT 'WEBINAR_COORDINATOR', 'Manage webinars, family members, seats, and attendance reports'
WHERE NOT EXISTS (SELECT 1 FROM roles WHERE name = 'WEBINAR_COORDINATOR');
```

- [ ] **Step 4: Run the test**

Run: `cd server && ./gradlew test --tests "*V37MigrationTest"`
Expected: PASS (3 tests).

- [ ] **Step 5: Commit**

```bash
git add server/src/main/resources/db/migration/V37__webinar_integration.sql server/src/test/java/com/acme/rsvp/migration
git commit -m "feat: V37 webinar schema and WEBINAR_COORDINATOR role"
```

---

## Task 3: Entities and repositories

**Files:**
- Create: `model/Webinar.java`, `WebinarStatus.java`, `WebinarAccessMode.java`, `FamilyMember.java`, `WebinarSeat.java`, `SeatSource.java`, `WebinarJoinToken.java`, `WebinarJoinLog.java`, `JoinSource.java`, `WebinarActiveLock.java`
- Create: `repository/WebinarRepository.java`, `FamilyMemberRepository.java`, `WebinarSeatRepository.java`, `WebinarJoinTokenRepository.java`, `WebinarJoinLogRepository.java`, `WebinarActiveLockRepository.java`
- Modify: `repository/PersonRepository.java`
- Modify: `server/src/test/java/com/acme/rsvp/support/TestData.java`
- Test: `server/src/test/java/com/acme/rsvp/model/WebinarModelTest.java`

**Interfaces:**
- Produces (entities):
  - `Webinar`: getters/setters for `title, description, hostName, scheduledStart, scheduledEnd (OffsetDateTime), status (WebinarStatus), accessMode (WebinarAccessMode), joinUrl, zoomMeetingId, managedByZoom (boolean), joinWindowBeforeMin, joinWindowAfterMin (int), eventId (Long)`; `joinWindowStart()`, `joinWindowEnd() : OffsetDateTime`; `isJoinOpen(OffsetDateTime now) : boolean` (true only when `PUBLISHED` and inside the window, inclusive).
  - `FamilyMember`: `hof (Person)`, `firstName`, `lastName`, `itsNumber`, `active`; `fullName()`.
  - `WebinarSeat(Webinar, Person, FamilyMember, SeatSource)`: `getWebinar()`, `getPerson()`, `getFamilyMember()`, `isFamilySeat()`, `attendeeIts()`, `attendeeName()`, `displayName()` = `attendeeIts() + " " + attendeeName()`.
  - `WebinarJoinToken(UUID id, WebinarSeat seat, String tokenHash, OffsetDateTime createdAt, OffsetDateTime expiresAt)` with `revokedAt`, `lastUsedAt`, `useCount`.
  - `WebinarJoinLog(WebinarSeat seat, OffsetDateTime joinedAt, JoinSource source)`.
  - `WebinarActiveLock(Person person, FamilyMember familyMember)` with `webinar`, `lockedUntil`.
- Produces (repositories): the method signatures in Step 4.
- Produces (fixtures): `TestData.webinar(WebinarAccessMode mode, OffsetDateTime start) : Webinar` (published, one hour long, join URL `https://zoom.us/j/123?pwd=abc`); `TestData.familyMember(Person hof) : FamilyMember`.

- [ ] **Step 1: Write the failing test**

```java
package com.acme.rsvp.model;

import static org.assertj.core.api.Assertions.assertThat;

import java.time.OffsetDateTime;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import com.acme.rsvp.repository.WebinarSeatRepository;
import com.acme.rsvp.support.PostgresIntegrationTest;
import com.acme.rsvp.support.TestData;

class WebinarModelTest extends PostgresIntegrationTest {

  @Autowired TestData data;
  @Autowired WebinarSeatRepository seats;

  @Test
  void joinWindowIsInclusiveAndRequiresPublished() {
    OffsetDateTime start = OffsetDateTime.parse("2030-01-01T18:00:00Z");
    Webinar w = data.webinar(WebinarAccessMode.ASSIGNED, start);
    assertThat(w.isJoinOpen(start.minusMinutes(11))).isFalse();
    assertThat(w.isJoinOpen(start.minusMinutes(10))).isTrue();
    assertThat(w.isJoinOpen(start.plusHours(1).plusMinutes(15))).isTrue();
    assertThat(w.isJoinOpen(start.plusHours(1).plusMinutes(16))).isFalse();
    w.setStatus(WebinarStatus.DRAFT);
    assertThat(w.isJoinOpen(start)).isFalse();
  }

  @Test
  void seatResolvesMemberOrFamilyIdentity() {
    Person hof = data.person(true);
    FamilyMember fm = data.familyMember(hof);
    Webinar w = data.webinar(WebinarAccessMode.ASSIGNED, OffsetDateTime.now().plusDays(1));

    WebinarSeat own = seats.saveAndFlush(new WebinarSeat(w, hof, null, SeatSource.ASSIGNED));
    WebinarSeat family = seats.saveAndFlush(new WebinarSeat(w, hof, fm, SeatSource.ASSIGNED));

    assertThat(own.isFamilySeat()).isFalse();
    assertThat(own.displayName()).isEqualTo(hof.getItsNumber() + " " + hof.getFirstName() + " " + hof.getLastName());
    assertThat(family.isFamilySeat()).isTrue();
    assertThat(family.displayName()).isEqualTo(fm.getItsNumber() + " " + fm.getFirstName() + " " + fm.getLastName());
    assertThat(seats.findByWebinarIdAndFamilyMemberId(w.getId(), fm.getId())).isPresent();
    assertThat(seats.findByWebinarIdAndPersonIdAndFamilyMemberIsNull(w.getId(), hof.getId())).isPresent();
    assertThat(seats.findByWebinarIdWithAttendees(w.getId())).hasSize(2);
  }
}
```

- [ ] **Step 2: Run it to verify it fails**

Run: `cd server && ./gradlew test --tests "*WebinarModelTest"`
Expected: FAIL — compilation errors, `Webinar` and the other types do not exist.

- [ ] **Step 3: Write the enums and entities**

`WebinarStatus.java`:
```java
package com.acme.rsvp.model;

public enum WebinarStatus { DRAFT, PUBLISHED, CANCELLED }
```

`WebinarAccessMode.java`:
```java
package com.acme.rsvp.model;

public enum WebinarAccessMode { OPEN, ASSIGNED }
```

`SeatSource.java`:
```java
package com.acme.rsvp.model;

public enum SeatSource { ASSIGNED, OPEN_AUTO }
```

`JoinSource.java`:
```java
package com.acme.rsvp.model;

public enum JoinSource { PORTAL, MAGIC_LINK }
```

`Webinar.java`:
```java
package com.acme.rsvp.model;

import java.time.OffsetDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "webinars")
public class Webinar extends Auditable {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;

  @Column(name = "title", nullable = false, length = 200)
  private String title;

  @Column(name = "description", length = 2000)
  private String description;

  @Column(name = "host_name", length = 200)
  private String hostName;

  @Column(name = "scheduled_start", nullable = false)
  private OffsetDateTime scheduledStart;

  @Column(name = "scheduled_end", nullable = false)
  private OffsetDateTime scheduledEnd;

  @Enumerated(EnumType.STRING)
  @Column(name = "status", nullable = false, length = 16)
  private WebinarStatus status = WebinarStatus.DRAFT;

  @Enumerated(EnumType.STRING)
  @Column(name = "access_mode", nullable = false, length = 16)
  private WebinarAccessMode accessMode = WebinarAccessMode.ASSIGNED;

  /** Secret. Never copy this into a DTO, log line or email. */
  @Column(name = "join_url", length = 2000)
  private String joinUrl;

  @Column(name = "zoom_meeting_id", length = 64)
  private String zoomMeetingId;

  @Column(name = "managed_by_zoom", nullable = false)
  private boolean managedByZoom = false;

  @Column(name = "join_window_before_min", nullable = false)
  private int joinWindowBeforeMin = 10;

  @Column(name = "join_window_after_min", nullable = false)
  private int joinWindowAfterMin = 15;

  @Column(name = "event_id")
  private Long eventId;

  public OffsetDateTime joinWindowStart() { return scheduledStart.minusMinutes(joinWindowBeforeMin); }

  public OffsetDateTime joinWindowEnd() { return scheduledEnd.plusMinutes(joinWindowAfterMin); }

  public boolean isJoinOpen(OffsetDateTime now) {
    return status == WebinarStatus.PUBLISHED
        && !now.isBefore(joinWindowStart())
        && !now.isAfter(joinWindowEnd());
  }

  public Long getId() { return id; }
  public String getTitle() { return title; }
  public void setTitle(String title) { this.title = title; }
  public String getDescription() { return description; }
  public void setDescription(String description) { this.description = description; }
  public String getHostName() { return hostName; }
  public void setHostName(String hostName) { this.hostName = hostName; }
  public OffsetDateTime getScheduledStart() { return scheduledStart; }
  public void setScheduledStart(OffsetDateTime scheduledStart) { this.scheduledStart = scheduledStart; }
  public OffsetDateTime getScheduledEnd() { return scheduledEnd; }
  public void setScheduledEnd(OffsetDateTime scheduledEnd) { this.scheduledEnd = scheduledEnd; }
  public WebinarStatus getStatus() { return status; }
  public void setStatus(WebinarStatus status) { this.status = status; }
  public WebinarAccessMode getAccessMode() { return accessMode; }
  public void setAccessMode(WebinarAccessMode accessMode) { this.accessMode = accessMode; }
  public String getJoinUrl() { return joinUrl; }
  public void setJoinUrl(String joinUrl) { this.joinUrl = joinUrl; }
  public String getZoomMeetingId() { return zoomMeetingId; }
  public void setZoomMeetingId(String zoomMeetingId) { this.zoomMeetingId = zoomMeetingId; }
  public boolean isManagedByZoom() { return managedByZoom; }
  public void setManagedByZoom(boolean managedByZoom) { this.managedByZoom = managedByZoom; }
  public int getJoinWindowBeforeMin() { return joinWindowBeforeMin; }
  public void setJoinWindowBeforeMin(int v) { this.joinWindowBeforeMin = v; }
  public int getJoinWindowAfterMin() { return joinWindowAfterMin; }
  public void setJoinWindowAfterMin(int v) { this.joinWindowAfterMin = v; }
  public Long getEventId() { return eventId; }
  public void setEventId(Long eventId) { this.eventId = eventId; }
}
```

`FamilyMember.java`:
```java
package com.acme.rsvp.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

/** A family member saved under a head of family. Not a user: no login, password or role. */
@Entity
@Table(name = "family_members")
public class FamilyMember extends Auditable {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;

  @ManyToOne(optional = false, fetch = FetchType.LAZY)
  @JoinColumn(name = "hof_person_id", nullable = false)
  private Person hof;

  @Column(name = "first_name", nullable = false, length = 100)
  private String firstName;

  @Column(name = "last_name", nullable = false, length = 100)
  private String lastName;

  @Column(name = "its_number", nullable = false, unique = true, length = 32)
  private String itsNumber;

  @Column(name = "active", nullable = false)
  private boolean active = true;

  public String fullName() { return firstName + " " + lastName; }

  public Long getId() { return id; }
  public Person getHof() { return hof; }
  public void setHof(Person hof) { this.hof = hof; }
  public String getFirstName() { return firstName; }
  public void setFirstName(String firstName) { this.firstName = firstName; }
  public String getLastName() { return lastName; }
  public void setLastName(String lastName) { this.lastName = lastName; }
  public String getItsNumber() { return itsNumber; }
  public void setItsNumber(String itsNumber) { this.itsNumber = itsNumber; }
  public boolean isActive() { return active; }
  public void setActive(boolean active) { this.active = active; }
}
```

`WebinarSeat.java`:
```java
package com.acme.rsvp.model;

import java.time.OffsetDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

/**
 * One attendee on one webinar. familyMember == null means the person's own seat;
 * otherwise person is the family member's head of family.
 */
@Entity
@Table(name = "webinar_seats")
public class WebinarSeat {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;

  @ManyToOne(optional = false, fetch = FetchType.LAZY)
  @JoinColumn(name = "webinar_id", nullable = false)
  private Webinar webinar;

  @ManyToOne(optional = false, fetch = FetchType.LAZY)
  @JoinColumn(name = "person_id", nullable = false)
  private Person person;

  @ManyToOne(fetch = FetchType.LAZY)
  @JoinColumn(name = "family_member_id")
  private FamilyMember familyMember;

  @Enumerated(EnumType.STRING)
  @Column(name = "source", nullable = false, length = 16)
  private SeatSource source;

  @Column(name = "created_at", nullable = false)
  private OffsetDateTime createdAt;

  protected WebinarSeat() {}

  public WebinarSeat(Webinar webinar, Person person, FamilyMember familyMember, SeatSource source) {
    this.webinar = webinar;
    this.person = person;
    this.familyMember = familyMember;
    this.source = source;
    this.createdAt = OffsetDateTime.now();
  }

  public boolean isFamilySeat() { return familyMember != null; }

  public String attendeeIts() {
    return familyMember != null ? familyMember.getItsNumber() : person.getItsNumber();
  }

  public String attendeeName() {
    return familyMember != null
        ? familyMember.fullName()
        : person.getFirstName() + " " + person.getLastName();
  }

  /** The locked Zoom display name: "ITS First Last". */
  public String displayName() { return attendeeIts() + " " + attendeeName(); }

  public Long getId() { return id; }
  public Webinar getWebinar() { return webinar; }
  public Person getPerson() { return person; }
  public FamilyMember getFamilyMember() { return familyMember; }
  public SeatSource getSource() { return source; }
  public OffsetDateTime getCreatedAt() { return createdAt; }
}
```

`WebinarJoinToken.java`:
```java
package com.acme.rsvp.model;

import java.time.OffsetDateTime;
import java.util.UUID;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

/** A magic join link for one seat. Only the SHA-256 hash of the raw token is stored. */
@Entity
@Table(name = "webinar_join_tokens")
public class WebinarJoinToken {

  @Id
  @Column(name = "id", columnDefinition = "uuid")
  private UUID id;

  @ManyToOne(optional = false, fetch = FetchType.LAZY)
  @JoinColumn(name = "seat_id", nullable = false)
  private WebinarSeat seat;

  @Column(name = "token_hash", nullable = false, unique = true, length = 64)
  private String tokenHash;

  @Column(name = "created_at", nullable = false)
  private OffsetDateTime createdAt;

  @Column(name = "expires_at", nullable = false)
  private OffsetDateTime expiresAt;

  @Column(name = "revoked_at")
  private OffsetDateTime revokedAt;

  @Column(name = "last_used_at")
  private OffsetDateTime lastUsedAt;

  @Column(name = "use_count", nullable = false)
  private int useCount = 0;

  protected WebinarJoinToken() {}

  public WebinarJoinToken(UUID id, WebinarSeat seat, String tokenHash,
      OffsetDateTime createdAt, OffsetDateTime expiresAt) {
    this.id = id;
    this.seat = seat;
    this.tokenHash = tokenHash;
    this.createdAt = createdAt;
    this.expiresAt = expiresAt;
  }

  public UUID getId() { return id; }
  public WebinarSeat getSeat() { return seat; }
  public String getTokenHash() { return tokenHash; }
  public OffsetDateTime getCreatedAt() { return createdAt; }
  public OffsetDateTime getExpiresAt() { return expiresAt; }
  public OffsetDateTime getRevokedAt() { return revokedAt; }
  public void setRevokedAt(OffsetDateTime revokedAt) { this.revokedAt = revokedAt; }
  public OffsetDateTime getLastUsedAt() { return lastUsedAt; }
  public void setLastUsedAt(OffsetDateTime lastUsedAt) { this.lastUsedAt = lastUsedAt; }
  public int getUseCount() { return useCount; }
  public void setUseCount(int useCount) { this.useCount = useCount; }
}
```

`WebinarJoinLog.java`:
```java
package com.acme.rsvp.model;

import java.time.OffsetDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

@Entity
@Table(name = "webinar_join_logs")
public class WebinarJoinLog {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;

  @ManyToOne(optional = false, fetch = FetchType.LAZY)
  @JoinColumn(name = "seat_id", nullable = false)
  private WebinarSeat seat;

  @Column(name = "joined_at", nullable = false)
  private OffsetDateTime joinedAt;

  @Enumerated(EnumType.STRING)
  @Column(name = "source", nullable = false, length = 16)
  private JoinSource source;

  protected WebinarJoinLog() {}

  public WebinarJoinLog(WebinarSeat seat, OffsetDateTime joinedAt, JoinSource source) {
    this.seat = seat;
    this.joinedAt = joinedAt;
    this.source = source;
  }

  public Long getId() { return id; }
  public WebinarSeat getSeat() { return seat; }
  public OffsetDateTime getJoinedAt() { return joinedAt; }
  public JoinSource getSource() { return source; }
}
```

`WebinarActiveLock.java`:
```java
package com.acme.rsvp.model;

import java.time.OffsetDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

/** Which webinar an attendee is currently in. One row per attendee. */
@Entity
@Table(name = "webinar_active_locks")
public class WebinarActiveLock {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;

  @ManyToOne(optional = false, fetch = FetchType.LAZY)
  @JoinColumn(name = "person_id", nullable = false)
  private Person person;

  @ManyToOne(fetch = FetchType.LAZY)
  @JoinColumn(name = "family_member_id")
  private FamilyMember familyMember;

  @ManyToOne(optional = false, fetch = FetchType.LAZY)
  @JoinColumn(name = "webinar_id", nullable = false)
  private Webinar webinar;

  @Column(name = "locked_until", nullable = false)
  private OffsetDateTime lockedUntil;

  protected WebinarActiveLock() {}

  public WebinarActiveLock(Person person, FamilyMember familyMember) {
    this.person = person;
    this.familyMember = familyMember;
  }

  public Long getId() { return id; }
  public Webinar getWebinar() { return webinar; }
  public void setWebinar(Webinar webinar) { this.webinar = webinar; }
  public OffsetDateTime getLockedUntil() { return lockedUntil; }
  public void setLockedUntil(OffsetDateTime lockedUntil) { this.lockedUntil = lockedUntil; }
}
```

- [ ] **Step 4: Write the repositories**

`WebinarRepository.java`:
```java
package com.acme.rsvp.repository;

import java.time.OffsetDateTime;
import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.acme.rsvp.model.Webinar;
import com.acme.rsvp.model.WebinarStatus;

public interface WebinarRepository extends JpaRepository<Webinar, Long> {
  List<Webinar> findAllByOrderByScheduledStartDesc();
  List<Webinar> findByStatusOrderByScheduledStartAsc(WebinarStatus status);
  Optional<Webinar> findByZoomMeetingIdAndScheduledStart(String zoomMeetingId, OffsetDateTime scheduledStart);
}
```

`FamilyMemberRepository.java`:
```java
package com.acme.rsvp.repository;

import java.util.List;

import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.acme.rsvp.model.FamilyMember;

public interface FamilyMemberRepository extends JpaRepository<FamilyMember, Long> {
  List<FamilyMember> findByHofIdOrderByFirstNameAscLastNameAsc(Long hofPersonId);
  boolean existsByItsNumber(String itsNumber);
  boolean existsByItsNumberAndIdNot(String itsNumber, Long id);
  long countByHofIdAndActiveTrue(Long hofPersonId);

  @Query("""
      SELECT f FROM FamilyMember f JOIN FETCH f.hof h
      WHERE f.active = true
        AND (LOWER(CONCAT(f.firstName, ' ', f.lastName)) LIKE LOWER(CONCAT('%', :search, '%'))
             OR f.itsNumber LIKE CONCAT(:search, '%'))
      ORDER BY f.firstName, f.lastName
      """)
  List<FamilyMember> searchActive(@Param("search") String search, Pageable pageable);
}
```

`WebinarSeatRepository.java`:
```java
package com.acme.rsvp.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.acme.rsvp.model.WebinarSeat;

public interface WebinarSeatRepository extends JpaRepository<WebinarSeat, Long> {

  @Query("""
      SELECT s FROM WebinarSeat s
      JOIN FETCH s.person
      LEFT JOIN FETCH s.familyMember
      WHERE s.webinar.id = :webinarId
      """)
  List<WebinarSeat> findByWebinarIdWithAttendees(@Param("webinarId") Long webinarId);

  Optional<WebinarSeat> findByWebinarIdAndPersonIdAndFamilyMemberIsNull(Long webinarId, Long personId);
  Optional<WebinarSeat> findByWebinarIdAndFamilyMemberId(Long webinarId, Long familyMemberId);
  long countByWebinarId(Long webinarId);
}
```

`WebinarJoinTokenRepository.java`:
```java
package com.acme.rsvp.repository;

import java.time.OffsetDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.acme.rsvp.model.WebinarJoinToken;

public interface WebinarJoinTokenRepository extends JpaRepository<WebinarJoinToken, UUID> {

  Optional<WebinarJoinToken> findByTokenHash(String tokenHash);

  List<WebinarJoinToken> findBySeatIdAndRevokedAtIsNull(Long seatId);

  @Query("SELECT t FROM WebinarJoinToken t WHERE t.revokedAt IS NULL AND t.seat.familyMember.id = :familyMemberId")
  List<WebinarJoinToken> findLiveByFamilyMemberId(@Param("familyMemberId") Long familyMemberId);

  /** Call inside a transaction. */
  default int revokeForSeat(Long seatId, OffsetDateTime now) {
    List<WebinarJoinToken> live = findBySeatIdAndRevokedAtIsNull(seatId);
    live.forEach(t -> t.setRevokedAt(now));
    return live.size();
  }

  /** Call inside a transaction. */
  default int revokeForFamilyMember(Long familyMemberId, OffsetDateTime now) {
    List<WebinarJoinToken> live = findLiveByFamilyMemberId(familyMemberId);
    live.forEach(t -> t.setRevokedAt(now));
    return live.size();
  }
}
```

Revocation loads the tokens and sets `revokedAt` on the entities rather than running a bulk `UPDATE`. A bulk update bypasses the persistence context, so a token already loaded in the same transaction would still look live.

`WebinarJoinLogRepository.java`:
```java
package com.acme.rsvp.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.acme.rsvp.model.WebinarJoinLog;

public interface WebinarJoinLogRepository extends JpaRepository<WebinarJoinLog, Long> {

  @Query("SELECT l FROM WebinarJoinLog l WHERE l.seat.webinar.id = :webinarId ORDER BY l.joinedAt ASC")
  List<WebinarJoinLog> findByWebinarId(@Param("webinarId") Long webinarId);

  boolean existsBySeatId(Long seatId);
}
```

`WebinarActiveLockRepository.java`:
```java
package com.acme.rsvp.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.acme.rsvp.model.WebinarActiveLock;

public interface WebinarActiveLockRepository extends JpaRepository<WebinarActiveLock, Long> {
  Optional<WebinarActiveLock> findByPersonIdAndFamilyMemberIsNull(Long personId);
  Optional<WebinarActiveLock> findByFamilyMemberId(Long familyMemberId);
}
```

Add to `PersonRepository.java` (inside the interface; add `import org.springframework.data.domain.Pageable;`):
```java
  // Active, non-expired people matching a name or ITS prefix. Not limited to HOFs.
  @Query("""
      SELECT p FROM Person p
      WHERE p.accountStatus = com.acme.rsvp.model.AccountStatus.ACTIVE
        AND (p.userType = com.acme.rsvp.model.UserType.REGISTERED
             OR p.accountExpiresAt IS NULL
             OR p.accountExpiresAt > :now)
        AND (LOWER(CONCAT(p.firstName, ' ', p.lastName)) LIKE LOWER(CONCAT('%', :search, '%'))
             OR p.itsNumber LIKE CONCAT(:search, '%'))
      ORDER BY p.firstName, p.lastName
      """)
  List<Person> searchActive(@Param("search") String search, @Param("now") Instant now, Pageable pageable);
```

- [ ] **Step 5: Extend `TestData.java`** — add these fields and methods (plus imports for `Webinar`, `WebinarAccessMode`, `WebinarStatus`, `FamilyMember`, `WebinarRepository`, `FamilyMemberRepository`):

```java
  @Autowired WebinarRepository webinars;
  @Autowired FamilyMemberRepository familyMembers;

  /** A published, one-hour webinar with a join URL. */
  public Webinar webinar(WebinarAccessMode mode, OffsetDateTime start) {
    Webinar w = new Webinar();
    w.setTitle("Test Webinar");
    w.setHostName("Host");
    w.setScheduledStart(start);
    w.setScheduledEnd(start.plusHours(1));
    w.setStatus(WebinarStatus.PUBLISHED);
    w.setAccessMode(mode);
    w.setJoinUrl("https://zoom.us/j/123?pwd=abc");
    return webinars.saveAndFlush(w);
  }

  public FamilyMember familyMember(Person hof) {
    FamilyMember fm = new FamilyMember();
    fm.setHof(hof);
    fm.setFirstName("Family");
    fm.setLastName("Member");
    fm.setItsNumber(nextIts());
    return familyMembers.saveAndFlush(fm);
  }
```

- [ ] **Step 6: Run the tests**

Run: `cd server && ./gradlew test --tests "*WebinarModelTest" --tests "*V37MigrationTest"`
Expected: PASS. A `SchemaManagementException` here means an entity column does not match V37; fix the entity, never the migration.

- [ ] **Step 7: Commit**

```bash
git add server/src/main/java/com/acme/rsvp/model server/src/main/java/com/acme/rsvp/repository server/src/test
git commit -m "feat: webinar, family member and seat entities with repositories"
```

---

## Task 4: Webinar CRUD service

**Files:**
- Create: `exception/NotFoundException.java`, `config/WebinarProperties.java`, `dto/WebinarDtos.java`, `service/WebinarService.java`
- Modify: `RsvpApplication.java`, `server/src/main/resources/application.yml`, `web/GlobalExceptionHandler.java`
- Test: `server/src/test/java/com/acme/rsvp/service/WebinarServiceTest.java`

**Interfaces:**
- Produces: `NotFoundException(String)` → HTTP 404.
- Produces: `WebinarProperties` record with `joinWindowBeforeMinutes()`, `joinWindowAfterMinutes()`, `displayZone()`.
- Produces: every record in `WebinarDtos` (Step 3). Later tasks use these names exactly.
- Produces: `WebinarService` — `create(SaveWebinarRequest) : WebinarSummary`, `update(Long, SaveWebinarRequest) : WebinarSummary`, `list() : List<WebinarSummary>`, `get(Long) : WebinarSummary`, `delete(Long)`, `require(Long) : Webinar`, `toSummary(Webinar) : WebinarSummary`, `listForMember(Long personId, OffsetDateTime now) : List<MemberWebinar>`.

- [ ] **Step 1: Write the failing test**

```java
package com.acme.rsvp.service;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

import java.time.OffsetDateTime;
import java.util.Arrays;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import com.acme.rsvp.dto.WebinarDtos.MemberWebinar;
import com.acme.rsvp.dto.WebinarDtos.SaveWebinarRequest;
import com.acme.rsvp.dto.WebinarDtos.WebinarSummary;
import com.acme.rsvp.exception.NotFoundException;
import com.acme.rsvp.model.Person;
import com.acme.rsvp.model.SeatSource;
import com.acme.rsvp.model.Webinar;
import com.acme.rsvp.model.WebinarAccessMode;
import com.acme.rsvp.model.WebinarSeat;
import com.acme.rsvp.repository.WebinarSeatRepository;
import com.acme.rsvp.support.PostgresIntegrationTest;
import com.acme.rsvp.support.TestData;

class WebinarServiceTest extends PostgresIntegrationTest {

  @Autowired WebinarService service;
  @Autowired WebinarSeatRepository seats;
  @Autowired TestData data;

  private SaveWebinarRequest req(String joinUrl) {
    OffsetDateTime start = OffsetDateTime.now().plusDays(2);
    return new SaveWebinarRequest("Majlis", "desc", "Host", start, start.plusHours(1),
        null, null, joinUrl, null, null);
  }

  @Test
  void createAppliesDefaultsAndNeverExposesJoinUrl() {
    WebinarSummary s = service.create(req("https://zoom.us/j/1"));
    assertThat(s.status()).isEqualTo("DRAFT");
    assertThat(s.accessMode()).isEqualTo("ASSIGNED");
    assertThat(s.joinWindowBeforeMin()).isEqualTo(10);
    assertThat(s.joinWindowAfterMin()).isEqualTo(15);
    assertThat(s.hasJoinUrl()).isTrue();
    assertThat(Arrays.stream(WebinarSummary.class.getRecordComponents()).map(c -> c.getName()))
        .doesNotContain("joinUrl");
  }

  @Test
  void blankJoinUrlOnUpdateKeepsStoredValue() {
    WebinarSummary s = service.create(req("https://zoom.us/j/1"));
    service.update(s.id(), req("  "));
    assertThat(service.require(s.id()).getJoinUrl()).isEqualTo("https://zoom.us/j/1");
  }

  @Test
  void rejectsBadInput() {
    OffsetDateTime start = OffsetDateTime.now().plusDays(2);
    assertThatThrownBy(() -> service.create(new SaveWebinarRequest(" ", null, null, start, start.plusHours(1),
        null, null, null, null, null))).isInstanceOf(IllegalArgumentException.class);
    assertThatThrownBy(() -> service.create(new SaveWebinarRequest("T", null, null, start, start,
        null, null, null, null, null))).isInstanceOf(IllegalArgumentException.class);
    assertThatThrownBy(() -> service.create(req("http://not-https"))).isInstanceOf(IllegalArgumentException.class);
    assertThatThrownBy(() -> service.require(-1L)).isInstanceOf(NotFoundException.class);
  }

  @Test
  void memberSeesOpenWebinarsAndOnesTheyHoldASeatFor() {
    Person p = data.person(false);
    OffsetDateTime soon = OffsetDateTime.now().plusDays(1);
    Webinar open = data.webinar(WebinarAccessMode.OPEN, soon);
    Webinar assignedWithSeat = data.webinar(WebinarAccessMode.ASSIGNED, soon);
    Webinar assignedNoSeat = data.webinar(WebinarAccessMode.ASSIGNED, soon);
    Webinar past = data.webinar(WebinarAccessMode.OPEN, OffsetDateTime.now().minusDays(3));
    seats.saveAndFlush(new WebinarSeat(assignedWithSeat, p, null, SeatSource.ASSIGNED));

    assertThat(service.listForMember(p.getId(), OffsetDateTime.now()).stream().map(MemberWebinar::id))
        .contains(open.getId(), assignedWithSeat.getId())
        .doesNotContain(assignedNoSeat.getId(), past.getId());
  }
}
```

- [ ] **Step 2: Run it to verify it fails**

Run: `cd server && ./gradlew test --tests "*WebinarServiceTest"`
Expected: FAIL — compilation errors (`WebinarService`, `WebinarDtos`, `NotFoundException` missing).

- [ ] **Step 3: Write the supporting types**

`exception/NotFoundException.java`:
```java
package com.acme.rsvp.exception;

public class NotFoundException extends RuntimeException {
  public NotFoundException(String message) { super(message); }
}
```

Add to `GlobalExceptionHandler.java` (import `com.acme.rsvp.exception.NotFoundException`):
```java
    @ExceptionHandler(NotFoundException.class)
    public ResponseEntity<Map<String, String>> handleNotFound(NotFoundException ex) {
        return ResponseEntity.status(HttpStatus.NOT_FOUND)
                .body(Map.of("error", ex.getMessage()));
    }
```

`config/WebinarProperties.java`:
```java
package com.acme.rsvp.config;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.context.properties.bind.DefaultValue;

@ConfigurationProperties(prefix = "app.webinar")
public record WebinarProperties(
    @DefaultValue("10") int joinWindowBeforeMinutes,
    @DefaultValue("15") int joinWindowAfterMinutes,
    @DefaultValue("America/New_York") String displayZone) {}
```

`RsvpApplication.java` — add the annotation and its import:
```java
import org.springframework.boot.context.properties.ConfigurationPropertiesScan;

@SpringBootApplication
@ConfigurationPropertiesScan
public class RsvpApplication {
```

`application.yml` — append under the existing `app:` key, at the same indent as `sendgrid:`:
```yaml
  webinar:
    join-window-before-minutes: ${WEBINAR_JOIN_WINDOW_BEFORE_MIN:10}
    join-window-after-minutes: ${WEBINAR_JOIN_WINDOW_AFTER_MIN:15}
    display-zone: ${WEBINAR_DISPLAY_ZONE:America/New_York}
```

`dto/WebinarDtos.java`:
```java
package com.acme.rsvp.dto;

import java.time.OffsetDateTime;
import java.util.List;

/** All request/response shapes for the webinar module. None of them carries the Zoom join URL. */
public final class WebinarDtos {
  private WebinarDtos() {}

  // ---- webinars ----
  public record SaveWebinarRequest(String title, String description, String hostName,
      OffsetDateTime scheduledStart, OffsetDateTime scheduledEnd, String status, String accessMode,
      String joinUrl, Integer joinWindowBeforeMin, Integer joinWindowAfterMin) {}

  public record WebinarSummary(Long id, String title, String description, String hostName,
      OffsetDateTime scheduledStart, OffsetDateTime scheduledEnd, String status, String accessMode,
      boolean managedByZoom, int joinWindowBeforeMin, int joinWindowAfterMin,
      boolean hasJoinUrl, long seatCount) {}

  public record MemberWebinar(Long id, String title, String hostName,
      OffsetDateTime scheduledStart, OffsetDateTime scheduledEnd, boolean joinOpen) {}

  // ---- family members ----
  public record SaveFamilyMemberRequest(Long hofPersonId, String firstName, String lastName,
      String itsNumber, Long webinarId) {}

  public record FamilyMemberDto(Long id, Long hofPersonId, String firstName, String lastName,
      String itsNumber, boolean active) {}

  public record SetActiveRequest(boolean active) {}

  public record HofDto(Long id, String firstName, String lastName, String itsNumber,
      long familyMemberCount) {}

  // ---- seats ----
  public record GiveSeatRequest(Long personId, Long familyMemberId) {}

  public record FamilySeatRow(Long familyMemberId, String itsNumber, String name, Long seatId) {}

  /** One head of family or member, their own seat (null if none), and their active family members. */
  public record FamilySeats(Long personId, String itsNumber, String name, boolean hof,
      Long ownSeatId, List<FamilySeatRow> family) {}

  /** A search hit: a person (familyMemberId null) or a saved family member. */
  public record AssignableRow(Long personId, Long familyMemberId, String itsNumber, String name,
      String hofName, boolean hof, boolean hasSeat) {}

  public record CopySeatsResult(int added, int skipped) {}

  // ---- links and invites ----
  public record LinkResponse(String link) {}

  public record InviteLink(String label, String url) {}

  public record InviteResult(int sent, List<String> skipped) {}

  public record MagicJoinInfo(String title, String hostName, OffsetDateTime scheduledStart,
      OffsetDateTime scheduledEnd, boolean joinOpen, String attendeeName, String attendeeIts) {}

  // ---- report ----
  public record AttendeeRow(String itsNumber, String name, String type, String hofName, String hofIts,
      boolean joined, OffsetDateTime firstJoinedAt, int launchCount) {}

  public record AttendanceReport(WebinarSummary webinar, int seatCount, int joinedCount,
      List<AttendeeRow> rows) {}

  // ---- zoom sync ----
  public record ZoomSyncRow(String zoomMeetingId, String topic, OffsetDateTime start,
      OffsetDateTime end, boolean alreadyImported) {}

  public record ZoomImportRequest(String kind, String zoomMeetingId, OffsetDateTime start,
      String accessMode) {}
}
```

- [ ] **Step 4: Write `service/WebinarService.java`**

```java
package com.acme.rsvp.service;

import java.time.OffsetDateTime;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.acme.rsvp.config.WebinarProperties;
import com.acme.rsvp.dto.WebinarDtos.MemberWebinar;
import com.acme.rsvp.dto.WebinarDtos.SaveWebinarRequest;
import com.acme.rsvp.dto.WebinarDtos.WebinarSummary;
import com.acme.rsvp.exception.NotFoundException;
import com.acme.rsvp.model.Webinar;
import com.acme.rsvp.model.WebinarAccessMode;
import com.acme.rsvp.model.WebinarStatus;
import com.acme.rsvp.repository.WebinarRepository;
import com.acme.rsvp.repository.WebinarSeatRepository;

@Service
public class WebinarService {

  private final WebinarRepository webinars;
  private final WebinarSeatRepository seats;
  private final WebinarProperties props;

  public WebinarService(WebinarRepository webinars, WebinarSeatRepository seats, WebinarProperties props) {
    this.webinars = webinars;
    this.seats = seats;
    this.props = props;
  }

  @Transactional
  public WebinarSummary create(SaveWebinarRequest req) {
    Webinar w = new Webinar();
    w.setJoinWindowBeforeMin(props.joinWindowBeforeMinutes());
    w.setJoinWindowAfterMin(props.joinWindowAfterMinutes());
    apply(w, req);
    return toSummary(webinars.save(w));
  }

  @Transactional
  public WebinarSummary update(Long id, SaveWebinarRequest req) {
    Webinar w = require(id);
    apply(w, req);
    return toSummary(w);
  }

  @Transactional(readOnly = true)
  public List<WebinarSummary> list() {
    return webinars.findAllByOrderByScheduledStartDesc().stream().map(this::toSummary).toList();
  }

  @Transactional(readOnly = true)
  public WebinarSummary get(Long id) {
    return toSummary(require(id));
  }

  @Transactional
  public void delete(Long id) {
    webinars.delete(require(id));
  }

  @Transactional(readOnly = true)
  public Webinar require(Long id) {
    return webinars.findById(id).orElseThrow(() -> new NotFoundException("Webinar not found"));
  }

  /** Published webinars whose join window has not closed, that are OPEN or where the person holds their own seat. */
  @Transactional(readOnly = true)
  public List<MemberWebinar> listForMember(Long personId, OffsetDateTime now) {
    return webinars.findByStatusOrderByScheduledStartAsc(WebinarStatus.PUBLISHED).stream()
        .filter(w -> !now.isAfter(w.joinWindowEnd()))
        .filter(w -> w.getAccessMode() == WebinarAccessMode.OPEN
            || seats.findByWebinarIdAndPersonIdAndFamilyMemberIsNull(w.getId(), personId).isPresent())
        .map(w -> new MemberWebinar(w.getId(), w.getTitle(), w.getHostName(),
            w.getScheduledStart(), w.getScheduledEnd(), w.isJoinOpen(now)))
        .toList();
  }

  public WebinarSummary toSummary(Webinar w) {
    long seatCount = w.getId() == null ? 0 : seats.countByWebinarId(w.getId());
    return new WebinarSummary(w.getId(), w.getTitle(), w.getDescription(), w.getHostName(),
        w.getScheduledStart(), w.getScheduledEnd(), w.getStatus().name(), w.getAccessMode().name(),
        w.isManagedByZoom(), w.getJoinWindowBeforeMin(), w.getJoinWindowAfterMin(),
        w.getJoinUrl() != null && !w.getJoinUrl().isBlank(), seatCount);
  }

  private void apply(Webinar w, SaveWebinarRequest req) {
    if (req.title() == null || req.title().isBlank()) {
      throw new IllegalArgumentException("Title is required");
    }
    if (req.scheduledStart() == null || req.scheduledEnd() == null) {
      throw new IllegalArgumentException("Start and end times are required");
    }
    if (!req.scheduledEnd().isAfter(req.scheduledStart())) {
      throw new IllegalArgumentException("End time must be after start time");
    }
    w.setTitle(req.title().trim());
    w.setDescription(req.description());
    w.setHostName(req.hostName());
    w.setScheduledStart(req.scheduledStart());
    w.setScheduledEnd(req.scheduledEnd());
    if (req.status() != null && !req.status().isBlank()) {
      w.setStatus(WebinarStatus.valueOf(req.status()));
    }
    if (req.accessMode() != null && !req.accessMode().isBlank()) {
      w.setAccessMode(WebinarAccessMode.valueOf(req.accessMode()));
    }
    if (req.joinWindowBeforeMin() != null) {
      if (req.joinWindowBeforeMin() < 0) throw new IllegalArgumentException("Join window cannot be negative");
      w.setJoinWindowBeforeMin(req.joinWindowBeforeMin());
    }
    if (req.joinWindowAfterMin() != null) {
      if (req.joinWindowAfterMin() < 0) throw new IllegalArgumentException("Join window cannot be negative");
      w.setJoinWindowAfterMin(req.joinWindowAfterMin());
    }
    // A blank join URL means "keep what is stored" so the edit form never needs to receive it.
    if (req.joinUrl() != null && !req.joinUrl().isBlank()) {
      String url = req.joinUrl().trim();
      if (!url.startsWith("https://")) {
        throw new IllegalArgumentException("Zoom link must start with https://");
      }
      w.setJoinUrl(url);
    }
  }
}
```

- [ ] **Step 5: Run the tests**

Run: `cd server && ./gradlew test --tests "*WebinarServiceTest"`
Expected: PASS (4 tests).

- [ ] **Step 6: Commit**

```bash
git add server/src/main server/src/test
git commit -m "feat: webinar CRUD service, DTOs and 404 mapping"
```

---

## Task 5: Family members

**Files:**
- Create: `service/FamilyMemberService.java`
- Modify: `service/AuthService.java` (in `register`), `service/AdminUserService.java` (in `createUser`)
- Test: `server/src/test/java/com/acme/rsvp/service/FamilyMemberServiceTest.java`

**Interfaces:**
- Consumes: `FamilyMemberRepository`, `PersonRepository`, `WebinarJoinTokenRepository.revokeForFamilyMember`.
- Produces: `FamilyMemberService` — `createEntity(Long hofPersonId, String firstName, String lastName, String itsNumber) : FamilyMember`, `create(SaveFamilyMemberRequest) : FamilyMemberDto`, `update(Long id, SaveFamilyMemberRequest) : FamilyMemberDto`, `setActive(Long id, boolean active) : FamilyMemberDto`, `listByHof(Long hofPersonId) : List<FamilyMemberDto>`, `searchHofs(String search) : List<HofDto>`, `toDto(FamilyMember) : FamilyMemberDto`.

- [ ] **Step 1: Write the failing test**

```java
package com.acme.rsvp.service;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import com.acme.rsvp.dto.AdminUserDtos.CreateUserRequest;
import com.acme.rsvp.dto.WebinarDtos.FamilyMemberDto;
import com.acme.rsvp.dto.WebinarDtos.HofDto;
import com.acme.rsvp.dto.WebinarDtos.SaveFamilyMemberRequest;
import com.acme.rsvp.model.Person;
import com.acme.rsvp.support.PostgresIntegrationTest;
import com.acme.rsvp.support.TestData;

class FamilyMemberServiceTest extends PostgresIntegrationTest {

  @Autowired FamilyMemberService service;
  @Autowired AdminUserService adminUsers;
  @Autowired TestData data;

  private SaveFamilyMemberRequest req(Person hof, String its) {
    return new SaveFamilyMemberRequest(hof.getId(), " Fatema ", "Kanchwala", its, null);
  }

  @Test
  void createsUnderAnHofAndTrimsNames() {
    Person hof = data.person(true);
    FamilyMemberDto dto = service.create(req(hof, TestData.nextIts()));
    assertThat(dto.firstName()).isEqualTo("Fatema");
    assertThat(dto.active()).isTrue();
    assertThat(service.listByHof(hof.getId())).hasSize(1);
  }

  @Test
  void rejectsNonHofOwner() {
    Person notHof = data.person(false);
    assertThatThrownBy(() -> service.create(req(notHof, TestData.nextIts())))
        .isInstanceOf(IllegalArgumentException.class).hasMessageContaining("head of family");
  }

  @Test
  void rejectsBadOrDuplicateIts() {
    Person hof = data.person(true);
    assertThatThrownBy(() -> service.create(req(hof, "1234567")))
        .isInstanceOf(IllegalArgumentException.class).hasMessageContaining("8 digits");
    assertThatThrownBy(() -> service.create(req(hof, "1234567a")))
        .isInstanceOf(IllegalArgumentException.class);

    String its = TestData.nextIts();
    service.create(req(hof, its));
    assertThatThrownBy(() -> service.create(req(hof, its)))
        .isInstanceOf(IllegalArgumentException.class).hasMessageContaining("already saved");
  }

  @Test
  void rejectsItsBelongingToAnExistingUser() {
    Person hof = data.person(true);
    Person other = data.person(false);
    assertThatThrownBy(() -> service.create(req(hof, other.getItsNumber())))
        .isInstanceOf(IllegalArgumentException.class).hasMessageContaining("existing user");
  }

  @Test
  void updateAllowsKeepingOwnIts() {
    Person hof = data.person(true);
    String its = TestData.nextIts();
    FamilyMemberDto dto = service.create(req(hof, its));
    FamilyMemberDto updated = service.update(dto.id(),
        new SaveFamilyMemberRequest(hof.getId(), "Fatima", "Kanchwala", its, null));
    assertThat(updated.firstName()).isEqualTo("Fatima");
  }

  @Test
  void deactivateKeepsTheRow() {
    Person hof = data.person(true);
    FamilyMemberDto dto = service.create(req(hof, TestData.nextIts()));
    assertThat(service.setActive(dto.id(), false).active()).isFalse();
    assertThat(service.listByHof(hof.getId())).hasSize(1);
  }

  @Test
  void adminUserCreationRejectsAFamilyMemberIts() {
    Person hof = data.person(true);
    String its = TestData.nextIts();
    service.create(req(hof, its));
    CreateUserRequest create = new CreateUserRequest(its, "New", "User", "new" + its + "@example.com",
        null, "password1", null, Set.of("USER"), UserType.REGISTERED, null, true);
    assertThatThrownBy(() -> adminUsers.createUser(create))
        .isInstanceOf(IllegalArgumentException.class).hasMessageContaining("family member");
  }

  @Test
  void searchHofsFindsByNameAndCountsFamily() {
    Person hof = data.person(true);
    service.create(req(hof, TestData.nextIts()));
    assertThat(service.searchHofs(hof.getLastName()).stream().filter(h -> h.id().equals(hof.getId())))
        .singleElement().extracting(HofDto::familyMemberCount).isEqualTo(1L);
    assertThat(service.searchHofs("x")).isEmpty(); // fewer than 2 characters
  }
}
```

Add these imports to the test: `java.util.Set` and `com.acme.rsvp.model.UserType`. `CreateUserRequest` is the existing record in `dto/AdminUserDtos.java` with components `(itsNumber, firstName, lastName, email, phone, password, pickupZoneId, roles, userType, accountExpiresAt, isHof)`.

- [ ] **Step 2: Run it to verify it fails**

Run: `cd server && ./gradlew test --tests "*FamilyMemberServiceTest"`
Expected: FAIL — `FamilyMemberService` does not exist.

- [ ] **Step 3: Write `service/FamilyMemberService.java`**

```java
package com.acme.rsvp.service;

import java.time.Instant;
import java.time.OffsetDateTime;
import java.util.List;
import java.util.regex.Pattern;

import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.acme.rsvp.dto.WebinarDtos.FamilyMemberDto;
import com.acme.rsvp.dto.WebinarDtos.HofDto;
import com.acme.rsvp.dto.WebinarDtos.SaveFamilyMemberRequest;
import com.acme.rsvp.exception.NotFoundException;
import com.acme.rsvp.model.FamilyMember;
import com.acme.rsvp.model.Person;
import com.acme.rsvp.repository.FamilyMemberRepository;
import com.acme.rsvp.repository.PersonRepository;
import com.acme.rsvp.repository.WebinarJoinTokenRepository;

@Service
public class FamilyMemberService {

  private static final Pattern ITS = Pattern.compile("\\d{8}");

  private final FamilyMemberRepository familyMembers;
  private final PersonRepository persons;
  private final WebinarJoinTokenRepository tokens;

  public FamilyMemberService(FamilyMemberRepository familyMembers, PersonRepository persons,
      WebinarJoinTokenRepository tokens) {
    this.familyMembers = familyMembers;
    this.persons = persons;
    this.tokens = tokens;
  }

  @Transactional
  public FamilyMember createEntity(Long hofPersonId, String firstName, String lastName, String itsNumber) {
    if (hofPersonId == null) throw new IllegalArgumentException("Head of family is required");
    Person hof = persons.findById(hofPersonId)
        .orElseThrow(() -> new IllegalArgumentException("Head of family not found"));
    if (!hof.isHof()) {
      throw new IllegalArgumentException("Family members can only be added under a head of family");
    }
    FamilyMember fm = new FamilyMember();
    fm.setHof(hof);
    fm.setFirstName(requireName(firstName, "First name"));
    fm.setLastName(requireName(lastName, "Last name"));
    fm.setItsNumber(validateIts(itsNumber, null));
    return familyMembers.save(fm);
  }

  @Transactional
  public FamilyMemberDto create(SaveFamilyMemberRequest req) {
    return toDto(createEntity(req.hofPersonId(), req.firstName(), req.lastName(), req.itsNumber()));
  }

  @Transactional
  public FamilyMemberDto update(Long id, SaveFamilyMemberRequest req) {
    FamilyMember fm = require(id);
    fm.setFirstName(requireName(req.firstName(), "First name"));
    fm.setLastName(requireName(req.lastName(), "Last name"));
    fm.setItsNumber(validateIts(req.itsNumber(), id));
    return toDto(fm);
  }

  /** Deactivating never deletes: past attendance reports keep the name. Live links stop working. */
  @Transactional
  public FamilyMemberDto setActive(Long id, boolean active) {
    FamilyMember fm = require(id);
    fm.setActive(active);
    if (!active) {
      tokens.revokeForFamilyMember(id, OffsetDateTime.now());
    }
    return toDto(fm);
  }

  @Transactional(readOnly = true)
  public List<FamilyMemberDto> listByHof(Long hofPersonId) {
    return familyMembers.findByHofIdOrderByFirstNameAscLastNameAsc(hofPersonId).stream()
        .map(this::toDto).toList();
  }

  /** Active heads of family matching a name or ITS prefix. Returns nothing for fewer than 2 characters. */
  @Transactional(readOnly = true)
  public List<HofDto> searchHofs(String search) {
    String s = search == null ? "" : search.trim();
    if (s.length() < 2) return List.of();
    return persons.searchActive(s, Instant.now(), PageRequest.of(0, 50)).stream()
        .filter(Person::isHof)
        .limit(20)
        .map(p -> new HofDto(p.getId(), p.getFirstName(), p.getLastName(), p.getItsNumber(),
            familyMembers.countByHofIdAndActiveTrue(p.getId())))
        .toList();
  }

  public FamilyMemberDto toDto(FamilyMember fm) {
    return new FamilyMemberDto(fm.getId(), fm.getHof().getId(), fm.getFirstName(), fm.getLastName(),
        fm.getItsNumber(), fm.isActive());
  }

  private FamilyMember require(Long id) {
    return familyMembers.findById(id).orElseThrow(() -> new NotFoundException("Family member not found"));
  }

  private static String requireName(String value, String label) {
    if (value == null || value.isBlank()) throw new IllegalArgumentException(label + " is required");
    return value.trim();
  }

  private String validateIts(String raw, Long selfId) {
    String its = raw == null ? "" : raw.trim();
    if (!ITS.matcher(its).matches()) {
      throw new IllegalArgumentException("ITS number must be exactly 8 digits");
    }
    if (persons.existsByItsNumber(its)) {
      throw new IllegalArgumentException(
          "ITS " + its + " belongs to an existing user. Give that user a seat directly instead.");
    }
    boolean taken = selfId == null
        ? familyMembers.existsByItsNumber(its)
        : familyMembers.existsByItsNumberAndIdNot(its, selfId);
    if (taken) {
      throw new IllegalArgumentException("ITS " + its + " is already saved as a family member");
    }
    return its;
  }
}
```

- [ ] **Step 4: Guard user creation in both places**

In `AdminUserService.java`, inject `FamilyMemberRepository` through the constructor, then in `createUser` add directly after the existing duplicate-ITS check:
```java
        if (familyMemberRepository.existsByItsNumber(request.itsNumber())) {
            throw new IllegalArgumentException("ITS number " + request.itsNumber()
                    + " is saved as a family member. Remove or change that family member first.");
        }
```

In `AuthService.java`, inject `FamilyMemberRepository` through the constructor, then in `register` add directly after the `User already exists` check:
```java
		if (familyMemberRepo.existsByItsNumber(req.itsNumber()))
			throw new IllegalArgumentException(
					"This ITS number is already on file as a family member. Please contact an administrator.");
```

Both classes use constructor injection already; add the parameter and field following the style of the existing ones.

- [ ] **Step 5: Run the tests**

Run: `cd server && ./gradlew test --tests "*FamilyMemberServiceTest"`
Expected: PASS (8 tests).

- [ ] **Step 6: Commit**

```bash
git add server/src/main server/src/test
git commit -m "feat: saved family members with ITS rules"
```

---

## Task 6: Seats

**Files:**
- Create: `service/WebinarSeatService.java`
- Test: `server/src/test/java/com/acme/rsvp/service/WebinarSeatServiceTest.java`

**Interfaces:**
- Consumes: `WebinarService.require`, `FamilyMemberService.createEntity` / `toDto`, the repositories from Task 3.
- Produces: `WebinarSeatService` —
  - `giveSeat(Long webinarId, Long personId, Long familyMemberId) : WebinarSeat` (`familyMemberId` null for the person's own seat)
  - `createFamilyMemberAndSeat(SaveFamilyMemberRequest req) : FamilyMemberDto` (uses `req.webinarId()`)
  - `removeSeat(Long webinarId, Long seatId)`
  - `listSeats(Long webinarId) : List<FamilySeats>`
  - `searchAssignable(Long webinarId, String search) : List<AssignableRow>`
  - `copyFrom(Long webinarId, Long otherWebinarId) : CopySeatsResult`
  - `ensureOwnSeat(Webinar w, Person p) : WebinarSeat` — existing own seat, or a new `OPEN_AUTO` seat on an `OPEN` webinar, or `null`.

- [ ] **Step 1: Write the failing test**

```java
package com.acme.rsvp.service;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

import java.time.OffsetDateTime;
import java.util.List;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import com.acme.rsvp.dto.WebinarDtos.AssignableRow;
import com.acme.rsvp.dto.WebinarDtos.CopySeatsResult;
import com.acme.rsvp.dto.WebinarDtos.FamilyMemberDto;
import com.acme.rsvp.dto.WebinarDtos.FamilySeats;
import com.acme.rsvp.dto.WebinarDtos.SaveFamilyMemberRequest;
import com.acme.rsvp.model.AccountStatus;
import com.acme.rsvp.model.FamilyMember;
import com.acme.rsvp.model.JoinSource;
import com.acme.rsvp.model.Person;
import com.acme.rsvp.model.SeatSource;
import com.acme.rsvp.model.Webinar;
import com.acme.rsvp.model.WebinarAccessMode;
import com.acme.rsvp.model.WebinarJoinLog;
import com.acme.rsvp.model.WebinarSeat;
import com.acme.rsvp.repository.WebinarJoinLogRepository;
import com.acme.rsvp.repository.WebinarSeatRepository;
import com.acme.rsvp.support.PostgresIntegrationTest;
import com.acme.rsvp.support.TestData;

class WebinarSeatServiceTest extends PostgresIntegrationTest {

  @Autowired WebinarSeatService service;
  @Autowired FamilyMemberService familyMemberService;
  @Autowired WebinarSeatRepository seats;
  @Autowired WebinarJoinLogRepository logs;
  @Autowired TestData data;

  private Webinar assigned() {
    return data.webinar(WebinarAccessMode.ASSIGNED, OffsetDateTime.now().plusDays(1));
  }

  @Test
  void familyMemberCanHoldASeatWhenTheHofHasNone() {
    Person hof = data.person(true);
    FamilyMember fm = data.familyMember(hof);
    Webinar w = assigned();

    service.giveSeat(w.getId(), hof.getId(), fm.getId());

    List<FamilySeats> rows = service.listSeats(w.getId());
    assertThat(rows).hasSize(1);
    assertThat(rows.get(0).personId()).isEqualTo(hof.getId());
    assertThat(rows.get(0).ownSeatId()).isNull();
    assertThat(rows.get(0).family()).singleElement()
        .satisfies(r -> assertThat(r.seatId()).isNotNull());
  }

  @Test
  void listSeatsShowsUnseatedActiveFamilyMembersOfSeatedFamilies() {
    Person hof = data.person(true);
    data.familyMember(hof);
    Webinar w = assigned();
    service.giveSeat(w.getId(), hof.getId(), null);

    FamilySeats row = service.listSeats(w.getId()).get(0);
    assertThat(row.ownSeatId()).isNotNull();
    assertThat(row.family()).singleElement().satisfies(r -> assertThat(r.seatId()).isNull());
  }

  @Test
  void rejectsDuplicates() {
    Person hof = data.person(true);
    FamilyMember fm = data.familyMember(hof);
    Webinar w = assigned();
    service.giveSeat(w.getId(), hof.getId(), null);
    service.giveSeat(w.getId(), hof.getId(), fm.getId());

    assertThatThrownBy(() -> service.giveSeat(w.getId(), hof.getId(), null))
        .isInstanceOf(IllegalStateException.class).hasMessageContaining("already has a seat");
    assertThatThrownBy(() -> service.giveSeat(w.getId(), hof.getId(), fm.getId()))
        .isInstanceOf(IllegalStateException.class).hasMessageContaining("already has a seat");
  }

  @Test
  void rejectsFamilyMemberOfAnotherHofDeactivatedMembersAndInactiveAccounts() {
    Person hof = data.person(true);
    Person otherHof = data.person(true);
    FamilyMember fm = data.familyMember(hof);
    Webinar w = assigned();

    assertThatThrownBy(() -> service.giveSeat(w.getId(), otherHof.getId(), fm.getId()))
        .isInstanceOf(IllegalStateException.class).hasMessageContaining("does not belong");

    familyMemberService.setActive(fm.getId(), false);
    assertThatThrownBy(() -> service.giveSeat(w.getId(), hof.getId(), fm.getId()))
        .isInstanceOf(IllegalStateException.class).hasMessageContaining("deactivated");

    FamilyMember fm2 = data.familyMember(hof);
    hof.setAccountStatus(AccountStatus.DISABLED);
    assertThatThrownBy(() -> service.giveSeat(w.getId(), hof.getId(), fm2.getId()))
        .isInstanceOf(IllegalStateException.class).hasMessageContaining("not active");
  }

  @Test
  void removeSeatIsRefusedOnceTheAttendeeHasJoined() {
    Person p = data.person(false);
    Webinar w = assigned();
    WebinarSeat removable = service.giveSeat(w.getId(), p.getId(), null);
    service.removeSeat(w.getId(), removable.getId());
    assertThat(seats.countByWebinarId(w.getId())).isZero();

    WebinarSeat joined = service.giveSeat(w.getId(), p.getId(), null);
    logs.saveAndFlush(new WebinarJoinLog(joined, OffsetDateTime.now(), JoinSource.PORTAL));
    assertThatThrownBy(() -> service.removeSeat(w.getId(), joined.getId()))
        .isInstanceOf(IllegalStateException.class).hasMessageContaining("already joined");
  }

  @Test
  void copyFromSeatsEligibleAttendeesAndSkipsTheRest() {
    Person hof = data.person(true);
    FamilyMember keep = data.familyMember(hof);
    FamilyMember gone = data.familyMember(hof);
    Webinar previous = assigned();
    service.giveSeat(previous.getId(), hof.getId(), null);
    service.giveSeat(previous.getId(), hof.getId(), keep.getId());
    service.giveSeat(previous.getId(), hof.getId(), gone.getId());
    familyMemberService.setActive(gone.getId(), false);

    Webinar next = assigned();
    CopySeatsResult result = service.copyFrom(next.getId(), previous.getId());

    assertThat(result.added()).isEqualTo(2);
    assertThat(result.skipped()).isEqualTo(1);
    assertThat(service.copyFrom(next.getId(), previous.getId()).added()).isZero();
  }

  @Test
  void ensureOwnSeatAutoCreatesOnlyOnOpenWebinars() {
    Person p = data.person(false);
    Webinar open = data.webinar(WebinarAccessMode.OPEN, OffsetDateTime.now().plusDays(1));
    WebinarSeat first = service.ensureOwnSeat(open, p);
    assertThat(first.getSource()).isEqualTo(SeatSource.OPEN_AUTO);
    assertThat(service.ensureOwnSeat(open, p).getId()).isEqualTo(first.getId());
    assertThat(service.ensureOwnSeat(assigned(), p)).isNull();
  }

  @Test
  void createFamilyMemberAndSeatDoesBothInOneStep() {
    Person hof = data.person(true);
    Webinar w = assigned();
    FamilyMemberDto dto = service.createFamilyMemberAndSeat(
        new SaveFamilyMemberRequest(hof.getId(), "Husain", "Kanchwala", TestData.nextIts(), w.getId()));
    assertThat(seats.findByWebinarIdAndFamilyMemberId(w.getId(), dto.id())).isPresent();
  }

  @Test
  void searchFindsPeopleAndFamilyMembers() {
    Person hof = data.person(true);
    FamilyMember fm = data.familyMember(hof);
    Webinar w = assigned();
    service.giveSeat(w.getId(), hof.getId(), null);

    List<AssignableRow> byPerson = service.searchAssignable(w.getId(), hof.getItsNumber());
    assertThat(byPerson).anySatisfy(r -> {
      assertThat(r.personId()).isEqualTo(hof.getId());
      assertThat(r.familyMemberId()).isNull();
      assertThat(r.hasSeat()).isTrue();
    });
    List<AssignableRow> byFamily = service.searchAssignable(w.getId(), fm.getItsNumber());
    assertThat(byFamily).anySatisfy(r -> {
      assertThat(r.familyMemberId()).isEqualTo(fm.getId());
      assertThat(r.hasSeat()).isFalse();
    });
    assertThat(service.searchAssignable(w.getId(), "9")).isEmpty();
  }
}
```

- [ ] **Step 2: Run it to verify it fails**

Run: `cd server && ./gradlew test --tests "*WebinarSeatServiceTest"`
Expected: FAIL — `WebinarSeatService` does not exist.

- [ ] **Step 3: Write `service/WebinarSeatService.java`**

```java
package com.acme.rsvp.service;

import java.time.Instant;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.acme.rsvp.dto.WebinarDtos.AssignableRow;
import com.acme.rsvp.dto.WebinarDtos.CopySeatsResult;
import com.acme.rsvp.dto.WebinarDtos.FamilyMemberDto;
import com.acme.rsvp.dto.WebinarDtos.FamilySeatRow;
import com.acme.rsvp.dto.WebinarDtos.FamilySeats;
import com.acme.rsvp.dto.WebinarDtos.SaveFamilyMemberRequest;
import com.acme.rsvp.exception.NotFoundException;
import com.acme.rsvp.model.AccountStatus;
import com.acme.rsvp.model.FamilyMember;
import com.acme.rsvp.model.Person;
import com.acme.rsvp.model.SeatSource;
import com.acme.rsvp.model.Webinar;
import com.acme.rsvp.model.WebinarAccessMode;
import com.acme.rsvp.model.WebinarSeat;
import com.acme.rsvp.repository.FamilyMemberRepository;
import com.acme.rsvp.repository.PersonRepository;
import com.acme.rsvp.repository.WebinarJoinLogRepository;
import com.acme.rsvp.repository.WebinarSeatRepository;

@Service
public class WebinarSeatService {

  private final WebinarSeatRepository seats;
  private final WebinarService webinarService;
  private final PersonRepository persons;
  private final FamilyMemberRepository familyMembers;
  private final FamilyMemberService familyMemberService;
  private final WebinarJoinLogRepository logs;

  public WebinarSeatService(WebinarSeatRepository seats, WebinarService webinarService,
      PersonRepository persons, FamilyMemberRepository familyMembers,
      FamilyMemberService familyMemberService, WebinarJoinLogRepository logs) {
    this.seats = seats;
    this.webinarService = webinarService;
    this.persons = persons;
    this.familyMembers = familyMembers;
    this.familyMemberService = familyMemberService;
    this.logs = logs;
  }

  @Transactional
  public WebinarSeat giveSeat(Long webinarId, Long personId, Long familyMemberId) {
    Webinar w = webinarService.require(webinarId);
    if (personId == null) throw new IllegalArgumentException("Person is required");
    Person p = persons.findById(personId).orElseThrow(() -> new IllegalArgumentException("Person not found"));
    FamilyMember fm = familyMemberId == null ? null : familyMembers.findById(familyMemberId)
        .orElseThrow(() -> new IllegalArgumentException("Family member not found"));
    String problem = problem(webinarId, p, fm);
    if (problem != null) throw new IllegalStateException(problem);
    try {
      return seats.saveAndFlush(new WebinarSeat(w, p, fm, SeatSource.ASSIGNED));
    } catch (DataIntegrityViolationException e) {
      // Two coordinators seating the same attendee at once: report it as a rule violation, not a 403/500.
      throw new IllegalStateException("This attendee already has a seat");
    }
  }

  @Transactional
  public FamilyMemberDto createFamilyMemberAndSeat(SaveFamilyMemberRequest req) {
    FamilyMember fm = familyMemberService.createEntity(
        req.hofPersonId(), req.firstName(), req.lastName(), req.itsNumber());
    giveSeat(req.webinarId(), req.hofPersonId(), fm.getId());
    return familyMemberService.toDto(fm);
  }

  @Transactional
  public void removeSeat(Long webinarId, Long seatId) {
    WebinarSeat seat = seats.findById(seatId)
        .filter(s -> s.getWebinar().getId().equals(webinarId))
        .orElseThrow(() -> new NotFoundException("Seat not found"));
    if (logs.existsBySeatId(seatId)) {
      // Deleting the seat would delete its join logs and erase the attendance record.
      throw new IllegalStateException(seat.attendeeName() + " has already joined; the seat cannot be removed");
    }
    seats.delete(seat); // join tokens go with it (ON DELETE CASCADE), so its link stops working
    seats.flush();
  }

  @Transactional(readOnly = true)
  public List<FamilySeats> listSeats(Long webinarId) {
    webinarService.require(webinarId);
    Map<Long, Person> people = new LinkedHashMap<>();
    Map<Long, Long> ownSeat = new HashMap<>();
    Map<Long, Long> familySeat = new HashMap<>();
    for (WebinarSeat s : seats.findByWebinarIdWithAttendees(webinarId)) {
      people.putIfAbsent(s.getPerson().getId(), s.getPerson());
      if (s.isFamilySeat()) {
        familySeat.put(s.getFamilyMember().getId(), s.getId());
      } else {
        ownSeat.put(s.getPerson().getId(), s.getId());
      }
    }
    return people.values().stream()
        .sorted(Comparator.comparing((Person p) -> p.getFirstName() + " " + p.getLastName(),
            String.CASE_INSENSITIVE_ORDER))
        .map(p -> new FamilySeats(p.getId(), p.getItsNumber(), p.getFirstName() + " " + p.getLastName(),
            p.isHof(), ownSeat.get(p.getId()),
            familyMembers.findByHofIdOrderByFirstNameAscLastNameAsc(p.getId()).stream()
                .filter(fm -> fm.isActive() || familySeat.containsKey(fm.getId()))
                .map(fm -> new FamilySeatRow(fm.getId(), fm.getItsNumber(), fm.fullName(),
                    familySeat.get(fm.getId())))
                .toList()))
        .toList();
  }

  /** People and saved family members matching a name or ITS prefix. Nothing for fewer than 2 characters. */
  @Transactional(readOnly = true)
  public List<AssignableRow> searchAssignable(Long webinarId, String search) {
    String s = search == null ? "" : search.trim();
    if (s.length() < 2) return List.of();
    List<AssignableRow> rows = new ArrayList<>();
    for (Person p : persons.searchActive(s, Instant.now(), PageRequest.of(0, 20))) {
      rows.add(new AssignableRow(p.getId(), null, p.getItsNumber(),
          p.getFirstName() + " " + p.getLastName(), null, p.isHof(),
          seats.findByWebinarIdAndPersonIdAndFamilyMemberIsNull(webinarId, p.getId()).isPresent()));
    }
    for (FamilyMember fm : familyMembers.searchActive(s, PageRequest.of(0, 20))) {
      Person hof = fm.getHof();
      rows.add(new AssignableRow(hof.getId(), fm.getId(), fm.getItsNumber(), fm.fullName(),
          hof.getFirstName() + " " + hof.getLastName(), false,
          seats.findByWebinarIdAndFamilyMemberId(webinarId, fm.getId()).isPresent()));
    }
    return rows;
  }

  @Transactional
  public CopySeatsResult copyFrom(Long webinarId, Long otherWebinarId) {
    if (webinarId.equals(otherWebinarId)) {
      throw new IllegalArgumentException("Choose a different webinar to copy from");
    }
    Webinar w = webinarService.require(webinarId);
    webinarService.require(otherWebinarId);
    int added = 0;
    int skipped = 0;
    for (WebinarSeat other : seats.findByWebinarIdWithAttendees(otherWebinarId)) {
      if (problem(webinarId, other.getPerson(), other.getFamilyMember()) == null) {
        seats.save(new WebinarSeat(w, other.getPerson(), other.getFamilyMember(), SeatSource.ASSIGNED));
        added++;
      } else {
        skipped++;
      }
    }
    seats.flush();
    return new CopySeatsResult(added, skipped);
  }

  /** The person's own seat; created on first use for OPEN webinars; null when they have no access. */
  @Transactional
  public WebinarSeat ensureOwnSeat(Webinar w, Person p) {
    return seats.findByWebinarIdAndPersonIdAndFamilyMemberIsNull(w.getId(), p.getId())
        .orElseGet(() -> w.getAccessMode() == WebinarAccessMode.OPEN
            ? seats.saveAndFlush(new WebinarSeat(w, p, null, SeatSource.OPEN_AUTO))
            : null);
  }

  /** Why this attendee cannot be given a seat, or null if they can. A family seat never needs an HOF seat. */
  private String problem(Long webinarId, Person p, FamilyMember fm) {
    String who = fm != null ? fm.fullName() : p.getFirstName() + " " + p.getLastName();
    if (fm != null && !fm.getHof().getId().equals(p.getId())) {
      return who + " does not belong to this head of family";
    }
    if (p.getAccountStatus() != AccountStatus.ACTIVE || p.isExpired()) {
      return (fm != null ? "The head of family's account" : who + "'s account") + " is not active";
    }
    if (fm != null) {
      if (!fm.isActive()) return who + " is deactivated";
      if (seats.findByWebinarIdAndFamilyMemberId(webinarId, fm.getId()).isPresent()) {
        return who + " already has a seat";
      }
    } else if (seats.findByWebinarIdAndPersonIdAndFamilyMemberIsNull(webinarId, p.getId()).isPresent()) {
      return who + " already has a seat";
    }
    return null;
  }
}
```

- [ ] **Step 4: Run the tests**

Run: `cd server && ./gradlew test --tests "*WebinarSeatServiceTest"`
Expected: PASS (9 tests).

- [ ] **Step 5: Commit**

```bash
git add server/src/main/java/com/acme/rsvp/service/WebinarSeatService.java server/src/test
git commit -m "feat: webinar seats for members and family members"
```

---

## Task 7: Tracked launch

This is the security-critical path: it decides whether to hand out the Zoom URL.

**Files:**
- Create: `security/TokenHasher.java`, `service/WebinarLaunchService.java`
- Test: `server/src/test/java/com/acme/rsvp/service/WebinarLaunchServiceTest.java`

**Interfaces:**
- Consumes: `WebinarSeatService.ensureOwnSeat`, repositories from Task 3.
- Produces: `TokenHasher.randomToken() : String` (base64url, 43 chars), `TokenHasher.sha256Hex(String) : String`.
- Produces: `WebinarLaunchService` —
  - `launchForMember(Long webinarId, Long personId, OffsetDateTime now) : String` (Zoom URL)
  - `launchForToken(String rawToken, OffsetDateTime now) : String`
  - `resolveToken(String rawToken, OffsetDateTime now) : WebinarJoinToken` — throws `NotFoundException` if unknown, revoked, or the webinar's join window has closed
  - `static appendDisplayName(String joinUrl, String displayName) : String`
- A token's validity end is the webinar's **current** `joinWindowEnd()`, not the stored `expires_at`, so rescheduling a webinar does not strand or extend links. `expires_at` is recorded at issue time for audit only.

- [ ] **Step 1: Write the failing test**

```java
package com.acme.rsvp.service;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

import java.time.OffsetDateTime;
import java.util.UUID;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import com.acme.rsvp.exception.NotFoundException;
import com.acme.rsvp.model.AccountStatus;
import com.acme.rsvp.model.FamilyMember;
import com.acme.rsvp.model.JoinSource;
import com.acme.rsvp.model.Person;
import com.acme.rsvp.model.Webinar;
import com.acme.rsvp.model.WebinarAccessMode;
import com.acme.rsvp.model.WebinarJoinToken;
import com.acme.rsvp.model.WebinarSeat;
import com.acme.rsvp.model.WebinarStatus;
import com.acme.rsvp.repository.WebinarJoinLogRepository;
import com.acme.rsvp.repository.WebinarJoinTokenRepository;
import com.acme.rsvp.security.TokenHasher;
import com.acme.rsvp.support.PostgresIntegrationTest;
import com.acme.rsvp.support.TestData;

class WebinarLaunchServiceTest extends PostgresIntegrationTest {

  @Autowired WebinarLaunchService launch;
  @Autowired WebinarSeatService seatService;
  @Autowired WebinarJoinTokenRepository tokens;
  @Autowired WebinarJoinLogRepository logs;
  @Autowired TestData data;

  private final OffsetDateTime now = OffsetDateTime.now();

  /** A webinar whose join window is open right now. */
  private Webinar live(WebinarAccessMode mode) {
    return data.webinar(mode, now.plusMinutes(5));
  }

  private String tokenFor(WebinarSeat seat) {
    String raw = TokenHasher.randomToken();
    tokens.saveAndFlush(new WebinarJoinToken(UUID.randomUUID(), seat, TokenHasher.sha256Hex(raw),
        now, seat.getWebinar().joinWindowEnd()));
    return raw;
  }

  @Test
  void appendDisplayNameReplacesExistingUnameAndKeepsOtherParams() {
    String url = WebinarLaunchService.appendDisplayName(
        "https://zoom.us/j/123?pwd=a%2Bb&uname=old#frag", "30702040 Fatema Kanchwala");
    assertThat(url).isEqualTo("https://zoom.us/j/123?pwd=a%2Bb&uname=30702040%20Fatema%20Kanchwala#frag");
    assertThat(WebinarLaunchService.appendDisplayName("https://zoom.us/j/123", "1 A B"))
        .isEqualTo("https://zoom.us/j/123?uname=1%20A%20B");
  }

  @Test
  void tokenHasherProducesStableHashAndRandomTokens() {
    assertThat(TokenHasher.sha256Hex("abc"))
        .isEqualTo("ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad");
    assertThat(TokenHasher.randomToken()).hasSize(43).isNotEqualTo(TokenHasher.randomToken());
  }

  @Test
  void memberOnOpenWebinarGetsASeatALogAndTheirNameInTheUrl() {
    Person p = data.person(false);
    Webinar w = live(WebinarAccessMode.OPEN);
    String url = launch.launchForMember(w.getId(), p.getId(), now);
    assertThat(url).startsWith("https://zoom.us/j/123?pwd=abc&uname=" + p.getItsNumber() + "%20");
    assertThat(logs.findByWebinarId(w.getId())).singleElement()
        .satisfies(l -> assertThat(l.getSource()).isEqualTo(JoinSource.PORTAL));
  }

  @Test
  void memberWithoutASeatOnAssignedWebinarIsRefused() {
    Person p = data.person(false);
    Webinar w = live(WebinarAccessMode.ASSIGNED);
    assertThatThrownBy(() -> launch.launchForMember(w.getId(), p.getId(), now))
        .isInstanceOf(IllegalStateException.class).hasMessageContaining("do not have access");
  }

  @Test
  void refusesOutsideTheWindowAndWhenNotPublished() {
    Person p = data.person(false);
    Webinar future = data.webinar(WebinarAccessMode.OPEN, now.plusDays(1));
    assertThatThrownBy(() -> launch.launchForMember(future.getId(), p.getId(), now))
        .isInstanceOf(IllegalStateException.class).hasMessageContaining("not open for joining yet");

    Webinar draft = live(WebinarAccessMode.OPEN);
    draft.setStatus(WebinarStatus.DRAFT);
    assertThatThrownBy(() -> launch.launchForMember(draft.getId(), p.getId(), now))
        .isInstanceOf(IllegalStateException.class).hasMessageContaining("not available");

    Webinar noLink = live(WebinarAccessMode.OPEN);
    noLink.setJoinUrl(null);
    assertThatThrownBy(() -> launch.launchForMember(noLink.getId(), p.getId(), now))
        .isInstanceOf(IllegalStateException.class).hasMessageContaining("no Zoom link");
  }

  @Test
  void familyLinkJoinsAsTheFamilyMemberAndCountsUse() {
    Person hof = data.person(true);
    FamilyMember fm = data.familyMember(hof);
    Webinar w = live(WebinarAccessMode.ASSIGNED);
    WebinarSeat seat = seatService.giveSeat(w.getId(), hof.getId(), fm.getId());
    String raw = tokenFor(seat);

    String url = launch.launchForToken(raw, now);

    assertThat(url).contains("uname=" + fm.getItsNumber() + "%20Family%20Member");
    WebinarJoinToken t = tokens.findByTokenHash(TokenHasher.sha256Hex(raw)).orElseThrow();
    assertThat(t.getUseCount()).isEqualTo(1);
    assertThat(logs.findByWebinarId(w.getId())).singleElement()
        .satisfies(l -> assertThat(l.getSource()).isEqualTo(JoinSource.MAGIC_LINK));
  }

  @Test
  void unknownRevokedAndClosedWindowTokensAreNotFound() {
    Person p = data.person(false);
    Webinar w = live(WebinarAccessMode.ASSIGNED);
    WebinarSeat seat = seatService.giveSeat(w.getId(), p.getId(), null);
    String raw = tokenFor(seat);

    assertThatThrownBy(() -> launch.resolveToken("garbage", now)).isInstanceOf(NotFoundException.class);
    assertThatThrownBy(() -> launch.resolveToken(raw, w.joinWindowEnd().plusSeconds(1)))
        .isInstanceOf(NotFoundException.class);

    tokens.revokeForSeat(seat.getId(), now);
    assertThatThrownBy(() -> launch.launchForToken(raw, now)).isInstanceOf(NotFoundException.class);
  }

  @Test
  void disabledHofBlocksTheFamilySeatAndDeactivatedMemberIsBlocked() {
    Person hof = data.person(true);
    FamilyMember fm = data.familyMember(hof);
    Webinar w = live(WebinarAccessMode.ASSIGNED);
    WebinarSeat seat = seatService.giveSeat(w.getId(), hof.getId(), fm.getId());
    String raw = tokenFor(seat);

    fm.setActive(false);
    assertThatThrownBy(() -> launch.launchForToken(raw, now))
        .isInstanceOf(IllegalStateException.class).hasMessageContaining("no longer active");

    fm.setActive(true);
    hof.setAccountStatus(AccountStatus.DISABLED);
    assertThatThrownBy(() -> launch.launchForToken(raw, now))
        .isInstanceOf(IllegalStateException.class).hasMessageContaining("account is not active");
  }

  @Test
  void oneWebinarAtATimePerAttendeeButFamilyMembersAreIndependent() {
    Person hof = data.person(true);
    FamilyMember fm = data.familyMember(hof);
    Webinar a = live(WebinarAccessMode.OPEN);
    Webinar b = live(WebinarAccessMode.OPEN);
    WebinarSeat familyOnB = seatService.giveSeat(b.getId(), hof.getId(), fm.getId());

    launch.launchForMember(a.getId(), hof.getId(), now);
    launch.launchForMember(a.getId(), hof.getId(), now.plusMinutes(1)); // rejoin same webinar is fine

    assertThatThrownBy(() -> launch.launchForMember(b.getId(), hof.getId(), now))
        .isInstanceOf(IllegalStateException.class).hasMessageContaining("another webinar");

    // The family member is a different attendee and is not blocked by the HOF's lock.
    assertThat(launch.launchForToken(tokenFor(familyOnB), now)).contains("uname=");
    assertThat(logs.findByWebinarId(a.getId())).hasSize(2);
  }
}
```

- [ ] **Step 2: Run it to verify it fails**

Run: `cd server && ./gradlew test --tests "*WebinarLaunchServiceTest"`
Expected: FAIL — `TokenHasher` and `WebinarLaunchService` do not exist.

- [ ] **Step 3: Write `security/TokenHasher.java`**

```java
package com.acme.rsvp.security;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;
import java.util.HexFormat;

public final class TokenHasher {
  private static final SecureRandom RANDOM = new SecureRandom();

  private TokenHasher() {}

  /** 256 random bits, base64url without padding (43 characters). */
  public static String randomToken() {
    byte[] bytes = new byte[32];
    RANDOM.nextBytes(bytes);
    return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
  }

  public static String sha256Hex(String value) {
    try {
      MessageDigest digest = MessageDigest.getInstance("SHA-256");
      return HexFormat.of().formatHex(digest.digest(value.getBytes(StandardCharsets.UTF_8)));
    } catch (NoSuchAlgorithmException e) {
      throw new IllegalStateException("SHA-256 unavailable", e);
    }
  }
}
```

- [ ] **Step 4: Write `service/WebinarLaunchService.java`**

```java
package com.acme.rsvp.service;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.acme.rsvp.exception.NotFoundException;
import com.acme.rsvp.model.AccountStatus;
import com.acme.rsvp.model.FamilyMember;
import com.acme.rsvp.model.JoinSource;
import com.acme.rsvp.model.Person;
import com.acme.rsvp.model.Webinar;
import com.acme.rsvp.model.WebinarActiveLock;
import com.acme.rsvp.model.WebinarJoinLog;
import com.acme.rsvp.model.WebinarJoinToken;
import com.acme.rsvp.model.WebinarSeat;
import com.acme.rsvp.model.WebinarStatus;
import com.acme.rsvp.repository.PersonRepository;
import com.acme.rsvp.repository.WebinarActiveLockRepository;
import com.acme.rsvp.repository.WebinarJoinLogRepository;
import com.acme.rsvp.repository.WebinarJoinTokenRepository;
import com.acme.rsvp.repository.WebinarRepository;
import com.acme.rsvp.security.TokenHasher;

/**
 * The only code that reads Webinar.joinUrl for an attendee. Every path to Zoom goes through
 * launchSeat, which re-checks the account, the window and the one-webinar-at-a-time rule.
 */
@Service
public class WebinarLaunchService {

  private static final String INVALID_LINK = "This link is invalid or has expired";

  private final WebinarRepository webinars;
  private final PersonRepository persons;
  private final WebinarSeatService seatService;
  private final WebinarJoinTokenRepository tokens;
  private final WebinarJoinLogRepository logs;
  private final WebinarActiveLockRepository locks;

  public WebinarLaunchService(WebinarRepository webinars, PersonRepository persons,
      WebinarSeatService seatService, WebinarJoinTokenRepository tokens,
      WebinarJoinLogRepository logs, WebinarActiveLockRepository locks) {
    this.webinars = webinars;
    this.persons = persons;
    this.seatService = seatService;
    this.tokens = tokens;
    this.logs = logs;
    this.locks = locks;
  }

  @Transactional
  public String launchForMember(Long webinarId, Long personId, OffsetDateTime now) {
    Webinar w = webinars.findById(webinarId).orElseThrow(() -> new NotFoundException("Webinar not found"));
    Person p = persons.findById(personId).orElseThrow(() -> new NotFoundException("Person not found"));
    if (w.getStatus() != WebinarStatus.PUBLISHED) {
      throw new IllegalStateException("This webinar is not available.");
    }
    WebinarSeat seat = seatService.ensureOwnSeat(w, p);
    if (seat == null) {
      throw new IllegalStateException("You do not have access to this webinar.");
    }
    return launchSeat(seat, JoinSource.PORTAL, now);
  }

  @Transactional
  public String launchForToken(String rawToken, OffsetDateTime now) {
    WebinarJoinToken token = resolveToken(rawToken, now);
    String url = launchSeat(token.getSeat(), JoinSource.MAGIC_LINK, now);
    token.setUseCount(token.getUseCount() + 1);
    token.setLastUsedAt(now);
    return url;
  }

  @Transactional(readOnly = true)
  public WebinarJoinToken resolveToken(String rawToken, OffsetDateTime now) {
    if (rawToken == null || rawToken.isBlank()) throw new NotFoundException(INVALID_LINK);
    WebinarJoinToken token = tokens.findByTokenHash(TokenHasher.sha256Hex(rawToken))
        .orElseThrow(() -> new NotFoundException(INVALID_LINK));
    if (token.getRevokedAt() != null || now.isAfter(token.getSeat().getWebinar().joinWindowEnd())) {
      throw new NotFoundException(INVALID_LINK);
    }
    return token;
  }

  private String launchSeat(WebinarSeat seat, JoinSource source, OffsetDateTime now) {
    Webinar w = seat.getWebinar();
    Person p = seat.getPerson();
    FamilyMember fm = seat.getFamilyMember();

    if (p.getAccountStatus() != AccountStatus.ACTIVE || p.isExpired()) {
      throw new IllegalStateException("This account is not active. Please contact an administrator.");
    }
    if (fm != null && !fm.isActive()) {
      throw new IllegalStateException("This seat is no longer active.");
    }
    if (w.getStatus() != WebinarStatus.PUBLISHED) {
      throw new IllegalStateException("This webinar is not available.");
    }
    if (!w.isJoinOpen(now)) {
      throw new IllegalStateException(now.isBefore(w.joinWindowStart())
          ? "This webinar is not open for joining yet."
          : "This webinar has ended.");
    }
    if (w.getJoinUrl() == null || w.getJoinUrl().isBlank()) {
      throw new IllegalStateException("This webinar has no Zoom link yet. Please contact the coordinator.");
    }

    WebinarActiveLock lock = (fm == null
        ? locks.findByPersonIdAndFamilyMemberIsNull(p.getId())
        : locks.findByFamilyMemberId(fm.getId())).orElse(null);
    if (lock != null && lock.getLockedUntil().isAfter(now)
        && !lock.getWebinar().getId().equals(w.getId())) {
      throw new IllegalStateException("You are already joined to another webinar.");
    }
    if (lock == null) lock = new WebinarActiveLock(p, fm);
    lock.setWebinar(w);
    lock.setLockedUntil(w.joinWindowEnd());
    locks.save(lock);

    logs.save(new WebinarJoinLog(seat, now, source));
    return appendDisplayName(w.getJoinUrl(), seat.displayName());
  }

  /**
   * Sets the uname query parameter, replacing any existing one and leaving every other parameter
   * byte-for-byte as stored (the Zoom pwd value must not be re-encoded).
   */
  public static String appendDisplayName(String joinUrl, String displayName) {
    String fragment = "";
    String base = joinUrl;
    int hash = base.indexOf('#');
    if (hash >= 0) {
      fragment = base.substring(hash);
      base = base.substring(0, hash);
    }
    String path = base;
    String query = "";
    int q = base.indexOf('?');
    if (q >= 0) {
      path = base.substring(0, q);
      query = base.substring(q + 1);
    }
    List<String> kept = new ArrayList<>();
    for (String part : query.split("&")) {
      if (part.isEmpty() || part.equals("uname") || part.startsWith("uname=")) continue;
      kept.add(part);
    }
    kept.add("uname=" + URLEncoder.encode(displayName, StandardCharsets.UTF_8).replace("+", "%20"));
    return path + "?" + String.join("&", kept) + fragment;
  }
}
```

- [ ] **Step 5: Run the tests**

Run: `cd server && ./gradlew test --tests "*WebinarLaunchServiceTest"`
Expected: PASS (9 tests).

- [ ] **Step 6: Commit**

```bash
git add server/src/main/java/com/acme/rsvp/security/TokenHasher.java server/src/main/java/com/acme/rsvp/service/WebinarLaunchService.java server/src/test
git commit -m "feat: tracked webinar launch with display-name lock and per-attendee lock"
```

---

## Task 8: Join links and invite emails

**Files:**
- Create: `service/WebinarInviteService.java`
- Modify: `service/EmailService.java`
- Test: `server/src/test/java/com/acme/rsvp/service/WebinarInviteServiceTest.java`

**Interfaces:**
- Consumes: `TokenHasher`, `WebinarService.require`, `WebinarProperties.displayZone()`, existing property `app.frontend-url`.
- Produces: `EmailService.sendWebinarInvite(String to, String title, String hostName, String whenText, List<InviteLink> links)`.
- Produces: `WebinarInviteService` — `issueLink(Long webinarId, Long seatId, OffsetDateTime now) : String` (full URL `${app.frontend-url}/j/<raw>`; revokes the seat's earlier links) and `sendInvites(Long webinarId, OffsetDateTime now) : InviteResult` (one email per person with a seat in their family; reissues every link).

- [ ] **Step 1: Write the failing test**

```java
package com.acme.rsvp.service;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.verify;

import java.time.OffsetDateTime;
import java.util.List;

import org.junit.jupiter.api.Test;
import org.mockito.ArgumentCaptor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.bean.override.mockito.MockitoBean;

import com.acme.rsvp.dto.WebinarDtos.InviteLink;
import com.acme.rsvp.dto.WebinarDtos.InviteResult;
import com.acme.rsvp.exception.NotFoundException;
import com.acme.rsvp.model.FamilyMember;
import com.acme.rsvp.model.Person;
import com.acme.rsvp.model.Webinar;
import com.acme.rsvp.model.WebinarAccessMode;
import com.acme.rsvp.model.WebinarSeat;
import com.acme.rsvp.model.WebinarStatus;
import com.acme.rsvp.repository.WebinarJoinTokenRepository;
import com.acme.rsvp.security.TokenHasher;
import com.acme.rsvp.support.PostgresIntegrationTest;
import com.acme.rsvp.support.TestData;

class WebinarInviteServiceTest extends PostgresIntegrationTest {

  @Autowired WebinarInviteService invites;
  @Autowired WebinarSeatService seatService;
  @Autowired WebinarLaunchService launch;
  @Autowired WebinarJoinTokenRepository tokens;
  @Autowired TestData data;
  @MockitoBean EmailService email;

  private final OffsetDateTime now = OffsetDateTime.now();

  private Webinar webinar() {
    return data.webinar(WebinarAccessMode.ASSIGNED, now.plusDays(1));
  }

  @Test
  void issueLinkStoresOnlyTheHashAndReissueRevokesTheOldLink() {
    Person p = data.person(false);
    Webinar w = webinar();
    WebinarSeat seat = seatService.giveSeat(w.getId(), p.getId(), null);

    String first = invites.issueLink(w.getId(), seat.getId(), now);
    assertThat(first).startsWith("http://localhost:5173/j/");
    String rawFirst = first.substring(first.lastIndexOf('/') + 1);
    assertThat(tokens.findByTokenHash(TokenHasher.sha256Hex(rawFirst))).isPresent();
    assertThat(tokens.findByTokenHash(rawFirst)).isEmpty();

    String second = invites.issueLink(w.getId(), seat.getId(), now);
    String rawSecond = second.substring(second.lastIndexOf('/') + 1);
    assertThatThrownBy(() -> launch.resolveToken(rawFirst, now)).isInstanceOf(NotFoundException.class);
    assertThat(launch.resolveToken(rawSecond, now).getSeat().getId()).isEqualTo(seat.getId());
  }

  @Test
  void issueLinkRejectsASeatFromAnotherWebinar() {
    Person p = data.person(false);
    WebinarSeat seat = seatService.giveSeat(webinar().getId(), p.getId(), null);
    assertThatThrownBy(() -> invites.issueLink(webinar().getId(), seat.getId(), now))
        .isInstanceOf(NotFoundException.class);
  }

  @Test
  @SuppressWarnings("unchecked")
  void sendsOneEmailPerFamilyAndHofWithoutASeatGetsOnlyFamilyLinks() {
    Person hof = data.person(true);
    FamilyMember fm1 = data.familyMember(hof);
    FamilyMember fm2 = data.familyMember(hof);
    Person member = data.person(false);
    Webinar w = webinar();
    seatService.giveSeat(w.getId(), hof.getId(), fm1.getId());
    seatService.giveSeat(w.getId(), hof.getId(), fm2.getId());
    seatService.giveSeat(w.getId(), member.getId(), null);

    InviteResult result = invites.sendInvites(w.getId(), now);

    assertThat(result.sent()).isEqualTo(2);
    assertThat(result.skipped()).isEmpty();

    ArgumentCaptor<List<InviteLink>> hofLinks = ArgumentCaptor.forClass(List.class);
    verify(email).sendWebinarInvite(eq(hof.getEmail()), eq(w.getTitle()), any(), any(), hofLinks.capture());
    assertThat(hofLinks.getValue()).hasSize(2);
    assertThat(hofLinks.getValue()).extracting(InviteLink::label)
        .noneMatch(l -> l.equals("Your link"))
        .allMatch(l -> l.startsWith("Family Member ("));
    assertThat(hofLinks.getValue()).extracting(InviteLink::url).allMatch(u -> u.contains("/j/"));

    ArgumentCaptor<List<InviteLink>> memberLinks = ArgumentCaptor.forClass(List.class);
    verify(email).sendWebinarInvite(eq(member.getEmail()), any(), any(), any(), memberLinks.capture());
    assertThat(memberLinks.getValue()).singleElement()
        .satisfies(l -> assertThat(l.label()).isEqualTo("Your link"));
  }

  @Test
  void refusesToSendForAnUnpublishedWebinar() {
    Webinar w = webinar();
    w.setStatus(WebinarStatus.DRAFT);
    assertThatThrownBy(() -> invites.sendInvites(w.getId(), now))
        .isInstanceOf(IllegalStateException.class).hasMessageContaining("Publish");
  }
}
```

- [ ] **Step 2: Run it to verify it fails**

Run: `cd server && ./gradlew test --tests "*WebinarInviteServiceTest"`
Expected: FAIL — `WebinarInviteService` and `sendWebinarInvite` do not exist.

- [ ] **Step 3: Add `sendWebinarInvite` to `EmailService.java`**

Add imports `java.util.List`, `org.springframework.web.util.HtmlUtils`, `com.acme.rsvp.dto.WebinarDtos.InviteLink`, then add the method. It builds the HTML with `StringBuilder`, not `.formatted()`, because a literal `%` in CSS has broken `.formatted()` templates in this class before.

```java
    public void sendWebinarInvite(String to, String title, String hostName, String whenText,
            List<InviteLink> links) {
        String subject = "Your webinar link: " + title;

        StringBuilder text = new StringBuilder();
        text.append(title).append("\n");
        if (hostName != null && !hostName.isBlank()) text.append("Host: ").append(hostName).append("\n");
        text.append("When: ").append(whenText).append("\n\n");
        for (InviteLink link : links) {
            text.append(link.label()).append(": ").append(link.url()).append("\n");
        }
        text.append("\nEach link is personal. Please forward each family member their own link. ")
            .append("Links work only around the scheduled time.");

        StringBuilder html = new StringBuilder();
        html.append("<div style=\"font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;\">")
            .append("<div style=\"background: #6d28d9; padding: 24px; text-align: center;\">")
            .append("<h1 style=\"color: #ffffff; margin: 0; font-size: 22px;\">")
            .append(HtmlUtils.htmlEscape(title)).append("</h1></div>")
            .append("<div style=\"padding: 24px; color: #333333;\">");
        if (hostName != null && !hostName.isBlank()) {
            html.append("<p style=\"margin: 0 0 8px 0;\"><strong>Host:</strong> ")
                .append(HtmlUtils.htmlEscape(hostName)).append("</p>");
        }
        html.append("<p style=\"margin: 0 0 20px 0;\"><strong>When:</strong> ")
            .append(HtmlUtils.htmlEscape(whenText)).append("</p>");
        for (InviteLink link : links) {
            html.append("<p style=\"margin: 0 0 14px 0;\">")
                .append(HtmlUtils.htmlEscape(link.label())).append("<br>")
                .append("<a href=\"").append(HtmlUtils.htmlEscape(link.url()))
                .append("\" style=\"color: #2563eb; font-weight: bold;\">Join webinar</a></p>");
        }
        html.append("<p style=\"color: #666666; font-size: 13px; margin-top: 24px;\">")
            .append("Each link is personal. Please forward each family member their own link. ")
            .append("Links work only around the scheduled time.</p>")
            .append("</div><div style=\"background: #f8f8f8; padding: 16px; text-align: center; ")
            .append("color: #999999; font-size: 12px;\">Anjuman-e-Ezzi, Washington DC</div></div>");

        sendEmail(to, subject, html.toString(), text.toString());
    }
```

- [ ] **Step 4: Write `service/WebinarInviteService.java`**

```java
package com.acme.rsvp.service;

import java.time.OffsetDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.UUID;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.acme.rsvp.config.WebinarProperties;
import com.acme.rsvp.dto.WebinarDtos.InviteLink;
import com.acme.rsvp.dto.WebinarDtos.InviteResult;
import com.acme.rsvp.exception.NotFoundException;
import com.acme.rsvp.model.Person;
import com.acme.rsvp.model.Webinar;
import com.acme.rsvp.model.WebinarJoinToken;
import com.acme.rsvp.model.WebinarSeat;
import com.acme.rsvp.model.WebinarStatus;
import com.acme.rsvp.repository.WebinarJoinTokenRepository;
import com.acme.rsvp.repository.WebinarSeatRepository;
import com.acme.rsvp.security.TokenHasher;

@Service
public class WebinarInviteService {
  private static final Logger log = LoggerFactory.getLogger(WebinarInviteService.class);
  private static final DateTimeFormatter WHEN =
      DateTimeFormatter.ofPattern("EEEE, MMMM d, yyyy 'at' h:mm a z", Locale.US);

  private final WebinarService webinarService;
  private final WebinarSeatRepository seats;
  private final WebinarJoinTokenRepository tokens;
  private final EmailService email;
  private final WebinarProperties props;
  private final String frontendUrl;

  public WebinarInviteService(WebinarService webinarService, WebinarSeatRepository seats,
      WebinarJoinTokenRepository tokens, EmailService email, WebinarProperties props,
      @Value("${app.frontend-url:http://localhost:5173}") String frontendUrl) {
    this.webinarService = webinarService;
    this.seats = seats;
    this.tokens = tokens;
    this.email = email;
    this.props = props;
    this.frontendUrl = frontendUrl.endsWith("/") ? frontendUrl.substring(0, frontendUrl.length() - 1) : frontendUrl;
  }

  @Transactional
  public String issueLink(Long webinarId, Long seatId, OffsetDateTime now) {
    WebinarSeat seat = seats.findById(seatId)
        .filter(s -> s.getWebinar().getId().equals(webinarId))
        .orElseThrow(() -> new NotFoundException("Seat not found"));
    return issue(seat, now);
  }

  @Transactional
  public InviteResult sendInvites(Long webinarId, OffsetDateTime now) {
    Webinar w = webinarService.require(webinarId);
    if (w.getStatus() != WebinarStatus.PUBLISHED) {
      throw new IllegalStateException("Publish the webinar before sending invites");
    }
    String whenText = WHEN.format(w.getScheduledStart().atZoneSameInstant(ZoneId.of(props.displayZone())));

    Map<Long, List<WebinarSeat>> byPerson = new LinkedHashMap<>();
    for (WebinarSeat s : seats.findByWebinarIdWithAttendees(webinarId)) {
      byPerson.computeIfAbsent(s.getPerson().getId(), k -> new ArrayList<>()).add(s);
    }

    int sent = 0;
    List<String> skipped = new ArrayList<>();
    for (List<WebinarSeat> family : byPerson.values()) {
      Person contact = family.get(0).getPerson();
      String contactName = contact.getFirstName() + " " + contact.getLastName();
      if (contact.getEmail() == null || contact.getEmail().isBlank()) {
        skipped.add(contactName + " (no email address)");
        continue;
      }
      // Own seat first, then family members by name.
      family.sort(Comparator.comparing(WebinarSeat::isFamilySeat).thenComparing(WebinarSeat::attendeeName));
      List<InviteLink> links = new ArrayList<>();
      for (WebinarSeat s : family) {
        String label = s.isFamilySeat() ? s.attendeeName() + " (" + s.attendeeIts() + ")" : "Your link";
        links.add(new InviteLink(label, issue(s, now)));
      }
      try {
        email.sendWebinarInvite(contact.getEmail(), w.getTitle(), w.getHostName(), whenText, links);
        sent++;
      } catch (RuntimeException e) {
        log.error("Failed to send webinar invite for webinar {} to person {}", webinarId, contact.getId(), e);
        skipped.add(contactName + " (email failed)");
      }
    }
    return new InviteResult(sent, skipped);
  }

  /** One live link per seat: issuing a new one revokes the rest. The raw token is returned once and never stored. */
  private String issue(WebinarSeat seat, OffsetDateTime now) {
    tokens.revokeForSeat(seat.getId(), now);
    String raw = TokenHasher.randomToken();
    tokens.save(new WebinarJoinToken(UUID.randomUUID(), seat, TokenHasher.sha256Hex(raw), now,
        seat.getWebinar().joinWindowEnd()));
    return frontendUrl + "/j/" + raw;
  }
}
```

Do not log the links or the raw tokens anywhere. Note that `EmailService.sendEmail` logs the plain-text body when SendGrid is disabled; that is dev-only behaviour and is acceptable, but confirm `SENDGRID_ENABLED=true` in production before the first real send (Task 16).

- [ ] **Step 5: Run the tests**

Run: `cd server && ./gradlew test --tests "*WebinarInviteServiceTest"`
Expected: PASS (4 tests).

- [ ] **Step 6: Commit**

```bash
git add server/src/main/java/com/acme/rsvp/service server/src/test
git commit -m "feat: webinar join links and per-family invite emails"
```

---

## Task 9: Attendance report

**Files:**
- Create: `service/WebinarReportService.java`
- Test: `server/src/test/java/com/acme/rsvp/service/WebinarReportServiceTest.java`

**Interfaces:**
- Produces: `WebinarReportService.report(Long webinarId) : AttendanceReport`. Rows are every seat on the webinar; `type` is `"Member"` or `"Family"`; `hofName`/`hofIts` are set only for family rows; rows are sorted by head-of-family name, own seat first, then attendee name.

- [ ] **Step 1: Write the failing test**

```java
package com.acme.rsvp.service;

import static org.assertj.core.api.Assertions.assertThat;

import java.time.OffsetDateTime;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import com.acme.rsvp.dto.WebinarDtos.AttendanceReport;
import com.acme.rsvp.dto.WebinarDtos.AttendeeRow;
import com.acme.rsvp.model.FamilyMember;
import com.acme.rsvp.model.JoinSource;
import com.acme.rsvp.model.Person;
import com.acme.rsvp.model.Webinar;
import com.acme.rsvp.model.WebinarAccessMode;
import com.acme.rsvp.model.WebinarJoinLog;
import com.acme.rsvp.model.WebinarSeat;
import com.acme.rsvp.repository.WebinarJoinLogRepository;
import com.acme.rsvp.support.PostgresIntegrationTest;
import com.acme.rsvp.support.TestData;

class WebinarReportServiceTest extends PostgresIntegrationTest {

  @Autowired WebinarReportService reports;
  @Autowired WebinarSeatService seatService;
  @Autowired WebinarJoinLogRepository logs;
  @Autowired TestData data;

  @Test
  void listsEachFamilyMemberSeparatelyWithJoinDetails() {
    Person hof = data.person(true);
    FamilyMember joinedFm = data.familyMember(hof);
    FamilyMember absentFm = data.familyMember(hof);
    Person member = data.person(false);
    Webinar w = data.webinar(WebinarAccessMode.ASSIGNED, OffsetDateTime.now().plusDays(1));

    WebinarSeat s1 = seatService.giveSeat(w.getId(), hof.getId(), joinedFm.getId());
    seatService.giveSeat(w.getId(), hof.getId(), absentFm.getId());
    seatService.giveSeat(w.getId(), member.getId(), null);

    OffsetDateTime first = OffsetDateTime.parse("2030-01-01T18:00:00Z");
    logs.saveAndFlush(new WebinarJoinLog(s1, first.plusMinutes(5), JoinSource.MAGIC_LINK));
    logs.saveAndFlush(new WebinarJoinLog(s1, first, JoinSource.MAGIC_LINK));

    AttendanceReport report = reports.report(w.getId());

    assertThat(report.seatCount()).isEqualTo(3);
    assertThat(report.joinedCount()).isEqualTo(1);
    // The HOF holds no seat, so there is no row for them.
    assertThat(report.rows()).extracting(AttendeeRow::itsNumber).doesNotContain(hof.getItsNumber());

    AttendeeRow joined = report.rows().stream()
        .filter(r -> r.itsNumber().equals(joinedFm.getItsNumber())).findFirst().orElseThrow();
    assertThat(joined.type()).isEqualTo("Family");
    assertThat(joined.hofIts()).isEqualTo(hof.getItsNumber());
    assertThat(joined.joined()).isTrue();
    assertThat(joined.launchCount()).isEqualTo(2);
    assertThat(joined.firstJoinedAt().isEqual(first)).isTrue();

    AttendeeRow absent = report.rows().stream()
        .filter(r -> r.itsNumber().equals(absentFm.getItsNumber())).findFirst().orElseThrow();
    assertThat(absent.joined()).isFalse();
    assertThat(absent.launchCount()).isZero();
    assertThat(absent.firstJoinedAt()).isNull();

    AttendeeRow own = report.rows().stream()
        .filter(r -> r.itsNumber().equals(member.getItsNumber())).findFirst().orElseThrow();
    assertThat(own.type()).isEqualTo("Member");
    assertThat(own.hofName()).isNull();
  }
}
```

- [ ] **Step 2: Run it to verify it fails**

Run: `cd server && ./gradlew test --tests "*WebinarReportServiceTest"`
Expected: FAIL — `WebinarReportService` does not exist.

- [ ] **Step 3: Write `service/WebinarReportService.java`**

```java
package com.acme.rsvp.service;

import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.acme.rsvp.dto.WebinarDtos.AttendanceReport;
import com.acme.rsvp.dto.WebinarDtos.AttendeeRow;
import com.acme.rsvp.model.Person;
import com.acme.rsvp.model.Webinar;
import com.acme.rsvp.model.WebinarJoinLog;
import com.acme.rsvp.model.WebinarSeat;
import com.acme.rsvp.repository.WebinarJoinLogRepository;
import com.acme.rsvp.repository.WebinarSeatRepository;

@Service
public class WebinarReportService {

  private final WebinarService webinarService;
  private final WebinarSeatRepository seats;
  private final WebinarJoinLogRepository logs;

  public WebinarReportService(WebinarService webinarService, WebinarSeatRepository seats,
      WebinarJoinLogRepository logs) {
    this.webinarService = webinarService;
    this.seats = seats;
    this.logs = logs;
  }

  @Transactional(readOnly = true)
  public AttendanceReport report(Long webinarId) {
    Webinar w = webinarService.require(webinarId);

    Map<Long, OffsetDateTime> firstJoin = new HashMap<>();
    Map<Long, Integer> launches = new HashMap<>();
    for (WebinarJoinLog l : logs.findByWebinarId(webinarId)) { // ordered by joinedAt ascending
      Long seatId = l.getSeat().getId();
      firstJoin.putIfAbsent(seatId, l.getJoinedAt());
      launches.merge(seatId, 1, Integer::sum);
    }

    List<WebinarSeat> all = new ArrayList<>(seats.findByWebinarIdWithAttendees(webinarId));
    all.sort(Comparator
        .comparing((WebinarSeat s) -> fullName(s.getPerson()), String.CASE_INSENSITIVE_ORDER)
        .thenComparing(WebinarSeat::isFamilySeat)
        .thenComparing(WebinarSeat::attendeeName, String.CASE_INSENSITIVE_ORDER));

    List<AttendeeRow> rows = all.stream().map(s -> {
      boolean family = s.isFamilySeat();
      return new AttendeeRow(s.attendeeIts(), s.attendeeName(), family ? "Family" : "Member",
          family ? fullName(s.getPerson()) : null,
          family ? s.getPerson().getItsNumber() : null,
          firstJoin.containsKey(s.getId()), firstJoin.get(s.getId()),
          launches.getOrDefault(s.getId(), 0));
    }).toList();

    int joined = (int) rows.stream().filter(AttendeeRow::joined).count();
    return new AttendanceReport(webinarService.toSummary(w), rows.size(), joined, rows);
  }

  private static String fullName(Person p) {
    return p.getFirstName() + " " + p.getLastName();
  }
}
```

- [ ] **Step 4: Run the tests**

Run: `cd server && ./gradlew test --tests "*WebinarReportServiceTest"`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add server/src/main/java/com/acme/rsvp/service/WebinarReportService.java server/src/test
git commit -m "feat: webinar attendance report"
```

---

## Task 10: Security rules and controllers

**Files:**
- Modify: `config/WebSecurityConfig.java`, `security/SessionAuthFilter.java`
- Create: `web/WebinarAdminController.java`, `web/FamilyMemberAdminController.java`, `web/WebinarController.java`, `web/WebinarPublicController.java`
- Test: `server/src/test/java/com/acme/rsvp/web/WebinarApiTest.java`

**Interfaces:**
- Consumes: every service from Tasks 4–9.
- Produces the HTTP API in the spec, section 7, except the two Zoom endpoints (Task 11):
  - `/api/webinars/admin/**` and `/api/admin/family-members/**` — `ADMIN` or `WEBINAR_COORDINATOR` only.
  - `/api/webinars`, `/api/webinars/{id}/launch` — any authenticated user.
  - `GET /api/webinars/public/**` — anonymous.
- Launch endpoints always answer `302`. On success the `Location` is the Zoom URL. On a rule failure the `Location` is a frontend page with a `joinError` query parameter (`/webinars?joinError=…` for members, `/j/{token}?joinError=…` for links), because the browser navigated here directly and would otherwise show raw JSON.

- [ ] **Step 1: Write the failing test**

```java
package com.acme.rsvp.web;

import static org.hamcrest.Matchers.allOf;
import static org.hamcrest.Matchers.containsString;
import static org.hamcrest.Matchers.not;
import static org.hamcrest.Matchers.startsWith;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.header;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import java.time.OffsetDateTime;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import com.acme.rsvp.model.FamilyMember;
import com.acme.rsvp.model.Person;
import com.acme.rsvp.model.Webinar;
import com.acme.rsvp.model.WebinarAccessMode;
import com.acme.rsvp.model.WebinarSeat;
import com.acme.rsvp.service.WebinarInviteService;
import com.acme.rsvp.service.WebinarSeatService;
import com.acme.rsvp.support.PostgresIntegrationTest;
import com.acme.rsvp.support.TestData;

class WebinarApiTest extends PostgresIntegrationTest {

  @Autowired MockMvc mvc;
  @Autowired TestData data;
  @Autowired WebinarSeatService seatService;
  @Autowired WebinarInviteService invites;

  private final OffsetDateTime now = OffsetDateTime.now();

  private String rawTokenFor(Webinar w, WebinarSeat seat) {
    String link = invites.issueLink(w.getId(), seat.getId(), now);
    return link.substring(link.lastIndexOf('/') + 1);
  }

  @Test
  void adminEndpointsRejectPlainUsersAndAnonymous() throws Exception {
    Person user = data.person(true, "USER");
    mvc.perform(get("/api/webinars/admin").cookie(data.session(user))).andExpect(status().isForbidden());
    mvc.perform(get("/api/admin/family-members/hofs").param("search", "ab").cookie(data.session(user)))
        .andExpect(status().isForbidden());
    mvc.perform(get("/api/webinars/admin")).andExpect(status().isForbidden());
    mvc.perform(get("/api/webinars")).andExpect(status().isForbidden());
  }

  @Test
  void coordinatorCanCreateAndTheResponseNeverContainsTheJoinUrl() throws Exception {
    Person coord = data.person(false, "USER", "WEBINAR_COORDINATOR");
    String body = """
        {"title":"Majlis","hostName":"Host","scheduledStart":"2031-01-01T18:00:00Z",
         "scheduledEnd":"2031-01-01T19:00:00Z","status":"PUBLISHED","accessMode":"ASSIGNED",
         "joinUrl":"https://zoom.us/j/999?pwd=secretpwd"}
        """;
    mvc.perform(post("/api/webinars/admin").cookie(data.session(coord))
            .contentType(MediaType.APPLICATION_JSON).content(body))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.hasJoinUrl").value(true))
        .andExpect(jsonPath("$.joinUrl").doesNotExist())
        .andExpect(content().string(not(containsString("secretpwd"))));
    mvc.perform(get("/api/webinars/admin").cookie(data.session(coord)))
        .andExpect(status().isOk())
        .andExpect(content().string(not(containsString("secretpwd"))));
  }

  @Test
  void coordinatorManagesFamilyMembersSeatsLinksAndReport() throws Exception {
    Person coord = data.person(false, "USER", "WEBINAR_COORDINATOR");
    Person hof = data.person(true);
    Webinar w = data.webinar(WebinarAccessMode.ASSIGNED, now.plusDays(1));
    var session = data.session(coord);

    String fmBody = """
        {"hofPersonId":%d,"firstName":"Fatema","lastName":"Kanchwala","itsNumber":"%s","webinarId":%d}
        """.formatted(hof.getId(), TestData.nextIts(), w.getId());
    mvc.perform(post("/api/admin/family-members").cookie(session)
            .contentType(MediaType.APPLICATION_JSON).content(fmBody))
        .andExpect(status().isOk()).andExpect(jsonPath("$.active").value(true));

    mvc.perform(get("/api/webinars/admin/{id}/seats", w.getId()).cookie(session))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$[0].personId").value(hof.getId()))
        .andExpect(jsonPath("$[0].ownSeatId").doesNotExist())
        .andExpect(jsonPath("$[0].family[0].seatId").isNumber());

    mvc.perform(post("/api/webinars/admin/{id}/seats", w.getId()).cookie(session)
            .contentType(MediaType.APPLICATION_JSON).content("{\"personId\":" + hof.getId() + "}"))
        .andExpect(status().isOk());
    mvc.perform(post("/api/webinars/admin/{id}/seats", w.getId()).cookie(session)
            .contentType(MediaType.APPLICATION_JSON).content("{\"personId\":" + hof.getId() + "}"))
        .andExpect(status().isBadRequest())
        .andExpect(jsonPath("$.error").value(containsString("already has a seat")));

    mvc.perform(get("/api/webinars/admin/{id}/report", w.getId()).cookie(session))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.seatCount").value(2))
        .andExpect(jsonPath("$.joinedCount").value(0));

    mvc.perform(post("/api/webinars/admin/{id}/send-invites", w.getId()).cookie(session))
        .andExpect(status().isOk()).andExpect(jsonPath("$.sent").value(1));

    mvc.perform(delete("/api/webinars/admin/{id}", 999999L).cookie(session))
        .andExpect(status().isNotFound());
  }

  @Test
  void memberListAndLaunchRedirectToZoomOrBackWithAnError() throws Exception {
    Person member = data.person(false);
    Webinar live = data.webinar(WebinarAccessMode.OPEN, now.plusMinutes(5));
    Webinar noAccess = data.webinar(WebinarAccessMode.ASSIGNED, now.plusMinutes(5));
    var session = data.session(member);

    mvc.perform(get("/api/webinars").cookie(session))
        .andExpect(status().isOk())
        .andExpect(content().string(not(containsString("zoom.us"))));

    mvc.perform(get("/api/webinars/{id}/launch", live.getId()).cookie(session))
        .andExpect(status().isFound())
        .andExpect(header().string("Location",
            allOf(startsWith("https://zoom.us/j/123"), containsString("uname=" + member.getItsNumber()))));

    mvc.perform(get("/api/webinars/{id}/launch", noAccess.getId()).cookie(session))
        .andExpect(status().isFound())
        .andExpect(header().string("Location",
            allOf(startsWith("http://localhost:5173/webinars?joinError="), not(containsString("zoom.us")))));
  }

  @Test
  void magicLinkWorksWithoutLoginAndShowsWhoseSeatItIs() throws Exception {
    Person hof = data.person(true);
    FamilyMember fm = data.familyMember(hof);
    Webinar live = data.webinar(WebinarAccessMode.ASSIGNED, now.plusMinutes(5));
    String raw = rawTokenFor(live, seatService.giveSeat(live.getId(), hof.getId(), fm.getId()));

    mvc.perform(get("/api/webinars/public/{token}", raw))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.attendeeIts").value(fm.getItsNumber()))
        .andExpect(jsonPath("$.joinOpen").value(true))
        .andExpect(content().string(not(containsString("zoom.us"))));

    mvc.perform(get("/api/webinars/public/{token}/launch", raw))
        .andExpect(status().isFound())
        .andExpect(header().string("Location", containsString("uname=" + fm.getItsNumber())));

    mvc.perform(get("/api/webinars/public/{token}", "garbage")).andExpect(status().isNotFound());

    Webinar later = data.webinar(WebinarAccessMode.ASSIGNED, now.plusDays(1));
    String early = rawTokenFor(later, seatService.giveSeat(later.getId(), hof.getId(), fm.getId()));
    mvc.perform(get("/api/webinars/public/{token}/launch", early))
        .andExpect(status().isFound())
        .andExpect(header().string("Location", startsWith("http://localhost:5173/j/" + early + "?joinError=")));
  }
}
```

- [ ] **Step 2: Run it to verify it fails**

Run: `cd server && ./gradlew test --tests "*WebinarApiTest"`
Expected: FAIL — 404s, since no controllers exist. (`adminEndpointsRejectPlainUsersAndAnonymous` may partly pass for anonymous calls; the `USER` assertions fail.)

- [ ] **Step 3: Open the public path and add the role rule**

In `WebSecurityConfig.java`, inside `authorizeHttpRequests`, add `"/api/webinars/public/**"` to the existing `HttpMethod.GET` `permitAll()` list, and add this line immediately before `.anyRequest().authenticated()`:

```java
	    	        .requestMatchers("/api/webinars/admin/**", "/api/admin/family-members/**")
	    	            .hasAnyRole("ADMIN", "WEBINAR_COORDINATOR")
```

In `SessionAuthFilter.java`, add directly after the block that skips `GET /api/events/{id}`:

```java
		// Magic-link endpoints are anonymous: the token in the path is the credential.
		if ("GET".equalsIgnoreCase(method) && path.startsWith("/api/webinars/public/")) {
			chain.doFilter(req, resp);
			return;
		}
```

`hasAnyRole` works because `SessionAuthFilter` already grants authorities as `ROLE_<role>`.

- [ ] **Step 4: Write `web/WebinarAdminController.java`**

```java
package com.acme.rsvp.web;

import java.time.OffsetDateTime;
import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.acme.rsvp.dto.WebinarDtos.AssignableRow;
import com.acme.rsvp.dto.WebinarDtos.AttendanceReport;
import com.acme.rsvp.dto.WebinarDtos.CopySeatsResult;
import com.acme.rsvp.dto.WebinarDtos.FamilySeats;
import com.acme.rsvp.dto.WebinarDtos.GiveSeatRequest;
import com.acme.rsvp.dto.WebinarDtos.InviteResult;
import com.acme.rsvp.dto.WebinarDtos.LinkResponse;
import com.acme.rsvp.dto.WebinarDtos.SaveWebinarRequest;
import com.acme.rsvp.dto.WebinarDtos.WebinarSummary;
import com.acme.rsvp.service.WebinarInviteService;
import com.acme.rsvp.service.WebinarReportService;
import com.acme.rsvp.service.WebinarSeatService;
import com.acme.rsvp.service.WebinarService;

/** ADMIN / WEBINAR_COORDINATOR only, enforced by the URL rule in WebSecurityConfig. */
@RestController
@RequestMapping("/api/webinars/admin")
public class WebinarAdminController {

  private final WebinarService webinars;
  private final WebinarSeatService seats;
  private final WebinarInviteService invites;
  private final WebinarReportService reports;

  public WebinarAdminController(WebinarService webinars, WebinarSeatService seats,
      WebinarInviteService invites, WebinarReportService reports) {
    this.webinars = webinars;
    this.seats = seats;
    this.invites = invites;
    this.reports = reports;
  }

  @GetMapping
  public List<WebinarSummary> list() { return webinars.list(); }

  @PostMapping
  public WebinarSummary create(@RequestBody SaveWebinarRequest req) { return webinars.create(req); }

  @GetMapping("/{id}")
  public WebinarSummary get(@PathVariable Long id) { return webinars.get(id); }

  @PutMapping("/{id}")
  public WebinarSummary update(@PathVariable Long id, @RequestBody SaveWebinarRequest req) {
    return webinars.update(id, req);
  }

  @DeleteMapping("/{id}")
  public ResponseEntity<Void> delete(@PathVariable Long id) {
    webinars.delete(id);
    return ResponseEntity.noContent().build();
  }

  @GetMapping("/{id}/seats")
  public List<FamilySeats> seats(@PathVariable Long id) { return seats.listSeats(id); }

  @GetMapping("/{id}/assignable")
  public List<AssignableRow> assignable(@PathVariable Long id, @RequestParam(defaultValue = "") String search) {
    return seats.searchAssignable(id, search);
  }

  @PostMapping("/{id}/seats")
  public Map<String, Long> giveSeat(@PathVariable Long id, @RequestBody GiveSeatRequest req) {
    return Map.of("seatId", seats.giveSeat(id, req.personId(), req.familyMemberId()).getId());
  }

  @DeleteMapping("/{id}/seats/{seatId}")
  public ResponseEntity<Void> removeSeat(@PathVariable Long id, @PathVariable Long seatId) {
    seats.removeSeat(id, seatId);
    return ResponseEntity.noContent().build();
  }

  @PostMapping("/{id}/seats/copy-from/{otherId}")
  public CopySeatsResult copyFrom(@PathVariable Long id, @PathVariable Long otherId) {
    return seats.copyFrom(id, otherId);
  }

  @PostMapping("/{id}/seats/{seatId}/link")
  public LinkResponse link(@PathVariable Long id, @PathVariable Long seatId) {
    return new LinkResponse(invites.issueLink(id, seatId, OffsetDateTime.now()));
  }

  @PostMapping("/{id}/send-invites")
  public InviteResult sendInvites(@PathVariable Long id) {
    return invites.sendInvites(id, OffsetDateTime.now());
  }

  @GetMapping("/{id}/report")
  public AttendanceReport report(@PathVariable Long id) { return reports.report(id); }
}
```

- [ ] **Step 5: Write `web/FamilyMemberAdminController.java`**

```java
package com.acme.rsvp.web;

import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.acme.rsvp.dto.WebinarDtos.FamilyMemberDto;
import com.acme.rsvp.dto.WebinarDtos.HofDto;
import com.acme.rsvp.dto.WebinarDtos.SaveFamilyMemberRequest;
import com.acme.rsvp.dto.WebinarDtos.SetActiveRequest;
import com.acme.rsvp.service.FamilyMemberService;
import com.acme.rsvp.service.WebinarSeatService;

/** ADMIN / WEBINAR_COORDINATOR only, enforced by the URL rule in WebSecurityConfig. */
@RestController
@RequestMapping("/api/admin/family-members")
public class FamilyMemberAdminController {

  private final FamilyMemberService familyMembers;
  private final WebinarSeatService seats;

  public FamilyMemberAdminController(FamilyMemberService familyMembers, WebinarSeatService seats) {
    this.familyMembers = familyMembers;
    this.seats = seats;
  }

  /** Exposes only id, name, ITS and family count, so coordinators need no access to user management. */
  @GetMapping("/hofs")
  public List<HofDto> hofs(@RequestParam(defaultValue = "") String search) {
    return familyMembers.searchHofs(search);
  }

  @GetMapping
  public List<FamilyMemberDto> list(@RequestParam Long hofPersonId) {
    return familyMembers.listByHof(hofPersonId);
  }

  /** With webinarId set, the new family member is also given a seat on that webinar in one transaction. */
  @PostMapping
  public FamilyMemberDto create(@RequestBody SaveFamilyMemberRequest req) {
    return req.webinarId() != null ? seats.createFamilyMemberAndSeat(req) : familyMembers.create(req);
  }

  @PutMapping("/{id}")
  public FamilyMemberDto update(@PathVariable Long id, @RequestBody SaveFamilyMemberRequest req) {
    return familyMembers.update(id, req);
  }

  @PutMapping("/{id}/active")
  public FamilyMemberDto setActive(@PathVariable Long id, @RequestBody SetActiveRequest req) {
    return familyMembers.setActive(id, req.active());
  }
}
```

- [ ] **Step 6: Write `web/WebinarController.java`**

```java
package com.acme.rsvp.web;

import java.net.URI;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.OffsetDateTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.CacheControl;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.acme.rsvp.dto.WebinarDtos.MemberWebinar;
import com.acme.rsvp.exception.NotFoundException;
import com.acme.rsvp.model.Person;
import com.acme.rsvp.service.WebinarLaunchService;
import com.acme.rsvp.service.WebinarService;

/** Any logged-in member. Not limited to heads of family. */
@RestController
@RequestMapping("/api/webinars")
public class WebinarController {

  private final WebinarService webinars;
  private final WebinarLaunchService launchService;
  private final String frontendUrl;

  public WebinarController(WebinarService webinars, WebinarLaunchService launchService,
      @Value("${app.frontend-url:http://localhost:5173}") String frontendUrl) {
    this.webinars = webinars;
    this.launchService = launchService;
    this.frontendUrl = frontendUrl.endsWith("/") ? frontendUrl.substring(0, frontendUrl.length() - 1) : frontendUrl;
  }

  @GetMapping
  public List<MemberWebinar> mine(@AuthenticationPrincipal Person me) {
    return webinars.listForMember(me.getId(), OffsetDateTime.now());
  }

  /** The browser navigates here directly, so every outcome is a redirect: to Zoom, or back with a message. */
  @GetMapping("/{id}/launch")
  public ResponseEntity<Void> launch(@PathVariable Long id, @AuthenticationPrincipal Person me) {
    String target;
    try {
      target = launchService.launchForMember(id, me.getId(), OffsetDateTime.now());
    } catch (IllegalStateException | NotFoundException e) {
      target = frontendUrl + "/webinars?joinError=" + URLEncoder.encode(e.getMessage(), StandardCharsets.UTF_8);
    }
    return ResponseEntity.status(HttpStatus.FOUND)
        .cacheControl(CacheControl.noStore())
        .location(URI.create(target))
        .build();
  }
}
```

- [ ] **Step 7: Write `web/WebinarPublicController.java`**

```java
package com.acme.rsvp.web;

import java.net.URI;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.OffsetDateTime;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.CacheControl;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.acme.rsvp.dto.WebinarDtos.MagicJoinInfo;
import com.acme.rsvp.exception.NotFoundException;
import com.acme.rsvp.model.Webinar;
import com.acme.rsvp.model.WebinarSeat;
import com.acme.rsvp.service.WebinarLaunchService;

/** Anonymous. The token in the path is the only credential. */
@RestController
@RequestMapping("/api/webinars/public")
public class WebinarPublicController {

  private final WebinarLaunchService launchService;
  private final String frontendUrl;

  public WebinarPublicController(WebinarLaunchService launchService,
      @Value("${app.frontend-url:http://localhost:5173}") String frontendUrl) {
    this.launchService = launchService;
    this.frontendUrl = frontendUrl.endsWith("/") ? frontendUrl.substring(0, frontendUrl.length() - 1) : frontendUrl;
  }

  @GetMapping("/{token}")
  @Transactional(readOnly = true)
  public MagicJoinInfo info(@PathVariable String token) {
    OffsetDateTime now = OffsetDateTime.now();
    WebinarSeat seat = launchService.resolveToken(token, now).getSeat();
    Webinar w = seat.getWebinar();
    return new MagicJoinInfo(w.getTitle(), w.getHostName(), w.getScheduledStart(), w.getScheduledEnd(),
        w.isJoinOpen(now), seat.attendeeName(), seat.attendeeIts());
  }

  @GetMapping("/{token}/launch")
  public ResponseEntity<Void> launch(@PathVariable String token) {
    String target;
    try {
      target = launchService.launchForToken(token, OffsetDateTime.now());
    } catch (IllegalStateException | NotFoundException e) {
      target = frontendUrl + "/j/" + URLEncoder.encode(token, StandardCharsets.UTF_8)
          + "?joinError=" + URLEncoder.encode(e.getMessage(), StandardCharsets.UTF_8);
    }
    return ResponseEntity.status(HttpStatus.FOUND)
        .cacheControl(CacheControl.noStore())
        .location(URI.create(target))
        .build();
  }
}
```

- [ ] **Step 8: Run the whole backend suite**

Run: `cd server && ./gradlew test`
Expected: PASS, all test classes.

- [ ] **Step 9: Commit**

```bash
git add server/src/main server/src/test
git commit -m "feat: webinar admin, member and public endpoints with role rules"
```

---

## Task 11: Zoom sync

The Zoom request and response shapes below follow Zoom's Server-to-Server OAuth and "list meetings" / "list webinars" APIs as understood when this plan was written. **Before writing code, check the current Zoom API reference** for `POST /oauth/token` (`grant_type=account_credentials`), `GET /v2/users/{userId}/meetings` and `GET /v2/users/{userId}/webinars`, and confirm: the field names `id`, `topic`, `start_time`, `duration`, `join_url`; that list responses include `join_url`; and the scopes the S2S app needs. If list responses omit `join_url`, fetch it per item with the "get a meeting" / "get a webinar" call and adjust `ZoomClient.listScheduled` and its test to match.

**Files:**
- Create: `zoom/ZoomProperties.java`, `zoom/ZoomMeeting.java`, `zoom/ZoomClient.java`, `service/WebinarZoomSyncService.java`
- Modify: `server/src/main/resources/application.yml`, `web/WebinarAdminController.java`
- Test: `server/src/test/java/com/acme/rsvp/zoom/ZoomClientTest.java` (plain unit test), `server/src/test/java/com/acme/rsvp/service/WebinarZoomSyncServiceTest.java`

**Interfaces:**
- Produces: `ZoomProperties` record — `enabled()`, `accountId()`, `clientId()`, `clientSecret()`, `importUserId()`, `webinarImportUserId()`, `oauthUrl()`, `baseUrl()`, `defaultHostName()`.
- Produces: `ZoomMeeting(String id, String topic, OffsetDateTime start, OffsetDateTime end, String joinUrl)`.
- Produces: `ZoomClient.accessToken(OffsetDateTime now) : String`, `ZoomClient.listScheduled(String kind, OffsetDateTime now) : List<ZoomMeeting>` (`kind` is `"meetings"` or `"webinars"`).
- Produces: `WebinarZoomSyncService.preview(String kind) : List<ZoomSyncRow>`, `importOne(ZoomImportRequest) : WebinarSummary`.
- Produces: `GET /api/webinars/admin/zoom/preview?kind=`, `POST /api/webinars/admin/zoom/import`.

- [ ] **Step 1: Write the failing client test**

```java
package com.acme.rsvp.zoom;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.springframework.test.web.client.ExpectedCount.once;
import static org.springframework.test.web.client.match.MockRestRequestMatchers.header;
import static org.springframework.test.web.client.match.MockRestRequestMatchers.method;
import static org.springframework.test.web.client.match.MockRestRequestMatchers.requestTo;
import static org.springframework.test.web.client.response.MockRestResponseCreators.withSuccess;

import java.time.OffsetDateTime;
import java.util.List;

import org.junit.jupiter.api.Test;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.test.web.client.MockRestServiceServer;
import org.springframework.web.client.RestClient;

class ZoomClientTest {

  private static final ZoomProperties PROPS = new ZoomProperties(true, "acct", "cid", "secret",
      "me", "", "https://zoom.us/oauth/token", "https://api.zoom.us", "FMB");

  private final OffsetDateTime now = OffsetDateTime.parse("2030-01-01T00:00:00Z");

  @Test
  void tokenIsFetchedOnceAndReusedUntilItNearsExpiry() {
    RestClient.Builder builder = RestClient.builder();
    MockRestServiceServer server = MockRestServiceServer.bindTo(builder).build();
    server.expect(once(), requestTo("https://zoom.us/oauth/token?grant_type=account_credentials&account_id=acct"))
        .andExpect(method(HttpMethod.POST))
        .andExpect(header("Authorization", "Basic Y2lkOnNlY3JldA=="))
        .andRespond(withSuccess("{\"access_token\":\"tok1\",\"expires_in\":3600}", MediaType.APPLICATION_JSON));
    ZoomClient client = new ZoomClient(PROPS, builder);

    assertThat(client.accessToken(now)).isEqualTo("tok1");
    assertThat(client.accessToken(now.plusMinutes(30))).isEqualTo("tok1");
    server.verify();
  }

  @Test
  void listsScheduledMeetingsAndSkipsItemsWithoutAStartOrJoinUrl() {
    RestClient.Builder builder = RestClient.builder();
    MockRestServiceServer server = MockRestServiceServer.bindTo(builder).build();
    server.expect(requestTo("https://zoom.us/oauth/token?grant_type=account_credentials&account_id=acct"))
        .andRespond(withSuccess("{\"access_token\":\"tok1\",\"expires_in\":3600}", MediaType.APPLICATION_JSON));
    server.expect(requestTo("https://api.zoom.us/v2/users/me/meetings?type=scheduled&page_size=300"))
        .andExpect(header("Authorization", "Bearer tok1"))
        .andRespond(withSuccess("""
            {"meetings":[
              {"id":8123456789,"topic":"Majlis","start_time":"2030-02-01T23:00:00Z","duration":90,
               "join_url":"https://zoom.us/j/8123456789?pwd=x","extra":"ignored"},
              {"id":1,"topic":"No fixed time","duration":60,"join_url":"https://zoom.us/j/1"},
              {"id":2,"topic":"No link","start_time":"2030-02-02T23:00:00Z","duration":60}
            ]}
            """, MediaType.APPLICATION_JSON));
    ZoomClient client = new ZoomClient(PROPS, builder);

    List<ZoomMeeting> meetings = client.listScheduled("meetings", now);

    assertThat(meetings).singleElement().satisfies(m -> {
      assertThat(m.id()).isEqualTo("8123456789");
      assertThat(m.topic()).isEqualTo("Majlis");
      assertThat(m.start().isEqual(OffsetDateTime.parse("2030-02-01T23:00:00Z"))).isTrue();
      assertThat(m.end().isEqual(OffsetDateTime.parse("2030-02-02T00:30:00Z"))).isTrue();
      assertThat(m.joinUrl()).isEqualTo("https://zoom.us/j/8123456789?pwd=x");
    });
    server.verify();
  }

  @Test
  void refusesWhenTheIntegrationIsNotConfigured() {
    ZoomProperties off = new ZoomProperties(false, "", "", "", "", "",
        "https://zoom.us/oauth/token", "https://api.zoom.us", "FMB");
    ZoomClient client = new ZoomClient(off, RestClient.builder());
    assertThatThrownBy(() -> client.listScheduled("meetings", now))
        .isInstanceOf(IllegalStateException.class).hasMessageContaining("not configured");
  }
}
```

- [ ] **Step 2: Run it to verify it fails**

Run: `cd server && ./gradlew test --tests "*ZoomClientTest"`
Expected: FAIL — `ZoomProperties` and `ZoomClient` do not exist.

- [ ] **Step 3: Write the Zoom types and config**

`application.yml` — append under `app:`, at the same indent as `webinar:`:
```yaml
  zoom:
    enabled: ${ZOOM_ENABLED:false}
    account-id: ${ZOOM_ACCOUNT_ID:}
    client-id: ${ZOOM_CLIENT_ID:}
    client-secret: ${ZOOM_CLIENT_SECRET:}
    import-user-id: ${ZOOM_IMPORT_USER_ID:me}
    webinar-import-user-id: ${ZOOM_WEBINAR_IMPORT_USER_ID:}
    oauth-url: ${ZOOM_OAUTH_URL:https://zoom.us/oauth/token}
    base-url: ${ZOOM_BASE_URL:https://api.zoom.us}
    default-host-name: ${ZOOM_DEFAULT_HOST_NAME:FMB}
```

`zoom/ZoomProperties.java`:
```java
package com.acme.rsvp.zoom;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.context.properties.bind.DefaultValue;

@ConfigurationProperties(prefix = "app.zoom")
public record ZoomProperties(
    @DefaultValue("false") boolean enabled,
    @DefaultValue("") String accountId,
    @DefaultValue("") String clientId,
    @DefaultValue("") String clientSecret,
    @DefaultValue("me") String importUserId,
    @DefaultValue("") String webinarImportUserId,
    @DefaultValue("https://zoom.us/oauth/token") String oauthUrl,
    @DefaultValue("https://api.zoom.us") String baseUrl,
    @DefaultValue("FMB") String defaultHostName) {}
```

`zoom/ZoomMeeting.java`:
```java
package com.acme.rsvp.zoom;

import java.time.OffsetDateTime;

/** A scheduled Zoom meeting or webinar occurrence. joinUrl stays on the server. */
public record ZoomMeeting(String id, String topic, OffsetDateTime start, OffsetDateTime end, String joinUrl) {}
```

`zoom/ZoomClient.java`:
```java
package com.acme.rsvp.zoom;

import java.time.OffsetDateTime;
import java.util.List;

import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClient;
import org.springframework.web.client.RestClientException;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

/** Zoom Server-to-Server OAuth client. Read-only: it lists scheduled sessions and nothing else. */
@Component
public class ZoomClient {

  @JsonIgnoreProperties(ignoreUnknown = true)
  record TokenResponse(@JsonProperty("access_token") String accessToken,
      @JsonProperty("expires_in") long expiresIn) {}

  @JsonIgnoreProperties(ignoreUnknown = true)
  record Item(String id, String topic, @JsonProperty("start_time") OffsetDateTime startTime,
      Integer duration, @JsonProperty("join_url") String joinUrl) {}

  @JsonIgnoreProperties(ignoreUnknown = true)
  record ListResponse(List<Item> meetings, List<Item> webinars) {}

  private final ZoomProperties props;
  private final RestClient http;
  private String cachedToken;
  private OffsetDateTime cachedUntil;

  public ZoomClient(ZoomProperties props, RestClient.Builder builder) {
    this.props = props;
    this.http = builder.build();
  }

  public synchronized String accessToken(OffsetDateTime now) {
    requireConfigured();
    if (cachedToken == null || !now.isBefore(cachedUntil)) {
      TokenResponse t;
      try {
        t = http.post()
            .uri(props.oauthUrl() + "?grant_type=account_credentials&account_id={accountId}", props.accountId())
            .headers(h -> h.setBasicAuth(props.clientId(), props.clientSecret()))
            .retrieve()
            .body(TokenResponse.class);
      } catch (RestClientException e) {
        throw new IllegalStateException("Could not sign in to Zoom. Check the Zoom credentials.");
      }
      if (t == null || t.accessToken() == null) {
        throw new IllegalStateException("Zoom did not return an access token");
      }
      cachedToken = t.accessToken();
      cachedUntil = now.plusSeconds(Math.max(0, t.expiresIn() - 60)); // refresh a minute early
    }
    return cachedToken;
  }

  public List<ZoomMeeting> listScheduled(String kind, OffsetDateTime now) {
    requireConfigured();
    boolean webinars = "webinars".equals(kind);
    String userId = webinars && !props.webinarImportUserId().isBlank()
        ? props.webinarImportUserId() : props.importUserId();
    String path = webinars
        ? "/v2/users/{userId}/webinars?page_size=300"
        : "/v2/users/{userId}/meetings?type=scheduled&page_size=300";
    String token = accessToken(now);
    ListResponse response;
    try {
      response = http.get()
          .uri(props.baseUrl() + path, userId)
          .headers(h -> h.setBearerAuth(token))
          .retrieve()
          .body(ListResponse.class);
    } catch (RestClientException e) {
      throw new IllegalStateException("Could not read the schedule from Zoom. Please try again.");
    }
    List<Item> items = response == null ? null : webinars ? response.webinars() : response.meetings();
    if (items == null) return List.of();
    return items.stream()
        .filter(i -> i.id() != null && i.startTime() != null && i.joinUrl() != null && !i.joinUrl().isBlank())
        .map(i -> new ZoomMeeting(i.id(), i.topic(), i.startTime(),
            i.startTime().plusMinutes(i.duration() == null || i.duration() <= 0 ? 60 : i.duration()),
            i.joinUrl()))
        .toList();
  }

  private void requireConfigured() {
    if (!props.enabled() || props.accountId().isBlank() || props.clientId().isBlank()
        || props.clientSecret().isBlank()) {
      throw new IllegalStateException("Zoom integration is not configured");
    }
  }
}
```

The error messages deliberately omit the underlying exception text so that no credential or URL can leak into an API response.

- [ ] **Step 4: Run the client test**

Run: `cd server && ./gradlew test --tests "*ZoomClientTest"`
Expected: PASS (3 tests).

- [ ] **Step 5: Write the failing sync test**

```java
package com.acme.rsvp.service;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.when;

import java.time.OffsetDateTime;
import java.util.List;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.bean.override.mockito.MockitoBean;

import com.acme.rsvp.dto.WebinarDtos.WebinarSummary;
import com.acme.rsvp.dto.WebinarDtos.ZoomImportRequest;
import com.acme.rsvp.dto.WebinarDtos.ZoomSyncRow;
import com.acme.rsvp.repository.WebinarRepository;
import com.acme.rsvp.support.PostgresIntegrationTest;
import com.acme.rsvp.zoom.ZoomClient;
import com.acme.rsvp.zoom.ZoomMeeting;

class WebinarZoomSyncServiceTest extends PostgresIntegrationTest {

  @Autowired WebinarZoomSyncService sync;
  @Autowired WebinarService webinarService;
  @Autowired WebinarRepository webinars;
  @MockitoBean ZoomClient zoom;

  private final OffsetDateTime start = OffsetDateTime.parse("2031-03-01T23:00:00Z");

  @Test
  void previewFlagsImportedRowsAndImportUpsertsWithoutDuplicates() {
    when(zoom.listScheduled(eq("meetings"), any())).thenReturn(List.of(
        new ZoomMeeting("555", "Majlis", start, start.plusMinutes(90), "https://zoom.us/j/555?pwd=first")));

    assertThat(sync.preview("meetings")).singleElement()
        .satisfies(r -> assertThat(r.alreadyImported()).isFalse());

    WebinarSummary created = sync.importOne(new ZoomImportRequest("meetings", "555", start, "OPEN"));
    assertThat(created.title()).isEqualTo("Majlis");
    assertThat(created.managedByZoom()).isTrue();
    assertThat(created.accessMode()).isEqualTo("OPEN");
    assertThat(created.status()).isEqualTo("DRAFT");
    assertThat(webinarService.require(created.id()).getJoinUrl()).isEqualTo("https://zoom.us/j/555?pwd=first");

    assertThat(sync.preview("meetings")).singleElement().satisfies(ZoomSyncRow::alreadyImported);

    when(zoom.listScheduled(eq("meetings"), any())).thenReturn(List.of(
        new ZoomMeeting("555", "Majlis (renamed)", start, start.plusMinutes(90), "https://zoom.us/j/555?pwd=second")));
    WebinarSummary updated = sync.importOne(new ZoomImportRequest("meetings", "555", start, null));
    assertThat(updated.id()).isEqualTo(created.id());
    assertThat(updated.title()).isEqualTo("Majlis (renamed)");
    assertThat(updated.accessMode()).isEqualTo("OPEN"); // unchanged when the request omits it
    assertThat(webinarService.require(created.id()).getJoinUrl()).endsWith("pwd=second");
  }

  @Test
  void importFailsCleanlyWhenTheSessionIsNoLongerOnZoom() {
    when(zoom.listScheduled(eq("meetings"), any())).thenReturn(List.of());
    assertThatThrownBy(() -> sync.importOne(new ZoomImportRequest("meetings", "555", start, "OPEN")))
        .isInstanceOf(IllegalStateException.class).hasMessageContaining("not found");
  }
}
```

- [ ] **Step 6: Run it to verify it fails**

Run: `cd server && ./gradlew test --tests "*WebinarZoomSyncServiceTest"`
Expected: FAIL — `WebinarZoomSyncService` does not exist.

- [ ] **Step 7: Write `service/WebinarZoomSyncService.java`**

```java
package com.acme.rsvp.service;

import java.time.OffsetDateTime;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.acme.rsvp.config.WebinarProperties;
import com.acme.rsvp.dto.WebinarDtos.WebinarSummary;
import com.acme.rsvp.dto.WebinarDtos.ZoomImportRequest;
import com.acme.rsvp.dto.WebinarDtos.ZoomSyncRow;
import com.acme.rsvp.model.Webinar;
import com.acme.rsvp.model.WebinarAccessMode;
import com.acme.rsvp.repository.WebinarRepository;
import com.acme.rsvp.zoom.ZoomClient;
import com.acme.rsvp.zoom.ZoomMeeting;
import com.acme.rsvp.zoom.ZoomProperties;

@Service
public class WebinarZoomSyncService {

  private final ZoomClient zoom;
  private final ZoomProperties zoomProps;
  private final WebinarProperties webinarProps;
  private final WebinarRepository webinars;
  private final WebinarService webinarService;

  public WebinarZoomSyncService(ZoomClient zoom, ZoomProperties zoomProps, WebinarProperties webinarProps,
      WebinarRepository webinars, WebinarService webinarService) {
    this.zoom = zoom;
    this.zoomProps = zoomProps;
    this.webinarProps = webinarProps;
    this.webinars = webinars;
    this.webinarService = webinarService;
  }

  /** What is scheduled on Zoom, without join URLs, flagged if already imported. */
  @Transactional(readOnly = true)
  public List<ZoomSyncRow> preview(String kind) {
    return zoom.listScheduled(kind, OffsetDateTime.now()).stream()
        .map(m -> new ZoomSyncRow(m.id(), m.topic(), m.start(), m.end(),
            webinars.findByZoomMeetingIdAndScheduledStart(m.id(), m.start()).isPresent()))
        .toList();
  }

  /**
   * Imports one previewed session. The join URL is re-read from Zoom here, so it never passes
   * through the browser. Importing the same session again updates the existing webinar.
   */
  @Transactional
  public WebinarSummary importOne(ZoomImportRequest req) {
    if (req.zoomMeetingId() == null || req.start() == null) {
      throw new IllegalArgumentException("Zoom session id and start time are required");
    }
    ZoomMeeting m = zoom.listScheduled(req.kind(), OffsetDateTime.now()).stream()
        .filter(x -> x.id().equals(req.zoomMeetingId()) && x.start().isEqual(req.start()))
        .findFirst()
        .orElseThrow(() -> new IllegalStateException(
            "That Zoom session was not found. Refresh the list and try again."));

    Webinar w = webinars.findByZoomMeetingIdAndScheduledStart(m.id(), m.start()).orElseGet(() -> {
      Webinar created = new Webinar();
      created.setZoomMeetingId(m.id());
      created.setHostName(zoomProps.defaultHostName());
      created.setJoinWindowBeforeMin(webinarProps.joinWindowBeforeMinutes());
      created.setJoinWindowAfterMin(webinarProps.joinWindowAfterMinutes());
      return created;
    });
    String topic = m.topic() == null || m.topic().isBlank() ? "Zoom session" : m.topic().trim();
    w.setTitle(topic.length() > 200 ? topic.substring(0, 200) : topic);
    w.setScheduledStart(m.start());
    w.setScheduledEnd(m.end());
    w.setJoinUrl(m.joinUrl());
    w.setManagedByZoom(true);
    if (req.accessMode() != null && !req.accessMode().isBlank()) {
      w.setAccessMode(WebinarAccessMode.valueOf(req.accessMode()));
    }
    return webinarService.toSummary(webinars.save(w));
  }
}
```

- [ ] **Step 8: Add the two endpoints to `WebinarAdminController.java`**

Add `WebinarZoomSyncService zoomSync` as a constructor parameter and field, add imports for `ZoomImportRequest` and `ZoomSyncRow`, then add:

```java
  @GetMapping("/zoom/preview")
  public List<ZoomSyncRow> zoomPreview(@RequestParam(defaultValue = "meetings") String kind) {
    return zoomSync.preview(kind);
  }

  @PostMapping("/zoom/import")
  public WebinarSummary zoomImport(@RequestBody ZoomImportRequest req) {
    return zoomSync.importOne(req);
  }
```

`/zoom/preview` does not clash with `/{id}`: `/{id}` is a single segment and `/zoom/preview` is two.

- [ ] **Step 9: Run the whole backend suite**

Run: `cd server && ./gradlew test`
Expected: PASS, all test classes.

- [ ] **Step 10: Commit**

```bash
git add server/src/main server/src/test
git commit -m "feat: Zoom S2S client with preview-then-import sync"
```

---

## Frontend conventions for Tasks 12–15

- Data access is `api.get/post/put/delete` from `web/src/api/client.ts`. Paths are given without the `/api` prefix. `api.get` etc. return `{ data }`. Errors are thrown as `Error` whose message is the response body, usually JSON `{"error":"…"}`; use `errMsg` from `lib/webinars.ts` to show them.
- React Query v5: `useQuery({ queryKey, queryFn })`, `useMutation({ mutationFn, onSuccess })`, `queryClient.invalidateQueries({ queryKey })`.
- Call every hook before any conditional `return`. A hook after an early return has crashed pages in this app before.
- Shared CSS classes `.input` and `.btn` exist in `web/src/styles/index.css`. Primary buttons elsewhere use `bg-gradient-to-r from-purple-600 to-blue-600 text-white`.
- The Zoom URL never reaches the browser. "Join" is a plain link to a launch endpoint; never fetch a launch endpoint with `api.get`.
- Each task ends with `cd web && npm run build` succeeding, then the stated manual check on the dev stack (`docker compose --env-file ./.env.dev -f docker-compose.dev.yml up --build`).

---

## Task 12: Member webinars page and magic-link page

**Files:**
- Create: `web/src/lib/webinars.ts`, `web/src/pages/WebinarsPage.tsx`, `web/src/pages/MagicJoinPage.tsx`
- Modify: `web/src/main.tsx`, `web/src/App.tsx`

**Interfaces:**
- Consumes: `GET /api/webinars`, `GET /api/webinars/{id}/launch`, `GET /api/webinars/public/{token}`, `GET /api/webinars/public/{token}/launch`.
- Produces: the shared types and helpers in `lib/webinars.ts` used by Tasks 13–15; routes `/webinars` and `/j/:token`.

- [ ] **Step 1: Write `web/src/lib/webinars.ts`**

```ts
export type WebinarSummary = {
  id: number;
  title: string;
  description: string | null;
  hostName: string | null;
  scheduledStart: string;
  scheduledEnd: string;
  status: 'DRAFT' | 'PUBLISHED' | 'CANCELLED';
  accessMode: 'OPEN' | 'ASSIGNED';
  managedByZoom: boolean;
  joinWindowBeforeMin: number;
  joinWindowAfterMin: number;
  hasJoinUrl: boolean;
  seatCount: number;
};

export type MemberWebinar = {
  id: number;
  title: string;
  hostName: string | null;
  scheduledStart: string;
  scheduledEnd: string;
  joinOpen: boolean;
};

export type MagicJoinInfo = {
  title: string;
  hostName: string | null;
  scheduledStart: string;
  scheduledEnd: string;
  joinOpen: boolean;
  attendeeName: string;
  attendeeIts: string;
};

export type FamilyMember = {
  id: number;
  hofPersonId: number;
  firstName: string;
  lastName: string;
  itsNumber: string;
  active: boolean;
};

export type Hof = { id: number; firstName: string; lastName: string; itsNumber: string; familyMemberCount: number };

export type FamilySeatRow = { familyMemberId: number; itsNumber: string; name: string; seatId: number | null };

export type FamilySeats = {
  personId: number;
  itsNumber: string;
  name: string;
  hof: boolean;
  ownSeatId: number | null;
  family: FamilySeatRow[];
};

export type AssignableRow = {
  personId: number;
  familyMemberId: number | null;
  itsNumber: string;
  name: string;
  hofName: string | null;
  hof: boolean;
  hasSeat: boolean;
};

export type AttendeeRow = {
  itsNumber: string;
  name: string;
  type: 'Member' | 'Family';
  hofName: string | null;
  hofIts: string | null;
  joined: boolean;
  firstJoinedAt: string | null;
  launchCount: number;
};

export type AttendanceReport = { webinar: WebinarSummary; seatCount: number; joinedCount: number; rows: AttendeeRow[] };

export type ZoomSyncRow = { zoomMeetingId: string; topic: string; start: string; end: string; alreadyImported: boolean };

/** The API throws Error(responseBody); the body is usually {"error":"..."}. */
export function errMsg(e: unknown): string {
  const raw = e instanceof Error ? e.message : String(e);
  try {
    const parsed = JSON.parse(raw);
    return parsed.error || parsed.message || raw;
  } catch {
    return raw;
  }
}

/** An ISO instant shown in the viewer's own time zone. */
export function fmtDateTime(iso: string): string {
  return new Date(iso).toLocaleString(undefined, {
    weekday: 'short', month: 'short', day: 'numeric', year: 'numeric', hour: 'numeric', minute: '2-digit',
  });
}

export function fmtTime(iso: string): string {
  return new Date(iso).toLocaleTimeString(undefined, { hour: 'numeric', minute: '2-digit' });
}

/** ISO instant -> value for <input type="datetime-local"> in local time. */
export function toLocalInput(iso?: string | null): string {
  if (!iso) return '';
  const d = new Date(iso);
  const pad = (n: number) => String(n).padStart(2, '0');
  return `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())}T${pad(d.getHours())}:${pad(d.getMinutes())}`;
}

/** <input type="datetime-local"> value (local time) -> ISO instant with offset. */
export function fromLocalInput(value: string): string {
  return new Date(value).toISOString();
}
```

- [ ] **Step 2: Write `web/src/pages/WebinarsPage.tsx`**

```tsx
import { useQuery } from '@tanstack/react-query';
import { useSearchParams } from 'react-router-dom';
import { api, API_BASE } from '../api/client';
import { MemberWebinar, fmtDateTime, fmtTime } from '../lib/webinars';

export default function WebinarsPage() {
  const [params] = useSearchParams();
  const joinError = params.get('joinError');
  const { data, isLoading } = useQuery<MemberWebinar[]>({
    queryKey: ['my-webinars'],
    queryFn: async () => (await api.get('/webinars')).data,
    refetchInterval: 30_000, // keeps the Join button in step with the join window
  });

  return (
    <div className="max-w-3xl mx-auto px-4 py-6">
      <h1 className="text-2xl font-bold text-gray-900 mb-1">Webinars</h1>
      <p className="text-sm text-gray-500 mb-6">
        Sessions you can join. The Join button becomes available shortly before the start time.
      </p>

      {joinError && (
        <div className="mb-4 rounded-lg border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-800">
          {joinError}
        </div>
      )}

      {isLoading && <div className="text-gray-500">Loading...</div>}
      {!isLoading && (data?.length ?? 0) === 0 && (
        <div className="rounded-xl border bg-white p-8 text-center text-gray-500">
          You have no upcoming webinars.
        </div>
      )}

      <div className="space-y-3">
        {data?.map((w) => (
          <div key={w.id} className="rounded-xl border-l-4 border-indigo-500 bg-white p-4 shadow-sm flex flex-wrap items-center justify-between gap-3">
            <div>
              <div className="font-semibold text-gray-900">{w.title}</div>
              {w.hostName && <div className="text-sm text-gray-500">Host: {w.hostName}</div>}
              <div className="text-sm text-gray-700 mt-1">
                {fmtDateTime(w.scheduledStart)} – {fmtTime(w.scheduledEnd)}
              </div>
            </div>
            {w.joinOpen ? (
              <a
                href={`${API_BASE}/api/webinars/${w.id}/launch`}
                target="_blank"
                rel="noopener noreferrer"
                className="rounded-lg bg-gradient-to-r from-purple-600 to-blue-600 px-5 py-2 text-sm font-semibold text-white"
              >
                Join
              </a>
            ) : (
              <span className="rounded-lg bg-gray-100 px-4 py-2 text-sm text-gray-500">Not open yet</span>
            )}
          </div>
        ))}
      </div>
    </div>
  );
}
```

- [ ] **Step 3: Write `web/src/pages/MagicJoinPage.tsx`**

```tsx
import { useQuery } from '@tanstack/react-query';
import { useParams, useSearchParams } from 'react-router-dom';
import { api, API_BASE } from '../api/client';
import { MagicJoinInfo, fmtDateTime, fmtTime } from '../lib/webinars';

export default function MagicJoinPage() {
  const { token } = useParams();
  const [params] = useSearchParams();
  const joinError = params.get('joinError');
  const { data, isLoading, isError } = useQuery<MagicJoinInfo>({
    queryKey: ['magic-join', token],
    queryFn: async () => (await api.get(`/webinars/public/${encodeURIComponent(token ?? '')}`)).data,
    retry: false,
    refetchInterval: 30_000,
  });

  if (isLoading) return <div className="text-center text-gray-500 py-12">Loading...</div>;

  if (isError || !data) {
    return (
      <div className="rounded-xl border bg-white p-8 text-center">
        <h1 className="text-xl font-semibold text-gray-900 mb-2">This link is invalid or has expired</h1>
        <p className="text-sm text-gray-600">Please ask your head of family or the coordinator for a new link.</p>
      </div>
    );
  }

  return (
    <div className="rounded-xl border bg-white p-6 shadow-sm">
      <h1 className="text-xl font-bold text-gray-900">{data.title}</h1>
      {data.hostName && <p className="text-sm text-gray-500">Host: {data.hostName}</p>}
      <p className="mt-2 text-gray-800">{fmtDateTime(data.scheduledStart)} – {fmtTime(data.scheduledEnd)}</p>

      <div className="mt-4 rounded-lg bg-indigo-50 px-4 py-3 text-sm text-indigo-900">
        Seat for <span className="font-semibold">{data.attendeeName}</span> ({data.attendeeIts}).
        If this is not you, please do not use this link.
      </div>

      {joinError && (
        <div className="mt-4 rounded-lg border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-800">{joinError}</div>
      )}

      <div className="mt-6">
        {data.joinOpen ? (
          <a
            href={`${API_BASE}/api/webinars/public/${encodeURIComponent(token ?? '')}/launch`}
            className="block rounded-lg bg-gradient-to-r from-purple-600 to-blue-600 px-5 py-3 text-center font-semibold text-white"
          >
            Join Zoom
          </a>
        ) : (
          <div className="rounded-lg bg-gray-100 px-5 py-3 text-center text-gray-600">
            Joining opens shortly before the start time. Keep this page open; the button will appear.
          </div>
        )}
      </div>
    </div>
  );
}
```

- [ ] **Step 4: Register the routes in `web/src/main.tsx`**

Add the imports next to the other page imports:
```tsx
import WebinarsPage from './pages/WebinarsPage'
import MagicJoinPage from './pages/MagicJoinPage'
```
Add to the top-level `children` array, after the `profile` route:
```tsx
      { path: 'webinars', element: <WebinarsPage /> },
      { path: 'j/:token', element: <MagicJoinPage /> },
```

- [ ] **Step 5: Wire `web/src/App.tsx`** — four edits:

1. Public routes (the magic-link page must render without a login):
```tsx
const PUBLIC_ROUTES = ['/', '/login', '/forgot-password', '/reset-password', '/j/'];
```
2. Add `'WEBINAR_COORDINATOR'` to the array in `hasAdminRole`.
3. In the `useEffect` that redirects logged-in users from `/`, give users who are neither HOF nor admin somewhere to land. Replace
```tsx
      if (user.isHof) {
        navigate('/events', { replace: true });
      } else if (hasAdminRole) {
        navigate('/admin', { replace: true });
      }
```
with
```tsx
      if (user.isHof) {
        navigate('/events', { replace: true });
      } else if (hasAdminRole) {
        navigate('/admin', { replace: true });
      } else {
        navigate('/webinars', { replace: true });
      }
```
4. Next to `isCalendarActive`, add `const isWebinarsActive = location.pathname.startsWith('/webinars');`, then inside `<nav>`, between the `{user.isHof && (…)}` block and the `{hasAdminRole && (…)}` block, add a link shown to every logged-in member:
```tsx
              <Link
                to="/webinars"
                className={`px-4 py-2 rounded-lg text-sm font-medium transition-colors ${
                  isWebinarsActive
                    ? 'bg-white/20 text-white'
                    : 'text-white/80 hover:bg-white/10 hover:text-white'
                }`}
              >
                Webinars
              </Link>
```

- [ ] **Step 6: Build**

Run: `cd web && npm run build`
Expected: build succeeds with no TypeScript errors.

- [ ] **Step 7: Manual check on the dev stack**

Insert a live open webinar directly (the admin screens come in Task 13):
```bash
docker compose --env-file ./.env.dev -f docker-compose.dev.yml exec db psql -U rsvp -d rsvp -c \
"insert into webinars (title, host_name, scheduled_start, scheduled_end, status, access_mode, join_url) values ('Dev test webinar','Host', now() + interval '5 minutes', now() + interval '65 minutes','PUBLISHED','OPEN','https://zoom.us/j/123?pwd=abc');"
```
Log in at http://localhost:5173, open "Webinars", confirm the card shows with a Join button, click it, and confirm the new tab's address is `zoom.us/j/123?pwd=abc&uname=<your ITS>%20<your name>`. Open `http://localhost:5173/j/garbage` in a private window and confirm the "invalid or has expired" message appears without a login redirect.

- [ ] **Step 8: Commit**

```bash
git add web/src
git commit -m "feat(web): member webinars page and magic-link join page"
```

---

## Task 13: Admin webinar list, create/edit, Zoom sync

**Files:**
- Create: `web/src/pages/admin/webinars/WebinarList.tsx`, `CreateWebinar.tsx`, `ZoomSyncModal.tsx`
- Modify: `web/src/main.tsx`, `web/src/pages/admin/AdminLayout.tsx`

**Interfaces:**
- Consumes: `/api/webinars/admin` CRUD, `/send-invites`, `/zoom/preview`, `/zoom/import`; types from `lib/webinars.ts`.
- Produces: routes `/admin/webinars`, `/admin/webinars/new`, `/admin/webinars/:id/edit`; links to `/admin/webinars/:id/attendees` and `/admin/webinars/:id/report` (pages arrive in Tasks 14 and 15).

- [ ] **Step 1: Write `WebinarList.tsx`**

```tsx
import { useState } from 'react';
import { Link } from 'react-router-dom';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { api } from '../../../api/client';
import { WebinarSummary, errMsg, fmtDateTime } from '../../../lib/webinars';
import ZoomSyncModal from './ZoomSyncModal';

const STATUS_STYLE: Record<string, string> = {
  PUBLISHED: 'bg-green-100 text-green-800',
  DRAFT: 'bg-amber-100 text-amber-800',
  CANCELLED: 'bg-red-100 text-red-800',
};

export default function WebinarList() {
  const qc = useQueryClient();
  const [syncOpen, setSyncOpen] = useState(false);
  const [notice, setNotice] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [confirm, setConfirm] = useState<{ kind: 'invite' | 'delete'; webinar: WebinarSummary } | null>(null);

  const { data, isLoading } = useQuery<WebinarSummary[]>({
    queryKey: ['webinars'],
    queryFn: async () => (await api.get('/webinars/admin')).data,
  });

  const sendInvites = useMutation({
    mutationFn: async (id: number) => (await api.post(`/webinars/admin/${id}/send-invites`, {})).data,
    onSuccess: (r: { sent: number; skipped: string[] }) => {
      setNotice(`Invites sent to ${r.sent} ${r.sent === 1 ? 'family' : 'families'}.`
        + (r.skipped.length ? ` Skipped: ${r.skipped.join(', ')}.` : ''));
      setError(null);
    },
    onError: (e) => setError(errMsg(e)),
  });

  const remove = useMutation({
    mutationFn: async (id: number) => api.delete(`/webinars/admin/${id}`),
    onSuccess: () => qc.invalidateQueries({ queryKey: ['webinars'] }),
    onError: (e) => setError(errMsg(e)),
  });

  const runConfirmed = () => {
    if (!confirm) return;
    if (confirm.kind === 'invite') sendInvites.mutate(confirm.webinar.id);
    else remove.mutate(confirm.webinar.id);
    setConfirm(null);
  };

  return (
    <div>
      <div className="flex flex-wrap items-center justify-between gap-3 mb-4">
        <h1 className="text-2xl font-bold text-gray-900">Webinars</h1>
        <div className="flex gap-2">
          <button onClick={() => setSyncOpen(true)} className="rounded-lg border px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50">
            Sync from Zoom
          </button>
          <Link to="/admin/webinars/new" className="rounded-lg bg-gradient-to-r from-purple-600 to-blue-600 px-4 py-2 text-sm font-semibold text-white">
            New Webinar
          </Link>
        </div>
      </div>

      {notice && <div className="mb-3 rounded-lg border border-green-200 bg-green-50 px-4 py-3 text-sm text-green-800">{notice}</div>}
      {error && <div className="mb-3 rounded-lg border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-800">{error}</div>}

      <div className="overflow-x-auto rounded-xl border bg-white">
        <table className="min-w-full text-sm">
          <thead className="bg-gray-50 text-left text-xs uppercase tracking-wide text-gray-500">
            <tr>
              <th className="px-4 py-3">Webinar</th>
              <th className="px-4 py-3">Starts</th>
              <th className="px-4 py-3">Access</th>
              <th className="px-4 py-3">Seats</th>
              <th className="px-4 py-3">Status</th>
              <th className="px-4 py-3">Actions</th>
            </tr>
          </thead>
          <tbody className="divide-y">
            {isLoading && <tr><td colSpan={6} className="px-4 py-6 text-center text-gray-500">Loading...</td></tr>}
            {!isLoading && (data?.length ?? 0) === 0 && (
              <tr><td colSpan={6} className="px-4 py-6 text-center text-gray-500">No webinars yet.</td></tr>
            )}
            {data?.map((w) => (
              <tr key={w.id}>
                <td className="px-4 py-3">
                  <div className="font-medium text-gray-900">{w.title}</div>
                  <div className="text-xs text-gray-500">
                    {w.hostName ?? ''}{w.managedByZoom ? ' · from Zoom' : ''}{!w.hasJoinUrl ? ' · no Zoom link' : ''}
                  </div>
                </td>
                <td className="px-4 py-3 whitespace-nowrap">{fmtDateTime(w.scheduledStart)}</td>
                <td className="px-4 py-3">{w.accessMode === 'OPEN' ? 'Open' : 'Assigned'}</td>
                <td className="px-4 py-3">{w.seatCount}</td>
                <td className="px-4 py-3">
                  <span className={`rounded-full px-2 py-1 text-xs font-medium ${STATUS_STYLE[w.status]}`}>
                    {w.status.charAt(0) + w.status.slice(1).toLowerCase()}
                  </span>
                </td>
                <td className="px-4 py-3 whitespace-nowrap space-x-3">
                  <Link className="text-blue-700 hover:underline" to={`/admin/webinars/${w.id}/edit`}>Edit</Link>
                  <Link className="text-blue-700 hover:underline" to={`/admin/webinars/${w.id}/attendees`}>Attendees</Link>
                  <button className="text-blue-700 hover:underline" onClick={() => setConfirm({ kind: 'invite', webinar: w })}>Send Invites</button>
                  <Link className="text-blue-700 hover:underline" to={`/admin/webinars/${w.id}/report`}>Report</Link>
                  <button className="text-red-600 hover:underline" onClick={() => setConfirm({ kind: 'delete', webinar: w })}>Delete</button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {confirm && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40 p-4">
          <div className="w-full max-w-md rounded-xl bg-white p-6">
            <h2 className="text-lg font-semibold text-gray-900">
              {confirm.kind === 'invite' ? 'Send invites' : 'Delete webinar'}
            </h2>
            <p className="mt-2 text-sm text-gray-600">
              {confirm.kind === 'invite'
                ? `Each family with a seat on "${confirm.webinar.title}" will be emailed fresh links. Any links sent or copied earlier for this webinar will stop working.`
                : `Delete "${confirm.webinar.title}" with its seats, links and attendance records? This cannot be undone.`}
            </p>
            <div className="mt-5 flex justify-end gap-2">
              <button onClick={() => setConfirm(null)} className="rounded-lg bg-gray-500 px-4 py-2 text-sm text-white">Cancel</button>
              <button onClick={runConfirmed} className={`rounded-lg px-4 py-2 text-sm font-semibold text-white ${confirm.kind === 'delete' ? 'bg-red-600' : 'bg-blue-600'}`}>
                {confirm.kind === 'invite' ? 'Send' : 'Delete'}
              </button>
            </div>
          </div>
        </div>
      )}

      {syncOpen && <ZoomSyncModal onClose={() => setSyncOpen(false)} />}
    </div>
  );
}
```

- [ ] **Step 2: Write `CreateWebinar.tsx`**

```tsx
import { useEffect, useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { api } from '../../../api/client';
import { WebinarSummary, errMsg, fromLocalInput, toLocalInput } from '../../../lib/webinars';

type Form = {
  title: string; description: string; hostName: string; start: string; end: string;
  status: string; accessMode: string; joinUrl: string; before: string; after: string;
};

const EMPTY: Form = {
  title: '', description: '', hostName: '', start: '', end: '',
  status: 'DRAFT', accessMode: 'ASSIGNED', joinUrl: '', before: '10', after: '15',
};

export default function CreateWebinar() {
  const { id } = useParams();
  const isEdit = !!id;
  const navigate = useNavigate();
  const qc = useQueryClient();
  const [form, setForm] = useState<Form>(EMPTY);
  const [error, setError] = useState<string | null>(null);

  const { data: existing } = useQuery<WebinarSummary>({
    queryKey: ['webinar', id],
    queryFn: async () => (await api.get(`/webinars/admin/${id}`)).data,
    enabled: isEdit,
  });

  useEffect(() => {
    if (!existing) return;
    setForm({
      title: existing.title,
      description: existing.description ?? '',
      hostName: existing.hostName ?? '',
      start: toLocalInput(existing.scheduledStart),
      end: toLocalInput(existing.scheduledEnd),
      status: existing.status,
      accessMode: existing.accessMode,
      joinUrl: '', // write-only: the server never sends it back
      before: String(existing.joinWindowBeforeMin),
      after: String(existing.joinWindowAfterMin),
    });
  }, [existing]);

  const save = useMutation({
    mutationFn: async () => {
      const payload = {
        title: form.title,
        description: form.description || null,
        hostName: form.hostName || null,
        scheduledStart: form.start ? fromLocalInput(form.start) : null,
        scheduledEnd: form.end ? fromLocalInput(form.end) : null,
        status: form.status,
        accessMode: form.accessMode,
        joinUrl: form.joinUrl || null,
        joinWindowBeforeMin: Number(form.before),
        joinWindowAfterMin: Number(form.after),
      };
      return isEdit ? api.put(`/webinars/admin/${id}`, payload) : api.post('/webinars/admin', payload);
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['webinars'] });
      qc.invalidateQueries({ queryKey: ['webinar', id] });
      navigate('/admin/webinars');
    },
    onError: (e) => setError(errMsg(e)),
  });

  const set = (key: keyof Form) => (e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement | HTMLTextAreaElement>) =>
    setForm({ ...form, [key]: e.target.value });

  return (
    <div className="max-w-2xl">
      <h1 className="text-2xl font-bold text-gray-900 mb-4">{isEdit ? 'Edit Webinar' : 'New Webinar'}</h1>
      {error && <div className="mb-3 rounded-lg border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-800">{error}</div>}

      <form
        className="space-y-4 rounded-xl border bg-white p-6"
        onSubmit={(e) => { e.preventDefault(); setError(null); save.mutate(); }}
      >
        <label className="block text-sm font-medium text-gray-700">Title
          <input className="input mt-1" value={form.title} onChange={set('title')} required maxLength={200} />
        </label>
        <label className="block text-sm font-medium text-gray-700">Host name
          <input className="input mt-1" value={form.hostName} onChange={set('hostName')} maxLength={200} />
        </label>
        <label className="block text-sm font-medium text-gray-700">Description
          <textarea className="input mt-1" rows={3} value={form.description} onChange={set('description')} maxLength={2000} />
        </label>
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
          <label className="block text-sm font-medium text-gray-700">Starts
            <input type="datetime-local" className="input mt-1" value={form.start} onChange={set('start')} required />
          </label>
          <label className="block text-sm font-medium text-gray-700">Ends
            <input type="datetime-local" className="input mt-1" value={form.end} onChange={set('end')} required />
          </label>
        </div>
        <label className="block text-sm font-medium text-gray-700">Zoom link
          <input
            className="input mt-1" value={form.joinUrl} onChange={set('joinUrl')} autoComplete="off"
            placeholder={isEdit && existing?.hasJoinUrl ? 'A link is saved. Leave blank to keep it.' : 'https://zoom.us/j/...'}
          />
          <span className="mt-1 block text-xs font-normal text-gray-500">
            Attendees never see this link. It is not shown again after saving.
          </span>
        </label>
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
          <label className="block text-sm font-medium text-gray-700">Who can join
            <select className="input mt-1" value={form.accessMode} onChange={set('accessMode')}>
              <option value="ASSIGNED">Only people given a seat</option>
              <option value="OPEN">Any active member (family members still need a seat)</option>
            </select>
          </label>
          <label className="block text-sm font-medium text-gray-700">Status
            <select className="input mt-1" value={form.status} onChange={set('status')}>
              <option value="DRAFT">Draft</option>
              <option value="PUBLISHED">Published</option>
              <option value="CANCELLED">Cancelled</option>
            </select>
          </label>
        </div>
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
          <label className="block text-sm font-medium text-gray-700">Join opens (minutes before start)
            <input type="number" min={0} className="input mt-1" value={form.before} onChange={set('before')} />
          </label>
          <label className="block text-sm font-medium text-gray-700">Join closes (minutes after end)
            <input type="number" min={0} className="input mt-1" value={form.after} onChange={set('after')} />
          </label>
        </div>
        <div className="flex justify-end gap-2 pt-2">
          <button type="button" onClick={() => navigate('/admin/webinars')} className="rounded-lg bg-gray-500 px-4 py-2 text-sm text-white">Cancel</button>
          <button type="submit" disabled={save.isPending} className="rounded-lg bg-gradient-to-r from-purple-600 to-blue-600 px-4 py-2 text-sm font-semibold text-white disabled:opacity-50">
            {save.isPending ? 'Saving...' : 'Save'}
          </button>
        </div>
      </form>
    </div>
  );
}
```

- [ ] **Step 3: Write `ZoomSyncModal.tsx`**

```tsx
import { useState } from 'react';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { api } from '../../../api/client';
import { ZoomSyncRow, errMsg, fmtDateTime } from '../../../lib/webinars';

export default function ZoomSyncModal({ onClose }: { onClose: () => void }) {
  const qc = useQueryClient();
  const [kind, setKind] = useState<'meetings' | 'webinars'>('meetings');
  const [accessMode, setAccessMode] = useState('ASSIGNED');
  const [error, setError] = useState<string | null>(null);

  const { data, isLoading, error: loadError } = useQuery<ZoomSyncRow[]>({
    queryKey: ['zoom-preview', kind],
    queryFn: async () => (await api.get(`/webinars/admin/zoom/preview?kind=${kind}`)).data,
    retry: false,
  });

  const importOne = useMutation({
    mutationFn: async (row: ZoomSyncRow) =>
      api.post('/webinars/admin/zoom/import', { kind, zoomMeetingId: row.zoomMeetingId, start: row.start, accessMode }),
    onSuccess: () => {
      setError(null);
      qc.invalidateQueries({ queryKey: ['zoom-preview', kind] });
      qc.invalidateQueries({ queryKey: ['webinars'] });
    },
    onError: (e) => setError(errMsg(e)),
  });

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40 p-4">
      <div className="w-full max-w-2xl rounded-xl bg-white p-6 max-h-[85vh] overflow-y-auto">
        <div className="flex items-center justify-between mb-4">
          <h2 className="text-lg font-semibold text-gray-900">Sync from Zoom</h2>
          <button onClick={onClose} className="text-gray-500 hover:text-gray-800">Close</button>
        </div>

        <div className="flex flex-wrap items-center gap-3 mb-4">
          <div className="inline-flex rounded-lg border overflow-hidden text-sm">
            {(['meetings', 'webinars'] as const).map((k) => (
              <button key={k} onClick={() => setKind(k)} className={`px-3 py-1.5 ${kind === k ? 'bg-blue-600 text-white' : 'bg-white text-gray-700'}`}>
                {k === 'meetings' ? 'Meetings' : 'Webinars'}
              </button>
            ))}
          </div>
          <label className="text-sm text-gray-700">Import as
            <select className="ml-2 rounded-lg border p-1.5" value={accessMode} onChange={(e) => setAccessMode(e.target.value)}>
              <option value="ASSIGNED">Assigned</option>
              <option value="OPEN">Open</option>
            </select>
          </label>
        </div>

        {(error || loadError) && (
          <div className="mb-3 rounded-lg border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-800">
            {error ?? errMsg(loadError)}
          </div>
        )}
        {isLoading && <div className="text-gray-500">Loading from Zoom...</div>}
        {!isLoading && !loadError && (data?.length ?? 0) === 0 && (
          <div className="text-gray-500">Nothing scheduled on Zoom.</div>
        )}

        <ul className="divide-y">
          {data?.map((row) => (
            <li key={`${row.zoomMeetingId}-${row.start}`} className="flex items-center justify-between gap-3 py-3">
              <div>
                <div className="font-medium text-gray-900">{row.topic}</div>
                <div className="text-sm text-gray-500">{fmtDateTime(row.start)}</div>
              </div>
              <button
                onClick={() => importOne.mutate(row)}
                disabled={importOne.isPending}
                className="rounded-lg border px-3 py-1.5 text-sm font-medium text-blue-700 hover:bg-blue-50 disabled:opacity-50"
              >
                {row.alreadyImported ? 'Update from Zoom' : 'Import'}
              </button>
            </li>
          ))}
        </ul>
        <p className="mt-4 text-xs text-gray-500">Imported sessions start as drafts. Publish them when ready.</p>
      </div>
    </div>
  );
}
```

- [ ] **Step 4: Register routes and navigation**

`web/src/main.tsx` — add imports with the other admin pages:
```tsx
import WebinarList from './pages/admin/webinars/WebinarList'
import CreateWebinar from './pages/admin/webinars/CreateWebinar'
```
and add to the `admin` route's `children`, after the `announcements` route:
```tsx
          { path: 'webinars', element: <WebinarList /> },
          { path: 'webinars/new', element: <CreateWebinar /> },
          { path: 'webinars/:id/edit', element: <CreateWebinar /> },
```

`web/src/pages/admin/AdminLayout.tsx` — add the helper next to `isDanaCoordinator`:
```tsx
const isWebinarCoordinator = (roles: string[]) => hasRole(roles, 'WEBINAR_COORDINATOR');
```
and in `getNavItems`, immediately before the `// Settings - admin only` block:
```tsx
  // Webinars - admin and webinar coordinators
  if (admin || isWebinarCoordinator(roles)) {
    items.push({
      label: 'Webinars',
      children: [
        { label: 'All Webinars', path: '/admin/webinars' },
        { label: 'New Webinar', path: '/admin/webinars/new' },
        { label: 'Family Members', path: '/admin/webinars/family-members' },
      ],
    });
  }
```
The Family Members path is registered in Task 14.

- [ ] **Step 5: Build and check**

Run: `cd web && npm run build`
Expected: build succeeds.

Manual: grant yourself nothing extra (you are `ADMIN`). Open Admin → Webinars → New Webinar, create a published `ASSIGNED` webinar starting in 5 minutes with Zoom link `https://zoom.us/j/456?pwd=xyz`. Confirm it lists with "Assigned", 0 seats. Edit it: the Zoom link field is empty with the "A link is saved" placeholder; save without typing a link, then confirm in the database that `join_url` is unchanged. Click "Sync from Zoom": with Zoom not configured, the modal shows "Zoom integration is not configured".

- [ ] **Step 6: Commit**

```bash
git add web/src
git commit -m "feat(web): admin webinar list, create/edit and Zoom sync"
```

---

## Task 14: Attendees screen and Family Members page

**Files:**
- Create: `web/src/pages/admin/webinars/WebinarAttendees.tsx`, `web/src/pages/admin/webinars/FamilyMembers.tsx`
- Modify: `web/src/main.tsx`, `web/src/pages/admin/settings/UserList.tsx`

**Interfaces:**
- Consumes: `/api/webinars/admin/{id}/seats`, `/assignable`, `/seats/{seatId}`, `/seats/{seatId}/link`, `/seats/copy-from/{otherId}`; `/api/admin/family-members` (`/hofs`, list, create, update, `/active`).
- Produces: routes `/admin/webinars/:id/attendees` and `/admin/webinars/family-members` (accepts `?search=` to prefill the HOF search).

- [ ] **Step 1: Write `WebinarAttendees.tsx`**

```tsx
import { useState } from 'react';
import { Link, useParams } from 'react-router-dom';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { api } from '../../../api/client';
import { AssignableRow, FamilySeats, WebinarSummary, errMsg, fmtDateTime } from '../../../lib/webinars';

type NewMember = { firstName: string; lastName: string; itsNumber: string };
const EMPTY_MEMBER: NewMember = { firstName: '', lastName: '', itsNumber: '' };

export default function WebinarAttendees() {
  const { id } = useParams();
  const qc = useQueryClient();
  const [search, setSearch] = useState('');
  const [error, setError] = useState<string | null>(null);
  const [notice, setNotice] = useState<string | null>(null);
  const [link, setLink] = useState<{ name: string; url: string } | null>(null);
  const [addingFor, setAddingFor] = useState<number | null>(null);
  const [newMember, setNewMember] = useState<NewMember>(EMPTY_MEMBER);
  const [copyFrom, setCopyFrom] = useState('');

  const { data: webinar } = useQuery<WebinarSummary>({
    queryKey: ['webinar', id],
    queryFn: async () => (await api.get(`/webinars/admin/${id}`)).data,
  });
  const { data: seats, isLoading } = useQuery<FamilySeats[]>({
    queryKey: ['webinar-seats', id],
    queryFn: async () => (await api.get(`/webinars/admin/${id}/seats`)).data,
  });
  const { data: others } = useQuery<WebinarSummary[]>({
    queryKey: ['webinars'],
    queryFn: async () => (await api.get('/webinars/admin')).data,
  });
  const term = search.trim();
  const { data: results } = useQuery<AssignableRow[]>({
    queryKey: ['webinar-assignable', id, term],
    queryFn: async () => (await api.get(`/webinars/admin/${id}/assignable?search=${encodeURIComponent(term)}`)).data,
    enabled: term.length >= 2,
  });

  const refresh = () => {
    qc.invalidateQueries({ queryKey: ['webinar-seats', id] });
    qc.invalidateQueries({ queryKey: ['webinar-assignable', id] });
    qc.invalidateQueries({ queryKey: ['webinars'] });
  };
  const fail = (e: unknown) => { setError(errMsg(e)); setNotice(null); };
  const ok = (message?: string) => { setError(null); setNotice(message ?? null); refresh(); };

  const giveSeat = useMutation({
    mutationFn: async (v: { personId: number; familyMemberId: number | null }) => api.post(`/webinars/admin/${id}/seats`, v),
    onSuccess: () => ok(),
    onError: fail,
  });
  const removeSeat = useMutation({
    mutationFn: async (seatId: number) => api.delete(`/webinars/admin/${id}/seats/${seatId}`),
    onSuccess: () => ok(),
    onError: fail,
  });
  const addMember = useMutation({
    mutationFn: async (hofPersonId: number) =>
      api.post('/admin/family-members', { hofPersonId, ...newMember, webinarId: Number(id) }),
    onSuccess: () => { setAddingFor(null); setNewMember(EMPTY_MEMBER); ok('Family member added and given a seat.'); },
    onError: fail,
  });
  const copySeats = useMutation({
    mutationFn: async () => (await api.post(`/webinars/admin/${id}/seats/copy-from/${copyFrom}`, {})).data,
    onSuccess: (r: { added: number; skipped: number }) =>
      ok(`Copied ${r.added} seat${r.added === 1 ? '' : 's'}.` + (r.skipped ? ` Skipped ${r.skipped} (already seated or no longer eligible).` : '')),
    onError: fail,
  });
  const makeLink = useMutation({
    mutationFn: async (v: { seatId: number; name: string }) => {
      const url: string = (await api.post(`/webinars/admin/${id}/seats/${v.seatId}/link`, {})).data.link;
      return { name: v.name, url };
    },
    onSuccess: async (r) => {
      setError(null);
      setLink(r);
      try { await navigator.clipboard.writeText(r.url); setNotice(`Link for ${r.name} copied.`); }
      catch { setNotice(`Link for ${r.name} is shown below. Copy it manually.`); }
    },
    onError: fail,
  });

  const seatButtons = (seatId: number, name: string) => (
    <span className="space-x-3 whitespace-nowrap">
      <span className="rounded-full bg-green-100 px-2 py-0.5 text-xs font-medium text-green-800">Seat</span>
      <button className="text-blue-700 hover:underline" onClick={() => makeLink.mutate({ seatId, name })}>Copy link</button>
      <button className="text-red-600 hover:underline" onClick={() => removeSeat.mutate(seatId)}>Remove</button>
    </span>
  );

  return (
    <div className="max-w-4xl">
      <Link to="/admin/webinars" className="text-sm text-blue-700 hover:underline">← All webinars</Link>
      <h1 className="text-2xl font-bold text-gray-900 mt-1">Attendees</h1>
      {webinar && (
        <p className="text-sm text-gray-600 mb-4">
          {webinar.title} · {fmtDateTime(webinar.scheduledStart)} · {webinar.accessMode === 'OPEN' ? 'Open' : 'Assigned'}
        </p>
      )}

      {error && <div className="mb-3 rounded-lg border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-800">{error}</div>}
      {notice && <div className="mb-3 rounded-lg border border-green-200 bg-green-50 px-4 py-3 text-sm text-green-800">{notice}</div>}
      {link && (
        <div className="mb-3 rounded-lg border bg-white px-4 py-3 text-sm">
          <div className="text-gray-700 mb-1">Link for {link.name}. Copying a new link cancels this person's previous one.</div>
          <input readOnly className="input font-mono text-xs" value={link.url} onFocus={(e) => e.target.select()} />
        </div>
      )}

      <div className="rounded-xl border bg-white p-4 mb-4">
        <label className="block text-sm font-medium text-gray-700">Find a member or family member
          <input className="input mt-1" placeholder="Name or ITS (at least 2 characters)" value={search} onChange={(e) => setSearch(e.target.value)} />
        </label>
        {term.length >= 2 && (
          <ul className="mt-2 divide-y">
            {(results?.length ?? 0) === 0 && <li className="py-2 text-sm text-gray-500">No matches.</li>}
            {results?.map((r) => (
              <li key={`${r.personId}-${r.familyMemberId ?? 'own'}`} className="flex flex-wrap items-center justify-between gap-2 py-2 text-sm">
                <span>
                  <span className="font-medium text-gray-900">{r.name}</span> <span className="text-gray-500">({r.itsNumber})</span>
                  {r.hofName && <span className="text-gray-500"> · family of {r.hofName}</span>}
                </span>
                <span className="space-x-3">
                  {r.hasSeat
                    ? <span className="text-gray-400">Has a seat</span>
                    : <button className="text-blue-700 hover:underline" onClick={() => giveSeat.mutate({ personId: r.personId, familyMemberId: r.familyMemberId })}>Give seat</button>}
                  {r.familyMemberId === null && r.hof && (
                    <button className="text-blue-700 hover:underline" onClick={() => { setAddingFor(r.personId); setNewMember(EMPTY_MEMBER); }}>Add family member</button>
                  )}
                </span>
              </li>
            ))}
          </ul>
        )}
        {addingFor !== null && !seats?.some((f) => f.personId === addingFor) && (
          <AddMemberForm value={newMember} onChange={setNewMember} pending={addMember.isPending}
            onCancel={() => setAddingFor(null)} onSave={() => addMember.mutate(addingFor)} />
        )}
      </div>

      <div className="rounded-xl border bg-white p-4 mb-4 flex flex-wrap items-end gap-3">
        <label className="text-sm font-medium text-gray-700">Copy seats from a previous webinar
          <select className="input mt-1" value={copyFrom} onChange={(e) => setCopyFrom(e.target.value)}>
            <option value="">Choose a webinar</option>
            {others?.filter((o) => String(o.id) !== id).map((o) => (
              <option key={o.id} value={o.id}>{o.title} · {fmtDateTime(o.scheduledStart)} · {o.seatCount} seats</option>
            ))}
          </select>
        </label>
        <button disabled={!copyFrom || copySeats.isPending} onClick={() => copySeats.mutate()} className="rounded-lg border px-4 py-2 text-sm font-medium text-blue-700 hover:bg-blue-50 disabled:opacity-50">
          Copy seats
        </button>
      </div>

      <div className="rounded-xl border bg-white">
        {isLoading && <div className="p-4 text-gray-500">Loading...</div>}
        {!isLoading && (seats?.length ?? 0) === 0 && <div className="p-4 text-gray-500">No one has a seat yet.</div>}
        <ul className="divide-y">
          {seats?.map((f) => (
            <li key={f.personId} className="p-4 text-sm">
              <div className="flex flex-wrap items-center justify-between gap-2">
                <span><span className="font-semibold text-gray-900">{f.name}</span> <span className="text-gray-500">({f.itsNumber})</span></span>
                {f.ownSeatId !== null
                  ? seatButtons(f.ownSeatId, f.name)
                  : <span className="space-x-3"><span className="text-gray-400">No seat</span>
                      <button className="text-blue-700 hover:underline" onClick={() => giveSeat.mutate({ personId: f.personId, familyMemberId: null })}>Give seat</button></span>}
              </div>
              <ul className="mt-2 ml-4 space-y-2 border-l pl-4">
                {f.family.map((m) => (
                  <li key={m.familyMemberId} className="flex flex-wrap items-center justify-between gap-2">
                    <span>{m.name} <span className="text-gray-500">({m.itsNumber})</span></span>
                    {m.seatId !== null
                      ? seatButtons(m.seatId, m.name)
                      : <button className="text-blue-700 hover:underline" onClick={() => giveSeat.mutate({ personId: f.personId, familyMemberId: m.familyMemberId })}>Give seat</button>}
                  </li>
                ))}
                {f.hof && addingFor !== f.personId && (
                  <li><button className="text-blue-700 hover:underline" onClick={() => { setAddingFor(f.personId); setNewMember(EMPTY_MEMBER); }}>+ Add family member</button></li>
                )}
                {addingFor === f.personId && (
                  <li><AddMemberForm value={newMember} onChange={setNewMember} pending={addMember.isPending}
                    onCancel={() => setAddingFor(null)} onSave={() => addMember.mutate(f.personId)} /></li>
                )}
              </ul>
            </li>
          ))}
        </ul>
      </div>
    </div>
  );
}

function AddMemberForm(props: {
  value: NewMember; onChange: (v: NewMember) => void; onSave: () => void; onCancel: () => void; pending: boolean;
}) {
  const { value, onChange } = props;
  const valid = value.firstName.trim() && value.lastName.trim() && /^\d{8}$/.test(value.itsNumber);
  return (
    <div className="mt-2 grid grid-cols-1 sm:grid-cols-4 gap-2 items-end">
      <input className="input" placeholder="First name" value={value.firstName} onChange={(e) => onChange({ ...value, firstName: e.target.value })} />
      <input className="input" placeholder="Last name" value={value.lastName} onChange={(e) => onChange({ ...value, lastName: e.target.value })} />
      <input className="input" placeholder="ITS (8 digits)" inputMode="numeric" maxLength={8} value={value.itsNumber}
        onChange={(e) => onChange({ ...value, itsNumber: e.target.value.replace(/\D/g, '') })} />
      <div className="flex gap-2">
        <button disabled={!valid || props.pending} onClick={props.onSave} className="rounded-lg bg-blue-600 px-3 py-2 text-sm font-semibold text-white disabled:opacity-50">Save and seat</button>
        <button onClick={props.onCancel} className="rounded-lg bg-gray-500 px-3 py-2 text-sm text-white">Cancel</button>
      </div>
    </div>
  );
}
```

- [ ] **Step 2: Write `FamilyMembers.tsx`**

```tsx
import { useState } from 'react';
import { useSearchParams } from 'react-router-dom';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { api } from '../../../api/client';
import { FamilyMember, Hof, errMsg } from '../../../lib/webinars';

type Form = { id: number | null; firstName: string; lastName: string; itsNumber: string };
const EMPTY: Form = { id: null, firstName: '', lastName: '', itsNumber: '' };

export default function FamilyMembers() {
  const qc = useQueryClient();
  const [params] = useSearchParams();
  const [search, setSearch] = useState(params.get('search') ?? '');
  const [hof, setHof] = useState<Hof | null>(null);
  const [form, setForm] = useState<Form>(EMPTY);
  const [error, setError] = useState<string | null>(null);

  const term = search.trim();
  const { data: hofs } = useQuery<Hof[]>({
    queryKey: ['family-hofs', term],
    queryFn: async () => (await api.get(`/admin/family-members/hofs?search=${encodeURIComponent(term)}`)).data,
    enabled: term.length >= 2,
  });
  const { data: members } = useQuery<FamilyMember[]>({
    queryKey: ['family-members', hof?.id],
    queryFn: async () => (await api.get(`/admin/family-members?hofPersonId=${hof!.id}`)).data,
    enabled: !!hof,
  });

  const done = () => {
    setError(null);
    setForm(EMPTY);
    qc.invalidateQueries({ queryKey: ['family-members', hof?.id] });
    qc.invalidateQueries({ queryKey: ['family-hofs'] });
  };
  const save = useMutation({
    mutationFn: async () => {
      const body = { hofPersonId: hof!.id, firstName: form.firstName, lastName: form.lastName, itsNumber: form.itsNumber };
      return form.id === null ? api.post('/admin/family-members', body) : api.put(`/admin/family-members/${form.id}`, body);
    },
    onSuccess: done,
    onError: (e) => setError(errMsg(e)),
  });
  const setActive = useMutation({
    mutationFn: async (v: { id: number; active: boolean }) => api.put(`/admin/family-members/${v.id}/active`, { active: v.active }),
    onSuccess: done,
    onError: (e) => setError(errMsg(e)),
  });

  const valid = form.firstName.trim() && form.lastName.trim() && /^\d{8}$/.test(form.itsNumber);

  return (
    <div className="max-w-3xl">
      <h1 className="text-2xl font-bold text-gray-900 mb-1">Family Members</h1>
      <p className="text-sm text-gray-500 mb-4">
        Family members saved under a head of family can be given their own webinar seats. They are not users and cannot log in.
      </p>
      {error && <div className="mb-3 rounded-lg border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-800">{error}</div>}

      <div className="rounded-xl border bg-white p-4 mb-4">
        <label className="block text-sm font-medium text-gray-700">Find a head of family
          <input className="input mt-1" placeholder="Name or ITS (at least 2 characters)" value={search} onChange={(e) => setSearch(e.target.value)} />
        </label>
        {term.length >= 2 && (
          <ul className="mt-2 divide-y">
            {(hofs?.length ?? 0) === 0 && <li className="py-2 text-sm text-gray-500">No heads of family match.</li>}
            {hofs?.map((h) => (
              <li key={h.id} className="flex items-center justify-between py-2 text-sm">
                <span><span className="font-medium text-gray-900">{h.firstName} {h.lastName}</span> <span className="text-gray-500">({h.itsNumber}) · {h.familyMemberCount} saved</span></span>
                <button className="text-blue-700 hover:underline" onClick={() => { setHof(h); setForm(EMPTY); setError(null); }}>Select</button>
              </li>
            ))}
          </ul>
        )}
      </div>

      {hof && (
        <div className="rounded-xl border bg-white p-4">
          <h2 className="font-semibold text-gray-900 mb-3">Family of {hof.firstName} {hof.lastName} ({hof.itsNumber})</h2>
          <ul className="divide-y mb-4">
            {(members?.length ?? 0) === 0 && <li className="py-2 text-sm text-gray-500">No family members saved yet.</li>}
            {members?.map((m) => (
              <li key={m.id} className="flex flex-wrap items-center justify-between gap-2 py-2 text-sm">
                <span className={m.active ? '' : 'text-gray-400 line-through'}>{m.firstName} {m.lastName} ({m.itsNumber})</span>
                <span className="space-x-3">
                  <button className="text-blue-700 hover:underline" onClick={() => setForm({ id: m.id, firstName: m.firstName, lastName: m.lastName, itsNumber: m.itsNumber })}>Edit</button>
                  <button className={m.active ? 'text-red-600 hover:underline' : 'text-green-700 hover:underline'} onClick={() => setActive.mutate({ id: m.id, active: !m.active })}>
                    {m.active ? 'Deactivate' : 'Reactivate'}
                  </button>
                </span>
              </li>
            ))}
          </ul>
          <div className="grid grid-cols-1 sm:grid-cols-4 gap-2 items-end">
            <input className="input" placeholder="First name" value={form.firstName} onChange={(e) => setForm({ ...form, firstName: e.target.value })} />
            <input className="input" placeholder="Last name" value={form.lastName} onChange={(e) => setForm({ ...form, lastName: e.target.value })} />
            <input className="input" placeholder="ITS (8 digits)" inputMode="numeric" maxLength={8} value={form.itsNumber}
              onChange={(e) => setForm({ ...form, itsNumber: e.target.value.replace(/\D/g, '') })} />
            <div className="flex gap-2">
              <button disabled={!valid || save.isPending} onClick={() => save.mutate()} className="rounded-lg bg-blue-600 px-3 py-2 text-sm font-semibold text-white disabled:opacity-50">
                {form.id === null ? 'Add' : 'Save'}
              </button>
              {form.id !== null && <button onClick={() => setForm(EMPTY)} className="rounded-lg bg-gray-500 px-3 py-2 text-sm text-white">Cancel</button>}
            </div>
          </div>
          <p className="mt-2 text-xs text-gray-500">Deactivating keeps past attendance records and cancels any live join links.</p>
        </div>
      )}
    </div>
  );
}
```

- [ ] **Step 3: Register the routes in `web/src/main.tsx`**

Imports:
```tsx
import WebinarAttendees from './pages/admin/webinars/WebinarAttendees'
import FamilyMembers from './pages/admin/webinars/FamilyMembers'
```
Add to the `admin` children, **before** `webinars/:id/edit` so the literal path is matched ahead of the parameter:
```tsx
          { path: 'webinars/family-members', element: <FamilyMembers /> },
          { path: 'webinars/:id/attendees', element: <WebinarAttendees /> },
```

- [ ] **Step 4: Link from the Users page**

In `web/src/pages/admin/settings/UserList.tsx`, add `Link` to the `react-router-dom` import (add the import line if the file has none), then add this block directly after the "Head of Family Checkbox" block (the `{/* Head of Family Checkbox */}` comment near line 599), inside the form:

```tsx
            {isEditing && formData.isHof && (
              <div className="text-sm">
                <Link
                  to={`/admin/webinars/family-members?search=${encodeURIComponent(formData.itsNumber)}`}
                  className="text-blue-700 hover:underline"
                >
                  Manage this family's members for webinars
                </Link>
              </div>
            )}
```

The spec asked for a read-only count beside this link. The Family Members page shows the count in its search result ("N saved"), so the link alone is enough here and avoids a second query on the Users page.

- [ ] **Step 5: Build and check**

Run: `cd web && npm run build`
Expected: build succeeds.

Manual, using the webinar from Task 13:
1. Attendees → search an HOF by name → "Add family member" → enter a name and an 8-digit ITS → "Save and seat". The HOF appears with "No seat" and the family member with "Seat".
2. Try adding a second family member with the ITS of an existing user: the error reads "belongs to an existing user".
3. "Copy link" on the family member: the link appears and is on the clipboard.
4. "Remove" the family member's seat, then "Give seat" again.
5. Admin → Webinars → Family Members: search the same HOF, select, edit the family member's first name, deactivate and reactivate.
6. Admin → Settings → Users → edit that HOF: the "Manage this family's members" link opens the Family Members page with the search prefilled.

- [ ] **Step 6: Commit**

```bash
git add web/src
git commit -m "feat(web): webinar attendees screen and family members page"
```

---

## Task 15: Attendance report page

**Files:**
- Create: `web/src/pages/admin/webinars/WebinarReport.tsx`
- Modify: `web/src/main.tsx`

**Interfaces:**
- Consumes: `GET /api/webinars/admin/{id}/report`; `AttendanceReport` from `lib/webinars.ts`; `xlsx`, `jspdf`, `jspdf-autotable` (already dependencies, imported the same way as in `ThaaliOrderReport.tsx`).
- Produces: route `/admin/webinars/:id/report`.

- [ ] **Step 1: Write `WebinarReport.tsx`**

```tsx
import { useMemo, useState } from 'react';
import { Link, useParams } from 'react-router-dom';
import { useQuery } from '@tanstack/react-query';
import jsPDF from 'jspdf';
import autoTable from 'jspdf-autotable';
import * as XLSX from 'xlsx';
import { api } from '../../../api/client';
import { AttendanceReport, AttendeeRow, fmtDateTime } from '../../../lib/webinars';

type Filter = 'all' | 'joined' | 'absent';
type Sort = 'family' | 'name';

export default function WebinarReport() {
  const { id } = useParams();
  const [filter, setFilter] = useState<Filter>('all');
  const [sort, setSort] = useState<Sort>('family');

  const { data, isLoading } = useQuery<AttendanceReport>({
    queryKey: ['webinar-report', id],
    queryFn: async () => (await api.get(`/webinars/admin/${id}/report`)).data,
  });

  // The server returns rows grouped by family. "name" re-sorts by attendee name.
  const rows = useMemo(() => {
    const all = (data?.rows ?? []).filter((r) => filter === 'all' || (filter === 'joined') === r.joined);
    return sort === 'name' ? [...all].sort((a, b) => a.name.localeCompare(b.name)) : all;
  }, [data, filter, sort]);

  const hofText = (r: AttendeeRow) => (r.hofName ? `${r.hofName} (${r.hofIts})` : '');
  const joinedText = (r: AttendeeRow) => (r.firstJoinedAt ? fmtDateTime(r.firstJoinedAt) : '');
  const fileBase = `webinar-attendance-${(data?.webinar.title ?? 'report').replace(/[^a-z0-9]+/gi, '-').toLowerCase()}`;

  const exportExcel = () => {
    if (!data) return;
    const sheet = XLSX.utils.json_to_sheet(rows.map((r) => ({
      ITS: r.itsNumber, Name: r.name, Type: r.type, 'Head of family': hofText(r),
      Joined: r.joined ? 'Yes' : 'No', 'First joined': joinedText(r), Launches: r.launchCount,
    })));
    const book = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(book, sheet, 'Attendance');
    XLSX.writeFile(book, `${fileBase}.xlsx`);
  };

  const exportPdf = () => {
    if (!data) return;
    const doc = new jsPDF();
    doc.setFontSize(14);
    doc.text(data.webinar.title, 14, 16);
    doc.setFontSize(10);
    doc.text(fmtDateTime(data.webinar.scheduledStart), 14, 23);
    doc.text(`Seats: ${data.seatCount}   Joined: ${data.joinedCount}   Not joined: ${data.seatCount - data.joinedCount}`, 14, 29);
    autoTable(doc, {
      startY: 35,
      head: [['ITS', 'Name', 'Type', 'Head of family', 'Joined', 'First joined', 'Launches']],
      body: rows.map((r) => [r.itsNumber, r.name, r.type, hofText(r), r.joined ? 'Yes' : 'No', joinedText(r), String(r.launchCount)]),
      styles: { fontSize: 8 },
      headStyles: { fillColor: [79, 70, 229] },
      alternateRowStyles: { fillColor: [245, 245, 250] },
    });
    doc.save(`${fileBase}.pdf`);
  };

  if (isLoading) return <div className="text-gray-500">Loading...</div>;
  if (!data) return <div className="text-gray-500">Report not available.</div>;

  const pill = (active: boolean) => `px-3 py-1.5 text-sm ${active ? 'bg-blue-600 text-white' : 'bg-white text-gray-700'}`;

  return (
    <div>
      <Link to="/admin/webinars" className="text-sm text-blue-700 hover:underline">← All webinars</Link>
      <div className="flex flex-wrap items-center justify-between gap-3 mt-1 mb-4">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">Attendance</h1>
          <p className="text-sm text-gray-600">{data.webinar.title} · {fmtDateTime(data.webinar.scheduledStart)}</p>
        </div>
        <div className="flex gap-2">
          <button onClick={exportExcel} className="rounded-lg border px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50">Export to Excel</button>
          <button onClick={exportPdf} className="rounded-lg bg-blue-600 px-4 py-2 text-sm font-semibold text-white">Export to PDF</button>
        </div>
      </div>

      <div className="grid grid-cols-3 gap-3 mb-4">
        {[['Seats', data.seatCount], ['Joined', data.joinedCount], ['Not joined', data.seatCount - data.joinedCount]].map(([label, value]) => (
          <div key={label} className="rounded-xl border bg-white p-4">
            <div className="text-xs uppercase tracking-wide text-gray-500">{label}</div>
            <div className="text-2xl font-bold text-gray-900">{value}</div>
          </div>
        ))}
      </div>

      <div className="flex flex-wrap gap-3 mb-3">
        <div className="inline-flex rounded-lg border overflow-hidden">
          <button className={pill(filter === 'all')} onClick={() => setFilter('all')}>All</button>
          <button className={pill(filter === 'joined')} onClick={() => setFilter('joined')}>Joined</button>
          <button className={pill(filter === 'absent')} onClick={() => setFilter('absent')}>Not joined</button>
        </div>
        <div className="inline-flex rounded-lg border overflow-hidden">
          <button className={pill(sort === 'family')} onClick={() => setSort('family')}>By family</button>
          <button className={pill(sort === 'name')} onClick={() => setSort('name')}>By name</button>
        </div>
      </div>

      <div className="overflow-x-auto rounded-xl border bg-white">
        <table className="min-w-full text-sm">
          <thead className="bg-gray-50 text-left text-xs uppercase tracking-wide text-gray-500">
            <tr>
              <th className="px-4 py-3">ITS</th><th className="px-4 py-3">Name</th><th className="px-4 py-3">Type</th>
              <th className="px-4 py-3">Head of family</th><th className="px-4 py-3">Joined</th>
              <th className="px-4 py-3">First joined</th><th className="px-4 py-3">Launches</th>
            </tr>
          </thead>
          <tbody className="divide-y">
            {rows.length === 0 && <tr><td colSpan={7} className="px-4 py-6 text-center text-gray-500">No attendees match.</td></tr>}
            {rows.map((r) => (
              <tr key={`${r.itsNumber}-${r.type}`}>
                <td className="px-4 py-2 font-mono">{r.itsNumber}</td>
                <td className="px-4 py-2 font-medium text-gray-900">{r.name}</td>
                <td className="px-4 py-2">{r.type}</td>
                <td className="px-4 py-2 text-gray-600">{hofText(r)}</td>
                <td className="px-4 py-2">{r.joined ? <span className="text-green-700 font-semibold">Yes</span> : <span className="text-gray-400">No</span>}</td>
                <td className="px-4 py-2 whitespace-nowrap">{joinedText(r)}</td>
                <td className="px-4 py-2">{r.launchCount}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
      <p className="mt-3 text-xs text-gray-500">
        "Joined" means the attendee opened Zoom through their own link or the portal. It does not show how long they stayed.
      </p>
    </div>
  );
}
```

- [ ] **Step 2: Register the route in `web/src/main.tsx`**

```tsx
import WebinarReport from './pages/admin/webinars/WebinarReport'
```
and in the `admin` children, next to the attendees route:
```tsx
          { path: 'webinars/:id/report', element: <WebinarReport /> },
```

- [ ] **Step 3: Build and check**

Run: `cd web && npm run build`
Expected: build succeeds.

Manual: with the Task 13 webinar inside its join window, open the family member's copied link in a private window and click "Join Zoom". Open Report: the family member's row shows Type "Family", the HOF's name and ITS under "Head of family", Joined "Yes", and Launches 1; there is no row for the HOF. Export to Excel and to PDF and open both.

- [ ] **Step 4: Commit**

```bash
git add web/src
git commit -m "feat(web): webinar attendance report with Excel and PDF export"
```

---

## Task 16: Deployment configuration, docs and end-to-end verification

**Files:**
- Modify: `docker-compose.yml`, `docker-compose.dev.yml`, `DEPLOYMENT.md`

- [ ] **Step 1: Pass the new variables to the server container**

A variable defined in `.env` but not listed under the service is not visible to the app; this has caused two production incidents (CORS, SendGrid).

`docker-compose.yml`, `server.environment`, after the `SENDGRID_FROM_NAME` line:
```yaml
      WEBINAR_DISPLAY_ZONE: ${WEBINAR_DISPLAY_ZONE:-America/New_York}
      ZOOM_ENABLED: ${ZOOM_ENABLED:-false}
      ZOOM_ACCOUNT_ID: ${ZOOM_ACCOUNT_ID:-}
      ZOOM_CLIENT_ID: ${ZOOM_CLIENT_ID:-}
      ZOOM_CLIENT_SECRET: ${ZOOM_CLIENT_SECRET:-}
      ZOOM_IMPORT_USER_ID: ${ZOOM_IMPORT_USER_ID:-me}
      ZOOM_WEBINAR_IMPORT_USER_ID: ${ZOOM_WEBINAR_IMPORT_USER_ID:-}
```

`docker-compose.dev.yml`, `server.environment`, after `CORS_ALLOWED_ORIGINS` — the same seven lines, plus `FRONTEND_URL`, which dev does not currently pass and which the magic links and launch error redirects now depend on:
```yaml
      FRONTEND_URL: ${FRONTEND_URL:-http://localhost:5173}
```

- [ ] **Step 2: Validate both compose files**

Run: `docker compose --env-file ./.env.dev -f docker-compose.dev.yml config >/dev/null && echo dev-ok`
Run: `docker compose -f docker-compose.yml config >/dev/null && echo prod-ok` (needs a `.env`; on a machine without one, skip and say so)
Expected: `dev-ok` and `prod-ok`.

- [ ] **Step 3: Document the feature in `DEPLOYMENT.md`** — add a section "Webinars and Zoom" covering:

1. Creating a Server-to-Server OAuth app in the Zoom App Marketplace under the account that owns the meetings, and the read scopes for listing meetings and webinars (use the exact scope names confirmed in Task 11).
2. The prod `.env` entries: `ZOOM_ENABLED=true`, `ZOOM_ACCOUNT_ID`, `ZOOM_CLIENT_ID`, `ZOOM_CLIENT_SECRET`, `ZOOM_IMPORT_USER_ID` (the Zoom user whose schedule is imported; `me` is the app owner), optional `ZOOM_WEBINAR_IMPORT_USER_ID`. State that these never go in git.
3. That `FRONTEND_URL` must be `https://fmb.dcjamaat.com` in prod because join links are built from it, and that `SENDGRID_ENABLED` must be `true` before sending invites.
4. That Zoom is optional: with `ZOOM_ENABLED=false`, webinars are created by hand with a pasted Zoom link and everything else works.
5. Granting the coordinator role: Admin → Settings → Users → edit the user → tick `WEBINAR_COORDINATOR`.
6. Deploy note: V37 is applied by both the `flyway` container and the app on start. If Flyway reports a checksum mismatch on an older migration, follow the existing "Flyway Checksum Mismatch Recovery" section; do not edit V37 to work around it.

- [ ] **Step 4: Full automated verification**

Run: `cd server && ./gradlew test`
Expected: all tests pass.
Run: `cd web && npm run build`
Expected: build succeeds.

- [ ] **Step 5: Secrecy check**

Run from the repo root:
```bash
grep -rn "joinUrl\|getJoinUrl" server/src/main/java
```
Expected: matches only in `model/Webinar.java`, `service/WebinarService.java` (`apply` and the `hasJoinUrl` boolean in `toSummary`), `service/WebinarLaunchService.java`, `service/WebinarZoomSyncService.java`, `zoom/ZoomClient.java`, `zoom/ZoomMeeting.java`, and the request record `SaveWebinarRequest` in `dto/WebinarDtos.java`. Any other match, in particular any response record, is a defect.

- [ ] **Step 6: End-to-end run on the dev stack**

Dev's Flyway history has had checksum drift on V21 and V27–V36. If the server fails to start with a checksum error, repair dev only (`cd server && ./gradlew flywayRepair` against the dev database), then restart. Never repair by editing migration files.

Then walk through, as an admin:
1. Give a second user `WEBINAR_COORDINATOR` and log in as them: the Admin link and the Webinars section are visible; Settings is not; `GET /api/admin/users` is still reachable only as before (this plan does not change it).
2. Create and publish an `ASSIGNED` webinar starting in 5 minutes.
3. On Attendees, add two family members under an HOF who holds no seat; give a different member their own seat.
4. Send Invites. With SendGrid disabled, read the two emails from the server log: the HOF's lists two labelled family links and no "Your link"; the member's has "Your link".
5. Open one family link in a private window: the page names that family member; "Join Zoom" redirects to Zoom with `uname=<their ITS>%20<their name>`.
6. Log in as the member: Webinars shows the card; Join redirects with their own ITS and name.
7. As the HOF: Webinars does not list this webinar.
8. Report: both joiners show "Yes"; the other family member shows "No"; no row for the HOF.
9. Copy a new link for the family member who joined; the earlier link now shows "invalid or has expired".
10. Deactivate that family member on the Family Members page; their new link stops working too.
11. Confirm on a real Zoom meeting, with a real join link, that the `uname` parameter sets and locks the display name as expected for your account's settings. If Zoom ignores it (for example for webinars that require registration), stop and report: the display-name rule would need Zoom-side registration instead, which is outside this plan.

- [ ] **Step 7: Security review**

Run `/security-review` on the branch. Confirm specifically: no response contains the join URL; tokens are stored only as hashes and are never logged; only `GET /api/webinars/public/**` is anonymous; a plain `USER` gets 403 on `/api/webinars/admin/**` and `/api/admin/family-members/**`; the join window and one-webinar rule are enforced on the server.

- [ ] **Step 8: Commit and open the PR**

```bash
git add docker-compose.yml docker-compose.dev.yml DEPLOYMENT.md
git commit -m "chore: webinar deploy configuration and docs"
git push -u origin feature/zoom-webinar-family-seats
```
Open a PR to `main` using `.github/pull_request_template.md`.

---

## Self-Review

**Spec coverage**

| Spec section | Task |
|---|---|
| 4 Data model, role seed | 2, 3 |
| 4 Family ITS rules, both directions | 5 |
| 5 Who may hold a seat; family seat without HOF seat | 6 |
| 5 Launch checks, display name, URL secrecy | 7, 10 |
| 6 Backend components | 4–11 |
| 6 Authorisation | 10 (URL rules; see deviation 1) |
| 7 API | 10, 11 |
| 8 Frontend | 12–15 |
| 9 Invite email | 8 |
| 10 Attendance report | 9, 15 |
| 11 Configuration and deployment | 4, 11, 16 |
| 12 Error handling | 4 (404), 6 (constraint race), 8 (per-email failure), 11 (Zoom off) |
| 13 Testing | every backend task; manual checks in 12–16 |

**Deliberate deviations from the spec**

1. **Role enforcement uses URL rules, not method security.** Investigation showed the server has no role enforcement at all today beyond "logged in", and that turning on method security would activate dormant annotations and lock coordinators out of existing pages. The spec allowed either mechanism.
2. **A seat cannot be removed once the attendee has joined.** Removing it would delete their join logs and erase attendance. Not in the spec; added to protect the report.
3. **Link expiry follows the webinar's current join window** rather than the stored `expires_at`, so rescheduling does not strand links.
4. **Launch failures redirect to a frontend page with a message** instead of returning a 400, because the browser navigates to launch endpoints directly.
5. **No new base-URL variable**: links use the existing `FRONTEND_URL`.
6. **Users page shows a link, not a count**; the count is on the Family Members page.
7. **`webinar_active_locks` and `webinars` use `VARCHAR`, never `TEXT`**, to keep schema validation simple.

**Known unknowns to resolve during execution**

- Zoom API field names, whether list responses include `join_url`, and scope names (Task 11 opening note).
- Whether Zoom honours `uname` for this account's meeting type (Task 16, step 6.11).
- Whether V1–V36 apply cleanly to an empty database (Task 1, step 6). They have only ever been applied incrementally.

**Type consistency:** DTO names are defined once in Task 4 and used unchanged in Tasks 5–11 and mirrored in `lib/webinars.ts` (Task 12). `giveSeat(webinarId, personId, familyMemberId)`, `ensureOwnSeat(Webinar, Person)`, `issueLink(webinarId, seatId, now)`, `launchForMember(webinarId, personId, now)`, `launchForToken(raw, now)`, `resolveToken(raw, now)` and `listScheduled(kind, now)` have the same signatures wherever they appear.

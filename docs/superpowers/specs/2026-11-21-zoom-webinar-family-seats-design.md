# Zoom Webinar Access with Family Seats — Design

**Date:** 2026-11-21
**Status:** Approved design, awaiting spec review
**Supersedes the data model in:** `docs/superpowers/plans/2026-08-03-zoom-webinar-integration.md`
**Source material:** `~/workspace/jamaat/zoom-integration/` (blueprint v1, flow-and-data document, reference Python app)

## 1. Purpose

Give FMB RSVP controlled, tracked access to Zoom webinars:

- Admins and webinar coordinators create or import Zoom sessions and decide who may join each one.
- Attendees never see the real Zoom URL. The server checks authorisation and redirects to Zoom.
- Each attendee arrives in Zoom with a locked display name of ITS number plus name.
- Family members who are in a different location from the head of family (HOF) get their own join link, without becoming application users.
- Admins can see, per webinar, exactly which members and which family members joined.

## 2. Decisions made

| Topic | Decision |
|---|---|
| Webinar model | Its own entity and table (`webinars`), with an optional link to an `Event`. Not a subtype of `Event`. |
| Family identity | Named seats: each family member has a first name, last name and ITS number. All three are required. |
| Who creates family seats | Admins and webinar coordinators only. HOFs cannot self-serve. |
| Persistence | Family members are saved once under their HOF and reused across webinars. |
| Link delivery | Sent to the HOF by email. Coordinators can also copy an individual link. |
| HOF seat | A family seat never requires the HOF to hold a seat on that webinar. |
| Attendee model | One seat row per attendee per webinar. Links, join logs and locks hang off the seat or the attendee. |

## 3. Scope

### In scope
- Webinar create, edit, delete, list.
- Access modes `OPEN` and `ASSIGNED`.
- Saved family members under an HOF.
- Seats for members and family members; copy seats from a previous webinar.
- Server-side launch redirect with locked display name, join window and one-webinar-at-a-time rule.
- Magic join links (hashed, expiring, one live link per seat).
- Invite email to the HOF or member, listing all of the family's links.
- Zoom Server-to-Server OAuth: preview, then confirmed import of scheduled meetings and webinars.
- Attendance report per webinar with Excel and PDF export.
- `WEBINAR_COORDINATOR` role.

### Out of scope
- HOF self-service for family seats.
- Email addresses or logins for family members.
- Topics or audience categories, WhatsApp message preparation, audit log, family or group attendance credit, embedded Zoom SDK.
- Attendance duration from Zoom's participant reports.
- Showing webinars in the existing Events list or calendar. The optional event link leaves room for this later.

## 4. Data model

One Flyway migration, `V37__webinar_integration.sql`. Nothing is added to the `events` table.

### `webinars`
| Column | Type | Notes |
|---|---|---|
| `id` | BIGSERIAL PK | |
| `title` | VARCHAR(200) NOT NULL | |
| `description` | TEXT | |
| `host_name` | VARCHAR(200) | |
| `scheduled_start` | TIMESTAMPTZ NOT NULL | |
| `scheduled_end` | TIMESTAMPTZ NOT NULL | Must be after start |
| `status` | VARCHAR(16) NOT NULL | `DRAFT`, `PUBLISHED`, `CANCELLED`; default `DRAFT` |
| `access_mode` | VARCHAR(16) NOT NULL | `OPEN` or `ASSIGNED`; default `ASSIGNED` |
| `join_url` | TEXT | Secret. Never serialised to any API response. |
| `zoom_meeting_id` | TEXT | Set for Zoom-imported sessions |
| `managed_by_zoom` | BOOLEAN NOT NULL | Default false |
| `join_window_before_min` | INTEGER NOT NULL | Default 10 |
| `join_window_after_min` | INTEGER NOT NULL | Default 15 |
| `event_id` | BIGINT NULL FK → `events(id)` ON DELETE SET NULL | Optional link |
| `created_at`, `updated_at` | TIMESTAMPTZ NOT NULL | |

Unique index on `(zoom_meeting_id, scheduled_start)` where `zoom_meeting_id` is not null, used as the upsert key for Zoom sync.

Only `PUBLISHED` webinars are visible to attendees or joinable.

### `family_members`
| Column | Type | Notes |
|---|---|---|
| `id` | BIGSERIAL PK | |
| `hof_person_id` | BIGINT NOT NULL FK → `persons(id)` ON DELETE CASCADE | |
| `first_name` | VARCHAR(100) NOT NULL | |
| `last_name` | VARCHAR(100) NOT NULL | |
| `its_number` | VARCHAR(32) NOT NULL UNIQUE | Exactly 8 digits, validated in the service |
| `active` | BOOLEAN NOT NULL | Default true |
| `created_at`, `updated_at` | TIMESTAMPTZ NOT NULL | |

Rules:
- The owning person must have `is_hof = true`.
- `its_number` must not match any `persons.its_number`. If it does, creation is refused with a message telling the coordinator to assign that user directly.
- Family members are deactivated, never deleted, so past reports keep their names.
- A family member is not a `Person`: no password, role, session or entry in the Users list.

A person's ITS could later be registered as a user after it was saved as a family member. Registration and admin user creation therefore also reject an ITS that exists in `family_members`, with a message to contact an admin.

### `webinar_seats`
| Column | Type | Notes |
|---|---|---|
| `id` | BIGSERIAL PK | |
| `webinar_id` | BIGINT NOT NULL FK → `webinars(id)` ON DELETE CASCADE | |
| `person_id` | BIGINT NOT NULL FK → `persons(id)` ON DELETE CASCADE | The member, or the HOF for a family seat |
| `family_member_id` | BIGINT NULL FK → `family_members(id)` ON DELETE CASCADE | Null means the member's own seat |
| `source` | VARCHAR(16) NOT NULL | `ASSIGNED` or `OPEN_AUTO` |
| `created_at` | TIMESTAMPTZ NOT NULL | |

Uniqueness, enforced with two partial unique indexes:
- `(webinar_id, person_id)` where `family_member_id` is null.
- `(webinar_id, family_member_id)` where `family_member_id` is not null.

For a family seat, `person_id` must equal the family member's `hof_person_id`.

### `webinar_join_tokens`
| Column | Type | Notes |
|---|---|---|
| `id` | UUID PK | |
| `seat_id` | BIGINT NOT NULL FK → `webinar_seats(id)` ON DELETE CASCADE | |
| `token_hash` | TEXT NOT NULL UNIQUE | SHA-256 hex of the raw token |
| `created_at`, `expires_at` | TIMESTAMPTZ NOT NULL | Expires at the end of the join window |
| `revoked_at` | TIMESTAMPTZ | |
| `last_used_at` | TIMESTAMPTZ | |
| `use_count` | INTEGER NOT NULL | Default 0 |

The raw token is 256 random bits, base64url-encoded, returned once at issue time and never stored. Issuing a new token for a seat revokes that seat's earlier tokens.

### `webinar_join_logs`
| Column | Type | Notes |
|---|---|---|
| `id` | BIGSERIAL PK | |
| `seat_id` | BIGINT NOT NULL FK → `webinar_seats(id)` ON DELETE CASCADE | |
| `joined_at` | TIMESTAMPTZ NOT NULL | |
| `source` | VARCHAR(16) NOT NULL | `PORTAL` or `MAGIC_LINK` |

### `webinar_active_locks`
| Column | Type | Notes |
|---|---|---|
| `id` | BIGSERIAL PK | |
| `person_id` | BIGINT NOT NULL FK → `persons(id)` ON DELETE CASCADE | |
| `family_member_id` | BIGINT NULL FK → `family_members(id)` ON DELETE CASCADE | |
| `webinar_id` | BIGINT NOT NULL FK → `webinars(id)` ON DELETE CASCADE | |
| `locked_until` | TIMESTAMPTZ NOT NULL | End of that webinar's join window |

One row per attendee, with the same pair of partial unique indexes as seats but without `webinar_id`. The HOF and each family member lock independently.

### Role seed
`INSERT INTO roles (name, description) VALUES ('WEBINAR_COORDINATOR', 'Manage webinars, family members, seats, and attendance reports')`, guarded so it is idempotent. The `roles` table has `name` and `description` with defaults for the remaining columns (see V10, V26).

## 5. Access and join rules

### Who may hold a seat
- A member's own seat on an `ASSIGNED` webinar: created by a coordinator.
- A member's own seat on an `OPEN` webinar: created automatically (`OPEN_AUTO`) the first time they launch, provided their account is active and not expired. HOF status is not required.
- A family seat: always created explicitly by a coordinator, on either access mode.

### Checks on every launch
The launch is refused with a 400 and a plain message if any check fails. Unknown or malformed tokens return 404.

1. For a link launch: the token exists, is not revoked and is not expired.
2. The seat still exists.
3. The seat's person has `account_status = ACTIVE` and is not expired (`Person.isExpired()`). For a family seat this is the HOF, and the family member must be active.
4. The webinar is `PUBLISHED` and the current time is within `scheduled_start − before` to `scheduled_end + after`.
5. The attendee has no unexpired lock for a different webinar.

On success, in one transaction: write a join log, upsert the attendee's lock, bump the token's `use_count` and `last_used_at` if a link was used, and return a 302 to the Zoom URL with the `uname` query parameter set (replacing any existing value).

### Display name
`ITS First Last`, using the family member's own ITS and name for a family seat, and the person's for a member seat.

### Join URL secrecy
`join_url` appears only on the entity. No DTO carries it. The edit form treats it as write-only. Zoom sync re-derives the URL on the server at import time, so it never passes through the browser.

## 6. Backend components

Package root `com.acme.rsvp`. Each unit has one job.

| Unit | Responsibility |
|---|---|
| `model/Webinar`, `WebinarStatus`, `WebinarAccessMode` | Webinar entity; `isJoinOpen(now)` |
| `model/FamilyMember` | Saved family member |
| `model/WebinarSeat`, `SeatSource` | Seat entity; `displayName()` and `attendeeIts()` resolve member versus family |
| `model/WebinarJoinToken`, `WebinarJoinLog`, `JoinSource`, `WebinarActiveLock` | Supporting entities |
| `service/FamilyMemberService` | Create, update, deactivate, list by HOF; ITS validation and uniqueness |
| `service/WebinarService` | Webinar CRUD and member-facing listing |
| `service/WebinarSeatService` | Give and remove seats, list seats grouped by family, search assignable attendees, copy seats from another webinar |
| `service/WebinarLaunchService` | The launch checks, logging, locking and URL building. Kept small because it is the security-critical path. |
| `service/WebinarInviteService` | Issue tokens, build links, send one email per family |
| `service/WebinarReportService` | Attendance aggregation |
| `security/TokenHasher` | Random token and SHA-256 hashing |
| `zoom/ZoomClient`, `ZoomProperties` | S2S OAuth token cache; list scheduled meetings and webinars |
| `service/WebinarZoomSyncService` | Preview and confirmed import |
| `web/WebinarAdminController` | `/api/webinars/admin/**` |
| `web/FamilyMemberAdminController` | `/api/admin/family-members/**` |
| `web/WebinarController` | `/api/webinars/**` for logged-in members |
| `web/WebinarPublicController` | `/api/webinars/public/**` for link holders |
| `service/EmailService` (modified) | Add `sendWebinarInvite` |

### Authorisation
- Admin and family-member endpoints: `ADMIN` or `WEBINAR_COORDINATOR`.
- Member endpoints: any authenticated, active, non-expired account.
- Public endpoints: anonymous; `WebSecurityConfig` and `SessionAuthFilter` both need the `/api/webinars/public/` prefix opened, since the filter has its own public-path list.

**Prerequisite to verify:** `@PreAuthorize` is used in `AnnouncementController` and `IngredientLookupController`, but no `@EnableMethodSecurity` was found in the codebase. If method security is in fact off, those annotations are inert today. The plan must confirm this first, then either enable method security (and check the two existing controllers still behave as intended for each role) or enforce webinar roles through URL rules in `WebSecurityConfig`. Webinar endpoints must have a test proving a plain `USER` is rejected.

## 7. API

All responses omit `joinUrl`.

### Admin — webinars (`/api/webinars/admin`)
| Method and path | Purpose |
|---|---|
| `GET /` | List webinars |
| `POST /` | Create |
| `GET /{id}` | Detail, including seat counts |
| `PUT /{id}` | Update; a blank `joinUrl` keeps the stored value |
| `DELETE /{id}` | Delete |
| `GET /{id}/seats` | Seats grouped by family: each HOF or member with their own seat state and their family members' seat states |
| `GET /{id}/assignable?search=` | Members and saved family members without a seat, matched by name or ITS |
| `POST /{id}/seats` | Give a seat. Body: `personId`, optional `familyMemberId` |
| `DELETE /{id}/seats/{seatId}` | Remove the seat and revoke its tokens |
| `POST /{id}/seats/copy-from/{otherId}` | Seat the same attendees as another webinar; skips anyone now ineligible and returns the counts |
| `POST /{id}/seats/{seatId}/link` | Issue a fresh link for one seat and return it once |
| `POST /{id}/send-invites` | Reissue all links and email each family. Returns `sent` and a list of people skipped for having no email |
| `GET /{id}/report` | Attendance report |
| `GET /zoom/preview?kind=meetings\|webinars` | Preview of scheduled Zoom items, flagged if already imported |
| `POST /zoom/import` | Import one previewed item by `zoomMeetingId` and start time |

### Admin — family members (`/api/admin/family-members`)
| Method and path | Purpose |
|---|---|
| `GET /hofs?search=` | Active HOFs matched by name or ITS; returns id, name and ITS only |
| `GET /?hofPersonId=` | List a family's members, including inactive |
| `POST /` | Create. Body: `hofPersonId`, `firstName`, `lastName`, `itsNumber`. Optional `webinarId` also gives a seat in the same transaction |
| `PUT /{id}` | Update name or ITS |
| `PUT /{id}/active` | Activate or deactivate. Deactivating revokes live tokens for that family member |

### Member (`/api/webinars`)
| Method and path | Purpose |
|---|---|
| `GET /` | Upcoming published webinars where the caller holds a seat, plus `OPEN` ones |
| `GET /{id}/launch` | 302 to Zoom after the launch checks |

### Public (`/api/webinars/public`)
| Method and path | Purpose |
|---|---|
| `GET /{token}` | Title, host, start, end, whether the join window is open, and the seat holder's name and ITS |
| `GET /{token}/launch` | 302 to Zoom after the launch checks |

## 8. Frontend

### Admin (sidebar item "Webinars", for `ADMIN` and `WEBINAR_COORDINATOR`)
- **`admin/webinars/WebinarList.tsx`** — table with Edit, Attendees, Send Invites, Report, Delete; "Sync from Zoom" opens `ZoomSyncModal.tsx`.
- **`admin/webinars/CreateWebinar.tsx`** — create and edit; write-only join URL.
- **`admin/webinars/WebinarAttendees.tsx`** — search and add; seat list grouped under each HOF; per row Give seat, Copy link, Remove; inline "+ Add family member" form (first name, last name, ITS) that saves and seats in one step; "Copy seats from a previous webinar".
- **`admin/webinars/WebinarReport.tsx`** — summary counts and the attendance table; sort by name or family; filter joined or not joined; Excel and PDF export using the existing `xlsx` and `jspdf` approach.
- **`admin/webinars/FamilyMembers.tsx`** — a standalone "Family Members" page under the Webinars nav group: search HOFs by name or ITS, then list, add, edit and deactivate that family's members. Available to admins and webinar coordinators. This is how family lists are maintained outside any particular webinar.
- **`admin/settings/UserList.tsx`** (modified) — the edit form for an HOF user shows a read-only count of family members with a link to the Family Members page for that HOF.

`WEBINAR_COORDINATOR` is added to the admin-role check in `App.tsx`, and `AdminLayout.tsx` gets the nav items. The Users page stays admin-only, so a webinar coordinator gains no access to user management. The HOF search on the Family Members page is served by `GET /api/admin/family-members/hofs?search=`, which returns only id, name and ITS of active HOFs.

### Member
- **`pages/WebinarsPage.tsx`** — a "Webinars" nav link for every logged-in member, not gated on HOF. Cards with local start time and countdown. "Join" navigates the browser to the launch endpoint so the Zoom URL never enters page state. Family seats are not shown here.

### Public
- **`pages/MagicJoinPage.tsx`** at `/j/:token` — shows the webinar and "Seat for First Last (ITS)"; "Join Zoom" is enabled inside the window; invalid or expired links show a plain message. `/j` is added to `PUBLIC_ROUTES`.

## 9. Invite email

One email per person who has at least one seat in their family on that webinar, sent to that person's email:

- Webinar title, host, and date and time.
- "Your link" if they hold their own seat.
- One labelled link per seated family member: "Fatema Kanchwala (30702040)".
- A note that each link is personal and works only during the join window.

If the HOF holds no seat, the email contains only the family links. Sending invites reissues every seat's link, which invalidates earlier emails and any previously copied links for that webinar; the confirmation dialog says so.

## 10. Attendance report

Rows are the webinar's seats left-joined to their join logs.

| Field | Source |
|---|---|
| ITS, Name | Family member if present, else person |
| Type | `Member` or `Family` |
| Head of family | For family seats: HOF name and ITS |
| Joined | At least one join log |
| First joined | Earliest log |
| Launches | Count of logs |

Summary: seats, joined, not joined. On `OPEN` webinars, members who never launched have no seat and so are not listed as absent; family seats are always listed.

The report records that an attendee launched Zoom through their own link and when. It does not record duration and cannot prove who was at the device.

## 11. Configuration and deployment

`application.yml` under `app:` — `public-base-url`, `webinar.join-window-before-minutes`, `webinar.join-window-after-minutes`, and `zoom.*` (`enabled`, `account-id`, `client-id`, `client-secret`, `import-user-id`, `webinar-import-user-id`, `oauth-url`, `base-url`, `default-host-name`).

Each new variable must be passed through explicitly in the `server` service of `docker-compose.yml`; this has been missed before for CORS and SendGrid. Zoom secrets live only in the prod `.env`. `DEPLOYMENT.md` documents the Zoom S2S app and its read scopes.

Known hazard: the dev database has had Flyway checksum drift on V21 and V27–V36. V37 may need a repair on dev before it applies.

## 12. Error handling

- Rule violations throw `IllegalStateException` or `IllegalArgumentException`, which `GlobalExceptionHandler` already maps to 400 with the message.
- Unknown tokens return 404 with no detail.
- Unique-constraint races (two coordinators seating the same attendee) are caught and returned as 400 "already has a seat", not left to surface as a 403, which is how constraint violations have appeared in this app before.
- Zoom calls when the integration is disabled return 400 "Zoom integration is not configured".
- Invite sending continues past an individual email failure and reports who was skipped.

## 13. Testing

Backend, against real Postgres via Testcontainers (added by this work; the repo has no such harness yet):

- Migration applies and the role is seeded.
- Family member: 8-digit rule, uniqueness, clash with an existing person's ITS, HOF-only owner, deactivation revokes tokens.
- Seats: both uniqueness rules; family seat without an HOF seat; family seat on an `OPEN` webinar is explicit; `OPEN_AUTO` creation on first launch; copy-from skips ineligible attendees.
- Launch: each of the five checks fails correctly; display name for member and family; `uname` replaces an existing value; HOF and family member lock independently; a disabled HOF blocks the family seat.
- Tokens: only the hash is stored; reissue revokes the old one; expiry at window end.
- Invites: one email per family; HOF without a seat gets only family links; people without email are reported.
- Report: mixed member and family rows, counts, first-joined and launch count.
- Security: a plain `USER` is rejected from admin endpoints; no response body contains `joinUrl`; public endpoints work without a session.
- Zoom client: token cache and list parsing against a mock server.

Frontend has no test harness. Each screen is verified with `npm run build` and a manual pass on the dev stack: create a webinar, add a family member under an HOF who holds no seat, send invites, join from the link in a private window, and confirm the family member appears as joined in the report.

## 14. Effect on the existing plan

The August plan's phases and tooling carry over. The following must be reworked:

- V37: new `webinars` table instead of columns on `events`; add `family_members` and `webinar_seats`; tokens and logs key on `seat_id`; locks key on attendee.
- `WebinarEvent extends Event` becomes a standalone `Webinar` entity, removing the invented registration-window values.
- "Assignments" become seats; add family member management, grouped attendees screen, copy-from, per-seat link copy.
- Launch, invite and report logic resolve the attendee through the seat.
- Add the method-security verification as an early task.

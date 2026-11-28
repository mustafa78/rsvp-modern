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

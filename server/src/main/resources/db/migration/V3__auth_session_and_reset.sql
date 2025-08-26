-- V3: Session tokens (cookie-based login) and password reset tokens

CREATE TABLE IF NOT EXISTS session_tokens (
  id UUID PRIMARY KEY,
  person_id BIGINT NOT NULL REFERENCES persons(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  expires_at TIMESTAMPTZ NOT NULL,
  revoked BOOLEAN NOT NULL DEFAULT FALSE
);
CREATE INDEX IF NOT EXISTS ix_session_active ON session_tokens(person_id, expires_at) WHERE revoked = false;

CREATE TABLE IF NOT EXISTS password_reset_tokens (
  id UUID PRIMARY KEY,
  person_id BIGINT NOT NULL REFERENCES persons(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  expires_at TIMESTAMPTZ NOT NULL,
  used_at TIMESTAMPTZ
);
CREATE INDEX IF NOT EXISTS ix_password_reset_active ON password_reset_tokens(person_id, expires_at) WHERE used_at IS NULL;

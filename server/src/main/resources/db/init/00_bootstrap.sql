-- db/init/00_bootstrap.sql
-- Runs only on first container init (empty data dir) OR can be run manually.
-- Creates role/database ⁠ rsvp ⁠ idempotently and grants basic privileges.

DO $$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'rsvp') THEN
    CREATE ROLE rsvp LOGIN PASSWORD 'rsvp';
  END IF;
END$$;

DO $$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_database WHERE datname = 'rsvp') THEN
    CREATE DATABASE rsvp OWNER rsvp;
  END IF;
END$$;

-- Grant DB-level privileges (safe to run repeatedly)
GRANT ALL PRIVILEGES ON DATABASE rsvp TO rsvp;

-- Switch to the rsvp DB to fix schema ownership/privileges
\connect rsvp

ALTER SCHEMA public OWNER TO rsvp;
GRANT ALL ON SCHEMA public TO rsvp;

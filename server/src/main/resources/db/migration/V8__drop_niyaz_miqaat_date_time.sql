-- V8: Remove redundant miqaat_date and miqaat_time columns from events table
-- These fields duplicated event_date and start_time for Niyaz events

ALTER TABLE events DROP COLUMN IF EXISTS miqaat_date;
ALTER TABLE events DROP COLUMN IF EXISTS miqaat_time;

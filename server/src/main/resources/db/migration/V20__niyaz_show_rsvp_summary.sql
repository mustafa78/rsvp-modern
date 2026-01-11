-- Add show_rsvp_summary column to events table (for Niyaz events)
-- When TRUE, the RSVP list/summary is shown on the public event detail page
-- When FALSE (default), the RSVP list is hidden (like Evite's "hide guest list")
-- This column is only meaningful for NIYAZ type events

ALTER TABLE events ADD COLUMN show_rsvp_summary BOOLEAN NOT NULL DEFAULT FALSE;

COMMENT ON COLUMN events.show_rsvp_summary IS 'For Niyaz events: when true, displays RSVP summary (count and/or list) on the public event page';

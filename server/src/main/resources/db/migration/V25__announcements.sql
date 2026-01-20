-- Announcements feature: manual announcements and event update notifications

-- Create announcements table
CREATE TABLE announcements (
    id BIGSERIAL PRIMARY KEY,
    title VARCHAR(200),
    content TEXT NOT NULL,
    type VARCHAR(20) NOT NULL, -- 'MANUAL' or 'EVENT_UPDATE'
    event_id BIGINT REFERENCES events(id) ON DELETE CASCADE,
    created_by BIGINT REFERENCES persons(id),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    expires_at TIMESTAMPTZ, -- Optional expiration
    active BOOLEAN NOT NULL DEFAULT TRUE
);

-- Create announcement_reads table to track which users have dismissed announcements
CREATE TABLE announcement_reads (
    id BIGSERIAL PRIMARY KEY,
    announcement_id BIGINT NOT NULL REFERENCES announcements(id) ON DELETE CASCADE,
    person_id BIGINT NOT NULL REFERENCES persons(id) ON DELETE CASCADE,
    read_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(announcement_id, person_id)
);

-- Add last_significant_update_at to events for "Updated" badge tracking
ALTER TABLE events ADD COLUMN last_significant_update_at TIMESTAMPTZ;

-- Create indexes for better query performance
CREATE INDEX idx_announcements_active ON announcements(active);
CREATE INDEX idx_announcements_type ON announcements(type);
CREATE INDEX idx_announcements_event_id ON announcements(event_id);
CREATE INDEX idx_announcements_created_at ON announcements(created_at DESC);
CREATE INDEX idx_announcement_reads_person_id ON announcement_reads(person_id);
CREATE INDEX idx_announcement_reads_announcement_id ON announcement_reads(announcement_id);

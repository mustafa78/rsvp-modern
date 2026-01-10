-- Add Head of Family (HOF) flag to persons table
-- HOF users can RSVP and signup for thaalis
-- Non-HOF users are admin/operational users who only access the admin panel

ALTER TABLE persons ADD COLUMN is_hof BOOLEAN NOT NULL DEFAULT TRUE;

-- Add index for potential queries filtering by is_hof
CREATE INDEX ix_person_is_hof ON persons(is_hof);

COMMENT ON COLUMN persons.is_hof IS 'Head of Family - only HOF users can RSVP/signup for events';

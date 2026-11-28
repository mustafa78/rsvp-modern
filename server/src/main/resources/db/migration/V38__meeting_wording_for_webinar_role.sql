-- The app now calls these "meetings" in everything people read. The role keeps its
-- code (WEBINAR_COORDINATOR); only the description shown on the Roles page changes.
UPDATE roles
SET description = 'Manage online meetings, family members, seats, and attendance reports'
WHERE name = 'WEBINAR_COORDINATOR';

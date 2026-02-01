-- V29: Seed roles and pickup zones from dev environment
-- This script deletes existing data and inserts fresh data

-- First, clear person_roles that reference roles we're about to delete
-- (keeping the person records intact)
DELETE FROM person_roles;

-- Clear roles
DELETE FROM roles;

-- Clear pickup_zones (persons.pickup_zone_id will become orphaned but that's OK - it's nullable)
UPDATE persons SET pickup_zone_id = NULL;
DELETE FROM pickup_zones;

-- Insert roles
INSERT INTO roles (id, name, description, active, created_at, updated_at) VALUES
(1, 'USER', 'Basic access to view events, submit RSVPs, and place Thaali orders', true, now(), now()),
(2, 'SUPER_USER', 'Elevated access to view reports and manage event data', true, now(), now()),
(3, 'ADMIN', 'Full administrative access to all system features', true, now(), now()),
(4, 'NIYAZ_COORDINATOR', 'Can create and manage Niyaz events', true, now(), now()),
(5, 'THAALI_COORDINATOR', 'Can create and manage Thaali events', true, now(), now()),
(6, 'SHOPPING_COORDINATOR', 'Can view shopping lists but not individual registrations', true, now(), now()),
(7, 'MENU_COORDINATOR', 'Can create new dishes, add new ingredients, manage chefs', true, now(), now()),
(8, 'DANA_COORDINATOR', 'Coordinate with Niyaz hosts on planning the cooking estimates based on RSVP.', true, now(), now());

-- Reset the sequence for roles
SELECT setval('roles_id_seq', (SELECT MAX(id) FROM roles));

-- Insert pickup zones
INSERT INTO pickup_zones (id, name, active, created_at) VALUES
(1, 'SELF_PICKUP_NAJMI_MASJID', true, now()),
(2, 'NORTH_POTOMAC_ROCKVILLE', true, now()),
(3, 'GERMANTOWN', true, now()),
(4, 'WASHINGTON_DC', true, now()),
(5, 'FREDERICK', true, now()),
(6, 'ELLICOTT_CITY_COLUMBIA', true, now()),
(7, 'CLARKSVILLE', true, now());

-- Reset the sequence for pickup_zones
SELECT setval('pickup_zones_id_seq', (SELECT MAX(id) FROM pickup_zones));

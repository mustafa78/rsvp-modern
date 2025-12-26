-- Remove the hardcoded role check constraint to allow dynamic roles
ALTER TABLE person_roles DROP CONSTRAINT IF EXISTS chk_person_role;

-- Increase the role column length to match the roles table
ALTER TABLE person_roles ALTER COLUMN role TYPE VARCHAR(50);

-- Add a foreign key reference to the roles table for data integrity
-- This ensures only valid roles from the roles table can be assigned
ALTER TABLE person_roles
    ADD CONSTRAINT fk_person_roles_role
    FOREIGN KEY (role) REFERENCES roles(name) ON UPDATE CASCADE;

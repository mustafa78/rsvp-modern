-- Add user type functionality for REGISTERED, STUDENT, and MEHMAAN users
-- REGISTERED: Permanent members (no expiration)
-- STUDENT: Temporary users, default 2 months expiration
-- MEHMAAN: Guest users, default 1 month expiration

-- Add user_type column with default 'REGISTERED' for existing users
ALTER TABLE persons
ADD COLUMN user_type VARCHAR(20) NOT NULL DEFAULT 'REGISTERED';

-- Add account expiration timestamp (nullable - null means no expiration)
ALTER TABLE persons
ADD COLUMN account_expires_at TIMESTAMPTZ;

-- Add check constraint for valid user types
ALTER TABLE persons
ADD CONSTRAINT chk_person_user_type
CHECK (user_type IN ('REGISTERED', 'STUDENT', 'MEHMAAN'));

-- Create index for efficient expiration queries (admin reports, cleanup jobs)
CREATE INDEX ix_person_expires_at ON persons(account_expires_at)
WHERE account_expires_at IS NOT NULL;

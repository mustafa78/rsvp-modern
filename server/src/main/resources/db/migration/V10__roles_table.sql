-- Create roles table for dynamic role management
CREATE TABLE roles (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255),
    active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Insert default roles with explicit timestamps
INSERT INTO roles (name, description, active, created_at, updated_at) VALUES
    ('USER', 'Basic access to view events, submit RSVPs, and place Thaali orders', TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('SUPER_USER', 'Elevated access to view reports and manage event data', TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('ADMIN', 'Full administrative access to all system features', TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Create index on name for faster lookups
CREATE INDEX idx_roles_name ON roles(name);
CREATE INDEX idx_roles_active ON roles(active);

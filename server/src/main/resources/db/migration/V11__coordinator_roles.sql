-- Add coordinator roles for event management
INSERT INTO roles (name, description, active, created_at, updated_at) VALUES
    ('NIYAZ_COORDINATOR', 'Can create and manage Niyaz events', TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('THAALI_COORDINATOR', 'Can create and manage Thaali events', TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

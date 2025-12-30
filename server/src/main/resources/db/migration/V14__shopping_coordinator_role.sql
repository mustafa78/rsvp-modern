-- Add Shopping Coordinator role for order/shopping management
INSERT INTO roles (name, description, active, created_at, updated_at) VALUES
    ('SHOPPING_COORDINATOR', 'Can view shopping lists but not individual registrations', TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

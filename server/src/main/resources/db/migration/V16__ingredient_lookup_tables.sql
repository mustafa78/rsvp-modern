-- Lookup tables for ingredient metadata

-- Categories (produce, meat, dairy, etc.)
CREATE TABLE ingredient_categories (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    display_order INT DEFAULT 0,
    active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Stores (Costco, Indian Store, etc.)
CREATE TABLE ingredient_stores (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    display_order INT DEFAULT 0,
    active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Storage Locations (refrigerator, freezer, pantry, etc.)
CREATE TABLE ingredient_storage_locations (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    display_order INT DEFAULT 0,
    active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Units of measure (g, kg, lb, etc.)
CREATE TABLE ingredient_units (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(32) NOT NULL UNIQUE,
    display_order INT DEFAULT 0,
    active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Seed initial data from hardcoded values

-- Categories
INSERT INTO ingredient_categories (name, display_order) VALUES
    ('produce', 1),
    ('meat', 2),
    ('dairy', 3),
    ('non-perishable', 4),
    ('frozen', 5),
    ('pantry', 6),
    ('bread', 7),
    ('spices', 8),
    ('beverages', 9);

-- Stores
INSERT INTO ingredient_stores (name, display_order) VALUES
    ('Costco', 1),
    ('Indian Store', 2),
    ('Grocery', 3),
    ('Walmart', 4),
    ('Target', 5),
    ('Online', 6);

-- Storage Locations
INSERT INTO ingredient_storage_locations (name, display_order) VALUES
    ('refrigerator', 1),
    ('freezer', 2),
    ('pantry', 3),
    ('spice rack', 4),
    ('counter', 5),
    ('dry storage', 6);

-- Units
INSERT INTO ingredient_units (name, display_order) VALUES
    ('g', 1),
    ('kg', 2),
    ('lb', 3),
    ('oz', 4),
    ('tsp', 5),
    ('tbsp', 6),
    ('cup', 7),
    ('ml', 8),
    ('l', 9),
    ('piece', 10),
    ('bunch', 11),
    ('can', 12),
    ('box', 13),
    ('bag', 14),
    ('jar', 15),
    ('handful', 16),
    ('quart', 17);

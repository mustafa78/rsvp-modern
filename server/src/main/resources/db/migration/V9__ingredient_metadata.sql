-- V9: Add metadata columns to ingredients for shopping list organization
-- category: produce, meat, non-perishable, frozen, pantry, bread
-- default_store: Costco, Indian, Indus, Grocery
-- storage_location: refrigerator, freezer, spice rack, pantry shelf, etc.

ALTER TABLE ingredients ADD COLUMN IF NOT EXISTS category VARCHAR(32);
ALTER TABLE ingredients ADD COLUMN IF NOT EXISTS default_store VARCHAR(64);
ALTER TABLE ingredients ADD COLUMN IF NOT EXISTS storage_location VARCHAR(100);

-- Create indexes for common grouping queries
CREATE INDEX IF NOT EXISTS ix_ingredients_category ON ingredients(category);
CREATE INDEX IF NOT EXISTS ix_ingredients_store ON ingredients(default_store);

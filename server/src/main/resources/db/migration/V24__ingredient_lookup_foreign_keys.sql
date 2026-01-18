-- Convert ingredients.category, default_store, storage_location from strings to foreign key references

-- Step 1: Insert any missing categories from ingredients table into ingredient_categories
INSERT INTO ingredient_categories (name, display_order)
SELECT DISTINCT i.category, 100
FROM ingredients i
WHERE i.category IS NOT NULL
  AND i.category != ''
  AND NOT EXISTS (SELECT 1 FROM ingredient_categories c WHERE LOWER(c.name) = LOWER(i.category))
ON CONFLICT (name) DO NOTHING;

-- Step 2: Insert any missing stores from ingredients table into ingredient_stores
INSERT INTO ingredient_stores (name, display_order)
SELECT DISTINCT i.default_store, 100
FROM ingredients i
WHERE i.default_store IS NOT NULL
  AND i.default_store != ''
  AND NOT EXISTS (SELECT 1 FROM ingredient_stores s WHERE LOWER(s.name) = LOWER(i.default_store))
ON CONFLICT (name) DO NOTHING;

-- Step 3: Insert any missing storage locations from ingredients table into ingredient_storage_locations
INSERT INTO ingredient_storage_locations (name, display_order)
SELECT DISTINCT i.storage_location, 100
FROM ingredients i
WHERE i.storage_location IS NOT NULL
  AND i.storage_location != ''
  AND NOT EXISTS (SELECT 1 FROM ingredient_storage_locations sl WHERE LOWER(sl.name) = LOWER(i.storage_location))
ON CONFLICT (name) DO NOTHING;

-- Step 4: Add new foreign key columns (nullable since these fields are optional)
ALTER TABLE ingredients ADD COLUMN category_id BIGINT;
ALTER TABLE ingredients ADD COLUMN store_id BIGINT;
ALTER TABLE ingredients ADD COLUMN storage_location_id BIGINT;

-- Step 5: Populate category_id from existing category string (case-insensitive match)
UPDATE ingredients i
SET category_id = c.id
FROM ingredient_categories c
WHERE i.category IS NOT NULL AND LOWER(i.category) = LOWER(c.name);

-- Step 6: Populate store_id from existing default_store string (case-insensitive match)
UPDATE ingredients i
SET store_id = s.id
FROM ingredient_stores s
WHERE i.default_store IS NOT NULL AND LOWER(i.default_store) = LOWER(s.name);

-- Step 7: Populate storage_location_id from existing storage_location string (case-insensitive match)
UPDATE ingredients i
SET storage_location_id = sl.id
FROM ingredient_storage_locations sl
WHERE i.storage_location IS NOT NULL AND LOWER(i.storage_location) = LOWER(sl.name);

-- Step 8: Add foreign key constraints (columns remain nullable for optional fields)
ALTER TABLE ingredients ADD CONSTRAINT fk_ingredient_category
    FOREIGN KEY (category_id) REFERENCES ingredient_categories(id);
ALTER TABLE ingredients ADD CONSTRAINT fk_ingredient_store
    FOREIGN KEY (store_id) REFERENCES ingredient_stores(id);
ALTER TABLE ingredients ADD CONSTRAINT fk_ingredient_storage_location
    FOREIGN KEY (storage_location_id) REFERENCES ingredient_storage_locations(id);

-- Step 9: Drop the old string columns
ALTER TABLE ingredients DROP COLUMN category;
ALTER TABLE ingredients DROP COLUMN default_store;
ALTER TABLE ingredients DROP COLUMN storage_location;

-- Step 10: Create indexes for better query performance
CREATE INDEX idx_ingredients_category_id ON ingredients(category_id);
CREATE INDEX idx_ingredients_store_id ON ingredients(store_id);
CREATE INDEX idx_ingredients_storage_location_id ON ingredients(storage_location_id);

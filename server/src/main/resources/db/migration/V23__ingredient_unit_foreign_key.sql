-- Convert ingredients.unit from string to foreign key reference to ingredient_units

-- Step 1: Insert any missing units from ingredients table into ingredient_units
INSERT INTO ingredient_units (name, display_order)
SELECT DISTINCT i.unit, 100
FROM ingredients i
WHERE i.unit IS NOT NULL
  AND i.unit != ''
  AND NOT EXISTS (SELECT 1 FROM ingredient_units u WHERE LOWER(u.name) = LOWER(i.unit))
ON CONFLICT (name) DO NOTHING;

-- Step 2: Add unit_id column
ALTER TABLE ingredients ADD COLUMN unit_id BIGINT;

-- Step 3: Populate unit_id from existing unit string (case-insensitive match)
UPDATE ingredients i
SET unit_id = u.id
FROM ingredient_units u
WHERE LOWER(i.unit) = LOWER(u.name);

-- Step 4: For any ingredients without a unit, set to a default (create 'each' if needed)
INSERT INTO ingredient_units (name, display_order) VALUES ('each', 99)
ON CONFLICT (name) DO NOTHING;

UPDATE ingredients
SET unit_id = (SELECT id FROM ingredient_units WHERE name = 'each')
WHERE unit_id IS NULL;

-- Step 5: Make unit_id NOT NULL and add foreign key constraint
ALTER TABLE ingredients ALTER COLUMN unit_id SET NOT NULL;
ALTER TABLE ingredients ADD CONSTRAINT fk_ingredient_unit
    FOREIGN KEY (unit_id) REFERENCES ingredient_units(id);

-- Step 6: Drop the old unit string column
ALTER TABLE ingredients DROP COLUMN unit;

-- Step 7: Create index for better query performance
CREATE INDEX idx_ingredients_unit_id ON ingredients(unit_id);

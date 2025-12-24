-- Menu Shopping Calculator Import
-- Generated from menu-shopping-calculator.numbers

-- ============================================
-- 1. INGREDIENTS
-- ============================================
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('BBQ sauce, Sweet Baby Ray''s brand', 'lb', 'non-perishable', 'Costco', 'refrigerator rack, bottom shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('Better than Boullion roasted vegetable', 'jar', 'pantry', 'Costco', 'refrigerator rack, middle upper shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('Frankly Fresh stuffed grape leaves', 'box', 'perishable', 'Costco', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('French baguette', 'loaf', 'bread', 'Grocery', 'dishwasher rack, bottom shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('French beans, whole fresh', 'lb', 'produce', 'Costco', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('Impossible burger', 'lb', 'meat', 'Grocery', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('King''s Hawaiian sweet rolls', '32 roll packet', 'bread', 'Costco', 'refrigerator rack, bottom shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('Kontos pita loaves', 'loaf', 'other', NULL, NULL, NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('Lahori charga masala, Shan brand', 'box', 'non-perishable', 'Indian', 'spice rack', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('Mexican blend cheese, shredded', 'lb', 'produce', 'Costco', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('Mexican chili powder', 'oz', 'non-perishable', 'Grocery', 'refrigerator rack, bottom shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('Punjabi Yakhni Pulao masala, Shan brand', 'box', 'non-perishable', 'Indian', 'spice rack', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('Sindhi biryani masala, Shan brand', 'box', 'non-perishable', 'Indian', 'spice rack', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('Sri racha chile sauce', 'lb', 'pantry', 'Korean', 'refrigerator rack, bottom shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('achaar gosht masala, Shan brand', 'box', 'non-perishable', 'Indian', 'spice rack', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('almonds, sliced', 'lb', 'non-perishable', 'Indian', 'spice rack', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('almonds, whole unsalted', 'lb', 'non-perishable', 'Costco', 'mawaid', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('apples', 'pieces', 'other', NULL, 'mawaid table', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('banana', 'pieces', 'other', NULL, 'mawaid table', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('basil leaves, fresh', 'bunch', 'produce', 'Korean', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('batura bread', 'packet', 'bread', 'Indian', 'white freezer', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('bay leaves', '100 gm', 'pantry', 'Indian', 'spice rack', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('beef, boneless nihari cut 2" pieces', 'lb', 'meat', 'Indus', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('beef, ground 85% lean (frozen)', 'lb', 'meat', 'Costco', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('beef, ground 90% lean', 'lb', 'meat', 'Indus', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('bell pepper, green', 'lb', 'produce', 'Grocery', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('bell pepper, mixed colored', 'pieces', 'produce', 'Costco', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('bell pepper, red', 'lb', 'produce', 'Grocery', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('besan (gram flour)', 'lb', 'pantry', 'Indian', 'spice rack', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('birista', 'lb', 'pantry', 'Indian', 'refrigerator rack, bottom shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('black beans, canned', 'lb', 'non-perishable', 'Costco', 'refrigerator rack, bottom shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('black beans, dry', 'lb', 'non-perishable', 'Grocery', 'spice rack', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('black eyed peas (chawla)', 'lb', 'non-perishable', 'Indian', 'refrigerator rack, bottom shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('blueberries', 'pieces', 'other', NULL, 'mawaid table', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('blueberries, fresh', 'lb', 'produce', 'Costco', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('bread crumb', 'lb', 'pantry', 'Grocery', NULL, NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('bread, Afghani style', 'loaf', 'bread', 'Indian', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('brocolli florets, fresh', 'lb', 'produce', 'Costco', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('butter chicken masala, Shan brand', 'box', 'non-perishable', 'Indian', 'spice rack', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('butter, unsalted', 'lb', 'pantry', 'Costco', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('cabbage, Napa', 'lb', 'produce', 'Grocery', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('cabbage, green', 'lb', 'produce', 'Grocery', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('cabbage, red', 'lb', 'produce', 'Grocery', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('caju pak', 'packet', 'other', NULL, 'white refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('canola oil', '96 oz bottle', 'pantry', 'Costco', 'door rack, bottom shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('capers', '32 oz jar', 'non-perishable', 'Costco', NULL, NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('cardamom, green', 'lb', 'pantry', 'Indian', 'spice rack', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('carrots, fresh baby cut', 'lb', 'produce', 'Costco', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('carrots, shredded', 'lb', 'produce', 'Grocery', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('carrots, whole fresh', 'lb', 'produce', 'Grocery', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('cashews, roasted salted', 'lb', 'non-perishable', 'Costco', 'spice rack', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('cauliflower, fresh', 'lb', 'produce', 'Grocery', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('cauliflower, frozen riced', 'lb', 'frozen', 'Costco', 'white freezer', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('celery, whole fresh', 'lb', 'produce', 'Costco', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('chana daal', 'lb', 'non-perishable', 'Indian', 'spice rack', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('chicken breast, boneless', 'lb', 'meat', 'Indus', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('chicken legs, cut into 4 pieces', 'lb', 'meat', 'Indus', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('chicken legs, whole skin off', 'lb', 'meat', 'Indus', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('chicken legs, whole with skin', 'lb', 'meat', 'Indus', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('chicken tenders, boneless breaded (halal)', 'lb', 'meat', 'Restaurant Depot', 'white freezer', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('chicken thigh, boneless', 'lb', 'meat', 'Indus', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('chicken thigh, boneless cut 1" pieces', 'lb', 'meat', 'Indus', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('chicken thigh, ground', 'lb', 'meat', 'Indus', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('chicken, whole baby skin off', 'bird', 'meat', 'Indus', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('chili garlic sauce', 'lb', 'refrigerator', 'Indian', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('chilies, green fresh', 'handful', 'produce', 'Indian', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('chilies, long green fresh', 'pieces', 'produce', 'Indian', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('chilies, red fresh (Thai)', 'handful', 'produce', 'Korean', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('chipotle chilies in adobo, Goya brand canned', 'can', 'non-perishable', 'Grocery', 'refrigerator rack, bottom shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('chironji', 'gm', 'non-perishable', 'Indian', 'spice rack', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('chola batura masala, Badshah brand', 'box', 'non-perishable', 'Indian', 'spice rack', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('chowmein hakka noodle masala, Ching''s Secret brand', 'oz', 'pantry', 'Indian', 'spice rack', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('cilantro', 'bunch', 'produce', 'Indian', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('cinnamon stick', 'gm', 'pantry', 'Indian', 'spice rack', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('coconut milk', 'can', 'non-perishable', 'Costco', 'dishwasher shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('coconut, dried shredded', 'lb', 'non-perishable', 'Indian', 'spice rack', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('collard greens', 'lb', 'produce', 'Grocery', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('coriander powder', 'lb', 'pantry', 'Indian', 'spice rack', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('corn starch', 'lb', 'pantry', 'Grocery', 'refrigerator rack, middle upper shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('corn tortilla', 'count', 'shelf', 'Grocery', 'shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('corn, frozen kernels', 'lb', 'frozen', 'Costco', 'white freezer', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('cottage cheese, 2% fat', 'lb', 'produce', 'Costco', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('cream of celery condensed soup', 'can', 'non-perishable', 'Grocery', 'refrigerator rack, bottom shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('creamed corn, canned', 'can', 'non-perishable', 'Grocery', 'refrigerator rack, bottom shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('crunchy peanut butter, JIF brand', 'lb', 'non-perishable', 'Costco', 'refrigerator rack, bottom shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('cucumber, English', '3-pack', 'produce', 'Costco', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('cumin powder', 'lb', 'pantry', 'Indian', 'spice rack', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('cumin seeds, whole', 'lb', 'pantry', 'Indian', 'spice rack', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('curry leaves, fresh', 'bunch', 'produce', 'Indian', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('dates, medjool pitted', 'lb', 'non-perishable', 'Costco', 'refrigerator rack, bottom shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('doodhi', 'lb', 'produce', 'Indian', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('dried apricots', 'lb', 'non-perishable', 'Costco', NULL, NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('drumsticks', 'lb', 'frozen', 'Indian', 'white freezer', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('egg noodles, wide', 'lb', 'non-perishable', 'Grocery', 'refrigerator rack, bottom shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('eggplant, Chinese', 'lb', 'produce', 'Grocery', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('eggplant, Indian', 'lb', 'produce', 'Indian', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('eggplant, regular', 'lb', 'produce', 'Grocery', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('eggs', 'dozen', 'produce', 'Costco', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('elbow pasta', 'lb', 'non-perishable', 'Grocery', 'dishwasher shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('fenugreek (methi) seeds', 'lb', 'pantry', 'Indian', 'spice rack', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('flour tortilla, Mission brand', '36 cnt packet', 'bread', 'Costco', 'dishwasher rack bottom shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('flour, all-purpose unbleached', 'lb', 'pantry', 'Grocery', 'spice rack', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('flour, chapatti atta', 'lb', 'non-perishable', 'Indian', 'refrigerator rack, bottom shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('fruit custard', 'packet', 'other', NULL, 'white refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('galangal, fresh', 'lb', 'produce', 'Korean', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('garam masala powder', 'lb', 'pantry', 'Indian', 'spice rack', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('garbanzo beans, canned', 'lb', 'non-perishable', 'Costco', 'prep table, bottom shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('garlic paste', 'bottle', 'pantry', 'Indian', 'stove prep table middle shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('garlic, whole peeled', 'lb', 'produce', 'Indian', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('ghee', 'lb', 'non-perishable', 'Indian', 'refrigerator rack, middle shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('ginger paste', 'bottle', 'pantry', 'Indian', 'stove prep table middle shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('goat cubes', 'lb', 'meat', 'Indus', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('goat paya', 'lb', 'meat', 'Indus', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('green peas, frozen', 'lb', 'frozen', 'Costco', 'white freezer', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('guacamole single serve mini-cup', '20 cnt pack', 'produce', 'Costco', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('gulab jamun, canned', 'can', 'non-perishable', 'Indian', 'mawaid table', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('guvar, frozen', 'lb', 'frozen', 'Indian', 'white freezer', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('hakka noodles, Ching''s Secret', 'lb', 'non-perishable', 'Indian', 'door rack, bottom shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('haleem masala, Shan brand', 'box', 'non-perishable', 'Indian', 'spice rack', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('haleem wheat, Sadaf brand', 'lb', 'non-perishable', 'Indian', 'spice rack', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('half and half', 'quart', 'produce', 'Costco', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('hamburger bun', 'bun', 'bread', 'Costco', 'dishwasher rack, bottom shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('heavy cream', 'quart', 'produce', 'Costco', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('honey', 'lb', 'pantry', 'Costco', 'refrigerator rack, middle upper shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('hummus', 'lb', 'produce', 'Costco', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('ice cream - any variey', '48 oz', 'other', NULL, 'silver freezer', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('iodized salt', 'box', 'pantry', 'Costco', 'spice rack', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('kaari masala', 'lb', 'non-perishable', NULL, 'white freezer', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('kafir lime leaves, whole', 'lb', 'produce', 'Korean', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('kashmiri red chili powder', 'lb', 'pantry', 'Indian', 'spice rack', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('kasuri methi leaves', 'lb', 'pantry', 'Indian', 'spice rack', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('kebabs, frozen (ready-made)', 'box', 'frozen', 'Indus', 'silver freezer', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('ketchup', 'lb', 'pantry', 'Costco', 'refrigerator rack, bottom shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('kewra essence', 'bottle', 'pantry', 'Indian', 'stove prep table bottom shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('kharak', 'lb', 'non-perishable', 'Indian', 'mawaid', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('kheer', 'lb', 'other', NULL, NULL, NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('kidney beans, light dry', 'lb', 'non-perishable', 'Grocery', 'spice rack', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('kielbasa sausage', 'lb', 'meat', 'Indus', 'silver freezer', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('kiwi', 'pieces', 'other', NULL, 'mawaid table', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('kokum', 'lb', 'produce', 'Indian', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('korma masala, Shan brand', 'box', 'non-perishable', 'Indian', 'spice rack', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('kulfi - kesar/kesar pista/other similar', 'unit', 'other', NULL, 'silver freezer', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('kulfi - mango', 'unit', 'other', NULL, 'silver freezer', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('lasagne noodles', 'lb', 'non-perishable', 'Grocery', 'dishwasher shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('lasagne noodles, no-boil variety', 'lb', 'non-perishable', 'Grocery', 'refrigerator rack, bottom shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('lavash wrap, Damascus Bakeries brand', 'packet', 'bread', 'Costco', 'dishwasher rack, bottom shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('lemon juice', 'bottle', 'pantry', 'Costco', 'refrigerator rack, middle shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('lemongrass, whole stalk', 'stalk', 'produce', 'Korean', 'dishwasher rack, bottom shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('lemons, whole fresh', 'lb', 'produce', 'Costco', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('lettuce, Romaine whole head', '6-pack', 'produce', 'Costco', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('lettuce, Spring Mix (mixed greens)', 'box', 'refrigerator', 'Costco', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('lime juice', 'bottle', 'non-perishable', 'Grocery', 'refrigerator rack, bottom shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('limes, fresh', 'count', 'shelf', 'Costco', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('liver, goat', 'lb', 'meat', 'Indus', 'silver freezer', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('macaroni elbow pasta', 'lb', 'non-perishable', 'Grocery', 'refrigerator rack, bottom shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('masoor daal, brown (whole)', 'lb', 'non-perishable', 'Indian', 'spice rack', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('masoor daal, red', 'lb', 'non-perishable', 'Indian', 'spice rack', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('mayonaise', 'lb', 'refrigerator', 'Grocery', 'refrigerator rack, bottom shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('methi bhaji leaves, frozen', 'lb', 'frozen', 'Indian', 'freezer', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('milk, 1% fat', 'gallon', 'produce', 'Costco', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('milk, evaporated canned', 'can', 'non-perishable', 'Costco', 'mawaid table', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('milk, sweetened condensed canned', 'can', 'non-perishable', 'Costco', 'mawaid table', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('milk, whole fat', 'gallon', 'produce', 'Costco', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('mint leaves, fresh', 'bunch', 'produce', 'Indian', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('mixed vegetables, frozen', 'lb', 'frozen', 'Costco', 'white freezer', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('moong daal halwa', 'packet', 'other', NULL, 'white refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('moong daal, whole (green)', 'lb', 'non-perishable', 'Indian', 'spice rack', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('moong daal, yellow (split)', 'lb', 'non-perishable', 'Indian', 'spice rack', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('mozzarella cheese, shredded', 'lb', 'produce', 'Costco', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('mushroom soup, canned condensed', 'lb', 'non-perishable', 'Grocery', 'dishwasher shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('mushrooms, white fresh', 'lb', 'produce', 'Costco', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('mustard, yellow spicy', 'lb', 'non-perishable', 'Grocery', 'spice rack', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('naan, tandoori style (frozen)', 'packet', 'frozen', 'Indian', 'white freezer', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('okra, frozen cut', 'lb', 'frozen', 'Indian', 'white freezer', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('olive oil, extra virgin', 'bottle', 'shelf', 'Costco', 'shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('olives, black sliced', 'can', 'non-perishable', 'Costco', 'refrigerator rack, bottom shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('olives, green pimento stuffed', 'lb', 'non-perishable', 'Costco', 'refrigerator rack, bottom shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('onions, red', 'lb', 'produce', 'Grocery', 'door rack, lower middle shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('onions, yellow', 'lb', 'produce', 'Costco', 'door rack, lower middle shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('orange', 'pieces', 'other', NULL, 'mawaid table', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('oregano leaves, dried McCormick brand', 'bottles', 'pantry', 'Costco', 'refrigerator rack, middle upper shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('paneer', 'lb', 'produce', 'Indian', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('paratha, frozen', 'packet', 'frozen', 'Indian', 'white freezer', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('parmesan cheese, grated', 'lb', 'produce', 'Costco', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('parsley, fresh', 'bunch', 'produce', 'Grocery', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('pasta sauce, Ragu brand', 'quart', 'non-perishable', 'Costco', 'dishwasher shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('patvelia, frozen', 'lb', 'frozen', 'Indian', 'white freezer', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('peach', 'pieces', 'other', NULL, 'mawaid table', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('peanuts, salted roasted', 'lb', 'non-perishable', 'Costco', 'spice rack', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('pear', 'pieces', 'other', NULL, 'mawaid table', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('peas and carrots, frozen diced', 'lb', 'frozen', 'Grocery', 'white freezer', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('penne pasta', 'lb', 'non-perishable', 'Costco', 'dishwasher shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('persimmons, pomegranates, or other uncut fruit', 'pieces', 'other', NULL, 'mawaid table', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('pesto, Kirkland Signature', 'bottle', 'perishable', 'Costco', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('pineapple chunks, canned', 'lb', 'non-perishable', 'Grocery', 'refrigerator rack, bottom shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('pinto beans, dry', 'lb', 'non-perishable', 'Grocery', 'spice rack', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('pistachios, whole shelled', 'lb', 'non-perishable', 'Indian', 'spice rack', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('plum', 'pieces', 'other', NULL, 'mawaid table', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('potato bread, Martin''s brand', 'loaf', 'bread', 'Costco', 'dishwasher rack, bottom shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('potatoes, baby size', 'lb', 'produce', 'Costco', 'dishwasher rack, bottom shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('potatoes, red or yellow', 'lb', 'produce', 'Costco', 'door rack, 2nd shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('pound cake', 'loaf', 'bread', 'Costco', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('raisins, golden', 'lb', 'non-perishable', 'Indian', 'mawaid', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('ravioli, spinach and mozzarella (Pasta Prima brand)', 'lb', 'frozen', 'Costco', 'silver freezer', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('red chilies, whole dried', 'lb', 'pantry', 'Indian', 'spice rack', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('rice, basmati', 'lb', 'non-perishable', 'Costco', 'door rack, top shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('rice, jasmine', 'lb', 'non-perishable', 'Costco', 'door rack, top shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('ricotta cheese, whole milk', 'lb', 'produce', 'Costco', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('roti packet, frozen', 'packet', 'frozen', 'Indian', 'white freezer', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('rotini pasta', 'lb', 'non-perishable', 'Grocery', 'refrigerator rack, bottom shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('saffron', 'gm', 'pantry', 'Indian', 'spice rack', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('scallions, fresh (green onions)', 'bunch', 'produce', 'Grocery', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('semolina, fine (sooji)', 'lb', 'refrigerator', 'Indian', 'refrigerator rack, bottom shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('sesame oil', 'bottle', 'pantry', 'Grocery', 'refrigerator rack, bottom shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('sesame seeds', 'lb', 'non-perishable', 'Costco', 'refrigerator rack, 2nd shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('sev vermicelli', 'lb', 'non-perishable', 'Indian', 'refrigerator rack, bottom shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('sev zarda', '24 oz bottle', 'other', NULL, 'mawaid table', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('sheermal', 'packet', 'bread', 'Indian', 'white freezer', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('snack nut variety pack, Kirkland Signature', '30-cnt box', 'non-perishable', 'Costco', 'dishwasher rack, bottom shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('sooji halwa', 'packet', 'other', NULL, 'white refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('sour cream', 'lb', 'perishable', 'Costco', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('soy sauce', 'bottle', 'pantry', 'Grocery', 'refrigerator rack, bottom shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('spinach leaves, fresh', 'lb', 'produce', 'Costco', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('spinach pakoda, frozen, Deep brand', 'packet', 'frozen', 'Indian', 'white freezer', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('spinach, frozen chopped', 'lb', 'frozen', 'Grocery', 'white freezer', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('spinach, frozen cut', 'lb', 'frozen', 'Grocery', 'white freezer', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('sugar', 'lb', 'non-perishable', 'Costco', 'spice rack', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('sweet potatoes', 'lb', 'produce', 'Grocery', 'refrigerator rack, bottom shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('tahini paste', 'lb', 'non-perishable', 'Indian', 'stove prep table middle shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('tamarind paste', 'bottle', 'pantry', 'Indian', 'refrigerator rack, middle upper shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('tandoori masala, Shan brand', 'box', 'non-perishable', 'Indian', 'refrigerator rack, bottom shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('tapenade', 'lb', 'other', NULL, NULL, NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('tea, Wagh Bakhri or Safari brand', '100 cnt box', 'non-perishable', 'Indian', 'mawaid table', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('thyme leaves, dried McCormick brand', 'bottles', 'pantry', 'Costco', 'refrigerator rack, middle upper shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('tindoora, frozen', 'lb', 'frozen', 'Indian', 'white freezer', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('tofu, extra firm', 'lb', 'produce', 'Grocery', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('tomato paste, canned', 'lb', 'non-perishable', 'Costco', 'stove prep table bottom shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('tomato sauce, canned', 'lb', 'non-perishable', 'Costco', 'stove prep table shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('tomato, fresh', 'lb', 'produce', 'Costco', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('tomatoes, canned crushed', 'lb', 'non-perishable', 'Costco', 'stove prep table middle shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('tomatoes, canned diced', 'lb', 'non-perishable', 'Costco', 'stove prep table middle shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('tomatoes, cherry fresh', 'lb', 'produce', 'Grocery', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('toor daal', 'lb', 'non-perishable', 'Indian', 'spice rack', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('toor daal, oily', 'lb', 'non-perishable', 'Indian', 'refrigerator rack, top shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('tres leches caramel cake', 'cake', 'produce', 'Costco', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('tuxedo cake', 'cake', 'produce', 'Costco', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('tzaziki dip, Hannah brand', 'lb', 'perishable', 'Costco', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('urad daal, whole (black)', 'lb', 'non-perishable', 'Indian', 'spice rack', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('vanilla pudding mix, Jello instant', 'box', 'non-perishable', 'Grocery', 'refrigerator rack, bottom shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('vegetarian oyster sauce', 'bottle', 'non-perishable', 'Korean', 'refrigerator rack, bottom shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('vinegar, white', 'quart', 'pantry', 'Grocery', 'refrigerator rack, bottom shelf', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('water', 'gallon', 'pantry', NULL, NULL, NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('yogurt, greek 0% fat', 'lb', 'produce', 'Costco', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('yogurt, lowfat', 'lb', 'produce', 'Costco', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('yogurt, whole milk', 'lb', 'produce', 'Costco', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();
INSERT INTO ingredients (name, unit, category, default_store, storage_location, created_at, updated_at)
VALUES ('zucchini', 'lb', 'produce', 'Grocery', 'refrigerator', NOW(), NOW())
ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category, default_store = EXCLUDED.default_store, storage_location = EXCLUDED.storage_location, updated_at = NOW();

-- ============================================
-- 2. DISHES
-- ============================================
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('Afghani Chicken', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('Afghani bread', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('Black bean Veggie Pesto Chicken Pasta', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('Cauliflower steaks w/mashed and picatta sauce', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('Chinese chicken stirfry', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('Falafel with rice', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('General - kheer', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('General - pantry spice', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('General - pantry staple', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('General Items - stock adjust', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('Hyderbadi baingan', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('Impossible chili', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('Indian-style chicken fried rice', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('Indonesian rendang curry (goat)', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('Lahori chicken', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('Mexican mac and cheese', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('Mideast Chicken and Rice', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('North Indian egg curry', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('SEHORI butter', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('SEHORI eggs', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('SEHORI roti', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('SEHORI tea items', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('South Indian egg curry', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('Sri Lankan chicken curry', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('Swedish meatballs', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('Thai beef stirfry', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('Thai chicken stirfry', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('Thai green curry (chicken)', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('West African peanut chicken curry', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('achaar chicken', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('achaar gosht', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('akhni pulao', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('aloo baingan', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('aloo bhajhi', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('aloo gobi', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('aloo matar', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('aloo tarkari (rai wala)', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('baked chicken tenders', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('baked herb chicken', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('batura bread', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('bbq chicken legs', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('bbq chicken sliders', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('beef chili', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('bhinda masala', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('blueberry poundcake trifle', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('bread - baguette', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('bread - lavash', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('bread - naan', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('bread - paratha', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('bread - sheermal', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('butter chicken', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('cabbage stirfry', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('cauliflower tikka masala', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('chana doodhi', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('chana gosht', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('chawla pulao', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('chicen kaari', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('chicken biryani', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('chicken corn soup', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('chicken curry', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('chicken fajita', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('chicken gumbo', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('chicken hakka noodles', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('chicken jalfrezi', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('chicken kheema bhaji', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('chicken khurdhi', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('chicken lagan ni seekh', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('chicken legs in peanut sauce', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('chicken legs in red sauce', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('chicken legs in white sauce', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('chicken manchurian', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('chicken pasta casserole', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('chicken picatta', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('chicken quesadilla', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('chicken tikka masala', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('chicken tortilla soup w/rice and beans', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('chicken vegetable pulao', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('chicken veggie casserole', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('chickoli', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('chilli chicken', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('chola batura', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('coleslaw', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('creamy pasta primavera', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('daal chawal', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('daal gosht', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('daal makhani', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('daal tadka (daal fry)', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('dahi kadhi', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('dhaba chana dal fry', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('doodhi tarkari', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('dum aloo', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('fruit - apple', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('fruit - banana', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('fruit - blueberries', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('fruit - buyer''s choice', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('fruit - kiwi', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('fruit - orange', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('fruit - peach', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('fruit - pear', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('fruit - plum', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('general - tres leches caramel cake', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('gosht biryani', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('gosht kaari', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('gosht ni tarkari', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('green bean aloo curry', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('green chicken (caju ni murghi)', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('green gosht (caju ni gosht)', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('guvar aloo', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('haleem', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('haleem - garnish', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('handi chicken', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('ice cream', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('kaleji ni tarkari', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('karahi chicken', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('kebabs, frozen (ready-made)', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('khajoor', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('kheema aloo matar', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('kheema bhaji', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('kheema biryani', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('kheema khichdhi', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('kheema patvelia', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('kheema pau', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('khichdi', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('kofta curry', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('kushari', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('lagan ni seekh', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('lasagne with meat sauce', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('lemon olive chicken tagine', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('malvi gosht', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('masoor daal', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('masoor daal w/gosht', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('masoor pulao', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('matar paneer', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('mattho', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('mezze - hummus', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('mezze - pita bread', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('mezze - stuffed grape leaves', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('mezze - tapenade', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('mezze - tzaziki', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('mithaas - caju pak', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('mithaas - fruit custard', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('mithaas - gajar nu halwo', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('mithaas - gulab jamun', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('mithaas - ice cream', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('mithaas - sev zarda', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('mithaas - sooji halwa', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('mithaas - tuxedo cake', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('mixed daal', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('mixed daal gosht', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('mixed vegetable tarkari', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('moong pulao', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('mutton khurdhi', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('mutton paya', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('navratan korma', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('nihari', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('nut packet', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('olives, green', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('orange masoor daal', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('paav bhaji', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('paav bhaji - buns', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('pakorda', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('palak paneer', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('palida', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('panang curry (chicken)', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('paneer jalfrezi', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('paneer karahi', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('paneer makhani', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('paneer tikka masala', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('pesto ravioli', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('pollo guisado', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('punjabi baingan ka bharta', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('raita', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('ravioli Florentine', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('salad - English cumbers', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('salad - Romaine lettuce', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('salad - bell peppers', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('salad - carrots', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('salad - mixed greens lettuce', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('shahi tukda', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('sheer khurma', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('sloppy joes', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('sooji halwa', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('sweet and sour chicken over rice', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('tahini sauce', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('tandoori chicken legs', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('tindoora fry', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('tomato soup', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('vegetable biryani', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('vegetable hakka noodles', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('vegetable korma', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('vegetable lasagne', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('white rice', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('whole chicken in white sauce', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;
INSERT INTO dishes (name, description, default_quarts_per_thaali_unit, active, created_at)
VALUES ('whole chicken keit (red sauce)', NULL, 1.00, true, NOW())
ON CONFLICT (name) DO NOTHING;

-- ============================================
-- 3. DISH INGREDIENTS
-- ============================================
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.35
FROM dishes d, ingredients i
WHERE d.name = 'Afghani Chicken' AND i.name = 'chicken legs, cut into 4 pieces'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'Afghani Chicken' AND i.name = 'cashews, roasted salted'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.03
FROM dishes d, ingredients i
WHERE d.name = 'Afghani Chicken' AND i.name = 'almonds, whole unsalted'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.4
FROM dishes d, ingredients i
WHERE d.name = 'Afghani Chicken' AND i.name = 'yogurt, whole milk'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.12
FROM dishes d, ingredients i
WHERE d.name = 'Afghani Chicken' AND i.name = 'half and half'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'Afghani Chicken' AND i.name = 'chilies, green fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.167
FROM dishes d, ingredients i
WHERE d.name = 'Afghani bread' AND i.name = 'bread, Afghani style'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.5
FROM dishes d, ingredients i
WHERE d.name = 'Black bean Veggie Pesto Chicken Pasta' AND i.name = 'chicken thigh, boneless cut 1" pieces'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.45
FROM dishes d, ingredients i
WHERE d.name = 'Black bean Veggie Pesto Chicken Pasta' AND i.name = 'rotini pasta'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'Black bean Veggie Pesto Chicken Pasta' AND i.name = 'pesto, Kirkland Signature'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.4
FROM dishes d, ingredients i
WHERE d.name = 'Black bean Veggie Pesto Chicken Pasta' AND i.name = 'bell pepper, mixed colored'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.4
FROM dishes d, ingredients i
WHERE d.name = 'Black bean Veggie Pesto Chicken Pasta' AND i.name = 'black beans, canned'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'Black bean Veggie Pesto Chicken Pasta' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.3
FROM dishes d, ingredients i
WHERE d.name = 'Black bean Veggie Pesto Chicken Pasta' AND i.name = 'corn, frozen kernels'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'Black bean Veggie Pesto Chicken Pasta' AND i.name = 'chili garlic sauce'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'Black bean Veggie Pesto Chicken Pasta' AND i.name = 'mozzarella cheese, shredded'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.3
FROM dishes d, ingredients i
WHERE d.name = 'Cauliflower steaks w/mashed and picatta sauce' AND i.name = 'cauliflower, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'Cauliflower steaks w/mashed and picatta sauce' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.04
FROM dishes d, ingredients i
WHERE d.name = 'Cauliflower steaks w/mashed and picatta sauce' AND i.name = 'capers'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.12
FROM dishes d, ingredients i
WHERE d.name = 'Cauliflower steaks w/mashed and picatta sauce' AND i.name = 'parsley, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.6
FROM dishes d, ingredients i
WHERE d.name = 'Cauliflower steaks w/mashed and picatta sauce' AND i.name = 'potatoes, red or yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'Cauliflower steaks w/mashed and picatta sauce' AND i.name = 'garlic, whole peeled'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'Cauliflower steaks w/mashed and picatta sauce' AND i.name = 'butter, unsalted'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.02
FROM dishes d, ingredients i
WHERE d.name = 'Cauliflower steaks w/mashed and picatta sauce' AND i.name = 'lemon juice'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'Cauliflower steaks w/mashed and picatta sauce' AND i.name = 'Better than Boullion roasted vegetable'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.04
FROM dishes d, ingredients i
WHERE d.name = 'Cauliflower steaks w/mashed and picatta sauce' AND i.name = 'milk, whole fat'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'Chinese chicken stirfry' AND i.name = 'chicken thigh, boneless cut 1" pieces'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.4
FROM dishes d, ingredients i
WHERE d.name = 'Chinese chicken stirfry' AND i.name = 'brocolli florets, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.25
FROM dishes d, ingredients i
WHERE d.name = 'Chinese chicken stirfry' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'Chinese chicken stirfry' AND i.name = 'mushrooms, white fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'Chinese chicken stirfry' AND i.name = 'carrots, fresh baby cut'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'Chinese chicken stirfry' AND i.name = 'bell pepper, green'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'Chinese chicken stirfry' AND i.name = 'bell pepper, mixed colored'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'Chinese chicken stirfry' AND i.name = 'honey'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'Chinese chicken stirfry' AND i.name = 'soy sauce'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'Chinese chicken stirfry' AND i.name = 'corn starch'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.04
FROM dishes d, ingredients i
WHERE d.name = 'Chinese chicken stirfry' AND i.name = 'sesame oil'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.45
FROM dishes d, ingredients i
WHERE d.name = 'Falafel with rice' AND i.name = 'rice, basmati'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.2
FROM dishes d, ingredients i
WHERE d.name = 'Falafel with rice' AND i.name = 'chicken thigh, boneless'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'Falafel with rice' AND i.name = 'lettuce, Romaine whole head'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'Falafel with rice' AND i.name = 'tomato, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'Falafel with rice' AND i.name = 'oregano leaves, dried McCormick brand'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'Falafel with rice' AND i.name = 'thyme leaves, dried McCormick brand'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'Falafel with rice' AND i.name = 'Better than Boullion roasted vegetable'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'Falafel with rice' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'General - kheer' AND i.name = 'kheer'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'General - pantry spice' AND i.name = 'cardamom, green'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'General - pantry spice' AND i.name = 'coriander powder'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'General - pantry spice' AND i.name = 'cumin powder'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'General - pantry spice' AND i.name = 'bay leaves'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'General - pantry spice' AND i.name = 'kasuri methi leaves'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'General - pantry spice' AND i.name = 'kashmiri red chili powder'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 200.0
FROM dishes d, ingredients i
WHERE d.name = 'General - pantry spice' AND i.name = 'cinnamon stick'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'General - pantry spice' AND i.name = 'garam masala powder'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'General - pantry spice' AND i.name = 'cumin seeds, whole'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'General - pantry staple' AND i.name = 'corn starch'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'General - pantry staple' AND i.name = 'canola oil'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'General - pantry staple' AND i.name = 'ginger paste'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'General - pantry staple' AND i.name = 'iodized salt'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'General - pantry staple' AND i.name = 'lemon juice'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'General - pantry staple' AND i.name = 'garlic paste'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'General - pantry staple' AND i.name = 'birista'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'General - pantry staple' AND i.name = 'soy sauce'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'General - pantry staple' AND i.name = 'curry leaves, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'General - pantry staple' AND i.name = 'tomatoes, canned diced'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'General - pantry staple' AND i.name = 'Sri racha chile sauce'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'General - pantry staple' AND i.name = 'garlic, whole peeled'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'General - pantry staple' AND i.name = 'tomatoes, canned crushed'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'General - pantry staple' AND i.name = 'sesame oil'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'General - pantry staple' AND i.name = 'besan (gram flour)'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'General - pantry staple' AND i.name = 'fenugreek (methi) seeds'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'General - pantry staple' AND i.name = 'red chilies, whole dried'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'General - pantry staple' AND i.name = 'saffron'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'General Items - stock adjust' AND i.name = 'potatoes, red or yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.75
FROM dishes d, ingredients i
WHERE d.name = 'Hyderbadi baingan' AND i.name = 'eggplant, Indian'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'Hyderbadi baingan' AND i.name = 'peanuts, salted roasted'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.02
FROM dishes d, ingredients i
WHERE d.name = 'Hyderbadi baingan' AND i.name = 'coconut, dried shredded'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.02
FROM dishes d, ingredients i
WHERE d.name = 'Hyderbadi baingan' AND i.name = 'sesame seeds'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.08
FROM dishes d, ingredients i
WHERE d.name = 'Hyderbadi baingan' AND i.name = 'tamarind paste'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'Hyderbadi baingan' AND i.name = 'chilies, long green fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.08
FROM dishes d, ingredients i
WHERE d.name = 'Hyderbadi baingan' AND i.name = 'coconut milk'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.3
FROM dishes d, ingredients i
WHERE d.name = 'Impossible chili' AND i.name = 'Impossible burger'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.12
FROM dishes d, ingredients i
WHERE d.name = 'Impossible chili' AND i.name = 'black beans, dry'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.12
FROM dishes d, ingredients i
WHERE d.name = 'Impossible chili' AND i.name = 'pinto beans, dry'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.12
FROM dishes d, ingredients i
WHERE d.name = 'Impossible chili' AND i.name = 'kidney beans, light dry'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'Impossible chili' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'Impossible chili' AND i.name = 'chipotle chilies in adobo, Goya brand canned'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.075
FROM dishes d, ingredients i
WHERE d.name = 'Impossible chili' AND i.name = 'bell pepper, green'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'Impossible chili' AND i.name = 'tomato paste, canned'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.25
FROM dishes d, ingredients i
WHERE d.name = 'Impossible chili' AND i.name = 'Mexican chili powder'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.3
FROM dishes d, ingredients i
WHERE d.name = 'Indian-style chicken fried rice' AND i.name = 'chicken thigh, boneless cut 1" pieces'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.55
FROM dishes d, ingredients i
WHERE d.name = 'Indian-style chicken fried rice' AND i.name = 'rice, basmati'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.35
FROM dishes d, ingredients i
WHERE d.name = 'Indian-style chicken fried rice' AND i.name = 'bell pepper, mixed colored'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.25
FROM dishes d, ingredients i
WHERE d.name = 'Indian-style chicken fried rice' AND i.name = 'scallions, fresh (green onions)'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'Indian-style chicken fried rice' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'Indian-style chicken fried rice' AND i.name = 'peas and carrots, frozen diced'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'Indian-style chicken fried rice' AND i.name = 'eggs'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'Indonesian rendang curry (goat)' AND i.name = 'goat cubes'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.25
FROM dishes d, ingredients i
WHERE d.name = 'Indonesian rendang curry (goat)' AND i.name = 'coconut milk'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'Indonesian rendang curry (goat)' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.04
FROM dishes d, ingredients i
WHERE d.name = 'Indonesian rendang curry (goat)' AND i.name = 'galangal, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'Indonesian rendang curry (goat)' AND i.name = 'lemongrass, whole stalk'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.02
FROM dishes d, ingredients i
WHERE d.name = 'Indonesian rendang curry (goat)' AND i.name = 'kafir lime leaves, whole'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.06
FROM dishes d, ingredients i
WHERE d.name = 'Indonesian rendang curry (goat)' AND i.name = 'basil leaves, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'Indonesian rendang curry (goat)' AND i.name = 'chilies, green fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'Indonesian rendang curry (goat)' AND i.name = 'lime juice'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'Indonesian rendang curry (goat)' AND i.name = 'garlic, whole peeled'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.08
FROM dishes d, ingredients i
WHERE d.name = 'Lahori chicken' AND i.name = 'chicken legs, cut into 4 pieces'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'Lahori chicken' AND i.name = 'Lahori charga masala, Shan brand'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'Lahori chicken' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'Lahori chicken' AND i.name = 'yogurt, whole milk'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.185
FROM dishes d, ingredients i
WHERE d.name = 'Lahori chicken' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'Lahori chicken' AND i.name = 'tomato paste, canned'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.3
FROM dishes d, ingredients i
WHERE d.name = 'Mexican mac and cheese' AND i.name = 'beef, ground 85% lean (frozen)'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.5
FROM dishes d, ingredients i
WHERE d.name = 'Mexican mac and cheese' AND i.name = 'macaroni elbow pasta'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'Mexican mac and cheese' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.3
FROM dishes d, ingredients i
WHERE d.name = 'Mexican mac and cheese' AND i.name = 'bell pepper, mixed colored'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'Mexican mac and cheese' AND i.name = 'olives, black sliced'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.18
FROM dishes d, ingredients i
WHERE d.name = 'Mexican mac and cheese' AND i.name = 'milk, whole fat'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'Mexican mac and cheese' AND i.name = 'butter, unsalted'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'Mexican mac and cheese' AND i.name = 'Mexican blend cheese, shredded'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.08
FROM dishes d, ingredients i
WHERE d.name = 'Mexican mac and cheese' AND i.name = 'flour, all-purpose unbleached'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'Mexican mac and cheese' AND i.name = 'corn, frozen kernels'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.25
FROM dishes d, ingredients i
WHERE d.name = 'Mexican mac and cheese' AND i.name = 'chicken thigh, ground'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.45
FROM dishes d, ingredients i
WHERE d.name = 'Mideast Chicken and Rice' AND i.name = 'rice, basmati'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.2
FROM dishes d, ingredients i
WHERE d.name = 'Mideast Chicken and Rice' AND i.name = 'chicken thigh, boneless'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.03
FROM dishes d, ingredients i
WHERE d.name = 'Mideast Chicken and Rice' AND i.name = 'lettuce, Romaine whole head'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'Mideast Chicken and Rice' AND i.name = 'tomato, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'Mideast Chicken and Rice' AND i.name = 'oregano leaves, dried McCormick brand'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'Mideast Chicken and Rice' AND i.name = 'thyme leaves, dried McCormick brand'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'Mideast Chicken and Rice' AND i.name = 'Better than Boullion roasted vegetable'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'Mideast Chicken and Rice' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.45
FROM dishes d, ingredients i
WHERE d.name = 'North Indian egg curry' AND i.name = 'eggs'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.35
FROM dishes d, ingredients i
WHERE d.name = 'North Indian egg curry' AND i.name = 'coconut milk'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'North Indian egg curry' AND i.name = 'kharak'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'North Indian egg curry' AND i.name = 'curry leaves, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'North Indian egg curry' AND i.name = 'cashews, roasted salted'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'North Indian egg curry' AND i.name = 'mustard, yellow spicy'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.25
FROM dishes d, ingredients i
WHERE d.name = 'SEHORI butter' AND i.name = 'butter, unsalted'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'SEHORI eggs' AND i.name = 'eggs'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'SEHORI roti' AND i.name = 'roti packet, frozen'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.08
FROM dishes d, ingredients i
WHERE d.name = 'SEHORI tea items' AND i.name = 'tea, Wagh Bakhri or Safari brand'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'SEHORI tea items' AND i.name = 'milk, evaporated canned'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.45
FROM dishes d, ingredients i
WHERE d.name = 'South Indian egg curry' AND i.name = 'eggs'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.35
FROM dishes d, ingredients i
WHERE d.name = 'South Indian egg curry' AND i.name = 'coconut milk'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'South Indian egg curry' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'South Indian egg curry' AND i.name = 'curry leaves, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'South Indian egg curry' AND i.name = 'tamarind paste'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'South Indian egg curry' AND i.name = 'chilies, green fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.08
FROM dishes d, ingredients i
WHERE d.name = 'South Indian egg curry' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'South Indian egg curry' AND i.name = 'tomatoes, canned diced'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.125
FROM dishes d, ingredients i
WHERE d.name = 'Sri Lankan chicken curry' AND i.name = 'chicken legs, cut into 4 pieces'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.25
FROM dishes d, ingredients i
WHERE d.name = 'Sri Lankan chicken curry' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.0125
FROM dishes d, ingredients i
WHERE d.name = 'Sri Lankan chicken curry' AND i.name = 'kewra essence'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'Sri Lankan chicken curry' AND i.name = 'tamarind paste'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'Sri Lankan chicken curry' AND i.name = 'coconut milk'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'Sri Lankan chicken curry' AND i.name = 'curry leaves, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'Sri Lankan chicken curry' AND i.name = 'tomatoes, canned diced'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'Sri Lankan chicken curry' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'Sri Lankan chicken curry' AND i.name = 'coconut, dried shredded'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.5
FROM dishes d, ingredients i
WHERE d.name = 'Swedish meatballs' AND i.name = 'beef, ground 90% lean'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.35
FROM dishes d, ingredients i
WHERE d.name = 'Swedish meatballs' AND i.name = 'chicken thigh, ground'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'Swedish meatballs' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.04
FROM dishes d, ingredients i
WHERE d.name = 'Swedish meatballs' AND i.name = 'butter, unsalted'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.04
FROM dishes d, ingredients i
WHERE d.name = 'Swedish meatballs' AND i.name = 'sour cream'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.02
FROM dishes d, ingredients i
WHERE d.name = 'Swedish meatballs' AND i.name = 'potato bread, Martin''s brand'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.04
FROM dishes d, ingredients i
WHERE d.name = 'Swedish meatballs' AND i.name = 'parsley, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.03
FROM dishes d, ingredients i
WHERE d.name = 'Swedish meatballs' AND i.name = 'Better than Boullion roasted vegetable'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.38
FROM dishes d, ingredients i
WHERE d.name = 'Swedish meatballs' AND i.name = 'egg noodles, wide'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.04
FROM dishes d, ingredients i
WHERE d.name = 'Swedish meatballs' AND i.name = 'eggs'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.01
FROM dishes d, ingredients i
WHERE d.name = 'Swedish meatballs' AND i.name = 'mustard, yellow spicy'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.02
FROM dishes d, ingredients i
WHERE d.name = 'Swedish meatballs' AND i.name = 'garlic, whole peeled'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.4
FROM dishes d, ingredients i
WHERE d.name = 'Thai beef stirfry' AND i.name = 'chicken thigh, ground'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.5
FROM dishes d, ingredients i
WHERE d.name = 'Thai beef stirfry' AND i.name = 'French beans, whole fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.3
FROM dishes d, ingredients i
WHERE d.name = 'Thai beef stirfry' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'Thai beef stirfry' AND i.name = 'mushrooms, white fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'Thai beef stirfry' AND i.name = 'basil leaves, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.5
FROM dishes d, ingredients i
WHERE d.name = 'Thai beef stirfry' AND i.name = 'bell pepper, mixed colored'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'Thai beef stirfry' AND i.name = 'vegetarian oyster sauce'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'Thai beef stirfry' AND i.name = 'soy sauce'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'Thai beef stirfry' AND i.name = 'corn starch'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.04
FROM dishes d, ingredients i
WHERE d.name = 'Thai beef stirfry' AND i.name = 'sesame oil'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.4
FROM dishes d, ingredients i
WHERE d.name = 'Thai beef stirfry' AND i.name = 'beef, ground 90% lean'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'Thai beef stirfry' AND i.name = 'tofu, extra firm'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'Thai beef stirfry' AND i.name = 'spinach leaves, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.2
FROM dishes d, ingredients i
WHERE d.name = 'Thai chicken stirfry' AND i.name = 'chicken thigh, boneless cut 1" pieces'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.5
FROM dishes d, ingredients i
WHERE d.name = 'Thai chicken stirfry' AND i.name = 'French beans, whole fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.3
FROM dishes d, ingredients i
WHERE d.name = 'Thai chicken stirfry' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'Thai chicken stirfry' AND i.name = 'mushrooms, white fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'Thai chicken stirfry' AND i.name = 'basil leaves, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.5
FROM dishes d, ingredients i
WHERE d.name = 'Thai chicken stirfry' AND i.name = 'bell pepper, mixed colored'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'Thai chicken stirfry' AND i.name = 'vegetarian oyster sauce'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'Thai chicken stirfry' AND i.name = 'soy sauce'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'Thai chicken stirfry' AND i.name = 'corn starch'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.04
FROM dishes d, ingredients i
WHERE d.name = 'Thai chicken stirfry' AND i.name = 'sesame oil'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'Thai green curry (chicken)' AND i.name = 'chicken legs, cut into 4 pieces'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.25
FROM dishes d, ingredients i
WHERE d.name = 'Thai green curry (chicken)' AND i.name = 'coconut milk'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'Thai green curry (chicken)' AND i.name = 'potatoes, red or yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.08
FROM dishes d, ingredients i
WHERE d.name = 'Thai green curry (chicken)' AND i.name = 'carrots, fresh baby cut'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.08
FROM dishes d, ingredients i
WHERE d.name = 'Thai green curry (chicken)' AND i.name = 'bell pepper, green'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'Thai green curry (chicken)' AND i.name = 'eggplant, Chinese'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.08
FROM dishes d, ingredients i
WHERE d.name = 'Thai green curry (chicken)' AND i.name = 'mushrooms, white fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.04
FROM dishes d, ingredients i
WHERE d.name = 'Thai green curry (chicken)' AND i.name = 'galangal, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'Thai green curry (chicken)' AND i.name = 'lemongrass, whole stalk'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.02
FROM dishes d, ingredients i
WHERE d.name = 'Thai green curry (chicken)' AND i.name = 'kafir lime leaves, whole'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.06
FROM dishes d, ingredients i
WHERE d.name = 'Thai green curry (chicken)' AND i.name = 'basil leaves, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.3
FROM dishes d, ingredients i
WHERE d.name = 'Thai green curry (chicken)' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'Thai green curry (chicken)' AND i.name = 'chilies, green fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'Thai green curry (chicken)' AND i.name = 'lime juice'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'Thai green curry (chicken)' AND i.name = 'garlic, whole peeled'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'West African peanut chicken curry' AND i.name = 'chicken legs, cut into 4 pieces'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.25
FROM dishes d, ingredients i
WHERE d.name = 'West African peanut chicken curry' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.3
FROM dishes d, ingredients i
WHERE d.name = 'West African peanut chicken curry' AND i.name = 'sweet potatoes'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.25
FROM dishes d, ingredients i
WHERE d.name = 'West African peanut chicken curry' AND i.name = 'collard greens'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'West African peanut chicken curry' AND i.name = 'crunchy peanut butter, JIF brand'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'West African peanut chicken curry' AND i.name = 'tomatoes, canned diced'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'West African peanut chicken curry' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'West African peanut chicken curry' AND i.name = 'coconut, dried shredded'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.2
FROM dishes d, ingredients i
WHERE d.name = 'achaar chicken' AND i.name = 'chicken legs, cut into 4 pieces'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.3333333333
FROM dishes d, ingredients i
WHERE d.name = 'achaar chicken' AND i.name = 'yogurt, lowfat'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.3333333333
FROM dishes d, ingredients i
WHERE d.name = 'achaar chicken' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2222222222
FROM dishes d, ingredients i
WHERE d.name = 'achaar chicken' AND i.name = 'achaar gosht masala, Shan brand'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'achaar chicken' AND i.name = 'birista'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'achaar gosht' AND i.name = 'goat cubes'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.33
FROM dishes d, ingredients i
WHERE d.name = 'achaar gosht' AND i.name = 'yogurt, lowfat'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.33
FROM dishes d, ingredients i
WHERE d.name = 'achaar gosht' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.22
FROM dishes d, ingredients i
WHERE d.name = 'achaar gosht' AND i.name = 'achaar gosht masala, Shan brand'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'achaar gosht' AND i.name = 'birista'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.6
FROM dishes d, ingredients i
WHERE d.name = 'akhni pulao' AND i.name = 'rice, basmati'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.6
FROM dishes d, ingredients i
WHERE d.name = 'akhni pulao' AND i.name = 'goat cubes'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.25
FROM dishes d, ingredients i
WHERE d.name = 'akhni pulao' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.12
FROM dishes d, ingredients i
WHERE d.name = 'akhni pulao' AND i.name = 'mint leaves, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.25
FROM dishes d, ingredients i
WHERE d.name = 'akhni pulao' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.25
FROM dishes d, ingredients i
WHERE d.name = 'akhni pulao' AND i.name = 'Punjabi Yakhni Pulao masala, Shan brand'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.13
FROM dishes d, ingredients i
WHERE d.name = 'akhni pulao' AND i.name = 'coconut milk'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'aloo baingan' AND i.name = 'eggplant, Indian'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.45
FROM dishes d, ingredients i
WHERE d.name = 'aloo baingan' AND i.name = 'potatoes, red or yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.18
FROM dishes d, ingredients i
WHERE d.name = 'aloo baingan' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.18
FROM dishes d, ingredients i
WHERE d.name = 'aloo baingan' AND i.name = 'tomatoes, canned diced'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'aloo baingan' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.75
FROM dishes d, ingredients i
WHERE d.name = 'aloo bhajhi' AND i.name = 'spinach, frozen chopped'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.5
FROM dishes d, ingredients i
WHERE d.name = 'aloo bhajhi' AND i.name = 'potatoes, red or yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.25
FROM dishes d, ingredients i
WHERE d.name = 'aloo bhajhi' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.25
FROM dishes d, ingredients i
WHERE d.name = 'aloo bhajhi' AND i.name = 'tomatoes, canned diced'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.12
FROM dishes d, ingredients i
WHERE d.name = 'aloo bhajhi' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.3
FROM dishes d, ingredients i
WHERE d.name = 'aloo bhajhi' AND i.name = 'methi bhaji leaves, frozen'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'aloo gobi' AND i.name = 'cauliflower, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.45
FROM dishes d, ingredients i
WHERE d.name = 'aloo gobi' AND i.name = 'potatoes, red or yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.18
FROM dishes d, ingredients i
WHERE d.name = 'aloo gobi' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.18
FROM dishes d, ingredients i
WHERE d.name = 'aloo gobi' AND i.name = 'tomatoes, canned diced'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'aloo gobi' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.85
FROM dishes d, ingredients i
WHERE d.name = 'aloo matar' AND i.name = 'green peas, frozen'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.4
FROM dishes d, ingredients i
WHERE d.name = 'aloo matar' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.4
FROM dishes d, ingredients i
WHERE d.name = 'aloo matar' AND i.name = 'potatoes, red or yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1666666667
FROM dishes d, ingredients i
WHERE d.name = 'aloo matar' AND i.name = 'tomatoes, canned crushed'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.08333333333
FROM dishes d, ingredients i
WHERE d.name = 'aloo matar' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.08333333333
FROM dishes d, ingredients i
WHERE d.name = 'aloo matar' AND i.name = 'half and half'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.06666666667
FROM dishes d, ingredients i
WHERE d.name = 'aloo matar' AND i.name = 'cashews, roasted salted'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.5
FROM dishes d, ingredients i
WHERE d.name = 'aloo tarkari (rai wala)' AND i.name = 'potatoes, red or yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'aloo tarkari (rai wala)' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'aloo tarkari (rai wala)' AND i.name = 'curry leaves, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'baked chicken tenders' AND i.name = 'chicken tenders, boneless breaded (halal)'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 2.0
FROM dishes d, ingredients i
WHERE d.name = 'baked herb chicken' AND i.name = 'chicken legs, whole with skin'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'baked herb chicken' AND i.name = 'carrots, fresh baby cut'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.12
FROM dishes d, ingredients i
WHERE d.name = 'baked herb chicken' AND i.name = 'parsley, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'baked herb chicken' AND i.name = 'cauliflower, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.5
FROM dishes d, ingredients i
WHERE d.name = 'baked herb chicken' AND i.name = 'bell pepper, mixed colored'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.02
FROM dishes d, ingredients i
WHERE d.name = 'baked herb chicken' AND i.name = 'lemon juice'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'baked herb chicken' AND i.name = 'potatoes, red or yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'baked herb chicken' AND i.name = 'butter, unsalted'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'batura bread' AND i.name = 'batura bread'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 2.3
FROM dishes d, ingredients i
WHERE d.name = 'bbq chicken legs' AND i.name = 'chicken legs, whole with skin'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.03
FROM dishes d, ingredients i
WHERE d.name = 'bbq chicken legs' AND i.name = 'mustard, yellow spicy'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.25
FROM dishes d, ingredients i
WHERE d.name = 'bbq chicken legs' AND i.name = 'BBQ sauce, Sweet Baby Ray''s brand'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.03
FROM dishes d, ingredients i
WHERE d.name = 'bbq chicken legs' AND i.name = 'garlic, whole peeled'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'bbq chicken sliders' AND i.name = 'chicken thigh, boneless cut 1" pieces'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.03
FROM dishes d, ingredients i
WHERE d.name = 'bbq chicken sliders' AND i.name = 'mustard, yellow spicy'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.25
FROM dishes d, ingredients i
WHERE d.name = 'bbq chicken sliders' AND i.name = 'BBQ sauce, Sweet Baby Ray''s brand'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.08
FROM dishes d, ingredients i
WHERE d.name = 'bbq chicken sliders' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.375
FROM dishes d, ingredients i
WHERE d.name = 'bbq chicken sliders' AND i.name = 'King''s Hawaiian sweet rolls'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'beef chili' AND i.name = 'beef, ground 90% lean'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.12
FROM dishes d, ingredients i
WHERE d.name = 'beef chili' AND i.name = 'black beans, dry'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.12
FROM dishes d, ingredients i
WHERE d.name = 'beef chili' AND i.name = 'pinto beans, dry'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.12
FROM dishes d, ingredients i
WHERE d.name = 'beef chili' AND i.name = 'kidney beans, light dry'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'beef chili' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'beef chili' AND i.name = 'chipotle chilies in adobo, Goya brand canned'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.075
FROM dishes d, ingredients i
WHERE d.name = 'beef chili' AND i.name = 'bell pepper, green'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'beef chili' AND i.name = 'tomato paste, canned'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.25
FROM dishes d, ingredients i
WHERE d.name = 'beef chili' AND i.name = 'Mexican chili powder'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'beef chili' AND i.name = 'chicken thigh, ground'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.3
FROM dishes d, ingredients i
WHERE d.name = 'bhinda masala' AND i.name = 'tomato, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.35
FROM dishes d, ingredients i
WHERE d.name = 'bhinda masala' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.85
FROM dishes d, ingredients i
WHERE d.name = 'bhinda masala' AND i.name = 'okra, frozen cut'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'bhinda masala' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'blueberry poundcake trifle' AND i.name = 'blueberries, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'blueberry poundcake trifle' AND i.name = 'pound cake'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.25
FROM dishes d, ingredients i
WHERE d.name = 'blueberry poundcake trifle' AND i.name = 'vanilla pudding mix, Jello instant'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'blueberry poundcake trifle' AND i.name = 'milk, sweetened condensed canned'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.07
FROM dishes d, ingredients i
WHERE d.name = 'blueberry poundcake trifle' AND i.name = 'milk, whole fat'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'bread - baguette' AND i.name = 'French baguette'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'bread - lavash' AND i.name = 'lavash wrap, Damascus Bakeries brand'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'bread - naan' AND i.name = 'naan, tandoori style (frozen)'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'bread - paratha' AND i.name = 'paratha, frozen'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'bread - sheermal' AND i.name = 'sheermal'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.08
FROM dishes d, ingredients i
WHERE d.name = 'butter chicken' AND i.name = 'chicken legs, cut into 4 pieces'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.075
FROM dishes d, ingredients i
WHERE d.name = 'butter chicken' AND i.name = 'cashews, roasted salted'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'butter chicken' AND i.name = 'butter, unsalted'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'butter chicken' AND i.name = 'heavy cream'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.185
FROM dishes d, ingredients i
WHERE d.name = 'butter chicken' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'butter chicken' AND i.name = 'milk, whole fat'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.35
FROM dishes d, ingredients i
WHERE d.name = 'butter chicken' AND i.name = 'tomato sauce, canned'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'butter chicken' AND i.name = 'butter chicken masala, Shan brand'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'butter chicken' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.8
FROM dishes d, ingredients i
WHERE d.name = 'cabbage stirfry' AND i.name = 'cabbage, green'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'cabbage stirfry' AND i.name = 'cabbage, red'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'cabbage stirfry' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.02
FROM dishes d, ingredients i
WHERE d.name = 'cabbage stirfry' AND i.name = 'moong daal, yellow (split)'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.07
FROM dishes d, ingredients i
WHERE d.name = 'cabbage stirfry' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.25
FROM dishes d, ingredients i
WHERE d.name = 'cauliflower tikka masala' AND i.name = 'cauliflower, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.35
FROM dishes d, ingredients i
WHERE d.name = 'cauliflower tikka masala' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.12
FROM dishes d, ingredients i
WHERE d.name = 'cauliflower tikka masala' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.08
FROM dishes d, ingredients i
WHERE d.name = 'cauliflower tikka masala' AND i.name = 'chilies, green fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'cauliflower tikka masala' AND i.name = 'cashews, roasted salted'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.67
FROM dishes d, ingredients i
WHERE d.name = 'cauliflower tikka masala' AND i.name = 'tomato sauce, canned'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.13
FROM dishes d, ingredients i
WHERE d.name = 'cauliflower tikka masala' AND i.name = 'bell pepper, red'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.12
FROM dishes d, ingredients i
WHERE d.name = 'cauliflower tikka masala' AND i.name = 'coconut milk'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.45
FROM dishes d, ingredients i
WHERE d.name = 'chana doodhi' AND i.name = 'chana daal'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'chana doodhi' AND i.name = 'doodhi'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'chana doodhi' AND i.name = 'tomatoes, canned crushed'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'chana doodhi' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'chana doodhi' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.1
FROM dishes d, ingredients i
WHERE d.name = 'chana gosht' AND i.name = 'goat cubes'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.3
FROM dishes d, ingredients i
WHERE d.name = 'chana gosht' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'chana gosht' AND i.name = 'tomatoes, canned crushed'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'chana gosht' AND i.name = 'chana daal'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'chana gosht' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.25
FROM dishes d, ingredients i
WHERE d.name = 'chawla pulao' AND i.name = 'black eyed peas (chawla)'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.55
FROM dishes d, ingredients i
WHERE d.name = 'chawla pulao' AND i.name = 'rice, basmati'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.25
FROM dishes d, ingredients i
WHERE d.name = 'chawla pulao' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.25
FROM dishes d, ingredients i
WHERE d.name = 'chawla pulao' AND i.name = 'tomatoes, canned diced'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'chawla pulao' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'chawla pulao' AND i.name = 'chilies, green fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.05
FROM dishes d, ingredients i
WHERE d.name = 'chicen kaari' AND i.name = 'chicken legs, cut into 4 pieces'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.25
FROM dishes d, ingredients i
WHERE d.name = 'chicen kaari' AND i.name = 'coconut milk'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'chicen kaari' AND i.name = 'kaari masala'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'chicen kaari' AND i.name = 'curry leaves, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'chicen kaari' AND i.name = 'tamarind paste'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'chicen kaari' AND i.name = 'chilies, green fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.45
FROM dishes d, ingredients i
WHERE d.name = 'chicken biryani' AND i.name = 'rice, basmati'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.22
FROM dishes d, ingredients i
WHERE d.name = 'chicken biryani' AND i.name = 'yogurt, whole milk'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.6
FROM dishes d, ingredients i
WHERE d.name = 'chicken biryani' AND i.name = 'chicken legs, cut into 4 pieces'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.13
FROM dishes d, ingredients i
WHERE d.name = 'chicken biryani' AND i.name = 'birista'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.04
FROM dishes d, ingredients i
WHERE d.name = 'chicken biryani' AND i.name = 'tomato paste, canned'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.13
FROM dishes d, ingredients i
WHERE d.name = 'chicken biryani' AND i.name = 'mint leaves, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.17
FROM dishes d, ingredients i
WHERE d.name = 'chicken biryani' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'chicken biryani' AND i.name = 'Sindhi biryani masala, Shan brand'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.22
FROM dishes d, ingredients i
WHERE d.name = 'chicken biryani' AND i.name = 'potatoes, red or yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'chicken corn soup' AND i.name = 'chicken thigh, boneless cut 1" pieces'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'chicken corn soup' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'chicken corn soup' AND i.name = 'creamed corn, canned'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'chicken corn soup' AND i.name = 'corn, frozen kernels'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.08
FROM dishes d, ingredients i
WHERE d.name = 'chicken corn soup' AND i.name = 'eggs'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.1
FROM dishes d, ingredients i
WHERE d.name = 'chicken curry' AND i.name = 'chicken legs, cut into 4 pieces'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.25
FROM dishes d, ingredients i
WHERE d.name = 'chicken curry' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.3
FROM dishes d, ingredients i
WHERE d.name = 'chicken curry' AND i.name = 'tomatoes, canned crushed'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'chicken curry' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'chicken fajita' AND i.name = 'chicken thigh, boneless'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2222
FROM dishes d, ingredients i
WHERE d.name = 'chicken fajita' AND i.name = 'flour tortilla, Mission brand'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'chicken fajita' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'chicken fajita' AND i.name = 'guacamole single serve mini-cup'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.65
FROM dishes d, ingredients i
WHERE d.name = 'chicken fajita' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.35
FROM dishes d, ingredients i
WHERE d.name = 'chicken fajita' AND i.name = 'bell pepper, green'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'chicken gumbo' AND i.name = 'chicken legs, cut into 4 pieces'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.175
FROM dishes d, ingredients i
WHERE d.name = 'chicken gumbo' AND i.name = 'okra, frozen cut'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.12
FROM dishes d, ingredients i
WHERE d.name = 'chicken gumbo' AND i.name = 'celery, whole fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.12
FROM dishes d, ingredients i
WHERE d.name = 'chicken gumbo' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'chicken gumbo' AND i.name = 'bell pepper, green'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'chicken gumbo' AND i.name = 'flour, all-purpose unbleached'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'chicken gumbo' AND i.name = 'kielbasa sausage'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.4
FROM dishes d, ingredients i
WHERE d.name = 'chicken hakka noodles' AND i.name = 'hakka noodles, Ching''s Secret'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.5
FROM dishes d, ingredients i
WHERE d.name = 'chicken hakka noodles' AND i.name = 'scallions, fresh (green onions)'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.18
FROM dishes d, ingredients i
WHERE d.name = 'chicken hakka noodles' AND i.name = 'carrots, shredded'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.25
FROM dishes d, ingredients i
WHERE d.name = 'chicken hakka noodles' AND i.name = 'cabbage, green'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'chicken hakka noodles' AND i.name = 'mushrooms, white fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.17
FROM dishes d, ingredients i
WHERE d.name = 'chicken hakka noodles' AND i.name = 'bell pepper, green'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'chicken hakka noodles' AND i.name = 'chilies, green fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.02
FROM dishes d, ingredients i
WHERE d.name = 'chicken hakka noodles' AND i.name = 'soy sauce'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.01
FROM dishes d, ingredients i
WHERE d.name = 'chicken hakka noodles' AND i.name = 'vinegar, white'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'chicken hakka noodles' AND i.name = 'sesame oil'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'chicken hakka noodles' AND i.name = 'garlic, whole peeled'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'chicken hakka noodles' AND i.name = 'Sri racha chile sauce'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.5
FROM dishes d, ingredients i
WHERE d.name = 'chicken hakka noodles' AND i.name = 'chowmein hakka noodle masala, Ching''s Secret brand'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.3
FROM dishes d, ingredients i
WHERE d.name = 'chicken hakka noodles' AND i.name = 'chicken thigh, boneless cut 1" pieces'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.5
FROM dishes d, ingredients i
WHERE d.name = 'chicken jalfrezi' AND i.name = 'chicken legs, cut into 4 pieces'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.5
FROM dishes d, ingredients i
WHERE d.name = 'chicken jalfrezi' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.25
FROM dishes d, ingredients i
WHERE d.name = 'chicken jalfrezi' AND i.name = 'yogurt, lowfat'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.25
FROM dishes d, ingredients i
WHERE d.name = 'chicken jalfrezi' AND i.name = 'tomato, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.25
FROM dishes d, ingredients i
WHERE d.name = 'chicken jalfrezi' AND i.name = 'eggplant, regular'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.6
FROM dishes d, ingredients i
WHERE d.name = 'chicken jalfrezi' AND i.name = 'bell pepper, green'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'chicken jalfrezi' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.1
FROM dishes d, ingredients i
WHERE d.name = 'chicken kheema bhaji' AND i.name = 'chicken thigh, ground'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.95
FROM dishes d, ingredients i
WHERE d.name = 'chicken kheema bhaji' AND i.name = 'spinach, frozen cut'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'chicken kheema bhaji' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'chicken kheema bhaji' AND i.name = 'tomatoes, canned diced'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.35
FROM dishes d, ingredients i
WHERE d.name = 'chicken khurdhi' AND i.name = 'chicken legs, cut into 4 pieces'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'chicken khurdhi' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'chicken khurdhi' AND i.name = 'mint leaves, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'chicken khurdhi' AND i.name = 'carrots, fresh baby cut'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'chicken khurdhi' AND i.name = 'celery, whole fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.07
FROM dishes d, ingredients i
WHERE d.name = 'chicken khurdhi' AND i.name = 'milk, whole fat'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.3
FROM dishes d, ingredients i
WHERE d.name = 'chicken lagan ni seekh' AND i.name = 'chicken thigh, ground'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'chicken lagan ni seekh' AND i.name = 'mint leaves, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.03
FROM dishes d, ingredients i
WHERE d.name = 'chicken lagan ni seekh' AND i.name = 'birista'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'chicken lagan ni seekh' AND i.name = 'tomato, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.002
FROM dishes d, ingredients i
WHERE d.name = 'chicken lagan ni seekh' AND i.name = 'lemon juice'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'chicken lagan ni seekh' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'chicken lagan ni seekh' AND i.name = 'eggs'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'chicken lagan ni seekh' AND i.name = 'bread crumb'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'chicken lagan ni seekh' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 2.3
FROM dishes d, ingredients i
WHERE d.name = 'chicken legs in peanut sauce' AND i.name = 'chicken legs, whole skin off'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.4
FROM dishes d, ingredients i
WHERE d.name = 'chicken legs in peanut sauce' AND i.name = 'yogurt, whole milk'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'chicken legs in peanut sauce' AND i.name = 'sour cream'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.07
FROM dishes d, ingredients i
WHERE d.name = 'chicken legs in peanut sauce' AND i.name = 'peanuts, salted roasted'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.25
FROM dishes d, ingredients i
WHERE d.name = 'chicken legs in peanut sauce' AND i.name = 'brocolli florets, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'chicken legs in peanut sauce' AND i.name = 'mushrooms, white fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'chicken legs in peanut sauce' AND i.name = 'mushroom soup, canned condensed'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'chicken legs in peanut sauce' AND i.name = 'cream of celery condensed soup'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.5
FROM dishes d, ingredients i
WHERE d.name = 'chicken legs in peanut sauce' AND i.name = 'bell pepper, mixed colored'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.03
FROM dishes d, ingredients i
WHERE d.name = 'chicken legs in peanut sauce' AND i.name = 'cashews, roasted salted'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'chicken legs in peanut sauce' AND i.name = 'lemon juice'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'chicken legs in peanut sauce' AND i.name = 'chili garlic sauce'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.6
FROM dishes d, ingredients i
WHERE d.name = 'chicken legs in red sauce' AND i.name = 'chicken legs, whole skin off'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.07
FROM dishes d, ingredients i
WHERE d.name = 'chicken legs in red sauce' AND i.name = 'birista'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.3
FROM dishes d, ingredients i
WHERE d.name = 'chicken legs in red sauce' AND i.name = 'tomatoes, canned crushed'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'chicken legs in red sauce' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.3
FROM dishes d, ingredients i
WHERE d.name = 'chicken legs in white sauce' AND i.name = 'chicken legs, cut into 4 pieces'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'chicken legs in white sauce' AND i.name = 'cashews, roasted salted'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'chicken legs in white sauce' AND i.name = 'yogurt, whole milk'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.03
FROM dishes d, ingredients i
WHERE d.name = 'chicken legs in white sauce' AND i.name = 'milk, whole fat'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.025
FROM dishes d, ingredients i
WHERE d.name = 'chicken legs in white sauce' AND i.name = 'tahini paste'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'chicken legs in white sauce' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.07
FROM dishes d, ingredients i
WHERE d.name = 'chicken legs in white sauce' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.04
FROM dishes d, ingredients i
WHERE d.name = 'chicken legs in white sauce' AND i.name = 'half and half'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.6
FROM dishes d, ingredients i
WHERE d.name = 'chicken legs in white sauce' AND i.name = 'chicken legs, whole skin off'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.12
FROM dishes d, ingredients i
WHERE d.name = 'chicken legs in white sauce' AND i.name = 'parsley, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'chicken legs in white sauce' AND i.name = 'celery, whole fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.25
FROM dishes d, ingredients i
WHERE d.name = 'chicken legs in white sauce' AND i.name = 'brocolli florets, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'chicken legs in white sauce' AND i.name = 'butter, unsalted'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'chicken legs in white sauce' AND i.name = 'mushrooms, white fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'chicken legs in white sauce' AND i.name = 'parmesan cheese, grated'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.5
FROM dishes d, ingredients i
WHERE d.name = 'chicken manchurian' AND i.name = 'chicken thigh, boneless cut 1" pieces'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.35
FROM dishes d, ingredients i
WHERE d.name = 'chicken manchurian' AND i.name = 'scallions, fresh (green onions)'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'chicken manchurian' AND i.name = 'ketchup'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'chicken manchurian' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'chicken manchurian' AND i.name = 'eggs'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'chicken manchurian' AND i.name = 'chilies, green fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.02
FROM dishes d, ingredients i
WHERE d.name = 'chicken manchurian' AND i.name = 'soy sauce'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.07
FROM dishes d, ingredients i
WHERE d.name = 'chicken manchurian' AND i.name = 'corn starch'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.08
FROM dishes d, ingredients i
WHERE d.name = 'chicken manchurian' AND i.name = 'sesame oil'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.03
FROM dishes d, ingredients i
WHERE d.name = 'chicken manchurian' AND i.name = 'garlic, whole peeled'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.5
FROM dishes d, ingredients i
WHERE d.name = 'chicken pasta casserole' AND i.name = 'chicken thigh, boneless cut 1" pieces'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.45
FROM dishes d, ingredients i
WHERE d.name = 'chicken pasta casserole' AND i.name = 'penne pasta'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.25
FROM dishes d, ingredients i
WHERE d.name = 'chicken pasta casserole' AND i.name = 'brocolli florets, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.3
FROM dishes d, ingredients i
WHERE d.name = 'chicken pasta casserole' AND i.name = 'bell pepper, mixed colored'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'chicken pasta casserole' AND i.name = 'zucchini'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'chicken pasta casserole' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'chicken pasta casserole' AND i.name = 'mushrooms, white fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'chicken pasta casserole' AND i.name = 'milk, whole fat'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'chicken pasta casserole' AND i.name = 'butter, unsalted'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'chicken pasta casserole' AND i.name = 'mozzarella cheese, shredded'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'chicken pasta casserole' AND i.name = 'flour, all-purpose unbleached'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.03
FROM dishes d, ingredients i
WHERE d.name = 'chicken pasta casserole' AND i.name = 'Better than Boullion roasted vegetable'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 2.0
FROM dishes d, ingredients i
WHERE d.name = 'chicken picatta' AND i.name = 'chicken legs, whole with skin'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.04
FROM dishes d, ingredients i
WHERE d.name = 'chicken picatta' AND i.name = 'capers'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.12
FROM dishes d, ingredients i
WHERE d.name = 'chicken picatta' AND i.name = 'parsley, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'chicken picatta' AND i.name = 'penne pasta'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'chicken picatta' AND i.name = 'brocolli florets, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'chicken picatta' AND i.name = 'butter, unsalted'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.5
FROM dishes d, ingredients i
WHERE d.name = 'chicken quesadilla' AND i.name = 'chicken thigh, boneless'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2222
FROM dishes d, ingredients i
WHERE d.name = 'chicken quesadilla' AND i.name = 'flour tortilla, Mission brand'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.5
FROM dishes d, ingredients i
WHERE d.name = 'chicken quesadilla' AND i.name = 'Mexican blend cheese, shredded'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'chicken quesadilla' AND i.name = 'guacamole single serve mini-cup'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'chicken quesadilla' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'chicken tikka masala' AND i.name = 'chicken legs, cut into 4 pieces'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.35
FROM dishes d, ingredients i
WHERE d.name = 'chicken tikka masala' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.12
FROM dishes d, ingredients i
WHERE d.name = 'chicken tikka masala' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.08
FROM dishes d, ingredients i
WHERE d.name = 'chicken tikka masala' AND i.name = 'chilies, green fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'chicken tikka masala' AND i.name = 'cashews, roasted salted'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.67
FROM dishes d, ingredients i
WHERE d.name = 'chicken tikka masala' AND i.name = 'tomato sauce, canned'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'chicken tikka masala' AND i.name = 'bell pepper, mixed colored'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.12
FROM dishes d, ingredients i
WHERE d.name = 'chicken tikka masala' AND i.name = 'coconut milk'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'chicken tortilla soup w/rice and beans' AND i.name = 'chicken breast, boneless'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.3
FROM dishes d, ingredients i
WHERE d.name = 'chicken tortilla soup w/rice and beans' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'chicken tortilla soup w/rice and beans' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'chicken tortilla soup w/rice and beans' AND i.name = 'corn, frozen kernels'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'chicken tortilla soup w/rice and beans' AND i.name = 'lime juice'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.25
FROM dishes d, ingredients i
WHERE d.name = 'chicken tortilla soup w/rice and beans' AND i.name = 'rice, jasmine'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.12
FROM dishes d, ingredients i
WHERE d.name = 'chicken tortilla soup w/rice and beans' AND i.name = 'black beans, dry'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'chicken tortilla soup w/rice and beans' AND i.name = 'chipotle chilies in adobo, Goya brand canned'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'chicken tortilla soup w/rice and beans' AND i.name = 'corn tortilla'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.02
FROM dishes d, ingredients i
WHERE d.name = 'chicken tortilla soup w/rice and beans' AND i.name = 'olive oil, extra virgin'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'chicken tortilla soup w/rice and beans' AND i.name = 'Better than Boullion roasted vegetable'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.25
FROM dishes d, ingredients i
WHERE d.name = 'chicken tortilla soup w/rice and beans' AND i.name = 'tomatoes, canned diced'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'chicken tortilla soup w/rice and beans' AND i.name = 'Mexican blend cheese, shredded'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.5
FROM dishes d, ingredients i
WHERE d.name = 'chicken tortilla soup w/rice and beans' AND i.name = 'limes, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.25
FROM dishes d, ingredients i
WHERE d.name = 'chicken vegetable pulao' AND i.name = 'chicken thigh, boneless'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.55
FROM dishes d, ingredients i
WHERE d.name = 'chicken vegetable pulao' AND i.name = 'rice, basmati'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.25
FROM dishes d, ingredients i
WHERE d.name = 'chicken vegetable pulao' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.25
FROM dishes d, ingredients i
WHERE d.name = 'chicken vegetable pulao' AND i.name = 'tomatoes, canned diced'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'chicken vegetable pulao' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'chicken vegetable pulao' AND i.name = 'chilies, green fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.35
FROM dishes d, ingredients i
WHERE d.name = 'chicken vegetable pulao' AND i.name = 'mixed vegetables, frozen'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.75
FROM dishes d, ingredients i
WHERE d.name = 'chicken veggie casserole' AND i.name = 'chicken thigh, boneless cut 1" pieces'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'chicken veggie casserole' AND i.name = 'cream of celery condensed soup'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.55
FROM dishes d, ingredients i
WHERE d.name = 'chicken veggie casserole' AND i.name = 'brocolli florets, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.5
FROM dishes d, ingredients i
WHERE d.name = 'chicken veggie casserole' AND i.name = 'bell pepper, mixed colored'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'chicken veggie casserole' AND i.name = 'potatoes, red or yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'chicken veggie casserole' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.25
FROM dishes d, ingredients i
WHERE d.name = 'chicken veggie casserole' AND i.name = 'mushrooms, white fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'chicken veggie casserole' AND i.name = 'milk, whole fat'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'chicken veggie casserole' AND i.name = 'butter, unsalted'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'chicken veggie casserole' AND i.name = 'Mexican blend cheese, shredded'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'chicken veggie casserole' AND i.name = 'flour, all-purpose unbleached'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.03
FROM dishes d, ingredients i
WHERE d.name = 'chicken veggie casserole' AND i.name = 'Better than Boullion roasted vegetable'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'chicken veggie casserole' AND i.name = 'mozzarella cheese, shredded'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.25
FROM dishes d, ingredients i
WHERE d.name = 'chickoli' AND i.name = 'potatoes, red or yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.65
FROM dishes d, ingredients i
WHERE d.name = 'chickoli' AND i.name = 'flour, chapatti atta'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.25
FROM dishes d, ingredients i
WHERE d.name = 'chickoli' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'chickoli' AND i.name = 'tomato, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.5
FROM dishes d, ingredients i
WHERE d.name = 'chickoli' AND i.name = 'goat cubes'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'chickoli' AND i.name = 'sweet potatoes'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'chickoli' AND i.name = 'peas and carrots, frozen diced'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'chickoli' AND i.name = 'French beans, whole fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'chickoli' AND i.name = 'toor daal'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.07
FROM dishes d, ingredients i
WHERE d.name = 'chickoli' AND i.name = 'masoor daal, red'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'chickoli' AND i.name = 'drumsticks'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.35
FROM dishes d, ingredients i
WHERE d.name = 'chilli chicken' AND i.name = 'chicken thigh, boneless cut 1" pieces'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.4
FROM dishes d, ingredients i
WHERE d.name = 'chilli chicken' AND i.name = 'scallions, fresh (green onions)'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'chilli chicken' AND i.name = 'carrots, shredded'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'chilli chicken' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.3
FROM dishes d, ingredients i
WHERE d.name = 'chilli chicken' AND i.name = 'bell pepper, green'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'chilli chicken' AND i.name = 'chilies, green fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.02
FROM dishes d, ingredients i
WHERE d.name = 'chilli chicken' AND i.name = 'soy sauce'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.07
FROM dishes d, ingredients i
WHERE d.name = 'chilli chicken' AND i.name = 'corn starch'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.08
FROM dishes d, ingredients i
WHERE d.name = 'chilli chicken' AND i.name = 'sesame oil'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'chilli chicken' AND i.name = 'garlic, whole peeled'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'chilli chicken' AND i.name = 'Sri racha chile sauce'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'chilli chicken' AND i.name = 'tomato paste, canned'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.67
FROM dishes d, ingredients i
WHERE d.name = 'chola batura' AND i.name = 'garbanzo beans, canned'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.125
FROM dishes d, ingredients i
WHERE d.name = 'chola batura' AND i.name = 'chola batura masala, Badshah brand'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'chola batura' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'chola batura' AND i.name = 'tomato, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.07
FROM dishes d, ingredients i
WHERE d.name = 'chola batura' AND i.name = 'chilies, green fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.125
FROM dishes d, ingredients i
WHERE d.name = 'chola batura' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.17
FROM dishes d, ingredients i
WHERE d.name = 'chola batura' AND i.name = 'yogurt, whole milk'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.3
FROM dishes d, ingredients i
WHERE d.name = 'coleslaw' AND i.name = 'scallions, fresh (green onions)'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'coleslaw' AND i.name = 'carrots, shredded'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.75
FROM dishes d, ingredients i
WHERE d.name = 'coleslaw' AND i.name = 'cabbage, green'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'coleslaw' AND i.name = 'cabbage, red'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.25
FROM dishes d, ingredients i
WHERE d.name = 'coleslaw' AND i.name = 'yogurt, greek 0% fat'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'coleslaw' AND i.name = 'mayonaise'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.08
FROM dishes d, ingredients i
WHERE d.name = 'coleslaw' AND i.name = 'dried apricots'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'creamy pasta primavera' AND i.name = 'green peas, frozen'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.6
FROM dishes d, ingredients i
WHERE d.name = 'creamy pasta primavera' AND i.name = 'penne pasta'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'creamy pasta primavera' AND i.name = 'brocolli florets, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.3
FROM dishes d, ingredients i
WHERE d.name = 'creamy pasta primavera' AND i.name = 'bell pepper, mixed colored'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'creamy pasta primavera' AND i.name = 'zucchini'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'creamy pasta primavera' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'creamy pasta primavera' AND i.name = 'mushrooms, white fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'creamy pasta primavera' AND i.name = 'milk, whole fat'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'creamy pasta primavera' AND i.name = 'butter, unsalted'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'creamy pasta primavera' AND i.name = 'parmesan cheese, grated'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'creamy pasta primavera' AND i.name = 'heavy cream'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'creamy pasta primavera' AND i.name = 'carrots, fresh baby cut'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'creamy pasta primavera' AND i.name = 'tomatoes, cherry fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'creamy pasta primavera' AND i.name = 'basil leaves, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.55
FROM dishes d, ingredients i
WHERE d.name = 'daal chawal' AND i.name = 'rice, basmati'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.25
FROM dishes d, ingredients i
WHERE d.name = 'daal chawal' AND i.name = 'toor daal, oily'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'daal gosht' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.4
FROM dishes d, ingredients i
WHERE d.name = 'daal gosht' AND i.name = 'toor daal'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'daal gosht' AND i.name = 'tomatoes, canned diced'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.35
FROM dishes d, ingredients i
WHERE d.name = 'daal gosht' AND i.name = 'goat cubes'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'daal gosht' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.3
FROM dishes d, ingredients i
WHERE d.name = 'daal makhani' AND i.name = 'urad daal, whole (black)'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.12
FROM dishes d, ingredients i
WHERE d.name = 'daal makhani' AND i.name = 'kidney beans, light dry'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.06
FROM dishes d, ingredients i
WHERE d.name = 'daal makhani' AND i.name = 'chana daal'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'daal makhani' AND i.name = 'half and half'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.06
FROM dishes d, ingredients i
WHERE d.name = 'daal makhani' AND i.name = 'butter, unsalted'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'daal makhani' AND i.name = 'tomato paste, canned'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'daal tadka (daal fry)' AND i.name = 'tomato, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'daal tadka (daal fry)' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.35
FROM dishes d, ingredients i
WHERE d.name = 'daal tadka (daal fry)' AND i.name = 'toor daal'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.025
FROM dishes d, ingredients i
WHERE d.name = 'daal tadka (daal fry)' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.04
FROM dishes d, ingredients i
WHERE d.name = 'daal tadka (daal fry)' AND i.name = 'chilies, green fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'daal tadka (daal fry)' AND i.name = 'curry leaves, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'daal tadka (daal fry)' AND i.name = 'chana daal'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'dahi kadhi' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.4
FROM dishes d, ingredients i
WHERE d.name = 'dahi kadhi' AND i.name = 'yogurt, lowfat'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'dahi kadhi' AND i.name = 'curry leaves, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'dahi kadhi' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'dahi kadhi' AND i.name = 'chilies, green fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'dahi kadhi' AND i.name = 'tomato, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'dahi kadhi' AND i.name = 'besan (gram flour)'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.65
FROM dishes d, ingredients i
WHERE d.name = 'dhaba chana dal fry' AND i.name = 'chana daal'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.16
FROM dishes d, ingredients i
WHERE d.name = 'dhaba chana dal fry' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'dhaba chana dal fry' AND i.name = 'tomatoes, canned crushed'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'dhaba chana dal fry' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'dhaba chana dal fry' AND i.name = 'curry leaves, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.02
FROM dishes d, ingredients i
WHERE d.name = 'dhaba chana dal fry' AND i.name = 'garlic, whole peeled'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.02
FROM dishes d, ingredients i
WHERE d.name = 'dhaba chana dal fry' AND i.name = 'ghee'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.6
FROM dishes d, ingredients i
WHERE d.name = 'doodhi tarkari' AND i.name = 'doodhi'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.35
FROM dishes d, ingredients i
WHERE d.name = 'doodhi tarkari' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'doodhi tarkari' AND i.name = 'tomatoes, canned diced'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'doodhi tarkari' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.08
FROM dishes d, ingredients i
WHERE d.name = 'doodhi tarkari' AND i.name = 'curry leaves, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.25
FROM dishes d, ingredients i
WHERE d.name = 'dum aloo' AND i.name = 'potatoes, baby size'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'dum aloo' AND i.name = 'cashews, roasted salted'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'dum aloo' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'dum aloo' AND i.name = 'yogurt, whole milk'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'dum aloo' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'dum aloo' AND i.name = 'tomatoes, canned crushed'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'fruit - apple' AND i.name = 'apples'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'fruit - banana' AND i.name = 'banana'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 2.0
FROM dishes d, ingredients i
WHERE d.name = 'fruit - blueberries' AND i.name = 'blueberries'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'fruit - buyer''s choice' AND i.name = 'persimmons, pomegranates, or other uncut fruit'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'fruit - kiwi' AND i.name = 'kiwi'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'fruit - orange' AND i.name = 'orange'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'fruit - peach' AND i.name = 'peach'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'fruit - pear' AND i.name = 'pear'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'fruit - plum' AND i.name = 'plum'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.125
FROM dishes d, ingredients i
WHERE d.name = 'general - tres leches caramel cake' AND i.name = 'tres leches caramel cake'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.52
FROM dishes d, ingredients i
WHERE d.name = 'gosht biryani' AND i.name = 'rice, basmati'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.49
FROM dishes d, ingredients i
WHERE d.name = 'gosht biryani' AND i.name = 'goat cubes'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.22
FROM dishes d, ingredients i
WHERE d.name = 'gosht biryani' AND i.name = 'yogurt, whole milk'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.13
FROM dishes d, ingredients i
WHERE d.name = 'gosht biryani' AND i.name = 'birista'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.04
FROM dishes d, ingredients i
WHERE d.name = 'gosht biryani' AND i.name = 'tomato paste, canned'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'gosht biryani' AND i.name = 'mint leaves, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.17
FROM dishes d, ingredients i
WHERE d.name = 'gosht biryani' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'gosht biryani' AND i.name = 'Sindhi biryani masala, Shan brand'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.22
FROM dishes d, ingredients i
WHERE d.name = 'gosht biryani' AND i.name = 'potatoes, red or yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.05
FROM dishes d, ingredients i
WHERE d.name = 'gosht kaari' AND i.name = 'goat cubes'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.25
FROM dishes d, ingredients i
WHERE d.name = 'gosht kaari' AND i.name = 'coconut milk'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'gosht kaari' AND i.name = 'kaari masala'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'gosht kaari' AND i.name = 'curry leaves, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'gosht kaari' AND i.name = 'tamarind paste'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'gosht kaari' AND i.name = 'chilies, green fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.85
FROM dishes d, ingredients i
WHERE d.name = 'gosht ni tarkari' AND i.name = 'goat cubes'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'gosht ni tarkari' AND i.name = 'tomatoes, canned crushed'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'gosht ni tarkari' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'gosht ni tarkari' AND i.name = 'chilies, green fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.3
FROM dishes d, ingredients i
WHERE d.name = 'gosht ni tarkari' AND i.name = 'potatoes, red or yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'green bean aloo curry' AND i.name = 'French beans, whole fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.45
FROM dishes d, ingredients i
WHERE d.name = 'green bean aloo curry' AND i.name = 'potatoes, red or yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'green bean aloo curry' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'green bean aloo curry' AND i.name = 'tomato, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'green bean aloo curry' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.4
FROM dishes d, ingredients i
WHERE d.name = 'green chicken (caju ni murghi)' AND i.name = 'chicken legs, cut into 4 pieces'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.65
FROM dishes d, ingredients i
WHERE d.name = 'green chicken (caju ni murghi)' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'green chicken (caju ni murghi)' AND i.name = 'cashews, roasted salted'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'green chicken (caju ni murghi)' AND i.name = 'mint leaves, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'green chicken (caju ni murghi)' AND i.name = 'coconut, dried shredded'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'green chicken (caju ni murghi)' AND i.name = 'tomato, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.02
FROM dishes d, ingredients i
WHERE d.name = 'green chicken (caju ni murghi)' AND i.name = 'lemon juice'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.08
FROM dishes d, ingredients i
WHERE d.name = 'green chicken (caju ni murghi)' AND i.name = 'chilies, green fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.25
FROM dishes d, ingredients i
WHERE d.name = 'green chicken (caju ni murghi)' AND i.name = 'yogurt, whole milk'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.25
FROM dishes d, ingredients i
WHERE d.name = 'green chicken (caju ni murghi)' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.2
FROM dishes d, ingredients i
WHERE d.name = 'green gosht (caju ni gosht)' AND i.name = 'goat cubes'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.65
FROM dishes d, ingredients i
WHERE d.name = 'green gosht (caju ni gosht)' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'green gosht (caju ni gosht)' AND i.name = 'cashews, roasted salted'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'green gosht (caju ni gosht)' AND i.name = 'mint leaves, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'green gosht (caju ni gosht)' AND i.name = 'birista'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'green gosht (caju ni gosht)' AND i.name = 'tomatoes, canned diced'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.02
FROM dishes d, ingredients i
WHERE d.name = 'green gosht (caju ni gosht)' AND i.name = 'lemon juice'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.08
FROM dishes d, ingredients i
WHERE d.name = 'green gosht (caju ni gosht)' AND i.name = 'chilies, green fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.25
FROM dishes d, ingredients i
WHERE d.name = 'green gosht (caju ni gosht)' AND i.name = 'yogurt, lowfat'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.25
FROM dishes d, ingredients i
WHERE d.name = 'green gosht (caju ni gosht)' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'guvar aloo' AND i.name = 'guvar, frozen'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.45
FROM dishes d, ingredients i
WHERE d.name = 'guvar aloo' AND i.name = 'potatoes, red or yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.18
FROM dishes d, ingredients i
WHERE d.name = 'guvar aloo' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.18
FROM dishes d, ingredients i
WHERE d.name = 'guvar aloo' AND i.name = 'tomato, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'guvar aloo' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.45
FROM dishes d, ingredients i
WHERE d.name = 'haleem' AND i.name = 'goat cubes'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'haleem' AND i.name = 'haleem wheat, Sadaf brand'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.03
FROM dishes d, ingredients i
WHERE d.name = 'haleem' AND i.name = 'toor daal'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.03
FROM dishes d, ingredients i
WHERE d.name = 'haleem' AND i.name = 'chana daal'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.03
FROM dishes d, ingredients i
WHERE d.name = 'haleem' AND i.name = 'moong daal, yellow (split)'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'haleem' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'haleem' AND i.name = 'chilies, green fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.17
FROM dishes d, ingredients i
WHERE d.name = 'haleem' AND i.name = 'tomatoes, canned diced'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.17
FROM dishes d, ingredients i
WHERE d.name = 'haleem' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.07
FROM dishes d, ingredients i
WHERE d.name = 'haleem' AND i.name = 'haleem masala, Shan brand'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.07
FROM dishes d, ingredients i
WHERE d.name = 'haleem - garnish' AND i.name = 'lemons, whole fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'haleem - garnish' AND i.name = 'birista'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'haleem - garnish' AND i.name = 'mint leaves, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.5
FROM dishes d, ingredients i
WHERE d.name = 'handi chicken' AND i.name = 'chicken legs, cut into 4 pieces'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.25
FROM dishes d, ingredients i
WHERE d.name = 'handi chicken' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.12
FROM dishes d, ingredients i
WHERE d.name = 'handi chicken' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.08
FROM dishes d, ingredients i
WHERE d.name = 'handi chicken' AND i.name = 'chilies, green fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.08
FROM dishes d, ingredients i
WHERE d.name = 'handi chicken' AND i.name = 'yogurt, whole milk'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'handi chicken' AND i.name = 'tomatoes, canned crushed'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'ice cream' AND i.name = 'kulfi - mango'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'ice cream' AND i.name = 'kulfi - kesar/kesar pista/other similar'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.2
FROM dishes d, ingredients i
WHERE d.name = 'kaleji ni tarkari' AND i.name = 'liver, goat'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'kaleji ni tarkari' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.17
FROM dishes d, ingredients i
WHERE d.name = 'kaleji ni tarkari' AND i.name = 'chilies, green fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'kaleji ni tarkari' AND i.name = 'tomatoes, canned diced'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'kaleji ni tarkari' AND i.name = 'tomato paste, canned'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'kaleji ni tarkari' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.5
FROM dishes d, ingredients i
WHERE d.name = 'karahi chicken' AND i.name = 'chicken legs, cut into 4 pieces'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'karahi chicken' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.12
FROM dishes d, ingredients i
WHERE d.name = 'karahi chicken' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.08
FROM dishes d, ingredients i
WHERE d.name = 'karahi chicken' AND i.name = 'chilies, green fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.5
FROM dishes d, ingredients i
WHERE d.name = 'karahi chicken' AND i.name = 'tomatoes, canned diced'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'karahi chicken' AND i.name = 'tomato paste, canned'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'kebabs, frozen (ready-made)' AND i.name = 'kebabs, frozen (ready-made)'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.125
FROM dishes d, ingredients i
WHERE d.name = 'khajoor' AND i.name = 'dates, medjool pitted'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.45
FROM dishes d, ingredients i
WHERE d.name = 'kheema aloo matar' AND i.name = 'beef, ground 90% lean'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.55
FROM dishes d, ingredients i
WHERE d.name = 'kheema aloo matar' AND i.name = 'chicken thigh, ground'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.6
FROM dishes d, ingredients i
WHERE d.name = 'kheema aloo matar' AND i.name = 'potatoes, red or yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'kheema aloo matar' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'kheema aloo matar' AND i.name = 'tomatoes, canned diced'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'kheema aloo matar' AND i.name = 'green peas, frozen'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.55
FROM dishes d, ingredients i
WHERE d.name = 'kheema bhaji' AND i.name = 'chicken thigh, ground'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.95
FROM dishes d, ingredients i
WHERE d.name = 'kheema bhaji' AND i.name = 'spinach, frozen cut'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'kheema bhaji' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'kheema bhaji' AND i.name = 'tomatoes, canned diced'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.55
FROM dishes d, ingredients i
WHERE d.name = 'kheema bhaji' AND i.name = 'beef, ground 85% lean (frozen)'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.5
FROM dishes d, ingredients i
WHERE d.name = 'kheema biryani' AND i.name = 'rice, basmati'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.3
FROM dishes d, ingredients i
WHERE d.name = 'kheema biryani' AND i.name = 'beef, ground 90% lean'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.22
FROM dishes d, ingredients i
WHERE d.name = 'kheema biryani' AND i.name = 'yogurt, whole milk'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.13
FROM dishes d, ingredients i
WHERE d.name = 'kheema biryani' AND i.name = 'birista'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.04
FROM dishes d, ingredients i
WHERE d.name = 'kheema biryani' AND i.name = 'tomato paste, canned'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.13
FROM dishes d, ingredients i
WHERE d.name = 'kheema biryani' AND i.name = 'mint leaves, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.17
FROM dishes d, ingredients i
WHERE d.name = 'kheema biryani' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'kheema biryani' AND i.name = 'Sindhi biryani masala, Shan brand'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.22
FROM dishes d, ingredients i
WHERE d.name = 'kheema biryani' AND i.name = 'potatoes, red or yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.35
FROM dishes d, ingredients i
WHERE d.name = 'kheema biryani' AND i.name = 'chicken thigh, ground'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'kheema khichdhi' AND i.name = 'moong daal, yellow (split)'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.55
FROM dishes d, ingredients i
WHERE d.name = 'kheema khichdhi' AND i.name = 'rice, basmati'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.25
FROM dishes d, ingredients i
WHERE d.name = 'kheema khichdhi' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.25
FROM dishes d, ingredients i
WHERE d.name = 'kheema khichdhi' AND i.name = 'tomatoes, canned diced'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'kheema khichdhi' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'kheema khichdhi' AND i.name = 'chilies, green fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.3
FROM dishes d, ingredients i
WHERE d.name = 'kheema khichdhi' AND i.name = 'beef, ground 90% lean'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.3
FROM dishes d, ingredients i
WHERE d.name = 'kheema khichdhi' AND i.name = 'chicken thigh, ground'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.45
FROM dishes d, ingredients i
WHERE d.name = 'kheema patvelia' AND i.name = 'beef, ground 90% lean'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.6
FROM dishes d, ingredients i
WHERE d.name = 'kheema patvelia' AND i.name = 'chicken thigh, ground'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.95
FROM dishes d, ingredients i
WHERE d.name = 'kheema patvelia' AND i.name = 'patvelia, frozen'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'kheema patvelia' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'kheema patvelia' AND i.name = 'tomatoes, canned diced'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.45
FROM dishes d, ingredients i
WHERE d.name = 'kheema pau' AND i.name = 'beef, ground 85% lean (frozen)'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.55
FROM dishes d, ingredients i
WHERE d.name = 'kheema pau' AND i.name = 'chicken thigh, ground'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'kheema pau' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.4
FROM dishes d, ingredients i
WHERE d.name = 'kheema pau' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.35
FROM dishes d, ingredients i
WHERE d.name = 'kheema pau' AND i.name = 'tomato, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.3
FROM dishes d, ingredients i
WHERE d.name = 'kheema pau' AND i.name = 'green peas, frozen'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.25
FROM dishes d, ingredients i
WHERE d.name = 'kheema pau' AND i.name = 'King''s Hawaiian sweet rolls'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.45
FROM dishes d, ingredients i
WHERE d.name = 'khichdi' AND i.name = 'rice, basmati'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'khichdi' AND i.name = 'moong daal, yellow (split)'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.45
FROM dishes d, ingredients i
WHERE d.name = 'kofta curry' AND i.name = 'beef, ground 90% lean'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.6
FROM dishes d, ingredients i
WHERE d.name = 'kofta curry' AND i.name = 'chicken thigh, ground'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'kofta curry' AND i.name = 'tomato sauce, canned'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.25
FROM dishes d, ingredients i
WHERE d.name = 'kofta curry' AND i.name = 'yogurt, lowfat'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'kofta curry' AND i.name = 'birista'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'kofta curry' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.02
FROM dishes d, ingredients i
WHERE d.name = 'kofta curry' AND i.name = 'eggs'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.25
FROM dishes d, ingredients i
WHERE d.name = 'kushari' AND i.name = 'rice, basmati'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.25
FROM dishes d, ingredients i
WHERE d.name = 'kushari' AND i.name = 'masoor daal, brown (whole)'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'kushari' AND i.name = 'elbow pasta'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'kushari' AND i.name = 'garbanzo beans, canned'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.3
FROM dishes d, ingredients i
WHERE d.name = 'kushari' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.35
FROM dishes d, ingredients i
WHERE d.name = 'kushari' AND i.name = 'tomato sauce, canned'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'kushari' AND i.name = 'birista'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'kushari' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.55
FROM dishes d, ingredients i
WHERE d.name = 'lagan ni seekh' AND i.name = 'beef, ground 90% lean'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.7
FROM dishes d, ingredients i
WHERE d.name = 'lagan ni seekh' AND i.name = 'chicken thigh, ground'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'lagan ni seekh' AND i.name = 'mint leaves, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.03
FROM dishes d, ingredients i
WHERE d.name = 'lagan ni seekh' AND i.name = 'birista'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'lagan ni seekh' AND i.name = 'tomato, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.002
FROM dishes d, ingredients i
WHERE d.name = 'lagan ni seekh' AND i.name = 'lemon juice'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'lagan ni seekh' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'lagan ni seekh' AND i.name = 'eggs'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'lagan ni seekh' AND i.name = 'bread crumb'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'lagan ni seekh' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'lasagne with meat sauce' AND i.name = 'chicken thigh, ground'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'lasagne with meat sauce' AND i.name = 'beef, ground 90% lean'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'lasagne with meat sauce' AND i.name = 'pasta sauce, Ragu brand'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'lasagne with meat sauce' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'lasagne with meat sauce' AND i.name = 'mushrooms, white fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'lasagne with meat sauce' AND i.name = 'spinach, frozen chopped'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.4
FROM dishes d, ingredients i
WHERE d.name = 'lasagne with meat sauce' AND i.name = 'ricotta cheese, whole milk'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'lasagne with meat sauce' AND i.name = 'cottage cheese, 2% fat'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'lasagne with meat sauce' AND i.name = 'parmesan cheese, grated'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.235
FROM dishes d, ingredients i
WHERE d.name = 'lasagne with meat sauce' AND i.name = 'lasagne noodles'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'lasagne with meat sauce' AND i.name = 'mozzarella cheese, shredded'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.65
FROM dishes d, ingredients i
WHERE d.name = 'lemon olive chicken tagine' AND i.name = 'chicken legs, whole skin off'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'lemon olive chicken tagine' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'lemon olive chicken tagine' AND i.name = 'lemons, whole fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'lemon olive chicken tagine' AND i.name = 'olives, green pimento stuffed'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'lemon olive chicken tagine' AND i.name = 'bell pepper, mixed colored'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'lemon olive chicken tagine' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.95
FROM dishes d, ingredients i
WHERE d.name = 'malvi gosht' AND i.name = 'goat cubes'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.3
FROM dishes d, ingredients i
WHERE d.name = 'malvi gosht' AND i.name = 'tomatoes, canned crushed'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.3
FROM dishes d, ingredients i
WHERE d.name = 'malvi gosht' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'malvi gosht' AND i.name = 'chilies, green fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'masoor daal' AND i.name = 'tomatoes, canned diced'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'masoor daal' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.4
FROM dishes d, ingredients i
WHERE d.name = 'masoor daal' AND i.name = 'masoor daal, brown (whole)'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.025
FROM dishes d, ingredients i
WHERE d.name = 'masoor daal' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.5
FROM dishes d, ingredients i
WHERE d.name = 'masoor daal w/gosht' AND i.name = 'goat cubes'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.25
FROM dishes d, ingredients i
WHERE d.name = 'masoor pulao' AND i.name = 'masoor daal, brown (whole)'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.55
FROM dishes d, ingredients i
WHERE d.name = 'masoor pulao' AND i.name = 'rice, basmati'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.25
FROM dishes d, ingredients i
WHERE d.name = 'masoor pulao' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.25
FROM dishes d, ingredients i
WHERE d.name = 'masoor pulao' AND i.name = 'tomatoes, canned diced'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'masoor pulao' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'masoor pulao' AND i.name = 'chilies, green fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.4
FROM dishes d, ingredients i
WHERE d.name = 'masoor pulao' AND i.name = 'goat cubes'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.85
FROM dishes d, ingredients i
WHERE d.name = 'matar paneer' AND i.name = 'green peas, frozen'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.4
FROM dishes d, ingredients i
WHERE d.name = 'matar paneer' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.4
FROM dishes d, ingredients i
WHERE d.name = 'matar paneer' AND i.name = 'paneer'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1666666667
FROM dishes d, ingredients i
WHERE d.name = 'matar paneer' AND i.name = 'tomatoes, canned crushed'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.08333333333
FROM dishes d, ingredients i
WHERE d.name = 'matar paneer' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.08333333333
FROM dishes d, ingredients i
WHERE d.name = 'matar paneer' AND i.name = 'half and half'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.06666666667
FROM dishes d, ingredients i
WHERE d.name = 'matar paneer' AND i.name = 'cashews, roasted salted'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.5
FROM dishes d, ingredients i
WHERE d.name = 'mattho' AND i.name = 'yogurt, whole milk'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'mattho' AND i.name = 'milk, whole fat'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'mattho' AND i.name = 'sugar'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.08
FROM dishes d, ingredients i
WHERE d.name = 'mattho' AND i.name = 'water'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.33
FROM dishes d, ingredients i
WHERE d.name = 'mezze - hummus' AND i.name = 'hummus'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 6.0
FROM dishes d, ingredients i
WHERE d.name = 'mezze - pita bread' AND i.name = 'Kontos pita loaves'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.25
FROM dishes d, ingredients i
WHERE d.name = 'mezze - stuffed grape leaves' AND i.name = 'Frankly Fresh stuffed grape leaves'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.33
FROM dishes d, ingredients i
WHERE d.name = 'mezze - tapenade' AND i.name = 'tapenade'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.33
FROM dishes d, ingredients i
WHERE d.name = 'mezze - tzaziki' AND i.name = 'tzaziki dip, Hannah brand'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'mithaas - caju pak' AND i.name = 'caju pak'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'mithaas - fruit custard' AND i.name = 'fruit custard'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'mithaas - gajar nu halwo' AND i.name = 'caju pak'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2222222222
FROM dishes d, ingredients i
WHERE d.name = 'mithaas - gulab jamun' AND i.name = 'gulab jamun, canned'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'mithaas - ice cream' AND i.name = 'ice cream - any variey'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'mithaas - sev zarda' AND i.name = 'sev zarda'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'mithaas - sooji halwa' AND i.name = 'sooji halwa'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'mithaas - sooji halwa' AND i.name = 'moong daal halwa'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.125
FROM dishes d, ingredients i
WHERE d.name = 'mithaas - tuxedo cake' AND i.name = 'tuxedo cake'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'mixed daal' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.13
FROM dishes d, ingredients i
WHERE d.name = 'mixed daal' AND i.name = 'masoor daal, red'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.12
FROM dishes d, ingredients i
WHERE d.name = 'mixed daal' AND i.name = 'urad daal, whole (black)'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.11
FROM dishes d, ingredients i
WHERE d.name = 'mixed daal' AND i.name = 'chana daal'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.08
FROM dishes d, ingredients i
WHERE d.name = 'mixed daal' AND i.name = 'moong daal, whole (green)'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'mixed daal' AND i.name = 'tomatoes, canned diced'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'mixed daal gosht' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.11
FROM dishes d, ingredients i
WHERE d.name = 'mixed daal gosht' AND i.name = 'masoor daal, red'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'mixed daal gosht' AND i.name = 'urad daal, whole (black)'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'mixed daal gosht' AND i.name = 'chana daal'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.075
FROM dishes d, ingredients i
WHERE d.name = 'mixed daal gosht' AND i.name = 'moong daal, whole (green)'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'mixed daal gosht' AND i.name = 'tomatoes, canned diced'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.45
FROM dishes d, ingredients i
WHERE d.name = 'mixed daal gosht' AND i.name = 'goat cubes'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.1
FROM dishes d, ingredients i
WHERE d.name = 'mixed vegetable tarkari' AND i.name = 'mixed vegetables, frozen'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.4
FROM dishes d, ingredients i
WHERE d.name = 'mixed vegetable tarkari' AND i.name = 'potatoes, red or yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.4
FROM dishes d, ingredients i
WHERE d.name = 'mixed vegetable tarkari' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.4
FROM dishes d, ingredients i
WHERE d.name = 'mixed vegetable tarkari' AND i.name = 'tomato, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'mixed vegetable tarkari' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.25
FROM dishes d, ingredients i
WHERE d.name = 'moong pulao' AND i.name = 'moong daal, whole (green)'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.55
FROM dishes d, ingredients i
WHERE d.name = 'moong pulao' AND i.name = 'rice, basmati'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.25
FROM dishes d, ingredients i
WHERE d.name = 'moong pulao' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.25
FROM dishes d, ingredients i
WHERE d.name = 'moong pulao' AND i.name = 'tomatoes, canned diced'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'moong pulao' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'moong pulao' AND i.name = 'chilies, green fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'mutton khurdhi' AND i.name = 'goat cubes'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'mutton khurdhi' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.12
FROM dishes d, ingredients i
WHERE d.name = 'mutton khurdhi' AND i.name = 'mint leaves, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.12
FROM dishes d, ingredients i
WHERE d.name = 'mutton khurdhi' AND i.name = 'carrots, fresh baby cut'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.18
FROM dishes d, ingredients i
WHERE d.name = 'mutton khurdhi' AND i.name = 'goat paya'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.12
FROM dishes d, ingredients i
WHERE d.name = 'mutton khurdhi' AND i.name = 'celery, whole fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.07
FROM dishes d, ingredients i
WHERE d.name = 'mutton khurdhi' AND i.name = 'milk, whole fat'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'mutton paya' AND i.name = 'goat paya'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.3
FROM dishes d, ingredients i
WHERE d.name = 'mutton paya' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'mutton paya' AND i.name = 'tomatoes, canned diced'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.1
FROM dishes d, ingredients i
WHERE d.name = 'mutton paya' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.25
FROM dishes d, ingredients i
WHERE d.name = 'mutton paya' AND i.name = 'goat cubes'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'navratan korma' AND i.name = 'cauliflower, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.25
FROM dishes d, ingredients i
WHERE d.name = 'navratan korma' AND i.name = 'potatoes, red or yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'navratan korma' AND i.name = 'French beans, whole fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.4
FROM dishes d, ingredients i
WHERE d.name = 'navratan korma' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'navratan korma' AND i.name = 'bell pepper, green'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.3
FROM dishes d, ingredients i
WHERE d.name = 'navratan korma' AND i.name = 'bell pepper, mixed colored'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.12
FROM dishes d, ingredients i
WHERE d.name = 'navratan korma' AND i.name = 'cashews, roasted salted'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'navratan korma' AND i.name = 'half and half'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'navratan korma' AND i.name = 'carrots, whole fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.4
FROM dishes d, ingredients i
WHERE d.name = 'navratan korma' AND i.name = 'tomato, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'navratan korma' AND i.name = 'pineapple chunks, canned'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.3
FROM dishes d, ingredients i
WHERE d.name = 'nihari' AND i.name = 'beef, boneless nihari cut 2" pieces'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.3
FROM dishes d, ingredients i
WHERE d.name = 'nihari' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'nihari' AND i.name = 'chilies, green fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.11
FROM dishes d, ingredients i
WHERE d.name = 'nihari' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'nihari' AND i.name = 'flour, all-purpose unbleached'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.03333333333
FROM dishes d, ingredients i
WHERE d.name = 'nut packet' AND i.name = 'snack nut variety pack, Kirkland Signature'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'olives, green' AND i.name = 'olives, green pimento stuffed'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.3529411765
FROM dishes d, ingredients i
WHERE d.name = 'orange masoor daal' AND i.name = 'masoor daal, red'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2941176471
FROM dishes d, ingredients i
WHERE d.name = 'orange masoor daal' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2058823529
FROM dishes d, ingredients i
WHERE d.name = 'orange masoor daal' AND i.name = 'tomatoes, canned diced'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.08823529412
FROM dishes d, ingredients i
WHERE d.name = 'orange masoor daal' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05882352941
FROM dishes d, ingredients i
WHERE d.name = 'orange masoor daal' AND i.name = 'chilies, green fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.4
FROM dishes d, ingredients i
WHERE d.name = 'paav bhaji' AND i.name = 'potatoes, red or yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.35
FROM dishes d, ingredients i
WHERE d.name = 'paav bhaji' AND i.name = 'cauliflower, frozen riced'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'paav bhaji' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'paav bhaji' AND i.name = 'tomatoes, canned crushed'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'paav bhaji' AND i.name = 'carrots, fresh baby cut'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.25
FROM dishes d, ingredients i
WHERE d.name = 'paav bhaji' AND i.name = 'green peas, frozen'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'paav bhaji' AND i.name = 'bell pepper, green'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.25
FROM dishes d, ingredients i
WHERE d.name = 'paav bhaji' AND i.name = 'brocolli florets, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 4.0
FROM dishes d, ingredients i
WHERE d.name = 'paav bhaji - buns' AND i.name = 'hamburger bun'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'pakorda' AND i.name = 'spinach pakoda, frozen, Deep brand'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.2
FROM dishes d, ingredients i
WHERE d.name = 'palak paneer' AND i.name = 'spinach, frozen chopped'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.45
FROM dishes d, ingredients i
WHERE d.name = 'palak paneer' AND i.name = 'paneer'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.3
FROM dishes d, ingredients i
WHERE d.name = 'palak paneer' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.25
FROM dishes d, ingredients i
WHERE d.name = 'palak paneer' AND i.name = 'tomato, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'palak paneer' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.08
FROM dishes d, ingredients i
WHERE d.name = 'palak paneer' AND i.name = 'yogurt, lowfat'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'palida' AND i.name = 'toor daal, oily'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'palida' AND i.name = 'doodhi'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'palida' AND i.name = 'drumsticks'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.04
FROM dishes d, ingredients i
WHERE d.name = 'palida' AND i.name = 'kokum'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'palida' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'palida' AND i.name = 'tomato, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'palida' AND i.name = 'garlic, whole peeled'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'palida' AND i.name = 'besan (gram flour)'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'panang curry (chicken)' AND i.name = 'chicken legs, cut into 4 pieces'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.25
FROM dishes d, ingredients i
WHERE d.name = 'panang curry (chicken)' AND i.name = 'coconut milk'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'panang curry (chicken)' AND i.name = 'potatoes, red or yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.08
FROM dishes d, ingredients i
WHERE d.name = 'panang curry (chicken)' AND i.name = 'carrots, fresh baby cut'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.25
FROM dishes d, ingredients i
WHERE d.name = 'panang curry (chicken)' AND i.name = 'bell pepper, mixed colored'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'panang curry (chicken)' AND i.name = 'eggplant, Chinese'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.08
FROM dishes d, ingredients i
WHERE d.name = 'panang curry (chicken)' AND i.name = 'mushrooms, white fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.04
FROM dishes d, ingredients i
WHERE d.name = 'panang curry (chicken)' AND i.name = 'galangal, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'panang curry (chicken)' AND i.name = 'lemongrass, whole stalk'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.02
FROM dishes d, ingredients i
WHERE d.name = 'panang curry (chicken)' AND i.name = 'kafir lime leaves, whole'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'panang curry (chicken)' AND i.name = 'basil leaves, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.08
FROM dishes d, ingredients i
WHERE d.name = 'panang curry (chicken)' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'panang curry (chicken)' AND i.name = 'chilies, red fresh (Thai)'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'panang curry (chicken)' AND i.name = 'lime juice'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'panang curry (chicken)' AND i.name = 'garlic, whole peeled'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'panang curry (chicken)' AND i.name = 'peanuts, salted roasted'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.2
FROM dishes d, ingredients i
WHERE d.name = 'paneer jalfrezi' AND i.name = 'paneer'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.5
FROM dishes d, ingredients i
WHERE d.name = 'paneer jalfrezi' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.25
FROM dishes d, ingredients i
WHERE d.name = 'paneer jalfrezi' AND i.name = 'yogurt, lowfat'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.4
FROM dishes d, ingredients i
WHERE d.name = 'paneer jalfrezi' AND i.name = 'tomato, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'paneer jalfrezi' AND i.name = 'bell pepper, mixed colored'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.3
FROM dishes d, ingredients i
WHERE d.name = 'paneer jalfrezi' AND i.name = 'bell pepper, green'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'paneer jalfrezi' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.9
FROM dishes d, ingredients i
WHERE d.name = 'paneer karahi' AND i.name = 'paneer'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.35
FROM dishes d, ingredients i
WHERE d.name = 'paneer karahi' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.12
FROM dishes d, ingredients i
WHERE d.name = 'paneer karahi' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.08
FROM dishes d, ingredients i
WHERE d.name = 'paneer karahi' AND i.name = 'chilies, green fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.5
FROM dishes d, ingredients i
WHERE d.name = 'paneer karahi' AND i.name = 'tomatoes, canned diced'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'paneer karahi' AND i.name = 'tomato paste, canned'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'paneer karahi' AND i.name = 'bell pepper, green'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'paneer karahi' AND i.name = 'yogurt, greek 0% fat'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.9
FROM dishes d, ingredients i
WHERE d.name = 'paneer makhani' AND i.name = 'paneer'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.075
FROM dishes d, ingredients i
WHERE d.name = 'paneer makhani' AND i.name = 'cashews, roasted salted'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'paneer makhani' AND i.name = 'butter, unsalted'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'paneer makhani' AND i.name = 'heavy cream'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.185
FROM dishes d, ingredients i
WHERE d.name = 'paneer makhani' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'paneer makhani' AND i.name = 'milk, whole fat'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.35
FROM dishes d, ingredients i
WHERE d.name = 'paneer makhani' AND i.name = 'tomato sauce, canned'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'paneer makhani' AND i.name = 'butter chicken masala, Shan brand'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'paneer makhani' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.78
FROM dishes d, ingredients i
WHERE d.name = 'paneer tikka masala' AND i.name = 'paneer'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.35
FROM dishes d, ingredients i
WHERE d.name = 'paneer tikka masala' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.12
FROM dishes d, ingredients i
WHERE d.name = 'paneer tikka masala' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.08
FROM dishes d, ingredients i
WHERE d.name = 'paneer tikka masala' AND i.name = 'chilies, green fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'paneer tikka masala' AND i.name = 'cashews, roasted salted'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.5
FROM dishes d, ingredients i
WHERE d.name = 'paneer tikka masala' AND i.name = 'tomato sauce, canned'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'paneer tikka masala' AND i.name = 'bell pepper, red'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.12
FROM dishes d, ingredients i
WHERE d.name = 'paneer tikka masala' AND i.name = 'coconut milk'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.1
FROM dishes d, ingredients i
WHERE d.name = 'pesto ravioli' AND i.name = 'ravioli, spinach and mozzarella (Pasta Prima brand)'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.08
FROM dishes d, ingredients i
WHERE d.name = 'pesto ravioli' AND i.name = 'milk, 1% fat'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.14
FROM dishes d, ingredients i
WHERE d.name = 'pesto ravioli' AND i.name = 'pesto, Kirkland Signature'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.04
FROM dishes d, ingredients i
WHERE d.name = 'pesto ravioli' AND i.name = 'parmesan cheese, grated'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'pollo guisado' AND i.name = 'chicken legs, cut into 4 pieces'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'pollo guisado' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'pollo guisado' AND i.name = 'potatoes, red or yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.08
FROM dishes d, ingredients i
WHERE d.name = 'pollo guisado' AND i.name = 'carrots, fresh baby cut'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'pollo guisado' AND i.name = 'bell pepper, green'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'pollo guisado' AND i.name = 'olives, green pimento stuffed'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'pollo guisado' AND i.name = 'parsley, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'pollo guisado' AND i.name = 'tomato, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.02
FROM dishes d, ingredients i
WHERE d.name = 'pollo guisado' AND i.name = 'chipotle chilies in adobo, Goya brand canned'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.08
FROM dishes d, ingredients i
WHERE d.name = 'pollo guisado' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'pollo guisado' AND i.name = 'garlic, whole peeled'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.333333333
FROM dishes d, ingredients i
WHERE d.name = 'punjabi baingan ka bharta' AND i.name = 'eggplant, regular'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.4666666667
FROM dishes d, ingredients i
WHERE d.name = 'punjabi baingan ka bharta' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.4
FROM dishes d, ingredients i
WHERE d.name = 'punjabi baingan ka bharta' AND i.name = 'tomatoes, canned diced'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.3333333333
FROM dishes d, ingredients i
WHERE d.name = 'punjabi baingan ka bharta' AND i.name = 'bell pepper, green'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1333333333
FROM dishes d, ingredients i
WHERE d.name = 'punjabi baingan ka bharta' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.6
FROM dishes d, ingredients i
WHERE d.name = 'raita' AND i.name = 'yogurt, whole milk'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'raita' AND i.name = 'cucumber, English'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'raita' AND i.name = 'onions, red'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'raita' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'raita' AND i.name = 'mint leaves, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.1
FROM dishes d, ingredients i
WHERE d.name = 'ravioli Florentine' AND i.name = 'ravioli, spinach and mozzarella (Pasta Prima brand)'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'ravioli Florentine' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'ravioli Florentine' AND i.name = 'spinach, frozen chopped'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.08
FROM dishes d, ingredients i
WHERE d.name = 'ravioli Florentine' AND i.name = 'mushrooms, white fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.04
FROM dishes d, ingredients i
WHERE d.name = 'ravioli Florentine' AND i.name = 'parmesan cheese, grated'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.3
FROM dishes d, ingredients i
WHERE d.name = 'ravioli Florentine' AND i.name = 'pasta sauce, Ragu brand'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'ravioli Florentine' AND i.name = 'half and half'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.02
FROM dishes d, ingredients i
WHERE d.name = 'ravioli Florentine' AND i.name = 'heavy cream'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'salad - English cumbers' AND i.name = 'cucumber, English'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.333
FROM dishes d, ingredients i
WHERE d.name = 'salad - Romaine lettuce' AND i.name = 'lettuce, Romaine whole head'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'salad - bell peppers' AND i.name = 'bell pepper, mixed colored'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 2.0
FROM dishes d, ingredients i
WHERE d.name = 'salad - carrots' AND i.name = 'carrots, fresh baby cut'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'salad - mixed greens lettuce' AND i.name = 'lettuce, Spring Mix (mixed greens)'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.0625
FROM dishes d, ingredients i
WHERE d.name = 'shahi tukda' AND i.name = 'potato bread, Martin''s brand'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.0625
FROM dishes d, ingredients i
WHERE d.name = 'shahi tukda' AND i.name = 'milk, whole fat'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'shahi tukda' AND i.name = 'milk, sweetened condensed canned'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'shahi tukda' AND i.name = 'sugar'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.03
FROM dishes d, ingredients i
WHERE d.name = 'shahi tukda' AND i.name = 'almonds, sliced'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.03
FROM dishes d, ingredients i
WHERE d.name = 'shahi tukda' AND i.name = 'pistachios, whole shelled'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.025
FROM dishes d, ingredients i
WHERE d.name = 'shahi tukda' AND i.name = 'butter, unsalted'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'sheer khurma' AND i.name = 'sev vermicelli'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'sheer khurma' AND i.name = 'raisins, golden'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'sheer khurma' AND i.name = 'kharak'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'sheer khurma' AND i.name = 'saffron'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'sheer khurma' AND i.name = 'milk, evaporated canned'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'sheer khurma' AND i.name = 'sugar'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.55
FROM dishes d, ingredients i
WHERE d.name = 'sloppy joes' AND i.name = 'chicken thigh, ground'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.03
FROM dishes d, ingredients i
WHERE d.name = 'sloppy joes' AND i.name = 'mustard, yellow spicy'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'sloppy joes' AND i.name = 'tomato sauce, canned'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'sloppy joes' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'sloppy joes' AND i.name = 'bell pepper, green'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.5
FROM dishes d, ingredients i
WHERE d.name = 'sloppy joes' AND i.name = 'beef, ground 85% lean (frozen)'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 6.0
FROM dishes d, ingredients i
WHERE d.name = 'sloppy joes' AND i.name = 'hamburger bun'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.25
FROM dishes d, ingredients i
WHERE d.name = 'sooji halwa' AND i.name = 'semolina, fine (sooji)'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'sooji halwa' AND i.name = 'raisins, golden'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.12
FROM dishes d, ingredients i
WHERE d.name = 'sooji halwa' AND i.name = 'sugar'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 10.0
FROM dishes d, ingredients i
WHERE d.name = 'sooji halwa' AND i.name = 'chironji'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.3
FROM dishes d, ingredients i
WHERE d.name = 'sooji halwa' AND i.name = 'milk, evaporated canned'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.12
FROM dishes d, ingredients i
WHERE d.name = 'sooji halwa' AND i.name = 'ghee'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'sooji halwa' AND i.name = 'almonds, sliced'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.08
FROM dishes d, ingredients i
WHERE d.name = 'sooji halwa' AND i.name = 'butter, unsalted'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.5
FROM dishes d, ingredients i
WHERE d.name = 'sweet and sour chicken over rice' AND i.name = 'chicken thigh, boneless cut 1" pieces'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'sweet and sour chicken over rice' AND i.name = 'bell pepper, green'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'sweet and sour chicken over rice' AND i.name = 'cabbage, Napa'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'sweet and sour chicken over rice' AND i.name = 'carrots, whole fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'sweet and sour chicken over rice' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'sweet and sour chicken over rice' AND i.name = 'pineapple chunks, canned'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'sweet and sour chicken over rice' AND i.name = 'brocolli florets, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.025
FROM dishes d, ingredients i
WHERE d.name = 'sweet and sour chicken over rice' AND i.name = 'ketchup'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.4
FROM dishes d, ingredients i
WHERE d.name = 'tahini sauce' AND i.name = 'tahini paste'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'tahini sauce' AND i.name = 'lemon juice'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'tahini sauce' AND i.name = 'water'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'tahini sauce' AND i.name = 'garlic, whole peeled'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.75
FROM dishes d, ingredients i
WHERE d.name = 'tandoori chicken legs' AND i.name = 'chicken legs, whole skin off'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.07
FROM dishes d, ingredients i
WHERE d.name = 'tandoori chicken legs' AND i.name = 'yogurt, lowfat'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'tandoori chicken legs' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'tandoori chicken legs' AND i.name = 'tandoori masala, Shan brand'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.02
FROM dishes d, ingredients i
WHERE d.name = 'tandoori chicken legs' AND i.name = 'lemon juice'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 2.0
FROM dishes d, ingredients i
WHERE d.name = 'tindoora fry' AND i.name = 'tindoora, frozen'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'tindoora fry' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'tindoora fry' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.35
FROM dishes d, ingredients i
WHERE d.name = 'tomato soup' AND i.name = 'tomato sauce, canned'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.04
FROM dishes d, ingredients i
WHERE d.name = 'tomato soup' AND i.name = 'milk, whole fat'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.125
FROM dishes d, ingredients i
WHERE d.name = 'tomato soup' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'tomato soup' AND i.name = 'celery, whole fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'tomato soup' AND i.name = 'corn, frozen kernels'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.09
FROM dishes d, ingredients i
WHERE d.name = 'tomato soup' AND i.name = 'carrots, fresh baby cut'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.45
FROM dishes d, ingredients i
WHERE d.name = 'vegetable biryani' AND i.name = 'rice, basmati'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.65
FROM dishes d, ingredients i
WHERE d.name = 'vegetable biryani' AND i.name = 'mixed vegetables, frozen'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.23
FROM dishes d, ingredients i
WHERE d.name = 'vegetable biryani' AND i.name = 'yogurt, whole milk'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'vegetable biryani' AND i.name = 'birista'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.045
FROM dishes d, ingredients i
WHERE d.name = 'vegetable biryani' AND i.name = 'tomato sauce, canned'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.13
FROM dishes d, ingredients i
WHERE d.name = 'vegetable biryani' AND i.name = 'mint leaves, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.17
FROM dishes d, ingredients i
WHERE d.name = 'vegetable biryani' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'vegetable biryani' AND i.name = 'Sindhi biryani masala, Shan brand'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'vegetable biryani' AND i.name = 'potatoes, red or yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'vegetable biryani' AND i.name = 'eggplant, Indian'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.4
FROM dishes d, ingredients i
WHERE d.name = 'vegetable hakka noodles' AND i.name = 'hakka noodles, Ching''s Secret'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.5
FROM dishes d, ingredients i
WHERE d.name = 'vegetable hakka noodles' AND i.name = 'scallions, fresh (green onions)'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.18
FROM dishes d, ingredients i
WHERE d.name = 'vegetable hakka noodles' AND i.name = 'carrots, shredded'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.25
FROM dishes d, ingredients i
WHERE d.name = 'vegetable hakka noodles' AND i.name = 'cabbage, green'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'vegetable hakka noodles' AND i.name = 'mushrooms, white fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.17
FROM dishes d, ingredients i
WHERE d.name = 'vegetable hakka noodles' AND i.name = 'bell pepper, green'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'vegetable hakka noodles' AND i.name = 'chilies, green fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.02
FROM dishes d, ingredients i
WHERE d.name = 'vegetable hakka noodles' AND i.name = 'soy sauce'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.01
FROM dishes d, ingredients i
WHERE d.name = 'vegetable hakka noodles' AND i.name = 'vinegar, white'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'vegetable hakka noodles' AND i.name = 'sesame oil'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'vegetable hakka noodles' AND i.name = 'garlic, whole peeled'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'vegetable hakka noodles' AND i.name = 'Sri racha chile sauce'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.5
FROM dishes d, ingredients i
WHERE d.name = 'vegetable hakka noodles' AND i.name = 'chowmein hakka noodle masala, Ching''s Secret brand'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.6
FROM dishes d, ingredients i
WHERE d.name = 'vegetable korma' AND i.name = 'mixed vegetables, frozen'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.25
FROM dishes d, ingredients i
WHERE d.name = 'vegetable korma' AND i.name = 'potatoes, red or yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.27
FROM dishes d, ingredients i
WHERE d.name = 'vegetable korma' AND i.name = 'brocolli florets, fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.25
FROM dishes d, ingredients i
WHERE d.name = 'vegetable korma' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.3
FROM dishes d, ingredients i
WHERE d.name = 'vegetable korma' AND i.name = 'yogurt, lowfat'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'vegetable korma' AND i.name = 'korma masala, Shan brand'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.075
FROM dishes d, ingredients i
WHERE d.name = 'vegetable korma' AND i.name = 'cashews, roasted salted'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.17
FROM dishes d, ingredients i
WHERE d.name = 'vegetable korma' AND i.name = 'coconut milk'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'vegetable lasagne' AND i.name = 'mozzarella cheese, shredded'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.235
FROM dishes d, ingredients i
WHERE d.name = 'vegetable lasagne' AND i.name = 'lasagne noodles, no-boil variety'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'vegetable lasagne' AND i.name = 'pasta sauce, Ragu brand'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'vegetable lasagne' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'vegetable lasagne' AND i.name = 'mushrooms, white fresh'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.15
FROM dishes d, ingredients i
WHERE d.name = 'vegetable lasagne' AND i.name = 'bell pepper, red'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.4
FROM dishes d, ingredients i
WHERE d.name = 'vegetable lasagne' AND i.name = 'ricotta cheese, whole milk'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'vegetable lasagne' AND i.name = 'zucchini'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.05
FROM dishes d, ingredients i
WHERE d.name = 'vegetable lasagne' AND i.name = 'parmesan cheese, grated'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.55
FROM dishes d, ingredients i
WHERE d.name = 'white rice' AND i.name = 'rice, basmati'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'whole chicken in white sauce' AND i.name = 'chicken, whole baby skin off'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'whole chicken in white sauce' AND i.name = 'cashews, roasted salted'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.2
FROM dishes d, ingredients i
WHERE d.name = 'whole chicken in white sauce' AND i.name = 'yogurt, whole milk'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.03
FROM dishes d, ingredients i
WHERE d.name = 'whole chicken in white sauce' AND i.name = 'milk, whole fat'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.025
FROM dishes d, ingredients i
WHERE d.name = 'whole chicken in white sauce' AND i.name = 'tahini paste'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'whole chicken in white sauce' AND i.name = 'onions, yellow'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.07
FROM dishes d, ingredients i
WHERE d.name = 'whole chicken in white sauce' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.04
FROM dishes d, ingredients i
WHERE d.name = 'whole chicken in white sauce' AND i.name = 'half and half'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 1.0
FROM dishes d, ingredients i
WHERE d.name = 'whole chicken keit (red sauce)' AND i.name = 'chicken, whole baby skin off'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'whole chicken keit (red sauce)' AND i.name = 'birista'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.3
FROM dishes d, ingredients i
WHERE d.name = 'whole chicken keit (red sauce)' AND i.name = 'tomatoes, canned crushed'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'whole chicken keit (red sauce)' AND i.name = 'cilantro'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
INSERT INTO dish_ingredients (dish_id, ingredient_id, qty_per_quart)
SELECT d.id, i.id, 0.1
FROM dishes d, ingredients i
WHERE d.name = 'whole chicken keit (red sauce)' AND i.name = 'yogurt, whole milk'
ON CONFLICT (dish_id, ingredient_id) DO UPDATE SET qty_per_quart = EXCLUDED.qty_per_quart;
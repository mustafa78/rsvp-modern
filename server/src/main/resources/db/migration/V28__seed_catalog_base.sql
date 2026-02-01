-- V30: Seed catalog base tables (categories, units, stores, storage locations)
-- Must run after V29

-- Clear dependent data first (ingredients reference these)
DELETE FROM dish_ingredients;
DELETE FROM dishes;
DELETE FROM ingredients;

-- Clear base catalog tables
DELETE FROM ingredient_categories;
DELETE FROM ingredient_units;
DELETE FROM ingredient_stores;
DELETE FROM ingredient_storage_locations;

-- Insert categories
INSERT INTO ingredient_categories (id, name, display_order, active, created_at, updated_at) VALUES
(1, 'produce', 1, true, now(), now()),
(2, 'meat', 2, true, now(), now()),
(3, 'dairy', 3, true, now(), now()),
(4, 'non-perishable', 4, true, now(), now()),
(5, 'frozen', 5, true, now(), now()),
(6, 'pantry', 6, true, now(), now()),
(7, 'bread', 7, true, now(), now()),
(8, 'spices', 8, true, now(), now()),
(9, 'beverages', 9, true, now(), now()),
(10, 'shelf', 100, true, now(), now()),
(11, 'perishable', 100, true, now(), now()),
(12, 'other', 100, true, now(), now()),
(13, 'refrigerator', 100, true, now(), now());

SELECT setval('ingredient_categories_id_seq', (SELECT MAX(id) FROM ingredient_categories));

-- Insert units
INSERT INTO ingredient_units (id, name, display_order, active, created_at, updated_at) VALUES
(1, 'gm', 1, true, now(), now()),
(2, 'kg', 2, true, now(), now()),
(3, 'lb', 3, true, now(), now()),
(4, 'oz', 4, true, now(), now()),
(5, 'tsp', 5, true, now(), now()),
(6, 'tbsp', 6, true, now(), now()),
(7, 'cup', 7, true, now(), now()),
(8, 'ml', 8, true, now(), now()),
(9, 'ltr', 9, true, now(), now()),
(10, 'piece', 10, true, now(), now()),
(11, 'bunch', 11, true, now(), now()),
(12, 'can', 12, true, now(), now()),
(13, 'box', 13, true, now(), now()),
(14, 'bag', 14, true, now(), now()),
(15, 'jar', 15, true, now(), now()),
(16, 'handful', 16, true, now(), now()),
(17, 'quart', 17, true, now(), now()),
(18, '48 oz', 100, true, now(), now()),
(19, '36 cnt packet', 100, true, now(), now()),
(20, '100 gm', 100, true, now(), now()),
(21, 'count', 100, true, now(), now()),
(22, 'gallon', 100, true, now(), now()),
(23, 'bottles', 100, true, now(), now()),
(24, 'stalk', 100, true, now(), now()),
(25, 'pieces', 100, true, now(), now()),
(26, '24 oz bottle', 100, true, now(), now()),
(27, '100 cnt box', 100, true, now(), now()),
(28, '32 roll packet', 100, true, now(), now()),
(29, '6-pack', 100, true, now(), now()),
(30, 'dozen', 100, true, now(), now()),
(31, '30-cnt box', 100, true, now(), now()),
(32, '3-pack', 100, true, now(), now()),
(33, 'bird', 100, true, now(), now()),
(34, '20 cnt pack', 100, true, now(), now()),
(35, '32 oz jar', 100, true, now(), now()),
(36, 'unit', 100, true, now(), now()),
(37, 'bottle', 100, true, now(), now()),
(38, 'bun', 100, true, now(), now()),
(39, 'cake', 100, true, now(), now()),
(40, '96 oz bottle', 100, true, now(), now()),
(41, 'loaf', 100, true, now(), now()),
(42, 'packet', 100, true, now(), now()),
(43, 'each', 99, true, now(), now());

SELECT setval('ingredient_units_id_seq', (SELECT MAX(id) FROM ingredient_units));

-- Insert stores
INSERT INTO ingredient_stores (id, name, display_order, active, created_at, updated_at) VALUES
(1, 'Costco', 1, true, now(), now()),
(2, 'Indian', 2, true, now(), now()),
(3, 'Grocery', 3, true, now(), now()),
(4, 'Walmart', 4, true, now(), now()),
(5, 'Target', 5, true, now(), now()),
(6, 'Amazon', 6, true, now(), now()),
(7, 'Indus', 2, true, now(), now()),
(8, 'Indian Store', 100, true, now(), now()),
(9, 'Korean', 100, true, now(), now()),
(10, 'Restaurant Depot', 100, true, now(), now());

SELECT setval('ingredient_stores_id_seq', (SELECT MAX(id) FROM ingredient_stores));

-- Insert storage locations
INSERT INTO ingredient_storage_locations (id, name, display_order, active, created_at, updated_at) VALUES
(1, 'refrigerator', 1, true, now(), now()),
(2, 'freezer', 2, true, now(), now()),
(3, 'pantry', 3, true, now(), now()),
(4, 'spice rack', 4, true, now(), now()),
(5, 'counter', 5, true, now(), now()),
(6, 'dry storage', 6, true, now(), now()),
(7, 'FMB Storage, Mardo Sehen', 7, true, now(), now()),
(8, 'Electrical Room', 8, true, now(), now()),
(9, 'refrigerator rack, bottom shelf', 100, true, now(), now()),
(10, 'door rack, bottom shelf', 100, true, now(), now()),
(11, 'stove prep table middle shelf', 100, true, now(), now()),
(12, 'stove prep table bottom shelf', 100, true, now(), now()),
(13, 'dishwasher rack bottom shelf', 100, true, now(), now()),
(14, 'white freezer', 100, true, now(), now()),
(15, 'dishwasher shelf', 100, true, now(), now()),
(16, 'prep table, bottom shelf', 100, true, now(), now()),
(17, 'silver freezer', 100, true, now(), now()),
(18, 'mawaid table', 100, true, now(), now()),
(19, 'refrigerator rack, top shelf', 100, true, now(), now()),
(20, 'door rack, 2nd shelf', 100, true, now(), now()),
(21, 'mawaid', 100, true, now(), now()),
(22, 'stove prep table shelf', 100, true, now(), now()),
(23, 'dishwasher rack, bottom shelf', 100, true, now(), now()),
(24, 'shelf', 100, true, now(), now()),
(25, 'white refrigerator', 100, true, now(), now()),
(26, 'refrigerator rack, 2nd shelf', 100, true, now(), now()),
(27, 'refrigerator rack, middle upper shelf', 100, true, now(), now()),
(28, 'refrigerator rack, middle shelf', 100, true, now(), now()),
(29, 'door rack, top shelf', 100, true, now(), now()),
(30, 'door rack, lower middle shelf', 100, true, now(), now());

SELECT setval('ingredient_storage_locations_id_seq', (SELECT MAX(id) FROM ingredient_storage_locations));

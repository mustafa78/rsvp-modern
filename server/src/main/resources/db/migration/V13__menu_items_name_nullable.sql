-- V13: Make menu_items.name nullable since the name now comes from the linked dish
-- The old name column is kept for backwards compatibility with any legacy data

ALTER TABLE menu_items ALTER COLUMN name DROP NOT NULL;

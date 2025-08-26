-- V4: widen menu_items.position to INTEGER
ALTER TABLE menu_items
  ALTER COLUMN position TYPE INTEGER USING position::integer;
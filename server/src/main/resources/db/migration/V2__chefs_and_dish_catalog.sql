-- V3: Introduce 'chefs' (independent of people/persons), a reusable dish catalog,
-- and make menu_items reference dishes. Keep old event_person_chefs if present.

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema='public' AND table_name='event_chefs') THEN
    IF EXISTS (
      SELECT 1 FROM information_schema.columns 
      WHERE table_schema='public' AND table_name='event_chefs' AND column_name='person_id'
    ) THEN
      EXECUTE 'ALTER TABLE public.event_chefs RENAME TO event_person_chefs';
    END IF;
  END IF;
EXCEPTION WHEN OTHERS THEN
  -- no-op for idempotency
END$$;

-- 1) Chefs independent table
CREATE TABLE IF NOT EXISTS chefs (
  id BIGSERIAL PRIMARY KEY,
  name TEXT NOT NULL UNIQUE,
  type TEXT NOT NULL DEFAULT 'GROUP' CHECK (type IN ('PERSON','GROUP','EXTERNAL')),
  email TEXT,
  phone TEXT,
  notes TEXT,
  active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 2) Event↔Chef join
CREATE TABLE IF NOT EXISTS event_chefs (
  event_id BIGINT NOT NULL REFERENCES events(id) ON DELETE CASCADE,
  chef_id  BIGINT NOT NULL REFERENCES chefs(id)  ON DELETE RESTRICT,
  role TEXT,
  PRIMARY KEY (event_id, chef_id)
);

-- 3) Dish catalog + per-quart recipe
CREATE TABLE IF NOT EXISTS dishes (
  id BIGSERIAL PRIMARY KEY,
  name TEXT NOT NULL UNIQUE,
  description TEXT,
  default_quarts_per_thaali_unit NUMERIC(6,2) NOT NULL DEFAULT 1.00,
  active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS dish_ingredients (
  dish_id BIGINT NOT NULL REFERENCES dishes(id) ON DELETE CASCADE,
  ingredient_id BIGINT NOT NULL REFERENCES ingredients(id) ON DELETE RESTRICT,
  qty_per_quart NUMERIC(10,3) NOT NULL,
  PRIMARY KEY (dish_id, ingredient_id)
);

-- 4) Menu items now point to a dish (optional override + sort position)
ALTER TABLE menu_items
  ADD COLUMN IF NOT EXISTS dish_id BIGINT,
  ADD COLUMN IF NOT EXISTS position SMALLINT;

ALTER TABLE menu_items
  ADD CONSTRAINT IF NOT EXISTS fk_menu_items_dish
  FOREIGN KEY (dish_id) REFERENCES dishes(id) ON DELETE RESTRICT;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_indexes WHERE schemaname='public' AND indexname = 'uk_menu_items_event_dish'
  ) THEN
    EXECUTE 'CREATE UNIQUE INDEX uk_menu_items_event_dish ON public.menu_items(event_id, dish_id) WHERE dish_id IS NOT NULL';
  END IF;
END$$;

-- 5) Helper view for computing per-event ingredient needs (per Thaali unit)
CREATE OR REPLACE VIEW v_event_menu_dish_ingredients AS
SELECT mi.event_id,
       mi.id AS menu_item_id,
       d.id  AS dish_id,
       di.ingredient_id,
       di.qty_per_quart,
       COALESCE(mi.quarts_per_thaali_unit, d.default_quarts_per_thaali_unit) AS quarts_per_thaali_unit
FROM menu_items mi
JOIN dishes d ON d.id = mi.dish_id
JOIN dish_ingredients di ON di.dish_id = d.id;

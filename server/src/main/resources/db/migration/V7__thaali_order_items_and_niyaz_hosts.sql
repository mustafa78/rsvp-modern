-- V7: Restructure ThaaliOrder to use order items (per menu item) and add Niyaz hosts

-- ============================================
-- 1) Create thaali_order_items table
-- ============================================
CREATE TABLE IF NOT EXISTS thaali_order_items (
  id BIGSERIAL PRIMARY KEY,
  order_id BIGINT NOT NULL REFERENCES thaali_orders(id) ON DELETE CASCADE,
  menu_item_id BIGINT NOT NULL REFERENCES menu_items(id) ON DELETE CASCADE,
  size VARCHAR(16) NOT NULL, -- LARGE, SMALL, BARAKATI
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT uc_order_menu_item UNIQUE (order_id, menu_item_id)
);

CREATE INDEX IF NOT EXISTS ix_thaali_order_items_order ON thaali_order_items(order_id);
CREATE INDEX IF NOT EXISTS ix_thaali_order_items_menu_item ON thaali_order_items(menu_item_id);

-- ============================================
-- 2) Migrate existing orders to new structure
--    For each existing order with counts > 0, create order items
--    This assumes menu_items exist for the event
-- ============================================
DO $$
DECLARE
  rec RECORD;
  menu_item_rec RECORD;
  item_count INT;
  size_name VARCHAR(16);
BEGIN
  -- Only migrate if old columns exist
  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema='public'
      AND table_name='thaali_orders'
      AND column_name='large_count'
  ) THEN
    -- For each existing order
    FOR rec IN SELECT id, event_id, large_count, small_count, barakati_count FROM thaali_orders LOOP
      -- Get menu items for this event (ordered by position)
      item_count := 0;
      FOR menu_item_rec IN
        SELECT id FROM menu_items WHERE event_id = rec.event_id ORDER BY position, id
      LOOP
        item_count := item_count + 1;

        -- Determine size based on position (best effort migration)
        -- First item gets LARGE if large_count > 0, etc.
        IF item_count = 1 AND rec.large_count > 0 THEN
          size_name := 'LARGE';
        ELSIF item_count = 2 AND rec.small_count > 0 THEN
          size_name := 'SMALL';
        ELSIF item_count = 3 AND rec.barakati_count > 0 THEN
          size_name := 'BARAKATI';
        ELSE
          -- Skip if no count for this position
          CONTINUE;
        END IF;

        -- Insert order item (ignore conflicts)
        INSERT INTO thaali_order_items (order_id, menu_item_id, size)
        VALUES (rec.id, menu_item_rec.id, size_name)
        ON CONFLICT (order_id, menu_item_id) DO NOTHING;

        -- Only process first 3 menu items for migration
        IF item_count >= 3 THEN
          EXIT;
        END IF;
      END LOOP;
    END LOOP;
  END IF;
END$$;

-- ============================================
-- 3) Drop old count columns from thaali_orders
-- ============================================
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema='public'
      AND table_name='thaali_orders'
      AND column_name='large_count'
  ) THEN
    ALTER TABLE thaali_orders DROP COLUMN large_count;
  END IF;

  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema='public'
      AND table_name='thaali_orders'
      AND column_name='small_count'
  ) THEN
    ALTER TABLE thaali_orders DROP COLUMN small_count;
  END IF;

  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema='public'
      AND table_name='thaali_orders'
      AND column_name='barakati_count'
  ) THEN
    ALTER TABLE thaali_orders DROP COLUMN barakati_count;
  END IF;
END$$;

-- ============================================
-- 4) Create niyaz_event_hosts join table
-- ============================================
CREATE TABLE IF NOT EXISTS niyaz_event_hosts (
  event_id BIGINT NOT NULL REFERENCES events(id) ON DELETE CASCADE,
  person_id BIGINT NOT NULL REFERENCES persons(id) ON DELETE CASCADE,
  PRIMARY KEY (event_id, person_id)
);

CREATE INDEX IF NOT EXISTS ix_niyaz_event_hosts_person ON niyaz_event_hosts(person_id);

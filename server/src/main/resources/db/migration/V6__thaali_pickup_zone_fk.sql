-- V6: Move ThaaliOrder.pickupZone to FK (pickup_zone_id) referencing pickup_zones

-- 1) Ensure pickup_zones exists (idempotent)
CREATE TABLE IF NOT EXISTS pickup_zones (
  id BIGSERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE,
  active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 2) Seed common zones (safe due to UNIQUE name)
INSERT INTO pickup_zones (name, active) VALUES
  ('SELF_PICKUP_NAJMI_MASJID', true),
  ('NORTH_POTOMAC_ROCKVILLE', true),
  ('GERMANTOWN', true),
  ('WASHINGTON_DC', true),
  ('FREDERICK', true),
  ('ELLICOTT_CITY_COLUMBIA', true),
  ('CLARKSVILLE', true)
ON CONFLICT (name) DO NOTHING;

-- 3) Add pickup_zone_id column if missing
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema='public'
      AND table_name='thaali_orders'
      AND column_name='pickup_zone_id'
  ) THEN
    ALTER TABLE thaali_orders ADD COLUMN pickup_zone_id BIGINT;
  END IF;
END$$;

-- 4) If old enum/string column exists, migrate by name -> FK id
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema='public'
      AND table_name='thaali_orders'
      AND column_name='pickup_zone'
  ) THEN
    UPDATE thaali_orders o
       SET pickup_zone_id = z.id
      FROM pickup_zones z
     WHERE o.pickup_zone_id IS NULL
       AND o.pickup_zone = z.name;

    -- drop the old column after migration
    ALTER TABLE thaali_orders DROP COLUMN pickup_zone;
  END IF;
END$$;

-- 5) Default any remaining NULLs to 'Germantown' (if present)
UPDATE thaali_orders o
   SET pickup_zone_id = (SELECT id FROM pickup_zones WHERE name='Germantown' LIMIT 1)
 WHERE o.pickup_zone_id IS NULL
   AND EXISTS (SELECT 1 FROM pickup_zones WHERE name='Germantown');

-- 6) Add FK only if it doesn't exist
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
      FROM pg_constraint
     WHERE conname = 'fk_thaali_orders_pickup_zone'
  ) THEN
    EXECUTE 'ALTER TABLE thaali_orders
               ADD CONSTRAINT fk_thaali_orders_pickup_zone
               FOREIGN KEY (pickup_zone_id) REFERENCES pickup_zones(id)';
  END IF;
END$$;

-- 7) Helpful index (IF NOT EXISTS is supported for indexes)
CREATE INDEX IF NOT EXISTS ix_thaali_orders_pickup_zone
  ON thaali_orders(pickup_zone_id);

-- 8) Enforce NOT NULL if the column is still nullable
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.columns
     WHERE table_schema='public'
       AND table_name='thaali_orders'
       AND column_name='pickup_zone_id'
       AND is_nullable='YES'
  ) THEN
    EXECUTE 'ALTER TABLE thaali_orders ALTER COLUMN pickup_zone_id SET NOT NULL';
  END IF;
END$$;

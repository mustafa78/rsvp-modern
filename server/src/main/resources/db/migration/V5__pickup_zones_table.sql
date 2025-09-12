-- V5: pickup_zones table + FK on people/persons/person; seed from your former enum

CREATE TABLE IF NOT EXISTS pickup_zones (
  id BIGSERIAL PRIMARY KEY,
  name TEXT NOT NULL UNIQUE,
  active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

INSERT INTO pickup_zones (name, active) VALUES
  ('SELF_PICKUP_NAJMI_MASJID', true),
  ('NORTH_POTOMAC_ROCKVILLE', true),
  ('GERMANTOWN', true),
  ('WASHINGTON_DC', true),
  ('FREDERICK', true),
  ('ELLICOTT_CITY_COLUMBIA', true),
  ('CLARKSVILLE', true)
ON CONFLICT (name) DO NOTHING;

DO $$
BEGIN
  -- add pickup_zone_id to whichever table you use for Person
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema='public' AND table_name='people') THEN
    EXECUTE 'ALTER TABLE public.people ADD COLUMN IF NOT EXISTS pickup_zone_id BIGINT REFERENCES pickup_zones(id)';
    EXECUTE 'ALTER TABLE public.people DROP COLUMN IF EXISTS pickup_zone';
  ELSIF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema='public' AND table_name='persons') THEN
    EXECUTE 'ALTER TABLE public.persons ADD COLUMN IF NOT EXISTS pickup_zone_id BIGINT REFERENCES pickup_zones(id)';
    EXECUTE 'ALTER TABLE public.persons DROP COLUMN IF EXISTS pickup_zone';
  ELSIF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema='public' AND table_name='person') THEN
    EXECUTE 'ALTER TABLE public.person ADD COLUMN IF NOT EXISTS pickup_zone_id BIGINT REFERENCES pickup_zones(id)';
    EXECUTE 'ALTER TABLE public.person DROP COLUMN IF EXISTS pickup_zone';
  END IF;
END $$;
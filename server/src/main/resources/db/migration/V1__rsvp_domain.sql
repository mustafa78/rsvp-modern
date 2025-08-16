-- Flyway V2: RSVP domain (persons, events, menus, ingredients, orders, rsvps)
CREATE TABLE IF NOT EXISTS persons (
  id BIGSERIAL PRIMARY KEY,
  its_number VARCHAR(32) NOT NULL UNIQUE,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  phone VARCHAR(32),
  email VARCHAR(255) NOT NULL UNIQUE,
  pickup_zone VARCHAR(64) NOT NULL DEFAULT 'SELF_PICKUP_NAJMI_MASJID',
  password_hash VARCHAR(100) NOT NULL,
  account_status VARCHAR(16) NOT NULL DEFAULT 'ACTIVE',
  reset_token VARCHAR(100),
  reset_expires_at TIMESTAMPTZ,
  failed_login_count INTEGER NOT NULL DEFAULT 0,
  last_login_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT chk_person_account_status CHECK (account_status IN ('ACTIVE','LOCKED','DISABLED')),
  CONSTRAINT chk_person_pickup_zone CHECK (pickup_zone IN (
      'SELF_PICKUP_NAJMI_MASJID','NORTH_POTOMAC_ROCKVILLE','GERMANTOWN','WASHINGTON_DC','FREDERICK','ELLICOTT_CITY_COLUMBIA','CLARKSVILLE'
  ))
);
CREATE TABLE IF NOT EXISTS person_roles (
  person_id BIGINT NOT NULL REFERENCES persons(id) ON DELETE CASCADE,
  role VARCHAR(32) NOT NULL,
  PRIMARY KEY (person_id, role),
  CONSTRAINT chk_person_role CHECK (role IN ('USER','SUPER_USER','ADMIN'))
);
CREATE TABLE IF NOT EXISTS events (
  id BIGSERIAL PRIMARY KEY,
  event_type VARCHAR(16) NOT NULL,
  title VARCHAR(200),
  description VARCHAR(2000),
  event_date DATE NOT NULL,
  start_time TIME,
  registration_open_at TIMESTAMPTZ NOT NULL,
  registration_close_at TIMESTAMPTZ NOT NULL,
  status VARCHAR(16) NOT NULL DEFAULT 'DRAFT',
  miqaat_name VARCHAR(200),
  miqaat_date DATE,
  miqaat_time TIME,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT chk_event_status CHECK (status IN ('DRAFT','PUBLISHED','CANCELLED')),
  CONSTRAINT chk_event_type CHECK (event_type IN ('NIYAZ','THAALI'))
);
CREATE INDEX IF NOT EXISTS ix_event_date ON events(event_date);
CREATE TABLE IF NOT EXISTS event_chefs (
  event_id BIGINT NOT NULL REFERENCES events(id) ON DELETE CASCADE,
  person_id BIGINT NOT NULL REFERENCES persons(id) ON DELETE CASCADE,
  PRIMARY KEY (event_id, person_id)
);
CREATE TABLE IF NOT EXISTS menu_items (
  id BIGSERIAL PRIMARY KEY,
  event_id BIGINT NOT NULL REFERENCES events(id) ON DELETE CASCADE,
  name VARCHAR(200) NOT NULL,
  description VARCHAR(1000),
  quarts_per_thaali_unit NUMERIC(19,6) NOT NULL DEFAULT 1.0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS ix_menu_items_event ON menu_items(event_id);
CREATE TABLE IF NOT EXISTS ingredients (
  id BIGSERIAL PRIMARY KEY,
  name VARCHAR(200) NOT NULL UNIQUE,
  unit VARCHAR(32) NOT NULL,
  notes VARCHAR(500),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE TABLE IF NOT EXISTS menu_item_ingredients (
  menu_item_id BIGINT NOT NULL REFERENCES menu_items(id) ON DELETE CASCADE,
  ingredient_id BIGINT NOT NULL REFERENCES ingredients(id) ON DELETE CASCADE,
  qty_per_quart NUMERIC(19,6) NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  PRIMARY KEY (menu_item_id, ingredient_id)
);
CREATE TABLE IF NOT EXISTS niyaz_rsvps (
  id BIGSERIAL PRIMARY KEY,
  event_id BIGINT NOT NULL REFERENCES events(id) ON DELETE CASCADE,
  person_id BIGINT NOT NULL REFERENCES persons(id) ON DELETE CASCADE,
  adults INTEGER NOT NULL DEFAULT 0,
  kids INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT uc_niyaz_event_person UNIQUE (event_id, person_id),
  CONSTRAINT chk_niyaz_counts_nonneg CHECK (adults >= 0 AND kids >= 0)
);
CREATE INDEX IF NOT EXISTS ix_niyaz_event ON niyaz_rsvps(event_id);
CREATE TABLE IF NOT EXISTS thaali_orders (
  id BIGSERIAL PRIMARY KEY,
  event_id BIGINT NOT NULL REFERENCES events(id) ON DELETE CASCADE,
  person_id BIGINT NOT NULL REFERENCES persons(id) ON DELETE CASCADE,
  large_count INTEGER NOT NULL DEFAULT 0,
  small_count INTEGER NOT NULL DEFAULT 0,
  barakati_count INTEGER NOT NULL DEFAULT 0,
  pickup_zone VARCHAR(64) NOT NULL,
  notes VARCHAR(500),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT uc_thaali_event_person UNIQUE (event_id, person_id),
  CONSTRAINT chk_thaali_counts_nonneg CHECK (large_count >= 0 AND small_count >= 0 AND barakati_count >= 0),
  CONSTRAINT chk_thaali_pickup_zone CHECK (pickup_zone IN ('SELF_PICKUP_NAJMI_MASJID','NORTH_POTOMAC_ROCKVILLE','GERMANTOWN','WASHINGTON_DC','FREDERICK','ELLICOTT_CITY_COLUMBIA','CLARKSVILLE'))
);
CREATE INDEX IF NOT EXISTS ix_thaali_event ON thaali_orders(event_id);

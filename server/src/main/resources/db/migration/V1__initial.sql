CREATE TABLE IF NOT EXISTS events (
  id BIGSERIAL PRIMARY KEY,
  date date NOT NULL,
  start_time time,
  capacity integer,
  notes text
);

CREATE TABLE IF NOT EXISTS people (
  id BIGSERIAL PRIMARY KEY,
  name varchar(255) NOT NULL,
  email varchar(255) NOT NULL UNIQUE,
  phone varchar(50)
);

CREATE TABLE IF NOT EXISTS rsvps (
  id BIGSERIAL PRIMARY KEY,
  event_id bigint NOT NULL REFERENCES events(id) ON DELETE CASCADE,
  person_id bigint NOT NULL REFERENCES people(id) ON DELETE CASCADE,
  status varchar(10) NOT NULL,
  role varchar(10),
  headcount integer,
  created_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT uc_event_person UNIQUE(event_id, person_id)
);

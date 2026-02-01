-- V31: Seed chefs from dev environment

-- Clear existing chefs (event_chefs will cascade)
DELETE FROM event_chefs;
DELETE FROM chefs;

-- Insert chefs
INSERT INTO chefs (id, name, type, email, phone, notes, active, created_at) VALUES
(1, 'Jabalpurwala Group', 'GROUP', NULL, '(301) 661-4672', NULL, true, now()),
(2, 'Turabi Group', 'GROUP', NULL, '(571) 234-2943', NULL, true, now()),
(3, 'Ravat Group', 'GROUP', NULL, '(240) 520-2546', NULL, true, now()),
(4, 'Rangwala Group', 'GROUP', NULL, '(240) 476-2096', NULL, true, now()),
(5, 'Kanchwala Group', 'GROUP', NULL, '(240) 475-8599', NULL, true, now()),
(6, 'Hanif', 'PERSON', NULL, '(703) 622-0169', NULL, true, now()),
(7, 'Samreena', 'PERSON', NULL, '(240) 595-4927', NULL, true, now()),
(8, 'Merchant Group', 'GROUP', 'kusaim@gmail.com', '(240) 381-3104', NULL, true, now());

SELECT setval('chefs_id_seq', (SELECT MAX(id) FROM chefs));

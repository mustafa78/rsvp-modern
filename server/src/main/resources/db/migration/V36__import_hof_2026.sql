-- V28: Import HOF users from HOF-List-2026.xlsx
-- Updates existing users by ITS number, inserts new users
-- Default password for new users: 'moulatus'
-- Phone format: (xxx) xxx-xxxx
-- User type: REGISTERED, Status: ACTIVE, is_hof: true
-- Role: USER (except 30702039 which gets ADMIN)
-- Total records: 115

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('20313462', 'Mustafa', 'Khambalia', 'mfidahus@gmail.com', '(443) 653-8607', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '20313462'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('20324764', 'Taherali', 'Lukmanjee', 'taher.lukmanji@gmail.com', '(832) 768-3526', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '20324764'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('20327445', 'Idris', 'Sunelwala', 'idrisshujauddin@attalim.net', '(227) 251-7928', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '20327445'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('20338717', 'Murtaza', 'Zaki', 'mufanash@gmail.com', '(443) 670-2500', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '20338717'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('20342143', 'Adil', 'Merchant', 'akhandwa@hotmail.com', '(301) 518-8641', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '20342143'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('20342480', 'Ibrahim', 'Sabir', 'ibrahim_sabir@yahoo.com', '(301) 674-9548', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '20342480'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('20342717', 'Zahid', 'Rangoonwala', 'rangoonwal@gmail.com', '(202) 602-9312', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '20342717'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('20353730', 'Shireen', 'Marfatia', 'shirinmarfatia@gmail.com', '(301) 825-3857', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '20353730'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('20355020', 'Moiz', 'Kitabwalla', 'mkitabi@gmail.com', '(463) 269-1203', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '20355020'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('20355701', 'Hatimali', 'Kurawadwala', 'khatimali@yahoo.com', '(240) 796-6698', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '20355701'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('20355702', 'Adnan', 'Basrai', 'adnanbasrai1@gmail.com', '(301) 765-4455', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '20355702'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('20355703', 'Saifuddin', 'Qaiyumi', 'saifsafe@aol.com', '(443) 538-4091', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '20355703'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('20355704', 'Hakimuddin', 'Suterwala', 'jsuts@aol.com', '(240) 566-2159', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '20355704'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('20355708', 'Fatema', 'Turabi', 'shmimscare@aol.com', '(571) 234-2943', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '20355708'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('20355710', 'Tasadduk', 'Husain', 'rehanahusain@yahoo.com', '(443) 621-7701', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '20355710'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('20355712', 'Hakimuddin', 'Manasawala', 'hmanasa52@gmail.com', '(301) 728-2559', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '20355712'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('20355714', 'Fakhruddin', 'Kurawadwala', 'fak786@comcast.net', '(301) 263-4252', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '20355714'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('20355718', 'Murtaza', 'Colombowala', 'colombowalas@yahoo.com', '(240) 422-7652', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '20355718'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('20355719', 'Shabbirhusain', 'Kurawadwala', 'skurawadwala@yahoo.com', '(240) 731-5280', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '20355719'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('20355723', 'Mustafa', 'Shahmalak', 'mshahmalak@gmail.com', '(202) 821-3669', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '20355723'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('20355727', 'Shujaat', 'Hussain', 'szpan05@hotmail.com', '(240) 498-4701', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '20355727'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('20355731', 'Qusai', 'Kagalwala', 'qusai18@hotmail.com', '(443) 670-6555', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '20355731'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('20355732', 'Faisal', 'Ghadially', 'faisalgh@gmail.com', '(617) 594-0839', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '20355732'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('20355750', 'Yusuf', 'Hameed', 'yush_21@yahoo.com', '(443) 823-5622', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '20355750'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('20355751', 'Mansoor', 'Karachiwala', 'adil.zainulbhai@gmail.com', NULL, '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '20355751'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('20355754', 'Enayatali', 'Rahemanji', 'inayat.rahemanji@gmail.com', '(717) 439-2575', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '20355754'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('20355761', 'Mohammed', 'Haziq', 'mfhaziq@yahoo.com', '(410) 695-5604', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '20355761'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('20355767', 'Quresh', 'Hakimji', 'qureshhakimji@gmail.com', '(240) 460-1671', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '20355767'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('20355770', 'Aliasgar', 'Gadiwalla', 'ali.gadiwalla@yahoo.com', '(443) 812-6531', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '20355770'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('20355773', 'Mansoor', 'Poonawala', 'mansoorpoona@gmail.com', '(240) 876-0191', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '20355773'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('20355776', 'Juzer', 'Babuji', 'juzerababuji@yahoo.com', '(301) 247-0516', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '20355776'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('20355778', 'Khuzaima', 'Pirbhai', 'tazkhuz@gmail.com', '(443) 562-9214', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '20355778'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('20355779', 'Shahid', 'Husain', 'lubmus10@gmail.com', '(240) 731-4339', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '20355779'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('20355780', 'Shabbir', 'Talib', 'sstalib@hotmail.com', '(301) 867-3786', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '20355780'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('20355785', 'Zoher', 'Anis', 'nisreenanis4@hotmail.com', '(240) 477-0659', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '20355785'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('20355790', 'Yousuf', 'Dawood', 'yousufdawood@gmail.com', '(240) 535-7581', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '20355790'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('20357958', 'Shabbir', 'Rangwala', 'shabbiremail@yahoo.com', '(410) 350-6320', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '20357958'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('20357960', 'Aqeel', 'Qaiyumi', 'faridaqaiyumi@hotmail.com', '(443) 538-2703', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '20357960'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('20357963', 'Shabbir', 'Shamshudin', 'shabbirshamshudin@gmail.com', '(717) 860-9229', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '20357963'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('20357975', 'Adil', 'Degani', 'atdegani@hotmail.com', NULL, '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '20357975'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('20412494', 'Aliasgar', 'Najmi', 'annajmi1543@gmail.com', '(240) 731-7462', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '20412494'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('20439188', 'Murtaza', 'Patanwala', 'murnisju@yahoo.com', '(301) 500-8422', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '20439188'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('30141573', 'Aliamjed', 'Bader', 'rukhsanasbader@gmail.com', '(301) 309-9562', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '30141573'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('30151129', 'Amjad', 'Hussain', 'amjadhus571@gmail.com', '(304) 685-8956', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '30151129'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('30303336', 'Husain', 'Kagalwala', 'huseink2@yahoo.com', '(202) 288-6786', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '30303336'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('30311267', 'Huzaifa', 'Arsiwala', 'hozefa.arsiwala@gmail.com', '(312) 498-9880', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '30311267'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('30312165', 'Mustafa', 'Bhinderwala', 'mustafaab@yahoo.com', '(551) 587-8685', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '30312165'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('30324711', 'Abizar', 'Shapurwala', 'abz.wala@gmail.com', '(443) 756-7934', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '30324711'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('30373440', 'Abbas', 'Lokhandwala', 'zainabbas.hu52@gmail.com', '(443) 891-6247', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '30373440'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('30394967', 'Shabbar', 'Jamali', 'shabbarjamali@gmail.com', '(443) 739-8968', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '30394967'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('30412239', 'Malekulashter', 'Husain', 'husainmalik1@gmail.com', '(301) 366-6474', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '30412239'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('30413322', 'Tasneem', 'Bahrainwala', 'tbahrainwala@outlook.com', NULL, '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '30413322'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('30415859', 'Hussein', 'Seifuddin', 'seifudd@gmail.com', '(469) 583-0651', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '30415859'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('30415904', 'Adnan', 'Hameed', 'adnanice@gmail.com', '(443) 535-3676', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '30415904'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('30419534', 'Hussain', 'Jabalpurwala', 'hussain.lubna@ymail.com', '(301) 661-4681', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '30419534'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('30434889', 'Shabbir', 'Kanchwala', 'shabbirkanchwala042@gmail.com', '(227) 218-4042', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '30434889'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('30440154', 'Shabbir', 'Hamid', 'shabbir2152@gmail.com', '(972) 259-0080', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '30440154'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('30456247', 'Fakhruddin', 'Bootwala', 'farook.bootwala@gmail.com', '(443) 905-7860', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '30456247'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('30462597', 'Saifuddin', 'Kalolwala', 'saif.kalol@gmail.com', '(732) 429-2552', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '30462597'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('30464085', 'Aliabbas', 'Nagpurwala', 'draliabbas2003@yahoo.com', '(716) 713-9508', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '30464085'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('30464507', 'Huzaifa', 'Mun', 'huzefamun@gmail.com', '(484) 744-0470', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '30464507'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('30464515', 'Qusai', 'Merchant', 'kusaim@gmail.com', '(240) 381-3104', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '30464515'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('30464701', 'Shoeb', 'Kanchwala', 'shoebmhk@yahoo.com', '(240) 745-5868', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '30464701'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('30466244', 'Idris', 'Amin', 'idris719@gmail.com', '(646) 322-6413', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '30466244'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('30466762', 'Nafisa', 'Amin', 'nafisaab@hotmail.com', '(518) 265-2375', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '30466762'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('30469204', 'Mohammed', 'Qaiyumi', 'adilqaiyumi@gmail.com', '(443) 538-4087', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '30469204'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('30469207', 'Husain', 'Suterwala', 'suterwalahh@gmail.com', '(301) 655-2152', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '30469207'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('30469231', 'Murtaza', '(Shajapurwala)', 'amurtazaali@gmail.com', '(301) 318-3308', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '30469231'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('30469235', 'Yusuf', 'Husain', 'yusufhusain110@gmail.com', '(443) 538-1691', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '30469235'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('30469238', 'Parvez', 'Hussain', 'p.ahussain737@gmail.com', '(240) 426-2473', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '30469238'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('30469245', 'Mufaddal', 'Manasawala', 'mufman786@gmail.com', '(301) 728-1217', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '30469245'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('30469249', 'Mohammed', 'Manasawala', 'mohammed.manasawala@gmail.com', '(302) 465-1952', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '30469249'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('30469269', 'Ayaz', 'Rahemanji', 'ayaz.rahemanji@gmail.com', '(717) 649-4410', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '30469269'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('30469284', 'Aliakbar', 'Turabi', 'adwan.singh@gmail.com', '(509) 939-9481', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '30469284'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('30602203', 'Abbas', 'Fawad', 'fawad.abbas51@gmail.com', '(202) 445-0696', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '30602203'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('30602213', 'Qusai', 'Poonawala', 'qusaip@gmail.com', '(313) 384-0826', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '30602213'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('30602214', 'Shabbir', 'Bharmal', 'bharmals@gmail.com', '(443) 364-0137', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '30602214'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('30602218', 'Maleka', 'Kaka/Marvi', 'maleka.kaka@gmail.com', '(443) 802-5869', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '30602218'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('30602220', 'Firoz', 'Arastu', 'feroz.arastu@gmail.com', '(703) 899-1942', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '30602220'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('30602234', 'Ismail', 'Essajee', 'eessajee@yahoo.com', '(717) 730-0560', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '30602234'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('30602245', 'Qutbuddin', 'Vakil', 'qutub.ghulamali@gmail.com', '(240) 899-7169', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '30602245'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('30602681', 'Murtaza', 'Dawood', 'murtazadawood@gmail.com', '(443) 878-4255', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '30602681'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('30603259', 'Murtaza', 'Hassonjee', 'murtaza.hassonjee@gmail.com', '(610) 368-4678', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '30603259'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('30700376', 'Ali', 'Kagalwala', 'alihkagalwala@gmail.com', '(214) 205-2321', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '30700376'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('30701386', 'Moiz', 'Adamji', 'moiza67@gmail.com', '(780) 264-2704', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '30701386'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('30702010', 'Mustafa', 'Bahrain', 'mbahrain@msn.com', '(240) 264-7887', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '30702010'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('30702028', 'Shafaqat', 'Rangwala', 'safakat.rangwala@gmail.com', '(240) 447-4119', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '30702028'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('30702030', 'Sultan', 'Jiwanji', 'sjiwanji@verizon.net', '(717) 480-6241', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '30702030'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('30702039', 'Mustafa', 'Kanchwala', 'mustafa.kanchwala@gmail.com', '(240) 529-4705', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'ADMIN' FROM persons WHERE its_number = '30702039'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('30702042', 'Ali', 'Bader', 'afshan.bader@gmail.com', '(410) 409-6171', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '30702042'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('30711387', 'Qasim', 'Marvi', 'qmarvi@yahoo.com', '(443) 545-9374', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '30711387'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('30712126', 'Mustafa', 'Islam', 'mstfislam@gmail.com', '(443) 583-9659', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '30712126'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('30800213', 'Ali', 'Fakhruddin', 'aliifakhri@gmail.com', '(412) 612-5081', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '30800213'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('30804303', 'Mariyah', 'Chinwala', 'maria.chinwala@gmail.com', '(706) 380-6959', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '30804303'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('30805389', 'Taher', 'Patel', 'justtahir@gmail.com', '(646) 417-3176', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '30805389'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('30907725', 'Abbas', 'Sinnar', 'azsinnar@hotmail.com', '(443) 851-4292', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '30907725'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('30911367', 'Anees', 'Hitawala', 'aneeshita@gmail.com', '(202) 400-8088', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '30911367'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('30912665', 'Akhtar', 'Hasan', 'akthar3@yahoo.com', '(301) 785-0101', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '30912665'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('30916213', 'Moiz', 'Marvi', 'nmarvi5152@aol.com', '(443) 370-4679', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '30916213'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('30916223', 'Firoz', 'Malik', 'fandzmalik@gmail.com', '(717) 395-0653', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '30916223'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('30920001', 'Yusuf', 'Patel', 'patelyus@yahoo.com', '(410) 218-3073', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '30920001'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('40406259', 'Mustafa', 'Rawat', 'ravat.mustafa@gmail.com', '(240) 520-2546', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '40406259'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('40440404', 'Mustafa', 'Rangwala', 'rangwalamustafa@gmail.com', '(240) 441-4396', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '40440404'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('40496476', 'Adnan', 'wala', 'adnansaifuddin5152@gmail.com', '(346) 446-0701', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '40496476'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('50171755', 'Hussaina', 'Saria', 'dr1hussaina@hotmail.com', '(424) 231-5838', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '50171755'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('50180590', 'Nasirali', 'Emadi', 'naemadi@hotmail.com', '(717) 839-7081', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '50180590'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('50183675', 'Esmail', 'Chitalwala', 'ef.chitalwala@gmail.com', '(703) 863-4658', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '50183675'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('50184301', 'Ibrahim', 'Bream', 'ijiwanji@gmail.com', '(717) 877-1557', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '50184301'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('50191425', 'Ajmal', 'Arastu', 'parveen_arastu@yahoo.com', '(732) 570-5978', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '50191425'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('50243141', 'Hunaid', 'Vasi', 'Nargius@gmail.com', '(410) 252-5883', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '50243141'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('50401803', 'Zeeshan', 'Ali', 'zeeshanalibpl@gmail.com', '(202) 651-1291', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '50401803'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('50423797', 'Ammar', 'Motorwala', 'ak.motorwala@gmail.com', '(540) 998-3991', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '50423797'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('50472957', 'Shaadab', 'Azeem', 'ashadab.52@gmail.com', '(202) 527-8688', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '50472957'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('60437574', 'Amatullah', 'Nakara', 'amatullahnakara2610@gmail.com', '(443) 929-7913', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '60437574'
ON CONFLICT (person_id, role) DO NOTHING;

INSERT INTO persons (its_number, first_name, last_name, email, phone, password_hash, is_hof, user_type, account_status)
VALUES ('60454132', 'Mohammed', 'Raja', 'tasneem.raja@yahoo.com', '(864) 508-2176', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  phone = EXCLUDED.phone,
  is_hof = true,
  updated_at = now();

INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons WHERE its_number = '60454132'
ON CONFLICT (person_id, role) DO NOTHING;

-- End of import

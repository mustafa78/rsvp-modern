-- V21: Import HOF users from HOF-List-2025.xlsx
-- Updates existing users by ITS number, inserts new users
-- Default password for new users: 'moulatus'

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('30373440', 'Abbas', 'Lokhandwala', 'zainabbas.hu52@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('30907725', 'Abbas', 'Sinnar', 'azsinnar@hotmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('30602203', 'Abbas', 'Fawad', 'fawad.abbas51@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('30324711', 'Abizar', 'Shapurwala', 'abz.wala@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('20342143', 'Adil', 'Merchant', 'akhandwa@hotmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('20357975', 'Adil', 'Degani', 'atdegani@hotmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('40496476', 'Adnan', 'wala', 'adnansaifuddin5152@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('30415904', 'Adnan', 'Hameed', 'adnanice@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('50191425', 'Ajmal', 'Arastu', 'parveen_arastu@yahoo.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('30912665', 'Akhtar', 'Hasan', 'akthar3@yahoo.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('30702042', 'Ali', 'Bader', 'afshan.bader@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('30700376', 'Ali', 'Kagalwala', 'alihkagalwala@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('30800213', 'Ali', 'Fakhruddin', 'aliifakhri@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('30464085', 'Aliabbas', 'Nagpurwala', 'draliabbas2003@yahoo.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('30141573', 'Aliamjed', 'Bader', 'rukhsanasbader@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('20412494', 'Aliasgar', 'Najmi', 'annajmi1543@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('60437574', 'Amatullah', 'Nakara', 'amatullahnakara2610@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('30151129', 'Amjad', 'Hussain', 'amjadhus571@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('50423797', 'Ammar', 'Motorwala', 'ak.motorwala@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('30911367', 'Anees', 'Hitawala', 'aneeshita@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('20357960', 'Aqeel', 'Qaiyumi', 'faridaqaiyumi@hotmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('30469269', 'Ayaz', 'Rahemanji', 'ayaz.rahemanji@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('20355754', 'Enayatali', 'Rahemanji', 'inayat.rahemanji@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('50183675', 'Esmail', 'Chitalwala', 'ef.chitalwala@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('20355732', 'Faisal', 'Ghadially', 'faisalgh@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('30456247', 'Fakhruddin', 'Bootwala', 'farook.bootwala@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('30602220', 'Firoz', 'Arastu', 'feroz.arastu@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('30916223', 'Firoz', 'Malik', 'fandzmalik@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('50243141', 'Hunaid', 'Vasi', 'nargius@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('30303336', 'Husain', 'Kagalwala', 'huseink2@yahoo.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('30419534', 'Hussain', 'Jabalpurwala', 'hussain.lubna@ymail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('50171755', 'Hussaina', 'Saria', 'dr1hussaina@hotmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('30415859', 'Hussein', 'Seifuddin', 'seifudd@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('30311267', 'Huzaifa', 'Arsiwala', 'hozefa.arsiwala@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('50184301', 'Ibrahim', 'Bream', 'ijiwanji@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('30466244', 'Idris', 'Amin', 'idris719@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('30602234', 'Ismail', 'Essajee', 'eessajee@yahoo.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('20355776', 'Juzer', 'Babuji', 'juzerababuji@yahoo.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('20355778', 'Khuzaima', 'Pirbhai', 'tazkhuz@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('30602218', 'Maleka', 'Kaka/Marvi', 'maleka.kaka@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('20355773', 'Mansoor', 'Poonawala', 'mansoorpoona@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('30804303', 'Mariyah', 'Chinwala', 'maria.chinwala@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('20355761', 'Mohammed', 'Haziq', 'mfhaziq@yahoo.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('60454132', 'Mohammed', 'Raja', 'tasneem.raja@yahoo.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('20355020', 'Moiz', 'Kitabwalla', 'mkitabi@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('30916213', 'Moiz', 'Marvi', 'nmarvi5152@aol.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('30701386', 'Moiz', 'Adamji', 'moiza67@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('30469284', 'Aliakbar', 'Turabi', 'adwan.singh@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('20355770', 'Aliasgar', 'Gadiwalla', 'ali.gadiwalla@yahoo.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('20355708', 'Fatema', 'Turabi', 'shmimscare@aol.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('30464507', 'Huzaifa', 'Mun', 'huzefamun@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('30412239', 'Malekulashter', 'Husain', 'husainmalik1@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('30469204', 'Mohammed', 'Qaiyumi', 'adilqaiyumi@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('30469245', 'Mufaddal', 'Manasawala', 'mufman786@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('30469231', 'Murtaza', '(Shajapurwala)', 'amurtazaali@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('30462597', 'Saifuddin', 'Kalolwala', 'saif.kalol@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('30440154', 'Shabbir', 'Hamid', 'shabbir2152@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('20439188', 'Murtaza', 'Patanwala', 'murnisju@yahoo.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('30603259', 'Murtaza', 'Hassonjee', 'murtaza.hassonjee@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('30602681', 'Murtaza', 'Dawood', 'murtazadawood@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('20338717', 'Murtaza', 'Zaki', 'mufanash@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('30312165', 'Mustafa', 'Bhinderwala', 'mustafaab@yahoo.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('40440404', 'Mustafa', 'Rangwala', 'rangwalamustafa@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('30702010', 'Mustafa', 'Bahrain', 'mbahrain@msn.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('20313462', 'Mustafa', 'Khambalia', 'mfidahus@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('30712126', 'Mustafa', 'Islam', 'mstfislam@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('40406259', 'Mustafa', 'Rawat', 'ravat.mustafa@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('30702039', 'Mustafa', 'Kanchwala', 'mustafa.kanchwala@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('30466762', 'Nafisa', 'Amin', 'nafisaab@hotmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('50180590', 'Nasirali', 'Emadi', 'naemadi@hotmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('30469238', 'Parvez', 'Hussain', 'p.ahussain737@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('30711387', 'Qasim', 'Marvi', 'qmarvi@yahoo.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('20355767', 'Quresh', 'Hakimji', 'qureshhakimji@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('20355731', 'Qusai', 'Kagalwala', 'qusai18@hotmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('30602213', 'Qusai', 'Poonawala', 'qusaip@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('50472957', 'Shaadab', 'Azeem', 'ashadab.52@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('30394967', 'Shabbar', 'Jamali', 'shabbarjamali@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('20357958', 'Shabbir', 'Rangwala', 'shabbiremail@yahoo.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('20357963', 'Shabbir', 'Shamshudin', 'shabbirshamshudin@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('30602214', 'Shabbir', 'Bharmal', 'bharmals@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('30434889', 'Shabbir', 'Kanchwala', 'shabbirkanchwala042@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('20355780', 'Shabbir', 'Talib', 'sstalib@hotmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('20355719', 'Shabbirhusain', 'Kurawadwala', 'skurawadwala@yahoo.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('30702028', 'Shafaqat', 'Rangwala', 'safakat.rangwala@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('20355779', 'Shahid', 'Husain', 'lubmus10@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('20355702', 'Adnan', 'Basrai', 'adnanbasrai1@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('20355714', 'Fakhruddin', 'Kurawadwala', 'fak786@comcast.net', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('20355712', 'Hakimuddin', 'Manasawala', 'hmanasa52@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('20355704', 'Hakimuddin', 'Suterwala', 'jsuts@aol.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('20355701', 'Hatimali', 'Kurawadwala', 'khatimali@yahoo.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('30469207', 'Husain', 'Suterwala', 'suterwalahh@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('20342480', 'Ibrahim', 'Sabir', 'ibrahim_sabir@yahoo.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('20327445', 'Idris', 'Sunelwala', 'idrisshujauddin@attalim.net', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('20355751', 'Mansoor', 'Karachiwala', 'adil.zainulbhai@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('30469249', 'Mohammed', 'Manasawala', 'mohammed.manasawala@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('20355718', 'Murtaza', 'Colombowala', 'colombowalas@yahoo.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('20355723', 'Mustafa', 'Shahmalak', 'mshahmalak@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('30464515', 'Qusai', 'Merchant', 'kusaim@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('30602245', 'Qutbuddin', 'Vakil', 'qutub.ghulamali@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('20355703', 'Saifuddin', 'Qaiyumi', 'saifsafe@aol.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('20355710', 'Tasadduk', 'Husain', 'rehanahusain@yahoo.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('20355790', 'Yousuf', 'Dawood', 'yousufdawood@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('20355750', 'Yusuf', 'Hameed', 'yush_21@yahoo.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('20353730', 'Shireen', 'Marfatia', 'shirinmarfatia@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('30464701', 'Shoeb', 'Kanchwala', 'shoebmhk@yahoo.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('20355727', 'Shujaat', 'Hussain', 'szpan05@hotmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('30702030', 'Sultan', 'Jiwanji', 'sjiwanji@verizon.net', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('30805389', 'Taher', 'Patel', 'justtahir@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('20324764', 'Taherali', 'Lukmanjee', 'taher.lukmanji@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('30413322', 'Tasneem', 'Bahrainwala', 'tbahrainwala@outlook.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('30920001', 'Yusuf', 'Patel', 'patelyus@yahoo.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('30469235', 'Yusuf', 'Husain', 'yusufhusain110@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('20342717', 'Zahid', 'Rangoonwala', 'rangoonwal@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('50401803', 'Zeeshan', 'Ali', 'zeeshanalibpl@gmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

INSERT INTO persons (its_number, first_name, last_name, email, password_hash, is_hof, user_type, account_status)
VALUES ('20355785', 'Zoher', 'Anis', 'nisreenanis4@hotmail.com', '$2b$10$XiE/4DZ3swecI9aiTMOqT.kT9TAXGRxiGKBf0BK5yzr6IpcSCmr6y', true, 'REGISTERED', 'ACTIVE')
ON CONFLICT (its_number) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email,
  is_hof = true,
  updated_at = now();

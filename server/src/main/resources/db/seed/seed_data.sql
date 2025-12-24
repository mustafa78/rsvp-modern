-- Seed Data from fmb_signups_2025-12-17.xlsx
-- Password for all users is: moulatus

-- ============================================
-- 1. PERSONS (Users)
-- ============================================
INSERT INTO persons (its_number, first_name, last_name, phone, email, password_hash, account_status, pickup_zone_id, failed_login_count, created_at, updated_at)
VALUES ('30603259', 'Bhai Murtaza', 'Hassonjee', NULL, 'bhaimurtaza.hassonjee@example.com', '$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK', 'ACTIVE', 7, 0, NOW(), NOW())
ON CONFLICT (its_number) DO NOTHING;
INSERT INTO persons (its_number, first_name, last_name, phone, email, password_hash, account_status, pickup_zone_id, failed_login_count, created_at, updated_at)
VALUES ('30907725', 'Abbas', 'Sinnar', '443-851-4292', 'abbas.sinnar@example.com', '$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK', 'ACTIVE', 7, 0, NOW(), NOW())
ON CONFLICT (its_number) DO NOTHING;
INSERT INTO persons (its_number, first_name, last_name, phone, email, password_hash, account_status, pickup_zone_id, failed_login_count, created_at, updated_at)
VALUES ('20355750', 'Yusuf', 'Hameed', '410-696-8699', 'yusuf.hameed@example.com', '$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK', 'ACTIVE', 6, 0, NOW(), NOW())
ON CONFLICT (its_number) DO NOTHING;
INSERT INTO persons (its_number, first_name, last_name, phone, email, password_hash, account_status, pickup_zone_id, failed_login_count, created_at, updated_at)
VALUES ('30415904', 'Adnan', 'Hameed', NULL, 'adnan.hameed@example.com', '$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK', 'ACTIVE', 6, 0, NOW(), NOW())
ON CONFLICT (its_number) DO NOTHING;
INSERT INTO persons (its_number, first_name, last_name, phone, email, password_hash, account_status, pickup_zone_id, failed_login_count, created_at, updated_at)
VALUES ('30394967', 'Shabbar', 'Jamali', '443-739-8968', 'shabbar.jamali@example.com', '$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK', 'ACTIVE', 6, 0, NOW(), NOW())
ON CONFLICT (its_number) DO NOTHING;
INSERT INTO persons (its_number, first_name, last_name, phone, email, password_hash, account_status, pickup_zone_id, failed_login_count, created_at, updated_at)
VALUES ('20355731', 'Qusai', 'Kagalwala', '443-364-4134', 'qusai.kagalwala@example.com', '$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK', 'ACTIVE', 6, 0, NOW(), NOW())
ON CONFLICT (its_number) DO NOTHING;
INSERT INTO persons (its_number, first_name, last_name, phone, email, password_hash, account_status, pickup_zone_id, failed_login_count, created_at, updated_at)
VALUES ('20342143', 'Adil', 'Merchant', '443-285-0791', 'adil.merchant@example.com', '$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK', 'ACTIVE', 6, 0, NOW(), NOW())
ON CONFLICT (its_number) DO NOTHING;
INSERT INTO persons (its_number, first_name, last_name, phone, email, password_hash, account_status, pickup_zone_id, failed_login_count, created_at, updated_at)
VALUES ('20355778', 'Khuzaima', 'Pirbhai', '410-772-0383', 'khuzaima.pirbhai@example.com', '$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK', 'ACTIVE', 6, 0, NOW(), NOW())
ON CONFLICT (its_number) DO NOTHING;
INSERT INTO persons (its_number, first_name, last_name, phone, email, password_hash, account_status, pickup_zone_id, failed_login_count, created_at, updated_at)
VALUES ('30602213', 'Qusai', 'Poonawala', '313-384-0826', 'qusai.poonawala@example.com', '$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK', 'ACTIVE', 6, 0, NOW(), NOW())
ON CONFLICT (its_number) DO NOTHING;
INSERT INTO persons (its_number, first_name, last_name, phone, email, password_hash, account_status, pickup_zone_id, failed_login_count, created_at, updated_at)
VALUES ('30469204', 'Mohammed', 'Qaiyumi', NULL, 'mohammed.qaiyumi@example.com', '$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK', 'ACTIVE', 6, 0, NOW(), NOW())
ON CONFLICT (its_number) DO NOTHING;
INSERT INTO persons (its_number, first_name, last_name, phone, email, password_hash, account_status, pickup_zone_id, failed_login_count, created_at, updated_at)
VALUES ('20355703', 'Saifuddin', 'Qaiyumi', '410-381-5896', 'saifuddin.qaiyumi@example.com', '$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK', 'ACTIVE', 6, 0, NOW(), NOW())
ON CONFLICT (its_number) DO NOTHING;
INSERT INTO persons (its_number, first_name, last_name, phone, email, password_hash, account_status, pickup_zone_id, failed_login_count, created_at, updated_at)
VALUES ('20357958', 'Shabbir', 'Rangwala', '410-461-2924', 'shabbir.rangwala@example.com', '$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK', 'ACTIVE', 6, 0, NOW(), NOW())
ON CONFLICT (its_number) DO NOTHING;
INSERT INTO persons (its_number, first_name, last_name, phone, email, password_hash, account_status, pickup_zone_id, failed_login_count, created_at, updated_at)
VALUES ('30712127', 'Samina', 'Saifuddin', NULL, 'samina.saifuddin@example.com', '$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK', 'ACTIVE', 6, 0, NOW(), NOW())
ON CONFLICT (its_number) DO NOTHING;
INSERT INTO persons (its_number, first_name, last_name, phone, email, password_hash, account_status, pickup_zone_id, failed_login_count, created_at, updated_at)
VALUES ('30469253', 'Taher', 'Ezzi', NULL, 'taher.ezzi@example.com', '$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK', 'ACTIVE', 6, 0, NOW(), NOW())
ON CONFLICT (its_number) DO NOTHING;
INSERT INTO persons (its_number, first_name, last_name, phone, email, password_hash, account_status, pickup_zone_id, failed_login_count, created_at, updated_at)
VALUES ('20394720', 'Bhai Zainuddin', 'Tajbhai', NULL, 'bhaizainuddin.tajbhai@example.com', '$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK', 'ACTIVE', 6, 0, NOW(), NOW())
ON CONFLICT (its_number) DO NOTHING;
INSERT INTO persons (its_number, first_name, last_name, phone, email, password_hash, account_status, pickup_zone_id, failed_login_count, created_at, updated_at)
VALUES ('20355776', 'Juzer', 'Babuji', '301-300-2484', 'juzer.babuji@example.com', '$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK', 'ACTIVE', 5, 0, NOW(), NOW())
ON CONFLICT (its_number) DO NOTHING;
INSERT INTO persons (its_number, first_name, last_name, phone, email, password_hash, account_status, pickup_zone_id, failed_login_count, created_at, updated_at)
VALUES ('20355767', 'Quraish', 'Hakimji', '301-631-6789', 'quraish.hakimji@example.com', '$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK', 'ACTIVE', 5, 0, NOW(), NOW())
ON CONFLICT (its_number) DO NOTHING;
INSERT INTO persons (its_number, first_name, last_name, phone, email, password_hash, account_status, pickup_zone_id, failed_login_count, created_at, updated_at)
VALUES ('40406259', 'Mustafa', 'Rawat', '240-520-2546', 'mustafa.rawat@example.com', '$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK', 'ACTIVE', 5, 0, NOW(), NOW())
ON CONFLICT (its_number) DO NOTHING;
INSERT INTO persons (its_number, first_name, last_name, phone, email, password_hash, account_status, pickup_zone_id, failed_login_count, created_at, updated_at)
VALUES ('50171755', 'Dr. Hussaina', 'Saria', NULL, 'dr.hussaina.saria@example.com', '$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK', 'ACTIVE', 5, 0, NOW(), NOW())
ON CONFLICT (its_number) DO NOTHING;
INSERT INTO persons (its_number, first_name, last_name, phone, email, password_hash, account_status, pickup_zone_id, failed_login_count, created_at, updated_at)
VALUES ('20342717', 'Zahid', 'Rangoonwala', NULL, 'zahid.rangoonwala@example.com', '$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK', 'ACTIVE', 5, 0, NOW(), NOW())
ON CONFLICT (its_number) DO NOTHING;
INSERT INTO persons (its_number, first_name, last_name, phone, email, password_hash, account_status, pickup_zone_id, failed_login_count, created_at, updated_at)
VALUES ('30602220', 'Firoz', 'Arastu', '240-654-4002', 'firoz.arastu@example.com', '$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK', 'ACTIVE', 3, 0, NOW(), NOW())
ON CONFLICT (its_number) DO NOTHING;
INSERT INTO persons (its_number, first_name, last_name, phone, email, password_hash, account_status, pickup_zone_id, failed_login_count, created_at, updated_at)
VALUES ('50183675', 'Esmail', 'Chitalwala', NULL, 'esmail.chitalwala@example.com', '$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK', 'ACTIVE', 3, 0, NOW(), NOW())
ON CONFLICT (its_number) DO NOTHING;
INSERT INTO persons (its_number, first_name, last_name, phone, email, password_hash, account_status, pickup_zone_id, failed_login_count, created_at, updated_at)
VALUES ('30602245', 'Qutbuddin', 'Ghulamali', '301-528-9081', 'qutbuddin.ghulamali@example.com', '$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK', 'ACTIVE', 3, 0, NOW(), NOW())
ON CONFLICT (its_number) DO NOTHING;
INSERT INTO persons (its_number, first_name, last_name, phone, email, password_hash, account_status, pickup_zone_id, failed_login_count, created_at, updated_at)
VALUES ('20355779', 'Shahed', 'Husain', '301-972-1760', 'shahed.husain@example.com', '$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK', 'ACTIVE', 3, 0, NOW(), NOW())
ON CONFLICT (its_number) DO NOTHING;
INSERT INTO persons (its_number, first_name, last_name, phone, email, password_hash, account_status, pickup_zone_id, failed_login_count, created_at, updated_at)
VALUES ('20355727', 'Shujaat', 'Hussain', '301-972-3486', 'shujaat.hussain@example.com', '$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK', 'ACTIVE', 3, 0, NOW(), NOW())
ON CONFLICT (its_number) DO NOTHING;
INSERT INTO persons (its_number, first_name, last_name, phone, email, password_hash, account_status, pickup_zone_id, failed_login_count, created_at, updated_at)
VALUES ('30702039', 'Mustafa', 'Kanchwala', NULL, 'mustafa.kanchwala@example.com', '$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK', 'ACTIVE', 3, 0, NOW(), NOW())
ON CONFLICT (its_number) DO NOTHING;
INSERT INTO persons (its_number, first_name, last_name, phone, email, password_hash, account_status, pickup_zone_id, failed_login_count, created_at, updated_at)
VALUES ('20355723', 'Mustafa', 'Shahmalak', NULL, 'mustafa.shahmalak@example.com', '$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK', 'ACTIVE', 3, 0, NOW(), NOW())
ON CONFLICT (its_number) DO NOTHING;
INSERT INTO persons (its_number, first_name, last_name, phone, email, password_hash, account_status, pickup_zone_id, failed_login_count, created_at, updated_at)
VALUES ('30469231', 'Murtaza', 'Shajapurwala', '301-540-4509', 'murtaza.shajapurwala@example.com', '$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK', 'ACTIVE', 3, 0, NOW(), NOW())
ON CONFLICT (its_number) DO NOTHING;
INSERT INTO persons (its_number, first_name, last_name, phone, email, password_hash, account_status, pickup_zone_id, failed_login_count, created_at, updated_at)
VALUES ('50401803', 'Zeeshan', 'Ali', NULL, 'zeeshan.ali@example.com', '$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK', 'ACTIVE', 3, 0, NOW(), NOW())
ON CONFLICT (its_number) DO NOTHING;
INSERT INTO persons (its_number, first_name, last_name, phone, email, password_hash, account_status, pickup_zone_id, failed_login_count, created_at, updated_at)
VALUES ('30415859', 'Hussein', 'Seifuddin', '469-583-0651', 'hussein.seifuddin@example.com', '$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK', 'ACTIVE', 3, 0, NOW(), NOW())
ON CONFLICT (its_number) DO NOTHING;
INSERT INTO persons (its_number, first_name, last_name, phone, email, password_hash, account_status, pickup_zone_id, failed_login_count, created_at, updated_at)
VALUES ('20355732', 'Faisal', 'Ghadially', '301-217-0836', 'faisal.ghadially@example.com', '$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK', 'ACTIVE', 2, 0, NOW(), NOW())
ON CONFLICT (its_number) DO NOTHING;
INSERT INTO persons (its_number, first_name, last_name, phone, email, password_hash, account_status, pickup_zone_id, failed_login_count, created_at, updated_at)
VALUES ('30309367', 'Behen Sakina', 'Goawala', NULL, 'behensakina.goawala@example.com', '$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK', 'ACTIVE', 2, 0, NOW(), NOW())
ON CONFLICT (its_number) DO NOTHING;
INSERT INTO persons (its_number, first_name, last_name, phone, email, password_hash, account_status, pickup_zone_id, failed_login_count, created_at, updated_at)
VALUES ('30303336', 'Husein', 'Kagalwala', NULL, 'husein.kagalwala@example.com', '$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK', 'ACTIVE', 2, 0, NOW(), NOW())
ON CONFLICT (its_number) DO NOTHING;
INSERT INTO persons (its_number, first_name, last_name, phone, email, password_hash, account_status, pickup_zone_id, failed_login_count, created_at, updated_at)
VALUES ('30469245', 'Mufaddal', 'Manasawala', NULL, 'mufaddal.manasawala@example.com', '$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK', 'ACTIVE', 2, 0, NOW(), NOW())
ON CONFLICT (its_number) DO NOTHING;
INSERT INTO persons (its_number, first_name, last_name, phone, email, password_hash, account_status, pickup_zone_id, failed_login_count, created_at, updated_at)
VALUES ('30466244', 'Dr. Idris', 'Amin', '646-322-6413', 'dr.idris.amin@example.com', '$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK', 'ACTIVE', 1, 0, NOW(), NOW())
ON CONFLICT (its_number) DO NOTHING;
INSERT INTO persons (its_number, first_name, last_name, phone, email, password_hash, account_status, pickup_zone_id, failed_login_count, created_at, updated_at)
VALUES ('20355804', 'Abbas', 'Amin', NULL, 'abbas.amin@example.com', '$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK', 'ACTIVE', 1, 0, NOW(), NOW())
ON CONFLICT (its_number) DO NOTHING;
INSERT INTO persons (its_number, first_name, last_name, phone, email, password_hash, account_status, pickup_zone_id, failed_login_count, created_at, updated_at)
VALUES ('30311267', 'Hozefa', 'Arsiwala', '312-498-9880', 'hozefa.arsiwala@example.com', '$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK', 'ACTIVE', 1, 0, NOW(), NOW())
ON CONFLICT (its_number) DO NOTHING;
INSERT INTO persons (its_number, first_name, last_name, phone, email, password_hash, account_status, pickup_zone_id, failed_login_count, created_at, updated_at)
VALUES ('20355702', 'Adnan', 'Basrai', '301-460-5266', 'adnan.basrai@example.com', '$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK', 'ACTIVE', 1, 0, NOW(), NOW())
ON CONFLICT (its_number) DO NOTHING;
INSERT INTO persons (its_number, first_name, last_name, phone, email, password_hash, account_status, pickup_zone_id, failed_login_count, created_at, updated_at)
VALUES ('30456247', 'Fakhruddin', 'Bootwala', '443-905-7860', 'fakhruddin.bootwala@example.com', '$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK', 'ACTIVE', 1, 0, NOW(), NOW())
ON CONFLICT (its_number) DO NOTHING;
INSERT INTO persons (its_number, first_name, last_name, phone, email, password_hash, account_status, pickup_zone_id, failed_login_count, created_at, updated_at)
VALUES ('20355718', 'Murtaza', 'Colombowala', NULL, 'murtaza.colombowala@example.com', '$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK', 'ACTIVE', 1, 0, NOW(), NOW())
ON CONFLICT (its_number) DO NOTHING;
INSERT INTO persons (its_number, first_name, last_name, phone, email, password_hash, account_status, pickup_zone_id, failed_login_count, created_at, updated_at)
VALUES ('30602681', 'Murtaza', 'Dawood', '410-312-4951', 'murtaza.dawood@example.com', '$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK', 'ACTIVE', 1, 0, NOW(), NOW())
ON CONFLICT (its_number) DO NOTHING;
INSERT INTO persons (its_number, first_name, last_name, phone, email, password_hash, account_status, pickup_zone_id, failed_login_count, created_at, updated_at)
VALUES ('30800216', 'Abid', 'Fakhri', '412-607-1834', 'abid.fakhri@example.com', '$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK', 'ACTIVE', 1, 0, NOW(), NOW())
ON CONFLICT (its_number) DO NOTHING;
INSERT INTO persons (its_number, first_name, last_name, phone, email, password_hash, account_status, pickup_zone_id, failed_login_count, created_at, updated_at)
VALUES ('20355770', 'Aliasgar', 'Gadiwalla', '410-531-7552', 'aliasgar.gadiwalla@example.com', '$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK', 'ACTIVE', 1, 0, NOW(), NOW())
ON CONFLICT (its_number) DO NOTHING;
INSERT INTO persons (its_number, first_name, last_name, phone, email, password_hash, account_status, pickup_zone_id, failed_login_count, created_at, updated_at)
VALUES ('30440154', 'Shabbir', 'Hamid', NULL, 'shabbir.hamid@example.com', '$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK', 'ACTIVE', 1, 0, NOW(), NOW())
ON CONFLICT (its_number) DO NOTHING;
INSERT INTO persons (its_number, first_name, last_name, phone, email, password_hash, account_status, pickup_zone_id, failed_login_count, created_at, updated_at)
VALUES ('30151129', 'Rashida', 'Hussain', '304-906-7224', 'rashida.hussain@example.com', '$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK', 'ACTIVE', 1, 0, NOW(), NOW())
ON CONFLICT (its_number) DO NOTHING;
INSERT INTO persons (its_number, first_name, last_name, phone, email, password_hash, account_status, pickup_zone_id, failed_login_count, created_at, updated_at)
VALUES ('30434889', 'Bhai Shabbir', 'Kanchwala', '443-713-0286', 'bhaishabbir.kanchwala@example.com', '$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK', 'ACTIVE', 1, 0, NOW(), NOW())
ON CONFLICT (its_number) DO NOTHING;
INSERT INTO persons (its_number, first_name, last_name, phone, email, password_hash, account_status, pickup_zone_id, failed_login_count, created_at, updated_at)
VALUES ('20355714', 'Fakhruddin', 'Kurawadwala', '301-774-6440', 'fakhruddin.kurawadwala@example.com', '$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK', 'ACTIVE', 1, 0, NOW(), NOW())
ON CONFLICT (its_number) DO NOTHING;
INSERT INTO persons (its_number, first_name, last_name, phone, email, password_hash, account_status, pickup_zone_id, failed_login_count, created_at, updated_at)
VALUES ('30373440', 'Abbas', 'Lokhandwala', '646-244-4205', 'abbas.lokhandwala@example.com', '$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK', 'ACTIVE', 1, 0, NOW(), NOW())
ON CONFLICT (its_number) DO NOTHING;
INSERT INTO persons (its_number, first_name, last_name, phone, email, password_hash, account_status, pickup_zone_id, failed_login_count, created_at, updated_at)
VALUES ('20324764', 'Taher', 'Lukmanji', NULL, 'taher.lukmanji@example.com', '$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK', 'ACTIVE', 1, 0, NOW(), NOW())
ON CONFLICT (its_number) DO NOTHING;
INSERT INTO persons (its_number, first_name, last_name, phone, email, password_hash, account_status, pickup_zone_id, failed_login_count, created_at, updated_at)
VALUES ('30469249', 'Mohammed', 'Manasawala', '302-465-1952', 'mohammed.manasawala@example.com', '$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK', 'ACTIVE', 1, 0, NOW(), NOW())
ON CONFLICT (its_number) DO NOTHING;
INSERT INTO persons (its_number, first_name, last_name, phone, email, password_hash, account_status, pickup_zone_id, failed_login_count, created_at, updated_at)
VALUES ('20353730', 'Shireen', 'Marfatia', '301-593-0108', 'shireen.marfatia@example.com', '$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK', 'ACTIVE', 1, 0, NOW(), NOW())
ON CONFLICT (its_number) DO NOTHING;
INSERT INTO persons (its_number, first_name, last_name, phone, email, password_hash, account_status, pickup_zone_id, failed_login_count, created_at, updated_at)
VALUES ('30602218', 'Maleka', 'Marvi', '410-997-7056', 'maleka.marvi@example.com', '$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK', 'ACTIVE', 1, 0, NOW(), NOW())
ON CONFLICT (its_number) DO NOTHING;
INSERT INTO persons (its_number, first_name, last_name, phone, email, password_hash, account_status, pickup_zone_id, failed_login_count, created_at, updated_at)
VALUES ('50423797', 'Ammar', 'Motorwala', NULL, 'ammar.motorwala@example.com', '$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK', 'ACTIVE', 1, 0, NOW(), NOW())
ON CONFLICT (its_number) DO NOTHING;
INSERT INTO persons (its_number, first_name, last_name, phone, email, password_hash, account_status, pickup_zone_id, failed_login_count, created_at, updated_at)
VALUES ('20412494', 'Janab Amilsaheb Ali Asgar BS', 'Najmi', NULL, 'janabamilsahebaliasgarbs.najmi@example.com', '$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK', 'ACTIVE', 1, 0, NOW(), NOW())
ON CONFLICT (its_number) DO NOTHING;
INSERT INTO persons (its_number, first_name, last_name, phone, email, password_hash, account_status, pickup_zone_id, failed_login_count, created_at, updated_at)
VALUES ('30920001', 'Yusuf', 'Patel', NULL, 'yusuf.patel@example.com', '$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK', 'ACTIVE', 1, 0, NOW(), NOW())
ON CONFLICT (its_number) DO NOTHING;
INSERT INTO persons (its_number, first_name, last_name, phone, email, password_hash, account_status, pickup_zone_id, failed_login_count, created_at, updated_at)
VALUES ('30805389', 'Tahir', 'Patel', NULL, 'tahir.patel@example.com', '$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK', 'ACTIVE', 1, 0, NOW(), NOW())
ON CONFLICT (its_number) DO NOTHING;
INSERT INTO persons (its_number, first_name, last_name, phone, email, password_hash, account_status, pickup_zone_id, failed_login_count, created_at, updated_at)
VALUES ('20342480', 'Ibrahim', 'Sabir', '301-637-4347', 'ibrahim.sabir@example.com', '$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK', 'ACTIVE', 1, 0, NOW(), NOW())
ON CONFLICT (its_number) DO NOTHING;
INSERT INTO persons (its_number, first_name, last_name, phone, email, password_hash, account_status, pickup_zone_id, failed_login_count, created_at, updated_at)
VALUES ('20327445', 'Shaikh Idris Bhai', 'Sunelwala', NULL, 'shaikhidrisbhai.sunelwala@example.com', '$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK', 'ACTIVE', 1, 0, NOW(), NOW())
ON CONFLICT (its_number) DO NOTHING;
INSERT INTO persons (its_number, first_name, last_name, phone, email, password_hash, account_status, pickup_zone_id, failed_login_count, created_at, updated_at)
VALUES ('20338717', 'Murtaza', 'Zaki', '240-786-6114', 'murtaza.zaki@example.com', '$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK', 'ACTIVE', 1, 0, NOW(), NOW())
ON CONFLICT (its_number) DO NOTHING;
INSERT INTO persons (its_number, first_name, last_name, phone, email, password_hash, account_status, pickup_zone_id, failed_login_count, created_at, updated_at)
VALUES ('30469235', 'Yusuf', 'Husain', NULL, 'yusuf.husain@example.com', '$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK', 'ACTIVE', 1, 0, NOW(), NOW())
ON CONFLICT (its_number) DO NOTHING;
INSERT INTO persons (its_number, first_name, last_name, phone, email, password_hash, account_status, pickup_zone_id, failed_login_count, created_at, updated_at)
VALUES ('20439188', 'Murtaza', 'Patanwala', NULL, 'murtaza.patanwala@example.com', '$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK', 'ACTIVE', 1, 0, NOW(), NOW())
ON CONFLICT (its_number) DO NOTHING;
INSERT INTO persons (its_number, first_name, last_name, phone, email, password_hash, account_status, pickup_zone_id, failed_login_count, created_at, updated_at)
VALUES ('30469206', 'Nisrin', 'Suterwala', NULL, 'nisrin.suterwala@example.com', '$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK', 'ACTIVE', 1, 0, NOW(), NOW())
ON CONFLICT (its_number) DO NOTHING;
INSERT INTO persons (its_number, first_name, last_name, phone, email, password_hash, account_status, pickup_zone_id, failed_login_count, created_at, updated_at)
VALUES ('30469207', 'Hussain', 'Sutterwala', NULL, 'hussain.sutterwala@example.com', '$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK', 'ACTIVE', 1, 0, NOW(), NOW())
ON CONFLICT (its_number) DO NOTHING;
INSERT INTO persons (its_number, first_name, last_name, phone, email, password_hash, account_status, pickup_zone_id, failed_login_count, created_at, updated_at)
VALUES ('30464515', 'Kusai', 'Merchant', '240-381-3104', 'kusai.merchant@example.com', '$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK', 'ACTIVE', 4, 0, NOW(), NOW())
ON CONFLICT (its_number) DO NOTHING;
INSERT INTO persons (its_number, first_name, last_name, phone, email, password_hash, account_status, pickup_zone_id, failed_login_count, created_at, updated_at)
VALUES ('30464507', 'Huzefa', 'Mun', NULL, 'huzefa.mun@example.com', '$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK', 'ACTIVE', 4, 0, NOW(), NOW())
ON CONFLICT (its_number) DO NOTHING;
INSERT INTO persons (its_number, first_name, last_name, phone, email, password_hash, account_status, pickup_zone_id, failed_login_count, created_at, updated_at)
VALUES ('30462008', 'Behen Tasneem', 'Dollar', '713-897-9792', 'behentasneem.dollar@example.com', '$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK', 'ACTIVE', 4, 0, NOW(), NOW())
ON CONFLICT (its_number) DO NOTHING;
INSERT INTO persons (its_number, first_name, last_name, phone, email, password_hash, account_status, pickup_zone_id, failed_login_count, created_at, updated_at)
VALUES ('30329984', 'Khuzema', 'Habib', NULL, 'khuzema.habib@example.com', '$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK', 'ACTIVE', 4, 0, NOW(), NOW())
ON CONFLICT (its_number) DO NOTHING;

-- Assign USER role to all persons
INSERT INTO person_roles (person_id, role)
SELECT id, 'USER' FROM persons
ON CONFLICT DO NOTHING;

-- Make Mustafa Kanchwala an admin (ITS: 30702039)
INSERT INTO person_roles (person_id, role)
SELECT id, 'ADMIN' FROM persons WHERE its_number = '30702039'
ON CONFLICT DO NOTHING;
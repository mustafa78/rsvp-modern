-- Populate cost_per_unit and calories_per_unit for ingredients
-- Costs are approximate retail prices in USD
-- Calories are per unit as specified in the unit column

-- =====================================================
-- MEAT (per lb unless otherwise noted)
-- =====================================================
UPDATE ingredients SET cost_per_unit = 9.99, calories_per_unit = 1150 WHERE name = 'beef, boneless nihari cut 2" pieces';
UPDATE ingredients SET cost_per_unit = 5.99, calories_per_unit = 1280 WHERE name = 'beef, ground 85% lean (frozen)';
UPDATE ingredients SET cost_per_unit = 6.99, calories_per_unit = 1130 WHERE name = 'beef, ground 90% lean';
UPDATE ingredients SET cost_per_unit = 4.49, calories_per_unit = 750 WHERE name = 'chicken breast, boneless';
UPDATE ingredients SET cost_per_unit = 2.49, calories_per_unit = 950 WHERE name = 'chicken legs, cut into 4 pieces';
UPDATE ingredients SET cost_per_unit = 2.29, calories_per_unit = 920 WHERE name = 'chicken legs, whole skin off';
UPDATE ingredients SET cost_per_unit = 1.99, calories_per_unit = 1050 WHERE name = 'chicken legs, whole with skin';
UPDATE ingredients SET cost_per_unit = 6.99, calories_per_unit = 900 WHERE name = 'chicken tenders, boneless breaded (halal)';
UPDATE ingredients SET cost_per_unit = 3.99, calories_per_unit = 1090 WHERE name = 'chicken thigh, boneless';
UPDATE ingredients SET cost_per_unit = 3.99, calories_per_unit = 1090 WHERE name = 'chicken thigh, boneless cut 1" pieces';
UPDATE ingredients SET cost_per_unit = 4.49, calories_per_unit = 750 WHERE name = 'chicken thigh, ground';
UPDATE ingredients SET cost_per_unit = 5.99, calories_per_unit = 850 WHERE name = 'chicken, whole baby skin off';
UPDATE ingredients SET cost_per_unit = 12.99, calories_per_unit = 900 WHERE name = 'goat cubes';
UPDATE ingredients SET cost_per_unit = 8.99, calories_per_unit = 450 WHERE name = 'goat paya';
UPDATE ingredients SET cost_per_unit = 9.99, calories_per_unit = 1090 WHERE name = 'Impossible burger';
UPDATE ingredients SET cost_per_unit = 5.99, calories_per_unit = 1300 WHERE name = 'kielbasa sausage';
UPDATE ingredients SET cost_per_unit = 7.99, calories_per_unit = 650 WHERE name = 'liver, goat';
UPDATE ingredients SET cost_per_unit = 11.99, calories_per_unit = 1200 WHERE name = 'mutton, ground';

-- =====================================================
-- BREAD (per unit as specified)
-- =====================================================
UPDATE ingredients SET cost_per_unit = 3.99, calories_per_unit = 800 WHERE name = 'batura bread';
UPDATE ingredients SET cost_per_unit = 3.49, calories_per_unit = 1200 WHERE name = 'bread, Afghani style';
UPDATE ingredients SET cost_per_unit = 6.99, calories_per_unit = 3600 WHERE name = 'flour tortilla, Mission brand';
UPDATE ingredients SET cost_per_unit = 2.99, calories_per_unit = 600 WHERE name = 'French baguette';
UPDATE ingredients SET cost_per_unit = 0.50, calories_per_unit = 150 WHERE name = 'hamburger bun';
UPDATE ingredients SET cost_per_unit = 8.99, calories_per_unit = 2880 WHERE name = 'King''s Hawaiian sweet rolls';
UPDATE ingredients SET cost_per_unit = 4.99, calories_per_unit = 800 WHERE name = 'lavash wrap, Damascus Bakeries brand';
UPDATE ingredients SET cost_per_unit = 4.49, calories_per_unit = 1100 WHERE name = 'potato bread, Martin''s brand';
UPDATE ingredients SET cost_per_unit = 5.99, calories_per_unit = 2400 WHERE name = 'pound cake';
UPDATE ingredients SET cost_per_unit = 4.99, calories_per_unit = 900 WHERE name = 'sheermal';

-- =====================================================
-- FROZEN (per lb or per unit as specified)
-- =====================================================
UPDATE ingredients SET cost_per_unit = 2.99, calories_per_unit = 110 WHERE name = 'cauliflower, frozen riced';
UPDATE ingredients SET cost_per_unit = 1.49, calories_per_unit = 370 WHERE name = 'corn, frozen kernels';
UPDATE ingredients SET cost_per_unit = 3.99, calories_per_unit = 120 WHERE name = 'drumsticks';
UPDATE ingredients SET cost_per_unit = 1.79, calories_per_unit = 360 WHERE name = 'green peas, frozen';
UPDATE ingredients SET cost_per_unit = 3.99, calories_per_unit = 140 WHERE name = 'guvar, frozen';
UPDATE ingredients SET cost_per_unit = 12.99, calories_per_unit = 800 WHERE name = 'kebabs, frozen (ready-made)';
UPDATE ingredients SET cost_per_unit = 3.49, calories_per_unit = 100 WHERE name = 'methi bhaji leaves, frozen';
UPDATE ingredients SET cost_per_unit = 1.99, calories_per_unit = 180 WHERE name = 'mixed vegetables, frozen';
UPDATE ingredients SET cost_per_unit = 4.99, calories_per_unit = 1200 WHERE name = 'naan, tandoori style (frozen)';
UPDATE ingredients SET cost_per_unit = 2.99, calories_per_unit = 140 WHERE name = 'okra, frozen cut';
UPDATE ingredients SET cost_per_unit = 3.99, calories_per_unit = 1200 WHERE name = 'paratha, frozen';
UPDATE ingredients SET cost_per_unit = 3.99, calories_per_unit = 120 WHERE name = 'patvelia, frozen';
UPDATE ingredients SET cost_per_unit = 1.79, calories_per_unit = 200 WHERE name = 'peas and carrots, frozen diced';
UPDATE ingredients SET cost_per_unit = 7.99, calories_per_unit = 1100 WHERE name = 'ravioli, spinach and mozzarella (Pasta Prima brand)';
UPDATE ingredients SET cost_per_unit = 3.99, calories_per_unit = 1000 WHERE name = 'roti packet, frozen';
UPDATE ingredients SET cost_per_unit = 1.49, calories_per_unit = 100 WHERE name = 'spinach, frozen chopped';
UPDATE ingredients SET cost_per_unit = 1.49, calories_per_unit = 100 WHERE name = 'spinach, frozen cut';
UPDATE ingredients SET cost_per_unit = 5.99, calories_per_unit = 600 WHERE name = 'spinach pakoda, frozen, Deep brand';
UPDATE ingredients SET cost_per_unit = 3.99, calories_per_unit = 80 WHERE name = 'tindoora, frozen';

-- =====================================================
-- NON-PERISHABLE (per lb or per unit as specified)
-- =====================================================
UPDATE ingredients SET cost_per_unit = 2.99, calories_per_unit = 50 WHERE name = 'achaar gosht masala, Shan brand';
UPDATE ingredients SET cost_per_unit = 9.99, calories_per_unit = 2630 WHERE name = 'almonds, sliced';
UPDATE ingredients SET cost_per_unit = 8.99, calories_per_unit = 2630 WHERE name = 'almonds, whole unsalted';
UPDATE ingredients SET cost_per_unit = 3.99, calories_per_unit = 900 WHERE name = 'BBQ sauce, Sweet Baby Ray''s brand';
UPDATE ingredients SET cost_per_unit = 1.29, calories_per_unit = 560 WHERE name = 'black beans, canned';
UPDATE ingredients SET cost_per_unit = 1.99, calories_per_unit = 1540 WHERE name = 'black beans, dry';
UPDATE ingredients SET cost_per_unit = 2.49, calories_per_unit = 1540 WHERE name = 'black eyed peas (chawla)';
UPDATE ingredients SET cost_per_unit = 2.99, calories_per_unit = 50 WHERE name = 'butter chicken masala, Shan brand';
UPDATE ingredients SET cost_per_unit = 6.99, calories_per_unit = 40 WHERE name = 'capers';
UPDATE ingredients SET cost_per_unit = 10.99, calories_per_unit = 2530 WHERE name = 'cashews, roasted salted';
UPDATE ingredients SET cost_per_unit = 2.49, calories_per_unit = 1640 WHERE name = 'chana daal';
UPDATE ingredients SET cost_per_unit = 2.49, calories_per_unit = 60 WHERE name = 'chipotle chilies in adobo, Goya brand canned';
UPDATE ingredients SET cost_per_unit = 0.15, calories_per_unit = 6 WHERE name = 'chironji';
UPDATE ingredients SET cost_per_unit = 2.99, calories_per_unit = 50 WHERE name = 'chola batura masala, Badshah brand';
UPDATE ingredients SET cost_per_unit = 4.99, calories_per_unit = 2830 WHERE name = 'coconut, dried shredded';
UPDATE ingredients SET cost_per_unit = 2.49, calories_per_unit = 420 WHERE name = 'coconut milk';
UPDATE ingredients SET cost_per_unit = 1.79, calories_per_unit = 350 WHERE name = 'creamed corn, canned';
UPDATE ingredients SET cost_per_unit = 1.49, calories_per_unit = 180 WHERE name = 'cream of celery condensed soup';
UPDATE ingredients SET cost_per_unit = 4.99, calories_per_unit = 2710 WHERE name = 'crunchy peanut butter, JIF brand';
UPDATE ingredients SET cost_per_unit = 7.99, calories_per_unit = 1250 WHERE name = 'dates, medjool pitted';
UPDATE ingredients SET cost_per_unit = 5.99, calories_per_unit = 1090 WHERE name = 'dried apricots';
UPDATE ingredients SET cost_per_unit = 2.99, calories_per_unit = 1770 WHERE name = 'egg noodles, wide';
UPDATE ingredients SET cost_per_unit = 1.49, calories_per_unit = 1680 WHERE name = 'elbow pasta';
UPDATE ingredients SET cost_per_unit = 1.29, calories_per_unit = 1650 WHERE name = 'flour, chapatti atta';
UPDATE ingredients SET cost_per_unit = 1.29, calories_per_unit = 540 WHERE name = 'garbanzo beans, canned';
UPDATE ingredients SET cost_per_unit = 8.99, calories_per_unit = 4000 WHERE name = 'ghee';
UPDATE ingredients SET cost_per_unit = 4.99, calories_per_unit = 1200 WHERE name = 'gulab jamun, canned';
UPDATE ingredients SET cost_per_unit = 3.99, calories_per_unit = 1680 WHERE name = 'hakka noodles, Ching''s Secret';
UPDATE ingredients SET cost_per_unit = 2.99, calories_per_unit = 50 WHERE name = 'haleem masala, Shan brand';
UPDATE ingredients SET cost_per_unit = 4.99, calories_per_unit = 1500 WHERE name = 'haleem wheat, Sadaf brand';
UPDATE ingredients SET cost_per_unit = 12.99, calories_per_unit = 1500 WHERE name = 'kaari masala';
UPDATE ingredients SET cost_per_unit = 8.99, calories_per_unit = 1250 WHERE name = 'kharak';
UPDATE ingredients SET cost_per_unit = 1.99, calories_per_unit = 1540 WHERE name = 'kidney beans, light dry';
UPDATE ingredients SET cost_per_unit = 2.99, calories_per_unit = 50 WHERE name = 'korma masala, Shan brand';
UPDATE ingredients SET cost_per_unit = 2.99, calories_per_unit = 50 WHERE name = 'Lahori charga masala, Shan brand';
UPDATE ingredients SET cost_per_unit = 2.49, calories_per_unit = 1680 WHERE name = 'lasagne noodles';
UPDATE ingredients SET cost_per_unit = 3.49, calories_per_unit = 1680 WHERE name = 'lasagne noodles, no-boil variety';
UPDATE ingredients SET cost_per_unit = 3.99, calories_per_unit = 100 WHERE name = 'lime juice';
UPDATE ingredients SET cost_per_unit = 1.49, calories_per_unit = 1680 WHERE name = 'macaroni elbow pasta';
UPDATE ingredients SET cost_per_unit = 2.49, calories_per_unit = 1540 WHERE name = 'masoor daal, brown (whole)';
UPDATE ingredients SET cost_per_unit = 2.29, calories_per_unit = 1540 WHERE name = 'masoor daal, red';
UPDATE ingredients SET cost_per_unit = 0.30, calories_per_unit = 10 WHERE name = 'Mexican chili powder';
UPDATE ingredients SET cost_per_unit = 1.79, calories_per_unit = 340 WHERE name = 'milk, evaporated canned';
UPDATE ingredients SET cost_per_unit = 2.49, calories_per_unit = 980 WHERE name = 'milk, sweetened condensed canned';
UPDATE ingredients SET cost_per_unit = 2.49, calories_per_unit = 1540 WHERE name = 'moong daal, whole (green)';
UPDATE ingredients SET cost_per_unit = 2.79, calories_per_unit = 1540 WHERE name = 'moong daal, yellow (split)';
UPDATE ingredients SET cost_per_unit = 1.49, calories_per_unit = 300 WHERE name = 'mushroom soup, canned condensed';
UPDATE ingredients SET cost_per_unit = 2.99, calories_per_unit = 330 WHERE name = 'mustard, yellow spicy';
UPDATE ingredients SET cost_per_unit = 2.49, calories_per_unit = 240 WHERE name = 'olives, black sliced';
UPDATE ingredients SET cost_per_unit = 4.99, calories_per_unit = 520 WHERE name = 'olives, green pimento stuffed';
UPDATE ingredients SET cost_per_unit = 3.99, calories_per_unit = 400 WHERE name = 'pasta sauce, Ragu brand';
UPDATE ingredients SET cost_per_unit = 4.99, calories_per_unit = 2580 WHERE name = 'peanuts, salted roasted';
UPDATE ingredients SET cost_per_unit = 1.49, calories_per_unit = 1680 WHERE name = 'penne pasta';
UPDATE ingredients SET cost_per_unit = 2.49, calories_per_unit = 360 WHERE name = 'pineapple chunks, canned';
UPDATE ingredients SET cost_per_unit = 1.79, calories_per_unit = 1540 WHERE name = 'pinto beans, dry';
UPDATE ingredients SET cost_per_unit = 14.99, calories_per_unit = 2540 WHERE name = 'pistachios, whole shelled';
UPDATE ingredients SET cost_per_unit = 2.99, calories_per_unit = 50 WHERE name = 'Punjabi Yakhni Pulao masala, Shan brand';
UPDATE ingredients SET cost_per_unit = 4.99, calories_per_unit = 1360 WHERE name = 'raisins, golden';
UPDATE ingredients SET cost_per_unit = 1.79, calories_per_unit = 1630 WHERE name = 'rice, basmati';
UPDATE ingredients SET cost_per_unit = 1.49, calories_per_unit = 1630 WHERE name = 'rice, jasmine';
UPDATE ingredients SET cost_per_unit = 1.49, calories_per_unit = 1680 WHERE name = 'rotini pasta';
UPDATE ingredients SET cost_per_unit = 5.99, calories_per_unit = 2540 WHERE name = 'sesame seeds';
UPDATE ingredients SET cost_per_unit = 3.99, calories_per_unit = 1600 WHERE name = 'sev vermicelli';
UPDATE ingredients SET cost_per_unit = 2.99, calories_per_unit = 50 WHERE name = 'Sindhi biryani masala, Shan brand';
UPDATE ingredients SET cost_per_unit = 19.99, calories_per_unit = 4800 WHERE name = 'snack nut variety pack, Kirkland Signature';
UPDATE ingredients SET cost_per_unit = 0.79, calories_per_unit = 1730 WHERE name = 'sugar';
UPDATE ingredients SET cost_per_unit = 7.99, calories_per_unit = 2700 WHERE name = 'tahini paste';
UPDATE ingredients SET cost_per_unit = 2.99, calories_per_unit = 50 WHERE name = 'tandoori masala, Shan brand';
UPDATE ingredients SET cost_per_unit = 8.99, calories_per_unit = 200 WHERE name = 'tea, Wagh Bakhri or Safari brand';
UPDATE ingredients SET cost_per_unit = 1.29, calories_per_unit = 180 WHERE name = 'tomatoes, canned crushed';
UPDATE ingredients SET cost_per_unit = 1.29, calories_per_unit = 110 WHERE name = 'tomatoes, canned diced';
UPDATE ingredients SET cost_per_unit = 1.49, calories_per_unit = 380 WHERE name = 'tomato paste, canned';
UPDATE ingredients SET cost_per_unit = 0.99, calories_per_unit = 150 WHERE name = 'tomato sauce, canned';
UPDATE ingredients SET cost_per_unit = 2.49, calories_per_unit = 1540 WHERE name = 'toor daal';
UPDATE ingredients SET cost_per_unit = 2.79, calories_per_unit = 1600 WHERE name = 'toor daal, oily';
UPDATE ingredients SET cost_per_unit = 2.99, calories_per_unit = 1540 WHERE name = 'urad daal, whole (black)';
UPDATE ingredients SET cost_per_unit = 3.49, calories_per_unit = 400 WHERE name = 'vanilla pudding mix, Jello instant';
UPDATE ingredients SET cost_per_unit = 4.99, calories_per_unit = 200 WHERE name = 'vegetarian oyster sauce';

-- =====================================================
-- OTHER/DESSERTS (per unit as specified)
-- =====================================================
UPDATE ingredients SET cost_per_unit = 0.50, calories_per_unit = 95 WHERE name = 'apples';
UPDATE ingredients SET cost_per_unit = 0.25, calories_per_unit = 105 WHERE name = 'banana';
UPDATE ingredients SET cost_per_unit = 0.05, calories_per_unit = 1 WHERE name = 'blueberries';
UPDATE ingredients SET cost_per_unit = 6.99, calories_per_unit = 800 WHERE name = 'caju pak';
UPDATE ingredients SET cost_per_unit = 5.99, calories_per_unit = 600 WHERE name = 'fruit custard';
UPDATE ingredients SET cost_per_unit = 7.99, calories_per_unit = 1200 WHERE name = 'ice cream - any variey';
UPDATE ingredients SET cost_per_unit = 8.99, calories_per_unit = 1200 WHERE name = 'kheer';
UPDATE ingredients SET cost_per_unit = 0.50, calories_per_unit = 42 WHERE name = 'kiwi';
UPDATE ingredients SET cost_per_unit = 3.99, calories_per_unit = 600 WHERE name = 'Kontos pita loaves';
UPDATE ingredients SET cost_per_unit = 2.50, calories_per_unit = 200 WHERE name = 'kulfi - kesar/kesar pista/other similar';
UPDATE ingredients SET cost_per_unit = 2.50, calories_per_unit = 180 WHERE name = 'kulfi - mango';
UPDATE ingredients SET cost_per_unit = 7.99, calories_per_unit = 1400 WHERE name = 'moong daal halwa';
UPDATE ingredients SET cost_per_unit = 0.50, calories_per_unit = 62 WHERE name = 'orange';
UPDATE ingredients SET cost_per_unit = 0.75, calories_per_unit = 59 WHERE name = 'peach';
UPDATE ingredients SET cost_per_unit = 0.75, calories_per_unit = 102 WHERE name = 'pear';
UPDATE ingredients SET cost_per_unit = 1.00, calories_per_unit = 80 WHERE name = 'persimmons, pomegranates, or other uncut fruit';
UPDATE ingredients SET cost_per_unit = 0.50, calories_per_unit = 30 WHERE name = 'plum';
UPDATE ingredients SET cost_per_unit = 6.99, calories_per_unit = 1800 WHERE name = 'sev zarda';
UPDATE ingredients SET cost_per_unit = 6.99, calories_per_unit = 1200 WHERE name = 'sooji halwa';
UPDATE ingredients SET cost_per_unit = 8.99, calories_per_unit = 880 WHERE name = 'tapenade';

-- =====================================================
-- PANTRY (per unit as specified)
-- =====================================================
UPDATE ingredients SET cost_per_unit = 4.99, calories_per_unit = 150 WHERE name = 'bay leaves';
UPDATE ingredients SET cost_per_unit = 2.49, calories_per_unit = 1630 WHERE name = 'besan (gram flour)';
UPDATE ingredients SET cost_per_unit = 6.99, calories_per_unit = 100 WHERE name = 'Better than Boullion roasted vegetable';
UPDATE ingredients SET cost_per_unit = 5.99, calories_per_unit = 2000 WHERE name = 'birista';
UPDATE ingredients SET cost_per_unit = 2.99, calories_per_unit = 1820 WHERE name = 'bread crumb';
UPDATE ingredients SET cost_per_unit = 4.99, calories_per_unit = 3260 WHERE name = 'butter, unsalted';
UPDATE ingredients SET cost_per_unit = 8.99, calories_per_unit = 18000 WHERE name = 'canola oil';
UPDATE ingredients SET cost_per_unit = 24.99, calories_per_unit = 1360 WHERE name = 'cardamom, green';
UPDATE ingredients SET cost_per_unit = 0.40, calories_per_unit = 15 WHERE name = 'chowmein hakka noodle masala, Ching''s Secret brand';
UPDATE ingredients SET cost_per_unit = 0.10, calories_per_unit = 6 WHERE name = 'cinnamon stick';
UPDATE ingredients SET cost_per_unit = 6.99, calories_per_unit = 1360 WHERE name = 'coriander powder';
UPDATE ingredients SET cost_per_unit = 2.49, calories_per_unit = 1620 WHERE name = 'corn starch';
UPDATE ingredients SET cost_per_unit = 8.99, calories_per_unit = 1780 WHERE name = 'cumin powder';
UPDATE ingredients SET cost_per_unit = 7.99, calories_per_unit = 1680 WHERE name = 'cumin seeds, whole';
UPDATE ingredients SET cost_per_unit = 9.99, calories_per_unit = 1780 WHERE name = 'fenugreek (methi) seeds';
UPDATE ingredients SET cost_per_unit = 0.89, calories_per_unit = 1650 WHERE name = 'flour, all-purpose unbleached';
UPDATE ingredients SET cost_per_unit = 8.99, calories_per_unit = 1430 WHERE name = 'garam masala powder';
UPDATE ingredients SET cost_per_unit = 4.99, calories_per_unit = 200 WHERE name = 'garlic paste';
UPDATE ingredients SET cost_per_unit = 4.99, calories_per_unit = 160 WHERE name = 'ginger paste';
UPDATE ingredients SET cost_per_unit = 7.99, calories_per_unit = 1380 WHERE name = 'honey';
UPDATE ingredients SET cost_per_unit = 1.49, calories_per_unit = 0 WHERE name = 'iodized salt';
UPDATE ingredients SET cost_per_unit = 9.99, calories_per_unit = 1360 WHERE name = 'kashmiri red chili powder';
UPDATE ingredients SET cost_per_unit = 7.99, calories_per_unit = 950 WHERE name = 'kasuri methi leaves';
UPDATE ingredients SET cost_per_unit = 2.99, calories_per_unit = 450 WHERE name = 'ketchup';
UPDATE ingredients SET cost_per_unit = 3.99, calories_per_unit = 0 WHERE name = 'kewra essence';
UPDATE ingredients SET cost_per_unit = 3.99, calories_per_unit = 100 WHERE name = 'lemon juice';
UPDATE ingredients SET cost_per_unit = 4.99, calories_per_unit = 100 WHERE name = 'oregano leaves, dried McCormick brand';
UPDATE ingredients SET cost_per_unit = 8.99, calories_per_unit = 1360 WHERE name = 'red chilies, whole dried';
UPDATE ingredients SET cost_per_unit = 3.00, calories_per_unit = 310 WHERE name = 'saffron';
UPDATE ingredients SET cost_per_unit = 6.99, calories_per_unit = 3860 WHERE name = 'sesame oil';
UPDATE ingredients SET cost_per_unit = 4.99, calories_per_unit = 200 WHERE name = 'soy sauce';
UPDATE ingredients SET cost_per_unit = 3.99, calories_per_unit = 900 WHERE name = 'Sri racha chile sauce';
UPDATE ingredients SET cost_per_unit = 4.99, calories_per_unit = 200 WHERE name = 'tamarind paste';
UPDATE ingredients SET cost_per_unit = 4.99, calories_per_unit = 100 WHERE name = 'thyme leaves, dried McCormick brand';
UPDATE ingredients SET cost_per_unit = 2.99, calories_per_unit = 20 WHERE name = 'vinegar, white';
UPDATE ingredients SET cost_per_unit = 0.00, calories_per_unit = 0 WHERE name = 'water';

-- =====================================================
-- PERISHABLE (per unit as specified)
-- =====================================================
UPDATE ingredients SET cost_per_unit = 7.99, calories_per_unit = 400 WHERE name = 'Frankly Fresh stuffed grape leaves';
UPDATE ingredients SET cost_per_unit = 8.99, calories_per_unit = 1200 WHERE name = 'pesto, Kirkland Signature';
UPDATE ingredients SET cost_per_unit = 2.99, calories_per_unit = 870 WHERE name = 'sour cream';
UPDATE ingredients SET cost_per_unit = 5.99, calories_per_unit = 300 WHERE name = 'tzaziki dip, Hannah brand';

-- =====================================================
-- PRODUCE (per lb or per unit as specified)
-- =====================================================
UPDATE ingredients SET cost_per_unit = 2.99, calories_per_unit = 10 WHERE name = 'basil leaves, fresh';
UPDATE ingredients SET cost_per_unit = 1.49, calories_per_unit = 90 WHERE name = 'bell pepper, green';
UPDATE ingredients SET cost_per_unit = 1.00, calories_per_unit = 30 WHERE name = 'bell pepper, mixed colored';
UPDATE ingredients SET cost_per_unit = 2.99, calories_per_unit = 140 WHERE name = 'bell pepper, red';
UPDATE ingredients SET cost_per_unit = 4.99, calories_per_unit = 260 WHERE name = 'blueberries, fresh';
UPDATE ingredients SET cost_per_unit = 2.49, calories_per_unit = 155 WHERE name = 'brocolli florets, fresh';
UPDATE ingredients SET cost_per_unit = 0.79, calories_per_unit = 110 WHERE name = 'cabbage, green';
UPDATE ingredients SET cost_per_unit = 1.49, calories_per_unit = 68 WHERE name = 'cabbage, Napa';
UPDATE ingredients SET cost_per_unit = 1.29, calories_per_unit = 140 WHERE name = 'cabbage, red';
UPDATE ingredients SET cost_per_unit = 2.49, calories_per_unit = 160 WHERE name = 'carrots, fresh baby cut';
UPDATE ingredients SET cost_per_unit = 2.99, calories_per_unit = 185 WHERE name = 'carrots, shredded';
UPDATE ingredients SET cost_per_unit = 1.29, calories_per_unit = 185 WHERE name = 'carrots, whole fresh';
UPDATE ingredients SET cost_per_unit = 2.49, calories_per_unit = 115 WHERE name = 'cauliflower, fresh';
UPDATE ingredients SET cost_per_unit = 1.99, calories_per_unit = 65 WHERE name = 'celery, whole fresh';
UPDATE ingredients SET cost_per_unit = 0.99, calories_per_unit = 20 WHERE name = 'chilies, green fresh';
UPDATE ingredients SET cost_per_unit = 0.10, calories_per_unit = 5 WHERE name = 'chilies, long green fresh';
UPDATE ingredients SET cost_per_unit = 0.99, calories_per_unit = 40 WHERE name = 'chilies, red fresh (Thai)';
UPDATE ingredients SET cost_per_unit = 1.49, calories_per_unit = 10 WHERE name = 'cilantro';
UPDATE ingredients SET cost_per_unit = 2.49, calories_per_unit = 140 WHERE name = 'collard greens';
UPDATE ingredients SET cost_per_unit = 2.99, calories_per_unit = 410 WHERE name = 'cottage cheese, 2% fat';
UPDATE ingredients SET cost_per_unit = 2.99, calories_per_unit = 45 WHERE name = 'cucumber, English';
UPDATE ingredients SET cost_per_unit = 1.99, calories_per_unit = 15 WHERE name = 'curry leaves, fresh';
UPDATE ingredients SET cost_per_unit = 1.99, calories_per_unit = 65 WHERE name = 'doodhi';
UPDATE ingredients SET cost_per_unit = 1.99, calories_per_unit = 110 WHERE name = 'eggplant, Chinese';
UPDATE ingredients SET cost_per_unit = 2.49, calories_per_unit = 110 WHERE name = 'eggplant, Indian';
UPDATE ingredients SET cost_per_unit = 1.79, calories_per_unit = 110 WHERE name = 'eggplant, regular';
UPDATE ingredients SET cost_per_unit = 4.99, calories_per_unit = 840 WHERE name = 'eggs';
UPDATE ingredients SET cost_per_unit = 3.99, calories_per_unit = 140 WHERE name = 'French beans, whole fresh';
UPDATE ingredients SET cost_per_unit = 6.99, calories_per_unit = 320 WHERE name = 'galangal, fresh';
UPDATE ingredients SET cost_per_unit = 3.99, calories_per_unit = 680 WHERE name = 'garlic, whole peeled';
UPDATE ingredients SET cost_per_unit = 12.99, calories_per_unit = 2000 WHERE name = 'guacamole single serve mini-cup';
UPDATE ingredients SET cost_per_unit = 4.99, calories_per_unit = 315 WHERE name = 'half and half';
UPDATE ingredients SET cost_per_unit = 5.99, calories_per_unit = 820 WHERE name = 'heavy cream';
UPDATE ingredients SET cost_per_unit = 4.99, calories_per_unit = 700 WHERE name = 'hummus';
UPDATE ingredients SET cost_per_unit = 9.99, calories_per_unit = 35 WHERE name = 'kafir lime leaves, whole';
UPDATE ingredients SET cost_per_unit = 4.99, calories_per_unit = 60 WHERE name = 'kokum';
UPDATE ingredients SET cost_per_unit = 0.50, calories_per_unit = 5 WHERE name = 'lemongrass, whole stalk';
UPDATE ingredients SET cost_per_unit = 2.99, calories_per_unit = 80 WHERE name = 'lemons, whole fresh';
UPDATE ingredients SET cost_per_unit = 4.99, calories_per_unit = 100 WHERE name = 'lettuce, Romaine whole head';
UPDATE ingredients SET cost_per_unit = 4.99, calories_per_unit = 1810 WHERE name = 'Mexican blend cheese, shredded';
UPDATE ingredients SET cost_per_unit = 3.99, calories_per_unit = 490 WHERE name = 'milk, 1% fat';
UPDATE ingredients SET cost_per_unit = 4.49, calories_per_unit = 600 WHERE name = 'milk, whole fat';
UPDATE ingredients SET cost_per_unit = 2.49, calories_per_unit = 15 WHERE name = 'mint leaves, fresh';
UPDATE ingredients SET cost_per_unit = 4.49, calories_per_unit = 1280 WHERE name = 'mozzarella cheese, shredded';
UPDATE ingredients SET cost_per_unit = 3.99, calories_per_unit = 100 WHERE name = 'mushrooms, white fresh';
UPDATE ingredients SET cost_per_unit = 1.29, calories_per_unit = 180 WHERE name = 'onions, red';
UPDATE ingredients SET cost_per_unit = 0.99, calories_per_unit = 180 WHERE name = 'onions, yellow';
UPDATE ingredients SET cost_per_unit = 6.99, calories_per_unit = 1200 WHERE name = 'paneer';
UPDATE ingredients SET cost_per_unit = 8.99, calories_per_unit = 1800 WHERE name = 'parmesan cheese, grated';
UPDATE ingredients SET cost_per_unit = 1.99, calories_per_unit = 15 WHERE name = 'parsley, fresh';
UPDATE ingredients SET cost_per_unit = 2.49, calories_per_unit = 320 WHERE name = 'potatoes, baby size';
UPDATE ingredients SET cost_per_unit = 1.49, calories_per_unit = 350 WHERE name = 'potatoes, red or yellow';
UPDATE ingredients SET cost_per_unit = 4.99, calories_per_unit = 740 WHERE name = 'ricotta cheese, whole milk';
UPDATE ingredients SET cost_per_unit = 1.49, calories_per_unit = 15 WHERE name = 'scallions, fresh (green onions)';
UPDATE ingredients SET cost_per_unit = 3.99, calories_per_unit = 105 WHERE name = 'spinach leaves, fresh';
UPDATE ingredients SET cost_per_unit = 1.79, calories_per_unit = 390 WHERE name = 'sweet potatoes';
UPDATE ingredients SET cost_per_unit = 2.99, calories_per_unit = 350 WHERE name = 'tofu, extra firm';
UPDATE ingredients SET cost_per_unit = 3.99, calories_per_unit = 80 WHERE name = 'tomatoes, cherry fresh';
UPDATE ingredients SET cost_per_unit = 1.99, calories_per_unit = 80 WHERE name = 'tomato, fresh';
UPDATE ingredients SET cost_per_unit = 29.99, calories_per_unit = 3000 WHERE name = 'tres leches caramel cake';
UPDATE ingredients SET cost_per_unit = 19.99, calories_per_unit = 3500 WHERE name = 'tuxedo cake';
UPDATE ingredients SET cost_per_unit = 4.99, calories_per_unit = 260 WHERE name = 'yogurt, greek 0% fat';
UPDATE ingredients SET cost_per_unit = 3.49, calories_per_unit = 280 WHERE name = 'yogurt, lowfat';
UPDATE ingredients SET cost_per_unit = 3.99, calories_per_unit = 340 WHERE name = 'yogurt, whole milk';
UPDATE ingredients SET cost_per_unit = 1.99, calories_per_unit = 75 WHERE name = 'zucchini';

-- =====================================================
-- REFRIGERATOR (per unit as specified)
-- =====================================================
UPDATE ingredients SET cost_per_unit = 3.99, calories_per_unit = 900 WHERE name = 'chili garlic sauce';
UPDATE ingredients SET cost_per_unit = 5.99, calories_per_unit = 100 WHERE name = 'lettuce, Spring Mix (mixed greens)';
UPDATE ingredients SET cost_per_unit = 3.99, calories_per_unit = 3140 WHERE name = 'mayonaise';
UPDATE ingredients SET cost_per_unit = 2.49, calories_per_unit = 1640 WHERE name = 'semolina, fine (sooji)';

-- =====================================================
-- SHELF (per unit as specified)
-- =====================================================
UPDATE ingredients SET cost_per_unit = 0.05, calories_per_unit = 50 WHERE name = 'corn tortilla';
UPDATE ingredients SET cost_per_unit = 0.15, calories_per_unit = 20 WHERE name = 'limes, fresh';
UPDATE ingredients SET cost_per_unit = 9.99, calories_per_unit = 3860 WHERE name = 'olive oil, extra virgin';

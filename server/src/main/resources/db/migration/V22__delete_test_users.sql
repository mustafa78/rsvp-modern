-- Delete test users with ITS IDs: 30712127, 20355804, 30309367, 30469206
-- This migration removes these users and their related data

-- First, delete related session tokens
DELETE FROM session_tokens WHERE person_id IN (
    SELECT id FROM persons WHERE its_number IN ('30712127', '20355804', '30309367', '30469206')
);

-- Delete related niyaz RSVPs
DELETE FROM niyaz_rsvps WHERE person_id IN (
    SELECT id FROM persons WHERE its_number IN ('30712127', '20355804', '30309367', '30469206')
);

-- Delete related thaali order items (child of thaali_orders)
DELETE FROM thaali_order_items WHERE order_id IN (
    SELECT id FROM thaali_orders WHERE person_id IN (
        SELECT id FROM persons WHERE its_number IN ('30712127', '20355804', '30309367', '30469206')
    )
);

-- Delete related thaali orders
DELETE FROM thaali_orders WHERE person_id IN (
    SELECT id FROM persons WHERE its_number IN ('30712127', '20355804', '30309367', '30469206')
);

-- Delete related password reset tokens
DELETE FROM password_reset_tokens WHERE person_id IN (
    SELECT id FROM persons WHERE its_number IN ('30712127', '20355804', '30309367', '30469206')
);

-- Finally, delete the persons
DELETE FROM persons WHERE its_number IN ('30712127', '20355804', '30309367', '30469206');

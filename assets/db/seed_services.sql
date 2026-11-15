-- শুধু ৮টি সেবার নাম ও ধরন। কোনো অফিস, ফোন, ঠিকানা, ফি বা কাগজপত্রের তথ্য এখানে নেই।
-- সব সেবা needs_review অবস্থায়; সরকারি সূত্র থেকে যাচাইয়ের পরই verified হবে।

INSERT INTO services (slug, name_bn, name_en, category) VALUES
 ('old-age-allowance', 'বয়স্ক ভাতা', 'Old Age Allowance', 'allowance'),
 ('widow-allowance', 'বিধবা ও স্বামী নিগৃহীতা মহিলা ভাতা', 'Widow and Husband-Deserted Women''s Allowance', 'allowance'),
 ('disability-allowance', 'প্রতিবন্ধী ভাতা', 'Disability Allowance', 'allowance'),
 ('birth-registration', 'জন্মনিবন্ধন', 'Birth Registration', 'civil_registration'),
 ('nid-services', 'জাতীয় পরিচয়পত্র সেবা', 'National Identity Card Services', 'identity'),
 ('passport', 'পাসপোর্ট', 'Passport', 'travel_document'),
 ('trade-license', 'ট্রেড লাইসেন্স', 'Trade License', 'business'),
 ('education-stipend', 'শিক্ষা উপবৃত্তি', 'Education Stipend', 'education');

INSERT INTO service_keywords (service_id, keyword)
SELECT id, k FROM services, (SELECT 'বয়স্ক ভাতা' AS k UNION SELECT 'বয়স্কভাতা' UNION SELECT 'বৃদ্ধ ভাতা') WHERE slug = 'old-age-allowance';
INSERT INTO service_keywords (service_id, keyword)
SELECT id, k FROM services, (SELECT 'বিধবা ভাতা' AS k UNION SELECT 'স্বামী নিগৃহীতা' UNION SELECT 'বিধবা') WHERE slug = 'widow-allowance';
INSERT INTO service_keywords (service_id, keyword)
SELECT id, k FROM services, (SELECT 'প্রতিবন্ধী ভাতা' AS k UNION SELECT 'প্রতিবন্ধী' UNION SELECT 'দিব্যাঙ্গ') WHERE slug = 'disability-allowance';
INSERT INTO service_keywords (service_id, keyword)
SELECT id, k FROM services, (SELECT 'জন্মনিবন্ধন' AS k UNION SELECT 'জন্ম নিবন্ধন' UNION SELECT 'জন্মসনদ' UNION SELECT 'জন্ম সনদ') WHERE slug = 'birth-registration';
INSERT INTO service_keywords (service_id, keyword)
SELECT id, k FROM services, (SELECT 'এনআইডি' AS k UNION SELECT 'জাতীয় পরিচয়পত্র' UNION SELECT 'ভোটার আইডি' UNION SELECT 'NID') WHERE slug = 'nid-services';
INSERT INTO service_keywords (service_id, keyword)
SELECT id, k FROM services, (SELECT 'পাসপোর্ট' AS k UNION SELECT 'passport') WHERE slug = 'passport';
INSERT INTO service_keywords (service_id, keyword)
SELECT id, k FROM services, (SELECT 'ট্রেড লাইসেন্স' AS k UNION SELECT 'ট্রেডলাইসেন্স' UNION SELECT 'ব্যবসার লাইসেন্স') WHERE slug = 'trade-license';
INSERT INTO service_keywords (service_id, keyword)
SELECT id, k FROM services, (SELECT 'উপবৃত্তি' AS k UNION SELECT 'শিক্ষা উপবৃত্তি' UNION SELECT 'বৃত্তি') WHERE slug = 'education-stipend';

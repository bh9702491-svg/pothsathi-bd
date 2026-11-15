-- পথসাথী BD ডাটাবেস স্কিমা (সংস্করণ ১)
-- ভেরিফিকেশন স্ট্যাটাস: verified | needs_review | outdated
-- নিয়ম: verified হতে হলে last_verified_at বাধ্যতামূলক

CREATE TABLE sources (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  url TEXT NOT NULL UNIQUE,
  publisher TEXT,
  source_type TEXT NOT NULL DEFAULT 'official_website'
    CHECK (source_type IN ('official_website','gazette','circular','portal','other')),
  accessed_at TEXT,
  created_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE services (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  slug TEXT NOT NULL UNIQUE,
  name_bn TEXT NOT NULL,
  name_en TEXT NOT NULL,
  category TEXT NOT NULL
    CHECK (category IN ('allowance','civil_registration','identity','travel_document','business','education','other')),
  summary_bn TEXT,
  online_apply_url TEXT,
  fee_info_bn TEXT,
  processing_time_bn TEXT,
  is_demo INTEGER NOT NULL DEFAULT 0 CHECK (is_demo IN (0,1)),
  verification_status TEXT NOT NULL DEFAULT 'needs_review'
    CHECK (verification_status IN ('verified','needs_review','outdated')),
  last_verified_at TEXT,
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  updated_at TEXT NOT NULL DEFAULT (datetime('now')),
  CHECK (verification_status <> 'verified' OR last_verified_at IS NOT NULL)
);

CREATE TABLE offices (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name_bn TEXT NOT NULL,
  name_en TEXT,
  office_type TEXT,
  division TEXT,
  district TEXT,
  upazila TEXT,
  address_bn TEXT,
  phone TEXT,
  email TEXT,
  website_url TEXT,
  maps_url TEXT,
  is_demo INTEGER NOT NULL DEFAULT 0 CHECK (is_demo IN (0,1)),
  verification_status TEXT NOT NULL DEFAULT 'needs_review'
    CHECK (verification_status IN ('verified','needs_review','outdated')),
  last_verified_at TEXT,
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  updated_at TEXT NOT NULL DEFAULT (datetime('now')),
  CHECK (verification_status <> 'verified' OR last_verified_at IS NOT NULL)
);

-- কোন অফিস কোন এলাকার দায়িত্বে (upazila NULL মানে পুরো জেলা)
CREATE TABLE office_jurisdictions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  office_id INTEGER NOT NULL REFERENCES offices(id) ON DELETE CASCADE,
  division TEXT,
  district TEXT NOT NULL,
  upazila TEXT,
  note_bn TEXT
);

-- একটি সেবার একাধিক অফিস, একটি অফিসের একাধিক সেবা
CREATE TABLE service_offices (
  service_id INTEGER NOT NULL REFERENCES services(id) ON DELETE CASCADE,
  office_id INTEGER NOT NULL REFERENCES offices(id) ON DELETE CASCADE,
  role_bn TEXT,
  notes_bn TEXT,
  PRIMARY KEY (service_id, office_id)
);

CREATE TABLE required_documents (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  service_id INTEGER NOT NULL REFERENCES services(id) ON DELETE CASCADE,
  name_bn TEXT NOT NULL,
  details_bn TEXT,
  is_mandatory INTEGER NOT NULL DEFAULT 1 CHECK (is_mandatory IN (0,1)),
  sort_order INTEGER NOT NULL DEFAULT 0,
  source_id INTEGER REFERENCES sources(id) ON DELETE SET NULL,
  verification_status TEXT NOT NULL DEFAULT 'needs_review'
    CHECK (verification_status IN ('verified','needs_review','outdated'))
);

CREATE TABLE application_steps (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  service_id INTEGER NOT NULL REFERENCES services(id) ON DELETE CASCADE,
  step_no INTEGER NOT NULL CHECK (step_no > 0),
  title_bn TEXT NOT NULL,
  details_bn TEXT,
  source_id INTEGER REFERENCES sources(id) ON DELETE SET NULL,
  verification_status TEXT NOT NULL DEFAULT 'needs_review'
    CHECK (verification_status IN ('verified','needs_review','outdated')),
  UNIQUE (service_id, step_no)
);

CREATE TABLE service_sources (
  service_id INTEGER NOT NULL REFERENCES services(id) ON DELETE CASCADE,
  source_id INTEGER NOT NULL REFERENCES sources(id) ON DELETE CASCADE,
  PRIMARY KEY (service_id, source_id)
);

-- প্রতিটি যাচাইয়ের ইতিহাস
CREATE TABLE verification_records (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  entity_type TEXT NOT NULL CHECK (entity_type IN ('service','office','document','step')),
  entity_id INTEGER NOT NULL,
  status TEXT NOT NULL CHECK (status IN ('verified','needs_review','outdated')),
  source_id INTEGER REFERENCES sources(id) ON DELETE SET NULL,
  verified_by TEXT,
  note TEXT,
  verified_at TEXT NOT NULL DEFAULT (datetime('now'))
);

-- সার্চের জন্য ব্যবহারকারীর ভাষার কীওয়ার্ড (তথ্য নয়, শুধু মিলানোর শব্দ)
CREATE TABLE service_keywords (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  service_id INTEGER NOT NULL REFERENCES services(id) ON DELETE CASCADE,
  keyword TEXT NOT NULL,
  UNIQUE (service_id, keyword)
);

CREATE TABLE career_paths (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  slug TEXT NOT NULL UNIQUE,
  title_bn TEXT NOT NULL,
  description_bn TEXT
);

CREATE TABLE learning_tasks (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  career_path_id INTEGER NOT NULL REFERENCES career_paths(id) ON DELETE CASCADE,
  level TEXT NOT NULL CHECK (level IN ('beginner','intermediate','advanced')),
  day_no INTEGER,
  title_bn TEXT NOT NULL,
  details_bn TEXT,
  resource_url TEXT,
  resource_is_free INTEGER NOT NULL DEFAULT 1 CHECK (resource_is_free IN (0,1)),
  sort_order INTEGER NOT NULL DEFAULT 0
);

-- ব্যবহারকারী প্রোফাইল: একটিই সারি; NID/OTP/ব্যাংক তথ্য রাখা হয় না
CREATE TABLE user_profile (
  id INTEGER PRIMARY KEY CHECK (id = 1),
  display_name TEXT,
  division TEXT,
  district TEXT,
  upazila TEXT,
  updated_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE saved_guides (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  service_id INTEGER NOT NULL UNIQUE REFERENCES services(id) ON DELETE CASCADE,
  saved_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE user_progress (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  learning_task_id INTEGER NOT NULL UNIQUE REFERENCES learning_tasks(id) ON DELETE CASCADE,
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending','in_progress','done')),
  updated_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE checklist_items (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  service_id INTEGER REFERENCES services(id) ON DELETE SET NULL,
  kind TEXT NOT NULL CHECK (kind IN ('document','task')),
  title_bn TEXT NOT NULL,
  is_done INTEGER NOT NULL DEFAULT 0 CHECK (is_done IN (0,1)),
  created_at TEXT NOT NULL DEFAULT (datetime('now'))
);

-- ভুল তথ্যের রিপোর্ট (ব্যবহারকারী শুধু রিপোর্ট জমা দিতে পারে, সরকারি রেকর্ড বদলাতে পারে না)
CREATE TABLE error_reports (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  entity_type TEXT NOT NULL CHECK (entity_type IN ('service','office','document','step')),
  entity_id INTEGER NOT NULL,
  message_bn TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'new' CHECK (status IN ('new','reviewed','resolved')),
  created_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE INDEX idx_services_category ON services(category);
CREATE INDEX idx_services_status ON services(verification_status);
CREATE INDEX idx_offices_location ON offices(district, upazila);
CREATE INDEX idx_jurisdictions_location ON office_jurisdictions(district, upazila);
CREATE INDEX idx_jurisdictions_office ON office_jurisdictions(office_id);
CREATE INDEX idx_service_offices_office ON service_offices(office_id);
CREATE INDEX idx_documents_service ON required_documents(service_id, sort_order);
CREATE INDEX idx_steps_service ON application_steps(service_id, step_no);
CREATE INDEX idx_keywords_keyword ON service_keywords(keyword);
CREATE INDEX idx_tasks_path ON learning_tasks(career_path_id, level, sort_order);
CREATE INDEX idx_verification_entity ON verification_records(entity_type, entity_id);
CREATE INDEX idx_error_reports_status ON error_reports(status);

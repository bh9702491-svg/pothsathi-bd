"""ডাটাবেস স্কিমা ও সিড ডাটা যাচাই (অ্যাপের Dart কোডের মতো একই নিয়মে স্টেটমেন্ট ভাগ করে)।"""
import sqlite3, sys

def split_sql(script):
    no_comments = "\n".join(l for l in script.split("\n") if not l.lstrip().startswith("--"))
    return [s.strip() for s in no_comments.split(";") if s.strip()]

db = sqlite3.connect(":memory:")
db.execute("PRAGMA foreign_keys = ON")
for f in ["assets/db/schema.sql", "assets/db/seed_services.sql"]:
    for stmt in split_sql(open(f, encoding="utf-8").read()):
        db.execute(stmt)

ok = True
def check(name, cond):
    global ok
    print(("PASS " if cond else "FAIL ") + name)
    ok = ok and cond

def raises(sql, args=()):
    try:
        db.execute(sql, args); return False
    except sqlite3.IntegrityError:
        return True

tables = {r[0] for r in db.execute("SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'")}
required = {"services","offices","service_offices","required_documents","application_steps","sources",
            "verification_records","career_paths","learning_tasks","saved_guides","user_progress"}
check("স্পেসিফিকেশনের ১১টি টেবিল আছে", required <= tables)
check(f"মোট টেবিল: {len(tables)}", True)
check("৮টি সেবা", db.execute("SELECT COUNT(*) FROM services").fetchone()[0] == 8)
check("সব সেবা needs_review (কিছুই verified নয়)",
      db.execute("SELECT COUNT(*) FROM services WHERE verification_status!='needs_review'").fetchone()[0] == 0)
check("কোনো অফিস/ঠিকানা/ফোন সিড করা নেই", db.execute("SELECT COUNT(*) FROM offices").fetchone()[0] == 0)
check("প্রতিটি সেবার কীওয়ার্ড আছে",
      db.execute("SELECT COUNT(*) FROM services s WHERE NOT EXISTS (SELECT 1 FROM service_keywords k WHERE k.service_id=s.id)").fetchone()[0] == 0)
check("foreign_key_check পরিষ্কার", db.execute("PRAGMA foreign_key_check").fetchall() == [])

check("তারিখ ছাড়া 'verified' বসানো যায় না",
      raises("UPDATE services SET verification_status='verified' WHERE id=1"))
db.execute("UPDATE services SET verification_status='verified', last_verified_at='2026-11-10' WHERE id=1")
check("তারিখসহ 'verified' বসানো যায়", True)
check("ভুল স্ট্যাটাস মান আটকায়", raises("UPDATE services SET verification_status='ok' WHERE id=2"))
check("ভুল category আটকায়", raises("INSERT INTO services(slug,name_bn,name_en,category) VALUES('x','x','x','bad')"))
check("সদৃশ slug আটকায়", raises("INSERT INTO services(slug,name_bn,name_en,category) VALUES('passport','x','x','other')"))
check("অস্তিত্বহীন সেবায় নথি আটকায়", raises("INSERT INTO required_documents(service_id,name_bn) VALUES(999,'x')"))
check("একই সেবায় একই step_no আটকায়",
      not raises("INSERT INTO application_steps(service_id,step_no,title_bn) VALUES(1,1,'a')") and
      raises("INSERT INTO application_steps(service_id,step_no,title_bn) VALUES(1,1,'b')"))

# বহু-থেকে-বহু সম্পর্ক
db.execute("INSERT INTO offices(name_bn,is_demo) VALUES('ডেমো অফিস ক',1)")
db.execute("INSERT INTO offices(name_bn,is_demo) VALUES('ডেমো অফিস খ',1)")
for s, o in [(1,1),(1,2),(2,1)]:
    db.execute("INSERT INTO service_offices(service_id,office_id) VALUES(?,?)", (s,o))
check("এক সেবা-একাধিক অফিস ও এক অফিস-একাধিক সেবা", True)
check("একই (সেবা,অফিস) জোড়া দুইবার আটকায়", raises("INSERT INTO service_offices(service_id,office_id) VALUES(1,1)"))
db.execute("DELETE FROM services WHERE id=1")
check("সেবা মুছলে সংশ্লিষ্ট কীওয়ার্ড/জোড়া মোছে (CASCADE)",
      db.execute("SELECT COUNT(*) FROM service_keywords WHERE service_id=1").fetchone()[0] == 0)
check("user_profile শুধু একটি সারি (id=1)", raises("INSERT INTO user_profile(id) VALUES(2)"))

print("\nফলাফল:", "সব ঠিক আছে" if ok else "ব্যর্থ")
sys.exit(0 if ok else 1)

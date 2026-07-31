"""
Seed rich sample data into toeic_auth (users) and toeic_exam (exam_results)
so that all dashboards (Student, Manager, Admin) display rich, realistic dynamic data.
"""
import psycopg2
import bcrypt
import json
import uuid
from datetime import datetime, timedelta, timezone

AUTH_CONN = dict(host='localhost', port=5433, user='toeic_auth', password='change-me-auth', dbname='toeic_auth')
EXAM_CONN = dict(host='localhost', port=5434, user='toeic_exam', password='change-me-exam', dbname='toeic_exam')

def hash_pass(pwd):
    return bcrypt.hashpw(pwd.encode('utf-8'), bcrypt.gensalt(10)).decode('utf-8')

def main():
    auth_db = psycopg2.connect(**AUTH_CONN)
    exam_db = psycopg2.connect(**EXAM_CONN)
    ac = auth_db.cursor()
    ec = exam_db.cursor()

    default_pass = hash_pass('admin123')

    # 1. Seed Accounts into toeic_auth.users
    users_data = [
        ('1bce7142-da6d-4078-86de-02dcc4544a05', 'admin@toeic.com', 'Super Admin', 'SUPERADMIN', 'system'),
        ('a65c4394-907d-4d29-8f33-eb3f04ef22c6', 'manager@toeic.com', 'Bạch Sỹ Núi', 'MANAGER', 'tt-hanoi-01'),
        ('b1111111-1111-1111-1111-111111111111', 'manager.hcm@toeic.com', 'Lê Hoàng Nam', 'MANAGER', 'tt-hcm-01'),
        ('321656f7-1fbd-4a1f-8bad-c808ef95f2e6', 'student@example.com', 'Google User', 'STUDENT', 'tt-hanoi-01'),
        ('379dec63-538e-45da-9399-9e2705d40239', 'testreg@toeic.com', 'Nguyễn Thị Lan', 'STUDENT', 'tt-hanoi-01'),
        ('c2222222-2222-2222-2222-222222222222', 'khoa.tran@example.com', 'Trần Minh Khoa', 'STUDENT', 'tt-hanoi-01'),
        ('c3333333-3333-3333-3333-333333333333', 'ha.le@example.com', 'Lê Thu Hà', 'STUDENT', 'tt-hanoi-01'),
        ('c4444444-4444-4444-4444-444444444444', 'bao.pham@example.com', 'Phạm Quốc Bảo', 'STUDENT', 'tt-hanoi-01'),
        ('c5555555-5555-5555-5555-555555555555', 'mai.vu@example.com', 'Vũ Thanh Mai', 'STUDENT', 'tt-hanoi-01'),
    ]

    for uid, email, name, role, tenant in users_data:
        ac.execute("DELETE FROM users WHERE email = %s OR id = %s", (email, uid))
        ac.execute("""
            INSERT INTO users (id, email, name, password_hash, role, tenant_id, created_at)
            VALUES (%s, %s, %s, %s, %s, %s, NOW())
        """, (uid, email, name, default_pass, role, tenant))

    auth_db.commit()
    print("✅ Seeded users into toeic_auth.users")

    # 2. Seed Test Results into toeic_exam.exam_results
    test_results_data = [
        ('321656f7-1fbd-4a1f-8bad-c808ef95f2e6', 'toeic-test-01', 75, 70, 1),
        ('321656f7-1fbd-4a1f-8bad-c808ef95f2e6', 'toeic-test-02', 80, 78, 3),
        ('379dec63-538e-45da-9399-9e2705d40239', 'toeic-test-01', 82, 75, 2),
        ('379dec63-538e-45da-9399-9e2705d40239', 'toeic-test-02', 88, 80, 5),
        ('c2222222-2222-2222-2222-222222222222', 'toeic-test-01', 65, 62, 4),
        ('c2222222-2222-2222-2222-222222222222', 'toeic-test-03', 70, 68, 6),
        ('c3333333-3333-3333-3333-333333333333', 'toeic-test-01', 92, 85, 1),
        ('c3333333-3333-3333-3333-333333333333', 'toeic-test-04', 95, 90, 3),
        ('c4444444-4444-4444-4444-444444444444', 'toeic-test-01', 58, 55, 7),
        ('c5555555-5555-5555-5555-555555555555', 'toeic-test-01', 94, 92, 2),
        ('c5555555-5555-5555-5555-555555555555', 'toeic-test-05', 98, 95, 4),
    ]

    for uid, ecode, l_corr, r_corr, days_ago in test_results_data:
        l_score = min(495, max(5, round(l_corr * 4.95)))
        r_score = min(495, max(5, round(r_corr * 4.95)))
        tot = l_score + r_score
        sub_time = datetime.now(timezone.utc) - timedelta(days=days_ago)
        answers = {str(i): "A" if i % 4 == 0 else "B" for i in range(1, 201)}

        ec.execute("""
            INSERT INTO exam_results (id, user_id, exam_code, listening_correct, reading_correct, listening_score, reading_score, total_score, answers, submitted_at)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
            ON CONFLICT (id) DO NOTHING
        """, (str(uuid.uuid4()), uid, ecode, l_corr, r_corr, l_score, r_score, tot, json.dumps(answers), sub_time))

    exam_db.commit()
    print("✅ Seeded realistic exam_results into toeic_exam.exam_results")

    ac.close(); auth_db.close()
    ec.close(); exam_db.close()

if __name__ == '__main__':
    main()

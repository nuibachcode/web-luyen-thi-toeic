"""
Tạo bảng exams trong Render PostgreSQL và seed 15 bộ đề thi.
"""
import psycopg2
import uuid
from datetime import datetime, timezone

DB_URL = "postgresql://toeic_user:0FcKcaH548fGZFvD66F68KuGFdUyKCWg@dpg-d9ndhsdaeets73bn2jm0-a.oregon-postgres.render.com/toeic_db_qwyv?sslmode=require"

EXAMS = [
    ("toeic-test-01", "TOEIC Practice Test 01", "Bộ đề thi thử TOEIC tổng hợp số 1 - 200 câu hỏi đầy đủ 7 phần"),
    ("toeic-test-02", "TOEIC Practice Test 02", "Bộ đề thi thử TOEIC tổng hợp số 2 - 200 câu hỏi đầy đủ 7 phần"),
    ("toeic-test-03", "TOEIC Practice Test 03", "Bộ đề thi thử TOEIC tổng hợp số 3 - 200 câu hỏi đầy đủ 7 phần"),
    ("toeic-test-04", "TOEIC Practice Test 04", "Bộ đề thi thử TOEIC tổng hợp số 4 - 200 câu hỏi đầy đủ 7 phần"),
    ("toeic-test-05", "TOEIC Practice Test 05", "Bộ đề thi thử TOEIC tổng hợp số 5 - 200 câu hỏi đầy đủ 7 phần"),
    ("toeic-test-06", "TOEIC Practice Test 06", "Bộ đề thi thử TOEIC tổng hợp số 6 - 200 câu hỏi đầy đủ 7 phần"),
    ("toeic-test-07", "TOEIC Practice Test 07", "Bộ đề thi thử TOEIC tổng hợp số 7 - 200 câu hỏi đầy đủ 7 phần"),
    ("toeic-test-08", "TOEIC Practice Test 08", "Bộ đề thi thử TOEIC tổng hợp số 8 - 200 câu hỏi đầy đủ 7 phần"),
    ("toeic-test-09", "TOEIC Practice Test 09", "Bộ đề thi thử TOEIC tổng hợp số 9 - 200 câu hỏi đầy đủ 7 phần"),
    ("toeic-test-10", "TOEIC Practice Test 10", "Bộ đề thi thử TOEIC tổng hợp số 10 - 200 câu hỏi đầy đủ 7 phần"),
    ("toeic-test-11", "TOEIC Practice Test 11", "Bộ đề thi thử TOEIC tổng hợp số 11 - 200 câu hỏi đầy đủ 7 phần"),
    ("toeic-test-12", "TOEIC Practice Test 12", "Bộ đề thi thử TOEIC tổng hợp số 12 - 200 câu hỏi đầy đủ 7 phần"),
    ("toeic-test-13", "TOEIC Practice Test 13", "Bộ đề thi thử TOEIC tổng hợp số 13 - 200 câu hỏi đầy đủ 7 phần"),
    ("toeic-test-14", "TOEIC Practice Test 14", "Bộ đề thi thử TOEIC tổng hợp số 14 - 200 câu hỏi đầy đủ 7 phần"),
    ("toeic-test-15", "TOEIC Practice Test 15", "Bộ đề thi thử TOEIC tổng hợp số 15 - 200 câu hỏi đầy đủ 7 phần"),
]

def main():
    conn = psycopg2.connect(DB_URL)
    cur = conn.cursor()

    # Create exams table if not exists (matching Prisma schema exactly)
    cur.execute("""
        CREATE TABLE IF NOT EXISTS exams (
            id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
            code VARCHAR(100) UNIQUE NOT NULL,
            title VARCHAR(255) NOT NULL,
            description TEXT,
            duration_minutes SMALLINT NOT NULL DEFAULT 120,
            status VARCHAR(20) NOT NULL DEFAULT 'PUBLISHED',
            questions JSONB NOT NULL DEFAULT '[]',
            created_by UUID,
            created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
            updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
        )
    """)
    conn.commit()
    print("Table exams created/verified OK")

    now = datetime.now(timezone.utc)
    inserted = 0
    skipped = 0

    for code, title, description in EXAMS:
        cur.execute("SELECT code FROM exams WHERE code = %s", (code,))
        if cur.fetchone():
            print(f"  SKIP: {code}")
            skipped += 1
            continue
        cur.execute(
            """INSERT INTO exams (id, code, title, description, duration_minutes, status, questions, created_at, updated_at)
               VALUES (%s, %s, %s, %s, %s, %s, %s::jsonb, %s, %s)""",
            (str(uuid.uuid4()), code, title, description, 120, 'PUBLISHED', '[]', now, now)
        )
        print(f"  INSERT: {code}")
        inserted += 1

    conn.commit()

    # Verify
    cur.execute("SELECT COUNT(*) FROM exams")
    total = cur.fetchone()[0]
    print(f"\nDone! Inserted: {inserted}, Skipped: {skipped}, Total in DB: {total}")

    cur.close()
    conn.close()

if __name__ == "__main__":
    main()

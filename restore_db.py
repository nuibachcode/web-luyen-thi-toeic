"""
Tạo lại toàn bộ bảng DB trên Render PostgreSQL và re-seed data.
Chạy script này khi DB bị reset/mất bảng.
"""
import psycopg2
import psycopg2.extras
import uuid
import json
import glob
import os
from datetime import datetime, timezone

DB_URL = "postgresql://toeic_user:0FcKcaH548fGZFvD66F68KuGFdUyKCWg@dpg-d9ndhsdaeets73bn2jm0-a.oregon-postgres.render.com/toeic_db_qwyv?sslmode=require"
EXAM_JSON_DIR = "crawler/downloaded_exams"

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
    conn.autocommit = False
    cur = conn.cursor()

    print("=== TẠO LẠI TOÀN BỘ BẢNG DB ===\n")

    # 1. users (account-service)
    cur.execute("""
        CREATE TABLE IF NOT EXISTS users (
            id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
            google_id VARCHAR(255) UNIQUE,
            email VARCHAR(255) UNIQUE NOT NULL,
            name VARCHAR(255) NOT NULL,
            picture TEXT,
            password_hash VARCHAR(255),
            role VARCHAR(50) NOT NULL DEFAULT 'STUDENT',
            tenant_id VARCHAR(255),
            created_at TIMESTAMPTZ DEFAULT NOW()
        )
    """)
    print("✅ Table 'users' OK")

    # 2. exams (catalog-service)
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
    print("✅ Table 'exams' OK")

    # 3. questions (exam-service)
    cur.execute("""
        CREATE TABLE IF NOT EXISTS questions (
            id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
            exam_code VARCHAR(100) NOT NULL,
            question_number SMALLINT NOT NULL,
            part SMALLINT NOT NULL,
            section VARCHAR(20),
            question_text TEXT,
            option_a TEXT,
            option_b TEXT,
            option_c TEXT,
            option_d TEXT,
            correct_answer VARCHAR(1),
            explanation_vi TEXT,
            explanation_en TEXT,
            audio_url TEXT,
            image_url TEXT,
            passage_id VARCHAR(100),
            passage_text TEXT,
            passage_audio TEXT,
            passage_image TEXT,
            tu_vung JSONB,
            raw_data JSONB,
            UNIQUE(exam_code, question_number)
        )
    """)
    cur.execute("CREATE INDEX IF NOT EXISTS idx_questions_exam_code ON questions(exam_code)")
    cur.execute("CREATE INDEX IF NOT EXISTS idx_questions_exam_part ON questions(exam_code, part)")
    print("✅ Table 'questions' OK")

    # 4. exam_results (exam-service)
    cur.execute("""
        CREATE TABLE IF NOT EXISTS exam_results (
            id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
            user_id UUID NOT NULL,
            exam_code VARCHAR(100) NOT NULL,
            listening_correct SMALLINT NOT NULL,
            reading_correct SMALLINT NOT NULL,
            listening_score SMALLINT NOT NULL,
            reading_score SMALLINT NOT NULL,
            total_score SMALLINT NOT NULL,
            answers JSONB NOT NULL DEFAULT '{}',
            submitted_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
        )
    """)
    cur.execute("CREATE INDEX IF NOT EXISTS idx_exam_results_user ON exam_results(user_id, submitted_at)")
    print("✅ Table 'exam_results' OK")

    # 5. ai_student_profiles (exam-service)
    cur.execute("""
        CREATE TABLE IF NOT EXISTS ai_student_profiles (
            id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
            user_id UUID UNIQUE NOT NULL,
            target_score SMALLINT NOT NULL DEFAULT 750,
            duration_days SMALLINT NOT NULL DEFAULT 30,
            active_roadmap JSONB,
            daily_lessons_cache JSONB,
            daily_quiz_results JSONB,
            completed_task_keys JSONB,
            created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
            updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
        )
    """)
    print("✅ Table 'ai_student_profiles' OK")

    conn.commit()
    print("\n=== SEED 15 ĐỀ THI VÀO EXAMS ===\n")

    now = datetime.now(timezone.utc)
    inserted_exams = 0
    for code, title, desc in EXAMS:
        cur.execute("SELECT code FROM exams WHERE code = %s", (code,))
        if cur.fetchone():
            print(f"  SKIP (exists): {code}")
            continue
        cur.execute(
            "INSERT INTO exams (id, code, title, description, duration_minutes, status, questions, created_at, updated_at) VALUES (%s,%s,%s,%s,%s,%s,%s::jsonb,%s,%s)",
            (str(uuid.uuid4()), code, title, desc, 120, 'PUBLISHED', '[]', now, now)
        )
        inserted_exams += 1
        print(f"  INSERT: {code}")
    conn.commit()
    print(f"Exams inserted: {inserted_exams}\n")

    print("=== IMPORT CÂU HỎI TỪ JSON FILES ===\n")
    json_files = sorted(glob.glob(os.path.join(EXAM_JSON_DIR, "*.json")))
    print(f"Found {len(json_files)} JSON files")
    total_q = 0

    for json_path in json_files:
        exam_code = os.path.splitext(os.path.basename(json_path))[0]
        cur.execute("SELECT COUNT(*) FROM questions WHERE exam_code = %s", (exam_code,))
        if cur.fetchone()[0] > 0:
            print(f"  SKIP {exam_code}: already has questions")
            continue

        with open(json_path, encoding='utf-8') as f:
            questions = json.load(f)

        rows = []
        for q in questions:
            passage = q.get('passage') or {}
            passage_audio = q.get('passage_audio', '') or (passage.get('audio_url', '') if isinstance(passage, dict) else '')
            passage_image = q.get('passage_image', '') or (passage.get('image_url', '') if isinstance(passage, dict) else '')
            rows.append((
                str(uuid.uuid4()),
                exam_code,
                q.get('question_number', 0),
                q.get('part', 1),
                q.get('section', 'listening'),
                q.get('question_text') or q.get('question_stem', ''),
                q.get('option_a', ''),
                q.get('option_b', ''),
                q.get('option_c', ''),
                q.get('option_d', ''),
                q.get('correct_answer', ''),
                q.get('explanation_vi', ''),
                q.get('explanation_en', ''),
                q.get('audio_url', ''),
                q.get('image_url', ''),
                q.get('passage_id'),
                q.get('passage_text', ''),
                passage_audio,
                passage_image,
                json.dumps(q.get('tu_vung')) if q.get('tu_vung') else None,
            ))

        psycopg2.extras.execute_values(
            cur,
            """INSERT INTO questions
               (id, exam_code, question_number, part, section, question_text,
                option_a, option_b, option_c, option_d, correct_answer,
                explanation_vi, explanation_en, audio_url, image_url,
                passage_id, passage_text, passage_audio, passage_image, tu_vung)
               VALUES %s ON CONFLICT DO NOTHING""",
            rows,
            template="(%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s::jsonb)"
        )
        conn.commit()
        total_q += len(rows)
        print(f"  ✅ {exam_code}: {len(rows)} questions imported")

    # Final count
    cur.execute("SELECT COUNT(*) FROM exams")
    n_exams = cur.fetchone()[0]
    cur.execute("SELECT COUNT(*) FROM questions")
    n_q = cur.fetchone()[0]
    cur.execute("SELECT COUNT(*) FROM users")
    n_users = cur.fetchone()[0]

    cur.close()
    conn.close()

    print(f"\n=== XONG ===")
    print(f"  exams:              {n_exams}")
    print(f"  questions:          {n_q}")
    print(f"  users:              {n_users}")
    print(f"  ai_student_profiles: tạo xong (trống)")
    print(f"  exam_results:       tạo xong (trống)")

if __name__ == "__main__":
    main()

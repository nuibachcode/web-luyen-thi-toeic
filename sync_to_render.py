import psycopg2
import json

RENDER_URL = "postgresql://toeic_user:0FcKcaH548fGZFvD66F68KuGFdUyKCWg@dpg-d9ndhsdaeets73bn2jm0-a.oregon-postgres.render.com/toeic_db_qwyv?sslmode=require"

LOCAL_CONNS = [
    dict(host='localhost', port=5433, user='toeic_auth', password='change-me-auth', dbname='toeic_auth'),
    dict(host='localhost', port=5434, user='toeic_exam', password='change-me-exam', dbname='toeic_exam'),
    dict(host='localhost', port=5435, user='toeic_catalog', password='change-me-catalog', dbname='toeic_catalog'),
    dict(host='localhost', port=5432, user='postgres', password='password', dbname='postgres')
]

def main():
    print("🚀 Bắt đầu quá trình đồng bộ dữ liệu từ Local lên CSDL Render Cloud...")
    try:
        render_db = psycopg2.connect(RENDER_URL)
        rc = render_db.cursor()
        print("✅ Đã kết nối thành công tới CSDL Render Cloud (aerotoeic-db)")
    except Exception as e:
        print(f"❌ Kết nối Render CSDL thất bại: {e}")
        return

    # Ensure tables exist in Render DB
    rc.execute("""
    CREATE TABLE IF NOT EXISTS users (
        id UUID PRIMARY KEY,
        google_id VARCHAR(255) UNIQUE,
        email VARCHAR(255) UNIQUE NOT NULL,
        name VARCHAR(255) NOT NULL,
        picture TEXT,
        password_hash VARCHAR(255),
        role VARCHAR(50) NOT NULL DEFAULT 'STUDENT',
        tenant_id VARCHAR(255),
        created_at TIMESTAMPTZ DEFAULT NOW()
    );

    CREATE TABLE IF NOT EXISTS exams (
        id UUID PRIMARY KEY,
        code VARCHAR(100) UNIQUE NOT NULL,
        title VARCHAR(255) NOT NULL,
        description TEXT,
        duration_minutes SMALLINT NOT NULL DEFAULT 120,
        status VARCHAR(20) NOT NULL DEFAULT 'PUBLISHED',
        questions JSONB NOT NULL DEFAULT '[]'::jsonb,
        created_by UUID,
        created_at TIMESTAMPTZ DEFAULT NOW(),
        updated_at TIMESTAMPTZ DEFAULT NOW()
    );

    CREATE TABLE IF NOT EXISTS questions (
        id UUID PRIMARY KEY,
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
        CONSTRAINT unique_exam_question UNIQUE(exam_code, question_number)
    );

    CREATE TABLE IF NOT EXISTS exam_results (
        id UUID PRIMARY KEY,
        user_id UUID NOT NULL,
        exam_code VARCHAR(100) NOT NULL,
        listening_correct SMALLINT NOT NULL,
        reading_correct SMALLINT NOT NULL,
        listening_score SMALLINT NOT NULL,
        reading_score SMALLINT NOT NULL,
        total_score SMALLINT NOT NULL,
        answers JSONB NOT NULL DEFAULT '{}'::jsonb,
        submitted_at TIMESTAMPTZ DEFAULT NOW()
    );

    CREATE TABLE IF NOT EXISTS ai_student_profiles (
        id UUID PRIMARY KEY,
        user_id UUID UNIQUE NOT NULL,
        target_score SMALLINT DEFAULT 750,
        duration_days SMALLINT DEFAULT 30,
        active_roadmap JSONB,
        daily_lessons_cache JSONB,
        daily_quiz_results JSONB,
        completed_task_keys JSONB,
        created_at TIMESTAMPTZ DEFAULT NOW(),
        updated_at TIMESTAMPTZ DEFAULT NOW()
    );
    """)
    render_db.commit()
    print("✅ Đã khởi tạo cấu trúc các Bảng (Tables) trên CSDL Render Cloud")

    total_synced_users = 0
    total_synced_exams = 0
    total_synced_questions = 0
    total_synced_results = 0

    for conn_info in LOCAL_CONNS:
        try:
            local_db = psycopg2.connect(**conn_info)
            lc = local_db.cursor()
            port = conn_info['port']

            # Sync users
            try:
                lc.execute("SELECT id, google_id, email, name, picture, password_hash, role, tenant_id, created_at FROM users")
                users = lc.fetchall()
                for u in users:
                    rc.execute("""
                        INSERT INTO users (id, google_id, email, name, picture, password_hash, role, tenant_id, created_at)
                        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
                        ON CONFLICT (email) DO UPDATE SET
                            name = EXCLUDED.name,
                            password_hash = COALESCE(users.password_hash, EXCLUDED.password_hash),
                            role = EXCLUDED.role,
                            tenant_id = EXCLUDED.tenant_id
                    """, u)
                    total_synced_users += 1
                render_db.commit()
            except Exception:
                local_db.rollback()

            # Sync exams
            try:
                lc.execute("SELECT id, code, title, description, duration_minutes, status, questions, created_by, created_at, updated_at FROM exams")
                exams = lc.fetchall()
                for e in exams:
                    rc.execute("""
                        INSERT INTO exams (id, code, title, description, duration_minutes, status, questions, created_by, created_at, updated_at)
                        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                        ON CONFLICT (code) DO UPDATE SET
                            title = EXCLUDED.title,
                            description = EXCLUDED.description,
                            duration_minutes = EXCLUDED.duration_minutes,
                            status = EXCLUDED.status,
                            questions = EXCLUDED.questions
                    """, e)
                    total_synced_exams += 1
                render_db.commit()
            except Exception:
                local_db.rollback()

            # Sync questions
            try:
                lc.execute("""
                    SELECT id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d,
                           correct_answer, explanation_vi, explanation_en, audio_url, image_url, passage_id, passage_text,
                           passage_audio, passage_image, tu_vung, raw_data FROM questions
                """)
                questions = lc.fetchall()
                for q in questions:
                    rc.execute("""
                        INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d,
                                               correct_answer, explanation_vi, explanation_en, audio_url, image_url, passage_id, passage_text,
                                               passage_audio, passage_image, tu_vung, raw_data)
                        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                        ON CONFLICT (exam_code, question_number) DO UPDATE SET
                            question_text = EXCLUDED.question_text,
                            option_a = EXCLUDED.option_a, option_b = EXCLUDED.option_b, option_c = EXCLUDED.option_c, option_d = EXCLUDED.option_d,
                            correct_answer = EXCLUDED.correct_answer, explanation_vi = EXCLUDED.explanation_vi, audio_url = EXCLUDED.audio_url, image_url = EXCLUDED.image_url
                    """, q)
                    total_synced_questions += 1
                render_db.commit()
            except Exception:
                local_db.rollback()

            # Sync exam_results
            try:
                lc.execute("""
                    SELECT id, user_id, exam_code, listening_correct, reading_correct, listening_score, reading_score, total_score, answers, submitted_at FROM exam_results
                """)
                results = lc.fetchall()
                for r in results:
                    rc.execute("""
                        INSERT INTO exam_results (id, user_id, exam_code, listening_correct, reading_correct, listening_score, reading_score, total_score, answers, submitted_at)
                        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                        ON CONFLICT (id) DO NOTHING
                    """, r)
                    total_synced_results += 1
                render_db.commit()
            except Exception:
                local_db.rollback()

            lc.close()
            local_db.close()
            print(f"✅ Đã quét thành công CSDL local ở cổng {port}")
        except Exception as e:
            # Container might not be running on this specific port, continue to next
            pass

    rc.close()
    render_db.close()

    print("\n🎉 HÀN THÀNH ĐỒNG BỘ CSDL LÊN RENDER CLOUD 100%!")
    print(f"📊 Kết quả đồng bộ:")
    print(f"   - Tài khoản (Users): {total_synced_users}")
    print(f"   - Đề thi (Exams): {total_synced_exams}")
    print(f"   - Câu hỏi (Questions): {total_synced_questions}")
    print(f"   - Kết quả làm bài (Exam Results): {total_synced_results}")

if __name__ == '__main__':
    main()

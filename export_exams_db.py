"""
Export all exams and questions from Render Cloud Database to SQL and JSON files.
"""
import psycopg2
import json

RENDER_URL = "postgresql://toeic_user:0FcKcaH548fGZFvD66F68KuGFdUyKCWg@dpg-d9ndhsdaeets73bn2jm0-a.oregon-postgres.render.com/toeic_db_qwyv?sslmode=require"

def main():
    print("🚀 Bắt đầu xuất toàn bộ CSDL Đề thi & Câu hỏi từ Render Cloud Database...")
    try:
        db = psycopg2.connect(RENDER_URL)
        cursor = db.cursor()
        print("✅ Đã kết nối CSDL Render Cloud thành công!")
    except Exception as e:
        print(f"❌ Kết nối CSDL thất bại: {e}")
        return

    # Fetch exams
    cursor.execute("SELECT id, code, title, description, duration_minutes, status, created_at, updated_at FROM exams ORDER BY created_at DESC")
    exams_rows = cursor.fetchall()

    # Fetch questions
    cursor.execute("""
        SELECT id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d,
               correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text, tu_vung
        FROM questions
        ORDER BY exam_code ASC, question_number ASC
    """)
    questions_rows = cursor.fetchall()

    print(f"📊 Tìm thấy {len(exams_rows)} đề thi và {len(questions_rows)} câu hỏi trong CSDL Cloud.")

    # 1. Export to SQL File
    sql_filename = "exported_exams.sql"
    with open(sql_filename, "w", encoding="utf-8") as f:
        f.write("-- EXPORTED TOEIC EXAMS & QUESTIONS DATABASE BACKUP --\n\n")
        f.write("CREATE TABLE IF NOT EXISTS exams (\n")
        f.write("    id UUID PRIMARY KEY,\n")
        f.write("    code VARCHAR(100) UNIQUE NOT NULL,\n")
        f.write("    title VARCHAR(255) NOT NULL,\n")
        f.write("    description TEXT,\n")
        f.write("    duration_minutes SMALLINT NOT NULL DEFAULT 120,\n")
        f.write("    status VARCHAR(20) NOT NULL DEFAULT 'PUBLISHED',\n")
        f.write("    questions JSONB NOT NULL DEFAULT '[]'::jsonb,\n")
        f.write("    created_at TIMESTAMPTZ DEFAULT NOW(),\n")
        f.write("    updated_at TIMESTAMPTZ DEFAULT NOW()\n")
        f.write(");\n\n")

        f.write("CREATE TABLE IF NOT EXISTS questions (\n")
        f.write("    id UUID PRIMARY KEY,\n")
        f.write("    exam_code VARCHAR(100) NOT NULL,\n")
        f.write("    question_number SMALLINT NOT NULL,\n")
        f.write("    part SMALLINT NOT NULL,\n")
        f.write("    section VARCHAR(20),\n")
        f.write("    question_text TEXT,\n")
        f.write("    option_a TEXT,\n")
        f.write("    option_b TEXT,\n")
        f.write("    option_c TEXT,\n")
        f.write("    option_d TEXT,\n")
        f.write("    correct_answer VARCHAR(1),\n")
        f.write("    explanation_vi TEXT,\n")
        f.write("    audio_url TEXT,\n")
        f.write("    image_url TEXT,\n")
        f.write("    passage_id VARCHAR(100),\n")
        f.write("    passage_text TEXT,\n")
        f.write("    tu_vung JSONB,\n")
        f.write("    CONSTRAINT unique_exam_question UNIQUE(exam_code, question_number)\n")
        f.write(");\n\n")

        f.write("-- EXAMS INSERTS --\n")
        for e in exams_rows:
            e_id, code, title, desc, dur, status, c_at, u_at = e
            desc_esc = (desc or '').replace("'", "''")
            title_esc = (title or '').replace("'", "''")
            f.write(f"INSERT INTO exams (id, code, title, description, duration_minutes, status) VALUES ('{e_id}', '{code}', '{title_esc}', '{desc_esc}', {dur}, '{status}') ON CONFLICT (code) DO NOTHING;\n")

        f.write("\n-- QUESTIONS INSERTS --\n")
        for q in questions_rows:
            q_id, ecode, qnum, part, sec, qtext, opta, optb, optc, optd, corr, expl, audio, img, pas_id, pas_text, vocab = q
            qtext_esc = (qtext or '').replace("'", "''")
            opta_esc = (opta or '').replace("'", "''")
            optb_esc = (optb or '').replace("'", "''")
            optc_esc = (optc or '').replace("'", "''")
            optd_esc = (optd or '').replace("'", "''")
            expl_esc = (expl or '').replace("'", "''")
            audio_esc = (audio or '').replace("'", "''")
            img_esc = (img or '').replace("'", "''")
            pas_id_esc = (pas_id or '').replace("'", "''")
            pas_text_esc = (pas_text or '').replace("'", "''")

            f.write(f"INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('{q_id}', '{ecode}', {qnum}, {part}, '{sec}', '{qtext_esc}', '{opta_esc}', '{optb_esc}', '{optc_esc}', '{optd_esc}', '{corr}', '{expl_esc}', '{audio_esc}', '{img_esc}', '{pas_id_esc}', '{pas_text_esc}') ON CONFLICT (exam_code, question_number) DO NOTHING;\n")

    print(f"✅ Đã xuất file SQL thành công: {sql_filename}")

    # 2. Export to JSON File
    json_filename = "exported_exams.json"
    export_data = {
        "exams": [
            {
                "id": str(e[0]), "code": e[1], "title": e[2],
                "description": e[3], "duration_minutes": e[4], "status": e[5]
            } for e in exams_rows
        ],
        "questions": [
            {
                "id": str(q[0]), "exam_code": q[1], "question_number": q[2],
                "part": q[3], "section": q[4], "question_text": q[5],
                "option_a": q[6], "option_b": q[7], "option_c": q[8], "option_d": q[9],
                "correct_answer": q[10], "explanation_vi": q[11],
                "audio_url": q[12], "image_url": q[13], "passage_id": q[14],
                "passage_text": q[15], "tu_vung": q[16]
            } for q in questions_rows
        ]
    }

    with open(json_filename, "w", encoding="utf-8") as f:
        json.dump(export_data, f, ensure_ascii=False, indent=2)

    print(f"✅ Đã xuất file JSON thành công: {json_filename}")
    cursor.close()
    db.close()
    print("\n🎉 XUẤT CSDL ĐỀ THI HOÀN TẤT 100%!")

if __name__ == '__main__':
    main()

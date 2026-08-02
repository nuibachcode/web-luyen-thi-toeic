"""
Import all question JSON files from crawler/downloaded_exams/ into Render PostgreSQL.
Maps JSON fields -> DB columns matching exam-service Prisma schema.
"""
import psycopg2
import psycopg2.extras
import json
import uuid
import os
import glob

RENDER_DB = "postgresql://toeic_user:0FcKcaH548fGZFvD66F68KuGFdUyKCWg@dpg-d9ndhsdaeets73bn2jm0-a.oregon-postgres.render.com/toeic_db_qwyv?sslmode=require"
EXAM_JSON_DIR = "crawler/downloaded_exams"

def main():
    conn = psycopg2.connect(RENDER_DB)
    conn.autocommit = False
    cur = conn.cursor()

    # Check schema of questions table
    cur.execute("""
        SELECT column_name, data_type FROM information_schema.columns
        WHERE table_name='questions' AND table_schema='public'
        ORDER BY ordinal_position
    """)
    cols = cur.fetchall()
    print("Questions table columns:")
    for c in cols:
        print(f"  {c[0]} ({c[1]})")
    print()

    json_files = sorted(glob.glob(os.path.join(EXAM_JSON_DIR, "*.json")))
    print(f"Found {len(json_files)} exam JSON files\n")

    total_inserted = 0

    for json_path in json_files:
        exam_code = os.path.splitext(os.path.basename(json_path))[0]

        # Skip if already has questions
        cur.execute("SELECT COUNT(*) FROM questions WHERE exam_code = %s", (exam_code,))
        existing = cur.fetchone()[0]
        if existing > 0:
            print(f"SKIP {exam_code}: already has {existing} questions")
            continue

        with open(json_path, encoding='utf-8') as f:
            questions = json.load(f)

        print(f"Importing {exam_code}: {len(questions)} questions...")

        rows = []
        for q in questions:
            rows.append((
                str(uuid.uuid4()),       # id
                exam_code,               # exam_code
                q.get('question_number', 0),  # question_number
                q.get('part', 1),        # part
                q.get('section', 'listening'),  # section
                q.get('question_text') or q.get('question_stem', ''),  # question_text
                q.get('option_a', ''),   # option_a
                q.get('option_b', ''),   # option_b
                q.get('option_c', ''),   # option_c
                q.get('option_d', ''),   # option_d
                q.get('correct_answer', ''),  # correct_answer
                q.get('explanation_vi', ''),  # explanation_vi
                q.get('explanation_en', ''),  # explanation_en
                q.get('audio_url', ''),  # audio_url
                q.get('image_url', ''),  # image_url
                q.get('passage_id'),     # passage_id
                q.get('passage_text', ''),    # passage_text
                q.get('passage_audio') or (q.get('passage', {}) or {}).get('audio_url', '') if isinstance(q.get('passage'), dict) else '',  # passage_audio
                q.get('passage_image') or (q.get('passage', {}) or {}).get('image_url', '') if isinstance(q.get('passage'), dict) else '',  # passage_image
                json.dumps(q.get('tu_vung')) if q.get('tu_vung') else None,  # tu_vung (JSONB)
            ))

        psycopg2.extras.execute_values(
            cur,
            """INSERT INTO questions 
               (id, exam_code, question_number, part, section, question_text,
                option_a, option_b, option_c, option_d, correct_answer,
                explanation_vi, explanation_en, audio_url, image_url,
                passage_id, passage_text, passage_audio, passage_image, tu_vung)
               VALUES %s
               ON CONFLICT DO NOTHING""",
            rows,
            template="""(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s::jsonb)"""
        )
        conn.commit()
        total_inserted += len(rows)
        print(f"  -> Inserted {len(rows)} questions for {exam_code}")

    cur.execute("SELECT COUNT(*) FROM questions")
    total_in_db = cur.fetchone()[0]
    cur.close()
    conn.close()
    print(f"\nDone! Inserted this run: {total_inserted}, Total in DB: {total_in_db}")

if __name__ == "__main__":
    main()

import psycopg2
import json

RENDER_URL = "postgresql://toeic_user:0FcKcaH548fGZFvD66F68KuGFdUyKCWg@dpg-d9ndhsdaeets73bn2jm0-a.oregon-postgres.render.com/toeic_db_qwyv?sslmode=require"

def main():
    print("🚀 Bắt đầu nạp toàn bộ Đề thi ETS Thật & Câu hỏi vào CSDL Render Cloud...")

    # Load JSON data from frontend/src/data/dautoeic_real_test.json
    try:
        with open('frontend/src/data/dautoeic_real_test.json', 'r', encoding='utf-8') as f:
            real_qs = json.load(f)
        print(f"📦 Đã đọc thành công {len(real_qs)} câu hỏi ETS từ dautoeic_real_test.json")
    except Exception as e:
        print(f"❌ Không mở được file dautoeic_real_test.json: {e}")
        return

    try:
        db = psycopg2.connect(RENDER_URL)
        cursor = db.cursor()
        print("✅ Đã kết nối thành công CSDL Render Cloud")
    except Exception as e:
        print(f"❌ Lỗi kết nối CSDL Render: {e}")
        return

    # 1. Ensure Exams exist in 'exams' table
    exams_list = [
        ('toeic-test-01', 'TOEIC ETS 2024 - Test 01 (Thực chiến)', 'Đề thi thử TOEIC ETS 2024 chuẩn cấu trúc 200 câu Listening & Reading', 120, 'PUBLISHED'),
        ('toeic-test-02', 'TOEIC ETS 2024 - Test 02 (Full ETS)', 'Đề luyện tập chuyên sâu Part 1-7 ETS 2024 kèm Audio và Lời giải', 120, 'PUBLISHED'),
        ('toeic-test-03', 'TOEIC ETS 2023 - Test 01 (Cập nhật)', 'Bộ đề thi ETS 2023 thực chiến đầy đủ đáp án & dịch nghĩa', 120, 'PUBLISHED'),
        ('ets-imported-test', 'TOEIC ETS 990+ Chuyên sâu', 'Bộ đề thi nâng cao bứt phá điểm số ETS', 120, 'PUBLISHED')
    ]

    for code, title, desc, dur, status in exams_list:
        cursor.execute("""
            INSERT INTO exams (id, code, title, description, duration_minutes, status, questions, created_at, updated_at)
            VALUES (gen_random_uuid(), %s, %s, %s, %s, %s, '[]'::jsonb, NOW(), NOW())
            ON CONFLICT (code) DO UPDATE SET
                title = EXCLUDED.title,
                description = EXCLUDED.description,
                status = EXCLUDED.status
        """, (code, title, desc, dur, status))

    db.commit()
    print("✅ Đã tạo danh sách Đề thi mẫu (Exams) trong bảng 'exams'")

    # 2. Insert questions for 'toeic-test-01' and 'ets-imported-test'
    target_codes = ['toeic-test-01', 'ets-imported-test']
    inserted_count = 0

    for exam_code in target_codes:
        for item in real_qs:
            q_num = item.get('question_number')
            if not q_num:
                continue
            
            p_num = item.get('part', 1)
            sec = item.get('section') or ('listening' if p_num <= 4 else 'reading')
            q_text = item.get('question_text') or ''
            opt_a = item.get('option_a') or ''
            opt_b = item.get('option_b') or ''
            opt_c = item.get('option_c') or ''
            opt_d = item.get('option_d') or ''
            corr = item.get('correct_answer') or 'A'
            expl = item.get('dich_nghia') or item.get('explanation_vi') or ''
            audio = item.get('audio_url') or ''
            img = item.get('image_url') or ''
            pas_id = item.get('passage_id') or ''
            pas_text = item.get('passage_text') or ''
            vocab = item.get('tu_vung') or ''
            vocab_json = json.dumps(vocab) if vocab else None

            cursor.execute("""
                INSERT INTO questions (
                    id, exam_code, question_number, part, section, question_text,
                    option_a, option_b, option_c, option_d, correct_answer,
                    explanation_vi, audio_url, image_url, passage_id, passage_text,
                    passage_audio, passage_image, tu_vung
                )
                VALUES (
                    gen_random_uuid(), %s, %s, %s, %s, %s,
                    %s, %s, %s, %s, %s,
                    %s, %s, %s, %s, %s,
                    %s, %s, %s
                )
                ON CONFLICT (exam_code, question_number) DO UPDATE SET
                    question_text = EXCLUDED.question_text,
                    option_a = EXCLUDED.option_a,
                    option_b = EXCLUDED.option_b,
                    option_c = EXCLUDED.option_c,
                    option_d = EXCLUDED.option_d,
                    correct_answer = EXCLUDED.correct_answer,
                    explanation_vi = EXCLUDED.explanation_vi,
                    audio_url = EXCLUDED.audio_url,
                    image_url = EXCLUDED.image_url,
                    passage_text = EXCLUDED.passage_text,
                    tu_vung = EXCLUDED.tu_vung
            """, (
                exam_code, q_num, p_num, sec, q_text,
                opt_a, opt_b, opt_c, opt_d, corr,
                expl, audio, img, pas_id, pas_text,
                audio, img, vocab_json
            ))
            inserted_count += 1

    db.commit()
    cursor.close()
    db.close()

    print(f"\n🎉 NẠP THÀNH CÔNG {inserted_count} CÂU HỎI VÀ ĐỀ BÀI LÊN RENDER CLOUD 100%!")

if __name__ == '__main__':
    main()

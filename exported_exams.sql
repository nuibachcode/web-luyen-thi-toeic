-- EXPORTED TOEIC EXAMS & QUESTIONS DATABASE BACKUP --

CREATE TABLE IF NOT EXISTS exams (
    id UUID PRIMARY KEY,
    code VARCHAR(100) UNIQUE NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    duration_minutes SMALLINT NOT NULL DEFAULT 120,
    status VARCHAR(20) NOT NULL DEFAULT 'PUBLISHED',
    questions JSONB NOT NULL DEFAULT '[]'::jsonb,
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
    audio_url TEXT,
    image_url TEXT,
    passage_id VARCHAR(100),
    passage_text TEXT,
    tu_vung JSONB,
    CONSTRAINT unique_exam_question UNIQUE(exam_code, question_number)
);

-- EXAMS INSERTS --
INSERT INTO exams (id, code, title, description, duration_minutes, status) VALUES ('df9eba58-db66-48c8-b4e4-09818af94985', 'toeic-test-01', 'TOEIC ETS 2024 - Test 01 (Thực chiến)', 'Đề thi thử TOEIC ETS 2024 chuẩn cấu trúc 200 câu Listening & Reading', 120, 'PUBLISHED') ON CONFLICT (code) DO NOTHING;
INSERT INTO exams (id, code, title, description, duration_minutes, status) VALUES ('94e5ef5a-5202-41fb-b0bf-f66b1b1df51d', 'toeic-test-02', 'TOEIC ETS 2024 - Test 02 (Full ETS)', 'Đề luyện tập chuyên sâu Part 1-7 ETS 2024 kèm Audio và Lời giải', 120, 'PUBLISHED') ON CONFLICT (code) DO NOTHING;
INSERT INTO exams (id, code, title, description, duration_minutes, status) VALUES ('f9ffb412-f1c2-4354-b1fc-2efeaf329426', 'toeic-test-03', 'TOEIC ETS 2023 - Test 01 (Cập nhật)', 'Bộ đề thi ETS 2023 thực chiến đầy đủ đáp án & dịch nghĩa', 120, 'PUBLISHED') ON CONFLICT (code) DO NOTHING;
INSERT INTO exams (id, code, title, description, duration_minutes, status) VALUES ('8815993a-3209-48f4-b64a-65eb35ffea9c', 'ets-imported-test', 'TOEIC ETS 990+ Chuyên sâu', 'Bộ đề thi nâng cao bứt phá điểm số ETS', 120, 'PUBLISHED') ON CONFLICT (code) DO NOTHING;

-- QUESTIONS INSERTS --
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('d329e1b8-3456-4efa-93c0-86ab30ca19db', 'ets-imported-test', 1, 1, 'listening', '', 'The woman is carrying a tray of food.', 'The woman is wearing a jacket.', 'The woman is tying up her hair.', 'The woman is removing her hat.', 'B', '(A) Người phụ nữ đang bê một khay thức ăn.

(B) Người phụ nữ đang mặc một chiếc áo khoác.

(C) Người phụ nữ đang buộc tóc.

(D) Người phụ nữ đang tháo mũ của mình.', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/1.mp3', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/1.webp', '', '(A) The woman is carrying a tray of food.
(B) The woman is wearing a jacket.
(C) The woman is tying up her hair.
(D) The woman is removing her hat.') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('3aa7eedc-18f1-4858-967a-1c5e2081318e', 'ets-imported-test', 2, 1, 'listening', '', 'Some people are standing next to a filing cabinet.', 'Some people are searching through a desk.', 'Some people are watching a presentation.', 'Some people are looking at a book.', 'D', '(A) Một vài người đang đứng cạnh tủ đựng hồ sơ.

(B) Một vài người đang tìm kiếm thứ gì đó trong bàn làm việc.

(C) Một vài người đang xem một bài thuyết trình.

(D) Một vài người đang nhìn vào một cuốn sách.', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/2.mp3', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/2.webp', '', '(A) Some people are standing next to a filing cabinet.
(B) Some people are searching through a desk.
(C) Some people are watching a presentation.
(D) Some people are looking at a book.') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('1072054f-3449-41b0-84d4-f3dbc725ac86', 'ets-imported-test', 3, 1, 'listening', '', 'A woman is holding a phone up to her ear.', 'A woman is pouring a beverage into a glass.', 'Some light fixtures are hanging from the ceiling.', 'Some tiles are being installed in a hallway.', 'C', '(A) Một người phụ nữ đang áp điện thoại lên tai.

(B) Một người phụ nữ đang rót đồ uống vào ly.

(C) Một số đèn trang trí đang treo trên trần nhà.

(D) Một số viên gạch lát đang được lắp đặt ở hành lang.', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/3.mp3', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/3.webp', '', '(A) A woman is holding a phone up to her ear.
(B) A woman is pouring a beverage into a glass.
(C) Some light fixtures are hanging from the ceiling.
(D) Some tiles are being installed in a hallway.') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('0700bbdd-4774-4896-8354-46c7816c75e5', 'ets-imported-test', 4, 1, 'listening', '', 'A wooden crate is filled with vegetables.', 'One of the men is putting vegetables into a shopping bag.', 'A backpack has been set on the ground.', 'One of the men is reaching into a bucket.', 'A', '(A) Một thùng gỗ chứa đầy rau củ.

(B) Một trong những người đàn ông đang cho rau vào túi mua hàng.

(C) Một chiếc ba lô đã được đặt trên mặt đất.

(D) Một trong những người đàn ông đang với tay vào một cái xô.', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/4.mp3', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/4.webp', '', '(A) A wooden crate is filled with vegetables.
(B) One of the men is putting vegetables into a shopping bag.
(C) A backpack has been set on the ground.
(D) One of the men is reaching into a bucket.') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('b9de0ca9-b613-4039-960e-064e9fc9d0e3', 'ets-imported-test', 5, 1, 'listening', '', 'Painting supplies have been laid out on the floor.', 'He''s laying a brush down on a windowsill.', 'He''s lifting a can of paint by its handle.', 'Cans of paint have been placed on a step stool.', 'A', '(A) Dụng cụ sơn đã được bày ra trên sàn.

(B) Anh ấy đang đặt một chiếc cọ xuống bậu cửa sổ.

(C) Anh ấy đang nhấc một lon sơn bằng tay cầm.

(D) Những lon sơn đã được đặt trên một chiếc ghế thang.', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/5.mp3', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/5.webp', '', '(A) Painting supplies have been laid out on the floor.
(B) He''s laying a brush down on a windowsill.
(C) He''s lifting a can of paint by its handle.
(D) Cans of paint have been placed on a step stool.') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('162bfb17-8d9d-449d-8829-d48cdfabaa86', 'ets-imported-test', 6, 1, 'listening', '', 'A path is covered with fallen branches.', 'A tree is lying across a grassy area.', 'Some water has pooled on a path.', 'Some cyclists are riding through a field.', 'C', '(A) Một con đường bị phủ đầy bởi những cành cây gãy.

(B) Một cái cây đang nằm chắn ngang khu vực thảm cỏ.

(C) Một ít nước đọng lại thành vũng trên đường.

(D) Một số người đi xe đạp đang đạp xe qua một cánh đồng.', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/6.mp3', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/6.webp', '', '(A) A path is covered with fallen branches.
(B) A tree is lying across a grassy area.
(C) Some water has pooled on a path.
(D) Some cyclists are riding through a field.') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('855f9d35-05ea-4daf-8d19-b46ad01325ce', 'ets-imported-test', 7, 2, 'listening', 'Where is the conference being held?', 'A three-day vacation.', 'At the Riverview Hotel.', 'In the supply cabinet.', '', 'B', 'Hội nghị được tổ chức ở đâu?

(A) Một kỳ nghỉ kéo dài ba ngày.

(B) Tại khách sạn Riverview.

(C) Trong tủ đựng đồ dùng.', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/7.mp3', '', '', 'Where is the conference being held?
(A) A three-day vacation.
(B) At the Riverview Hotel.
(C) In the supply cabinet.') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('4fa21c57-b08d-489d-a125-113ce77b6d3f', 'ets-imported-test', 8, 2, 'listening', 'When does the warehouse manager arrive?', 'Sure, no problem.', 'About twelve shipping boxes.', 'Not until this afternoon.', '', 'C', 'Quản lý kho hàng đến lúc mấy giờ?

(A) Chắc chắn rồi, không vấn đề gì.

(B) Khoảng mười hai thùng hàng.

(C) Phải đến tận chiều nay.', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/8.mp3', '', '', 'When does the warehouse manager arrive?
(A) Sure, no problem.
(B) About twelve shipping boxes.
(C) Not until this afternoon.') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('f17bf6c9-9d48-4bfa-b0a4-90bd2a3d8029', 'ets-imported-test', 9, 2, 'listening', 'There''s a nice park nearby, right?', 'Did you order paper for the copier?', 'Yes-it''s next to Greendale Lake.', 'They''re in the parking garage.', '', 'B', 'Gần đây có một công viên đẹp, đúng không?

(A) Bạn đã đặt giấy cho máy photocopy chưa?

(B) Có - nó nằm cạnh hồ Greendale.

(C) Chúng ở trong nhà để xe.', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/9.mp3', '', '', 'There''s a nice park nearby, right?
(A) Did you order paper for the copier?
(B) Yes-it''s next to Greendale Lake.
(C) They''re in the parking garage.') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('379a5c77-2f6a-4d51-8424-d065a61ca7d6', 'ets-imported-test', 10, 2, 'listening', 'Who sent the meeting minutes to the accounting department?', 'Our office assistant.', 'They have a savings account.', 'Cash and credit cards.', '', 'A', 'Ai đã gửi biên bản cuộc họp cho phòng kế toán?

(A) Trợ lý văn phòng của chúng tôi.

(B) Họ có một tài khoản tiết kiệm.

(C) Tiền mặt và thẻ tín dụng.', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/10.mp3', '', '', 'Who sent the meeting minutes to the accounting department?
(A) Our office assistant.
(B) They have a savings account.
(C) Cash and credit cards.') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('13395700-17d7-420f-8b7a-ce23adb04d9d', 'ets-imported-test', 11, 2, 'listening', 'I''d like to know what you think of our new finance analyst.', 'I''ve prepared the decorations for tomorrow.', 'He seems very competent.', 'It''s finally stopped raining.', '', 'B', 'Tôi muốn biết bạn nghĩ gì về chuyên viên phân tích tài chính mới của chúng ta.

(A) Tôi đã chuẩn bị đồ trang trí cho ngày mai.

(B) Anh ấy có vẻ rất có năng lực.

(C) Cuối cùng thì trời cũng đã tạnh mưa.', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/11.mp3', '', '', 'I''d like to know what you think of our new finance analyst.
(A) I''ve prepared the decorations for tomorrow.
(B) He seems very competent.
(C) It''s finally stopped raining.') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('539e3ad9-41d4-4268-9405-06a4daf2b7d0', 'ets-imported-test', 12, 2, 'listening', 'Let''s go on the company retreat.', 'Oh, did he?', 'Yes, that''s a good idea.', 'He tried to solve that problem.', '', 'B', 'Chúng ta đi chuyến nghỉ dưỡng của công ty đi.

(A) Ồ, anh ấy đã làm vậy sao?

(B) Vâng, đó là một ý kiến hay.

(C) Anh ấy đã cố gắng giải quyết vấn đề đó.', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/12.mp3', '', '', 'Let''s go on the company retreat.
(A) Oh, did he?
(B) Yes, that''s a good idea.
(C) He tried to solve that problem.') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('6027cb4c-a1ec-4f3b-ab34-e17b2a9d97fa', 'ets-imported-test', 13, 2, 'listening', 'What time can I pick up my glasses?', 'No, it''s not very heavy.', 'About twenty meters.', 'We close at six o''clock.', '', 'C', 'Mấy giờ tôi có thể đến lấy kính?

(A) Không, nó không nặng lắm.

(B) Khoảng hai mươi mét.

(C) Chúng tôi đóng cửa lúc sáu giờ.', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/13.mp3', '', '', 'What time can I pick up my glasses?
(A) No, it''s not very heavy.
(B) About twenty meters.
(C) We close at six o''clock.') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('42fa3298-e55d-44ef-90c8-242a45947180', 'ets-imported-test', 14, 2, 'listening', 'The sales team knows how to use the tracking software, don''t they?', 'It''s on the lower shelf.', 'A twelve-thirty departure.', 'I haven''t seen them using it yet.', '', 'C', 'Đội bán hàng biết cách sử dụng phần mềm theo dõi, đúng không?

(A) Nó ở trên kệ dưới.

(B) Chuyến khởi hành lúc mười hai giờ ba mươi.

(C) Tôi vẫn chưa thấy họ sử dụng nó.', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/14.mp3', '', '', 'The sales team knows how to use the tracking software, don''t they?
(A) It''s on the lower shelf.
(B) A twelve-thirty departure.
(C) I haven''t seen them using it yet.') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('5becfe9d-14b6-406a-957b-3dff86e65201', 'ets-imported-test', 15, 2, 'listening', 'Are you going to the hardware store on Mill Street?', 'That store hasn''t opened yet.', 'The blue package you sent me.', 'Some nails and a hammer.', '', 'A', 'Bạn có định đến cửa hàng ngũ kim trên đường Mill không?

(A) Cửa hàng đó vẫn chưa mở cửa.

(B) Gói hàng màu xanh mà bạn đã gửi cho tôi.

(C) Một vài chiếc đinh và một cây búa.', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/15.mp3', '', '', 'Are you going to the hardware store on Mill Street?
(A) That store hasn''t opened yet.
(B) The blue package you sent me.
(C) Some nails and a hammer.') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('de196eb1-ae94-4ae4-928c-d979991a4a26', 'ets-imported-test', 16, 2, 'listening', 'Would you be able to write the introduction for the workshop?', 'That was a great book.', 'OK, I''d be happy to.', 'He doesn''t have any more.', '', 'B', 'Bạn có thể viết phần giới thiệu cho buổi hội thảo không?

(A) Đó là một cuốn sách tuyệt vời.

(B) Được chứ, tôi rất sẵn lòng.

(C) Anh ấy không còn cái nào nữa.', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/16.mp3', '', '', 'Would you be able to write the introduction for the workshop?
(A) That was a great book.
(B) OK, I''d be happy to.
(C) He doesn''t have any more.') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('8e563bb2-5cee-48d7-aa2c-64488a685243', 'ets-imported-test', 17, 2, 'listening', 'I picked up some flowers for Tunji''s retirement party.', 'No, pick any day.', 'That was thoughtful.', 'A delivery driver.', '', 'B', 'Tôi đã mua một ít hoa cho bữa tiệc nghỉ hưu của Tunji.

(A) Không, hãy chọn bất kỳ ngày nào.

(B) Thật là chu đáo.

(C) Một nhân viên giao hàng.', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/17.mp3', '', '', 'I picked up some flowers for Tunji''s retirement party.
(A) No, pick any day.
(B) That was thoughtful.
(C) A delivery driver.') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('383c9042-8e3b-4479-9ee0-e3ca8ba986cd', 'ets-imported-test', 18, 2, 'listening', 'Which meeting room did you tell the interns to go to?', 'The Jefferson Room.', 'The meeting was fun, thanks.', 'Yes, it''s a conference call.', '', 'A', 'Bạn đã bảo các thực tập sinh đến phòng họp nào?

(A) Phòng Jefferson.

(B) Cuộc họp rất vui, cảm ơn.

(C) Vâng, đó là một cuộc gọi hội nghị.', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/18.mp3', '', '', 'Which meeting room did you tell the interns to go to?
(A) The Jefferson Room.
(B) The meeting was fun, thanks.
(C) Yes, it''s a conference call.') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('6513507c-6268-4780-83ae-a1e1c4345469', 'ets-imported-test', 19, 2, 'listening', 'Is your dental appointment next Tuesday?', 'You can borrow mine.', 'I''ll have to check my calendar.', 'Yes, it was a good meeting.', '', 'B', 'Lịch hẹn nha sĩ của bạn vào thứ Ba tới phải không?

(A) Bạn có thể mượn cái của tôi.

(B) Tôi sẽ phải kiểm tra lịch của mình.

(C) Vâng, đó là một cuộc họp tốt.', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/19.mp3', '', '', 'Is your dental appointment next Tuesday?
(A) You can borrow mine.
(B) I''ll have to check my calendar.
(C) Yes, it was a good meeting.') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('39e11608-3515-4e1f-9606-5dd2ae294d16', 'ets-imported-test', 20, 2, 'listening', 'Why aren''t there any brochures in the lobby?', 'No, I haven''t received my confirmation e-mail yet.', 'My winter coat.', 'Because someone just took the last one.', '', 'C', 'Tại sao không có tờ rơi quảng cáo nào ở sảnh chờ?

(A) Không, tôi vẫn chưa nhận được email xác nhận.

(B) Áo khoác mùa đông của tôi.

(C) Bởi vì ai đó vừa mới lấy cái cuối cùng rồi.', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/20.mp3', '', '', 'Why aren''t there any brochures in the lobby?
(A) No, I haven''t received my confirmation e-mail yet.
(B) My winter coat.
(C) Because someone just took the last one.') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('23faf1be-68c7-446b-bf43-8a8b9d61915a', 'ets-imported-test', 21, 2, 'listening', 'What''s the process for submitting my expense report?', 'You send it to the finance department.', 'The end of the day.', 'That''s correct.', '', 'A', 'Quy trình nộp báo cáo chi phí của tôi là gì?

(A) Bạn gửi nó cho bộ phận tài chính.

(B) Cuối ngày.

(C) Điều đó đúng.', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/21.mp3', '', '', 'What''s the process for submitting my expense report?
(A) You send it to the finance department.
(B) The end of the day.
(C) That''s correct.') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('a533eafe-93ec-46f7-8e7e-7e8d4f52cf91', 'ets-imported-test', 22, 2, 'listening', 'Do you sell your products online or in stores?', 'About twenty percent off.', 'A product demonstration.', 'Only online.', '', 'C', 'Bạn bán sản phẩm trực tuyến hay tại cửa hàng?

(A) Giảm giá khoảng hai mươi phần trăm.

(B) Một buổi trình diễn sản phẩm.

(C) Chỉ trực tuyến thôi.', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/22.mp3', '', '', 'Do you sell your products online or in stores?
(A) About twenty percent off.
(B) A product demonstration.
(C) Only online.') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('18e32bb2-d93f-4179-a564-a9dc57590317', 'ets-imported-test', 23, 2, 'listening', 'How often do you charge this device?', 'Whenever the light turns red.', 'A wireless one.', 'At the hardware store.', '', 'A', 'Bạn sạc thiết bị này thường xuyên như thế nào?

(A) Bất cứ khi nào đèn chuyển sang màu đỏ.

(B) Một cái không dây.

(C) Tại cửa hàng ngũ kim.', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/23.mp3', '', '', 'How often do you charge this device?
(A) Whenever the light turns red.
(B) A wireless one.
(C) At the hardware store.') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('7c207fa0-ee4f-4843-8a0c-06cae1755f90', 'ets-imported-test', 24, 2, 'listening', 'The tickets to Friday night''s concert cost ten dollars each.', 'Actually, they''re fifteen.', 'No, I can''t play the guitar.', 'It''s in aisle five.', '', 'A', 'Vé xem buổi hòa nhạc tối thứ Sáu giá mười đô la mỗi vé.

(A) Thực ra, chúng có giá mười lăm đô la.

(B) Không, tôi không biết chơi ghi-ta.

(C) Nó ở lối đi số năm.', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/24.mp3', '', '', 'The tickets to Friday night''s concert cost ten dollars each.
(A) Actually, they''re fifteen.
(B) No, I can''t play the guitar.
(C) It''s in aisle five.') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('a9ae0a0d-ad83-4f62-91ac-bc1837a82e9c', 'ets-imported-test', 25, 2, 'listening', 'Can''t you update the database today?', 'I did it yesterday.', 'That''s an interesting movie.', 'No, just me.', '', 'A', 'Bạn không thể cập nhật cơ sở dữ liệu hôm nay sao?

(A) Tôi đã làm nó vào ngày hôm qua rồi.

(B) Đó là một bộ phim thú vị.

(C) Không, chỉ mình tôi thôi.', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/25.mp3', '', '', 'Can''t you update the database today?
(A) I did it yesterday.
(B) That''s an interesting movie.
(C) No, just me.') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('03f38aa0-4594-419f-be14-8f87a402d2de', 'ets-imported-test', 26, 2, 'listening', 'How are we going to fit the extra supplies in that closet?', 'I''ve already read them.', 'Natalie''s in charge of supplies.', 'It''s the door at the end of the hallway.', '', 'B', 'Làm sao chúng ta nhét thêm đồ dùng vào tủ đó được?

(A) Tôi đã đọc chúng rồi.

(B) Natalie chịu trách nhiệm về vật tư.

(C) Đó là cánh cửa ở cuối hành lang.', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/26.mp3', '', '', 'How are we going to fit the extra supplies in that closet?
(A) I''ve already read them.
(B) Natalie''s in charge of supplies.
(C) It''s the door at the end of the hallway.') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('24b8f901-f879-44fb-a9eb-5bc687c2517b', 'ets-imported-test', 27, 2, 'listening', 'Have all the new windows been installed?', 'Sure, I''ll close the blinds.', 'The construction crew is almost finished.', 'This isn''t the tallest ladder available.', '', 'B', 'Tất cả các cửa sổ mới đã được lắp đặt chưa?

(A) Chắc chắn rồi, tôi sẽ đóng rèm lại.

(B) Đội xây dựng gần như đã hoàn thành xong.

(C) Đây không phải là chiếc thang cao nhất hiện có.', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/27.mp3', '', '', 'Have all the new windows been installed?
(A) Sure, I''ll close the blinds.
(B) The construction crew is almost finished.
(C) This isn''t the tallest ladder available.') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('72096484-afbf-4706-a3c3-fa3b6885d472', 'ets-imported-test', 28, 2, 'listening', 'Would you rather go to lunch now or at noon?', 'I''m taking a client to lunch.', 'On the corner of Fourth and Main.', 'The daily special is soup and a sandwich.', '', 'A', 'Bạn muốn đi ăn trưa bây giờ hay lúc giữa trưa?

(A) Tôi đang đưa một khách hàng đi ăn trưa.

(B) Ở góc đường số 4 và đường Main.

(C) Món đặc biệt hàng ngày là súp và bánh mì kẹp.', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/28.mp3', '', '', 'Would you rather go to lunch now or at noon?
(A) I''m taking a client to lunch.
(B) On the corner of Fourth and Main.
(C) The daily special is soup and a sandwich.') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('a90acd16-e77e-4129-8c61-fae665ac3192', 'ets-imported-test', 29, 2, 'listening', 'You''re taking the training in the afternoon, aren''t you?', 'The new head of the accounting department.', 'No, I take my coffee black.', 'Well, it depends on my schedule.', '', 'C', 'Bạn sẽ tham gia buổi đào tạo vào buổi chiều, đúng không?

(A) Trưởng phòng kế toán mới.

(B) Không, tôi uống cà phê đen.

(C) À, nó còn tùy thuộc vào lịch trình của tôi.', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/29.mp3', '', '', 'You''re taking the training in the afternoon, aren''t you?
(A) The new head of the accounting department.
(B) No, I take my coffee black.
(C) Well, it depends on my schedule.') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('21e14e5a-1f61-4e14-bc78-17db6ed89315', 'ets-imported-test', 30, 2, 'listening', 'Shouldn''t Ms. Ishida look over the financial projections?', 'I just got this monitor.', 'To the south entrance.', 'I''m meeting with her at ten.', '', 'C', 'Cô Ishida có nên xem qua các dự báo tài chính không?

(A) Tôi vừa mới nhận được cái màn hình này.

(B) Đến lối vào phía Nam.

(C) Tôi sẽ gặp cô ấy lúc mười giờ.', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/30.mp3', '', '', 'Shouldn''t Ms. Ishida look over the financial projections?
(A) I just got this monitor.
(B) To the south entrance.
(C) I''m meeting with her at ten.') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('103d9c0a-d352-4409-b50a-a287fc6ae79e', 'ets-imported-test', 31, 2, 'listening', 'When are you going to choose a new project manager?', 'The projector''s not working correctly.', 'Next to the front entrance.', 'I''m really busy this week.', '', 'C', 'Khi nào bạn sẽ chọn một quản lý dự án mới?

(A) Máy chiếu đang hoạt động không đúng cách.

(B) Cạnh lối vào phía trước.

(C) Tuần này tôi thực sự rất bận.', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/31.mp3', '', '', 'When are you going to choose a new project manager?
(A) The projector''s not working correctly.
(B) Next to the front entrance.
(C) I''m really busy this week.') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('e22ddea6-f154-43bd-96e2-0fbd9ed2d51c', 'ets-imported-test', 32, 3, 'listening', 'What type of food product does the speakers’ company sell?', 'Candy', 'Cheese', 'Bread', 'Pasta', 'B', 'W: Này Oliver. Anh đã xem kết quả thảo luận nhóm tập trung (focus group) cho loại phô mai cheddar cay mới của chúng ta chưa? Mọi người thực sự rất thích nó.

M: Rồi. Nó sẽ là một sự bổ sung tuyệt vời cho dòng phô mai của công ty chúng ta.

W: Một vài người đã đề cập rằng họ muốn sử dụng nó trong các công thức nấu ăn—chẳng hạn như thêm vào các loại nước sốt.

M: Vậy có lẽ chúng ta nên cân nhắc việc bán phiên bản phô mai bào để nó dễ tan chảy hơn khi nấu nướng.

W: Tôi chắc chắn chúng ta có thể làm được việc đó. Tôi sẽ liên lạc với quản lý sản xuất để đưa ra yêu cầu này.', '', '', '0573fe39-710f-41f2-8491-afe9de68bd3a', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('1fbe94b3-14af-4451-a445-3847b466f98b', 'ets-imported-test', 33, 3, 'listening', 'What does the man suggest?', 'Lowering prices', 'Hiring more workers', 'Publishing a recipe', 'Offering additional options', 'D', 'W: Này Oliver. Anh đã xem kết quả thảo luận nhóm tập trung (focus group) cho loại phô mai cheddar cay mới của chúng ta chưa? Mọi người thực sự rất thích nó.

M: Rồi. Nó sẽ là một sự bổ sung tuyệt vời cho dòng phô mai của công ty chúng ta.

W: Một vài người đã đề cập rằng họ muốn sử dụng nó trong các công thức nấu ăn—chẳng hạn như thêm vào các loại nước sốt.

M: Vậy có lẽ chúng ta nên cân nhắc việc bán phiên bản phô mai bào để nó dễ tan chảy hơn khi nấu nướng.

W: Tôi chắc chắn chúng ta có thể làm được việc đó. Tôi sẽ liên lạc với quản lý sản xuất để đưa ra yêu cầu này.', '', '', '0573fe39-710f-41f2-8491-afe9de68bd3a', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('0248a669-c524-4300-bc88-381d7b68750d', 'ets-imported-test', 34, 3, 'listening', 'What does the woman say she will do?', 'Send a schedule update', 'Contact a production manager', 'Visit the company headquarters', 'Plan an advertising campaign', 'B', 'W: Này Oliver. Anh đã xem kết quả thảo luận nhóm tập trung (focus group) cho loại phô mai cheddar cay mới của chúng ta chưa? Mọi người thực sự rất thích nó.

M: Rồi. Nó sẽ là một sự bổ sung tuyệt vời cho dòng phô mai của công ty chúng ta.

W: Một vài người đã đề cập rằng họ muốn sử dụng nó trong các công thức nấu ăn—chẳng hạn như thêm vào các loại nước sốt.

M: Vậy có lẽ chúng ta nên cân nhắc việc bán phiên bản phô mai bào để nó dễ tan chảy hơn khi nấu nướng.

W: Tôi chắc chắn chúng ta có thể làm được việc đó. Tôi sẽ liên lạc với quản lý sản xuất để đưa ra yêu cầu này.', '', '', '0573fe39-710f-41f2-8491-afe9de68bd3a', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('c7b06e02-bfcb-4104-a2f2-303694437104', 'ets-imported-test', 35, 3, 'listening', 'Why is the man calling?', 'To sign up for lessons', 'To enter a competition', 'To buy tickets to an event', 'To ask about branded merchandise', 'C', 'M: Xin chào. Tôi gọi điện để đặt ba vé cho trận đấu quần vợt vào thứ Năm tuần này. Còn ghế trống nào không?

W: Chỉ còn vài ghế thôi! Vé cho trận đấu thứ Năm đang được bán rất nhanh.

M: Tôi không ngạc nhiên đâu! Suy cho cùng, Ife Rotimi đã giành chức vô địch khu vực vào tháng trước mà. Mọi người đều muốn xem cô ấy thi đấu sau màn trình diễn đáng kinh ngạc đó. Còn những chỗ ngồi nào trống?

W: Chà, chỉ còn duy nhất một nhóm ba ghế cạnh nhau. Yêu cầu phải thanh toán trước để giữ chỗ.', '', '', '9bd22317-304d-48bf-aa10-7f565ea00eb5', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('ee8c31a3-55d2-4b9a-af5b-63a2862dc700', 'ets-imported-test', 36, 3, 'listening', 'What did Ife Rotimi do last month?', 'She won a regional tournament.', 'She gave a television interview.', 'She started an institute.', 'She hired a new coach.', 'A', 'M: Xin chào. Tôi gọi điện để đặt ba vé cho trận đấu quần vợt vào thứ Năm tuần này. Còn ghế trống nào không?

W: Chỉ còn vài ghế thôi! Vé cho trận đấu thứ Năm đang được bán rất nhanh.

M: Tôi không ngạc nhiên đâu! Suy cho cùng, Ife Rotimi đã giành chức vô địch khu vực vào tháng trước mà. Mọi người đều muốn xem cô ấy thi đấu sau màn trình diễn đáng kinh ngạc đó. Còn những chỗ ngồi nào trống?

W: Chà, chỉ còn duy nhất một nhóm ba ghế cạnh nhau. Yêu cầu phải thanh toán trước để giữ chỗ.', '', '', '9bd22317-304d-48bf-aa10-7f565ea00eb5', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('2ae01223-ff93-406b-a6e0-085a1a32da3a', 'ets-imported-test', 37, 3, 'listening', 'What does the woman say is required?', 'A parking permit', 'A photo ID', 'Contact information', 'Advance payment', 'D', 'M: Xin chào. Tôi gọi điện để đặt ba vé cho trận đấu quần vợt vào thứ Năm tuần này. Còn ghế trống nào không?

W: Chỉ còn vài ghế thôi! Vé cho trận đấu thứ Năm đang được bán rất nhanh.

M: Tôi không ngạc nhiên đâu! Suy cho cùng, Ife Rotimi đã giành chức vô địch khu vực vào tháng trước mà. Mọi người đều muốn xem cô ấy thi đấu sau màn trình diễn đáng kinh ngạc đó. Còn những chỗ ngồi nào trống?

W: Chà, chỉ còn duy nhất một nhóm ba ghế cạnh nhau. Yêu cầu phải thanh toán trước để giữ chỗ.', '', '', '9bd22317-304d-48bf-aa10-7f565ea00eb5', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('28b68bf7-35a6-4629-ad70-d07c7b21fdc0', 'ets-imported-test', 38, 3, 'listening', 'What event are the speakers planning?', 'A fund-raising dinner', 'An art gallery opening', 'An awards ceremony', 'A children’s book fair', 'A', 'W: Cảm ơn anh đã đồng ý giúp tôi tổ chức bữa tối gây quỹ thường niên của thư viện, Klaus. Chúng tôi hy vọng sự kiện này sẽ mang lại đủ tiền để mở rộng khu vực sách dành cho trẻ em.

M: Cô muốn tôi bắt đầu với nhiệm vụ nào?

W: Chà, tôi cần một chút trợ giúp để gửi các thư mời.

M: Được thôi, tôi có thể đảm nhận việc đó. Có sẵn danh sách những người tham dự không?

W: Nó nằm trong các tệp máy tính của tôi. Tôi sẽ gửi email cho anh.', '', '', '0d04c823-8b01-4da9-8151-282fa769137a', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('c33dcf05-8723-4359-b624-426537172371', 'ets-imported-test', 39, 3, 'listening', 'What task does the woman ask the man to help with?', 'Arranging a shuttle service', 'Choosing a catering firm', 'Preparing a speech', 'Sending out invitations', 'D', 'W: Cảm ơn anh đã đồng ý giúp tôi tổ chức bữa tối gây quỹ thường niên của thư viện, Klaus. Chúng tôi hy vọng sự kiện này sẽ mang lại đủ tiền để mở rộng khu vực sách dành cho trẻ em.

M: Cô muốn tôi bắt đầu với nhiệm vụ nào?

W: Chà, tôi cần một chút trợ giúp để gửi các thư mời.

M: Được thôi, tôi có thể đảm nhận việc đó. Có sẵn danh sách những người tham dự không?

W: Nó nằm trong các tệp máy tính của tôi. Tôi sẽ gửi email cho anh.', '', '', '0d04c823-8b01-4da9-8151-282fa769137a', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('4cf1ecb0-753f-410b-af6e-5bcc6571cd61', 'ets-imported-test', 40, 3, 'listening', 'What does the woman say she will do?', 'E-mail a list', 'Speak with a colleague', 'Provide a password', 'Post a job opening', 'A', 'W: Cảm ơn anh đã đồng ý giúp tôi tổ chức bữa tối gây quỹ thường niên của thư viện, Klaus. Chúng tôi hy vọng sự kiện này sẽ mang lại đủ tiền để mở rộng khu vực sách dành cho trẻ em.

M: Cô muốn tôi bắt đầu với nhiệm vụ nào?

W: Chà, tôi cần một chút trợ giúp để gửi các thư mời.

M: Được thôi, tôi có thể đảm nhận việc đó. Có sẵn danh sách những người tham dự không?

W: Nó nằm trong các tệp máy tính của tôi. Tôi sẽ gửi email cho anh.', '', '', '0d04c823-8b01-4da9-8151-282fa769137a', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('964a34b2-6281-4f87-8eb0-651b2894fea2', 'ets-imported-test', 41, 3, 'listening', 'What event are the speakers preparing for?', 'A new-employee orientation', 'A grand opening', 'A community festival', 'A trade show', 'C', 'W: Này Brian và Matteo. Tôi đã tìm thấy một số loại bút rất tuyệt để tặng tại lễ hội cộng đồng nhằm quảng bá doanh nghiệp của chúng ta.

M1: Tuyệt quá. Chúng ta có thể in logo dịch vụ vệ sinh của mình lên đó không?

W: Có chứ, không mất thêm phí đâu. Và chúng còn có thể phân hủy sinh học nữa. Chúng được làm từ giấy.

M2: Vậy khi chúng ta phát chúng, chúng ta có thể đề cập đến điều đó.

M1: Cũng như nói về các vật dụng vệ sinh hữu cơ mà công ty chúng ta sử dụng.

W: Được rồi. Tôi sẽ tiến hành đặt mua vài thùng.', '', '', '8289f3e5-3556-49f1-9682-ec69643be8e5', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('201d3dda-b3db-4746-b965-53682ee748ea', 'ets-imported-test', 42, 3, 'listening', 'What is mentioned about some pens?', 'They are available in multiple colors.', 'They use permanent ink.', 'They are preferred by book authors.', 'They are made from paper.', 'D', 'W: Này Brian và Matteo. Tôi đã tìm thấy một số loại bút rất tuyệt để tặng tại lễ hội cộng đồng nhằm quảng bá doanh nghiệp của chúng ta.

M1: Tuyệt quá. Chúng ta có thể in logo dịch vụ vệ sinh của mình lên đó không?

W: Có chứ, không mất thêm phí đâu. Và chúng còn có thể phân hủy sinh học nữa. Chúng được làm từ giấy.

M2: Vậy khi chúng ta phát chúng, chúng ta có thể đề cập đến điều đó.

M1: Cũng như nói về các vật dụng vệ sinh hữu cơ mà công ty chúng ta sử dụng.

W: Được rồi. Tôi sẽ tiến hành đặt mua vài thùng.', '', '', '8289f3e5-3556-49f1-9682-ec69643be8e5', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('c1d74aea-8a3c-465e-8c03-120c9983340d', 'ets-imported-test', 43, 3, 'listening', 'What does the woman offer to do?', 'Reserve a booth', 'Place an order', 'Organize a focus group', 'Revise a budget', 'B', 'W: Này Brian và Matteo. Tôi đã tìm thấy một số loại bút rất tuyệt để tặng tại lễ hội cộng đồng nhằm quảng bá doanh nghiệp của chúng ta.

M1: Tuyệt quá. Chúng ta có thể in logo dịch vụ vệ sinh của mình lên đó không?

W: Có chứ, không mất thêm phí đâu. Và chúng còn có thể phân hủy sinh học nữa. Chúng được làm từ giấy.

M2: Vậy khi chúng ta phát chúng, chúng ta có thể đề cập đến điều đó.

M1: Cũng như nói về các vật dụng vệ sinh hữu cơ mà công ty chúng ta sử dụng.

W: Được rồi. Tôi sẽ tiến hành đặt mua vài thùng.', '', '', '8289f3e5-3556-49f1-9682-ec69643be8e5', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('99ec55a2-0be2-42ac-b1e9-0f7640423b7f', 'ets-imported-test', 44, 3, 'listening', 'Where does the woman work?', 'At a delivery service', 'At an electronics store', 'At a recycling facility', 'At a real estate agency', 'C', 'W: Cơ sở tái chế Jamestown xin nghe. Tôi có thể giúp gì cho ông?

M: Chào cô. Tôi đang chuẩn bị chuyển nhà sớm, và tôi có một số đồ điện tử như tivi và máy tính mà tôi muốn bỏ đi trước khi rao bán nhà. Bạn tôi có nói rằng các cô có thể nhận chúng.

W: Vâng, đúng vậy. Chúng tôi nhận tất cả đồ điện tử.

M: Tuyệt. Tôi chỉ có một câu hỏi. Các cô có cung cấp dịch vụ đến lấy hàng tận nơi không?

W: Không, thật không may là ông sẽ phải tự mình mang mọi thứ đến đây. Tuy nhiên, trên trang web của chúng tôi có liệt kê một số công ty có thể tháo dỡ và xử lý các vật dụng đó cho ông.', '', '', '3960e378-e3ea-4c5c-b832-1ca1fb9df88a', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('318c328b-e4a8-431b-a13f-a7d08a38d94a', 'ets-imported-test', 45, 3, 'listening', 'What does the man want to dispose of?', 'Yard waste', 'Used furniture', 'Electronics', 'Books', 'C', 'W: Cơ sở tái chế Jamestown xin nghe. Tôi có thể giúp gì cho ông?

M: Chào cô. Tôi đang chuẩn bị chuyển nhà sớm, và tôi có một số đồ điện tử như tivi và máy tính mà tôi muốn bỏ đi trước khi rao bán nhà. Bạn tôi có nói rằng các cô có thể nhận chúng.

W: Vâng, đúng vậy. Chúng tôi nhận tất cả đồ điện tử.

M: Tuyệt. Tôi chỉ có một câu hỏi. Các cô có cung cấp dịch vụ đến lấy hàng tận nơi không?

W: Không, thật không may là ông sẽ phải tự mình mang mọi thứ đến đây. Tuy nhiên, trên trang web của chúng tôi có liệt kê một số công ty có thể tháo dỡ và xử lý các vật dụng đó cho ông.', '', '', '3960e378-e3ea-4c5c-b832-1ca1fb9df88a', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('333e62b7-26e8-48f6-b177-b310c3fc8352', 'ets-imported-test', 46, 3, 'listening', 'What does the woman say can be found on a Web site?', 'A list of companies', 'Hours of operation', 'A permit application', 'Directions to a site', 'A', 'W: Cơ sở tái chế Jamestown xin nghe. Tôi có thể giúp gì cho ông?

M: Chào cô. Tôi đang chuẩn bị chuyển nhà sớm, và tôi có một số đồ điện tử như tivi và máy tính mà tôi muốn bỏ đi trước khi rao bán nhà. Bạn tôi có nói rằng các cô có thể nhận chúng.

W: Vâng, đúng vậy. Chúng tôi nhận tất cả đồ điện tử.

M: Tuyệt. Tôi chỉ có một câu hỏi. Các cô có cung cấp dịch vụ đến lấy hàng tận nơi không?

W: Không, thật không may là ông sẽ phải tự mình mang mọi thứ đến đây. Tuy nhiên, trên trang web của chúng tôi có liệt kê một số công ty có thể tháo dỡ và xử lý các vật dụng đó cho ông.', '', '', '3960e378-e3ea-4c5c-b832-1ca1fb9df88a', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('134339e4-9ea3-4c91-b958-5322d91f1f0f', 'ets-imported-test', 47, 3, 'listening', 'How do the speakers know each other?', 'They took a class together.', 'They used to work for the same company.', 'They grew up in the same neighborhood.', 'They met on a train.', 'A', 'M: Zaina! Thật bất ngờ! Tôi đã không gặp cô kể từ khi chúng ta học chung lớp dành cho chủ doanh nghiệp năm ngoái. Cô thế nào rồi?

W: Rất tốt, cảm ơn anh. Tôi vừa ở khu vực lân cận và nghĩ rằng mình sẽ ghé vào ăn một chiếc bánh quy hoặc một miếng bánh ngọt. Anh có rất nhiều đồ nướng ngon ở đây.

M: Cảm ơn cô! Đó là một năm kinh doanh thuận lợi. Tôi thậm chí đang cân nhắc việc mở địa điểm thứ hai.

W: Thật sao? À, tôi nhận thấy nhà hàng Sunnyvale đã đóng cửa kinh doanh, và tòa nhà đó đang được cho thuê. Nó rất gần trường đại học địa phương. Anh có thể sẽ có rất nhiều khách vãng lai đấy.', '', '', '2681a24a-17a6-48a0-817a-c3cd9c92b115', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('c4b3c076-960e-4c8b-a47c-101c76f57386', 'ets-imported-test', 48, 3, 'listening', 'What type of business does the man most likely own?', 'A fitness center', 'A real estate agency', 'A culinary school', 'A bakery', 'D', 'M: Zaina! Thật bất ngờ! Tôi đã không gặp cô kể từ khi chúng ta học chung lớp dành cho chủ doanh nghiệp năm ngoái. Cô thế nào rồi?

W: Rất tốt, cảm ơn anh. Tôi vừa ở khu vực lân cận và nghĩ rằng mình sẽ ghé vào ăn một chiếc bánh quy hoặc một miếng bánh ngọt. Anh có rất nhiều đồ nướng ngon ở đây.

M: Cảm ơn cô! Đó là một năm kinh doanh thuận lợi. Tôi thậm chí đang cân nhắc việc mở địa điểm thứ hai.

W: Thật sao? À, tôi nhận thấy nhà hàng Sunnyvale đã đóng cửa kinh doanh, và tòa nhà đó đang được cho thuê. Nó rất gần trường đại học địa phương. Anh có thể sẽ có rất nhiều khách vãng lai đấy.', '', '', '2681a24a-17a6-48a0-817a-c3cd9c92b115', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('c2e75828-e628-46b4-922e-137a6c470d7b', 'ets-imported-test', 49, 3, 'listening', 'What advantage does the woman point out about a rental space?', 'Its price', 'Its size', 'Its location', 'Its design', 'C', 'M: Zaina! Thật bất ngờ! Tôi đã không gặp cô kể từ khi chúng ta học chung lớp dành cho chủ doanh nghiệp năm ngoái. Cô thế nào rồi?

W: Rất tốt, cảm ơn anh. Tôi vừa ở khu vực lân cận và nghĩ rằng mình sẽ ghé vào ăn một chiếc bánh quy hoặc một miếng bánh ngọt. Anh có rất nhiều đồ nướng ngon ở đây.

M: Cảm ơn cô! Đó là một năm kinh doanh thuận lợi. Tôi thậm chí đang cân nhắc việc mở địa điểm thứ hai.

W: Thật sao? À, tôi nhận thấy nhà hàng Sunnyvale đã đóng cửa kinh doanh, và tòa nhà đó đang được cho thuê. Nó rất gần trường đại học địa phương. Anh có thể sẽ có rất nhiều khách vãng lai đấy.', '', '', '2681a24a-17a6-48a0-817a-c3cd9c92b115', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('fd1c3f02-bdfc-4c5f-98b9-1bddbba8dd2a', 'ets-imported-test', 50, 3, 'listening', 'Who most likely are the speakers?', 'Film actors', 'Museum directors', 'Video game developers', 'Investigative journalists', 'C', 'W: Chào Koji. Tôi nghĩ trò chơi điện tử mới của chúng ta đã gần sẵn sàng để phát hành rồi. Anh có biết về bất kỳ cải thiện nào cần thực hiện trước đó không?

M: Thực ra, tôi vừa kết thúc việc kiểm tra trò chơi sáng nay. Tôi đã tìm thấy một vấn đề ở màn thứ ba của trò chơi. Có một vài lần nhân vật của tôi không thể di chuyển được.

W: Ồ, lạ thật đấy!

M: Tôi đã kiểm tra lại vấn đề đó bằng một bộ điều khiển khác. Vấn đề tương tự vẫn xảy ra.

W: Ồ. Tôi nghĩ Pauline cũng gặp vấn đề tương tự với một trò chơi mà cô ấy đã kiểm tra. Có lẽ anh nên hỏi cô ấy về việc đó.', '', '', '08cfc15e-111f-4df1-940a-8b326fb06ea1', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('37a53427-38f9-4d5c-9d3c-ac169886bb9a', 'ets-imported-test', 51, 3, 'listening', 'What did the man recently do?', 'He secured some funding.', 'He tested a product.', 'He read a script.', 'He conducted an interview.', 'B', 'W: Chào Koji. Tôi nghĩ trò chơi điện tử mới của chúng ta đã gần sẵn sàng để phát hành rồi. Anh có biết về bất kỳ cải thiện nào cần thực hiện trước đó không?

M: Thực ra, tôi vừa kết thúc việc kiểm tra trò chơi sáng nay. Tôi đã tìm thấy một vấn đề ở màn thứ ba của trò chơi. Có một vài lần nhân vật của tôi không thể di chuyển được.

W: Ồ, lạ thật đấy!

M: Tôi đã kiểm tra lại vấn đề đó bằng một bộ điều khiển khác. Vấn đề tương tự vẫn xảy ra.

W: Ồ. Tôi nghĩ Pauline cũng gặp vấn đề tương tự với một trò chơi mà cô ấy đã kiểm tra. Có lẽ anh nên hỏi cô ấy về việc đó.', '', '', '08cfc15e-111f-4df1-940a-8b326fb06ea1', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('fce9cba9-8314-4a52-9c7a-10b7707e6f4b', 'ets-imported-test', 52, 3, 'listening', 'What does the woman suggest?', 'Consulting a colleague', 'Planning an event', 'Negotiating a contract', 'Giving a client an update', 'A', 'W: Chào Koji. Tôi nghĩ trò chơi điện tử mới của chúng ta đã gần sẵn sàng để phát hành rồi. Anh có biết về bất kỳ cải thiện nào cần thực hiện trước đó không?

M: Thực ra, tôi vừa kết thúc việc kiểm tra trò chơi sáng nay. Tôi đã tìm thấy một vấn đề ở màn thứ ba của trò chơi. Có một vài lần nhân vật của tôi không thể di chuyển được.

W: Ồ, lạ thật đấy!

M: Tôi đã kiểm tra lại vấn đề đó bằng một bộ điều khiển khác. Vấn đề tương tự vẫn xảy ra.

W: Ồ. Tôi nghĩ Pauline cũng gặp vấn đề tương tự với một trò chơi mà cô ấy đã kiểm tra. Có lẽ anh nên hỏi cô ấy về việc đó.', '', '', '08cfc15e-111f-4df1-940a-8b326fb06ea1', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('e9363ffb-c0a3-45bf-bf58-97f84953a7f8', 'ets-imported-test', 53, 3, 'listening', 'Who most likely is the man?', 'A delivery driver', 'A security guard', 'A maintenance worker', 'A customer service representative', 'C', 'M: Bạn đã gọi đến văn phòng bảo trì tại Khu chung cư Hillview.

W: Xin chào. Tôi là Palavi Sen từ căn hộ 35B. Tôi gọi vì cái bộ nhiệt kế mới trong căn hộ của tôi không hoạt động. Nó cứ tự tắt và bật một cách ngẫu nhiên, nên căn hộ của tôi đang bị lạnh.

M: Vấn đề này bắt đầu từ khi nào?

W: Vài giờ trước. Bộ nhiệt kế này vừa mới được lắp đặt ngày hôm qua.

M: Được rồi. Tôi có thể đến và kiểm tra nó vào sáng mai.

W: Nhưng tối nay nhiệt độ được dự báo là dưới mức đóng băng đấy!', '', '', '514f5ff6-5099-43aa-93bc-f04469584e3d', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('b59de191-9ae7-4ff1-b1ac-64ed4621deec', 'ets-imported-test', 54, 3, 'listening', 'What problem does the woman describe?', 'A device is malfunctioning.', 'A key is missing.', 'A parking area is unavailable.', 'A package was not received.', 'A', 'M: Bạn đã gọi đến văn phòng bảo trì tại Khu chung cư Hillview.

W: Xin chào. Tôi là Palavi Sen từ căn hộ 35B. Tôi gọi vì cái bộ nhiệt kế mới trong căn hộ của tôi không hoạt động. Nó cứ tự tắt và bật một cách ngẫu nhiên, nên căn hộ của tôi đang bị lạnh.

M: Vấn đề này bắt đầu từ khi nào?

W: Vài giờ trước. Bộ nhiệt kế này vừa mới được lắp đặt ngày hôm qua.

M: Được rồi. Tôi có thể đến và kiểm tra nó vào sáng mai.

W: Nhưng tối nay nhiệt độ được dự báo là dưới mức đóng băng đấy!', '', '', '514f5ff6-5099-43aa-93bc-f04469584e3d', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('82e4a7c6-2e0b-4f86-b431-883dc7a9f09e', 'ets-imported-test', 55, 3, 'listening', 'What does the woman mean when she says, “it’s supposed to be below freezing tonight”?', 'She is surprised by the weather forecast.', 'She wants a service to be completed sooner.', 'She will move some items indoors.', 'She would prefer to park near her apartment.', 'B', 'M: Bạn đã gọi đến văn phòng bảo trì tại Khu chung cư Hillview.

W: Xin chào. Tôi là Palavi Sen từ căn hộ 35B. Tôi gọi vì cái bộ nhiệt kế mới trong căn hộ của tôi không hoạt động. Nó cứ tự tắt và bật một cách ngẫu nhiên, nên căn hộ của tôi đang bị lạnh.

M: Vấn đề này bắt đầu từ khi nào?

W: Vài giờ trước. Bộ nhiệt kế này vừa mới được lắp đặt ngày hôm qua.

M: Được rồi. Tôi có thể đến và kiểm tra nó vào sáng mai.

W: Nhưng tối nay nhiệt độ được dự báo là dưới mức đóng băng đấy!', '', '', '514f5ff6-5099-43aa-93bc-f04469584e3d', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('8fb4fa90-af4b-46b7-a5b6-29beeb0e3416', 'ets-imported-test', 56, 3, 'listening', 'Why do the men want to speak to the woman?', 'To review a building design', 'To discuss a loan', 'To develop an advertising plan', 'To purchase some supplies', 'B', 'W: Chào buổi sáng! Chào mừng quý khách đến với Ngân hàng Jasper.

M1: Cảm ơn cô đã gặp chúng tôi để thảo luận về một khoản vay cho doanh nghiệp của chúng tôi.

W: Hai ông có thể cho tôi biết thêm về doanh nghiệp của mình được không? Tôi hiểu đó là một cửa hàng sửa chữa?

M2: Chà, mười năm trước, chúng tôi mở cửa như một cửa hàng sửa chữa xe trượt tuyết, nhưng sau vài năm, chúng tôi cũng bắt đầu cho thuê xe trượt tuyết và các thiết bị thể thao khác.

M1: Vâng, và vì du lịch mùa đông đã gia tăng gần đây, chúng tôi muốn mở rộng không gian của mình để có thể chứa nhiều hàng tồn kho hơn.', '', '', '49b0b3c2-f4e6-41d4-a7eb-b8c098781ea4', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('c244cd65-add5-42e3-ba86-4f3398714d77', 'ets-imported-test', 57, 3, 'listening', 'What type of business do the men own?', 'A sports equipment store', 'A winter apparel store', 'An automobile dealership', 'A hotel chain', 'A', 'W: Chào buổi sáng! Chào mừng quý khách đến với Ngân hàng Jasper.

M1: Cảm ơn cô đã gặp chúng tôi để thảo luận về một khoản vay cho doanh nghiệp của chúng tôi.

W: Hai ông có thể cho tôi biết thêm về doanh nghiệp của mình được không? Tôi hiểu đó là một cửa hàng sửa chữa?

M2: Chà, mười năm trước, chúng tôi mở cửa như một cửa hàng sửa chữa xe trượt tuyết, nhưng sau vài năm, chúng tôi cũng bắt đầu cho thuê xe trượt tuyết và các thiết bị thể thao khác.

M1: Vâng, và vì du lịch mùa đông đã gia tăng gần đây, chúng tôi muốn mở rộng không gian của mình để có thể chứa nhiều hàng tồn kho hơn.', '', '', '49b0b3c2-f4e6-41d4-a7eb-b8c098781ea4', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('1c343570-f151-455a-a4c5-700037ef0325', 'ets-imported-test', 58, 3, 'listening', 'According to the men, what has changed recently?', 'Roads have become more accessible.', 'Costs have decreased.', 'Tourism has increased.', 'Weather patterns have shifted.', 'C', 'W: Chào buổi sáng! Chào mừng quý khách đến với Ngân hàng Jasper.

M1: Cảm ơn cô đã gặp chúng tôi để thảo luận về một khoản vay cho doanh nghiệp của chúng tôi.

W: Hai ông có thể cho tôi biết thêm về doanh nghiệp của mình được không? Tôi hiểu đó là một cửa hàng sửa chữa?

M2: Chà, mười năm trước, chúng tôi mở cửa như một cửa hàng sửa chữa xe trượt tuyết, nhưng sau vài năm, chúng tôi cũng bắt đầu cho thuê xe trượt tuyết và các thiết bị thể thao khác.

M1: Vâng, và vì du lịch mùa đông đã gia tăng gần đây, chúng tôi muốn mở rộng không gian của mình để có thể chứa nhiều hàng tồn kho hơn.', '', '', '49b0b3c2-f4e6-41d4-a7eb-b8c098781ea4', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('b6e4a4e5-4342-4dc8-a974-e4bcaec200b3', 'ets-imported-test', 59, 3, 'listening', 'What does the man want to do?', 'Provide training opportunities', 'Upgrade machinery', 'Hire additional employees', 'Reorganize the factory layout', 'A', 'M: Nhiều công nhân nhà máy của chúng ta đã bày tỏ mong muốn được nâng cao kỹ năng. Tôi muốn triển khai một chương trình đào tạo chéo (peer-training), nơi những người học sẽ đi theo quan sát các nhân viên giàu kinh nghiệm hơn và xem cách họ làm việc.

W: Tôi e rằng điều đó có thể trở thành gánh nặng cho những nhân viên lâu năm. Họ sẽ phải làm chậm công việc của mình để giải thích những gì họ đang làm.

M: Nếu chúng ta quay video các nhân viên giàu kinh nghiệm thực hiện các nhiệm vụ cụ thể thì sao? Video chất lượng cao có thể được ghi lại và chỉnh sửa bằng điện thoại thông minh.

W: Tôi thích ý tưởng đó. Nó cho phép chúng ta ghi lại chuyên môn của công nhân mà không làm chậm dây chuyền sản xuất.', '', '', '42d18202-fdc1-4067-a424-97e937fb1d7d', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('7c2f371b-ca82-451b-822c-aabf5a2a7bed', 'ets-imported-test', 60, 3, 'listening', 'What is the woman concerned about?', 'Increasing expenses', 'Introducing errors', 'Reducing productivity', 'Causing confusion', 'C', 'M: Nhiều công nhân nhà máy của chúng ta đã bày tỏ mong muốn được nâng cao kỹ năng. Tôi muốn triển khai một chương trình đào tạo chéo (peer-training), nơi những người học sẽ đi theo quan sát các nhân viên giàu kinh nghiệm hơn và xem cách họ làm việc.

W: Tôi e rằng điều đó có thể trở thành gánh nặng cho những nhân viên lâu năm. Họ sẽ phải làm chậm công việc của mình để giải thích những gì họ đang làm.

M: Nếu chúng ta quay video các nhân viên giàu kinh nghiệm thực hiện các nhiệm vụ cụ thể thì sao? Video chất lượng cao có thể được ghi lại và chỉnh sửa bằng điện thoại thông minh.

W: Tôi thích ý tưởng đó. Nó cho phép chúng ta ghi lại chuyên môn của công nhân mà không làm chậm dây chuyền sản xuất.', '', '', '42d18202-fdc1-4067-a424-97e937fb1d7d', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('ccccdf36-13cf-4833-9070-389cf0c421b6', 'ets-imported-test', 61, 3, 'listening', 'What does the man mean when he says, “High-quality video can be recorded and edited with a smartphone”?', 'A new policy should be established.', 'An idea is easy to implement.', 'Data security is a concern.', 'Some information should be verified.', 'B', 'M: Nhiều công nhân nhà máy của chúng ta đã bày tỏ mong muốn được nâng cao kỹ năng. Tôi muốn triển khai một chương trình đào tạo chéo (peer-training), nơi những người học sẽ đi theo quan sát các nhân viên giàu kinh nghiệm hơn và xem cách họ làm việc.

W: Tôi e rằng điều đó có thể trở thành gánh nặng cho những nhân viên lâu năm. Họ sẽ phải làm chậm công việc của mình để giải thích những gì họ đang làm.

M: Nếu chúng ta quay video các nhân viên giàu kinh nghiệm thực hiện các nhiệm vụ cụ thể thì sao? Video chất lượng cao có thể được ghi lại và chỉnh sửa bằng điện thoại thông minh.

W: Tôi thích ý tưởng đó. Nó cho phép chúng ta ghi lại chuyên môn của công nhân mà không làm chậm dây chuyền sản xuất.', '', '', '42d18202-fdc1-4067-a424-97e937fb1d7d', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('fa27ccfd-612c-4288-9e61-3a81c114038d', 'ets-imported-test', 62, 3, 'listening', 'Where is the woman?', 'At a restaurant', 'At a travel agency', 'At an airport', 'At a warehouse', 'C', 'W: Chào Suresh. Tôi đang ở sân bay chờ chuyến bay của mình. Tôi muốn gặp một nhà đầu tư tiềm năng trong khi ở Chicago. Tên cô ấy là Marta Gomez. Tôi có thể gửi cho anh thông tin liên lạc của cô ấy.

M: Được rồi. Cô muốn gặp cô ấy vào ngày nào?

W: Sau khi kết thúc cuộc họp với nhân viên ở Chicago thì sao nhỉ?

M: Được thôi. Nhân tiện, cô có thấy công ty chúng ta vừa giành được giải thưởng cho những đóng góp cho cộng đồng không? Nó vừa được thông báo sáng nay đấy.', '', '', '124a5de5-eaa8-40c3-985d-50a1f8f16938', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('a53c799e-8651-4139-ad57-3d1f8234e1b8', 'ets-imported-test', 63, 3, 'listening', 'Look at the graphic. When does the woman prefer to meet with an investor?', 'On Monday', 'On Tuesday', 'On Wednesday', 'On Thursday', 'C', 'W: Chào Suresh. Tôi đang ở sân bay chờ chuyến bay của mình. Tôi muốn gặp một nhà đầu tư tiềm năng trong khi ở Chicago. Tên cô ấy là Marta Gomez. Tôi có thể gửi cho anh thông tin liên lạc của cô ấy.

M: Được rồi. Cô muốn gặp cô ấy vào ngày nào?

W: Sau khi kết thúc cuộc họp với nhân viên ở Chicago thì sao nhỉ?

M: Được thôi. Nhân tiện, cô có thấy công ty chúng ta vừa giành được giải thưởng cho những đóng góp cho cộng đồng không? Nó vừa được thông báo sáng nay đấy.', '', '', '124a5de5-eaa8-40c3-985d-50a1f8f16938', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('e82d5502-4a82-4347-86cd-d36f822ac9ac', 'ets-imported-test', 64, 3, 'listening', 'What good news does the man share?', 'A colleague received a promotion.', 'A conference proposal was accepted.', 'An airline ticket has been upgraded.', 'A company won an award.', 'D', 'W: Chào Suresh. Tôi đang ở sân bay chờ chuyến bay của mình. Tôi muốn gặp một nhà đầu tư tiềm năng trong khi ở Chicago. Tên cô ấy là Marta Gomez. Tôi có thể gửi cho anh thông tin liên lạc của cô ấy.

M: Được rồi. Cô muốn gặp cô ấy vào ngày nào?

W: Sau khi kết thúc cuộc họp với nhân viên ở Chicago thì sao nhỉ?

M: Được thôi. Nhân tiện, cô có thấy công ty chúng ta vừa giành được giải thưởng cho những đóng góp cho cộng đồng không? Nó vừa được thông báo sáng nay đấy.', '', '', '124a5de5-eaa8-40c3-985d-50a1f8f16938', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('d8f8cf8a-1539-4311-9075-49eab837ce6a', 'ets-imported-test', 65, 3, 'listening', 'Where do the speakers work?', 'At an amusement park', 'At an art museum', 'At a concert hall', 'At a botanical garden', 'D', 'M: Marion, chúng ta liên tục nhận được cuộc gọi từ những người muốn tham quan vườn bách thảo nhưng không tìm thấy thông tin đỗ xe. Nó không có trên trang web của chúng ta sao?

W: Có chứ, nhưng anh phải nhấp vào trang "Về chúng tôi" và cuộn xuống cuối trang đó. Có lẽ mọi người không nhìn thấy nó.

M: Ồ, tôi nghĩ chúng ta nên chuyển thông tin đó khỏi trang "Về chúng tôi" và tạo một trang riêng cho chỉ dẫn đường đi và thông tin đỗ xe. Bằng cách đó, mọi người có thể tìm thấy nó dễ dàng hơn.

W: Tôi rất sẵn lòng thực hiện thay đổi đó. Nhưng chúng ta đang trong quá trình cập nhật phần mềm, nên việc này sẽ phải đợi đến thứ Hai.', '', '', '75ff7fbb-7e60-480a-8f03-f7252c6c6b1f', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('808392f0-9652-4cc0-ba57-b4ebc06cf79e', 'ets-imported-test', 66, 3, 'listening', 'Look at the graphic. Which page on the Web site does the man want to change?', 'Page 1', 'Page 2', 'Page 3', 'Page 4', 'A', 'M: Marion, chúng ta liên tục nhận được cuộc gọi từ những người muốn tham quan vườn bách thảo nhưng không tìm thấy thông tin đỗ xe. Nó không có trên trang web của chúng ta sao?

W: Có chứ, nhưng anh phải nhấp vào trang "Về chúng tôi" và cuộn xuống cuối trang đó. Có lẽ mọi người không nhìn thấy nó.

M: Ồ, tôi nghĩ chúng ta nên chuyển thông tin đó khỏi trang "Về chúng tôi" và tạo một trang riêng cho chỉ dẫn đường đi và thông tin đỗ xe. Bằng cách đó, mọi người có thể tìm thấy it dễ dàng hơn.

W: Tôi rất sẵn lòng thực hiện thay đổi đó. Nhưng chúng ta đang trong quá trình cập nhật phần mềm, nên việc này sẽ phải đợi đến thứ Hai.', '', '', '75ff7fbb-7e60-480a-8f03-f7252c6c6b1f', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('2aafa311-ef89-4184-a711-f5302bf7f4fc', 'ets-imported-test', 67, 3, 'listening', 'Why does the woman say she cannot complete a task until Monday?', 'She requires approval from a manager.', 'She is attending a workshop.', 'Some software is being updated.', 'Some clients will be arriving soon.', 'C', 'M: Marion, chúng ta liên tục nhận được cuộc gọi từ những người muốn tham quan vườn bách thảo nhưng không tìm thấy thông tin đỗ xe. Nó không có trên trang web của chúng ta sao?

W: Có chứ, nhưng anh phải nhấp vào trang "Về chúng tôi" và cuộn xuống cuối trang đó. Có lẽ mọi người không nhìn thấy nó.

M: Ồ, tôi nghĩ chúng ta nên chuyển thông tin đó khỏi trang "Về chúng tôi" và tạo một trang riêng cho chỉ dẫn đường đi và thông tin đỗ xe. Bằng cách đó, mọi người có thể tìm thấy it dễ dàng hơn.

W: Tôi rất sẵn lòng thực hiện thay đổi đó. Nhưng chúng ta đang trong quá trình cập nhật phần mềm, nên việc này sẽ phải đợi đến thứ Hai.', '', '', '75ff7fbb-7e60-480a-8f03-f7252c6c6b1f', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('d6299d58-d5d7-4d44-9ec0-94c3fe4a9335', 'ets-imported-test', 68, 3, 'listening', 'What news does the man share?', 'A station road will be closed for repair.', 'A project has been approved.', 'A parking area has been expanded.', 'An office will relocate.', 'B', 'M: Tin tốt đây! Cuối cùng chúng ta đã nhận được sự chấp thuận cho dự án của bộ phận mình về việc lắp đặt các giá để xe đạp tại ga tàu trung tâm thành phố.

W: Cuối cùng cũng được! Vậy bây giờ chúng ta cần quyết định nơi đặt các giá để xe. Đặt ở lối vào nhà ga thì sao?

M: Hmm. Nếu chúng ta hỏi những người đi tàu, tôi cá là họ sẽ nói rằng vị trí thuận tiện nhất là càng gần sân ga càng tốt.

W: Hãy làm như vậy đi. Tôi sẽ liên hệ với một số công ty để lấy báo giá (estimates).', '', '', '8047aeab-2270-433e-b7b3-739f78d2fd68', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('24c96621-1cd1-42f5-965b-01c0ef2c8bca', 'ets-imported-test', 69, 3, 'listening', 'Look at the graphic. Where do the speakers decide to install some bicycle racks?', 'Near the covered parking area', 'Near the long-term parking area', 'Near the short-term parking area', 'Near the overflow parking area', 'A', 'M: Tin tốt đây! Cuối cùng chúng ta đã nhận được sự chấp thuận cho dự án của bộ phận mình về việc lắp đặt các giá để xe đạp tại ga tàu trung tâm thành phố.

W: Cuối cùng cũng được! Vậy bây giờ chúng ta cần quyết định nơi đặt các giá để xe. Đặt ở lối vào nhà ga thì sao?

M: Hmm. Nếu chúng ta hỏi những người đi tàu, tôi cá là họ sẽ nói rằng vị trí thuận tiện nhất là càng gần sân ga càng tốt.

W: Hãy làm như vậy đi. Tôi sẽ liên hệ với một số công ty để lấy báo giá (estimates).', '', '', '8047aeab-2270-433e-b7b3-739f78d2fd68', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('e4e0cb6e-5924-459a-aeb4-fadf467ed50c', 'ets-imported-test', 70, 3, 'listening', 'Why does the woman say she will contact some companies?', 'To arrange a loan', 'To apply for a permit', 'To ask for estimates', 'To create a proposal', 'C', 'M: Tin tốt đây! Cuối cùng chúng ta đã nhận được sự chấp thuận cho dự án của bộ phận mình về việc lắp đặt các giá để xe đạp tại ga tàu trung tâm thành phố.

W: Cuối cùng cũng được! Vậy bây giờ chúng ta cần quyết định nơi đặt các giá để xe. Đặt ở lối vào nhà ga thì sao?

M: Hmm. Nếu chúng ta hỏi những người đi tàu, tôi cá là họ sẽ nói rằng vị trí thuận tiện nhất là càng gần sân ga càng tốt.

W: Hãy làm như vậy đi. Tôi sẽ liên hệ với một số công ty để lấy báo giá (estimates).', '', '', '8047aeab-2270-433e-b7b3-739f78d2fd68', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('ea3c5593-f940-4be5-abf7-e9e0c132ac1b', 'ets-imported-test', 71, 4, 'listening', 'What type of products does the business repair?', 'Computers', 'Vehicles', 'Light fixtures', 'Kitchen appliances', 'B', 'Bạn đã gọi đến Dịch vụ Sửa chữa Select. Chúng tôi chuyên về tất cả các dòng xe và mẫu mã ô tô. Các chuyên gia được đào tạo chính quy của chúng tôi sẽ giữ cho phương tiện của bạn hoạt động trong tình trạng tốt nhất. Như một lợi ích bổ sung, chúng tôi cung cấp gói bảo hành mở rộng cho tất cả các phương tiện mà chúng tôi bảo trì. Bạn có thể tận hưởng thêm ba năm lái xe mà không cần lo lắng. Xin lưu ý rằng Dịch vụ Sửa chữa Select sẽ đóng cửa vào thứ Sáu, ngày 30 tháng 6, để chúng tôi có thể hoàn thành việc kiểm kê vật tư hàng quý. Cảm ơn sự kiên nhẫn của bạn. Đại diện của chúng tôi sẽ hỗ trợ bạn trong giây lát.', '', '', '1c59a560-b3db-4c08-8a19-31c23aac8f84', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('b3f75976-838a-4ca4-9826-988c60d0e671', 'ets-imported-test', 72, 4, 'listening', 'What special benefit does the speaker mention?', 'Free pickup', 'Online scheduling', 'Extended warranties', 'A membership loyalty program', 'C', 'Bạn đã gọi đến Dịch vụ Sửa chữa Select. Chúng tôi chuyên về tất cả các dòng xe và mẫu mã ô tô. Các chuyên gia được đào tạo chính quy của chúng tôi sẽ giữ cho phương tiện của bạn hoạt động trong tình trạng tốt nhất. Như một lợi ích bổ sung, chúng tôi cung cấp gói bảo hành mở rộng cho tất cả các phương tiện mà chúng tôi bảo trì. Bạn có thể tận hưởng thêm ba năm lái xe mà không cần lo lắng. Xin lưu ý rằng Dịch vụ Sửa chữa Select sẽ đóng cửa vào thứ Sáu, ngày 30 tháng 6, để chúng tôi có thể hoàn thành việc kiểm kê vật tư hàng quý. Cảm ơn sự kiên nhẫn của bạn. Đại diện của chúng tôi sẽ hỗ trợ bạn trong giây lát.', '', '', '1c59a560-b3db-4c08-8a19-31c23aac8f84', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('377d4320-fca3-4e33-87dc-c1b117f84ef0', 'ets-imported-test', 73, 4, 'listening', 'Why will a business close on Friday?', 'For an inventory count', 'For employee training', 'For a company celebration', 'For equipment installation', 'A', 'Bạn đã gọi đến Dịch vụ Sửa chữa Select. Chúng tôi chuyên về tất cả các dòng xe và mẫu mã ô tô. Các chuyên gia được đào tạo chính quy của chúng tôi sẽ giữ cho phương tiện của bạn hoạt động trong tình trạng tốt nhất. Như một lợi ích bổ sung, chúng tôi cung cấp gói bảo hành mở rộng cho tất cả các phương tiện mà chúng tôi bảo trì. Bạn có thể tận hưởng thêm ba năm lái xe mà không cần lo lắng. Xin lưu ý rằng Dịch vụ Sửa chữa Select sẽ đóng cửa vào thứ Sáu, ngày 30 tháng 6, để chúng tôi có thể hoàn thành việc kiểm kê vật tư hàng quý. Cảm ơn sự kiên nhẫn của bạn. Đại diện của chúng tôi sẽ hỗ trợ bạn trong giây lát.', '', '', '1c59a560-b3db-4c08-8a19-31c23aac8f84', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('58d4e46d-1c15-4308-8d12-d90c1b7bffc2', 'ets-imported-test', 74, 4, 'listening', 'Who most likely is the speaker?', 'A facilities manager', 'A human resources representative', 'A security officer', 'A corporate executive', 'B', 'Chào mừng các nhân viên mới! Tôi tên là Diego, và tôi điều phối tất cả các buổi định hướng. Trước khi chúng ta bắt đầu hôm nay, các bạn sẽ cần thiết lập tài khoản nhân viên của mình. Nếu bạn nhìn vào trang đầu tiên của bìa hồ sơ đào tạo, bạn sẽ thấy tên người dùng và mật khẩu tạm thời. Vui lòng mở máy tính xách tay mà bạn được giao sáng nay và đăng nhập bằng các thông tin đó. Sau đó, bạn sẽ được yêu cầu tạo mật khẩu của riêng mình. Sau khi hoàn tất, bạn sẽ có quyền truy cập vào tất cả các tệp tin của bộ phận mình. Xin lưu ý rằng bạn chỉ có thể truy cập chúng từ máy tính của công ty.', '', '', '53e4a234-2c31-428c-993b-7edf5cf36d7b', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('a6d3f6de-404f-48cc-91a6-a4a1a782982c', 'ets-imported-test', 75, 4, 'listening', 'According to the speaker, what will the listeners find in a binder?', 'A map of the building', 'An employment contract', 'An identification badge', 'Log-in credentials', 'D', 'Chào mừng các nhân viên mới! Tôi tên là Diego, và tôi điều phối tất cả các buổi định hướng. Trước khi chúng ta bắt đầu hôm nay, các bạn sẽ cần thiết lập tài khoản nhân viên của mình. Nếu bạn nhìn vào trang đầu tiên của bìa hồ sơ đào tạo, bạn sẽ thấy tên người dùng và mật khẩu tạm thời. Vui lòng mở máy tính xách tay mà bạn được giao sáng nay và đăng nhập bằng các thông tin đó. Sau đó, bạn sẽ được yêu cầu tạo mật khẩu của riêng mình. Sau khi hoàn tất, bạn sẽ có quyền truy cập vào tất cả các tệp tin của bộ phận mình. Xin lưu ý rằng bạn chỉ có thể truy cập chúng từ máy tính của công ty.', '', '', '53e4a234-2c31-428c-993b-7edf5cf36d7b', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('fb613ce9-5afc-4591-9728-3b56ad87d873', 'ets-imported-test', 76, 4, 'listening', 'What does the speaker say about department files?', 'They are only accessible from company computers.', 'They must be password protected.', 'They must follow a specific naming convention.', 'They must be archived annually.', 'A', 'Chào mừng các nhân viên mới! Tôi tên là Diego, và tôi điều phối tất cả các buổi định hướng. Trước khi chúng ta bắt đầu hôm nay, các bạn sẽ cần thiết lập tài khoản nhân viên của mình. Nếu bạn nhìn vào trang đầu tiên của bìa hồ sơ đào tạo, bạn sẽ thấy tên người dùng và mật khẩu tạm thời. Vui lòng mở máy tính xách tay mà bạn được giao sáng nay và đăng nhập bằng các thông tin đó. Sau đó, bạn sẽ được yêu cầu tạo mật khẩu của riêng mình. Sau khi hoàn tất, bạn sẽ có quyền truy cập vào tất cả các tệp tin của bộ phận mình. Xin lưu ý rằng bạn chỉ có thể truy cập chúng từ máy tính của công ty.', '', '', '53e4a234-2c31-428c-993b-7edf5cf36d7b', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('d7a02cd1-f77b-4cc9-99bf-f1fe973c2069', 'ets-imported-test', 77, 4, 'listening', 'Where does the speaker work?', 'At a laundry facility', 'At an amusement park', 'At a sports stadium', 'At a fitness center', 'B', 'Xin chào. Đây là Heather Ross gọi từ Công viên Giải trí Denville. Khoảng một tháng trước, tôi đã đặt mua một trong những máy chơi trò chơi điện tử mới của các bạn, Space Defenders. Tôi thực sự hài lòng với giao dịch mua này, vì trò chơi này cực kỳ phổ biến với khách tham quan công viên của chúng tôi! Tôi đang cân nhắc mua thêm một số máy nữa trong tương lai gần. Tôi nghe nói các bạn có thể sẽ phát hành một trò chơi mới sớm. Bạn có thể gọi lại cho tôi và cho biết điều đó có đúng không? Cảm ơn!', '', '', 'c075c848-c127-4110-940c-a535e186bcd7', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('78af3b0c-4154-442f-a7d5-f27309d5643f', 'ets-imported-test', 78, 4, 'listening', 'What does the speaker say about an item she ordered a month ago?', 'It arrived later than expected.', 'It was damaged during delivery.', 'She needs help assembling it.', 'She is pleased with it.', 'D', 'Xin chào. Đây là Heather Ross gọi từ Công viên Giải trí Denville. Khoảng một tháng trước, tôi đã đặt mua một trong những máy chơi trò chơi điện tử mới của các bạn, Space Defenders. Tôi thực sự hài lòng với giao dịch mua này, vì trò chơi này cực kỳ phổ biến với khách tham quan công viên của chúng tôi! Tôi đang cân nhắc mua thêm một số máy nữa trong tương lai gần. Tôi nghe nói các bạn có thể sẽ phát hành một trò chơi mới sớm. Bạn có thể gọi lại cho tôi và cho biết điều đó có đúng không? Cảm ơn!', '', '', 'c075c848-c127-4110-940c-a535e186bcd7', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('63211dbd-0d05-4061-b7f7-a0b8031469f1', 'ets-imported-test', 79, 4, 'listening', 'What does the speaker ask the listener to confirm?', 'Whether a new product will be available soon', 'When a replacement part will be shipped', 'How long a warranty lasts', 'Who to contact about future orders', 'A', 'Xin chào. Đây là Heather Ross gọi từ Công viên Giải trí Denville. Khoảng một tháng trước, tôi đã đặt mua một trong những máy chơi trò chơi điện tử mới của các bạn, Space Defenders. Tôi thực sự hài lòng với giao dịch mua này, vì trò chơi này cực kỳ phổ biến với khách tham quan công viên của chúng tôi! Tôi đang cân nhắc mua thêm một số máy nữa trong tương lai gần. Tôi nghe nói các bạn có thể sẽ phát hành một trò chơi mới sớm. Bạn có thể gọi lại cho tôi và cho biết điều đó có đúng không? Cảm ơn!', '', '', 'c075c848-c127-4110-940c-a535e186bcd7', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('6ec1f82a-fe8e-4d8e-941d-8015247660c0', 'ets-imported-test', 80, 4, 'listening', 'What type of product does the speaker''s company make?', 'Furniture', 'Luggage', 'Bedding', 'Clothing', 'D', 'Nội dung đầu tiên trong chương trình nghị sự cho cuộc họp hội đồng quản trị của chúng ta là báo cáo doanh số hàng năm. Tất cả chúng ta đều thất vọng trước sự sụt giảm doanh số bán quần áo. Sự sụt giảm này chủ yếu là do các vấn đề về phân phối. Vì các nhà máy của chúng ta đều ở nước ngoài nên mất quá nhiều thời gian để đơn hàng đến tay khách hàng. Vì vậy, tôi đề nghị chúng ta bắt đầu sản xuất một số mặt hàng may mặc tại địa phương. Chúng ta sẽ tìm kiếm một địa điểm để xây dựng cơ sở sản xuất. Tôi đã thuê một cố vấn để lập danh sách các địa điểm chúng ta có thể sử dụng. Anh ấy sẽ có mặt tại cuộc họp hội đồng quản trị tiếp theo để giải thích các ưu và nhược điểm của từng nơi.', '', '', '13e358ce-17ab-482e-8c89-8e7000517012', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('c794af70-29a0-4e29-a2db-0e449b9eb97f', 'ets-imported-test', 81, 4, 'listening', 'What does the speaker recommend doing?', 'Manufacturing some products locally', 'Offering free shipping', 'Participating in a trade show', 'Developing a new product line', 'A', 'Nội dung đầu tiên trong chương trình nghị sự cho cuộc họp hội đồng quản trị của chúng ta là báo cáo doanh số hàng năm. Tất cả chúng ta đều thất vọng trước sự sụt giảm doanh số bán quần áo. Sự sụt giảm này chủ yếu là do các vấn đề về phân phối. Vì các nhà máy của chúng ta đều ở nước ngoài nên mất quá nhiều thời gian để đơn hàng đến tay khách hàng. Vì vậy, tôi đề nghị chúng ta bắt đầu sản xuất một số mặt hàng may mặc tại địa phương. Chúng ta sẽ tìm kiếm một địa điểm để xây dựng cơ sở sản xuất. Tôi đã thuê một cố vấn để lập danh sách các địa điểm chúng ta có thể sử dụng. Anh ấy sẽ có mặt tại cuộc họp hội đồng quản trị tiếp theo để giải thích các ưu và nhược điểm của từng nơi.', '', '', '13e358ce-17ab-482e-8c89-8e7000517012', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('305a97f5-f374-45db-9ff5-ecb232b6ba65', 'ets-imported-test', 82, 4, 'listening', 'What will happen at the next meeting?', 'A vote will take place.', 'A consultant will give a presentation.', 'Some contracts will be updated.', 'Safety procedures will be reviewed.', 'B', 'Nội dung đầu tiên trong chương trình nghị sự cho cuộc họp hội đồng quản trị của chúng ta là báo cáo doanh số hàng năm. Tất cả chúng ta đều thất vọng trước sự sụt giảm doanh số bán quần áo. Sự sụt giảm này chủ yếu là do các vấn đề về phân phối. Vì các nhà máy của chúng ta đều ở nước ngoài nên mất quá nhiều thời gian để đơn hàng đến tay khách hàng. Vì vậy, tôi đề nghị chúng ta bắt đầu sản xuất một số mặt hàng may mặc tại địa phương. Chúng ta sẽ tìm kiếm một địa điểm để xây dựng cơ sở sản xuất. Tôi đã thuê một cố vấn để lập danh sách các địa điểm chúng ta có thể sử dụng. Anh ấy sẽ có mặt tại cuộc họp hội đồng quản trị tiếp theo để giải thích các ưu và nhược điểm của từng nơi.', '', '', '13e358ce-17ab-482e-8c89-8e7000517012', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('6f3da50f-5488-4ffc-9f30-629c3e181050', 'ets-imported-test', 83, 4, 'listening', 'What is the announcement mainly about?', 'A promotional event', 'A vacation package', 'A building renovation', 'A travel delay', 'D', 'Xin hành khách chú ý. Tất cả các chuyến tàu đến Ga Midway đều bị trễ do sửa chữa đường ray. Các đội sửa chữa đang làm việc trên một đoạn đường ray ngay phía nam thị trấn Wheedon. Họ dự kiến sẽ hoàn thành việc sửa chữa trong vòng một giờ tới. Chúng tôi xin lỗi vì sự chậm trễ này. Chúng tôi hiểu rằng nhiều người đi làm cần phải đến Midway càng sớm càng tốt. Một chiếc xe buýt sẽ khởi hành đến điểm đến đó trong mười lăm phút nữa. Ngoài ra, xin nhắc nhở rằng quán cà phê của nhà ga mở cửa lúc 8 giờ sáng và có các quầy thực phẩm ở sân ga số một.', '', '', '9132025a-6db0-4cc2-b423-893d4386401a', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('a2a03efa-d221-4c72-ad5e-00ede898b19e', 'ets-imported-test', 84, 4, 'listening', 'Why does the speaker say, “A bus will be departing for that destination in fifteen minutes”?', 'To suggest an alternative arrangement', 'To explain an extended wait time', 'To recommend changing the travel date', 'To inform customers about a new destination', 'A', 'Xin hành khách chú ý. Tất cả các chuyến tàu đến Ga Midway đều bị trễ do sửa chữa đường ray. Các đội sửa chữa đang làm việc trên một đoạn đường ray ngay phía nam thị trấn Wheedon. Họ dự kiến sẽ hoàn thành việc sửa chữa trong vòng một giờ tới. Chúng tôi xin lỗi vì sự chậm trễ này. Chúng tôi hiểu rằng nhiều người đi làm cần phải đến Midway càng sớm càng tốt. Một chiếc xe buýt sẽ khởi hành đến điểm đến đó trong mười lăm phút nữa. Ngoài ra, xin nhắc nhở rằng quán cà phê của nhà ga mở cửa lúc 8 giờ sáng và có các quầy thực phẩm ở sân ga số một.', '', '', '9132025a-6db0-4cc2-b423-893d4386401a', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('4f6c81fa-19e6-4052-9f32-272af9cd6ffa', 'ets-imported-test', 85, 4, 'listening', 'What does the speaker remind the listeners about?', 'How to download a mobile application', 'Where a waiting area is located', 'How to reserve tickets', 'Where to buy food', 'D', 'Xin hành khách chú ý. Tất cả các chuyến tàu đến Ga Midway đều bị trễ do sửa chữa đường ray. Các đội sửa chữa đang làm việc trên một đoạn đường ray ngay phía nam thị trấn Wheedon. Họ dự kiến sẽ hoàn thành việc sửa chữa trong vòng một giờ tới. Chúng tôi xin lỗi vì sự chậm trễ này. Chúng tôi hiểu rằng nhiều người đi làm cần phải đến Midway càng sớm càng tốt. Một chiếc xe buýt sẽ khởi hành đến điểm đến đó trong mười lăm phút nữa. Ngoài ra, xin nhắc nhở rằng quán cà phê của nhà ga mở cửa lúc 8 giờ sáng và có các quầy thực phẩm ở sân ga số một.', '', '', '9132025a-6db0-4cc2-b423-893d4386401a', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('e9c28c4b-29b3-4241-979a-ad773eab3a6f', 'ets-imported-test', 86, 4, 'listening', 'Where does the speaker most likely work?', 'At a graphic design company', 'At a law firm', 'At a photography studio', 'At a museum', 'A', 'Tôi gọi điện về công việc mà đội thiết kế của tôi đang thực hiện để cập nhật logo công ty của bạn. Tôi vừa gửi email hai phiên bản để bạn xem xét. Phiên bản đầu tiên là một thiết kế hiện đại với màu sắc đậm và kiểu chữ đơn giản. Hình ảnh thứ hai phản ánh lịch sử của thương hiệu và logo của nó. Nó ít hợp thời trang hơn, nhưng nó không khác biệt nhiều so với bản gốc, điều mà bạn có thể sẽ thích hơn. Hãy dành thời gian suy nghĩ về phiên bản nào bạn muốn chọn. Tôi sẽ đi nghỉ mát suốt tuần tới, nhưng nếu bạn gọi cho văn phòng, trợ lý của tôi sẽ sắp xếp một cuộc họp khi tôi quay lại.', '', '', '698c74fc-6a81-4297-a773-92c1c9dd63e6', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('aa8500b7-a155-4a3e-abe6-408a343988b5', 'ets-imported-test', 87, 4, 'listening', 'What did the listener receive by e-mail?', 'A newsletter', 'Some images', 'An invoice', 'Some contracts', 'B', 'Tôi gọi điện về công việc mà đội thiết kế của tôi đang thực hiện để cập nhật logo công ty của bạn. Tôi vừa gửi email hai phiên bản để bạn xem xét. Phiên bản đầu tiên là một thiết kế hiện đại với màu sắc đậm và kiểu chữ đơn giản. Hình ảnh thứ hai phản ánh lịch sử của thương hiệu và logo của nó. Nó ít hợp thời trang hơn, nhưng nó không khác biệt nhiều so với bản gốc, điều mà bạn có thể sẽ thích hơn. Hãy dành thời gian suy nghĩ về phiên bản nào bạn muốn chọn. Tôi sẽ đi nghỉ mát suốt tuần tới, nhưng nếu bạn gọi cho văn phòng, trợ lý của tôi sẽ sắp xếp một cuộc họp khi tôi quay lại.', '', '', '698c74fc-6a81-4297-a773-92c1c9dd63e6', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('f67ea6d3-d482-4726-9863-468b2625fc45', 'ets-imported-test', 88, 4, 'listening', 'Why is the speaker unavailable next week?', 'She will be working at another branch.', 'She will be with other clients.', 'She will be on vacation.', 'She will be at an industry conference.', 'C', 'Tôi gọi điện về công việc mà đội thiết kế của tôi đang thực hiện để cập nhật logo công ty của bạn. Tôi vừa gửi email hai phiên bản để bạn xem xét. Phiên bản đầu tiên là một thiết kế hiện đại với màu sắc đậm và kiểu chữ đơn giản. Hình ảnh thứ hai phản ánh lịch sử của thương hiệu và logo của nó. Nó ít hợp thời trang hơn, nhưng nó không khác biệt nhiều so với bản gốc, điều mà bạn có thể sẽ thích hơn. Hãy dành thời gian suy nghĩ về phiên bản nào bạn muốn chọn. Tôi sẽ đi nghỉ mát suốt tuần tới, nhưng nếu bạn gọi cho văn phòng, trợ lý của tôi sẽ sắp xếp một cuộc họp khi tôi quay lại.', '', '', '698c74fc-6a81-4297-a773-92c1c9dd63e6', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('0d07c04e-a3cb-413d-b526-6c6bb9cc626c', 'ets-imported-test', 89, 4, 'listening', 'Who most likely are the listeners?', 'Investors', 'Government officials', 'Engineers', 'Journalists', 'D', 'Sau khi cơ quan vận tải công bố bản dự thảo kế hoạch cải tiến vào tuần trước, các thành viên báo chí đã hỏi liệu chúng tôi có đang cân nhắc việc lắp đặt các động cơ tiết kiệm nhiên liệu hơn cho tàu hỏa của mình hay không. Tôi đã sắp xếp buổi họp báo này để trả lời chính thức các thắc mắc của quý vị. Mười tám tháng trước, chúng tôi đã thuê một công ty để xác định xem việc nâng cấp này có khả thi đối với các đoàn tàu của chúng tôi hay không. Họ báo cáo rằng việc nâng cấp sẽ chỉ mang lại hiệu quả kinh tế đối với các đoàn tàu tương đối mới—nghĩa là những đoàn tàu dưới năm năm tuổi. Tất cả các tàu của chúng tôi đều đã ít nhất mười năm tuổi. Tôi hy vọng điều này giải đáp được các câu hỏi của quý vị. Nếu quý vị quan tâm đến thêm chi tiết, hãy gửi email cho bộ phận quan hệ truyền thông của chúng tôi để nhận bản tóm tắt các kết quả tìm được.', '', '', 'ce2e28d3-c199-4e8f-850d-06aa866cdd92', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('df82a38e-c4ec-47a9-bd71-346bba49700e', 'ets-imported-test', 90, 4, 'listening', 'What does the speaker mean when she says, “All of ours are at least ten years old”?', 'An event needs to be relocated.', 'An upgrade is not feasible.', 'A project team has a lot of experience.', 'Some company policies are outdated.', 'B', 'Sau khi cơ quan vận tải công bố bản dự thảo kế hoạch cải tiến vào tuần trước, các thành viên báo chí đã hỏi liệu chúng tôi có đang cân nhắc việc lắp đặt các động cơ tiết kiệm nhiên liệu hơn cho tàu hỏa của mình hay không. Tôi đã sắp xếp buổi họp báo này để trả lời chính thức các thắc mắc của quý vị. Mười tám tháng trước, chúng tôi đã thuê một công ty để xác định xem việc nâng cấp này có khả thi đối với các đoàn tàu của chúng tôi hay không. Họ báo cáo rằng việc nâng cấp sẽ chỉ mang lại hiệu quả kinh tế đối với các đoàn tàu tương đối mới—nghĩa là những đoàn tàu dưới năm năm tuổi. Tất cả các tàu của chúng tôi đều đã ít nhất mười năm tuổi. Tôi hy vọng điều này giải đáp được các câu hỏi của quý vị. Nếu quý vị quan tâm đến thêm chi tiết, hãy gửi email cho bộ phận quan hệ truyền thông của chúng tôi để nhận bản tóm tắt các kết quả tìm được.', '', '', 'ce2e28d3-c199-4e8f-850d-06aa866cdd92', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('11679146-3528-4012-8a07-879cbfc944ba', 'ets-imported-test', 91, 4, 'listening', 'According to the speaker, what can be requested by e-mail?', 'Some presentation slides', 'Some product samples', 'A report summary', 'A discounted ticket', 'C', 'Sau khi cơ quan vận tải công bố bản dự thảo kế hoạch cải tiến vào tuần trước, các thành viên báo chí đã hỏi liệu chúng tôi có đang cân nhắc việc lắp đặt các động cơ tiết kiệm nhiên liệu hơn cho tàu hỏa của mình hay không. Tôi đã sắp xếp buổi họp báo này để trả lời chính thức các thắc mắc của quý vị. Mười tám tháng trước, chúng tôi đã thuê một công ty để xác định xem việc nâng cấp này có khả thi đối với các đoàn tàu của chúng tôi hay không. Họ báo cáo rằng việc nâng cấp sẽ chỉ mang lại hiệu quả kinh tế đối với các đoàn tàu tương đối mới—nghĩa là những đoàn tàu dưới năm năm tuổi. Tất cả các tàu của chúng tôi đều đã ít nhất mười năm tuổi. Tôi hy vọng điều này giải đáp được các câu hỏi của quý vị. Nếu quý vị quan tâm đến thêm chi tiết, hãy gửi email cho bộ phận quan hệ truyền thông của chúng tôi để nhận bản tóm tắt các kết quả tìm được.', '', '', 'ce2e28d3-c199-4e8f-850d-06aa866cdd92', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('1a4a58cf-23df-4962-b5e4-362a8202a42e', 'ets-imported-test', 92, 4, 'listening', 'What does the speaker want to do?', 'Increase online sales', 'Upgrade a payment system', 'Create a new product line', 'Add store locations', 'B', 'Với tư cách là giám đốc bán hàng khu vực, tôi muốn tìm hiểu việc sử dụng hệ thống thanh toán hiện đại hơn trong các cửa hàng mỹ phẩm của chúng ta. Hệ thống này sẽ cho phép bất kỳ cộng tác viên bán hàng nào cũng có thể nhận thanh toán của khách hàng từ máy tính bảng ở bất kỳ đâu trong cửa hàng. Tại sao chúng ta nên làm điều này? Khiếu nại chính về việc mua sắm tại các cửa hàng của chúng ta là phải chờ đợi trong những hàng dài để thanh toán. Rất nhiều cửa hàng của chúng ta có thể hưởng lợi từ việc này, nhưng tôi đã quyết định tiến hành chạy thử tại cửa hàng ở Center City Mall. Cho đến nay, đó là địa điểm bận rộn nhất của chúng ta.', '', '', 'e899fe92-b16e-4106-b3e8-64d79504148e', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('2503d1a6-adcf-454f-88d2-84fa6a717a23', 'ets-imported-test', 93, 4, 'listening', 'According to the speaker, what is the customers’ main complaint?', 'Long lines', 'High prices', 'Unavailable items', 'Unfriendly staff', 'A', 'Với tư cách là giám đốc bán hàng khu vực, tôi muốn tìm hiểu việc sử dụng hệ thống thanh toán hiện đại hơn trong các cửa hàng mỹ phẩm của chúng ta. Hệ thống này sẽ cho phép bất kỳ cộng tác viên bán hàng nào cũng có thể nhận thanh toán của khách hàng từ máy tính bảng ở bất kỳ đâu trong cửa hàng. Tại sao chúng ta nên làm điều này? Khiếu nại chính về việc mua sắm tại các cửa hàng của chúng ta là phải chờ đợi trong những hàng dài để thanh toán. Rất nhiều cửa hàng của chúng ta có thể hưởng lợi từ việc này, nhưng tôi đã quyết định tiến hành chạy thử tại cửa hàng ở Center City Mall. Cho đến nay, đó là địa điểm bận rộn nhất của chúng ta.', '', '', 'e899fe92-b16e-4106-b3e8-64d79504148e', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('61627221-dfa2-4445-8c16-8e8bd1aa8fa6', 'ets-imported-test', 94, 4, 'listening', 'Why does the speaker say, “that’s our busiest location”?', 'To request some feedback', 'To compliment some staff', 'To express frustration', 'To justify a choice', 'D', 'Với tư cách là giám đốc bán hàng khu vực, tôi muốn tìm hiểu việc sử dụng hệ thống thanh toán hiện đại hơn trong các cửa hàng mỹ phẩm của chúng ta. Hệ thống này sẽ cho phép bất kỳ cộng tác viên bán hàng nào cũng có thể nhận thanh toán của khách hàng từ máy tính bảng ở bất kỳ đâu trong cửa hàng. Tại sao chúng ta nên làm điều này? Khiếu nại chính về việc mua sắm tại các cửa hàng của chúng ta là phải chờ đợi trong những hàng dài để thanh toán. Rất nhiều cửa hàng của chúng ta có thể hưởng lợi từ việc này, nhưng tôi đã quyết định tiến hành chạy thử tại cửa hàng ở Center City Mall. Cho đến nay, đó là địa điểm bận rộn nhất của chúng ta.', '', '', 'e899fe92-b16e-4106-b3e8-64d79504148e', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('5ddb0f76-913b-456a-9ae4-34a7202649b3', 'ets-imported-test', 95, 4, 'listening', 'According to the speaker, what is special about the Reston Office Tower?', 'It features an indoor garden.', 'It exhibits work from local artists.', 'It runs on solar power.', 'It has won many awards.', 'A', 'Trong tin tức địa phương, Tòa tháp văn phòng Reston ở trung tâm thành phố đã được hoàn thành. Đặc điểm phi thường nhất của tòa nhà là khu vườn xinh đẹp nằm trong sảnh đợi. Văn phòng quản lý của Reston đã xác nhận danh sách người thuê cho tòa nhà. Và chúng tôi đã phỏng vấn Giám đốc điều hành của Barnum Financial Services về văn phòng mới của họ. Ông cho biết ông và đội ngũ của mình rất hào hứng khi được chuyển đến vào tháng Giêng. Bản ghi âm toàn bộ cuộc phỏng vấn với CEO đã có trên trang web của chúng tôi.', '', '', '79d23969-8969-42f6-8fc8-b98afaad46c8', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('33e5f607-c542-4cf8-87d7-c3f8a900f35d', 'ets-imported-test', 96, 4, 'listening', 'Look at the graphic. Which floors will be occupied in January?', 'Floors 1–5', 'Floors 6–10', 'Floors 11–14', 'Floors 15–17', 'C', 'Trong tin tức địa phương, Tòa tháp văn phòng Reston ở trung tâm thành phố đã được hoàn thành. Đặc điểm phi thường nhất của tòa nhà là khu vườn xinh đẹp nằm trong sảnh đợi. Văn phòng quản lý của Reston đã xác nhận danh sách người thuê cho tòa nhà. Và chúng tôi đã phỏng vấn Giám đốc điều hành của Barnum Financial Services về văn phòng mới của họ. Ông cho biết ông và đội ngũ của mình rất hào hứng khi được chuyển đến vào tháng Giêng. Bản ghi âm toàn bộ cuộc phỏng vấn với CEO đã có trên trang web của chúng tôi.', '', '', '79d23969-8969-42f6-8fc8-b98afaad46c8', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('a2c17bc8-7d2f-4639-afb7-ea4bb67fb4cc', 'ets-imported-test', 97, 4, 'listening', 'What does the speaker say is available on a Web site?', 'Some photographs', 'An event schedule', 'A floor layout', 'A recorded interview', 'D', 'Trong tin tức địa phương, Tòa tháp văn phòng Reston ở trung tâm thành phố đã được hoàn thành. Đặc điểm phi thường nhất của tòa nhà là khu vườn xinh đẹp nằm trong sảnh đợi. Văn phòng quản lý của Reston đã xác nhận danh sách người thuê cho tòa nhà. Và chúng tôi đã phỏng vấn Giám đốc điều hành của Barnum Financial Services về văn phòng mới của họ. Ông cho biết ông và đội ngũ của mình rất hào hứng khi được chuyển đến vào tháng Giêng. Bản ghi âm toàn bộ cuộc phỏng vấn với CEO đã có trên trang web của chúng tôi.', '', '', '79d23969-8969-42f6-8fc8-b98afaad46c8', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('718a8ee0-0454-4147-a6c3-32c30e615446', 'ets-imported-test', 98, 4, 'listening', 'Who most likely are the listeners?', 'Safety engineers', 'Laboratory technicians', 'Legal consultants', 'Business investors', 'D', 'Chào buổi sáng và cảm ơn quý vị đã tham dự buổi họp dành cho các nhà đầu tư tiềm năng này. ZZ Mining đã lên kế hoạch mở rộng hoạt động của chúng tôi bằng cách mở thêm một mỏ bạc. Để tôi cho quý vị xem kết quả phân tích trong phòng thí nghiệm về hoạt động khoan thăm dò của chúng tôi. Trên màn hình, quý vị có thể thấy thông tin về quặng được chiết xuất từ các địa điểm khác nhau. Địa điểm có hàm lượng cao nhất có 410 gram bạc trên mỗi tấn quặng. Tuy nhiên, địa điểm có 390 gram mỗi tấn có trữ lượng lớn hơn, vì vậy đó là nơi chúng tôi sẽ xây dựng mỏ mới. Bước tiếp theo của chúng tôi là xin các giấy phép cần thiết. Chúng tôi sẽ thực hiện việc đó vào tuần tới.', '', '', 'e1620efc-b706-4c93-a665-32eaaf629638', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('515aec33-f327-434a-bb35-618d448e7380', 'ets-imported-test', 99, 4, 'listening', 'Look at the graphic. Where will a new mine be built?', 'At site 1', 'At site 2', 'At site 3', 'At site 4', 'C', 'Chào buổi sáng và cảm ơn quý vị đã tham dự buổi họp dành cho các nhà đầu tư tiềm năng này. ZZ Mining đã lên kế hoạch mở rộng hoạt động của chúng tôi bằng cách mở thêm một mỏ bạc. Để tôi cho quý vị xem kết quả phân tích trong phòng thí nghiệm về hoạt động khoan thăm dò của chúng tôi. Trên màn hình, quý vị có thể thấy thông tin về quặng được chiết xuất từ các địa điểm khác nhau. Địa điểm có hàm lượng cao nhất có 410 gram bạc trên mỗi tấn quặng. Tuy nhiên, địa điểm có 390 gram mỗi tấn có trữ lượng lớn hơn, vì vậy đó là nơi chúng tôi sẽ xây dựng mỏ mới. Bước tiếp theo của chúng tôi là xin các giấy phép cần thiết. Chúng tôi sẽ thực hiện việc đó vào tuần tới.', '', '', 'e1620efc-b706-4c93-a665-32eaaf629638', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('b26b5dea-1e59-42bc-9c16-c409c71d1b70', 'ets-imported-test', 100, 4, 'listening', 'What does the speaker say is the next step?', 'Applying for permits', 'Installing equipment', 'Hiring additional staff', 'Updating a manual', 'A', 'Chào buổi sáng và cảm ơn quý vị đã tham dự buổi họp dành cho các nhà đầu tư tiềm năng này. ZZ Mining đã lên kế hoạch mở rộng hoạt động của chúng tôi bằng cách mở thêm một mỏ bạc. Để tôi cho quý vị xem kết quả phân tích trong phòng thí nghiệm về hoạt động khoan thăm dò của chúng tôi. Trên màn hình, quý vị có thể thấy thông tin về quặng được chiết xuất từ các địa điểm khác nhau. Địa điểm có hàm lượng cao nhất có 410 gram bạc trên mỗi tấn quặng. Tuy nhiên, địa điểm có 390 gram mỗi tấn có trữ lượng lớn hơn, vì vậy đó là nơi chúng tôi sẽ xây dựng mỏ mới. Bước tiếp theo của chúng tôi là xin các giấy phép cần thiết. Chúng tôi sẽ thực hiện việc đó vào tuần tới.', '', '', 'e1620efc-b706-4c93-a665-32eaaf629638', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('302385d0-548a-46fb-8082-248b00347ef0', 'ets-imported-test', 101, 5, 'reading', 'The lecture will take place at 6:00 P.M, ------- which attendees may ask questions.', 'across', 'after', 'inside', 'among', 'B', 'Bài giảng sẽ diễn ra vào lúc 6:00 chiều, sau đó những người tham dự có thể đặt câu hỏi.', '', '', '', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('b96b766a-6bba-484f-87b5-c3c92a281345', 'ets-imported-test', 102, 5, 'reading', 'The ------- antique shop in Pepper Valley will close down next month.', 'last', 'lasts', 'lasted', 'lasting', 'A', 'Cửa hàng đồ cổ cuối cùng ở Pepper Valley sẽ đóng cửa vào tháng tới.', '', '', '', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('030f90c8-3e59-44ed-986e-921eb41ffc85', 'ets-imported-test', 103, 5, 'reading', 'Merryville residents will receive an online status ------- about the ongoing bridge construction project.', 'update', 'change', 'payment', 'request', 'A', 'Cư dân Merryville sẽ nhận được bản cập nhật trạng thái trực tuyến về dự án xây dựng cầu đang diễn ra.', '', '', '', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('c5152418-2035-41fb-aa7c-23f9a58afc46', 'ets-imported-test', 104, 5, 'reading', 'As a result of ------- many years leading media organizations, Ms. Ayo was selected for the Dowel Journalism Prize.', 'she', 'her', 'hers', 'herself', 'B', 'Nhờ kết quả của nhiều năm dẫn dắt các tổ chức truyền thông, bà Ayo đã được chọn cho Giải thưởng Báo chí Dowel.', '', '', '', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('4c9c83e3-2c4d-45ba-af7d-3f325147bf12', 'ets-imported-test', 105, 5, 'reading', 'To stop the ------- of computer viruses, do not open suspicious e-mails.', 'break', 'spread', 'balance', 'surface', 'B', 'Để ngăn chặn sự lây lan của virus máy tính, đừng mở các email khả nghi.', '', '', '', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('22ec8314-0ec2-440a-87f4-bda37a116bb6', 'ets-imported-test', 106, 5, 'reading', 'The hiring manager ------- considered each applicant''s résumé and qualifications.', 'caring', 'careful', 'carefully', 'carefulness', 'C', 'Nhà quản lý tuyển dụng đã xem xét cẩn thận sơ yếu lý lịch và năng lực của từng ứng viên.', '', '', '', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('533b8e41-94cb-44ec-bfc3-767e72c692aa', 'ets-imported-test', 107, 5, 'reading', 'In October, Mr. Sakamoto will leave for New Zealand ------- will oversee the opening of the new Auckland branch.', 'because', 'in addition', 'and', 'prior to', 'C', 'Vào tháng 10, ông Sakamoto sẽ đi New Zealand và sẽ giám sát việc khai trương chi nhánh Auckland mới.', '', '', '', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('78c96a8e-a769-4698-a9a9-709433ef07ae', 'ets-imported-test', 108, 5, 'reading', 'Tarateer Pharmaceuticals is varying its product ------- to include over-the-counter medications.', 'to line', 'lining', 'lined', 'line', 'D', 'Tarateer Pharmaceuticals đang đa dạng hóa dòng sản phẩm của mình để bao gồm cả các loại thuốc không kê đơn.', '', '', '', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('07d0ef40-1c07-4c1e-88f4-088dbc52d57d', 'ets-imported-test', 109, 5, 'reading', 'Dynart, Inc., continuously ------- new ways to reduce its use of plastics.', 'seeks', 'seeker', 'to seek', 'seeking', 'A', 'Dynart, Inc. liên tục tìm kiếm những cách mới để giảm việc sử dụng nhựa.', '', '', '', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('0c230165-7c57-4ed5-ad09-e10dba01f038', 'ets-imported-test', 110, 5, 'reading', 'The cash registers at Pirkle Books automatically ------- the remaining inventory of books available.', 'calculate', 'calculator', 'calculating', 'calculation', 'A', 'Máy tính tiền tại Pirkle Books tự động tính toán số lượng sách tồn kho còn lại hiện có.', '', '', '', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('43031f64-06dd-482d-ad7d-6ac817257acd', 'ets-imported-test', 111, 5, 'reading', 'The product team is designing mapping software that can ------- locate underground minerals.', 'infinitely', 'sincerely', 'precisely', 'greatly', 'C', 'Nhóm sản phẩm đang thiết kế phần mềm lập bản đồ có thể xác định chính xác vị trí các khoáng sản dưới lòng đất.', '', '', '', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('3d0baa22-db6c-4a46-94ce-60febf6412c0', 'ets-imported-test', 112, 5, 'reading', 'According to CEO Mayu Yamada, it would not be ------- responsible to expand the warehouse at this time.', 'finance', 'financials', 'financially', 'financing', 'C', 'Theo CEO Mayu Yamada, việc mở rộng kho hàng vào thời điểm này sẽ không có trách nhiệm về mặt tài chính.', '', '', '', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('bf68b3ba-f13e-4028-a857-e27baf73ba55', 'ets-imported-test', 113, 5, 'reading', 'Analysts cannot say with any ------- what the regional demand for electric trucks will be.', 'certainty', 'justice', 'excellence', 'denial', 'A', 'Các nhà phân tích không thể nói chắc chắn rằng nhu cầu khu vực đối với xe tải điện sẽ như thế nào.', '', '', '', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('9b78bd4a-1c51-4b18-ab32-b739d838410b', 'ets-imported-test', 114, 5, 'reading', 'As part of its marketing campaign, Elegancia Dishware is ------- soliciting feedback from customers.', 'lightly', 'loyally', 'actively', 'cleanly', 'C', 'Là một phần của chiến dịch tiếp thị, Elegancia Dishware đang tích cực trưng cầu ý kiến phản hồi từ khách hàng.', '', '', '', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('e7747a92-75eb-4ced-9ceb-937bd3066025', 'ets-imported-test', 115, 5, 'reading', 'Rain gardens are intended to ------- water to prevent flooding of local roads.', 'engage', 'undergo', 'absorb', 'overwhelm', 'C', 'Vườn mưa được thiết kế để hấp thụ nước nhằm ngăn chặn tình trạng ngập lụt các tuyến đường địa phương.', '', '', '', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('d64891f6-d85c-402b-b77c-c8f8d74f39e6', 'ets-imported-test', 116, 5, 'reading', 'Theta Industries'' training program aims to increase the ------- of its manufacturing systems.', 'producer', 'produced', 'productive', 'productivity', 'D', 'Chương trình đào tạo của Theta Industries nhằm mục đích tăng năng suất của các hệ thống sản xuất của mình.', '', '', '', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('c2a7a3a2-a903-4f8f-8b63-595f57455d2b', 'ets-imported-test', 117, 5, 'reading', 'The board of directors has voted to award Mr. Mitrakos a bonus for his role ------- obtaining the international contract.', 'in', 'at', 'except', 'apart', 'A', 'Hội đồng quản trị đã bỏ phiếu trao thưởng cho ông Mitrakos một khoản tiền thưởng vì vai trò của ông trong việc đạt được hợp đồng quốc tế.', '', '', '', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('e860f9ad-66d5-418e-ae69-ff682136bdef', 'ets-imported-test', 118, 5, 'reading', 'The finance director gave his approval ------- the project can move forward.', 'along', 'furthermore', 'cautiously', 'so that', 'D', 'Giám đốc tài chính đã đưa ra sự phê duyệt để dự án có thể tiến triển.', '', '', '', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('d400c376-75f5-4073-a7b7-e15c25269afb', 'ets-imported-test', 119, 5, 'reading', 'The newspaper article describes ways job seekers can ------- for having little workplace experience.', 'reply', 'capture', 'compensate', 'accumulate', 'C', 'Bài báo trên báo mô tả những cách mà người tìm việc có thể bù đắp cho việc có ít kinh nghiệm làm việc.', '', '', '', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('920d6631-ae0a-4610-8fce-fec6eb71f0c4', 'ets-imported-test', 120, 5, 'reading', 'Mr. Ellis and Ms. Barnes were both highly qualified, but ------- got the job.', 'myself', 'neither', 'anybody', 'whoever', 'B', 'Cả ông Ellis và bà Barnes đều rất có năng lực, nhưng không ai trong số họ nhận được công việc.', '', '', '', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('960ae362-7796-46ab-9cd9-8860cd602a33', 'ets-imported-test', 121, 5, 'reading', 'Ennis Photography purchased all new lighting equipment ------- the high cost.', 'even though', 'however', 'until', 'despite', 'D', 'Ennis Photography đã mua tất cả thiết bị chiếu sáng mới bất chấp chi phí cao.', '', '', '', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('8c81538f-2323-419d-8281-1206e67d8e1b', 'ets-imported-test', 122, 5, 'reading', 'Marburton residents who wish to ------- a home should contact the award-winning team at Kwan Real Estate.', 'seller', 'sold', 'sell', 'selling', 'C', 'Những cư dân Marburton muốn bán nhà nên liên hệ với đội ngũ từng đoạt giải thưởng tại Kwan Real Estate.', '', '', '', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('e403a570-8baa-4085-a2a3-8935ed2f0969', 'ets-imported-test', 123, 5, 'reading', 'Maswa Bistro began a ------- agreement with local farmers to purchase a set amount of produce each week.', 'disruptive', 'cooperative', 'grateful', 'concerned', 'B', 'Maswa Bistro đã bắt đầu một thỏa thuận hợp tác với các nông dân địa phương để mua một lượng nông sản nhất định mỗi tuần.', '', '', '', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('2d14e9d5-a303-47ec-a0f3-df0796ddfb51', 'ets-imported-test', 124, 5, 'reading', 'The City of Doyle''s new downtown parking ------- have been met with opposition by residents and visitors.', 'restricts', 'restricted', 'restrictions', 'restricting', 'C', 'Các quy định hạn chế đậu xe mới ở trung tâm thành phố Doyle đã vấp phải sự phản đối của cư dân và du khách.', '', '', '', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('25587af6-5c4a-48f3-be1e-7abc5115a25d', 'ets-imported-test', 125, 5, 'reading', 'The plumbing position requires extensive training, even for those who studied ------- in technical school.', 'diligently', 'scientifically', 'objectively', 'decidedly', 'A', 'Vị trí thợ sửa ống nước yêu cầu đào tạo chuyên sâu, ngay cả đối với những người đã học tập chăm chỉ ở trường kỹ thuật.', '', '', '', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('bb326537-a9ad-45d0-ae1e-fcc634a95522', 'ets-imported-test', 126, 5, 'reading', 'With its fixed price -------, Omega Cellular guarantees no phone bill increases for three years.', 'assurance', 'assuredly', 'assuring', 'assures', 'A', 'Với sự đảm bảo về giá cố định, Omega Cellular cam kết không tăng hóa đơn điện thoại trong ba năm.', '', '', '', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('1b852710-5194-40cd-b5d5-13535ad5e1ae', 'ets-imported-test', 127, 5, 'reading', 'As chief analytics officer, Mr. Ko has worked at Lochston Ltd. with great ------- for more than twenty years.', 'deduction', 'duplication', 'declaration', 'dedication', 'D', 'Với tư cách là giám đốc phân tích, ông Ko đã làm việc tại Lochston Ltd. với sự cống hiến to lớn trong hơn hai mươi năm.', '', '', '', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('8e924fd6-8bcb-4028-a85a-efaa3113b65f', 'ets-imported-test', 128, 5, 'reading', 'Milltown Hospital''s cafeteria serves lunch seven days a week ------- only on weekdays.', 'up to', 'as though', 'each time', 'rather than', 'D', 'Nhà ăn của Bệnh viện Milltown phục vụ bữa trưa bảy ngày một tuần thay vì chỉ vào các ngày trong tuần.', '', '', '', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('834ab52b-91d3-4393-a765-bdf347f9123c', 'ets-imported-test', 129, 5, 'reading', 'The store''s entire inventory of lumber comes from a nearby ------- supplier.', 'financial', 'promotional', 'chemical', 'commercial', 'D', 'Toàn bộ lượng gỗ dự trữ của cửa hàng đến từ một nhà cung cấp thương mại gần đó.', '', '', '', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('3c89cc37-c98f-4352-bf1a-e0c56a807ac8', 'ets-imported-test', 130, 5, 'reading', 'For a $95 ------- fee, our mechanics will determine what repairs are needed.', 'diagnosed', 'diagnostic', 'diagnosable', 'diagnose', 'B', 'Với mức phí chẩn đoán 95 đô la, các thợ máy của chúng tôi sẽ xác định những sửa chữa nào là cần thiết.', '', '', '', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('27556146-0637-4ce4-b40c-c6fe845b652d', 'ets-imported-test', 131, 6, 'reading', 'Questions 131-134 refer to the following flyer.', 'Staff members have written articles for the local newspaper.', 'Installing lights can enhance the effect of a well-designed garden.', 'Local competitors cannot beat the prices we charge.', 'Riessler Landscaping''s goal is to make your vision a reality.', 'D', 'Hãy tìm đến Riessler Landscaping cho các nhu cầu về khu vườn của bạn

Riessler Landscaping có mọi thứ bạn cần để tạo ra khu vườn mơ ước. Chúng tôi sẽ lắng nghe ý tưởng của bạn và đưa ra những gợi ý phù hợp với mong muốn làm vườn của bạn. Mục tiêu của Riessler Landscaping là biến tầm nhìn của bạn thành hiện thực. Vườn ươm tại đây bao gồm nhiều loại cây với kích cỡ khác nhau, bùng nổ với màu sắc bắt mắt quanh năm. Bạn chắc chắn sẽ tìm thấy thứ gì đó giúp tăng thêm vẻ đẹp cho khu vườn của mình. Chúng tôi cũng được trang bị đầy đủ để xây dựng các hồ nhỏ hoặc các tính năng nước khác. Và như tên gọi của mình, chúng tôi có thể đảm nhận các dự án cảnh quan đầy tham vọng hơn — bất cứ điều gì bạn cần! Với hơn 40 năm kinh nghiệm, chuyên môn của chúng tôi là không đối thủ.', '', '', '4d838179-03dc-445b-81ce-71bd6d13620a', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('046ddc8f-ffae-4e3a-b6d2-c8a1c85e8d3a', 'ets-imported-test', 132, 6, 'reading', 'Questions 131-134 refer to the following flyer.', 'years', 'space', 'beauty', 'moisture', 'C', 'Hãy tìm đến Riessler Landscaping cho các nhu cầu về khu vườn của bạn

Riessler Landscaping có mọi thứ bạn cần để tạo ra khu vườn mơ ước. Chúng tôi sẽ lắng nghe ý tưởng của bạn và đưa ra những gợi ý phù hợp với mong muốn làm vườn của bạn. Mục tiêu của Riessler Landscaping là biến tầm nhìn của bạn thành hiện thực. Vườn ươm tại đây bao gồm nhiều loại cây với kích cỡ khác nhau, bùng nổ với màu sắc bắt mắt quanh năm. Bạn chắc chắn sẽ tìm thấy thứ gì đó giúp tăng thêm vẻ đẹp cho khu vườn của mình. Chúng tôi cũng được trang bị đầy đủ để xây dựng các hồ nhỏ hoặc các tính năng nước khác. Và như tên gọi của mình, chúng tôi có thể đảm nhận các dự án cảnh quan đầy tham vọng hơn — bất cứ điều gì bạn cần! Với hơn 40 năm kinh nghiệm, chuyên môn của chúng tôi là không đối thủ.', '', '', '4d838179-03dc-445b-81ce-71bd6d13620a', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('ed3483c8-7e16-4522-8efc-60ab60ad69e0', 'ets-imported-test', 133, 6, 'reading', 'Questions 131-134 refer to the following flyer.', 'also', 'rarely', 'somehow', 'nevertheless', 'A', 'Hãy tìm đến Riessler Landscaping cho các nhu cầu về khu vườn của bạn

Riessler Landscaping có mọi thứ bạn cần để tạo ra khu vườn mơ ước. Chúng tôi sẽ lắng nghe ý tưởng của bạn và đưa ra những gợi ý phù hợp với mong muốn làm vườn của bạn. Mục tiêu của Riessler Landscaping là biến tầm nhìn của bạn thành hiện thực. Vườn ươm tại đây bao gồm nhiều loại cây với kích cỡ khác nhau, bùng nổ với màu sắc bắt mắt quanh năm. Bạn chắc chắn sẽ tìm thấy thứ gì đó giúp tăng thêm vẻ đẹp cho khu vườn của mình. Chúng tôi cũng được trang bị đầy đủ để xây dựng các hồ nhỏ hoặc các tính năng nước khác. Và như tên gọi của mình, chúng tôi có thể đảm nhận các dự án cảnh quan đầy tham vọng hơn — bất cứ điều gì bạn cần! Với hơn 40 năm kinh nghiệm, chuyên môn của chúng tôi là không đối thủ.', '', '', '4d838179-03dc-445b-81ce-71bd6d13620a', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('ddc833ef-42e3-46f8-98cf-53e061d78f17', 'ets-imported-test', 134, 6, 'reading', 'Questions 131-134 refer to the following flyer.', 'its', 'our', 'others', 'their', 'B', 'Hãy tìm đến Riessler Landscaping cho các nhu cầu về khu vườn của bạn

Riessler Landscaping có mọi thứ bạn cần để tạo ra khu vườn mơ ước. Chúng tôi sẽ lắng nghe ý tưởng của bạn và đưa ra những gợi ý phù hợp với mong muốn làm vườn của bạn. Mục tiêu của Riessler Landscaping là biến tầm nhìn của bạn thành hiện thực. Vườn ươm tại đây bao gồm nhiều loại cây với kích cỡ khác nhau, bùng nổ với màu sắc bắt mắt quanh năm. Bạn chắc chắn sẽ tìm thấy thứ gì đó giúp tăng thêm vẻ đẹp cho khu vườn của mình. Chúng tôi cũng được trang bị đầy đủ để xây dựng các hồ nhỏ hoặc các tính năng nước khác. Và như tên gọi của mình, chúng tôi có thể đảm nhận các dự án cảnh quan đầy tham vọng hơn — bất cứ điều gì bạn cần! Với hơn 40 năm kinh nghiệm, chuyên môn của chúng tôi là không đối thủ.', '', '', '4d838179-03dc-445b-81ce-71bd6d13620a', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('4551cabf-e3f7-4d17-a2c8-6d99ba55d859', 'ets-imported-test', 135, 6, 'reading', 'Questions 135-138 refer to the following letter.', 'We especially value our long-term customers.', 'Please join our holiday celebration.', 'Our annual report will be released soon.', 'You have been a valuable member of our team.', 'D', 'Ngày 10 tháng 1

Thân gửi bà Mulligan,

Chúng tôi rất vui mừng được kỷ niệm 30 năm làm việc của bà tại Trung tâm Phân phối Brandrix. Bà đã là một thành viên quý giá trong đội ngũ của chúng tôi. Sự tận tụy, lòng trung thành và sự chăm chỉ của bà đã đóng góp rất lớn vào thành công của chúng tôi trong những năm qua. Chúng tôi trân trọng cam kết của bà đối với sự xuất sắc. Trong suốt những năm qua, bà đã thể hiện sự chủ động, sáng tạo và khả năng lãnh đạo tuyệt vời. Bà sẽ sớm nhận được một bảng kỷ niệm chương qua đường bưu điện. Chúng tôi hy vọng món quà tri ân này sẽ nhắc nhở bà rằng bà có ý nghĩa như thế nào đối với chúng tôi. Chúc mừng bà đã đạt được cột mốc này.', '', '', 'e2b2732c-7f34-45c3-b902-4f5de0e934fc', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('857990c8-cafc-4d30-945a-d3bd6eb77a4f', 'ets-imported-test', 136, 6, 'reading', 'Questions 135-138 refer to the following letter.', 'will show', 'must show', 'have shown', 'are showing', 'C', 'Ngày 10 tháng 1

Thân gửi bà Mulligan,

Chúng tôi rất vui mừng được kỷ niệm 30 năm làm việc của bà tại Trung tâm Phân phối Brandrix. Bà đã là một thành viên quý giá trong đội ngũ của chúng tôi. Sự tận tụy, lòng trung thành và sự chăm chỉ của bà đã đóng góp rất lớn vào thành công của chúng tôi trong những năm qua. Chúng tôi trân trọng cam kết của bà đối với sự xuất sắc. Trong suốt những năm qua, bà đã thể hiện sự chủ động, sáng tạo và khả năng lãnh đạo tuyệt vời. Bà sẽ sớm nhận được một bảng kỷ niệm chương qua đường bưu điện. Chúng tôi hy vọng món quà tri ân này sẽ nhắc nhở bà rằng bà có ý nghĩa như thế nào đối với chúng tôi. Chúc mừng bà đã đạt được cột mốc này.', '', '', 'e2b2732c-7f34-45c3-b902-4f5de0e934fc', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('3257f937-81c0-4cb5-9e64-1bf9be1bb089', 'ets-imported-test', 137, 6, 'reading', 'Questions 135-138 refer to the following letter.', 'then', 'soon', 'instead', 'likewise', 'B', 'Ngày 10 tháng 1

Thân gửi bà Mulligan,

Chúng tôi rất vui mừng được kỷ niệm 30 năm làm việc của bà tại Trung tâm Phân phối Brandrix. Bà đã là một thành viên quý giá trong đội ngũ của chúng tôi. Sự tận tụy, lòng trung thành và sự chăm chỉ của bà đã đóng góp rất lớn vào thành công của chúng tôi trong những năm qua. Chúng tôi trân trọng cam kết của bà đối với sự xuất sắc. Trong suốt những năm qua, bà đã thể hiện sự chủ động, sáng tạo và khả năng lãnh đạo tuyệt vời. Bà sẽ sớm nhận được một bảng kỷ niệm chương qua đường bưu điện. Chúng tôi hy vọng món quà tri ân này sẽ nhắc nhở bà rằng bà có ý nghĩa như thế nào đối với chúng tôi. Chúc mừng bà đã đạt được cột mốc này.', '', '', 'e2b2732c-7f34-45c3-b902-4f5de0e934fc', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('9fd8a410-d7e1-4da6-9663-e41c0643b828', 'ets-imported-test', 138, 6, 'reading', 'Questions 135-138 refer to the following letter.', 'milestone', 'consensus', 'destination', 'understanding', 'A', 'Ngày 10 tháng 1

Thân gửi bà Mulligan,

Chúng tôi rất vui mừng được kỷ niệm 30 năm làm việc của bà tại Trung tâm Phân phối Brandrix. Bà đã là một thành viên quý giá trong đội ngũ của chúng tôi. Sự tận tụy, lòng trung thành và sự chăm chỉ của bà đã đóng góp rất lớn vào thành công của chúng tôi trong những năm qua. Chúng tôi trân trọng cam kết của bà đối với sự xuất sắc. Trong suốt những năm qua, bà đã thể hiện sự chủ động, sáng tạo và khả năng lãnh đạo tuyệt vời. Bà sẽ sớm nhận được một bảng kỷ niệm chương qua đường bưu điện. Chúng tôi hy vọng món quà tri ân này sẽ nhắc nhở bà rằng bà có ý nghĩa như thế nào đối với chúng tôi. Chúc mừng bà đã đạt được cột mốc này.', '', '', 'e2b2732c-7f34-45c3-b902-4f5de0e934fc', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('d9ae999c-2431-46b4-bc58-a6cdbd8e718b', 'ets-imported-test', 139, 6, 'reading', 'Questions 139-142 refer to the following e-mail.', 'finalizing', 'finalize', 'finalized', 'finalizes', 'A', 'Người nhận: Kay Berman

Người gửi: Ali Chaleby

Ngày: 21 tháng 8

Chủ đề: Kế hoạch cho phòng khách

Thân gửi bà Berman, đội ngũ thiết kế của tôi đang trong quá trình hoàn tất các bản kế hoạch cho phòng khách của bà. Dựa trên cuộc trò chuyện cuối cùng của chúng ta, tôi đã chọn các loại sơn khác nhau cho tường và viền. Vui lòng xem tệp đính kèm và quyết định xem bà có thích những màu sắc mới đó không. Nếu không, vẫn chưa quá muộn để thay đổi. Chúng tôi dự định sẽ không bắt đầu công việc trong vòng hai tuần tới. Đánh giá của bà sẽ giúp chúng tôi hoàn thiện thiết kế trước khi bắt đầu. Vui lòng cho tôi biết nếu bà có bất kỳ câu hỏi nào. Tôi mong sớm nhận được phản hồi từ bà.', '', '', 'f1b710e4-d37a-4eed-a97a-6ff0a4b11842', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('2a1c42d8-2539-46f3-8b05-6deea1755a38', 'ets-imported-test', 140, 6, 'reading', 'Questions 139-142 refer to the following e-mail.', 'organizations', 'schedules', 'colors', 'times', 'C', 'Người nhận: Kay Berman

Người gửi: Ali Chaleby

Ngày: 21 tháng 8

Chủ đề: Kế hoạch cho phòng khách

Thân gửi bà Berman, đội ngũ thiết kế của tôi đang trong quá trình hoàn tất các bản kế hoạch cho phòng khách của bà. Dựa trên cuộc trò chuyện cuối cùng của chúng ta, tôi đã chọn các loại sơn khác nhau cho tường và viền. Vui lòng xem tệp đính kèm và quyết định xem bà có thích những màu sắc mới đó không. Nếu không, vẫn chưa quá muộn để thay đổi. Chúng tôi dự định sẽ không bắt đầu công việc trong vòng hai tuần tới. Đánh giá của bà sẽ giúp chúng tôi hoàn thiện thiết kế trước khi bắt đầu. Vui lòng cho tôi biết nếu bà có bất kỳ câu hỏi nào. Tôi mong sớm nhận được phản hồi từ bà.', '', '', 'f1b710e4-d37a-4eed-a97a-6ff0a4b11842', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('86ae1b6e-2248-4145-b02d-ba1cbb8ab0a4', 'ets-imported-test', 141, 6, 'reading', 'Questions 139-142 refer to the following e-mail.', 'I have already begun drawing up plans for your kitchen.', 'We are not planning to begin work for another two weeks.', 'Your living room is particularly spacious and airy.', 'We have not yet received your current payment.', 'B', 'Người nhận: Kay Berman

Người gửi: Ali Chaleby

Ngày: 21 tháng 8

Chủ đề: Kế hoạch cho phòng khách

Thân gửi bà Berman, đội ngũ thiết kế của tôi đang trong quá trình hoàn tất các bản kế hoạch cho phòng khách của bà. Dựa trên cuộc trò chuyện cuối cùng của chúng ta, tôi đã chọn các loại sơn khác nhau cho tường và viền. Vui lòng xem tệp đính kèm và quyết định xem bà có thích những màu sắc mới đó không. Nếu không, vẫn chưa quá muộn để thay đổi. Chúng tôi dự định sẽ không bắt đầu công việc trong vòng hai tuần tới. Đánh giá của bà sẽ giúp chúng tôi hoàn thiện thiết kế trước khi bắt đầu. Vui lòng cho tôi biết nếu bà có bất kỳ câu hỏi nào. Tôi mong sớm nhận được phản hồi từ bà.', '', '', 'f1b710e4-d37a-4eed-a97a-6ff0a4b11842', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('562d62a0-6c5c-40fe-9eaa-0471454b488d', 'ets-imported-test', 142, 6, 'reading', 'Questions 139-142 refer to the following e-mail.', 'them', 'ours', 'his', 'me', 'D', 'Người nhận: Kay Berman

Người gửi: Ali Chaleby

Ngày: 21 tháng 8

Chủ đề: Kế hoạch cho phòng khách

Thân gửi bà Berman, đội ngũ thiết kế của tôi đang trong quá trình hoàn tất các bản kế hoạch cho phòng khách của bà. Dựa trên cuộc trò chuyện cuối cùng của chúng ta, tôi đã chọn các loại sơn khác nhau cho tường và viền. Vui lòng xem tệp đính kèm và quyết định xem bà có thích những màu sắc mới đó không. Nếu không, vẫn chưa quá muộn để thay đổi. Chúng tôi dự định sẽ không bắt đầu công việc trong vòng hai tuần tới. Đánh giá của bà sẽ giúp chúng tôi hoàn thiện thiết kế trước khi bắt đầu. Vui lòng cho tôi biết nếu bà có bất kỳ câu hỏi nào. Tôi mong sớm nhận được phản hồi từ bà.', '', '', 'f1b710e4-d37a-4eed-a97a-6ff0a4b11842', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('376ca3cf-24d7-42be-a694-3cbe95c64707', 'ets-imported-test', 143, 6, 'reading', 'Questions 143-146 refer to the following e-mail.', 'satisfied', 'satisfaction', 'satisfactory', 'satisfactorily', 'C', 'Thân gửi bà Zalen, cảm ơn bà đã đến thăm Phòng khám Đa khoa Kaymar gần đây. Chúng tôi hy vọng bà thấy dịch vụ của chúng tôi thỏa đáng, và chúng tôi hoan nghênh các ý kiến đóng góp để cải thiện.

Chúng tôi đã đăng một bản tóm tắt về cuộc tư vấn của bà trên cổng thông tin. Vui lòng dành chút thời gian xem qua và cho chúng tôi biết nếu bà có thắc mắc. Như một lời nhắc nhở, bà có thể đăng nhập cổng thông tin cho nhiều hoạt động khác nhau. Chẳng hạn, bà có thể đặt lịch hẹn và thanh toán, xem lịch sử y tế, kiểm tra kết quả xét nghiệm và yêu cầu cấp lại thuốc. Chúng tôi hy vọng bà sẽ sử dụng nguồn tài nguyên này để quản lý nhu cầu sức khỏe của mình. Hãy yên tâm rằng thông tin cá nhân của bà luôn được an toàn.', '', '', '0e05dc71-5acf-4cf8-8bf3-50897d0d7ef8', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('b579c7e4-a440-4e83-9067-02b3563dc4cf', 'ets-imported-test', 144, 6, 'reading', 'Questions 143-146 refer to the following e-mail.', 'photo', 'lecture', 'summary', 'schedule', 'C', 'Thân gửi bà Zalen, cảm ơn bà đã đến thăm Phòng khám Đa khoa Kaymar gần đây. Chúng tôi hy vọng bà thấy dịch vụ của chúng tôi thỏa đáng, và chúng tôi hoan nghênh các ý kiến đóng góp để cải thiện.

Chúng tôi đã đăng một bản tóm tắt về cuộc tư vấn của bà trên cổng thông tin. Vui lòng dành chút thời gian xem qua và cho chúng tôi biết nếu bà có thắc mắc. Như một lời nhắc nhở, bà có thể đăng nhập cổng thông tin cho nhiều hoạt động khác nhau. Chẳng hạn, bà có thể đặt lịch hẹn và thanh toán, xem lịch sử y tế, kiểm tra kết quả xét nghiệm và yêu cầu cấp lại thuốc. Chúng tôi hy vọng bà sẽ sử dụng nguồn tài nguyên này để quản lý nhu cầu sức khỏe của mình. Hãy yên tâm rằng thông tin cá nhân của bà luôn được an toàn.', '', '', '0e05dc71-5acf-4cf8-8bf3-50897d0d7ef8', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('8a118343-cddc-4c12-a06a-3f070265be18', 'ets-imported-test', 145, 6, 'reading', 'Questions 143-146 refer to the following e-mail.', 'To repeat', 'For instance', 'Otherwise', 'Consequently', 'B', 'Thân gửi bà Zalen, cảm ơn bà đã đến thăm Phòng khám Đa khoa Kaymar gần đây. Chúng tôi hy vọng bà thấy dịch vụ của chúng tôi thỏa đáng, và chúng tôi hoan nghênh các ý kiến đóng góp để cải thiện.

Chúng tôi đã đăng một bản tóm tắt về cuộc tư vấn của bà trên cổng thông tin. Vui lòng dành chút thời gian xem qua và cho chúng tôi biết nếu bà có thắc mắc. Như một lời nhắc nhở, bà có thể đăng nhập cổng thông tin cho nhiều hoạt động khác nhau. Chẳng hạn, bà có thể đặt lịch hẹn và thanh toán, xem lịch sử y tế, kiểm tra kết quả xét nghiệm và yêu cầu cấp lại thuốc. Chúng tôi hy vọng bà sẽ sử dụng nguồn tài nguyên này để quản lý nhu cầu sức khỏe của mình. Hãy yên tâm rằng thông tin cá nhân của bà luôn được an toàn.', '', '', '0e05dc71-5acf-4cf8-8bf3-50897d0d7ef8', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('12b50796-42b6-4af5-b03d-c00d36e7ea0a', 'ets-imported-test', 146, 6, 'reading', 'Questions 143-146 refer to the following e-mail.', 'We hope you will use this resource to manage your health-care needs.', 'The staff will close the office early on Friday afternoons.', 'Please be sure to come to our office fifteen minutes in advance.', 'We apologize for any confusion about your appointment time.', 'A', 'Thân gửi bà Zalen, cảm ơn bà đã đến thăm Phòng khám Đa khoa Kaymar gần đây. Chúng tôi hy vọng bà thấy dịch vụ của chúng tôi thỏa đáng, và chúng tôi hoan nghênh các ý kiến đóng góp để cải thiện.

Chúng tôi đã đăng một bản tóm tắt về cuộc tư vấn của bà trên cổng thông tin. Vui lòng dành chút thời gian xem qua và cho chúng tôi biết nếu bà có thắc mắc. Như một lời nhắc nhở, bà có thể đăng nhập cổng thông tin cho nhiều hoạt động khác nhau. Chẳng hạn, bà có thể đặt lịch hẹn và thanh toán, xem lịch sử y tế, kiểm tra kết quả xét nghiệm và yêu cầu cấp lại thuốc. Chúng tôi hy vọng bà sẽ sử dụng nguồn tài nguyên này để quản lý nhu cầu sức khỏe của mình. Hãy yên tâm rằng thông tin cá nhân của bà luôn được an toàn.', '', '', '0e05dc71-5acf-4cf8-8bf3-50897d0d7ef8', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('c90f54ad-fc05-4c8f-be0a-5ffc3d478000', 'ets-imported-test', 147, 7, 'reading', 'What is the purpose of the notice?', 'To invite residents to a meeting on May 3', 'To request feedback about parking facilities', 'To inform residents of an upcoming project', 'To announce an increase in parking fees', 'C', 'Thân gửi cư dân Chung cư High View,

Công ty Trải nhựa Riverside sẽ đến Chung cư High View vào ngày 3 và 4 tháng 5 để trải lại bề mặt khu vực bãi đậu xe. Tất cả các phương tiện phải được di dời trước 8 giờ sáng ngày 3 tháng 5 để công việc được bắt đầu. Cư dân có thể sử dụng lại bãi đậu xe bắt đầu từ 8 giờ sáng ngày 5 tháng 5. Chúng tôi nhận thấy rằng việc cố gắng tìm một nơi khác để đậu xe là bất tiện, nhưng điều này là cần thiết để công việc được hoàn thành trong hai ngày theo kế hoạch. Lưu ý rằng tất cả các chỗ đậu xe sẽ được mở rộng, và một số chỗ có thể bị thay đổi vị trí trong quá trình làm việc. Bạn sẽ nhận được email nếu chỗ đậu xe của bạn bị di chuyển hơn 20 mét so với chỗ cũ.

Cảm ơn sự hợp tác của bạn,

Judith Alvarez, Quản lý tài sản', '', '', '57863889-edbf-4fe8-8621-720c4f7a69b9', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('02d08851-349f-4814-addb-cc2db888216c', 'ets-imported-test', 148, 7, 'reading', 'What is suggested about High View Apartments?', 'It charges residents a monthly maintenance fee.', 'It recently hired a new property manager.', 'It has the parking area repaved every year.', 'It assigns tenants specific parking spots.', 'D', 'Thân gửi cư dân Chung cư High View,

Công ty Trải nhựa Riverside sẽ đến Chung cư High View vào ngày 3 và 4 tháng 5 để trải lại bề mặt khu vực bãi đậu xe. Tất cả các phương tiện phải được di dời trước 8 giờ sáng ngày 3 tháng 5 để công việc được bắt đầu. Cư dân có thể sử dụng lại bãi đậu xe bắt đầu từ 8 giờ sáng ngày 5 tháng 5. Chúng tôi nhận thấy rằng việc cố gắng tìm một nơi khác để đậu xe là bất tiện, nhưng điều này là cần thiết để công việc được hoàn thành trong hai ngày theo kế hoạch. Lưu ý rằng tất cả các chỗ đậu xe sẽ được mở rộng, và một số chỗ có thể bị thay đổi vị trí trong quá trình làm việc. Bạn sẽ nhận được email nếu chỗ đậu xe của bạn bị di chuyển hơn 20 mét so với chỗ cũ.

Cảm ơn sự hợp tác của bạn,

Judith Alvarez, Quản lý tài sản', '', '', '57863889-edbf-4fe8-8621-720c4f7a69b9', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('951395a4-ac7f-42ef-aa2d-4ff30ba41d5c', 'ets-imported-test', 149, 7, 'reading', 'What most likely is Ms. Seang’s job?', 'Glassmaker', 'Art instructor', 'Beach lifeguard', 'Program administrator', 'B', 'Carol Barger (10:45 sáng)

Xin chào, cô Seang.

Leakhena Seang (10:55 sáng)

Chào buổi sáng!

Carol Barger (11:15 sáng)

Chúng tôi có mười lăm người đăng ký tham gia hội thảo khảm của cô vào ngày mai. Con số đó nhiều hơn năm người so với mùa hè năm ngoái. Hội thảo của cô ngày càng trở nên phổ biến hơn qua mỗi năm! Cô có đủ nguyên liệu cho ngần ấy người tham gia không?

Leakhena Seang (11:23 sáng)

Tôi có dư dả cho mọi người. Chúng ta sẽ tạo ra các thiết kế khảm bằng những mảnh thủy tinh biển mà tôi đã thu thập được trong kỳ nghỉ hè năm ngoái. Chúng là những mảnh chai lọ màu nâu, xanh lá cây và xanh dương dạt vào bãi biển. Cát đã làm nhẵn tất cả các cạnh sắc, vì vậy chúng hoàn toàn an toàn cho mọi người sử dụng.

Carol Barger (11:30 sáng)

Nghe có vẻ hay đấy. Hẹn gặp cô vào bữa sáng mai.', '', '', '44042b04-b2c7-4d37-949f-41596b4f2341', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('ed6294eb-bb43-4327-9762-cd623b2ee911', 'ets-imported-test', 150, 7, 'reading', 'At 11:23 A.M., what does Ms. Seang imply when she writes, “I have plenty to go around”?', 'She intends to create an extra-large mosaic.', 'She has been collecting sea glass for many years.', 'She can share her sea glass with all the workshop participants.', 'She does not think she will use much of her sea glass.', 'C', 'Carol Barger (10:45 sáng)

Xin chào, cô Seang.

Leakhena Seang (10:55 sáng)

Chào buổi sáng!

Carol Barger (11:15 sáng)

Chúng tôi có mười lăm người đăng ký tham gia hội thảo khảm của cô vào ngày mai. Con số đó nhiều hơn năm người so với mùa hè năm ngoái. Hội thảo của cô ngày càng trở nên phổ biến hơn qua mỗi năm! Cô có đủ nguyên liệu cho ngần ấy người tham gia không?

Leakhena Seang (11:23 sáng)

Tôi có dư dả cho mọi người. Chúng ta sẽ tạo ra các thiết kế khảm bằng những mảnh thủy tinh biển mà tôi đã thu thập được trong kỳ nghỉ hè năm ngoái. Chúng là những mảnh chai lọ màu nâu, xanh lá cây và xanh dương dạt vào bãi biển. Cát đã làm nhẵn tất cả các cạnh sắc, vì vậy chúng hoàn toàn an toàn cho mọi người sử dụng.

Carol Barger (11:30 sáng)

Nghe có vẻ hay đấy. Hẹn gặp cô vào bữa sáng mai.', '', '', '44042b04-b2c7-4d37-949f-41596b4f2341', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('85f0fa75-3f9a-4c90-ae41-a4c01bbe7175', 'ets-imported-test', 151, 7, 'reading', 'What is mentioned about Mr. Norton?', 'He will be attending a sales conference.', 'He sent Ms. Correa an office supply request.', 'He wrote an article in the September newsletter.', 'He will be moving to another company location.', 'D', 'Gửi: Đội ngũ bán hàng

Từ: Laura Correa

Ngày: 5 tháng 10

Chủ đề: Cập nhật

Thân gửi cả đội,

Như đã thông báo trong bản tin tháng 9 của Brighter Sails, hiệu suất của chúng ta đã duy trì ở mức mạnh mẽ trong năm nay. Đây là một thành tích mà tất cả chúng ta có thể tự hào. Hãy dành chút thời gian để chúc mừng lẫn nhau. Chúng ta sẽ tiếp tục mơ về những kế hoạch mới và thú vị cho tương lai!

Trong một tin tức khác, Jasen Norton sẽ chuyển đến trụ sở chính ở Kingston của chúng ta vào tháng tới. Chúng tôi rất buồn khi mất đi ông Norton, nhưng chúng tôi biết ơn và ghi nhận công việc xuất sắc của ông và chúc ông tiếp tục thành công trong vai trò mới.

Sẽ có một bữa tiệc trưa chia tay ông Norton vào ngày 28 tháng 10 lúc 1:00 chiều tại phòng họp tầng hai. Hãy mang theo sự vui vẻ và có lẽ là một câu chuyện để chia sẻ. Công ty sẽ cung cấp bữa trưa, bánh ngọt và đồ trang trí. Hãy cho tôi biết trước ngày 12 tháng 10 liệu bạn có thể tham gia hay không.

Trân trọng,

Laura Correa, Quản lý bán hàng

Brighter Sails Ltd.', '', '', '9d1192d0-16f0-4c5b-981d-29d0bc5762a0', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('8b1dd45d-63a2-40cc-8b5a-c05b05f50df4', 'ets-imported-test', 152, 7, 'reading', 'What does Ms. Correa ask members of the sales team to do?', 'Send her stories for a newsletter', 'Give her names of potential new hires', 'Inform her of plans to attend an event', 'Help her decorate the office', 'C', 'Gửi: Đội ngũ bán hàng

Từ: Laura Correa

Ngày: 5 tháng 10

Chủ đề: Cập nhật

Thân gửi cả đội,

Như đã thông báo trong bản tin tháng 9 của Brighter Sails, hiệu suất của chúng ta đã duy trì ở mức mạnh mẽ trong năm nay. Đây là một thành tích mà tất cả chúng ta có thể tự hào. Hãy dành chút thời gian để chúc mừng lẫn nhau. Chúng ta sẽ tiếp tục mơ về những kế hoạch mới và thú vị cho tương lai!

Trong một tin tức khác, Jasen Norton sẽ chuyển đến trụ sở chính ở Kingston của chúng ta vào tháng tới. Chúng tôi rất buồn khi mất đi ông Norton, nhưng chúng tôi biết ơn và ghi nhận công việc xuất sắc của ông và chúc ông tiếp tục thành công trong vai trò mới.

Sẽ có một bữa tiệc trưa chia tay ông Norton vào ngày 28 tháng 10 lúc 1:00 chiều tại phòng họp tầng hai. Hãy mang theo sự vui vẻ và có lẽ là một câu chuyện để chia sẻ. Công ty sẽ cung cấp bữa trưa, bánh ngọt và đồ trang trí. Hãy cho tôi biết trước ngày 12 tháng 10 liệu bạn có thể tham gia hay không.

Trân trọng,

Laura Correa, Quản lý bán hàng

Brighter Sails Ltd.', '', '', '9d1192d0-16f0-4c5b-981d-29d0bc5762a0', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('bc130e99-0031-4470-8d5d-54ec4b247234', 'ets-imported-test', 153, 7, 'reading', 'What is the purpose of the article?', 'To report on beach conditions', 'To announce a business reopening', 'To promote a movie premiere', 'To advertise a new restaurant', 'B', 'BEACHVILLE (24 tháng 2) — Cư dân và khách du lịch tại Beachville có lý do chính đáng để ăn mừng. Rạp hát Crown Coastal 40 năm tuổi dự kiến sẽ mở cửa trở lại vào tháng 6. Nhiều người đã đau buồn khi những chủ sở hữu rạp hát trước đó quyết định đóng cửa địa điểm này hơn một năm trước, với lý do chi phí cải tạo cần thiết. May mắn thay, rạp hát đã có những chủ sở hữu mới, những người đã dành cả năm qua để cập nhật nội thất và hệ thống máy chiếu.

Christine Lafferty cho biết cô và người bạn thời thơ ấu Morgan Flanagan đã dành rất nhiều thời gian tại rạp hát trong khi lớn lên. “Đi xem phim là việc nên làm vào một ngày mưa ở một thị trấn ven biển. Chúng tôi rất tiếc khi thấy nó đóng cửa.” Đôi bạn này, những người cũng sở hữu nhà hàng Blue Bay Bistro nổi tiếng, đã quyết định mua lại rạp hát và thực hiện các sửa chữa cần thiết để duy trì nó như một doanh nghiệp thịnh vượng. Để biết thêm thông tin về rạp hát và các sự kiện sắp tới, hãy truy cập www.crowncoastaltheater.com.', '', '', 'ee0c5f51-0ca3-4ae4-947d-6cd444dd186c', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('bd00d62a-74ba-4a03-8e09-0d5af9876897', 'ets-imported-test', 154, 7, 'reading', 'Who is Ms. Flanagan?', 'A town council member', 'An event coordinator', 'Ms. Lafferty’s business partner', 'The writer of the article', 'C', 'BEACHVILLE (24 tháng 2) — Cư dân và khách du lịch tại Beachville có lý do chính đáng để ăn mừng. Rạp hát Crown Coastal 40 năm tuổi dự kiến sẽ mở cửa trở lại vào tháng 6. Nhiều người đã đau buồn khi những chủ sở hữu rạp hát trước đó quyết định đóng cửa địa điểm này hơn một năm trước, với lý do chi phí cải tạo cần thiết. May mắn thay, rạp hát đã có những chủ sở hữu mới, những người đã dành cả năm qua để cập nhật nội thất và hệ thống máy chiếu.

Christine Lafferty cho biết cô và người bạn thời thơ ấu Morgan Flanagan đã dành rất nhiều thời gian tại rạp hát trong khi lớn lên. “Đi xem phim là việc nên làm vào một ngày mưa ở một thị trấn ven biển. Chúng tôi rất tiếc khi thấy nó đóng cửa.” Đôi bạn này, những người cũng sở hữu nhà hàng Blue Bay Bistro nổi tiếng, đã quyết định mua lại rạp hát và thực hiện các sửa chữa cần thiết để duy trì nó như một doanh nghiệp thịnh vượng. Để biết thêm thông tin về rạp hát và các sự kiện sắp tới, hãy truy cập www.crowncoastaltheater.com.', '', '', 'ee0c5f51-0ca3-4ae4-947d-6cd444dd186c', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('ccad9704-b489-408a-9fe2-9dcd11456d62', 'ets-imported-test', 155, 7, 'reading', 'What is the purpose of the e-mail?', 'To request payment', 'To provide operating instructions', 'To advertise a new product', 'To offer a substitute item', 'D', 'Gửi: Randi Longfellow

Từ: Deon Welman

Ngày: 27 tháng 3

Chủ đề: Mẫu Makatasi METX-33948

Thân gửi cô Longfellow,

Cảm ơn cô đã đặt mua Kính thiên văn khúc xạ ba lớp Makatasi ETX, mẫu METX-33948. Thật không may, mặt hàng cô yêu cầu hiện đang hết hàng. — [1] —. Nếu cô không muốn chờ đợi, chúng tôi có một chiếc kính thiên văn tương tự do một nhà sản xuất khác chế tạo, Belter Telescopes. Giống như mẫu Makatasi mà cô đã đặt, Belter BTR-1483 có khẩu độ 120 mm và loa che nắng có thể thu vào. — [2] —. Ngoài ra, tất cả các kính thiên văn Belter đều bao gồm một bao đựng có đệm lót. Chiếc Belter BTR-1483 có giá thấp hơn 200 đô la so với chiếc Makatasi METX-33948.

Nếu cô muốn điều chỉnh đơn hàng của mình, chỉ cần trả lời email này trong vòng 48 giờ hoặc truy cập trang web của chúng tôi để trò chuyện với đại diện tại http://www.skyviewscopes.com.au. Sau đó, chúng tôi sẽ thay đổi đơn hàng của cô, hoàn trả 200 đô la vào thẻ tín dụng của cô và vận chuyển kính thiên văn mới của cô qua đêm mà không tính thêm phí. — [3] —. Nếu không, chúng tôi sẽ thông báo cho cô khi mẫu Makatasi METX-33948 có hàng trở lại và cung cấp thông tin giao hàng tại thời điểm đó. — [4] —.

Trân trọng,

Deon Welman

Đại diện bán hàng, Skyview Scopes', '', '', 'd1ae535c-7b7f-4316-8c30-8f9467351137', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('2e313ca4-b0fb-4b84-ac85-ef06b6bd1c44', 'ets-imported-test', 156, 7, 'reading', 'What is mentioned about the Belter BTR-1483 telescope?', 'It can only be ordered online.', 'It will ship directly from the manufacturer.', 'It includes a protective case.', 'It is the most expensive telescope of its type.', 'C', 'Gửi: Randi Longfellow

Từ: Deon Welman

Ngày: 27 tháng 3

Chủ đề: Mẫu Makatasi METX-33948

Thân gửi cô Longfellow,

Cảm ơn cô đã đặt mua Kính thiên văn khúc xạ ba lớp Makatasi ETX, mẫu METX-33948. Thật không may, mặt hàng cô yêu cầu hiện đang hết hàng. — [1] —. Nếu cô không muốn chờ đợi, chúng tôi có một chiếc kính thiên văn tương tự do một nhà sản xuất khác chế tạo, Belter Telescopes. Giống như mẫu Makatasi mà cô đã đặt, Belter BTR-1483 có khẩu độ 120 mm và loa che nắng có thể thu vào. — [2] —. Ngoài ra, tất cả các kính thiên văn Belter đều bao gồm một bao đựng có đệm lót. Chiếc Belter BTR-1483 có giá thấp hơn 200 đô la so với chiếc Makatasi METX-33948.

Nếu cô muốn điều chỉnh đơn hàng của mình, chỉ cần trả lời email này trong vòng 48 giờ hoặc truy cập trang web của chúng tôi để trò chuyện với đại diện tại http://www.skyviewscopes.com.au. Sau đó, chúng tôi sẽ thay đổi đơn hàng của cô, hoàn trả 200 đô la vào thẻ tín dụng của cô và vận chuyển kính thiên văn mới của cô qua đêm mà không tính thêm phí. — [3] —. Nếu không, chúng tôi sẽ thông báo cho cô khi mẫu Makatasi METX-33948 có hàng trở lại và cung cấp thông tin giao hàng tại thời điểm đó. — [4] —.

Trân trọng,

Deon Welman

Đại diện bán hàng, Skyview Scopes', '', '', 'd1ae535c-7b7f-4316-8c30-8f9467351137', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('53b05e09-c723-4a46-9399-0c8a36091e0d', 'ets-imported-test', 157, 7, 'reading', 'In which of the positions marked [1], [2], [3], and [4] does the following sentence best belong? “You can see a full list of specifications on our Web site.”', '[1]', '[2]', '[3]', '[4]', 'B', 'Gửi: Randi Longfellow

Từ: Deon Welman

Ngày: 27 tháng 3

Chủ đề: Mẫu Makatasi METX-33948

Thân gửi cô Longfellow,

Cảm ơn cô đã đặt mua Kính thiên văn khúc xạ ba lớp Makatasi ETX, mẫu METX-33948. Thật không may, mặt hàng cô yêu cầu hiện đang hết hàng. — [1] —. Nếu cô không muốn chờ đợi, chúng tôi có một chiếc kính thiên văn tương tự do một nhà sản xuất khác chế tạo, Belter Telescopes. Giống như mẫu Makatasi mà cô đã đặt, Belter BTR-1483 có khẩu độ 120 mm và loa che nắng có thể thu vào. — [2] —. Ngoài ra, tất cả các kính thiên văn Belter đều bao gồm một bao đựng có đệm lót. Chiếc Belter BTR-1483 có giá thấp hơn 200 đô la so với chiếc Makatasi METX-33948.

Nếu cô muốn điều chỉnh đơn hàng của mình, chỉ cần trả lời email này trong vòng 48 giờ hoặc truy cập trang web của chúng tôi để trò chuyện với đại diện tại http://www.skyviewscopes.com.au. Sau đó, chúng tôi sẽ thay đổi đơn hàng của cô, hoàn trả 200 đô la vào thẻ tín dụng của cô và vận chuyển kính thiên văn mới của cô qua đêm mà không tính thêm phí. — [3] —. Nếu không, chúng tôi sẽ thông báo cho cô khi mẫu Makatasi METX-33948 có hàng trở lại và cung cấp thông tin giao hàng tại thời điểm đó. — [4] —.

Trân trọng,

Deon Welman

Đại diện bán hàng, Skyview Scopes', '', '', 'd1ae535c-7b7f-4316-8c30-8f9467351137', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('6b148127-5996-4942-80fd-68e8d3c6023d', 'ets-imported-test', 158, 7, 'reading', 'What is one purpose of the e-mail?', 'To explain how to use a software program', 'To request Ms. Myo’s assistance with a project', 'To introduce a new staff member', 'To indicate that Mr. Delpit is out of the office', 'D', 'Xin chào,

Cảm ơn email của bạn. Tôi hiện đang đi nghỉ và sẽ quay lại văn phòng vào ngày 15 tháng 3. Tôi sẽ phản hồi tin nhắn của bạn sớm nhất có thể sau khi tôi quay lại.

Nếu bạn cần hỗ trợ chung trong thời gian tôi vắng mặt hoặc có thắc mắc về vị trí đang tuyển dụng trong bộ phận bán hàng của chúng tôi, vui lòng liên hệ với trợ lý của tôi, Sita Viswan, tại số 04 555 0193 hoặc sviswan@hamerkoptech.co.nz. Đối với các câu hỏi về các sản phẩm phần mềm cụ thể của Hamerkoptech, hãy liên hệ với bộ phận dịch vụ khách hàng tại customerservice@hamerkoptech.co.nz.

Ngoài ra, tôi rất vui mừng thông báo rằng chương trình phần mềm thiết kế đồ họa mới của chúng tôi sẽ được phát hành vào ngày 2 tháng 4. Bạn có thể đọc thêm về chương trình tại trang web mới được thiết kế lại của Hamerkoptech, www.hamerkoptech.co.nz. Tại đó, bạn cũng có thể đăng ký nhận bản tin hàng tuần của chúng tôi bằng cách làm theo hướng dẫn trên trang chủ.

Trân trọng,

Jan Delpit', '', '', 'd5086d20-42ac-4185-97cf-3bae12c1d680', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('6397352c-19e1-4641-bed6-7d685f96bbe8', 'ets-imported-test', 159, 7, 'reading', 'What will happen on April 2?', 'A job opening will be filled.', 'A product will be launched.', 'A client meeting will take place.', 'A Web site redesign will begin.', 'B', 'Xin chào,

Cảm ơn email của bạn. Tôi hiện đang đi nghỉ và sẽ quay lại văn phòng vào ngày 15 tháng 3. Tôi sẽ phản hồi tin nhắn của bạn sớm nhất có thể sau khi tôi quay lại.

Nếu bạn cần hỗ trợ chung trong thời gian tôi vắng mặt hoặc có thắc mắc về vị trí đang tuyển dụng trong bộ phận bán hàng của chúng tôi, vui lòng liên hệ với trợ lý của tôi, Sita Viswan, tại số 04 555 0193 hoặc sviswan@hamerkoptech.co.nz. Đối với các câu hỏi về các sản phẩm phần mềm cụ thể của Hamerkoptech, hãy liên hệ với bộ phận dịch vụ khách hàng tại customerservice@hamerkoptech.co.nz.

Ngoài ra, tôi rất vui mừng thông báo rằng chương trình phần mềm thiết kế đồ họa mới của chúng tôi sẽ được phát hành vào ngày 2 tháng 4. Bạn có thể đọc thêm về chương trình tại trang web mới được thiết kế lại của Hamerkoptech, www.hamerkoptech.co.nz. Tại đó, bạn cũng có thể đăng ký nhận bản tin hàng tuần của chúng tôi bằng cách làm theo hướng dẫn trên trang chủ.

Trân trọng,

Jan Delpit', '', '', 'd5086d20-42ac-4185-97cf-3bae12c1d680', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('77e5123f-687b-4efd-b084-70ab0b6b038d', 'ets-imported-test', 160, 7, 'reading', 'How can people subscribe to a newsletter?', 'By calling Ms. Viswan', 'By replying to Mr. Delpit’s e-mail', 'By visiting Hamerkoptech’s Web site', 'By contacting the customer service department', 'C', 'Xin chào,

Cảm ơn email của bạn. Tôi hiện đang đi nghỉ và sẽ quay lại văn phòng vào ngày 15 tháng 3. Tôi sẽ phản hồi tin nhắn của bạn sớm nhất có thể sau khi tôi quay lại.

Nếu bạn cần hỗ trợ chung trong thời gian tôi vắng mặt hoặc có thắc mắc về vị trí đang tuyển dụng trong bộ phận bán hàng của chúng tôi, vui lòng liên hệ với trợ lý của tôi, Sita Viswan, tại số 04 555 0193 hoặc sviswan@hamerkoptech.co.nz. Đối với các câu hỏi về các sản phẩm phần mềm cụ thể của Hamerkoptech, hãy liên hệ với bộ phận dịch vụ khách hàng tại customerservice@hamerkoptech.co.nz.

Ngoài ra, tôi rất vui mừng thông báo rằng chương trình phần mềm thiết kế đồ họa mới của chúng tôi sẽ được phát hành vào ngày 2 tháng 4. Bạn có thể đọc thêm về chương trình tại trang web mới được thiết kế lại của Hamerkoptech, www.hamerkoptech.co.nz. Tại đó, bạn cũng có thể đăng ký nhận bản tin hàng tuần của chúng tôi bằng cách làm theo hướng dẫn trên trang chủ.

Trân trọng,

Jan Delpit', '', '', 'd5086d20-42ac-4185-97cf-3bae12c1d680', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('ae498052-9e7c-40cc-990f-b0fa2d4b6654', 'ets-imported-test', 161, 7, 'reading', 'What is one purpose of the article?', 'To discuss a cooking technique', 'To report on a corporate merger', 'To announce a new product line', 'To introduce a recently hired executive', 'C', 'VANCOUVER (2 tháng 8) — Vimalo Brands, công ty hàng tiêu dùng lớn chuyên tiếp thị các sản phẩm hỗ trợ dinh dưỡng và chăm sóc cá nhân phổ biến, bao gồm đồ uống ăn sáng Powerburst cùng xà phòng và sữa dưỡng thể Honeysoft, sẽ sớm cung cấp một điều mới mẻ cho khách hàng của mình: thực phẩm đông lạnh. "Dòng sản phẩm Nutridinna mới của chúng tôi không chỉ đơn thuần là về sự tiện lợi," Giám đốc điều hành Danitza Martens đã phát biểu trong một cuộc họp báo diễn ra sáng nay. "Thực phẩm đông lạnh không phải là một khái niệm mới, nhưng phương pháp cấp đông nhanh các loại nông sản và thịt tươi sống của chúng tôi đảm bảo rằng sản phẩm vẫn giữ được cấu trúc và hương vị cũng như các vitamin và khoáng chất có lợi cho sức khỏe. Giờ đây, khách hàng của chúng tôi có thể tận hưởng sự tiện lợi của thực phẩm đông lạnh mà không phải đánh đổi chất lượng."

Vimalo Brands đã hợp tác với các trang trại ở khu vực Vancouver để thu mua nông sản và thịt cho dòng sản phẩm Nutridinna. "Bằng cách duy trì các hoạt động tại địa phương, chúng tôi tránh được việc chậm trễ trong vận chuyển và có thể cấp đông nhanh các loại rau củ vừa thu hoạch ở độ chín cao nhất," bà Martens nói. "Khách hàng của chúng tôi còn được hưởng lợi nhiều hơn, vì sản phẩm của chúng tôi có thể được bảo quản trong ngăn đông lên đến sáu tháng." Thực phẩm Nutridinna sẽ có mặt tại các siêu thị bắt đầu từ tháng 11. Cá đông lạnh và các loại hải sản khác sẽ được bổ sung vào đầu năm tới.', '', '', '05b0bab3-b74b-4bae-874a-ff86cc08c172', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('4e1f3f09-4a8a-43ea-9e16-ffe68212be08', 'ets-imported-test', 162, 7, 'reading', 'The word “just” in paragraph 1, line 4, is closest in meaning to', 'recently', 'exactly', 'slightly', 'only', 'D', 'VANCOUVER (2 tháng 8) — Vimalo Brands, công ty hàng tiêu dùng lớn chuyên tiếp thị các sản phẩm hỗ trợ dinh dưỡng và chăm sóc cá nhân phổ biến, bao gồm đồ uống ăn sáng Powerburst cùng xà phòng và sữa dưỡng thể Honeysoft, sẽ sớm cung cấp một điều mới mẻ cho khách hàng của mình: thực phẩm đông lạnh. "Dòng sản phẩm Nutridinna mới của chúng tôi không chỉ đơn thuần là về sự tiện lợi," Giám đốc điều hành Danitza Martens đã phát biểu trong một cuộc họp báo diễn ra sáng nay. "Thực phẩm đông lạnh không phải là một khái niệm mới, nhưng phương pháp cấp đông nhanh các loại nông sản và thịt tươi sống của chúng tôi đảm bảo rằng sản phẩm vẫn giữ được cấu trúc và hương vị cũng như các vitamin và khoáng chất có lợi cho sức khỏe. Giờ đây, khách hàng của chúng tôi có thể tận hưởng sự tiện lợi của thực phẩm đông lạnh mà không phải đánh đổi chất lượng."

Vimalo Brands đã hợp tác với các trang trại ở khu vực Vancouver để thu mua nông sản và thịt cho dòng sản phẩm Nutridinna. "Bằng cách duy trì các hoạt động tại địa phương, chúng tôi tránh được việc chậm trễ trong vận chuyển và có thể cấp đông nhanh các loại rau củ vừa thu hoạch ở độ chín cao nhất," bà Martens nói. "Khách hàng của chúng tôi còn được hưởng lợi nhiều hơn, vì sản phẩm của chúng tôi có thể được bảo quản trong ngăn đông lên đến sáu tháng." Thực phẩm Nutridinna sẽ có mặt tại các siêu thị bắt đầu từ tháng 11. Cá đông lạnh và các loại hải sản khác sẽ được bổ sung vào đầu năm tới.', '', '', '05b0bab3-b74b-4bae-874a-ff86cc08c172', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('a3cefeed-a5a2-4bcb-bac8-610662291d77', 'ets-imported-test', 163, 7, 'reading', 'What does Ms. Martens suggest about flash-frozen food?', 'It is less expensive than fresh food.', 'It is as nutritious as fresh food.', 'It is as easy to ship as fresh food.', 'It is less flavorful than fresh food.', 'B', 'VANCOUVER (2 tháng 8) — Vimalo Brands, công ty hàng tiêu dùng lớn chuyên tiếp thị các sản phẩm hỗ trợ dinh dưỡng và chăm sóc cá nhân phổ biến, bao gồm đồ uống ăn sáng Powerburst cùng xà phòng và sữa dưỡng thể Honeysoft, sẽ sớm cung cấp một điều mới mẻ cho khách hàng của mình: thực phẩm đông lạnh. "Dòng sản phẩm Nutridinna mới của chúng tôi không chỉ đơn thuần là về sự tiện lợi," Giám đốc điều hành Danitza Martens đã phát biểu trong một cuộc họp báo diễn ra sáng nay. "Thực phẩm đông lạnh không phải là một khái niệm mới, nhưng phương pháp cấp đông nhanh các loại nông sản và thịt tươi sống của chúng tôi đảm bảo rằng sản phẩm vẫn giữ được cấu trúc và hương vị cũng như các vitamin và khoáng chất có lợi cho sức khỏe. Giờ đây, khách hàng của chúng tôi có thể tận hưởng sự tiện lợi của thực phẩm đông lạnh mà không phải đánh đổi chất lượng."

Vimalo Brands đã hợp tác với các trang trại ở khu vực Vancouver để thu mua nông sản và thịt cho dòng sản phẩm Nutridinna. "Bằng cách duy trì các hoạt động tại địa phương, chúng tôi tránh được việc chậm trễ trong vận chuyển và có thể cấp đông nhanh các loại rau củ vừa thu hoạch ở độ chín cao nhất," bà Martens nói. "Khách hàng của chúng tôi còn được hưởng lợi nhiều hơn, vì sản phẩm của chúng tôi có thể được bảo quản trong ngăn đông lên đến sáu tháng." Thực phẩm Nutridinna sẽ có mặt tại các siêu thị bắt đầu từ tháng 11. Cá đông lạnh và các loại hải sản khác sẽ được bổ sung vào đầu năm tới.', '', '', '05b0bab3-b74b-4bae-874a-ff86cc08c172', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('bab8f207-52c5-421c-97bf-d2484c474f30', 'ets-imported-test', 164, 7, 'reading', 'According to the advertisement, who most likely is Ms. Navani?', 'A Karning Creative Designs client', 'A business owner', 'A photographer', 'A real estate agent', 'B', 'Bạn đã sẵn sàng làm việc chăm chỉ như một phần của đội ngũ gồm những cá nhân cùng chí hướng chưa? Bạn có sẵn lòng vận dụng học vấn, kinh nghiệm và trí tưởng tượng của mình vào những việc hữu ích không? Nếu có, thì chúng tôi có công việc dành cho bạn. Karning Creative Designs đang mở rộng, và cùng với sự thành công của chúng tôi là cơ hội của bạn.

Karning Creative Designs bắt đầu từ mười năm trước như một hoạt động kinh doanh gồm hai người được thiết lập tại nhà của CEO và người sáng lập hiện tại của chúng tôi, Shirin Navani. Hiện tọa lạc tại một căn hộ gác lửng tuyệt đẹp ở trung tâm thành phố Hollinson, công ty chúng tôi hiện đang thuê 25 nhân viên toàn thời gian. Tại Karning, chúng tôi thiết kế các tập gấp quảng cáo bằng giấy, danh mục sản phẩm, quảng cáo và áp phích cho khách hàng. Chúng tôi hiện đang tìm kiếm các nhà thiết kế và nghệ sĩ có năng lực, những người sẽ tỏa sáng trong một môi trường hợp tác, tốc độ nhanh.

Ứng viên lý tưởng

* Có bằng cấp về thiết kế, quảng cáo hoặc nghệ thuật đồ họa—mặc dù vài năm kinh nghiệm trực tiếp có thể thay thế cho bằng cấp

* Thể hiện khả năng làm việc chặt chẽ với các đồng nghiệp

* Duy trì con mắt phản biện về chi tiết và sự chính xác

* Luôn đáp ứng đúng thời hạn và có thể phát triển dưới áp lực

Kinh nghiệm thiết kế đồ họa hoặc các kinh nghiệm liên quan là một điểm cộng nhưng không bắt buộc nghiêm ngặt.

Nếu bạn đã sẵn sàng tham gia đội ngũ của chúng tôi, chúng tôi muốn gặp bạn! Hãy liên hệ với Salvador Tomassin tại số 608-555-0144 để biết thêm chi tiết. Tất cả hồ sơ ứng tuyển phải được nhận trước ngày 31 tháng 3.', '', '', '76380eea-c341-4ded-841f-0064fb8d8309', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('20efa5dd-b567-4ac4-954b-1ad33d13bd73', 'ets-imported-test', 165, 7, 'reading', 'What is indicated about Karning Creative Designs?', 'Its primary focus is Web design.', 'It initially employed two people.', 'It was founded by Mr. Tomassin.', 'Its staff are permitted to work from home.', 'B', 'Bạn đã sẵn sàng làm việc chăm chỉ như một phần của đội ngũ gồm những cá nhân cùng chí hướng chưa? Bạn có sẵn lòng vận dụng học vấn, kinh nghiệm và trí tưởng tượng của mình vào những việc hữu ích không? Nếu có, thì chúng tôi có công việc dành cho bạn. Karning Creative Designs đang mở rộng, và cùng với sự thành công của chúng tôi là cơ hội của bạn.

Karning Creative Designs bắt đầu từ mười năm trước như một hoạt động kinh doanh gồm hai người được thiết lập tại nhà của CEO và người sáng lập hiện tại của chúng tôi, Shirin Navani. Hiện tọa lạc tại một căn hộ gác lửng tuyệt đẹp ở trung tâm thành phố Hollinson, công ty chúng tôi hiện đang thuê 25 nhân viên toàn thời gian. Tại Karning, chúng tôi thiết kế các tập gấp quảng cáo bằng giấy, danh mục sản phẩm, quảng cáo và áp phích cho khách hàng. Chúng tôi hiện đang tìm kiếm các nhà thiết kế và nghệ sĩ có năng lực, những người sẽ tỏa sáng trong một môi trường hợp tác, tốc độ nhanh.

Ứng viên lý tưởng

* Có bằng cấp về thiết kế, quảng cáo hoặc nghệ thuật đồ họa—mặc dù vài năm kinh nghiệm trực tiếp có thể thay thế cho bằng cấp

* Thể hiện khả năng làm việc chặt chẽ với các đồng nghiệp

* Duy trì con mắt phản biện về chi tiết và sự chính xác

* Luôn đáp ứng đúng thời hạn và có thể phát triển dưới áp lực

Kinh nghiệm thiết kế đồ họa hoặc các kinh nghiệm liên quan là một điểm cộng nhưng không bắt buộc nghiêm ngặt.

Nếu bạn đã sẵn sàng tham gia đội ngũ của chúng tôi, chúng tôi muốn gặp bạn! Hãy liên hệ với Salvador Tomassin tại số 608-555-0144 để biết thêm chi tiết. Tất cả hồ sơ ứng tuyển phải được nhận trước ngày 31 tháng 3.', '', '', '76380eea-c341-4ded-841f-0064fb8d8309', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('c1db916e-cb2c-4c33-ae68-22fbade1d5de', 'ets-imported-test', 166, 7, 'reading', 'What is required of job applicants?', 'Skill in working with others', 'Previous design experience', 'A willingness to work on weekends', 'An ability to use certain software applications', 'A', 'Bạn đã sẵn sàng làm việc chăm chỉ như một phần của đội ngũ gồm những cá nhân cùng chí hướng chưa? Bạn có sẵn lòng vận dụng học vấn, kinh nghiệm và trí tưởng tượng của mình vào những việc hữu ích không? Nếu có, thì chúng tôi có công việc dành cho bạn. Karning Creative Designs đang mở rộng, và cùng với sự thành công của chúng tôi là cơ hội của bạn.

Karning Creative Designs bắt đầu từ mười năm trước như một hoạt động kinh doanh gồm hai người được thiết lập tại nhà của CEO và người sáng lập hiện tại của chúng tôi, Shirin Navani. Hiện tọa lạc tại một căn hộ gác lửng tuyệt đẹp ở trung tâm thành phố Hollinson, công ty chúng tôi hiện đang thuê 25 nhân viên toàn thời gian. Tại Karning, chúng tôi thiết kế các tập gấp quảng cáo bằng giấy, danh mục sản phẩm, quảng cáo và áp phích cho khách hàng. Chúng tôi hiện đang tìm kiếm các nhà thiết kế và nghệ sĩ có năng lực, những người sẽ tỏa sáng trong một môi trường hợp tác, tốc độ nhanh.

Ứng viên lý tưởng

* Có bằng cấp về thiết kế, quảng cáo hoặc nghệ thuật đồ họa—mặc dù vài năm kinh nghiệm trực tiếp có thể thay thế cho bằng cấp

* Thể hiện khả năng làm việc chặt chẽ với các đồng nghiệp

* Duy trì con mắt phản biện về chi tiết và sự chính xác

* Luôn đáp ứng đúng thời hạn và có thể phát triển dưới áp lực

Kinh nghiệm thiết kế đồ họa hoặc các kinh nghiệm liên quan là một điểm cộng nhưng không bắt buộc nghiêm ngặt.

Nếu bạn đã sẵn sàng tham gia đội ngũ của chúng tôi, chúng tôi muốn gặp bạn! Hãy liên hệ với Salvador Tomassin tại số 608-555-0144 để biết thêm chi tiết. Tất cả hồ sơ ứng tuyển phải được nhận trước ngày 31 tháng 3.', '', '', '76380eea-c341-4ded-841f-0064fb8d8309', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('d1d742b1-62ca-422a-98e9-b997dffe299e', 'ets-imported-test', 167, 7, 'reading', 'What will happen on March 31?', 'A project will begin.', 'A deadline will occur.', 'A graphic designer will relocate.', 'An application form will be made available.', 'B', 'Bạn đã sẵn sàng làm việc chăm chỉ như một phần của đội ngũ gồm những cá nhân cùng chí hướng chưa? Bạn có sẵn lòng vận dụng học vấn, kinh nghiệm và trí tưởng tượng của mình vào những việc hữu ích không? Nếu có, thì chúng tôi có công việc dành cho bạn. Karning Creative Designs đang mở rộng, và cùng với sự thành công của chúng tôi là cơ hội của bạn.

Karning Creative Designs bắt đầu từ mười năm trước như một hoạt động kinh doanh gồm hai người được thiết lập tại nhà của CEO và người sáng lập hiện tại của chúng tôi, Shirin Navani. Hiện tọa lạc tại một căn hộ gác lửng tuyệt đẹp ở trung tâm thành phố Hollinson, công ty chúng tôi hiện đang thuê 25 nhân viên toàn thời gian. Tại Karning, chúng tôi thiết kế các tập gấp quảng cáo bằng giấy, danh mục sản phẩm, quảng cáo và áp phích cho khách hàng. Chúng tôi hiện đang tìm kiếm các nhà thiết kế và nghệ sĩ có năng lực, những người sẽ tỏa sáng trong một môi trường hợp tác, tốc độ nhanh.

Ứng viên lý tưởng

* Có bằng cấp về thiết kế, quảng cáo hoặc nghệ thuật đồ họa—mặc dù vài năm kinh nghiệm trực tiếp có thể thay thế cho bằng cấp

* Thể hiện khả năng làm việc chặt chẽ với các đồng nghiệp

* Duy trì con mắt phản biện về chi tiết và sự chính xác

* Luôn đáp ứng đúng thời hạn và có thể phát triển dưới áp lực

Kinh nghiệm thiết kế đồ họa hoặc các kinh nghiệm liên quan là một điểm cộng nhưng không bắt buộc nghiêm ngặt.

Nếu bạn đã sẵn sàng tham gia đội ngũ của chúng tôi, chúng tôi muốn gặp bạn! Hãy liên hệ với Salvador Tomassin tại số 608-555-0144 để biết thêm chi tiết. Tất cả hồ sơ ứng tuyển phải được nhận trước ngày 31 tháng 3.', '', '', '76380eea-c341-4ded-841f-0064fb8d8309', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('7a95ba52-83dc-483d-a99a-16a47727e825', 'ets-imported-test', 168, 7, 'reading', 'What does the article mention about Marco’s Italian Restaurant?', 'It is the oldest restaurant in New Haven.', 'It is looking for a chef who can cook traditional dishes.', 'It needed major renovations.', 'It opened in a new location.', 'C', 'NEW HAVEN (Ngày 1 tháng 6) — Nhà hàng Ý của Marco trên đường Frontage sẽ mở cửa trở lại vào cuối tháng 6. Nó đã đóng cửa ba tháng trước sau khi một vụ rò rỉ nước gây ra thiệt hại trên diện rộng cho nhà bếp. Một lượng công việc đáng kể cần phải được thực hiện ở khu vực bếp và khu vực ăn uống. — [1] —. Nhà hàng sẽ có sức chứa cho các nhóm khách lớn hơn khi mở cửa trở lại.

Trong ba tháng qua, nhiều nhân viên của nhà hàng đã có thể làm việc tại Chợ Ý của Marco, nằm ở phía đối diện của con phố. — [2] —. "Vụ rò rỉ xảy ra ngay trước khi mùa cao điểm của chợ bắt đầu," Tom Marco, chủ sở hữu của cả hai cơ sở kinh doanh, cho biết. "Chúng tôi cần bổ sung nhân viên ở đó tạm thời, và tôi rất vui khi vẫn duy trì được việc làm cho đội ngũ nhân viên nhà hàng của mình." Hầu hết những nhân viên đó hiện đã quay trở lại làm việc tại nhà hàng. — [3] —.

Ông Marco đã lên kế hoạch cho một buổi khai trương hoành tráng vào ngày 25 tháng 6. Khách mời sẽ được thưởng thức nhạc sống và thực đơn dùng thử mới. — [4] —. Việc đặt chỗ là bắt buộc cho ngày kỷ niệm và có thể được thực hiện bằng cách gọi số 203-555-0124. "Chúng tôi rất hào hứng khi có thể chế biến các món ăn truyền thống của mình và chào đón cộng đồng quay trở lại một lần nữa," ông Marco phát biểu.', '', '', 'afdda604-2c7e-49ed-b32e-6159e8994840', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('032c2044-ae10-4ca8-8cb5-d7b21727080a', 'ets-imported-test', 169, 7, 'reading', 'What is indicated about Marco’s Italian Market?', 'It supplies ingredients to Marco’s Italian Restaurant.', 'It occasionally hires temporary workers.', 'It is scheduled to close in three months.', 'It is located next door to Marco’s Italian Restaurant.', 'B', 'NEW HAVEN (Ngày 1 tháng 6) — Nhà hàng Ý của Marco trên đường Frontage sẽ mở cửa trở lại vào cuối tháng 6. Nó đã đóng cửa ba tháng trước sau khi một vụ rò rỉ nước gây ra thiệt hại trên diện rộng cho nhà bếp. Một lượng công việc đáng kể cần phải được thực hiện ở khu vực bếp và khu vực ăn uống. — [1] —. Nhà hàng sẽ có sức chứa cho các nhóm khách lớn hơn khi mở cửa trở lại.

Trong ba tháng qua, nhiều nhân viên của nhà hàng đã có thể làm việc tại Chợ Ý của Marco, nằm ở phía đối diện của con phố. — [2] —. "Vụ rò rỉ xảy ra ngay trước khi mùa cao điểm của chợ bắt đầu," Tom Marco, chủ sở hữu của cả hai cơ sở kinh doanh, cho biết. "Chúng tôi cần bổ sung nhân viên ở đó tạm thời, và tôi rất vui khi vẫn duy trì được việc làm cho đội ngũ nhân viên nhà hàng của mình." Hầu hết những nhân viên đó hiện đã quay trở lại làm việc tại nhà hàng. — [3] —.

Ông Marco đã lên kế hoạch cho một buổi khai trương hoành tráng vào ngày 25 tháng 6. Khách mời sẽ được thưởng thức nhạc sống và thực đơn dùng thử mới. — [4] —. Việc đặt chỗ là bắt buộc cho ngày kỷ niệm và có thể được thực hiện bằng cách gọi số 203-555-0124. "Chúng tôi rất hào hứng khi có thể chế biến các món ăn truyền thống của mình và chào đón cộng đồng quay trở lại một lần nữa," ông Marco phát biểu.', '', '', 'afdda604-2c7e-49ed-b32e-6159e8994840', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('e445f1f7-0767-4573-a72e-e4dcf31faba9', 'ets-imported-test', 170, 7, 'reading', 'What will happen during the event on June 25?', 'The restaurant will reduce its menu prices.', 'The restaurant will offer special menu items.', 'Mr. Marco will celebrate his retirement.', 'The New Haven business community will honor Mr. Marco.', 'B', 'NEW HAVEN (Ngày 1 tháng 6) — Nhà hàng Ý của Marco trên đường Frontage sẽ mở cửa trở lại vào cuối tháng 6. Nó đã đóng cửa ba tháng trước sau khi một vụ rò rỉ nước gây ra thiệt hại trên diện rộng cho nhà bếp. Một lượng công việc đáng kể cần phải được thực hiện ở khu vực bếp và khu vực ăn uống. — [1] —. Nhà hàng sẽ có sức chứa cho các nhóm khách lớn hơn khi mở cửa trở lại.

Trong ba tháng qua, nhiều nhân viên của nhà hàng đã có thể làm việc tại Chợ Ý của Marco, nằm ở phía đối diện của con phố. — [2] —. "Vụ rò rỉ xảy ra ngay trước khi mùa cao điểm của chợ bắt đầu," Tom Marco, chủ sở hữu của cả hai cơ sở kinh doanh, cho biết. "Chúng tôi cần bổ sung nhân viên ở đó tạm thời, và tôi rất vui khi vẫn duy trì được việc làm cho đội ngũ nhân viên nhà hàng của mình." Hầu hết những nhân viên đó hiện đã quay trở lại làm việc tại nhà hàng. — [3] —.

Ông Marco đã lên kế hoạch cho một buổi khai trương hoành tráng vào ngày 25 tháng 6. Khách mời sẽ được thưởng thức nhạc sống và thực đơn dùng thử mới. — [4] —. Việc đặt chỗ là bắt buộc cho ngày kỷ niệm và có thể được thực hiện bằng cách gọi số 203-555-0124. "Chúng tôi rất hào hứng khi có thể chế biến các món ăn truyền thống của mình và chào đón cộng đồng quay trở lại một lần nữa," ông Marco phát biểu.', '', '', 'afdda604-2c7e-49ed-b32e-6159e8994840', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('878988b0-8276-43f5-80e2-4ec62ea2b02e', 'ets-imported-test', 171, 7, 'reading', 'In which of the positions marked [1], [2], [3], and [4] does the following sentence best belong? “During repairs, some additional dining space was added.”', '[1]', '[2]', '[3]', '[4]', 'A', 'NEW HAVEN (Ngày 1 tháng 6) — Nhà hàng Ý của Marco trên đường Frontage sẽ mở cửa trở lại vào cuối tháng 6. Nó đã đóng cửa ba tháng trước sau khi một vụ rò rỉ nước gây ra thiệt hại trên diện rộng cho nhà bếp. Một lượng công việc đáng kể cần phải được thực hiện ở khu vực bếp và khu vực ăn uống. — [1] —. Nhà hàng sẽ có sức chứa cho các nhóm khách lớn hơn khi mở cửa trở lại.

Trong ba tháng qua, nhiều nhân viên của nhà hàng đã có thể làm việc tại Chợ Ý của Marco, nằm ở phía đối diện của con phố. — [2] —. "Vụ rò rỉ xảy ra ngay trước khi mùa cao điểm của chợ bắt đầu," Tom Marco, chủ sở hữu của cả hai cơ sở kinh doanh, cho biết. "Chúng tôi cần bổ sung nhân viên ở đó tạm thời, và tôi rất vui khi vẫn duy trì được việc làm cho đội ngũ nhân viên nhà hàng của mình." Hầu hết những nhân viên đó hiện đã quay trở lại làm việc tại nhà hàng. — [3] —.

Ông Marco đã lên kế hoạch cho một buổi khai trương hoành tráng vào ngày 25 tháng 6. Khách mời sẽ được thưởng thức nhạc sống và thực đơn dùng thử mới. — [4] —. Việc đặt chỗ là bắt buộc cho ngày kỷ niệm và có thể được thực hiện bằng cách gọi số 203-555-0124. "Chúng tôi rất hào hứng khi có thể chế biến các món ăn truyền thống của mình và chào đón cộng đồng quay trở lại một lần nữa," ông Marco phát biểu.', '', '', 'afdda604-2c7e-49ed-b32e-6159e8994840', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('f979830c-e4d5-486a-bee2-612e6434a050', 'ets-imported-test', 172, 7, 'reading', 'Why did Ms. Barry begin an online chat with Mr. Kubelski?', 'To refer him to a different department', 'To decline an invitation', 'To issue an apology', 'To ask for clarification about a request', 'D', 'Marlys Barry (10:17 sáng)

Tôi là Barry từ bộ phận phân tích dữ liệu. Tôi có bao gồm đồng nghiệp của mình, cô Choi. Chúng tôi liên hệ với ông về yêu cầu dữ liệu địa chỉ email của tất cả các chủ tài khoản, được sắp xếp theo độ tuổi.

Alexander Kubelski (10:17 sáng)

Vâng, các bạn có thể hoàn thành yêu cầu sớm đến mức nào?

Marlys Barry (10:18 sáng)

Tôi có một câu hỏi cho ông trước. Ông có thực sự cần địa chỉ email của tất cả các chủ tài khoản không? Đó sẽ là một tệp rất lớn. Hay ông chỉ cần địa chỉ email của các chủ tài khoản trong một nhóm tuổi nhất định?

Alexander Kubelski (10:19 sáng)

Tôi hiểu ý cô rồi. Tôi muốn gửi email cho các chủ tài khoản từ 55 đến 65 tuổi để mời họ gặp chuyên gia lập kế hoạch hưu trí. Tôi có phải nộp mẫu yêu cầu dự án mới không?

Bora Choi (10:21 sáng)

Điều đó không cần thiết đâu, ông Kubelski. Chúng tôi có thể cập nhật mẫu yêu cầu hiện tại cho ông. Ông sẽ không muốn mất vị trí của mình trong hàng đợi đâu.

Alexander Kubelski (10:21 sáng)

Tuyệt vời, cảm ơn cô! Cô có thể gửi danh sách đó cho tôi ngay lập tức được không?

Marlys Barry (10:22 sáng)

Có một vài dự án đang xếp hàng trước dự án của ông.

Alexander Kubelski (10:23 sáng)

Tôi đã hy vọng gửi thư mời qua email vào ngày mai.

Marlys Barry (10:24 sáng)

Chúng tôi sẽ xử lý nó ngay khi có thể.', '', '', '5b16a09d-4c11-44bb-a1e9-f4b34c91efbf', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('e3ae93ee-8a18-4ede-929f-b233c84fb419', 'ets-imported-test', 173, 7, 'reading', 'Who will receive an e-mail from Mr. Kubelski?', 'Account holders in one age-group', 'Data analysis team members', 'Financial planners', 'All Mr. Kubelski’s clients', 'A', 'Marlys Barry (10:17 sáng)

Tôi là Barry từ bộ phận phân tích dữ liệu. Tôi có bao gồm đồng nghiệp của mình, cô Choi. Chúng tôi liên hệ với ông về yêu cầu dữ liệu địa chỉ email của tất cả các chủ tài khoản, được sắp xếp theo độ tuổi.

Alexander Kubelski (10:17 sáng)

Vâng, các bạn có thể hoàn thành yêu cầu sớm đến mức nào?

Marlys Barry (10:18 sáng)

Tôi có một câu hỏi cho ông trước. Ông có thực sự cần địa chỉ email của tất cả các chủ tài khoản không? Đó sẽ là một tệp rất lớn. Hay ông chỉ cần địa chỉ email của các chủ tài khoản trong một nhóm tuổi nhất định?

Alexander Kubelski (10:19 sáng)

Tôi hiểu ý cô rồi. Tôi muốn gửi email cho các chủ tài khoản từ 55 đến 65 tuổi để mời họ gặp chuyên gia lập kế hoạch hưu trí. Tôi có phải nộp mẫu yêu cầu dự án mới không?

Bora Choi (10:21 sáng)

Điều đó không cần thiết đâu, ông Kubelski. Chúng tôi có thể cập nhật mẫu yêu cầu hiện tại cho ông. Ông sẽ không muốn mất vị trí của mình trong hàng đợi đâu.

Alexander Kubelski (10:21 sáng)

Tuyệt vời, cảm ơn cô! Cô có thể gửi danh sách đó cho tôi ngay lập tức được không?

Marlys Barry (10:22 sáng)

Có một vài dự án đang xếp hàng trước dự án của ông.

Alexander Kubelski (10:23 sáng)

Tôi đã hy vọng gửi thư mời qua email vào ngày mai.

Marlys Barry (10:24 sáng)

Chúng tôi sẽ xử lý nó ngay khi có thể.', '', '', '5b16a09d-4c11-44bb-a1e9-f4b34c91efbf', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('4c2dff38-f74d-417a-9bc8-e29411e9df8f', 'ets-imported-test', 174, 7, 'reading', 'What does Ms. Choi offer to do?', 'Write an e-mail', 'Make a change to a form', 'Open an account', 'Revise a policy', 'B', 'Marlys Barry (10:17 sáng)

Tôi là Barry từ bộ phận phân tích dữ liệu. Tôi có bao gồm đồng nghiệp của mình, cô Choi. Chúng tôi liên hệ với ông về yêu cầu dữ liệu địa chỉ email của tất cả các chủ tài khoản, được sắp xếp theo độ tuổi.

Alexander Kubelski (10:17 sáng)

Vâng, các bạn có thể hoàn thành yêu cầu sớm đến mức nào?

Marlys Barry (10:18 sáng)

Tôi có một câu hỏi cho ông trước. Ông có thực sự cần địa chỉ email của tất cả các chủ tài khoản không? Đó sẽ là một tệp rất lớn. Hay ông chỉ cần địa chỉ email của các chủ tài khoản trong một nhóm tuổi nhất định?

Alexander Kubelski (10:19 sáng)

Tôi hiểu ý cô rồi. Tôi muốn gửi email cho các chủ tài khoản từ 55 đến 65 tuổi để mời họ gặp chuyên gia lập kế hoạch hưu trí. Tôi có phải nộp mẫu yêu cầu dự án mới không?

Bora Choi (10:21 sáng)

Điều đó không cần thiết đâu, ông Kubelski. Chúng tôi có thể cập nhật mẫu yêu cầu hiện tại cho ông. Ông sẽ không muốn mất vị trí của mình trong hàng đợi đâu.

Alexander Kubelski (10:21 sáng)

Tuyệt vời, cảm ơn cô! Cô có thể gửi danh sách đó cho tôi ngay lập tức được không?

Marlys Barry (10:22 sáng)

Có một vài dự án đang xếp hàng trước dự án của ông.

Alexander Kubelski (10:23 sáng)

Tôi đã hy vọng gửi thư mời qua email vào ngày mai.

Marlys Barry (10:24 sáng)

Chúng tôi sẽ xử lý nó ngay khi có thể.', '', '', '5b16a09d-4c11-44bb-a1e9-f4b34c91efbf', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('88200043-7913-4810-be35-3a871a86cee9', 'ets-imported-test', 175, 7, 'reading', 'At 10:22 A.M., what does Ms. Barry most likely mean when she writes, “There are several projects ahead of yours”?', 'Ms. Barry will move Mr. Kubelski’s request to the end of the queue.', 'Ms. Barry will not be able to send out the invitations for Mr. Kubelski.', 'Mr. Kubelski’s request will not be the first job Ms. Barry completes.', 'Mr. Kubelski will need to assist with other projects first.', 'C', 'Marlys Barry (10:17 sáng)

Tôi là Barry từ bộ phận phân tích dữ liệu. Tôi có bao gồm đồng nghiệp của mình, cô Choi. Chúng tôi liên hệ với ông về yêu cầu dữ liệu địa chỉ email của tất cả các chủ tài khoản, được sắp xếp theo độ tuổi.

Alexander Kubelski (10:17 sáng)

Vâng, các bạn có thể hoàn thành yêu cầu sớm đến mức nào?

Marlys Barry (10:18 sáng)

Tôi có một câu hỏi cho ông trước. Ông có thực sự cần địa chỉ email của tất cả các chủ tài khoản không? Đó sẽ là một tệp rất lớn. Hay ông chỉ cần địa chỉ email của các chủ tài khoản trong một nhóm tuổi nhất định?

Alexander Kubelski (10:19 sáng)

Tôi hiểu ý cô rồi. Tôi muốn gửi email cho các chủ tài khoản từ 55 đến 65 tuổi để mời họ gặp chuyên gia lập kế hoạch hưu trí. Tôi có phải nộp mẫu yêu cầu dự án mới không?

Bora Choi (10:21 sáng)

Điều đó không cần thiết đâu, ông Kubelski. Chúng tôi có thể cập nhật mẫu yêu cầu hiện tại cho ông. Ông sẽ không muốn mất vị trí của mình trong hàng đợi đâu.

Alexander Kubelski (10:21 sáng)

Tuyệt vời, cảm ơn cô! Cô có thể gửi danh sách đó cho tôi ngay lập tức được không?

Marlys Barry (10:22 sáng)

Có một vài dự án đang xếp hàng trước dự án của ông.

Alexander Kubelski (10:23 sáng)

Tôi đã hy vọng gửi thư mời qua email vào ngày mai.

Marlys Barry (10:24 sáng)

Chúng tôi sẽ xử lý nó ngay khi có thể.', '', '', '5b16a09d-4c11-44bb-a1e9-f4b34c91efbf', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('520c0944-44b0-4959-a269-7a08277bb05b', 'ets-imported-test', 176, 7, 'reading', 'According to the article, what is one way that food truck owners traditionally attract customers?', 'By word of mouth', 'From highway billboards', 'Through newspaper advertisements', 'From signs at food festivals', 'A', 'Mẹo thiết kế trang web cho doanh nghiệp xe bán đồ ăn

Các chủ xe bán đồ ăn di chuyển từ nơi này sang nơi khác, trong và giữa các thành phố khi họ kinh doanh, vì vậy họ thường dựa vào truyền miệng hoặc mạng xã hội để thu hút khách hàng. Kết quả là, họ có thể không xây dựng trang web của riêng mình. Nhưng trên thực tế, do bản chất kinh doanh của mình, điều quan trọng là các chủ xe bán đồ ăn phải có một nơi cố định để công chúng tìm hiểu về họ, đặt hàng, liên hệ, v.v. Hơn nữa, nghiên cứu thị trường cho thấy một trang web có thể giúp xây dựng lượng khách hàng thân thiết. Vì vậy, dưới đây là một số mẹo để phát triển một trang web tuyệt vời cho xe bán đồ ăn của bạn.

Trang chủ (Home page) nên có đồ họa đậm nét cùng với tên xe bán đồ ăn của bạn. Văn bản phải hiển thị nổi bật các thông tin chính, chẳng hạn như vị trí của xe và giờ hoạt động. Các biểu mẫu trực tuyến với các ô để điền thông tin, chẳng hạn như yêu cầu đặt chỗ cho các sự kiện hoặc dịch vụ đặc biệt, cung cấp cho khách truy cập mới quá nhiều thông tin trực quan. Chúng tốt hơn nên được kết hợp dưới dạng các liên kết hoặc cửa sổ bật lên (pop-up).

Trang Thực đơn (Food Menu) cần những hình ảnh hấp dẫn, độ phân giải cao cùng với văn bản sống động và chính xác mô tả chi tiết từng món ăn. Hãy nhớ rằng ảnh của bạn nên đủ lớn để trông hấp dẫn trên màn hình máy tính lớn hơn.

Trang Về chúng tôi (About Us) nên bao gồm một số nội dung giải thích chủ đề và ý tưởng của xe bán đồ ăn, và một số dữ liệu tiểu sử chi tiết về nền tảng của bạn trong ngành thực phẩm.

Trang Tin tức (News page) có thể bao gồm văn bản thông báo cho khách truy cập về các món ăn theo mùa và các chương trình khuyến mãi sắp tới hoặc các sự kiện đặc biệt như lễ hội ẩm thực.

---

Gửi: Doug Abruzzo

Từ: Ed Vale

Ngày: 29 tháng 3

Chủ đề: Phản hồi

Thân gửi ông Abruzzo,

Cảm ơn ông một lần nữa vì đã tạo ra trang web mẫu cho doanh nghiệp xe bán đồ ăn của tôi. Tôi chỉ muốn nhắc lại rằng nó đã nhận được phản hồi tích cực từ những khách hàng đã dùng thử. Tôi rất vui vì chúng ta đã làm theo lời khuyên trong bài báo mà ông gửi cho tôi về thiết kế trang web cho xe bán đồ ăn!

Như chúng ta đã thảo luận trong cuộc gọi điện thoại ngày hôm qua, chúng tôi sẽ tiến hành trang web mẫu và ra mắt nó như trang web chính thức vào ngày 5 tháng 4. Tuy nhiên, tôi vẫn không thấy thông tin tôi đã gửi về chương trình khuyến mãi mới của chúng tôi sẽ bắt đầu vào giữa tháng 4, một món tráng miệng miễn phí với bất kỳ giao dịch mua bánh sandwich nào. Vui lòng đảm bảo thêm thông tin quan trọng này trước khi chúng tôi ra mắt trang web.

Trân trọng,

Ed', '', '', 'faa3506d-efb5-439e-aa4f-399c59504094', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('01275921-c8cd-43f0-9817-928cfda49626', 'ets-imported-test', 177, 7, 'reading', 'According to the article, what information does not need to appear on the Home page?', 'Truck locations', 'Hours of operation', 'Company name', 'Seasonal food items', 'D', 'Mẹo thiết kế trang web cho doanh nghiệp xe bán đồ ăn

Các chủ xe bán đồ ăn di chuyển từ nơi này sang nơi khác, trong và giữa các thành phố khi họ kinh doanh, vì vậy họ thường dựa vào truyền miệng hoặc mạng xã hội để thu hút khách hàng. Kết quả là, họ có thể không xây dựng trang web của riêng mình. Nhưng trên thực tế, do bản chất kinh doanh của mình, điều quan trọng là các chủ xe bán đồ ăn phải có một nơi cố định để công chúng tìm hiểu về họ, đặt hàng, liên hệ, v.v. Hơn nữa, nghiên cứu thị trường cho thấy một trang web có thể giúp xây dựng lượng khách hàng thân thiết. Vì vậy, dưới đây là một số mẹo để phát triển một trang web tuyệt vời cho xe bán đồ ăn của bạn.

Trang chủ (Home page) nên có đồ họa đậm nét cùng với tên xe bán đồ ăn của bạn. Văn bản phải hiển thị nổi bật các thông tin chính, chẳng hạn như vị trí của xe và giờ hoạt động. Các biểu mẫu trực tuyến với các ô để điền thông tin, chẳng hạn như yêu cầu đặt chỗ cho các sự kiện hoặc dịch vụ đặc biệt, cung cấp cho khách truy cập mới quá nhiều thông tin trực quan. Chúng tốt hơn nên được kết hợp dưới dạng các liên kết hoặc cửa sổ bật lên (pop-up).

Trang Thực đơn (Food Menu) cần những hình ảnh hấp dẫn, độ phân giải cao cùng với văn bản sống động và chính xác mô tả chi tiết từng món ăn. Hãy nhớ rằng ảnh của bạn nên đủ lớn để trông hấp dẫn trên màn hình máy tính lớn hơn.

Trang Về chúng tôi (About Us) nên bao gồm một số nội dung giải thích chủ đề và ý tưởng của xe bán đồ ăn, và một số dữ liệu tiểu sử chi tiết về nền tảng của bạn trong ngành thực phẩm.

Trang Tin tức (News page) có thể bao gồm văn bản thông báo cho khách truy cập về các món ăn theo mùa và các chương trình khuyến mãi sắp tới hoặc các sự kiện đặc biệt như lễ hội ẩm thực.

---

Gửi: Doug Abruzzo

Từ: Ed Vale

Ngày: 29 tháng 3

Chủ đề: Phản hồi

Thân gửi ông Abruzzo,

Cảm ơn ông một lần nữa vì đã tạo ra trang web mẫu cho doanh nghiệp xe bán đồ ăn của tôi. Tôi chỉ muốn nhắc lại rằng nó đã nhận được phản hồi tích cực từ những khách hàng đã dùng thử. Tôi rất vui vì chúng ta đã làm theo lời khuyên trong bài báo mà ông gửi cho tôi về thiết kế trang web cho xe bán đồ ăn!

Như chúng ta đã thảo luận trong cuộc gọi điện thoại ngày hôm qua, chúng tôi sẽ tiến hành trang web mẫu và ra mắt nó như trang web chính thức vào ngày 5 tháng 4. Tuy nhiên, tôi vẫn không thấy thông tin tôi đã gửi về chương trình khuyến mãi mới của chúng tôi sẽ bắt đầu vào giữa tháng 4, một món tráng miệng miễn phí với bất kỳ giao dịch mua bánh sandwich nào. Vui lòng đảm bảo thêm thông tin quan trọng này trước khi chúng tôi ra mắt trang web.

Trân trọng,

Ed', '', '', 'faa3506d-efb5-439e-aa4f-399c59504094', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('e6a66f63-011e-40f5-96e3-56f69a2ee96e', 'ets-imported-test', 178, 7, 'reading', 'In what field does Mr. Abruzzo most likely work?', 'Market research', 'Catering', 'Web design', 'Package delivery', 'C', 'Mẹo thiết kế trang web cho doanh nghiệp xe bán đồ ăn

Các chủ xe bán đồ ăn di chuyển từ nơi này sang nơi khác, trong và giữa các thành phố khi họ kinh doanh, vì vậy họ thường dựa vào truyền miệng hoặc mạng xã hội để thu hút khách hàng. Kết quả là, họ có thể không xây dựng trang web của riêng mình. Nhưng trên thực tế, do bản chất kinh doanh của mình, điều quan trọng là các chủ xe bán đồ ăn phải có một nơi cố định để công chúng tìm hiểu về họ, đặt hàng, liên hệ, v.v. Hơn nữa, nghiên cứu thị trường cho thấy một trang web có thể giúp xây dựng lượng khách hàng thân thiết. Vì vậy, dưới đây là một số mẹo để phát triển một trang web tuyệt vời cho xe bán đồ ăn của bạn.

Trang chủ (Home page) nên có đồ họa đậm nét cùng với tên xe bán đồ ăn của bạn. Văn bản phải hiển thị nổi bật các thông tin chính, chẳng hạn như vị trí của xe và giờ hoạt động. Các biểu mẫu trực tuyến với các ô để điền thông tin, chẳng hạn như yêu cầu đặt chỗ cho các sự kiện hoặc dịch vụ đặc biệt, cung cấp cho khách truy cập mới quá nhiều thông tin trực quan. Chúng tốt hơn nên được kết hợp dưới dạng các liên kết hoặc cửa sổ bật lên (pop-up).

Trang Thực đơn (Food Menu) cần những hình ảnh hấp dẫn, độ phân giải cao cùng với văn bản sống động và chính xác mô tả chi tiết từng món ăn. Hãy nhớ rằng ảnh của bạn nên đủ lớn để trông hấp dẫn trên màn hình máy tính lớn hơn.

Trang Về chúng tôi (About Us) nên bao gồm một số nội dung giải thích chủ đề và ý tưởng của xe bán đồ ăn, và một số dữ liệu tiểu sử chi tiết về nền tảng của bạn trong ngành thực phẩm.

Trang Tin tức (News page) có thể bao gồm văn bản thông báo cho khách truy cập về các món ăn theo mùa và các chương trình khuyến mãi sắp tới hoặc các sự kiện đặc biệt như lễ hội ẩm thực.

---

Gửi: Doug Abruzzo

Từ: Ed Vale

Ngày: 29 tháng 3

Chủ đề: Phản hồi

Thân gửi ông Abruzzo,

Cảm ơn ông một lần nữa vì đã tạo ra trang web mẫu cho doanh nghiệp xe bán đồ ăn của tôi. Tôi chỉ muốn nhắc lại rằng nó đã nhận được phản hồi tích cực từ những khách hàng đã dùng thử. Tôi rất vui vì chúng ta đã làm theo lời khuyên trong bài báo mà ông gửi cho tôi về thiết kế trang web cho xe bán đồ ăn!

Như chúng ta đã thảo luận trong cuộc gọi điện thoại ngày hôm qua, chúng tôi sẽ tiến hành trang web mẫu và ra mắt nó như trang web chính thức vào ngày 5 tháng 4. Tuy nhiên, tôi vẫn không thấy thông tin tôi đã gửi về chương trình khuyến mãi mới của chúng tôi sẽ bắt đầu vào giữa tháng 4, một món tráng miệng miễn phí với bất kỳ giao dịch mua bánh sandwich nào. Vui lòng đảm bảo thêm thông tin quan trọng này trước khi chúng tôi ra mắt trang web.

Trân trọng,

Ed', '', '', 'faa3506d-efb5-439e-aa4f-399c59504094', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('4c8f0a29-e8b0-4d08-80b4-bee966a62bf6', 'ets-imported-test', 179, 7, 'reading', 'In which section of the Web site will information most likely be added?', 'The Home page', 'The Food Menu page', 'The About Us page', 'The News page', 'D', 'Mẹo thiết kế trang web cho doanh nghiệp xe bán đồ ăn

Các chủ xe bán đồ ăn di chuyển từ nơi này sang nơi khác, trong và giữa các thành phố khi họ kinh doanh, vì vậy họ thường dựa vào truyền miệng hoặc mạng xã hội để thu hút khách hàng. Kết quả là, họ có thể không xây dựng trang web của riêng mình. Nhưng trên thực tế, do bản chất kinh doanh của mình, điều quan trọng là các chủ xe bán đồ ăn phải có một nơi cố định để công chúng tìm hiểu về họ, đặt hàng, liên hệ, v.v. Hơn nữa, nghiên cứu thị trường cho thấy một trang web có thể giúp xây dựng lượng khách hàng thân thiết. Vì vậy, dưới đây là một số mẹo để phát triển một trang web tuyệt vời cho xe bán đồ ăn của bạn.

Trang chủ (Home page) nên có đồ họa đậm nét cùng với tên xe bán đồ ăn của bạn. Văn bản phải hiển thị nổi bật các thông tin chính, chẳng hạn như vị trí của xe và giờ hoạt động. Các biểu mẫu trực tuyến với các ô để điền thông tin, chẳng hạn như yêu cầu đặt chỗ cho các sự kiện hoặc dịch vụ đặc biệt, cung cấp cho khách truy cập mới quá nhiều thông tin trực quan. Chúng tốt hơn nên được kết hợp dưới dạng các liên kết hoặc cửa sổ bật lên (pop-up).

Trang Thực đơn (Food Menu) cần những hình ảnh hấp dẫn, độ phân giải cao cùng với văn bản sống động và chính xác mô tả chi tiết từng món ăn. Hãy nhớ rằng ảnh của bạn nên đủ lớn để trông hấp dẫn trên màn hình máy tính lớn hơn.

Trang Về chúng tôi (About Us) nên bao gồm một số nội dung giải thích chủ đề và ý tưởng của xe bán đồ ăn, và một số dữ liệu tiểu sử chi tiết về nền tảng của bạn trong ngành thực phẩm.

Trang Tin tức (News page) có thể bao gồm văn bản thông báo cho khách truy cập về các món ăn theo mùa và các chương trình khuyến mãi sắp tới hoặc các sự kiện đặc biệt như lễ hội ẩm thực.

---

Gửi: Doug Abruzzo

Từ: Ed Vale

Ngày: 29 tháng 3

Chủ đề: Phản hồi

Thân gửi ông Abruzzo,

Cảm ơn ông một lần nữa vì đã tạo ra trang web mẫu cho doanh nghiệp xe bán đồ ăn của tôi. Tôi chỉ muốn nhắc lại rằng nó đã nhận được phản hồi tích cực từ những khách hàng đã dùng thử. Tôi rất vui vì chúng ta đã làm theo lời khuyên trong bài báo mà ông gửi cho tôi về thiết kế trang web cho xe bán đồ ăn!

Như chúng ta đã thảo luận trong cuộc gọi điện thoại ngày hôm qua, chúng tôi sẽ tiến hành trang web mẫu và ra mắt nó như trang web chính thức vào ngày 5 tháng 4. Tuy nhiên, tôi vẫn không thấy thông tin tôi đã gửi về chương trình khuyến mãi mới của chúng tôi sẽ bắt đầu vào giữa tháng 4, một món tráng miệng miễn phí với bất kỳ giao dịch mua bánh sandwich nào. Vui lòng đảm bảo thêm thông tin quan trọng này trước khi chúng tôi ra mắt trang web.

Trân trọng,

Ed', '', '', 'faa3506d-efb5-439e-aa4f-399c59504094', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('31c693f0-cd71-4f64-9254-624404fe603e', 'ets-imported-test', 180, 7, 'reading', 'According to the e-mail, when will the Web site launch?', 'On March 28', 'On March 29', 'On April 5', 'On April 15', 'C', 'Mẹo thiết kế trang web cho doanh nghiệp xe bán đồ ăn

Các chủ xe bán đồ ăn di chuyển từ nơi này sang nơi khác, trong và giữa các thành phố khi họ kinh doanh, vì vậy họ thường dựa vào truyền miệng hoặc mạng xã hội để thu hút khách hàng. Kết quả là, họ có thể không xây dựng trang web của riêng mình. Nhưng trên thực tế, do bản chất kinh doanh của mình, điều quan trọng là các chủ xe bán đồ ăn phải có một nơi cố định để công chúng tìm hiểu về họ, đặt hàng, liên hệ, v.v. Hơn nữa, nghiên cứu thị trường cho thấy một trang web có thể giúp xây dựng lượng khách hàng thân thiết. Vì vậy, dưới đây là một số mẹo để phát triển một trang web tuyệt vời cho xe bán đồ ăn của bạn.

Trang chủ (Home page) nên có đồ họa đậm nét cùng với tên xe bán đồ ăn của bạn. Văn bản phải hiển thị nổi bật các thông tin chính, chẳng hạn như vị trí của xe và giờ hoạt động. Các biểu mẫu trực tuyến với các ô để điền thông tin, chẳng hạn như yêu cầu đặt chỗ cho các sự kiện hoặc dịch vụ đặc biệt, cung cấp cho khách truy cập mới quá nhiều thông tin trực quan. Chúng tốt hơn nên được kết hợp dưới dạng các liên kết hoặc cửa sổ bật lên (pop-up).

Trang Thực đơn (Food Menu) cần những hình ảnh hấp dẫn, độ phân giải cao cùng với văn bản sống động và chính xác mô tả chi tiết từng món ăn. Hãy nhớ rằng ảnh của bạn nên đủ lớn để trông hấp dẫn trên màn hình máy tính lớn hơn.

Trang Về chúng tôi (About Us) nên bao gồm một số nội dung giải thích chủ đề và ý tưởng của xe bán đồ ăn, và một số dữ liệu tiểu sử chi tiết về nền tảng của bạn trong ngành thực phẩm.

Trang Tin tức (News page) có thể bao gồm văn bản thông báo cho khách truy cập về các món ăn theo mùa và các chương trình khuyến mãi sắp tới hoặc các sự kiện đặc biệt như lễ hội ẩm thực.

---

Gửi: Doug Abruzzo

Từ: Ed Vale

Ngày: 29 tháng 3

Chủ đề: Phản hồi

Thân gửi ông Abruzzo,

Cảm ơn ông một lần nữa vì đã tạo ra trang web mẫu cho doanh nghiệp xe bán đồ ăn của tôi. Tôi chỉ muốn nhắc lại rằng nó đã nhận được phản hồi tích cực từ những khách hàng đã dùng thử. Tôi rất vui vì chúng ta đã làm theo lời khuyên trong bài báo mà ông gửi cho tôi về thiết kế trang web cho xe bán đồ ăn!

Như chúng ta đã thảo luận trong cuộc gọi điện thoại ngày hôm qua, chúng tôi sẽ tiến hành trang web mẫu và ra mắt nó như trang web chính thức vào ngày 5 tháng 4. Tuy nhiên, tôi vẫn không thấy thông tin tôi đã gửi về chương trình khuyến mãi mới của chúng tôi sẽ bắt đầu vào giữa tháng 4, một món tráng miệng miễn phí với bất kỳ giao dịch mua bánh sandwich nào. Vui lòng đảm bảo thêm thông tin quan trọng này trước khi chúng tôi ra mắt trang web.

Trân trọng,

Ed', '', '', 'faa3506d-efb5-439e-aa4f-399c59504094', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('32532445-db94-4e72-916a-b87ef9e16cad', 'ets-imported-test', 181, 7, 'reading', 'What is indicated about the Net Zero Initiative?', 'It is being funded by the Red Hills Business Association.', 'It was inspired by similar initiatives in other cities.', 'It will use geothermal energy to power a city.', 'It will change the way an institution heats its buildings.', 'D', 'Gửi: Manny Green

Từ: John LaRose

Ngày: 18 tháng 5

Chủ đề: Thông báo khoan

Thân gửi ông Green:

Với tư cách là một phép lịch sự, tôi viết thư cho ông tại Hiệp hội Kinh doanh Red Hills, nhờ ông giúp tôi gửi thông tin này đến các thành viên của ông. Đã có thông báo trên tờ Daily Gazette tháng trước rằng Đại học Rilamore đang tiến hành Sáng kiến Net Zero. Trong vòng ba năm, chúng tôi dự kiến sẽ lắp đặt và vận hành các giếng địa nhiệt để sưởi ấm và làm mát toàn bộ khuôn viên trường. Việc hạn chế sự phụ thuộc của tổ chức vào nhiên liệu hóa thạch từ lâu đã là một mục tiêu, và hệ thống mới là một bước đi quan trọng hướng tới việc đạt được mục tiêu đó.

Trong tháng tới, chúng tôi sẽ tiến hành khoan thử nghiệm tại một số địa điểm trong khuôn viên trường. Nếu mọi việc diễn ra theo đúng kế hoạch, đội ngũ sẽ khoan liền kề với Khu Kinh doanh Red Hills và Chung cư Oak Street bắt đầu từ Thứ Tư, ngày 5 tháng 6. Chúng tôi muốn thông báo cho các chủ doanh nghiệp và cư dân gần khuôn viên trường chuẩn bị tinh thần cho mức độ tiếng ồn cao hơn bình thường trong hai tuần mà chúng tôi ước tính sẽ mất để hoàn thành công việc. Giờ làm việc của đội khoan là từ 10 giờ sáng đến 3 giờ chiều mỗi ngày, từ Thứ Hai đến Thứ Sáu.

Chúng tôi xin lỗi trước về sự bất tiện mà điều này có thể gây ra cho những người hàng xóm. Mọi câu hỏi hoặc thắc mắc nên được gửi trực tiếp cho tôi theo số 813-555-0123.

John LaRose

Liên lạc viên cộng đồng, Văn phòng Truyền thông Đại học Rilamore

---

THÔNG CÁO BÁO CHÍ

Liên hệ: Manny Green

RED HILLS (Ngày 25 tháng 5) — Hiệp hội Kinh doanh Red Hills đang thay đổi ngày diễn ra Chuỗi Hòa nhạc Giờ Ăn trưa rất được mong đợi. Thông thường được tổ chức vào mỗi Thứ Năm trong tháng Sáu, bốn buổi hòa nhạc miễn phí thay vào đó sẽ diễn ra vào mỗi Thứ Năm trong tháng Bảy. Danh sách nghệ sĩ vẫn không thay đổi — nhóm Jaystone Jazz Trio sẽ mở màn chuỗi chương trình vào ngày 4 tháng 7, tiếp theo vào các Thứ Năm kế tiếp là Joss and the Jaybirds, Ray Starform và Barklay Bass Quintet.

Như thường lệ, cả ba dãy phố của đường Oak Street sẽ bị cấm lưu thông, các nhà hàng sẽ phục vụ bữa trưa tại các bàn ngoài trời, và các nhà bán lẻ đồ thủ công mỹ nghệ địa phương sẽ trưng bày tác phẩm của họ trên bãi cỏ của Trung tâm Văn hóa. Đây là một sự kiện ăn mừng tuyệt vời tại trung tâm của một khu phố Red Hills sầm uất. Chúng tôi hy vọng sẽ gặp bạn ở đó!', '', '', 'd54069b2-068b-48ab-af19-0f9d17b3cdd0', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('ed216a23-42e2-4305-9c42-5c8609d0fee1', 'ets-imported-test', 182, 7, 'reading', 'In the e-mail, the word “conduct” in paragraph 2, line 1, is closest in meaning to', 'behave', 'accompany', 'transmit', 'carry out', 'D', 'Gửi: Manny Green

Từ: John LaRose

Ngày: 18 tháng 5

Chủ đề: Thông báo khoan

Thân gửi ông Green:

Với tư cách là một phép lịch sự, tôi viết thư cho ông tại Hiệp hội Kinh doanh Red Hills, nhờ ông giúp tôi gửi thông tin này đến các thành viên của ông. Đã có thông báo trên tờ Daily Gazette tháng trước rằng Đại học Rilamore đang tiến hành Sáng kiến Net Zero. Trong vòng ba năm, chúng tôi dự kiến sẽ lắp đặt và vận hành các giếng địa nhiệt để sưởi ấm và làm mát toàn bộ khuôn viên trường. Việc hạn chế sự phụ thuộc của tổ chức vào nhiên liệu hóa thạch từ lâu đã là một mục tiêu, và hệ thống mới là một bước đi quan trọng hướng tới việc đạt được mục tiêu đó.

Trong tháng tới, chúng tôi sẽ tiến hành khoan thử nghiệm tại một số địa điểm trong khuôn viên trường. Nếu mọi việc diễn ra theo đúng kế hoạch, đội ngũ sẽ khoan liền kề với Khu Kinh doanh Red Hills và Chung cư Oak Street bắt đầu từ Thứ Tư, ngày 5 tháng 6. Chúng tôi muốn thông báo cho các chủ doanh nghiệp và cư dân gần khuôn viên trường chuẩn bị tinh thần cho mức độ tiếng ồn cao hơn bình thường trong hai tuần mà chúng tôi ước tính sẽ mất để hoàn thành công việc. Giờ làm việc của đội khoan là từ 10 giờ sáng đến 3 giờ chiều mỗi ngày, từ Thứ Hai đến Thứ Sáu.

Chúng tôi xin lỗi trước về sự bất tiện mà điều này có thể gây ra cho những người hàng xóm. Mọi câu hỏi hoặc thắc mắc nên được gửi trực tiếp cho tôi theo số 813-555-0123.

John LaRose

Liên lạc viên cộng đồng, Văn phòng Truyền thông Đại học Rilamore

---

THÔNG CÁO BÁO CHÍ

Liên hệ: Manny Green

RED HILLS (Ngày 25 tháng 5) — Hiệp hội Kinh doanh Red Hills đang thay đổi ngày diễn ra Chuỗi Hòa nhạc Giờ Ăn trưa rất được mong đợi. Thông thường được tổ chức vào mỗi Thứ Năm trong tháng Sáu, bốn buổi hòa nhạc miễn phí thay vào đó sẽ diễn ra vào mỗi Thứ Năm trong tháng Bảy. Danh sách nghệ sĩ vẫn không thay đổi — nhóm Jaystone Jazz Trio sẽ mở màn chuỗi chương trình vào ngày 4 tháng 7, tiếp theo vào các Thứ Năm kế tiếp là Joss and the Jaybirds, Ray Starform và Barklay Bass Quintet.

Như thường lệ, cả ba dãy phố của đường Oak Street sẽ bị cấm lưu thông, các nhà hàng sẽ phục vụ bữa trưa tại các bàn ngoài trời, và các nhà bán lẻ đồ thủ công mỹ nghệ địa phương sẽ trưng bày tác phẩm của họ trên bãi cỏ của Trung tâm Văn hóa. Đây là một sự kiện ăn mừng tuyệt vời tại trung tâm của một khu phố Red Hills sầm uất. Chúng tôi hy vọng sẽ gặp bạn ở đó!', '', '', 'd54069b2-068b-48ab-af19-0f9d17b3cdd0', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('6634ddb7-9575-45a0-84df-fb4d61df8046', 'ets-imported-test', 183, 7, 'reading', 'What can be concluded about the Red Hills Business District?', 'It is located near a university campus.', 'It hosts an arts festival every July.', 'It includes the Oak Street Apartments.', 'It is home to the offices of the Daily Gazette.', 'A', 'Gửi: Manny Green

Từ: John LaRose

Ngày: 18 tháng 5

Chủ đề: Thông báo khoan

Thân gửi ông Green:

Với tư cách là một phép lịch sự, tôi viết thư cho ông tại Hiệp hội Kinh doanh Red Hills, nhờ ông giúp tôi gửi thông tin này đến các thành viên của ông. Đã có thông báo trên tờ Daily Gazette tháng trước rằng Đại học Rilamore đang tiến hành Sáng kiến Net Zero. Trong vòng ba năm, chúng tôi dự kiến sẽ lắp đặt và vận hành các giếng địa nhiệt để sưởi ấm và làm mát toàn bộ khuôn viên trường. Việc hạn chế sự phụ thuộc của tổ chức vào nhiên liệu hóa thạch từ lâu đã là một mục tiêu, và hệ thống mới là một bước đi quan trọng hướng tới việc đạt được mục tiêu đó.

Trong tháng tới, chúng tôi sẽ tiến hành khoan thử nghiệm tại một số địa điểm trong khuôn viên trường. Nếu mọi việc diễn ra theo đúng kế hoạch, đội ngũ sẽ khoan liền kề với Khu Kinh doanh Red Hills và Chung cư Oak Street bắt đầu từ Thứ Tư, ngày 5 tháng 6. Chúng tôi muốn thông báo cho các chủ doanh nghiệp và cư dân gần khuôn viên trường chuẩn bị tinh thần cho mức độ tiếng ồn cao hơn bình thường trong hai tuần mà chúng tôi ước tính sẽ mất để hoàn thành công việc. Giờ làm việc của đội khoan là từ 10 giờ sáng đến 3 giờ chiều mỗi ngày, từ Thứ Hai đến Thứ Sáu.

Chúng tôi xin lỗi trước về sự bất tiện mà điều này có thể gây ra cho những người hàng xóm. Mọi câu hỏi hoặc thắc mắc nên được gửi trực tiếp cho tôi theo số 813-555-0123.

John LaRose

Liên lạc viên cộng đồng, Văn phòng Truyền thông Đại học Rilamore

---

THÔNG CÁO BÁO CHÍ

Liên hệ: Manny Green

RED HILLS (Ngày 25 tháng 5) — Hiệp hội Kinh doanh Red Hills đang thay đổi ngày diễn ra Chuỗi Hòa nhạc Giờ Ăn trưa rất được mong đợi. Thông thường được tổ chức vào mỗi Thứ Năm trong tháng Sáu, bốn buổi hòa nhạc miễn phí thay vào đó sẽ diễn ra vào mỗi Thứ Năm trong tháng Bảy. Danh sách nghệ sĩ vẫn không thay đổi — nhóm Jaystone Jazz Trio sẽ mở màn chuỗi chương trình vào ngày 4 tháng 7, tiếp theo vào các Thứ Năm kế tiếp là Joss and the Jaybirds, Ray Starform và Barklay Bass Quintet.

Như thường lệ, cả ba dãy phố của đường Oak Street sẽ bị cấm lưu thông, các nhà hàng sẽ phục vụ bữa trưa tại các bàn ngoài trời, và các nhà bán lẻ đồ thủ công mỹ nghệ địa phương sẽ trưng bày tác phẩm của họ trên bãi cỏ của Trung tâm Văn hóa. Đây là một sự kiện ăn mừng tuyệt vời tại trung tâm của một khu phố Red Hills sầm uất. Chúng tôi hy vọng sẽ gặp bạn ở đó!', '', '', 'd54069b2-068b-48ab-af19-0f9d17b3cdd0', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('2b9246d2-6305-4c1a-b50a-badc833c030f', 'ets-imported-test', 184, 7, 'reading', 'Why most likely did the Red Hills Business Association change the dates of its concert series?', 'To take advantage of a new power source', 'To accommodate students’ schedules', 'To avoid noise from nearby construction', 'To prevent a conflict with a similar event', 'C', 'Gửi: Manny Green

Từ: John LaRose

Ngày: 18 tháng 5

Chủ đề: Thông báo khoan

Thân gửi ông Green:

Với tư cách là một phép lịch sự, tôi viết thư cho ông tại Hiệp hội Kinh doanh Red Hills, nhờ ông giúp tôi gửi thông tin này đến các thành viên của ông. Đã có thông báo trên tờ Daily Gazette tháng trước rằng Đại học Rilamore đang tiến hành Sáng kiến Net Zero. Trong vòng ba năm, chúng tôi dự kiến sẽ lắp đặt và vận hành các giếng địa nhiệt để sưởi ấm và làm mát toàn bộ khuôn viên trường. Việc hạn chế sự phụ thuộc của tổ chức vào nhiên liệu hóa thạch từ lâu đã là một mục tiêu, và hệ thống mới là một bước đi quan trọng hướng tới việc đạt được mục tiêu đó.

Trong tháng tới, chúng tôi sẽ tiến hành khoan thử nghiệm tại một số địa điểm trong khuôn viên trường. Nếu mọi việc diễn ra theo đúng kế hoạch, đội ngũ sẽ khoan liền kề với Khu Kinh doanh Red Hills và Chung cư Oak Street bắt đầu từ Thứ Tư, ngày 5 tháng 6. Chúng tôi muốn thông báo cho các chủ doanh nghiệp và cư dân gần khuôn viên trường chuẩn bị tinh thần cho mức độ tiếng ồn cao hơn bình thường trong hai tuần mà chúng tôi ước tính sẽ mất để hoàn thành công việc. Giờ làm việc của đội khoan là từ 10 giờ sáng đến 3 giờ chiều mỗi ngày, từ Thứ Hai đến Thứ Sáu.

Chúng tôi xin lỗi trước về sự bất tiện mà điều này có thể gây ra cho những người hàng xóm. Mọi câu hỏi hoặc thắc mắc nên được gửi trực tiếp cho tôi theo số 813-555-0123.

John LaRose

Liên lạc viên cộng đồng, Văn phòng Truyền thông Đại học Rilamore

---

THÔNG CÁO BÁO CHÍ

Liên hệ: Manny Green

RED HILLS (Ngày 25 tháng 5) — Hiệp hội Kinh doanh Red Hills đang thay đổi ngày diễn ra Chuỗi Hòa nhạc Giờ Ăn trưa rất được mong đợi. Thông thường được tổ chức vào mỗi Thứ Năm trong tháng Sáu, bốn buổi hòa nhạc miễn phí thay vào đó sẽ diễn ra vào mỗi Thứ Năm trong tháng Bảy. Danh sách nghệ sĩ vẫn không thay đổi — nhóm Jaystone Jazz Trio sẽ mở màn chuỗi chương trình vào ngày 4 tháng 7, tiếp theo vào các Thứ Năm kế tiếp là Joss and the Jaybirds, Ray Starform và Barklay Bass Quintet.

Như thường lệ, cả ba dãy phố của đường Oak Street sẽ bị cấm lưu thông, các nhà hàng sẽ phục vụ bữa trưa tại các bàn ngoài trời, và các nhà bán lẻ đồ thủ công mỹ nghệ địa phương sẽ trưng bày tác phẩm của họ trên bãi cỏ của Trung tâm Văn hóa. Đây là một sự kiện ăn mừng tuyệt vời tại trung tâm của một khu phố Red Hills sầm uất. Chúng tôi hy vọng sẽ gặp bạn ở đó!', '', '', 'd54069b2-068b-48ab-af19-0f9d17b3cdd0', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('fd056323-ff2b-4133-bd0d-f8ca5120d342', 'ets-imported-test', 185, 7, 'reading', 'What is mentioned in the press release about the Cultural Center?', 'It will provide lunch for musicians.', 'It will have artwork for sale on its property.', 'It will offer arts-and-crafts workshops.', 'It will provide the stage for performers.', 'B', 'Gửi: Manny Green

Từ: John LaRose

Ngày: 18 tháng 5

Chủ đề: Thông báo khoan

Thân gửi ông Green:

Với tư cách là một phép lịch sự, tôi viết thư cho ông tại Hiệp hội Kinh doanh Red Hills, nhờ ông giúp tôi gửi thông tin này đến các thành viên của ông. Đã có thông báo trên tờ Daily Gazette tháng trước rằng Đại học Rilamore đang tiến hành Sáng kiến Net Zero. Trong vòng ba năm, chúng tôi dự kiến sẽ lắp đặt và vận hành các giếng địa nhiệt để sưởi ấm và làm mát toàn bộ khuôn viên trường. Việc hạn chế sự phụ thuộc của tổ chức vào nhiên liệu hóa thạch từ lâu đã là một mục tiêu, và hệ thống mới là một bước đi quan trọng hướng tới việc đạt được mục tiêu đó.

Trong tháng tới, chúng tôi sẽ tiến hành khoan thử nghiệm tại một số địa điểm trong khuôn viên trường. Nếu mọi việc diễn ra theo đúng kế hoạch, đội ngũ sẽ khoan liền kề với Khu Kinh doanh Red Hills và Chung cư Oak Street bắt đầu từ Thứ Tư, ngày 5 tháng 6. Chúng tôi muốn thông báo cho các chủ doanh nghiệp và cư dân gần khuôn viên trường chuẩn bị tinh thần cho mức độ tiếng ồn cao hơn bình thường trong hai tuần mà chúng tôi ước tính sẽ mất để hoàn thành công việc. Giờ làm việc của đội khoan là từ 10 giờ sáng đến 3 giờ chiều mỗi ngày, từ Thứ Hai đến Thứ Sáu.

Chúng tôi xin lỗi trước về sự bất tiện mà điều này có thể gây ra cho những người hàng xóm. Mọi câu hỏi hoặc thắc mắc nên được gửi trực tiếp cho tôi theo số 813-555-0123.

John LaRose

Liên lạc viên cộng đồng, Văn phòng Truyền thông Đại học Rilamore

---

THÔNG CÁO BÁO CHÍ

Liên hệ: Manny Green

RED HILLS (Ngày 25 tháng 5) — Hiệp hội Kinh doanh Red Hills đang thay đổi ngày diễn ra Chuỗi Hòa nhạc Giờ Ăn trưa rất được mong đợi. Thông thường được tổ chức vào mỗi Thứ Năm trong tháng Sáu, bốn buổi hòa nhạc miễn phí thay vào đó sẽ diễn ra vào mỗi Thứ Năm trong tháng Bảy. Danh sách nghệ sĩ vẫn không thay đổi — nhóm Jaystone Jazz Trio sẽ mở màn chuỗi chương trình vào ngày 4 tháng 7, tiếp theo vào các Thứ Năm kế tiếp là Joss and the Jaybirds, Ray Starform và Barklay Bass Quintet.

Như thường lệ, cả ba dãy phố của đường Oak Street sẽ bị cấm lưu thông, các nhà hàng sẽ phục vụ bữa trưa tại các bàn ngoài trời, và các nhà bán lẻ đồ thủ công mỹ nghệ địa phương sẽ trưng bày tác phẩm của họ trên bãi cỏ của Trung tâm Văn hóa. Đây là một sự kiện ăn mừng tuyệt vời tại trung tâm của một khu phố Red Hills sầm uất. Chúng tôi hy vọng sẽ gặp bạn ở đó!', '', '', 'd54069b2-068b-48ab-af19-0f9d17b3cdd0', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('de58ea35-5ded-499b-8e90-973e1de4c16b', 'ets-imported-test', 186, 7, 'reading', 'According to the advertisement, what is one type of work performed by Lawal Home Service?', 'Planting trees', 'Repairing gutters', 'Building home additions', 'Replacing heating systems', 'B', 'Dịch vụ Nhà Lawal: Phục vụ Nam California hơn 40 năm

Lawal Home Service cung cấp các giải pháp về mái nhà và năng lượng mặt trời cho cư dân Nam California tại Inglewood và các khu vực lân cận. Ngoài việc thay thế mái nhà, chúng tôi cung cấp một loạt các dịch vụ, từ cách nhiệt gác mái và phục hồi máng xối đến sửa chữa rò rỉ và lắp đặt các tấm pin mặt trời.

Lawal Home Service tự hào về giao tiếp minh bạch và sự chú trọng đến từng chi tiết. Các giám sát viên dự án của chúng tôi luôn có mặt tại công trường để trả lời các câu hỏi của khách hàng, cung cấp cập nhật và đảm bảo công trường an toàn, sạch sẽ. Để yêu cầu chẩn đoán mái nhà miễn phí, hãy truy cập www.lawalhomeservice.com hoặc gọi cho đại lý đặt chỗ của chúng tôi theo số 310-555-0108.

Mẫu Liên hệ Dịch vụ Nhà Lawal

Hãy tin tưởng các chuyên gia tại Lawal Home Service để chẩn đoán nhu cầu mái nhà của bạn một cách nhanh chóng và chuyên nghiệp. Vui lòng dành vài phút để hoàn thành mẫu với càng nhiều chi tiết càng tốt. Hãy nhớ rằng, tất cả các mái nhà do Lawal lắp đặt đều được bảo hành 25 năm.

(Bảng dữ liệu: Tên: Drew Gerson; Ngày: 12/12; Địa chỉ: 820 North Acacia Street, Inglewood, CA 90301).

Chúng tôi có thể giúp gì cho bạn?: Trong trận bão gió tuần trước, vài tấm lợp mái đã bị xé toạc và cần thay thế. Tôi đang cân nhắc thay toàn bộ mái vì nó đã hơn 30 năm tuổi, và nước đã bắt đầu nhỏ giọt qua phần trên hiên nhà. Tôi sẽ rất cảm kích nếu được nói chuyện với ai đó có thể cho tôi biết các lựa chọn và cung cấp bản ước tính.

Đánh giá từ khu dân cư: Dịch vụ Nhà Lawal

5 sao - "Tôi rất hài lòng với sự kỹ lưỡng trong công việc của họ."

Tôi đã để lại mô tả về vấn đề của mình cho Lawal Home Service, và một trong những chuyên gia ước tính của công ty đã đến kiểm tra mái nhà của tôi ngay ngày hôm sau. Sau khi tôi quyết định thay mái, đội ngũ Lawal đã có thể bắt đầu làm việc vào tuần sau đó. Diana Perez đã có mặt tại công trường trong suốt quá trình làm việc như đã hứa và trả lời mọi câu hỏi của tôi. Công việc bắt đầu vào ngày 19/12 và kết thúc vào ngày 20/12. Sau khi lợp mái xong, đội ngũ đã dọn dẹp rất tốt. Họ đã sử dụng hai thiết bị nam châm giống như máy cắt cỏ và quét qua toàn bộ bãi cỏ của tôi để tìm bất kỳ chiếc đinh lợp mái nào bị rơi. Tôi chưa bao giờ thấy thứ gì như vậy! Tôi rất hài lòng với sự kỹ lưỡng trong công việc của họ. — Drew Gerson, Inglewood, CA', '', '', 'cb594aff-40ff-4dd4-b919-27c0f5238ec9', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('1e0b9c42-9d36-4689-bf2c-bc33d3eac293', 'ets-imported-test', 187, 7, 'reading', 'What does Mr. Gerson indicate on the form about his roof?', 'It has developed a leak.', 'It was recently replaced.', 'It was not expensive to install.', 'It is under warranty for 30 years.', 'A', 'Dịch vụ Nhà Lawal: Phục vụ Nam California hơn 40 năm

Lawal Home Service cung cấp các giải pháp về mái nhà và năng lượng mặt trời cho cư dân Nam California tại Inglewood và các khu vực lân cận. Ngoài việc thay thế mái nhà, chúng tôi cung cấp một loạt các dịch vụ, từ cách nhiệt gác mái và phục hồi máng xối đến sửa chữa rò rỉ và lắp đặt các tấm pin mặt trời.

Lawal Home Service tự hào về giao tiếp minh bạch và sự chú trọng đến từng chi tiết. Các giám sát viên dự án của chúng tôi luôn có mặt tại công trường để trả lời các câu hỏi của khách hàng, cung cấp cập nhật và đảm bảo công trường an toàn, sạch sẽ. Để yêu cầu chẩn đoán mái nhà miễn phí, hãy truy cập www.lawalhomeservice.com hoặc gọi cho đại lý đặt chỗ của chúng tôi theo số 310-555-0108.

Mẫu Liên hệ Dịch vụ Nhà Lawal

Hãy tin tưởng các chuyên gia tại Lawal Home Service để chẩn đoán nhu cầu mái nhà của bạn một cách nhanh chóng và chuyên nghiệp. Vui lòng dành vài phút để hoàn thành mẫu với càng nhiều chi tiết càng tốt. Hãy nhớ rằng, tất cả các mái nhà do Lawal lắp đặt đều được bảo hành 25 năm.

(Bảng dữ liệu: Tên: Drew Gerson; Ngày: 12/12; Địa chỉ: 820 North Acacia Street, Inglewood, CA 90301).

Chúng tôi có thể giúp gì cho bạn?: Trong trận bão gió tuần trước, vài tấm lợp mái đã bị xé toạc và cần thay thế. Tôi đang cân nhắc thay toàn bộ mái vì nó đã hơn 30 năm tuổi, và nước đã bắt đầu nhỏ giọt qua phần trên hiên nhà. Tôi sẽ rất cảm kích nếu được nói chuyện với ai đó có thể cho tôi biết các lựa chọn và cung cấp bản ước tính.

Đánh giá từ khu dân cư: Dịch vụ Nhà Lawal

5 sao - "Tôi rất hài lòng với sự kỹ lưỡng trong công việc của họ."

Tôi đã để lại mô tả về vấn đề của mình cho Lawal Home Service, và một trong những chuyên gia ước tính của công ty đã đến kiểm tra mái nhà của tôi ngay ngày hôm sau. Sau khi tôi quyết định thay mái, đội ngũ Lawal đã có thể bắt đầu làm việc vào tuần sau đó. Diana Perez đã có mặt tại công trường trong suốt quá trình làm việc như đã hứa và trả lời mọi câu hỏi của tôi. Công việc bắt đầu vào ngày 19/12 và kết thúc vào ngày 20/12. Sau khi lợp mái xong, đội ngũ đã dọn dẹp rất tốt. Họ đã sử dụng hai thiết bị nam châm giống như máy cắt cỏ và quét qua toàn bộ bãi cỏ của tôi để tìm bất kỳ chiếc đinh lợp mái nào bị rơi. Tôi chưa bao giờ thấy thứ gì như vậy! Tôi rất hài lòng với sự kỹ lưỡng trong công việc của họ. — Drew Gerson, Inglewood, CA', '', '', 'cb594aff-40ff-4dd4-b919-27c0f5238ec9', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('c22d5bee-d884-4d79-9c51-4e9fe41946d5', 'ets-imported-test', 188, 7, 'reading', 'When did Lawal Home Service inspect Mr. Gerson’s roof?', 'On December 12', 'On December 13', 'On December 19', 'On December 20', 'B', 'Dịch vụ Nhà Lawal: Phục vụ Nam California hơn 40 năm

Lawal Home Service cung cấp các giải pháp về mái nhà và năng lượng mặt trời cho cư dân Nam California tại Inglewood và các khu vực lân cận. Ngoài việc thay thế mái nhà, chúng tôi cung cấp một loạt các dịch vụ, từ cách nhiệt gác mái và phục hồi máng xối đến sửa chữa rò rỉ và lắp đặt các tấm pin mặt trời.

Lawal Home Service tự hào về giao tiếp minh bạch và sự chú trọng đến từng chi tiết. Các giám sát viên dự án của chúng tôi luôn có mặt tại công trường để trả lời các câu hỏi của khách hàng, cung cấp cập nhật và đảm bảo công trường an toàn, sạch sẽ. Để yêu cầu chẩn đoán mái nhà miễn phí, hãy truy cập www.lawalhomeservice.com hoặc gọi cho đại lý đặt chỗ của chúng tôi theo số 310-555-0108.

Mẫu Liên hệ Dịch vụ Nhà Lawal

Hãy tin tưởng các chuyên gia tại Lawal Home Service để chẩn đoán nhu cầu mái nhà của bạn một cách nhanh chóng và chuyên nghiệp. Vui lòng dành vài phút để hoàn thành mẫu với càng nhiều chi tiết càng tốt. Hãy nhớ rằng, tất cả các mái nhà do Lawal lắp đặt đều được bảo hành 25 năm.

(Bảng dữ liệu: Tên: Drew Gerson; Ngày: 12/12; Địa chỉ: 820 North Acacia Street, Inglewood, CA 90301).

Chúng tôi có thể giúp gì cho bạn?: Trong trận bão gió tuần trước, vài tấm lợp mái đã bị xé toạc và cần thay thế. Tôi đang cân nhắc thay toàn bộ mái vì nó đã hơn 30 năm tuổi, và nước đã bắt đầu nhỏ giọt qua phần trên hiên nhà. Tôi sẽ rất cảm kích nếu được nói chuyện với ai đó có thể cho tôi biết các lựa chọn và cung cấp bản ước tính.

Đánh giá từ khu dân cư: Dịch vụ Nhà Lawal

5 sao - "Tôi rất hài lòng với sự kỹ lưỡng trong công việc của họ."

Tôi đã để lại mô tả về vấn đề của mình cho Lawal Home Service, và một trong những chuyên gia ước tính của công ty đã đến kiểm tra mái nhà của tôi ngay ngày hôm sau. Sau khi tôi quyết định thay mái, đội ngũ Lawal đã có thể bắt đầu làm việc vào tuần sau đó. Diana Perez đã có mặt tại công trường trong suốt quá trình làm việc như đã hứa và trả lời mọi câu hỏi của tôi. Công việc bắt đầu vào ngày 19/12 và kết thúc vào ngày 20/12. Sau khi lợp mái xong, đội ngũ đã dọn dẹp rất tốt. Họ đã sử dụng hai thiết bị nam châm giống như máy cắt cỏ và quét qua toàn bộ bãi cỏ của tôi để tìm bất kỳ chiếc đinh lợp mái nào bị rơi. Tôi chưa bao giờ thấy thứ gì như vậy! Tôi rất hài lòng với sự kỹ lưỡng trong công việc của họ. — Drew Gerson, Inglewood, CA', '', '', 'cb594aff-40ff-4dd4-b919-27c0f5238ec9', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('b0d8e361-a1a2-473d-aed7-90f2af171312', 'ets-imported-test', 189, 7, 'reading', 'Who most likely is Ms. Perez?', 'A project supervisor', 'A roofing estimator', 'An interior decorator', 'A booking agent', 'A', 'Dịch vụ Nhà Lawal: Phục vụ Nam California hơn 40 năm

Lawal Home Service cung cấp các giải pháp về mái nhà và năng lượng mặt trời cho cư dân Nam California tại Inglewood và các khu vực lân cận. Ngoài việc thay thế mái nhà, chúng tôi cung cấp một loạt các dịch vụ, từ cách nhiệt gác mái và phục hồi máng xối đến sửa chữa rò rỉ và lắp đặt các tấm pin mặt trời.

Lawal Home Service tự hào về giao tiếp minh bạch và sự chú trọng đến từng chi tiết. Các giám sát viên dự án của chúng tôi luôn có mặt tại công trường để trả lời các câu hỏi của khách hàng, cung cấp cập nhật và đảm bảo công trường an toàn, sạch sẽ. Để yêu cầu chẩn đoán mái nhà miễn phí, hãy truy cập www.lawalhomeservice.com hoặc gọi cho đại lý đặt chỗ của chúng tôi theo số 310-555-0108.

Mẫu Liên hệ Dịch vụ Nhà Lawal

Hãy tin tưởng các chuyên gia tại Lawal Home Service để chẩn đoán nhu cầu mái nhà của bạn một cách nhanh chóng và chuyên nghiệp. Vui lòng dành vài phút để hoàn thành mẫu với càng nhiều chi tiết càng tốt. Hãy nhớ rằng, tất cả các mái nhà do Lawal lắp đặt đều được bảo hành 25 năm.

(Bảng dữ liệu: Tên: Drew Gerson; Ngày: 12/12; Địa chỉ: 820 North Acacia Street, Inglewood, CA 90301).

Chúng tôi có thể giúp gì cho bạn?: Trong trận bão gió tuần trước, vài tấm lợp mái đã bị xé toạc và cần thay thế. Tôi đang cân nhắc thay toàn bộ mái vì nó đã hơn 30 năm tuổi, và nước đã bắt đầu nhỏ giọt qua phần trên hiên nhà. Tôi sẽ rất cảm kích nếu được nói chuyện với ai đó có thể cho tôi biết các lựa chọn và cung cấp bản ước tính.

Đánh giá từ khu dân cư: Dịch vụ Nhà Lawal

5 sao - "Tôi rất hài lòng với sự kỹ lưỡng trong công việc của họ."

Tôi đã để lại mô tả về vấn đề của mình cho Lawal Home Service, và một trong những chuyên gia ước tính của công ty đã đến kiểm tra mái nhà của tôi ngay ngày hôm sau. Sau khi tôi quyết định thay mái, đội ngũ Lawal đã có thể bắt đầu làm việc vào tuần sau đó. Diana Perez đã có mặt tại công trường trong suốt quá trình làm việc như đã hứa và trả lời mọi câu hỏi của tôi. Công việc bắt đầu vào ngày 19/12 và kết thúc vào ngày 20/12. Sau khi lợp mái xong, đội ngũ đã dọn dẹp rất tốt. Họ đã sử dụng hai thiết bị nam châm giống như máy cắt cỏ và quét qua toàn bộ bãi cỏ của tôi để tìm bất kỳ chiếc đinh lợp mái nào bị rơi. Tôi chưa bao giờ thấy thứ gì như vậy! Tôi rất hài lòng với sự kỹ lưỡng trong công việc của họ. — Drew Gerson, Inglewood, CA', '', '', 'cb594aff-40ff-4dd4-b919-27c0f5238ec9', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('7aa56a3d-27aa-4fc2-8b24-e8e0267a7958', 'ets-imported-test', 190, 7, 'reading', 'According to the review, what surprised Mr. Gerson about the crew from Lawal Home Service?', 'The price they charged', 'The warranty they offered', 'The quality of their materials', 'The tools they used for a job', 'D', 'Dịch vụ Nhà Lawal: Phục vụ Nam California hơn 40 năm

Lawal Home Service cung cấp các giải pháp về mái nhà và năng lượng mặt trời cho cư dân Nam California tại Inglewood và các khu vực lân cận. Ngoài việc thay thế mái nhà, chúng tôi cung cấp một loạt các dịch vụ, từ cách nhiệt gác mái và phục hồi máng xối đến sửa chữa rò rỉ và lắp đặt các tấm pin mặt trời.

Lawal Home Service tự hào về giao tiếp minh bạch và sự chú trọng đến từng chi tiết. Các giám sát viên dự án của chúng tôi luôn có mặt tại công trường để trả lời các câu hỏi của khách hàng, cung cấp cập nhật và đảm bảo công trường an toàn, sạch sẽ. Để yêu cầu chẩn đoán mái nhà miễn phí, hãy truy cập www.lawalhomeservice.com hoặc gọi cho đại lý đặt chỗ của chúng tôi theo số 310-555-0108.

Mẫu Liên hệ Dịch vụ Nhà Lawal

Hãy tin tưởng các chuyên gia tại Lawal Home Service để chẩn đoán nhu cầu mái nhà của bạn một cách nhanh chóng và chuyên nghiệp. Vui lòng dành vài phút để hoàn thành mẫu với càng nhiều chi tiết càng tốt. Hãy nhớ rằng, tất cả các mái nhà do Lawal lắp đặt đều được bảo hành 25 năm.

(Bảng dữ liệu: Tên: Drew Gerson; Ngày: 12/12; Địa chỉ: 820 North Acacia Street, Inglewood, CA 90301).

Chúng tôi có thể giúp gì cho bạn?: Trong trận bão gió tuần trước, vài tấm lợp mái đã bị xé toạc và cần thay thế. Tôi đang cân nhắc thay toàn bộ mái vì nó đã hơn 30 năm tuổi, và nước đã bắt đầu nhỏ giọt qua phần trên hiên nhà. Tôi sẽ rất cảm kích nếu được nói chuyện với ai đó có thể cho tôi biết các lựa chọn và cung cấp bản ước tính.

Đánh giá từ khu dân cư: Dịch vụ Nhà Lawal

5 sao - "Tôi rất hài lòng với sự kỹ lưỡng trong công việc của họ."

Tôi đã để lại mô tả về vấn đề của mình cho Lawal Home Service, và một trong những chuyên gia ước tính của công ty đã đến kiểm tra mái nhà của tôi ngay ngày hôm sau. Sau khi tôi quyết định thay mái, đội ngũ Lawal đã có thể bắt đầu làm việc vào tuần sau đó. Diana Perez đã có mặt tại công trường trong suốt quá trình làm việc như đã hứa và trả lời mọi câu hỏi của tôi. Công việc bắt đầu vào ngày 19/12 và kết thúc vào ngày 20/12. Sau khi lợp mái xong, đội ngũ đã dọn dẹp rất tốt. Họ đã sử dụng hai thiết bị nam châm giống như máy cắt cỏ và quét qua toàn bộ bãi cỏ của tôi để tìm bất kỳ chiếc đinh lợp mái nào bị rơi. Tôi chưa bao giờ thấy thứ gì như vậy! Tôi rất hài lòng với sự kỹ lưỡng trong công việc của họ. — Drew Gerson, Inglewood, CA', '', '', 'cb594aff-40ff-4dd4-b919-27c0f5238ec9', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('3e086857-e369-402d-9756-7c940252aa14', 'ets-imported-test', 191, 7, 'reading', 'What is one service that Darboury Company most likely provides?', 'Travel booking', 'Textbook publishing', 'Flower delivery', 'Graphic design', 'D', 'Gửi: Omar Balaji

Từ: Juanita Pereira

Ngày: 10 tháng 5

Chủ đề: Yêu cầu về sổ tay

Thân gửi ông Balaji,

Chúng tôi đang mở rộng mảng văn phòng phẩm tại Bun Bun Books và muốn cung cấp một số lựa chọn sổ tay trắng có dòng kẻ. Chúng tôi muốn nhờ ông giúp tạo ra các thiết kế bìa sau đây:

- Great Thoughts: Biểu tượng bóng đèn, tia chớp và ngôi sao; Nền Xanh dương.

- World Suitcase: Vali với nhãn dán du lịch tên các quốc gia; Nền Đen.

- Lavender Bouquet: Bó hoa oải hương lớn trên cành dài xanh nhạt; Nền Vàng.

- Sail Away: Mặt trời lặn phía trên thuyền buồm trên hồ; Nền Trắng.

Chúng tôi cần có sổ tay trong kho kịp thời cho đợt giảm giá hàng năm bắt đầu từ ngày 1 tháng 8. Sau khi phê duyệt các bìa mẫu, khi nào chúng tôi cần đặt hàng?

Cảm ơn ông, Juanita Pereira

Gửi: Juanita Pereira

Từ: Omar Balaji

Ngày: 25 tháng 5

Chủ đề: Re: Yêu cầu về sổ tay

Chào cô Pereira,

Tôi đã gửi một số bìa sổ tay mẫu để cô kiểm tra. Thật không may, tôi đã không thể gửi kèm một trong các thiết kế vì nó cần thay đổi màu nền ở giai đoạn cuối. Các hình dán nghệ thuật không hiển thị rõ trên nền đen ban đầu. Chúng tôi đang thử nghiệm màu be nhạt, và tôi sẽ gửi mẫu bìa cập nhật cho cô sau khi nó được phê duyệt nội bộ. Tôi sẽ gửi mẫu cuối cùng cho cô vào cuối tuần này. Miễn là cô gửi phê duyệt cho tất cả các bìa trước ngày 11 tháng 6, chúng tôi sẽ có thể vận chuyển toàn bộ đơn hàng trước ngày 20 tháng 7. Trân trọng, Omar Balaji.

ĐƠN ĐẶT HÀNG - CÔNG TY DARBOURY

Khách hàng: Bun Bun Books. Ngày vận chuyển: 15/7. Phương thức: Tiêu chuẩn. Ngày giao hàng yêu cầu: 20/7.

- N3-GT: Sổ tay xoắn ốc kích thước chuẩn (Thiết kế: Great Thoughts) - SL: 200

- N3-WS: Sổ tay xoắn ốc kích thước chuẩn (Thiết kế: World Suitcase) - SL: 200

- H3-LB: Sổ tay ghi chép bìa cứng nhỏ (Thiết kế: Lavender Bouquet) - SL: 150

- H3-SA: Sổ tay ghi chép bìa cứng nhỏ (Thiết kế: Sail Away) - SL: 150

- D1: Giá trưng bày kim loại lớn (chứa sổ xoắn ốc chuẩn) - SL: 1', '', '', '428e81cd-4331-4327-a918-8f9304b92538', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('3a363b89-3137-47ec-94b1-b922f2d2e3dd', 'ets-imported-test', 192, 7, 'reading', 'What sample was delayed?', 'Great Thoughts', 'World Suitcase', 'Lavender Bouquet', 'Sail Away', 'B', 'Gửi: Omar Balaji

Từ: Juanita Pereira

Ngày: 10 tháng 5

Chủ đề: Yêu cầu về sổ tay

Thân gửi ông Balaji,

Chúng tôi đang mở rộng mảng văn phòng phẩm tại Bun Bun Books và muốn cung cấp một số lựa chọn sổ tay trắng có dòng kẻ. Chúng tôi muốn nhờ ông giúp tạo ra các thiết kế bìa sau đây:

- Great Thoughts: Biểu tượng bóng đèn, tia chớp và ngôi sao; Nền Xanh dương.

- World Suitcase: Vali với nhãn dán du lịch tên các quốc gia; Nền Đen.

- Lavender Bouquet: Bó hoa oải hương lớn trên cành dài xanh nhạt; Nền Vàng.

- Sail Away: Mặt trời lặn phía trên thuyền buồm trên hồ; Nền Trắng.

Chúng tôi cần có sổ tay trong kho kịp thời cho đợt giảm giá hàng năm bắt đầu từ ngày 1 tháng 8. Sau khi phê duyệt các bìa mẫu, khi nào chúng tôi cần đặt hàng?

Cảm ơn ông, Juanita Pereira

Gửi: Juanita Pereira

Từ: Omar Balaji

Ngày: 25 tháng 5

Chủ đề: Re: Yêu cầu về sổ tay

Chào cô Pereira,

Tôi đã gửi một số bìa sổ tay mẫu để cô kiểm tra. Thật không may, tôi đã không thể gửi kèm một trong các thiết kế vì nó cần thay đổi màu nền ở giai đoạn cuối. Các hình dán nghệ thuật không hiển thị rõ trên nền đen ban đầu. Chúng tôi đang thử nghiệm màu be nhạt, và tôi sẽ gửi mẫu bìa cập nhật cho cô sau khi nó được phê duyệt nội bộ. Tôi sẽ gửi mẫu cuối cùng cho cô vào cuối tuần này. Miễn là cô gửi phê duyệt cho tất cả các bìa trước ngày 11 tháng 6, chúng tôi sẽ có thể vận chuyển toàn bộ đơn hàng trước ngày 20 tháng 7. Trân trọng, Omar Balaji.

ĐƠN ĐẶT HÀNG - CÔNG TY DARBOURY

Khách hàng: Bun Bun Books. Ngày vận chuyển: 15/7. Phương thức: Tiêu chuẩn. Ngày giao hàng yêu cầu: 20/7.

- N3-GT: Sổ tay xoắn ốc kích thước chuẩn (Thiết kế: Great Thoughts) - SL: 200

- N3-WS: Sổ tay xoắn ốc kích thước chuẩn (Thiết kế: World Suitcase) - SL: 200

- H3-LB: Sổ tay ghi chép bìa cứng nhỏ (Thiết kế: Lavender Bouquet) - SL: 150

- H3-SA: Sổ tay ghi chép bìa cứng nhỏ (Thiết kế: Sail Away) - SL: 150

- D1: Giá trưng bày kim loại lớn (chứa sổ xoắn ốc chuẩn) - SL: 1', '', '', '428e81cd-4331-4327-a918-8f9304b92538', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('574e03c7-c459-4319-ba8c-2e792c6baa71', 'ets-imported-test', 193, 7, 'reading', 'When is the deadline for Ms. Pereira to approve samples?', 'May 25', 'June 11', 'July 20', 'August 1', 'B', 'Gửi: Omar Balaji

Từ: Juanita Pereira

Ngày: 10 tháng 5

Chủ đề: Yêu cầu về sổ tay

Thân gửi ông Balaji,

Chúng tôi đang mở rộng mảng văn phòng phẩm tại Bun Bun Books và muốn cung cấp một số lựa chọn sổ tay trắng có dòng kẻ. Chúng tôi muốn nhờ ông giúp tạo ra các thiết kế bìa sau đây:

- Great Thoughts: Biểu tượng bóng đèn, tia chớp và ngôi sao; Nền Xanh dương.

- World Suitcase: Vali với nhãn dán du lịch tên các quốc gia; Nền Đen.

- Lavender Bouquet: Bó hoa oải hương lớn trên cành dài xanh nhạt; Nền Vàng.

- Sail Away: Mặt trời lặn phía trên thuyền buồm trên hồ; Nền Trắng.

Chúng tôi cần có sổ tay trong kho kịp thời cho đợt giảm giá hàng năm bắt đầu từ ngày 1 tháng 8. Sau khi phê duyệt các bìa mẫu, khi nào chúng tôi cần đặt hàng?

Cảm ơn ông, Juanita Pereira

Gửi: Juanita Pereira

Từ: Omar Balaji

Ngày: 25 tháng 5

Chủ đề: Re: Yêu cầu về sổ tay

Chào cô Pereira,

Tôi đã gửi một số bìa sổ tay mẫu để cô kiểm tra. Thật không may, tôi đã không thể gửi kèm một trong các thiết kế vì nó cần thay đổi màu nền ở giai đoạn cuối. Các hình dán nghệ thuật không hiển thị rõ trên nền đen ban đầu. Chúng tôi đang thử nghiệm màu be nhạt, và tôi sẽ gửi mẫu bìa cập nhật cho cô sau khi nó được phê duyệt nội bộ. Tôi sẽ gửi mẫu cuối cùng cho cô vào cuối tuần này. Miễn là cô gửi phê duyệt cho tất cả các bìa trước ngày 11 tháng 6, chúng tôi sẽ có thể vận chuyển toàn bộ đơn hàng trước ngày 20 tháng 7. Trân trọng, Omar Balaji.

ĐƠN ĐẶT HÀNG - CÔNG TY DARBOURY

Khách hàng: Bun Bun Books. Ngày vận chuyển: 15/7. Phương thức: Tiêu chuẩn. Ngày giao hàng yêu cầu: 20/7.

- N3-GT: Sổ tay xoắn ốc kích thước chuẩn (Thiết kế: Great Thoughts) - SL: 200

- N3-WS: Sổ tay xoắn ốc kích thước chuẩn (Thiết kế: World Suitcase) - SL: 200

- H3-LB: Sổ tay ghi chép bìa cứng nhỏ (Thiết kế: Lavender Bouquet) - SL: 150

- H3-SA: Sổ tay ghi chép bìa cứng nhỏ (Thiết kế: Sail Away) - SL: 150

- D1: Giá trưng bày kim loại lớn (chứa sổ xoắn ốc chuẩn) - SL: 1', '', '', '428e81cd-4331-4327-a918-8f9304b92538', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('d029a33f-46bb-4a82-bcd2-aeb1c58cd489', 'ets-imported-test', 194, 7, 'reading', 'What does the form indicate about the Bun Bun Books order?', 'It will include a display stand.', 'It will ship overnight.', 'It will be paid upon delivery.', 'It will arrive late.', 'A', 'Gửi: Omar Balaji

Từ: Juanita Pereira

Ngày: 10 tháng 5

Chủ đề: Yêu cầu về sổ tay

Thân gửi ông Balaji,

Chúng tôi đang mở rộng mảng văn phòng phẩm tại Bun Bun Books và muốn cung cấp một số lựa chọn sổ tay trắng có dòng kẻ. Chúng tôi muốn nhờ ông giúp tạo ra các thiết kế bìa sau đây:

- Great Thoughts: Biểu tượng bóng đèn, tia chớp và ngôi sao; Nền Xanh dương.

- World Suitcase: Vali với nhãn dán du lịch tên các quốc gia; Nền Đen.

- Lavender Bouquet: Bó hoa oải hương lớn trên cành dài xanh nhạt; Nền Vàng.

- Sail Away: Mặt trời lặn phía trên thuyền buồm trên hồ; Nền Trắng.

Chúng tôi cần có sổ tay trong kho kịp thời cho đợt giảm giá hàng năm bắt đầu từ ngày 1 tháng 8. Sau khi phê duyệt các bìa mẫu, khi nào chúng tôi cần đặt hàng?

Cảm ơn ông, Juanita Pereira

Gửi: Juanita Pereira

Từ: Omar Balaji

Ngày: 25 tháng 5

Chủ đề: Re: Yêu cầu về sổ tay

Chào cô Pereira,

Tôi đã gửi một số bìa sổ tay mẫu để cô kiểm tra. Thật không may, tôi đã không thể gửi kèm một trong các thiết kế vì nó cần thay đổi màu nền ở giai đoạn cuối. Các hình dán nghệ thuật không hiển thị rõ trên nền đen ban đầu. Chúng tôi đang thử nghiệm màu be nhạt, và tôi sẽ gửi mẫu bìa cập nhật cho cô sau khi nó được phê duyệt nội bộ. Tôi sẽ gửi mẫu cuối cùng cho cô vào cuối tuần này. Miễn là cô gửi phê duyệt cho tất cả các bìa trước ngày 11 tháng 6, chúng tôi sẽ có thể vận chuyển toàn bộ đơn hàng trước ngày 20 tháng 7. Trân trọng, Omar Balaji.

ĐƠN ĐẶT HÀNG - CÔNG TY DARBOURY

Khách hàng: Bun Bun Books. Ngày vận chuyển: 15/7. Phương thức: Tiêu chuẩn. Ngày giao hàng yêu cầu: 20/7.

- N3-GT: Sổ tay xoắn ốc kích thước chuẩn (Thiết kế: Great Thoughts) - SL: 200

- N3-WS: Sổ tay xoắn ốc kích thước chuẩn (Thiết kế: World Suitcase) - SL: 200

- H3-LB: Sổ tay ghi chép bìa cứng nhỏ (Thiết kế: Lavender Bouquet) - SL: 150

- H3-SA: Sổ tay ghi chép bìa cứng nhỏ (Thiết kế: Sail Away) - SL: 150

- D1: Giá trưng bày kim loại lớn (chứa sổ xoắn ốc chuẩn) - SL: 1', '', '', '428e81cd-4331-4327-a918-8f9304b92538', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('5f0b1692-7eae-4d47-8852-2e90fd0e9658', 'ets-imported-test', 195, 7, 'reading', 'What is the background color on the cover of item N3-GT?', 'Blue', 'Black', 'Yellow', 'White', 'A', 'Gửi: Omar Balaji

Từ: Juanita Pereira

Ngày: 10 tháng 5

Chủ đề: Yêu cầu về sổ tay

Thân gửi ông Balaji,

Chúng tôi đang mở rộng mảng văn phòng phẩm tại Bun Bun Books và muốn cung cấp một số lựa chọn sổ tay trắng có dòng kẻ. Chúng tôi muốn nhờ ông giúp tạo ra các thiết kế bìa sau đây:

- Great Thoughts: Biểu tượng bóng đèn, tia chớp và ngôi sao; Nền Xanh dương.

- World Suitcase: Vali với nhãn dán du lịch tên các quốc gia; Nền Đen.

- Lavender Bouquet: Bó hoa oải hương lớn trên cành dài xanh nhạt; Nền Vàng.

- Sail Away: Mặt trời lặn phía trên thuyền buồm trên hồ; Nền Trắng.

Chúng tôi cần có sổ tay trong kho kịp thời cho đợt giảm giá hàng năm bắt đầu từ ngày 1 tháng 8. Sau khi phê duyệt các bìa mẫu, khi nào chúng tôi cần đặt hàng?

Cảm ơn ông, Juanita Pereira

Gửi: Juanita Pereira

Từ: Omar Balaji

Ngày: 25 tháng 5

Chủ đề: Re: Yêu cầu về sổ tay

Chào cô Pereira,

Tôi đã gửi một số bìa sổ tay mẫu để cô kiểm tra. Thật không may, tôi đã không thể gửi kèm một trong các thiết kế vì nó cần thay đổi màu nền ở giai đoạn cuối. Các hình dán nghệ thuật không hiển thị rõ trên nền đen ban đầu. Chúng tôi đang thử nghiệm màu be nhạt, và tôi sẽ gửi mẫu bìa cập nhật cho cô sau khi nó được phê duyệt nội bộ. Tôi sẽ gửi mẫu cuối cùng cho cô vào cuối tuần này. Miễn là cô gửi phê duyệt cho tất cả các bìa trước ngày 11 tháng 6, chúng tôi sẽ có thể vận chuyển toàn bộ đơn hàng trước ngày 20 tháng 7. Trân trọng, Omar Balaji.

ĐƠN ĐẶT HÀNG - CÔNG TY DARBOURY

Khách hàng: Bun Bun Books. Ngày vận chuyển: 15/7. Phương thức: Tiêu chuẩn. Ngày giao hàng yêu cầu: 20/7.

- N3-GT: Sổ tay xoắn ốc kích thước chuẩn (Thiết kế: Great Thoughts) - SL: 200

- N3-WS: Sổ tay xoắn ốc kích thước chuẩn (Thiết kế: World Suitcase) - SL: 200

- H3-LB: Sổ tay ghi chép bìa cứng nhỏ (Thiết kế: Lavender Bouquet) - SL: 150

- H3-SA: Sổ tay ghi chép bìa cứng nhỏ (Thiết kế: Sail Away) - SL: 150

- D1: Giá trưng bày kim loại lớn (chứa sổ xoắn ốc chuẩn) - SL: 1', '', '', '428e81cd-4331-4327-a918-8f9304b92538', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('5ca10319-c9f3-4cf8-80ff-0605487e5cd9', 'ets-imported-test', 196, 7, 'reading', 'What is the purpose of the e-mail?', 'To share a list of job candidates', 'To ask for opinions from managers', 'To summarize a managers’ meeting', 'To nominate a manager for an award', 'B', 'Gửi: Các quản lý

Từ: Charlotte Black

Ngày: 16 tháng 8

Chủ đề: Nhân viên của tháng

Thân gửi các Quản lý,

Đã đến lúc bình chọn Nhân viên của tháng cho tháng 9 tại Wilson Autos. Dưới đây là các ứng cử viên.

Erica Boyd mới làm việc với chúng ta vài tháng nhưng đã cho thấy tiềm năng lớn và rất ham học hỏi những điều mới.

Lauren Almahdi rất chủ động. Nếu có việc cần làm, cô ấy sẽ chỉ ra cho quản lý và tình nguyện tự mình xử lý.

Nick Salehi đã tìm thấy một lỗi trong hệ thống máy tính của chúng ta và ngăn chặn việc đặt hàng nhầm kho bãi không cần thiết (từ đó giúp chúng ta tiết kiệm tiền).

Max Rhodes đặc biệt hữu ích trong việc đào tạo nhân viên mới. Anh ấy bình tĩnh, kiên nhẫn và giải thích các quy trình của chúng ta rất tốt.

Vui lòng phản hồi email này trước thứ Sáu kèm theo phiếu bầu của bạn. Người chiến thắng phải nhận được ít nhất ba phiếu bầu. Người chiến thắng sẽ được niêm yết tại quầy lễ tân và trên trang web của chúng ta vào thứ Hai tới.

Trân trọng,

Charlotte Black - Tổng quản lý, Wilson Autos

---

Westchester Reviews: Wilson Autos (Westchester)

5 sao - Vợ chồng tôi vừa mua một chiếc xe tải Excelera mới tại Wilson Autos cơ sở Westchester với sự giúp đỡ của Erica Boyd. Dù là nhân viên mới, cô ấy rất am hiểu về tất cả các loại xe tải mà chúng tôi muốn lái thử. Một vài câu hỏi cô ấy không trả lời được đã được người hướng dẫn của cô ấy, Max, giải quyết nhanh chóng. Chúng tôi rất hài lòng với dịch vụ khách hàng và còn vui mừng hơn khi tổng quản lý đồng ý bán chiếc Excelera với cùng mức giá mà một đại lý cạnh tranh đang quảng cáo. Tôi thực sự khuyên bạn nên đến Wilson Autos nếu bạn đang muốn mua một chiếc xe mới! — Henry Riggs, 22 tháng 8

---

NHÂN VIÊN CỦA THÁNG 9 LÀ ERICA BOYD!

Trong 3 tháng tại Wilson Autos, Erica đã tiếp thu các kỹ năng mới nhanh chóng và luôn cố gắng học hỏi thêm. Cô ấy đã trở nên rất am hiểu về kho hàng của chúng ta và có thể chia sẻ kiến thức đó với khách hàng để hoàn tất việc bán hàng. Cô ấy cũng là người góp công lớn trong việc khuyến khích những khách hàng hài lòng đăng ý kiến lên các trang mạng xã hội của chúng ta. Chúng ta đã nhận được nhiều đánh giá tốt trong tháng qua hơn cả 4 tháng trước đó cộng lại! Erica đã nhận được thẻ quà tặng trị giá 50 đô la tại Nhà hàng Alonzo như một lời cảm ơn. Chúc mừng Erica!', '', '', '746eac99-7cf3-46e4-b096-c533edf9d23c', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('142b2138-bc28-4578-b65f-ab3f84a100b7', 'ets-imported-test', 197, 7, 'reading', 'According to the e-mail, who identified a technical problem?', 'Mr. Salehi', 'Ms. Almahdi', 'Mr. Rhodes', 'Ms. Black', 'A', 'Gửi: Các quản lý

Từ: Charlotte Black

Ngày: 16 tháng 8

Chủ đề: Nhân viên của tháng

Thân gửi các Quản lý,

Đã đến lúc bình chọn Nhân viên của tháng cho tháng 9 tại Wilson Autos. Dưới đây là các ứng cử viên.

Erica Boyd mới làm việc với chúng ta vài tháng nhưng đã cho thấy tiềm năng lớn và rất ham học hỏi những điều mới.

Lauren Almahdi rất chủ động. Nếu có việc cần làm, cô ấy sẽ chỉ ra cho quản lý và tình nguyện tự mình xử lý.

Nick Salehi đã tìm thấy một lỗi trong hệ thống máy tính của chúng ta và ngăn chặn việc đặt hàng nhầm kho bãi không cần thiết (từ đó giúp chúng ta tiết kiệm tiền).

Max Rhodes đặc biệt hữu ích trong việc đào tạo nhân viên mới. Anh ấy bình tĩnh, kiên nhẫn và giải thích các quy trình của chúng ta rất tốt.

Vui lòng phản hồi email này trước thứ Sáu kèm theo phiếu bầu của bạn. Người chiến thắng phải nhận được ít nhất ba phiếu bầu. Người chiến thắng sẽ được niêm yết tại quầy lễ tân và trên trang web của chúng ta vào thứ Hai tới.

Trân trọng,

Charlotte Black - Tổng quản lý, Wilson Autos

---

Westchester Reviews: Wilson Autos (Westchester)

5 sao - Vợ chồng tôi vừa mua một chiếc xe tải Excelera mới tại Wilson Autos cơ sở Westchester với sự giúp đỡ của Erica Boyd. Dù là nhân viên mới, cô ấy rất am hiểu về tất cả các loại xe tải mà chúng tôi muốn lái thử. Một vài câu hỏi cô ấy không trả lời được đã được người hướng dẫn của cô ấy, Max, giải quyết nhanh chóng. Chúng tôi rất hài lòng với dịch vụ khách hàng và còn vui mừng hơn khi tổng quản lý đồng ý bán chiếc Excelera với cùng mức giá mà một đại lý cạnh tranh đang quảng cáo. Tôi thực sự khuyên bạn nên đến Wilson Autos nếu bạn đang muốn mua một chiếc xe mới! — Henry Riggs, 22 tháng 8

---

NHÂN VIÊN CỦA THÁNG 9 LÀ ERICA BOYD!

Trong 3 tháng tại Wilson Autos, Erica đã tiếp thu các kỹ năng mới nhanh chóng và luôn cố gắng học hỏi thêm. Cô ấy đã trở nên rất am hiểu về kho hàng của chúng ta và có thể chia sẻ kiến thức đó với khách hàng để hoàn tất việc bán hàng. Cô ấy cũng là người góp công lớn trong việc khuyến khích những khách hàng hài lòng đăng ý kiến lên các trang mạng xã hội của chúng ta. Chúng ta đã nhận được nhiều đánh giá tốt trong tháng qua hơn cả 4 tháng trước đó cộng lại! Erica đã nhận được thẻ quà tặng trị giá 50 đô la tại Nhà hàng Alonzo như một lời cảm ơn. Chúc mừng Erica!', '', '', '746eac99-7cf3-46e4-b096-c533edf9d23c', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('faaaf224-2aaf-4afe-9d72-fae249a8ff07', 'ets-imported-test', 198, 7, 'reading', 'What can be concluded about Mr. Riggs?', 'His previous vehicle was an Excelera truck.', 'He is a neighbor of Ms. Boyd’s.', 'He has purchased a vehicle from Wilson Autos in the past.', 'He negotiated with Ms. Black for a lower price.', 'D', 'Gửi: Các quản lý

Từ: Charlotte Black

Ngày: 16 tháng 8

Chủ đề: Nhân viên của tháng

Thân gửi các Quản lý,

Đã đến lúc bình chọn Nhân viên của tháng cho tháng 9 tại Wilson Autos. Dưới đây là các ứng cử viên.

Erica Boyd mới làm việc với chúng ta vài tháng nhưng đã cho thấy tiềm năng lớn và rất ham học hỏi những điều mới.

Lauren Almahdi rất chủ động. Nếu có việc cần làm, cô ấy sẽ chỉ ra cho quản lý và tình nguyện tự mình xử lý.

Nick Salehi đã tìm thấy một lỗi trong hệ thống máy tính của chúng ta và ngăn chặn việc đặt hàng nhầm kho bãi không cần thiết (từ đó giúp chúng ta tiết kiệm tiền).

Max Rhodes đặc biệt hữu ích trong việc đào tạo nhân viên mới. Anh ấy bình tĩnh, kiên nhẫn và giải thích các quy trình của chúng ta rất tốt.

Vui lòng phản hồi email này trước thứ Sáu kèm theo phiếu bầu của bạn. Người chiến thắng phải nhận được ít nhất ba phiếu bầu. Người chiến thắng sẽ được niêm yết tại quầy lễ tân và trên trang web của chúng ta vào thứ Hai tới.

Trân trọng,

Charlotte Black - Tổng quản lý, Wilson Autos

---

Westchester Reviews: Wilson Autos (Westchester)

5 sao - Vợ chồng tôi vừa mua một chiếc xe tải Excelera mới tại Wilson Autos cơ sở Westchester với sự giúp đỡ của Erica Boyd. Dù là nhân viên mới, cô ấy rất am hiểu về tất cả các loại xe tải mà chúng tôi muốn lái thử. Một vài câu hỏi cô ấy không trả lời được đã được người hướng dẫn của cô ấy, Max, giải quyết nhanh chóng. Chúng tôi rất hài lòng với dịch vụ khách hàng và còn vui mừng hơn khi tổng quản lý đồng ý bán chiếc Excelera với cùng mức giá mà một đại lý cạnh tranh đang quảng cáo. Tôi thực sự khuyên bạn nên đến Wilson Autos nếu bạn đang muốn mua một chiếc xe mới! — Henry Riggs, 22 tháng 8

---

NHÂN VIÊN CỦA THÁNG 9 LÀ ERICA BOYD!

Trong 3 tháng tại Wilson Autos, Erica đã tiếp thu các kỹ năng mới nhanh chóng và luôn cố gắng học hỏi thêm. Cô ấy đã trở nên rất am hiểu về kho hàng của chúng ta và có thể chia sẻ kiến thức đó với khách hàng để hoàn tất việc bán hàng. Cô ấy cũng là người góp công lớn trong việc khuyến khích những khách hàng hài lòng đăng ý kiến lên các trang mạng xã hội của chúng ta. Chúng ta đã nhận được nhiều đánh giá tốt trong tháng qua hơn cả 4 tháng trước đó cộng lại! Erica đã nhận được thẻ quà tặng trị giá 50 đô la tại Nhà hàng Alonzo như một lời cảm ơn. Chúc mừng Erica!', '', '', '746eac99-7cf3-46e4-b096-c533edf9d23c', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('2760f4f1-5218-45ba-b1d1-2312b0160707', 'ets-imported-test', 199, 7, 'reading', 'What is indicated in the notice about Ms. Boyd?', 'She eats regularly at Alonzo’s Restaurant.', 'She manages social media sites for Wilson Autos.', 'She is responsible for an increase in customer feedback.', 'She recently completed a sales training course.', 'C', 'Gửi: Các quản lý

Từ: Charlotte Black

Ngày: 16 tháng 8

Chủ đề: Nhân viên của tháng

Thân gửi các Quản lý,

Đã đến lúc bình chọn Nhân viên của tháng cho tháng 9 tại Wilson Autos. Dưới đây là các ứng cử viên.

Erica Boyd mới làm việc với chúng ta vài tháng nhưng đã cho thấy tiềm năng lớn và rất ham học hỏi những điều mới.

Lauren Almahdi rất chủ động. Nếu có việc cần làm, cô ấy sẽ chỉ ra cho quản lý và tình nguyện tự mình xử lý.

Nick Salehi đã tìm thấy một lỗi trong hệ thống máy tính của chúng ta và ngăn chặn việc đặt hàng nhầm kho bãi không cần thiết (từ đó giúp chúng ta tiết kiệm tiền).

Max Rhodes đặc biệt hữu ích trong việc đào tạo nhân viên mới. Anh ấy bình tĩnh, kiên nhẫn và giải thích các quy trình của chúng ta rất tốt.

Vui lòng phản hồi email này trước thứ Sáu kèm theo phiếu bầu của bạn. Người chiến thắng phải nhận được ít nhất ba phiếu bầu. Người chiến thắng sẽ được niêm yết tại quầy lễ tân và trên trang web của chúng ta vào thứ Hai tới.

Trân trọng,

Charlotte Black - Tổng quản lý, Wilson Autos

---

Westchester Reviews: Wilson Autos (Westchester)

5 sao - Vợ chồng tôi vừa mua một chiếc xe tải Excelera mới tại Wilson Autos cơ sở Westchester với sự giúp đỡ của Erica Boyd. Dù là nhân viên mới, cô ấy rất am hiểu về tất cả các loại xe tải mà chúng tôi muốn lái thử. Một vài câu hỏi cô ấy không trả lời được đã được người hướng dẫn của cô ấy, Max, giải quyết nhanh chóng. Chúng tôi rất hài lòng với dịch vụ khách hàng và còn vui mừng hơn khi tổng quản lý đồng ý bán chiếc Excelera với cùng mức giá mà một đại lý cạnh tranh đang quảng cáo. Tôi thực sự khuyên bạn nên đến Wilson Autos nếu bạn đang muốn mua một chiếc xe mới! — Henry Riggs, 22 tháng 8

---

NHÂN VIÊN CỦA THÁNG 9 LÀ ERICA BOYD!

Trong 3 tháng tại Wilson Autos, Erica đã tiếp thu các kỹ năng mới nhanh chóng và luôn cố gắng học hỏi thêm. Cô ấy đã trở nên rất am hiểu về kho hàng của chúng ta và có thể chia sẻ kiến thức đó với khách hàng để hoàn tất việc bán hàng. Cô ấy cũng là người góp công lớn trong việc khuyến khích những khách hàng hài lòng đăng ý kiến lên các trang mạng xã hội của chúng ta. Chúng ta đã nhận được nhiều đánh giá tốt trong tháng qua hơn cả 4 tháng trước đó cộng lại! Erica đã nhận được thẻ quà tặng trị giá 50 đô la tại Nhà hàng Alonzo như một lời cảm ơn. Chúc mừng Erica!', '', '', '746eac99-7cf3-46e4-b096-c533edf9d23c', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('f1cbed3b-2b53-4a5b-a207-2690baea5294', 'ets-imported-test', 200, 7, 'reading', 'What is most likely true about Ms. Boyd?', 'She received votes from at least three managers.', 'She was the top salesperson in August.', 'She has years of experience in the auto industry.', 'She was hired by Wilson Autos in April.', 'A', 'Gửi: Các quản lý

Từ: Charlotte Black

Ngày: 16 tháng 8

Chủ đề: Nhân viên của tháng

Thân gửi các Quản lý,

Đã đến lúc bình chọn Nhân viên của tháng cho tháng 9 tại Wilson Autos. Dưới đây là các ứng cử viên.

Erica Boyd mới làm việc với chúng ta vài tháng nhưng đã cho thấy tiềm năng lớn và rất ham học hỏi những điều mới.

Lauren Almahdi rất chủ động. Nếu có việc cần làm, cô ấy sẽ chỉ ra cho quản lý và tình nguyện tự mình xử lý.

Nick Salehi đã tìm thấy một lỗi trong hệ thống máy tính của chúng ta và ngăn chặn việc đặt hàng nhầm kho bãi không cần thiết (từ đó giúp chúng ta tiết kiệm tiền).

Max Rhodes đặc biệt hữu ích trong việc đào tạo nhân viên mới. Anh ấy bình tĩnh, kiên nhẫn và giải thích các quy trình của chúng ta rất tốt.

Vui lòng phản hồi email này trước thứ Sáu kèm theo phiếu bầu của bạn. Người chiến thắng phải nhận được ít nhất ba phiếu bầu. Người chiến thắng sẽ được niêm yết tại quầy lễ tân và trên trang web của chúng ta vào thứ Hai tới.

Trân trọng,

Charlotte Black - Tổng quản lý, Wilson Autos

---

Westchester Reviews: Wilson Autos (Westchester)

5 sao - Vợ chồng tôi vừa mua một chiếc xe tải Excelera mới tại Wilson Autos cơ sở Westchester với sự giúp đỡ của Erica Boyd. Dù là nhân viên mới, cô ấy rất am hiểu về tất cả các loại xe tải mà chúng tôi muốn lái thử. Một vài câu hỏi cô ấy không trả lời được đã được người hướng dẫn của cô ấy, Max, giải quyết nhanh chóng. Chúng tôi rất hài lòng với dịch vụ khách hàng và còn vui mừng hơn khi tổng quản lý đồng ý bán chiếc Excelera với cùng mức giá mà một đại lý cạnh tranh đang quảng cáo. Tôi thực sự khuyên bạn nên đến Wilson Autos nếu bạn đang muốn mua một chiếc xe mới! — Henry Riggs, 22 tháng 8

---

NHÂN VIÊN CỦA THÁNG 9 LÀ ERICA BOYD!

Trong 3 tháng tại Wilson Autos, Erica đã tiếp thu các kỹ năng mới nhanh chóng và luôn cố gắng học hỏi thêm. Cô ấy đã trở nên rất am hiểu về kho hàng của chúng ta và có thể chia sẻ kiến thức đó với khách hàng để hoàn tất việc bán hàng. Cô ấy cũng là người góp công lớn trong việc khuyến khích những khách hàng hài lòng đăng ý kiến lên các trang mạng xã hội của chúng ta. Chúng ta đã nhận được nhiều đánh giá tốt trong tháng qua hơn cả 4 tháng trước đó cộng lại! Erica đã nhận được thẻ quà tặng trị giá 50 đô la tại Nhà hàng Alonzo như một lời cảm ơn. Chúc mừng Erica!', '', '', '746eac99-7cf3-46e4-b096-c533edf9d23c', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('f7a8159c-40b2-455e-ba0c-0283b5f61e04', 'toeic-test-01', 1, 1, 'listening', '', 'The woman is carrying a tray of food.', 'The woman is wearing a jacket.', 'The woman is tying up her hair.', 'The woman is removing her hat.', 'B', '(A) Người phụ nữ đang bê một khay thức ăn.

(B) Người phụ nữ đang mặc một chiếc áo khoác.

(C) Người phụ nữ đang buộc tóc.

(D) Người phụ nữ đang tháo mũ của mình.', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/1.mp3', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/1.webp', '', '(A) The woman is carrying a tray of food.
(B) The woman is wearing a jacket.
(C) The woman is tying up her hair.
(D) The woman is removing her hat.') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('1eef8088-8f8b-4e81-a10b-3e4007d8f8e4', 'toeic-test-01', 2, 1, 'listening', '', 'Some people are standing next to a filing cabinet.', 'Some people are searching through a desk.', 'Some people are watching a presentation.', 'Some people are looking at a book.', 'D', '(A) Một vài người đang đứng cạnh tủ đựng hồ sơ.

(B) Một vài người đang tìm kiếm thứ gì đó trong bàn làm việc.

(C) Một vài người đang xem một bài thuyết trình.

(D) Một vài người đang nhìn vào một cuốn sách.', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/2.mp3', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/2.webp', '', '(A) Some people are standing next to a filing cabinet.
(B) Some people are searching through a desk.
(C) Some people are watching a presentation.
(D) Some people are looking at a book.') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('caa42e4c-7bc7-4da6-ad41-99f54ddabb5c', 'toeic-test-01', 3, 1, 'listening', '', 'A woman is holding a phone up to her ear.', 'A woman is pouring a beverage into a glass.', 'Some light fixtures are hanging from the ceiling.', 'Some tiles are being installed in a hallway.', 'C', '(A) Một người phụ nữ đang áp điện thoại lên tai.

(B) Một người phụ nữ đang rót đồ uống vào ly.

(C) Một số đèn trang trí đang treo trên trần nhà.

(D) Một số viên gạch lát đang được lắp đặt ở hành lang.', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/3.mp3', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/3.webp', '', '(A) A woman is holding a phone up to her ear.
(B) A woman is pouring a beverage into a glass.
(C) Some light fixtures are hanging from the ceiling.
(D) Some tiles are being installed in a hallway.') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('66575cdb-a58b-4fd0-bcdf-a9c0afc81860', 'toeic-test-01', 4, 1, 'listening', '', 'A wooden crate is filled with vegetables.', 'One of the men is putting vegetables into a shopping bag.', 'A backpack has been set on the ground.', 'One of the men is reaching into a bucket.', 'A', '(A) Một thùng gỗ chứa đầy rau củ.

(B) Một trong những người đàn ông đang cho rau vào túi mua hàng.

(C) Một chiếc ba lô đã được đặt trên mặt đất.

(D) Một trong những người đàn ông đang với tay vào một cái xô.', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/4.mp3', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/4.webp', '', '(A) A wooden crate is filled with vegetables.
(B) One of the men is putting vegetables into a shopping bag.
(C) A backpack has been set on the ground.
(D) One of the men is reaching into a bucket.') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('fc38f0c6-44cb-4f2c-8e33-500b8359cd4c', 'toeic-test-01', 5, 1, 'listening', '', 'Painting supplies have been laid out on the floor.', 'He''s laying a brush down on a windowsill.', 'He''s lifting a can of paint by its handle.', 'Cans of paint have been placed on a step stool.', 'A', '(A) Dụng cụ sơn đã được bày ra trên sàn.

(B) Anh ấy đang đặt một chiếc cọ xuống bậu cửa sổ.

(C) Anh ấy đang nhấc một lon sơn bằng tay cầm.

(D) Những lon sơn đã được đặt trên một chiếc ghế thang.', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/5.mp3', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/5.webp', '', '(A) Painting supplies have been laid out on the floor.
(B) He''s laying a brush down on a windowsill.
(C) He''s lifting a can of paint by its handle.
(D) Cans of paint have been placed on a step stool.') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('04d6de9a-e83e-4fd5-aef5-a5b9287630dc', 'toeic-test-01', 6, 1, 'listening', '', 'A path is covered with fallen branches.', 'A tree is lying across a grassy area.', 'Some water has pooled on a path.', 'Some cyclists are riding through a field.', 'C', '(A) Một con đường bị phủ đầy bởi những cành cây gãy.

(B) Một cái cây đang nằm chắn ngang khu vực thảm cỏ.

(C) Một ít nước đọng lại thành vũng trên đường.

(D) Một số người đi xe đạp đang đạp xe qua một cánh đồng.', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/6.mp3', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/6.webp', '', '(A) A path is covered with fallen branches.
(B) A tree is lying across a grassy area.
(C) Some water has pooled on a path.
(D) Some cyclists are riding through a field.') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('cb0f89f4-b1dc-40c9-9031-83645fd32a51', 'toeic-test-01', 7, 2, 'listening', 'Where is the conference being held?', 'A three-day vacation.', 'At the Riverview Hotel.', 'In the supply cabinet.', '', 'B', 'Hội nghị được tổ chức ở đâu?

(A) Một kỳ nghỉ kéo dài ba ngày.

(B) Tại khách sạn Riverview.

(C) Trong tủ đựng đồ dùng.', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/7.mp3', '', '', 'Where is the conference being held?
(A) A three-day vacation.
(B) At the Riverview Hotel.
(C) In the supply cabinet.') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('a8a05a8d-bece-4a77-8956-3b2a627d7055', 'toeic-test-01', 8, 2, 'listening', 'When does the warehouse manager arrive?', 'Sure, no problem.', 'About twelve shipping boxes.', 'Not until this afternoon.', '', 'C', 'Quản lý kho hàng đến lúc mấy giờ?

(A) Chắc chắn rồi, không vấn đề gì.

(B) Khoảng mười hai thùng hàng.

(C) Phải đến tận chiều nay.', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/8.mp3', '', '', 'When does the warehouse manager arrive?
(A) Sure, no problem.
(B) About twelve shipping boxes.
(C) Not until this afternoon.') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('2bdd29eb-85fc-492e-9ce5-071aa8974f27', 'toeic-test-01', 9, 2, 'listening', 'There''s a nice park nearby, right?', 'Did you order paper for the copier?', 'Yes-it''s next to Greendale Lake.', 'They''re in the parking garage.', '', 'B', 'Gần đây có một công viên đẹp, đúng không?

(A) Bạn đã đặt giấy cho máy photocopy chưa?

(B) Có - nó nằm cạnh hồ Greendale.

(C) Chúng ở trong nhà để xe.', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/9.mp3', '', '', 'There''s a nice park nearby, right?
(A) Did you order paper for the copier?
(B) Yes-it''s next to Greendale Lake.
(C) They''re in the parking garage.') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('8d645c7e-86f6-4f47-9f1a-440a00dfadc6', 'toeic-test-01', 10, 2, 'listening', 'Who sent the meeting minutes to the accounting department?', 'Our office assistant.', 'They have a savings account.', 'Cash and credit cards.', '', 'A', 'Ai đã gửi biên bản cuộc họp cho phòng kế toán?

(A) Trợ lý văn phòng của chúng tôi.

(B) Họ có một tài khoản tiết kiệm.

(C) Tiền mặt và thẻ tín dụng.', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/10.mp3', '', '', 'Who sent the meeting minutes to the accounting department?
(A) Our office assistant.
(B) They have a savings account.
(C) Cash and credit cards.') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('7edeb675-e548-46a9-9920-ecedab1a2428', 'toeic-test-01', 11, 2, 'listening', 'I''d like to know what you think of our new finance analyst.', 'I''ve prepared the decorations for tomorrow.', 'He seems very competent.', 'It''s finally stopped raining.', '', 'B', 'Tôi muốn biết bạn nghĩ gì về chuyên viên phân tích tài chính mới của chúng ta.

(A) Tôi đã chuẩn bị đồ trang trí cho ngày mai.

(B) Anh ấy có vẻ rất có năng lực.

(C) Cuối cùng thì trời cũng đã tạnh mưa.', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/11.mp3', '', '', 'I''d like to know what you think of our new finance analyst.
(A) I''ve prepared the decorations for tomorrow.
(B) He seems very competent.
(C) It''s finally stopped raining.') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('0ed119ff-bf93-4822-aa91-446a9bcae698', 'toeic-test-01', 12, 2, 'listening', 'Let''s go on the company retreat.', 'Oh, did he?', 'Yes, that''s a good idea.', 'He tried to solve that problem.', '', 'B', 'Chúng ta đi chuyến nghỉ dưỡng của công ty đi.

(A) Ồ, anh ấy đã làm vậy sao?

(B) Vâng, đó là một ý kiến hay.

(C) Anh ấy đã cố gắng giải quyết vấn đề đó.', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/12.mp3', '', '', 'Let''s go on the company retreat.
(A) Oh, did he?
(B) Yes, that''s a good idea.
(C) He tried to solve that problem.') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('4b3d759a-36d8-4de1-992c-3ffbcc2a6dfa', 'toeic-test-01', 13, 2, 'listening', 'What time can I pick up my glasses?', 'No, it''s not very heavy.', 'About twenty meters.', 'We close at six o''clock.', '', 'C', 'Mấy giờ tôi có thể đến lấy kính?

(A) Không, nó không nặng lắm.

(B) Khoảng hai mươi mét.

(C) Chúng tôi đóng cửa lúc sáu giờ.', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/13.mp3', '', '', 'What time can I pick up my glasses?
(A) No, it''s not very heavy.
(B) About twenty meters.
(C) We close at six o''clock.') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('a72115f1-7556-4edc-bccc-6c9b1573d5b5', 'toeic-test-01', 14, 2, 'listening', 'The sales team knows how to use the tracking software, don''t they?', 'It''s on the lower shelf.', 'A twelve-thirty departure.', 'I haven''t seen them using it yet.', '', 'C', 'Đội bán hàng biết cách sử dụng phần mềm theo dõi, đúng không?

(A) Nó ở trên kệ dưới.

(B) Chuyến khởi hành lúc mười hai giờ ba mươi.

(C) Tôi vẫn chưa thấy họ sử dụng nó.', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/14.mp3', '', '', 'The sales team knows how to use the tracking software, don''t they?
(A) It''s on the lower shelf.
(B) A twelve-thirty departure.
(C) I haven''t seen them using it yet.') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('ebfe6713-c62c-410d-a10a-4441afba0db6', 'toeic-test-01', 15, 2, 'listening', 'Are you going to the hardware store on Mill Street?', 'That store hasn''t opened yet.', 'The blue package you sent me.', 'Some nails and a hammer.', '', 'A', 'Bạn có định đến cửa hàng ngũ kim trên đường Mill không?

(A) Cửa hàng đó vẫn chưa mở cửa.

(B) Gói hàng màu xanh mà bạn đã gửi cho tôi.

(C) Một vài chiếc đinh và một cây búa.', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/15.mp3', '', '', 'Are you going to the hardware store on Mill Street?
(A) That store hasn''t opened yet.
(B) The blue package you sent me.
(C) Some nails and a hammer.') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('28cc4407-5974-41ed-9782-f58eab0267ac', 'toeic-test-01', 16, 2, 'listening', 'Would you be able to write the introduction for the workshop?', 'That was a great book.', 'OK, I''d be happy to.', 'He doesn''t have any more.', '', 'B', 'Bạn có thể viết phần giới thiệu cho buổi hội thảo không?

(A) Đó là một cuốn sách tuyệt vời.

(B) Được chứ, tôi rất sẵn lòng.

(C) Anh ấy không còn cái nào nữa.', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/16.mp3', '', '', 'Would you be able to write the introduction for the workshop?
(A) That was a great book.
(B) OK, I''d be happy to.
(C) He doesn''t have any more.') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('42a2c97b-b381-4527-b74a-a4d3a9cabe52', 'toeic-test-01', 17, 2, 'listening', 'I picked up some flowers for Tunji''s retirement party.', 'No, pick any day.', 'That was thoughtful.', 'A delivery driver.', '', 'B', 'Tôi đã mua một ít hoa cho bữa tiệc nghỉ hưu của Tunji.

(A) Không, hãy chọn bất kỳ ngày nào.

(B) Thật là chu đáo.

(C) Một nhân viên giao hàng.', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/17.mp3', '', '', 'I picked up some flowers for Tunji''s retirement party.
(A) No, pick any day.
(B) That was thoughtful.
(C) A delivery driver.') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('0a19c615-dd21-4213-b0ba-35e7c2808b22', 'toeic-test-01', 18, 2, 'listening', 'Which meeting room did you tell the interns to go to?', 'The Jefferson Room.', 'The meeting was fun, thanks.', 'Yes, it''s a conference call.', '', 'A', 'Bạn đã bảo các thực tập sinh đến phòng họp nào?

(A) Phòng Jefferson.

(B) Cuộc họp rất vui, cảm ơn.

(C) Vâng, đó là một cuộc gọi hội nghị.', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/18.mp3', '', '', 'Which meeting room did you tell the interns to go to?
(A) The Jefferson Room.
(B) The meeting was fun, thanks.
(C) Yes, it''s a conference call.') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('37249b73-fa19-4146-be41-39569c5e8c56', 'toeic-test-01', 19, 2, 'listening', 'Is your dental appointment next Tuesday?', 'You can borrow mine.', 'I''ll have to check my calendar.', 'Yes, it was a good meeting.', '', 'B', 'Lịch hẹn nha sĩ của bạn vào thứ Ba tới phải không?

(A) Bạn có thể mượn cái của tôi.

(B) Tôi sẽ phải kiểm tra lịch của mình.

(C) Vâng, đó là một cuộc họp tốt.', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/19.mp3', '', '', 'Is your dental appointment next Tuesday?
(A) You can borrow mine.
(B) I''ll have to check my calendar.
(C) Yes, it was a good meeting.') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('a38de03d-b2ab-490c-85f8-fe2b617e77d8', 'toeic-test-01', 20, 2, 'listening', 'Why aren''t there any brochures in the lobby?', 'No, I haven''t received my confirmation e-mail yet.', 'My winter coat.', 'Because someone just took the last one.', '', 'C', 'Tại sao không có tờ rơi quảng cáo nào ở sảnh chờ?

(A) Không, tôi vẫn chưa nhận được email xác nhận.

(B) Áo khoác mùa đông của tôi.

(C) Bởi vì ai đó vừa mới lấy cái cuối cùng rồi.', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/20.mp3', '', '', 'Why aren''t there any brochures in the lobby?
(A) No, I haven''t received my confirmation e-mail yet.
(B) My winter coat.
(C) Because someone just took the last one.') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('87711b71-0c92-4497-a40b-f257ad0b40e5', 'toeic-test-01', 21, 2, 'listening', 'What''s the process for submitting my expense report?', 'You send it to the finance department.', 'The end of the day.', 'That''s correct.', '', 'A', 'Quy trình nộp báo cáo chi phí của tôi là gì?

(A) Bạn gửi nó cho bộ phận tài chính.

(B) Cuối ngày.

(C) Điều đó đúng.', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/21.mp3', '', '', 'What''s the process for submitting my expense report?
(A) You send it to the finance department.
(B) The end of the day.
(C) That''s correct.') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('0e40159b-7006-40e2-acdb-364a49bb775b', 'toeic-test-01', 22, 2, 'listening', 'Do you sell your products online or in stores?', 'About twenty percent off.', 'A product demonstration.', 'Only online.', '', 'C', 'Bạn bán sản phẩm trực tuyến hay tại cửa hàng?

(A) Giảm giá khoảng hai mươi phần trăm.

(B) Một buổi trình diễn sản phẩm.

(C) Chỉ trực tuyến thôi.', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/22.mp3', '', '', 'Do you sell your products online or in stores?
(A) About twenty percent off.
(B) A product demonstration.
(C) Only online.') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('7ffff3ef-2255-4dde-be86-d153bfda7ecd', 'toeic-test-01', 23, 2, 'listening', 'How often do you charge this device?', 'Whenever the light turns red.', 'A wireless one.', 'At the hardware store.', '', 'A', 'Bạn sạc thiết bị này thường xuyên như thế nào?

(A) Bất cứ khi nào đèn chuyển sang màu đỏ.

(B) Một cái không dây.

(C) Tại cửa hàng ngũ kim.', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/23.mp3', '', '', 'How often do you charge this device?
(A) Whenever the light turns red.
(B) A wireless one.
(C) At the hardware store.') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('f5c95d50-4800-4293-bd41-45d110d50d48', 'toeic-test-01', 24, 2, 'listening', 'The tickets to Friday night''s concert cost ten dollars each.', 'Actually, they''re fifteen.', 'No, I can''t play the guitar.', 'It''s in aisle five.', '', 'A', 'Vé xem buổi hòa nhạc tối thứ Sáu giá mười đô la mỗi vé.

(A) Thực ra, chúng có giá mười lăm đô la.

(B) Không, tôi không biết chơi ghi-ta.

(C) Nó ở lối đi số năm.', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/24.mp3', '', '', 'The tickets to Friday night''s concert cost ten dollars each.
(A) Actually, they''re fifteen.
(B) No, I can''t play the guitar.
(C) It''s in aisle five.') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('bf074903-4991-4cd5-b99e-8ed74eace453', 'toeic-test-01', 25, 2, 'listening', 'Can''t you update the database today?', 'I did it yesterday.', 'That''s an interesting movie.', 'No, just me.', '', 'A', 'Bạn không thể cập nhật cơ sở dữ liệu hôm nay sao?

(A) Tôi đã làm nó vào ngày hôm qua rồi.

(B) Đó là một bộ phim thú vị.

(C) Không, chỉ mình tôi thôi.', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/25.mp3', '', '', 'Can''t you update the database today?
(A) I did it yesterday.
(B) That''s an interesting movie.
(C) No, just me.') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('698166d0-1724-43c0-aa64-799c2d9e1e60', 'toeic-test-01', 26, 2, 'listening', 'How are we going to fit the extra supplies in that closet?', 'I''ve already read them.', 'Natalie''s in charge of supplies.', 'It''s the door at the end of the hallway.', '', 'B', 'Làm sao chúng ta nhét thêm đồ dùng vào tủ đó được?

(A) Tôi đã đọc chúng rồi.

(B) Natalie chịu trách nhiệm về vật tư.

(C) Đó là cánh cửa ở cuối hành lang.', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/26.mp3', '', '', 'How are we going to fit the extra supplies in that closet?
(A) I''ve already read them.
(B) Natalie''s in charge of supplies.
(C) It''s the door at the end of the hallway.') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('6470069d-7d18-459f-8366-394619cfe106', 'toeic-test-01', 27, 2, 'listening', 'Have all the new windows been installed?', 'Sure, I''ll close the blinds.', 'The construction crew is almost finished.', 'This isn''t the tallest ladder available.', '', 'B', 'Tất cả các cửa sổ mới đã được lắp đặt chưa?

(A) Chắc chắn rồi, tôi sẽ đóng rèm lại.

(B) Đội xây dựng gần như đã hoàn thành xong.

(C) Đây không phải là chiếc thang cao nhất hiện có.', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/27.mp3', '', '', 'Have all the new windows been installed?
(A) Sure, I''ll close the blinds.
(B) The construction crew is almost finished.
(C) This isn''t the tallest ladder available.') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('ceb12ba5-944f-4d89-9393-7161c3a5faeb', 'toeic-test-01', 28, 2, 'listening', 'Would you rather go to lunch now or at noon?', 'I''m taking a client to lunch.', 'On the corner of Fourth and Main.', 'The daily special is soup and a sandwich.', '', 'A', 'Bạn muốn đi ăn trưa bây giờ hay lúc giữa trưa?

(A) Tôi đang đưa một khách hàng đi ăn trưa.

(B) Ở góc đường số 4 và đường Main.

(C) Món đặc biệt hàng ngày là súp và bánh mì kẹp.', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/28.mp3', '', '', 'Would you rather go to lunch now or at noon?
(A) I''m taking a client to lunch.
(B) On the corner of Fourth and Main.
(C) The daily special is soup and a sandwich.') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('68cc62d7-6bca-45b4-9b7b-d572d2c00edb', 'toeic-test-01', 29, 2, 'listening', 'You''re taking the training in the afternoon, aren''t you?', 'The new head of the accounting department.', 'No, I take my coffee black.', 'Well, it depends on my schedule.', '', 'C', 'Bạn sẽ tham gia buổi đào tạo vào buổi chiều, đúng không?

(A) Trưởng phòng kế toán mới.

(B) Không, tôi uống cà phê đen.

(C) À, nó còn tùy thuộc vào lịch trình của tôi.', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/29.mp3', '', '', 'You''re taking the training in the afternoon, aren''t you?
(A) The new head of the accounting department.
(B) No, I take my coffee black.
(C) Well, it depends on my schedule.') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('20050997-0638-44df-ae88-b3a44c22bc42', 'toeic-test-01', 30, 2, 'listening', 'Shouldn''t Ms. Ishida look over the financial projections?', 'I just got this monitor.', 'To the south entrance.', 'I''m meeting with her at ten.', '', 'C', 'Cô Ishida có nên xem qua các dự báo tài chính không?

(A) Tôi vừa mới nhận được cái màn hình này.

(B) Đến lối vào phía Nam.

(C) Tôi sẽ gặp cô ấy lúc mười giờ.', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/30.mp3', '', '', 'Shouldn''t Ms. Ishida look over the financial projections?
(A) I just got this monitor.
(B) To the south entrance.
(C) I''m meeting with her at ten.') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('d5cc92b0-0b0a-4738-a838-3bbbda391b09', 'toeic-test-01', 31, 2, 'listening', 'When are you going to choose a new project manager?', 'The projector''s not working correctly.', 'Next to the front entrance.', 'I''m really busy this week.', '', 'C', 'Khi nào bạn sẽ chọn một quản lý dự án mới?

(A) Máy chiếu đang hoạt động không đúng cách.

(B) Cạnh lối vào phía trước.

(C) Tuần này tôi thực sự rất bận.', 'https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/2026/t1/31.mp3', '', '', 'When are you going to choose a new project manager?
(A) The projector''s not working correctly.
(B) Next to the front entrance.
(C) I''m really busy this week.') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('00ff3cbc-7bac-4784-956d-fe936304907a', 'toeic-test-01', 32, 3, 'listening', 'What type of food product does the speakers’ company sell?', 'Candy', 'Cheese', 'Bread', 'Pasta', 'B', 'W: Này Oliver. Anh đã xem kết quả thảo luận nhóm tập trung (focus group) cho loại phô mai cheddar cay mới của chúng ta chưa? Mọi người thực sự rất thích nó.

M: Rồi. Nó sẽ là một sự bổ sung tuyệt vời cho dòng phô mai của công ty chúng ta.

W: Một vài người đã đề cập rằng họ muốn sử dụng nó trong các công thức nấu ăn—chẳng hạn như thêm vào các loại nước sốt.

M: Vậy có lẽ chúng ta nên cân nhắc việc bán phiên bản phô mai bào để nó dễ tan chảy hơn khi nấu nướng.

W: Tôi chắc chắn chúng ta có thể làm được việc đó. Tôi sẽ liên lạc với quản lý sản xuất để đưa ra yêu cầu này.', '', '', '0573fe39-710f-41f2-8491-afe9de68bd3a', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('916fbfab-6153-492c-a077-3bf245c47003', 'toeic-test-01', 33, 3, 'listening', 'What does the man suggest?', 'Lowering prices', 'Hiring more workers', 'Publishing a recipe', 'Offering additional options', 'D', 'W: Này Oliver. Anh đã xem kết quả thảo luận nhóm tập trung (focus group) cho loại phô mai cheddar cay mới của chúng ta chưa? Mọi người thực sự rất thích nó.

M: Rồi. Nó sẽ là một sự bổ sung tuyệt vời cho dòng phô mai của công ty chúng ta.

W: Một vài người đã đề cập rằng họ muốn sử dụng nó trong các công thức nấu ăn—chẳng hạn như thêm vào các loại nước sốt.

M: Vậy có lẽ chúng ta nên cân nhắc việc bán phiên bản phô mai bào để nó dễ tan chảy hơn khi nấu nướng.

W: Tôi chắc chắn chúng ta có thể làm được việc đó. Tôi sẽ liên lạc với quản lý sản xuất để đưa ra yêu cầu này.', '', '', '0573fe39-710f-41f2-8491-afe9de68bd3a', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('de84b75a-49d0-4f46-b42f-360b65dca4c3', 'toeic-test-01', 34, 3, 'listening', 'What does the woman say she will do?', 'Send a schedule update', 'Contact a production manager', 'Visit the company headquarters', 'Plan an advertising campaign', 'B', 'W: Này Oliver. Anh đã xem kết quả thảo luận nhóm tập trung (focus group) cho loại phô mai cheddar cay mới của chúng ta chưa? Mọi người thực sự rất thích nó.

M: Rồi. Nó sẽ là một sự bổ sung tuyệt vời cho dòng phô mai của công ty chúng ta.

W: Một vài người đã đề cập rằng họ muốn sử dụng nó trong các công thức nấu ăn—chẳng hạn như thêm vào các loại nước sốt.

M: Vậy có lẽ chúng ta nên cân nhắc việc bán phiên bản phô mai bào để nó dễ tan chảy hơn khi nấu nướng.

W: Tôi chắc chắn chúng ta có thể làm được việc đó. Tôi sẽ liên lạc với quản lý sản xuất để đưa ra yêu cầu này.', '', '', '0573fe39-710f-41f2-8491-afe9de68bd3a', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('66e42937-7bd5-458f-8dbf-8722d88af18e', 'toeic-test-01', 35, 3, 'listening', 'Why is the man calling?', 'To sign up for lessons', 'To enter a competition', 'To buy tickets to an event', 'To ask about branded merchandise', 'C', 'M: Xin chào. Tôi gọi điện để đặt ba vé cho trận đấu quần vợt vào thứ Năm tuần này. Còn ghế trống nào không?

W: Chỉ còn vài ghế thôi! Vé cho trận đấu thứ Năm đang được bán rất nhanh.

M: Tôi không ngạc nhiên đâu! Suy cho cùng, Ife Rotimi đã giành chức vô địch khu vực vào tháng trước mà. Mọi người đều muốn xem cô ấy thi đấu sau màn trình diễn đáng kinh ngạc đó. Còn những chỗ ngồi nào trống?

W: Chà, chỉ còn duy nhất một nhóm ba ghế cạnh nhau. Yêu cầu phải thanh toán trước để giữ chỗ.', '', '', '9bd22317-304d-48bf-aa10-7f565ea00eb5', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('62940187-39d7-4526-acfd-a5cdcdefe745', 'toeic-test-01', 36, 3, 'listening', 'What did Ife Rotimi do last month?', 'She won a regional tournament.', 'She gave a television interview.', 'She started an institute.', 'She hired a new coach.', 'A', 'M: Xin chào. Tôi gọi điện để đặt ba vé cho trận đấu quần vợt vào thứ Năm tuần này. Còn ghế trống nào không?

W: Chỉ còn vài ghế thôi! Vé cho trận đấu thứ Năm đang được bán rất nhanh.

M: Tôi không ngạc nhiên đâu! Suy cho cùng, Ife Rotimi đã giành chức vô địch khu vực vào tháng trước mà. Mọi người đều muốn xem cô ấy thi đấu sau màn trình diễn đáng kinh ngạc đó. Còn những chỗ ngồi nào trống?

W: Chà, chỉ còn duy nhất một nhóm ba ghế cạnh nhau. Yêu cầu phải thanh toán trước để giữ chỗ.', '', '', '9bd22317-304d-48bf-aa10-7f565ea00eb5', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('9c3321c6-0163-4595-8b38-b602a2f3a2e6', 'toeic-test-01', 37, 3, 'listening', 'What does the woman say is required?', 'A parking permit', 'A photo ID', 'Contact information', 'Advance payment', 'D', 'M: Xin chào. Tôi gọi điện để đặt ba vé cho trận đấu quần vợt vào thứ Năm tuần này. Còn ghế trống nào không?

W: Chỉ còn vài ghế thôi! Vé cho trận đấu thứ Năm đang được bán rất nhanh.

M: Tôi không ngạc nhiên đâu! Suy cho cùng, Ife Rotimi đã giành chức vô địch khu vực vào tháng trước mà. Mọi người đều muốn xem cô ấy thi đấu sau màn trình diễn đáng kinh ngạc đó. Còn những chỗ ngồi nào trống?

W: Chà, chỉ còn duy nhất một nhóm ba ghế cạnh nhau. Yêu cầu phải thanh toán trước để giữ chỗ.', '', '', '9bd22317-304d-48bf-aa10-7f565ea00eb5', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('a6386ecd-c658-4e1b-a683-4e523668d6b7', 'toeic-test-01', 38, 3, 'listening', 'What event are the speakers planning?', 'A fund-raising dinner', 'An art gallery opening', 'An awards ceremony', 'A children’s book fair', 'A', 'W: Cảm ơn anh đã đồng ý giúp tôi tổ chức bữa tối gây quỹ thường niên của thư viện, Klaus. Chúng tôi hy vọng sự kiện này sẽ mang lại đủ tiền để mở rộng khu vực sách dành cho trẻ em.

M: Cô muốn tôi bắt đầu với nhiệm vụ nào?

W: Chà, tôi cần một chút trợ giúp để gửi các thư mời.

M: Được thôi, tôi có thể đảm nhận việc đó. Có sẵn danh sách những người tham dự không?

W: Nó nằm trong các tệp máy tính của tôi. Tôi sẽ gửi email cho anh.', '', '', '0d04c823-8b01-4da9-8151-282fa769137a', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('b612ae37-8ba9-46fd-a07c-21d50903e6a3', 'toeic-test-01', 39, 3, 'listening', 'What task does the woman ask the man to help with?', 'Arranging a shuttle service', 'Choosing a catering firm', 'Preparing a speech', 'Sending out invitations', 'D', 'W: Cảm ơn anh đã đồng ý giúp tôi tổ chức bữa tối gây quỹ thường niên của thư viện, Klaus. Chúng tôi hy vọng sự kiện này sẽ mang lại đủ tiền để mở rộng khu vực sách dành cho trẻ em.

M: Cô muốn tôi bắt đầu với nhiệm vụ nào?

W: Chà, tôi cần một chút trợ giúp để gửi các thư mời.

M: Được thôi, tôi có thể đảm nhận việc đó. Có sẵn danh sách những người tham dự không?

W: Nó nằm trong các tệp máy tính của tôi. Tôi sẽ gửi email cho anh.', '', '', '0d04c823-8b01-4da9-8151-282fa769137a', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('7a6cb10f-291f-4cad-90f9-ebe00de72009', 'toeic-test-01', 40, 3, 'listening', 'What does the woman say she will do?', 'E-mail a list', 'Speak with a colleague', 'Provide a password', 'Post a job opening', 'A', 'W: Cảm ơn anh đã đồng ý giúp tôi tổ chức bữa tối gây quỹ thường niên của thư viện, Klaus. Chúng tôi hy vọng sự kiện này sẽ mang lại đủ tiền để mở rộng khu vực sách dành cho trẻ em.

M: Cô muốn tôi bắt đầu với nhiệm vụ nào?

W: Chà, tôi cần một chút trợ giúp để gửi các thư mời.

M: Được thôi, tôi có thể đảm nhận việc đó. Có sẵn danh sách những người tham dự không?

W: Nó nằm trong các tệp máy tính của tôi. Tôi sẽ gửi email cho anh.', '', '', '0d04c823-8b01-4da9-8151-282fa769137a', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('3b07e394-e032-480f-9d4c-864b36003f07', 'toeic-test-01', 41, 3, 'listening', 'What event are the speakers preparing for?', 'A new-employee orientation', 'A grand opening', 'A community festival', 'A trade show', 'C', 'W: Này Brian và Matteo. Tôi đã tìm thấy một số loại bút rất tuyệt để tặng tại lễ hội cộng đồng nhằm quảng bá doanh nghiệp của chúng ta.

M1: Tuyệt quá. Chúng ta có thể in logo dịch vụ vệ sinh của mình lên đó không?

W: Có chứ, không mất thêm phí đâu. Và chúng còn có thể phân hủy sinh học nữa. Chúng được làm từ giấy.

M2: Vậy khi chúng ta phát chúng, chúng ta có thể đề cập đến điều đó.

M1: Cũng như nói về các vật dụng vệ sinh hữu cơ mà công ty chúng ta sử dụng.

W: Được rồi. Tôi sẽ tiến hành đặt mua vài thùng.', '', '', '8289f3e5-3556-49f1-9682-ec69643be8e5', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('c7937285-3b28-4147-b803-c726a88bbebf', 'toeic-test-01', 42, 3, 'listening', 'What is mentioned about some pens?', 'They are available in multiple colors.', 'They use permanent ink.', 'They are preferred by book authors.', 'They are made from paper.', 'D', 'W: Này Brian và Matteo. Tôi đã tìm thấy một số loại bút rất tuyệt để tặng tại lễ hội cộng đồng nhằm quảng bá doanh nghiệp của chúng ta.

M1: Tuyệt quá. Chúng ta có thể in logo dịch vụ vệ sinh của mình lên đó không?

W: Có chứ, không mất thêm phí đâu. Và chúng còn có thể phân hủy sinh học nữa. Chúng được làm từ giấy.

M2: Vậy khi chúng ta phát chúng, chúng ta có thể đề cập đến điều đó.

M1: Cũng như nói về các vật dụng vệ sinh hữu cơ mà công ty chúng ta sử dụng.

W: Được rồi. Tôi sẽ tiến hành đặt mua vài thùng.', '', '', '8289f3e5-3556-49f1-9682-ec69643be8e5', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('091d772e-167e-42e4-9d2e-ad43e6473d7b', 'toeic-test-01', 43, 3, 'listening', 'What does the woman offer to do?', 'Reserve a booth', 'Place an order', 'Organize a focus group', 'Revise a budget', 'B', 'W: Này Brian và Matteo. Tôi đã tìm thấy một số loại bút rất tuyệt để tặng tại lễ hội cộng đồng nhằm quảng bá doanh nghiệp của chúng ta.

M1: Tuyệt quá. Chúng ta có thể in logo dịch vụ vệ sinh của mình lên đó không?

W: Có chứ, không mất thêm phí đâu. Và chúng còn có thể phân hủy sinh học nữa. Chúng được làm từ giấy.

M2: Vậy khi chúng ta phát chúng, chúng ta có thể đề cập đến điều đó.

M1: Cũng như nói về các vật dụng vệ sinh hữu cơ mà công ty chúng ta sử dụng.

W: Được rồi. Tôi sẽ tiến hành đặt mua vài thùng.', '', '', '8289f3e5-3556-49f1-9682-ec69643be8e5', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('936afc9f-3c91-4a73-b166-e43d38d0e16d', 'toeic-test-01', 44, 3, 'listening', 'Where does the woman work?', 'At a delivery service', 'At an electronics store', 'At a recycling facility', 'At a real estate agency', 'C', 'W: Cơ sở tái chế Jamestown xin nghe. Tôi có thể giúp gì cho ông?

M: Chào cô. Tôi đang chuẩn bị chuyển nhà sớm, và tôi có một số đồ điện tử như tivi và máy tính mà tôi muốn bỏ đi trước khi rao bán nhà. Bạn tôi có nói rằng các cô có thể nhận chúng.

W: Vâng, đúng vậy. Chúng tôi nhận tất cả đồ điện tử.

M: Tuyệt. Tôi chỉ có một câu hỏi. Các cô có cung cấp dịch vụ đến lấy hàng tận nơi không?

W: Không, thật không may là ông sẽ phải tự mình mang mọi thứ đến đây. Tuy nhiên, trên trang web của chúng tôi có liệt kê một số công ty có thể tháo dỡ và xử lý các vật dụng đó cho ông.', '', '', '3960e378-e3ea-4c5c-b832-1ca1fb9df88a', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('b37abeb9-2567-4f3a-ba53-bff4c2a4d8c8', 'toeic-test-01', 45, 3, 'listening', 'What does the man want to dispose of?', 'Yard waste', 'Used furniture', 'Electronics', 'Books', 'C', 'W: Cơ sở tái chế Jamestown xin nghe. Tôi có thể giúp gì cho ông?

M: Chào cô. Tôi đang chuẩn bị chuyển nhà sớm, và tôi có một số đồ điện tử như tivi và máy tính mà tôi muốn bỏ đi trước khi rao bán nhà. Bạn tôi có nói rằng các cô có thể nhận chúng.

W: Vâng, đúng vậy. Chúng tôi nhận tất cả đồ điện tử.

M: Tuyệt. Tôi chỉ có một câu hỏi. Các cô có cung cấp dịch vụ đến lấy hàng tận nơi không?

W: Không, thật không may là ông sẽ phải tự mình mang mọi thứ đến đây. Tuy nhiên, trên trang web của chúng tôi có liệt kê một số công ty có thể tháo dỡ và xử lý các vật dụng đó cho ông.', '', '', '3960e378-e3ea-4c5c-b832-1ca1fb9df88a', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('bca4bc38-25b3-42f5-b50c-adcf499f7d16', 'toeic-test-01', 46, 3, 'listening', 'What does the woman say can be found on a Web site?', 'A list of companies', 'Hours of operation', 'A permit application', 'Directions to a site', 'A', 'W: Cơ sở tái chế Jamestown xin nghe. Tôi có thể giúp gì cho ông?

M: Chào cô. Tôi đang chuẩn bị chuyển nhà sớm, và tôi có một số đồ điện tử như tivi và máy tính mà tôi muốn bỏ đi trước khi rao bán nhà. Bạn tôi có nói rằng các cô có thể nhận chúng.

W: Vâng, đúng vậy. Chúng tôi nhận tất cả đồ điện tử.

M: Tuyệt. Tôi chỉ có một câu hỏi. Các cô có cung cấp dịch vụ đến lấy hàng tận nơi không?

W: Không, thật không may là ông sẽ phải tự mình mang mọi thứ đến đây. Tuy nhiên, trên trang web của chúng tôi có liệt kê một số công ty có thể tháo dỡ và xử lý các vật dụng đó cho ông.', '', '', '3960e378-e3ea-4c5c-b832-1ca1fb9df88a', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('5c7d0df7-1bba-4435-9d5e-b27511bae3cf', 'toeic-test-01', 47, 3, 'listening', 'How do the speakers know each other?', 'They took a class together.', 'They used to work for the same company.', 'They grew up in the same neighborhood.', 'They met on a train.', 'A', 'M: Zaina! Thật bất ngờ! Tôi đã không gặp cô kể từ khi chúng ta học chung lớp dành cho chủ doanh nghiệp năm ngoái. Cô thế nào rồi?

W: Rất tốt, cảm ơn anh. Tôi vừa ở khu vực lân cận và nghĩ rằng mình sẽ ghé vào ăn một chiếc bánh quy hoặc một miếng bánh ngọt. Anh có rất nhiều đồ nướng ngon ở đây.

M: Cảm ơn cô! Đó là một năm kinh doanh thuận lợi. Tôi thậm chí đang cân nhắc việc mở địa điểm thứ hai.

W: Thật sao? À, tôi nhận thấy nhà hàng Sunnyvale đã đóng cửa kinh doanh, và tòa nhà đó đang được cho thuê. Nó rất gần trường đại học địa phương. Anh có thể sẽ có rất nhiều khách vãng lai đấy.', '', '', '2681a24a-17a6-48a0-817a-c3cd9c92b115', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('da638151-18b0-45a1-9103-0aa622c3abc3', 'toeic-test-01', 48, 3, 'listening', 'What type of business does the man most likely own?', 'A fitness center', 'A real estate agency', 'A culinary school', 'A bakery', 'D', 'M: Zaina! Thật bất ngờ! Tôi đã không gặp cô kể từ khi chúng ta học chung lớp dành cho chủ doanh nghiệp năm ngoái. Cô thế nào rồi?

W: Rất tốt, cảm ơn anh. Tôi vừa ở khu vực lân cận và nghĩ rằng mình sẽ ghé vào ăn một chiếc bánh quy hoặc một miếng bánh ngọt. Anh có rất nhiều đồ nướng ngon ở đây.

M: Cảm ơn cô! Đó là một năm kinh doanh thuận lợi. Tôi thậm chí đang cân nhắc việc mở địa điểm thứ hai.

W: Thật sao? À, tôi nhận thấy nhà hàng Sunnyvale đã đóng cửa kinh doanh, và tòa nhà đó đang được cho thuê. Nó rất gần trường đại học địa phương. Anh có thể sẽ có rất nhiều khách vãng lai đấy.', '', '', '2681a24a-17a6-48a0-817a-c3cd9c92b115', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('f9f80766-b4f3-48ce-b6b6-c07c3dd26f58', 'toeic-test-01', 49, 3, 'listening', 'What advantage does the woman point out about a rental space?', 'Its price', 'Its size', 'Its location', 'Its design', 'C', 'M: Zaina! Thật bất ngờ! Tôi đã không gặp cô kể từ khi chúng ta học chung lớp dành cho chủ doanh nghiệp năm ngoái. Cô thế nào rồi?

W: Rất tốt, cảm ơn anh. Tôi vừa ở khu vực lân cận và nghĩ rằng mình sẽ ghé vào ăn một chiếc bánh quy hoặc một miếng bánh ngọt. Anh có rất nhiều đồ nướng ngon ở đây.

M: Cảm ơn cô! Đó là một năm kinh doanh thuận lợi. Tôi thậm chí đang cân nhắc việc mở địa điểm thứ hai.

W: Thật sao? À, tôi nhận thấy nhà hàng Sunnyvale đã đóng cửa kinh doanh, và tòa nhà đó đang được cho thuê. Nó rất gần trường đại học địa phương. Anh có thể sẽ có rất nhiều khách vãng lai đấy.', '', '', '2681a24a-17a6-48a0-817a-c3cd9c92b115', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('2a65889c-5b43-4013-ae10-ef1c6c8e8473', 'toeic-test-01', 50, 3, 'listening', 'Who most likely are the speakers?', 'Film actors', 'Museum directors', 'Video game developers', 'Investigative journalists', 'C', 'W: Chào Koji. Tôi nghĩ trò chơi điện tử mới của chúng ta đã gần sẵn sàng để phát hành rồi. Anh có biết về bất kỳ cải thiện nào cần thực hiện trước đó không?

M: Thực ra, tôi vừa kết thúc việc kiểm tra trò chơi sáng nay. Tôi đã tìm thấy một vấn đề ở màn thứ ba của trò chơi. Có một vài lần nhân vật của tôi không thể di chuyển được.

W: Ồ, lạ thật đấy!

M: Tôi đã kiểm tra lại vấn đề đó bằng một bộ điều khiển khác. Vấn đề tương tự vẫn xảy ra.

W: Ồ. Tôi nghĩ Pauline cũng gặp vấn đề tương tự với một trò chơi mà cô ấy đã kiểm tra. Có lẽ anh nên hỏi cô ấy về việc đó.', '', '', '08cfc15e-111f-4df1-940a-8b326fb06ea1', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('b97e4d68-039f-49dc-add8-17a27446a2e2', 'toeic-test-01', 51, 3, 'listening', 'What did the man recently do?', 'He secured some funding.', 'He tested a product.', 'He read a script.', 'He conducted an interview.', 'B', 'W: Chào Koji. Tôi nghĩ trò chơi điện tử mới của chúng ta đã gần sẵn sàng để phát hành rồi. Anh có biết về bất kỳ cải thiện nào cần thực hiện trước đó không?

M: Thực ra, tôi vừa kết thúc việc kiểm tra trò chơi sáng nay. Tôi đã tìm thấy một vấn đề ở màn thứ ba của trò chơi. Có một vài lần nhân vật của tôi không thể di chuyển được.

W: Ồ, lạ thật đấy!

M: Tôi đã kiểm tra lại vấn đề đó bằng một bộ điều khiển khác. Vấn đề tương tự vẫn xảy ra.

W: Ồ. Tôi nghĩ Pauline cũng gặp vấn đề tương tự với một trò chơi mà cô ấy đã kiểm tra. Có lẽ anh nên hỏi cô ấy về việc đó.', '', '', '08cfc15e-111f-4df1-940a-8b326fb06ea1', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('f1287366-cba2-417d-baf3-e0baa40cfdf8', 'toeic-test-01', 52, 3, 'listening', 'What does the woman suggest?', 'Consulting a colleague', 'Planning an event', 'Negotiating a contract', 'Giving a client an update', 'A', 'W: Chào Koji. Tôi nghĩ trò chơi điện tử mới của chúng ta đã gần sẵn sàng để phát hành rồi. Anh có biết về bất kỳ cải thiện nào cần thực hiện trước đó không?

M: Thực ra, tôi vừa kết thúc việc kiểm tra trò chơi sáng nay. Tôi đã tìm thấy một vấn đề ở màn thứ ba của trò chơi. Có một vài lần nhân vật của tôi không thể di chuyển được.

W: Ồ, lạ thật đấy!

M: Tôi đã kiểm tra lại vấn đề đó bằng một bộ điều khiển khác. Vấn đề tương tự vẫn xảy ra.

W: Ồ. Tôi nghĩ Pauline cũng gặp vấn đề tương tự với một trò chơi mà cô ấy đã kiểm tra. Có lẽ anh nên hỏi cô ấy về việc đó.', '', '', '08cfc15e-111f-4df1-940a-8b326fb06ea1', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('8d3b42b2-a1d5-459b-b5cf-7d945952f41f', 'toeic-test-01', 53, 3, 'listening', 'Who most likely is the man?', 'A delivery driver', 'A security guard', 'A maintenance worker', 'A customer service representative', 'C', 'M: Bạn đã gọi đến văn phòng bảo trì tại Khu chung cư Hillview.

W: Xin chào. Tôi là Palavi Sen từ căn hộ 35B. Tôi gọi vì cái bộ nhiệt kế mới trong căn hộ của tôi không hoạt động. Nó cứ tự tắt và bật một cách ngẫu nhiên, nên căn hộ của tôi đang bị lạnh.

M: Vấn đề này bắt đầu từ khi nào?

W: Vài giờ trước. Bộ nhiệt kế này vừa mới được lắp đặt ngày hôm qua.

M: Được rồi. Tôi có thể đến và kiểm tra nó vào sáng mai.

W: Nhưng tối nay nhiệt độ được dự báo là dưới mức đóng băng đấy!', '', '', '514f5ff6-5099-43aa-93bc-f04469584e3d', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('ba7db65e-4118-4eae-a83e-3a670768c0af', 'toeic-test-01', 54, 3, 'listening', 'What problem does the woman describe?', 'A device is malfunctioning.', 'A key is missing.', 'A parking area is unavailable.', 'A package was not received.', 'A', 'M: Bạn đã gọi đến văn phòng bảo trì tại Khu chung cư Hillview.

W: Xin chào. Tôi là Palavi Sen từ căn hộ 35B. Tôi gọi vì cái bộ nhiệt kế mới trong căn hộ của tôi không hoạt động. Nó cứ tự tắt và bật một cách ngẫu nhiên, nên căn hộ của tôi đang bị lạnh.

M: Vấn đề này bắt đầu từ khi nào?

W: Vài giờ trước. Bộ nhiệt kế này vừa mới được lắp đặt ngày hôm qua.

M: Được rồi. Tôi có thể đến và kiểm tra nó vào sáng mai.

W: Nhưng tối nay nhiệt độ được dự báo là dưới mức đóng băng đấy!', '', '', '514f5ff6-5099-43aa-93bc-f04469584e3d', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('da9260a2-9124-4609-9b69-4954df711d62', 'toeic-test-01', 55, 3, 'listening', 'What does the woman mean when she says, “it’s supposed to be below freezing tonight”?', 'She is surprised by the weather forecast.', 'She wants a service to be completed sooner.', 'She will move some items indoors.', 'She would prefer to park near her apartment.', 'B', 'M: Bạn đã gọi đến văn phòng bảo trì tại Khu chung cư Hillview.

W: Xin chào. Tôi là Palavi Sen từ căn hộ 35B. Tôi gọi vì cái bộ nhiệt kế mới trong căn hộ của tôi không hoạt động. Nó cứ tự tắt và bật một cách ngẫu nhiên, nên căn hộ của tôi đang bị lạnh.

M: Vấn đề này bắt đầu từ khi nào?

W: Vài giờ trước. Bộ nhiệt kế này vừa mới được lắp đặt ngày hôm qua.

M: Được rồi. Tôi có thể đến và kiểm tra nó vào sáng mai.

W: Nhưng tối nay nhiệt độ được dự báo là dưới mức đóng băng đấy!', '', '', '514f5ff6-5099-43aa-93bc-f04469584e3d', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('8cfbb1c9-b385-4621-aa15-5a6863733901', 'toeic-test-01', 56, 3, 'listening', 'Why do the men want to speak to the woman?', 'To review a building design', 'To discuss a loan', 'To develop an advertising plan', 'To purchase some supplies', 'B', 'W: Chào buổi sáng! Chào mừng quý khách đến với Ngân hàng Jasper.

M1: Cảm ơn cô đã gặp chúng tôi để thảo luận về một khoản vay cho doanh nghiệp của chúng tôi.

W: Hai ông có thể cho tôi biết thêm về doanh nghiệp của mình được không? Tôi hiểu đó là một cửa hàng sửa chữa?

M2: Chà, mười năm trước, chúng tôi mở cửa như một cửa hàng sửa chữa xe trượt tuyết, nhưng sau vài năm, chúng tôi cũng bắt đầu cho thuê xe trượt tuyết và các thiết bị thể thao khác.

M1: Vâng, và vì du lịch mùa đông đã gia tăng gần đây, chúng tôi muốn mở rộng không gian của mình để có thể chứa nhiều hàng tồn kho hơn.', '', '', '49b0b3c2-f4e6-41d4-a7eb-b8c098781ea4', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('5cbc9a3e-849d-4a87-aebd-b7ce715e75a6', 'toeic-test-01', 57, 3, 'listening', 'What type of business do the men own?', 'A sports equipment store', 'A winter apparel store', 'An automobile dealership', 'A hotel chain', 'A', 'W: Chào buổi sáng! Chào mừng quý khách đến với Ngân hàng Jasper.

M1: Cảm ơn cô đã gặp chúng tôi để thảo luận về một khoản vay cho doanh nghiệp của chúng tôi.

W: Hai ông có thể cho tôi biết thêm về doanh nghiệp của mình được không? Tôi hiểu đó là một cửa hàng sửa chữa?

M2: Chà, mười năm trước, chúng tôi mở cửa như một cửa hàng sửa chữa xe trượt tuyết, nhưng sau vài năm, chúng tôi cũng bắt đầu cho thuê xe trượt tuyết và các thiết bị thể thao khác.

M1: Vâng, và vì du lịch mùa đông đã gia tăng gần đây, chúng tôi muốn mở rộng không gian của mình để có thể chứa nhiều hàng tồn kho hơn.', '', '', '49b0b3c2-f4e6-41d4-a7eb-b8c098781ea4', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('d61a09d8-e83b-4e6e-ab25-5ed05458f678', 'toeic-test-01', 58, 3, 'listening', 'According to the men, what has changed recently?', 'Roads have become more accessible.', 'Costs have decreased.', 'Tourism has increased.', 'Weather patterns have shifted.', 'C', 'W: Chào buổi sáng! Chào mừng quý khách đến với Ngân hàng Jasper.

M1: Cảm ơn cô đã gặp chúng tôi để thảo luận về một khoản vay cho doanh nghiệp của chúng tôi.

W: Hai ông có thể cho tôi biết thêm về doanh nghiệp của mình được không? Tôi hiểu đó là một cửa hàng sửa chữa?

M2: Chà, mười năm trước, chúng tôi mở cửa như một cửa hàng sửa chữa xe trượt tuyết, nhưng sau vài năm, chúng tôi cũng bắt đầu cho thuê xe trượt tuyết và các thiết bị thể thao khác.

M1: Vâng, và vì du lịch mùa đông đã gia tăng gần đây, chúng tôi muốn mở rộng không gian của mình để có thể chứa nhiều hàng tồn kho hơn.', '', '', '49b0b3c2-f4e6-41d4-a7eb-b8c098781ea4', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('1d4ac418-a5ec-4d80-8fe9-8b570545cb6d', 'toeic-test-01', 59, 3, 'listening', 'What does the man want to do?', 'Provide training opportunities', 'Upgrade machinery', 'Hire additional employees', 'Reorganize the factory layout', 'A', 'M: Nhiều công nhân nhà máy của chúng ta đã bày tỏ mong muốn được nâng cao kỹ năng. Tôi muốn triển khai một chương trình đào tạo chéo (peer-training), nơi những người học sẽ đi theo quan sát các nhân viên giàu kinh nghiệm hơn và xem cách họ làm việc.

W: Tôi e rằng điều đó có thể trở thành gánh nặng cho những nhân viên lâu năm. Họ sẽ phải làm chậm công việc của mình để giải thích những gì họ đang làm.

M: Nếu chúng ta quay video các nhân viên giàu kinh nghiệm thực hiện các nhiệm vụ cụ thể thì sao? Video chất lượng cao có thể được ghi lại và chỉnh sửa bằng điện thoại thông minh.

W: Tôi thích ý tưởng đó. Nó cho phép chúng ta ghi lại chuyên môn của công nhân mà không làm chậm dây chuyền sản xuất.', '', '', '42d18202-fdc1-4067-a424-97e937fb1d7d', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('4b2bb555-ad35-40cd-8f5a-58c4051efd88', 'toeic-test-01', 60, 3, 'listening', 'What is the woman concerned about?', 'Increasing expenses', 'Introducing errors', 'Reducing productivity', 'Causing confusion', 'C', 'M: Nhiều công nhân nhà máy của chúng ta đã bày tỏ mong muốn được nâng cao kỹ năng. Tôi muốn triển khai một chương trình đào tạo chéo (peer-training), nơi những người học sẽ đi theo quan sát các nhân viên giàu kinh nghiệm hơn và xem cách họ làm việc.

W: Tôi e rằng điều đó có thể trở thành gánh nặng cho những nhân viên lâu năm. Họ sẽ phải làm chậm công việc của mình để giải thích những gì họ đang làm.

M: Nếu chúng ta quay video các nhân viên giàu kinh nghiệm thực hiện các nhiệm vụ cụ thể thì sao? Video chất lượng cao có thể được ghi lại và chỉnh sửa bằng điện thoại thông minh.

W: Tôi thích ý tưởng đó. Nó cho phép chúng ta ghi lại chuyên môn của công nhân mà không làm chậm dây chuyền sản xuất.', '', '', '42d18202-fdc1-4067-a424-97e937fb1d7d', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('cfc47959-1e93-43e1-8e85-077363c4e368', 'toeic-test-01', 61, 3, 'listening', 'What does the man mean when he says, “High-quality video can be recorded and edited with a smartphone”?', 'A new policy should be established.', 'An idea is easy to implement.', 'Data security is a concern.', 'Some information should be verified.', 'B', 'M: Nhiều công nhân nhà máy của chúng ta đã bày tỏ mong muốn được nâng cao kỹ năng. Tôi muốn triển khai một chương trình đào tạo chéo (peer-training), nơi những người học sẽ đi theo quan sát các nhân viên giàu kinh nghiệm hơn và xem cách họ làm việc.

W: Tôi e rằng điều đó có thể trở thành gánh nặng cho những nhân viên lâu năm. Họ sẽ phải làm chậm công việc của mình để giải thích những gì họ đang làm.

M: Nếu chúng ta quay video các nhân viên giàu kinh nghiệm thực hiện các nhiệm vụ cụ thể thì sao? Video chất lượng cao có thể được ghi lại và chỉnh sửa bằng điện thoại thông minh.

W: Tôi thích ý tưởng đó. Nó cho phép chúng ta ghi lại chuyên môn của công nhân mà không làm chậm dây chuyền sản xuất.', '', '', '42d18202-fdc1-4067-a424-97e937fb1d7d', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('28d4a09c-b014-44eb-a2a8-d714ba132556', 'toeic-test-01', 62, 3, 'listening', 'Where is the woman?', 'At a restaurant', 'At a travel agency', 'At an airport', 'At a warehouse', 'C', 'W: Chào Suresh. Tôi đang ở sân bay chờ chuyến bay của mình. Tôi muốn gặp một nhà đầu tư tiềm năng trong khi ở Chicago. Tên cô ấy là Marta Gomez. Tôi có thể gửi cho anh thông tin liên lạc của cô ấy.

M: Được rồi. Cô muốn gặp cô ấy vào ngày nào?

W: Sau khi kết thúc cuộc họp với nhân viên ở Chicago thì sao nhỉ?

M: Được thôi. Nhân tiện, cô có thấy công ty chúng ta vừa giành được giải thưởng cho những đóng góp cho cộng đồng không? Nó vừa được thông báo sáng nay đấy.', '', '', '124a5de5-eaa8-40c3-985d-50a1f8f16938', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('671ccebb-9899-48f0-a3b1-d8c743720bfb', 'toeic-test-01', 63, 3, 'listening', 'Look at the graphic. When does the woman prefer to meet with an investor?', 'On Monday', 'On Tuesday', 'On Wednesday', 'On Thursday', 'C', 'W: Chào Suresh. Tôi đang ở sân bay chờ chuyến bay của mình. Tôi muốn gặp một nhà đầu tư tiềm năng trong khi ở Chicago. Tên cô ấy là Marta Gomez. Tôi có thể gửi cho anh thông tin liên lạc của cô ấy.

M: Được rồi. Cô muốn gặp cô ấy vào ngày nào?

W: Sau khi kết thúc cuộc họp với nhân viên ở Chicago thì sao nhỉ?

M: Được thôi. Nhân tiện, cô có thấy công ty chúng ta vừa giành được giải thưởng cho những đóng góp cho cộng đồng không? Nó vừa được thông báo sáng nay đấy.', '', '', '124a5de5-eaa8-40c3-985d-50a1f8f16938', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('20e57cb7-e200-4c29-93c2-2df4c240b736', 'toeic-test-01', 64, 3, 'listening', 'What good news does the man share?', 'A colleague received a promotion.', 'A conference proposal was accepted.', 'An airline ticket has been upgraded.', 'A company won an award.', 'D', 'W: Chào Suresh. Tôi đang ở sân bay chờ chuyến bay của mình. Tôi muốn gặp một nhà đầu tư tiềm năng trong khi ở Chicago. Tên cô ấy là Marta Gomez. Tôi có thể gửi cho anh thông tin liên lạc của cô ấy.

M: Được rồi. Cô muốn gặp cô ấy vào ngày nào?

W: Sau khi kết thúc cuộc họp với nhân viên ở Chicago thì sao nhỉ?

M: Được thôi. Nhân tiện, cô có thấy công ty chúng ta vừa giành được giải thưởng cho những đóng góp cho cộng đồng không? Nó vừa được thông báo sáng nay đấy.', '', '', '124a5de5-eaa8-40c3-985d-50a1f8f16938', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('46f3d47c-2811-4fe7-92ea-db51c1408949', 'toeic-test-01', 65, 3, 'listening', 'Where do the speakers work?', 'At an amusement park', 'At an art museum', 'At a concert hall', 'At a botanical garden', 'D', 'M: Marion, chúng ta liên tục nhận được cuộc gọi từ những người muốn tham quan vườn bách thảo nhưng không tìm thấy thông tin đỗ xe. Nó không có trên trang web của chúng ta sao?

W: Có chứ, nhưng anh phải nhấp vào trang "Về chúng tôi" và cuộn xuống cuối trang đó. Có lẽ mọi người không nhìn thấy nó.

M: Ồ, tôi nghĩ chúng ta nên chuyển thông tin đó khỏi trang "Về chúng tôi" và tạo một trang riêng cho chỉ dẫn đường đi và thông tin đỗ xe. Bằng cách đó, mọi người có thể tìm thấy nó dễ dàng hơn.

W: Tôi rất sẵn lòng thực hiện thay đổi đó. Nhưng chúng ta đang trong quá trình cập nhật phần mềm, nên việc này sẽ phải đợi đến thứ Hai.', '', '', '75ff7fbb-7e60-480a-8f03-f7252c6c6b1f', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('f0466d6d-b5fc-4b5c-8356-9fdb59cc8251', 'toeic-test-01', 66, 3, 'listening', 'Look at the graphic. Which page on the Web site does the man want to change?', 'Page 1', 'Page 2', 'Page 3', 'Page 4', 'A', 'M: Marion, chúng ta liên tục nhận được cuộc gọi từ những người muốn tham quan vườn bách thảo nhưng không tìm thấy thông tin đỗ xe. Nó không có trên trang web của chúng ta sao?

W: Có chứ, nhưng anh phải nhấp vào trang "Về chúng tôi" và cuộn xuống cuối trang đó. Có lẽ mọi người không nhìn thấy nó.

M: Ồ, tôi nghĩ chúng ta nên chuyển thông tin đó khỏi trang "Về chúng tôi" và tạo một trang riêng cho chỉ dẫn đường đi và thông tin đỗ xe. Bằng cách đó, mọi người có thể tìm thấy it dễ dàng hơn.

W: Tôi rất sẵn lòng thực hiện thay đổi đó. Nhưng chúng ta đang trong quá trình cập nhật phần mềm, nên việc này sẽ phải đợi đến thứ Hai.', '', '', '75ff7fbb-7e60-480a-8f03-f7252c6c6b1f', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('00b62137-1b66-424a-b8f4-18b3e62b308e', 'toeic-test-01', 67, 3, 'listening', 'Why does the woman say she cannot complete a task until Monday?', 'She requires approval from a manager.', 'She is attending a workshop.', 'Some software is being updated.', 'Some clients will be arriving soon.', 'C', 'M: Marion, chúng ta liên tục nhận được cuộc gọi từ những người muốn tham quan vườn bách thảo nhưng không tìm thấy thông tin đỗ xe. Nó không có trên trang web của chúng ta sao?

W: Có chứ, nhưng anh phải nhấp vào trang "Về chúng tôi" và cuộn xuống cuối trang đó. Có lẽ mọi người không nhìn thấy nó.

M: Ồ, tôi nghĩ chúng ta nên chuyển thông tin đó khỏi trang "Về chúng tôi" và tạo một trang riêng cho chỉ dẫn đường đi và thông tin đỗ xe. Bằng cách đó, mọi người có thể tìm thấy it dễ dàng hơn.

W: Tôi rất sẵn lòng thực hiện thay đổi đó. Nhưng chúng ta đang trong quá trình cập nhật phần mềm, nên việc này sẽ phải đợi đến thứ Hai.', '', '', '75ff7fbb-7e60-480a-8f03-f7252c6c6b1f', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('b6998d06-1e13-4204-ac45-40955ba8f343', 'toeic-test-01', 68, 3, 'listening', 'What news does the man share?', 'A station road will be closed for repair.', 'A project has been approved.', 'A parking area has been expanded.', 'An office will relocate.', 'B', 'M: Tin tốt đây! Cuối cùng chúng ta đã nhận được sự chấp thuận cho dự án của bộ phận mình về việc lắp đặt các giá để xe đạp tại ga tàu trung tâm thành phố.

W: Cuối cùng cũng được! Vậy bây giờ chúng ta cần quyết định nơi đặt các giá để xe. Đặt ở lối vào nhà ga thì sao?

M: Hmm. Nếu chúng ta hỏi những người đi tàu, tôi cá là họ sẽ nói rằng vị trí thuận tiện nhất là càng gần sân ga càng tốt.

W: Hãy làm như vậy đi. Tôi sẽ liên hệ với một số công ty để lấy báo giá (estimates).', '', '', '8047aeab-2270-433e-b7b3-739f78d2fd68', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('b387714c-940f-475f-a71d-fd0e6a9b9c27', 'toeic-test-01', 69, 3, 'listening', 'Look at the graphic. Where do the speakers decide to install some bicycle racks?', 'Near the covered parking area', 'Near the long-term parking area', 'Near the short-term parking area', 'Near the overflow parking area', 'A', 'M: Tin tốt đây! Cuối cùng chúng ta đã nhận được sự chấp thuận cho dự án của bộ phận mình về việc lắp đặt các giá để xe đạp tại ga tàu trung tâm thành phố.

W: Cuối cùng cũng được! Vậy bây giờ chúng ta cần quyết định nơi đặt các giá để xe. Đặt ở lối vào nhà ga thì sao?

M: Hmm. Nếu chúng ta hỏi những người đi tàu, tôi cá là họ sẽ nói rằng vị trí thuận tiện nhất là càng gần sân ga càng tốt.

W: Hãy làm như vậy đi. Tôi sẽ liên hệ với một số công ty để lấy báo giá (estimates).', '', '', '8047aeab-2270-433e-b7b3-739f78d2fd68', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('6715eb8a-205a-41a0-90d7-f155334dd457', 'toeic-test-01', 70, 3, 'listening', 'Why does the woman say she will contact some companies?', 'To arrange a loan', 'To apply for a permit', 'To ask for estimates', 'To create a proposal', 'C', 'M: Tin tốt đây! Cuối cùng chúng ta đã nhận được sự chấp thuận cho dự án của bộ phận mình về việc lắp đặt các giá để xe đạp tại ga tàu trung tâm thành phố.

W: Cuối cùng cũng được! Vậy bây giờ chúng ta cần quyết định nơi đặt các giá để xe. Đặt ở lối vào nhà ga thì sao?

M: Hmm. Nếu chúng ta hỏi những người đi tàu, tôi cá là họ sẽ nói rằng vị trí thuận tiện nhất là càng gần sân ga càng tốt.

W: Hãy làm như vậy đi. Tôi sẽ liên hệ với một số công ty để lấy báo giá (estimates).', '', '', '8047aeab-2270-433e-b7b3-739f78d2fd68', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('40f8e6f8-a34c-4996-acdc-86c4d9348df8', 'toeic-test-01', 71, 4, 'listening', 'What type of products does the business repair?', 'Computers', 'Vehicles', 'Light fixtures', 'Kitchen appliances', 'B', 'Bạn đã gọi đến Dịch vụ Sửa chữa Select. Chúng tôi chuyên về tất cả các dòng xe và mẫu mã ô tô. Các chuyên gia được đào tạo chính quy của chúng tôi sẽ giữ cho phương tiện của bạn hoạt động trong tình trạng tốt nhất. Như một lợi ích bổ sung, chúng tôi cung cấp gói bảo hành mở rộng cho tất cả các phương tiện mà chúng tôi bảo trì. Bạn có thể tận hưởng thêm ba năm lái xe mà không cần lo lắng. Xin lưu ý rằng Dịch vụ Sửa chữa Select sẽ đóng cửa vào thứ Sáu, ngày 30 tháng 6, để chúng tôi có thể hoàn thành việc kiểm kê vật tư hàng quý. Cảm ơn sự kiên nhẫn của bạn. Đại diện của chúng tôi sẽ hỗ trợ bạn trong giây lát.', '', '', '1c59a560-b3db-4c08-8a19-31c23aac8f84', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('98a54fba-82d4-47b4-8f3c-fe9d2b1dc1ff', 'toeic-test-01', 72, 4, 'listening', 'What special benefit does the speaker mention?', 'Free pickup', 'Online scheduling', 'Extended warranties', 'A membership loyalty program', 'C', 'Bạn đã gọi đến Dịch vụ Sửa chữa Select. Chúng tôi chuyên về tất cả các dòng xe và mẫu mã ô tô. Các chuyên gia được đào tạo chính quy của chúng tôi sẽ giữ cho phương tiện của bạn hoạt động trong tình trạng tốt nhất. Như một lợi ích bổ sung, chúng tôi cung cấp gói bảo hành mở rộng cho tất cả các phương tiện mà chúng tôi bảo trì. Bạn có thể tận hưởng thêm ba năm lái xe mà không cần lo lắng. Xin lưu ý rằng Dịch vụ Sửa chữa Select sẽ đóng cửa vào thứ Sáu, ngày 30 tháng 6, để chúng tôi có thể hoàn thành việc kiểm kê vật tư hàng quý. Cảm ơn sự kiên nhẫn của bạn. Đại diện của chúng tôi sẽ hỗ trợ bạn trong giây lát.', '', '', '1c59a560-b3db-4c08-8a19-31c23aac8f84', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('5cd10ab8-bdf8-4751-b5cb-c59568f0f9b0', 'toeic-test-01', 73, 4, 'listening', 'Why will a business close on Friday?', 'For an inventory count', 'For employee training', 'For a company celebration', 'For equipment installation', 'A', 'Bạn đã gọi đến Dịch vụ Sửa chữa Select. Chúng tôi chuyên về tất cả các dòng xe và mẫu mã ô tô. Các chuyên gia được đào tạo chính quy của chúng tôi sẽ giữ cho phương tiện của bạn hoạt động trong tình trạng tốt nhất. Như một lợi ích bổ sung, chúng tôi cung cấp gói bảo hành mở rộng cho tất cả các phương tiện mà chúng tôi bảo trì. Bạn có thể tận hưởng thêm ba năm lái xe mà không cần lo lắng. Xin lưu ý rằng Dịch vụ Sửa chữa Select sẽ đóng cửa vào thứ Sáu, ngày 30 tháng 6, để chúng tôi có thể hoàn thành việc kiểm kê vật tư hàng quý. Cảm ơn sự kiên nhẫn của bạn. Đại diện của chúng tôi sẽ hỗ trợ bạn trong giây lát.', '', '', '1c59a560-b3db-4c08-8a19-31c23aac8f84', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('1fbf407e-2cd4-4aa8-8dd2-911db4da0e3b', 'toeic-test-01', 74, 4, 'listening', 'Who most likely is the speaker?', 'A facilities manager', 'A human resources representative', 'A security officer', 'A corporate executive', 'B', 'Chào mừng các nhân viên mới! Tôi tên là Diego, và tôi điều phối tất cả các buổi định hướng. Trước khi chúng ta bắt đầu hôm nay, các bạn sẽ cần thiết lập tài khoản nhân viên của mình. Nếu bạn nhìn vào trang đầu tiên của bìa hồ sơ đào tạo, bạn sẽ thấy tên người dùng và mật khẩu tạm thời. Vui lòng mở máy tính xách tay mà bạn được giao sáng nay và đăng nhập bằng các thông tin đó. Sau đó, bạn sẽ được yêu cầu tạo mật khẩu của riêng mình. Sau khi hoàn tất, bạn sẽ có quyền truy cập vào tất cả các tệp tin của bộ phận mình. Xin lưu ý rằng bạn chỉ có thể truy cập chúng từ máy tính của công ty.', '', '', '53e4a234-2c31-428c-993b-7edf5cf36d7b', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('1408bd39-3e69-4f6c-8ef9-4f19a1f900a6', 'toeic-test-01', 75, 4, 'listening', 'According to the speaker, what will the listeners find in a binder?', 'A map of the building', 'An employment contract', 'An identification badge', 'Log-in credentials', 'D', 'Chào mừng các nhân viên mới! Tôi tên là Diego, và tôi điều phối tất cả các buổi định hướng. Trước khi chúng ta bắt đầu hôm nay, các bạn sẽ cần thiết lập tài khoản nhân viên của mình. Nếu bạn nhìn vào trang đầu tiên của bìa hồ sơ đào tạo, bạn sẽ thấy tên người dùng và mật khẩu tạm thời. Vui lòng mở máy tính xách tay mà bạn được giao sáng nay và đăng nhập bằng các thông tin đó. Sau đó, bạn sẽ được yêu cầu tạo mật khẩu của riêng mình. Sau khi hoàn tất, bạn sẽ có quyền truy cập vào tất cả các tệp tin của bộ phận mình. Xin lưu ý rằng bạn chỉ có thể truy cập chúng từ máy tính của công ty.', '', '', '53e4a234-2c31-428c-993b-7edf5cf36d7b', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('7b8f49a8-5625-4289-aa25-f0b3741ed06d', 'toeic-test-01', 76, 4, 'listening', 'What does the speaker say about department files?', 'They are only accessible from company computers.', 'They must be password protected.', 'They must follow a specific naming convention.', 'They must be archived annually.', 'A', 'Chào mừng các nhân viên mới! Tôi tên là Diego, và tôi điều phối tất cả các buổi định hướng. Trước khi chúng ta bắt đầu hôm nay, các bạn sẽ cần thiết lập tài khoản nhân viên của mình. Nếu bạn nhìn vào trang đầu tiên của bìa hồ sơ đào tạo, bạn sẽ thấy tên người dùng và mật khẩu tạm thời. Vui lòng mở máy tính xách tay mà bạn được giao sáng nay và đăng nhập bằng các thông tin đó. Sau đó, bạn sẽ được yêu cầu tạo mật khẩu của riêng mình. Sau khi hoàn tất, bạn sẽ có quyền truy cập vào tất cả các tệp tin của bộ phận mình. Xin lưu ý rằng bạn chỉ có thể truy cập chúng từ máy tính của công ty.', '', '', '53e4a234-2c31-428c-993b-7edf5cf36d7b', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('2e072e80-41ba-47eb-a6cd-e5c1e126143a', 'toeic-test-01', 77, 4, 'listening', 'Where does the speaker work?', 'At a laundry facility', 'At an amusement park', 'At a sports stadium', 'At a fitness center', 'B', 'Xin chào. Đây là Heather Ross gọi từ Công viên Giải trí Denville. Khoảng một tháng trước, tôi đã đặt mua một trong những máy chơi trò chơi điện tử mới của các bạn, Space Defenders. Tôi thực sự hài lòng với giao dịch mua này, vì trò chơi này cực kỳ phổ biến với khách tham quan công viên của chúng tôi! Tôi đang cân nhắc mua thêm một số máy nữa trong tương lai gần. Tôi nghe nói các bạn có thể sẽ phát hành một trò chơi mới sớm. Bạn có thể gọi lại cho tôi và cho biết điều đó có đúng không? Cảm ơn!', '', '', 'c075c848-c127-4110-940c-a535e186bcd7', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('80cb5749-989a-43ca-b1c2-ce023cb2b1e8', 'toeic-test-01', 78, 4, 'listening', 'What does the speaker say about an item she ordered a month ago?', 'It arrived later than expected.', 'It was damaged during delivery.', 'She needs help assembling it.', 'She is pleased with it.', 'D', 'Xin chào. Đây là Heather Ross gọi từ Công viên Giải trí Denville. Khoảng một tháng trước, tôi đã đặt mua một trong những máy chơi trò chơi điện tử mới của các bạn, Space Defenders. Tôi thực sự hài lòng với giao dịch mua này, vì trò chơi này cực kỳ phổ biến với khách tham quan công viên của chúng tôi! Tôi đang cân nhắc mua thêm một số máy nữa trong tương lai gần. Tôi nghe nói các bạn có thể sẽ phát hành một trò chơi mới sớm. Bạn có thể gọi lại cho tôi và cho biết điều đó có đúng không? Cảm ơn!', '', '', 'c075c848-c127-4110-940c-a535e186bcd7', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('a13d6fdb-27cb-4265-a1a8-a81eb47d2349', 'toeic-test-01', 79, 4, 'listening', 'What does the speaker ask the listener to confirm?', 'Whether a new product will be available soon', 'When a replacement part will be shipped', 'How long a warranty lasts', 'Who to contact about future orders', 'A', 'Xin chào. Đây là Heather Ross gọi từ Công viên Giải trí Denville. Khoảng một tháng trước, tôi đã đặt mua một trong những máy chơi trò chơi điện tử mới của các bạn, Space Defenders. Tôi thực sự hài lòng với giao dịch mua này, vì trò chơi này cực kỳ phổ biến với khách tham quan công viên của chúng tôi! Tôi đang cân nhắc mua thêm một số máy nữa trong tương lai gần. Tôi nghe nói các bạn có thể sẽ phát hành một trò chơi mới sớm. Bạn có thể gọi lại cho tôi và cho biết điều đó có đúng không? Cảm ơn!', '', '', 'c075c848-c127-4110-940c-a535e186bcd7', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('026ee4a0-88cb-40fb-bb04-5d49319f7072', 'toeic-test-01', 80, 4, 'listening', 'What type of product does the speaker''s company make?', 'Furniture', 'Luggage', 'Bedding', 'Clothing', 'D', 'Nội dung đầu tiên trong chương trình nghị sự cho cuộc họp hội đồng quản trị của chúng ta là báo cáo doanh số hàng năm. Tất cả chúng ta đều thất vọng trước sự sụt giảm doanh số bán quần áo. Sự sụt giảm này chủ yếu là do các vấn đề về phân phối. Vì các nhà máy của chúng ta đều ở nước ngoài nên mất quá nhiều thời gian để đơn hàng đến tay khách hàng. Vì vậy, tôi đề nghị chúng ta bắt đầu sản xuất một số mặt hàng may mặc tại địa phương. Chúng ta sẽ tìm kiếm một địa điểm để xây dựng cơ sở sản xuất. Tôi đã thuê một cố vấn để lập danh sách các địa điểm chúng ta có thể sử dụng. Anh ấy sẽ có mặt tại cuộc họp hội đồng quản trị tiếp theo để giải thích các ưu và nhược điểm của từng nơi.', '', '', '13e358ce-17ab-482e-8c89-8e7000517012', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('4a800f8b-e198-49d1-9c07-3e8d3f0f56a7', 'toeic-test-01', 81, 4, 'listening', 'What does the speaker recommend doing?', 'Manufacturing some products locally', 'Offering free shipping', 'Participating in a trade show', 'Developing a new product line', 'A', 'Nội dung đầu tiên trong chương trình nghị sự cho cuộc họp hội đồng quản trị của chúng ta là báo cáo doanh số hàng năm. Tất cả chúng ta đều thất vọng trước sự sụt giảm doanh số bán quần áo. Sự sụt giảm này chủ yếu là do các vấn đề về phân phối. Vì các nhà máy của chúng ta đều ở nước ngoài nên mất quá nhiều thời gian để đơn hàng đến tay khách hàng. Vì vậy, tôi đề nghị chúng ta bắt đầu sản xuất một số mặt hàng may mặc tại địa phương. Chúng ta sẽ tìm kiếm một địa điểm để xây dựng cơ sở sản xuất. Tôi đã thuê một cố vấn để lập danh sách các địa điểm chúng ta có thể sử dụng. Anh ấy sẽ có mặt tại cuộc họp hội đồng quản trị tiếp theo để giải thích các ưu và nhược điểm của từng nơi.', '', '', '13e358ce-17ab-482e-8c89-8e7000517012', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('cbfbcef7-87af-433e-a12b-c7e71aa5eceb', 'toeic-test-01', 82, 4, 'listening', 'What will happen at the next meeting?', 'A vote will take place.', 'A consultant will give a presentation.', 'Some contracts will be updated.', 'Safety procedures will be reviewed.', 'B', 'Nội dung đầu tiên trong chương trình nghị sự cho cuộc họp hội đồng quản trị của chúng ta là báo cáo doanh số hàng năm. Tất cả chúng ta đều thất vọng trước sự sụt giảm doanh số bán quần áo. Sự sụt giảm này chủ yếu là do các vấn đề về phân phối. Vì các nhà máy của chúng ta đều ở nước ngoài nên mất quá nhiều thời gian để đơn hàng đến tay khách hàng. Vì vậy, tôi đề nghị chúng ta bắt đầu sản xuất một số mặt hàng may mặc tại địa phương. Chúng ta sẽ tìm kiếm một địa điểm để xây dựng cơ sở sản xuất. Tôi đã thuê một cố vấn để lập danh sách các địa điểm chúng ta có thể sử dụng. Anh ấy sẽ có mặt tại cuộc họp hội đồng quản trị tiếp theo để giải thích các ưu và nhược điểm của từng nơi.', '', '', '13e358ce-17ab-482e-8c89-8e7000517012', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('e4d63ebd-39af-40a3-bee7-841ccee8c407', 'toeic-test-01', 83, 4, 'listening', 'What is the announcement mainly about?', 'A promotional event', 'A vacation package', 'A building renovation', 'A travel delay', 'D', 'Xin hành khách chú ý. Tất cả các chuyến tàu đến Ga Midway đều bị trễ do sửa chữa đường ray. Các đội sửa chữa đang làm việc trên một đoạn đường ray ngay phía nam thị trấn Wheedon. Họ dự kiến sẽ hoàn thành việc sửa chữa trong vòng một giờ tới. Chúng tôi xin lỗi vì sự chậm trễ này. Chúng tôi hiểu rằng nhiều người đi làm cần phải đến Midway càng sớm càng tốt. Một chiếc xe buýt sẽ khởi hành đến điểm đến đó trong mười lăm phút nữa. Ngoài ra, xin nhắc nhở rằng quán cà phê của nhà ga mở cửa lúc 8 giờ sáng và có các quầy thực phẩm ở sân ga số một.', '', '', '9132025a-6db0-4cc2-b423-893d4386401a', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('0e11495f-fd49-4b9a-ab0b-3cd4ec6d6056', 'toeic-test-01', 84, 4, 'listening', 'Why does the speaker say, “A bus will be departing for that destination in fifteen minutes”?', 'To suggest an alternative arrangement', 'To explain an extended wait time', 'To recommend changing the travel date', 'To inform customers about a new destination', 'A', 'Xin hành khách chú ý. Tất cả các chuyến tàu đến Ga Midway đều bị trễ do sửa chữa đường ray. Các đội sửa chữa đang làm việc trên một đoạn đường ray ngay phía nam thị trấn Wheedon. Họ dự kiến sẽ hoàn thành việc sửa chữa trong vòng một giờ tới. Chúng tôi xin lỗi vì sự chậm trễ này. Chúng tôi hiểu rằng nhiều người đi làm cần phải đến Midway càng sớm càng tốt. Một chiếc xe buýt sẽ khởi hành đến điểm đến đó trong mười lăm phút nữa. Ngoài ra, xin nhắc nhở rằng quán cà phê của nhà ga mở cửa lúc 8 giờ sáng và có các quầy thực phẩm ở sân ga số một.', '', '', '9132025a-6db0-4cc2-b423-893d4386401a', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('0e67e46b-7d37-4a55-9ff6-2bcab8d33014', 'toeic-test-01', 85, 4, 'listening', 'What does the speaker remind the listeners about?', 'How to download a mobile application', 'Where a waiting area is located', 'How to reserve tickets', 'Where to buy food', 'D', 'Xin hành khách chú ý. Tất cả các chuyến tàu đến Ga Midway đều bị trễ do sửa chữa đường ray. Các đội sửa chữa đang làm việc trên một đoạn đường ray ngay phía nam thị trấn Wheedon. Họ dự kiến sẽ hoàn thành việc sửa chữa trong vòng một giờ tới. Chúng tôi xin lỗi vì sự chậm trễ này. Chúng tôi hiểu rằng nhiều người đi làm cần phải đến Midway càng sớm càng tốt. Một chiếc xe buýt sẽ khởi hành đến điểm đến đó trong mười lăm phút nữa. Ngoài ra, xin nhắc nhở rằng quán cà phê của nhà ga mở cửa lúc 8 giờ sáng và có các quầy thực phẩm ở sân ga số một.', '', '', '9132025a-6db0-4cc2-b423-893d4386401a', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('7913243a-0d14-4b42-8623-0b78a8881beb', 'toeic-test-01', 86, 4, 'listening', 'Where does the speaker most likely work?', 'At a graphic design company', 'At a law firm', 'At a photography studio', 'At a museum', 'A', 'Tôi gọi điện về công việc mà đội thiết kế của tôi đang thực hiện để cập nhật logo công ty của bạn. Tôi vừa gửi email hai phiên bản để bạn xem xét. Phiên bản đầu tiên là một thiết kế hiện đại với màu sắc đậm và kiểu chữ đơn giản. Hình ảnh thứ hai phản ánh lịch sử của thương hiệu và logo của nó. Nó ít hợp thời trang hơn, nhưng nó không khác biệt nhiều so với bản gốc, điều mà bạn có thể sẽ thích hơn. Hãy dành thời gian suy nghĩ về phiên bản nào bạn muốn chọn. Tôi sẽ đi nghỉ mát suốt tuần tới, nhưng nếu bạn gọi cho văn phòng, trợ lý của tôi sẽ sắp xếp một cuộc họp khi tôi quay lại.', '', '', '698c74fc-6a81-4297-a773-92c1c9dd63e6', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('6e6c36ac-2bb0-4f51-aa03-c7b2a41aa665', 'toeic-test-01', 87, 4, 'listening', 'What did the listener receive by e-mail?', 'A newsletter', 'Some images', 'An invoice', 'Some contracts', 'B', 'Tôi gọi điện về công việc mà đội thiết kế của tôi đang thực hiện để cập nhật logo công ty của bạn. Tôi vừa gửi email hai phiên bản để bạn xem xét. Phiên bản đầu tiên là một thiết kế hiện đại với màu sắc đậm và kiểu chữ đơn giản. Hình ảnh thứ hai phản ánh lịch sử của thương hiệu và logo của nó. Nó ít hợp thời trang hơn, nhưng nó không khác biệt nhiều so với bản gốc, điều mà bạn có thể sẽ thích hơn. Hãy dành thời gian suy nghĩ về phiên bản nào bạn muốn chọn. Tôi sẽ đi nghỉ mát suốt tuần tới, nhưng nếu bạn gọi cho văn phòng, trợ lý của tôi sẽ sắp xếp một cuộc họp khi tôi quay lại.', '', '', '698c74fc-6a81-4297-a773-92c1c9dd63e6', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('8f905c6c-f2d4-443d-b6bc-7b9dc6c59c23', 'toeic-test-01', 88, 4, 'listening', 'Why is the speaker unavailable next week?', 'She will be working at another branch.', 'She will be with other clients.', 'She will be on vacation.', 'She will be at an industry conference.', 'C', 'Tôi gọi điện về công việc mà đội thiết kế của tôi đang thực hiện để cập nhật logo công ty của bạn. Tôi vừa gửi email hai phiên bản để bạn xem xét. Phiên bản đầu tiên là một thiết kế hiện đại với màu sắc đậm và kiểu chữ đơn giản. Hình ảnh thứ hai phản ánh lịch sử của thương hiệu và logo của nó. Nó ít hợp thời trang hơn, nhưng nó không khác biệt nhiều so với bản gốc, điều mà bạn có thể sẽ thích hơn. Hãy dành thời gian suy nghĩ về phiên bản nào bạn muốn chọn. Tôi sẽ đi nghỉ mát suốt tuần tới, nhưng nếu bạn gọi cho văn phòng, trợ lý của tôi sẽ sắp xếp một cuộc họp khi tôi quay lại.', '', '', '698c74fc-6a81-4297-a773-92c1c9dd63e6', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('7e43213a-4ae3-40a8-8ae8-94d948be2527', 'toeic-test-01', 89, 4, 'listening', 'Who most likely are the listeners?', 'Investors', 'Government officials', 'Engineers', 'Journalists', 'D', 'Sau khi cơ quan vận tải công bố bản dự thảo kế hoạch cải tiến vào tuần trước, các thành viên báo chí đã hỏi liệu chúng tôi có đang cân nhắc việc lắp đặt các động cơ tiết kiệm nhiên liệu hơn cho tàu hỏa của mình hay không. Tôi đã sắp xếp buổi họp báo này để trả lời chính thức các thắc mắc của quý vị. Mười tám tháng trước, chúng tôi đã thuê một công ty để xác định xem việc nâng cấp này có khả thi đối với các đoàn tàu của chúng tôi hay không. Họ báo cáo rằng việc nâng cấp sẽ chỉ mang lại hiệu quả kinh tế đối với các đoàn tàu tương đối mới—nghĩa là những đoàn tàu dưới năm năm tuổi. Tất cả các tàu của chúng tôi đều đã ít nhất mười năm tuổi. Tôi hy vọng điều này giải đáp được các câu hỏi của quý vị. Nếu quý vị quan tâm đến thêm chi tiết, hãy gửi email cho bộ phận quan hệ truyền thông của chúng tôi để nhận bản tóm tắt các kết quả tìm được.', '', '', 'ce2e28d3-c199-4e8f-850d-06aa866cdd92', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('1edb4592-5426-44cb-a763-95b3318f2758', 'toeic-test-01', 90, 4, 'listening', 'What does the speaker mean when she says, “All of ours are at least ten years old”?', 'An event needs to be relocated.', 'An upgrade is not feasible.', 'A project team has a lot of experience.', 'Some company policies are outdated.', 'B', 'Sau khi cơ quan vận tải công bố bản dự thảo kế hoạch cải tiến vào tuần trước, các thành viên báo chí đã hỏi liệu chúng tôi có đang cân nhắc việc lắp đặt các động cơ tiết kiệm nhiên liệu hơn cho tàu hỏa của mình hay không. Tôi đã sắp xếp buổi họp báo này để trả lời chính thức các thắc mắc của quý vị. Mười tám tháng trước, chúng tôi đã thuê một công ty để xác định xem việc nâng cấp này có khả thi đối với các đoàn tàu của chúng tôi hay không. Họ báo cáo rằng việc nâng cấp sẽ chỉ mang lại hiệu quả kinh tế đối với các đoàn tàu tương đối mới—nghĩa là những đoàn tàu dưới năm năm tuổi. Tất cả các tàu của chúng tôi đều đã ít nhất mười năm tuổi. Tôi hy vọng điều này giải đáp được các câu hỏi của quý vị. Nếu quý vị quan tâm đến thêm chi tiết, hãy gửi email cho bộ phận quan hệ truyền thông của chúng tôi để nhận bản tóm tắt các kết quả tìm được.', '', '', 'ce2e28d3-c199-4e8f-850d-06aa866cdd92', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('43a08fe4-50bd-413d-926c-1a31ee56dafe', 'toeic-test-01', 91, 4, 'listening', 'According to the speaker, what can be requested by e-mail?', 'Some presentation slides', 'Some product samples', 'A report summary', 'A discounted ticket', 'C', 'Sau khi cơ quan vận tải công bố bản dự thảo kế hoạch cải tiến vào tuần trước, các thành viên báo chí đã hỏi liệu chúng tôi có đang cân nhắc việc lắp đặt các động cơ tiết kiệm nhiên liệu hơn cho tàu hỏa của mình hay không. Tôi đã sắp xếp buổi họp báo này để trả lời chính thức các thắc mắc của quý vị. Mười tám tháng trước, chúng tôi đã thuê một công ty để xác định xem việc nâng cấp này có khả thi đối với các đoàn tàu của chúng tôi hay không. Họ báo cáo rằng việc nâng cấp sẽ chỉ mang lại hiệu quả kinh tế đối với các đoàn tàu tương đối mới—nghĩa là những đoàn tàu dưới năm năm tuổi. Tất cả các tàu của chúng tôi đều đã ít nhất mười năm tuổi. Tôi hy vọng điều này giải đáp được các câu hỏi của quý vị. Nếu quý vị quan tâm đến thêm chi tiết, hãy gửi email cho bộ phận quan hệ truyền thông của chúng tôi để nhận bản tóm tắt các kết quả tìm được.', '', '', 'ce2e28d3-c199-4e8f-850d-06aa866cdd92', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('35c3fa6b-1aab-4e77-aa70-3191b6c83c11', 'toeic-test-01', 92, 4, 'listening', 'What does the speaker want to do?', 'Increase online sales', 'Upgrade a payment system', 'Create a new product line', 'Add store locations', 'B', 'Với tư cách là giám đốc bán hàng khu vực, tôi muốn tìm hiểu việc sử dụng hệ thống thanh toán hiện đại hơn trong các cửa hàng mỹ phẩm của chúng ta. Hệ thống này sẽ cho phép bất kỳ cộng tác viên bán hàng nào cũng có thể nhận thanh toán của khách hàng từ máy tính bảng ở bất kỳ đâu trong cửa hàng. Tại sao chúng ta nên làm điều này? Khiếu nại chính về việc mua sắm tại các cửa hàng của chúng ta là phải chờ đợi trong những hàng dài để thanh toán. Rất nhiều cửa hàng của chúng ta có thể hưởng lợi từ việc này, nhưng tôi đã quyết định tiến hành chạy thử tại cửa hàng ở Center City Mall. Cho đến nay, đó là địa điểm bận rộn nhất của chúng ta.', '', '', 'e899fe92-b16e-4106-b3e8-64d79504148e', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('e696b076-ef6d-4abe-ae95-c7d374401aa2', 'toeic-test-01', 93, 4, 'listening', 'According to the speaker, what is the customers’ main complaint?', 'Long lines', 'High prices', 'Unavailable items', 'Unfriendly staff', 'A', 'Với tư cách là giám đốc bán hàng khu vực, tôi muốn tìm hiểu việc sử dụng hệ thống thanh toán hiện đại hơn trong các cửa hàng mỹ phẩm của chúng ta. Hệ thống này sẽ cho phép bất kỳ cộng tác viên bán hàng nào cũng có thể nhận thanh toán của khách hàng từ máy tính bảng ở bất kỳ đâu trong cửa hàng. Tại sao chúng ta nên làm điều này? Khiếu nại chính về việc mua sắm tại các cửa hàng của chúng ta là phải chờ đợi trong những hàng dài để thanh toán. Rất nhiều cửa hàng của chúng ta có thể hưởng lợi từ việc này, nhưng tôi đã quyết định tiến hành chạy thử tại cửa hàng ở Center City Mall. Cho đến nay, đó là địa điểm bận rộn nhất của chúng ta.', '', '', 'e899fe92-b16e-4106-b3e8-64d79504148e', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('fa774137-7e50-4c7c-8096-305c775f8711', 'toeic-test-01', 94, 4, 'listening', 'Why does the speaker say, “that’s our busiest location”?', 'To request some feedback', 'To compliment some staff', 'To express frustration', 'To justify a choice', 'D', 'Với tư cách là giám đốc bán hàng khu vực, tôi muốn tìm hiểu việc sử dụng hệ thống thanh toán hiện đại hơn trong các cửa hàng mỹ phẩm của chúng ta. Hệ thống này sẽ cho phép bất kỳ cộng tác viên bán hàng nào cũng có thể nhận thanh toán của khách hàng từ máy tính bảng ở bất kỳ đâu trong cửa hàng. Tại sao chúng ta nên làm điều này? Khiếu nại chính về việc mua sắm tại các cửa hàng của chúng ta là phải chờ đợi trong những hàng dài để thanh toán. Rất nhiều cửa hàng của chúng ta có thể hưởng lợi từ việc này, nhưng tôi đã quyết định tiến hành chạy thử tại cửa hàng ở Center City Mall. Cho đến nay, đó là địa điểm bận rộn nhất của chúng ta.', '', '', 'e899fe92-b16e-4106-b3e8-64d79504148e', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('a23805ac-c3c2-454a-9050-979ce3113104', 'toeic-test-01', 95, 4, 'listening', 'According to the speaker, what is special about the Reston Office Tower?', 'It features an indoor garden.', 'It exhibits work from local artists.', 'It runs on solar power.', 'It has won many awards.', 'A', 'Trong tin tức địa phương, Tòa tháp văn phòng Reston ở trung tâm thành phố đã được hoàn thành. Đặc điểm phi thường nhất của tòa nhà là khu vườn xinh đẹp nằm trong sảnh đợi. Văn phòng quản lý của Reston đã xác nhận danh sách người thuê cho tòa nhà. Và chúng tôi đã phỏng vấn Giám đốc điều hành của Barnum Financial Services về văn phòng mới của họ. Ông cho biết ông và đội ngũ của mình rất hào hứng khi được chuyển đến vào tháng Giêng. Bản ghi âm toàn bộ cuộc phỏng vấn với CEO đã có trên trang web của chúng tôi.', '', '', '79d23969-8969-42f6-8fc8-b98afaad46c8', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('75285100-c822-4ff7-ba8a-59587bd65fec', 'toeic-test-01', 96, 4, 'listening', 'Look at the graphic. Which floors will be occupied in January?', 'Floors 1–5', 'Floors 6–10', 'Floors 11–14', 'Floors 15–17', 'C', 'Trong tin tức địa phương, Tòa tháp văn phòng Reston ở trung tâm thành phố đã được hoàn thành. Đặc điểm phi thường nhất của tòa nhà là khu vườn xinh đẹp nằm trong sảnh đợi. Văn phòng quản lý của Reston đã xác nhận danh sách người thuê cho tòa nhà. Và chúng tôi đã phỏng vấn Giám đốc điều hành của Barnum Financial Services về văn phòng mới của họ. Ông cho biết ông và đội ngũ của mình rất hào hứng khi được chuyển đến vào tháng Giêng. Bản ghi âm toàn bộ cuộc phỏng vấn với CEO đã có trên trang web của chúng tôi.', '', '', '79d23969-8969-42f6-8fc8-b98afaad46c8', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('91d764ed-6781-40a8-9f06-9a8218c30bc3', 'toeic-test-01', 97, 4, 'listening', 'What does the speaker say is available on a Web site?', 'Some photographs', 'An event schedule', 'A floor layout', 'A recorded interview', 'D', 'Trong tin tức địa phương, Tòa tháp văn phòng Reston ở trung tâm thành phố đã được hoàn thành. Đặc điểm phi thường nhất của tòa nhà là khu vườn xinh đẹp nằm trong sảnh đợi. Văn phòng quản lý của Reston đã xác nhận danh sách người thuê cho tòa nhà. Và chúng tôi đã phỏng vấn Giám đốc điều hành của Barnum Financial Services về văn phòng mới của họ. Ông cho biết ông và đội ngũ của mình rất hào hứng khi được chuyển đến vào tháng Giêng. Bản ghi âm toàn bộ cuộc phỏng vấn với CEO đã có trên trang web của chúng tôi.', '', '', '79d23969-8969-42f6-8fc8-b98afaad46c8', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('21659f70-f9cc-421c-9dbb-4aef26a7cb14', 'toeic-test-01', 98, 4, 'listening', 'Who most likely are the listeners?', 'Safety engineers', 'Laboratory technicians', 'Legal consultants', 'Business investors', 'D', 'Chào buổi sáng và cảm ơn quý vị đã tham dự buổi họp dành cho các nhà đầu tư tiềm năng này. ZZ Mining đã lên kế hoạch mở rộng hoạt động của chúng tôi bằng cách mở thêm một mỏ bạc. Để tôi cho quý vị xem kết quả phân tích trong phòng thí nghiệm về hoạt động khoan thăm dò của chúng tôi. Trên màn hình, quý vị có thể thấy thông tin về quặng được chiết xuất từ các địa điểm khác nhau. Địa điểm có hàm lượng cao nhất có 410 gram bạc trên mỗi tấn quặng. Tuy nhiên, địa điểm có 390 gram mỗi tấn có trữ lượng lớn hơn, vì vậy đó là nơi chúng tôi sẽ xây dựng mỏ mới. Bước tiếp theo của chúng tôi là xin các giấy phép cần thiết. Chúng tôi sẽ thực hiện việc đó vào tuần tới.', '', '', 'e1620efc-b706-4c93-a665-32eaaf629638', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('a3b7d782-d1c8-4db7-bfab-fba4c8bc1035', 'toeic-test-01', 99, 4, 'listening', 'Look at the graphic. Where will a new mine be built?', 'At site 1', 'At site 2', 'At site 3', 'At site 4', 'C', 'Chào buổi sáng và cảm ơn quý vị đã tham dự buổi họp dành cho các nhà đầu tư tiềm năng này. ZZ Mining đã lên kế hoạch mở rộng hoạt động của chúng tôi bằng cách mở thêm một mỏ bạc. Để tôi cho quý vị xem kết quả phân tích trong phòng thí nghiệm về hoạt động khoan thăm dò của chúng tôi. Trên màn hình, quý vị có thể thấy thông tin về quặng được chiết xuất từ các địa điểm khác nhau. Địa điểm có hàm lượng cao nhất có 410 gram bạc trên mỗi tấn quặng. Tuy nhiên, địa điểm có 390 gram mỗi tấn có trữ lượng lớn hơn, vì vậy đó là nơi chúng tôi sẽ xây dựng mỏ mới. Bước tiếp theo của chúng tôi là xin các giấy phép cần thiết. Chúng tôi sẽ thực hiện việc đó vào tuần tới.', '', '', 'e1620efc-b706-4c93-a665-32eaaf629638', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('1171de95-ade3-4cac-ab7a-faf51f4c116e', 'toeic-test-01', 100, 4, 'listening', 'What does the speaker say is the next step?', 'Applying for permits', 'Installing equipment', 'Hiring additional staff', 'Updating a manual', 'A', 'Chào buổi sáng và cảm ơn quý vị đã tham dự buổi họp dành cho các nhà đầu tư tiềm năng này. ZZ Mining đã lên kế hoạch mở rộng hoạt động của chúng tôi bằng cách mở thêm một mỏ bạc. Để tôi cho quý vị xem kết quả phân tích trong phòng thí nghiệm về hoạt động khoan thăm dò của chúng tôi. Trên màn hình, quý vị có thể thấy thông tin về quặng được chiết xuất từ các địa điểm khác nhau. Địa điểm có hàm lượng cao nhất có 410 gram bạc trên mỗi tấn quặng. Tuy nhiên, địa điểm có 390 gram mỗi tấn có trữ lượng lớn hơn, vì vậy đó là nơi chúng tôi sẽ xây dựng mỏ mới. Bước tiếp theo của chúng tôi là xin các giấy phép cần thiết. Chúng tôi sẽ thực hiện việc đó vào tuần tới.', '', '', 'e1620efc-b706-4c93-a665-32eaaf629638', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('cce90394-eb84-4d08-aab0-8bd0b37f5ab9', 'toeic-test-01', 101, 5, 'reading', 'The lecture will take place at 6:00 P.M, ------- which attendees may ask questions.', 'across', 'after', 'inside', 'among', 'B', 'Bài giảng sẽ diễn ra vào lúc 6:00 chiều, sau đó những người tham dự có thể đặt câu hỏi.', '', '', '', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('8cd9546c-7ebc-4bed-b6e4-fffbdcb30a47', 'toeic-test-01', 102, 5, 'reading', 'The ------- antique shop in Pepper Valley will close down next month.', 'last', 'lasts', 'lasted', 'lasting', 'A', 'Cửa hàng đồ cổ cuối cùng ở Pepper Valley sẽ đóng cửa vào tháng tới.', '', '', '', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('87ebe470-4d07-452f-be5d-c9babfbc47df', 'toeic-test-01', 103, 5, 'reading', 'Merryville residents will receive an online status ------- about the ongoing bridge construction project.', 'update', 'change', 'payment', 'request', 'A', 'Cư dân Merryville sẽ nhận được bản cập nhật trạng thái trực tuyến về dự án xây dựng cầu đang diễn ra.', '', '', '', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('e0bf9591-e203-4e1d-ba03-da5dffcae6c3', 'toeic-test-01', 104, 5, 'reading', 'As a result of ------- many years leading media organizations, Ms. Ayo was selected for the Dowel Journalism Prize.', 'she', 'her', 'hers', 'herself', 'B', 'Nhờ kết quả của nhiều năm dẫn dắt các tổ chức truyền thông, bà Ayo đã được chọn cho Giải thưởng Báo chí Dowel.', '', '', '', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('3f664638-6ead-4bf9-b8b0-3c7e04db0469', 'toeic-test-01', 105, 5, 'reading', 'To stop the ------- of computer viruses, do not open suspicious e-mails.', 'break', 'spread', 'balance', 'surface', 'B', 'Để ngăn chặn sự lây lan của virus máy tính, đừng mở các email khả nghi.', '', '', '', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('230d1bf5-ac80-4f4b-a88e-5896d1a456e9', 'toeic-test-01', 106, 5, 'reading', 'The hiring manager ------- considered each applicant''s résumé and qualifications.', 'caring', 'careful', 'carefully', 'carefulness', 'C', 'Nhà quản lý tuyển dụng đã xem xét cẩn thận sơ yếu lý lịch và năng lực của từng ứng viên.', '', '', '', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('ae0eee81-b6c0-4c4a-b7c5-7dda5e2070d9', 'toeic-test-01', 107, 5, 'reading', 'In October, Mr. Sakamoto will leave for New Zealand ------- will oversee the opening of the new Auckland branch.', 'because', 'in addition', 'and', 'prior to', 'C', 'Vào tháng 10, ông Sakamoto sẽ đi New Zealand và sẽ giám sát việc khai trương chi nhánh Auckland mới.', '', '', '', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('dca68741-7861-47cc-81f6-02c9a7feb4a3', 'toeic-test-01', 108, 5, 'reading', 'Tarateer Pharmaceuticals is varying its product ------- to include over-the-counter medications.', 'to line', 'lining', 'lined', 'line', 'D', 'Tarateer Pharmaceuticals đang đa dạng hóa dòng sản phẩm của mình để bao gồm cả các loại thuốc không kê đơn.', '', '', '', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('87846a8e-bb71-4693-b863-616ad4a4f4d5', 'toeic-test-01', 109, 5, 'reading', 'Dynart, Inc., continuously ------- new ways to reduce its use of plastics.', 'seeks', 'seeker', 'to seek', 'seeking', 'A', 'Dynart, Inc. liên tục tìm kiếm những cách mới để giảm việc sử dụng nhựa.', '', '', '', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('46276648-de4b-4a1e-a751-ad1812bcb2bb', 'toeic-test-01', 110, 5, 'reading', 'The cash registers at Pirkle Books automatically ------- the remaining inventory of books available.', 'calculate', 'calculator', 'calculating', 'calculation', 'A', 'Máy tính tiền tại Pirkle Books tự động tính toán số lượng sách tồn kho còn lại hiện có.', '', '', '', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('9cb15efd-a25c-49c4-864a-390bff36dc80', 'toeic-test-01', 111, 5, 'reading', 'The product team is designing mapping software that can ------- locate underground minerals.', 'infinitely', 'sincerely', 'precisely', 'greatly', 'C', 'Nhóm sản phẩm đang thiết kế phần mềm lập bản đồ có thể xác định chính xác vị trí các khoáng sản dưới lòng đất.', '', '', '', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('5a338c55-7383-4d86-b02f-1e8c7bb5062e', 'toeic-test-01', 112, 5, 'reading', 'According to CEO Mayu Yamada, it would not be ------- responsible to expand the warehouse at this time.', 'finance', 'financials', 'financially', 'financing', 'C', 'Theo CEO Mayu Yamada, việc mở rộng kho hàng vào thời điểm này sẽ không có trách nhiệm về mặt tài chính.', '', '', '', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('a5bcf8db-9fc4-4940-b1fe-2d7d6363968c', 'toeic-test-01', 113, 5, 'reading', 'Analysts cannot say with any ------- what the regional demand for electric trucks will be.', 'certainty', 'justice', 'excellence', 'denial', 'A', 'Các nhà phân tích không thể nói chắc chắn rằng nhu cầu khu vực đối với xe tải điện sẽ như thế nào.', '', '', '', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('7772e1ba-a428-4ff7-8092-0f34975c99bb', 'toeic-test-01', 114, 5, 'reading', 'As part of its marketing campaign, Elegancia Dishware is ------- soliciting feedback from customers.', 'lightly', 'loyally', 'actively', 'cleanly', 'C', 'Là một phần của chiến dịch tiếp thị, Elegancia Dishware đang tích cực trưng cầu ý kiến phản hồi từ khách hàng.', '', '', '', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('9b615293-d7fe-4a83-9aee-81e17ca917bc', 'toeic-test-01', 115, 5, 'reading', 'Rain gardens are intended to ------- water to prevent flooding of local roads.', 'engage', 'undergo', 'absorb', 'overwhelm', 'C', 'Vườn mưa được thiết kế để hấp thụ nước nhằm ngăn chặn tình trạng ngập lụt các tuyến đường địa phương.', '', '', '', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('d1c46510-ca10-4f2a-8bcf-5a7bf9356757', 'toeic-test-01', 116, 5, 'reading', 'Theta Industries'' training program aims to increase the ------- of its manufacturing systems.', 'producer', 'produced', 'productive', 'productivity', 'D', 'Chương trình đào tạo của Theta Industries nhằm mục đích tăng năng suất của các hệ thống sản xuất của mình.', '', '', '', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('0b16c401-b5f5-48b8-bbde-7f6f1d57d275', 'toeic-test-01', 117, 5, 'reading', 'The board of directors has voted to award Mr. Mitrakos a bonus for his role ------- obtaining the international contract.', 'in', 'at', 'except', 'apart', 'A', 'Hội đồng quản trị đã bỏ phiếu trao thưởng cho ông Mitrakos một khoản tiền thưởng vì vai trò của ông trong việc đạt được hợp đồng quốc tế.', '', '', '', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('34bdd71c-3c76-4613-9f85-1a52226a6a08', 'toeic-test-01', 118, 5, 'reading', 'The finance director gave his approval ------- the project can move forward.', 'along', 'furthermore', 'cautiously', 'so that', 'D', 'Giám đốc tài chính đã đưa ra sự phê duyệt để dự án có thể tiến triển.', '', '', '', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('50cc6b24-a3f2-4fa9-a0bc-f283199a01d4', 'toeic-test-01', 119, 5, 'reading', 'The newspaper article describes ways job seekers can ------- for having little workplace experience.', 'reply', 'capture', 'compensate', 'accumulate', 'C', 'Bài báo trên báo mô tả những cách mà người tìm việc có thể bù đắp cho việc có ít kinh nghiệm làm việc.', '', '', '', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('a0f59639-0ad6-4136-82ea-9fcb30d03d16', 'toeic-test-01', 120, 5, 'reading', 'Mr. Ellis and Ms. Barnes were both highly qualified, but ------- got the job.', 'myself', 'neither', 'anybody', 'whoever', 'B', 'Cả ông Ellis và bà Barnes đều rất có năng lực, nhưng không ai trong số họ nhận được công việc.', '', '', '', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('dfd1bbee-505b-4464-9142-41544624400b', 'toeic-test-01', 121, 5, 'reading', 'Ennis Photography purchased all new lighting equipment ------- the high cost.', 'even though', 'however', 'until', 'despite', 'D', 'Ennis Photography đã mua tất cả thiết bị chiếu sáng mới bất chấp chi phí cao.', '', '', '', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('763ee476-66b7-4133-bef3-c410c381fe6c', 'toeic-test-01', 122, 5, 'reading', 'Marburton residents who wish to ------- a home should contact the award-winning team at Kwan Real Estate.', 'seller', 'sold', 'sell', 'selling', 'C', 'Những cư dân Marburton muốn bán nhà nên liên hệ với đội ngũ từng đoạt giải thưởng tại Kwan Real Estate.', '', '', '', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('96b1797c-8b20-4c72-a008-cfa6f58545d4', 'toeic-test-01', 123, 5, 'reading', 'Maswa Bistro began a ------- agreement with local farmers to purchase a set amount of produce each week.', 'disruptive', 'cooperative', 'grateful', 'concerned', 'B', 'Maswa Bistro đã bắt đầu một thỏa thuận hợp tác với các nông dân địa phương để mua một lượng nông sản nhất định mỗi tuần.', '', '', '', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('e521ccde-474c-4680-86b5-0e72bcc6892a', 'toeic-test-01', 124, 5, 'reading', 'The City of Doyle''s new downtown parking ------- have been met with opposition by residents and visitors.', 'restricts', 'restricted', 'restrictions', 'restricting', 'C', 'Các quy định hạn chế đậu xe mới ở trung tâm thành phố Doyle đã vấp phải sự phản đối của cư dân và du khách.', '', '', '', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('a666c401-b608-4c09-8f18-f3a7f60c5045', 'toeic-test-01', 125, 5, 'reading', 'The plumbing position requires extensive training, even for those who studied ------- in technical school.', 'diligently', 'scientifically', 'objectively', 'decidedly', 'A', 'Vị trí thợ sửa ống nước yêu cầu đào tạo chuyên sâu, ngay cả đối với những người đã học tập chăm chỉ ở trường kỹ thuật.', '', '', '', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('7c3ff17e-246d-4090-a3b2-1dfa0abed7a3', 'toeic-test-01', 126, 5, 'reading', 'With its fixed price -------, Omega Cellular guarantees no phone bill increases for three years.', 'assurance', 'assuredly', 'assuring', 'assures', 'A', 'Với sự đảm bảo về giá cố định, Omega Cellular cam kết không tăng hóa đơn điện thoại trong ba năm.', '', '', '', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('bf5ba70f-80a1-4200-b378-eaf36be20d2c', 'toeic-test-01', 127, 5, 'reading', 'As chief analytics officer, Mr. Ko has worked at Lochston Ltd. with great ------- for more than twenty years.', 'deduction', 'duplication', 'declaration', 'dedication', 'D', 'Với tư cách là giám đốc phân tích, ông Ko đã làm việc tại Lochston Ltd. với sự cống hiến to lớn trong hơn hai mươi năm.', '', '', '', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('15f4f191-8e4d-45f1-a13a-875a41ec6510', 'toeic-test-01', 128, 5, 'reading', 'Milltown Hospital''s cafeteria serves lunch seven days a week ------- only on weekdays.', 'up to', 'as though', 'each time', 'rather than', 'D', 'Nhà ăn của Bệnh viện Milltown phục vụ bữa trưa bảy ngày một tuần thay vì chỉ vào các ngày trong tuần.', '', '', '', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('1c90d586-3326-4e0f-899f-d7171f3368af', 'toeic-test-01', 129, 5, 'reading', 'The store''s entire inventory of lumber comes from a nearby ------- supplier.', 'financial', 'promotional', 'chemical', 'commercial', 'D', 'Toàn bộ lượng gỗ dự trữ của cửa hàng đến từ một nhà cung cấp thương mại gần đó.', '', '', '', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('17b22ba5-5ea4-4158-97f8-aed58834a117', 'toeic-test-01', 130, 5, 'reading', 'For a $95 ------- fee, our mechanics will determine what repairs are needed.', 'diagnosed', 'diagnostic', 'diagnosable', 'diagnose', 'B', 'Với mức phí chẩn đoán 95 đô la, các thợ máy của chúng tôi sẽ xác định những sửa chữa nào là cần thiết.', '', '', '', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('9871d08a-bedb-4d24-b134-d3584cf2c063', 'toeic-test-01', 131, 6, 'reading', 'Questions 131-134 refer to the following flyer.', 'Staff members have written articles for the local newspaper.', 'Installing lights can enhance the effect of a well-designed garden.', 'Local competitors cannot beat the prices we charge.', 'Riessler Landscaping''s goal is to make your vision a reality.', 'D', 'Hãy tìm đến Riessler Landscaping cho các nhu cầu về khu vườn của bạn

Riessler Landscaping có mọi thứ bạn cần để tạo ra khu vườn mơ ước. Chúng tôi sẽ lắng nghe ý tưởng của bạn và đưa ra những gợi ý phù hợp với mong muốn làm vườn của bạn. Mục tiêu của Riessler Landscaping là biến tầm nhìn của bạn thành hiện thực. Vườn ươm tại đây bao gồm nhiều loại cây với kích cỡ khác nhau, bùng nổ với màu sắc bắt mắt quanh năm. Bạn chắc chắn sẽ tìm thấy thứ gì đó giúp tăng thêm vẻ đẹp cho khu vườn của mình. Chúng tôi cũng được trang bị đầy đủ để xây dựng các hồ nhỏ hoặc các tính năng nước khác. Và như tên gọi của mình, chúng tôi có thể đảm nhận các dự án cảnh quan đầy tham vọng hơn — bất cứ điều gì bạn cần! Với hơn 40 năm kinh nghiệm, chuyên môn của chúng tôi là không đối thủ.', '', '', '4d838179-03dc-445b-81ce-71bd6d13620a', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('8711d3ce-dda4-4d64-943a-be8857207e4b', 'toeic-test-01', 132, 6, 'reading', 'Questions 131-134 refer to the following flyer.', 'years', 'space', 'beauty', 'moisture', 'C', 'Hãy tìm đến Riessler Landscaping cho các nhu cầu về khu vườn của bạn

Riessler Landscaping có mọi thứ bạn cần để tạo ra khu vườn mơ ước. Chúng tôi sẽ lắng nghe ý tưởng của bạn và đưa ra những gợi ý phù hợp với mong muốn làm vườn của bạn. Mục tiêu của Riessler Landscaping là biến tầm nhìn của bạn thành hiện thực. Vườn ươm tại đây bao gồm nhiều loại cây với kích cỡ khác nhau, bùng nổ với màu sắc bắt mắt quanh năm. Bạn chắc chắn sẽ tìm thấy thứ gì đó giúp tăng thêm vẻ đẹp cho khu vườn của mình. Chúng tôi cũng được trang bị đầy đủ để xây dựng các hồ nhỏ hoặc các tính năng nước khác. Và như tên gọi của mình, chúng tôi có thể đảm nhận các dự án cảnh quan đầy tham vọng hơn — bất cứ điều gì bạn cần! Với hơn 40 năm kinh nghiệm, chuyên môn của chúng tôi là không đối thủ.', '', '', '4d838179-03dc-445b-81ce-71bd6d13620a', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('bc51a6de-8fff-4c10-bfc9-fe2c16602740', 'toeic-test-01', 133, 6, 'reading', 'Questions 131-134 refer to the following flyer.', 'also', 'rarely', 'somehow', 'nevertheless', 'A', 'Hãy tìm đến Riessler Landscaping cho các nhu cầu về khu vườn của bạn

Riessler Landscaping có mọi thứ bạn cần để tạo ra khu vườn mơ ước. Chúng tôi sẽ lắng nghe ý tưởng của bạn và đưa ra những gợi ý phù hợp với mong muốn làm vườn của bạn. Mục tiêu của Riessler Landscaping là biến tầm nhìn của bạn thành hiện thực. Vườn ươm tại đây bao gồm nhiều loại cây với kích cỡ khác nhau, bùng nổ với màu sắc bắt mắt quanh năm. Bạn chắc chắn sẽ tìm thấy thứ gì đó giúp tăng thêm vẻ đẹp cho khu vườn của mình. Chúng tôi cũng được trang bị đầy đủ để xây dựng các hồ nhỏ hoặc các tính năng nước khác. Và như tên gọi của mình, chúng tôi có thể đảm nhận các dự án cảnh quan đầy tham vọng hơn — bất cứ điều gì bạn cần! Với hơn 40 năm kinh nghiệm, chuyên môn của chúng tôi là không đối thủ.', '', '', '4d838179-03dc-445b-81ce-71bd6d13620a', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('9c373e73-b760-4212-b91d-44838c89d37e', 'toeic-test-01', 134, 6, 'reading', 'Questions 131-134 refer to the following flyer.', 'its', 'our', 'others', 'their', 'B', 'Hãy tìm đến Riessler Landscaping cho các nhu cầu về khu vườn của bạn

Riessler Landscaping có mọi thứ bạn cần để tạo ra khu vườn mơ ước. Chúng tôi sẽ lắng nghe ý tưởng của bạn và đưa ra những gợi ý phù hợp với mong muốn làm vườn của bạn. Mục tiêu của Riessler Landscaping là biến tầm nhìn của bạn thành hiện thực. Vườn ươm tại đây bao gồm nhiều loại cây với kích cỡ khác nhau, bùng nổ với màu sắc bắt mắt quanh năm. Bạn chắc chắn sẽ tìm thấy thứ gì đó giúp tăng thêm vẻ đẹp cho khu vườn của mình. Chúng tôi cũng được trang bị đầy đủ để xây dựng các hồ nhỏ hoặc các tính năng nước khác. Và như tên gọi của mình, chúng tôi có thể đảm nhận các dự án cảnh quan đầy tham vọng hơn — bất cứ điều gì bạn cần! Với hơn 40 năm kinh nghiệm, chuyên môn của chúng tôi là không đối thủ.', '', '', '4d838179-03dc-445b-81ce-71bd6d13620a', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('1307c93c-ea99-4e27-8e5b-8ca92c9f027e', 'toeic-test-01', 135, 6, 'reading', 'Questions 135-138 refer to the following letter.', 'We especially value our long-term customers.', 'Please join our holiday celebration.', 'Our annual report will be released soon.', 'You have been a valuable member of our team.', 'D', 'Ngày 10 tháng 1

Thân gửi bà Mulligan,

Chúng tôi rất vui mừng được kỷ niệm 30 năm làm việc của bà tại Trung tâm Phân phối Brandrix. Bà đã là một thành viên quý giá trong đội ngũ của chúng tôi. Sự tận tụy, lòng trung thành và sự chăm chỉ của bà đã đóng góp rất lớn vào thành công của chúng tôi trong những năm qua. Chúng tôi trân trọng cam kết của bà đối với sự xuất sắc. Trong suốt những năm qua, bà đã thể hiện sự chủ động, sáng tạo và khả năng lãnh đạo tuyệt vời. Bà sẽ sớm nhận được một bảng kỷ niệm chương qua đường bưu điện. Chúng tôi hy vọng món quà tri ân này sẽ nhắc nhở bà rằng bà có ý nghĩa như thế nào đối với chúng tôi. Chúc mừng bà đã đạt được cột mốc này.', '', '', 'e2b2732c-7f34-45c3-b902-4f5de0e934fc', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('1cd06d86-a84d-486a-a261-1517ef170009', 'toeic-test-01', 136, 6, 'reading', 'Questions 135-138 refer to the following letter.', 'will show', 'must show', 'have shown', 'are showing', 'C', 'Ngày 10 tháng 1

Thân gửi bà Mulligan,

Chúng tôi rất vui mừng được kỷ niệm 30 năm làm việc của bà tại Trung tâm Phân phối Brandrix. Bà đã là một thành viên quý giá trong đội ngũ của chúng tôi. Sự tận tụy, lòng trung thành và sự chăm chỉ của bà đã đóng góp rất lớn vào thành công của chúng tôi trong những năm qua. Chúng tôi trân trọng cam kết của bà đối với sự xuất sắc. Trong suốt những năm qua, bà đã thể hiện sự chủ động, sáng tạo và khả năng lãnh đạo tuyệt vời. Bà sẽ sớm nhận được một bảng kỷ niệm chương qua đường bưu điện. Chúng tôi hy vọng món quà tri ân này sẽ nhắc nhở bà rằng bà có ý nghĩa như thế nào đối với chúng tôi. Chúc mừng bà đã đạt được cột mốc này.', '', '', 'e2b2732c-7f34-45c3-b902-4f5de0e934fc', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('2db44358-ea26-41d5-9e62-6de7a9e685a2', 'toeic-test-01', 137, 6, 'reading', 'Questions 135-138 refer to the following letter.', 'then', 'soon', 'instead', 'likewise', 'B', 'Ngày 10 tháng 1

Thân gửi bà Mulligan,

Chúng tôi rất vui mừng được kỷ niệm 30 năm làm việc của bà tại Trung tâm Phân phối Brandrix. Bà đã là một thành viên quý giá trong đội ngũ của chúng tôi. Sự tận tụy, lòng trung thành và sự chăm chỉ của bà đã đóng góp rất lớn vào thành công của chúng tôi trong những năm qua. Chúng tôi trân trọng cam kết của bà đối với sự xuất sắc. Trong suốt những năm qua, bà đã thể hiện sự chủ động, sáng tạo và khả năng lãnh đạo tuyệt vời. Bà sẽ sớm nhận được một bảng kỷ niệm chương qua đường bưu điện. Chúng tôi hy vọng món quà tri ân này sẽ nhắc nhở bà rằng bà có ý nghĩa như thế nào đối với chúng tôi. Chúc mừng bà đã đạt được cột mốc này.', '', '', 'e2b2732c-7f34-45c3-b902-4f5de0e934fc', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('5824a6ac-8359-4de9-9ef6-7c4eaef59fdd', 'toeic-test-01', 138, 6, 'reading', 'Questions 135-138 refer to the following letter.', 'milestone', 'consensus', 'destination', 'understanding', 'A', 'Ngày 10 tháng 1

Thân gửi bà Mulligan,

Chúng tôi rất vui mừng được kỷ niệm 30 năm làm việc của bà tại Trung tâm Phân phối Brandrix. Bà đã là một thành viên quý giá trong đội ngũ của chúng tôi. Sự tận tụy, lòng trung thành và sự chăm chỉ của bà đã đóng góp rất lớn vào thành công của chúng tôi trong những năm qua. Chúng tôi trân trọng cam kết của bà đối với sự xuất sắc. Trong suốt những năm qua, bà đã thể hiện sự chủ động, sáng tạo và khả năng lãnh đạo tuyệt vời. Bà sẽ sớm nhận được một bảng kỷ niệm chương qua đường bưu điện. Chúng tôi hy vọng món quà tri ân này sẽ nhắc nhở bà rằng bà có ý nghĩa như thế nào đối với chúng tôi. Chúc mừng bà đã đạt được cột mốc này.', '', '', 'e2b2732c-7f34-45c3-b902-4f5de0e934fc', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('ec18d3fd-64ac-41a8-a6d7-394de7842127', 'toeic-test-01', 139, 6, 'reading', 'Questions 139-142 refer to the following e-mail.', 'finalizing', 'finalize', 'finalized', 'finalizes', 'A', 'Người nhận: Kay Berman

Người gửi: Ali Chaleby

Ngày: 21 tháng 8

Chủ đề: Kế hoạch cho phòng khách

Thân gửi bà Berman, đội ngũ thiết kế của tôi đang trong quá trình hoàn tất các bản kế hoạch cho phòng khách của bà. Dựa trên cuộc trò chuyện cuối cùng của chúng ta, tôi đã chọn các loại sơn khác nhau cho tường và viền. Vui lòng xem tệp đính kèm và quyết định xem bà có thích những màu sắc mới đó không. Nếu không, vẫn chưa quá muộn để thay đổi. Chúng tôi dự định sẽ không bắt đầu công việc trong vòng hai tuần tới. Đánh giá của bà sẽ giúp chúng tôi hoàn thiện thiết kế trước khi bắt đầu. Vui lòng cho tôi biết nếu bà có bất kỳ câu hỏi nào. Tôi mong sớm nhận được phản hồi từ bà.', '', '', 'f1b710e4-d37a-4eed-a97a-6ff0a4b11842', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('9cae0730-9f86-4460-a9f9-fb7610ccff33', 'toeic-test-01', 140, 6, 'reading', 'Questions 139-142 refer to the following e-mail.', 'organizations', 'schedules', 'colors', 'times', 'C', 'Người nhận: Kay Berman

Người gửi: Ali Chaleby

Ngày: 21 tháng 8

Chủ đề: Kế hoạch cho phòng khách

Thân gửi bà Berman, đội ngũ thiết kế của tôi đang trong quá trình hoàn tất các bản kế hoạch cho phòng khách của bà. Dựa trên cuộc trò chuyện cuối cùng của chúng ta, tôi đã chọn các loại sơn khác nhau cho tường và viền. Vui lòng xem tệp đính kèm và quyết định xem bà có thích những màu sắc mới đó không. Nếu không, vẫn chưa quá muộn để thay đổi. Chúng tôi dự định sẽ không bắt đầu công việc trong vòng hai tuần tới. Đánh giá của bà sẽ giúp chúng tôi hoàn thiện thiết kế trước khi bắt đầu. Vui lòng cho tôi biết nếu bà có bất kỳ câu hỏi nào. Tôi mong sớm nhận được phản hồi từ bà.', '', '', 'f1b710e4-d37a-4eed-a97a-6ff0a4b11842', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('10534a9e-78c7-4794-b4fd-d0d27b45801a', 'toeic-test-01', 141, 6, 'reading', 'Questions 139-142 refer to the following e-mail.', 'I have already begun drawing up plans for your kitchen.', 'We are not planning to begin work for another two weeks.', 'Your living room is particularly spacious and airy.', 'We have not yet received your current payment.', 'B', 'Người nhận: Kay Berman

Người gửi: Ali Chaleby

Ngày: 21 tháng 8

Chủ đề: Kế hoạch cho phòng khách

Thân gửi bà Berman, đội ngũ thiết kế của tôi đang trong quá trình hoàn tất các bản kế hoạch cho phòng khách của bà. Dựa trên cuộc trò chuyện cuối cùng của chúng ta, tôi đã chọn các loại sơn khác nhau cho tường và viền. Vui lòng xem tệp đính kèm và quyết định xem bà có thích những màu sắc mới đó không. Nếu không, vẫn chưa quá muộn để thay đổi. Chúng tôi dự định sẽ không bắt đầu công việc trong vòng hai tuần tới. Đánh giá của bà sẽ giúp chúng tôi hoàn thiện thiết kế trước khi bắt đầu. Vui lòng cho tôi biết nếu bà có bất kỳ câu hỏi nào. Tôi mong sớm nhận được phản hồi từ bà.', '', '', 'f1b710e4-d37a-4eed-a97a-6ff0a4b11842', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('89471f61-6f1e-413c-a115-8a4feab8b888', 'toeic-test-01', 142, 6, 'reading', 'Questions 139-142 refer to the following e-mail.', 'them', 'ours', 'his', 'me', 'D', 'Người nhận: Kay Berman

Người gửi: Ali Chaleby

Ngày: 21 tháng 8

Chủ đề: Kế hoạch cho phòng khách

Thân gửi bà Berman, đội ngũ thiết kế của tôi đang trong quá trình hoàn tất các bản kế hoạch cho phòng khách của bà. Dựa trên cuộc trò chuyện cuối cùng của chúng ta, tôi đã chọn các loại sơn khác nhau cho tường và viền. Vui lòng xem tệp đính kèm và quyết định xem bà có thích những màu sắc mới đó không. Nếu không, vẫn chưa quá muộn để thay đổi. Chúng tôi dự định sẽ không bắt đầu công việc trong vòng hai tuần tới. Đánh giá của bà sẽ giúp chúng tôi hoàn thiện thiết kế trước khi bắt đầu. Vui lòng cho tôi biết nếu bà có bất kỳ câu hỏi nào. Tôi mong sớm nhận được phản hồi từ bà.', '', '', 'f1b710e4-d37a-4eed-a97a-6ff0a4b11842', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('f3cea484-5a1c-4dae-96f5-5a5d18e57ad7', 'toeic-test-01', 143, 6, 'reading', 'Questions 143-146 refer to the following e-mail.', 'satisfied', 'satisfaction', 'satisfactory', 'satisfactorily', 'C', 'Thân gửi bà Zalen, cảm ơn bà đã đến thăm Phòng khám Đa khoa Kaymar gần đây. Chúng tôi hy vọng bà thấy dịch vụ của chúng tôi thỏa đáng, và chúng tôi hoan nghênh các ý kiến đóng góp để cải thiện.

Chúng tôi đã đăng một bản tóm tắt về cuộc tư vấn của bà trên cổng thông tin. Vui lòng dành chút thời gian xem qua và cho chúng tôi biết nếu bà có thắc mắc. Như một lời nhắc nhở, bà có thể đăng nhập cổng thông tin cho nhiều hoạt động khác nhau. Chẳng hạn, bà có thể đặt lịch hẹn và thanh toán, xem lịch sử y tế, kiểm tra kết quả xét nghiệm và yêu cầu cấp lại thuốc. Chúng tôi hy vọng bà sẽ sử dụng nguồn tài nguyên này để quản lý nhu cầu sức khỏe của mình. Hãy yên tâm rằng thông tin cá nhân của bà luôn được an toàn.', '', '', '0e05dc71-5acf-4cf8-8bf3-50897d0d7ef8', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('680b836b-0940-4725-a7a9-e1bd927c9b86', 'toeic-test-01', 144, 6, 'reading', 'Questions 143-146 refer to the following e-mail.', 'photo', 'lecture', 'summary', 'schedule', 'C', 'Thân gửi bà Zalen, cảm ơn bà đã đến thăm Phòng khám Đa khoa Kaymar gần đây. Chúng tôi hy vọng bà thấy dịch vụ của chúng tôi thỏa đáng, và chúng tôi hoan nghênh các ý kiến đóng góp để cải thiện.

Chúng tôi đã đăng một bản tóm tắt về cuộc tư vấn của bà trên cổng thông tin. Vui lòng dành chút thời gian xem qua và cho chúng tôi biết nếu bà có thắc mắc. Như một lời nhắc nhở, bà có thể đăng nhập cổng thông tin cho nhiều hoạt động khác nhau. Chẳng hạn, bà có thể đặt lịch hẹn và thanh toán, xem lịch sử y tế, kiểm tra kết quả xét nghiệm và yêu cầu cấp lại thuốc. Chúng tôi hy vọng bà sẽ sử dụng nguồn tài nguyên này để quản lý nhu cầu sức khỏe của mình. Hãy yên tâm rằng thông tin cá nhân của bà luôn được an toàn.', '', '', '0e05dc71-5acf-4cf8-8bf3-50897d0d7ef8', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('3e7d74e8-4139-40f6-9a43-d9b5f57af2c3', 'toeic-test-01', 145, 6, 'reading', 'Questions 143-146 refer to the following e-mail.', 'To repeat', 'For instance', 'Otherwise', 'Consequently', 'B', 'Thân gửi bà Zalen, cảm ơn bà đã đến thăm Phòng khám Đa khoa Kaymar gần đây. Chúng tôi hy vọng bà thấy dịch vụ của chúng tôi thỏa đáng, và chúng tôi hoan nghênh các ý kiến đóng góp để cải thiện.

Chúng tôi đã đăng một bản tóm tắt về cuộc tư vấn của bà trên cổng thông tin. Vui lòng dành chút thời gian xem qua và cho chúng tôi biết nếu bà có thắc mắc. Như một lời nhắc nhở, bà có thể đăng nhập cổng thông tin cho nhiều hoạt động khác nhau. Chẳng hạn, bà có thể đặt lịch hẹn và thanh toán, xem lịch sử y tế, kiểm tra kết quả xét nghiệm và yêu cầu cấp lại thuốc. Chúng tôi hy vọng bà sẽ sử dụng nguồn tài nguyên này để quản lý nhu cầu sức khỏe của mình. Hãy yên tâm rằng thông tin cá nhân của bà luôn được an toàn.', '', '', '0e05dc71-5acf-4cf8-8bf3-50897d0d7ef8', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('13aa5493-83dc-41c5-ac6c-edb8aebcf9b8', 'toeic-test-01', 146, 6, 'reading', 'Questions 143-146 refer to the following e-mail.', 'We hope you will use this resource to manage your health-care needs.', 'The staff will close the office early on Friday afternoons.', 'Please be sure to come to our office fifteen minutes in advance.', 'We apologize for any confusion about your appointment time.', 'A', 'Thân gửi bà Zalen, cảm ơn bà đã đến thăm Phòng khám Đa khoa Kaymar gần đây. Chúng tôi hy vọng bà thấy dịch vụ của chúng tôi thỏa đáng, và chúng tôi hoan nghênh các ý kiến đóng góp để cải thiện.

Chúng tôi đã đăng một bản tóm tắt về cuộc tư vấn của bà trên cổng thông tin. Vui lòng dành chút thời gian xem qua và cho chúng tôi biết nếu bà có thắc mắc. Như một lời nhắc nhở, bà có thể đăng nhập cổng thông tin cho nhiều hoạt động khác nhau. Chẳng hạn, bà có thể đặt lịch hẹn và thanh toán, xem lịch sử y tế, kiểm tra kết quả xét nghiệm và yêu cầu cấp lại thuốc. Chúng tôi hy vọng bà sẽ sử dụng nguồn tài nguyên này để quản lý nhu cầu sức khỏe của mình. Hãy yên tâm rằng thông tin cá nhân của bà luôn được an toàn.', '', '', '0e05dc71-5acf-4cf8-8bf3-50897d0d7ef8', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('19a010b9-ac0f-4e17-9593-50297b7cbba6', 'toeic-test-01', 147, 7, 'reading', 'What is the purpose of the notice?', 'To invite residents to a meeting on May 3', 'To request feedback about parking facilities', 'To inform residents of an upcoming project', 'To announce an increase in parking fees', 'C', 'Thân gửi cư dân Chung cư High View,

Công ty Trải nhựa Riverside sẽ đến Chung cư High View vào ngày 3 và 4 tháng 5 để trải lại bề mặt khu vực bãi đậu xe. Tất cả các phương tiện phải được di dời trước 8 giờ sáng ngày 3 tháng 5 để công việc được bắt đầu. Cư dân có thể sử dụng lại bãi đậu xe bắt đầu từ 8 giờ sáng ngày 5 tháng 5. Chúng tôi nhận thấy rằng việc cố gắng tìm một nơi khác để đậu xe là bất tiện, nhưng điều này là cần thiết để công việc được hoàn thành trong hai ngày theo kế hoạch. Lưu ý rằng tất cả các chỗ đậu xe sẽ được mở rộng, và một số chỗ có thể bị thay đổi vị trí trong quá trình làm việc. Bạn sẽ nhận được email nếu chỗ đậu xe của bạn bị di chuyển hơn 20 mét so với chỗ cũ.

Cảm ơn sự hợp tác của bạn,

Judith Alvarez, Quản lý tài sản', '', '', '57863889-edbf-4fe8-8621-720c4f7a69b9', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('d6f6104e-1a4d-4c99-aa22-d7a81ad2a8c0', 'toeic-test-01', 148, 7, 'reading', 'What is suggested about High View Apartments?', 'It charges residents a monthly maintenance fee.', 'It recently hired a new property manager.', 'It has the parking area repaved every year.', 'It assigns tenants specific parking spots.', 'D', 'Thân gửi cư dân Chung cư High View,

Công ty Trải nhựa Riverside sẽ đến Chung cư High View vào ngày 3 và 4 tháng 5 để trải lại bề mặt khu vực bãi đậu xe. Tất cả các phương tiện phải được di dời trước 8 giờ sáng ngày 3 tháng 5 để công việc được bắt đầu. Cư dân có thể sử dụng lại bãi đậu xe bắt đầu từ 8 giờ sáng ngày 5 tháng 5. Chúng tôi nhận thấy rằng việc cố gắng tìm một nơi khác để đậu xe là bất tiện, nhưng điều này là cần thiết để công việc được hoàn thành trong hai ngày theo kế hoạch. Lưu ý rằng tất cả các chỗ đậu xe sẽ được mở rộng, và một số chỗ có thể bị thay đổi vị trí trong quá trình làm việc. Bạn sẽ nhận được email nếu chỗ đậu xe của bạn bị di chuyển hơn 20 mét so với chỗ cũ.

Cảm ơn sự hợp tác của bạn,

Judith Alvarez, Quản lý tài sản', '', '', '57863889-edbf-4fe8-8621-720c4f7a69b9', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('60f91361-ca1b-485c-84b8-cc6a767d6b6c', 'toeic-test-01', 149, 7, 'reading', 'What most likely is Ms. Seang’s job?', 'Glassmaker', 'Art instructor', 'Beach lifeguard', 'Program administrator', 'B', 'Carol Barger (10:45 sáng)

Xin chào, cô Seang.

Leakhena Seang (10:55 sáng)

Chào buổi sáng!

Carol Barger (11:15 sáng)

Chúng tôi có mười lăm người đăng ký tham gia hội thảo khảm của cô vào ngày mai. Con số đó nhiều hơn năm người so với mùa hè năm ngoái. Hội thảo của cô ngày càng trở nên phổ biến hơn qua mỗi năm! Cô có đủ nguyên liệu cho ngần ấy người tham gia không?

Leakhena Seang (11:23 sáng)

Tôi có dư dả cho mọi người. Chúng ta sẽ tạo ra các thiết kế khảm bằng những mảnh thủy tinh biển mà tôi đã thu thập được trong kỳ nghỉ hè năm ngoái. Chúng là những mảnh chai lọ màu nâu, xanh lá cây và xanh dương dạt vào bãi biển. Cát đã làm nhẵn tất cả các cạnh sắc, vì vậy chúng hoàn toàn an toàn cho mọi người sử dụng.

Carol Barger (11:30 sáng)

Nghe có vẻ hay đấy. Hẹn gặp cô vào bữa sáng mai.', '', '', '44042b04-b2c7-4d37-949f-41596b4f2341', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('a9eaddba-55e6-4a3e-a3e5-259607131c08', 'toeic-test-01', 150, 7, 'reading', 'At 11:23 A.M., what does Ms. Seang imply when she writes, “I have plenty to go around”?', 'She intends to create an extra-large mosaic.', 'She has been collecting sea glass for many years.', 'She can share her sea glass with all the workshop participants.', 'She does not think she will use much of her sea glass.', 'C', 'Carol Barger (10:45 sáng)

Xin chào, cô Seang.

Leakhena Seang (10:55 sáng)

Chào buổi sáng!

Carol Barger (11:15 sáng)

Chúng tôi có mười lăm người đăng ký tham gia hội thảo khảm của cô vào ngày mai. Con số đó nhiều hơn năm người so với mùa hè năm ngoái. Hội thảo của cô ngày càng trở nên phổ biến hơn qua mỗi năm! Cô có đủ nguyên liệu cho ngần ấy người tham gia không?

Leakhena Seang (11:23 sáng)

Tôi có dư dả cho mọi người. Chúng ta sẽ tạo ra các thiết kế khảm bằng những mảnh thủy tinh biển mà tôi đã thu thập được trong kỳ nghỉ hè năm ngoái. Chúng là những mảnh chai lọ màu nâu, xanh lá cây và xanh dương dạt vào bãi biển. Cát đã làm nhẵn tất cả các cạnh sắc, vì vậy chúng hoàn toàn an toàn cho mọi người sử dụng.

Carol Barger (11:30 sáng)

Nghe có vẻ hay đấy. Hẹn gặp cô vào bữa sáng mai.', '', '', '44042b04-b2c7-4d37-949f-41596b4f2341', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('711c1f2f-3a51-4535-837c-e3b4c40dc663', 'toeic-test-01', 151, 7, 'reading', 'What is mentioned about Mr. Norton?', 'He will be attending a sales conference.', 'He sent Ms. Correa an office supply request.', 'He wrote an article in the September newsletter.', 'He will be moving to another company location.', 'D', 'Gửi: Đội ngũ bán hàng

Từ: Laura Correa

Ngày: 5 tháng 10

Chủ đề: Cập nhật

Thân gửi cả đội,

Như đã thông báo trong bản tin tháng 9 của Brighter Sails, hiệu suất của chúng ta đã duy trì ở mức mạnh mẽ trong năm nay. Đây là một thành tích mà tất cả chúng ta có thể tự hào. Hãy dành chút thời gian để chúc mừng lẫn nhau. Chúng ta sẽ tiếp tục mơ về những kế hoạch mới và thú vị cho tương lai!

Trong một tin tức khác, Jasen Norton sẽ chuyển đến trụ sở chính ở Kingston của chúng ta vào tháng tới. Chúng tôi rất buồn khi mất đi ông Norton, nhưng chúng tôi biết ơn và ghi nhận công việc xuất sắc của ông và chúc ông tiếp tục thành công trong vai trò mới.

Sẽ có một bữa tiệc trưa chia tay ông Norton vào ngày 28 tháng 10 lúc 1:00 chiều tại phòng họp tầng hai. Hãy mang theo sự vui vẻ và có lẽ là một câu chuyện để chia sẻ. Công ty sẽ cung cấp bữa trưa, bánh ngọt và đồ trang trí. Hãy cho tôi biết trước ngày 12 tháng 10 liệu bạn có thể tham gia hay không.

Trân trọng,

Laura Correa, Quản lý bán hàng

Brighter Sails Ltd.', '', '', '9d1192d0-16f0-4c5b-981d-29d0bc5762a0', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('9a709999-97a5-4dea-9e0a-3461544ac57c', 'toeic-test-01', 152, 7, 'reading', 'What does Ms. Correa ask members of the sales team to do?', 'Send her stories for a newsletter', 'Give her names of potential new hires', 'Inform her of plans to attend an event', 'Help her decorate the office', 'C', 'Gửi: Đội ngũ bán hàng

Từ: Laura Correa

Ngày: 5 tháng 10

Chủ đề: Cập nhật

Thân gửi cả đội,

Như đã thông báo trong bản tin tháng 9 của Brighter Sails, hiệu suất của chúng ta đã duy trì ở mức mạnh mẽ trong năm nay. Đây là một thành tích mà tất cả chúng ta có thể tự hào. Hãy dành chút thời gian để chúc mừng lẫn nhau. Chúng ta sẽ tiếp tục mơ về những kế hoạch mới và thú vị cho tương lai!

Trong một tin tức khác, Jasen Norton sẽ chuyển đến trụ sở chính ở Kingston của chúng ta vào tháng tới. Chúng tôi rất buồn khi mất đi ông Norton, nhưng chúng tôi biết ơn và ghi nhận công việc xuất sắc của ông và chúc ông tiếp tục thành công trong vai trò mới.

Sẽ có một bữa tiệc trưa chia tay ông Norton vào ngày 28 tháng 10 lúc 1:00 chiều tại phòng họp tầng hai. Hãy mang theo sự vui vẻ và có lẽ là một câu chuyện để chia sẻ. Công ty sẽ cung cấp bữa trưa, bánh ngọt và đồ trang trí. Hãy cho tôi biết trước ngày 12 tháng 10 liệu bạn có thể tham gia hay không.

Trân trọng,

Laura Correa, Quản lý bán hàng

Brighter Sails Ltd.', '', '', '9d1192d0-16f0-4c5b-981d-29d0bc5762a0', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('9811dbf0-f4b3-4e55-bee9-149ea242cd56', 'toeic-test-01', 153, 7, 'reading', 'What is the purpose of the article?', 'To report on beach conditions', 'To announce a business reopening', 'To promote a movie premiere', 'To advertise a new restaurant', 'B', 'BEACHVILLE (24 tháng 2) — Cư dân và khách du lịch tại Beachville có lý do chính đáng để ăn mừng. Rạp hát Crown Coastal 40 năm tuổi dự kiến sẽ mở cửa trở lại vào tháng 6. Nhiều người đã đau buồn khi những chủ sở hữu rạp hát trước đó quyết định đóng cửa địa điểm này hơn một năm trước, với lý do chi phí cải tạo cần thiết. May mắn thay, rạp hát đã có những chủ sở hữu mới, những người đã dành cả năm qua để cập nhật nội thất và hệ thống máy chiếu.

Christine Lafferty cho biết cô và người bạn thời thơ ấu Morgan Flanagan đã dành rất nhiều thời gian tại rạp hát trong khi lớn lên. “Đi xem phim là việc nên làm vào một ngày mưa ở một thị trấn ven biển. Chúng tôi rất tiếc khi thấy nó đóng cửa.” Đôi bạn này, những người cũng sở hữu nhà hàng Blue Bay Bistro nổi tiếng, đã quyết định mua lại rạp hát và thực hiện các sửa chữa cần thiết để duy trì nó như một doanh nghiệp thịnh vượng. Để biết thêm thông tin về rạp hát và các sự kiện sắp tới, hãy truy cập www.crowncoastaltheater.com.', '', '', 'ee0c5f51-0ca3-4ae4-947d-6cd444dd186c', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('e857be4b-f784-44b3-89a9-6d6776caf041', 'toeic-test-01', 154, 7, 'reading', 'Who is Ms. Flanagan?', 'A town council member', 'An event coordinator', 'Ms. Lafferty’s business partner', 'The writer of the article', 'C', 'BEACHVILLE (24 tháng 2) — Cư dân và khách du lịch tại Beachville có lý do chính đáng để ăn mừng. Rạp hát Crown Coastal 40 năm tuổi dự kiến sẽ mở cửa trở lại vào tháng 6. Nhiều người đã đau buồn khi những chủ sở hữu rạp hát trước đó quyết định đóng cửa địa điểm này hơn một năm trước, với lý do chi phí cải tạo cần thiết. May mắn thay, rạp hát đã có những chủ sở hữu mới, những người đã dành cả năm qua để cập nhật nội thất và hệ thống máy chiếu.

Christine Lafferty cho biết cô và người bạn thời thơ ấu Morgan Flanagan đã dành rất nhiều thời gian tại rạp hát trong khi lớn lên. “Đi xem phim là việc nên làm vào một ngày mưa ở một thị trấn ven biển. Chúng tôi rất tiếc khi thấy nó đóng cửa.” Đôi bạn này, những người cũng sở hữu nhà hàng Blue Bay Bistro nổi tiếng, đã quyết định mua lại rạp hát và thực hiện các sửa chữa cần thiết để duy trì nó như một doanh nghiệp thịnh vượng. Để biết thêm thông tin về rạp hát và các sự kiện sắp tới, hãy truy cập www.crowncoastaltheater.com.', '', '', 'ee0c5f51-0ca3-4ae4-947d-6cd444dd186c', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('ab9a4a2a-4bb2-4a5f-b26f-f84899862246', 'toeic-test-01', 155, 7, 'reading', 'What is the purpose of the e-mail?', 'To request payment', 'To provide operating instructions', 'To advertise a new product', 'To offer a substitute item', 'D', 'Gửi: Randi Longfellow

Từ: Deon Welman

Ngày: 27 tháng 3

Chủ đề: Mẫu Makatasi METX-33948

Thân gửi cô Longfellow,

Cảm ơn cô đã đặt mua Kính thiên văn khúc xạ ba lớp Makatasi ETX, mẫu METX-33948. Thật không may, mặt hàng cô yêu cầu hiện đang hết hàng. — [1] —. Nếu cô không muốn chờ đợi, chúng tôi có một chiếc kính thiên văn tương tự do một nhà sản xuất khác chế tạo, Belter Telescopes. Giống như mẫu Makatasi mà cô đã đặt, Belter BTR-1483 có khẩu độ 120 mm và loa che nắng có thể thu vào. — [2] —. Ngoài ra, tất cả các kính thiên văn Belter đều bao gồm một bao đựng có đệm lót. Chiếc Belter BTR-1483 có giá thấp hơn 200 đô la so với chiếc Makatasi METX-33948.

Nếu cô muốn điều chỉnh đơn hàng của mình, chỉ cần trả lời email này trong vòng 48 giờ hoặc truy cập trang web của chúng tôi để trò chuyện với đại diện tại http://www.skyviewscopes.com.au. Sau đó, chúng tôi sẽ thay đổi đơn hàng của cô, hoàn trả 200 đô la vào thẻ tín dụng của cô và vận chuyển kính thiên văn mới của cô qua đêm mà không tính thêm phí. — [3] —. Nếu không, chúng tôi sẽ thông báo cho cô khi mẫu Makatasi METX-33948 có hàng trở lại và cung cấp thông tin giao hàng tại thời điểm đó. — [4] —.

Trân trọng,

Deon Welman

Đại diện bán hàng, Skyview Scopes', '', '', 'd1ae535c-7b7f-4316-8c30-8f9467351137', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('16ca5e6d-91c8-444d-a090-d1bc88563068', 'toeic-test-01', 156, 7, 'reading', 'What is mentioned about the Belter BTR-1483 telescope?', 'It can only be ordered online.', 'It will ship directly from the manufacturer.', 'It includes a protective case.', 'It is the most expensive telescope of its type.', 'C', 'Gửi: Randi Longfellow

Từ: Deon Welman

Ngày: 27 tháng 3

Chủ đề: Mẫu Makatasi METX-33948

Thân gửi cô Longfellow,

Cảm ơn cô đã đặt mua Kính thiên văn khúc xạ ba lớp Makatasi ETX, mẫu METX-33948. Thật không may, mặt hàng cô yêu cầu hiện đang hết hàng. — [1] —. Nếu cô không muốn chờ đợi, chúng tôi có một chiếc kính thiên văn tương tự do một nhà sản xuất khác chế tạo, Belter Telescopes. Giống như mẫu Makatasi mà cô đã đặt, Belter BTR-1483 có khẩu độ 120 mm và loa che nắng có thể thu vào. — [2] —. Ngoài ra, tất cả các kính thiên văn Belter đều bao gồm một bao đựng có đệm lót. Chiếc Belter BTR-1483 có giá thấp hơn 200 đô la so với chiếc Makatasi METX-33948.

Nếu cô muốn điều chỉnh đơn hàng của mình, chỉ cần trả lời email này trong vòng 48 giờ hoặc truy cập trang web của chúng tôi để trò chuyện với đại diện tại http://www.skyviewscopes.com.au. Sau đó, chúng tôi sẽ thay đổi đơn hàng của cô, hoàn trả 200 đô la vào thẻ tín dụng của cô và vận chuyển kính thiên văn mới của cô qua đêm mà không tính thêm phí. — [3] —. Nếu không, chúng tôi sẽ thông báo cho cô khi mẫu Makatasi METX-33948 có hàng trở lại và cung cấp thông tin giao hàng tại thời điểm đó. — [4] —.

Trân trọng,

Deon Welman

Đại diện bán hàng, Skyview Scopes', '', '', 'd1ae535c-7b7f-4316-8c30-8f9467351137', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('d403dc76-b93a-46db-9244-223ba0c240fb', 'toeic-test-01', 157, 7, 'reading', 'In which of the positions marked [1], [2], [3], and [4] does the following sentence best belong? “You can see a full list of specifications on our Web site.”', '[1]', '[2]', '[3]', '[4]', 'B', 'Gửi: Randi Longfellow

Từ: Deon Welman

Ngày: 27 tháng 3

Chủ đề: Mẫu Makatasi METX-33948

Thân gửi cô Longfellow,

Cảm ơn cô đã đặt mua Kính thiên văn khúc xạ ba lớp Makatasi ETX, mẫu METX-33948. Thật không may, mặt hàng cô yêu cầu hiện đang hết hàng. — [1] —. Nếu cô không muốn chờ đợi, chúng tôi có một chiếc kính thiên văn tương tự do một nhà sản xuất khác chế tạo, Belter Telescopes. Giống như mẫu Makatasi mà cô đã đặt, Belter BTR-1483 có khẩu độ 120 mm và loa che nắng có thể thu vào. — [2] —. Ngoài ra, tất cả các kính thiên văn Belter đều bao gồm một bao đựng có đệm lót. Chiếc Belter BTR-1483 có giá thấp hơn 200 đô la so với chiếc Makatasi METX-33948.

Nếu cô muốn điều chỉnh đơn hàng của mình, chỉ cần trả lời email này trong vòng 48 giờ hoặc truy cập trang web của chúng tôi để trò chuyện với đại diện tại http://www.skyviewscopes.com.au. Sau đó, chúng tôi sẽ thay đổi đơn hàng của cô, hoàn trả 200 đô la vào thẻ tín dụng của cô và vận chuyển kính thiên văn mới của cô qua đêm mà không tính thêm phí. — [3] —. Nếu không, chúng tôi sẽ thông báo cho cô khi mẫu Makatasi METX-33948 có hàng trở lại và cung cấp thông tin giao hàng tại thời điểm đó. — [4] —.

Trân trọng,

Deon Welman

Đại diện bán hàng, Skyview Scopes', '', '', 'd1ae535c-7b7f-4316-8c30-8f9467351137', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('281fa859-ed0a-476a-94f9-f67d4fea5467', 'toeic-test-01', 158, 7, 'reading', 'What is one purpose of the e-mail?', 'To explain how to use a software program', 'To request Ms. Myo’s assistance with a project', 'To introduce a new staff member', 'To indicate that Mr. Delpit is out of the office', 'D', 'Xin chào,

Cảm ơn email của bạn. Tôi hiện đang đi nghỉ và sẽ quay lại văn phòng vào ngày 15 tháng 3. Tôi sẽ phản hồi tin nhắn của bạn sớm nhất có thể sau khi tôi quay lại.

Nếu bạn cần hỗ trợ chung trong thời gian tôi vắng mặt hoặc có thắc mắc về vị trí đang tuyển dụng trong bộ phận bán hàng của chúng tôi, vui lòng liên hệ với trợ lý của tôi, Sita Viswan, tại số 04 555 0193 hoặc sviswan@hamerkoptech.co.nz. Đối với các câu hỏi về các sản phẩm phần mềm cụ thể của Hamerkoptech, hãy liên hệ với bộ phận dịch vụ khách hàng tại customerservice@hamerkoptech.co.nz.

Ngoài ra, tôi rất vui mừng thông báo rằng chương trình phần mềm thiết kế đồ họa mới của chúng tôi sẽ được phát hành vào ngày 2 tháng 4. Bạn có thể đọc thêm về chương trình tại trang web mới được thiết kế lại của Hamerkoptech, www.hamerkoptech.co.nz. Tại đó, bạn cũng có thể đăng ký nhận bản tin hàng tuần của chúng tôi bằng cách làm theo hướng dẫn trên trang chủ.

Trân trọng,

Jan Delpit', '', '', 'd5086d20-42ac-4185-97cf-3bae12c1d680', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('6e98dc91-e91e-4de0-80d9-42a7cfe2cfeb', 'toeic-test-01', 159, 7, 'reading', 'What will happen on April 2?', 'A job opening will be filled.', 'A product will be launched.', 'A client meeting will take place.', 'A Web site redesign will begin.', 'B', 'Xin chào,

Cảm ơn email của bạn. Tôi hiện đang đi nghỉ và sẽ quay lại văn phòng vào ngày 15 tháng 3. Tôi sẽ phản hồi tin nhắn của bạn sớm nhất có thể sau khi tôi quay lại.

Nếu bạn cần hỗ trợ chung trong thời gian tôi vắng mặt hoặc có thắc mắc về vị trí đang tuyển dụng trong bộ phận bán hàng của chúng tôi, vui lòng liên hệ với trợ lý của tôi, Sita Viswan, tại số 04 555 0193 hoặc sviswan@hamerkoptech.co.nz. Đối với các câu hỏi về các sản phẩm phần mềm cụ thể của Hamerkoptech, hãy liên hệ với bộ phận dịch vụ khách hàng tại customerservice@hamerkoptech.co.nz.

Ngoài ra, tôi rất vui mừng thông báo rằng chương trình phần mềm thiết kế đồ họa mới của chúng tôi sẽ được phát hành vào ngày 2 tháng 4. Bạn có thể đọc thêm về chương trình tại trang web mới được thiết kế lại của Hamerkoptech, www.hamerkoptech.co.nz. Tại đó, bạn cũng có thể đăng ký nhận bản tin hàng tuần của chúng tôi bằng cách làm theo hướng dẫn trên trang chủ.

Trân trọng,

Jan Delpit', '', '', 'd5086d20-42ac-4185-97cf-3bae12c1d680', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('0ca82864-2091-478a-afd7-308727d789e9', 'toeic-test-01', 160, 7, 'reading', 'How can people subscribe to a newsletter?', 'By calling Ms. Viswan', 'By replying to Mr. Delpit’s e-mail', 'By visiting Hamerkoptech’s Web site', 'By contacting the customer service department', 'C', 'Xin chào,

Cảm ơn email của bạn. Tôi hiện đang đi nghỉ và sẽ quay lại văn phòng vào ngày 15 tháng 3. Tôi sẽ phản hồi tin nhắn của bạn sớm nhất có thể sau khi tôi quay lại.

Nếu bạn cần hỗ trợ chung trong thời gian tôi vắng mặt hoặc có thắc mắc về vị trí đang tuyển dụng trong bộ phận bán hàng của chúng tôi, vui lòng liên hệ với trợ lý của tôi, Sita Viswan, tại số 04 555 0193 hoặc sviswan@hamerkoptech.co.nz. Đối với các câu hỏi về các sản phẩm phần mềm cụ thể của Hamerkoptech, hãy liên hệ với bộ phận dịch vụ khách hàng tại customerservice@hamerkoptech.co.nz.

Ngoài ra, tôi rất vui mừng thông báo rằng chương trình phần mềm thiết kế đồ họa mới của chúng tôi sẽ được phát hành vào ngày 2 tháng 4. Bạn có thể đọc thêm về chương trình tại trang web mới được thiết kế lại của Hamerkoptech, www.hamerkoptech.co.nz. Tại đó, bạn cũng có thể đăng ký nhận bản tin hàng tuần của chúng tôi bằng cách làm theo hướng dẫn trên trang chủ.

Trân trọng,

Jan Delpit', '', '', 'd5086d20-42ac-4185-97cf-3bae12c1d680', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('96377b9e-24da-4e53-8e2f-f8a527eacd4f', 'toeic-test-01', 161, 7, 'reading', 'What is one purpose of the article?', 'To discuss a cooking technique', 'To report on a corporate merger', 'To announce a new product line', 'To introduce a recently hired executive', 'C', 'VANCOUVER (2 tháng 8) — Vimalo Brands, công ty hàng tiêu dùng lớn chuyên tiếp thị các sản phẩm hỗ trợ dinh dưỡng và chăm sóc cá nhân phổ biến, bao gồm đồ uống ăn sáng Powerburst cùng xà phòng và sữa dưỡng thể Honeysoft, sẽ sớm cung cấp một điều mới mẻ cho khách hàng của mình: thực phẩm đông lạnh. "Dòng sản phẩm Nutridinna mới của chúng tôi không chỉ đơn thuần là về sự tiện lợi," Giám đốc điều hành Danitza Martens đã phát biểu trong một cuộc họp báo diễn ra sáng nay. "Thực phẩm đông lạnh không phải là một khái niệm mới, nhưng phương pháp cấp đông nhanh các loại nông sản và thịt tươi sống của chúng tôi đảm bảo rằng sản phẩm vẫn giữ được cấu trúc và hương vị cũng như các vitamin và khoáng chất có lợi cho sức khỏe. Giờ đây, khách hàng của chúng tôi có thể tận hưởng sự tiện lợi của thực phẩm đông lạnh mà không phải đánh đổi chất lượng."

Vimalo Brands đã hợp tác với các trang trại ở khu vực Vancouver để thu mua nông sản và thịt cho dòng sản phẩm Nutridinna. "Bằng cách duy trì các hoạt động tại địa phương, chúng tôi tránh được việc chậm trễ trong vận chuyển và có thể cấp đông nhanh các loại rau củ vừa thu hoạch ở độ chín cao nhất," bà Martens nói. "Khách hàng của chúng tôi còn được hưởng lợi nhiều hơn, vì sản phẩm của chúng tôi có thể được bảo quản trong ngăn đông lên đến sáu tháng." Thực phẩm Nutridinna sẽ có mặt tại các siêu thị bắt đầu từ tháng 11. Cá đông lạnh và các loại hải sản khác sẽ được bổ sung vào đầu năm tới.', '', '', '05b0bab3-b74b-4bae-874a-ff86cc08c172', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('494da2e8-d6cd-4f2e-8d58-a2959daa53d4', 'toeic-test-01', 162, 7, 'reading', 'The word “just” in paragraph 1, line 4, is closest in meaning to', 'recently', 'exactly', 'slightly', 'only', 'D', 'VANCOUVER (2 tháng 8) — Vimalo Brands, công ty hàng tiêu dùng lớn chuyên tiếp thị các sản phẩm hỗ trợ dinh dưỡng và chăm sóc cá nhân phổ biến, bao gồm đồ uống ăn sáng Powerburst cùng xà phòng và sữa dưỡng thể Honeysoft, sẽ sớm cung cấp một điều mới mẻ cho khách hàng của mình: thực phẩm đông lạnh. "Dòng sản phẩm Nutridinna mới của chúng tôi không chỉ đơn thuần là về sự tiện lợi," Giám đốc điều hành Danitza Martens đã phát biểu trong một cuộc họp báo diễn ra sáng nay. "Thực phẩm đông lạnh không phải là một khái niệm mới, nhưng phương pháp cấp đông nhanh các loại nông sản và thịt tươi sống của chúng tôi đảm bảo rằng sản phẩm vẫn giữ được cấu trúc và hương vị cũng như các vitamin và khoáng chất có lợi cho sức khỏe. Giờ đây, khách hàng của chúng tôi có thể tận hưởng sự tiện lợi của thực phẩm đông lạnh mà không phải đánh đổi chất lượng."

Vimalo Brands đã hợp tác với các trang trại ở khu vực Vancouver để thu mua nông sản và thịt cho dòng sản phẩm Nutridinna. "Bằng cách duy trì các hoạt động tại địa phương, chúng tôi tránh được việc chậm trễ trong vận chuyển và có thể cấp đông nhanh các loại rau củ vừa thu hoạch ở độ chín cao nhất," bà Martens nói. "Khách hàng của chúng tôi còn được hưởng lợi nhiều hơn, vì sản phẩm của chúng tôi có thể được bảo quản trong ngăn đông lên đến sáu tháng." Thực phẩm Nutridinna sẽ có mặt tại các siêu thị bắt đầu từ tháng 11. Cá đông lạnh và các loại hải sản khác sẽ được bổ sung vào đầu năm tới.', '', '', '05b0bab3-b74b-4bae-874a-ff86cc08c172', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('2091255d-09b4-42f4-8bf7-54c06c5ff100', 'toeic-test-01', 163, 7, 'reading', 'What does Ms. Martens suggest about flash-frozen food?', 'It is less expensive than fresh food.', 'It is as nutritious as fresh food.', 'It is as easy to ship as fresh food.', 'It is less flavorful than fresh food.', 'B', 'VANCOUVER (2 tháng 8) — Vimalo Brands, công ty hàng tiêu dùng lớn chuyên tiếp thị các sản phẩm hỗ trợ dinh dưỡng và chăm sóc cá nhân phổ biến, bao gồm đồ uống ăn sáng Powerburst cùng xà phòng và sữa dưỡng thể Honeysoft, sẽ sớm cung cấp một điều mới mẻ cho khách hàng của mình: thực phẩm đông lạnh. "Dòng sản phẩm Nutridinna mới của chúng tôi không chỉ đơn thuần là về sự tiện lợi," Giám đốc điều hành Danitza Martens đã phát biểu trong một cuộc họp báo diễn ra sáng nay. "Thực phẩm đông lạnh không phải là một khái niệm mới, nhưng phương pháp cấp đông nhanh các loại nông sản và thịt tươi sống của chúng tôi đảm bảo rằng sản phẩm vẫn giữ được cấu trúc và hương vị cũng như các vitamin và khoáng chất có lợi cho sức khỏe. Giờ đây, khách hàng của chúng tôi có thể tận hưởng sự tiện lợi của thực phẩm đông lạnh mà không phải đánh đổi chất lượng."

Vimalo Brands đã hợp tác với các trang trại ở khu vực Vancouver để thu mua nông sản và thịt cho dòng sản phẩm Nutridinna. "Bằng cách duy trì các hoạt động tại địa phương, chúng tôi tránh được việc chậm trễ trong vận chuyển và có thể cấp đông nhanh các loại rau củ vừa thu hoạch ở độ chín cao nhất," bà Martens nói. "Khách hàng của chúng tôi còn được hưởng lợi nhiều hơn, vì sản phẩm của chúng tôi có thể được bảo quản trong ngăn đông lên đến sáu tháng." Thực phẩm Nutridinna sẽ có mặt tại các siêu thị bắt đầu từ tháng 11. Cá đông lạnh và các loại hải sản khác sẽ được bổ sung vào đầu năm tới.', '', '', '05b0bab3-b74b-4bae-874a-ff86cc08c172', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('ffeaefdc-c370-4f38-9e44-275da378bb0b', 'toeic-test-01', 164, 7, 'reading', 'According to the advertisement, who most likely is Ms. Navani?', 'A Karning Creative Designs client', 'A business owner', 'A photographer', 'A real estate agent', 'B', 'Bạn đã sẵn sàng làm việc chăm chỉ như một phần của đội ngũ gồm những cá nhân cùng chí hướng chưa? Bạn có sẵn lòng vận dụng học vấn, kinh nghiệm và trí tưởng tượng của mình vào những việc hữu ích không? Nếu có, thì chúng tôi có công việc dành cho bạn. Karning Creative Designs đang mở rộng, và cùng với sự thành công của chúng tôi là cơ hội của bạn.

Karning Creative Designs bắt đầu từ mười năm trước như một hoạt động kinh doanh gồm hai người được thiết lập tại nhà của CEO và người sáng lập hiện tại của chúng tôi, Shirin Navani. Hiện tọa lạc tại một căn hộ gác lửng tuyệt đẹp ở trung tâm thành phố Hollinson, công ty chúng tôi hiện đang thuê 25 nhân viên toàn thời gian. Tại Karning, chúng tôi thiết kế các tập gấp quảng cáo bằng giấy, danh mục sản phẩm, quảng cáo và áp phích cho khách hàng. Chúng tôi hiện đang tìm kiếm các nhà thiết kế và nghệ sĩ có năng lực, những người sẽ tỏa sáng trong một môi trường hợp tác, tốc độ nhanh.

Ứng viên lý tưởng

* Có bằng cấp về thiết kế, quảng cáo hoặc nghệ thuật đồ họa—mặc dù vài năm kinh nghiệm trực tiếp có thể thay thế cho bằng cấp

* Thể hiện khả năng làm việc chặt chẽ với các đồng nghiệp

* Duy trì con mắt phản biện về chi tiết và sự chính xác

* Luôn đáp ứng đúng thời hạn và có thể phát triển dưới áp lực

Kinh nghiệm thiết kế đồ họa hoặc các kinh nghiệm liên quan là một điểm cộng nhưng không bắt buộc nghiêm ngặt.

Nếu bạn đã sẵn sàng tham gia đội ngũ của chúng tôi, chúng tôi muốn gặp bạn! Hãy liên hệ với Salvador Tomassin tại số 608-555-0144 để biết thêm chi tiết. Tất cả hồ sơ ứng tuyển phải được nhận trước ngày 31 tháng 3.', '', '', '76380eea-c341-4ded-841f-0064fb8d8309', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('088af65f-ac61-430e-b693-826b2d6efca2', 'toeic-test-01', 165, 7, 'reading', 'What is indicated about Karning Creative Designs?', 'Its primary focus is Web design.', 'It initially employed two people.', 'It was founded by Mr. Tomassin.', 'Its staff are permitted to work from home.', 'B', 'Bạn đã sẵn sàng làm việc chăm chỉ như một phần của đội ngũ gồm những cá nhân cùng chí hướng chưa? Bạn có sẵn lòng vận dụng học vấn, kinh nghiệm và trí tưởng tượng của mình vào những việc hữu ích không? Nếu có, thì chúng tôi có công việc dành cho bạn. Karning Creative Designs đang mở rộng, và cùng với sự thành công của chúng tôi là cơ hội của bạn.

Karning Creative Designs bắt đầu từ mười năm trước như một hoạt động kinh doanh gồm hai người được thiết lập tại nhà của CEO và người sáng lập hiện tại của chúng tôi, Shirin Navani. Hiện tọa lạc tại một căn hộ gác lửng tuyệt đẹp ở trung tâm thành phố Hollinson, công ty chúng tôi hiện đang thuê 25 nhân viên toàn thời gian. Tại Karning, chúng tôi thiết kế các tập gấp quảng cáo bằng giấy, danh mục sản phẩm, quảng cáo và áp phích cho khách hàng. Chúng tôi hiện đang tìm kiếm các nhà thiết kế và nghệ sĩ có năng lực, những người sẽ tỏa sáng trong một môi trường hợp tác, tốc độ nhanh.

Ứng viên lý tưởng

* Có bằng cấp về thiết kế, quảng cáo hoặc nghệ thuật đồ họa—mặc dù vài năm kinh nghiệm trực tiếp có thể thay thế cho bằng cấp

* Thể hiện khả năng làm việc chặt chẽ với các đồng nghiệp

* Duy trì con mắt phản biện về chi tiết và sự chính xác

* Luôn đáp ứng đúng thời hạn và có thể phát triển dưới áp lực

Kinh nghiệm thiết kế đồ họa hoặc các kinh nghiệm liên quan là một điểm cộng nhưng không bắt buộc nghiêm ngặt.

Nếu bạn đã sẵn sàng tham gia đội ngũ của chúng tôi, chúng tôi muốn gặp bạn! Hãy liên hệ với Salvador Tomassin tại số 608-555-0144 để biết thêm chi tiết. Tất cả hồ sơ ứng tuyển phải được nhận trước ngày 31 tháng 3.', '', '', '76380eea-c341-4ded-841f-0064fb8d8309', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('e90ddac1-5b01-4462-bf69-419c99d3d989', 'toeic-test-01', 166, 7, 'reading', 'What is required of job applicants?', 'Skill in working with others', 'Previous design experience', 'A willingness to work on weekends', 'An ability to use certain software applications', 'A', 'Bạn đã sẵn sàng làm việc chăm chỉ như một phần của đội ngũ gồm những cá nhân cùng chí hướng chưa? Bạn có sẵn lòng vận dụng học vấn, kinh nghiệm và trí tưởng tượng của mình vào những việc hữu ích không? Nếu có, thì chúng tôi có công việc dành cho bạn. Karning Creative Designs đang mở rộng, và cùng với sự thành công của chúng tôi là cơ hội của bạn.

Karning Creative Designs bắt đầu từ mười năm trước như một hoạt động kinh doanh gồm hai người được thiết lập tại nhà của CEO và người sáng lập hiện tại của chúng tôi, Shirin Navani. Hiện tọa lạc tại một căn hộ gác lửng tuyệt đẹp ở trung tâm thành phố Hollinson, công ty chúng tôi hiện đang thuê 25 nhân viên toàn thời gian. Tại Karning, chúng tôi thiết kế các tập gấp quảng cáo bằng giấy, danh mục sản phẩm, quảng cáo và áp phích cho khách hàng. Chúng tôi hiện đang tìm kiếm các nhà thiết kế và nghệ sĩ có năng lực, những người sẽ tỏa sáng trong một môi trường hợp tác, tốc độ nhanh.

Ứng viên lý tưởng

* Có bằng cấp về thiết kế, quảng cáo hoặc nghệ thuật đồ họa—mặc dù vài năm kinh nghiệm trực tiếp có thể thay thế cho bằng cấp

* Thể hiện khả năng làm việc chặt chẽ với các đồng nghiệp

* Duy trì con mắt phản biện về chi tiết và sự chính xác

* Luôn đáp ứng đúng thời hạn và có thể phát triển dưới áp lực

Kinh nghiệm thiết kế đồ họa hoặc các kinh nghiệm liên quan là một điểm cộng nhưng không bắt buộc nghiêm ngặt.

Nếu bạn đã sẵn sàng tham gia đội ngũ của chúng tôi, chúng tôi muốn gặp bạn! Hãy liên hệ với Salvador Tomassin tại số 608-555-0144 để biết thêm chi tiết. Tất cả hồ sơ ứng tuyển phải được nhận trước ngày 31 tháng 3.', '', '', '76380eea-c341-4ded-841f-0064fb8d8309', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('f4c0211f-2d91-4ede-a783-fcbd1383dbe2', 'toeic-test-01', 167, 7, 'reading', 'What will happen on March 31?', 'A project will begin.', 'A deadline will occur.', 'A graphic designer will relocate.', 'An application form will be made available.', 'B', 'Bạn đã sẵn sàng làm việc chăm chỉ như một phần của đội ngũ gồm những cá nhân cùng chí hướng chưa? Bạn có sẵn lòng vận dụng học vấn, kinh nghiệm và trí tưởng tượng của mình vào những việc hữu ích không? Nếu có, thì chúng tôi có công việc dành cho bạn. Karning Creative Designs đang mở rộng, và cùng với sự thành công của chúng tôi là cơ hội của bạn.

Karning Creative Designs bắt đầu từ mười năm trước như một hoạt động kinh doanh gồm hai người được thiết lập tại nhà của CEO và người sáng lập hiện tại của chúng tôi, Shirin Navani. Hiện tọa lạc tại một căn hộ gác lửng tuyệt đẹp ở trung tâm thành phố Hollinson, công ty chúng tôi hiện đang thuê 25 nhân viên toàn thời gian. Tại Karning, chúng tôi thiết kế các tập gấp quảng cáo bằng giấy, danh mục sản phẩm, quảng cáo và áp phích cho khách hàng. Chúng tôi hiện đang tìm kiếm các nhà thiết kế và nghệ sĩ có năng lực, những người sẽ tỏa sáng trong một môi trường hợp tác, tốc độ nhanh.

Ứng viên lý tưởng

* Có bằng cấp về thiết kế, quảng cáo hoặc nghệ thuật đồ họa—mặc dù vài năm kinh nghiệm trực tiếp có thể thay thế cho bằng cấp

* Thể hiện khả năng làm việc chặt chẽ với các đồng nghiệp

* Duy trì con mắt phản biện về chi tiết và sự chính xác

* Luôn đáp ứng đúng thời hạn và có thể phát triển dưới áp lực

Kinh nghiệm thiết kế đồ họa hoặc các kinh nghiệm liên quan là một điểm cộng nhưng không bắt buộc nghiêm ngặt.

Nếu bạn đã sẵn sàng tham gia đội ngũ của chúng tôi, chúng tôi muốn gặp bạn! Hãy liên hệ với Salvador Tomassin tại số 608-555-0144 để biết thêm chi tiết. Tất cả hồ sơ ứng tuyển phải được nhận trước ngày 31 tháng 3.', '', '', '76380eea-c341-4ded-841f-0064fb8d8309', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('2cc400cb-3668-4f25-b474-4dd434c1de2d', 'toeic-test-01', 168, 7, 'reading', 'What does the article mention about Marco’s Italian Restaurant?', 'It is the oldest restaurant in New Haven.', 'It is looking for a chef who can cook traditional dishes.', 'It needed major renovations.', 'It opened in a new location.', 'C', 'NEW HAVEN (Ngày 1 tháng 6) — Nhà hàng Ý của Marco trên đường Frontage sẽ mở cửa trở lại vào cuối tháng 6. Nó đã đóng cửa ba tháng trước sau khi một vụ rò rỉ nước gây ra thiệt hại trên diện rộng cho nhà bếp. Một lượng công việc đáng kể cần phải được thực hiện ở khu vực bếp và khu vực ăn uống. — [1] —. Nhà hàng sẽ có sức chứa cho các nhóm khách lớn hơn khi mở cửa trở lại.

Trong ba tháng qua, nhiều nhân viên của nhà hàng đã có thể làm việc tại Chợ Ý của Marco, nằm ở phía đối diện của con phố. — [2] —. "Vụ rò rỉ xảy ra ngay trước khi mùa cao điểm của chợ bắt đầu," Tom Marco, chủ sở hữu của cả hai cơ sở kinh doanh, cho biết. "Chúng tôi cần bổ sung nhân viên ở đó tạm thời, và tôi rất vui khi vẫn duy trì được việc làm cho đội ngũ nhân viên nhà hàng của mình." Hầu hết những nhân viên đó hiện đã quay trở lại làm việc tại nhà hàng. — [3] —.

Ông Marco đã lên kế hoạch cho một buổi khai trương hoành tráng vào ngày 25 tháng 6. Khách mời sẽ được thưởng thức nhạc sống và thực đơn dùng thử mới. — [4] —. Việc đặt chỗ là bắt buộc cho ngày kỷ niệm và có thể được thực hiện bằng cách gọi số 203-555-0124. "Chúng tôi rất hào hứng khi có thể chế biến các món ăn truyền thống của mình và chào đón cộng đồng quay trở lại một lần nữa," ông Marco phát biểu.', '', '', 'afdda604-2c7e-49ed-b32e-6159e8994840', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('72d97b93-7223-4145-9eb6-51d6465f87f7', 'toeic-test-01', 169, 7, 'reading', 'What is indicated about Marco’s Italian Market?', 'It supplies ingredients to Marco’s Italian Restaurant.', 'It occasionally hires temporary workers.', 'It is scheduled to close in three months.', 'It is located next door to Marco’s Italian Restaurant.', 'B', 'NEW HAVEN (Ngày 1 tháng 6) — Nhà hàng Ý của Marco trên đường Frontage sẽ mở cửa trở lại vào cuối tháng 6. Nó đã đóng cửa ba tháng trước sau khi một vụ rò rỉ nước gây ra thiệt hại trên diện rộng cho nhà bếp. Một lượng công việc đáng kể cần phải được thực hiện ở khu vực bếp và khu vực ăn uống. — [1] —. Nhà hàng sẽ có sức chứa cho các nhóm khách lớn hơn khi mở cửa trở lại.

Trong ba tháng qua, nhiều nhân viên của nhà hàng đã có thể làm việc tại Chợ Ý của Marco, nằm ở phía đối diện của con phố. — [2] —. "Vụ rò rỉ xảy ra ngay trước khi mùa cao điểm của chợ bắt đầu," Tom Marco, chủ sở hữu của cả hai cơ sở kinh doanh, cho biết. "Chúng tôi cần bổ sung nhân viên ở đó tạm thời, và tôi rất vui khi vẫn duy trì được việc làm cho đội ngũ nhân viên nhà hàng của mình." Hầu hết những nhân viên đó hiện đã quay trở lại làm việc tại nhà hàng. — [3] —.

Ông Marco đã lên kế hoạch cho một buổi khai trương hoành tráng vào ngày 25 tháng 6. Khách mời sẽ được thưởng thức nhạc sống và thực đơn dùng thử mới. — [4] —. Việc đặt chỗ là bắt buộc cho ngày kỷ niệm và có thể được thực hiện bằng cách gọi số 203-555-0124. "Chúng tôi rất hào hứng khi có thể chế biến các món ăn truyền thống của mình và chào đón cộng đồng quay trở lại một lần nữa," ông Marco phát biểu.', '', '', 'afdda604-2c7e-49ed-b32e-6159e8994840', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('136c7d25-ea07-459b-8445-d7d2fd82ac4f', 'toeic-test-01', 170, 7, 'reading', 'What will happen during the event on June 25?', 'The restaurant will reduce its menu prices.', 'The restaurant will offer special menu items.', 'Mr. Marco will celebrate his retirement.', 'The New Haven business community will honor Mr. Marco.', 'B', 'NEW HAVEN (Ngày 1 tháng 6) — Nhà hàng Ý của Marco trên đường Frontage sẽ mở cửa trở lại vào cuối tháng 6. Nó đã đóng cửa ba tháng trước sau khi một vụ rò rỉ nước gây ra thiệt hại trên diện rộng cho nhà bếp. Một lượng công việc đáng kể cần phải được thực hiện ở khu vực bếp và khu vực ăn uống. — [1] —. Nhà hàng sẽ có sức chứa cho các nhóm khách lớn hơn khi mở cửa trở lại.

Trong ba tháng qua, nhiều nhân viên của nhà hàng đã có thể làm việc tại Chợ Ý của Marco, nằm ở phía đối diện của con phố. — [2] —. "Vụ rò rỉ xảy ra ngay trước khi mùa cao điểm của chợ bắt đầu," Tom Marco, chủ sở hữu của cả hai cơ sở kinh doanh, cho biết. "Chúng tôi cần bổ sung nhân viên ở đó tạm thời, và tôi rất vui khi vẫn duy trì được việc làm cho đội ngũ nhân viên nhà hàng của mình." Hầu hết những nhân viên đó hiện đã quay trở lại làm việc tại nhà hàng. — [3] —.

Ông Marco đã lên kế hoạch cho một buổi khai trương hoành tráng vào ngày 25 tháng 6. Khách mời sẽ được thưởng thức nhạc sống và thực đơn dùng thử mới. — [4] —. Việc đặt chỗ là bắt buộc cho ngày kỷ niệm và có thể được thực hiện bằng cách gọi số 203-555-0124. "Chúng tôi rất hào hứng khi có thể chế biến các món ăn truyền thống của mình và chào đón cộng đồng quay trở lại một lần nữa," ông Marco phát biểu.', '', '', 'afdda604-2c7e-49ed-b32e-6159e8994840', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('5fa35801-a43a-4371-9269-18eba9bf86f8', 'toeic-test-01', 171, 7, 'reading', 'In which of the positions marked [1], [2], [3], and [4] does the following sentence best belong? “During repairs, some additional dining space was added.”', '[1]', '[2]', '[3]', '[4]', 'A', 'NEW HAVEN (Ngày 1 tháng 6) — Nhà hàng Ý của Marco trên đường Frontage sẽ mở cửa trở lại vào cuối tháng 6. Nó đã đóng cửa ba tháng trước sau khi một vụ rò rỉ nước gây ra thiệt hại trên diện rộng cho nhà bếp. Một lượng công việc đáng kể cần phải được thực hiện ở khu vực bếp và khu vực ăn uống. — [1] —. Nhà hàng sẽ có sức chứa cho các nhóm khách lớn hơn khi mở cửa trở lại.

Trong ba tháng qua, nhiều nhân viên của nhà hàng đã có thể làm việc tại Chợ Ý của Marco, nằm ở phía đối diện của con phố. — [2] —. "Vụ rò rỉ xảy ra ngay trước khi mùa cao điểm của chợ bắt đầu," Tom Marco, chủ sở hữu của cả hai cơ sở kinh doanh, cho biết. "Chúng tôi cần bổ sung nhân viên ở đó tạm thời, và tôi rất vui khi vẫn duy trì được việc làm cho đội ngũ nhân viên nhà hàng của mình." Hầu hết những nhân viên đó hiện đã quay trở lại làm việc tại nhà hàng. — [3] —.

Ông Marco đã lên kế hoạch cho một buổi khai trương hoành tráng vào ngày 25 tháng 6. Khách mời sẽ được thưởng thức nhạc sống và thực đơn dùng thử mới. — [4] —. Việc đặt chỗ là bắt buộc cho ngày kỷ niệm và có thể được thực hiện bằng cách gọi số 203-555-0124. "Chúng tôi rất hào hứng khi có thể chế biến các món ăn truyền thống của mình và chào đón cộng đồng quay trở lại một lần nữa," ông Marco phát biểu.', '', '', 'afdda604-2c7e-49ed-b32e-6159e8994840', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('1fe4ec97-a664-4afa-917f-331fffc0410d', 'toeic-test-01', 172, 7, 'reading', 'Why did Ms. Barry begin an online chat with Mr. Kubelski?', 'To refer him to a different department', 'To decline an invitation', 'To issue an apology', 'To ask for clarification about a request', 'D', 'Marlys Barry (10:17 sáng)

Tôi là Barry từ bộ phận phân tích dữ liệu. Tôi có bao gồm đồng nghiệp của mình, cô Choi. Chúng tôi liên hệ với ông về yêu cầu dữ liệu địa chỉ email của tất cả các chủ tài khoản, được sắp xếp theo độ tuổi.

Alexander Kubelski (10:17 sáng)

Vâng, các bạn có thể hoàn thành yêu cầu sớm đến mức nào?

Marlys Barry (10:18 sáng)

Tôi có một câu hỏi cho ông trước. Ông có thực sự cần địa chỉ email của tất cả các chủ tài khoản không? Đó sẽ là một tệp rất lớn. Hay ông chỉ cần địa chỉ email của các chủ tài khoản trong một nhóm tuổi nhất định?

Alexander Kubelski (10:19 sáng)

Tôi hiểu ý cô rồi. Tôi muốn gửi email cho các chủ tài khoản từ 55 đến 65 tuổi để mời họ gặp chuyên gia lập kế hoạch hưu trí. Tôi có phải nộp mẫu yêu cầu dự án mới không?

Bora Choi (10:21 sáng)

Điều đó không cần thiết đâu, ông Kubelski. Chúng tôi có thể cập nhật mẫu yêu cầu hiện tại cho ông. Ông sẽ không muốn mất vị trí của mình trong hàng đợi đâu.

Alexander Kubelski (10:21 sáng)

Tuyệt vời, cảm ơn cô! Cô có thể gửi danh sách đó cho tôi ngay lập tức được không?

Marlys Barry (10:22 sáng)

Có một vài dự án đang xếp hàng trước dự án của ông.

Alexander Kubelski (10:23 sáng)

Tôi đã hy vọng gửi thư mời qua email vào ngày mai.

Marlys Barry (10:24 sáng)

Chúng tôi sẽ xử lý nó ngay khi có thể.', '', '', '5b16a09d-4c11-44bb-a1e9-f4b34c91efbf', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('dd7f73a7-3a9e-46ea-b5ee-fef0ab5a0b9b', 'toeic-test-01', 173, 7, 'reading', 'Who will receive an e-mail from Mr. Kubelski?', 'Account holders in one age-group', 'Data analysis team members', 'Financial planners', 'All Mr. Kubelski’s clients', 'A', 'Marlys Barry (10:17 sáng)

Tôi là Barry từ bộ phận phân tích dữ liệu. Tôi có bao gồm đồng nghiệp của mình, cô Choi. Chúng tôi liên hệ với ông về yêu cầu dữ liệu địa chỉ email của tất cả các chủ tài khoản, được sắp xếp theo độ tuổi.

Alexander Kubelski (10:17 sáng)

Vâng, các bạn có thể hoàn thành yêu cầu sớm đến mức nào?

Marlys Barry (10:18 sáng)

Tôi có một câu hỏi cho ông trước. Ông có thực sự cần địa chỉ email của tất cả các chủ tài khoản không? Đó sẽ là một tệp rất lớn. Hay ông chỉ cần địa chỉ email của các chủ tài khoản trong một nhóm tuổi nhất định?

Alexander Kubelski (10:19 sáng)

Tôi hiểu ý cô rồi. Tôi muốn gửi email cho các chủ tài khoản từ 55 đến 65 tuổi để mời họ gặp chuyên gia lập kế hoạch hưu trí. Tôi có phải nộp mẫu yêu cầu dự án mới không?

Bora Choi (10:21 sáng)

Điều đó không cần thiết đâu, ông Kubelski. Chúng tôi có thể cập nhật mẫu yêu cầu hiện tại cho ông. Ông sẽ không muốn mất vị trí của mình trong hàng đợi đâu.

Alexander Kubelski (10:21 sáng)

Tuyệt vời, cảm ơn cô! Cô có thể gửi danh sách đó cho tôi ngay lập tức được không?

Marlys Barry (10:22 sáng)

Có một vài dự án đang xếp hàng trước dự án của ông.

Alexander Kubelski (10:23 sáng)

Tôi đã hy vọng gửi thư mời qua email vào ngày mai.

Marlys Barry (10:24 sáng)

Chúng tôi sẽ xử lý nó ngay khi có thể.', '', '', '5b16a09d-4c11-44bb-a1e9-f4b34c91efbf', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('f241170a-95da-46c9-9e30-f5f01f08cc32', 'toeic-test-01', 174, 7, 'reading', 'What does Ms. Choi offer to do?', 'Write an e-mail', 'Make a change to a form', 'Open an account', 'Revise a policy', 'B', 'Marlys Barry (10:17 sáng)

Tôi là Barry từ bộ phận phân tích dữ liệu. Tôi có bao gồm đồng nghiệp của mình, cô Choi. Chúng tôi liên hệ với ông về yêu cầu dữ liệu địa chỉ email của tất cả các chủ tài khoản, được sắp xếp theo độ tuổi.

Alexander Kubelski (10:17 sáng)

Vâng, các bạn có thể hoàn thành yêu cầu sớm đến mức nào?

Marlys Barry (10:18 sáng)

Tôi có một câu hỏi cho ông trước. Ông có thực sự cần địa chỉ email của tất cả các chủ tài khoản không? Đó sẽ là một tệp rất lớn. Hay ông chỉ cần địa chỉ email của các chủ tài khoản trong một nhóm tuổi nhất định?

Alexander Kubelski (10:19 sáng)

Tôi hiểu ý cô rồi. Tôi muốn gửi email cho các chủ tài khoản từ 55 đến 65 tuổi để mời họ gặp chuyên gia lập kế hoạch hưu trí. Tôi có phải nộp mẫu yêu cầu dự án mới không?

Bora Choi (10:21 sáng)

Điều đó không cần thiết đâu, ông Kubelski. Chúng tôi có thể cập nhật mẫu yêu cầu hiện tại cho ông. Ông sẽ không muốn mất vị trí của mình trong hàng đợi đâu.

Alexander Kubelski (10:21 sáng)

Tuyệt vời, cảm ơn cô! Cô có thể gửi danh sách đó cho tôi ngay lập tức được không?

Marlys Barry (10:22 sáng)

Có một vài dự án đang xếp hàng trước dự án của ông.

Alexander Kubelski (10:23 sáng)

Tôi đã hy vọng gửi thư mời qua email vào ngày mai.

Marlys Barry (10:24 sáng)

Chúng tôi sẽ xử lý nó ngay khi có thể.', '', '', '5b16a09d-4c11-44bb-a1e9-f4b34c91efbf', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('4a859fad-2dfe-45ee-9955-908f70549dfa', 'toeic-test-01', 175, 7, 'reading', 'At 10:22 A.M., what does Ms. Barry most likely mean when she writes, “There are several projects ahead of yours”?', 'Ms. Barry will move Mr. Kubelski’s request to the end of the queue.', 'Ms. Barry will not be able to send out the invitations for Mr. Kubelski.', 'Mr. Kubelski’s request will not be the first job Ms. Barry completes.', 'Mr. Kubelski will need to assist with other projects first.', 'C', 'Marlys Barry (10:17 sáng)

Tôi là Barry từ bộ phận phân tích dữ liệu. Tôi có bao gồm đồng nghiệp của mình, cô Choi. Chúng tôi liên hệ với ông về yêu cầu dữ liệu địa chỉ email của tất cả các chủ tài khoản, được sắp xếp theo độ tuổi.

Alexander Kubelski (10:17 sáng)

Vâng, các bạn có thể hoàn thành yêu cầu sớm đến mức nào?

Marlys Barry (10:18 sáng)

Tôi có một câu hỏi cho ông trước. Ông có thực sự cần địa chỉ email của tất cả các chủ tài khoản không? Đó sẽ là một tệp rất lớn. Hay ông chỉ cần địa chỉ email của các chủ tài khoản trong một nhóm tuổi nhất định?

Alexander Kubelski (10:19 sáng)

Tôi hiểu ý cô rồi. Tôi muốn gửi email cho các chủ tài khoản từ 55 đến 65 tuổi để mời họ gặp chuyên gia lập kế hoạch hưu trí. Tôi có phải nộp mẫu yêu cầu dự án mới không?

Bora Choi (10:21 sáng)

Điều đó không cần thiết đâu, ông Kubelski. Chúng tôi có thể cập nhật mẫu yêu cầu hiện tại cho ông. Ông sẽ không muốn mất vị trí của mình trong hàng đợi đâu.

Alexander Kubelski (10:21 sáng)

Tuyệt vời, cảm ơn cô! Cô có thể gửi danh sách đó cho tôi ngay lập tức được không?

Marlys Barry (10:22 sáng)

Có một vài dự án đang xếp hàng trước dự án của ông.

Alexander Kubelski (10:23 sáng)

Tôi đã hy vọng gửi thư mời qua email vào ngày mai.

Marlys Barry (10:24 sáng)

Chúng tôi sẽ xử lý nó ngay khi có thể.', '', '', '5b16a09d-4c11-44bb-a1e9-f4b34c91efbf', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('19a707cb-90f6-4753-90a0-3fadcbff2336', 'toeic-test-01', 176, 7, 'reading', 'According to the article, what is one way that food truck owners traditionally attract customers?', 'By word of mouth', 'From highway billboards', 'Through newspaper advertisements', 'From signs at food festivals', 'A', 'Mẹo thiết kế trang web cho doanh nghiệp xe bán đồ ăn

Các chủ xe bán đồ ăn di chuyển từ nơi này sang nơi khác, trong và giữa các thành phố khi họ kinh doanh, vì vậy họ thường dựa vào truyền miệng hoặc mạng xã hội để thu hút khách hàng. Kết quả là, họ có thể không xây dựng trang web của riêng mình. Nhưng trên thực tế, do bản chất kinh doanh của mình, điều quan trọng là các chủ xe bán đồ ăn phải có một nơi cố định để công chúng tìm hiểu về họ, đặt hàng, liên hệ, v.v. Hơn nữa, nghiên cứu thị trường cho thấy một trang web có thể giúp xây dựng lượng khách hàng thân thiết. Vì vậy, dưới đây là một số mẹo để phát triển một trang web tuyệt vời cho xe bán đồ ăn của bạn.

Trang chủ (Home page) nên có đồ họa đậm nét cùng với tên xe bán đồ ăn của bạn. Văn bản phải hiển thị nổi bật các thông tin chính, chẳng hạn như vị trí của xe và giờ hoạt động. Các biểu mẫu trực tuyến với các ô để điền thông tin, chẳng hạn như yêu cầu đặt chỗ cho các sự kiện hoặc dịch vụ đặc biệt, cung cấp cho khách truy cập mới quá nhiều thông tin trực quan. Chúng tốt hơn nên được kết hợp dưới dạng các liên kết hoặc cửa sổ bật lên (pop-up).

Trang Thực đơn (Food Menu) cần những hình ảnh hấp dẫn, độ phân giải cao cùng với văn bản sống động và chính xác mô tả chi tiết từng món ăn. Hãy nhớ rằng ảnh của bạn nên đủ lớn để trông hấp dẫn trên màn hình máy tính lớn hơn.

Trang Về chúng tôi (About Us) nên bao gồm một số nội dung giải thích chủ đề và ý tưởng của xe bán đồ ăn, và một số dữ liệu tiểu sử chi tiết về nền tảng của bạn trong ngành thực phẩm.

Trang Tin tức (News page) có thể bao gồm văn bản thông báo cho khách truy cập về các món ăn theo mùa và các chương trình khuyến mãi sắp tới hoặc các sự kiện đặc biệt như lễ hội ẩm thực.

---

Gửi: Doug Abruzzo

Từ: Ed Vale

Ngày: 29 tháng 3

Chủ đề: Phản hồi

Thân gửi ông Abruzzo,

Cảm ơn ông một lần nữa vì đã tạo ra trang web mẫu cho doanh nghiệp xe bán đồ ăn của tôi. Tôi chỉ muốn nhắc lại rằng nó đã nhận được phản hồi tích cực từ những khách hàng đã dùng thử. Tôi rất vui vì chúng ta đã làm theo lời khuyên trong bài báo mà ông gửi cho tôi về thiết kế trang web cho xe bán đồ ăn!

Như chúng ta đã thảo luận trong cuộc gọi điện thoại ngày hôm qua, chúng tôi sẽ tiến hành trang web mẫu và ra mắt nó như trang web chính thức vào ngày 5 tháng 4. Tuy nhiên, tôi vẫn không thấy thông tin tôi đã gửi về chương trình khuyến mãi mới của chúng tôi sẽ bắt đầu vào giữa tháng 4, một món tráng miệng miễn phí với bất kỳ giao dịch mua bánh sandwich nào. Vui lòng đảm bảo thêm thông tin quan trọng này trước khi chúng tôi ra mắt trang web.

Trân trọng,

Ed', '', '', 'faa3506d-efb5-439e-aa4f-399c59504094', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('5cbdd241-d3b9-4c92-8517-005cbd976e52', 'toeic-test-01', 177, 7, 'reading', 'According to the article, what information does not need to appear on the Home page?', 'Truck locations', 'Hours of operation', 'Company name', 'Seasonal food items', 'D', 'Mẹo thiết kế trang web cho doanh nghiệp xe bán đồ ăn

Các chủ xe bán đồ ăn di chuyển từ nơi này sang nơi khác, trong và giữa các thành phố khi họ kinh doanh, vì vậy họ thường dựa vào truyền miệng hoặc mạng xã hội để thu hút khách hàng. Kết quả là, họ có thể không xây dựng trang web của riêng mình. Nhưng trên thực tế, do bản chất kinh doanh của mình, điều quan trọng là các chủ xe bán đồ ăn phải có một nơi cố định để công chúng tìm hiểu về họ, đặt hàng, liên hệ, v.v. Hơn nữa, nghiên cứu thị trường cho thấy một trang web có thể giúp xây dựng lượng khách hàng thân thiết. Vì vậy, dưới đây là một số mẹo để phát triển một trang web tuyệt vời cho xe bán đồ ăn của bạn.

Trang chủ (Home page) nên có đồ họa đậm nét cùng với tên xe bán đồ ăn của bạn. Văn bản phải hiển thị nổi bật các thông tin chính, chẳng hạn như vị trí của xe và giờ hoạt động. Các biểu mẫu trực tuyến với các ô để điền thông tin, chẳng hạn như yêu cầu đặt chỗ cho các sự kiện hoặc dịch vụ đặc biệt, cung cấp cho khách truy cập mới quá nhiều thông tin trực quan. Chúng tốt hơn nên được kết hợp dưới dạng các liên kết hoặc cửa sổ bật lên (pop-up).

Trang Thực đơn (Food Menu) cần những hình ảnh hấp dẫn, độ phân giải cao cùng với văn bản sống động và chính xác mô tả chi tiết từng món ăn. Hãy nhớ rằng ảnh của bạn nên đủ lớn để trông hấp dẫn trên màn hình máy tính lớn hơn.

Trang Về chúng tôi (About Us) nên bao gồm một số nội dung giải thích chủ đề và ý tưởng của xe bán đồ ăn, và một số dữ liệu tiểu sử chi tiết về nền tảng của bạn trong ngành thực phẩm.

Trang Tin tức (News page) có thể bao gồm văn bản thông báo cho khách truy cập về các món ăn theo mùa và các chương trình khuyến mãi sắp tới hoặc các sự kiện đặc biệt như lễ hội ẩm thực.

---

Gửi: Doug Abruzzo

Từ: Ed Vale

Ngày: 29 tháng 3

Chủ đề: Phản hồi

Thân gửi ông Abruzzo,

Cảm ơn ông một lần nữa vì đã tạo ra trang web mẫu cho doanh nghiệp xe bán đồ ăn của tôi. Tôi chỉ muốn nhắc lại rằng nó đã nhận được phản hồi tích cực từ những khách hàng đã dùng thử. Tôi rất vui vì chúng ta đã làm theo lời khuyên trong bài báo mà ông gửi cho tôi về thiết kế trang web cho xe bán đồ ăn!

Như chúng ta đã thảo luận trong cuộc gọi điện thoại ngày hôm qua, chúng tôi sẽ tiến hành trang web mẫu và ra mắt nó như trang web chính thức vào ngày 5 tháng 4. Tuy nhiên, tôi vẫn không thấy thông tin tôi đã gửi về chương trình khuyến mãi mới của chúng tôi sẽ bắt đầu vào giữa tháng 4, một món tráng miệng miễn phí với bất kỳ giao dịch mua bánh sandwich nào. Vui lòng đảm bảo thêm thông tin quan trọng này trước khi chúng tôi ra mắt trang web.

Trân trọng,

Ed', '', '', 'faa3506d-efb5-439e-aa4f-399c59504094', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('5f408126-8ddd-4569-bb86-95917d12ca60', 'toeic-test-01', 178, 7, 'reading', 'In what field does Mr. Abruzzo most likely work?', 'Market research', 'Catering', 'Web design', 'Package delivery', 'C', 'Mẹo thiết kế trang web cho doanh nghiệp xe bán đồ ăn

Các chủ xe bán đồ ăn di chuyển từ nơi này sang nơi khác, trong và giữa các thành phố khi họ kinh doanh, vì vậy họ thường dựa vào truyền miệng hoặc mạng xã hội để thu hút khách hàng. Kết quả là, họ có thể không xây dựng trang web của riêng mình. Nhưng trên thực tế, do bản chất kinh doanh của mình, điều quan trọng là các chủ xe bán đồ ăn phải có một nơi cố định để công chúng tìm hiểu về họ, đặt hàng, liên hệ, v.v. Hơn nữa, nghiên cứu thị trường cho thấy một trang web có thể giúp xây dựng lượng khách hàng thân thiết. Vì vậy, dưới đây là một số mẹo để phát triển một trang web tuyệt vời cho xe bán đồ ăn của bạn.

Trang chủ (Home page) nên có đồ họa đậm nét cùng với tên xe bán đồ ăn của bạn. Văn bản phải hiển thị nổi bật các thông tin chính, chẳng hạn như vị trí của xe và giờ hoạt động. Các biểu mẫu trực tuyến với các ô để điền thông tin, chẳng hạn như yêu cầu đặt chỗ cho các sự kiện hoặc dịch vụ đặc biệt, cung cấp cho khách truy cập mới quá nhiều thông tin trực quan. Chúng tốt hơn nên được kết hợp dưới dạng các liên kết hoặc cửa sổ bật lên (pop-up).

Trang Thực đơn (Food Menu) cần những hình ảnh hấp dẫn, độ phân giải cao cùng với văn bản sống động và chính xác mô tả chi tiết từng món ăn. Hãy nhớ rằng ảnh của bạn nên đủ lớn để trông hấp dẫn trên màn hình máy tính lớn hơn.

Trang Về chúng tôi (About Us) nên bao gồm một số nội dung giải thích chủ đề và ý tưởng của xe bán đồ ăn, và một số dữ liệu tiểu sử chi tiết về nền tảng của bạn trong ngành thực phẩm.

Trang Tin tức (News page) có thể bao gồm văn bản thông báo cho khách truy cập về các món ăn theo mùa và các chương trình khuyến mãi sắp tới hoặc các sự kiện đặc biệt như lễ hội ẩm thực.

---

Gửi: Doug Abruzzo

Từ: Ed Vale

Ngày: 29 tháng 3

Chủ đề: Phản hồi

Thân gửi ông Abruzzo,

Cảm ơn ông một lần nữa vì đã tạo ra trang web mẫu cho doanh nghiệp xe bán đồ ăn của tôi. Tôi chỉ muốn nhắc lại rằng nó đã nhận được phản hồi tích cực từ những khách hàng đã dùng thử. Tôi rất vui vì chúng ta đã làm theo lời khuyên trong bài báo mà ông gửi cho tôi về thiết kế trang web cho xe bán đồ ăn!

Như chúng ta đã thảo luận trong cuộc gọi điện thoại ngày hôm qua, chúng tôi sẽ tiến hành trang web mẫu và ra mắt nó như trang web chính thức vào ngày 5 tháng 4. Tuy nhiên, tôi vẫn không thấy thông tin tôi đã gửi về chương trình khuyến mãi mới của chúng tôi sẽ bắt đầu vào giữa tháng 4, một món tráng miệng miễn phí với bất kỳ giao dịch mua bánh sandwich nào. Vui lòng đảm bảo thêm thông tin quan trọng này trước khi chúng tôi ra mắt trang web.

Trân trọng,

Ed', '', '', 'faa3506d-efb5-439e-aa4f-399c59504094', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('e57b82d8-3d9f-44a1-bf9a-1aa1a6543adc', 'toeic-test-01', 179, 7, 'reading', 'In which section of the Web site will information most likely be added?', 'The Home page', 'The Food Menu page', 'The About Us page', 'The News page', 'D', 'Mẹo thiết kế trang web cho doanh nghiệp xe bán đồ ăn

Các chủ xe bán đồ ăn di chuyển từ nơi này sang nơi khác, trong và giữa các thành phố khi họ kinh doanh, vì vậy họ thường dựa vào truyền miệng hoặc mạng xã hội để thu hút khách hàng. Kết quả là, họ có thể không xây dựng trang web của riêng mình. Nhưng trên thực tế, do bản chất kinh doanh của mình, điều quan trọng là các chủ xe bán đồ ăn phải có một nơi cố định để công chúng tìm hiểu về họ, đặt hàng, liên hệ, v.v. Hơn nữa, nghiên cứu thị trường cho thấy một trang web có thể giúp xây dựng lượng khách hàng thân thiết. Vì vậy, dưới đây là một số mẹo để phát triển một trang web tuyệt vời cho xe bán đồ ăn của bạn.

Trang chủ (Home page) nên có đồ họa đậm nét cùng với tên xe bán đồ ăn của bạn. Văn bản phải hiển thị nổi bật các thông tin chính, chẳng hạn như vị trí của xe và giờ hoạt động. Các biểu mẫu trực tuyến với các ô để điền thông tin, chẳng hạn như yêu cầu đặt chỗ cho các sự kiện hoặc dịch vụ đặc biệt, cung cấp cho khách truy cập mới quá nhiều thông tin trực quan. Chúng tốt hơn nên được kết hợp dưới dạng các liên kết hoặc cửa sổ bật lên (pop-up).

Trang Thực đơn (Food Menu) cần những hình ảnh hấp dẫn, độ phân giải cao cùng với văn bản sống động và chính xác mô tả chi tiết từng món ăn. Hãy nhớ rằng ảnh của bạn nên đủ lớn để trông hấp dẫn trên màn hình máy tính lớn hơn.

Trang Về chúng tôi (About Us) nên bao gồm một số nội dung giải thích chủ đề và ý tưởng của xe bán đồ ăn, và một số dữ liệu tiểu sử chi tiết về nền tảng của bạn trong ngành thực phẩm.

Trang Tin tức (News page) có thể bao gồm văn bản thông báo cho khách truy cập về các món ăn theo mùa và các chương trình khuyến mãi sắp tới hoặc các sự kiện đặc biệt như lễ hội ẩm thực.

---

Gửi: Doug Abruzzo

Từ: Ed Vale

Ngày: 29 tháng 3

Chủ đề: Phản hồi

Thân gửi ông Abruzzo,

Cảm ơn ông một lần nữa vì đã tạo ra trang web mẫu cho doanh nghiệp xe bán đồ ăn của tôi. Tôi chỉ muốn nhắc lại rằng nó đã nhận được phản hồi tích cực từ những khách hàng đã dùng thử. Tôi rất vui vì chúng ta đã làm theo lời khuyên trong bài báo mà ông gửi cho tôi về thiết kế trang web cho xe bán đồ ăn!

Như chúng ta đã thảo luận trong cuộc gọi điện thoại ngày hôm qua, chúng tôi sẽ tiến hành trang web mẫu và ra mắt nó như trang web chính thức vào ngày 5 tháng 4. Tuy nhiên, tôi vẫn không thấy thông tin tôi đã gửi về chương trình khuyến mãi mới của chúng tôi sẽ bắt đầu vào giữa tháng 4, một món tráng miệng miễn phí với bất kỳ giao dịch mua bánh sandwich nào. Vui lòng đảm bảo thêm thông tin quan trọng này trước khi chúng tôi ra mắt trang web.

Trân trọng,

Ed', '', '', 'faa3506d-efb5-439e-aa4f-399c59504094', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('e9c4e7b9-abb2-453a-bc1f-47180f1714e4', 'toeic-test-01', 180, 7, 'reading', 'According to the e-mail, when will the Web site launch?', 'On March 28', 'On March 29', 'On April 5', 'On April 15', 'C', 'Mẹo thiết kế trang web cho doanh nghiệp xe bán đồ ăn

Các chủ xe bán đồ ăn di chuyển từ nơi này sang nơi khác, trong và giữa các thành phố khi họ kinh doanh, vì vậy họ thường dựa vào truyền miệng hoặc mạng xã hội để thu hút khách hàng. Kết quả là, họ có thể không xây dựng trang web của riêng mình. Nhưng trên thực tế, do bản chất kinh doanh của mình, điều quan trọng là các chủ xe bán đồ ăn phải có một nơi cố định để công chúng tìm hiểu về họ, đặt hàng, liên hệ, v.v. Hơn nữa, nghiên cứu thị trường cho thấy một trang web có thể giúp xây dựng lượng khách hàng thân thiết. Vì vậy, dưới đây là một số mẹo để phát triển một trang web tuyệt vời cho xe bán đồ ăn của bạn.

Trang chủ (Home page) nên có đồ họa đậm nét cùng với tên xe bán đồ ăn của bạn. Văn bản phải hiển thị nổi bật các thông tin chính, chẳng hạn như vị trí của xe và giờ hoạt động. Các biểu mẫu trực tuyến với các ô để điền thông tin, chẳng hạn như yêu cầu đặt chỗ cho các sự kiện hoặc dịch vụ đặc biệt, cung cấp cho khách truy cập mới quá nhiều thông tin trực quan. Chúng tốt hơn nên được kết hợp dưới dạng các liên kết hoặc cửa sổ bật lên (pop-up).

Trang Thực đơn (Food Menu) cần những hình ảnh hấp dẫn, độ phân giải cao cùng với văn bản sống động và chính xác mô tả chi tiết từng món ăn. Hãy nhớ rằng ảnh của bạn nên đủ lớn để trông hấp dẫn trên màn hình máy tính lớn hơn.

Trang Về chúng tôi (About Us) nên bao gồm một số nội dung giải thích chủ đề và ý tưởng của xe bán đồ ăn, và một số dữ liệu tiểu sử chi tiết về nền tảng của bạn trong ngành thực phẩm.

Trang Tin tức (News page) có thể bao gồm văn bản thông báo cho khách truy cập về các món ăn theo mùa và các chương trình khuyến mãi sắp tới hoặc các sự kiện đặc biệt như lễ hội ẩm thực.

---

Gửi: Doug Abruzzo

Từ: Ed Vale

Ngày: 29 tháng 3

Chủ đề: Phản hồi

Thân gửi ông Abruzzo,

Cảm ơn ông một lần nữa vì đã tạo ra trang web mẫu cho doanh nghiệp xe bán đồ ăn của tôi. Tôi chỉ muốn nhắc lại rằng nó đã nhận được phản hồi tích cực từ những khách hàng đã dùng thử. Tôi rất vui vì chúng ta đã làm theo lời khuyên trong bài báo mà ông gửi cho tôi về thiết kế trang web cho xe bán đồ ăn!

Như chúng ta đã thảo luận trong cuộc gọi điện thoại ngày hôm qua, chúng tôi sẽ tiến hành trang web mẫu và ra mắt nó như trang web chính thức vào ngày 5 tháng 4. Tuy nhiên, tôi vẫn không thấy thông tin tôi đã gửi về chương trình khuyến mãi mới của chúng tôi sẽ bắt đầu vào giữa tháng 4, một món tráng miệng miễn phí với bất kỳ giao dịch mua bánh sandwich nào. Vui lòng đảm bảo thêm thông tin quan trọng này trước khi chúng tôi ra mắt trang web.

Trân trọng,

Ed', '', '', 'faa3506d-efb5-439e-aa4f-399c59504094', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('697aa6f0-8a63-42b5-94ac-942897adfcf0', 'toeic-test-01', 181, 7, 'reading', 'What is indicated about the Net Zero Initiative?', 'It is being funded by the Red Hills Business Association.', 'It was inspired by similar initiatives in other cities.', 'It will use geothermal energy to power a city.', 'It will change the way an institution heats its buildings.', 'D', 'Gửi: Manny Green

Từ: John LaRose

Ngày: 18 tháng 5

Chủ đề: Thông báo khoan

Thân gửi ông Green:

Với tư cách là một phép lịch sự, tôi viết thư cho ông tại Hiệp hội Kinh doanh Red Hills, nhờ ông giúp tôi gửi thông tin này đến các thành viên của ông. Đã có thông báo trên tờ Daily Gazette tháng trước rằng Đại học Rilamore đang tiến hành Sáng kiến Net Zero. Trong vòng ba năm, chúng tôi dự kiến sẽ lắp đặt và vận hành các giếng địa nhiệt để sưởi ấm và làm mát toàn bộ khuôn viên trường. Việc hạn chế sự phụ thuộc của tổ chức vào nhiên liệu hóa thạch từ lâu đã là một mục tiêu, và hệ thống mới là một bước đi quan trọng hướng tới việc đạt được mục tiêu đó.

Trong tháng tới, chúng tôi sẽ tiến hành khoan thử nghiệm tại một số địa điểm trong khuôn viên trường. Nếu mọi việc diễn ra theo đúng kế hoạch, đội ngũ sẽ khoan liền kề với Khu Kinh doanh Red Hills và Chung cư Oak Street bắt đầu từ Thứ Tư, ngày 5 tháng 6. Chúng tôi muốn thông báo cho các chủ doanh nghiệp và cư dân gần khuôn viên trường chuẩn bị tinh thần cho mức độ tiếng ồn cao hơn bình thường trong hai tuần mà chúng tôi ước tính sẽ mất để hoàn thành công việc. Giờ làm việc của đội khoan là từ 10 giờ sáng đến 3 giờ chiều mỗi ngày, từ Thứ Hai đến Thứ Sáu.

Chúng tôi xin lỗi trước về sự bất tiện mà điều này có thể gây ra cho những người hàng xóm. Mọi câu hỏi hoặc thắc mắc nên được gửi trực tiếp cho tôi theo số 813-555-0123.

John LaRose

Liên lạc viên cộng đồng, Văn phòng Truyền thông Đại học Rilamore

---

THÔNG CÁO BÁO CHÍ

Liên hệ: Manny Green

RED HILLS (Ngày 25 tháng 5) — Hiệp hội Kinh doanh Red Hills đang thay đổi ngày diễn ra Chuỗi Hòa nhạc Giờ Ăn trưa rất được mong đợi. Thông thường được tổ chức vào mỗi Thứ Năm trong tháng Sáu, bốn buổi hòa nhạc miễn phí thay vào đó sẽ diễn ra vào mỗi Thứ Năm trong tháng Bảy. Danh sách nghệ sĩ vẫn không thay đổi — nhóm Jaystone Jazz Trio sẽ mở màn chuỗi chương trình vào ngày 4 tháng 7, tiếp theo vào các Thứ Năm kế tiếp là Joss and the Jaybirds, Ray Starform và Barklay Bass Quintet.

Như thường lệ, cả ba dãy phố của đường Oak Street sẽ bị cấm lưu thông, các nhà hàng sẽ phục vụ bữa trưa tại các bàn ngoài trời, và các nhà bán lẻ đồ thủ công mỹ nghệ địa phương sẽ trưng bày tác phẩm của họ trên bãi cỏ của Trung tâm Văn hóa. Đây là một sự kiện ăn mừng tuyệt vời tại trung tâm của một khu phố Red Hills sầm uất. Chúng tôi hy vọng sẽ gặp bạn ở đó!', '', '', 'd54069b2-068b-48ab-af19-0f9d17b3cdd0', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('b0fd1495-cb39-413d-8a06-fdb524fcd1b8', 'toeic-test-01', 182, 7, 'reading', 'In the e-mail, the word “conduct” in paragraph 2, line 1, is closest in meaning to', 'behave', 'accompany', 'transmit', 'carry out', 'D', 'Gửi: Manny Green

Từ: John LaRose

Ngày: 18 tháng 5

Chủ đề: Thông báo khoan

Thân gửi ông Green:

Với tư cách là một phép lịch sự, tôi viết thư cho ông tại Hiệp hội Kinh doanh Red Hills, nhờ ông giúp tôi gửi thông tin này đến các thành viên của ông. Đã có thông báo trên tờ Daily Gazette tháng trước rằng Đại học Rilamore đang tiến hành Sáng kiến Net Zero. Trong vòng ba năm, chúng tôi dự kiến sẽ lắp đặt và vận hành các giếng địa nhiệt để sưởi ấm và làm mát toàn bộ khuôn viên trường. Việc hạn chế sự phụ thuộc của tổ chức vào nhiên liệu hóa thạch từ lâu đã là một mục tiêu, và hệ thống mới là một bước đi quan trọng hướng tới việc đạt được mục tiêu đó.

Trong tháng tới, chúng tôi sẽ tiến hành khoan thử nghiệm tại một số địa điểm trong khuôn viên trường. Nếu mọi việc diễn ra theo đúng kế hoạch, đội ngũ sẽ khoan liền kề với Khu Kinh doanh Red Hills và Chung cư Oak Street bắt đầu từ Thứ Tư, ngày 5 tháng 6. Chúng tôi muốn thông báo cho các chủ doanh nghiệp và cư dân gần khuôn viên trường chuẩn bị tinh thần cho mức độ tiếng ồn cao hơn bình thường trong hai tuần mà chúng tôi ước tính sẽ mất để hoàn thành công việc. Giờ làm việc của đội khoan là từ 10 giờ sáng đến 3 giờ chiều mỗi ngày, từ Thứ Hai đến Thứ Sáu.

Chúng tôi xin lỗi trước về sự bất tiện mà điều này có thể gây ra cho những người hàng xóm. Mọi câu hỏi hoặc thắc mắc nên được gửi trực tiếp cho tôi theo số 813-555-0123.

John LaRose

Liên lạc viên cộng đồng, Văn phòng Truyền thông Đại học Rilamore

---

THÔNG CÁO BÁO CHÍ

Liên hệ: Manny Green

RED HILLS (Ngày 25 tháng 5) — Hiệp hội Kinh doanh Red Hills đang thay đổi ngày diễn ra Chuỗi Hòa nhạc Giờ Ăn trưa rất được mong đợi. Thông thường được tổ chức vào mỗi Thứ Năm trong tháng Sáu, bốn buổi hòa nhạc miễn phí thay vào đó sẽ diễn ra vào mỗi Thứ Năm trong tháng Bảy. Danh sách nghệ sĩ vẫn không thay đổi — nhóm Jaystone Jazz Trio sẽ mở màn chuỗi chương trình vào ngày 4 tháng 7, tiếp theo vào các Thứ Năm kế tiếp là Joss and the Jaybirds, Ray Starform và Barklay Bass Quintet.

Như thường lệ, cả ba dãy phố của đường Oak Street sẽ bị cấm lưu thông, các nhà hàng sẽ phục vụ bữa trưa tại các bàn ngoài trời, và các nhà bán lẻ đồ thủ công mỹ nghệ địa phương sẽ trưng bày tác phẩm của họ trên bãi cỏ của Trung tâm Văn hóa. Đây là một sự kiện ăn mừng tuyệt vời tại trung tâm của một khu phố Red Hills sầm uất. Chúng tôi hy vọng sẽ gặp bạn ở đó!', '', '', 'd54069b2-068b-48ab-af19-0f9d17b3cdd0', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('366f3d9b-66dc-44a4-9b12-089fb66dac89', 'toeic-test-01', 183, 7, 'reading', 'What can be concluded about the Red Hills Business District?', 'It is located near a university campus.', 'It hosts an arts festival every July.', 'It includes the Oak Street Apartments.', 'It is home to the offices of the Daily Gazette.', 'A', 'Gửi: Manny Green

Từ: John LaRose

Ngày: 18 tháng 5

Chủ đề: Thông báo khoan

Thân gửi ông Green:

Với tư cách là một phép lịch sự, tôi viết thư cho ông tại Hiệp hội Kinh doanh Red Hills, nhờ ông giúp tôi gửi thông tin này đến các thành viên của ông. Đã có thông báo trên tờ Daily Gazette tháng trước rằng Đại học Rilamore đang tiến hành Sáng kiến Net Zero. Trong vòng ba năm, chúng tôi dự kiến sẽ lắp đặt và vận hành các giếng địa nhiệt để sưởi ấm và làm mát toàn bộ khuôn viên trường. Việc hạn chế sự phụ thuộc của tổ chức vào nhiên liệu hóa thạch từ lâu đã là một mục tiêu, và hệ thống mới là một bước đi quan trọng hướng tới việc đạt được mục tiêu đó.

Trong tháng tới, chúng tôi sẽ tiến hành khoan thử nghiệm tại một số địa điểm trong khuôn viên trường. Nếu mọi việc diễn ra theo đúng kế hoạch, đội ngũ sẽ khoan liền kề với Khu Kinh doanh Red Hills và Chung cư Oak Street bắt đầu từ Thứ Tư, ngày 5 tháng 6. Chúng tôi muốn thông báo cho các chủ doanh nghiệp và cư dân gần khuôn viên trường chuẩn bị tinh thần cho mức độ tiếng ồn cao hơn bình thường trong hai tuần mà chúng tôi ước tính sẽ mất để hoàn thành công việc. Giờ làm việc của đội khoan là từ 10 giờ sáng đến 3 giờ chiều mỗi ngày, từ Thứ Hai đến Thứ Sáu.

Chúng tôi xin lỗi trước về sự bất tiện mà điều này có thể gây ra cho những người hàng xóm. Mọi câu hỏi hoặc thắc mắc nên được gửi trực tiếp cho tôi theo số 813-555-0123.

John LaRose

Liên lạc viên cộng đồng, Văn phòng Truyền thông Đại học Rilamore

---

THÔNG CÁO BÁO CHÍ

Liên hệ: Manny Green

RED HILLS (Ngày 25 tháng 5) — Hiệp hội Kinh doanh Red Hills đang thay đổi ngày diễn ra Chuỗi Hòa nhạc Giờ Ăn trưa rất được mong đợi. Thông thường được tổ chức vào mỗi Thứ Năm trong tháng Sáu, bốn buổi hòa nhạc miễn phí thay vào đó sẽ diễn ra vào mỗi Thứ Năm trong tháng Bảy. Danh sách nghệ sĩ vẫn không thay đổi — nhóm Jaystone Jazz Trio sẽ mở màn chuỗi chương trình vào ngày 4 tháng 7, tiếp theo vào các Thứ Năm kế tiếp là Joss and the Jaybirds, Ray Starform và Barklay Bass Quintet.

Như thường lệ, cả ba dãy phố của đường Oak Street sẽ bị cấm lưu thông, các nhà hàng sẽ phục vụ bữa trưa tại các bàn ngoài trời, và các nhà bán lẻ đồ thủ công mỹ nghệ địa phương sẽ trưng bày tác phẩm của họ trên bãi cỏ của Trung tâm Văn hóa. Đây là một sự kiện ăn mừng tuyệt vời tại trung tâm của một khu phố Red Hills sầm uất. Chúng tôi hy vọng sẽ gặp bạn ở đó!', '', '', 'd54069b2-068b-48ab-af19-0f9d17b3cdd0', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('8fe95d02-5a27-40c8-b26a-0412c7983931', 'toeic-test-01', 184, 7, 'reading', 'Why most likely did the Red Hills Business Association change the dates of its concert series?', 'To take advantage of a new power source', 'To accommodate students’ schedules', 'To avoid noise from nearby construction', 'To prevent a conflict with a similar event', 'C', 'Gửi: Manny Green

Từ: John LaRose

Ngày: 18 tháng 5

Chủ đề: Thông báo khoan

Thân gửi ông Green:

Với tư cách là một phép lịch sự, tôi viết thư cho ông tại Hiệp hội Kinh doanh Red Hills, nhờ ông giúp tôi gửi thông tin này đến các thành viên của ông. Đã có thông báo trên tờ Daily Gazette tháng trước rằng Đại học Rilamore đang tiến hành Sáng kiến Net Zero. Trong vòng ba năm, chúng tôi dự kiến sẽ lắp đặt và vận hành các giếng địa nhiệt để sưởi ấm và làm mát toàn bộ khuôn viên trường. Việc hạn chế sự phụ thuộc của tổ chức vào nhiên liệu hóa thạch từ lâu đã là một mục tiêu, và hệ thống mới là một bước đi quan trọng hướng tới việc đạt được mục tiêu đó.

Trong tháng tới, chúng tôi sẽ tiến hành khoan thử nghiệm tại một số địa điểm trong khuôn viên trường. Nếu mọi việc diễn ra theo đúng kế hoạch, đội ngũ sẽ khoan liền kề với Khu Kinh doanh Red Hills và Chung cư Oak Street bắt đầu từ Thứ Tư, ngày 5 tháng 6. Chúng tôi muốn thông báo cho các chủ doanh nghiệp và cư dân gần khuôn viên trường chuẩn bị tinh thần cho mức độ tiếng ồn cao hơn bình thường trong hai tuần mà chúng tôi ước tính sẽ mất để hoàn thành công việc. Giờ làm việc của đội khoan là từ 10 giờ sáng đến 3 giờ chiều mỗi ngày, từ Thứ Hai đến Thứ Sáu.

Chúng tôi xin lỗi trước về sự bất tiện mà điều này có thể gây ra cho những người hàng xóm. Mọi câu hỏi hoặc thắc mắc nên được gửi trực tiếp cho tôi theo số 813-555-0123.

John LaRose

Liên lạc viên cộng đồng, Văn phòng Truyền thông Đại học Rilamore

---

THÔNG CÁO BÁO CHÍ

Liên hệ: Manny Green

RED HILLS (Ngày 25 tháng 5) — Hiệp hội Kinh doanh Red Hills đang thay đổi ngày diễn ra Chuỗi Hòa nhạc Giờ Ăn trưa rất được mong đợi. Thông thường được tổ chức vào mỗi Thứ Năm trong tháng Sáu, bốn buổi hòa nhạc miễn phí thay vào đó sẽ diễn ra vào mỗi Thứ Năm trong tháng Bảy. Danh sách nghệ sĩ vẫn không thay đổi — nhóm Jaystone Jazz Trio sẽ mở màn chuỗi chương trình vào ngày 4 tháng 7, tiếp theo vào các Thứ Năm kế tiếp là Joss and the Jaybirds, Ray Starform và Barklay Bass Quintet.

Như thường lệ, cả ba dãy phố của đường Oak Street sẽ bị cấm lưu thông, các nhà hàng sẽ phục vụ bữa trưa tại các bàn ngoài trời, và các nhà bán lẻ đồ thủ công mỹ nghệ địa phương sẽ trưng bày tác phẩm của họ trên bãi cỏ của Trung tâm Văn hóa. Đây là một sự kiện ăn mừng tuyệt vời tại trung tâm của một khu phố Red Hills sầm uất. Chúng tôi hy vọng sẽ gặp bạn ở đó!', '', '', 'd54069b2-068b-48ab-af19-0f9d17b3cdd0', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('a850c9ac-693b-419e-9f79-ea175aea3271', 'toeic-test-01', 185, 7, 'reading', 'What is mentioned in the press release about the Cultural Center?', 'It will provide lunch for musicians.', 'It will have artwork for sale on its property.', 'It will offer arts-and-crafts workshops.', 'It will provide the stage for performers.', 'B', 'Gửi: Manny Green

Từ: John LaRose

Ngày: 18 tháng 5

Chủ đề: Thông báo khoan

Thân gửi ông Green:

Với tư cách là một phép lịch sự, tôi viết thư cho ông tại Hiệp hội Kinh doanh Red Hills, nhờ ông giúp tôi gửi thông tin này đến các thành viên của ông. Đã có thông báo trên tờ Daily Gazette tháng trước rằng Đại học Rilamore đang tiến hành Sáng kiến Net Zero. Trong vòng ba năm, chúng tôi dự kiến sẽ lắp đặt và vận hành các giếng địa nhiệt để sưởi ấm và làm mát toàn bộ khuôn viên trường. Việc hạn chế sự phụ thuộc của tổ chức vào nhiên liệu hóa thạch từ lâu đã là một mục tiêu, và hệ thống mới là một bước đi quan trọng hướng tới việc đạt được mục tiêu đó.

Trong tháng tới, chúng tôi sẽ tiến hành khoan thử nghiệm tại một số địa điểm trong khuôn viên trường. Nếu mọi việc diễn ra theo đúng kế hoạch, đội ngũ sẽ khoan liền kề với Khu Kinh doanh Red Hills và Chung cư Oak Street bắt đầu từ Thứ Tư, ngày 5 tháng 6. Chúng tôi muốn thông báo cho các chủ doanh nghiệp và cư dân gần khuôn viên trường chuẩn bị tinh thần cho mức độ tiếng ồn cao hơn bình thường trong hai tuần mà chúng tôi ước tính sẽ mất để hoàn thành công việc. Giờ làm việc của đội khoan là từ 10 giờ sáng đến 3 giờ chiều mỗi ngày, từ Thứ Hai đến Thứ Sáu.

Chúng tôi xin lỗi trước về sự bất tiện mà điều này có thể gây ra cho những người hàng xóm. Mọi câu hỏi hoặc thắc mắc nên được gửi trực tiếp cho tôi theo số 813-555-0123.

John LaRose

Liên lạc viên cộng đồng, Văn phòng Truyền thông Đại học Rilamore

---

THÔNG CÁO BÁO CHÍ

Liên hệ: Manny Green

RED HILLS (Ngày 25 tháng 5) — Hiệp hội Kinh doanh Red Hills đang thay đổi ngày diễn ra Chuỗi Hòa nhạc Giờ Ăn trưa rất được mong đợi. Thông thường được tổ chức vào mỗi Thứ Năm trong tháng Sáu, bốn buổi hòa nhạc miễn phí thay vào đó sẽ diễn ra vào mỗi Thứ Năm trong tháng Bảy. Danh sách nghệ sĩ vẫn không thay đổi — nhóm Jaystone Jazz Trio sẽ mở màn chuỗi chương trình vào ngày 4 tháng 7, tiếp theo vào các Thứ Năm kế tiếp là Joss and the Jaybirds, Ray Starform và Barklay Bass Quintet.

Như thường lệ, cả ba dãy phố của đường Oak Street sẽ bị cấm lưu thông, các nhà hàng sẽ phục vụ bữa trưa tại các bàn ngoài trời, và các nhà bán lẻ đồ thủ công mỹ nghệ địa phương sẽ trưng bày tác phẩm của họ trên bãi cỏ của Trung tâm Văn hóa. Đây là một sự kiện ăn mừng tuyệt vời tại trung tâm của một khu phố Red Hills sầm uất. Chúng tôi hy vọng sẽ gặp bạn ở đó!', '', '', 'd54069b2-068b-48ab-af19-0f9d17b3cdd0', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('fb4a6822-c028-4123-bfd3-7a144ae2297a', 'toeic-test-01', 186, 7, 'reading', 'According to the advertisement, what is one type of work performed by Lawal Home Service?', 'Planting trees', 'Repairing gutters', 'Building home additions', 'Replacing heating systems', 'B', 'Dịch vụ Nhà Lawal: Phục vụ Nam California hơn 40 năm

Lawal Home Service cung cấp các giải pháp về mái nhà và năng lượng mặt trời cho cư dân Nam California tại Inglewood và các khu vực lân cận. Ngoài việc thay thế mái nhà, chúng tôi cung cấp một loạt các dịch vụ, từ cách nhiệt gác mái và phục hồi máng xối đến sửa chữa rò rỉ và lắp đặt các tấm pin mặt trời.

Lawal Home Service tự hào về giao tiếp minh bạch và sự chú trọng đến từng chi tiết. Các giám sát viên dự án của chúng tôi luôn có mặt tại công trường để trả lời các câu hỏi của khách hàng, cung cấp cập nhật và đảm bảo công trường an toàn, sạch sẽ. Để yêu cầu chẩn đoán mái nhà miễn phí, hãy truy cập www.lawalhomeservice.com hoặc gọi cho đại lý đặt chỗ của chúng tôi theo số 310-555-0108.

Mẫu Liên hệ Dịch vụ Nhà Lawal

Hãy tin tưởng các chuyên gia tại Lawal Home Service để chẩn đoán nhu cầu mái nhà của bạn một cách nhanh chóng và chuyên nghiệp. Vui lòng dành vài phút để hoàn thành mẫu với càng nhiều chi tiết càng tốt. Hãy nhớ rằng, tất cả các mái nhà do Lawal lắp đặt đều được bảo hành 25 năm.

(Bảng dữ liệu: Tên: Drew Gerson; Ngày: 12/12; Địa chỉ: 820 North Acacia Street, Inglewood, CA 90301).

Chúng tôi có thể giúp gì cho bạn?: Trong trận bão gió tuần trước, vài tấm lợp mái đã bị xé toạc và cần thay thế. Tôi đang cân nhắc thay toàn bộ mái vì nó đã hơn 30 năm tuổi, và nước đã bắt đầu nhỏ giọt qua phần trên hiên nhà. Tôi sẽ rất cảm kích nếu được nói chuyện với ai đó có thể cho tôi biết các lựa chọn và cung cấp bản ước tính.

Đánh giá từ khu dân cư: Dịch vụ Nhà Lawal

5 sao - "Tôi rất hài lòng với sự kỹ lưỡng trong công việc của họ."

Tôi đã để lại mô tả về vấn đề của mình cho Lawal Home Service, và một trong những chuyên gia ước tính của công ty đã đến kiểm tra mái nhà của tôi ngay ngày hôm sau. Sau khi tôi quyết định thay mái, đội ngũ Lawal đã có thể bắt đầu làm việc vào tuần sau đó. Diana Perez đã có mặt tại công trường trong suốt quá trình làm việc như đã hứa và trả lời mọi câu hỏi của tôi. Công việc bắt đầu vào ngày 19/12 và kết thúc vào ngày 20/12. Sau khi lợp mái xong, đội ngũ đã dọn dẹp rất tốt. Họ đã sử dụng hai thiết bị nam châm giống như máy cắt cỏ và quét qua toàn bộ bãi cỏ của tôi để tìm bất kỳ chiếc đinh lợp mái nào bị rơi. Tôi chưa bao giờ thấy thứ gì như vậy! Tôi rất hài lòng với sự kỹ lưỡng trong công việc của họ. — Drew Gerson, Inglewood, CA', '', '', 'cb594aff-40ff-4dd4-b919-27c0f5238ec9', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('f046e32d-aea6-4237-bd2e-98de2209ddba', 'toeic-test-01', 187, 7, 'reading', 'What does Mr. Gerson indicate on the form about his roof?', 'It has developed a leak.', 'It was recently replaced.', 'It was not expensive to install.', 'It is under warranty for 30 years.', 'A', 'Dịch vụ Nhà Lawal: Phục vụ Nam California hơn 40 năm

Lawal Home Service cung cấp các giải pháp về mái nhà và năng lượng mặt trời cho cư dân Nam California tại Inglewood và các khu vực lân cận. Ngoài việc thay thế mái nhà, chúng tôi cung cấp một loạt các dịch vụ, từ cách nhiệt gác mái và phục hồi máng xối đến sửa chữa rò rỉ và lắp đặt các tấm pin mặt trời.

Lawal Home Service tự hào về giao tiếp minh bạch và sự chú trọng đến từng chi tiết. Các giám sát viên dự án của chúng tôi luôn có mặt tại công trường để trả lời các câu hỏi của khách hàng, cung cấp cập nhật và đảm bảo công trường an toàn, sạch sẽ. Để yêu cầu chẩn đoán mái nhà miễn phí, hãy truy cập www.lawalhomeservice.com hoặc gọi cho đại lý đặt chỗ của chúng tôi theo số 310-555-0108.

Mẫu Liên hệ Dịch vụ Nhà Lawal

Hãy tin tưởng các chuyên gia tại Lawal Home Service để chẩn đoán nhu cầu mái nhà của bạn một cách nhanh chóng và chuyên nghiệp. Vui lòng dành vài phút để hoàn thành mẫu với càng nhiều chi tiết càng tốt. Hãy nhớ rằng, tất cả các mái nhà do Lawal lắp đặt đều được bảo hành 25 năm.

(Bảng dữ liệu: Tên: Drew Gerson; Ngày: 12/12; Địa chỉ: 820 North Acacia Street, Inglewood, CA 90301).

Chúng tôi có thể giúp gì cho bạn?: Trong trận bão gió tuần trước, vài tấm lợp mái đã bị xé toạc và cần thay thế. Tôi đang cân nhắc thay toàn bộ mái vì nó đã hơn 30 năm tuổi, và nước đã bắt đầu nhỏ giọt qua phần trên hiên nhà. Tôi sẽ rất cảm kích nếu được nói chuyện với ai đó có thể cho tôi biết các lựa chọn và cung cấp bản ước tính.

Đánh giá từ khu dân cư: Dịch vụ Nhà Lawal

5 sao - "Tôi rất hài lòng với sự kỹ lưỡng trong công việc của họ."

Tôi đã để lại mô tả về vấn đề của mình cho Lawal Home Service, và một trong những chuyên gia ước tính của công ty đã đến kiểm tra mái nhà của tôi ngay ngày hôm sau. Sau khi tôi quyết định thay mái, đội ngũ Lawal đã có thể bắt đầu làm việc vào tuần sau đó. Diana Perez đã có mặt tại công trường trong suốt quá trình làm việc như đã hứa và trả lời mọi câu hỏi của tôi. Công việc bắt đầu vào ngày 19/12 và kết thúc vào ngày 20/12. Sau khi lợp mái xong, đội ngũ đã dọn dẹp rất tốt. Họ đã sử dụng hai thiết bị nam châm giống như máy cắt cỏ và quét qua toàn bộ bãi cỏ của tôi để tìm bất kỳ chiếc đinh lợp mái nào bị rơi. Tôi chưa bao giờ thấy thứ gì như vậy! Tôi rất hài lòng với sự kỹ lưỡng trong công việc của họ. — Drew Gerson, Inglewood, CA', '', '', 'cb594aff-40ff-4dd4-b919-27c0f5238ec9', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('ba1ca8fc-5148-41b5-aac7-4360de1a46ec', 'toeic-test-01', 188, 7, 'reading', 'When did Lawal Home Service inspect Mr. Gerson’s roof?', 'On December 12', 'On December 13', 'On December 19', 'On December 20', 'B', 'Dịch vụ Nhà Lawal: Phục vụ Nam California hơn 40 năm

Lawal Home Service cung cấp các giải pháp về mái nhà và năng lượng mặt trời cho cư dân Nam California tại Inglewood và các khu vực lân cận. Ngoài việc thay thế mái nhà, chúng tôi cung cấp một loạt các dịch vụ, từ cách nhiệt gác mái và phục hồi máng xối đến sửa chữa rò rỉ và lắp đặt các tấm pin mặt trời.

Lawal Home Service tự hào về giao tiếp minh bạch và sự chú trọng đến từng chi tiết. Các giám sát viên dự án của chúng tôi luôn có mặt tại công trường để trả lời các câu hỏi của khách hàng, cung cấp cập nhật và đảm bảo công trường an toàn, sạch sẽ. Để yêu cầu chẩn đoán mái nhà miễn phí, hãy truy cập www.lawalhomeservice.com hoặc gọi cho đại lý đặt chỗ của chúng tôi theo số 310-555-0108.

Mẫu Liên hệ Dịch vụ Nhà Lawal

Hãy tin tưởng các chuyên gia tại Lawal Home Service để chẩn đoán nhu cầu mái nhà của bạn một cách nhanh chóng và chuyên nghiệp. Vui lòng dành vài phút để hoàn thành mẫu với càng nhiều chi tiết càng tốt. Hãy nhớ rằng, tất cả các mái nhà do Lawal lắp đặt đều được bảo hành 25 năm.

(Bảng dữ liệu: Tên: Drew Gerson; Ngày: 12/12; Địa chỉ: 820 North Acacia Street, Inglewood, CA 90301).

Chúng tôi có thể giúp gì cho bạn?: Trong trận bão gió tuần trước, vài tấm lợp mái đã bị xé toạc và cần thay thế. Tôi đang cân nhắc thay toàn bộ mái vì nó đã hơn 30 năm tuổi, và nước đã bắt đầu nhỏ giọt qua phần trên hiên nhà. Tôi sẽ rất cảm kích nếu được nói chuyện với ai đó có thể cho tôi biết các lựa chọn và cung cấp bản ước tính.

Đánh giá từ khu dân cư: Dịch vụ Nhà Lawal

5 sao - "Tôi rất hài lòng với sự kỹ lưỡng trong công việc của họ."

Tôi đã để lại mô tả về vấn đề của mình cho Lawal Home Service, và một trong những chuyên gia ước tính của công ty đã đến kiểm tra mái nhà của tôi ngay ngày hôm sau. Sau khi tôi quyết định thay mái, đội ngũ Lawal đã có thể bắt đầu làm việc vào tuần sau đó. Diana Perez đã có mặt tại công trường trong suốt quá trình làm việc như đã hứa và trả lời mọi câu hỏi của tôi. Công việc bắt đầu vào ngày 19/12 và kết thúc vào ngày 20/12. Sau khi lợp mái xong, đội ngũ đã dọn dẹp rất tốt. Họ đã sử dụng hai thiết bị nam châm giống như máy cắt cỏ và quét qua toàn bộ bãi cỏ của tôi để tìm bất kỳ chiếc đinh lợp mái nào bị rơi. Tôi chưa bao giờ thấy thứ gì như vậy! Tôi rất hài lòng với sự kỹ lưỡng trong công việc của họ. — Drew Gerson, Inglewood, CA', '', '', 'cb594aff-40ff-4dd4-b919-27c0f5238ec9', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('ea04f687-91e7-49ab-a225-1a66cdc5277b', 'toeic-test-01', 189, 7, 'reading', 'Who most likely is Ms. Perez?', 'A project supervisor', 'A roofing estimator', 'An interior decorator', 'A booking agent', 'A', 'Dịch vụ Nhà Lawal: Phục vụ Nam California hơn 40 năm

Lawal Home Service cung cấp các giải pháp về mái nhà và năng lượng mặt trời cho cư dân Nam California tại Inglewood và các khu vực lân cận. Ngoài việc thay thế mái nhà, chúng tôi cung cấp một loạt các dịch vụ, từ cách nhiệt gác mái và phục hồi máng xối đến sửa chữa rò rỉ và lắp đặt các tấm pin mặt trời.

Lawal Home Service tự hào về giao tiếp minh bạch và sự chú trọng đến từng chi tiết. Các giám sát viên dự án của chúng tôi luôn có mặt tại công trường để trả lời các câu hỏi của khách hàng, cung cấp cập nhật và đảm bảo công trường an toàn, sạch sẽ. Để yêu cầu chẩn đoán mái nhà miễn phí, hãy truy cập www.lawalhomeservice.com hoặc gọi cho đại lý đặt chỗ của chúng tôi theo số 310-555-0108.

Mẫu Liên hệ Dịch vụ Nhà Lawal

Hãy tin tưởng các chuyên gia tại Lawal Home Service để chẩn đoán nhu cầu mái nhà của bạn một cách nhanh chóng và chuyên nghiệp. Vui lòng dành vài phút để hoàn thành mẫu với càng nhiều chi tiết càng tốt. Hãy nhớ rằng, tất cả các mái nhà do Lawal lắp đặt đều được bảo hành 25 năm.

(Bảng dữ liệu: Tên: Drew Gerson; Ngày: 12/12; Địa chỉ: 820 North Acacia Street, Inglewood, CA 90301).

Chúng tôi có thể giúp gì cho bạn?: Trong trận bão gió tuần trước, vài tấm lợp mái đã bị xé toạc và cần thay thế. Tôi đang cân nhắc thay toàn bộ mái vì nó đã hơn 30 năm tuổi, và nước đã bắt đầu nhỏ giọt qua phần trên hiên nhà. Tôi sẽ rất cảm kích nếu được nói chuyện với ai đó có thể cho tôi biết các lựa chọn và cung cấp bản ước tính.

Đánh giá từ khu dân cư: Dịch vụ Nhà Lawal

5 sao - "Tôi rất hài lòng với sự kỹ lưỡng trong công việc của họ."

Tôi đã để lại mô tả về vấn đề của mình cho Lawal Home Service, và một trong những chuyên gia ước tính của công ty đã đến kiểm tra mái nhà của tôi ngay ngày hôm sau. Sau khi tôi quyết định thay mái, đội ngũ Lawal đã có thể bắt đầu làm việc vào tuần sau đó. Diana Perez đã có mặt tại công trường trong suốt quá trình làm việc như đã hứa và trả lời mọi câu hỏi của tôi. Công việc bắt đầu vào ngày 19/12 và kết thúc vào ngày 20/12. Sau khi lợp mái xong, đội ngũ đã dọn dẹp rất tốt. Họ đã sử dụng hai thiết bị nam châm giống như máy cắt cỏ và quét qua toàn bộ bãi cỏ của tôi để tìm bất kỳ chiếc đinh lợp mái nào bị rơi. Tôi chưa bao giờ thấy thứ gì như vậy! Tôi rất hài lòng với sự kỹ lưỡng trong công việc của họ. — Drew Gerson, Inglewood, CA', '', '', 'cb594aff-40ff-4dd4-b919-27c0f5238ec9', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('d4b12326-25c4-4fa9-a878-114b45e180f5', 'toeic-test-01', 190, 7, 'reading', 'According to the review, what surprised Mr. Gerson about the crew from Lawal Home Service?', 'The price they charged', 'The warranty they offered', 'The quality of their materials', 'The tools they used for a job', 'D', 'Dịch vụ Nhà Lawal: Phục vụ Nam California hơn 40 năm

Lawal Home Service cung cấp các giải pháp về mái nhà và năng lượng mặt trời cho cư dân Nam California tại Inglewood và các khu vực lân cận. Ngoài việc thay thế mái nhà, chúng tôi cung cấp một loạt các dịch vụ, từ cách nhiệt gác mái và phục hồi máng xối đến sửa chữa rò rỉ và lắp đặt các tấm pin mặt trời.

Lawal Home Service tự hào về giao tiếp minh bạch và sự chú trọng đến từng chi tiết. Các giám sát viên dự án của chúng tôi luôn có mặt tại công trường để trả lời các câu hỏi của khách hàng, cung cấp cập nhật và đảm bảo công trường an toàn, sạch sẽ. Để yêu cầu chẩn đoán mái nhà miễn phí, hãy truy cập www.lawalhomeservice.com hoặc gọi cho đại lý đặt chỗ của chúng tôi theo số 310-555-0108.

Mẫu Liên hệ Dịch vụ Nhà Lawal

Hãy tin tưởng các chuyên gia tại Lawal Home Service để chẩn đoán nhu cầu mái nhà của bạn một cách nhanh chóng và chuyên nghiệp. Vui lòng dành vài phút để hoàn thành mẫu với càng nhiều chi tiết càng tốt. Hãy nhớ rằng, tất cả các mái nhà do Lawal lắp đặt đều được bảo hành 25 năm.

(Bảng dữ liệu: Tên: Drew Gerson; Ngày: 12/12; Địa chỉ: 820 North Acacia Street, Inglewood, CA 90301).

Chúng tôi có thể giúp gì cho bạn?: Trong trận bão gió tuần trước, vài tấm lợp mái đã bị xé toạc và cần thay thế. Tôi đang cân nhắc thay toàn bộ mái vì nó đã hơn 30 năm tuổi, và nước đã bắt đầu nhỏ giọt qua phần trên hiên nhà. Tôi sẽ rất cảm kích nếu được nói chuyện với ai đó có thể cho tôi biết các lựa chọn và cung cấp bản ước tính.

Đánh giá từ khu dân cư: Dịch vụ Nhà Lawal

5 sao - "Tôi rất hài lòng với sự kỹ lưỡng trong công việc của họ."

Tôi đã để lại mô tả về vấn đề của mình cho Lawal Home Service, và một trong những chuyên gia ước tính của công ty đã đến kiểm tra mái nhà của tôi ngay ngày hôm sau. Sau khi tôi quyết định thay mái, đội ngũ Lawal đã có thể bắt đầu làm việc vào tuần sau đó. Diana Perez đã có mặt tại công trường trong suốt quá trình làm việc như đã hứa và trả lời mọi câu hỏi của tôi. Công việc bắt đầu vào ngày 19/12 và kết thúc vào ngày 20/12. Sau khi lợp mái xong, đội ngũ đã dọn dẹp rất tốt. Họ đã sử dụng hai thiết bị nam châm giống như máy cắt cỏ và quét qua toàn bộ bãi cỏ của tôi để tìm bất kỳ chiếc đinh lợp mái nào bị rơi. Tôi chưa bao giờ thấy thứ gì như vậy! Tôi rất hài lòng với sự kỹ lưỡng trong công việc của họ. — Drew Gerson, Inglewood, CA', '', '', 'cb594aff-40ff-4dd4-b919-27c0f5238ec9', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('9a4839d8-df8a-4dae-a573-a2deb2ec107b', 'toeic-test-01', 191, 7, 'reading', 'What is one service that Darboury Company most likely provides?', 'Travel booking', 'Textbook publishing', 'Flower delivery', 'Graphic design', 'D', 'Gửi: Omar Balaji

Từ: Juanita Pereira

Ngày: 10 tháng 5

Chủ đề: Yêu cầu về sổ tay

Thân gửi ông Balaji,

Chúng tôi đang mở rộng mảng văn phòng phẩm tại Bun Bun Books và muốn cung cấp một số lựa chọn sổ tay trắng có dòng kẻ. Chúng tôi muốn nhờ ông giúp tạo ra các thiết kế bìa sau đây:

- Great Thoughts: Biểu tượng bóng đèn, tia chớp và ngôi sao; Nền Xanh dương.

- World Suitcase: Vali với nhãn dán du lịch tên các quốc gia; Nền Đen.

- Lavender Bouquet: Bó hoa oải hương lớn trên cành dài xanh nhạt; Nền Vàng.

- Sail Away: Mặt trời lặn phía trên thuyền buồm trên hồ; Nền Trắng.

Chúng tôi cần có sổ tay trong kho kịp thời cho đợt giảm giá hàng năm bắt đầu từ ngày 1 tháng 8. Sau khi phê duyệt các bìa mẫu, khi nào chúng tôi cần đặt hàng?

Cảm ơn ông, Juanita Pereira

Gửi: Juanita Pereira

Từ: Omar Balaji

Ngày: 25 tháng 5

Chủ đề: Re: Yêu cầu về sổ tay

Chào cô Pereira,

Tôi đã gửi một số bìa sổ tay mẫu để cô kiểm tra. Thật không may, tôi đã không thể gửi kèm một trong các thiết kế vì nó cần thay đổi màu nền ở giai đoạn cuối. Các hình dán nghệ thuật không hiển thị rõ trên nền đen ban đầu. Chúng tôi đang thử nghiệm màu be nhạt, và tôi sẽ gửi mẫu bìa cập nhật cho cô sau khi nó được phê duyệt nội bộ. Tôi sẽ gửi mẫu cuối cùng cho cô vào cuối tuần này. Miễn là cô gửi phê duyệt cho tất cả các bìa trước ngày 11 tháng 6, chúng tôi sẽ có thể vận chuyển toàn bộ đơn hàng trước ngày 20 tháng 7. Trân trọng, Omar Balaji.

ĐƠN ĐẶT HÀNG - CÔNG TY DARBOURY

Khách hàng: Bun Bun Books. Ngày vận chuyển: 15/7. Phương thức: Tiêu chuẩn. Ngày giao hàng yêu cầu: 20/7.

- N3-GT: Sổ tay xoắn ốc kích thước chuẩn (Thiết kế: Great Thoughts) - SL: 200

- N3-WS: Sổ tay xoắn ốc kích thước chuẩn (Thiết kế: World Suitcase) - SL: 200

- H3-LB: Sổ tay ghi chép bìa cứng nhỏ (Thiết kế: Lavender Bouquet) - SL: 150

- H3-SA: Sổ tay ghi chép bìa cứng nhỏ (Thiết kế: Sail Away) - SL: 150

- D1: Giá trưng bày kim loại lớn (chứa sổ xoắn ốc chuẩn) - SL: 1', '', '', '428e81cd-4331-4327-a918-8f9304b92538', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('c03b3e41-46f5-4f38-bd39-06319f25b35c', 'toeic-test-01', 192, 7, 'reading', 'What sample was delayed?', 'Great Thoughts', 'World Suitcase', 'Lavender Bouquet', 'Sail Away', 'B', 'Gửi: Omar Balaji

Từ: Juanita Pereira

Ngày: 10 tháng 5

Chủ đề: Yêu cầu về sổ tay

Thân gửi ông Balaji,

Chúng tôi đang mở rộng mảng văn phòng phẩm tại Bun Bun Books và muốn cung cấp một số lựa chọn sổ tay trắng có dòng kẻ. Chúng tôi muốn nhờ ông giúp tạo ra các thiết kế bìa sau đây:

- Great Thoughts: Biểu tượng bóng đèn, tia chớp và ngôi sao; Nền Xanh dương.

- World Suitcase: Vali với nhãn dán du lịch tên các quốc gia; Nền Đen.

- Lavender Bouquet: Bó hoa oải hương lớn trên cành dài xanh nhạt; Nền Vàng.

- Sail Away: Mặt trời lặn phía trên thuyền buồm trên hồ; Nền Trắng.

Chúng tôi cần có sổ tay trong kho kịp thời cho đợt giảm giá hàng năm bắt đầu từ ngày 1 tháng 8. Sau khi phê duyệt các bìa mẫu, khi nào chúng tôi cần đặt hàng?

Cảm ơn ông, Juanita Pereira

Gửi: Juanita Pereira

Từ: Omar Balaji

Ngày: 25 tháng 5

Chủ đề: Re: Yêu cầu về sổ tay

Chào cô Pereira,

Tôi đã gửi một số bìa sổ tay mẫu để cô kiểm tra. Thật không may, tôi đã không thể gửi kèm một trong các thiết kế vì nó cần thay đổi màu nền ở giai đoạn cuối. Các hình dán nghệ thuật không hiển thị rõ trên nền đen ban đầu. Chúng tôi đang thử nghiệm màu be nhạt, và tôi sẽ gửi mẫu bìa cập nhật cho cô sau khi nó được phê duyệt nội bộ. Tôi sẽ gửi mẫu cuối cùng cho cô vào cuối tuần này. Miễn là cô gửi phê duyệt cho tất cả các bìa trước ngày 11 tháng 6, chúng tôi sẽ có thể vận chuyển toàn bộ đơn hàng trước ngày 20 tháng 7. Trân trọng, Omar Balaji.

ĐƠN ĐẶT HÀNG - CÔNG TY DARBOURY

Khách hàng: Bun Bun Books. Ngày vận chuyển: 15/7. Phương thức: Tiêu chuẩn. Ngày giao hàng yêu cầu: 20/7.

- N3-GT: Sổ tay xoắn ốc kích thước chuẩn (Thiết kế: Great Thoughts) - SL: 200

- N3-WS: Sổ tay xoắn ốc kích thước chuẩn (Thiết kế: World Suitcase) - SL: 200

- H3-LB: Sổ tay ghi chép bìa cứng nhỏ (Thiết kế: Lavender Bouquet) - SL: 150

- H3-SA: Sổ tay ghi chép bìa cứng nhỏ (Thiết kế: Sail Away) - SL: 150

- D1: Giá trưng bày kim loại lớn (chứa sổ xoắn ốc chuẩn) - SL: 1', '', '', '428e81cd-4331-4327-a918-8f9304b92538', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('5c735271-dc2c-46ae-9562-6d018de0efba', 'toeic-test-01', 193, 7, 'reading', 'When is the deadline for Ms. Pereira to approve samples?', 'May 25', 'June 11', 'July 20', 'August 1', 'B', 'Gửi: Omar Balaji

Từ: Juanita Pereira

Ngày: 10 tháng 5

Chủ đề: Yêu cầu về sổ tay

Thân gửi ông Balaji,

Chúng tôi đang mở rộng mảng văn phòng phẩm tại Bun Bun Books và muốn cung cấp một số lựa chọn sổ tay trắng có dòng kẻ. Chúng tôi muốn nhờ ông giúp tạo ra các thiết kế bìa sau đây:

- Great Thoughts: Biểu tượng bóng đèn, tia chớp và ngôi sao; Nền Xanh dương.

- World Suitcase: Vali với nhãn dán du lịch tên các quốc gia; Nền Đen.

- Lavender Bouquet: Bó hoa oải hương lớn trên cành dài xanh nhạt; Nền Vàng.

- Sail Away: Mặt trời lặn phía trên thuyền buồm trên hồ; Nền Trắng.

Chúng tôi cần có sổ tay trong kho kịp thời cho đợt giảm giá hàng năm bắt đầu từ ngày 1 tháng 8. Sau khi phê duyệt các bìa mẫu, khi nào chúng tôi cần đặt hàng?

Cảm ơn ông, Juanita Pereira

Gửi: Juanita Pereira

Từ: Omar Balaji

Ngày: 25 tháng 5

Chủ đề: Re: Yêu cầu về sổ tay

Chào cô Pereira,

Tôi đã gửi một số bìa sổ tay mẫu để cô kiểm tra. Thật không may, tôi đã không thể gửi kèm một trong các thiết kế vì nó cần thay đổi màu nền ở giai đoạn cuối. Các hình dán nghệ thuật không hiển thị rõ trên nền đen ban đầu. Chúng tôi đang thử nghiệm màu be nhạt, và tôi sẽ gửi mẫu bìa cập nhật cho cô sau khi nó được phê duyệt nội bộ. Tôi sẽ gửi mẫu cuối cùng cho cô vào cuối tuần này. Miễn là cô gửi phê duyệt cho tất cả các bìa trước ngày 11 tháng 6, chúng tôi sẽ có thể vận chuyển toàn bộ đơn hàng trước ngày 20 tháng 7. Trân trọng, Omar Balaji.

ĐƠN ĐẶT HÀNG - CÔNG TY DARBOURY

Khách hàng: Bun Bun Books. Ngày vận chuyển: 15/7. Phương thức: Tiêu chuẩn. Ngày giao hàng yêu cầu: 20/7.

- N3-GT: Sổ tay xoắn ốc kích thước chuẩn (Thiết kế: Great Thoughts) - SL: 200

- N3-WS: Sổ tay xoắn ốc kích thước chuẩn (Thiết kế: World Suitcase) - SL: 200

- H3-LB: Sổ tay ghi chép bìa cứng nhỏ (Thiết kế: Lavender Bouquet) - SL: 150

- H3-SA: Sổ tay ghi chép bìa cứng nhỏ (Thiết kế: Sail Away) - SL: 150

- D1: Giá trưng bày kim loại lớn (chứa sổ xoắn ốc chuẩn) - SL: 1', '', '', '428e81cd-4331-4327-a918-8f9304b92538', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('c5935cc3-0500-41ee-ac6e-297a81c3b6ed', 'toeic-test-01', 194, 7, 'reading', 'What does the form indicate about the Bun Bun Books order?', 'It will include a display stand.', 'It will ship overnight.', 'It will be paid upon delivery.', 'It will arrive late.', 'A', 'Gửi: Omar Balaji

Từ: Juanita Pereira

Ngày: 10 tháng 5

Chủ đề: Yêu cầu về sổ tay

Thân gửi ông Balaji,

Chúng tôi đang mở rộng mảng văn phòng phẩm tại Bun Bun Books và muốn cung cấp một số lựa chọn sổ tay trắng có dòng kẻ. Chúng tôi muốn nhờ ông giúp tạo ra các thiết kế bìa sau đây:

- Great Thoughts: Biểu tượng bóng đèn, tia chớp và ngôi sao; Nền Xanh dương.

- World Suitcase: Vali với nhãn dán du lịch tên các quốc gia; Nền Đen.

- Lavender Bouquet: Bó hoa oải hương lớn trên cành dài xanh nhạt; Nền Vàng.

- Sail Away: Mặt trời lặn phía trên thuyền buồm trên hồ; Nền Trắng.

Chúng tôi cần có sổ tay trong kho kịp thời cho đợt giảm giá hàng năm bắt đầu từ ngày 1 tháng 8. Sau khi phê duyệt các bìa mẫu, khi nào chúng tôi cần đặt hàng?

Cảm ơn ông, Juanita Pereira

Gửi: Juanita Pereira

Từ: Omar Balaji

Ngày: 25 tháng 5

Chủ đề: Re: Yêu cầu về sổ tay

Chào cô Pereira,

Tôi đã gửi một số bìa sổ tay mẫu để cô kiểm tra. Thật không may, tôi đã không thể gửi kèm một trong các thiết kế vì nó cần thay đổi màu nền ở giai đoạn cuối. Các hình dán nghệ thuật không hiển thị rõ trên nền đen ban đầu. Chúng tôi đang thử nghiệm màu be nhạt, và tôi sẽ gửi mẫu bìa cập nhật cho cô sau khi nó được phê duyệt nội bộ. Tôi sẽ gửi mẫu cuối cùng cho cô vào cuối tuần này. Miễn là cô gửi phê duyệt cho tất cả các bìa trước ngày 11 tháng 6, chúng tôi sẽ có thể vận chuyển toàn bộ đơn hàng trước ngày 20 tháng 7. Trân trọng, Omar Balaji.

ĐƠN ĐẶT HÀNG - CÔNG TY DARBOURY

Khách hàng: Bun Bun Books. Ngày vận chuyển: 15/7. Phương thức: Tiêu chuẩn. Ngày giao hàng yêu cầu: 20/7.

- N3-GT: Sổ tay xoắn ốc kích thước chuẩn (Thiết kế: Great Thoughts) - SL: 200

- N3-WS: Sổ tay xoắn ốc kích thước chuẩn (Thiết kế: World Suitcase) - SL: 200

- H3-LB: Sổ tay ghi chép bìa cứng nhỏ (Thiết kế: Lavender Bouquet) - SL: 150

- H3-SA: Sổ tay ghi chép bìa cứng nhỏ (Thiết kế: Sail Away) - SL: 150

- D1: Giá trưng bày kim loại lớn (chứa sổ xoắn ốc chuẩn) - SL: 1', '', '', '428e81cd-4331-4327-a918-8f9304b92538', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('55bcf709-8fc3-41b4-821e-0230dcf2d6fc', 'toeic-test-01', 195, 7, 'reading', 'What is the background color on the cover of item N3-GT?', 'Blue', 'Black', 'Yellow', 'White', 'A', 'Gửi: Omar Balaji

Từ: Juanita Pereira

Ngày: 10 tháng 5

Chủ đề: Yêu cầu về sổ tay

Thân gửi ông Balaji,

Chúng tôi đang mở rộng mảng văn phòng phẩm tại Bun Bun Books và muốn cung cấp một số lựa chọn sổ tay trắng có dòng kẻ. Chúng tôi muốn nhờ ông giúp tạo ra các thiết kế bìa sau đây:

- Great Thoughts: Biểu tượng bóng đèn, tia chớp và ngôi sao; Nền Xanh dương.

- World Suitcase: Vali với nhãn dán du lịch tên các quốc gia; Nền Đen.

- Lavender Bouquet: Bó hoa oải hương lớn trên cành dài xanh nhạt; Nền Vàng.

- Sail Away: Mặt trời lặn phía trên thuyền buồm trên hồ; Nền Trắng.

Chúng tôi cần có sổ tay trong kho kịp thời cho đợt giảm giá hàng năm bắt đầu từ ngày 1 tháng 8. Sau khi phê duyệt các bìa mẫu, khi nào chúng tôi cần đặt hàng?

Cảm ơn ông, Juanita Pereira

Gửi: Juanita Pereira

Từ: Omar Balaji

Ngày: 25 tháng 5

Chủ đề: Re: Yêu cầu về sổ tay

Chào cô Pereira,

Tôi đã gửi một số bìa sổ tay mẫu để cô kiểm tra. Thật không may, tôi đã không thể gửi kèm một trong các thiết kế vì nó cần thay đổi màu nền ở giai đoạn cuối. Các hình dán nghệ thuật không hiển thị rõ trên nền đen ban đầu. Chúng tôi đang thử nghiệm màu be nhạt, và tôi sẽ gửi mẫu bìa cập nhật cho cô sau khi nó được phê duyệt nội bộ. Tôi sẽ gửi mẫu cuối cùng cho cô vào cuối tuần này. Miễn là cô gửi phê duyệt cho tất cả các bìa trước ngày 11 tháng 6, chúng tôi sẽ có thể vận chuyển toàn bộ đơn hàng trước ngày 20 tháng 7. Trân trọng, Omar Balaji.

ĐƠN ĐẶT HÀNG - CÔNG TY DARBOURY

Khách hàng: Bun Bun Books. Ngày vận chuyển: 15/7. Phương thức: Tiêu chuẩn. Ngày giao hàng yêu cầu: 20/7.

- N3-GT: Sổ tay xoắn ốc kích thước chuẩn (Thiết kế: Great Thoughts) - SL: 200

- N3-WS: Sổ tay xoắn ốc kích thước chuẩn (Thiết kế: World Suitcase) - SL: 200

- H3-LB: Sổ tay ghi chép bìa cứng nhỏ (Thiết kế: Lavender Bouquet) - SL: 150

- H3-SA: Sổ tay ghi chép bìa cứng nhỏ (Thiết kế: Sail Away) - SL: 150

- D1: Giá trưng bày kim loại lớn (chứa sổ xoắn ốc chuẩn) - SL: 1', '', '', '428e81cd-4331-4327-a918-8f9304b92538', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('d3d374ec-e33a-4c0c-8f45-cca5b2f31f46', 'toeic-test-01', 196, 7, 'reading', 'What is the purpose of the e-mail?', 'To share a list of job candidates', 'To ask for opinions from managers', 'To summarize a managers’ meeting', 'To nominate a manager for an award', 'B', 'Gửi: Các quản lý

Từ: Charlotte Black

Ngày: 16 tháng 8

Chủ đề: Nhân viên của tháng

Thân gửi các Quản lý,

Đã đến lúc bình chọn Nhân viên của tháng cho tháng 9 tại Wilson Autos. Dưới đây là các ứng cử viên.

Erica Boyd mới làm việc với chúng ta vài tháng nhưng đã cho thấy tiềm năng lớn và rất ham học hỏi những điều mới.

Lauren Almahdi rất chủ động. Nếu có việc cần làm, cô ấy sẽ chỉ ra cho quản lý và tình nguyện tự mình xử lý.

Nick Salehi đã tìm thấy một lỗi trong hệ thống máy tính của chúng ta và ngăn chặn việc đặt hàng nhầm kho bãi không cần thiết (từ đó giúp chúng ta tiết kiệm tiền).

Max Rhodes đặc biệt hữu ích trong việc đào tạo nhân viên mới. Anh ấy bình tĩnh, kiên nhẫn và giải thích các quy trình của chúng ta rất tốt.

Vui lòng phản hồi email này trước thứ Sáu kèm theo phiếu bầu của bạn. Người chiến thắng phải nhận được ít nhất ba phiếu bầu. Người chiến thắng sẽ được niêm yết tại quầy lễ tân và trên trang web của chúng ta vào thứ Hai tới.

Trân trọng,

Charlotte Black - Tổng quản lý, Wilson Autos

---

Westchester Reviews: Wilson Autos (Westchester)

5 sao - Vợ chồng tôi vừa mua một chiếc xe tải Excelera mới tại Wilson Autos cơ sở Westchester với sự giúp đỡ của Erica Boyd. Dù là nhân viên mới, cô ấy rất am hiểu về tất cả các loại xe tải mà chúng tôi muốn lái thử. Một vài câu hỏi cô ấy không trả lời được đã được người hướng dẫn của cô ấy, Max, giải quyết nhanh chóng. Chúng tôi rất hài lòng với dịch vụ khách hàng và còn vui mừng hơn khi tổng quản lý đồng ý bán chiếc Excelera với cùng mức giá mà một đại lý cạnh tranh đang quảng cáo. Tôi thực sự khuyên bạn nên đến Wilson Autos nếu bạn đang muốn mua một chiếc xe mới! — Henry Riggs, 22 tháng 8

---

NHÂN VIÊN CỦA THÁNG 9 LÀ ERICA BOYD!

Trong 3 tháng tại Wilson Autos, Erica đã tiếp thu các kỹ năng mới nhanh chóng và luôn cố gắng học hỏi thêm. Cô ấy đã trở nên rất am hiểu về kho hàng của chúng ta và có thể chia sẻ kiến thức đó với khách hàng để hoàn tất việc bán hàng. Cô ấy cũng là người góp công lớn trong việc khuyến khích những khách hàng hài lòng đăng ý kiến lên các trang mạng xã hội của chúng ta. Chúng ta đã nhận được nhiều đánh giá tốt trong tháng qua hơn cả 4 tháng trước đó cộng lại! Erica đã nhận được thẻ quà tặng trị giá 50 đô la tại Nhà hàng Alonzo như một lời cảm ơn. Chúc mừng Erica!', '', '', '746eac99-7cf3-46e4-b096-c533edf9d23c', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('8228a5f4-3969-4a1e-9338-1c5a3b4bf670', 'toeic-test-01', 197, 7, 'reading', 'According to the e-mail, who identified a technical problem?', 'Mr. Salehi', 'Ms. Almahdi', 'Mr. Rhodes', 'Ms. Black', 'A', 'Gửi: Các quản lý

Từ: Charlotte Black

Ngày: 16 tháng 8

Chủ đề: Nhân viên của tháng

Thân gửi các Quản lý,

Đã đến lúc bình chọn Nhân viên của tháng cho tháng 9 tại Wilson Autos. Dưới đây là các ứng cử viên.

Erica Boyd mới làm việc với chúng ta vài tháng nhưng đã cho thấy tiềm năng lớn và rất ham học hỏi những điều mới.

Lauren Almahdi rất chủ động. Nếu có việc cần làm, cô ấy sẽ chỉ ra cho quản lý và tình nguyện tự mình xử lý.

Nick Salehi đã tìm thấy một lỗi trong hệ thống máy tính của chúng ta và ngăn chặn việc đặt hàng nhầm kho bãi không cần thiết (từ đó giúp chúng ta tiết kiệm tiền).

Max Rhodes đặc biệt hữu ích trong việc đào tạo nhân viên mới. Anh ấy bình tĩnh, kiên nhẫn và giải thích các quy trình của chúng ta rất tốt.

Vui lòng phản hồi email này trước thứ Sáu kèm theo phiếu bầu của bạn. Người chiến thắng phải nhận được ít nhất ba phiếu bầu. Người chiến thắng sẽ được niêm yết tại quầy lễ tân và trên trang web của chúng ta vào thứ Hai tới.

Trân trọng,

Charlotte Black - Tổng quản lý, Wilson Autos

---

Westchester Reviews: Wilson Autos (Westchester)

5 sao - Vợ chồng tôi vừa mua một chiếc xe tải Excelera mới tại Wilson Autos cơ sở Westchester với sự giúp đỡ của Erica Boyd. Dù là nhân viên mới, cô ấy rất am hiểu về tất cả các loại xe tải mà chúng tôi muốn lái thử. Một vài câu hỏi cô ấy không trả lời được đã được người hướng dẫn của cô ấy, Max, giải quyết nhanh chóng. Chúng tôi rất hài lòng với dịch vụ khách hàng và còn vui mừng hơn khi tổng quản lý đồng ý bán chiếc Excelera với cùng mức giá mà một đại lý cạnh tranh đang quảng cáo. Tôi thực sự khuyên bạn nên đến Wilson Autos nếu bạn đang muốn mua một chiếc xe mới! — Henry Riggs, 22 tháng 8

---

NHÂN VIÊN CỦA THÁNG 9 LÀ ERICA BOYD!

Trong 3 tháng tại Wilson Autos, Erica đã tiếp thu các kỹ năng mới nhanh chóng và luôn cố gắng học hỏi thêm. Cô ấy đã trở nên rất am hiểu về kho hàng của chúng ta và có thể chia sẻ kiến thức đó với khách hàng để hoàn tất việc bán hàng. Cô ấy cũng là người góp công lớn trong việc khuyến khích những khách hàng hài lòng đăng ý kiến lên các trang mạng xã hội của chúng ta. Chúng ta đã nhận được nhiều đánh giá tốt trong tháng qua hơn cả 4 tháng trước đó cộng lại! Erica đã nhận được thẻ quà tặng trị giá 50 đô la tại Nhà hàng Alonzo như một lời cảm ơn. Chúc mừng Erica!', '', '', '746eac99-7cf3-46e4-b096-c533edf9d23c', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('cda7c054-a96e-4340-9a47-9c3138bba95e', 'toeic-test-01', 198, 7, 'reading', 'What can be concluded about Mr. Riggs?', 'His previous vehicle was an Excelera truck.', 'He is a neighbor of Ms. Boyd’s.', 'He has purchased a vehicle from Wilson Autos in the past.', 'He negotiated with Ms. Black for a lower price.', 'D', 'Gửi: Các quản lý

Từ: Charlotte Black

Ngày: 16 tháng 8

Chủ đề: Nhân viên của tháng

Thân gửi các Quản lý,

Đã đến lúc bình chọn Nhân viên của tháng cho tháng 9 tại Wilson Autos. Dưới đây là các ứng cử viên.

Erica Boyd mới làm việc với chúng ta vài tháng nhưng đã cho thấy tiềm năng lớn và rất ham học hỏi những điều mới.

Lauren Almahdi rất chủ động. Nếu có việc cần làm, cô ấy sẽ chỉ ra cho quản lý và tình nguyện tự mình xử lý.

Nick Salehi đã tìm thấy một lỗi trong hệ thống máy tính của chúng ta và ngăn chặn việc đặt hàng nhầm kho bãi không cần thiết (từ đó giúp chúng ta tiết kiệm tiền).

Max Rhodes đặc biệt hữu ích trong việc đào tạo nhân viên mới. Anh ấy bình tĩnh, kiên nhẫn và giải thích các quy trình của chúng ta rất tốt.

Vui lòng phản hồi email này trước thứ Sáu kèm theo phiếu bầu của bạn. Người chiến thắng phải nhận được ít nhất ba phiếu bầu. Người chiến thắng sẽ được niêm yết tại quầy lễ tân và trên trang web của chúng ta vào thứ Hai tới.

Trân trọng,

Charlotte Black - Tổng quản lý, Wilson Autos

---

Westchester Reviews: Wilson Autos (Westchester)

5 sao - Vợ chồng tôi vừa mua một chiếc xe tải Excelera mới tại Wilson Autos cơ sở Westchester với sự giúp đỡ của Erica Boyd. Dù là nhân viên mới, cô ấy rất am hiểu về tất cả các loại xe tải mà chúng tôi muốn lái thử. Một vài câu hỏi cô ấy không trả lời được đã được người hướng dẫn của cô ấy, Max, giải quyết nhanh chóng. Chúng tôi rất hài lòng với dịch vụ khách hàng và còn vui mừng hơn khi tổng quản lý đồng ý bán chiếc Excelera với cùng mức giá mà một đại lý cạnh tranh đang quảng cáo. Tôi thực sự khuyên bạn nên đến Wilson Autos nếu bạn đang muốn mua một chiếc xe mới! — Henry Riggs, 22 tháng 8

---

NHÂN VIÊN CỦA THÁNG 9 LÀ ERICA BOYD!

Trong 3 tháng tại Wilson Autos, Erica đã tiếp thu các kỹ năng mới nhanh chóng và luôn cố gắng học hỏi thêm. Cô ấy đã trở nên rất am hiểu về kho hàng của chúng ta và có thể chia sẻ kiến thức đó với khách hàng để hoàn tất việc bán hàng. Cô ấy cũng là người góp công lớn trong việc khuyến khích những khách hàng hài lòng đăng ý kiến lên các trang mạng xã hội của chúng ta. Chúng ta đã nhận được nhiều đánh giá tốt trong tháng qua hơn cả 4 tháng trước đó cộng lại! Erica đã nhận được thẻ quà tặng trị giá 50 đô la tại Nhà hàng Alonzo như một lời cảm ơn. Chúc mừng Erica!', '', '', '746eac99-7cf3-46e4-b096-c533edf9d23c', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('861d9756-1137-4480-aed8-13142fdb2c9c', 'toeic-test-01', 199, 7, 'reading', 'What is indicated in the notice about Ms. Boyd?', 'She eats regularly at Alonzo’s Restaurant.', 'She manages social media sites for Wilson Autos.', 'She is responsible for an increase in customer feedback.', 'She recently completed a sales training course.', 'C', 'Gửi: Các quản lý

Từ: Charlotte Black

Ngày: 16 tháng 8

Chủ đề: Nhân viên của tháng

Thân gửi các Quản lý,

Đã đến lúc bình chọn Nhân viên của tháng cho tháng 9 tại Wilson Autos. Dưới đây là các ứng cử viên.

Erica Boyd mới làm việc với chúng ta vài tháng nhưng đã cho thấy tiềm năng lớn và rất ham học hỏi những điều mới.

Lauren Almahdi rất chủ động. Nếu có việc cần làm, cô ấy sẽ chỉ ra cho quản lý và tình nguyện tự mình xử lý.

Nick Salehi đã tìm thấy một lỗi trong hệ thống máy tính của chúng ta và ngăn chặn việc đặt hàng nhầm kho bãi không cần thiết (từ đó giúp chúng ta tiết kiệm tiền).

Max Rhodes đặc biệt hữu ích trong việc đào tạo nhân viên mới. Anh ấy bình tĩnh, kiên nhẫn và giải thích các quy trình của chúng ta rất tốt.

Vui lòng phản hồi email này trước thứ Sáu kèm theo phiếu bầu của bạn. Người chiến thắng phải nhận được ít nhất ba phiếu bầu. Người chiến thắng sẽ được niêm yết tại quầy lễ tân và trên trang web của chúng ta vào thứ Hai tới.

Trân trọng,

Charlotte Black - Tổng quản lý, Wilson Autos

---

Westchester Reviews: Wilson Autos (Westchester)

5 sao - Vợ chồng tôi vừa mua một chiếc xe tải Excelera mới tại Wilson Autos cơ sở Westchester với sự giúp đỡ của Erica Boyd. Dù là nhân viên mới, cô ấy rất am hiểu về tất cả các loại xe tải mà chúng tôi muốn lái thử. Một vài câu hỏi cô ấy không trả lời được đã được người hướng dẫn của cô ấy, Max, giải quyết nhanh chóng. Chúng tôi rất hài lòng với dịch vụ khách hàng và còn vui mừng hơn khi tổng quản lý đồng ý bán chiếc Excelera với cùng mức giá mà một đại lý cạnh tranh đang quảng cáo. Tôi thực sự khuyên bạn nên đến Wilson Autos nếu bạn đang muốn mua một chiếc xe mới! — Henry Riggs, 22 tháng 8

---

NHÂN VIÊN CỦA THÁNG 9 LÀ ERICA BOYD!

Trong 3 tháng tại Wilson Autos, Erica đã tiếp thu các kỹ năng mới nhanh chóng và luôn cố gắng học hỏi thêm. Cô ấy đã trở nên rất am hiểu về kho hàng của chúng ta và có thể chia sẻ kiến thức đó với khách hàng để hoàn tất việc bán hàng. Cô ấy cũng là người góp công lớn trong việc khuyến khích những khách hàng hài lòng đăng ý kiến lên các trang mạng xã hội của chúng ta. Chúng ta đã nhận được nhiều đánh giá tốt trong tháng qua hơn cả 4 tháng trước đó cộng lại! Erica đã nhận được thẻ quà tặng trị giá 50 đô la tại Nhà hàng Alonzo như một lời cảm ơn. Chúc mừng Erica!', '', '', '746eac99-7cf3-46e4-b096-c533edf9d23c', '') ON CONFLICT (exam_code, question_number) DO NOTHING;
INSERT INTO questions (id, exam_code, question_number, part, section, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation_vi, audio_url, image_url, passage_id, passage_text) VALUES ('79763fe6-8e71-42eb-a13e-2e9825c266c5', 'toeic-test-01', 200, 7, 'reading', 'What is most likely true about Ms. Boyd?', 'She received votes from at least three managers.', 'She was the top salesperson in August.', 'She has years of experience in the auto industry.', 'She was hired by Wilson Autos in April.', 'A', 'Gửi: Các quản lý

Từ: Charlotte Black

Ngày: 16 tháng 8

Chủ đề: Nhân viên của tháng

Thân gửi các Quản lý,

Đã đến lúc bình chọn Nhân viên của tháng cho tháng 9 tại Wilson Autos. Dưới đây là các ứng cử viên.

Erica Boyd mới làm việc với chúng ta vài tháng nhưng đã cho thấy tiềm năng lớn và rất ham học hỏi những điều mới.

Lauren Almahdi rất chủ động. Nếu có việc cần làm, cô ấy sẽ chỉ ra cho quản lý và tình nguyện tự mình xử lý.

Nick Salehi đã tìm thấy một lỗi trong hệ thống máy tính của chúng ta và ngăn chặn việc đặt hàng nhầm kho bãi không cần thiết (từ đó giúp chúng ta tiết kiệm tiền).

Max Rhodes đặc biệt hữu ích trong việc đào tạo nhân viên mới. Anh ấy bình tĩnh, kiên nhẫn và giải thích các quy trình của chúng ta rất tốt.

Vui lòng phản hồi email này trước thứ Sáu kèm theo phiếu bầu của bạn. Người chiến thắng phải nhận được ít nhất ba phiếu bầu. Người chiến thắng sẽ được niêm yết tại quầy lễ tân và trên trang web của chúng ta vào thứ Hai tới.

Trân trọng,

Charlotte Black - Tổng quản lý, Wilson Autos

---

Westchester Reviews: Wilson Autos (Westchester)

5 sao - Vợ chồng tôi vừa mua một chiếc xe tải Excelera mới tại Wilson Autos cơ sở Westchester với sự giúp đỡ của Erica Boyd. Dù là nhân viên mới, cô ấy rất am hiểu về tất cả các loại xe tải mà chúng tôi muốn lái thử. Một vài câu hỏi cô ấy không trả lời được đã được người hướng dẫn của cô ấy, Max, giải quyết nhanh chóng. Chúng tôi rất hài lòng với dịch vụ khách hàng và còn vui mừng hơn khi tổng quản lý đồng ý bán chiếc Excelera với cùng mức giá mà một đại lý cạnh tranh đang quảng cáo. Tôi thực sự khuyên bạn nên đến Wilson Autos nếu bạn đang muốn mua một chiếc xe mới! — Henry Riggs, 22 tháng 8

---

NHÂN VIÊN CỦA THÁNG 9 LÀ ERICA BOYD!

Trong 3 tháng tại Wilson Autos, Erica đã tiếp thu các kỹ năng mới nhanh chóng và luôn cố gắng học hỏi thêm. Cô ấy đã trở nên rất am hiểu về kho hàng của chúng ta và có thể chia sẻ kiến thức đó với khách hàng để hoàn tất việc bán hàng. Cô ấy cũng là người góp công lớn trong việc khuyến khích những khách hàng hài lòng đăng ý kiến lên các trang mạng xã hội của chúng ta. Chúng ta đã nhận được nhiều đánh giá tốt trong tháng qua hơn cả 4 tháng trước đó cộng lại! Erica đã nhận được thẻ quà tặng trị giá 50 đô la tại Nhà hàng Alonzo như một lời cảm ơn. Chúc mừng Erica!', '', '', '746eac99-7cf3-46e4-b096-c533edf9d23c', '') ON CONFLICT (exam_code, question_number) DO NOTHING;

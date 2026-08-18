CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    google_id VARCHAR(255) UNIQUE,
    email VARCHAR(255) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    picture TEXT,
    password_hash VARCHAR(255),
    role VARCHAR(50) NOT NULL DEFAULT 'STUDENT',
    tenant_id VARCHAR(255),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Dữ liệu thuộc exam-service. Lưu từng lần nộp bài và các đáp án để có thể
-- dựng lại lịch sử / phân tích sau này mà không cần thay đổi account-service.
CREATE TABLE IF NOT EXISTS exam_results (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    exam_code VARCHAR(100) NOT NULL,
    listening_correct SMALLINT NOT NULL CHECK (listening_correct BETWEEN 0 AND 100),
    reading_correct SMALLINT NOT NULL CHECK (reading_correct BETWEEN 0 AND 100),
    listening_score SMALLINT NOT NULL CHECK (listening_score BETWEEN 5 AND 495),
    reading_score SMALLINT NOT NULL CHECK (reading_score BETWEEN 5 AND 495),
    total_score SMALLINT NOT NULL CHECK (total_score BETWEEN 10 AND 990),
    answers JSONB NOT NULL DEFAULT '{}'::jsonb,
    submitted_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS exam_results_user_submitted_idx
    ON exam_results (user_id, submitted_at DESC);

CREATE TABLE IF NOT EXISTS exams (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    code VARCHAR(100) UNIQUE NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    duration_minutes SMALLINT NOT NULL DEFAULT 120 CHECK (duration_minutes > 0),
    status VARCHAR(20) NOT NULL DEFAULT 'PUBLISHED' CHECK (status IN ('DRAFT', 'PUBLISHED')),
    questions JSONB NOT NULL,
    created_by UUID REFERENCES users(id) ON DELETE SET NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Superadmin mặc định
INSERT INTO users (email, name, password_hash, role) 
VALUES ('admin@toeic.com', 'Super Admin', '$2b$10$h0JyYlmhmJRUWSd79l//ee7aFEqIl20n/etc/BkmReaEoFFtDAxDa', 'SUPERADMIN') -- pass: admin123
ON CONFLICT (email) DO NOTHING;

-- Dữ liệu câu hỏi chi tiết của exam-service
CREATE TABLE IF NOT EXISTS questions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
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
);

CREATE INDEX IF NOT EXISTS questions_exam_code_idx ON questions (exam_code);
CREATE INDEX IF NOT EXISTS questions_exam_code_part_idx ON questions (exam_code, part);

-- Hồ sơ học tập và AI Memory của học viên
CREATE TABLE IF NOT EXISTS ai_student_profiles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID UNIQUE NOT NULL,
    target_score SMALLINT NOT NULL DEFAULT 750,
    duration_days SMALLINT NOT NULL DEFAULT 30,
    active_roadmap JSONB,
    daily_lessons_cache JSONB,
    daily_quiz_results JSONB,
    completed_task_keys JSONB,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);


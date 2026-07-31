# Sơ đồ Kiến trúc Database & Luồng Hoạt Động

## Bảng thừa đã xóa

| Nơi | Bảng thừa | Lý do thừa | Đã xử lý |
|---|---|---|---|
| `toeic_auth` | `exam_results`, `exams` | Tạo ra do `init-db.sql` chạy trên sai DB | ✅ Đã xóa |
| `toeic_exam` | (đã xóa `exams`, `users` trước đó) | Prisma push đồng bộ sai schema | ✅ Đã xóa |

---

## Sơ đồ cấu trúc DB (sau khi dọn dẹp)

```mermaid
erDiagram
    %% ─── toeic_auth (port 5433) ───
    USERS {
        uuid id PK
        string email UK
        string name
        string password_hash
        string role
        string tenant_id
        string google_id
        timestamp created_at
    }

    %% ─── toeic_catalog (port 5435) ───
    EXAMS {
        uuid id PK
        string code UK
        string title
        string description
        int duration_minutes
        string status
        timestamp created_at
    }

    %% ─── toeic_exam (port 5434) ───
    QUESTIONS {
        uuid id PK
        string exam_code FK
        int question_number
        int part
        string question_text
        string option_a
        string option_b
        string option_c
        string option_d
        string correct_answer
        string explanation_vi
        text passage_text
        string audio_url
        string image_url
    }

    EXAM_RESULTS {
        uuid id PK
        uuid user_id FK
        string exam_code FK
        int listening_score
        int reading_score
        int total_score
        json answers
        timestamp submitted_at
    }

    %% Liên kết logic (không FK vật lý vì khác DB)
    USERS ||--o{ EXAM_RESULTS : "user_id → id (logic)"
    EXAMS ||--o{ QUESTIONS    : "code → exam_code (logic)"
    EXAMS ||--o{ EXAM_RESULTS : "code → exam_code (logic)"
```

---

## Luồng hoạt động đầy đủ

```mermaid
sequenceDiagram
    actor User as 👤 Người dùng
    participant FE as React Frontend<br/>:5173
    participant GW as API Gateway<br/>:4000
    participant AS as account-service<br/>:4001
    participant ES as exam-service<br/>:4002
    participant CS as catalog-service<br/>:4003
    participant AuthDB as toeic_auth<br/>:5433
    participant ExamDB as toeic_exam<br/>:5434
    participant CatDB as toeic_catalog<br/>:5435

    Note over User,CatDB: 🔑 LUỒNG 1: ĐĂNG NHẬP
    User->>FE: Nhập email + password
    FE->>GW: POST /api/auth/login
    GW->>AS: forward →
    AS->>AuthDB: SELECT * FROM users WHERE email=?
    AuthDB-->>AS: user record + password_hash
    AS-->>GW: JWT Token + user info
    GW-->>FE: token (role: STUDENT/MANAGER/SUPERADMIN)
    FE->>FE: Lưu token, navigate theo role

    Note over User,CatDB: 📋 LUỒNG 2: XEM DANH SÁCH ĐỀ THI
    User->>FE: Vào trang Trung tâm đề thi
    FE->>GW: GET /api/exams (JWT header)
    GW->>CS: forward → (catalog-service)
    CS->>CatDB: SELECT code,title,duration FROM exams
    CatDB-->>CS: 10 đề (metadata nhẹ, không có câu hỏi)
    CS-->>GW: [{code, title, duration, question_count:200}]
    GW-->>FE: danh sách 10 đề

    Note over User,CatDB: 📝 LUỒNG 3: VÀO PHÒNG THI
    User->>FE: Bấm "Bắt đầu thi" trên đề toeic-test-01
    FE->>GW: GET /api/exams/toeic-test-01
    GW->>ES: forward → (exam-service) ← routing mới!
    ES->>ExamDB: SELECT * FROM questions WHERE exam_code='toeic-test-01' ORDER BY question_number
    ExamDB-->>ES: 200 câu hỏi + passage + audio
    ES-->>GW: {exam: {code, title, questions:[200 câu]}}
    GW-->>FE: 200 câu đầy đủ
    FE->>FE: Render giao diện thi

    Note over User,CatDB: ✅ LUỒNG 4: NỘP BÀI
    User->>FE: Bấm "Nộp bài"
    FE->>GW: POST /api/exam-results (JWT + đáp án)
    GW->>ES: forward → (exam-service)
    ES->>ES: Tính điểm Listening + Reading
    ES->>ExamDB: INSERT INTO exam_results (user_id, exam_code, ...)
    ExamDB-->>ES: result saved
    ES-->>FE: {totalScore: 735, listeningScore: 350, readingScore: 385}
    FE->>User: Hiển thị kết quả
```

---

## Fault Isolation — Khi một service bị sập

```mermaid
graph TD
    subgraph "✅ catalog-service SẬP"
        A1[Trang danh sách đề ❌] 
        A2[Đang thi: vẫn OK ✅]
        A3[Đăng nhập: vẫn OK ✅]
        A4[Nộp bài: vẫn OK ✅]
    end

    subgraph "✅ exam-service SẬP"
        B1[Trang danh sách đề: OK ✅]
        B2[Vào phòng thi: thất bại ❌]
        B3[Nộp bài: thất bại ❌]
        B4[Đăng nhập: vẫn OK ✅]
    end

    subgraph "✅ account-service SẬP"
        C1[Đăng nhập mới: thất bại ❌]
        C2[Đang thi (đã login): vẫn OK ✅]
        C3[Nộp bài: vẫn OK ✅]
    end
```

> **Giải thích nguyên tắc:** Mỗi service chỉ biết về DB của mình. Liên kết giữa các bảng khác DB là **liên kết logic** qua `exam_code` (chuỗi "toeic-test-01") và `user_id` (UUID), không phải **Foreign Key vật lý**. Điều này cho phép mỗi DB scale và fail độc lập.

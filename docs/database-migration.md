# Tách database theo service

`legacy-postgres` giữ nguyên database cũ để có thể đối chiếu hoặc rollback. Database mới được service sở hữu hoàn toàn:

| Service | Database |
| --- | --- |
| account-service | `auth-db` / `toeic_auth` |
| exam-service | `exam-db` / `toeic_exam` |
| catalog-service | `catalog-db` / `toeic_catalog` |

Trước khi khởi động môi trường mới, sao chép `.env.example` thành `.env` và thay toàn bộ secret. Với dữ liệu hiện có, export bảng `users` từ legacy sang `auth-db`, `exam_results` sang `exam-db`, và `exams` sang `catalog-db`. Không xóa `legacy-postgres` cho đến khi xác nhận đăng nhập, lịch sử bài làm và thư viện đề hoạt động trên database mới.

Prisma schema của mỗi service là contract sở hữu dữ liệu; service khác không được kết nối trực tiếp vào database đó.

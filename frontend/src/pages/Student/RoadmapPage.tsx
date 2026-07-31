import { Shell } from '../../components/UI';
import AIRoadmapWidget from '../../components/AIRoadmapWidget';

export default function RoadmapPage() {
  return (
    <Shell page="/student/roadmap">
      <div className="content">
        <div className="page-title" style={{ marginBottom: '24px' }}>
          <div>
            <h1>Lộ Trình Học TOEIC Cá Nhân Hóa 🚀</h1>
            <p>Hệ thống AI tự động chẩn đoán điểm yếu, thiết lập lộ trình & biên soạn bài học 60 phút theo ngày.</p>
          </div>
        </div>

        <AIRoadmapWidget />
      </div>
    </Shell>
  );
}

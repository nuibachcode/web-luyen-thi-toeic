import { Shell } from '../../components/UI';
import { useLocation } from 'react-router-dom';

import ManagerOverview from './ManagerOverview';
import ManagerStudents from './ManagerStudents';
import ManagerExams from './ManagerExams';
import ManagerReports from './ManagerReports';
import ManagerSettings from './ManagerSettings';

export default function ManagerDashboard() {
  const location = useLocation();

  const subpage = location.pathname.includes('reports') ? 'reports'
    : location.pathname.includes('users') ? 'users'
    : location.pathname.includes('exams') ? 'exams'
    : location.pathname.includes('settings') ? 'settings'
    : 'overview';

  const titles: Record<string, [string, string]> = {
    overview: ['TỔNG QUAN', 'Theo dõi hiệu suất học tập của lớp bạn'],
    users:    ['HỌC VIÊN', 'Quản lý danh sách học viên'],
    exams:    ['ĐỀ THI', 'Quản lý đề thi'],
    reports:  ['BÁO CÁO', 'Báo cáo kết quả học tập'],
    settings: ['CÀI ĐẶT', 'Cài đặt'],
  };

  const [eyebrow, desc] = titles[subpage];

  return (
    <Shell page={`/manager${subpage === 'overview' ? '' : `/${subpage}`}`}>
      <div className="content">
        <div className="page-title">
          <div>
            <span className="eyebrow">MANAGER • {eyebrow}</span>
            <h1>{desc}</h1>
          </div>
        </div>

        {subpage === 'overview' && <ManagerOverview />}
        {subpage === 'users'    && <ManagerStudents />}
        {subpage === 'exams'    && <ManagerExams />}
        {subpage === 'reports'  && <ManagerReports />}
        {subpage === 'settings' && <ManagerSettings />}
      </div>
    </Shell>
  );
}

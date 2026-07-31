import { useAuth } from '../../context/AuthContext';
import { useNavigate } from 'react-router-dom';

export default function SuperadminDashboard() {
  const { user, logout } = useAuth();
  const navigate = useNavigate();

  const handleLogout = () => {
    logout();
    navigate('/');
  };

  return (
    <div className="app-container">
      <header className="glass-header" style={{ display: 'flex', justifyContent: 'space-between', padding: '1rem 2rem' }}>
        <h2>System Administration (Superadmin)</h2>
        <div style={{ display: 'flex', gap: '1rem', alignItems: 'center' }}>
          <span>Xin chào, <strong style={{ color: 'var(--accent-primary)' }}>{user?.name}</strong></span>
          <button className="btn btn-outline" onClick={handleLogout}>Đăng xuất</button>
        </div>
      </header>
      
      <main className="main-content" style={{ flexDirection: 'column' }}>
        <div className="glass-panel animate-fade-in" style={{ padding: '2rem' }}>
          <h3 style={{ marginBottom: '1.5rem', color: 'var(--warning)' }}>Quản lý Dữ liệu Hệ thống</h3>
          <p>Tại đây, bạn có quyền cao nhất để vận hành toàn bộ phần mềm.</p>
          
          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: '1.5rem', marginTop: '2rem' }}>
            <div style={{ background: 'rgba(255,255,255,0.02)', padding: '1.5rem', borderRadius: 'var(--radius-md)', border: '1px solid var(--border-color)' }}>
              <h4>Quản lý Khách hàng B2B (Managers)</h4>
              <p style={{ fontSize: '0.9rem', color: 'var(--text-muted)' }}>Cấp phát tài khoản cho các Trung tâm/Giáo viên thuê nền tảng.</p>
              <button className="btn btn-primary" style={{ marginTop: '1rem' }}>Xem Danh sách</button>
            </div>
            
            <div style={{ background: 'rgba(255,255,255,0.02)', padding: '1.5rem', borderRadius: 'var(--radius-md)', border: '1px solid var(--border-color)' }}>
              <h4>Quản lý Kho Đề Thi (Data Ingestion)</h4>
              <p style={{ fontSize: '0.9rem', color: 'var(--text-muted)' }}>Cào dữ liệu tự động hoặc upload file JSON hàng loạt.</p>
              <button className="btn btn-primary" style={{ marginTop: '1rem' }}>Quản lý Đề thi</button>
            </div>
            
            <div style={{ background: 'rgba(255,255,255,0.02)', padding: '1.5rem', borderRadius: 'var(--radius-md)', border: '1px solid var(--border-color)' }}>
              <h4>Cài đặt Hệ thống</h4>
              <p style={{ fontSize: '0.9rem', color: 'var(--text-muted)' }}>Thiết lập SMTP, Cổng thanh toán, Cấu hình AWS/Supabase.</p>
              <button className="btn btn-outline" style={{ marginTop: '1rem' }}>Thiết lập</button>
            </div>
          </div>
        </div>
      </main>
    </div>
  );
}

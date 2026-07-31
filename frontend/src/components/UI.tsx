import React from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import AITutorWidget from './AITutorWidget';

export function Logo({ light = false }: { light?: boolean }) {
  const navigate = useNavigate();
  return (
    <button
      className={'logo ' + (light ? 'light' : '')}
      onClick={() => navigate('/')}
      style={{ display: 'inline-flex', alignItems: 'center', gap: 10, background: 'none', border: 'none', cursor: 'pointer', padding: 0, whiteSpace: 'nowrap' }}
    >
      <img
        src="/logo.png"
        alt="AeroTOEIC AI Logo"
        style={{
          width: 34, height: 34, objectFit: 'cover', borderRadius: '50%',
          border: '1.5px solid #2563eb', boxShadow: '0 2px 8px rgba(37,99,235,0.25)',
          flexShrink: 0
        }}
      />
      <span style={{ fontSize: 18, fontWeight: 800, color: light ? '#ffffff' : '#0f172a', letterSpacing: '-0.02em', background: 'transparent', display: 'inline-flex', gap: 4 }}>
        AeroTOEIC <span style={{ color: '#2563eb', fontWeight: 800 }}>AI</span>
      </span>
    </button>
  );
}

export function Button({
  children,
  onClick,
  variant = 'primary',
  type = 'button',
  disabled = false,
  style
}: {
  children: React.ReactNode;
  onClick?: () => void;
  variant?: 'primary' | 'outline' | 'ghost';
  type?: 'button' | 'submit';
  disabled?: boolean;
  style?: React.CSSProperties;
}) {
  return (
    <button type={type} onClick={onClick} className={'button ' + variant} disabled={disabled} style={style}>
      {children}
    </button>
  );
}

export function Stat({
  icon,
  label,
  value,
  note,
  tone = 'blue'
}: {
  icon: string;
  label: string;
  value: string;
  note?: string;
  tone?: 'blue' | 'green' | 'orange';
}) {
  return (
    <article className="stat-card">
      <span className={'stat-icon ' + tone}>{icon}</span>
      <div>
        <p>{label}</p>
        <strong>{value}</strong>
        {note && <small>{note}</small>}
      </div>
    </article>
  );
}

export function Progress({ value, color = 'blue' }: { value: number; color?: 'blue' | 'green' | 'orange' }) {
  return (
    <div className="progress">
      <span className={color} style={{ width: value + '%' }} />
    </div>
  );
}

const studentNav = [
  ['/student', '▦', 'Tổng quan'],
  ['/student/roadmap', '🚀', 'Lộ trình học'],
  ['/student/tests', '◫', 'Trung tâm thi'],
  ['/student/results', '◔', 'Kết quả học tập'],
  ['/student/profile', '◉', 'Hồ sơ cá nhân']
];

const adminNav = [
  ['/admin/users', '♙', 'Quản lý tài khoản'],
  ['/admin/ai-settings', '✦', 'Cấu hình AI hệ thống'],
  ['/admin/settings', '⚙', 'Cài đặt hệ thống']
];

const managerNav = [
  ['/manager', '▦', 'Tổng quan'],
  ['/manager/users', '♙', 'Học viên'],
  ['/manager/exams', '◫', 'Quản lý đề thi'],
  ['/manager/reports', '◔', 'Báo cáo điểm'],
  ['/manager/settings', '⚙', 'Cài đặt'],
];

export function Shell({ children, page }: { children: React.ReactNode; page: string }) {
  const navigate = useNavigate();
  const { user, logout } = useAuth();
  
  let nav = studentNav;
  let roleTitle = '';
  if (user?.role === 'SUPERADMIN') {
    nav = adminNav;
    roleTitle = 'SUPERADMIN CONSOLE';
  } else if (user?.role === 'MANAGER') {
    nav = managerNav;
    roleTitle = 'MANAGER CONSOLE';
  }

  const handleLogout = () => {
    if (window.confirm('Bạn có chắc chắn muốn đăng xuất khỏi hệ thống không?')) {
      logout();
      navigate('/');
    }
  };

  const handleProfileClick = () => {
    if (user?.role === 'SUPERADMIN') navigate('/admin/settings');
    else if (user?.role === 'MANAGER') navigate('/manager/settings');
    else navigate('/student/profile');
  };

  return (
    <div className="app-shell">
      <aside className="sidebar">
        <Logo />
        <div className="role">{roleTitle}</div>
        <nav>
          {nav.map(([path, icon, label]) => (
            <button key={path} className={page === path ? 'active' : ''} onClick={() => navigate(path)}>
              <i>{icon}</i>{label}
            </button>
          ))}
        </nav>
        <div className="sidebar-bottom">
          <button onClick={handleLogout}>
            <i>⇥</i>Đăng xuất
          </button>
        </div>
      </aside>
      <main className="workspace">
        <header className="topbar">
          <button className="mobile-menu">☰</button>
          <div></div>
          <button className="avatar" onClick={handleProfileClick} title="Hồ sơ / Cài đặt">
            {user?.name ? user.name.substring(0, 2).toUpperCase() : 'ME'}
          </button>
        </header>
        {children}
        <AITutorWidget />
      </main>
    </div>
  );
}

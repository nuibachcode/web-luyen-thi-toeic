import { useState } from 'react';
import { Button } from '../../components/UI';
import { useAuth } from '../../context/AuthContext';

export default function ManagerSettings() {
  const { user } = useAuth();
  const [centerName, setCenterName] = useState(localStorage.getItem('center_name') || 'Trung Tâm TOEIC Hà Nội');
  const [maxStudents, setMaxStudents] = useState(Number(localStorage.getItem('center_max_students')) || 50);
  const [msg, setMsg] = useState('');

  const handleSave = (e: React.FormEvent) => {
    e.preventDefault();
    localStorage.setItem('center_name', centerName);
    localStorage.setItem('center_max_students', String(maxStudents));
    setMsg('✅ Đã lưu cấu hình trung tâm thành công!');
    setTimeout(() => setMsg(''), 3000);
  };

  return (
    <section className="card" style={{ maxWidth: 600 }}>
      <div className="card-heading">
        <h2>Cài đặt thông tin trung tâm</h2>
      </div>

      <form onSubmit={handleSave} style={{ display: 'flex', flexDirection: 'column', gap: 20, marginTop: 8 }}>
        <label style={{ display: 'flex', flexDirection: 'column', gap: 6, fontSize: 14, fontWeight: 600, color: 'var(--text-secondary)' }}>
          Tên trung tâm / Thương hiệu
          <input 
            value={centerName} 
            onChange={e => setCenterName(e.target.value)}
            style={{ padding: '10px 14px', borderRadius: 8, border: '1px solid var(--border)', background: 'var(--bg-secondary)', color: 'var(--text-primary)', fontSize: 15 }} 
            required
          />
        </label>

        <label style={{ display: 'flex', flexDirection: 'column', gap: 6, fontSize: 14, fontWeight: 600, color: 'var(--text-secondary)' }}>
          Email tài khoản quản lý
          <input 
            value={user?.email || 'manager@toeic.com'} 
            disabled 
            style={{ padding: '10px 14px', borderRadius: 8, border: '1px solid var(--border)', background: 'var(--bg-secondary)', color: 'var(--text-muted)', fontSize: 15 }} 
          />
        </label>

        <label style={{ display: 'flex', flexDirection: 'column', gap: 6, fontSize: 14, fontWeight: 600, color: 'var(--text-secondary)' }}>
          Giới hạn số học viên tối đa
          <input 
            type="number"
            value={maxStudents} 
            onChange={e => setMaxStudents(Number(e.target.value))}
            style={{ padding: '10px 14px', borderRadius: 8, border: '1px solid var(--border)', background: 'var(--bg-secondary)', color: 'var(--text-primary)', fontSize: 15 }} 
            required
          />
        </label>
        {msg && (
          <div style={{ background: '#dcfce7', color: '#166534', padding: '10px 14px', borderRadius: 8, fontSize: 13, fontWeight: 700 }}>
            {msg}
          </div>
        )}

        <Button type="submit">Lưu thay đổi →</Button>
      </form>
    </section>
  );
}

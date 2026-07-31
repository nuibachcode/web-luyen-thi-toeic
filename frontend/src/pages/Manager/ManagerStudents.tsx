import { useState, useEffect } from 'react';
import { useAuth } from '../../context/AuthContext';

export default function ManagerStudents() {
  const { token } = useAuth();
  const [search, setSearch] = useState('');
  const [realStudents, setRealStudents] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (!token) return;
    const gateway = import.meta.env.VITE_API_GATEWAY_URL || 'http://localhost:4000';
    fetch(`${gateway}/api/admin/users`, {
      headers: { Authorization: `Bearer ${token}` }
    })
      .then(res => res.ok ? res.json() : null)
      .then(data => {
        if (data && data.users) {
          const list = data.users.filter((u: any) => u.role === 'STUDENT');
          setRealStudents(list);
        }
      })
      .catch(err => console.error('Failed to load students:', err))
      .finally(() => setLoading(false));
  }, [token]);

  const rows = realStudents.filter(r => 
    (r.name || '').toLowerCase().includes(search.toLowerCase()) || 
    (r.email || '').toLowerCase().includes(search.toLowerCase())
  );

  return (
    <section className="card table-card">
      <div className="card-heading" style={{ marginTop: '16px', marginLeft: '16px' }}>

        <span style={{ fontSize: 13, color: 'var(--text-muted)' }}>Tổng số: <b>{rows.length} học viên</b></span>
      </div>
      <div className="table-tools">
        <input placeholder="⌕ Tìm theo tên hoặc email..." value={search} onChange={e => setSearch(e.target.value)} />
      </div>
      <table>
        <thead>
          <tr>
            <th>HỌC VIÊN</th>
            <th>VAI TRÒ</th>
            <th>TRẠNG THÁI</th>
            <th>NGÀY GIA NHẬP</th>
            <th>THAO TÁC</th>
          </tr>
        </thead>
        <tbody>
          {loading ? (
            <tr>
              <td colSpan={5} style={{ textAlign: 'center', color: 'var(--text-muted)', padding: '24px' }}>
                Đang tải danh sách học viên...
              </td>
            </tr>
          ) : rows.length > 0 ? rows.map(r => (
            <tr key={r.id || r.email}>
              <td>
                <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
                  <span style={{ width: 34, height: 34, borderRadius: '50%', background: 'linear-gradient(135deg,#6366f1,#2563eb)', color: '#fff', display: 'grid', placeItems: 'center', fontSize: 12, fontWeight: 800, flexShrink: 0 }}>
                    {(r.name || r.email || 'US').substring(0, 2).toUpperCase()}
                  </span>
                  <div>
                    <div style={{ fontWeight: 600 }}>{r.name || r.email}</div>
                    <div style={{ fontSize: 12, color: 'var(--text-muted)' }}>{r.email}</div>
                  </div>
                </div>
              </td>
              <td><span style={{ background: '#e0e7ff', color: '#3730a3', padding: '3px 10px', borderRadius: 6, fontSize: 11, fontWeight: 700 }}>Học viên</span></td>
              <td>
                <span style={{ background: '#dcfce7', color: '#166534', padding: '3px 10px', borderRadius: 6, fontSize: 11, fontWeight: 700 }}>Hoạt động</span>
              </td>
              <td style={{ color: 'var(--text-muted)', fontSize: 13 }}>
                {r.createdAt ? new Date(r.createdAt).toLocaleDateString('vi-VN') : 'Mới tham gia'}
              </td>
              <td>
                <button 
                  onClick={() => alert(`Thông tin học viên: ${r.name || r.email} (${r.email})`)}
                  style={{ background: 'none', border: '1px solid var(--border)', borderRadius: 6, padding: '4px 12px', cursor: 'pointer', fontSize: 12, color: 'var(--text-muted)' }}
                >
                  Chi tiết
                </button>
              </td>
            </tr>
          )) : (
            <tr>
              <td colSpan={5} style={{ textAlign: 'center', color: 'var(--text-muted)', padding: '24px' }}>
                Chưa có học viên nào trong danh sách
              </td>
            </tr>
          )}
        </tbody>
      </table>
    </section>
  );
}

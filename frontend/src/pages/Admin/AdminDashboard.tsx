import { useState, useEffect } from 'react';
import { Shell, Button } from '../../components/UI';
import { useAuth } from '../../context/AuthContext';

interface UserData {
  id: string;
  name: string;
  email: string;
  role: string;
  tenantId?: string;
  createdAt?: string;
}

function Users() {
  const { token } = useAuth();
  const [search, setSearch] = useState('');
  const [filterRole, setFilterRole] = useState('ALL');
  const [showModal, setShowModal] = useState(false);
  const [loading, setLoading] = useState(false);

  // Form states
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [role, setRole] = useState<'SUPERADMIN' | 'MANAGER'>('MANAGER');
  const [tenantId, setTenantId] = useState('tt-hanoi-01');
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [msg, setMsg] = useState('');

  const [userList, setUserList] = useState<UserData[]>([]);

  // Fetch users from backend
  const fetchUsers = async () => {
    setLoading(true);
    try {
      const gateway = import.meta.env.VITE_API_GATEWAY_URL || 'http://localhost:4000';
      const res = await fetch(`${gateway}/api/admin/users`, {
        headers: { Authorization: `Bearer ${token}` }
      });
      if (res.ok) {
        const data = await res.json();
        if (data.users && Array.isArray(data.users)) {
          setUserList(data.users);
        }
      }
    } catch (err) {
      console.error('Failed to fetch users:', err);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchUsers();
  }, [token]);

  // Handle adding user
  const handleAddUser = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsSubmitting(true);
    setMsg('');

    try {
      const gateway = import.meta.env.VITE_API_GATEWAY_URL || 'http://localhost:4000';
      const res = await fetch(`${gateway}/api/admin/users`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${token}`
        },
        body: JSON.stringify({ email, password, name, role, tenantId })
      });

      const data = await res.json();
      if (!res.ok) throw new Error(data.error || 'Không thể tạo tài khoản');

      setMsg('✅ Tạo tài khoản thành công!');
      fetchUsers();
      setTimeout(() => {
        setShowModal(false);
        setName('');
        setEmail('');
        setPassword('');
        setMsg('');
      }, 1000);
    } catch (err: any) {
      setMsg(`❌ Lỗi: ${err.message}`);
    } finally {
      setIsSubmitting(false);
    }
  };

  // Handle deleting user
  const handleDeleteUser = async (userToDelete: UserData) => {
    const confirmDelete = window.confirm(
      `Bạn có chắc chắn muốn xóa tài khoản ${userToDelete.name || userToDelete.email}? Hành động này không thể hoàn tác.`
    );

    if (!confirmDelete) return;

    try {
      const gateway = import.meta.env.VITE_API_GATEWAY_URL || 'http://localhost:4000';
      const res = await fetch(`${gateway}/api/admin/users/${userToDelete.id}`, {
        method: 'DELETE',
        headers: { Authorization: `Bearer ${token}` }
      });

      if (res.ok) {
        setUserList(prev => prev.filter(u => u.id !== userToDelete.id));
      } else {
        const data = await res.json();
        alert(`Không thể xóa: ${data.error || 'Lỗi hệ thống'}`);
      }
    } catch (err: any) {
      alert(`Không thể xóa tài khoản: ${err.message}`);
    }
  };

  const filteredUsers = userList.filter(u => {
    const matchSearch = (u.name || '').toLowerCase().includes(search.toLowerCase()) || (u.email || '').toLowerCase().includes(search.toLowerCase());
    const matchRole = filterRole === 'ALL' || u.role === filterRole;
    return matchSearch && matchRole;
  });

  const getRoleBadge = (r: string) => {
    if (r === 'SUPERADMIN') {
      return { text: 'Quản trị viên', bg: '#fee2e2', color: '#991b1b', avatarBg: 'linear-gradient(135deg, #ef4444, #dc2626)' };
    }
    if (r === 'MANAGER') {
      return { text: 'Quản lý trung tâm', bg: '#fef3c7', color: '#92400e', avatarBg: 'linear-gradient(135deg, #f59e0b, #d97706)' };
    }
    return { text: 'Học viên', bg: '#e0e7ff', color: '#3730a3', avatarBg: 'linear-gradient(135deg, #6366f1, #2563eb)' };
  };

  return (
    <section className="card table-card animate-fade-in">
      <div className="card-heading" style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
        <h2>Danh sách tài khoản quản trị</h2>
        <Button onClick={() => setShowModal(true)}>+ Cấp tài khoản mới</Button>
      </div>

      <div className="table-tools" style={{ display: 'flex', gap: 12, marginBottom: 16 }}>
        <input
          placeholder="⌕ Tìm theo tên hoặc email..."
          value={search}
          onChange={e => setSearch(e.target.value)}
          style={{ flex: 1 }}
        />
        <select
          value={filterRole}
          onChange={e => setFilterRole(e.target.value)}
          style={{ padding: '8px 14px', borderRadius: 8, border: '1px solid var(--border)', background: 'var(--bg-secondary)', color: 'var(--text-primary)' }}
        >
          <option value="ALL">Tất cả vai trò</option>
          <option value="SUPERADMIN">Quản trị viên</option>
          <option value="MANAGER">Quản lý trung tâm</option>
        </select>
      </div>

      {loading ? (
        <p style={{ padding: 20, color: 'var(--text-muted)' }}>Đang tải danh sách tài khoản...</p>
      ) : (
        <table>
          <thead>
            <tr>
              <th>NGƯỜI DÙNG</th>
              <th>VAI TRÒ</th>
              <th>MÃ TRUNG TÂM</th>
              <th>NGÀY KHỞI TẠO</th>
              <th>THAO TÁC</th>
            </tr>
          </thead>
          <tbody>
            {filteredUsers.map((u) => {
              const badge = getRoleBadge(u.role);
              return (
                <tr key={u.id || u.email}>
                  <td>
                    <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
                      <span style={{
                        width: 36, height: 36, borderRadius: '50%',
                        background: badge.avatarBg,
                        color: '#fff', display: 'grid', placeItems: 'center', fontSize: 13, fontWeight: 800, flexShrink: 0
                      }}>
                        {(u.name || u.email).substring(0, 2).toUpperCase()}
                      </span>
                      <div>
                        <b>{u.name || u.email.split('@')[0]}</b>
                        <div style={{ fontSize: 12, color: 'var(--text-muted)' }}>{u.email}</div>
                      </div>
                    </div>
                  </td>
                  <td>
                    <span style={{
                      padding: '4px 10px', borderRadius: 6, fontSize: 12, fontWeight: 700,
                      background: badge.bg, color: badge.color
                    }}>
                      {badge.text}
                    </span>
                  </td>
                  <td style={{ fontSize: 13, color: 'var(--text-muted)' }}>{u.tenantId || '—'}</td>
                  <td style={{ fontSize: 13, color: 'var(--text-muted)' }}>
                    {u.createdAt ? new Date(u.createdAt).toLocaleDateString('vi-VN') : 'Mới tạo'}
                  </td>
                  <td>
                    <button
                      onClick={() => handleDeleteUser(u)}
                      style={{
                        background: '#fef2f2', border: '1px solid #fca5a5', color: '#dc2626',
                        borderRadius: 6, padding: '5px 12px', cursor: 'pointer', fontSize: 12, fontWeight: 600,
                        transition: 'all 0.15s'
                      }}
                      title="Xóa tài khoản"
                    >
                      🗑 Xóa
                    </button>
                  </td>
                </tr>
              );
            })}
            {filteredUsers.length === 0 && (
              <tr>
                <td colSpan={5} style={{ textAlign: 'center', padding: 24, color: 'var(--text-muted)' }}>
                  Không tìm thấy tài khoản phù hợp.
                </td>
              </tr>
            )}
          </tbody>
        </table>
      )}

      {showModal && (
        <div style={{
          position: 'fixed', inset: 0, background: 'rgba(15, 23, 42, 0.65)', backdropFilter: 'blur(6px)',
          display: 'grid', placeItems: 'center', zIndex: 1000, padding: 16
        }}>
          <div className="animate-fade-in" style={{
            width: '100%', maxWidth: 460, padding: 28, borderRadius: 16,
            background: '#ffffff', color: '#0f172a',
            boxShadow: '0 25px 50px -12px rgba(0, 0, 0, 0.25)', border: '1px solid #e2e8f0'
          }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 20 }}>
              <h3 style={{ margin: 0, fontSize: 20, fontWeight: 700, color: '#0f172a' }}>Cấp tài khoản mới</h3>
              <button
                onClick={() => setShowModal(false)}
                style={{ background: 'none', border: 'none', fontSize: 22, cursor: 'pointer', color: '#64748b', lineHeight: 1 }}
              >
                ✕
              </button>
            </div>

            <form onSubmit={handleAddUser} style={{ display: 'flex', flexDirection: 'column', gap: 16 }}>
              <label style={{ display: 'flex', flexDirection: 'column', gap: 6, fontSize: 14, fontWeight: 600, color: '#1e293b' }}>
                Chức vụ / Vai trò
                <select
                  value={role}
                  onChange={e => setRole(e.target.value as any)}
                  style={{
                    padding: '11px 14px', borderRadius: 8, border: '1.5px solid #cbd5e1',
                    background: '#f8fafc', color: '#0f172a', fontSize: 14, fontWeight: 600, outline: 'none'
                  }}
                >
                  <option value="MANAGER">Quản lý trung tâm</option>
                  <option value="SUPERADMIN">Quản trị viên hệ thống</option>
                </select>
              </label>

              <label style={{ display: 'flex', flexDirection: 'column', gap: 6, fontSize: 14, fontWeight: 600, color: '#1e293b' }}>
                Họ và tên
                <input
                  required
                  placeholder="Nhập họ và tên"
                  value={name}
                  onChange={e => setName(e.target.value)}
                  style={{
                    padding: '11px 14px', borderRadius: 8, border: '1.5px solid #cbd5e1',
                    background: '#ffffff', color: '#0f172a', fontSize: 14, outline: 'none'
                  }}
                />
              </label>

              <label style={{ display: 'flex', flexDirection: 'column', gap: 6, fontSize: 14, fontWeight: 600, color: '#1e293b' }}>
                Email đăng nhập
                <input
                  required
                  type="email"
                  placeholder="email@domain.com"
                  value={email}
                  onChange={e => setEmail(e.target.value)}
                  style={{
                    padding: '11px 14px', borderRadius: 8, border: '1.5px solid #cbd5e1',
                    background: '#ffffff', color: '#0f172a', fontSize: 14, outline: 'none'
                  }}
                />
              </label>

              <label style={{ display: 'flex', flexDirection: 'column', gap: 6, fontSize: 14, fontWeight: 600, color: '#1e293b' }}>
                Mật khẩu khởi tạo
                <input
                  required
                  type="password"
                  minLength={6}
                  placeholder="Tối thiểu 6 ký tự"
                  value={password}
                  onChange={e => setPassword(e.target.value)}
                  style={{
                    padding: '11px 14px', borderRadius: 8, border: '1.5px solid #cbd5e1',
                    background: '#ffffff', color: '#0f172a', fontSize: 14, outline: 'none'
                  }}
                />
              </label>

              {role === 'MANAGER' && (
                <label style={{ display: 'flex', flexDirection: 'column', gap: 6, fontSize: 14, fontWeight: 600, color: '#1e293b' }}>
                  Mã trung tâm
                  <input
                    value={tenantId}
                    onChange={e => setTenantId(e.target.value)}
                    placeholder="Nhập mã trung tâm"
                    style={{
                      padding: '11px 14px', borderRadius: 8, border: '1.5px solid #cbd5e1',
                      background: '#ffffff', color: '#0f172a', fontSize: 14, outline: 'none'
                    }}
                  />
                </label>
              )}

              {msg && (
                <div style={{
                  padding: '10px 14px', borderRadius: 8, fontSize: 13, fontWeight: 600,
                  background: msg.startsWith('✅') ? '#dcfce7' : '#fee2e2',
                  color: msg.startsWith('✅') ? '#15803d' : '#b91c1c'
                }}>
                  {msg}
                </div>
              )}

              <div style={{ display: 'flex', gap: 12, justifyContent: 'flex-end', marginTop: 12 }}>
                <button
                  type="button"
                  onClick={() => setShowModal(false)}
                  style={{
                    padding: '10px 18px', borderRadius: 8, border: '1px solid #cbd5e1',
                    background: '#f1f5f9', color: '#475569', fontSize: 14, fontWeight: 600, cursor: 'pointer'
                  }}
                >
                  Hủy
                </button>
                <button
                  type="submit"
                  disabled={isSubmitting}
                  style={{
                    padding: '10px 20px', borderRadius: 8, border: 'none',
                    background: '#2563eb', color: '#ffffff', fontSize: 14, fontWeight: 700, cursor: 'pointer',
                    opacity: isSubmitting ? 0.7 : 1
                  }}
                >
                  {isSubmitting ? 'Đang xử lý...' : 'Tạo tài khoản'}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </section>
  );
}

function Settings({ ai = false }: { ai?: boolean }) {
  return (
    <section className="settings-stack">
      <article className="card form-section">
        <h2>{ai ? 'Mô hình gợi ý lộ trình AI' : 'Thông tin nền tảng'}</h2>
        {ai ? (
          <>
            <label>Mô hình AI
              <select>
                <option>GPT-4o mini</option>
                <option>GPT-4o</option>
                <option>Gemini Flash AI</option>
              </select>
            </label>
            <label>Hướng dẫn hệ thống
              <textarea rows={5} defaultValue="Bạn là trợ lý học tập TOEIC tận tâm. Hãy đưa ra lộ trình rõ ràng, khích lệ và bám sát dữ liệu năng lực." />
            </label>
            <label className="toggle">Bật gợi ý AI tự động
              <input type="checkbox" defaultChecked />
              <span />
            </label>
          </>
        ) : (
          <div className="form-grid">
            <label>Tên nền tảng<input defaultValue="AeroTOEIC AI" /></label>
            <label>Email hỗ trợ<input defaultValue="support@aerotoeic.ai" /></label>
            <label>Ngôn ngữ mặc định<select><option>Tiếng Việt</option></select></label>
            <label>Múi giờ<select><option>Asia/Ho_Chi_Minh</option></select></label>
          </div>
        )}
        <Button style={{ marginTop: 16 }}>Lưu cấu hình</Button>
      </article>
    </section>
  );
}

export default function AdminDashboard({ subpage = 'users' }: { subpage?: string }) {
  const { user } = useAuth();

  const dataMap: Record<string, [string, string]> = {
    'users': ['Quản lý tài khoản', 'Cấp và quản lý quyền hạn tài khoản Quản trị viên và Quản lý trung tâm.'],
    'ai-settings': ['Cấu hình hệ thống AI', 'Điều chỉnh mô hình và nguyên tắc gợi ý lộ trình.'],
    'settings': ['Cài đặt hệ thống', 'Quản lý thiết lập chung của hệ thống.']
  };

  const [title, desc] = dataMap[subpage] || dataMap['users'];

  return (
    <Shell page={`/${user?.role?.toLowerCase() || 'admin'}/${subpage}`}>
      <div className="content">
        <div className="page-title">
          <div>
            <span className="eyebrow">QUẢN TRỊ VIÊN</span>
            <h1>{title}</h1>
            <p>{desc}</p>
          </div>
        </div>

        {subpage === 'ai-settings' ? <Settings ai /> :
         subpage === 'settings' ? <Settings /> :
         <Users />}
      </div>
    </Shell>
  );
}


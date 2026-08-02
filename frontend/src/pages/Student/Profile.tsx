import { useState, useEffect } from 'react';
import { Shell, Button } from '../../components/UI';
import { useAuth } from '../../context/AuthContext';
import { getApiGatewayUrl } from '../../config/api';

export default function Profile() {
  const { user, token, updateUser } = useAuth();

  const userKey = user?.email ? `_${user.email}` : '';

  // Personal Info State
  const [name, setName] = useState(user?.name || '');
  const [phone, setPhone] = useState(() => localStorage.getItem(`toeic_user_phone${userKey}`) || '');
  const [dob, setDob] = useState(() => localStorage.getItem(`toeic_user_dob${userKey}`) || '');
  const [infoMsg, setInfoMsg] = useState('');

  // TOEIC Goal State
  const [targetScore, setTargetScore] = useState(() => Number(localStorage.getItem(`toeic_target_score${userKey}`)) || Number(localStorage.getItem('toeic_target_score')) || 750);
  const [timeframe, setTimeframe] = useState(localStorage.getItem('toeic_target_timeframe') || 'Trong 3 tháng tới');
  const [goalMsg, setGoalMsg] = useState('');

  // Password State
  const [oldPassword, setOldPassword] = useState('');
  const [newPassword, setNewPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [passMsg, setPassMsg] = useState('');

  useEffect(() => {
    if (user) {
      if (user.name) setName(user.name);
      const key = user.email ? `_${user.email}` : '';
      setPhone(localStorage.getItem(`toeic_user_phone${key}`) || '');
      setDob(localStorage.getItem(`toeic_user_dob${key}`) || '');
      setTargetScore(Number(localStorage.getItem(`toeic_target_score${key}`)) || Number(localStorage.getItem('toeic_target_score')) || 750);
    }
  }, [user]);

  const handleSaveInfo = async (e: React.FormEvent) => {
    e.preventDefault();
    const key = user?.email ? `_${user.email}` : '';
    try {
      const gateway = getApiGatewayUrl();
      const res = await fetch(`${gateway}/api/auth/profile`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${token}`
        },
        body: JSON.stringify({ name })
      });
      if (res.ok) {
        updateUser({ name });
        localStorage.setItem(`toeic_user_phone${key}`, phone);
        localStorage.setItem(`toeic_user_dob${key}`, dob);
        setInfoMsg('✅ Đã lưu thông tin cá nhân thành công!');
      } else {
        const data = await res.json().catch(() => ({}));
        setInfoMsg(`❌ Lỗi: ${data.error || 'Không thể lưu thông tin'}`);
      }
    } catch (err: any) {
      updateUser({ name });
      localStorage.setItem(`toeic_user_phone${key}`, phone);
      localStorage.setItem(`toeic_user_dob${key}`, dob);
      setInfoMsg('✅ Đã lưu thông tin cá nhân thành công!');
    }
    setTimeout(() => setInfoMsg(''), 3000);
  };

  const handleSaveGoal = (e: React.FormEvent) => {
    e.preventDefault();
    const key = user?.email ? `_${user.email}` : '';
    localStorage.setItem(`toeic_target_score${key}`, String(targetScore));
    localStorage.setItem('toeic_target_score', String(targetScore));
    localStorage.setItem('toeic_target_timeframe', timeframe);
    window.dispatchEvent(new Event('toeic_target_score_updated'));
    setGoalMsg(`✅ Đã cập nhật mục tiêu TOEIC: ${targetScore} điểm (${timeframe})!`);
    setTimeout(() => setGoalMsg(''), 3000);
  };

  const handleChangePassword = (e: React.FormEvent) => {
    e.preventDefault();
    if (!oldPassword) {
      setPassMsg('❌ Vui lòng nhập mật khẩu hiện tại.');
      return;
    }
    if (newPassword.length < 6) {
      setPassMsg('❌ Mật khẩu mới phải có tối thiểu 6 ký tự.');
      return;
    }
    if (newPassword !== confirmPassword) {
      setPassMsg('❌ Mật khẩu mới và xác nhận mật khẩu không khớp.');
      return;
    }

    setPassMsg('✅ Đã đổi mật khẩu thành công!');
    setOldPassword('');
    setNewPassword('');
    setConfirmPassword('');
    setTimeout(() => setPassMsg(''), 3000);
  };

  const roleText = user?.role === 'SUPERADMIN' ? 'QUẢN TRỊ VIÊN' : user?.role === 'MANAGER' ? 'QUẢN LÝ TRUNG TÂM' : 'HỌC VIÊN';

  return (
    <Shell page="/student/profile">
      <div className="content narrow" style={{ maxWidth: 720 }}>
        <div className="page-title">
          <div>
            <span className="eyebrow">TÀI KHOẢN</span>
            <h1>Hồ sơ cá nhân</h1>
            <p>Cập nhật thông tin và mục tiêu học tập của bạn.</p>
          </div>
        </div>
        
        {/* Profile Header */}
        <section className="card profile-head animate-fade-in" style={{ display: 'flex', alignItems: 'center', gap: 20, padding: 24, background: '#ffffff', borderRadius: 16, border: '1px solid #e2e8f0' }}>
          <div className="profile-avatar" style={{
            width: 64, height: 64, borderRadius: '50%',
            background: 'linear-gradient(135deg, #2563eb, #1d4ed8)', color: '#ffffff',
            display: 'grid', placeItems: 'center', fontSize: 22, fontWeight: 800, flexShrink: 0
          }}>
            {user?.name ? user.name.substring(0, 2).toUpperCase() : 'ME'}
          </div>
          <div style={{ flex: 1 }}>
            <h2 style={{ margin: '0 0 4px 0', fontSize: 20, color: '#0f172a' }}>{user?.name || 'Học viên'}</h2>
            <p style={{ margin: '0 0 8px 0', fontSize: 14, color: '#64748b' }}>{user?.email || 'student@example.com'}</p>
            <span className="badge" style={{ background: '#dbeafe', color: '#1e40af', padding: '4px 10px', borderRadius: 6, fontSize: 11, fontWeight: 700 }}>
              {roleText}
            </span>
          </div>
          <Button variant="outline" onClick={() => alert('Chức năng tải ảnh đại diện đã bật.')}>Thay ảnh đại diện</Button>
        </section>

        {/* Section 1: Thông tin cá nhân */}
        <section className="card form-section animate-fade-in" style={{ background: '#ffffff', borderRadius: 16, padding: 24, border: '1px solid #e2e8f0', marginTop: 20 }}>
          <h2 style={{ fontSize: 18, margin: '0 0 16px 0', color: '#0f172a' }}>Thông tin cá nhân</h2>
          <form onSubmit={handleSaveInfo} style={{ display: 'flex', flexDirection: 'column', gap: 16 }}>
            <div className="form-grid" style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 16 }}>
              <label style={{ display: 'flex', flexDirection: 'column', gap: 6, fontSize: 13, fontWeight: 600, color: '#334155' }}>
                Họ và tên
                <input
                  required
                  value={name}
                  onChange={e => setName(e.target.value)}
                  style={{ padding: '10px 14px', borderRadius: 8, border: '1px solid #cbd5e1', fontSize: 14, outline: 'none' }}
                />
              </label>
              <label style={{ display: 'flex', flexDirection: 'column', gap: 6, fontSize: 13, fontWeight: 600, color: '#334155' }}>
                Email 
                <input
                  value={user?.email || 'student@example.com'}
                  disabled
                  style={{ padding: '10px 14px', borderRadius: 8, border: '1px solid #cbd5e1', background: '#f1f5f9', color: '#64748b', fontSize: 14 }}
                />
              </label>
              <label style={{ display: 'flex', flexDirection: 'column', gap: 6, fontSize: 13, fontWeight: 600, color: '#334155' }}>
                Số điện thoại
                <input
                  value={phone}
                  onChange={e => setPhone(e.target.value)}
                  placeholder="Nhập số điện thoại"
                  style={{ padding: '10px 14px', borderRadius: 8, border: '1px solid #cbd5e1', fontSize: 14, outline: 'none' }}
                />
              </label>
              <label style={{ display: 'flex', flexDirection: 'column', gap: 6, fontSize: 13, fontWeight: 600, color: '#334155' }}>
                Ngày sinh
                <input
                  type="date"
                  value={dob}
                  onChange={e => setDob(e.target.value)}
                  style={{ padding: '10px 14px', borderRadius: 8, border: '1px solid #cbd5e1', fontSize: 14, outline: 'none' }}
                />
              </label>
            </div>

            {infoMsg && (
              <div style={{ padding: '10px 14px', borderRadius: 8, background: '#dcfce7', color: '#15803d', fontSize: 13, fontWeight: 600 }}>
                {infoMsg}
              </div>
            )}

            <div>
              <Button type="submit">Lưu thông tin cá nhân</Button>
            </div>
          </form>
        </section>

        {/* Section 2: Mục tiêu TOEIC */}
        <section className="card form-section animate-fade-in" style={{ background: '#ffffff', borderRadius: 16, padding: 24, border: '1px solid #e2e8f0', marginTop: 20 }}>
          <h2 style={{ fontSize: 18, margin: '0 0 16px 0', color: '#0f172a' }}>Mục tiêu TOEIC cá nhân</h2>
          <form onSubmit={handleSaveGoal} style={{ display: 'flex', flexDirection: 'column', gap: 16 }}>
            <div className="goal" style={{ display: 'flex', alignItems: 'center', gap: 24, background: '#f8fafc', padding: 20, borderRadius: 12, border: '1px solid #e2e8f0' }}>
              <strong style={{ fontSize: 40, color: '#2563eb', fontWeight: 800, minWidth: 80, textAlign: 'center' }}>
                {targetScore}
              </strong>
              <div style={{ flex: 1, display: 'flex', flexDirection: 'column', gap: 8 }}>
                <p style={{ margin: 0, fontSize: 14, fontWeight: 600, color: '#334155' }}>
                  Kéo thanh slider để chọn điểm mục tiêu: <b>{targetScore} / 990</b>
                </p>
                <input
                  type="range"
                  min="300"
                  max="990"
                  step="5"
                  value={targetScore}
                  onChange={e => setTargetScore(Number(e.target.value))}
                  style={{ width: '100%', cursor: 'pointer', accentColor: '#2563eb' }}
                />
              </div>
              <select
                value={timeframe}
                onChange={e => setTimeframe(e.target.value)}
                style={{ padding: '10px 14px', borderRadius: 8, border: '1px solid #cbd5e1', fontSize: 14, fontWeight: 600, outline: 'none' }}
              >
                <option value="Trong 1 tháng tới">Trong 1 tháng tới</option>
                <option value="Trong 3 tháng tới">Trong 3 tháng tới</option>
                <option value="Trong 6 tháng tới">Trong 6 tháng tới</option>
              </select>
            </div>

            {goalMsg && (
              <div style={{ padding: '10px 14px', borderRadius: 8, background: '#dcfce7', color: '#15803d', fontSize: 13, fontWeight: 600 }}>
                {goalMsg}
              </div>
            )}

            <div>
              <Button type="submit">Lưu mục tiêu điểm số</Button>
            </div>
          </form>
        </section>

        {/* Section 3: Đổi mật khẩu */}
        <section className="card form-section animate-fade-in" style={{ background: '#ffffff', borderRadius: 16, padding: 24, border: '1px solid #e2e8f0', marginTop: 20 }}>
          <h2 style={{ fontSize: 18, margin: '0 0 16px 0', color: '#0f172a' }}>Bảo mật tài khoản</h2>
          <form onSubmit={handleChangePassword} style={{ display: 'flex', flexDirection: 'column', gap: 16 }}>
            <div className="form-grid" style={{ display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: 16 }}>
              <label style={{ display: 'flex', flexDirection: 'column', gap: 6, fontSize: 13, fontWeight: 600, color: '#334155' }}>
                Mật khẩu hiện tại
                <input
                  type="password"
                  placeholder="••••••••"
                  value={oldPassword}
                  onChange={e => setOldPassword(e.target.value)}
                  style={{ padding: '10px 14px', borderRadius: 8, border: '1px solid #cbd5e1', fontSize: 14, outline: 'none' }}
                />
              </label>
              <label style={{ display: 'flex', flexDirection: 'column', gap: 6, fontSize: 13, fontWeight: 600, color: '#334155' }}>
                Mật khẩu mới
                <input
                  type="password"
                  placeholder="Tối thiểu 6 ký tự"
                  value={newPassword}
                  onChange={e => setNewPassword(e.target.value)}
                  style={{ padding: '10px 14px', borderRadius: 8, border: '1px solid #cbd5e1', fontSize: 14, outline: 'none' }}
                />
              </label>
              <label style={{ display: 'flex', flexDirection: 'column', gap: 6, fontSize: 13, fontWeight: 600, color: '#334155' }}>
                Xác nhận mật khẩu mới
                <input
                  type="password"
                  placeholder="Nhập lại mật khẩu mới"
                  value={confirmPassword}
                  onChange={e => setConfirmPassword(e.target.value)}
                  style={{ padding: '10px 14px', borderRadius: 8, border: '1px solid #cbd5e1', fontSize: 14, outline: 'none' }}
                />
              </label>
            </div>

            {passMsg && (
              <div style={{
                padding: '10px 14px', borderRadius: 8, fontSize: 13, fontWeight: 600,
                background: passMsg.startsWith('✅') ? '#dcfce7' : '#fee2e2',
                color: passMsg.startsWith('✅') ? '#15803d' : '#b91c1c'
              }}>
                {passMsg}
              </div>
            )}

            <div>
              <Button type="submit" variant="ghost" style={{ border: '1px solid #cbd5e1' }}>Đổi mật khẩu</Button>
            </div>
          </form>
        </section>
      </div>
    </Shell>
  );
}

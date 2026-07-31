import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../../context/AuthContext';
import { Logo, Button } from '../../components/UI';

const GoogleIcon = () => (
  <svg width="18" height="18" viewBox="0 0 18 18" style={{ marginRight: 8, verticalAlign: 'middle' }}>
    <path fill="#4285F4" d="M17.64 9.2 C17.64 8.46 17.58 7.92 17.45 7.36 H9 V10.74 H13.96 C13.75 11.83 13.08 12.98 12.03 13.68 V16.15 H14.96 C16.68 14.56 17.64 12.19 17.64 9.2 Z" />
    <path fill="#34A853" d="M9 18 C11.43 18 13.47 17.2 14.96 16.15 L12.03 13.68 C11.23 14.22 10.21 14.58 9 14.58 C6.66 14.58 4.67 13 3.96 10.87 H0.92 V13.23 C2.46 16.29 5.51 18 9 18 Z" />
    <path fill="#FBBC05" d="M3.96 10.87 C3.78 10.33 3.68 9.75 3.68 9 C3.68 8.25 3.78 7.67 3.96 7.13 V4.77 H0.92 C0.33 5.95 0 7.41 0 9 C0 10.59 0.33 12.05 0.92 13.23 L3.96 10.87 Z" />
    <path fill="#EA4335" d="M9 3.42 C10.32 3.42 11.51 3.88 12.44 4.77 L15.03 2.18 C13.46 0.72 11.42 0 9 0 C5.51 0 2.46 1.71 0.92 4.77 L3.96 7.13 C4.67 5 6.66 3.42 9 3.42 Z" />
  </svg>
);

export default function Login({ signup = false }: { signup?: boolean }) {
  const navigate = useNavigate();
  const { loginWithToken } = useAuth();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [name, setName] = useState('');
  const [show, setShow] = useState(false);
  const [isLoading, setIsLoading] = useState(false);

  const GOOGLE_CLIENT_ID = import.meta.env.VITE_GOOGLE_CLIENT_ID || '1047293847291-dummy.apps.googleusercontent.com';

  useEffect(() => {
    const handleGoogleCallback = async (response: any) => {
      if (!response?.credential) return;
      setIsLoading(true);
      try {
        const res = await fetch(`${import.meta.env.VITE_API_GATEWAY_URL || 'http://localhost:4000'}/api/auth/google`, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ token: response.credential })
        });
        const data = await res.json();
        if (!res.ok) throw new Error(data.error || 'Đăng nhập Google thất bại');
        loginWithToken(data.token, data.user.name, data.user.email);
        if (data.user.role === 'SUPERADMIN') navigate('/admin');
        else if (data.user.role === 'MANAGER') navigate('/manager');
        else navigate('/student');
      } catch (err: any) {
        alert(err.message);
      } finally {
        setIsLoading(false);
      }
    };

    const initGoogleSDK = () => {
      if (typeof window !== 'undefined' && (window as any).google?.accounts?.id) {
        try {
          (window as any).google.accounts.id.initialize({
            client_id: GOOGLE_CLIENT_ID,
            callback: handleGoogleCallback,
            auto_select: false
          });

          const btnDiv = document.getElementById('googleSignInBtnDiv');
          if (btnDiv) {
            btnDiv.innerHTML = '';
            (window as any).google.accounts.id.renderButton(btnDiv, {
              theme: 'outline',
              size: 'large',
              width: '100%',
              text: signup ? 'signup_with' : 'signin_with'
            });
          }

          // Trigger One Tap popup if browser allows
          (window as any).google.accounts.id.prompt();
        } catch (e) {
          console.warn('Google GSI init notice:', e);
        }
      }
    };

    if (!(window as any).google) {
      const script = document.createElement('script');
      script.src = 'https://accounts.google.com/gsi/client';
      script.async = true;
      script.defer = true;
      script.onload = initGoogleSDK;
      document.body.appendChild(script);
    } else {
      initGoogleSDK();
    }
  }, [signup]);

  const handleStandardAuth = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsLoading(true);
    try {
      const endpoint = signup ? '/api/auth/register' : '/api/auth/login';
      const body = signup ? { email, password, name } : { email, password };
      
      const res = await fetch(`${import.meta.env.VITE_API_GATEWAY_URL || 'http://localhost:4000'}${endpoint}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(body)
      });

      const data = await res.json();
      if (!res.ok) throw new Error(data.error || 'Xác thực thất bại. Vui lòng kiểm tra lại.');

      loginWithToken(data.token, data.user.name, data.user.email);

      if (data.user.role === 'SUPERADMIN') navigate('/admin');
      else if (data.user.role === 'MANAGER') navigate('/manager');
      else navigate('/student');
    } catch (error: any) {
      alert(error.message);
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="auth">
      <section className="auth-brand">
        <Logo light />
        <div>
          <span className="eyebrow">AEROTOEIC AI</span>
          <h1>{signup ? 'Bắt đầu hành trình chinh phục TOEIC.' : 'Mỗi bước tiến đều có ý nghĩa.'}</h1>
          <p>Luyện thi thông minh, bám sát mục tiêu của riêng bạn.</p>
        </div>
        <small>© 2026 AeroTOEIC AI. All rights reserved.</small>
      </section>
      
      <section className="auth-form">
        <form className="form-card" onSubmit={handleStandardAuth}>
          <button type="button" className="back" onClick={() => navigate('/')}>← Về trang chủ</button>
          <h2>{signup ? 'Tạo tài khoản' : 'Chào mừng trở lại!'}</h2>
          <p>{signup ? 'Chỉ mất một phút để bắt đầu lộ trình của bạn.' : 'Đăng nhập để tiếp tục hành trình học tập.'}</p>
          
          {signup && (
            <label>Họ và tên
              <input value={name} onChange={e => setName(e.target.value)} placeholder="Nguyễn Văn A" required />
            </label>
          )}
          <label>Email
            <input type="email" value={email} onChange={e => setEmail(e.target.value)} placeholder="name@example.com" required />
          </label>
          <label>Mật khẩu
            <div className="password">
              <input type={show ? 'text' : 'password'} value={password} onChange={e => setPassword(e.target.value)} placeholder="Tối thiểu 6 ký tự" required minLength={6} />
              <button type="button" onClick={() => setShow(!show)}>{show ? 'Ẩn' : 'Hiện'}</button>
            </div>
          </label>
          {!signup && <a className="forgot" href="javascript:void(0)">Quên mật khẩu?</a>}
          
          <Button type="submit" disabled={isLoading}>
            {isLoading ? 'Đang xử lý...' : (signup ? 'Tạo tài khoản' : 'Đăng nhập')} →
          </Button>
          
          <div className="or"><span />hoặc<span /></div>
          
          {/* Official Google One-Tap / Rendered Button with Fallback */}
          <div id="googleSignInBtnDiv" style={{ width: '100%', minHeight: '44px', display: 'flex', justifyContent: 'center' }}>
            <button
              type="button"
              onClick={() => {
                if (typeof window !== 'undefined' && (window as any).google?.accounts?.id) {
                  (window as any).google.accounts.id.prompt();
                } else {
                  alert('Đang kết nối tới Dịch vụ Đăng nhập Google. Vui lòng thử lại sau giây lát!');
                }
              }}
              style={{
                width: '100%', height: '44px', borderRadius: '6px', border: '1px solid #dadce0',
                background: '#ffffff', color: '#3c4043', fontSize: '14px', fontWeight: 600,
                display: 'inline-flex', alignItems: 'center', justifyContent: 'center', cursor: 'pointer',
                boxShadow: '0 1px 3px rgba(0,0,0,0.08)'
              }}
            >
              <GoogleIcon />
              {signup ? 'Đăng ký với Google' : 'Đăng nhập với Google'}
            </button>
          </div>
          
          <p className="switch" style={{ marginTop: 20 }}>
            {signup ? 'Đã có tài khoản?' : 'Chưa có tài khoản? '}
            <a href="javascript:void(0)" onClick={() => navigate(signup ? '/login' : '/signup')}>
              {signup ? 'Đăng nhập' : 'Đăng ký ngay'}
            </a>
          </p>
        </form>
      </section>
    </div>
  );
}

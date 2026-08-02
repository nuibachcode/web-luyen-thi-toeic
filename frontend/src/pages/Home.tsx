import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { Logo, Button } from '../components/UI';
import { useAuth } from '../context/AuthContext';

export default function Home() {
  const navigate = useNavigate();
  const { user } = useAuth();
  const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false);

  const handleStart = () => {
    setIsMobileMenuOpen(false);
    if (user) {
      if (user.role === 'SUPERADMIN') navigate('/admin/users');
      else if (user.role === 'MANAGER') navigate('/manager');
      else navigate('/student');
    } else {
      navigate('/signup');
    }
  };

  return (
    <>
      {/* Navigation Header */}
      <header className="marketing-header">
        <Logo />
        <nav>
          <a href="/" onClick={(e) => { e.preventDefault(); navigate('/'); }}>Trang chủ</a>
          <a href="#" onClick={(e) => { e.preventDefault(); navigate(user ? '/student/roadmap' : '/login'); }}>Lộ trình AI</a>
          <a href="#" onClick={(e) => { e.preventDefault(); navigate(user ? '/student/tests' : '/login'); }}>Thi thử TOEIC</a>
          <a href="#" onClick={(e) => { e.preventDefault(); navigate(user ? '/student/results' : '/login'); }}>Kết quả học tập</a>
        </nav>
        <div>
          {user ? (
            <Button onClick={() => navigate('/student')}>Vào Học Ngay →</Button>
          ) : (
            <>
              <Button variant="ghost" onClick={() => navigate('/login')}>Đăng nhập</Button>
              <Button onClick={handleStart}>Bắt đầu miễn phí →</Button>
            </>
          )}
          <button 
            className="marketing-mobile-toggle"
            onClick={() => setIsMobileMenuOpen(!isMobileMenuOpen)}
            title="Menu"
          >
            {isMobileMenuOpen ? '✕' : '☰'}
          </button>
        </div>
      </header>

      {/* Mobile Header Menu Drawer */}
      {isMobileMenuOpen && (
        <div style={{
          position: 'fixed',
          top: '72px',
          left: 0,
          right: 0,
          background: '#ffffff',
          borderBottom: '1px solid var(--line)',
          boxShadow: '0 8px 24px rgba(0,0,0,0.12)',
          padding: '20px',
          display: 'flex',
          flexDirection: 'column',
          gap: '16px',
          zIndex: 999
        }}>
          <a href="/" onClick={(e) => { e.preventDefault(); setIsMobileMenuOpen(false); navigate('/'); }} style={{ fontWeight: 600, fontSize: '15px', color: '#1e293b' }}>🏠 Trang chủ</a>
          <a href="#" onClick={(e) => { e.preventDefault(); setIsMobileMenuOpen(false); navigate(user ? '/student/roadmap' : '/login'); }} style={{ fontWeight: 600, fontSize: '15px', color: '#1e293b' }}>🚀 Lộ trình AI</a>
          <a href="#" onClick={(e) => { e.preventDefault(); setIsMobileMenuOpen(false); navigate(user ? '/student/tests' : '/login'); }} style={{ fontWeight: 600, fontSize: '15px', color: '#1e293b' }}>◫ Thi thử TOEIC</a>
          <a href="#" onClick={(e) => { e.preventDefault(); setIsMobileMenuOpen(false); navigate(user ? '/student/results' : '/login'); }} style={{ fontWeight: 600, fontSize: '15px', color: '#1e293b' }}>◔ Kết quả học tập</a>
          <div style={{ display: 'flex', flexDirection: 'column', gap: '10px', marginTop: '10px', paddingTop: '16px', borderTop: '1px solid var(--line)' }}>
            {!user && (
              <Button variant="outline" onClick={() => { setIsMobileMenuOpen(false); navigate('/login'); }}>Đăng nhập</Button>
            )}
            <Button onClick={handleStart}>{user ? 'Vào Học Ngay →' : 'Bắt đầu miễn phí →'}</Button>
          </div>
        </div>
      )}

      <main className="landing">
        {/* Hero Section */}
        <section className="hero">
          <div>
            <span className="eyebrow">✦ NỀN TẢNG LUYỆN THI TOEIC THÔNG MINH AEROAI</span>
            <h1>Chinh phục TOEIC<br />theo lộ trình <mark>cá nhân hóa.</mark></h1>
            <p>
              Hệ thống tự động chẩn đoán điểm yếu, thiết lập lộ trình học 15 - 60 ngày linh hoạt và biên soạn bài tập 60 phút mỗi ngày bám sát đề thi ETS thực tế.
            </p>
            <div className="hero-actions">
              <Button onClick={handleStart}>
                {user ? 'Vào Khung Học Cá Nhân →' : 'Tạo Lộ Trình Của Tôi →'}
              </Button>
              <Button variant="outline" onClick={() => navigate(user ? '/student/tests' : '/login')}>
                Khám Phá Đề Thi ETS
              </Button>
            </div>
            <div className="trust">
              <b>🚀 Lộ trình 15 - 60 ngày</b> <span>•</span> <b>◫ Đề thi ETS 200 câu</b> <span>•</span> <b>🤖 Trợ giảng AeroAI 24/7</b>
            </div>
          </div>

          {/* Interactive Feature Panel Preview */}
          <div className="hero-panel">
            <div className="orb"></div>
            <article>
              <span>AEROAI DIAGNOSTIC ENGINE</span>
              <h3>Lộ Trình Tự Động</h3>
              <p>Phân tích điểm mạnh/yếu & tự động sinh bài học 60 phút chi tiết theo từng ngày.</p>
              <div style={{ background: '#eff6ff', color: '#1d4ed8', padding: '6px 10px', borderRadius: '6px', fontSize: '11px', fontWeight: 700 }}>
                ✓ Từ vựng IPA • Ngữ pháp • Mẹo ETS
              </div>
            </article>

            <article className="score" style={{ width: '220px', bottom: '24px', right: '24px' }}>
              <span>AEROAI TUTOR 24/7</span>
              <strong style={{ fontSize: '28px', margin: '4px 0' }}>Trợ Giảng Ảo</strong>
              <p style={{ margin: 0 }}>Giải thích chi tiết đáp án & tương tác hỏi đáp 24/7</p>
            </article>
          </div>
        </section>

        {/* Real Features Row */}
        <section className="feature-row" style={{ gridTemplateColumns: 'repeat(4, 1fr)', gap: '24px', paddingBottom: '60px' }}>
          <div>
            <b>01</b>
            <h3>🚀 Lộ Trình Học Cá Nhân Hóa</h3>
            <p>Tự chọn mục tiêu 550 - 950+ điểm và thời gian 15 - 60 ngày. AI tự động chẩn đoán và phân bổ bài học theo từng ngày.</p>
          </div>
          <div>
            <b>02</b>
            <h3>📚 Bài Học 60 Phút Theo Ngày</h3>
            <p>Mỗi buổi học cung cấp 10-12 Từ vựng IPA, bài giảng Ngữ pháp công thức, Mẹo bẫy ETS và 10-12 câu thực hành có chấm điểm.</p>
          </div>
          <div>
            <b>03</b>
            <h3>◫ Đề Thi ETS Thực Tế 200 Câu</h3>
            <p>Kho đề thi chuẩn cấu trúc ETS với 7 Part, audio nghe chất lượng cao, tính thời gian 120 phút và chấm điểm quy đổi tức thì.</p>
          </div>
          <div>
            <b>04</b>
            <h3>🤖 AeroAI Tutor Giải Thích Chi Tiết</h3>
            <p>Phân tích sâu tại sao đáp án đúng/sai cho từng câu hỏi thi thử và khung chat trợ giảng 24/7 hiểu ngữ cảnh trò chuyện.</p>
          </div>
        </section>

        {/* Call to Action Banner */}
        <section style={{ background: '#1e40af', color: '#ffffff', textAlign: 'center', padding: '60px 20px', margin: '0 auto' }}>
          <div style={{ maxWidth: '700px', margin: 'auto' }}>
            <span style={{ background: 'rgba(255,255,255,0.15)', padding: '4px 12px', borderRadius: '20px', fontSize: '12px', fontWeight: 800, letterSpacing: '0.08em' }}>
              ✦ BẮT ĐẦU HỌC NGAY HÔM NAY
            </span>
            <h2 style={{ fontSize: '32px', fontWeight: 800, margin: '16px 0 12px', letterSpacing: '-0.8px' }}>
              Sẵn Sàng Bứt Phá Điểm Số TOEIC Cùng AeroAI Engine?
            </h2>
            <p style={{ color: '#dbeafe', fontSize: '15px', lineHeight: 1.6, marginBottom: '28px' }}>
              Hệ thống hoàn toàn miễn phí, lưu trữ lịch sử làm bài thi & bài tập hàng ngày trong cơ sở dữ liệu PostgreSQL của bạn.
            </p>
            <Button
              onClick={handleStart}
              style={{ background: '#ffffff', color: '#1e40af', padding: '14px 28px', fontSize: '15px', fontWeight: 800, border: 'none' }}
            >
              {user ? 'Truy Cập Bảng Điều Khiển Học Viên →' : 'Đăng Ký Khung Học Miễn Phí →'}
            </Button>
          </div>
        </section>
      </main>
    </>
  );
}

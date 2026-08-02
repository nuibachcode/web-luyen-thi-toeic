import { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { Shell } from '../../components/UI';
import { getApiGatewayUrl } from '../../config/api';

const fallbackTests = [
  { code: 'toeic-test-01', title: 'TOEIC Full Practice Test 01 - ETS 2026', time: '120 phút', questions: '200 câu hỏi', tag: 'CHÍNH THỨC 2026' },
  { code: 'toeic-test-02', title: 'TOEIC Full Practice Test 02 - ETS 2026', time: '120 phút', questions: '200 câu hỏi', tag: 'CHÍNH THỨC 2026' },
  { code: 'toeic-test-03', title: 'TOEIC Full Practice Test 03 - ETS 2026', time: '120 phút', questions: '200 câu hỏi', tag: 'CHÍNH THỨC 2026' }
];

const partInfoMap: Record<number, { name: string; title: string; count: string; icon: string; sec: string }> = {
  1: { name: 'Part 1', title: 'Mô tả hình ảnh', count: '6 câu hỏi', icon: '📷', sec: 'Nghe (Listening)' },
  2: { name: 'Part 2', title: 'Hỏi & Đáp', count: '25 câu hỏi', icon: '💬', sec: 'Nghe (Listening)' },
  3: { name: 'Part 3', title: 'Hội thoại ngắn', count: '39 câu hỏi', icon: '🗣️', sec: 'Nghe (Listening)' },
  4: { name: 'Part 4', title: 'Bài nói ngắn', count: '30 câu hỏi', icon: '🎙️', sec: 'Nghe (Listening)' },
  5: { name: 'Part 5', title: 'Điền câu ngắn', count: '30 câu hỏi', icon: '📝', sec: 'Đọc (Reading)' },
  6: { name: 'Part 6', title: 'Điền đoạn văn', count: '16 câu hỏi', icon: '📄', sec: 'Đọc (Reading)' },
  7: { name: 'Part 7', title: 'Đọc hiểu văn bản', count: '54 câu hỏi', icon: '📚', sec: 'Đọc (Reading)' },
};

export default function TestCenter() {
  const navigate = useNavigate();
  const [tests, setTests] = useState<any[]>(fallbackTests);
  const [activeTab, setActiveTab] = useState<'all' | 'listening' | 'reading'>('all');
  const [selectedPart, setSelectedPart] = useState<number | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetch(`${getApiGatewayUrl()}/api/exams`)
      .then(response => response.ok ? response.json() : Promise.reject())
      .then(({ exams }) => {
        if (exams && exams.length > 0) {
          setTests(exams.map((exam: any) => ({
            code: exam.code,
            title: exam.title,
            time: `${exam.duration_minutes || 120} phút`,
            questions: `${exam.question_count || 200} câu hỏi`,
            description: 'Bộ đề thi thử TOEIC thực tế chuẩn cấu trúc ETS mới nhất.',
            tag: 'CHÍNH THỨC 2026'
          })));
        }
      })
      .catch(() => { /* keeps fallback */ })
      .finally(() => setLoading(false));
  }, []);

  const listeningParts = [1, 2, 3, 4].map(p => ({ part: p, ...partInfoMap[p] }));
  const readingParts = [5, 6, 7].map(p => ({ part: p, ...partInfoMap[p] }));

  const handleTabChange = (tab: 'all' | 'listening' | 'reading') => {
    setActiveTab(tab);
    setSelectedPart(null);
  };

  return (
    <Shell page="/student/tests">
      <div className="content">
        <div className="page-title" style={{ alignItems: 'flex-start', marginBottom: '20px' }}>
          <div>
            
            <h1 style={{ fontSize: '30px', fontWeight: 800, marginTop: '4px', color: '#172033' }}>
              Trung tâm Thi Cử & Luyện Tập
            </h1>
            <p style={{ color: '#536174', fontSize: '14.5px' }}>
              Chọn chế độ <b>Thi Thử </b> hoặc <b>Luyện Tập theo từng Part</b> với lời giải chi tiết và từ vựng.
            </p>
          </div>
        </div>

        {/* Top Tab Bar: Tất cả đề thi / Luyện Nghe / Luyện Đọc */}
        <div className="tabs" style={{ gap: '24px', borderBottom: '2px solid #dde3ed', marginBottom: '20px' }}>
          <button 
            className={activeTab === 'all' ? 'selected' : ''} 
            onClick={() => handleTabChange('all')}
            style={{ fontSize: '15px', paddingBottom: '12px', cursor: 'pointer', fontWeight: activeTab === 'all' ? 700 : 500 }}
          >
            🌟 Tất cả đề thi ({tests.length})
          </button>
          <button 
            className={activeTab === 'listening' ? 'selected' : ''} 
            onClick={() => handleTabChange('listening')}
            style={{ fontSize: '15px', paddingBottom: '12px', cursor: 'pointer', fontWeight: activeTab === 'listening' ? 700 : 500 }}
          >
            🎧 Luyện kỹ năng Nghe
          </button>
          <button 
            className={activeTab === 'reading' ? 'selected' : ''} 
            onClick={() => handleTabChange('reading')}
            style={{ fontSize: '15px', paddingBottom: '12px', cursor: 'pointer', fontWeight: activeTab === 'reading' ? 700 : 500 }}
          >
            📖 Luyện kỹ năng Đọc
          </button>
        </div>

        {/* Part Selection Grid for Listening */}
        {activeTab === 'listening' && (
          <div style={{ background: '#f8fafc', border: '1px solid #e2e8f0', padding: '16px', borderRadius: '12px', marginBottom: '24px' }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '12px' }}>
              <span style={{ fontSize: '13px', fontWeight: 700, color: '#334155', textTransform: 'uppercase', letterSpacing: '0.5px' }}>
                Chọn Part để luyện kỹ năng Nghe (Part 1 - 4)
              </span>
              {selectedPart && (
                <button
                  onClick={() => setSelectedPart(null)}
                  style={{ background: 'none', border: 'none', color: '#2563eb', fontSize: '12px', fontWeight: 600, cursor: 'pointer' }}
                >
                  ✕ Xem tất cả bài luyện Nghe
                </button>
              )}
            </div>
            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(200px, 1fr))', gap: '12px' }}>
              {listeningParts.map(p => (
                <div
                  key={p.part}
                  onClick={() => setSelectedPart(selectedPart === p.part ? null : p.part)}
                  style={{
                    background: selectedPart === p.part ? '#eff6ff' : '#ffffff',
                    border: selectedPart === p.part ? '2px solid #2563eb' : '1px solid #cbd5e1',
                    borderRadius: '10px',
                    padding: '12px 14px',
                    cursor: 'pointer',
                    transition: 'all 0.15s'
                  }}
                >
                  <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '4px' }}>
                    <span style={{ fontWeight: 800, color: '#2563eb', fontSize: '14px' }}>{p.icon} {p.name}</span>
                    <span style={{ fontSize: '11px', color: '#64748b', fontWeight: 600 }}>{p.count}</span>
                  </div>
                  <div style={{ fontSize: '13px', fontWeight: 600, color: '#1e293b' }}>{p.title}</div>
                </div>
              ))}
            </div>
          </div>
        )}

        {/* Part Selection Grid for Reading */}
        {activeTab === 'reading' && (
          <div style={{ background: '#f8fafc', border: '1px solid #e2e8f0', padding: '16px', borderRadius: '12px', marginBottom: '24px' }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '12px' }}>
              <span style={{ fontSize: '13px', fontWeight: 700, color: '#334155', textTransform: 'uppercase', letterSpacing: '0.5px' }}>
                Chọn Part để luyện kỹ năng Đọc (Part 5 - 7)
              </span>
              {selectedPart && (
                <button
                  onClick={() => setSelectedPart(null)}
                  style={{ background: 'none', border: 'none', color: '#2563eb', fontSize: '12px', fontWeight: 600, cursor: 'pointer' }}
                >
                  ✕ Xem tất cả bài luyện Đọc
                </button>
              )}
            </div>
            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(220px, 1fr))', gap: '12px' }}>
              {readingParts.map(p => (
                <div
                  key={p.part}
                  onClick={() => setSelectedPart(selectedPart === p.part ? null : p.part)}
                  style={{
                    background: selectedPart === p.part ? '#eff6ff' : '#ffffff',
                    border: selectedPart === p.part ? '2px solid #2563eb' : '1px solid #cbd5e1',
                    borderRadius: '10px',
                    padding: '12px 14px',
                    cursor: 'pointer',
                    transition: 'all 0.15s'
                  }}
                >
                  <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '4px' }}>
                    <span style={{ fontWeight: 800, color: '#2563eb', fontSize: '14px' }}>{p.icon} {p.name}</span>
                    <span style={{ fontSize: '11px', color: '#64748b', fontWeight: 600 }}>{p.count}</span>
                  </div>
                  <div style={{ fontSize: '13px', fontWeight: 600, color: '#1e293b' }}>{p.title}</div>
                </div>
              ))}
            </div>
          </div>
        )}

        {loading && <p style={{ color: '#687386', fontStyle: 'italic' }}>⏳ Đang đồng bộ danh sách bài luyện từ hệ thống...</p>}

        {/* Dynamic Heading based on Selection */}
        <div style={{ marginBottom: '16px', display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
          <h2 style={{ fontSize: '18px', fontWeight: 800, color: '#0f172a', margin: 0 }}>
            {selectedPart
              ? `📌 Danh sách bài luyện tập Part ${selectedPart}: ${partInfoMap[selectedPart]?.title} (${partInfoMap[selectedPart]?.count})`
              : activeTab === 'listening'
              ? '🎧 Danh sách bài luyện tập Kỹ Năng Nghe (Part 1 - 4)'
              : activeTab === 'reading'
              ? '📖 Danh sách bài luyện tập Kỹ Năng Đọc (Part 5 - 7)'
              : '🌟 Tất cả bài thi thử TOEIC 200 câu'}
          </h2>
          <span style={{ fontSize: '13px', color: '#64748b', fontWeight: 600 }}>
            {tests.length} bài luyện tập có sẵn
          </span>
        </div>

        {/* Section Cards Render */}
        <section className="test-list" style={{ display: 'grid', gap: '16px' }}>
          {tests.map((t: any, i) => {
            const styleIdx = i % 3;
            const symbolClass = styleIdx === 0 ? '' : `s${styleIdx}`;

            // Case A: A specific Part is selected (e.g. Part 1, Part 5...)
            if (selectedPart) {
              const partInfo = partInfoMap[selectedPart];
              return (
                <article 
                  key={`${t.code}-part-${selectedPart}`}
                  className="test-card animate-fade-in"
                  style={{ 
                    background: '#ffffff', 
                    border: '1.5px solid #3b82f6', 
                    padding: '20px 24px', 
                    borderRadius: '14px', 
                    display: 'flex', 
                    alignItems: 'center', 
                    gap: '20px',
                    boxShadow: '0 4px 14px rgba(59, 130, 246, 0.08)'
                  }}
                >
                  <div 
                    style={{ 
                      width: '70px', 
                      height: '70px', 
                      borderRadius: '12px', 
                      background: 'linear-gradient(135deg, #2563eb, #1d4ed8)',
                      color: '#ffffff',
                      display: 'grid', 
                      placeItems: 'center', 
                      fontWeight: 800, 
                      fontSize: '14px',
                      textAlign: 'center',
                      lineHeight: '1.2',
                      flexShrink: 0
                    }}
                  >
                    {partInfo.icon}<br/>P{selectedPart}
                  </div>

                  <div style={{ flex: 1 }}>
                    <div style={{ display: 'flex', gap: '8px', alignItems: 'center', marginBottom: '6px' }}>
                      <span className="badge" style={{ background: '#dbeafe', color: '#1e40af', fontWeight: 700, padding: '3px 9px', borderRadius: '6px', fontSize: '11px' }}>
                        PART {selectedPart} • {partInfo.count.toUpperCase()}
                      </span>
                      <span style={{ fontSize: '12.5px', color: '#64748b' }}>Đề thi #{i + 1} &nbsp;•&nbsp; {partInfo.sec}</span>
                    </div>
                    <h3 style={{ fontSize: '17px', margin: '4px 0', fontWeight: 700, color: '#0f172a' }}>
                      Bài luyện Part {selectedPart} — {t.title}
                    </h3>
                    <p style={{ color: '#475569', fontSize: '13px', margin: 0 }}>
                      Bộ câu hỏi {partInfo.title} được trích xuất trực tiếp kèm âm thanh MP3, hình ảnh và lời giải chi tiết.
                    </p>
                  </div>

                  <button
                    onClick={() => navigate(`/student/exam?code=${encodeURIComponent(t.code)}&mode=practice&part=${selectedPart}`)}
                    style={{
                      background: '#2563eb',
                      color: '#ffffff',
                      border: 'none',
                      padding: '12px 20px',
                      borderRadius: '10px',
                      fontWeight: 700,
                      fontSize: '13.5px',
                      cursor: 'pointer',
                      boxShadow: '0 4px 10px rgba(37, 99, 235, 0.25)',
                      flexShrink: 0,
                      display: 'flex',
                      alignItems: 'center',
                      gap: '8px'
                    }}
                  >
                    <span>⚡</span> Làm bài Part {selectedPart} ngay
                  </button>
                </article>
              );
            }

            // Case B: In All / Listening / Reading tab (No specific part selected)
            let practiceUrl = `/student/exam?code=${encodeURIComponent(t.code)}&mode=practice`;
            let practiceBtnText = '📖 Luyện tập ';

            if (activeTab === 'listening') {
              practiceUrl += `&section=listening`;
              practiceBtnText = `🎧 Luyện phần Nghe (Part 1-4)`;
            } else if (activeTab === 'reading') {
              practiceUrl += `&section=reading`;
              practiceBtnText = `📖 Luyện phần Đọc (Part 5-7)`;
            }

            return (
              <article 
                key={t.code || t.title} 
                className="test-card" 
                style={{ 
                  background: '#fff', 
                  border: '1px solid #dde3ed', 
                  padding: '22px 24px', 
                  borderRadius: '14px', 
                  display: 'flex', 
                  alignItems: 'center', 
                  gap: '24px',
                  boxShadow: '0 4px 12px rgba(0,0,0,0.03)'
                }}
              >
                <div 
                  className={`test-symbol ${symbolClass}`} 
                  style={{ 
                    width: '75px', 
                    height: '75px', 
                    borderRadius: '12px', 
                    display: 'grid', 
                    placeItems: 'center', 
                    fontWeight: 800, 
                    fontSize: '15px',
                    letterSpacing: '-0.5px'
                  }}
                >
                  TOEIC {i + 1}
                </div>
                
                <div style={{ flex: 1 }}>
                  <div style={{ display: 'flex', gap: '10px', alignItems: 'center', marginBottom: '6px' }}>
                    <span className="badge" style={{ background: '#e8f0fe', color: '#1a73e8', fontWeight: 700, padding: '4px 10px', borderRadius: '6px', fontSize: '11px' }}>
                      {t.tag}
                    </span>
                    <span style={{ fontSize: '13px', color: '#687386' }}>⌚ {t.time} &nbsp; • &nbsp; ◫ {t.questions} &nbsp; • &nbsp; 🎧 7 Part Đầy đủ</span>
                  </div>
                  <h2 style={{ fontSize: '18px', margin: '6px 0', fontWeight: 700, color: '#172033' }}>{t.title}</h2>
                  <p style={{ color: '#536174', fontSize: '13.5px', margin: 0 }}>
                    Hệ thống câu hỏi chính xác kèm Audio âm thanh chất lượng cao, hình ảnh sắc nét và lời giải chi tiết.
                  </p>
                </div>
                
                <div style={{ display: 'flex', flexDirection: 'column', gap: '8px', minWidth: '180px' }}>
                  {activeTab === 'all' && (
                    <button 
                      onClick={() => navigate(`/student/exam?code=${encodeURIComponent(t.code)}&mode=exam`)}
                      style={{
                        background: '#e53e3e',
                        color: 'white',
                        border: 'none',
                        padding: '11px 16px',
                        borderRadius: '8px',
                        fontWeight: 700,
                        fontSize: '13px',
                        display: 'flex',
                        alignItems: 'center',
                        justifyContent: 'center',
                        gap: '8px',
                        cursor: 'pointer',
                        boxShadow: '0 2px 6px rgba(229, 62, 62, 0.2)'
                      }}
                      title="Thi thử thời gian thực theo cấu trúc ETS"
                    >
                      <span>▷</span> Thi thử ngay
                    </button>
                  )}

                  <button 
                    onClick={() => navigate(practiceUrl)}
                    style={{
                      background: activeTab !== 'all' ? '#2563eb' : '#eff6ff',
                      color: activeTab !== 'all' ? '#ffffff' : '#1d4ed8',
                      border: activeTab !== 'all' ? 'none' : '1px solid #bfdbfe',
                      padding: '11px 16px',
                      borderRadius: '8px',
                      fontWeight: 700,
                      fontSize: '13px',
                      display: 'flex',
                      alignItems: 'center',
                      justifyContent: 'center',
                      gap: '6px',
                      cursor: 'pointer',
                      boxShadow: activeTab !== 'all' ? '0 2px 6px rgba(37, 99, 235, 0.25)' : 'none'
                    }}
                    title="Luyện tập tự do có đáp án, dịch nghĩa và giải thích chi tiết"
                  >
                    {practiceBtnText}
                  </button>
                </div>
              </article>
            );
          })}
        </section>
      </div>
    </Shell>
  );
}

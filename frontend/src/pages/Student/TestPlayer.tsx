import React, { useEffect, useState, useRef } from 'react';
import { useNavigate, useLocation } from 'react-router-dom';
import { Shell } from '../../components/UI';

interface Question {
  id: string;
  test_id: string;
  passage_id?: string | null;
  part: number;
  section: 'listening' | 'reading';
  question_number: number;
  audio_url?: string | null;
  image_url?: string | null;
  passage_text?: string | null;
  question_text?: string | null;
  option_a?: string | null;
  option_b?: string | null;
  option_c?: string | null;
  option_d?: string | null;
  correct_answer?: string | null;
  dich_nghia?: string | null;
  tu_vung?: string | null;
  passage?: any;
}

interface QuestionGroup {
  id: string;
  part: number;
  section: 'listening' | 'reading';
  passage_id?: string | null;
  audio_url?: string | null;
  image_url?: string | null;
  passage_text?: string | null;
  passage_text_2?: string | null;
  passage_text_3?: string | null;
  title?: string | null;
  questions: Question[];
}

export default function TestPlayer() {
  const navigate = useNavigate();
  const location = useLocation();
  const query = new URLSearchParams(location.search);
  const testCode = query.get('code') || 'toeic-test-01';
  const mode = (query.get('mode') as 'exam' | 'practice') || 'practice';

  const [testTitle, setTestTitle] = useState('TOEIC Full Practice Test');
  const [questions, setQuestions] = useState<Question[]>([]);
  const [groups, setGroups] = useState<QuestionGroup[]>([]);
  const [currentGroupIdx, setCurrentGroupIdx] = useState(0);

  // AI Explanation state
  const [aiExplanations, setAiExplanations] = useState<Record<number, any>>({});
  const [aiLoading, setAiLoading] = useState<Record<number, boolean>>({});

  const handleFetchAiExplanation = async (q: any) => {
    const qNum = q.question_number;
    if (aiExplanations[qNum]) return;

    setAiLoading(prev => ({ ...prev, [qNum]: true }));
    try {
      const gateway = import.meta.env.VITE_API_GATEWAY_URL || 'http://localhost:4000';
      const res = await fetch(`${gateway}/api/ai/explain`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          questionText: q.question_text,
          options: q.options,
          correctAnswer: q.correct_answer,
          explanation: q.giai_thich_chi_tiet || q.dich_nghia,
          passageText: groups[currentGroupIdx]?.passage_text
        })
      });
      if (res.ok) {
        const data = await res.json();
        setAiExplanations(prev => ({ ...prev, [qNum]: data.ai }));
      }
    } catch (err) {
      console.error('AI Explain fetch error:', err);
    } finally {
      setAiLoading(prev => ({ ...prev, [qNum]: false }));
    }
  };

  // AI Transcript state
  const [aiTranscripts, setAiTranscripts] = useState<Record<string, string>>({});
  const [transcriptLoading, setTranscriptLoading] = useState<Record<string, boolean>>({});

  const handleFetchAiTranscript = async (grp: QuestionGroup) => {
    if (!grp || aiTranscripts[grp.id] || transcriptLoading[grp.id]) return;

    setTranscriptLoading(prev => ({ ...prev, [grp.id]: true }));
    try {
      const gateway = import.meta.env.VITE_API_GATEWAY_URL || 'http://localhost:4000';
      const res = await fetch(`${gateway}/api/ai/generate-transcript`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          part: grp.part,
          questions: grp.questions
        })
      });
      if (res.ok) {
        const data = await res.json();
        setAiTranscripts(prev => ({ ...prev, [grp.id]: data.transcript }));
      }
    } catch (err) {
      console.error('AI Transcript fetch error:', err);
    } finally {
      setTranscriptLoading(prev => ({ ...prev, [grp.id]: false }));
    }
  };

  // User interactions state
  const [answers, setAnswers] = useState<Record<number, string>>({});
  const [flagged, setFlagged] = useState<Record<number, boolean>>({});
  const [inlineExplanation, setInlineExplanation] = useState<Record<number, boolean>>({});
  const [showTranscript, setShowTranscript] = useState(false);
  const [showMatrixSidebar, setShowMatrixSidebar] = useState(false);
  const [isSubmitted, setIsSubmitted] = useState(false);
  const [timeLeft, setTimeLeft] = useState(120 * 60); // 120 minutes in seconds
  const [loading, setLoading] = useState(true);

  // Audio state
  const audioRef = useRef<HTMLAudioElement | null>(null);
  const [playbackRate, setPlaybackRate] = useState(1.0);

  // Fetch exam data & normalize
  useEffect(() => {
    setLoading(true);
    fetch(`${import.meta.env.VITE_API_GATEWAY_URL || 'http://localhost:4000'}/api/exams/${encodeURIComponent(testCode)}`)
      .then(res => res.ok ? res.json() : Promise.reject())
      .then(data => {
        const examObj = data.exam || data || {};
        if (examObj.title) setTestTitle(examObj.title);
        const rawQs: any[] = examObj.questions || [];
        
        // Normalize fields to prevent undefined errors
        const cleanedQs: Question[] = rawQs.map((q: any, idx: number) => {
          const pNum = Number(q.part) || 1;
          const sec = q.section || (pNum <= 4 ? 'listening' : 'reading');
          return {
            ...q,
            part: pNum,
            section: sec,
            question_number: Number(q.question_number) || idx + 1
          };
        });

        cleanedQs.sort((a, b) => a.question_number - b.question_number);
        
        const targetPartStr = query.get('part');
        const targetSectionStr = query.get('section');
        let filteredQs = cleanedQs;

        if (targetPartStr) {
          const pNum = Number(targetPartStr);
          filteredQs = cleanedQs.filter(q => q.part === pNum);
          if (examObj.title) setTestTitle(`${examObj.title} — Luyện Part ${pNum}`);
        } else if (targetSectionStr) {
          filteredQs = cleanedQs.filter(q => q.section === targetSectionStr);
          if (examObj.title) setTestTitle(`${examObj.title} — Luyện Kỹ Năng ${targetSectionStr === 'listening' ? 'Nghe' : 'Đọc'}`);
        }

        setQuestions(filteredQs);
        const dynamicTime = filteredQs.length >= 180 ? 120 * 60 : Math.max(5, Math.ceil(filteredQs.length * 0.6)) * 60;
        setTimeLeft(dynamicTime);

        // Group contiguous questions by passage
        const grps: QuestionGroup[] = [];
        for (const q of filteredQs) {
          const isGroupPart = [3, 4, 6, 7].includes(q.part);
          const pId = q.passage_id;
          const lastGroup = grps.length ? grps[grps.length - 1] : null;

          if (isGroupPart && pId && lastGroup && lastGroup.passage_id === pId) {
            lastGroup.questions.push(q);
          } else {
            const p = q.passage || {};
            grps.push({
              id: pId || q.id || String(q.question_number),
              part: q.part,
              section: q.section,
              passage_id: pId,
              audio_url: p.audio_url || q.audio_url || null,
              image_url: p.image_url || q.image_url || null,
              passage_text: p.passage_text || q.passage_text || null,
              passage_text_2: p.passage_text_2 || null,
              passage_text_3: p.passage_text_3 || null,
              title: p.title || null,
              questions: [q]
            });
          }
        }
        setGroups(grps);
      })
      .catch(() => {
        alert('Không tải được nội dung bài thi. Mời bạn kiểm tra lại server backend.');
      })
      .finally(() => setLoading(false));
  }, [testCode]);

  // Timer for Exam Mode
  useEffect(() => {
    if (mode !== 'exam' || isSubmitted) return;
    const timer = setInterval(() => {
      setTimeLeft(prev => {
        if (prev <= 1) {
          clearInterval(timer);
          handleSubmit();
          return 0;
        }
        return prev - 1;
      });
    }, 1000);
    return () => clearInterval(timer);
  }, [mode, isSubmitted]);

  const currentGroup = groups[currentGroupIdx] || null;

  const hasValidText = (text?: string | null) => {
    if (!text) return false;
    const stripped = text.replace(/<[^>]*>/g, '').trim();
    return stripped.length > 0;
  };

  // Sync audio playback speed & auto-trigger AI transcript if DB text is empty
  useEffect(() => {
    if (audioRef.current) {
      audioRef.current.playbackRate = playbackRate;
    }
    setShowTranscript(false); // Reset transcript toggle on group switch
  }, [currentGroupIdx, playbackRate]);

  useEffect(() => {
    if (currentGroup && currentGroup.part <= 4 && (showTranscript || isSubmitted)) {
      if (!hasValidText(currentGroup.passage_text) && !aiTranscripts[currentGroup.id] && !transcriptLoading[currentGroup.id]) {
        handleFetchAiTranscript(currentGroup);
      }
    }
  }, [showTranscript, isSubmitted, currentGroupIdx, currentGroup]);

  const handleSelectOption = (qNum: number, opt: string) => {
    if (isSubmitted) return;
    setAnswers(prev => ({ ...prev, [qNum]: opt }));
  };

  const handleToggleFlag = (qNum: number) => {
    setFlagged(prev => ({ ...prev, [qNum]: !prev[qNum] }));
  };

  const handleToggleInlineExplanation = (qNum: number) => {
    setInlineExplanation(prev => ({ ...prev, [qNum]: !prev[qNum] }));
  };

  const handleSubmit = async () => {
    if (!isSubmitted && window.confirm('Bạn có chắc chắn muốn nộp bài và chấm điểm ngay bây giờ không?')) {
      const score = calculateScore();
      setIsSubmitted(true);
      setShowMatrixSidebar(true); // Auto-open matrix after submit to show summary
      window.scrollTo({ top: 0, behavior: 'smooth' });

      // Save result to PostgreSQL database
      try {
        const token = localStorage.getItem('toeic_jwt');
        const gateway = import.meta.env.VITE_API_GATEWAY_URL || 'http://localhost:4000';
        await fetch(`${gateway}/api/exam-results`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            ...(token ? { Authorization: `Bearer ${token}` } : {})
          },
          body: JSON.stringify({
            examCode: testCode,
            listeningCorrect: score.listCorrect,
            readingCorrect: score.readCorrect,
            answers: answers
          })
        });
      } catch (err) {
        console.error('Failed to submit exam results to DB:', err);
      }
    }
  };

  const skipAudio = (seconds: number) => {
    if (audioRef.current) {
      audioRef.current.currentTime = Math.max(0, audioRef.current.currentTime + seconds);
    }
  };

  const calculateScore = () => {
    let listCorrect = 0;
    let readCorrect = 0;
    const listTotal = questions.filter(q => q.section === 'listening').length;
    const readTotal = questions.filter(q => q.section === 'reading').length;

    questions.forEach(q => {
      if (answers[q.question_number] === q.correct_answer) {
        if (q.section === 'listening') listCorrect++;
        else readCorrect++;
      }
    });

    const lScore = listTotal > 0 ? Math.min(495, Math.max(5, Math.round((listCorrect / listTotal) * 495 / 5) * 5)) : 0;
    const rScore = readTotal > 0 ? Math.min(495, Math.max(5, Math.round((readCorrect / readTotal) * 495 / 5) * 5)) : 0;
    return { listCorrect, readCorrect, listTotal, readTotal, lScore, rScore, total: lScore + rScore };
  };

  if (loading || !currentGroup) {
    return (
      <Shell page="/student/tests">
        <div style={{ padding: '80px 20px', textAlign: 'center', fontSize: '18px', color: '#687386' }}>
          ⏳ Đang chuẩn bị các câu hỏi và dữ liệu cho bài thi <b>{testTitle}</b>... Vui lòng chờ trong giây lát!
        </div>
      </Shell>
    );
  }

  const scoreData = isSubmitted ? calculateScore() : null;
  const isDangerTimer = timeLeft <= 60 && mode === 'exam' && !isSubmitted;
  const minutes = Math.floor(timeLeft / 60);
  const seconds = timeLeft % 60;
  const timerDisplay = `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
  
  const isListeningPart = currentGroup.part <= 4;
  const answeredCount = Object.keys(answers).length;

  return (
    <div style={{ background: '#f1f5f9', minHeight: '100vh', display: 'flex', flexDirection: 'column', fontFamily: "'Inter', Arial, sans-serif", overflow: 'hidden', height: '100vh' }}>
      
      {/* HEADER BAR */}
      <header style={{ 
        height: '64px', 
        background: '#1e293b', 
        color: '#fff', 
        display: 'flex', 
        alignItems: 'center', 
        justifyContent: 'space-between', 
        padding: '0 24px', 
        flexShrink: 0,
        boxShadow: '0 2px 8px rgba(0,0,0,0.15)',
        zIndex: 100
      }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: '16px' }}>
          <button 
            onClick={() => { if (window.confirm('Bạn có muốn thoát khỏi phòng thi? Các đáp án chưa nộp có thể không được lưu.')) navigate('/student/tests'); }}
            style={{ background: 'transparent', color: '#cbd5e1', border: '1px solid #475569', padding: '6px 12px', borderRadius: '6px', cursor: 'pointer', fontSize: '13px', fontWeight: 600 }}
          >
            ← Thoát
          </button>
          <div>
            <h1 style={{ fontSize: '15px', fontWeight: 700, margin: 0, color: '#f8fafc', whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis', maxWidth: '280px' }}>
              {testTitle}
            </h1>
            <span style={{ fontSize: '11.5px', color: mode === 'exam' ? '#f87171' : '#38bdf8', fontWeight: 700 }}>
              {mode === 'exam' ? '▷ THI THỬ' : '📖 LUYỆN TẬP '}
            </span>
          </div>
        </div>

        {/* Current Part & Question Numbers */}
        <div style={{ background: '#0f172a', padding: '6px 16px', borderRadius: '20px', border: '1px solid #334155', fontWeight: 700, color: '#cbd5e1', fontSize: '14px' }}>
          Part {currentGroup.part} • {(currentGroup.section || '').toUpperCase()} (Câu {currentGroup.questions[0].question_number} - {currentGroup.questions[currentGroup.questions.length - 1].question_number})
        </div>

        {/* Action Controls */}
        <div style={{ display: 'flex', alignItems: 'center', gap: '16px' }}>
          {mode === 'exam' && !isSubmitted && (
            <div style={{ 
              display: 'flex', 
              alignItems: 'center', 
              gap: '6px', 
              fontSize: '16px', 
              fontWeight: 800, 
              color: isDangerTimer ? '#ef4444' : '#fbbf24',
              padding: '6px 12px',
              background: '#0f172a',
              borderRadius: '8px',
              border: '1px solid #334155'
            }}>
              <span>⏱️</span>
              <span>{timerDisplay}</span>
            </div>
          )}
          
          <button
            onClick={() => setShowMatrixSidebar(!showMatrixSidebar)}
            style={{ background: showMatrixSidebar ? '#334155' : '#0f172a', color: '#fff', border: '1px solid #475569', padding: '8px 14px', borderRadius: '8px', fontWeight: 700, fontSize: '13px', cursor: 'pointer', display: 'flex', alignItems: 'center', gap: '6px' }}
          >
            <span>📋 Bảng đáp án ({answeredCount}/{questions.length})</span>
          </button>

          {!isSubmitted ? (
            <button 
              onClick={handleSubmit}
              style={{ background: '#3b82f6', color: '#fff', border: 'none', padding: '9px 18px', borderRadius: '8px', fontWeight: 700, fontSize: '13.5px', cursor: 'pointer', boxShadow: '0 2px 6px rgba(59,130,246,0.4)' }}
            >
              Nộp Bài →
            </button>
          ) : (
            <span style={{ background: '#10b981', color: 'white', padding: '7px 14px', borderRadius: '6px', fontWeight: 700, fontSize: '13px' }}>
              ✓ Đã Chấm Điểm
            </span>
          )}
        </div>
      </header>

      {/* RESULTS BANNER WHEN SUBMITTED */}
      {isSubmitted && scoreData && (
        <div style={{ background: '#0f172a', color: '#fff', padding: '20px 30px', borderBottom: '1px solid #334155', display: 'flex', alignItems: 'center', justifyContent: 'space-between', flexShrink: 0 }}>
          <div>
            <span style={{ color: '#38bdf8', fontSize: '12px', fontWeight: 700, letterSpacing: '1px' }}>KẾT QUẢ BÀI THI CỦA BẠN</span>
            <h2 style={{ fontSize: '32px', fontWeight: 800, margin: '4px 0', color: '#fbbf24' }}>
              Tổng điểm: {scoreData.total} <span style={{ fontSize: '18px', color: '#94a3b8', fontWeight: 500 }}>/ 990</span>
            </h2>
            <div style={{ display: 'flex', gap: '25px', color: '#cbd5e1', fontSize: '14px' }}>
              {scoreData.listTotal > 0 && <div>🎧 Listening: <b style={{ color: '#fff' }}>{scoreData.lScore}</b> (Đúng {scoreData.listCorrect}/{scoreData.listTotal})</div>}
              {scoreData.readTotal > 0 && <div>📖 Reading: <b style={{ color: '#fff' }}>{scoreData.rScore}</b> (Đúng {scoreData.readCorrect}/{scoreData.readTotal})</div>}
            </div>
          </div>
          <div style={{ maxWidth: '400px', fontSize: '13px', color: '#94a3b8', lineHeight: 1.5 }}>
            💡 Nhấp vào ô số bất kỳ trên <b>Bảng đáp án ({questions.length} câu)</b> hoặc bấm mũi tên tới lui để kiểm tra tường tận bản dịch, giải thích chi tiết cho từng đáp án ĐÚNG/SAI.
          </div>
        </div>
      )}

      {/* MAIN WORKSPACE (SPLIT SCREEN 50-50 + OPTIONAL SIDEBAR DRAWER) */}
      <main style={{ flex: 1, display: 'flex', overflow: 'hidden', position: 'relative' }}>
        
        {/* 2-COLUMN SPLIT SCREEN CONTENT (Left 50%, Right 50%) */}
        <div style={{ flex: 1, display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '16px', padding: '16px 20px', overflow: 'hidden' }}>
          
          {/* COLUMN 1: LEFT PASSAGE / AUDIO & IMAGE AREA */}
          <section style={{ background: '#fff', borderRadius: '12px', border: '1px solid #cbd5e1', padding: '24px', overflowY: 'auto', display: 'flex', flexDirection: 'column', gap: '20px', boxShadow: '0 2px 8px rgba(0,0,0,0.02)' }}>
            
            <div style={{ borderBottom: '2px solid #f1f5f9', paddingBottom: '12px', display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
              <span style={{ fontSize: '13px', fontWeight: 800, color: '#475569', textTransform: 'uppercase' }}>
                {currentGroup.title || `Nội dung Phần Thi • Part ${currentGroup.part}`}
              </span>
              {isListeningPart && mode === 'practice' && !isSubmitted && (
                <button 
                  onClick={() => setShowTranscript(!showTranscript)} 
                  style={{ background: '#f1f5f9', border: '1px solid #cbd5e1', color: '#2563eb', padding: '4px 10px', borderRadius: '6px', fontSize: '12px', fontWeight: 600, cursor: 'pointer' }}
                >
                  {showTranscript ? '🙈 Ẩn Transcript' : '👁️ Xem Transcript Audio'}
                </button>
              )}
            </div>

            {currentGroup.part === 1 && (
              <div style={{ fontSize: '15px', color: '#1e293b', fontWeight: 600, padding: '10px 16px', background: '#f8fafc', borderRadius: '8px', border: '1px solid #e2e8f0' }}>
                Select the one statement that best describes what you see in the picture.
              </div>
            )}
            {currentGroup.part === 2 && (
              <div style={{ fontSize: '15px', color: '#1e293b', fontWeight: 600, padding: '10px 16px', background: '#f8fafc', borderRadius: '8px', border: '1px solid #e2e8f0' }}>
                Select the best response to the question.
              </div>
            )}

            {/* AUDIO PLAYER MODULE (Part 1 to 4) */}
            {currentGroup.audio_url && (
              <div style={{ background: '#eff6ff', padding: '18px', borderRadius: '12px', border: '1px solid #bfdbfe' }}>
                <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: '12px' }}>
                  <strong style={{ color: '#1e3a8a', fontSize: '14px', display: 'flex', alignItems: 'center', gap: '6px' }}>
                    <span>🔊</span> Trình phát âm thanh
                  </strong>
                  {mode === 'practice' && (
                    <div style={{ display: 'flex', gap: '4px' }}>
                      {[0.8, 1.0, 1.25].map(rate => (
                        <button 
                          key={rate} 
                          onClick={() => setPlaybackRate(rate)}
                          style={{ padding: '3px 8px', borderRadius: '6px', fontSize: '11.5px', fontWeight: 700, background: playbackRate === rate ? '#2563eb' : '#fff', color: playbackRate === rate ? '#fff' : '#1e3a8a', border: '1px solid #93c5fd', cursor: 'pointer' }}
                        >
                          {rate}x
                        </button>
                      ))}
                    </div>
                  )}
                </div>

                <audio ref={audioRef} controls src={currentGroup.audio_url} style={{ width: '100%', outline: 'none' }} />

                {mode === 'practice' && (
                  <div style={{ display: 'flex', justifyContent: 'center', gap: '12px', marginTop: '12px' }}>
                    <button onClick={() => skipAudio(-5)} style={{ background: '#fff', border: '1px solid #93c5fd', color: '#1e40af', padding: '6px 14px', borderRadius: '8px', fontWeight: 600, cursor: 'pointer', fontSize: '12px', boxShadow: '0 1px 2px rgba(0,0,0,0.05)' }}>
                      ↩ Lùi 5 giây
                    </button>
                    <button onClick={() => skipAudio(5)} style={{ background: '#fff', border: '1px solid #93c5fd', color: '#1e40af', padding: '6px 14px', borderRadius: '8px', fontWeight: 600, cursor: 'pointer', fontSize: '12px', boxShadow: '0 1px 2px rgba(0,0,0,0.05)' }}>
                      Tiến 5 giây ↪
                    </button>
                  </div>
                )}
              </div>
            )}

            {/* GRAPHIC IMAGE (Part 1, 3, 4) */}
            {currentGroup.image_url && (
              <div style={{ textAlign: 'center', background: '#f8fafc', padding: '12px', borderRadius: '10px', border: '1px solid #cbd5e1' }}>
                <img src={currentGroup.image_url} alt="Minh họa Part 1" style={{ maxWidth: '100%', maxHeight: currentGroup.part === 1 ? '240px' : '320px', objectFit: 'contain', borderRadius: '6px' }} />
              </div>
            )}

            {/* LISTENING TRANSCRIPT OR READING PASSAGE */}
            {(!isListeningPart || showTranscript || isSubmitted) && (
              <div 
                className="passage-view" 
                style={{ 
                  lineHeight: '1.75', 
                  color: '#0f172a', 
                  fontSize: '14.5px', 
                  padding: '18px 22px', 
                  minHeight: '180px',
                  maxHeight: '420px',
                  overflowY: 'auto',
                  background: isListeningPart ? '#fffbeb' : '#ffffff', 
                  border: isListeningPart ? '1.5px solid #f59e0b' : '1px solid #e2e8f0', 
                  borderRadius: '12px',
                  boxShadow: '0 2px 6px rgba(0,0,0,0.03)'
                }}
              >
                {isListeningPart && (
                  <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '12px', paddingBottom: '8px', borderBottom: '1px solid #fde68a' }}>
                    <strong style={{ color: '#d97706', fontSize: '15px', display: 'flex', alignItems: 'center', gap: '6px' }}>
                      <span>📜</span> Transcript Bài Nghe & Bản Dịch:
                    </strong>
                    {!hasValidText(currentGroup.passage_text) && !aiTranscripts[currentGroup.id] && (
                      <button
                        onClick={() => handleFetchAiTranscript(currentGroup)}
                        disabled={transcriptLoading[currentGroup.id]}
                        style={{
                          background: 'linear-gradient(135deg, #d97706, #b45309)',
                          color: '#ffffff',
                          border: 'none',
                          padding: '6px 14px',
                          borderRadius: '8px',
                          fontWeight: 700,
                          fontSize: '12px',
                          cursor: 'pointer'
                        }}
                      >
                        {transcriptLoading[currentGroup.id] ? '⏳ AI đang sinh Transcript...' : '✨ Khôi Phục Transcript Bằng AI'}
                      </button>
                    )}
                  </div>
                )}

                {hasValidText(currentGroup.passage_text) ? (
                  <div dangerouslySetInnerHTML={{ __html: currentGroup.passage_text! }} />
                ) : aiTranscripts[currentGroup.id] ? (
                  <div dangerouslySetInnerHTML={{ __html: aiTranscripts[currentGroup.id].replace(/\n/g, '<br/>').replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>') }} />
                ) : transcriptLoading[currentGroup.id] ? (
                  <div style={{ color: '#d97706', fontStyle: 'italic', padding: '16px 0', fontSize: '14px' }}>
                    ⏳ AeroAI đang khôi phục bản transcript bài nghe tiếng Anh và bản dịch tiếng Việt cho bạn...
                  </div>
                ) : isListeningPart ? (
                  <div style={{ background: '#ffffff', padding: '14px', borderRadius: '8px', border: '1px dashed #d97706', color: '#92400e', fontSize: '13.5px', lineHeight: '1.5' }}>
                    ⚠️ Cụm bài nghe này chưa có sẵn transcript thủ công trong CSDL.
                    <button
                      onClick={() => handleFetchAiTranscript(currentGroup)}
                      style={{ display: 'block', marginTop: '10px', background: 'linear-gradient(135deg, #d97706, #b45309)', color: '#ffffff', border: 'none', padding: '8px 16px', borderRadius: '8px', fontWeight: 700, fontSize: '13px', cursor: 'pointer', boxShadow: '0 2px 8px rgba(217,119,6,0.3)' }}
                    >
                      ⚡ Khôi Phục Transcript Bài Nghe & Bản Dịch Bằng AeroAI →
                    </button>
                  </div>
                ) : null}
              </div>
            )}

            {/* Double / Triple Passages in Part 7 */}
            {!isListeningPart && currentGroup.passage_text_2 && (
              <div 
                style={{ lineHeight: '1.8', color: '#0f172a', fontSize: '15px', padding: '22px', background: '#ffffff', border: '1px solid #e2e8f0', borderRadius: '10px', overflowX: 'auto' }} 
                dangerouslySetInnerHTML={{ __html: currentGroup.passage_text_2 }} 
              />
            )}
            {!isListeningPart && currentGroup.passage_text_3 && (
              <div 
                style={{ lineHeight: '1.8', color: '#0f172a', fontSize: '15px', padding: '22px', background: '#ffffff', border: '1px solid #e2e8f0', borderRadius: '10px', overflowX: 'auto' }} 
                dangerouslySetInnerHTML={{ __html: currentGroup.passage_text_3 }} 
              />
            )}

            {!currentGroup.audio_url && !currentGroup.image_url && (!currentGroup.passage_text || (isListeningPart && !showTranscript && !isSubmitted)) && (
              <div style={{ padding: '60px 20px', textAlign: 'center', color: '#94a3b8', fontStyle: 'italic', background: '#f8fafc', borderRadius: '10px', border: '1px dashed #cbd5e1' }}>
                {isListeningPart ? '🎧 Hãy lắng nghe âm thanh và chọn đáp án chính xác cho các câu hỏi bên cột phải.' : '👉 Câu hỏi trắc nghiệm trực quan bên cột phải (Part 5 Incomplete Sentences).'}
              </div>
            )}
          </section>

          {/* COLUMN 2: MIDDLE / RIGHT QUESTIONS LIST AREA */}
          <section style={{ background: '#fff', borderRadius: '12px', border: '1px solid #cbd5e1', padding: '24px', overflowY: 'auto', display: 'flex', flexDirection: 'column', justifyContent: 'space-between', boxShadow: '0 2px 8px rgba(0,0,0,0.02)' }}>
            <div style={{ display: 'flex', flexDirection: 'column', gap: '32px' }}>
              
              {currentGroup.questions.map(q => {
                const selectedOpt = answers[q.question_number];
                const isCorrect = isSubmitted ? selectedOpt === q.correct_answer : null;
                const isFlagged = !!flagged[q.question_number];
                const showExpl = isSubmitted || inlineExplanation[q.question_number];

                // Strict TOEIC rule: Part 1 and Part 2 do not show option text!
                const hideOptionText = (q.part === 1 || q.part === 2) && !showExpl;

                return (
                  <div key={q.id || q.question_number} style={{ borderBottom: '2px solid #f1f5f9', paddingBottom: '26px' }}>
                    
                    <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: '16px', gap: '12px' }}>
                      <div style={{ flex: 1 }}>
                        <span style={{ display: 'inline-block', background: '#2563eb', color: 'white', fontWeight: 800, padding: '5px 12px', borderRadius: '6px', fontSize: '14px', marginRight: '10px', boxShadow: '0 2px 4px rgba(37,99,235,0.2)' }}>
                          Câu {q.question_number}
                        </span>
                        <strong style={{ fontSize: '16px', color: '#0f172a', lineHeight: 1.5 }}>
                          {hideOptionText ? '' : (q.question_text || 'Chọn đáp án đúng dưới đây:')}
                        </strong>
                      </div>

                      {/* Flag for review button */}
                      <button 
                        onClick={() => handleToggleFlag(q.question_number)}
                        style={{ background: isFlagged ? '#fef3c7' : '#f8fafc', border: `1px solid ${isFlagged ? '#f59e0b' : '#cbd5e1'}`, color: isFlagged ? '#d97706' : '#64748b', padding: '6px 12px', borderRadius: '8px', cursor: 'pointer', fontSize: '12.5px', fontWeight: 700, display: 'flex', alignItems: 'center', gap: '6px', flexShrink: 0 }}
                        title="Đánh dấu cờ màu vàng để quay lại xem trên bảng 200 câu"
                      >
                        <span>🚩</span> {isFlagged ? 'Đã Đánh Dấu' : 'Đánh dấu'}
                      </button>
                    </div>

                    {/* Options List */}
                    <div style={{ display: 'flex', flexDirection: 'column', gap: '12px' }}>
                      {['A', 'B', 'C', 'D'].map(optLetter => {
                        if (q.part === 2 && optLetter === 'D') return null; // Part 2 only has 3 choices
                        const optTextKey = `option_${optLetter.toLowerCase()}` as keyof Question;
                        const optText = (q[optTextKey] as string) || '';

                        let cardBg = selectedOpt === optLetter ? '#eff6ff' : '#f8fafc';
                        let cardBorder = selectedOpt === optLetter ? '#3b82f6' : '#e2e8f0';
                        let badgeBg = selectedOpt === optLetter ? '#2563eb' : '#e2e8f0';
                        let badgeColor = selectedOpt === optLetter ? '#ffffff' : '#475569';

                        if (isSubmitted) {
                          if (optLetter === q.correct_answer) {
                            cardBg = '#ecfdf5';
                            cardBorder = '#10b981';
                            badgeBg = '#10b981';
                            badgeColor = '#ffffff';
                          } else if (selectedOpt === optLetter && selectedOpt !== q.correct_answer) {
                            cardBg = '#fef2f2';
                            cardBorder = '#ef4444';
                            badgeBg = '#ef4444';
                            badgeColor = '#ffffff';
                          }
                        }

                        return (
                          <button 
                            key={optLetter}
                            onClick={() => handleSelectOption(q.question_number, optLetter)}
                            style={{ 
                              display: 'flex', 
                              alignItems: 'center', 
                              gap: '14px', 
                              padding: '13px 18px', 
                              background: cardBg, 
                              border: `2px solid ${cardBorder}`, 
                              borderRadius: '10px', 
                              textAlign: 'left', 
                              cursor: isSubmitted ? 'default' : 'pointer',
                              transition: 'all 0.15s'
                            }}
                          >
                            <span style={{ width: '32px', height: '32px', borderRadius: '50%', background: badgeBg, color: badgeColor, fontWeight: 800, display: 'grid', placeItems: 'center', fontSize: '13.5px', flexShrink: 0 }}>
                              {optLetter}
                            </span>
                            <span style={{ fontSize: '15px', color: '#1e293b', fontWeight: selectedOpt === optLetter ? 700 : 500 }}>
                              {hideOptionText ? '' : (optText || `(Lựa chọn ${optLetter})`)}
                            </span>
                          </button>
                        );
                      })}
                    </div>

                    {/* Practice Mode: Toggle inline Explanation */}
                    {mode === 'practice' && !isSubmitted && (
                      <button 
                        onClick={() => handleToggleInlineExplanation(q.question_number)}
                        style={{ marginTop: '14px', background: '#f8fafc', color: '#2563eb', border: '1px dashed #93c5fd', padding: '8px 16px', borderRadius: '8px', fontSize: '13px', fontWeight: 700, cursor: 'pointer', width: '100%', display: 'flex', alignItems: 'center', justifyContent: 'center', gap: '6px' }}
                      >
                        💡 {showExpl ? '🙈 Ẩn lời giải và dịch nghĩa' : '📖 Xem Lời Giải & Từ Vựng Ngay (Practice Mode)'}
                      </button>
                    )}

                    {/* Detailed Explanation Box */}
                    {showExpl && (
                      <div style={{ marginTop: '16px', background: '#f8fafc', padding: '20px', borderRadius: '12px', border: '1px solid #cbd5e1', fontSize: '14.5px', lineHeight: 1.6 }}>
                        <div style={{ marginBottom: '12px', paddingBottom: '10px', borderBottom: '1px solid #e2e8f0', display: 'flex', justifyContent: 'space-between' }}>
                          <span style={{ fontWeight: 800, color: '#10b981', fontSize: '15px' }}>✓ Đáp án chính xác: {q.correct_answer}</span>
                          {selectedOpt && (
                            <span style={{ fontWeight: 700, color: isCorrect ? '#10b981' : '#ef4444' }}>
                              (Bạn chọn: {selectedOpt} - {isCorrect ? 'Đúng' : 'Sai'})
                            </span>
                          )}
                        </div>

                        {q.dich_nghia && (
                          <div style={{ marginTop: '12px' }}>
                            <strong style={{ color: '#1e293b', display: 'block', marginBottom: '6px' }}>🇻🇳 Bản dịch nghĩa tiếng Việt:</strong>
                            <div style={{ color: '#334155', whiteSpace: 'pre-wrap', background: '#fff', padding: '12px', borderRadius: '8px', border: '1px solid #e2e8f0' }}>{q.dich_nghia}</div>
                          </div>
                        )}

                        {q.tu_vung && (
                          <div style={{ marginTop: '14px' }}>
                            <strong style={{ color: '#0284c7', display: 'block', marginBottom: '6px' }}>📚 Từ vựng ghi nhớ:</strong>
                            <div style={{ color: '#0f172a', whiteSpace: 'pre-wrap', background: '#f0f9ff', padding: '12px', borderRadius: '8px', border: '1px solid #bae6fd', fontFamily: 'monospace', fontSize: '13.5px' }}>{q.tu_vung}</div>
                          </div>
                        )}

                        {/* AI Trigger Button & AI Output Card */}
                        <div style={{ marginTop: '16px', paddingTop: '14px', borderTop: '1px dashed #cbd5e1' }}>
                          {!aiExplanations[q.question_number] ? (
                            <button
                              onClick={() => handleFetchAiExplanation(q)}
                              disabled={aiLoading[q.question_number]}
                              style={{
                                background: 'linear-gradient(135deg, #1d4ed8, #2563eb)',
                                color: '#ffffff',
                                border: 'none',
                                padding: '10px 18px',
                                borderRadius: '8px',
                                fontWeight: 700,
                                fontSize: '13.5px',
                                cursor: 'pointer',
                                display: 'flex',
                                alignItems: 'center',
                                gap: '8px',
                                boxShadow: '0 4px 10px rgba(37,99,235,0.2)'
                              }}
                            >
                              <span>🤖</span> {aiLoading[q.question_number] ? '⏳ AeroAI đang phân tích câu hỏi...' : 'Phân Tích Chuyên Sâu Bằng AeroAI →'}
                            </button>
                          ) : (
                            <div style={{ background: '#eff6ff', border: '1.5px solid #3b82f6', borderRadius: '12px', padding: '16px', marginTop: '8px' }}>
                              <div style={{ display: 'flex', alignItems: 'center', gap: '8px', marginBottom: '12px' }}>
                                <span style={{ fontSize: '18px' }}>🤖</span>
                                <strong style={{ color: '#1e40af', fontSize: '15px' }}>Phân tích chuyên sâu từ AeroAI 990+</strong>
                              </div>

                              {aiExplanations[q.question_number].translation && (
                                <div style={{ marginBottom: '10px' }}>
                                  <strong style={{ fontSize: '13px', color: '#1e3a8a' }}>🇻🇳 Dịch nghĩa sư phạm từ AI:</strong>
                                  <p style={{ margin: '4px 0 0 0', color: '#1e293b', fontSize: '13.5px', whiteSpace: 'pre-wrap' }}>
                                    {aiExplanations[q.question_number].translation}
                                  </p>
                                </div>
                              )}

                              {aiExplanations[q.question_number].whyCorrect && (
                                <div style={{ marginBottom: '10px' }}>
                                  <strong style={{ fontSize: '13px', color: '#1e3a8a' }}>🧠 Lý do chọn đáp án & Cấu trúc ngữ pháp:</strong>
                                  <p style={{ margin: '4px 0 0 0', color: '#1e293b', fontSize: '13.5px' }}>
                                    {aiExplanations[q.question_number].whyCorrect}
                                  </p>
                                </div>
                              )}

                              {aiExplanations[q.question_number].vocabulary && Array.isArray(aiExplanations[q.question_number].vocabulary) && (
                                <div style={{ marginBottom: '10px' }}>
                                  <strong style={{ fontSize: '13px', color: '#1e3a8a' }}>📚 Bảng từ vựng đắt giá:</strong>
                                  <div style={{ display: 'flex', flexWrap: 'wrap', gap: '8px', marginTop: '6px' }}>
                                    {aiExplanations[q.question_number].vocabulary.map((v: any, vIdx: number) => (
                                      <span key={vIdx} style={{ background: '#ffffff', border: '1px solid #bfdbfe', padding: '4px 10px', borderRadius: '6px', fontSize: '12.5px', color: '#1e40af', fontWeight: 600 }}>
                                        <b>{v.word}</b> {v.ipa ? <small style={{ color: '#64748b' }}>{v.ipa}</small> : ''}: {v.meaning}
                                      </span>
                                    ))}
                                  </div>
                                </div>
                              )}

                              {aiExplanations[q.question_number].trapWarning && (
                                <div style={{ background: '#fffbebfb', border: '1px solid #fef3c7', padding: '8px 12px', borderRadius: '8px', fontSize: '12.5px', color: '#92400e' }}>
                                  ⚠️ <b>Mẹo & Cảnh báo bẫy:</b> {aiExplanations[q.question_number].trapWarning}
                                </div>
                              )}
                            </div>
                          )}
                        </div>
                      </div>
                    )}
                  </div>
                );
              })}
            </div>

            {/* Group Navigation Buttons */}
            <div style={{ display: 'flex', justifyContent: 'space-between', marginTop: '32px', paddingTop: '18px', borderTop: '2px solid #e2e8f0', flexShrink: 0 }}>
              <button 
                onClick={() => setCurrentGroupIdx(prev => Math.max(0, prev - 1))}
                disabled={currentGroupIdx === 0}
                style={{ background: currentGroupIdx === 0 ? '#f1f5f9' : '#fff', border: '1px solid #cbd5e1', color: currentGroupIdx === 0 ? '#94a3b8' : '#1e293b', padding: '11px 22px', borderRadius: '8px', fontWeight: 700, cursor: currentGroupIdx === 0 ? 'not-allowed' : 'pointer', fontSize: '14px' }}
              >
                ← Cụm trước
              </button>
              
              <span style={{ alignSelf: 'center', color: '#64748b', fontWeight: 600, fontSize: '13.5px' }}>
                Cụm {currentGroupIdx + 1} / {groups.length}
              </span>

              <button 
                onClick={() => setCurrentGroupIdx(prev => Math.min(groups.length - 1, prev + 1))}
                disabled={currentGroupIdx === groups.length - 1}
                style={{ background: currentGroupIdx === groups.length - 1 ? '#cbd5e1' : '#2563eb', border: 'none', color: 'white', padding: '11px 26px', borderRadius: '8px', fontWeight: 700, cursor: currentGroupIdx === groups.length - 1 ? 'not-allowed' : 'pointer', fontSize: '14px', boxShadow: currentGroupIdx === groups.length - 1 ? 'none' : '0 2px 8px rgba(37,99,235,0.4)' }}
              >
                Cụm tiếp theo →
              </button>
            </div>
          </section>
        </div>

        {/* EXPANDABLE 200-QUESTION MATRIX SIDEBAR DRAWER */}
        {showMatrixSidebar && (
          <section style={{ 
            width: '310px', 
            background: '#ffffff', 
            borderLeft: '2px solid #cbd5e1', 
            padding: '20px', 
            overflowY: 'auto',
            boxShadow: '-4px 0 16px rgba(0,0,0,0.05)',
            flexShrink: 0,
            display: 'flex',
            flexDirection: 'column',
            zIndex: 50
          }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '16px', borderBottom: '2px solid #f1f5f9', paddingBottom: '12px' }}>
              <h3 style={{ margin: 0, fontSize: '16px', fontWeight: 800, color: '#0f172a' }}>
                Bảng {questions.length} Câu Hỏi
              </h3>
              <button 
                onClick={() => setShowMatrixSidebar(false)}
                style={{ background: 'transparent', border: 'none', fontSize: '18px', cursor: 'pointer', color: '#64748b', fontWeight: 800 }}
              >
                ✕
              </button>
            </div>

            <div style={{ display: 'flex', flexWrap: 'wrap', gap: '10px', fontSize: '11.5px', color: '#64748b', marginBottom: '18px', background: '#f8fafc', padding: '10px', borderRadius: '8px', border: '1px solid #e2e8f0' }}>
              <span style={{ display: 'flex', alignItems: 'center', gap: '5px', width: '45%' }}><b style={{ width: '12px', height: '12px', background: '#2563eb', borderRadius: '3px', display: 'inline-block' }}></b> Đã làm</span>
              <span style={{ display: 'flex', alignItems: 'center', gap: '5px', width: '45%' }}><b style={{ width: '12px', height: '12px', background: '#fef3c7', border: '1px solid #f59e0b', borderRadius: '3px', display: 'inline-block' }}></b> Đã cờ vàng</span>
              <span style={{ display: 'flex', alignItems: 'center', gap: '5px', width: '100%' }}><b style={{ width: '12px', height: '12px', border: '2px solid #2563eb', borderRadius: '3px', display: 'inline-block' }}></b> Đang xem hiện tại</span>
            </div>

            <div style={{ flex: 1 }}>
              {[1, 2, 3, 4, 5, 6, 7].map(partNum => {
                const partQs = questions.filter(q => q.part === partNum);
                if (!partQs.length) return null;

                const isListening = [1, 2, 3, 4].includes(partNum);
                const answeredInPart = partQs.filter(q => !!answers[q.question_number]).length;
                
                return (
                  <div key={partNum} style={{ marginBottom: '20px' }}>
                    <div style={{ fontSize: '12px', fontWeight: 800, color: '#334155', marginBottom: '10px', display: 'flex', justifyContent: 'space-between', background: '#f1f5f9', padding: '8px 12px', borderRadius: '6px', border: '1px solid #cbd5e1' }}>
                      <span>PART {partNum} ({partQs[0].question_number}-{partQs[partQs.length - 1].question_number})</span>
                      <span>{answeredInPart}/{partQs.length}</span>
                    </div>

                    <div style={{ display: 'grid', gridTemplateColumns: 'repeat(5, 1fr)', gap: '6px' }}>
                      {partQs.map(q => {
                        const qNum = q.question_number;
                        const isAnswered = !!answers[qNum];
                        const isFlagged = !!flagged[qNum];
                        const isCorrect = isSubmitted ? answers[qNum] === q.correct_answer : null;

                        const isInCurrentGroup = currentGroup.questions.some(cq => cq.question_number === qNum);
                        
                        // Strict TOEIC rule: In Exam mode, past listening parts are LOCKED!
                        const currentFirstQ = currentGroup.questions[0].question_number;
                        const isLockedListening = mode === 'exam' && !isSubmitted && isListening && qNum < currentFirstQ && !isInCurrentGroup && q.part < currentGroup.part;

                        let bg = '#fff';
                        let border = '#cbd5e1';
                        let color = '#475569';

                        if (isAnswered) {
                          bg = '#2563eb';
                          border = '#2563eb';
                          color = '#ffffff';
                        }
                        if (isFlagged) {
                          bg = '#fef3c7';
                          border = '#f59e0b';
                          color = '#d97706';
                        }
                        if (isInCurrentGroup) {
                          border = '#2563eb';
                          if (!isAnswered && !isFlagged) {
                            bg = '#eff6ff';
                            color = '#2563eb';
                          }
                        }

                        if (isSubmitted && isAnswered) {
                          if (isCorrect) { bg = '#10b981'; border = '#10b981'; color = 'white'; }
                          else { bg = '#ef4444'; border = '#ef4444'; color = 'white'; }
                        }

                        if (isLockedListening) {
                          bg = '#f1f5f9';
                          border = '#e2e8f0';
                          color = '#94a3b8';
                        }

                        return (
                          <button 
                            key={qNum}
                            onClick={() => {
                              if (isLockedListening) {
                                alert('⚠️ Luật thi TOEIC Thực Tế: Không được phép nhấp quay lại câu hỏi Listening đã qua!');
                                return;
                              }
                              const gIdx = groups.findIndex(g => g.questions.some(gq => gq.question_number === qNum));
                              if (gIdx !== -1) {
                                setCurrentGroupIdx(gIdx);
                                // optional: keep drawer open or close
                              }
                            }}
                            style={{
                              height: '34px',
                              borderRadius: '6px',
                              background: bg,
                              border: `2px solid ${border}`,
                              color: color,
                              fontWeight: isInCurrentGroup ? 800 : 600,
                              fontSize: '12px',
                              cursor: isLockedListening ? 'not-allowed' : 'pointer',
                              display: 'flex',
                              alignItems: 'center',
                              justifyContent: 'center'
                            }}
                            title={`Câu ${qNum}${isFlagged ? ' - Đã đánh dấu cờ vàng' : ''}${isLockedListening ? ' - Đã khóa (luật Listening)' : ''}`}
                          >
                            {isLockedListening ? '🔒' : (isFlagged ? '🚩' : qNum)}
                          </button>
                        );
                      })}
                    </div>
                  </div>
                );
              })}
            </div>
          </section>
        )}

      </main>
    </div>
  );
}

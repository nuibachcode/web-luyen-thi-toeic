import { useState, useEffect } from 'react';

type VocabItem = {
  word: string;
  ipa: string;
  partOfSpeech: string;
  meaning: string;
  example: string;
};

type GrammarRule = {
  title: string;
  explanation: string;
  formula: string;
  examples: string[];
};

type QuestionItem = {
  id: number;
  questionText: string;
  optionA: string;
  optionB: string;
  optionC: string;
  optionD: string;
  correctAnswer: string;
  explanation: string;
};

type DayLesson = {
  dayNumber: number;
  title: string;
  estimatedTimeMinutes: number;
  vocabularyList: VocabItem[];
  grammarRule: GrammarRule;
  etsTips: string;
  practiceQuestions: QuestionItem[];
};

type DayOverview = {
  dayNumber: number;
  weekNumber: number;
  title: string;
  focus: string;
};

type MasterRoadmap = {
  diagnosticSummary: string;
  weakPoints: string[];
  totalDays: number;
  weeksCount: number;
  days: DayOverview[];
};

export default function AIRoadmapWidget() {
  const [loading, setLoading] = useState(true);
  const [generating, setGenerating] = useState(false);
  const [loadingLesson, setLoadingLesson] = useState(false);

  // Setup Form states
  const [durationDays, setDurationDays] = useState(30);
  const [targetScore, setTargetScore] = useState(750);
  const [examHistory, setExamHistory] = useState<any[]>([]);

  // Active Roadmap & Lessons state
  const [roadmap, setRoadmap] = useState<MasterRoadmap | null>(null);
  const [dailyLessonsCache, setDailyLessonsCache] = useState<Record<number, DayLesson>>({});
  const [dailyQuizResults, setDailyQuizResults] = useState<Record<number, any>>({});
  const [completedTaskKeys, setCompletedTaskKeys] = useState<Record<string, boolean>>({});
  const [activeDay, setActiveDay] = useState<number | null>(null);

  // Interactive Quiz state for active day
  const [userAnswers, setUserAnswers] = useState<Record<number, string>>({});
  const [submittedQuiz, setSubmittedQuiz] = useState(false);

  const gateway = import.meta.env.VITE_API_GATEWAY_URL || 'http://localhost:4000';
  const token = localStorage.getItem('toeic_jwt');

  useEffect(() => {
    // Read saved target score from localStorage
    const savedTarget = localStorage.getItem('toeic_target_score');
    if (savedTarget) setTargetScore(parseInt(savedTarget, 10));

    fetchStudentProfile();
  }, []);

  const fetchStudentProfile = async () => {
    setLoading(true);
    try {
      const res = await fetch(`${gateway}/api/exam-results/ai-profile`, {
        headers: token ? { Authorization: `Bearer ${token}` } : {}
      });
      if (res.ok) {
        const data = await res.json();
        if (data.history) setExamHistory(data.history);

        if (data.profile) {
          if (data.profile.targetScore) {
            setTargetScore(data.profile.targetScore);
            localStorage.setItem('toeic_target_score', String(data.profile.targetScore));
          }
          if (data.profile.durationDays) setDurationDays(data.profile.durationDays);
          if (data.profile.activeRoadmap) setRoadmap(data.profile.activeRoadmap);
          if (data.profile.dailyLessonsCache) setDailyLessonsCache(data.profile.dailyLessonsCache);
          if (data.profile.dailyQuizResults) setDailyQuizResults(data.profile.dailyQuizResults);
          if (data.profile.completedTaskKeys) setCompletedTaskKeys(data.profile.completedTaskKeys);
        }
      }
    } catch (err) {
      console.error('Error fetching student AI profile:', err);
    } finally {
      setLoading(false);
    }
  };

  const syncTargetScore = (newScore: number) => {
    setTargetScore(newScore);
    localStorage.setItem('toeic_target_score', String(newScore));
    window.dispatchEvent(new Event('toeic_target_score_updated'));

    // Persist to DB
    fetch(`${gateway}/api/exam-results/ai-profile`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        ...(token ? { Authorization: `Bearer ${token}` } : {})
      },
      body: JSON.stringify({ targetScore: newScore })
    }).catch(e => console.warn('Failed to sync target score to DB:', e));
  };

  const handleCreateRoadmap = async () => {
    setGenerating(true);
    try {
      let currentScore = 450;
      let listeningAvg = 240;
      let readingAvg = 210;

      if (examHistory.length > 0) {
        currentScore = Math.max(...examHistory.map(r => r.totalScore || r.total_score || 450));
        listeningAvg = Math.round(examHistory.reduce((acc, r) => acc + (r.listeningScore || r.listening_score || 240), 0) / examHistory.length);
        readingAvg = Math.round(examHistory.reduce((acc, r) => acc + (r.readingScore || r.reading_score || 210), 0) / examHistory.length);
      }

      // Step 1: Fast Master Overview Generation (< 1.5s)
      const res = await fetch(`${gateway}/api/ai/create-roadmap-overview`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          ...(token ? { Authorization: `Bearer ${token}` } : {})
        },
        body: JSON.stringify({
          currentScore,
          targetScore,
          durationDays,
          listeningAvg,
          readingAvg,
          testHistory: examHistory
        })
      });

      if (res.ok) {
        const data = await res.json();
        if (data.overview) {
          setRoadmap(data.overview);
          setCompletedTaskKeys({});
          setDailyLessonsCache({});
          setDailyQuizResults({});
          // Save active roadmap to DB & reset previous completed checkmarks
          await fetch(`${gateway}/api/exam-results/ai-profile`, {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json',
              ...(token ? { Authorization: `Bearer ${token}` } : {})
            },
            body: JSON.stringify({
              targetScore,
              durationDays,
              activeRoadmap: data.overview,
              dailyLessonsCache: {},
              dailyQuizResults: {},
              completedTaskKeys: {}
            })
          });
        }
      }
    } catch (e) {
      console.error('Create roadmap error:', e);
      alert('Không thể kết nối dịch vụ AI. Bạn vui lòng thử lại sau.');
    } finally {
      setGenerating(false);
    }
  };

  const openDayLesson = async (dayNumber: number, dayTitle: string, dayFocus: string) => {
    setActiveDay(dayNumber);
    setUserAnswers({});
    setSubmittedQuiz(false);
    window.scrollTo({ top: 0, behavior: 'smooth' });

    // If lesson already in cache, load immediately
    if (dailyLessonsCache[dayNumber]) return;

    setLoadingLesson(true);
    try {
      let currentScore = 450;
      if (examHistory.length > 0) {
        currentScore = Math.max(...examHistory.map(r => r.totalScore || r.total_score || 450));
      }

      // On-demand Lazy Generation for THAT DAY ONLY
      const res = await fetch(`${gateway}/api/ai/generate-day-lesson`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          ...(token ? { Authorization: `Bearer ${token}` } : {})
        },
        body: JSON.stringify({
          dayNumber,
          dayTitle,
          dayFocus,
          targetScore,
          currentScore,
          durationDays
        })
      });

      if (res.ok) {
        const data = await res.json();
        if (data.lesson) {
          const updatedCache = { ...dailyLessonsCache, [dayNumber]: data.lesson };
          setDailyLessonsCache(updatedCache);

          // Save cached day lesson to DB
          fetch(`${gateway}/api/exam-results/ai-profile`, {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json',
              ...(token ? { Authorization: `Bearer ${token}` } : {})
            },
            body: JSON.stringify({ dailyLessonsCache: updatedCache })
          }).catch(e => console.warn('Save day lesson cache failed:', e));
        }
      }
    } catch (e) {
      console.error('Error generating day lesson:', e);
    } finally {
      setLoadingLesson(false);
    }
  };

  const toggleTaskCompleted = (dayNum: number) => {
    const taskKey = `day_${dayNum}`;
    const updated = { ...completedTaskKeys, [taskKey]: !completedTaskKeys[taskKey] };
    setCompletedTaskKeys(updated);

    fetch(`${gateway}/api/exam-results/ai-profile`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        ...(token ? { Authorization: `Bearer ${token}` } : {})
      },
      body: JSON.stringify({ completedTaskKeys: updated })
    }).catch(e => console.warn('Save completed task failed:', e));
  };

  if (loading) {
    return (
      <div style={{ background: '#ffffff', borderRadius: '16px', padding: '30px', textAlign: 'center', border: '1px solid #e2e8f0', marginBottom: '24px' }}>
        <span style={{ fontSize: '24px' }}>⏳</span>
        <p style={{ margin: '8px 0 0 0', color: '#64748b', fontSize: '14px' }}>Đang tải dữ liệu học tập AeroAI...</p>
      </div>
    );
  }

  // ==========================================
  // STATE 1: SETUP FORM FOR NEW / UNGENERATED USERS
  // ==========================================
  if (!roadmap) {
    return (
      <div style={{
        background: 'linear-gradient(135deg, #ffffff 0%, #f0f9ff 100%)',
        borderRadius: '16px',
        padding: '28px',
        boxShadow: '0 8px 30px rgba(0,0,0,0.06)',
        border: '1.5px solid #cbd5e1',
        marginBottom: '24px',
        fontFamily: 'sans-serif'
      }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: '14px', marginBottom: '20px' }}>
          <div style={{
            width: '50px', height: '50px', borderRadius: '14px', background: 'linear-gradient(135deg, #1d4ed8, #2563eb)',
            color: '#ffffff', display: 'grid', placeItems: 'center', fontSize: '26px', boxShadow: '0 4px 14px rgba(37,99,235,0.3)'
          }}>
            🚀
          </div>
          <div>
            <h3 style={{ margin: 0, fontSize: '19px', fontWeight: 800, color: '#0f172a' }}>
              Thiết Lập Lộ Trình Học TOEIC Cá Nhân Hóa
            </h3>
            <span style={{ fontSize: '13.5px', color: '#475569' }}>
              AeroAI thu thập dữ liệu thi thử thực tế & lập lộ trình bài học 60 phút mỗi ngày cho bạn
            </span>
          </div>
        </div>

        {/* Diagnostic Metrics Display */}
        <div style={{ background: '#ffffff', borderRadius: '12px', padding: '16px 20px', border: '1px solid #e2e8f0', marginBottom: '20px' }}>
          <h4 style={{ margin: '0 0 10px 0', fontSize: '14.5px', fontWeight: 700, color: '#1e293b' }}>
            📊 Dữ liệu Lịch sử Thi thử Thu thập Được:
          </h4>
          {examHistory.length > 0 ? (
            <div style={{ display: 'flex', gap: '20px', flexWrap: 'wrap' }}>
              <div style={{ fontSize: '13.5px', color: '#334155' }}>
                • Số bài thi thử đã làm: <b>{examHistory.length} bài</b>
              </div>
              <div style={{ fontSize: '13.5px', color: '#166534' }}>
                • Điểm thi cao nhất: <b>{Math.max(...examHistory.map(r => r.totalScore || r.total_score || 0))} điểm</b>
              </div>
              <div style={{ fontSize: '13.5px', color: '#2563eb' }}>
                • Điểm thi mới nhất: <b>{examHistory[0].totalScore || examHistory[0].total_score || 0} điểm</b>
              </div>
            </div>
          ) : (
            <span style={{ fontSize: '13.5px', color: '#64748b' }}>
              Chưa có bài thi thử nào. AeroAI sẽ tính toán điểm ước tính khởi điểm là <b>450 điểm</b>.
            </span>
          )}
        </div>

        {/* Interactive Controls Grid */}
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(240px, 1fr))', gap: '20px', marginBottom: '24px' }}>
          {/* Target Score Selector */}
          <div>
            <label style={{ display: 'block', fontSize: '13.5px', fontWeight: 700, color: '#1e293b', marginBottom: '8px' }}>
              🎯 Chọn Điểm Mục Tiêu:
            </label>
            <div style={{ display: 'flex', gap: '8px' }}>
              {[550, 650, 750, 850, 950].map(sc => (
                <button
                  key={sc}
                  onClick={() => syncTargetScore(sc)}
                  style={{
                    flex: 1,
                    padding: '9px 0',
                    borderRadius: '8px',
                    border: targetScore === sc ? '2px solid #2563eb' : '1px solid #cbd5e1',
                    background: targetScore === sc ? '#eff6ff' : '#ffffff',
                    color: targetScore === sc ? '#1d4ed8' : '#475569',
                    fontWeight: 800,
                    fontSize: '13.5px',
                    cursor: 'pointer'
                  }}
                >
                  {sc}
                </button>
              ))}
            </div>
          </div>

          {/* Duration Selector */}
          <div>
            <label style={{ display: 'block', fontSize: '13.5px', fontWeight: 700, color: '#1e293b', marginBottom: '8px' }}>
              ⏱️ Chọn Thời Gian Lộ Trình:
            </label>
            <div style={{ display: 'flex', gap: '8px' }}>
              {[15, 30, 45, 60].map(d => (
                <button
                  key={d}
                  onClick={() => setDurationDays(d)}
                  style={{
                    flex: 1,
                    padding: '9px 0',
                    borderRadius: '8px',
                    border: durationDays === d ? '2px solid #2563eb' : '1px solid #cbd5e1',
                    background: durationDays === d ? '#eff6ff' : '#ffffff',
                    color: durationDays === d ? '#1d4ed8' : '#475569',
                    fontWeight: 800,
                    fontSize: '13.5px',
                    cursor: 'pointer'
                  }}
                >
                  {d} Ngày
                </button>
              ))}
            </div>
          </div>
        </div>

        {/* Generate Button */}
        <button
          onClick={handleCreateRoadmap}
          disabled={generating}
          style={{
            width: '100%',
            background: 'linear-gradient(135deg, #2563eb, #1d4ed8)',
            color: '#ffffff',
            border: 'none',
            padding: '14px',
            borderRadius: '12px',
            fontWeight: 800,
            fontSize: '15px',
            cursor: 'pointer',
            boxShadow: '0 6px 18px rgba(37,99,235,0.3)',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            gap: '10px'
          }}
        >
          <span>⚡</span> {generating ? 'AeroAI đang thu thập dữ liệu & tạo khung lộ trình...' : `Tạo Lộ Trình ${durationDays} Ngày Cho Mục Tiêu ${targetScore} Điểm →`}
        </button>
      </div>
    );
  }

  // ==========================================
  // STATE 2: ACTIVE ROADMAP VIEW FOR EXISTING USERS
  // ==========================================
  const totalDays = roadmap.totalDays || roadmap.days.length;
  const completedCount = Object.keys(completedTaskKeys).filter(k => completedTaskKeys[k]).length;
  const progressPercent = Math.min(100, Math.round((completedCount / totalDays) * 100));

  const activeLessonData = activeDay ? dailyLessonsCache[activeDay] : null;

  // If an active day is selected, render ONLY the lesson view with back button!
  if (activeDay) {
    const dayMeta = roadmap?.days?.find(d => d.dayNumber === activeDay);
    return (
      <div style={{
        background: '#ffffff',
        borderRadius: '16px',
        padding: '24px',
        boxShadow: '0 8px 30px rgba(0,0,0,0.06)',
        border: '1.5px solid #2563eb',
        marginBottom: '24px',
        fontFamily: 'sans-serif'
      }}>
        {/* Navigation bar to return to Roadmap */}
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '20px', paddingBottom: '14px', borderBottom: '1px solid #e2e8f0', flexWrap: 'wrap', gap: '12px' }}>
          <button
            onClick={() => {
              setActiveDay(null);
              window.scrollTo({ top: 0, behavior: 'smooth' });
            }}
            style={{
              background: '#eff6ff',
              color: '#2563eb',
              border: '1.5px solid #bfdbfe',
              padding: '10px 18px',
              borderRadius: '10px',
              cursor: 'pointer',
              fontWeight: 800,
              fontSize: '14px',
              display: 'flex',
              alignItems: 'center',
              gap: '8px',
              boxShadow: '0 2px 6px rgba(37,99,235,0.1)'
            }}
          >
            ← Quay lại
          </button>
          
          <div style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
            <span style={{ background: '#2563eb', color: '#fff', padding: '6px 12px', borderRadius: '8px', fontSize: '13px', fontWeight: 800 }}>
              NGÀY {activeDay} / {totalDays}
            </span>
            <span style={{ fontSize: '12px', color: '#64748b', fontWeight: 600, background: '#f8fafc', padding: '6px 12px', borderRadius: '8px', border: '1px solid #e2e8f0' }}>
              ⏱️ ~60 phút
            </span>
          </div>
        </div>

        <div style={{ marginBottom: '24px' }}>
          <h2 style={{ margin: '0 0 6px 0', fontSize: '20px', fontWeight: 800, color: '#0f172a' }}>
            {dayMeta?.title || `Bài học Ngày ${activeDay}`}
          </h2>
          <span style={{ fontSize: '13.5px', color: '#64748b', fontWeight: 500 }}>
            💡 Trọng tâm: {dayMeta?.focus}
          </span>
        </div>

        {loadingLesson ? (
          <div style={{ textAlign: 'center', padding: '40px 20px', background: '#f8fafc', borderRadius: '12px', border: '1px solid #e2e8f0' }}>
            <span style={{ fontSize: '36px' }}>⏳</span>
            <h4 style={{ margin: '14px 0 6px 0', color: '#2563eb', fontSize: '17px', fontWeight: 800 }}>
              AeroAI đang biên soạn bài tập cho Ngày {activeDay}...
            </h4>
            <p style={{ margin: 0, fontSize: '13.5px', color: '#64748b' }}>
              Đang tạo ...
            </p>
          </div>
        ) : activeLessonData ? (
          <div>
            {/* 1. VOCABULARY SECTION */}
            <div style={{ marginBottom: '24px' }}>
              <h4 style={{ margin: '0 0 12px 0', fontSize: '15.5px', fontWeight: 800, color: '#1e293b', display: 'flex', alignItems: 'center', gap: '8px' }}>
                <span>📚</span> 1. Từ Vựng ({activeLessonData.vocabularyList.length} từ):
              </h4>
              <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(260px, 1fr))', gap: '12px' }}>
                {activeLessonData.vocabularyList.map((v, vIdx) => (
                  <div key={vIdx} style={{ background: '#f8fafc', padding: '12px 14px', borderRadius: '10px', border: '1px solid #e2e8f0' }}>
                    <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '4px' }}>
                      <strong style={{ fontSize: '15px', color: '#1d4ed8' }}>{v.word}</strong>
                      <span style={{ fontSize: '12px', color: '#64748b', fontStyle: 'italic' }}>{v.partOfSpeech}</span>
                    </div>
                    <div style={{ fontSize: '12.5px', color: '#0284c7', fontWeight: 600, marginBottom: '6px' }}>{v.ipa}</div>
                    <div style={{ fontSize: '13px', fontWeight: 700, color: '#1e293b', marginBottom: '4px' }}>👉 {v.meaning}</div>
                    <div style={{ fontSize: '12px', color: '#475569', background: '#ffffff', padding: '6px 8px', borderRadius: '6px', border: '1px solid #f1f5f9' }}>
                      "{v.example}"
                    </div>
                  </div>
                ))}
              </div>
            </div>

            {/* 2. GRAMMAR SECTION */}
            <div style={{ marginBottom: '24px', background: '#f0f9ff', padding: '18px', borderRadius: '12px', border: '1px solid #bae6fd' }}>
              <h4 style={{ margin: '0 0 8px 0', fontSize: '15.5px', fontWeight: 800, color: '#0369a1', display: 'flex', alignItems: 'center', gap: '8px' }}>
                <span>🧠</span> 2. {activeLessonData.grammarRule.title}:
              </h4>
              <p style={{ margin: '0 0 10px 0', fontSize: '13.5px', color: '#1e293b', lineHeight: 1.5 }}>
                {activeLessonData.grammarRule.explanation}
              </p>
              {activeLessonData.grammarRule.formula && (
                <div style={{ background: '#ffffff', padding: '10px 14px', borderRadius: '8px', borderLeft: '4px solid #0284c7', fontWeight: 700, color: '#0369a1', fontSize: '13.5px', marginBottom: '10px' }}>
                  📌 Công thức: {activeLessonData.grammarRule.formula}
                </div>
              )}
              {activeLessonData.grammarRule.examples && (
                <div>
                  <strong style={{ fontSize: '13px', color: '#0369a1' }}>Ví dụ minh họa:</strong>
                  <ul style={{ margin: '6px 0 0 0', paddingLeft: '20px', fontSize: '13px', color: '#334155' }}>
                    {activeLessonData.grammarRule.examples.map((ex, exIdx) => (
                      <li key={exIdx} style={{ marginBottom: '4px' }}>{ex}</li>
                    ))}
                  </ul>
                </div>
              )}
            </div>

            {/* 3. ETS TIPS SECTION */}
            <div style={{ marginBottom: '24px', background: '#fefce8', padding: '14px 18px', borderRadius: '12px', border: '1px solid #fef08a' }}>
              <span style={{ fontSize: '13.5px', fontWeight: 700, color: '#a16207' }}>
                {activeLessonData.etsTips}
              </span>
            </div>

            {/* 4. INTERACTIVE QUIZ SECTION */}
            <div>
              <h4 style={{ margin: '0 0 14px 0', fontSize: '15.5px', fontWeight: 800, color: '#1e293b', display: 'flex', alignItems: 'center', gap: '8px' }}>
                <span>📝</span> 3. Bài Tập Thực Hành ({activeLessonData.practiceQuestions.length} câu):
              </h4>

              <div style={{ display: 'flex', flexDirection: 'column', gap: '16px', marginBottom: '20px' }}>
                {activeLessonData.practiceQuestions.map((q, qIdx) => {
                  const selected = userAnswers[q.id];
                  const isCorrect = selected === q.correctAnswer;

                  return (
                    <div key={q.id} style={{ background: '#ffffff', border: '1px solid #cbd5e1', borderRadius: '12px', padding: '16px' }}>
                      <div style={{ fontSize: '14px', fontWeight: 700, color: '#0f172a', marginBottom: '12px' }}>
                        Câu {qIdx + 1}: {q.questionText}
                      </div>

                      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '8px', marginBottom: '12px' }}>
                        {[
                          ['A', q.optionA],
                          ['B', q.optionB],
                          ['C', q.optionC],
                          ['D', q.optionD]
                        ].map(([key, text]) => {
                          const isThisSelected = selected === key;
                          let btnBg = '#f8fafc';
                          let btnBorder = '#cbd5e1';

                          if (submittedQuiz) {
                            if (key === q.correctAnswer) {
                              btnBg = '#dcfce7';
                              btnBorder = '#22c55e';
                            } else if (isThisSelected) {
                              btnBg = '#fee2e2';
                              btnBorder = '#ef4444';
                            }
                          } else if (isThisSelected) {
                            btnBg = '#eff6ff';
                            btnBorder = '#2563eb';
                          }

                          return (
                            <button
                              key={key}
                              disabled={submittedQuiz}
                              onClick={() => setUserAnswers({ ...userAnswers, [q.id]: key })}
                              style={{
                                textAlign: 'left',
                                padding: '10px 14px',
                                borderRadius: '8px',
                                border: `1.5px solid ${btnBorder}`,
                                background: btnBg,
                                fontSize: '13px',
                                fontWeight: isThisSelected ? 700 : 500,
                                cursor: submittedQuiz ? 'default' : 'pointer'
                              }}
                            >
                              <b>({key})</b> {text}
                            </button>
                          );
                        })}
                      </div>

                      {submittedQuiz && (
                        <div style={{ background: isCorrect ? '#f0fdf4' : '#fff1f2', padding: '10px 14px', borderRadius: '8px', border: `1px solid ${isCorrect ? '#86efac' : '#fecdd3'}`, fontSize: '13px' }}>
                          <strong style={{ color: isCorrect ? '#166534' : '#991b1b' }}>
                            {isCorrect ? '✅ Đã trả lời đúng!' : `❌ Đáp án đúng là (${q.correctAnswer})`}
                          </strong>
                          <p style={{ margin: '4px 0 0 0', color: '#334155' }}>
                            💡 Giải thích: {q.explanation}
                          </p>
                        </div>
                      )}
                    </div>
                  );
                })}
              </div>

              {!submittedQuiz ? (
                <button
                  onClick={() => {
                    setSubmittedQuiz(true);
                    if (activeDay && activeLessonData) {
                      const correctCount = activeLessonData.practiceQuestions.filter(q => userAnswers[q.id] === q.correctAnswer).length;
                      const totalCount = activeLessonData.practiceQuestions.length;
                      const quizRecord = {
                        dayNumber: activeDay,
                        score: correctCount,
                        total: totalCount,
                        submittedAt: new Date().toISOString()
                      };
                      const updatedQuiz = { ...dailyQuizResults, [activeDay]: quizRecord };
                      setDailyQuizResults(updatedQuiz);

                      fetch(`${gateway}/api/exam-results/ai-profile`, {
                        method: 'POST',
                        headers: {
                          'Content-Type': 'application/json',
                          ...(token ? { Authorization: `Bearer ${token}` } : {})
                        },
                        body: JSON.stringify({ dailyQuizResults: updatedQuiz })
                      }).catch(e => console.warn('Failed to save daily quiz performance:', e));
                    }
                  }}
                  style={{
                    background: 'linear-gradient(135deg, #16a34a, #15803d)',
                    color: '#ffffff',
                    border: 'none',
                    padding: '12px 24px',
                    borderRadius: '10px',
                    fontWeight: 800,
                    fontSize: '14px',
                    cursor: 'pointer',
                    boxShadow: '0 4px 14px rgba(22,163,74,0.3)'
                  }}
                >
                  Nộp Bài
                </button>
              ) : (
                <div style={{ display: 'flex', alignItems: 'center', gap: '14px', flexWrap: 'wrap' }}>
                  <span style={{ fontSize: '15px', fontWeight: 800, color: '#166534' }}>
                    🎉 Đã hoàn thành! Đạt {activeLessonData.practiceQuestions.filter(q => userAnswers[q.id] === q.correctAnswer).length} / {activeLessonData.practiceQuestions.length} câu đúng.
                  </span>
                  <button
                    onClick={() => {
                      toggleTaskCompleted(activeDay);
                      setActiveDay(null); // Return to roadmap after completing
                    }}
                    style={{
                      background: '#2563eb',
                      color: '#fff',
                      border: 'none',
                      padding: '10px 18px',
                      borderRadius: '8px',
                      fontWeight: 700,
                      fontSize: '13px',
                      cursor: 'pointer'
                    }}
                  >
                    ✓ Hoàn Thành 
                  </button>
                </div>
              )}
            </div>
          </div>
        ) : null}
      </div>
    );
  }

  // ==========================================
  // ROADMAP OVERVIEW & LIST OF DAYS VIEW
  // ==========================================
  return (
    <div style={{
      background: '#ffffff',
      borderRadius: '16px',
      padding: '24px',
      boxShadow: '0 8px 30px rgba(0,0,0,0.06)',
      border: '1px solid #e2e8f0',
      marginBottom: '24px',
      fontFamily: 'sans-serif'
    }}>
      {/* Roadmap Header */}
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', flexWrap: 'wrap', gap: '16px', marginBottom: '20px' }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
          <div style={{
            width: '46px', height: '46px', borderRadius: '12px', background: 'linear-gradient(135deg, #1d4ed8, #2563eb)',
            color: '#ffffff', display: 'grid', placeItems: 'center', fontSize: '24px', boxShadow: '0 4px 12px rgba(37,99,235,0.3)'
          }}>
            🚀
          </div>
          <div>
            <h3 style={{ margin: 0, fontSize: '18px', fontWeight: 800, color: '#0f172a' }}>
              Lộ Trình Học TOEIC {roadmap.totalDays} Ngày
            </h3>
            <span style={{ fontSize: '13px', color: '#64748b', fontWeight: 500 }}>
              Mục tiêu: <b>{targetScore} điểm</b>
            </span>
          </div>
        </div>

        <button
          onClick={() => {
            setRoadmap(null);
            setCompletedTaskKeys({});
            setDailyLessonsCache({});
            setDailyQuizResults({});
          }}
          style={{
            background: '#ffffff',
            color: '#2563eb',
            border: '1.5px solid #2563eb',
            padding: '8px 16px',
            borderRadius: '10px',
            fontWeight: 700,
            fontSize: '13px',
            cursor: 'pointer'
          }}
        >
          🔄 Đổi Mục Tiêu / Số Ngày
        </button>
      </div>

      {/* Progress Bar */}
      <div style={{ background: '#f8fafc', padding: '16px', borderRadius: '12px', border: '1px solid #f1f5f9', marginBottom: '20px' }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '8px', fontSize: '13.5px', fontWeight: 700, color: '#334155' }}>
          <span>🎯 Tiến độ hoàn thành: {completedCount} / {totalDays} ngày ({progressPercent}%)</span>
          <span style={{ color: '#2563eb' }}>{progressPercent >= 100 ? '🎉 HOÀN THÀNH LỘ TRÌNH!' : `Còn ${totalDays - completedCount} ngày`}</span>
        </div>
        <div style={{ width: '100%', height: '10px', background: '#e2e8f0', borderRadius: '6px', overflow: 'hidden' }}>
          <div style={{ width: `${progressPercent}%`, height: '100%', background: 'linear-gradient(90deg, #3b82f6, #1d4ed8)', borderRadius: '6px', transition: 'width 0.4s' }} />
        </div>
      </div>

      {/* AI Diagnostic Summary Box */}
      <div style={{ background: '#eff6ff', border: '1.5px solid #bfdbfe', padding: '16px 20px', borderRadius: '12px', marginBottom: '24px' }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: '8px', marginBottom: '6px' }}>
          <span style={{ fontSize: '18px' }}>🤖</span>
          <strong style={{ color: '#1e40af', fontSize: '14.5px' }}>Chẩn đoán từ AeroAI Tutor:</strong>
        </div>
        <p style={{ margin: '0 0 10px 0', fontSize: '13.5px', color: '#1e293b', lineHeight: 1.5 }}>
          {roadmap.diagnosticSummary}
        </p>

        {roadmap.weakPoints && (
          <div style={{ display: 'flex', flexWrap: 'wrap', gap: '8px', alignItems: 'center' }}>
            <span style={{ fontSize: '12px', fontWeight: 700, color: '#1e3a8a' }}>⚠️ Dạng bài cần khắc phục:</span>
            {roadmap.weakPoints.map((wp, idx) => (
              <span key={idx} style={{ background: '#ffffff', border: '1px solid #93c5fd', color: '#1d4ed8', padding: '3px 10px', borderRadius: '12px', fontSize: '12px', fontWeight: 600 }}>
                {wp}
              </span>
            ))}
          </div>
        )}
      </div>

      {/* Days Schedule Grid */}
      <h4 style={{ margin: '0 0 14px 0', fontSize: '16px', fontWeight: 800, color: '#0f172a' }}>
        📅 Danh Sách Ngày Học:
      </h4>

      <div style={{ display: 'flex', flexDirection: 'column', gap: '10px', marginBottom: '24px' }}>
        {roadmap.days.map(d => {
          const isDone = Boolean(completedTaskKeys[`day_${d.dayNumber}`]);

          return (
            <div
              key={d.dayNumber}
              onClick={() => openDayLesson(d.dayNumber, d.title, d.focus)}
              style={{
                background: isDone ? '#f0fdf4' : '#ffffff',
                border: isDone ? '1.5px solid #86efac' : '1px solid #e2e8f0',
                borderRadius: '12px',
                padding: '14px 20px',
                cursor: 'pointer',
                transition: 'all 0.15s ease-in-out',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'space-between',
                gap: '16px',
                boxShadow: '0 1px 3px rgba(0,0,0,0.02)'
              }}
            >
              <div style={{ display: 'flex', alignItems: 'center', gap: '14px', flex: 1 }}>
                <input
                  type="checkbox"
                  checked={isDone}
                  onChange={(e) => {
                    e.stopPropagation();
                    toggleTaskCompleted(d.dayNumber);
                  }}
                  style={{ width: '20px', height: '20px', accentColor: '#16a34a', cursor: 'pointer', flexShrink: 0 }}
                />

                <span style={{
                  background: isDone ? '#16a34a' : '#f1f5f9',
                  color: isDone ? '#ffffff' : '#334155',
                  padding: '4px 10px',
                  borderRadius: '8px',
                  fontSize: '12px',
                  fontWeight: 800,
                  whiteSpace: 'nowrap',
                  flexShrink: 0
                }}>
                  NGÀY {d.dayNumber}
                </span>

                <div style={{ flex: 1, minWidth: 0 }}>
                  <h5 style={{ margin: '0 0 2px 0', fontSize: '14px', fontWeight: 700, color: '#0f172a', whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>
                    {d.title}
                  </h5>
                  <span style={{ fontSize: '12.5px', color: '#64748b', whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis', display: 'block' }}>
                    💡 {d.focus}
                  </span>
                </div>
              </div>

              <div style={{ display: 'flex', alignItems: 'center', gap: '14px', flexShrink: 0 }}>
                <span style={{ fontSize: '12px', color: '#64748b', fontWeight: 600, background: '#f8fafc', padding: '4px 10px', borderRadius: '6px', border: '1px solid #e2e8f0' }}>
                  ⏱️ ~60 phút
                </span>
                <span style={{ fontSize: '13px', color: '#2563eb', fontWeight: 700 }}>
                  Vào học →
                </span>
              </div>
            </div>
          );
        })}
      </div>
    </div>
  );
}

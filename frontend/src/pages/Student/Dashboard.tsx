import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { Shell, Button, Stat, Progress } from '../../components/UI';
import { useAuth } from '../../context/AuthContext';
import AIRoadmapWidget from '../../components/AIRoadmapWidget';
import { getApiGatewayUrl } from '../../config/api';

export default function Dashboard() {
  const navigate = useNavigate();
  const { user, token } = useAuth();
  
  const [targetScore, setTargetScoreState] = useState(Number(localStorage.getItem('toeic_target_score')) || 750);

  const [stats, setStats] = useState({
    totalTests: 0,
    highestScore: 450,
    latestScore: 450,
    listeningAccuracy: 60,
    readingAccuracy: 55,
    targetScore: targetScore,
    streakDays: 1
  });

  const getCalculatedStreak = (userEmail?: string): number => {
    const emailKey = userEmail ? `_${userEmail}` : '';
    const dateKey = `toeic_streak_last_date${emailKey}`;
    const countKey = `toeic_streak_count${emailKey}`;

    const todayStr = new Date().toISOString().slice(0, 10);
    const lastDateStr = localStorage.getItem(dateKey);
    const savedStreak = Number(localStorage.getItem(countKey)) || 0;

    if (!lastDateStr) {
      localStorage.setItem(dateKey, todayStr);
      localStorage.setItem(countKey, '1');
      return 1;
    }

    if (lastDateStr === todayStr) {
      return Math.max(1, savedStreak);
    }

    const lastDate = new Date(lastDateStr);
    const today = new Date(todayStr);
    const diffTime = today.getTime() - lastDate.getTime();
    const diffDays = Math.round(diffTime / (1000 * 3600 * 24));

    if (diffDays === 1) {
      const newStreak = savedStreak + 1;
      localStorage.setItem(dateKey, todayStr);
      localStorage.setItem(countKey, String(newStreak));
      return newStreak;
    } else if (diffDays > 1) {
      localStorage.setItem(dateKey, todayStr);
      localStorage.setItem(countKey, '1');
      return 1;
    }

    return Math.max(1, savedStreak);
  };

  useEffect(() => {
    const handleScoreSync = () => {
      const updatedScore = Number(localStorage.getItem('toeic_target_score')) || 750;
      setTargetScoreState(updatedScore);
      setStats(prev => ({ ...prev, targetScore: updatedScore }));
    };
    window.addEventListener('toeic_target_score_updated', handleScoreSync);
    return () => window.removeEventListener('toeic_target_score_updated', handleScoreSync);
  }, []);

  useEffect(() => {
    const calculatedStreak = getCalculatedStreak(user?.email);

    if (!token) {
      setStats(prev => ({ ...prev, streakDays: calculatedStreak }));
      return;
    }

    const gateway = getApiGatewayUrl();
    fetch(`${gateway}/api/exam-results/analytics/me`, {
      headers: { Authorization: `Bearer ${token}` }
    })
      .then(res => res.ok ? res.json() : null)
      .then(data => {
        const currentTarget = Number(localStorage.getItem('toeic_target_score')) || 750;
        if (data) {
          setStats({
            totalTests: data.totalTests || 0,
            highestScore: data.highestScore || (data.results && data.results.length ? Math.max(...data.results.map((r: any) => r.totalScore ?? r.total_score ?? 0)) : 450),
            latestScore: data.latestScore || 450,
            listeningAccuracy: data.listeningAccuracy || 60,
            readingAccuracy: data.readingAccuracy || 55,
            targetScore: currentTarget,
            streakDays: calculatedStreak
          });
        } else {
          setStats(prev => ({ ...prev, streakDays: calculatedStreak, targetScore: currentTarget }));
        }
      })
      .catch(err => {
        console.error('Failed to load dashboard analytics:', err);
        setStats(prev => ({ ...prev, streakDays: calculatedStreak }));
      });
  }, [token, targetScore, user]);

  const currentScore = stats.totalTests > 0 ? stats.highestScore : 450;
  const progressPercent = Math.min(100, Math.round((currentScore / stats.targetScore) * 100));

  // Dynamic greeting based on current local time
  const hour = new Date().getHours();
  const greeting = hour < 12 ? 'Chào buổi sáng' : hour < 18 ? 'Chào buổi chiều' : 'Chào buổi tối';

  // Dynamic AI lesson recommendation based on student accuracy
  const weakSkill = stats.listeningAccuracy < stats.readingAccuracy ? 'Listening' : 'Reading';
  const recTitle = weakSkill === 'Listening' ? 'Listening Part 3 & 4' : 'Reading Part 5 & 7';
  const recDesc = weakSkill === 'Listening'
    ? 'Tập trung luyện nghe hội thoại và bài nói ngắn để nâng phản xạ từ vựng.'
    : 'Củng cố ngữ pháp điền câu ngắn Part 5 và kỹ năng đọc nhanh Part 7.';

  const [activeLessonDay, setActiveLessonDay] = useState<number | null>(null);

  return (
    <Shell page="/student">
      <div className="content">
        {!activeLessonDay && (
          <>
            <div className="page-title">
              <div>
                <span className="eyebrow">HÔM NAY</span>
                <h1>{greeting}, {user?.name || 'Học viên'}! <span>👋</span></h1>
                <p>Hôm nay là một ngày tuyệt vời để tiến gần hơn tới mục tiêu TOEIC của bạn.</p>
              </div>
              <Button onClick={() => navigate('/student/tests')}>Bắt đầu luyện tập →</Button>
            </div>
            
            <section className="stats">
              <Stat icon="◫" label="Mục tiêu TOEIC" value={`${stats.targetScore}`} note={stats.totalTests > 0 ? `Tiến độ ${progressPercent}%` : 'Đã thiết lập'} />
              <Stat icon="◔" label="Dự báo hiện tại" value={`${currentScore}`} note={stats.totalTests > 0 ? `Đã hoàn thành ${stats.totalTests} bài thi` : 'Chưa thi bài nào'} tone="green" />
              <Stat icon="🔥" label="Chuỗi ngày học" value={`${stats.streakDays} ngày`}  />
            </section>

            {/* AI Recommendation Banner */}
            <section className="card recommendation" style={{ marginBottom: 20 }}>
              <span className="spark">💡</span>
              <div>
                <h3>Gợi ý tập trung hôm nay: {recTitle}</h3>
                <p>{recDesc}</p>
                <Progress value={progressPercent} color="blue" />
              </div>
            </section>
          </>
        )}
        
        <AIRoadmapWidget onActiveDayChange={setActiveLessonDay} />
      </div>
    </Shell>
  );
}

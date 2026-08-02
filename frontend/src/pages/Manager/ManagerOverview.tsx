import { useState, useEffect } from 'react';
import { Stat } from '../../components/UI';
import { useAuth } from '../../context/AuthContext';
import { getApiGatewayUrl } from '../../config/api';

export default function ManagerOverview() {
  const { token } = useAuth();
  const [summary, setSummary] = useState({ totalAttempts: 0, avgScore: 0, studentsCount: 0 });
  const [rankings, setRankings] = useState<any[]>([]);
  const [activities, setActivities] = useState<any[]>([]);

  useEffect(() => {
    if (!token) return;
    const gateway = getApiGatewayUrl();

    Promise.all([
      fetch(`${gateway}/api/admin/users`, { headers: { Authorization: `Bearer ${token}` } }).then(r => r.ok ? r.json() : null),
      fetch(`${gateway}/api/exam-results/analytics/tenant-summary`, { headers: { Authorization: `Bearer ${token}` } }).then(r => r.ok ? r.json() : null)
    ])
      .then(([userData, summaryData]) => {
        const users = userData?.users?.filter((u: any) => u.role === 'STUDENT') || [];
        const studentStats = summaryData?.studentStats || [];
        const recent = summaryData?.recentActivities || [];

        const userLookup: Record<string, any> = {};
        users.forEach((u: any) => { userLookup[u.id] = u; });

        const rankList = users.map((u: any) => {
          const stat = studentStats.find((s: any) => s.userId === u.id);
          return {
            id: u.id,
            name: u.name || u.email,
            email: u.email,
            avatar: (u.name || u.email).substring(0, 2).toUpperCase(),
            score: stat ? stat.highestScore : 0,
            done: stat ? stat.done : 0,
            hasAttempt: Boolean(stat)
          };
        });

        rankList.sort((a: any, b: any) => b.score - a.score);
        setRankings(rankList);

        const formattedActivities = recent.slice(0, 5).map((act: any) => {
          const student = userLookup[act.userId];
          const studentName = student ? (student.name || student.email) : 'Học viên';
          const timeAgo = act.submittedAt ? new Date(act.submittedAt).toLocaleDateString('vi-VN') : 'Gần đây';
          return {
            id: act.id,
            text: `${studentName} hoàn thành bài thi ${act.examCode} — ${act.totalScore} điểm`,
            time: timeAgo
          };
        });
        setActivities(formattedActivities);

        setSummary({
          totalAttempts: summaryData?.totalAttempts || 0,
          avgScore: summaryData?.avgScore || 0,
          studentsCount: users.length
        });
      })
      .catch(err => console.error('Error loading manager overview:', err));
  }, [token]);

  return (
    <>
      <section className="stats">
        <Stat icon="♙" label="Học viên thuộc trung tâm" value={`${summary.studentsCount}`} />
        <Stat icon="◫" label="Tổng lượt làm bài" value={`${summary.totalAttempts}`} tone="green" />
        <Stat icon="◔" label="Điểm trung bình lớp" value={summary.avgScore > 0 ? `${summary.avgScore}` : '--'} tone="orange" />
      </section>

      <section className="dashboard-grid">
        <article className="card wide">
          <div className="card-heading">
            <h2>Bảng xếp hạng học viên trung tâm</h2>
          </div>
          <table>
            <thead>
              <tr>
                <th>#</th>
                <th>HỌC VIÊN</th>
                <th>ĐIỂM CAO NHẤT</th>
                <th>SỐ BÀI ĐÃ THI</th>
                <th>TRẠNG THÁI</th>
              </tr>
            </thead>
            <tbody>
              {rankings.length > 0 ? rankings.map((s, i) => (
                <tr key={s.id || s.email}>
                  <td style={{ fontWeight: 800, color: i < 3 && s.hasAttempt ? '#f59e0b' : 'var(--text-muted)' }}>
                    {i === 0 && s.hasAttempt ? '🥇' : i === 1 && s.hasAttempt ? '🥈' : i === 2 && s.hasAttempt ? '🥉' : `#${i + 1}`}
                  </td>
                  <td>
                    <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
                      <span style={{ width: 34, height: 34, borderRadius: '50%', background: 'linear-gradient(135deg,#6366f1,#2563eb)', color: '#fff', display: 'grid', placeItems: 'center', fontSize: 12, fontWeight: 800, flexShrink: 0 }}>
                        {s.avatar}
                      </span>
                      <div>
                        <div style={{ fontWeight: 600 }}>{s.name}</div>
                        <div style={{ fontSize: 12, color: 'var(--text-muted)' }}>{s.email}</div>
                      </div>
                    </div>
                  </td>
                  <td>
                    <strong style={{ color: s.hasAttempt ? '#2563eb' : 'var(--text-muted)', fontSize: 15 }}>
                      {s.hasAttempt ? s.score : 'Chưa thi'}
                    </strong>
                  </td>
                  <td>{s.done} bài</td>
                  <td>
                    <span className="badge" style={{ background: '#dcfce7', color: '#166534', padding: '3px 10px', borderRadius: 6, fontSize: 11, fontWeight: 700 }}>
                      Hoạt động
                    </span>
                  </td>
                </tr>
              )) : (
                <tr>
                  <td colSpan={5} style={{ textAlign: 'center', color: 'var(--text-muted)', padding: '24px' }}>
                    Chưa có học viên nào trong trung tâm
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        </article>

        <article className="card">
          <h2>Hoạt động gần đây</h2>
          {activities.length > 0 ? activities.map((a) => (
            <div className="activity" key={a.id || a.text}>
              <i>◔</i>
              <p>{a.text}<small>{a.time}</small></p>
            </div>
          )) : (
            <div style={{ color: 'var(--text-muted)', fontSize: 13, padding: '16px 0' }}>
              Chưa có lượt làm bài thi mới từ học viên
            </div>
          )}
        </article>
      </section>
    </>
  );
}

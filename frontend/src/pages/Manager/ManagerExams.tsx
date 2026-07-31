import { useState, useEffect } from 'react';
import { Button } from '../../components/UI';
import { useAuth } from '../../context/AuthContext';

export default function ManagerExams() {
  const { token } = useAuth();
  const [exams, setExams] = useState<any[]>([]);
  const [search, setSearch] = useState('');
  const [loading, setLoading] = useState(true);

  // Modal 1: Basic Create / Edit Exam
  const [showBasicModal, setShowBasicModal] = useState(false);
  const [editingExam, setEditingExam] = useState<any | null>(null);
  const [code, setCode] = useState('');
  const [title, setTitle] = useState('');
  const [description, setDescription] = useState('');
  const [durationMinutes, setDurationMinutes] = useState(120);
  const [status, setStatus] = useState<'PUBLISHED' | 'DRAFT'>('PUBLISHED');
  const [basicMsg, setBasicMsg] = useState('');
  const [savingBasic, setSavingBasic] = useState(false);

  // Modal 2: Import Exam from cURL / JSON
  const [showImportModal, setShowImportModal] = useState(false);
  const [curlInput, setCurlInput] = useState('');
  const [importExamCode, setImportExamCode] = useState('ets-2024-test01');
  const [importExamTitle, setImportExamTitle] = useState('ETS 2024 Test 01');
  const [importMsg, setImportMsg] = useState('');
  const [importing, setImporting] = useState(false);

  // Modal 3: Detailed 200 Question Editor (Part 1-7)
  const [showQuestionModal, setShowQuestionModal] = useState(false);
  const [activeExamCode, setActiveExamCode] = useState('');
  const [questions, setQuestions] = useState<any[]>([]);
  const [activePart, setActivePart] = useState<number>(1);
  const [selectedQNum, setSelectedQNum] = useState<number>(1);
  const [loadingQuestions, setLoadingQuestions] = useState(false);
  const [qMsg, setQMsg] = useState('');
  const [savingQ, setSavingQ] = useState(false);

  // Question Form State
  const [qText, setQText] = useState('');
  const [opA, setOpA] = useState('');
  const [opB, setOpB] = useState('');
  const [opC, setOpC] = useState('');
  const [opD, setOpD] = useState('');
  const [ans, setAns] = useState('A');
  const [expVi, setExpVi] = useState('');
  const [audioUrl, setAudioUrl] = useState('');
  const [imageUrl, setImageUrl] = useState('');
  const [passageText, setPassageText] = useState('');

  const gateway = import.meta.env.VITE_API_GATEWAY_URL || 'http://localhost:4000';

  const fetchExams = async () => {
    setLoading(true);
    try {
      const res = await fetch(`${gateway}/api/admin/exams`, {
        headers: token ? { Authorization: `Bearer ${token}` } : {}
      });
      if (res.ok) {
        const data = await res.json();
        setExams(data.exams || []);
      } else {
        const res2 = await fetch(`${gateway}/api/exams`);
        if (res2.ok) {
          const data2 = await res2.json();
          setExams(data2.exams || []);
        }
      }
    } catch (err) {
      console.error('Failed to load exams:', err);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchExams();
  }, [token]);

  // Open Basic Modal
  const handleOpenCreate = () => {
    setEditingExam(null);
    setCode(`ets-2024-test${String(exams.length + 1).padStart(2, '0')}`);
    setTitle(`ETS 2024 Test ${String(exams.length + 1).padStart(2, '0')}`);
    setDescription('Đề thi thử chuẩn cấu trúc TOEIC ETS 2024');
    setDurationMinutes(120);
    setStatus('PUBLISHED');
    setBasicMsg('');
    setShowBasicModal(true);
  };

  const handleOpenEditBasic = (exam: any) => {
    setEditingExam(exam);
    setCode(exam.code);
    setTitle(exam.title);
    setDescription(exam.description || '');
    setDurationMinutes(exam.durationMinutes || exam.duration_minutes || 120);
    setStatus(exam.status || 'PUBLISHED');
    setBasicMsg('');
    setShowBasicModal(true);
  };

  const handleSaveBasicExam = async (e: React.FormEvent) => {
    e.preventDefault();
    setSavingBasic(true);
    setBasicMsg('');
    try {
      const res = await fetch(`${gateway}/api/admin/exams`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${token}`
        },
        body: JSON.stringify({
          code: code.trim().toLowerCase(),
          title: title.trim(),
          description,
          durationMinutes: Number(durationMinutes),
          status
        })
      });

      const data = await res.json();
      if (!res.ok) throw new Error(data.error || 'Lưu đề thi thất bại');

      setBasicMsg('✅ Đã lưu thông tin đề thi thành công vào CSDL!');
      setTimeout(() => {
        setShowBasicModal(false);
        fetchExams();
      }, 1000);
    } catch (err: any) {
      setBasicMsg(`❌ Lỗi: ${err.message}`);
    } finally {
      setSavingBasic(false);
    }
  };

  // Open cURL Importer Modal
  const handleOpenImport = () => {
    setCurlInput('');
    setImportExamCode(`ets-imported-test${exams.length + 1}`);
    setImportExamTitle(`TOEIC Imported Test ${exams.length + 1}`);
    setImportMsg('');
    setShowImportModal(true);
  };

  const handleRunImport = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!curlInput.trim()) return setImportMsg('❌ Vui lòng dán lệnh cURL vào khung bên dưới');

    setImporting(true);
    setImportMsg('⏳ Đang phân tích lệnh cURL và tải 200 câu hỏi từ API...');

    try {
      const res = await fetch(`${gateway}/api/admin/exams/import-curl`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${token}`
        },
        body: JSON.stringify({
          curlInput,
          targetExamCode: importExamCode.trim().toLowerCase(),
          targetExamTitle: importExamTitle.trim()
        })
      });

      const data = await res.json();
      if (!res.ok) throw new Error(data.error || 'Nhập cURL thất bại');

      // Also ensure catalog record exists
      await fetch(`${gateway}/api/admin/exams`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${token}`
        },
        body: JSON.stringify({
          code: importExamCode.trim().toLowerCase(),
          title: importExamTitle.trim(),
          description: 'Đề thi nhập tự động từ Supabase/cURL',
          durationMinutes: 120,
          status: 'PUBLISHED'
        })
      });

      setImportMsg(`🎉 ${data.message}`);
      setTimeout(() => {
        setShowImportModal(false);
        fetchExams();
      }, 1500);
    } catch (err: any) {
      setImportMsg(`❌ Lỗi: ${err.message}`);
    } finally {
      setImporting(false);
    }
  };

  // Open Question Editor Modal
  const handleOpenQuestionEditor = async (examCode: string) => {
    setActiveExamCode(examCode);
    setShowQuestionModal(true);
    setLoadingQuestions(true);
    setActivePart(1);
    setQMsg('');

    try {
      const res = await fetch(`${gateway}/api/admin/exams/${examCode}/questions`, {
        headers: token ? { Authorization: `Bearer ${token}` } : {}
      });
      if (res.ok) {
        const data = await res.json();
        const list = data.questions || [];
        setQuestions(list);
        if (list.length > 0) {
          loadQuestionIntoForm(list[0]);
        }
      }
    } catch (err) {
      console.error('Error loading questions:', err);
    } finally {
      setLoadingQuestions(false);
    }
  };

  const loadQuestionIntoForm = (q: any) => {
    setSelectedQNum(q.questionNumber);
    setQText(q.questionText || '');
    setOpA(q.optionA || '');
    setOpB(q.optionB || '');
    setOpC(q.optionC || '');
    setOpD(q.optionD || '');
    setAns(q.correctAnswer || 'A');
    setExpVi(q.explanationVi || '');
    setAudioUrl(q.audioUrl || '');
    setImageUrl(q.imageUrl || '');
    setPassageText(q.passageText || '');
  };

  const handleSelectQuestionNum = (qNum: number) => {
    setSelectedQNum(qNum);
    const q = questions.find(item => item.questionNumber === qNum);
    if (q) {
      loadQuestionIntoForm(q);
    } else {
      // Empty question state
      setQText(''); setOpA(''); setOpB(''); setOpC(''); setOpD(''); setAns('A');
      setExpVi(''); setAudioUrl(''); setImageUrl(''); setPassageText('');
    }
  };

  const handleSaveCurrentQuestion = async (e: React.FormEvent) => {
    e.preventDefault();
    setSavingQ(true);
    setQMsg('');
    try {
      const res = await fetch(`${gateway}/api/admin/exams/${activeExamCode}/questions/${selectedQNum}`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${token}`
        },
        body: JSON.stringify({
          questionNumber: selectedQNum,
          part: activePart,
          questionText: qText,
          optionA: opA,
          optionB: opB,
          optionC: opC,
          optionD: opD,
          correctAnswer: ans,
          explanationVi: expVi,
          audioUrl,
          imageUrl,
          passageText
        })
      });

      const data = await res.json();
      if (!res.ok) throw new Error(data.error || 'Lỗi lưu câu hỏi');

      setQMsg(`✅ Đã lưu thành công Câu ${selectedQNum}!`);
      // Update local state
      setQuestions(prev => {
        const idx = prev.findIndex(item => item.questionNumber === selectedQNum);
        const newObj = {
          ...data.question,
          questionNumber: selectedQNum,
          part: activePart,
          questionText: qText, optionA: opA, optionB: opB, optionC: opC, optionD: opD,
          correctAnswer: ans, explanationVi: expVi, audioUrl, imageUrl, passageText
        };
        if (idx >= 0) {
          const updated = [...prev];
          updated[idx] = newObj;
          return updated;
        }
        return [...prev, newObj];
      });

      setTimeout(() => setQMsg(''), 2000);
    } catch (err: any) {
      setQMsg(`❌ Lỗi: ${err.message}`);
    } finally {
      setSavingQ(false);
    }
  };

  const handleDeleteExam = async (examCode: string) => {
    if (!window.confirm(`Bạn có chắc chắn muốn xóa đề thi ${examCode}?`)) return;
    try {
      const res = await fetch(`${gateway}/api/admin/exams/${examCode}`, {
        method: 'DELETE',
        headers: { Authorization: `Bearer ${token}` }
      });
      if (res.ok) {
        fetchExams();
      } else {
        alert('Không thể xóa đề thi này.');
      }
    } catch (err) {
      console.error('Delete exam error:', err);
    }
  };

  const filteredExams = exams.filter(e =>
    (e.title || '').toLowerCase().includes(search.toLowerCase()) ||
    (e.code || '').toLowerCase().includes(search.toLowerCase())
  );

  const currentPartQuestions = questions.filter(q => q.part === activePart);

  return (
    <section className="card table-card">
      <div className="card-heading" style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', flexWrap: 'wrap', gap: 12 }}>
        <div style={{ marginTop: '16px', marginLeft: '16px' }}>

          <span style={{ fontSize: 13, color: 'var(--text-muted)' }}>Tổng số: <b>{filteredExams.length} đề thi</b></span>
        </div>
        <div style={{ display: 'flex', gap: 10, marginRight: '16px', marginTop: '16px' }}>
          <button
            onClick={handleOpenImport}
            style={{
              padding: '9px 18px', borderRadius: 8, background: '#2563eb', color: '#ffffff',
              fontWeight: 700, border: 'none', cursor: 'pointer', fontSize: 13, display: 'flex', alignItems: 'center', gap: 6,
              boxShadow: '0 4px 12px rgba(37,99,235,0.3)'
            }}
          >
            📥 Nhập Đề Bằng cURL / JSON
          </button>
        </div>
      </div>

      <div className="table-tools">
        <input
          placeholder="⌕ Tìm theo tên đề hoặc mã đề..."
          value={search}
          onChange={e => setSearch(e.target.value)}
        />
      </div>

      <table>
        <thead>
          <tr>
            <th>MÃ ĐỀ THI</th>
            <th>TÊN ĐỀ THI</th>
            <th>THỜI GIAN</th>
            <th>SỐ CÂU HỎI</th>
            <th>TRẠNG THÁI</th>
            <th>THAO TÁC</th>
          </tr>
        </thead>
        <tbody>
          {loading ? (
            <tr>
              <td colSpan={6} style={{ textAlign: 'center', padding: '24px', color: 'var(--text-muted)' }}>
                Đang tải danh sách đề thi...
              </td>
            </tr>
          ) : filteredExams.length > 0 ? (
            filteredExams.map(e => (
              <tr key={e.code}>
                <td>
                  <strong style={{ color: '#2563eb', fontFamily: 'monospace' }}>{e.code}</strong>
                </td>
                <td>
                  <div style={{ fontWeight: 600 }}>{e.title}</div>
                  {e.description && <div style={{ fontSize: 12, color: 'var(--text-muted)' }}>{e.description}</div>}
                </td>
                <td>{e.durationMinutes || e.duration_minutes || 120} phút</td>
                <td>{e.question_count || 200} câu</td>
                <td>
                  <span className="badge" style={{
                    background: e.status === 'DRAFT' ? '#fef3c7' : '#dcfce7',
                    color: e.status === 'DRAFT' ? '#92400e' : '#166534',
                    padding: '3px 10px', borderRadius: 6, fontSize: 11, fontWeight: 700
                  }}>
                    {e.status === 'DRAFT' ? 'Bản nháp' : 'Xuất bản'}
                  </span>
                </td>
                <td>
                  <div style={{ display: 'flex', gap: 6, flexWrap: 'wrap' }}>
                    <button
                      onClick={() => handleOpenQuestionEditor(e.code)}
                      style={{ background: '#e0e7ff', color: '#3730a3', border: 'none', borderRadius: 6, padding: '4px 10px', cursor: 'pointer', fontSize: 12, fontWeight: 700 }}
                    >
                      📝 Sửa 200 câu
                    </button>
                    <button
                      onClick={() => handleOpenEditBasic(e)}
                      style={{ background: 'none', border: '1px solid var(--border)', borderRadius: 6, padding: '4px 10px', cursor: 'pointer', fontSize: 12, fontWeight: 600 }}
                    >
                      ✏️ Tên/Mô tả
                    </button>
                    <button
                      onClick={() => handleDeleteExam(e.code)}
                      style={{ background: 'none', border: '1px solid #fca5a5', color: '#dc2626', borderRadius: 6, padding: '4px 10px', cursor: 'pointer', fontSize: 12, fontWeight: 600 }}
                    >
                      🗑️ Xóa
                    </button>
                  </div>
                </td>
              </tr>
            ))
          ) : (
            <tr>
              <td colSpan={6} style={{ textAlign: 'center', padding: '24px', color: 'var(--text-muted)' }}>
                Không tìm thấy đề thi nào
              </td>
            </tr>
          )}
        </tbody>
      </table>

      {/* MODAL 1: CREATE / EDIT BASIC EXAM INFO */}
      {showBasicModal && (
        <div style={{ position: 'fixed', top: 0, left: 0, right: 0, bottom: 0, background: 'rgba(0,0,0,0.5)', display: 'grid', placeItems: 'center', zIndex: 1000, padding: '20px' }}>
          <div style={{ background: '#ffffff', borderRadius: '14px', width: '100%', maxWidth: '540px', padding: '24px', boxShadow: '0 20px 40px rgba(0,0,0,0.2)' }}>
            <h3 style={{ margin: '0 0 16px 0', fontSize: '18px', fontWeight: 800, color: '#0f172a' }}>
              {editingExam ? `Chỉnh Sửa Thông Tin Đề: ${editingExam.code}` : 'Tạo Đề Thi Mới'}
            </h3>

            <form onSubmit={handleSaveBasicExam} style={{ display: 'flex', flexDirection: 'column', gap: '14px' }}>
              <label style={{ display: 'flex', flexDirection: 'column', gap: 4, fontSize: 13, fontWeight: 700, color: '#334155' }}>
                Mã Đề Thi (Code)
                <input value={code} onChange={e => setCode(e.target.value)} placeholder="ets-2024-test06" disabled={Boolean(editingExam)} required style={{ padding: '9px 12px', borderRadius: 8, border: '1px solid #cbd5e1', fontSize: 14 }} />
              </label>

              <label style={{ display: 'flex', flexDirection: 'column', gap: 4, fontSize: 13, fontWeight: 700, color: '#334155' }}>
                Tên Đề Thi
                <input value={title} onChange={e => setTitle(e.target.value)} placeholder="ETS 2024 Test 06" required style={{ padding: '9px 12px', borderRadius: 8, border: '1px solid #cbd5e1', fontSize: 14 }} />
              </label>

              <label style={{ display: 'flex', flexDirection: 'column', gap: 4, fontSize: 13, fontWeight: 700, color: '#334155' }}>
                Mô tả đề thi
                <textarea value={description} onChange={e => setDescription(e.target.value)} rows={2} placeholder="Mô tả..." style={{ padding: '9px 12px', borderRadius: 8, border: '1px solid #cbd5e1', fontSize: 14 }} />
              </label>

              <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '12px' }}>
                <label style={{ display: 'flex', flexDirection: 'column', gap: 4, fontSize: 13, fontWeight: 700, color: '#334155' }}>
                  Thời gian làm bài (Phút)
                  <input type="number" value={durationMinutes} onChange={e => setDurationMinutes(Number(e.target.value))} required min={5} max={180} style={{ padding: '9px 12px', borderRadius: 8, border: '1px solid #cbd5e1', fontSize: 14 }} />
                </label>

                <label style={{ display: 'flex', flexDirection: 'column', gap: 4, fontSize: 13, fontWeight: 700, color: '#334155' }}>
                  Trạng thái
                  <select value={status} onChange={e => setStatus(e.target.value as any)} style={{ padding: '9px 12px', borderRadius: 8, border: '1px solid #cbd5e1', fontSize: 14 }}>
                    <option value="PUBLISHED">Xuất bản (PUBLISHED)</option>
                    <option value="DRAFT">Bản nháp (DRAFT)</option>
                  </select>
                </label>
              </div>

              {basicMsg && (
                <div style={{ padding: '10px', borderRadius: 8, background: basicMsg.includes('✅') ? '#dcfce7' : '#fee2e2', color: basicMsg.includes('✅') ? '#166534' : '#991b1b', fontSize: 13, fontWeight: 700 }}>
                  {basicMsg}
                </div>
              )}

              <div style={{ display: 'flex', justifyContent: 'flex-end', gap: '10px', marginTop: '10px' }}>
                <button type="button" onClick={() => setShowBasicModal(false)} style={{ padding: '9px 16px', borderRadius: 8, border: '1px solid #cbd5e1', background: '#f8fafc', fontWeight: 600, cursor: 'pointer' }}>
                  Hủy bỏ
                </button>
                <Button type="submit" disabled={savingBasic}>
                  {savingBasic ? 'Đang lưu...' : 'Lưu Thông Tin →'}
                </Button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* MODAL 2: IMPORT EXAM VIA cURL / JSON */}
      {showImportModal && (
        <div style={{ position: 'fixed', top: 0, left: 0, right: 0, bottom: 0, background: 'rgba(0,0,0,0.5)', display: 'grid', placeItems: 'center', zIndex: 1000, padding: '20px' }}>
          <div style={{ background: '#ffffff', borderRadius: '14px', width: '100%', maxWidth: '680px', padding: '24px', boxShadow: '0 20px 40px rgba(0,0,0,0.2)' }}>
            <h3 style={{ margin: '0 0 8px 0', fontSize: '18px', fontWeight: 800, color: '#0f172a' }}>
              📥 Tự Động Nhập Đề Bằng cURL Supabase / API
            </h3>
            <p style={{ fontSize: 13, color: '#64748b', margin: '0 0 16px 0' }}>
              Dán câu lệnh <code>curl 'https://.../rpc/get_mock_questions_by_test_parts'</code> lấy từ F12 DevTools (Supabase/API) vào bên dưới. Hệ thống sẽ tự động gọi API tải trọn vẹn 200 câu hỏi vào CSDL PostgreSQL!
            </p>

            <form onSubmit={handleRunImport} style={{ display: 'flex', flexDirection: 'column', gap: '14px' }}>
              <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '12px' }}>
                <label style={{ display: 'flex', flexDirection: 'column', gap: 4, fontSize: 13, fontWeight: 700, color: '#334155' }}>
                  Mã Đề Thi Mới
                  <input value={importExamCode} onChange={e => setImportExamCode(e.target.value)} placeholder="ets-2024-test01" required style={{ padding: '9px 12px', borderRadius: 8, border: '1px solid #cbd5e1', fontSize: 14 }} />
                </label>
                <label style={{ display: 'flex', flexDirection: 'column', gap: 4, fontSize: 13, fontWeight: 700, color: '#334155' }}>
                  Tên Đề Thi
                  <input value={importExamTitle} onChange={e => setImportExamTitle(e.target.value)} placeholder="ETS 2024 Test 01" required style={{ padding: '9px 12px', borderRadius: 8, border: '1px solid #cbd5e1', fontSize: 14 }} />
                </label>
              </div>

              <label style={{ display: 'flex', flexDirection: 'column', gap: 4, fontSize: 13, fontWeight: 700, color: '#334155' }}>
                Dán Lệnh cURL Tại Đây:
                <textarea
                  value={curlInput}
                  onChange={e => setCurlInput(e.target.value)}
                  rows={6}
                  placeholder={`curl 'https://qfhmnlvgweznzcsoijyr.supabase.co/rest/v1/rpc/get_mock_questions_by_test_parts' \\\n  -H 'apikey: eyJhbGci...' \\\n  --data-raw '{"p_test_id":"66459c57-e764-4431-8876-6d76078963c7","p_parts":null}'`}
                  style={{ padding: '10px', borderRadius: 8, border: '1px solid #cbd5e1', fontSize: 12, fontFamily: 'monospace', background: '#0f172a', color: '#38bdf8' }}
                  required
                />
              </label>

              {importMsg && (
                <div style={{ padding: '10px', borderRadius: 8, background: importMsg.includes('🎉') ? '#dcfce7' : importMsg.includes('⏳') ? '#eff6ff' : '#fee2e2', color: importMsg.includes('🎉') ? '#166534' : importMsg.includes('⏳') ? '#1d4ed8' : '#991b1b', fontSize: 13, fontWeight: 700 }}>
                  {importMsg}
                </div>
              )}

              <div style={{ display: 'flex', justifyContent: 'flex-end', gap: '10px', marginTop: '10px' }}>
                <button type="button" onClick={() => setShowImportModal(false)} style={{ padding: '9px 16px', borderRadius: 8, border: '1px solid #cbd5e1', background: '#f8fafc', fontWeight: 600, cursor: 'pointer' }}>
                  Hủy bỏ
                </button>
                <button type="submit" disabled={importing} style={{ padding: '9px 20px', borderRadius: 8, background: '#2563eb', color: '#ffffff', fontWeight: 700, border: 'none', cursor: 'pointer' }}>
                  {importing ? '⏳ Đang phân tích...' : '⚡ Phân Tích & Tải 200 Câu Vào CSDL →'}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* MODAL 3: DETAILED 200 QUESTION EDITOR (PART 1-7) */}
      {showQuestionModal && (
        <div style={{ position: 'fixed', top: 0, left: 0, right: 0, bottom: 0, background: 'rgba(0,0,0,0.6)', display: 'grid', placeItems: 'center', zIndex: 1000, padding: '20px' }}>
          <div style={{ background: '#ffffff', borderRadius: '16px', width: '100%', maxWidth: '960px', maxHeight: '90vh', overflowY: 'auto', padding: '24px', boxShadow: '0 25px 50px rgba(0,0,0,0.3)' }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 16 }}>
              <div>
                <h3 style={{ margin: 0, fontSize: '20px', fontWeight: 800, color: '#0f172a' }}>
                  📝 Bộ Biên Tập 200 Câu Hỏi: <span style={{ color: '#2563eb' }}>{activeExamCode}</span>
                </h3>
                <span style={{ fontSize: 13, color: '#64748b' }}>Chỉnh sửa trực tiếp từng câu từ Part 1 ➔ Part 7</span>
              </div>
              <button onClick={() => setShowQuestionModal(false)} style={{ background: '#f1f5f9', border: 'none', borderRadius: '50%', width: 36, height: 36, fontWeight: 800, cursor: 'pointer', fontSize: 16 }}>✕</button>
            </div>

            {/* PART TABS */}
            <div style={{ display: 'flex', gap: 6, overflowX: 'auto', paddingBottom: 10, borderBottom: '1px solid #e2e8f0', marginBottom: 16 }}>
              {[
                { part: 1, label: 'Part 1 (Nghe ảnh)', range: 'Câu 1-6' },
                { part: 2, label: 'Part 2 (Hỏi đáp)', range: 'Câu 7-31' },
                { part: 3, label: 'Part 3 (Hội thoại)', range: 'Câu 32-70' },
                { part: 4, label: 'Part 4 (Bài nói)', range: 'Câu 71-100' },
                { part: 5, label: 'Part 5 (Điền câu)', range: 'Câu 101-130' },
                { part: 6, label: 'Part 6 (Đọc điền)', range: 'Câu 131-146' },
                { part: 7, label: 'Part 7 (Đọc hiểu)', range: 'Câu 147-200' },
              ].map(p => (
                <button
                  key={p.part}
                  onClick={() => {
                    setActivePart(p.part);
                    const firstQ = questions.find(q => q.part === p.part);
                    if (firstQ) loadQuestionIntoForm(firstQ);
                  }}
                  style={{
                    padding: '8px 14px', borderRadius: 8, border: '1px solid',
                    borderColor: activePart === p.part ? '#2563eb' : '#cbd5e1',
                    background: activePart === p.part ? '#2563eb' : '#f8fafc',
                    color: activePart === p.part ? '#ffffff' : '#334155',
                    fontWeight: 700, fontSize: 12, cursor: 'pointer', whiteSpace: 'nowrap'
                  }}
                >
                  {p.label} <small style={{ opacity: 0.8 }}>({p.range})</small>
                </button>
              ))}
            </div>

            {loadingQuestions ? (
              <div style={{ padding: 40, textAlign: 'center', color: '#64748b' }}>Đang tải 200 câu hỏi từ CSDL...</div>
            ) : (
              <div style={{ display: 'grid', gridTemplateColumns: '220px 1fr', gap: 20 }}>
                {/* QUESTION NUMBER SELECTOR SIDEBAR */}
                <div style={{ borderRight: '1px solid #e2e8f0', paddingRight: 16, maxHeight: '60vh', overflowY: 'auto' }}>
                  <div style={{ fontSize: 13, fontWeight: 700, color: '#475569', marginBottom: 8 }}>
                    Chọn câu hỏi (Part {activePart}):
                  </div>
                  <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', gap: 6 }}>
                    {Array.from({ length: 200 }, (_, i) => i + 1)
                      .filter(num => {
                        const expectedPart = num <= 6 ? 1 : num <= 31 ? 2 : num <= 70 ? 3 : num <= 100 ? 4 : num <= 130 ? 5 : num <= 146 ? 6 : 7;
                        return expectedPart === activePart;
                      })
                      .map(num => {
                        const hasQ = questions.some(q => q.questionNumber === num);
                        return (
                          <button
                            key={num}
                            onClick={() => handleSelectQuestionNum(num)}
                            style={{
                              padding: '8px 4px', borderRadius: 6, border: '1px solid',
                              borderColor: selectedQNum === num ? '#2563eb' : hasQ ? '#cbd5e1' : '#fca5a5',
                              background: selectedQNum === num ? '#2563eb' : hasQ ? '#ffffff' : '#fef2f2',
                              color: selectedQNum === num ? '#ffffff' : hasQ ? '#1e293b' : '#dc2626',
                              fontWeight: 700, fontSize: 12, cursor: 'pointer'
                            }}
                          >
                            {num}
                          </button>
                        );
                      })}
                  </div>
                </div>

                {/* QUESTION DETAIL FORM */}
                <form onSubmit={handleSaveCurrentQuestion} style={{ display: 'flex', flexDirection: 'column', gap: 14 }}>
                  <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', background: '#f8fafc', padding: '10px 14px', borderRadius: 8 }}>
                    <span style={{ fontWeight: 800, fontSize: 15, color: '#1e293b' }}>
                      Đang chỉnh sửa: <span style={{ color: '#2563eb' }}>CÂU SỐ {selectedQNum}</span> (Part {activePart})
                    </span>
                    <label style={{ fontSize: 13, fontWeight: 700, color: '#334155', display: 'flex', alignItems: 'center', gap: 8 }}>
                      Đáp án đúng:
                      <select value={ans} onChange={e => setAns(e.target.value)} style={{ padding: '4px 10px', borderRadius: 6, fontWeight: 800, background: '#dcfce7', color: '#166534' }}>
                        <option value="A">A</option>
                        <option value="B">B</option>
                        <option value="C">C</option>
                        <option value="D">D</option>
                      </select>
                    </label>
                  </div>

                  <label style={{ display: 'flex', flexDirection: 'column', gap: 4, fontSize: 13, fontWeight: 700, color: '#334155' }}>
                    Nội dung câu hỏi (`questionText`)
                    <textarea value={qText} onChange={e => setQText(e.target.value)} rows={2} placeholder="Nội dung câu hỏi..." style={{ padding: '8px 12px', borderRadius: 8, border: '1px solid #cbd5e1', fontSize: 13 }} />
                  </label>

                  {/* OPTIONS A/B/C/D */}
                  <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 10 }}>
                    <label style={{ display: 'flex', flexDirection: 'column', gap: 4, fontSize: 12, fontWeight: 700, color: '#334155' }}>
                      Phương án A
                      <input value={opA} onChange={e => setOpA(e.target.value)} placeholder="(A) ..." style={{ padding: '8px 10px', borderRadius: 6, border: '1px solid #cbd5e1', fontSize: 13 }} />
                    </label>
                    <label style={{ display: 'flex', flexDirection: 'column', gap: 4, fontSize: 12, fontWeight: 700, color: '#334155' }}>
                      Phương án B
                      <input value={opB} onChange={e => setOpB(e.target.value)} placeholder="(B) ..." style={{ padding: '8px 10px', borderRadius: 6, border: '1px solid #cbd5e1', fontSize: 13 }} />
                    </label>
                    <label style={{ display: 'flex', flexDirection: 'column', gap: 4, fontSize: 12, fontWeight: 700, color: '#334155' }}>
                      Phương án C
                      <input value={opC} onChange={e => setOpC(e.target.value)} placeholder="(C) ..." style={{ padding: '8px 10px', borderRadius: 6, border: '1px solid #cbd5e1', fontSize: 13 }} />
                    </label>
                    <label style={{ display: 'flex', flexDirection: 'column', gap: 4, fontSize: 12, fontWeight: 700, color: '#334155' }}>
                      Phương án D
                      <input value={opD} onChange={e => setOpD(e.target.value)} placeholder="(D) ..." style={{ padding: '8px 10px', borderRadius: 6, border: '1px solid #cbd5e1', fontSize: 13 }} />
                    </label>
                  </div>

                  {/* MEDIA URLS */}
                  <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 10 }}>
                    <label style={{ display: 'flex', flexDirection: 'column', gap: 4, fontSize: 12, fontWeight: 700, color: '#334155' }}>
                      Link File Nghe Audio (`audioUrl`)
                      <input value={audioUrl} onChange={e => setAudioUrl(e.target.value)} placeholder="https://.../1.mp3" style={{ padding: '8px 10px', borderRadius: 6, border: '1px solid #cbd5e1', fontSize: 12 }} />
                    </label>
                    <label style={{ display: 'flex', flexDirection: 'column', gap: 4, fontSize: 12, fontWeight: 700, color: '#334155' }}>
                      Link Hình Ảnh (`imageUrl`)
                      <input value={imageUrl} onChange={e => setImageUrl(e.target.value)} placeholder="https://.../1.png" style={{ padding: '8px 10px', borderRadius: 6, border: '1px solid #cbd5e1', fontSize: 12 }} />
                    </label>
                  </div>

                  {/* PASSAGE TEXT FOR PARTS 6 & 7 */}
                  {(activePart === 6 || activePart === 7) && (
                    <label style={{ display: 'flex', flexDirection: 'column', gap: 4, fontSize: 12, fontWeight: 700, color: '#334155' }}>
                      Bài đọc / Passage (`passageText`)
                      <textarea value={passageText} onChange={e => setPassageText(e.target.value)} rows={3} placeholder="Nội dung bài đọc đoạn văn..." style={{ padding: '8px 10px', borderRadius: 6, border: '1px solid #cbd5e1', fontSize: 12 }} />
                    </label>
                  )}

                  <label style={{ display: 'flex', flexDirection: 'column', gap: 4, fontSize: 12, fontWeight: 700, color: '#334155' }}>
                    Giải thích chi tiết Tiếng Việt (`explanationVi`)
                    <textarea value={expVi} onChange={e => setExpVi(e.target.value)} rows={2} placeholder="Lời giải chi tiết..." style={{ padding: '8px 10px', borderRadius: 6, border: '1px solid #cbd5e1', fontSize: 12 }} />
                  </label>

                  {qMsg && (
                    <div style={{ padding: '8px 12px', borderRadius: 6, background: qMsg.includes('✅') ? '#dcfce7' : '#fee2e2', color: qMsg.includes('✅') ? '#166534' : '#991b1b', fontSize: 13, fontWeight: 700 }}>
                      {qMsg}
                    </div>
                  )}

                  <div style={{ display: 'flex', justifyContent: 'flex-end', gap: 10, marginTop: 6 }}>
                    <button type="submit" disabled={savingQ} style={{ padding: '9px 24px', borderRadius: 8, background: '#2563eb', color: '#ffffff', fontWeight: 700, border: 'none', cursor: 'pointer' }}>
                      {savingQ ? 'Đang lưu...' : `💾 Lưu Thay Đổi Câu ${selectedQNum} →`}
                    </button>
                  </div>
                </form>
              </div>
            )}
          </div>
        </div>
      )}
    </section>
  );
}

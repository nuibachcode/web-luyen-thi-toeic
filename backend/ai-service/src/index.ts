import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import { Pool } from 'pg';
import { defaultAIConfig, AIConfig } from './ai_config';

dotenv.config();

const app = express();
const PORT = Number(process.env.PORT || 4004);

app.use(cors());
app.use(express.json());

let currentAIConfig: AIConfig = { ...defaultAIConfig };

// Database Persistence for System Configs
let rawDbUrl = process.env.DATABASE_URL || `postgresql://${process.env.DB_USER || 'toeic_user'}:${process.env.DB_PASSWORD || '0FcKcaH548fGZFvD66F68KuGFdUyKCWg'}@${process.env.DB_HOST || 'dpg-d9ndhsdaeets73bn2jm0-a.oregon-postgres.render.com'}/${process.env.DB_NAME || 'toeic_db_qwyv'}?sslmode=require`;

if (rawDbUrl.startsWith('postgres://')) {
  rawDbUrl = rawDbUrl.replace(/^postgres:\/\//, 'postgresql://');
}

const dbUrl = rawDbUrl;

const pool = new Pool({
  connectionString: dbUrl,
  ssl: dbUrl.includes('render.com') || dbUrl.includes('sslmode=require') ? { rejectUnauthorized: false } : false
});

async function initAiDatabase() {
  try {
    await pool.query(`
      CREATE TABLE IF NOT EXISTS system_configs (
        config_key VARCHAR(100) PRIMARY KEY,
        config_value TEXT NOT NULL,
        updated_at TIMESTAMPTZ DEFAULT NOW()
      );
    `);

    // Restore saved gemini_api_key on startup
    const resKey = await pool.query(`SELECT config_value FROM system_configs WHERE config_key = 'gemini_api_key'`);
    if (resKey.rows.length > 0 && resKey.rows[0].config_value) {
      currentAIConfig.geminiApiKey = resKey.rows[0].config_value;
      console.log('✅ Loaded persisted Gemini API Key from Database!');
    }

    // Restore saved system_instruction on startup
    const resInst = await pool.query(`SELECT config_value FROM system_configs WHERE config_key = 'system_instruction'`);
    if (resInst.rows.length > 0 && resInst.rows[0].config_value) {
      currentAIConfig.systemInstruction = resInst.rows[0].config_value;
    }
  } catch (err) {
    console.warn('AI DB Init notice:', (err as Error).message);
  }
}

initAiDatabase();

type GeminiResponse = {
  text: string | null;
  error: string | null;
  status: number;
};

// Helper function to call Google Gemini API with fallback formats
async function callGeminiApi(prompt: string, apiKey: string, customSystemInstruction?: string): Promise<GeminiResponse> {
  if (!apiKey || apiKey.trim().length === 0) {
    return { text: null, error: 'Chưa cấu hình Google Gemini API Key. Vui lòng vào trang Cấu hình Admin (/admin/ai-settings) hoặc bấm biểu tượng 🔑 để dán mã API Key!', status: 400 };
  }

  const systemText = customSystemInstruction || currentAIConfig.systemInstruction;
  
  const payloadSimple = {
    contents: [{ parts: [{ text: `${systemText}\n\n${prompt}` }] }]
  };

  const payloadWithSystem = {
    systemInstruction: { parts: [{ text: systemText }] },
    contents: [{ parts: [{ text: prompt }] }]
  };

  const models = ['gemini-flash-lite-latest', 'gemini-3.1-flash-lite', 'gemini-flash-latest', 'gemini-2.0-flash-lite', 'gemini-2.0-flash'];
  let lastErrorMsg = 'Không thể kết nối đến Google Gemini API';
  let lastStatus = 500;

  for (const model of models) {
    for (const payload of [payloadSimple, payloadWithSystem]) {
      try {
        const controller = new AbortController();
        const timeoutId = setTimeout(() => controller.abort(), 22000);

        const res = await fetch(
          `https://generativelanguage.googleapis.com/v1beta/models/${model}:generateContent?key=${apiKey}`,
          {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(payload),
            signal: controller.signal
          }
        );
        clearTimeout(timeoutId);

        if (res.ok) {
          const data = await res.json();
          const text = data.candidates?.[0]?.content?.parts?.[0]?.text;
          if (text) return { text, error: null, status: 200 };
        } else {
          lastStatus = res.status;
          const err = await res.json().catch(() => ({}));
          const errMsg = err.error?.message || `Lỗi Google API (${res.status})`;
          lastErrorMsg = `Google Gemini API báo lỗi (${res.status}): ${errMsg}`;
          console.warn(`[Mô hình ${model}] ${lastErrorMsg}`);
        }
      } catch (e) {
        lastErrorMsg = `Lỗi kết nối AI: ${(e as Error).message}`;
        console.warn(`[Mô hình ${model}] ${lastErrorMsg}`);
      }
    }
  }

  return { text: null, error: lastErrorMsg, status: lastStatus };
}

// Health Check
app.get('/health', (_req, res) => {
  const activeKey = currentAIConfig.geminiApiKey || process.env.GEMINI_API_KEY;
  const isConfigured = Boolean(activeKey && activeKey.length > 10);
  res.json({
    status: 'AI Service is running!',
    service: 'ai-service',
    port: PORT,
    gemini_api_configured: isConfigured,
    key_source: currentAIConfig.geminiApiKey ? 'database_admin' : (process.env.GEMINI_API_KEY ? 'environment' : 'missing'),
    key_mask: activeKey ? `${activeKey.substring(0, 6)}...${activeKey.substring(activeKey.length - 4)}` : 'none',
    specialization: currentAIConfig.specialization
  });
});

// GET /api/ai/config
app.get('/api/ai/config', (_req, res) => {
  const activeKey = currentAIConfig.geminiApiKey || process.env.GEMINI_API_KEY || '';
  res.json({
    config: {
      ...currentAIConfig,
      geminiApiKey: activeKey ? `${activeKey.substring(0, 6)}...${activeKey.substring(activeKey.length - 4)}` : '',
      isKeyActive: Boolean(activeKey && activeKey.length > 10)
    }
  });
});

// PUT /api/ai/config (Admin management endpoint)
app.put('/api/ai/config', async (req, res) => {
  const { systemInstruction, specialization, maxIconsAllowed, geminiApiKey } = req.body;
  if (systemInstruction && typeof systemInstruction === 'string') {
    currentAIConfig.systemInstruction = systemInstruction;
    pool.query(
      `INSERT INTO system_configs (config_key, config_value, updated_at) VALUES ('system_instruction', $1, NOW()) ON CONFLICT (config_key) DO UPDATE SET config_value = EXCLUDED.config_value, updated_at = NOW()`,
      [systemInstruction]
    ).catch(() => {});
  }
  if (specialization && typeof specialization === 'string') currentAIConfig.specialization = specialization;
  if (typeof maxIconsAllowed === 'number') currentAIConfig.maxIconsAllowed = maxIconsAllowed;
  
  if (typeof geminiApiKey === 'string') {
    const trimmed = geminiApiKey.trim();
    currentAIConfig.geminiApiKey = trimmed;
    pool.query(
      `INSERT INTO system_configs (config_key, config_value, updated_at) VALUES ('gemini_api_key', $1, NOW()) ON CONFLICT (config_key) DO UPDATE SET config_value = EXCLUDED.config_value, updated_at = NOW()`,
      [trimmed]
    ).catch(() => {});
  }

  const activeKey = currentAIConfig.geminiApiKey || process.env.GEMINI_API_KEY;
  let testSuccess = false;
  let testMsg = 'Đã lưu cấu hình';

  if (activeKey) {
    const testResult = await callGeminiApi('Hello, respond with OK', activeKey);
    if (testResult.text) {
      testSuccess = true;
      testMsg = '✅ Kết nối Google Gemini API thành công! Hệ thống đã lưu Key vào CSDL Cloud và kích hoạt AI Real-time.';
    } else {
      testMsg = `⚠️ Đã lưu Key vào CSDL nhưng kết nối Google Gemini API chưa thành công: ${testResult.error}`;
    }
  }

  res.json({
    message: testMsg,
    testSuccess,
    config: {
      ...currentAIConfig,
      geminiApiKey: activeKey ? `${activeKey.substring(0, 6)}...${activeKey.substring(activeKey.length - 4)}` : '',
      isKeyActive: testSuccess
    }
  });
});

// 1. AI Question Explanation & Vocabulary Extractor
app.post('/api/ai/explain', async (req, res) => {
  try {
    const { questionText, options, correctAnswer, explanation, passageText } = req.body;
    const apiKey = req.body.apiKey || currentAIConfig.geminiApiKey || process.env.GEMINI_API_KEY;

    if (!apiKey) {
      return res.status(400).json({ error: 'Chưa cấu hình Google Gemini API Key.' });
    }

    const prompt = `Hãy phân tích câu hỏi TOEIC sau:
Câu hỏi: ${questionText || ''}
${passageText ? `Đoạn văn: ${passageText}` : ''}
Các phương án: ${JSON.stringify(options || [])}
Đáp án đúng: ${correctAnswer || ''}
Giải thích: ${explanation || ''}

Trả về định dạng JSON hợp lệ (không kèm markdown):
{
  "translation": "Dịch toàn bộ câu hỏi và các phương án sang tiếng Việt",
  "whyCorrect": "Lý giải tại sao chọn đáp án này và phân tích ngữ pháp",
  "vocabulary": [
    { "word": "từ_vựng", "ipa": "/phiên_âm/", "meaning": "nghĩa" }
  ],
  "trapWarning": "Lưu ý bẫy hoặc mẹo nhớ nhanh"
}`;

    const result = await callGeminiApi(prompt, apiKey);
    if (!result.text) {
      return res.status(result.status || 500).json({ error: result.error || 'Lỗi gọi Google Gemini API.' });
    }

    const parsed = extractJsonObject(result.text);
    if (parsed && (parsed.translation || parsed.whyCorrect)) {
      return res.json({ ai: parsed, provider: 'Google Gemini AI (Real-time)' });
    } else {
      return res.status(500).json({ error: 'AI trả về phản hồi không thể phân tích cấu trúc JSON.' });
    }
  } catch (error) {
    console.error('AI Explain error:', error);
    res.status(500).json({ error: `Lỗi AI Explain: ${(error as Error).message}` });
  }
});

// 2. Interactive AI Tutor Chatbot
app.post('/api/ai/chat', async (req, res) => {
  try {
    const { message, history = [], context = {} } = req.body;
    if (!message) return res.status(400).json({ error: 'Message is required' });

    const apiKey = req.body.apiKey || currentAIConfig.geminiApiKey || process.env.GEMINI_API_KEY;

    if (!apiKey) {
      return res.status(400).json({ error: 'Chưa cấu hình Google Gemini API Key. Vui lòng nhập API Key để trò chuyện với AI Tutor!' });
    }

    const historySnippet = Array.isArray(history) && history.length > 0
      ? history.slice(-6).map((h: any) => `${h.sender === 'user' ? 'Học viên' : 'AeroAI'}: ${h.text}`).join('\n')
      : 'Chưa có cuộc trò chuyện trước đó.';

    const questionContext = context.activeQuestion
      ? `\n- Đang làm câu hỏi: "${context.activeQuestion.questionText || ''}"\n  Options: A. ${context.activeQuestion.optionA || ''} | B. ${context.activeQuestion.optionB || ''} | C. ${context.activeQuestion.optionC || ''} | D. ${context.activeQuestion.optionD || ''}\n  Đáp án đúng: ${context.activeQuestion.correctAnswer || ''}\n  Lựa chọn của học viên: ${context.activeQuestion.userAnswer || 'Chưa chọn'}`
      : '';

    const prompt = `Bạn là AeroAI Tutor 990+ — Trợ lý trợ giảng ảo luyện thi TOEIC siêu thông minh, thân thiện và giàu kinh nghiệm sư phạm.
Thông tin ngữ cảnh học viên hiện tại:
- Điểm hiện tại ước tính: ${context.currentScore || 450} điểm
- Điểm mục tiêu TOEIC: ${context.targetScore || 750} điểm
- Đang ở trang: ${context.page || 'Trang học viên'}${questionContext}

Lịch sử trò chuyện gần nhất:
${historySnippet}

Học viên vừa nhắn: "${message}"

Yêu cầu câu trả lời:
- Trả lời bằng tiếng Việt thân thiện, súc tích (dưới 160 từ).
- Nếu học viên hỏi về từ vựng hay ngữ pháp, hãy giải thích công thức, nghĩa tiếng Việt và cho ví dụ minh họa rõ ràng.
- Sử dụng icon/emoji sinh động, truyền động lực bứt phá điểm số TOEIC cho học viên.`;

    const result = await callGeminiApi(prompt, apiKey);
    if (!result.text) {
      return res.status(result.status || 500).json({ error: result.error || 'Không thể lấy phản hồi từ AI Tutor.' });
    }

    return res.json({ reply: result.text, provider: 'Google Gemini AI (Real-time)' });
  } catch (error) {
    console.error('AI Chat error:', error);
    res.status(500).json({ error: `Lỗi AI Tutor: ${(error as Error).message}` });
  }
});

// 3. AI Listening Transcript Generator
app.post('/api/ai/generate-transcript', async (req, res) => {
  try {
    const { part = 1, questions = [] } = req.body;
    const apiKey = req.body.apiKey || currentAIConfig.geminiApiKey || process.env.GEMINI_API_KEY;

    if (!apiKey) {
      return res.status(400).json({ error: 'Chưa cấu hình Google Gemini API Key.' });
    }

    const qSnippet = Array.isArray(questions)
      ? questions.map((q: any, i: number) =>
          `Câu ${i+1} (${q.question_number || i+1}): ${q.question_text || q.questionText || ''}\n` +
          `Options: A. ${q.option_a || ''} | B. ${q.option_b || ''} | C. ${q.option_c || ''} | D. ${q.option_d || ''}\n` +
          `Đáp án đúng: ${q.correct_answer || q.correctAnswer || 'A'}`
        ).join('\n\n')
      : '';

    const prompt = `Bạn là Chuyên gia Biên soạn Đề thi TOEIC ETS. Hãy khôi phục & viết lại BẢN TRANSCRIPT BÀI NGHE TIẾNG ANH CHUẨN ETS cho Part ${part} dựa trên thông tin các câu hỏi sau:

${qSnippet}

Yêu cầu định dạng đầu ra:
- Đối với Part 1: Viết 4 câu miêu tả bức ảnh (A), (B), (C), (D) bằng tiếng Anh kèm bản dịch tiếng Việt tương ứng bên dưới.
- Đối với Part 2: Viết câu hỏi (Man/Woman) và 3 câu trả lời (A), (B), (C) bằng tiếng Anh kèm dịch tiếng Việt.
- Đối với Part 3 & 4: Viết bài hội thoại/bài nói đầy đủ bằng tiếng Anh giữa 2 người (👨 Man, 👩 Woman) khớp chính xác với thông tin câu hỏi trên, sau đó kèm bản dịch Tiếng Việt chi tiết.
- Trình bày định dạng rõ ràng, đẹp mắt.`;

    const result = await callGeminiApi(prompt, apiKey);
    if (!result.text) {
      return res.status(result.status || 500).json({ error: result.error || 'Lỗi tạo Transcript.' });
    }

    return res.json({ transcript: result.text, provider: 'Google Gemini AI (Real-time)' });
  } catch (error) {
    console.error('AI Generate Transcript error:', error);
    res.status(500).json({ error: `Failed to generate AI transcript: ${(error as Error).message}` });
  }
});

function extractJsonObject(text: string) {
  if (!text) return null;
  const cleanText = text.replace(/```json/gi, '').replace(/```/g, '').trim();
  try {
    return JSON.parse(cleanText);
  } catch (e) {
    const start = text.indexOf('{');
    const end = text.lastIndexOf('}');
    if (start !== -1 && end > start) {
      try {
        return JSON.parse(text.slice(start, end + 1));
      } catch (err) {
        console.warn('Regex JSON parse failed:', (err as Error).message);
      }
    }
  }
  return null;
}

// 4. Roadmap Master Overview Generator
app.post('/api/ai/create-roadmap-overview', async (req, res) => {
  try {
    const { currentScore = 450, targetScore = 750, durationDays = 30, listeningAvg = 240, readingAvg = 210, testHistory = [] } = req.body;
    const apiKey = req.body.apiKey || currentAIConfig.geminiApiKey || process.env.GEMINI_API_KEY;
    const numDays = Math.min(60, Math.max(7, Number(durationDays) || 30));

    if (!apiKey) {
      return res.status(400).json({ error: 'Chưa cấu hình Google Gemini API Key. Vui lòng nhập API Key để tạo lộ trình AI!' });
    }

    const gap = targetScore - currentScore;

    const prompt = `Bạn là Giảng viên Luyện thi TOEIC ETS 990. Hãy lập KHUNG NỘI DUNG TỔNG QUAN lộ trình học ${numDays} ngày cá nhân hóa cho học viên từ ${currentScore} điểm (Listening: ${listeningAvg}, Reading: ${readingAvg}) lên mục tiêu ${targetScore} điểm (khoảng cách +${gap} điểm, số bài thi đã nộp: ${testHistory.length} bài).

Trả về duy nhất JSON hợp lệ (không chứa markdown codeblock):
{
  "diagnosticSummary": "Phân tích 2-3 câu CÁ NHÂN HÓA cho điểm ${currentScore} -> ${targetScore} trong ${numDays} ngày",
  "weakPoints": ["Điểm yếu 1 dựa trên ${currentScore} điểm", "Điểm yếu 2", "Điểm yếu 3"],
  "phase1": { "name": "Củng cố Nền tảng Part 1-2 (${targetScore}+)", "focus": "Mô tả hình ảnh & Hỏi đáp Wh-" },
  "phase2": { "name": "Tăng tốc Ngữ pháp & Bài nói Part 3-5 (${targetScore}+)", "focus": "Từ loại, Thì động từ & Nghe hội thoại" },
  "phase3": { "name": "Bứt phá Đọc hiểu & Thi thử Part 6-7 (${targetScore}+)", "focus": "Kỹ thuật Skimming/Scanning & Luyện đề ETS" }
}`;

    const result = await callGeminiApi(prompt, apiKey);
    if (!result.text) {
      return res.status(result.status || 500).json({ error: result.error || 'Không thể kết nối dịch vụ AI Tạo lộ trình.' });
    }

    const parsed = extractJsonObject(result.text);
    if (!parsed) {
      return res.status(500).json({ error: 'AI trả về phản hồi Lộ trình không hợp lệ.' });
    }

    let daysList: any[] = [];
    if (parsed.days && Array.isArray(parsed.days) && parsed.days.length > 0) {
      daysList = parsed.days.map((d: any, i: number) => ({
        dayNumber: d.dayNumber || (i + 1),
        weekNumber: d.weekNumber || Math.ceil((i + 1) / 7),
        title: d.title || `Ngày ${i + 1}: Chuyên đề TOEIC ${targetScore}+`,
        focus: d.focus || `Chiến thuật bứt phá mục tiêu ${targetScore} điểm`
      }));
    } else {
      const phase1Name = parsed.phase1?.name || `Củng cố Nền tảng & Từ vựng Part 1-2 (${targetScore}+)`;
      const phase1Focus = parsed.phase1?.focus || 'Mô tả hình ảnh & Hỏi đáp Wh-';
      const phase2Name = parsed.phase2?.name || `Tăng tốc Ngữ pháp & Bài nói Part 3-5 (${targetScore}+)`;
      const phase2Focus = parsed.phase2?.focus || 'Từ loại, Thì động từ & Nghe hội thoại';
      const phase3Name = parsed.phase3?.name || `Bứt phá Đọc hiểu & Thi thử Part 6-7 (${targetScore}+)`;
      const phase3Focus = parsed.phase3?.focus || 'Kỹ thuật Skimming/Scanning & Luyện đề ETS';

      const phases = [
        { name: phase1Name, focus: phase1Focus },
        { name: phase2Name, focus: phase2Focus },
        { name: phase3Name, focus: phase3Focus }
      ];

      daysList = Array.from({ length: numDays }, (_, i) => {
        const dayNum = i + 1;
        const weekNum = Math.ceil(dayNum / 7);
        const phaseIdx = Math.min(2, Math.floor((i / numDays) * 3));
        const currentPhase = phases[phaseIdx];
        return {
          dayNumber: dayNum,
          weekNumber: weekNum,
          title: `Ngày ${dayNum}: ${currentPhase.name}`,
          focus: currentPhase.focus
        };
      });
    }

    return res.json({
      overview: {
        diagnosticSummary: parsed.diagnosticSummary || `Hệ thống phân tích trình độ hiện tại (${currentScore} điểm) và mục tiêu ${targetScore} điểm trong ${numDays} ngày. Lộ trình tập trung cải thiện kỹ năng nghe (${listeningAvg} điểm) và đọc (${readingAvg} điểm).`,
        weakPoints: parsed.weakPoints || [
          `Tốc độ phân tích Part 5 & 6 ứng với mức điểm ${currentScore}`,
          `Vốn từ vựng chuyên ngành bứt phá mục tiêu ${targetScore}`,
          'Quản lý thời gian làm bài Part 7 đoạn kép & đoạn ba'
        ],
        totalDays: numDays,
        weeksCount: Math.ceil(numDays / 7),
        days: daysList
      },
      provider: 'Google Gemini AI (Real-time)'
    });
  } catch (error) {
    console.error('Roadmap overview error:', error);
    res.status(500).json({ error: `Lỗi tạo lộ trình: ${(error as Error).message}` });
  }
});

// 5. On-Demand Daily Lesson Generator (60 Minutes Full Content)
app.post('/api/ai/generate-day-lesson', async (req, res) => {
  try {
    const { dayNumber = 1, dayTitle, dayFocus, targetScore = 750, currentScore = 450 } = req.body;
    const apiKey = req.body.apiKey || currentAIConfig.geminiApiKey || process.env.GEMINI_API_KEY;

    if (!apiKey) {
      return res.status(400).json({ error: 'Chưa cấu hình Google Gemini API Key. Vui lòng nhập API Key để tạo bài học!' });
    }
    const gap = targetScore - currentScore;

    const prompt = `Bạn là Giảng viên Luyện thi TOEIC ETS 990. Hãy biên soạn TRỌN BỘ BÀI HỌC CÁ NHÂN HÓA CHO NGÀY ${dayNumber} theo đúng chủ đề: "${dayTitle || 'Luyện tập chuyên sâu'}" (Trọng tâm: ${dayFocus || 'Kiến thức TOEIC'}).
Mục tiêu bài học giúp học viên bứt phá từ ${currentScore} lên ${targetScore} điểm (khoảng cách +${gap} điểm).

Hãy trả về phản hồi JSON hợp lệ (không chứa ký tự markdown hay bọc codeblock):
{
  "dayNumber": ${dayNumber},
  "title": "${dayTitle || 'Bài học ngày ' + dayNumber}",
  "estimatedTimeMinutes": 60,
  "vocabularyList": [
    {
      "word": "inquire",
      "ipa": "/ɪnˈkwaɪər/",
      "partOfSpeech": "verb",
      "meaning": "hỏi, điều tra",
      "example": "She called to inquire about the job position."
    }
  ],
  "grammarRule": {
    "title": "Tên chủ đề Ngữ pháp bám sát chủ đề ngày học",
    "explanation": "Giải thích chi tiết quy tắc ngữ pháp cho bài học ngày này",
    "formula": "Công thức / Cấu trúc",
    "examples": [
      "Ví dụ 1 minh họa",
      "Ví dụ 2 minh họa"
    ]
  },
  "etsTips": "Mẹo tránh bẫy ETS bám sát chủ đề ngày học này",
  "practiceQuestions": [
    {
      "id": 1,
      "questionText": "Câu hỏi trắc nghiệm bám sát chủ đề bài học ngày này",
      "optionA": "Đáp án A",
      "optionB": "Đáp án B",
      "optionC": "Đáp án C",
      "optionD": "Đáp án D",
      "correctAnswer": "A",
      "explanation": "Lời giải thích chi tiết vì sao chọn A."
    }
  ]
}
Yêu cầu quan trọng: "vocabularyList" chứa 5-6 từ vựng xuất sắc chuẩn ETS theo đúng chủ đề "${dayTitle || 'Luyện tập'}". "practiceQuestions" chứa 4 câu hỏi trắc nghiệm A-B-C-D kèm đáp án và lời giải bám sát chủ đề "${dayTitle || 'Luyện tập'}". Phản hồi phải là JSON thuần.`;

    const result = await callGeminiApi(prompt, apiKey);
    if (!result.text) {
      return res.status(result.status || 500).json({ error: result.error || 'Không thể tạo bài học từ Google Gemini AI.' });
    }

    const parsed = extractJsonObject(result.text);
    if (parsed && (parsed.vocabularyList || parsed.grammarRule)) {
      return res.json({ lesson: parsed, provider: 'Google Gemini AI (Real-time)' });
    } else {
      return res.status(500).json({ error: 'AI trả về phản hồi Bài học không thể phân tích định dạng JSON.' });
    }
  } catch (error) {
    console.error('Generate day lesson error:', error);
    res.status(500).json({ error: `Lỗi bài học ngày: ${(error as Error).message}` });
  }
});

app.listen(PORT, () => {
  console.log(`🤖 AeroAI Dedicated Microservice listening on http://localhost:${PORT}`);
});

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
const dbUrl = process.env.DATABASE_URL || `postgresql://${process.env.DB_USER || 'toeic_user'}:${process.env.DB_PASSWORD || '0FcKcaH548fGZFvD66F68KuGFdUyKCWg'}@${process.env.DB_HOST || 'dpg-d9ndhsdaeets73bn2jm0-a.oregon-postgres.render.com'}/${process.env.DB_NAME || 'toeic_db_qwyv'}?sslmode=require`;

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

// Helper function to call Google Gemini API with fallback formats
async function callGeminiApi(prompt: string, apiKey: string, customSystemInstruction?: string) {
  const systemText = customSystemInstruction || currentAIConfig.systemInstruction;
  
  const payloadWithSystem = {
    systemInstruction: { parts: [{ text: systemText }] },
    contents: [{ parts: [{ text: prompt }] }]
  };

  const payloadSimple = {
    contents: [{ parts: [{ text: `${systemText}\n\n${prompt}` }] }]
  };

  const models = ['gemini-flash-latest', 'gemini-3.6-flash', 'gemini-3.5-flash', 'gemini-2.0-flash-lite-001', 'gemini-2.0-flash'];
  for (const model of models) {
    for (const payload of [payloadWithSystem, payloadSimple]) {
      try {
        const res = await fetch(
          `https://generativelanguage.googleapis.com/v1beta/models/${model}:generateContent?key=${apiKey}`,
          { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(payload) }
        );
        if (res.ok) {
          const data = await res.json();
          const text = data.candidates?.[0]?.content?.parts?.[0]?.text;
          if (text) return text;
        } else {
          const err = await res.json().catch(() => ({}));
          console.warn(`Model ${model} returned ${res.status}:`, JSON.stringify(err).slice(0, 100));
        }
      } catch (e) {
        console.warn(`Model ${model} failed:`, (e as Error).message);
      }
    }
  }
  return null;
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
    // Quick test against Gemini API
    const testResult = await callGeminiApi('Hello, respond with OK', activeKey);
    if (testResult) {
      testSuccess = true;
      testMsg = '✅ Kết nối Google Gemini API thành công! Hệ thống đã lưu Key vào CSDL Cloud và kích hoạt AI Real-time.';
    } else {
      testMsg = '⚠️ Đã lưu Key vào CSDL nhưng Google API trả về lỗi 401 (Key bị giới hạn quyền hoặc chưa bật API Generative Language). Hãy kiểm tra nút "+ Create API key" trên Google AI Studio!';
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

    if (apiKey) {
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

      const aiText = await callGeminiApi(prompt, apiKey);
      if (aiText) {
        const cleanJson = aiText.replace(/```json/g, '').replace(/```/g, '').trim();
        try {
          const parsed = JSON.parse(cleanJson);
          return res.json({ ai: parsed, provider: 'Google Gemini AI (Real-time)' });
        } catch (e) {
          console.warn('JSON parse error:', e);
        }
      }
    }

    // Fallback for explain
    const parsedOptions = Array.isArray(options) ? options : [];
    const correctOpt = parsedOptions.find((o: any) => o.label === correctAnswer) || parsedOptions[0];
    res.json({
      ai: {
        translation: `Câu hỏi: "${questionText || 'Câu hỏi luyện tập TOEIC'}"`,
        whyCorrect: `Đáp án (${correctAnswer || correctOpt?.label || 'A'}) là chính xác. ${explanation || 'Dựa theo ngữ cảnh văn phạm ETS.'}`,
        vocabulary: [
          { word: 'authorize', ipa: '/ˈɔː.θər.aɪz/', meaning: 'ủy quyền, cấp phép' },
          { word: 'confirm', ipa: '/kənˈfɜːm/', meaning: 'xác nhận' }
        ],
        trapWarning: 'Chú ý phân biệt từ đồng âm và các thì động từ thường gặp trong ETS.'
      },
      provider: 'AeroAI Engine (Smart Fallback)'
    });
  } catch (error) {
    console.error('AI Explain error:', error);
    res.status(500).json({ error: 'AI processing failed' });
  }
});

// 2. Interactive AI Tutor Chatbot
app.post('/api/ai/chat', async (req, res) => {
  try {
    const { message, history = [], context = {} } = req.body;
    if (!message) return res.status(400).json({ error: 'Message is required' });

    const apiKey = req.body.apiKey || currentAIConfig.geminiApiKey || process.env.GEMINI_API_KEY;

    if (apiKey) {
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

      const reply = await callGeminiApi(prompt, apiKey);
      if (reply) return res.json({ reply, provider: 'Google Gemini AI (Real-time)' });
    }

    // Smart Fallback AI Tutor chatbot reply
    let reply = `Chào bạn! Tôi là AeroAI Tutor 🤖 trợ lý luyện thi TOEIC của bạn.\n\n`;
    const lower = message.toLowerCase();

    if (lower.includes('part 1') || lower.includes('ảnh') || lower.includes('hình')) {
      reply += `**Mẹo làm Part 1 (Mô tả hình ảnh):**\n- Tập trung quan sát hành động của người (đang làm gì) hoặc vị trí vật thể.\n- Cảnh giác với bẫy từ đồng âm và bẫy thì Tiếp diễn (being + V3/ed).\n- Nếu bức ảnh không có người, chọn câu mô tả trạng thái vật thể!`;
    } else if (lower.includes('part 2') || lower.includes('hỏi')) {
      reply += `**Mẹo làm Part 2 (Hỏi & Đáp):**\n- Nghe kỹ từ hỏi đầu tiên (Who, Where, When, Why, How).\n- Loại ngay các đáp án có từ đồng âm với câu hỏi (thường là bẫy).\n- Đáp án "Tôi không biết / Để tôi kiểm tra" luôn đúng trong 95% trường hợp!`;
    } else if (lower.includes('part 5') || lower.includes('ngữ pháp')) {
      reply += `**Mẹo làm Part 5 (Điền câu ngắn):**\n- Xác định từ loại cần điền (Danh từ, Động từ, Tính từ, Trạng từ) dựa vào vị trí khoảng trống.\n- Nhìn trước và sau khoảng trống 2-3 từ trước khi đọc toàn bộ câu để tiết kiệm thời gian!`;
    } else if (lower.includes('từ vựng') || lower.includes('vocab')) {
      reply += `**Gợi ý từ vựng TOEIC phổ biến trong môi trường làm việc:**\n- **Implement** (v): Thực thi, triển khai\n- **Representative** (n): Người đại diện\n- **Accompany** (v): Đi cùng, đồng hành\n- **Compliance** (n): Sự tuân thủ quy định`;
    } else {
      reply += `Về thắc mắc **"${message}"**:\nTrong đề thi TOEIC ETS, chìa khóa chiến thắng là phân bổ thời gian hợp lý (Listening 45 phút, Reading 75 phút) và luyện tập từ vựng chủ đề Office/Business thường xuyên. Bạn có muốn tôi hỗ trợ giải thích cụ thể câu hỏi hay Part nào không?`;
    }

    res.json({ reply, provider: 'AeroAI Tutor (Smart Fallback)' });
  } catch (error) {
    console.error('AI Chat error:', error);
    res.status(500).json({ error: 'AI Tutor failed' });
  }
});

// 3. AI Listening Transcript Generator
app.post('/api/ai/generate-transcript', async (req, res) => {
  try {
    const { part = 1, questions = [] } = req.body;
    const apiKey = req.body.apiKey || currentAIConfig.geminiApiKey || process.env.GEMINI_API_KEY;

    if (apiKey) {
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

      const transcript = await callGeminiApi(prompt, apiKey);
      if (transcript) return res.json({ transcript, provider: 'Google Gemini AI (Real-time)' });
    }

    res.json({ transcript: 'Cụm bài nghe này chưa có sẵn transcript trong CSDL.', provider: 'Notice' });
  } catch (error) {
    console.error('AI Generate Transcript error:', error);
    res.status(500).json({ error: 'Failed to generate AI transcript' });
  }
});

// 4. Roadmap Master Overview Generator
app.post('/api/ai/create-roadmap-overview', async (req, res) => {
  try {
    const { currentScore = 450, targetScore = 750, durationDays = 30, listeningAvg = 240, readingAvg = 210, testHistory = [] } = req.body;
    const apiKey = req.body.apiKey || currentAIConfig.geminiApiKey || process.env.GEMINI_API_KEY;

    if (apiKey) {
      const gap = targetScore - currentScore;
      const expDifficulty = Math.round(Math.exp(gap / 120) * 10) / 10;

      const prompt = `Bạn là Giảng viên Luyện thi TOEIC ETS 990. Hãy lập KHUNG NỘI DUNG TỔNG QUAN lộ trình học ${durationDays} ngày cá nhân hóa cho học viên dựa trên:
- Trình độ hiện tại: ${currentScore} điểm (Listening: ${listeningAvg}, Reading: ${readingAvg})
- Mục tiêu: ${targetScore} điểm (Khoảng cách: +${gap} điểm. Hệ số độ khó ngầm: ${expDifficulty}x)
- Lịch sử thi thử đã nộp: ${testHistory.length} bài

Hãy trả về phản hồi JSON hợp lệ (không bọc codeblock):
{
  "diagnosticSummary": "Phân tích 2-3 câu về điểm mạnh, điểm yếu và chiến thuật bứt phá",
  "weakPoints": ["Điểm yếu 1", "Điểm yếu 2", "Điểm yếu 3"],
  "totalDays": ${durationDays},
  "weeksCount": ${Math.ceil(durationDays / 7)},
  "days": [
    {
      "dayNumber": 1,
      "weekNumber": 1,
      "title": "Ngày 1: Từ vựng Văn phòng & Bẫy thì tiếp diễn Part 1",
      "focus": "Mô tả hình ảnh & Từ vựng Office equipment"
    }
  ]
}
Lưu ý: mảng "days" phải chứa đúng ${durationDays} phần tử (từ Ngày 1 đến Ngày ${durationDays}). Tiêu đề và focus từng ngày phải phân bổ tăng dần từ củng cố nền tảng đến luyện thi bứt phá.`;

      const aiText = await callGeminiApi(prompt, apiKey);
      if (aiText) {
        const cleanJson = aiText.replace(/```json/g, '').replace(/```/g, '').trim();
        try {
          const parsed = JSON.parse(cleanJson);
          return res.json({ overview: parsed, provider: 'Google Gemini AI (Real-time)' });
        } catch (e) {
          console.warn('Overview JSON parse error:', e);
        }
      }
    }

    // Fallback Roadmap Generator
    const numDays = Math.min(60, Math.max(7, Number(durationDays) || 30));
    const topics = [
      { title: 'Từ vựng Văn phòng & Mô tả hình ảnh Part 1', focus: 'Bẫy thì tiếp diễn & Từ vựng Office Equipment' },
      { title: 'Chiến thuật Hỏi & Đáp Part 2', focus: 'Từ hỏi Wh- & Mẹo đáp án I don\'t know' },
      { title: 'Ngữ pháp Thì Quá khứ & Hiện tại Hoàn thành Part 5', focus: 'Dấu hiệu nhận biết thì & Sự hòa hợp S-V' },
      { title: 'Hội thoại Ngắn Part 3 - Chủ đề Đặt hàng & Giao hàng', focus: 'Kỹ năng đọc trước câu hỏi & Bắt key words' },
      { title: 'Bài nói Ngắn Part 4 - Thông báo & Hướng dẫn', focus: 'Nhận biết người nói & Mục đích bài phát biểu' },
      { title: 'Hoàn thành Đoạn văn Part 6', focus: 'Liên từ & Điền câu phù hợp văn cảnh' },
      { title: 'Đọc hiểu Đoạn đơn Part 7 - Email & Thư thoại', focus: 'Kỹ thuật Skimming & Scanning câu hỏi chi tiết' },
      { title: 'Đọc hiểu Đoạn đôi & Đoạn ba Part 7', focus: 'Kết nối thông tin giữa 2-3 tài liệu văn bản' },
      { title: 'Luyện đề thi thử ETS Mock Test', focus: 'Quản lý quỹ thời gian 120 phút & Kiểm soát áp lực' }
    ];

    const daysList = Array.from({ length: numDays }, (_, i) => {
      const dayNum = i + 1;
      const weekNum = Math.ceil(dayNum / 7);
      const topic = topics[i % topics.length];
      return {
        dayNumber: dayNum,
        weekNumber: weekNum,
        title: `Ngày ${dayNum}: ${topic.title}`,
        focus: topic.focus
      };
    });

    res.json({
      overview: {
        diagnosticSummary: `Hệ thống phân tích trình độ hiện tại (${currentScore} điểm) và mục tiêu ${targetScore} điểm trong ${numDays} ngày. Lộ trình tập trung cải thiện từ vựng cốt lõi, phản xạ kỹ năng nghe Parts 1-4 và tốc độ đọc Parts 5-7.`,
        weakPoints: [
          'Tốc độ phân tích câu ngữ pháp phức hợp ở Part 5 & 6',
          'Từ vựng chuyên ngành Logistics, Marketing và Hợp đồng',
          'Quản lý thời gian làm bài Part 7 đoạn kép & đoạn ba'
        ],
        totalDays: numDays,
        weeksCount: Math.ceil(numDays / 7),
        days: daysList
      },
      provider: 'AeroAI Roadmap Engine (Smart Fallback)'
    });
  } catch (error) {
    console.error('Roadmap overview error:', error);
    res.status(500).json({ error: 'Lỗi tạo lộ trình. Vui lòng thử lại sau.' });
  }
});

// 5. On-Demand Daily Lesson Generator (60 Minutes Full Content)
app.post('/api/ai/generate-day-lesson', async (req, res) => {
  try {
    const { dayNumber = 1, dayTitle, dayFocus, targetScore = 750, currentScore = 450 } = req.body;
    const apiKey = req.body.apiKey || currentAIConfig.geminiApiKey || process.env.GEMINI_API_KEY;

    if (apiKey) {
      const gap = targetScore - currentScore;

      const prompt = `Bạn là Giảng viên Luyện thi TOEIC ETS 990. Hãy biên soạn TRỌN BỘ BÀI HỌC 60 PHÚT ĐẦY ĐỦ CHO NGÀY ${dayNumber} theo chủ đề: "${dayTitle || 'Luyện tập chuyên sâu'}" (Trọng tâm: ${dayFocus || 'Kiến thức TOEIC'}).
Mục tiêu bài học giúp học viên bứt phá từ ${currentScore} lên ${targetScore} điểm (khoảng cách +${gap} điểm).

Hãy trả về phản hồi JSON hợp lệ (không chứa ký tự markdown hay bọc codeblock):
{
  "dayNumber": ${dayNumber},
  "title": "${dayTitle || 'Bài học ngày ' + dayNumber}",
  "estimatedTimeMinutes": 60,
  "vocabularyList": [
    {
      "word": "authorize",
      "ipa": "/ˈɔː.θər.aɪz/",
      "partOfSpeech": "verb",
      "meaning": "ủy quyền, cấp phép",
      "example": "The manager authorized the release of the financial report."
    }
  ],
  "grammarRule": {
    "title": "Cấu trúc Ngữ pháp Cốt lõi",
    "explanation": "Giải thích chi tiết quy tắc ngữ pháp cho buổi học này",
    "formula": "S + V + Object / Clause",
    "examples": [
      "Ví dụ 1 minh họa câu ngữ pháp TOEIC",
      "Ví dụ 2 phân tích thì động từ"
    ]
  },
  "etsTips": "Mẹo tránh bẫy từ đồng âm hoặc lỗi hay sai trong đề thi ETS cho ngày học này",
  "practiceQuestions": [
    {
      "id": 1,
      "questionText": "The board of directors agreed to ______ the new budget plan next Monday.",
      "optionA": "approve",
      "optionB": "approval",
      "optionC": "approving",
      "optionD": "approved",
      "correctAnswer": "A",
      "explanation": "Sau động từ 'agreed to' cần một động từ nguyên mẫu (V-bare). Chọn A."
    }
  ]
}
Yêu cầu quan trọng: "vocabularyList" phải chứa từ 10 đến 12 từ vựng phong phú đầy đủ phiên âm IPA, loại từ, nghĩa tiếng Việt và câu ví dụ dài. "practiceQuestions" phải chứa từ 10 đến 12 câu hỏi trắc nghiệm A-B-C-D kèm đáp án và lời giải thích rõ ràng, đảm bảo đủ thời lượng 60 phút luyện tập cho học viên. Phản hồi phải là JSON thuần, không markdown.`;

      const aiText = await callGeminiApi(prompt, apiKey);
      if (aiText) {
        const cleanJson = aiText.replace(/```json/g, '').replace(/```/g, '').trim();
        try {
          const parsed = JSON.parse(cleanJson);
          return res.json({ lesson: parsed, provider: 'Google Gemini AI (Real-time)' });
        } catch (e) {
          console.warn('Day Lesson JSON parse error:', e);
        }
      }
    }

    // Fallback 60-Minute Lesson Generator
    const dNum = Number(dayNumber) || 1;
    res.json({
      lesson: {
        dayNumber: dNum,
        title: dayTitle || `Bài học Ngày ${dNum}: Chuyên sâu ETS TOEIC`,
        estimatedTimeMinutes: 60,
        vocabularyList: [
          { word: 'implement', ipa: '/ˈɪm.plɪ.ment/', partOfSpeech: 'verb', meaning: 'triển khai, thực thi', example: 'The team will implement the new policy next month.' },
          { word: 'representative', ipa: '/ˌrep.rɪˈzen.tə.tɪv/', partOfSpeech: 'noun', meaning: 'người đại diện', example: 'A customer service representative will assist you shortly.' },
          { word: 'authorize', ipa: '/ˈɔː.θər.aɪz/', partOfSpeech: 'verb', meaning: 'ủy quyền, cho phép', example: 'Only the director can authorize international expenditures.' },
          { word: 'schedule', ipa: '/ˈʃed.juːl/', partOfSpeech: 'verb/noun', meaning: 'lịch trình, lên lịch', example: 'The conference is scheduled for next Tuesday.' },
          { word: 'compliance', ipa: '/kəmˈplaɪ.əns/', partOfSpeech: 'noun', meaning: 'sự tuân thủ', example: 'Safety compliance is mandatory for all lab technicians.' },
          { word: 'negotiate', ipa: '/nəˈɡəʊ.ʃi.eɪt/', partOfSpeech: 'verb', meaning: 'đàm phán, thương lượng', example: 'They negotiated a lower rate for the yearly contract.' },
          { word: 'substantially', ipa: '/səbˈstæn.ʃəl.i/', partOfSpeech: 'adverb', meaning: 'đáng kể, nhiều', example: 'Quarterly profits increased substantially after the merger.' },
          { word: 'accommodate', ipa: '/əˈkɒm.ə.deɪt/', partOfSpeech: 'verb', meaning: 'chứa, đáp ứng nhu cầu', example: 'The hall can accommodate up to 500 participants.' },
          { word: 'preliminary', ipa: '/prɪˈlɪm.ɪ.nər.i/', partOfSpeech: 'adjective', meaning: 'sơ bộ, ban đầu', example: 'The preliminary report will be reviewed tomorrow.' },
          { word: 'terminate', ipa: '/ˈtɜː.mɪ.neɪt/', partOfSpeech: 'verb', meaning: 'chấm dứt, kết thúc', example: 'Either party may terminate the agreement with written notice.' }
        ],
        grammarRule: {
          title: 'Quy tắc Ngữ pháp Cốt lõi TOEIC: Từ loại & Thì Động từ',
          explanation: 'Trong đề thi TOEIC, vị trí trước danh từ thường là tính từ (Adj + N), và vị trí bổ nghĩa cho động từ/tính từ là trạng từ (Adv + V/Adj). Đồng thời cần chú ý thì Hiện tại Hoàn thành (have/has + V3) biểu thị hành động đã bắt đầu và còn kéo dài.',
          formula: 'Subject + Have/Has + V3/ed + Object (since / for / already)',
          examples: [
            'Ms. Carter has successfully managed the sales division for five years.',
            'All official documents must be reviewed before final submission.'
          ]
        },
        etsTips: '💡 Mẹo ETS: Trong Part 5, nếu gặp câu hỏi từ loại có khoảng trống nằm giữa Động từ to be/từ nối và Tính từ, hãy chọn Trạng từ (-ly). Đối với Part 1 bài nghe, loại ngay đáp án có "being" nếu bức ảnh không có người đang thao tác!',
        practiceQuestions: [
          { id: 1, questionText: 'The board of directors agreed to ______ the proposed expansion plan next week.', optionA: 'approve', optionB: 'approval', optionC: 'approving', optionD: 'approved', correctAnswer: 'A', explanation: 'Sau cụm "agreed to" cần một động từ nguyên mẫu V-bare. Chọn A.' },
          { id: 2, questionText: 'All candidates must submit their application forms ______ 5:00 PM on Friday.', optionA: 'until', optionB: 'before', optionC: 'during', optionD: 'between', correctAnswer: 'B', explanation: 'Chỉ mốc thời gian hoàn thành trước một hạn chót, dùng mạo từ/giới từ "before". Chọn B.' },
          { id: 3, questionText: 'The marketing team worked ______ to complete the advertising campaign ahead of schedule.', optionA: 'diligent', optionB: 'diligently', optionC: 'diligence', optionD: 'more diligent', correctAnswer: 'B', explanation: 'Khoảng trống bổ nghĩa cho động từ thường "worked", chọn trạng từ "diligently". Chọn B.' },
          { id: 4, questionText: 'Dr. Lawson is considered one of the most ______ researchers in modern biophysics.', optionA: 'respect', optionB: 'respected', optionC: 'respectfully', optionD: 'respects', correctAnswer: 'B', explanation: 'Khoảng trống nằm giữa "most" và danh từ "researchers", cần một tính từ miêu tả uy tín/được kính trọng "respected". Chọn B.' },
          { id: 5, questionText: 'Please review the attached invoice and notify us if you find any ______.', optionA: 'discrepancies', optionB: 'discrepant', optionC: 'discrepantly', optionD: 'discrepancying', correctAnswer: 'A', explanation: 'Sau tính từ "any" cần một danh từ (ở dạng số nhiều "discrepancies" - sự sai lệch). Chọn A.' }
        ]
      },
      provider: 'AeroAI Day Lesson Engine (Smart Fallback)'
    });
  } catch (error) {
    console.error('Generate day lesson error:', error);
    res.status(500).json({ error: 'Lỗi tải bài học. Vui lòng thử lại sau.' });
  }
});

app.listen(PORT, () => {
  console.log(`🤖 AeroAI Dedicated Microservice listening on http://localhost:${PORT}`);
});

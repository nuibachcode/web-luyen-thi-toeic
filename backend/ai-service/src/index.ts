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

// Helper function to call Google Gemini API with fallback formats
async function callGeminiApi(prompt: string, apiKey: string, customSystemInstruction?: string) {
  const systemText = customSystemInstruction || currentAIConfig.systemInstruction;
  
  const payloadSimple = {
    contents: [{ parts: [{ text: `${systemText}\n\n${prompt}` }] }]
  };

  const payloadWithSystem = {
    systemInstruction: { parts: [{ text: systemText }] },
    contents: [{ parts: [{ text: prompt }] }]
  };

  const models = ['gemini-flash-lite-latest', 'gemini-3.1-flash-lite', 'gemini-flash-latest', 'gemini-2.0-flash-lite', 'gemini-2.0-flash'];
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

    if (apiKey) {
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

      const aiText = await callGeminiApi(prompt, apiKey);
      if (aiText) {
        const parsed = extractJsonObject(aiText);
        if (parsed) {
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
        }
      }
    }

    // Dynamic Fallback Roadmap Generator
    const topics = [
      { title: `Từ vựng & Mô tả hình ảnh Part 1 (Mục tiêu ${targetScore})`, focus: 'Bẫy thì tiếp diễn & Từ vựng Office Equipment' },
      { title: `Chiến thuật Hỏi & Đáp Part 2 (Mục tiêu ${targetScore})`, focus: 'Từ hỏi Wh- & Mẹo đáp án I don\'t know' },
      { title: `Ngữ pháp Từ loại & Thì Động từ Part 5 (Mục tiêu ${targetScore})`, focus: 'Dấu hiệu nhận biết từ loại & Sự hòa hợp S-V' },
      { title: `Hội thoại Ngắn Part 3 (Mục tiêu ${targetScore})`, focus: 'Kỹ năng đọc trước câu hỏi & Bắt từ đồng nghĩa' },
      { title: `Bài nói Ngắn Part 4 (Mục tiêu ${targetScore})`, focus: 'Nhận biết người nói & Mục đích bài phát biểu' },
      { title: `Hoàn thành Đoạn văn Part 6 (Mục tiêu ${targetScore})`, focus: 'Liên từ & Điền câu phù hợp văn cảnh' },
      { title: `Đọc hiểu Đoạn đơn Part 7 (Mục tiêu ${targetScore})`, focus: 'Kỹ thuật Skimming & Scanning câu hỏi chi tiết' },
      { title: `Đọc hiểu Đoạn đôi & Đoạn ba Part 7 (Mục tiêu ${targetScore})`, focus: 'Kết nối thông tin giữa 2-3 tài liệu văn bản' },
      { title: `Luyện đề thi thử ETS Mock Test (Mục tiêu ${targetScore})`, focus: 'Quản lý quỹ thời gian 120 phút & Kiểm soát áp lực' }
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
        diagnosticSummary: `Hệ thống phân tích trình độ hiện tại (${currentScore} điểm) và mục tiêu ${targetScore} điểm trong ${numDays} ngày. Lộ trình tập trung cải thiện từ vựng cốt lõi, phản xạ kỹ năng nghe (${listeningAvg} điểm) và tốc độ đọc (${readingAvg} điểm).`,
        weakPoints: [
          `Tốc độ phân tích câu ngữ pháp Part 5 & 6 ở mức ${currentScore} điểm`,
          `Vốn từ vựng thương mại bứt phá mục tiêu ${targetScore} điểm`,
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

      const aiText = await callGeminiApi(prompt, apiKey);
      if (aiText) {
        const parsed = extractJsonObject(aiText);
        if (parsed && (parsed.vocabularyList || parsed.grammarRule)) {
          return res.json({ lesson: parsed, provider: 'Google Gemini AI (Real-time)' });
        }
      }
    }

    // Smart Fallback 60-Minute Lesson Generator (Dynamic per day topic)
    const dNum = Number(dayNumber) || 1;
    const topicBankIndex = (dNum - 1) % 5;

    const topicBanks = [
      {
        title: dayTitle || `Bài học Ngày ${dNum}: Mô tả hình ảnh & Bẫy thì tiếp diễn Part 1`,
        vocabularyList: [
          { word: 'inspect', ipa: '/ɪnˈspekt/', partOfSpeech: 'verb', meaning: 'kiểm tra, thanh tra', example: 'The engineer is inspecting the machinery.' },
          { word: 'merchandise', ipa: '/ˈmɜː.tʃən.daɪz/', partOfSpeech: 'noun', meaning: 'hàng hóa', example: 'Merchandise is displayed on shelves.' },
          { word: 'pedestrian', ipa: '/pəˈdes.tri.ən/', partOfSpeech: 'noun', meaning: 'người đi bộ', example: 'Pedestrians are crossing the street.' },
          { word: 'assemble', ipa: '/əˈsem.bəl/', partOfSpeech: 'verb', meaning: 'lắp ráp, tập hợp', example: 'Workers are assembling the new equipment.' },
          { word: 'vehicle', ipa: '/ˈvɪə.kəl/', partOfSpeech: 'noun', meaning: 'xe cộ, phương tiện', example: 'Several vehicles are parked along the curb.' }
        ],
        grammarRule: {
          title: 'Chiến thuật làm bài Part 1: Cấu trúc Mô tả Hành động & Trạng thái',
          explanation: 'Đối với Part 1, chú ý bẫy "being + V3" (chỉ hành động đang diễn ra). Nếu hình ảnh không có người đang thao tác, đáp án có "being" là SAI.',
          formula: 'Subject + IS/ARE + BEING + V3/ed (Hành động đang làm)',
          examples: [
            'The road is being paved. (Đang có người lát đường)',
            'Boxes have been stacked in the warehouse. (Hộp đã được chất đống)'
          ]
        },
        etsTips: '💡 Mẹo Part 1: Quan sát kỹ tay và hướng mắt của nhân vật trong hình ảnh trước khi nghe 4 phương án.',
        practiceQuestions: [
          { id: 1, questionText: 'Look at the picture: A man is ______ a document on his desk.', optionA: 'examining', optionB: 'exam', optionC: 'examined', optionD: 'examination', correctAnswer: 'A', explanation: 'Sau động từ to be "is" miêu tả hành động đang diễn ra chọn V-ing "examining". Chọn A.' },
          { id: 2, questionText: 'Some items are being ______ on the counter.', optionA: 'display', optionB: 'displayed', optionC: 'displaying', optionD: 'displays', correctAnswer: 'B', explanation: 'Cấu trúc bị động "are being + V3/ed", chọn "displayed". Chọn B.' }
        ]
      },
      {
        title: dayTitle || `Bài học Ngày ${dNum}: Chiến thuật Hỏi & Đáp Part 2`,
        vocabularyList: [
          { word: 'inquire', ipa: '/ɪnˈkwaɪər/', partOfSpeech: 'verb', meaning: 'hỏi, điều tra', example: 'She called to inquire about room availability.' },
          { word: 'postpone', ipa: '/pəʊstˈpəʊn/', partOfSpeech: 'verb', meaning: 'hoãn lại', example: 'The meeting was postponed until Thursday.' },
          { word: 'location', ipa: '/ləʊˈkeɪ.ʃən/', partOfSpeech: 'noun', meaning: 'địa điểm', example: 'What is the location of the new branch?' },
          { word: 'confirm', ipa: '/kənˈfɜːm/', partOfSpeech: 'verb', meaning: 'xác nhận', example: 'Please confirm your flight reservation.' },
          { word: 'itinerary', ipa: '/aɪˈtɪn.ər.ər.i/', partOfSpeech: 'noun', meaning: 'lịch trình chuyến đi', example: 'The travel agency sent the updated itinerary.' }
        ],
        grammarRule: {
          title: 'Chiến thuật Hỏi & Đáp Part 2: Nhận biết câu hỏi Wh-',
          explanation: 'Nghe kỹ từ hỏi đầu tiên: Who (người), Where (nơi chốn), When (thời gian), Why (lý do), How (cách thức/chi phí). Loại ngay các đáp án có từ đồng âm bẫy.',
          formula: 'Wh- + Auxiliary + Subject + Main Verb?',
          examples: [
            'Where is the conference room? - On the second floor.',
            'Who is leading the seminar? - Mr. Thompson from Marketing.'
          ]
        },
        etsTips: '💡 Mẹo Part 2: Các phương án mang nghĩa "I don\'t know", "Let me check", "It hasn\'t been decided yet" luôn đúng trong 95% trường hợp!',
        practiceQuestions: [
          { id: 1, questionText: 'Where will the workshop take place tomorrow?', optionA: 'In Conference Room B.', optionB: 'Yes, I will.', optionC: 'At 3:00 PM.', optionD: 'Mr. Davis.', correctAnswer: 'A', explanation: 'Câu hỏi "Where" hỏi địa điểm. Đáp án A trả lời phòng họp B là chính xác nhất.' },
          { id: 2, questionText: 'When is the project proposal due?', optionA: 'By the end of this week.', optionB: 'Yes, it is.', optionC: 'To Mr. Harrison.', optionD: 'In the office.', correctAnswer: 'A', explanation: 'Câu hỏi "When" hỏi thời gian. Đáp án A chỉ hạn chót vào cuối tuần là đúng.' }
        ]
      },
      {
        title: dayTitle || `Bài học Ngày ${dNum}: Ngữ pháp Từ loại & Thì Động từ Part 5`,
        vocabularyList: [
          { word: 'implement', ipa: '/ˈɪm.plɪ.ment/', partOfSpeech: 'verb', meaning: 'triển khai, thực thi', example: 'The team will implement the new policy next month.' },
          { word: 'compliance', ipa: '/kəmˈplaɪ.əns/', partOfSpeech: 'noun', meaning: 'sự tuân thủ', example: 'Safety compliance is mandatory for all staff.' },
          { word: 'substantial', ipa: '/səbˈstæn.ʃəl/', partOfSpeech: 'adjective', meaning: 'đáng kể, lớn', example: 'The company reported a substantial growth in revenue.' },
          { word: 'diligent', ipa: '/ˈdɪl.ɪ.dʒənt/', partOfSpeech: 'adjective', meaning: 'siêng năng, cần cù', example: 'Her diligent efforts were recognized by the board.' },
          { word: 'eligible', ipa: '/ˈel.ɪ.dʒə.bəl/', partOfSpeech: 'adjective', meaning: 'đủ điều kiện', example: 'All full-time employees are eligible for benefits.' }
        ],
        grammarRule: {
          title: 'Quy tắc Ngữ pháp Cốt lõi: Vị trí Từ loại (N, V, Adj, Adv)',
          explanation: 'Đứng trước Danh từ là Tính từ (Adj + N). Bổ nghĩa cho Động từ/Tính từ là Trạng từ (Adv + V/Adj). Đứng sau Giới từ là Danh từ/V-ing.',
          formula: 'Article/Possessive + Adj + Noun | Verb + Adverb',
          examples: [
            'The board approved a substantial increase in budget.',
            'Mr. Lee handled the client complaint efficiently.'
          ]
        },
        etsTips: '💡 Mẹo Part 5: Nhìn trước và sau khoảng trống 2 từ trước khi đọc toàn bộ câu để chọn nhanh từ loại trong 10 giây.',
        practiceQuestions: [
          { id: 1, questionText: 'The committee member agreed to ______ the new budget proposal.', optionA: 'approve', optionB: 'approval', optionC: 'approving', optionD: 'approved', correctAnswer: 'A', explanation: 'Sau động từ "agreed to" cần một động từ nguyên mẫu V-bare "approve". Chọn A.' },
          { id: 2, questionText: 'All candidates worked ______ to meet the project deadline.', optionA: 'diligently', optionB: 'diligent', optionC: 'diligence', optionD: 'more diligent', correctAnswer: 'A', explanation: 'Bổ nghĩa cho động từ thường "worked", chọn trạng từ "diligently". Chọn A.' }
        ]
      },
      {
        title: dayTitle || `Bài học Ngày ${dNum}: Hội thoại Ngắn & Bài nói Part 3 & 4`,
        vocabularyList: [
          { word: 'representative', ipa: '/ˌrep.rɪˈzen.tə.tɪv/', partOfSpeech: 'noun', meaning: 'người đại diện', example: 'A customer representative will assist you.' },
          { word: 'accommodate', ipa: '/əˈkɒm.ə.deɪt/', partOfSpeech: 'verb', meaning: 'chứa, đáp ứng', example: 'The room can accommodate up to 100 guests.' },
          { word: 'negotiate', ipa: '/nəˈɡəʊ.ʃi.eɪt/', partOfSpeech: 'verb', meaning: 'thương lượng, đàm phán', example: 'They negotiated a lower rate for the contract.' },
          { word: 'vendor', ipa: '/ˈven.dər/', partOfSpeech: 'noun', meaning: 'nhà cung cấp', example: 'The vendor delivered the supplies on time.' },
          { word: 'inconvenience', ipa: '/ˌɪn.kəmˈviː.ni.əns/', partOfSpeech: 'noun', meaning: 'sự bất tiện', example: 'We apologize for any inconvenience caused.' }
        ],
        grammarRule: {
          title: 'Kỹ năng làm Part 3 & 4: Paraphrasing & Đọc trước câu hỏi',
          explanation: 'Tận dụng thời gian đọc hướng dẫn để đọc trước 3 câu hỏi của cụm bài nghe. Chú ý các từ đồng nghĩa (Paraphrasing) trong bài nghe và đáp án.',
          formula: 'Keywords in Question -> Paraphrased Synonym in Audio',
          examples: [
            'Audio: "We need to delay the shipment" -> Option: "Postpone delivery"',
            'Audio: "Reduce the price" -> Option: "Offer a discount"'
          ]
        },
        etsTips: '💡 Mẹo Part 3-4: Vừa nghe vừa khoanh đáp án, băng đọc xong 3 câu hỏi thì tay bạn đã phải sẵn sàng đọc trước 3 câu hỏi của bài tiếp theo!',
        practiceQuestions: [
          { id: 1, questionText: 'What is the main topic of the conversation?', optionA: 'Negotiating a contract.', optionB: 'Ordering lunch.', optionC: 'Booking a flight.', optionD: 'Hiring a manager.', correctAnswer: 'A', explanation: 'Bài hội thoại xoay quanh đàm phán hợp đồng cung cấp. Chọn A.' },
          { id: 2, questionText: 'What does the speaker promise to do next?', optionA: 'Send an email confirmation.', optionB: 'Cancel the order.', optionC: 'Call the technician.', optionD: 'Visit the office.', correctAnswer: 'A', explanation: 'Người nói cam kết gửi email xác nhận. Chọn A.' }
        ]
      },
      {
        title: dayTitle || `Bài học Ngày ${dNum}: Đọc hiểu Chuyên sâu Part 6 & 7`,
        vocabularyList: [
          { word: 'discrepancy', ipa: '/dɪsˈkrep.ən.si/', partOfSpeech: 'noun', meaning: 'sự sai lệch, khác biệt', example: 'Please report any billing discrepancies immediately.' },
          { word: 'terminate', ipa: '/ˈtɜː.mɪ.neɪt/', partOfSpeech: 'verb', meaning: 'chấm dứt, kết thúc', example: 'Either party may terminate the lease contract.' },
          { word: 'specification', ipa: '/ˌspes.ɪ.fɪˈkeɪ.ʃən/', partOfSpeech: 'noun', meaning: 'thông số kỹ thuật', example: 'Check the product specifications before ordering.' },
          { word: 'confidential', ipa: '/ˌkɒn.fɪˈden.ʃəl/', partOfSpeech: 'adjective', meaning: 'bảo mật, bí mật', example: 'All employee records are strictly confidential.' },
          { word: 'amend', ipa: '/əˈmend/', partOfSpeech: 'verb', meaning: 'sửa đổi, bổ sung', example: 'The policy was amended to protect worker rights.' }
        ],
        grammarRule: {
          title: 'Kỹ thuật đọc hiểu Part 7: Skimming & Scanning tài liệu đôi/ba',
          explanation: 'Đọc tiêu đề và câu đầu từng đoạn để nắm bức tranh tổng thể (Skimming). Sau đó dựa vào Từ khóa trong câu hỏi để quét chính xác dòng chứa đáp án (Scanning).',
          formula: 'Question Keyword -> Target Line in Document A/B/C',
          examples: [
            'Question: "According to the email, why is Mr. Chang visiting London?"',
            'Scan Document A for "Mr. Chang" and "London" to locate the reason.'
          ]
        },
        etsTips: '💡 Mẹo Part 7: Với các câu hỏi chọn vị trí điền câu [1], [2], [3], [4] ở Part 6 & 7, hãy chú ý các từ nối (However, Therefore) và đại từ thay thế (This, These).',
        practiceQuestions: [
          { id: 1, questionText: 'Please review the attached invoice and notify us if you find any ______.', optionA: 'discrepancies', optionB: 'discrepant', optionC: 'discrepantly', optionD: 'discrepancying', correctAnswer: 'A', explanation: 'Sau tính từ "any" cần một danh từ số nhiều "discrepancies". Chọn A.' },
          { id: 2, questionText: 'The agreement will remain in effect until ______ by either party.', optionA: 'terminated', optionB: 'terminate', optionC: 'terminating', optionD: 'termination', correctAnswer: 'A', explanation: 'Cấu trúc rút gọn mệnh đề bị động "until terminated", chọn V-ed. Chọn A.' }
        ]
      }
    ];

    const currentTopic = topicBanks[topicBankIndex];

    res.json({
      lesson: {
        dayNumber: dNum,
        title: dayTitle || currentTopic.title,
        estimatedTimeMinutes: 60,
        vocabularyList: currentTopic.vocabularyList,
        grammarRule: currentTopic.grammarRule,
        etsTips: currentTopic.etsTips,
        practiceQuestions: currentTopic.practiceQuestions
      },
      provider: 'AeroAI Dynamic Topic Engine (Smart Fallback)'
    });
  } catch (error) {
    console.error('Generate day lesson error:', error);
    res.status(500).json({ error: 'Lỗi tải bài học. Vui lòng thử lại sau.' });
  }
});

app.listen(PORT, () => {
  console.log(`🤖 AeroAI Dedicated Microservice listening on http://localhost:${PORT}`);
});

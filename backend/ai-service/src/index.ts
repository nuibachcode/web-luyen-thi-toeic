import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import { defaultAIConfig, AIConfig } from './ai_config';

dotenv.config();

const app = express();
const PORT = Number(process.env.PORT || 4004);

app.use(cors());
app.use(express.json());

let currentAIConfig: AIConfig = { ...defaultAIConfig };

// Helper function to call Gemini API
async function callGeminiApi(prompt: string, apiKey: string, customSystemInstruction?: string) {
  const systemText = customSystemInstruction || currentAIConfig.systemInstruction;
  const payload = {
    systemInstruction: { parts: [{ text: systemText }] },
    contents: [{ parts: [{ text: prompt }] }]
  };

  // Try lite model first (faster), fallback to full flash
  const models = ['gemini-2.0-flash-lite-001', 'gemini-2.0-flash'];
  for (const model of models) {
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
  return null;
}

// Health Check
app.get('/health', (_req, res) => {
  const envKey = process.env.GEMINI_API_KEY;
  res.json({
    status: 'AI Service is running!',
    service: 'ai-service',
    port: PORT,
    gemini_api_configured: Boolean(envKey),
    key_source: envKey ? 'environment' : 'missing',
    specialization: currentAIConfig.specialization
  });
});

// GET /api/ai/config
app.get('/api/ai/config', (_req, res) => {
  res.json({ config: currentAIConfig });
});

// PUT /api/ai/config
app.put('/api/ai/config', (req, res) => {
  const { systemInstruction, specialization, maxIconsAllowed } = req.body;
  if (systemInstruction && typeof systemInstruction === 'string') currentAIConfig.systemInstruction = systemInstruction;
  if (specialization && typeof specialization === 'string') currentAIConfig.specialization = specialization;
  if (typeof maxIconsAllowed === 'number') currentAIConfig.maxIconsAllowed = maxIconsAllowed;
  res.json({ message: 'Cập nhật cấu hình AI thành công!', config: currentAIConfig });
});

// 1. AI Question Explanation & Vocabulary Extractor
app.post('/api/ai/explain', async (req, res) => {
  try {
    const { questionText, options, correctAnswer, explanation, passageText } = req.body;
    const apiKey = process.env.GEMINI_API_KEY || req.body.apiKey;

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

    // Fallback for explain only (non-critical)
    const parsedOptions = Array.isArray(options) ? options : [];
    const correctOpt = parsedOptions.find((o: any) => o.label === correctAnswer) || parsedOptions[0];
    res.json({
      ai: {
        translation: `Câu hỏi: "${questionText || ''}"`,
        whyCorrect: `Đáp án (${correctAnswer || correctOpt?.label || 'A'}) là chính xác. ${explanation || ''}`,
        vocabulary: [{ word: 'authorize', ipa: '/ˈɔː.θər.aɪz/', meaning: 'ủy quyền, cấp phép' }],
        trapWarning: 'Chú ý phân biệt từ đồng âm và các thì động từ thường gặp.'
      },
      provider: 'Fallback Engine'
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

    const apiKey = process.env.GEMINI_API_KEY || req.body.apiKey;
    if (!apiKey) return res.json({ reply: '🔑 AI chưa được cấu hình. Vui lòng liên hệ quản trị viên.', provider: 'Notice' });

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

    res.json({ reply: '⚠️ AI tạm thời không phản hồi. Bạn thử lại sau vài giây nhé!', provider: 'Notice' });
  } catch (error) {
    console.error('AI Chat error:', error);
    res.status(500).json({ error: 'AI Tutor failed' });
  }
});

// 3. AI Listening Transcript Generator
app.post('/api/ai/generate-transcript', async (req, res) => {
  try {
    const { part = 1, questions = [] } = req.body;
    const apiKey = process.env.GEMINI_API_KEY || req.body.apiKey;

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
    const apiKey = process.env.GEMINI_API_KEY || req.body.apiKey;
    if (!apiKey) return res.status(503).json({ error: 'AI chưa được cấu hình API Key.' });

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
    if (!aiText) return res.status(503).json({ error: 'AI không phản hồi. Vui lòng thử lại sau.' });

    const cleanJson = aiText.replace(/```json/g, '').replace(/```/g, '').trim();
    try {
      const parsed = JSON.parse(cleanJson);
      return res.json({ overview: parsed, provider: 'Google Gemini AI (Real-time)' });
    } catch (e) {
      console.warn('Overview JSON parse error:', e);
      return res.status(503).json({ error: 'AI trả về dữ liệu không hợp lệ. Vui lòng thử lại.' });
    }
  } catch (error) {
    console.error('Roadmap overview error:', error);
    res.status(500).json({ error: 'Lỗi tạo lộ trình. Vui lòng thử lại sau.' });
  }
});

// 5. On-Demand Daily Lesson Generator (60 Minutes Full Content)
app.post('/api/ai/generate-day-lesson', async (req, res) => {
  try {
    const { dayNumber, dayTitle, dayFocus, targetScore = 750, currentScore = 450 } = req.body;
    if (!dayNumber) return res.status(400).json({ error: 'dayNumber is required' });

    const apiKey = process.env.GEMINI_API_KEY || req.body.apiKey;
    if (!apiKey) return res.status(503).json({ error: 'AI chưa được cấu hình API Key.' });

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
    if (!aiText) return res.status(503).json({ error: 'AI không phản hồi. Vui lòng thử lại sau.' });

    const cleanJson = aiText.replace(/```json/g, '').replace(/```/g, '').trim();
    try {
      const parsed = JSON.parse(cleanJson);
      return res.json({ lesson: parsed, provider: 'Google Gemini AI (Real-time)' });
    } catch (e) {
      console.warn('Day Lesson JSON parse error:', e);
      return res.status(503).json({ error: 'AI trả về dữ liệu không hợp lệ. Vui lòng thử lại.' });
    }
  } catch (error) {
    console.error('Generate day lesson error:', error);
    res.status(500).json({ error: 'Lỗi tải bài học. Vui lòng thử lại sau.' });
  }
});

app.listen(PORT, () => {
  console.log(`🤖 AeroAI Dedicated Microservice listening on http://localhost:${PORT}`);
});

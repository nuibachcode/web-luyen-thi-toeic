import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import jwt from 'jsonwebtoken';
import { PrismaClient, Prisma } from '@prisma/client';

dotenv.config();

const app = express();
const port = Number(process.env.PORT || 4002);
const jwtSecret = process.env.JWT_SECRET || 'super-secret-toeic-key';
process.env.DATABASE_URL ||= `postgresql://${process.env.DB_USER || 'postgres'}:${process.env.DB_PASSWORD || 'password'}@${process.env.DB_HOST || 'localhost'}:${process.env.DB_PORT || '5432'}/${process.env.DB_NAME || 'postgres'}?schema=public`;
const prisma = new PrismaClient();

type AuthenticatedRequest = express.Request & { userId?: string };

app.use(cors());
app.use(express.json({ limit: '1mb' }));

function requireUser(req: AuthenticatedRequest, res: express.Response, next: express.NextFunction) {
  const token = req.header('authorization')?.replace(/^Bearer\s+/i, '');
  if (!token) return res.status(401).json({ error: 'Authentication required' });
  try {
    const payload = jwt.verify(token, jwtSecret) as { id?: string };
    if (!payload.id) return res.status(401).json({ error: 'Invalid token' });
    req.userId = payload.id;
    next();
  } catch {
    return res.status(401).json({ error: 'Invalid or expired token' });
  }
}

app.get('/health', async (_req, res) => {
  try { await prisma.examResult.findFirst({ select: { id: true } }); } catch {}
  res.json({ status: 'Exam Service is running' });
});

app.post('/api/exam-results', requireUser, async (req: AuthenticatedRequest, res) => {
  const { examCode, listeningCorrect, readingCorrect, answers } = req.body;
  if (typeof examCode !== 'string' || !Number.isInteger(listeningCorrect) || !Number.isInteger(readingCorrect) || !answers || typeof answers !== 'object') {
    return res.status(400).json({ error: 'Invalid exam result payload' });
  }
  if (listeningCorrect < 0 || listeningCorrect > 100 || readingCorrect < 0 || readingCorrect > 100) {
    return res.status(400).json({ error: 'Correct answers must be between 0 and 100' });
  }

  const listeningScore = Math.min(495, Math.max(5, Math.round(listeningCorrect * 4.95)));
  const readingScore = Math.min(495, Math.max(5, Math.round(readingCorrect * 4.95)));
  const result = await prisma.examResult.create({ data: { userId: req.userId!, examCode, listeningCorrect, readingCorrect, listeningScore, readingScore, totalScore: listeningScore + readingScore, answers: answers as Prisma.InputJsonValue } });
  res.status(201).json({ result });
});

app.get('/api/exam-results/me', requireUser, async (req: AuthenticatedRequest, res) => {
  const results = await prisma.examResult.findMany({ where: { userId: req.userId }, orderBy: { submittedAt: 'desc' } });
  res.json({ results });
});

// Student personal analytics endpoint
app.get('/api/exam-results/analytics/me', requireUser, async (req: AuthenticatedRequest, res) => {
  try {
    const results = await prisma.examResult.findMany({ where: { userId: req.userId }, orderBy: { submittedAt: 'desc' } });
    if (!results.length) {
      return res.json({
        totalTests: 0,
        highestScore: 450,
        latestScore: 450,
        listeningAccuracy: 60,
        readingAccuracy: 55,
        targetScore: 750,
        streakDays: 1,
        results: []
      });
    }

    const highestScore = Math.max(...results.map(r => r.totalScore));
    const latestScore = results[0].totalScore;
    const avgListeningCorrect = results.reduce((acc, r) => acc + r.listeningCorrect, 0) / results.length;
    const avgReadingCorrect = results.reduce((acc, r) => acc + r.readingCorrect, 0) / results.length;

    res.json({
      totalTests: results.length,
      highestScore,
      latestScore,
      listeningAccuracy: Math.round(avgListeningCorrect),
      readingAccuracy: Math.round(avgReadingCorrect),
      targetScore: 750,
      streakDays: Math.min(14, results.length * 3 + 2),
      results
    });
  } catch (err) {
    console.error('Analytics error:', err);
    res.status(500).json({ error: 'Failed to compute analytics' });
  }
});

// Tenant manager analytics endpoint (for Manager Dashboard)
app.get('/api/exam-results/analytics/tenant-summary', async (req, res) => {
  try {
    const allResults = await prisma.examResult.findMany({ orderBy: { submittedAt: 'desc' }, take: 100 });
    
    // Group by userId to find highest score per student
    const studentMap: Record<string, { userId: string; highestScore: number; done: number; latestDate: Date }> = {};
    for (const r of allResults) {
      if (!studentMap[r.userId]) {
        studentMap[r.userId] = { userId: r.userId, highestScore: r.totalScore, done: 1, latestDate: r.submittedAt };
      } else {
        studentMap[r.userId].highestScore = Math.max(studentMap[r.userId].highestScore, r.totalScore);
        studentMap[r.userId].done += 1;
      }
    }

    const avgScore = allResults.length > 0
      ? Math.round(allResults.reduce((sum, r) => sum + r.totalScore, 0) / allResults.length)
      : 0;

    const avgListening = allResults.length > 0
      ? Math.min(100, Math.round((allResults.reduce((sum, r) => sum + r.listeningScore, 0) / (allResults.length * 495)) * 100))
      : 0;

    const avgReading = allResults.length > 0
      ? Math.min(100, Math.round((allResults.reduce((sum, r) => sum + r.readingScore, 0) / (allResults.length * 495)) * 100))
      : 0;

    const recentActivities = allResults.map(r => ({
      id: r.id,
      userId: r.userId,
      examCode: r.examCode,
      totalScore: r.totalScore,
      listeningScore: r.listeningScore,
      readingScore: r.readingScore,
      submittedAt: r.submittedAt
    }));

    res.json({
      totalAttempts: allResults.length,
      avgScore,
      avgListening,
      avgReading,
      studentsCount: Object.keys(studentMap).length,
      studentStats: Object.values(studentMap),
      recentActivities
    });
  } catch (err) {
    console.error('Tenant summary error:', err);
    res.status(500).json({ error: 'Failed to compute tenant summary' });
  }
});

// Serve full exam with questions from exam-db (proper microservice endpoint)
app.get('/api/exams/:code', async (req, res) => {
  try {
    const { code } = req.params;
    const questions = await prisma.question.findMany({
      where: { examCode: code },
      orderBy: { questionNumber: 'asc' },
      select: {
        id: true, examCode: true, questionNumber: true, part: true, section: true,
        questionText: true, optionA: true, optionB: true, optionC: true, optionD: true,
        correctAnswer: true, explanationVi: true, explanationEn: true,
        audioUrl: true, imageUrl: true,
        passageId: true, passageText: true, passageAudio: true, passageImage: true,
        tuVung: true,
      },
    });
    if (!questions.length) return res.status(404).json({ error: 'Exam not found in exam-service' });

    // Group passage info by passageId for deduplication
    const passageMap: Record<string, { audio_url: string; image_url: string; passage_text: string }> = {};
    for (const q of questions) {
      if (q.passageId && !passageMap[q.passageId]) {
        passageMap[q.passageId] = {
          audio_url: q.passageAudio || '',
          image_url: q.passageImage || '',
          passage_text: q.passageText || '',
        };
      }
    }

    // Normalize to the shape TestPlayer.tsx expects
    const normalized = questions.map(q => ({
      id: q.id,
      test_id: code,
      part: q.part,
      section: q.section || (q.part <= 4 ? 'listening' : 'reading'),
      question_number: q.questionNumber,
      question_text: q.questionText || '',
      option_a: q.optionA || '',
      option_b: q.optionB || '',
      option_c: q.optionC || '',
      option_d: q.optionD || '',
      correct_answer: q.correctAnswer || '',
      explanation_vi: q.explanationVi || '',
      explanation_en: q.explanationEn || '',
      audio_url: q.audioUrl || '',
      image_url: q.imageUrl || '',
      passage_id: q.passageId || null,
      passage_text: q.passageText || '',
      tu_vung: q.tuVung,
      passage: q.passageId ? {
        id: q.passageId,
        audio_url: q.passageAudio || '',
        image_url: q.passageImage || '',
        passage_text: q.passageText || '',
      } : null,
    }));

    res.json({
      exam: {
        code,
        title: `TOEIC Practice Test ${code.replace('toeic-test-', '')}`,
        durationMinutes: 120,
        questions: normalized,
      }
    });
  } catch (err) {
    console.error('Error fetching exam questions:', err);
    res.status(500).json({ error: 'Failed to load exam questions' });
  }
});

// AI Student Profile Management (Per-student persistent memory)
app.get('/api/exam-results/ai-profile', async (req, res) => {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader) return res.status(401).json({ error: 'Authorization header required' });
    const token = authHeader.split(' ')[1];
    const decoded = jwt.verify(token, jwtSecret) as { id: string };

    let profile = await prisma.aiStudentProfile.findUnique({
      where: { userId: decoded.id }
    });

    const history = await prisma.examResult.findMany({
      where: { userId: decoded.id },
      orderBy: { submittedAt: 'desc' },
      take: 20
    });

    res.json({
      profile: profile || null,
      history
    });
  } catch (error) {
    console.error('Error fetching student AI profile:', error);
    res.status(500).json({ error: 'Failed to fetch AI student profile' });
  }
});

app.post('/api/exam-results/ai-profile', async (req, res) => {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader) return res.status(401).json({ error: 'Authorization header required' });
    const token = authHeader.split(' ')[1];
    const decoded = jwt.verify(token, jwtSecret) as { id: string };

    const { targetScore, durationDays, activeRoadmap, dailyLessonsCache, dailyQuizResults, completedTaskKeys } = req.body;

    const profile = await prisma.aiStudentProfile.upsert({
      where: { userId: decoded.id },
      update: {
        ...(targetScore !== undefined ? { targetScore } : {}),
        ...(durationDays !== undefined ? { durationDays } : {}),
        ...(activeRoadmap !== undefined ? { activeRoadmap } : {}),
        ...(dailyLessonsCache !== undefined ? { dailyLessonsCache } : {}),
        ...(dailyQuizResults !== undefined ? { dailyQuizResults } : {}),
        ...(completedTaskKeys !== undefined ? { completedTaskKeys } : {}),
      },
      create: {
        userId: decoded.id,
        targetScore: targetScore || 750,
        durationDays: durationDays || 30,
        activeRoadmap: activeRoadmap || null,
        dailyLessonsCache: dailyLessonsCache || null,
        dailyQuizResults: dailyQuizResults || null,
        completedTaskKeys: completedTaskKeys || null,
      }
    });

    res.json({ profile });
  } catch (error) {
    console.error('Error updating student AI profile:', error);
    res.status(500).json({ error: 'Failed to update AI student profile' });
  }
});

// Manager/Admin endpoints for Question Management & cURL Importer
app.get('/api/admin/exams/:code/questions', async (req, res) => {
  try {
    const questions = await prisma.question.findMany({
      where: { examCode: req.params.code },
      orderBy: { questionNumber: 'asc' }
    });
    res.json({ questions });
  } catch (err) {
    console.error('Error fetching admin questions:', err);
    res.status(500).json({ error: 'Failed to load questions' });
  }
});

app.put('/api/admin/exams/:code/questions/:questionNumber', async (req, res) => {
  try {
    const { code, questionNumber } = req.params;
    const qNum = parseInt(questionNumber, 10);
    const {
      questionText, optionA, optionB, optionC, optionD,
      correctAnswer, explanationVi, audioUrl, imageUrl, passageText, part
    } = req.body;

    const existing = await prisma.question.findFirst({
      where: { examCode: code, questionNumber: qNum }
    });

    if (existing) {
      const updated = await prisma.question.update({
        where: { id: existing.id },
        data: {
          ...(questionText !== undefined ? { questionText } : {}),
          ...(optionA !== undefined ? { optionA } : {}),
          ...(optionB !== undefined ? { optionB } : {}),
          ...(optionC !== undefined ? { optionC } : {}),
          ...(optionD !== undefined ? { optionD } : {}),
          ...(correctAnswer !== undefined ? { correctAnswer } : {}),
          ...(explanationVi !== undefined ? { explanationVi } : {}),
          ...(audioUrl !== undefined ? { audioUrl } : {}),
          ...(imageUrl !== undefined ? { imageUrl } : {}),
          ...(passageText !== undefined ? { passageText } : {}),
          ...(part !== undefined ? { part: Number(part) } : {}),
        }
      });
      return res.json({ message: `Cập nhật câu ${qNum} thành công`, question: updated });
    } else {
      const created = await prisma.question.create({
        data: {
          examCode: code,
          questionNumber: qNum,
          part: Number(part) || (qNum <= 6 ? 1 : qNum <= 31 ? 2 : qNum <= 70 ? 3 : qNum <= 100 ? 4 : qNum <= 130 ? 5 : qNum <= 146 ? 6 : 7),
          section: (Number(part) || qNum) <= 100 ? 'listening' : 'reading',
          questionText: questionText || '',
          optionA: optionA || '',
          optionB: optionB || '',
          optionC: optionC || '',
          optionD: optionD || '',
          correctAnswer: correctAnswer || 'A',
          explanationVi: explanationVi || '',
          audioUrl: audioUrl || '',
          imageUrl: imageUrl || '',
          passageText: passageText || '',
        }
      });
      return res.status(201).json({ message: `Tạo mới câu ${qNum} thành công`, question: created });
    }
  } catch (err) {
    console.error('Error saving question:', err);
    res.status(500).json({ error: 'Không thể lưu câu hỏi' });
  }
});

app.post('/api/admin/exams/:code/batch-questions', async (req, res) => {
  try {
    const { code } = req.params;
    const { questions } = req.body;
    if (!Array.isArray(questions)) return res.status(400).json({ error: 'Mảng câu hỏi (questions) là bắt buộc' });

    let savedCount = 0;
    for (const q of questions) {
      const qNum = Number(q.questionNumber || q.question_number);
      if (!qNum) continue;

      const existing = await prisma.question.findFirst({
        where: { examCode: code, questionNumber: qNum }
      });

      const partNum = Number(q.part) || (qNum <= 6 ? 1 : qNum <= 31 ? 2 : qNum <= 70 ? 3 : qNum <= 100 ? 4 : qNum <= 130 ? 5 : qNum <= 146 ? 6 : 7);

      if (existing) {
        await prisma.question.update({
          where: { id: existing.id },
          data: {
            part: partNum,
            section: q.section || (partNum <= 4 ? 'listening' : 'reading'),
            questionText: q.questionText || q.question_text || '',
            optionA: q.optionA || q.option_a || '',
            optionB: q.optionB || q.option_b || '',
            optionC: q.optionC || q.option_c || '',
            optionD: q.optionD || q.option_d || '',
            correctAnswer: q.correctAnswer || q.correct_answer || 'A',
            explanationVi: q.explanationVi || q.explanation_vi || '',
            audioUrl: q.audioUrl || q.audio_url || '',
            imageUrl: q.imageUrl || q.image_url || '',
            passageText: q.passageText || q.passage_text || '',
          }
        });
      } else {
        await prisma.question.create({
          data: {
            examCode: code,
            questionNumber: qNum,
            part: partNum,
            section: q.section || (partNum <= 4 ? 'listening' : 'reading'),
            questionText: q.questionText || q.question_text || '',
            optionA: q.optionA || q.option_a || '',
            optionB: q.optionB || q.option_b || '',
            optionC: q.optionC || q.option_c || '',
            optionD: q.optionD || q.option_d || '',
            correctAnswer: q.correctAnswer || q.correct_answer || 'A',
            explanationVi: q.explanationVi || q.explanation_vi || '',
            audioUrl: q.audioUrl || q.audio_url || '',
            imageUrl: q.imageUrl || q.image_url || '',
            passageText: q.passageText || q.passage_text || '',
          }
        });
      }
      savedCount++;
    }

    res.json({ message: `Đã lưu thành công ${savedCount} câu hỏi cho đề thi ${code}` });
  } catch (err) {
    console.error('Batch questions save error:', err);
    res.status(500).json({ error: 'Lỗi lưu danh sách câu hỏi' });
  }
});

// AI Automatic Question & Option Enricher for Imported Exams
app.post('/api/admin/exams/:code/ai-enrich-questions', async (req, res) => {
  try {
    const { code } = req.params;
    const apiKey = req.body.apiKey || process.env.GEMINI_API_KEY || '';

    const questions = await prisma.question.findMany({
      where: { examCode: code },
      orderBy: { questionNumber: 'asc' }
    });

    if (!questions.length) return res.status(404).json({ error: 'Không tìm thấy câu hỏi cho mã đề này' });

    // Group questions by passageId or by chunks
    const passageGroups: Record<string, typeof questions> = {};
    const singleQs: typeof questions = [];

    for (const q of questions) {
      if (q.passageId && q.passageText && q.passageText.trim().length > 10) {
        passageGroups[q.passageId] = passageGroups[q.passageId] || [];
        passageGroups[q.passageId].push(q);
      } else {
        singleQs.push(q);
      }
    }

    let updatedCount = 0;

    // Enrich Passage-based Questions (Part 3, 4, 6, 7)
    for (const [pasId, group] of Object.entries(passageGroups)) {
      const qNums = group.map(g => g.questionNumber).join(', ');
      const pasText = group[0].passageText || '';
      const partNum = group[0].part;

      const prompt = `Bạn là Chuyên gia Biên soạn Đề thi TOEIC ETS. Dựa vào đoạn văn/hội thoại TOEIC Part ${partNum} sau:

"${pasText}"

Hãy tự động biên soạn nội dung câu hỏi trắc nghiệm tiếng Anh chi tiết (kèm 4 lựa chọn A, B, C, D và lời giải tiếng Việt) bám sát nội dung đoạn văn trên cho các câu số: ${qNums}.

Trả về duy nhất JSON hợp lệ (không chứa markdown codeblock):
[
  {
    "questionNumber": ${group[0].questionNumber},
    "questionText": "What is the main topic of the text?",
    "optionA": "A. Option A",
    "optionB": "B. Option B",
    "optionC": "C. Option C",
    "optionD": "D. Option D",
    "correctAnswer": "${group[0].correctAnswer || 'A'}",
    "explanationVi": "Lời giải tiếng Việt chi tiết..."
  }
]`;

      try {
        const aiUrl = `https://generativelanguage.googleapis.com/v1beta/models/gemini-flash-lite-latest:generateContent?key=${apiKey}`;
        const aiRes = await fetch(aiUrl, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ contents: [{ parts: [{ text: prompt }] }] })
        });

        if (aiRes.ok) {
          const data = await aiRes.json();
          const rawText = data.candidates?.[0]?.content?.parts?.[0]?.text || '';
          const cleanText = rawText.replace(/```json/gi, '').replace(/```/g, '').trim();
          let parsed: any[] = [];
          try {
            parsed = JSON.parse(cleanText);
          } catch (pe) {
            const start = cleanText.indexOf('[');
            const end = cleanText.lastIndexOf(']');
            if (start !== -1 && end > start) {
              parsed = JSON.parse(cleanText.slice(start, end + 1));
            }
          }

          if (Array.isArray(parsed)) {
            for (const item of parsed) {
              const matchingQ = group.find(g => g.questionNumber === Number(item.questionNumber));
              if (matchingQ) {
                await prisma.question.update({
                  where: { id: matchingQ.id },
                  data: {
                    questionText: item.questionText || matchingQ.questionText,
                    optionA: item.optionA || matchingQ.optionA,
                    optionB: item.optionB || matchingQ.optionB,
                    optionC: item.optionC || matchingQ.optionC,
                    optionD: item.optionD || matchingQ.optionD,
                    explanationVi: item.explanationVi || matchingQ.explanationVi
                  }
                });
                updatedCount++;
              }
            }
          }
        }
      } catch (err) {
        console.warn(`AI Enrich error for passage ${pasId}:`, (err as Error).message);
      }
    }

    res.json({ message: `AI đã tự động phân tích bài đọc & bổ sung nội dung cho ${updatedCount} câu hỏi!`, updatedCount });
  } catch (err) {
    console.error('AI enrich questions error:', err);
    res.status(500).json({ error: 'Lỗi AI tự động điền câu hỏi' });
  }
});

// Import Exam from cURL (Supabase REST / RPC or raw JSON)
app.post('/api/admin/exams/import-curl', async (req, res) => {
  try {
    const { curlInput, targetExamCode, targetExamTitle } = req.body;
    if (!curlInput || typeof curlInput !== 'string') {
      return res.status(400).json({ error: 'Chuỗi cURL (curlInput) là bắt buộc' });
    }

    const trimmedInput = curlInput.trim();

    // Check if user pasted raw JSON directly
    let rawJsonItems: any[] | null = null;
    if (trimmedInput.startsWith('[') || trimmedInput.startsWith('{')) {
      try {
        const parsed = JSON.parse(trimmedInput);
        rawJsonItems = Array.isArray(parsed) ? parsed : (parsed.questions || parsed.data || null);
      } catch (e) {
        // Not valid raw JSON, continue to cURL parser
      }
    }

    let items: any[] = [];
    let defaultCode = targetExamCode || 'ets-imported-test';

    if (rawJsonItems && Array.isArray(rawJsonItems)) {
      items = rawJsonItems;
    } else {
      // Clean multi-line backslashes and normalize space
      const cleanInput = trimmedInput.replace(/\\\r?\n/g, ' ').replace(/\s+/g, ' ');

      // Parse Target URL
      const urlMatch = cleanInput.match(/curl\s+(?:-[A-Za-z0-9]+\s+)*['"]?([^'\s]+)['"]?/i);
      if (!urlMatch) {
        return res.status(400).json({ error: 'Không tìm thấy đường dẫn URL hợp lệ trong câu lệnh cURL.' });
      }
      const targetUrl = urlMatch[1];

      // Parse Headers
      const headers: Record<string, string> = {
        'content-type': 'application/json',
        'origin': 'https://dautoeic.com',
        'referer': 'https://dautoeic.com/'
      };

      const headerRegex = /-H\s+['"]([^'"]+?)['"]/gi;
      let hMatch;
      while ((hMatch = headerRegex.exec(cleanInput)) !== null) {
        const colonIdx = hMatch[1].indexOf(':');
        if (colonIdx > 0) {
          const key = hMatch[1].substring(0, colonIdx).trim().toLowerCase();
          const val = hMatch[1].substring(colonIdx + 1).trim();
          headers[key] = val;
        }
      }

      // Parse Body Data
      let bodyData: any = null;
      const dataMatch = cleanInput.match(/(?:--data-raw|-d)\s+['"]({[\s\S]+?})['"]/i);
      if (dataMatch) {
        try {
          bodyData = JSON.parse(dataMatch[1]);
          if (bodyData?.p_test_id) {
            defaultCode = `toeic-${bodyData.p_test_id.substring(0, 8)}`;
          }
        } catch (e) {
          console.warn('Failed to parse cURL body JSON:', e);
        }
      }

      const isPost = Boolean(bodyData) || /RPC/i.test(targetUrl) || /--data/i.test(cleanInput);

      // Execute HTTP Fetch
      const response = await fetch(targetUrl, {
        method: isPost ? 'POST' : 'GET',
        headers,
        ...(bodyData ? { body: JSON.stringify(bodyData) } : {})
      });

      const responseText = await response.text();

      if (responseText.trim().startsWith('<')) {
        return res.status(400).json({
          error: '⚠️ Máy chủ Supabase trả về trang HTML bảo mật thay vì dữ liệu JSON. Nguyên nhân do Token xác thực trong cURL đã hết hạn. Hãy mở F12 trên dautoeic.com và copy lại câu lệnh cURL mới nhất!'
        });
      }

      if (!response.ok) {
        return res.status(400).json({ error: `Gọi API cURL thất bại (${response.status}): ${responseText}` });
      }

      let parsedJson: any = null;
      try {
        parsedJson = JSON.parse(responseText);
      } catch (e) {
        return res.status(400).json({ error: 'Dữ liệu API trả về không phải định dạng JSON hợp lệ.' });
      }

      items = Array.isArray(parsedJson) ? parsedJson : (parsedJson.questions || parsedJson.data || []);

      // If Supabase RPC was called, fetch passages and enrich items with media and text
      const testId = bodyData?.p_test_id || targetUrl.match(/id=eq\.([a-f0-9-]+)/i)?.[1];
      if (testId && headers['apikey']) {
        try {
          const supabaseHost = targetUrl.match(/https:\/\/[^/]+/)?.[0] || 'https://qfhmnlvgweznzcsoijyr.supabase.co';
          const subHeaders = {
            'apikey': headers['apikey'],
            ...(headers['authorization'] ? { 'authorization': headers['authorization'] } : {}),
            'content-type': 'application/json'
          };

          const pRes = await fetch(`${supabaseHost}/rest/v1/mock_test_passages?select=*&test_id=eq.${testId}`, { headers: subHeaders });
          let passages: any[] = [];
          if (pRes.ok) {
            passages = await pRes.json().catch(() => []);
          }

          const passageMap: Record<string, any> = {};
          if (Array.isArray(passages)) {
            passages.forEach(p => { passageMap[p.id] = p; });
          }

          // Enrich items with passage media & text
          items = items.map((q: any) => {
            const pas = q.passage_id ? passageMap[q.passage_id] : null;

            let rawAudio = q.audio_url || pas?.audio_url || '';
            if (rawAudio && !rawAudio.startsWith('http')) {
              rawAudio = `https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/${rawAudio}`;
            }

            let rawImg = q.image_url || pas?.image_url || '';
            if (rawImg && !rawImg.startsWith('http')) {
              rawImg = `https://qfhmnlvgweznzcsoijyr.supabase.co/storage/v1/object/public/mock-test-media/${rawImg}`;
            }

            const pasText = pas?.passage_text || pas?.transcript || pas?.passage_text_2 || pas?.passage_text_3 || q.passage_text || '';

            return {
              ...q,
              passage_id: q.passage_id || pas?.id || (pasText ? `pas-${q.part}-${q.question_number}` : null),
              audio_url: rawAudio,
              image_url: rawImg,
              passage_audio: rawAudio,
              passage_image: rawImg,
              passage_text: pasText
            };
          });
        } catch (subErr) {
          console.warn('Supabase passages fetch error:', subErr);
        }
      }
    }

    if (!Array.isArray(items) || items.length === 0) {
      return res.status(400).json({ error: 'Không tìm thấy mảng câu hỏi trong dữ liệu cURL.' });
    }

    const examCode = (targetExamCode || defaultCode).toLowerCase().replace(/[^a-z0-9-]/g, '');
    let count = 0;

    for (let i = 0; i < items.length; i++) {
      const item = items[i];
      const qNum = Number(item.question_number || item.questionNumber || i + 1);
      const partNum = Number(item.part) || (qNum <= 6 ? 1 : qNum <= 31 ? 2 : qNum <= 70 ? 3 : qNum <= 100 ? 4 : qNum <= 130 ? 5 : qNum <= 146 ? 6 : 7);

      const existing = await prisma.question.findFirst({
        where: { examCode, questionNumber: qNum }
      });

      // Default ETS Structured Question Text & Options if missing from RPC metadata
      let defaultQText = '';
      let defaultOptA = 'A. Statement (A)';
      let defaultOptB = 'B. Statement (B)';
      let defaultOptC = 'C. Statement (C)';
      let defaultOptD = 'D. Statement (D)';

      if (partNum === 1) {
        defaultQText = `Look at the picture marked No. ${qNum} in your test book and select the statement that best describes what you see in the picture.`;
      } else if (partNum === 2) {
        defaultQText = `Listen to the question or statement No. ${qNum} and select the best response from options (A), (B), or (C).`;
        defaultOptA = 'A. Response (A)';
        defaultOptB = 'B. Response (B)';
        defaultOptC = 'C. Response (C)';
        defaultOptD = '';
      } else if (partNum === 3) {
        defaultQText = `Refer to the conversation transcript and answer question No. ${qNum}.`;
        defaultOptA = 'A. Option (A)'; defaultOptB = 'B. Option (B)'; defaultOptC = 'C. Option (C)'; defaultOptD = 'D. Option (D)';
      } else if (partNum === 4) {
        defaultQText = `Refer to the talk transcript and answer question No. ${qNum}.`;
        defaultOptA = 'A. Option (A)'; defaultOptB = 'B. Option (B)'; defaultOptC = 'C. Option (C)'; defaultOptD = 'D. Option (D)';
      } else if (partNum === 5) {
        defaultQText = `Select the best word or phrase to complete sentence No. ${qNum}.`;
        defaultOptA = 'A. Option (A)'; defaultOptB = 'B. Option (B)'; defaultOptC = 'C. Option (C)'; defaultOptD = 'D. Option (D)';
      } else if (partNum === 6) {
        defaultQText = `Refer to the text passage and select the best word or phrase for blank No. ${qNum}.`;
        defaultOptA = 'A. Option (A)'; defaultOptB = 'B. Option (B)'; defaultOptC = 'C. Option (C)'; defaultOptD = 'D. Option (D)';
      } else {
        defaultQText = `According to the text passage, select the correct answer for question No. ${qNum}.`;
        defaultOptA = 'A. Option (A)'; defaultOptB = 'B. Option (B)'; defaultOptC = 'C. Option (C)'; defaultOptD = 'D. Option (D)';
      }

      const qData = {
        examCode,
        questionNumber: qNum,
        part: partNum,
        section: item.section || (partNum <= 4 ? 'listening' : 'reading'),
        questionText: item.question_text || item.questionText || defaultQText,
        optionA: item.option_a || item.optionA || defaultOptA,
        optionB: item.option_b || item.optionB || defaultOptB,
        optionC: item.option_c || item.optionC || defaultOptC,
        optionD: item.option_d || item.optionD || defaultOptD,
        correctAnswer: item.correct_answer || item.correctAnswer || 'A',
        explanationVi: item.explanation_vi || item.explanationVi || item.dich_nghia || '',
        audioUrl: item.audio_url || item.audioUrl || '',
        imageUrl: item.image_url || item.imageUrl || '',
        passageId: item.passage_id || item.passageId || '',
        passageText: item.passage_text || item.passageText || '',
        passageAudio: item.passage_audio || item.passageAudio || item.audio_url || '',
        passageImage: item.passage_image || item.passageImage || item.image_url || '',
        tuVung: item.tu_vung || null,
      };

      if (existing) {
        await prisma.question.update({ where: { id: existing.id }, data: qData });
      } else {
        await prisma.question.create({ data: qData });
      }
      count++;
    }

    res.json({
      message: `Đã tự động nhập thành công trọn bộ ${count} câu hỏi (đã gộp đoạn văn & file nghe/ảnh) vào CSDL cho đề ${examCode}`,
      examCode,
      totalQuestions: count
    });
  } catch (err: any) {
    console.error('Import cURL error:', err);
    res.status(500).json({ error: `Lỗi bóc tách cURL: ${err.message}` });
  }
});

app.listen(port, () => {
  console.log(`Exam Service listening on port ${port}`);
  prisma.$connect()
    .then(() => console.log('Prisma connected to Database successfully'))
    .catch((error) => console.error('Could not initialize exam-service database:', error));
});

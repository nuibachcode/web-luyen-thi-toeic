import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import jwt from 'jsonwebtoken';
import { PrismaClient } from '@prisma/client';

dotenv.config();
const app = express();
const port = Number(process.env.PORT || 4003);
const jwtSecret = process.env.JWT_SECRET || 'super-secret-toeic-key';
process.env.DATABASE_URL ||= `postgresql://${process.env.DB_USER || 'postgres'}:${process.env.DB_PASSWORD || 'password'}@${process.env.DB_HOST || 'localhost'}:${process.env.DB_PORT || '5432'}/${process.env.DB_NAME || 'postgres'}?schema=public`;
const prisma = new PrismaClient();
type AuthRequest = express.Request & { user?: { id: string; role: string } };

app.use(cors());
app.use(express.json({ limit: '15mb' }));

async function seedDefaultExams() {
  try {
    const count = await prisma.exam.count();
    if (count === 0) {
      const defaultExams = [
        { code: 'toeic-test-01', title: 'TOEIC ETS 2024 - Test 01', description: 'Đề thi thử TOEIC ETS 2024 chuẩn cấu trúc 200 câu Listening & Reading', durationMinutes: 120, status: 'PUBLISHED', createdBy: 'system' },
        { code: 'toeic-test-02', title: 'TOEIC ETS 2024 - Test 02', description: 'Đề luyện tập chuyên sâu Part 1-7 ETS 2024', durationMinutes: 120, status: 'PUBLISHED', createdBy: 'system' },
        { code: 'toeic-test-03', title: 'TOEIC ETS 2023 - Test 01', description: 'Bộ đề thi ETS 2023 thực chiến cập nhật mới nhất', durationMinutes: 120, status: 'PUBLISHED', createdBy: 'system' },
        { code: 'ets-imported-test', title: 'TOEIC ETS Thực Chiến 990+', description: 'Đề thi bứt phá điểm số cao cấp tích hợp cURL Importer', durationMinutes: 120, status: 'PUBLISHED', createdBy: 'system' }
      ];
      for (const e of defaultExams) {
        await prisma.exam.create({ data: e });
      }
      console.log('Seeded default TOEIC practice exams into Catalog database');
    }
  } catch (err) {
    console.warn('Seed default exams notice:', err);
  }
}

function requireManagerOrAdmin(req: AuthRequest, res: express.Response, next: express.NextFunction) {
  const token = req.header('authorization')?.replace(/^Bearer\s+/i, '');
  if (!token) return res.status(401).json({ error: 'Authentication required' });
  try {
    const payload = jwt.verify(token, jwtSecret) as { id?: string; role?: string };
    if (!payload.id || (payload.role !== 'SUPERADMIN' && payload.role !== 'MANAGER')) {
      return res.status(403).json({ error: 'Manager or Administrator access required' });
    }
    req.user = { id: payload.id, role: payload.role };
    next();
  } catch { return res.status(401).json({ error: 'Invalid or expired token' }); }
}

app.get('/health', async (_req, res) => { await prisma.exam.findFirst({ select: { id: true } }); res.json({ status: 'Catalog Service is running' }); });

app.get('/api/exams', async (_req, res) => {
  const exams = await prisma.exam.findMany({ where: { status: 'PUBLISHED' }, orderBy: { createdAt: 'desc' }, select: { code: true, title: true, description: true, durationMinutes: true } });
  res.json({ exams: exams.map((exam: any) => ({ ...exam, duration_minutes: exam.durationMinutes, question_count: 200 })) });
});

app.get('/api/exams/:code', async (req, res) => {
  const exam = await prisma.exam.findFirst({ where: { code: req.params.code, status: 'PUBLISHED' }, select: { code: true, title: true, description: true, durationMinutes: true } });
  if (!exam) return res.status(404).json({ error: 'Exam not found' });
  res.json({ exam: { ...exam, duration_minutes: exam.durationMinutes, question_count: 200 } });
});

app.get('/api/admin/exams', requireManagerOrAdmin, async (_req, res) => {
  const exams = await prisma.exam.findMany({ orderBy: { updatedAt: 'desc' }, select: { code: true, title: true, durationMinutes: true, status: true, questions: true, updatedAt: true } });
  res.json({ exams: exams.map((exam: any) => ({ ...exam, duration_minutes: exam.durationMinutes, question_count: Array.isArray(exam.questions) ? exam.questions.length : 200, updated_at: exam.updatedAt })) });
});

app.post('/api/admin/exams', requireManagerOrAdmin, async (req: AuthRequest, res) => {
  const { code, title, description = '', durationMinutes = 120, status = 'PUBLISHED', questions = [] } = req.body;
  if (!/^[a-z0-9-]+$/i.test(code || '') || typeof title !== 'string' || !Number.isInteger(durationMinutes) || durationMinutes < 1 || !['DRAFT', 'PUBLISHED'].includes(status)) {
    return res.status(400).json({ error: 'Payload không hợp lệ. Mã đề thi (code), tiêu đề (title), thời gian thi là bắt buộc.' });
  }
  const exam = await prisma.exam.upsert({
    where: { code },
    create: { code, title: title.trim(), description, durationMinutes, status, questions: questions as any, createdBy: req.user!.id },
    update: { title: title.trim(), description, durationMinutes, status, ...(Array.isArray(questions) && questions.length > 0 ? { questions: questions as any } : {}) }
  });
  res.status(201).json({ message: 'Lưu đề thi thành công', exam: { ...exam, duration_minutes: exam.durationMinutes } });
});

app.delete('/api/admin/exams/:code', requireManagerOrAdmin, async (req, res) => {
  try {
    const examCode = Array.isArray(req.params.code) ? req.params.code[0] : req.params.code;
    await prisma.exam.delete({ where: { code: String(examCode) } });
    res.json({ message: 'Đã xóa đề thi thành công' });
  } catch (err: any) {
    res.status(500).json({ error: 'Không thể xóa đề thi' });
  }
});

app.listen(port, () => {
  console.log(`Catalog Service listening on port ${port}`);
  prisma.$connect()
    .then(async () => {
      console.log('Prisma connected to Database successfully');
      await seedDefaultExams();
    })
    .catch((error: any) => console.error('Could not connect catalog-service database:', error));
});

import fs from 'fs';
import path from 'path';
import dotenv from 'dotenv';
import { PrismaClient } from '@prisma/client';

dotenv.config();

// Hỗ trợ tự động nhận diện Docker DB (port 5434) hoặc Standard Postgres (port 5432)
if (!process.env.DATABASE_URL) {
  const host = process.env.DB_HOST || 'localhost';
  const user = process.env.EXAM_DB_USER || process.env.DB_USER || 'toeic_exam';
  const pass = process.env.EXAM_DB_PASSWORD || process.env.DB_PASSWORD || 'change-me-exam';
  const port = process.env.DB_PORT || '5434';
  const db = process.env.DB_NAME || 'toeic_exam';
  process.env.DATABASE_URL = `postgresql://${user}:${pass}@${host}:${port}/${db}?schema=public`;
}
const prisma = new PrismaClient();

async function seedExamQuestions() {
  console.log('🚀 Bắt đầu nạp dữ liệu đề thi vào exam-service...');
  console.log(`🔗 Database URL: ${process.env.DATABASE_URL.replace(/:[^:@]+@/, ':****@')}`);

  // Tìm thư mục seeds/exams
  const possiblePaths = [
    path.join(__dirname, '../../../seeds/exams'),
    path.join(__dirname, '../../seeds/exams'),
    path.join(__dirname, '../seeds/exams'),
    path.join(process.cwd(), 'seeds/exams'),
    path.join(process.cwd(), '../seeds/exams')
  ];

  let examsDir = possiblePaths.find(p => fs.existsSync(p));
  if (!examsDir) {
    console.error('❌ Không tìm thấy thư mục seeds/exams. Đang tìm kiếm...');
    return;
  }

  const files = fs.readdirSync(examsDir).filter(f => f.endsWith('.json')).sort();
  console.log(`📂 Tìm thấy ${files.length} file đề thi trong thư mục: ${examsDir}`);

  let totalQuestionsInserted = 0;

  for (const file of files) {
    const filePath = path.join(examsDir, file);
    const examCode = file.replace('.json', '');
    const rawContent = fs.readFileSync(filePath, 'utf-8');
    const questions: any[] = JSON.parse(rawContent);

    console.log(`\n⏳ Đang nạp đề: ${examCode} (${questions.length} câu hỏi)...`);

    for (const q of questions) {
      const qNum = Number(q.question_number || q.questionNumber);
      if (!qNum) continue;

      const partNum = Number(q.part) || (qNum <= 6 ? 1 : qNum <= 31 ? 2 : qNum <= 70 ? 3 : qNum <= 100 ? 4 : qNum <= 130 ? 5 : qNum <= 146 ? 6 : 7);
      const section = q.section || (partNum <= 4 ? 'listening' : 'reading');

      const pData = q.passage || {};
      const passageText = q.passage_text || pData.passage_text || null;
      const passageAudio = pData.audio_url || (q.passage_id ? q.audio_url : null);
      const passageImage = pData.image_url || (q.passage_id ? q.image_url : null);

      await prisma.question.upsert({
        where: {
          examCode_questionNumber: {
            examCode,
            questionNumber: qNum
          }
        },
        create: {
          examCode,
          questionNumber: qNum,
          part: partNum,
          section,
          questionText: q.question_text || null,
          optionA: q.option_a || null,
          optionB: q.option_b || null,
          optionC: q.option_c || null,
          optionD: q.option_d || null,
          correctAnswer: (q.correct_answer || 'A').trim().toUpperCase(),
          explanationVi: q.explanation_vi || q.dich_nghia || null,
          explanationEn: q.explanation_en || null,
          audioUrl: q.audio_url || null,
          imageUrl: q.image_url || null,
          passageId: q.passage_id || null,
          passageText,
          passageAudio,
          passageImage,
          tuVung: q.tu_vung ? (typeof q.tu_vung === 'string' ? { raw: q.tu_vung } : q.tu_vung) : null,
          rawData: q
        },
        update: {
          part: partNum,
          section,
          questionText: q.question_text || null,
          optionA: q.option_a || null,
          optionB: q.option_b || null,
          optionC: q.option_c || null,
          optionD: q.option_d || null,
          correctAnswer: (q.correct_answer || 'A').trim().toUpperCase(),
          explanationVi: q.explanation_vi || q.dich_nghia || null,
          audioUrl: q.audio_url || null,
          imageUrl: q.image_url || null,
          passageId: q.passage_id || null,
          passageText,
          passageAudio,
          passageImage,
          tuVung: q.tu_vung ? (typeof q.tu_vung === 'string' ? { raw: q.tu_vung } : q.tu_vung) : null
        }
      });
      totalQuestionsInserted++;
    }

    console.log(`   ✅ Đã nạp xong ${questions.length} câu của đề ${examCode}`);
  }

  console.log(`\n🎉 HOÀN THÀNH! Tổng cộng đã nạp ${totalQuestionsInserted} câu hỏi cho ${files.length} đề thi.`);
}

seedExamQuestions()
  .catch(err => {
    console.error('❌ Lỗi khi seed câu hỏi:', err);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });

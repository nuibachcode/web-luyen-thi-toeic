import fs from 'fs';
import path from 'path';
import dotenv from 'dotenv';
import { PrismaClient } from '@prisma/client';

dotenv.config();

// Hỗ trợ tự động nhận diện Docker DB (port 5435) hoặc Standard Postgres (port 5432)
if (!process.env.DATABASE_URL) {
  const host = process.env.DB_HOST || 'localhost';
  const user = process.env.CATALOG_DB_USER || process.env.DB_USER || 'toeic_catalog';
  const pass = process.env.CATALOG_DB_PASSWORD || process.env.DB_PASSWORD || 'change-me-catalog';
  const port = process.env.DB_PORT || '5435';
  const db = process.env.DB_NAME || 'toeic_catalog';
  process.env.DATABASE_URL = `postgresql://${user}:${pass}@${host}:${port}/${db}?schema=public`;
}
const prisma = new PrismaClient();

async function seedCatalogExams() {
  console.log('🚀 Bắt đầu nạp danh mục đề thi vào catalog-service...');
  console.log(`🔗 Database URL: ${(process.env.DATABASE_URL || '').replace(/:[^:@]+@/, ':****@')}`);

  const possiblePaths = [
    path.join(__dirname, '../../../seeds/exams'),
    path.join(__dirname, '../../seeds/exams'),
    path.join(__dirname, '../seeds/exams'),
    path.join(process.cwd(), 'seeds/exams'),
    path.join(process.cwd(), '../seeds/exams')
  ];

  let examsDir = possiblePaths.find(p => fs.existsSync(p));
  if (!examsDir) {
    console.error('❌ Không tìm thấy thư mục seeds/exams');
    return;
  }

  const files = fs.readdirSync(examsDir).filter(f => f.endsWith('.json')).sort();
  console.log(`📂 Tìm thấy ${files.length} file đề thi trong thư mục: ${examsDir}`);

  for (let i = 0; i < files.length; i++) {
    const file = files[i];
    const filePath = path.join(examsDir, file);
    const examCode = file.replace('.json', '');
    const idx = i + 1;
    const rawContent = fs.readFileSync(filePath, 'utf-8');
    const questions: any[] = JSON.parse(rawContent);

    const title = `TOEIC Full Practice Test ${String(idx).padStart(2, '0')} - ETS 2026`;
    const description = `Bộ đề thi TOEIC thực tế ${String(idx).padStart(2, '0')} chuẩn format ETS, trọn gói Audio chất lượng cao và Lời giải chi tiết`;

    await prisma.exam.upsert({
      where: { code: examCode },
      create: {
        code: examCode,
        title,
        description,
        durationMinutes: 120,
        status: 'PUBLISHED',
        questions: questions as any
      },
      update: {
        title,
        description,
        durationMinutes: 120,
        status: 'PUBLISHED',
        questions: questions as any
      }
    });

    console.log(`   ✅ Đã nạp danh mục đề: ${examCode} (${title})`);
  }

  console.log(`\n🎉 HOÀN THÀNH! Đã nạp thành công ${files.length} đề thi vào Catalog Service.`);
}

seedCatalogExams()
  .catch(err => {
    console.error('❌ Lỗi khi seed catalog:', err);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });

import { spawn } from 'child_process';
import path from 'path';

function runScript(dir: string, cmd: string, args: string[]): Promise<void> {
  return new Promise((resolve, reject) => {
    console.log(`\n▶️ Chạy lệnh trong thư mục: ${dir}`);
    const proc = spawn(cmd, args, {
      cwd: dir,
      shell: true,
      stdio: 'inherit'
    });

    proc.on('close', code => {
      if (code === 0) resolve();
      else reject(new Error(`Lệnh kết thúc với mã lỗi ${code}`));
    });
  });
}

async function main() {
  console.log('====================================================');
  console.log('🎯 BẮT ĐẦU NẠP TOÀN BỘ 10 ĐỀ THI TOEIC VÀO DATABASE');
  console.log('====================================================');

  const rootDir = process.cwd();
  const examServiceDir = path.join(rootDir, 'backend/exam-service');
  const catalogServiceDir = path.join(rootDir, 'backend/catalog-service');

  try {
    console.log('\n[1/2] Nạp chi tiết 2000 câu hỏi vào Exam Service Database...');
    await runScript(examServiceDir, 'npx', ['tsx', 'src/seed.ts']);

    console.log('\n[2/2] Nạp danh mục 10 đề thi vào Catalog Service Database...');
    await runScript(catalogServiceDir, 'npx', ['tsx', 'src/seed.ts']);

    console.log('\n====================================================');
    console.log('🎉 TẤT CẢ 10 ĐỀ THI ĐÃ ĐƯỢC NẠP VÀO CSDL THÀNH CÔNG!');
    console.log('Học viên có thể vào luyện thi ngay lập tức.');
    console.log('====================================================');
  } catch (err: any) {
    console.error('\n❌ Có lỗi xảy ra trong quá trình nạp đề thi:', err.message);
    process.exit(1);
  }
}

main();

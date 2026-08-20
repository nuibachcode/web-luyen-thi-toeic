import expressApp from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import { OAuth2Client } from 'google-auth-library';
import jwt from 'jsonwebtoken';
import { PrismaClient } from '@prisma/client';
import bcrypt from 'bcryptjs';

dotenv.config();

process.env.DATABASE_URL ||= `postgresql://${process.env.DB_USER || 'postgres'}:${process.env.DB_PASSWORD || 'password'}@${process.env.DB_HOST || 'localhost'}:${process.env.DB_PORT || '5432'}/${process.env.DB_NAME || 'postgres'}?schema=public`;
const prisma = new PrismaClient();

const app = expressApp();
app.use(cors());
app.use(expressApp.json());

const PORT = process.env.PORT || 4001;
const JWT_SECRET = process.env.JWT_SECRET || 'super-secret-toeic-key';
const GOOGLE_CLIENT_ID = process.env.GOOGLE_CLIENT_ID || 'dummy-google-client-id';

const client = new OAuth2Client(GOOGLE_CLIENT_ID);

async function seedDefaultAccounts() {
  try {
    const adminEmail = 'admin@toeic.com';
    const existingAdmin = await prisma.user.findUnique({ where: { email: adminEmail } });
    if (!existingAdmin) {
      const hash = await bcrypt.hash('password123', 10);
      await prisma.user.create({
        data: { email: adminEmail, name: 'Quản trị viên Admin', passwordHash: hash, role: 'SUPERADMIN', tenantId: 'tenant-demo' }
      });
      console.log('Seeded default account admin@toeic.com');
    }

    const managerEmail = 'manager@center.com';
    const existingManager = await prisma.user.findUnique({ where: { email: managerEmail } });
    if (!existingManager) {
      const hash = await bcrypt.hash('password123', 10);
      await prisma.user.create({
        data: { email: managerEmail, name: 'Quản lý Trung tâm', passwordHash: hash, role: 'MANAGER', tenantId: 'tenant-demo' }
      });
      console.log('Seeded default account manager@center.com');
    }

    const studentEmail = 'student@example.com';
    const existingStudent = await prisma.user.findUnique({ where: { email: studentEmail } });
    if (!existingStudent) {
      const hash = await bcrypt.hash('password123', 10);
      await prisma.user.create({
        data: { email: studentEmail, name: 'Học viên Demo', passwordHash: hash, role: 'STUDENT', tenantId: 'tenant-demo' }
      });
      console.log('Seeded default account student@example.com');
    }
  } catch (e) {
    console.warn('Seed default accounts notice:', e);
  }
}

app.get('/health', (req, res) => {
  res.json({ status: 'Account Service is running!' });
});

// 0. API Đăng ký truyền thống (Email/Password)
app.post('/api/auth/register', async (req, res) => {
  try {
    const { email, password, name } = req.body;
    if (!email || !password || !name) return res.status(400).json({ error: 'Vui lòng điền đầy đủ họ tên, email và mật khẩu' });

    // Check existing
    const existing = await prisma.user.findUnique({ where: { email } });
    if (existing) return res.status(400).json({ error: 'Email này đã được đăng ký tài khoản trước đó.' });

    const passwordHash = await bcrypt.hash(password, 10);
    const user = await prisma.user.create({ data: { email, name, passwordHash, role: 'STUDENT', tenantId: 'tenant-demo' } });
    const token = jwt.sign({ id: user.id, role: user.role, tenant_id: user.tenantId }, JWT_SECRET, { expiresIn: '7d' });

    res.json({ message: 'Đăng ký thành công', token, user });
  } catch (error) {
    console.error('Register error:', error);
    res.status(500).json({ error: 'Đăng ký không thành công. Vui lòng thử lại.' });
  }
});

// 0.1 API Đăng nhập truyền thống (Email/Password)
app.post('/api/auth/login', async (req, res) => {
  try {
    const { email, password } = req.body;
    if (!email || !password) return res.status(400).json({ error: 'Vui lòng nhập Email và Mật khẩu' });

    const user = await prisma.user.findUnique({ where: { email } });
    if (!user || !user.passwordHash) {
      return res.status(401).json({ error: 'Tài khoản không tồn tại. Hãy bấm "Đăng ký ngay" bên dưới để tạo tài khoản mới!' });
    }

    const isValid = await bcrypt.compare(password, user.passwordHash);
    if (!isValid) return res.status(401).json({ error: 'Mật khẩu không chính xác. Vui lòng thử lại!' });

    const token = jwt.sign({ id: user.id, role: user.role, tenant_id: user.tenantId }, JWT_SECRET, { expiresIn: '7d' });
    res.json({ message: 'Login successful', token, user });
  } catch (error) {
    console.error('Login error:', error);
    res.status(500).json({ error: 'Lỗi đăng nhập hệ thống.' });
  }
});

// Update user profile in DB
app.put('/api/auth/profile', async (req, res) => {
  try {
    const authHeader = req.header('authorization')?.replace(/^Bearer\s+/i, '');
    if (!authHeader) return res.status(401).json({ error: 'Authentication required' });
    
    const payload = jwt.verify(authHeader, JWT_SECRET) as { id?: string };
    if (!payload.id) return res.status(401).json({ error: 'Invalid token' });

    const { name } = req.body;
    const updatedUser = await prisma.user.update({
      where: { id: payload.id },
      data: { name }
    });

    res.json({ message: 'Profile updated successfully', user: updatedUser });
  } catch (error) {
    console.error('Profile update error:', error);
    res.status(500).json({ error: 'Failed to update profile' });
  }
});

// 1. API Đăng nhập bằng Google
app.post('/api/auth/google', async (req, res) => {
  try {
    const { token, email: reqEmail, name: reqName, picture: reqPicture } = req.body;
    if (!token && !reqEmail) return res.status(400).json({ error: 'Token or Email is required' });

    let googleId = 'google-uid-12345';
    let email = reqEmail || 'student@example.com';
    let name = reqName || 'Học viên Google';
    let picture = reqPicture || '';

    // If token is a real Google JWT Token, decode payload
    if (token && token.includes('.')) {
      try {
        const decoded = jwt.decode(token) as any;
        if (decoded && decoded.email) {
          googleId = decoded.sub || googleId;
          email = decoded.email;
          name = decoded.name || name;
          picture = decoded.picture || picture;
        }
      } catch (e) {
        console.warn('Google token decode fallback:', e);
      }
    }

    // Tìm trong PostgreSQL Database
    let user = await prisma.user.findFirst({ where: { OR: [{ googleId }, { email }] } });
    
    if (!user) {
      // Nếu chưa có, tạo mới (Role mặc định STUDENT)
      user = await prisma.user.create({ data: { googleId, email, name, picture, role: 'STUDENT', tenantId: 'tenant-demo' } });
    } else if (!user.googleId) {
      // Nếu user đã tồn tại qua email nhưng chưa link Google ID
      user = await prisma.user.update({ where: { id: user.id }, data: { googleId, name: user.name || name } });
    }

    // Tạo JWT Token
    const jwtToken = jwt.sign(
      { id: user.id, role: user.role, tenant_id: user.tenantId },
      JWT_SECRET,
      { expiresIn: '7d' }
    );

    res.json({
      message: 'Login successful',
      token: jwtToken,
      user
    });

  } catch (error) {
    console.error('Google Auth Error:', error);
    res.status(500).json({ error: 'Authentication failed' });
  }
});

// Admin API: List all real users from Database
app.get('/api/admin/users', async (req, res) => {
  try {
    const users = await prisma.user.findMany({
      orderBy: { createdAt: 'desc' },
      select: {
        id: true,
        email: true,
        name: true,
        role: true,
        tenantId: true,
        createdAt: true,
      }
    });
    res.json({ users });
  } catch (error) {
    console.error('List users error:', error);
    res.status(500).json({ error: 'Failed to fetch users' });
  }
});

// Admin API: Create user (SUPERADMIN, MANAGER, STUDENT)
app.post('/api/admin/users', async (req, res) => {
  try {
    const { email, password, name, role = 'MANAGER', tenantId = 'tt-hanoi-01' } = req.body;
    if (!email || !password || !name) return res.status(400).json({ error: 'Missing required fields' });

    const existing = await prisma.user.findUnique({ where: { email } });
    if (existing) return res.status(400).json({ error: 'Email already exists' });

    const passwordHash = await bcrypt.hash(password, 10);
    const user = await prisma.user.create({
      data: { email, name, passwordHash, role, tenantId }
    });

    res.status(201).json({ message: 'User created successfully', user });
  } catch (error) {
    console.error('Create user error:', error);
    res.status(500).json({ error: 'Failed to create user' });
  }
});

// Admin API: Delete user by ID
app.delete('/api/admin/users/:id', async (req, res) => {
  try {
    const { id } = req.params;
    await prisma.user.delete({ where: { id } });
    res.json({ message: 'User deleted successfully' });
  } catch (error) {
    console.error('Delete user error:', error);
    res.status(500).json({ error: 'Failed to delete user' });
  }
});

// AI API: Detailed Question Explanation using Gemini AI
app.post('/api/ai/explain', async (req, res) => {
  try {
    const { questionText, options, correctAnswer, explanation, passageText } = req.body;
    const apiKey = process.env.GEMINI_API_KEY;

    if (apiKey) {
      const prompt = `Bạn là Giảng viên Luyện thi TOEIC ETS 990 điểm chuyên nghiệp. Hãy phân tích chi tiết câu hỏi TOEIC sau đây bằng tiếng Việt:
Câu hỏi: ${questionText || ''}
${passageText ? `Đoạn văn đính kèm: ${passageText}` : ''}
Các phương án: ${JSON.stringify(options || [])}
Đáp án đúng: ${correctAnswer || ''}
Giải thích có sẵn: ${explanation || ''}

Hãy trả về phản hồi định dạng JSON hợp lệ (không kèm markdown format) chứa đúng các trường sau:
{
  "translation": "Dịch toàn bộ câu hỏi và các phương án sang tiếng Việt chuẩn sư phạm",
  "whyCorrect": "Lý giải chi tiết tại sao đáp án đúng lại được chọn và phân tích ngữ pháp/ngữ cảnh",
  "vocabulary": [
    { "word": "từ_vựng", "ipa": "/phiên_âm/", "meaning": "nghĩa tiếng Việt" }
  ],
  "trapWarning": "Lưu ý bẫy bối cảnh/phát âm hoặc mẹo nhớ nhanh"
}`;

      const geminiRes = await fetch(`https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=${apiKey}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ contents: [{ parts: [{ text: prompt }] }] })
      });

      if (geminiRes.ok) {
        const geminiData = await geminiRes.json();
        const rawText = geminiData.candidates?.[0]?.content?.parts?.[0]?.text || '';
        const cleanJson = rawText.replace(/```json/g, '').replace(/```/g, '').trim();
        try {
          const parsed = JSON.parse(cleanJson);
          return res.json({ ai: parsed });
        } catch (e) {
          console.warn('JSON parse error from Gemini API response:', e);
        }
      }
    }

    // Rich fallback explanation generator when API Key is not set
    const parsedOptions = Array.isArray(options) ? options : [];
    const correctOpt = parsedOptions.find((o: any) => o.is_correct || o.label === correctAnswer) || parsedOptions[0];
    
    res.json({
      ai: {
        translation: `Câu hỏi: "${questionText || 'Câu hỏi luyện tập TOEIC'}"\n` +
          parsedOptions.map((o: any) => `• (${o.label || 'A'}) ${o.text || ''}`).join('\n'),
        whyCorrect: `Phương án (${correctAnswer || correctOpt?.label || 'A'}) là đáp án chính xác. ` +
          (explanation ? `Căn cứ: ${explanation}` : 'Văn cảnh câu hỏi yêu cầu cấu trúc ngữ pháp và từ vựng phù hợp nhất với ngữ cảnh kinh doanh ETS.'),
        vocabulary: [
          { word: 'authorize', ipa: '/ˈɔː.θər.aɪz/', meaning: 'ủy quyền, cấp phép' },
          { word: 'schedule', ipa: '/ˈʃed.juːl/', meaning: 'lịch trình, thời gian biểu' },
          { word: 'confirm', ipa: '/kənˈfɜːm/', meaning: 'xác nhận' }
        ],
        trapWarning: 'Chú ý phân biệt từ đồng âm và các thì động từ thường gặp trong các đề thi TOEIC chuẩn ETS.'
      }
    });
  } catch (error) {
    console.error('AI Explain error:', error);
    res.status(500).json({ error: 'AI processing failed' });
  }
});

// AI API: Interactive Tutor Chatbot using Gemini AI
app.post('/api/ai/chat', async (req, res) => {
  try {
    const { message } = req.body;
    if (!message) return res.status(400).json({ error: 'Message is required' });

    const apiKey = process.env.GEMINI_API_KEY;
    if (apiKey) {
      const prompt = `Bạn là AeroAI - Trợ lý Trợ giảng Luyện thi TOEIC 990+ thân thiện, uyên bác. Hãy giải đáp ngắn gọn, dễ hiểu và truyền cảm hứng cho câu hỏi của học viên sau đây bằng tiếng Việt:
Học viên hỏi: "${message}"`;

      const geminiRes = await fetch(`https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=${apiKey}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ contents: [{ parts: [{ text: prompt }] }] })
      });

      if (geminiRes.ok) {
        const geminiData = await geminiRes.json();
        const reply = geminiData.candidates?.[0]?.content?.parts?.[0]?.text;
        if (reply) return res.json({ reply });
      }
    }

    // Friendly smart fallback AI Tutor response
    let reply = `Chào bạn! Tôi là AeroAI 🤖 trợ lý luyện thi TOEIC của bạn.\n\n`;
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

    res.json({ reply });
  } catch (error) {
    console.error('AI Chat error:', error);
    res.status(500).json({ error: 'AI Tutor failed' });
  }
});

// Keep-Alive Ping back to Gateway every 4 minutes to prevent Render Free-tier cold starts
setInterval(() => {
  fetch('https://aerotoeic-api-gateway.onrender.com/health').catch(() => {});
}, 4 * 60 * 1000);

app.listen(Number(PORT), '0.0.0.0', () => {
  console.log(`Account Service is running on port ${PORT}`);
  prisma.$connect()
    .then(async () => {
      console.log('Prisma connected to Database successfully');
      await seedDefaultAccounts();
    })
    .catch((error) => console.error('Prisma DB connection warning:', error));
});

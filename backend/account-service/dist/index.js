"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const cors_1 = __importDefault(require("cors"));
const dotenv_1 = __importDefault(require("dotenv"));
const google_auth_library_1 = require("google-auth-library");
const jsonwebtoken_1 = __importDefault(require("jsonwebtoken"));
const client_1 = require("@prisma/client");
const bcryptjs_1 = __importDefault(require("bcryptjs"));
dotenv_1.default.config();
process.env.DATABASE_URL ||= `postgresql://${process.env.DB_USER || 'postgres'}:${process.env.DB_PASSWORD || 'password'}@${process.env.DB_HOST || 'localhost'}:${process.env.DB_PORT || '5432'}/${process.env.DB_NAME || 'postgres'}?schema=public`;
const prisma = new client_1.PrismaClient();
const app = (0, express_1.default)();
app.use((0, cors_1.default)());
app.use(express_1.default.json());
const PORT = process.env.PORT || 4001;
const JWT_SECRET = process.env.JWT_SECRET || 'super-secret-toeic-key';
const GOOGLE_CLIENT_ID = process.env.GOOGLE_CLIENT_ID || 'dummy-google-client-id';
const client = new google_auth_library_1.OAuth2Client(GOOGLE_CLIENT_ID);
app.get('/health', (req, res) => {
    res.json({ status: 'Account Service is running!' });
});
// 0. API Đăng ký truyền thống (Email/Password)
app.post('/api/auth/register', async (req, res) => {
    try {
        const { email, password, name } = req.body;
        if (!email || !password || !name)
            return res.status(400).json({ error: 'Missing fields' });
        // Check existing
        const existing = await prisma.user.findUnique({ where: { email } });
        if (existing)
            return res.status(400).json({ error: 'Email already exists' });
        const passwordHash = await bcryptjs_1.default.hash(password, 10);
        const user = await prisma.user.create({ data: { email, name, passwordHash, role: 'STUDENT' } });
        const token = jsonwebtoken_1.default.sign({ id: user.id, role: user.role, tenant_id: user.tenantId }, JWT_SECRET, { expiresIn: '7d' });
        res.json({ message: 'Registered successfully', token, user });
    }
    catch (error) {
        console.error('Register error:', error);
        res.status(500).json({ error: 'Registration failed' });
    }
});
// 0.1 API Đăng nhập truyền thống (Email/Password)
app.post('/api/auth/login', async (req, res) => {
    try {
        const { email, password } = req.body;
        if (!email || !password)
            return res.status(400).json({ error: 'Missing fields' });
        const user = await prisma.user.findUnique({ where: { email } });
        if (!user || !user.passwordHash)
            return res.status(401).json({ error: 'Invalid email or password' });
        const isValid = await bcryptjs_1.default.compare(password, user.passwordHash);
        if (!isValid)
            return res.status(401).json({ error: 'Invalid email or password' });
        const token = jsonwebtoken_1.default.sign({ id: user.id, role: user.role, tenant_id: user.tenantId }, JWT_SECRET, { expiresIn: '7d' });
        res.json({ message: 'Login successful', token, user });
    }
    catch (error) {
        console.error('Login error:', error);
        res.status(500).json({ error: 'Login failed' });
    }
});
// 1. API Đăng nhập bằng Google (Lưu ý: Bỏ mock role vì nó nên tự lấy từ DB hoặc set default)
app.post('/api/auth/google', async (req, res) => {
    try {
        const { token, role, tenant_id } = req.body;
        if (!token)
            return res.status(400).json({ error: 'Token is required' });
        // GIẢ LẬP XÁC THỰC GOOGLE ĐỂ TEST TRƯỚC KHI CÓ CLIENT ID THẬT
        const payload = {
            sub: 'google-uid-12345',
            email: 'student@example.com',
            name: 'Google User',
            picture: 'https://example.com/avatar.jpg'
        };
        if (!payload)
            return res.status(401).json({ error: 'Invalid Google Token' });
        const { sub: googleId, email, name, picture } = payload;
        // Tìm trong PostgreSQL Database
        let user = await prisma.user.findFirst({ where: { OR: [{ googleId }, { email }] } });
        if (!user) {
            // Nếu chưa có, tạo mới (Role mặc định STUDENT)
            user = await prisma.user.create({ data: { googleId, email, name, picture, role: 'STUDENT', tenantId: 'tenant-demo' } });
        }
        else if (!user.googleId) {
            // Nếu user đã tồn tại qua email nhưng chưa link Google ID
            user = await prisma.user.update({ where: { id: user.id }, data: { googleId } });
        }
        // Tạo JWT Token
        const jwtToken = jsonwebtoken_1.default.sign({ id: user.id, role: user.role, tenant_id: user.tenantId }, JWT_SECRET, { expiresIn: '7d' });
        res.json({
            message: 'Login successful',
            token: jwtToken,
            user
        });
    }
    catch (error) {
        console.error('Google Auth Error:', error);
        res.status(500).json({ error: 'Authentication failed' });
    }
});
prisma.$connect().then(() => app.listen(PORT, () => {
    console.log(`Account Service is running on http://localhost:${PORT}`);
}));

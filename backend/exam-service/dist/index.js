"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const cors_1 = __importDefault(require("cors"));
const dotenv_1 = __importDefault(require("dotenv"));
const jsonwebtoken_1 = __importDefault(require("jsonwebtoken"));
const pg_1 = require("pg");
dotenv_1.default.config();
const app = (0, express_1.default)();
const port = Number(process.env.PORT || 4002);
const jwtSecret = process.env.JWT_SECRET || 'super-secret-toeic-key';
const pool = new pg_1.Pool({
    user: process.env.DB_USER || 'postgres',
    host: process.env.DB_HOST || 'localhost',
    database: process.env.DB_NAME || 'postgres',
    password: process.env.DB_PASSWORD || 'password',
    port: Number(process.env.DB_PORT || 5432),
});
app.use((0, cors_1.default)());
app.use(express_1.default.json({ limit: '1mb' }));
async function initializeDatabase() {
    // init-db.sql is used for fresh Docker volumes. This makes the service safe to
    // introduce into an already-running development database as well.
    await pool.query('CREATE EXTENSION IF NOT EXISTS "uuid-ossp"');
    await pool.query(`
    CREATE TABLE IF NOT EXISTS exam_results (
      id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
      user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
      exam_code VARCHAR(100) NOT NULL,
      listening_correct SMALLINT NOT NULL CHECK (listening_correct BETWEEN 0 AND 100),
      reading_correct SMALLINT NOT NULL CHECK (reading_correct BETWEEN 0 AND 100),
      listening_score SMALLINT NOT NULL CHECK (listening_score BETWEEN 5 AND 495),
      reading_score SMALLINT NOT NULL CHECK (reading_score BETWEEN 5 AND 495),
      total_score SMALLINT NOT NULL CHECK (total_score BETWEEN 10 AND 990),
      answers JSONB NOT NULL DEFAULT '{}'::jsonb,
      submitted_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
    )
  `);
    await pool.query('CREATE INDEX IF NOT EXISTS exam_results_user_submitted_idx ON exam_results (user_id, submitted_at DESC)');
}
function requireUser(req, res, next) {
    const token = req.header('authorization')?.replace(/^Bearer\s+/i, '');
    if (!token)
        return res.status(401).json({ error: 'Authentication required' });
    try {
        const payload = jsonwebtoken_1.default.verify(token, jwtSecret);
        if (!payload.id)
            return res.status(401).json({ error: 'Invalid token' });
        req.userId = payload.id;
        next();
    }
    catch {
        return res.status(401).json({ error: 'Invalid or expired token' });
    }
}
app.get('/health', async (_req, res) => {
    await pool.query('SELECT 1');
    res.json({ status: 'Exam Service is running' });
});
app.post('/api/exam-results', requireUser, async (req, res) => {
    const { examCode, listeningCorrect, readingCorrect, answers } = req.body;
    if (typeof examCode !== 'string' || !Number.isInteger(listeningCorrect) || !Number.isInteger(readingCorrect) || !answers || typeof answers !== 'object') {
        return res.status(400).json({ error: 'Invalid exam result payload' });
    }
    if (listeningCorrect < 0 || listeningCorrect > 100 || readingCorrect < 0 || readingCorrect > 100) {
        return res.status(400).json({ error: 'Correct answers must be between 0 and 100' });
    }
    const listeningScore = Math.min(495, Math.max(5, Math.round(listeningCorrect * 4.95)));
    const readingScore = Math.min(495, Math.max(5, Math.round(readingCorrect * 4.95)));
    const result = await pool.query(`INSERT INTO exam_results
      (user_id, exam_code, listening_correct, reading_correct, listening_score, reading_score, total_score, answers)
     VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
     RETURNING id, exam_code, listening_correct, reading_correct, listening_score, reading_score, total_score, submitted_at`, [req.userId, examCode, listeningCorrect, readingCorrect, listeningScore, readingScore, listeningScore + readingScore, answers]);
    res.status(201).json({ result: result.rows[0] });
});
app.get('/api/exam-results/me', requireUser, async (req, res) => {
    const result = await pool.query(`SELECT id, exam_code, listening_correct, reading_correct, listening_score, reading_score, total_score, submitted_at
     FROM exam_results WHERE user_id = $1 ORDER BY submitted_at DESC`, [req.userId]);
    res.json({ results: result.rows });
});
initializeDatabase()
    .then(() => app.listen(port, () => console.log(`Exam Service listening on http://localhost:${port}`)))
    .catch((error) => {
    console.error('Could not initialize exam-service database:', error);
    process.exit(1);
});

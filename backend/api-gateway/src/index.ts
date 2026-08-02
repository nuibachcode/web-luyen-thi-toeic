import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import jwt from 'jsonwebtoken';
import { createProxyMiddleware } from 'http-proxy-middleware';
import { rateLimit } from 'express-rate-limit';

dotenv.config();

const app = express();
const port = Number(process.env.PORT || 4000);
const secret = process.env.JWT_SECRET || 'super-secret-toeic-key';

const services = {
  auth: process.env.ACCOUNT_SERVICE_URL || process.env.AUTH_SERVICE_URL || 'http://localhost:4001',
  exam: process.env.EXAM_SERVICE_URL || 'http://localhost:4002',
  catalog: process.env.CATALOG_SERVICE_URL || 'http://localhost:4003',
  analytics: process.env.ANALYTICS_SERVICE_URL || 'http://localhost:4004',
  ai: process.env.AI_SERVICE_URL || 'http://localhost:4005'
};

const preserveApiPath = (_path: string, req: { originalUrl?: string }) => req.originalUrl || _path;

app.use(cors());
app.use(rateLimit({ windowMs: 60_000, limit: 120, standardHeaders: 'draft-8', legacyHeaders: false }));
app.use((req, res, next) => {
  const traceId = req.header('x-trace-id') || crypto.randomUUID();
  res.setHeader('x-trace-id', traceId);
  req.headers['x-trace-id'] = traceId;
  next();
});

const verifyJwt = (req: express.Request, res: express.Response, next: express.NextFunction) => {
  if (req.path.startsWith('/api/auth') || req.path.startsWith('/api/ai')) return next();
  const token = req.header('authorization')?.replace(/^Bearer\s+/i, '');
  if (!token) return res.status(401).json({ error: 'Authentication required' });
  try { jwt.verify(token, secret); next(); } catch { res.status(401).json({ error: 'Invalid or expired token' }); }
};

const authProxy = createProxyMiddleware({ target: services.auth, changeOrigin: true, pathRewrite: preserveApiPath });
const examProxy = createProxyMiddleware({ target: services.exam, changeOrigin: true, pathRewrite: preserveApiPath });
const catalogProxy = createProxyMiddleware({ target: services.catalog, changeOrigin: true, pathRewrite: preserveApiPath });
const aiProxy = createProxyMiddleware({ target: services.ai, changeOrigin: true, pathRewrite: preserveApiPath });
const analyticsProxy = createProxyMiddleware({ target: services.analytics, changeOrigin: true, pathRewrite: preserveApiPath });

app.get('/health', (_req, res) => res.json({ status: 'Gateway running', services }));

app.use('/api/auth', authProxy);
app.use('/api/admin/users', verifyJwt, authProxy);
app.use('/api/exam-results', verifyJwt, examProxy);
app.use('/api/admin/exams', verifyJwt, (req, res, next) => {
  const path = req.path;
  if (path.includes('import-curl') || path.includes('questions')) {
    return examProxy(req, res, next);
  }
  return catalogProxy(req, res, next);
});

app.use('/api/exams', (req, res, next) => {
  const subpath = req.path;
  if (subpath && subpath !== '/' && req.method === 'GET') {
    return examProxy(req, res, next);
  }
  return catalogProxy(req, res, next);
});

app.use('/api/analytics', verifyJwt, analyticsProxy);
app.use('/api/ai', aiProxy);

app.listen(port, () => console.log(`Pure Microservices API Gateway listening on :${port}`));

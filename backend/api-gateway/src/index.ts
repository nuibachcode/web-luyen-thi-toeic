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
  analytics: process.env.ANALYTICS_SERVICE_URL || process.env.EXAM_SERVICE_URL || 'http://localhost:4002',
  ai: process.env.AI_SERVICE_URL || 'http://localhost:4005'
};

const preserveApiPath = (_path: string, req: { originalUrl?: string }) => req.originalUrl || _path;

const createServiceProxy = (targetUrl: string, serviceName: string) => {
  return createProxyMiddleware({
    target: targetUrl,
    changeOrigin: true,
    pathRewrite: preserveApiPath,
    proxyTimeout: 60000,
    timeout: 60000,
    on: {
      error: (err, _req, res: any) => {
        console.error(`Proxy Error [${serviceName}]:`, err.message);
        if (res && !res.headersSent) {
          res.status(502).json({
            error: `Dịch vụ ${serviceName} đang khởi động hoặc tạm thời gián đoạn kết nối. Vui lòng chờ 15-30 giây và thử lại!`
          });
        }
      }
    }
  });
};

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

const authProxy = createServiceProxy(services.auth, 'Account Service');
const examProxy = createServiceProxy(services.exam, 'Exam Service');
const catalogProxy = createServiceProxy(services.catalog, 'Catalog Service');
const aiProxy = createServiceProxy(services.ai, 'AI Service');
const analyticsProxy = createServiceProxy(services.analytics, 'Analytics Service');

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

"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const cors_1 = __importDefault(require("cors"));
const dotenv_1 = __importDefault(require("dotenv"));
const jsonwebtoken_1 = __importDefault(require("jsonwebtoken"));
const http_proxy_middleware_1 = require("http-proxy-middleware");
const express_rate_limit_1 = require("express-rate-limit");
dotenv_1.default.config();
const app = (0, express_1.default)();
const port = Number(process.env.PORT || 4000);
const secret = process.env.JWT_SECRET || 'development-only-change-me';
const services = {
    auth: process.env.AUTH_SERVICE_URL || 'http://account-service:4001',
    exam: process.env.EXAM_SERVICE_URL || 'http://exam-service:4002',
    catalog: process.env.CATALOG_SERVICE_URL || 'http://catalog-service:4003',
    analytics: process.env.ANALYTICS_SERVICE_URL || 'http://analytics-service:4005',
    ai: process.env.AI_SERVICE_URL || 'http://ai-service:4004'
};
app.use((0, cors_1.default)());
app.use((0, express_rate_limit_1.rateLimit)({ windowMs: 60_000, limit: 120, standardHeaders: 'draft-8', legacyHeaders: false }));
app.use((req, res, next) => {
    const traceId = req.header('x-trace-id') || crypto.randomUUID();
    res.setHeader('x-trace-id', traceId);
    req.headers['x-trace-id'] = traceId;
    next();
});
const verifyJwt = (req, res, next) => {
    if (req.path.startsWith('/api/auth'))
        return next();
    const token = req.header('authorization')?.replace(/^Bearer\s+/i, '');
    if (!token)
        return res.status(401).json({ error: 'Authentication required' });
    try {
        jsonwebtoken_1.default.verify(token, secret);
        next();
    }
    catch {
        res.status(401).json({ error: 'Invalid or expired token' });
    }
};
app.get('/health', (_req, res) => res.json({ status: 'Gateway running', services: Object.keys(services) }));
app.use('/api/auth', (0, http_proxy_middleware_1.createProxyMiddleware)({ target: services.auth, changeOrigin: true }));
app.use('/api/exam-results', verifyJwt, (0, http_proxy_middleware_1.createProxyMiddleware)({ target: services.exam, changeOrigin: true }));
app.use('/api/admin/exams', verifyJwt, (0, http_proxy_middleware_1.createProxyMiddleware)({ target: services.catalog, changeOrigin: true }));
app.use('/api/exams', (0, http_proxy_middleware_1.createProxyMiddleware)({ target: services.catalog, changeOrigin: true }));
app.use('/api/analytics', verifyJwt, (0, http_proxy_middleware_1.createProxyMiddleware)({ target: services.analytics, changeOrigin: true }));
app.use('/api/ai', verifyJwt, (0, http_proxy_middleware_1.createProxyMiddleware)({ target: services.ai, changeOrigin: true }));
app.listen(port, () => console.log(`API Gateway listening on :${port}`));

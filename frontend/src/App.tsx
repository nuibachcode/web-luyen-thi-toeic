import { useEffect } from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate, useLocation } from 'react-router-dom';
import { AuthProvider, useAuth } from './context/AuthContext';
import Home from './pages/Home';
import Login from './pages/Auth/Login';
import Dashboard from './pages/Student/Dashboard';
import TestCenter from './pages/Student/TestCenter';
import Results from './pages/Student/Results';
import Profile from './pages/Student/Profile';
import RoadmapPage from './pages/Student/RoadmapPage';
import TestPlayer from './pages/Student/TestPlayer';
import AdminDashboard from './pages/Admin/AdminDashboard';
import ManagerDashboard from './pages/Manager/ManagerDashboard';
import { getApiGatewayUrl } from './config/api';
import './index.css';
import type { JSX } from 'react/jsx-runtime';

function ScrollToTop() {
  const { pathname, search } = useLocation();

  useEffect(() => {
    window.scrollTo({ top: 0, left: 0, behavior: 'smooth' });
  }, [pathname, search]);

  return null;
}

const ProtectedRoute = ({ children, allowedRole }: { children: JSX.Element, allowedRole: string }) => {
  const { user, isLoading } = useAuth();
  if (isLoading) return <div style={{ display: 'grid', placeItems: 'center', minHeight: '100vh', color: '#64748b', fontWeight: 600 }}>⏳ Đang kiểm tra phiên đăng nhập...</div>;
  if (!user) return <Navigate to="/login" />;
  if (user.role !== allowedRole) return <Navigate to="/" />;
  return children;
};

const DefaultRoute = () => {
  const { user, isLoading } = useAuth();
  if (isLoading) return <div style={{ display: 'grid', placeItems: 'center', minHeight: '100vh', color: '#64748b', fontWeight: 600 }}>⏳ Đang nạp hệ thống...</div>;
  if (!user) return <Home />;
  if (user.role === 'SUPERADMIN') return <Navigate to="/admin/users" />;
  if (user.role === 'MANAGER') return <Navigate to="/manager" />;
  return <Navigate to="/student" />;
};

function AppRoutes() {
  return (
    <Routes>
      <Route path="/" element={<DefaultRoute />} />
      <Route path="/login" element={<Login />} />
      <Route path="/signup" element={<Login signup />} />
      
      {/* Student Routes */}
      <Route path="/student" element={<ProtectedRoute allowedRole="STUDENT"><Dashboard /></ProtectedRoute>} />
      <Route path="/student/roadmap" element={<ProtectedRoute allowedRole="STUDENT"><RoadmapPage /></ProtectedRoute>} />
      <Route path="/student/tests" element={<ProtectedRoute allowedRole="STUDENT"><TestCenter /></ProtectedRoute>} />
      <Route path="/student/results" element={<ProtectedRoute allowedRole="STUDENT"><Results /></ProtectedRoute>} />
      <Route path="/student/profile" element={<ProtectedRoute allowedRole="STUDENT"><Profile /></ProtectedRoute>} />
      <Route path="/student/settings" element={<ProtectedRoute allowedRole="STUDENT"><Profile /></ProtectedRoute>} />
      <Route path="/student/exam" element={<ProtectedRoute allowedRole="STUDENT"><TestPlayer /></ProtectedRoute>} />
      
      {/* Admin Routes */}
      <Route path="/admin" element={<ProtectedRoute allowedRole="SUPERADMIN"><Navigate to="/admin/users" replace /></ProtectedRoute>} />
      <Route path="/admin/users" element={<ProtectedRoute allowedRole="SUPERADMIN"><AdminDashboard subpage="users" /></ProtectedRoute>} />
      <Route path="/admin/ai-settings" element={<ProtectedRoute allowedRole="SUPERADMIN"><AdminDashboard subpage="ai-settings" /></ProtectedRoute>} />
      <Route path="/admin/settings" element={<ProtectedRoute allowedRole="SUPERADMIN"><AdminDashboard subpage="settings" /></ProtectedRoute>} />
      
      {/* Manager Routes */}
      <Route path="/manager" element={<ProtectedRoute allowedRole="MANAGER"><ManagerDashboard /></ProtectedRoute>} />
      <Route path="/manager/users" element={<ProtectedRoute allowedRole="MANAGER"><ManagerDashboard /></ProtectedRoute>} />
      <Route path="/manager/exams" element={<ProtectedRoute allowedRole="MANAGER"><ManagerDashboard /></ProtectedRoute>} />
      <Route path="/manager/reports" element={<ProtectedRoute allowedRole="MANAGER"><ManagerDashboard /></ProtectedRoute>} />
      <Route path="/manager/settings" element={<ProtectedRoute allowedRole="MANAGER"><ManagerDashboard /></ProtectedRoute>} />
      <Route path="/manager/profile" element={<ProtectedRoute allowedRole="MANAGER"><Profile /></ProtectedRoute>} />
    </Routes>
  );
}

export default function App() {
  useEffect(() => {
    // Silent background warmup ping to wake up backend containers when user opens the app
    const gatewayUrl = getApiGatewayUrl();
    fetch(`${gatewayUrl}/health`, { method: 'GET' }).catch(() => {});
  }, []);

  return (
    <AuthProvider>
      <Router>
        <ScrollToTop />
        <AppRoutes />
      </Router>
    </AuthProvider>
  );
}

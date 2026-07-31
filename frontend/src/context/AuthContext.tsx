import { createContext, useContext, useState, useEffect } from 'react';
import type { ReactNode } from 'react';
import { jwtDecode } from 'jwt-decode';

export type Role = 'SUPERADMIN' | 'MANAGER' | 'STUDENT' | null;

interface User {
  id: string;
  email?: string;
  name?: string;
  role: Role;
  tenant_id?: string;
}

interface AuthContextType {
  user: User | null;
  token: string | null;
  isLoading: boolean;
  loginWithToken: (token: string, name?: string, email?: string) => void;
  updateUser: (updatedFields: Partial<User>) => void;
  logout: () => void;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export const AuthProvider = ({ children }: { children: ReactNode }) => {
  const [user, setUser] = useState<User | null>(null);
  const [token, setToken] = useState<string | null>(null);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    // Khôi phục phiên đăng nhập khi F5 trình duyệt
    const savedToken = localStorage.getItem('toeic_jwt');
    const savedName = localStorage.getItem('toeic_user_name');
    const savedEmail = localStorage.getItem('toeic_user_email');
    if (savedToken) {
      try {
        const decoded = jwtDecode<any>(savedToken);
        const isExpired = decoded.exp && decoded.exp * 1000 < Date.now();
        if (isExpired) {
          logout();
        } else {
          setToken(savedToken);
          setUser({
            id: decoded.id,
            role: decoded.role,
            tenant_id: decoded.tenant_id,
            name: savedName || decoded.name || 'Học viên',
            email: savedEmail || decoded.email || 'student@example.com'
          });
        }
      } catch (error) {
        logout();
      }
    }
    setIsLoading(false);
  }, []);

  const loginWithToken = (newToken: string, name?: string, email?: string) => {
    try {
      const decoded = jwtDecode<any>(newToken);
      setToken(newToken);
      const userEmail = email || decoded.email || 'student@example.com';
      const userName = name || decoded.name || 'Học viên';
      setUser({
        id: decoded.id,
        role: decoded.role,
        tenant_id: decoded.tenant_id,
        name: userName,
        email: userEmail
      });
      localStorage.setItem('toeic_jwt', newToken);
      if (name) localStorage.setItem('toeic_user_name', userName);
      if (email) localStorage.setItem('toeic_user_email', userEmail);
    } catch (error) {
      console.error('Invalid token login:', error);
    }
  };

  const updateUser = (updatedFields: Partial<User>) => {
    setUser(prev => {
      if (!prev) return null;
      const next = { ...prev, ...updatedFields };
      if (next.name) localStorage.setItem('toeic_user_name', next.name);
      if (next.email) localStorage.setItem('toeic_user_email', next.email);
      return next;
    });
  };

  const logout = () => {
    setUser(null);
    setToken(null);
    localStorage.removeItem('toeic_jwt');
    localStorage.removeItem('toeic_user_name');
  };

  return (
    <AuthContext.Provider value={{ user, token, isLoading, loginWithToken, updateUser, logout }}>
      {children}
    </AuthContext.Provider>
  );
};

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
};

export const getApiGatewayUrl = (): string => {
  // 1. Explicit environment variable takes highest priority
  if (import.meta.env.VITE_API_GATEWAY_URL) {
    return import.meta.env.VITE_API_GATEWAY_URL;
  }
  
  // 2. Browser environment check
  if (typeof window !== 'undefined') {
    const hostname = window.location.hostname;
    // Mobile LAN access during development (e.g., 192.168.1.x)
    if (/^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/.test(hostname) && import.meta.env.DEV) {
      return `http://${hostname}:4000`;
    }
    // Remote / Production hostnames
    if (hostname !== 'localhost' && hostname !== '127.0.0.1') {
      return 'https://aerotoeic-api-gateway-yh6n.onrender.com';
    }
  }

  // 3. Default local development URL
  return 'http://localhost:4000';
};

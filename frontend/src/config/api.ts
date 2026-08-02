export const getApiGatewayUrl = (): string => {
  if (typeof window !== 'undefined' && window.location.hostname !== 'localhost' && window.location.hostname !== '127.0.0.1') {
    return 'https://aerotoeic-api-gateway.onrender.com';
  }
  return import.meta.env.VITE_API_GATEWAY_URL || 'http://localhost:4000';
};

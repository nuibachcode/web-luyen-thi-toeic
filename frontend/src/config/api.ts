export const getApiGatewayUrl = (): string => {
  const envUrl = import.meta.env.VITE_API_GATEWAY_URL;
  if (envUrl && envUrl.trim() !== '' && !envUrl.includes('web-luyen-thi-toeic.onrender.com')) {
    return envUrl;
  }
  if (typeof window !== 'undefined' && window.location.hostname !== 'localhost' && window.location.hostname !== '127.0.0.1') {
    return 'https://aerotoeic-api-gateway.onrender.com';
  }
  return 'http://localhost:4000';
};

// API Configuration - Use relative path when deployed, absolute for development
const getApiUrl = () => {
  // In production with ingress, use relative path
  if (window.location.hostname !== 'localhost' && window.location.hostname !== '127.0.0.1') {
    return '/api';
  }
  // In development, use environment variable or default
  return import.meta.env.VITE_API_URL || 'http://localhost:8080';
};

export const API_URL = getApiUrl();


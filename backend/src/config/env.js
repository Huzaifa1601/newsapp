import 'dotenv/config';

const splitOrigins = (value) =>
  value
    .split(',')
    .map((item) => item.trim())
    .filter(Boolean);

export const env = {
  port: Number(process.env.PORT || 4000),
  nodeEnv: process.env.NODE_ENV || 'development',
  corsOrigins: splitOrigins(
    process.env.CORS_ORIGIN || 'http://localhost:3000,http://localhost:8080',
  ),
  jwtSecret: process.env.JWT_SECRET || 'pulsewire-dev-secret',
  jwtExpiresIn: process.env.JWT_EXPIRES_IN || '12h',
  firebaseProjectId: process.env.FIREBASE_PROJECT_ID || '',
  firebaseStorageBucket: process.env.FIREBASE_STORAGE_BUCKET || '',
  firebaseServiceAccount: process.env.FIREBASE_SERVICE_ACCOUNT || '',
};

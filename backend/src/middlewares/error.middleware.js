import { ApiError } from '../utils/api-error.js';

export const notFoundHandler = (req, res, next) => {
  next(new ApiError(404, `Route not found: ${req.originalUrl}`));
};

export const errorHandler = (error, req, res, next) => {
  const statusCode = error instanceof ApiError ? error.statusCode : 500;

  res.status(statusCode).json({
    success: false,
    message: error.message || 'Unexpected server error.',
    details: error.details || undefined,
    stack: process.env.NODE_ENV === 'development' ? error.stack : undefined,
  });
};

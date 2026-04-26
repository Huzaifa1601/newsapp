import jwt from 'jsonwebtoken';

import { env } from '../config/env.js';
import { ApiError } from '../utils/api-error.js';

const requireRoles = (allowedRoles) => (req, res, next) => {
  const authorization = req.headers.authorization;
  if (!authorization?.startsWith('Bearer ')) {
    return next(new ApiError(401, 'Missing Bearer token.'));
  }

  const token = authorization.replace('Bearer ', '');

  try {
    const payload = jwt.verify(token, env.jwtSecret);
    if (!allowedRoles.includes(payload.role)) {
      throw new ApiError(403, `Required role: ${allowedRoles.join(' or ')}.`);
    }

    req.auth = payload;
    next();
  } catch (error) {
    next(error instanceof ApiError ? error : new ApiError(401, 'Invalid token.'));
  }
};

export const requireAdmin = requireRoles(['admin']);
export const requireAuthorOrAdmin = requireRoles(['author', 'admin']);

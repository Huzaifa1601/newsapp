import jwt from 'jsonwebtoken';

import { adminAuth, firebaseEnabled } from '../config/firebase.js';
import { env } from '../config/env.js';
import { loginAuthor, registerAuthor } from '../services/news.service.js';
import { asyncHandler } from '../utils/async-handler.js';

export const createAdminSession = asyncHandler(async (req, res) => {
  const { idToken, email } = req.validated.body;

  let adminUser = {
    uid: 'local-admin',
    email: email || 'admin@pulsewire.app',
    name: 'PulseWire Admin',
  };

  if (idToken && firebaseEnabled && adminAuth) {
    const decoded = await adminAuth.verifyIdToken(idToken);
    adminUser = {
      uid: decoded.uid,
      email: decoded.email,
      name: decoded.name || decoded.email || 'PulseWire Admin',
    };
  }

  const token = jwt.sign(
    {
      sub: adminUser.uid,
      email: adminUser.email,
      role: 'admin',
    },
    env.jwtSecret,
    { expiresIn: env.jwtExpiresIn },
  );

  res.json({
    success: true,
    data: {
      token,
      user: adminUser,
    },
  });
});

const signSession = (user, role) =>
  jwt.sign(
    {
      sub: user.id,
      email: user.email,
      role,
      name: user.name,
    },
    env.jwtSecret,
    { expiresIn: env.jwtExpiresIn },
  );

export const createAuthorAccount = asyncHandler(async (req, res) => {
  const author = await registerAuthor(req.validated.body);
  const token = signSession(author, 'author');

  res.status(201).json({
    success: true,
    data: {
      token,
      user: {
        ...author,
        role: 'author',
      },
    },
  });
});

export const createAuthorSession = asyncHandler(async (req, res) => {
  const author = await loginAuthor(req.validated.body);
  const token = signSession(author, 'author');

  res.json({
    success: true,
    data: {
      token,
      user: {
        ...author,
        role: 'author',
      },
    },
  });
});

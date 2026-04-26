import { Router } from 'express';
import { z } from 'zod';

import {
  createAdminSession,
  createAuthorAccount,
  createAuthorSession,
} from '../controllers/auth.controller.js';
import { validate } from '../middlewares/validate.middleware.js';

const router = Router();

router.post(
  '/session',
  validate(
    z.object({
      body: z.object({
        idToken: z.string().optional(),
        email: z.string().email().optional(),
      }),
      params: z.object({}),
      query: z.object({}),
    }),
  ),
  createAdminSession,
);

router.post(
  '/author/register',
  validate(
    z.object({
      body: z.object({
        name: z.string().min(2),
        email: z.string().email(),
        password: z.string().min(6),
        bio: z.string().optional(),
      }),
      params: z.object({}),
      query: z.object({}),
    }),
  ),
  createAuthorAccount,
);

router.post(
  '/author/login',
  validate(
    z.object({
      body: z.object({
        email: z.string().email(),
        password: z.string().min(6),
      }),
      params: z.object({}),
      query: z.object({}),
    }),
  ),
  createAuthorSession,
);

export default router;

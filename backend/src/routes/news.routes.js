import { Router } from 'express';
import { z } from 'zod';

import {
  createInteraction,
  getHome,
  getNewsById,
  searchNews,
} from '../controllers/news.controller.js';
import { validate } from '../middlewares/validate.middleware.js';

const router = Router();

router.get('/home', getHome);
router.get('/search', searchNews);
router.get('/:articleId', getNewsById);
router.post(
  '/:articleId/interactions',
  validate(
    z.object({
      body: z.object({
        type: z.enum(['open', 'like', 'share', 'bookmark']),
      }),
      params: z.object({
        articleId: z.string().min(1),
      }),
      query: z.object({}),
    }),
  ),
  createInteraction,
);

export default router;

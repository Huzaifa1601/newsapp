import { Router } from 'express';
import { z } from 'zod';

import {
  getAdminAnalytics,
  getAdminCategories,
  getAdminNews,
  getAdminUsers,
  getAuthorNews,
  removeAdminArticle,
  removeAdminCategory,
  saveAdminArticle,
  saveAdminCategory,
} from '../controllers/admin.controller.js';
import { requireAdmin, requireAuthorOrAdmin } from '../middlewares/auth.middleware.js';
import { validate } from '../middlewares/validate.middleware.js';

const router = Router();

const articleSchema = z.object({
  title: z.string().min(8),
  subtitle: z.string().min(8),
  summary: z.string().min(12),
  content: z.string().min(20),
  author: z.string().min(2),
  source: z.string().min(2),
  imageUrl: z.string().url(),
  category: z.string().min(2),
  publishedAt: z.string().optional(),
  readTimeMinutes: z.number().int().min(1).max(30),
  isBreaking: z.boolean(),
  views: z.number().int().min(0),
  likes: z.number().int().min(0),
  tags: z.array(z.string()).min(1),
});

const categorySchema = z.object({
  title: z.string().min(2),
  description: z.string().min(4),
});

router.get('/news', requireAdmin, getAdminNews);
router.get('/author/news', requireAuthorOrAdmin, getAuthorNews);
router.post(
  '/news',
  requireAuthorOrAdmin,
  validate(
    z.object({
      body: articleSchema,
      params: z.object({}),
      query: z.object({}),
    }),
  ),
  saveAdminArticle,
);
router.put(
  '/news/:articleId',
  requireAuthorOrAdmin,
  validate(
    z.object({
      body: articleSchema,
      params: z.object({ articleId: z.string().min(1) }),
      query: z.object({}),
    }),
  ),
  saveAdminArticle,
);
router.delete('/news/:articleId', requireAdmin, removeAdminArticle);

router.get('/categories', requireAdmin, getAdminCategories);
router.put(
  '/categories/:slug',
  requireAdmin,
  validate(
    z.object({
      body: categorySchema,
      params: z.object({ slug: z.string().min(2) }),
      query: z.object({}),
    }),
  ),
  saveAdminCategory,
);
router.delete('/categories/:slug', requireAdmin, removeAdminCategory);

router.get('/users', requireAdmin, getAdminUsers);
router.get('/analytics/overview', requireAdmin, getAdminAnalytics);

export default router;

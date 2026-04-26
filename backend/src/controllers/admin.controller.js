import { asyncHandler } from '../utils/async-handler.js';
import {
  deleteArticle,
  deleteCategory,
  getAnalyticsOverview,
  listAdminNews,
  listAuthorArticles,
  listCategories,
  listUsers,
  upsertArticle,
  upsertCategory,
} from '../services/news.service.js';

export const getAdminNews = asyncHandler(async (req, res) => {
  const data = await listAdminNews();
  res.json({ success: true, data });
});

export const saveAdminArticle = asyncHandler(async (req, res) => {
  const auth = req.auth;
  const body = req.validated.body;
  const data = await upsertArticle(req.params.articleId, {
    ...body,
    author: body.author || auth.name || body.source,
    createdBy: {
      id: auth.sub,
      email: auth.email,
      name: auth.name || body.author,
      role: auth.role,
    },
    createdById: auth.sub,
  });
  res.status(req.params.articleId ? 200 : 201).json({ success: true, data });
});

export const getAuthorNews = asyncHandler(async (req, res) => {
  const data = await listAuthorArticles(req.auth.sub);
  res.json({ success: true, data });
});

export const removeAdminArticle = asyncHandler(async (req, res) => {
  await deleteArticle(req.params.articleId);
  res.status(204).send();
});

export const getAdminCategories = asyncHandler(async (req, res) => {
  const data = await listCategories();
  res.json({ success: true, data });
});

export const saveAdminCategory = asyncHandler(async (req, res) => {
  const data = await upsertCategory(req.params.slug, req.validated.body);
  res.status(200).json({ success: true, data });
});

export const removeAdminCategory = asyncHandler(async (req, res) => {
  await deleteCategory(req.params.slug);
  res.status(204).send();
});

export const getAdminUsers = asyncHandler(async (req, res) => {
  const data = await listUsers();
  res.json({ success: true, data });
});

export const getAdminAnalytics = asyncHandler(async (req, res) => {
  const data = await getAnalyticsOverview();
  res.json({ success: true, data });
});

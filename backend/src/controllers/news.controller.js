import { asyncHandler } from '../utils/async-handler.js';
import {
  getArticleById,
  getHomeFeed,
  searchArticles,
  trackInteraction,
} from '../services/news.service.js';

export const getHome = asyncHandler(async (req, res) => {
  const { category, page, pageSize, interests } = req.query;
  const data = await getHomeFeed({
    category,
    page: Number(page || 1),
    pageSize: Number(pageSize || 6),
    interests: interests ? interests.split(',') : [],
  });

  res.json({ success: true, data });
});

export const searchNews = asyncHandler(async (req, res) => {
  const data = await searchArticles(req.query);
  res.json({ success: true, data });
});

export const getNewsById = asyncHandler(async (req, res) => {
  const data = await getArticleById(req.params.articleId);
  res.json({ success: true, data });
});

export const createInteraction = asyncHandler(async (req, res) => {
  const data = await trackInteraction(
    req.params.articleId,
    req.validated.body.type,
  );
  res.status(201).json({ success: true, data });
});

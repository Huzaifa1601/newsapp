import { Router } from 'express';

import adminRoutes from './admin.routes.js';
import authRoutes from './auth.routes.js';
import newsRoutes from './news.routes.js';

const router = Router();

router.get('/health', (req, res) => {
  res.json({ success: true, message: 'PulseWire backend is healthy.' });
});

router.use('/auth', authRoutes);
router.use('/news', newsRoutes);
router.use('/admin', adminRoutes);

export default router;

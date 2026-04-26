import cors from 'cors';
import express from 'express';
import helmet from 'helmet';
import morgan from 'morgan';

import { env } from './config/env.js';
import { errorHandler, notFoundHandler } from './middlewares/error.middleware.js';
import routes from './routes/index.js';

const app = express();

app.use(
  cors({
    origin: true, // allow all
    credentials: true,
  }),
);
app.use(
  helmet({
    contentSecurityPolicy: false,
  }),
);
app.use(express.json({ limit: '1mb' }));
app.use(morgan(env.nodeEnv === 'development' ? 'dev' : 'combined'));

app.use('/api/v1', routes);

app.use(notFoundHandler);
app.use(errorHandler);

export default app;

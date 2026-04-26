import app from './app.js';
import { env } from './config/env.js';

app.listen(env.port, () => {
  console.log(`PulseWire backend listening on port ${env.port}`);
});

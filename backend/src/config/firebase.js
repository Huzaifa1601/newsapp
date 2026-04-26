import { cert, getApps, initializeApp } from 'firebase-admin/app';
import { getAuth } from 'firebase-admin/auth';
import { getFirestore } from 'firebase-admin/firestore';
import { getStorage } from 'firebase-admin/storage';

import fs from 'fs';

let firebaseApp = null;
let firebaseEnabled = false;

try {
  const serviceAccount = JSON.parse(
    fs.readFileSync(new URL('./serviceAccount.json', import.meta.url)),
  );

  firebaseApp =
    getApps()[0] ||
    initializeApp({
      credential: cert(serviceAccount),
      projectId: serviceAccount.project_id,
      storageBucket: `${serviceAccount.project_id}.appspot.com`,
    });

  firebaseEnabled = true;
} catch (error) {
  console.warn(
    'Firebase Admin could not be initialized. Falling back to local in-memory mode.',
  );
}

export const db = firebaseApp ? getFirestore(firebaseApp) : null;
export const adminAuth = firebaseApp ? getAuth(firebaseApp) : null;
export const storage = firebaseApp ? getStorage(firebaseApp) : null;
export { firebaseEnabled };

import { db, firebaseEnabled } from '../config/firebase.js';
import { sampleArticles, sampleCategories } from '../data/sample-articles.js';

if (!firebaseEnabled || !db) {
  console.error('Firestore is not enabled. Check Firebase Admin configuration.');
  process.exit(1);
}

const demoAuthor = {
  id: 'author-demo',
  name: 'PulseWire Author',
  email: 'author@pulsewire.app',
  password: 'author123',
  bio: 'News author demo account',
  createdAt: new Date().toISOString(),
};

async function seed() {
  const batch = db.batch();

  for (const category of sampleCategories) {
    const ref = db.collection('categories').doc(category.slug);
    batch.set(ref, category, { merge: true });
  }

  for (const article of sampleArticles) {
    const ref = db.collection('articles').doc(article.id);
    batch.set(
      ref,
      {
        ...article,
        createdBy: {
          id: demoAuthor.id,
          email: demoAuthor.email,
          name: demoAuthor.name,
          role: 'author',
        },
        createdById: demoAuthor.id,
      },
      { merge: true },
    );
  }

  batch.set(db.collection('authors').doc(demoAuthor.id), demoAuthor, { merge: true });

  await batch.commit();

  const [authors, articles, categories] = await Promise.all([
    db.collection('authors').get(),
    db.collection('articles').get(),
    db.collection('categories').get(),
  ]);

  console.log(
    JSON.stringify({
      success: true,
      authors: authors.size,
      articles: articles.size,
      categories: categories.size,
    }),
  );
}

seed().catch((error) => {
  console.error(error);
  process.exit(1);
});

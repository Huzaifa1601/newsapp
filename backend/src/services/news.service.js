import { adminAuth, db, firebaseEnabled } from '../config/firebase.js';
import { sampleArticles, sampleCategories } from '../data/sample-articles.js';
import { ApiError } from '../utils/api-error.js';

const memoryStore = {
  articles: [...sampleArticles],
  categories: [...sampleCategories],
  interactions: [],
  authors: [
    {
      id: 'author-demo',
      name: 'PulseWire Author',
      email: 'author@pulsewire.app',
      password: 'author123',
      bio: 'News author demo account',
    },
  ],
};

const normalizeArticle = (article) => ({
  ...article,
  likes: Number(article.likes || 0),
  views: Number(article.views || 0),
  publishedAt:
    typeof article.publishedAt === 'string'
      ? article.publishedAt
      : article.publishedAt?.toDate?.().toISOString?.() ||
        new Date(article.publishedAt || Date.now()).toISOString(),
});

const sortByDate = (articles) =>
  [...articles].sort(
    (a, b) => new Date(b.publishedAt).getTime() - new Date(a.publishedAt).getTime(),
  );

const sortByPopularity = (articles) =>
  [...articles].sort((a, b) => b.views + b.likes - (a.views + a.likes));

async function readArticlesFromStore() {
  if (!firebaseEnabled || !db) {
    return sortByDate(memoryStore.articles);
  }

  const snapshot = await db.collection('articles').orderBy('publishedAt', 'desc').get();
  return snapshot.docs.map((doc) => normalizeArticle({ id: doc.id, ...doc.data() }));
}

async function readCategoriesFromStore() {
  if (!firebaseEnabled || !db) {
    return memoryStore.categories;
  }

  const snapshot = await db.collection('categories').orderBy('title').get();
  if (snapshot.empty) {
    return memoryStore.categories;
  }

  return snapshot.docs.map((doc) => ({ slug: doc.id, ...doc.data() }));
}

export async function getHomeFeed({
  category = 'all',
  page = 1,
  pageSize = 6,
  interests = [],
}) {
  const articles = await readArticlesFromStore();
  const categories = await readCategoriesFromStore();
  const scoped =
    category === 'all'
      ? articles
      : articles.filter((article) => article.category === category);

  const personalized = [...articles].sort((a, b) => {
    const aScore = (interests.includes(a.category) ? 1000 : 0) + a.views + a.likes;
    const bScore = (interests.includes(b.category) ? 1000 : 0) + b.views + b.likes;
    return bScore - aScore;
  });

  const offset = Math.max(0, (page - 1) * pageSize);
  const feed = scoped.slice(offset, offset + pageSize);

  return {
    categories,
    breakingNews: articles.filter((article) => article.isBreaking).slice(0, 4),
    trendingNews: sortByPopularity(articles).slice(0, 5),
    personalizedNews: personalized.slice(0, 5),
    feed,
    hasMore: offset + pageSize < scoped.length,
    nextPage: page + 1,
  };
}

export async function searchArticles({
  query = '',
  category = 'all',
  sortBy = 'latest',
  dateRange = 'all',
}) {
  const lower = query.toLowerCase();
  const now = Date.now();
  const articles = await readArticlesFromStore();

  const filtered = articles.filter((article) => {
    const categoryMatch = category === 'all' || article.category === category;
    const queryMatch =
      article.title.toLowerCase().includes(lower) ||
      article.summary.toLowerCase().includes(lower) ||
      article.tags.some((tag) => tag.toLowerCase().includes(lower));

    const publishedAt = new Date(article.publishedAt).getTime();
    const dateMatch =
      dateRange === 'today'
        ? publishedAt >= now - 24 * 60 * 60 * 1000
        : dateRange === 'week'
          ? publishedAt >= now - 7 * 24 * 60 * 60 * 1000
          : dateRange === 'month'
            ? publishedAt >= now - 30 * 24 * 60 * 60 * 1000
            : true;

    return categoryMatch && queryMatch && dateMatch;
  });

  return sortBy === 'popular' ? sortByPopularity(filtered) : sortByDate(filtered);
}

export async function getArticleById(articleId) {
  if (firebaseEnabled && db) {
    const snapshot = await db.collection('articles').doc(articleId).get();
    if (snapshot.exists) {
      return normalizeArticle({ id: snapshot.id, ...snapshot.data() });
    }
  }

  const article = memoryStore.articles.find((item) => item.id === articleId);
  if (!article) {
    throw new ApiError(404, 'Article not found.');
  }
  return article;
}

export async function trackInteraction(articleId, type) {
  const interaction = {
    articleId,
    type,
    createdAt: new Date().toISOString(),
  };

  memoryStore.interactions.push(interaction);

  if (firebaseEnabled && db) {
    await db.collection('interactions').add(interaction);
  }

  return interaction;
}

export async function listAdminNews() {
  return readArticlesFromStore();
}

export async function upsertArticle(articleId, payload) {
  const article = normalizeArticle({
    id: articleId || `article-${Date.now()}`,
    ...payload,
    publishedAt: payload.publishedAt || new Date().toISOString(),
    tags: payload.tags || [],
  });

  if (firebaseEnabled && db) {
    await db.collection('articles').doc(article.id).set(article, { merge: true });
  }

  const index = memoryStore.articles.findIndex((item) => item.id === article.id);
  if (index >= 0) {
    memoryStore.articles[index] = article;
  } else {
    memoryStore.articles.unshift(article);
  }

  return article;
}

export async function listAuthorArticles(authorId) {
  const articles = await readArticlesFromStore();
  return articles.filter(
    (article) =>
      article.createdBy?.id === authorId || article.createdById === authorId,
  );
}

export async function deleteArticle(articleId) {
  if (firebaseEnabled && db) {
    await db.collection('articles').doc(articleId).delete();
  }

  memoryStore.articles = memoryStore.articles.filter((item) => item.id !== articleId);
}

export async function listCategories() {
  return readCategoriesFromStore();
}

export async function upsertCategory(slug, payload) {
  const category = { slug, ...payload };

  if (firebaseEnabled && db) {
    await db.collection('categories').doc(slug).set(category, { merge: true });
  }

  const index = memoryStore.categories.findIndex((item) => item.slug === slug);
  if (index >= 0) {
    memoryStore.categories[index] = category;
  } else {
    memoryStore.categories.push(category);
  }

  return category;
}

export async function deleteCategory(slug) {
  if (firebaseEnabled && db) {
    await db.collection('categories').doc(slug).delete();
  }

  memoryStore.categories = memoryStore.categories.filter((item) => item.slug !== slug);
}

export async function listUsers() {
  if (firebaseEnabled && adminAuth) {
    const snapshot = await adminAuth.listUsers(100);
    return snapshot.users.map((user) => ({
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      disabled: user.disabled,
    }));
  }

  return [
    {
      uid: 'demo-user',
      email: 'reader@pulsewire.app',
      displayName: 'Demo Reader',
      disabled: false,
    },
  ];
}

export async function registerAuthor({ name, email, password, bio = '' }) {
  const normalizedEmail = email.toLowerCase().trim();
  const existingAuthor = memoryStore.authors.find(
    (author) => author.email === normalizedEmail,
  );

  if (existingAuthor) {
    throw new ApiError(409, 'Author already exists with this email.');
  }

  const author = {
    id: `author-${Date.now()}`,
    name,
    email: normalizedEmail,
    password,
    bio,
  };

  memoryStore.authors.push(author);

  if (firebaseEnabled && db) {
    await db.collection('authors').doc(author.id).set({
      id: author.id,
      name: author.name,
      email: author.email,
      password: author.password,
      bio: author.bio,
      createdAt: new Date().toISOString(),
    });
  }

  return {
    id: author.id,
    name: author.name,
    email: author.email,
    bio: author.bio,
  };
}

export async function loginAuthor({ email, password }) {
  const normalizedEmail = email.toLowerCase().trim();

  if (firebaseEnabled && db) {
    const snapshot = await db
      .collection('authors')
      .where('email', '==', normalizedEmail)
      .limit(1)
      .get();

    if (!snapshot.empty) {
      const author = snapshot.docs[0].data();
      if (author.password !== password) {
        throw new ApiError(401, 'Invalid author credentials.');
      }

      return {
        id: author.id || snapshot.docs[0].id,
        name: author.name,
        email: author.email,
        bio: author.bio || '',
      };
    }
  }

  const author = memoryStore.authors.find(
    (item) => item.email === normalizedEmail && item.password === password,
  );

  if (!author) {
    throw new ApiError(401, 'Invalid author credentials.');
  }

  return {
    id: author.id,
    name: author.name,
    email: author.email,
    bio: author.bio,
  };
}

export async function getAnalyticsOverview() {
  const [articles, categories, users] = await Promise.all([
    readArticlesFromStore(),
    readCategoriesFromStore(),
    listUsers(),
  ]);

  return {
    totals: {
      articles: articles.length,
      categories: categories.length,
      users: users.length,
      interactions: memoryStore.interactions.length,
    },
    topCategories: categories.map((category) => ({
      slug: category.slug,
      title: category.title,
      volume: articles.filter((article) => article.category === category.slug).length,
    })),
    topArticles: sortByPopularity(articles).slice(0, 5),
  };
}

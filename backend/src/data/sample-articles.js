const now = Date.now();

export const sampleCategories = [
  {
    slug: 'technology',
    title: 'Technology',
    description: 'AI, devices, software, and future-facing products.',
  },
  {
    slug: 'business',
    title: 'Business',
    description: 'Markets, strategy, consumers, and company movement.',
  },
  {
    slug: 'politics',
    title: 'Politics',
    description: 'Power, policy, and public decision-making.',
  },
  {
    slug: 'world',
    title: 'World',
    description: 'Global context and major regional shifts.',
  },
  {
    slug: 'sports',
    title: 'Sports',
    description: 'Performance, tactics, and high-stakes competition.',
  },
  {
    slug: 'science',
    title: 'Science',
    description: 'Climate, space, and emerging research.',
  },
];

export const sampleArticles = [
  {
    id: 'pw-001',
    title: 'AI assistants are moving from chat to operations inside large companies',
    subtitle: 'Enterprises are reorganizing workflows around task-native copilots.',
    summary:
      'Large organizations are shifting AI from experimental chat windows into core internal workflows.',
    content:
      'Companies are using AI to triage work, pre-assemble decisions, and reduce manual processing time across support, finance, and legal teams.',
    author: 'PulseWire Desk',
    source: 'PulseWire Labs',
    imageUrl:
      'https://images.unsplash.com/photo-1677442136019-21780ecad995?auto=format&fit=crop&w=1200&q=80',
    category: 'technology',
    publishedAt: new Date(now - 2 * 60 * 60 * 1000).toISOString(),
    readTimeMinutes: 6,
    isBreaking: true,
    views: 9240,
    likes: 640,
    tags: ['ai', 'enterprise', 'automation'],
  },
  {
    id: 'pw-002',
    title: 'Urban delivery startups are quietly becoming logistics infrastructure',
    subtitle: 'Reliability is replacing spectacle as the key growth story.',
    summary:
      'Instant delivery players are evolving into disciplined local infrastructure businesses.',
    content:
      'Operators are winning by improving route stability, dark-store density, and merchant relationships.',
    author: 'PulseWire Desk',
    source: 'PulseWire Markets',
    imageUrl:
      'https://images.unsplash.com/photo-1556740749-887f6717d7e4?auto=format&fit=crop&w=1200&q=80',
    category: 'business',
    publishedAt: new Date(now - 5 * 60 * 60 * 1000).toISOString(),
    readTimeMinutes: 5,
    isBreaking: false,
    views: 7310,
    likes: 480,
    tags: ['logistics', 'retail', 'startups'],
  },
  {
    id: 'pw-003',
    title: 'A climate pact on port emissions is changing shipping incentives',
    subtitle: 'Harbor regulation is reshaping fleet decisions on major routes.',
    summary:
      'New emissions frameworks are pushing carriers to rethink vessel mix and procurement strategy.',
    content:
      'Port access incentives tied to cleaner operations are altering shipping economics and freight planning.',
    author: 'PulseWire Desk',
    source: 'PulseWire World',
    imageUrl:
      'https://images.unsplash.com/photo-1473448912268-2022ce9509d8?auto=format&fit=crop&w=1200&q=80',
    category: 'world',
    publishedAt: new Date(now - 8 * 60 * 60 * 1000).toISOString(),
    readTimeMinutes: 7,
    isBreaking: false,
    views: 6820,
    likes: 402,
    tags: ['climate', 'shipping', 'policy'],
  },
  {
    id: 'pw-004',
    title: 'The new campaign battleground is local trust, not national volume',
    subtitle: 'Organizers are moving from broad saturation to neighborhood credibility.',
    summary:
      'Campaign teams are investing more in smaller trust networks and less in generic digital reach.',
    content:
      'Ground operations now emphasize messenger credibility, local framing, and lower-noise contact strategies.',
    author: 'PulseWire Desk',
    source: 'PulseWire Politics',
    imageUrl:
      'https://images.unsplash.com/photo-1529107386315-e1a2ed48a620?auto=format&fit=crop&w=1200&q=80',
    category: 'politics',
    publishedAt: new Date(now - 12 * 60 * 60 * 1000).toISOString(),
    readTimeMinutes: 4,
    isBreaking: true,
    views: 8450,
    likes: 560,
    tags: ['elections', 'campaigns', 'voters'],
  },
  {
    id: 'pw-005',
    title: 'A data-first coaching model is changing how clubs manage fatigue',
    subtitle: 'Elite teams are connecting recovery science with tactical planning.',
    summary:
      'Coaching staffs are blending wearables, sleep, and travel metrics into matchday decisions.',
    content:
      'Performance teams increasingly influence pressing intensity, rotation planning, and substitution timing.',
    author: 'PulseWire Desk',
    source: 'PulseWire Sports',
    imageUrl:
      'https://images.unsplash.com/photo-1517649763962-0c623066013b?auto=format&fit=crop&w=1200&q=80',
    category: 'sports',
    publishedAt: new Date(now - 18 * 60 * 60 * 1000).toISOString(),
    readTimeMinutes: 5,
    isBreaking: false,
    views: 6130,
    likes: 398,
    tags: ['football', 'performance', 'analytics'],
  },
  {
    id: 'pw-006',
    title: 'Scientists are rethinking drought prediction around soil memory',
    subtitle: 'Researchers say land itself may preserve stronger warning signals.',
    summary:
      'Forecasting models may improve by tracking how soil carries stress across seasons.',
    content:
      'Earlier drought warnings can be driven by land condition, not rainfall metrics alone.',
    author: 'PulseWire Desk',
    source: 'PulseWire Science',
    imageUrl:
      'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',
    category: 'science',
    publishedAt: new Date(now - 24 * 60 * 60 * 1000).toISOString(),
    readTimeMinutes: 7,
    isBreaking: false,
    views: 5920,
    likes: 431,
    tags: ['climate', 'research', 'drought'],
  },
];

import '../../domain/entities/news_article.dart';

final sampleCategories = <NewsCategory>[
  const NewsCategory(
    slug: 'technology',
    title: 'Technology',
    description: 'AI, startups, devices, and future-shaping products.',
  ),
  const NewsCategory(
    slug: 'business',
    title: 'Business',
    description: 'Markets, companies, consumer shifts, and strategy.',
  ),
  const NewsCategory(
    slug: 'politics',
    title: 'Politics',
    description: 'Policy, elections, diplomacy, and public power.',
  ),
  const NewsCategory(
    slug: 'sports',
    title: 'Sports',
    description: 'Momentum, rivalry, and match-changing performances.',
  ),
  const NewsCategory(
    slug: 'science',
    title: 'Science',
    description: 'Space, climate, health, and emerging discoveries.',
  ),
  const NewsCategory(
    slug: 'culture',
    title: 'Culture',
    description: 'Design, media, fashion, and the ideas people share.',
  ),
  const NewsCategory(
    slug: 'health',
    title: 'Health',
    description: 'Wellness, medicine, policy, and care systems.',
  ),
  const NewsCategory(
    slug: 'world',
    title: 'World',
    description: 'Global context, fast-moving regions, and big-picture shifts.',
  ),
];

final sampleArticles = <NewsArticle>[
  NewsArticle(
    id: 'pw-001',
    title:
        'AI assistants are moving from chat to operations inside large companies',
    subtitle:
        'Enterprises are reorganizing workflows around task-native copilots.',
    summary:
        'From legal review queues to customer support escalations, AI tools are shifting from suggestion layers into operational systems with real responsibility.',
    content:
        'Large companies are no longer treating AI as a novelty bolted onto chat windows. Teams across finance, support, logistics, and legal are now redesigning workflows around assistants that can triage requests, prepare decisions, and route work before a human even opens the ticket.\n\nThat shift changes the economics of internal software. Instead of asking whether AI can write a draft, leaders are asking whether the draft should ever have needed a person to assemble in the first place. The result is a new focus on orchestration, permissioning, audit trails, and the design of human overrides.\n\nAnalysts say the next phase will reward companies that treat AI as product infrastructure rather than a demo feature. The winners may be the teams with the clearest operational boundaries, not necessarily the flashiest models.',
    author: 'Sana Mirza',
    source: 'PulseWire Labs',
    imageUrl:
        'https://images.unsplash.com/photo-1677442136019-21780ecad995?auto=format&fit=crop&w=1200&q=80',
    category: 'technology',
    publishedAt: DateTime.now().subtract(const Duration(hours: 2)),
    readTimeMinutes: 6,
    isBreaking: true,
    views: 9240,
    likes: 640,
    tags: const ['ai', 'enterprise', 'automation'],
  ),
  NewsArticle(
    id: 'pw-002',
    title:
        'Urban delivery startups are quietly becoming logistics infrastructure',
    subtitle: 'The fastest operators are winning by owning boring reliability.',
    summary:
        'Instant delivery is maturing into city-scale infrastructure as operators optimize for routing consistency, dark stores, and profitable density.',
    content:
        'The biggest story in urban delivery is no longer speed alone. It is reliability at neighborhood scale. Startups that once marketed ten-minute spectacle are now building disciplined systems for routing, stocking, and predicting where demand will emerge block by block.\n\nInvestors tracking the category say a smaller number of operators now control much stronger local networks. That gives them leverage with merchants, better purchasing visibility, and a more defensible customer promise. The challenge is that infrastructure businesses rarely feel glamorous in the middle of being built.\n\nConsumers mostly notice the outcome rather than the architecture. Orders arrive when promised. Substitutions happen less often. Refunds are faster. In crowded categories, that kind of operational trust can become the strongest brand signal of all.',
    author: 'Rafiq Noor',
    source: 'PulseWire Markets',
    imageUrl:
        'https://images.unsplash.com/photo-1556740749-887f6717d7e4?auto=format&fit=crop&w=1200&q=80',
    category: 'business',
    publishedAt: DateTime.now().subtract(const Duration(hours: 5)),
    readTimeMinutes: 5,
    isBreaking: false,
    views: 7310,
    likes: 480,
    tags: const ['startups', 'logistics', 'retail'],
  ),
  NewsArticle(
    id: 'pw-003',
    title: 'A climate pact on port emissions is changing shipping incentives',
    subtitle:
        'Harbor regulation is pushing carriers toward cleaner short-route fleets.',
    summary:
        'A new cross-border emissions framework is accelerating vessel upgrades and changing how major carriers prioritize port-to-port routes.',
    content:
        'Shipping policy rarely produces public excitement, but port emissions agreements can quickly alter fleet economics. New compliance rules tied to berth access and fee structures are pushing carriers to prioritize cleaner short-route vessels for some of the world’s busiest corridors.\n\nOperators say the transition is uneven. Large carriers can spread capital costs across more routes, while smaller firms face tighter financing conditions. Port authorities argue that without measurable incentives, cleaner fuel adoption would continue to move too slowly.\n\nThe effect may be most visible in freight pricing and procurement strategy. Retailers and manufacturers increasingly want emissions reporting tied directly to route planning, not broad annual sustainability claims. That pressure turns climate regulation into a commercial differentiator.',
    author: 'Hira Zulfiqar',
    source: 'PulseWire World',
    imageUrl:
        'https://images.unsplash.com/photo-1473448912268-2022ce9509d8?auto=format&fit=crop&w=1200&q=80',
    category: 'world',
    publishedAt: DateTime.now().subtract(const Duration(hours: 8)),
    readTimeMinutes: 7,
    isBreaking: false,
    views: 6820,
    likes: 402,
    tags: const ['climate', 'shipping', 'policy'],
  ),
  NewsArticle(
    id: 'pw-004',
    title: 'The new campaign battleground is local trust, not national volume',
    subtitle:
        'Ground organizers are rebuilding neighborhood networks with data-light tactics.',
    summary:
        'Political teams are moving resources into smaller, trust-driven community efforts as broad digital saturation loses efficiency.',
    content:
        'Campaign strategists once obsessed over national reach are now paying closer attention to local trust networks. Organizers say broad social volume often fails to persuade voters who have tuned out constant political noise.\n\nIn response, some campaigns are investing in lower-scale but more durable tactics: community events, volunteer-led text chains, and hyperlocal issue framing that feels tied to everyday life rather than abstract national narratives. Data still matters, but the emphasis is shifting from maximum targeting to credible messengers.\n\nThat change may benefit candidates who can maintain consistency over time. Trust is expensive to build and hard to fake on short notice. In tight races, the strongest advantage may come from who has relationships already in motion.',
    author: 'Muneeb Ashraf',
    source: 'PulseWire Politics',
    imageUrl:
        'https://images.unsplash.com/photo-1529107386315-e1a2ed48a620?auto=format&fit=crop&w=1200&q=80',
    category: 'politics',
    publishedAt: DateTime.now().subtract(const Duration(hours: 12)),
    readTimeMinutes: 4,
    isBreaking: true,
    views: 8450,
    likes: 560,
    tags: const ['elections', 'campaigns', 'voters'],
  ),
  NewsArticle(
    id: 'pw-005',
    title: 'A data-first coaching model is changing how clubs manage fatigue',
    subtitle:
        'Elite teams are merging training science with matchday substitutions.',
    summary:
        'Wearables, travel metrics, and recovery windows are shaping tactical decisions earlier than ever in the season.',
    content:
        'Top clubs are expanding performance teams beyond strength coaches and analysts into full fatigue-management units. The aim is not only fewer injuries but smarter tactical planning over dense schedules.\n\nCoaches increasingly review recovery dashboards before deciding how aggressively to press or when to rotate key players. Some clubs even model substitution timing against travel strain and sleep disruption rather than pure match rhythm.\n\nCritics argue that over-measurement can flatten instinct, but the strongest staffs are using data as a conversation tool rather than a command center. When applied well, it sharpens decision-making without replacing the human read of a game.',
    author: 'Areeba Kamal',
    source: 'PulseWire Sports',
    imageUrl:
        'https://images.unsplash.com/photo-1517649763962-0c623066013b?auto=format&fit=crop&w=1200&q=80',
    category: 'sports',
    publishedAt: DateTime.now().subtract(const Duration(hours: 18)),
    readTimeMinutes: 5,
    isBreaking: false,
    views: 6130,
    likes: 398,
    tags: const ['football', 'performance', 'analytics'],
  ),
  NewsArticle(
    id: 'pw-006',
    title: 'Scientists are rethinking drought prediction around soil memory',
    subtitle:
        'New models suggest land itself carries usable signals across seasons.',
    summary:
        'Researchers say soil conditions may preserve longer-term stress signals that improve regional drought forecasting beyond rainfall metrics alone.',
    content:
        'Drought models have traditionally leaned heavily on rainfall, temperature, and reservoir data. A growing body of research argues that soil memory itself may be one of the missing indicators that explains why similar weather patterns can produce very different agricultural outcomes.\n\nBy tracking how land retains stress across seasons, researchers believe forecasters can issue earlier warnings for crop risk and water management. That could help regional planners make less reactive decisions, especially in areas where rainfall arrives unevenly.\n\nThe practical benefit is not perfect prediction. It is better timing. In climate adaptation, earlier signals can matter more than higher certainty delivered too late.',
    author: 'Dr. Farah Siddiqi',
    source: 'PulseWire Science',
    imageUrl:
        'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',
    category: 'science',
    publishedAt: DateTime.now().subtract(const Duration(days: 1)),
    readTimeMinutes: 7,
    isBreaking: false,
    views: 5920,
    likes: 431,
    tags: const ['climate', 'drought', 'research'],
  ),
  NewsArticle(
    id: 'pw-007',
    title:
        'Streaming platforms are commissioning fewer shows with stronger identity',
    subtitle: 'Studios want cultural signal, not just volume on the slate.',
    summary:
        'Executives are shifting budgets toward projects with clearer audience identity as the economics of endless content become harder to justify.',
    content:
        'The era of unconstrained streaming expansion appears to be ending. Platforms are commissioning fewer projects but applying more scrutiny to how each title fits brand identity, subscriber behavior, and international resonance.\n\nThat does not necessarily mean safer creative work. In some cases it means the opposite. If a platform is backing fewer originals, it may need each one to feel distinct enough to cut through a crowded release calendar. Broadly average programming is becoming harder to defend when marketing budgets are tighter.\n\nFor viewers, the result may be smaller libraries but sharper editorial intent. For creators, the pitch requirement is shifting from “Can this fill a slot?” to “Why should this exist here?”',
    author: 'Nadia Iqbal',
    source: 'PulseWire Culture',
    imageUrl:
        'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?auto=format&fit=crop&w=1200&q=80',
    category: 'culture',
    publishedAt: DateTime.now().subtract(const Duration(days: 1, hours: 5)),
    readTimeMinutes: 4,
    isBreaking: false,
    views: 5440,
    likes: 512,
    tags: const ['streaming', 'media', 'culture'],
  ),
  NewsArticle(
    id: 'pw-008',
    title: 'Primary care apps are becoming long-term health companions',
    subtitle: 'The strongest products are winning on continuity, not novelty.',
    summary:
        'Digital health platforms are broadening from appointment access into persistent care journeys with reminders, triage, and habit support.',
    content:
        'Health apps once focused mainly on faster booking and lighter admin overhead. The next competitive layer is continuity: keeping patients engaged between visits and making care feel easier to sustain over time.\n\nThat includes medication reminders, asynchronous follow-up, structured symptom check-ins, and clearer handoffs between clinicians. The goal is not simply more screen time. It is less friction in the parts of care that usually fall apart after a consultation ends.\n\nProviders say trust remains the hardest part. Patients will use digital tools if they feel helpful and discreet, but they quickly disengage when products become noisy, sales-driven, or confusing. In health, restraint can be a feature.',
    author: 'Dr. Amal Haider',
    source: 'PulseWire Health',
    imageUrl:
        'https://images.unsplash.com/photo-1576091160550-2173dba999ef?auto=format&fit=crop&w=1200&q=80',
    category: 'health',
    publishedAt: DateTime.now().subtract(const Duration(days: 1, hours: 9)),
    readTimeMinutes: 6,
    isBreaking: false,
    views: 4880,
    likes: 377,
    tags: const ['healthtech', 'care', 'apps'],
  ),
  NewsArticle(
    id: 'pw-009',
    title:
        'Chipmakers are rebuilding product roadmaps around energy efficiency',
    subtitle:
        'The next wave of device competition may hinge on power budgets more than peak speed.',
    summary:
        'From handheld gaming to on-device AI, efficiency gains are becoming the most commercially meaningful metric across new silicon launches.',
    content:
        'Performance still headlines most chip announcements, but product strategy is increasingly centered on energy efficiency. As devices take on more local AI workloads, thermal limits and battery expectations are becoming the real competitive boundary.\n\nManufacturers say customers want fast systems, but they also want silence, longevity, and fewer compromises in mobile form factors. That makes efficiency improvements more visible to users than benchmark spikes alone.\n\nThe result is a broader redesign cycle across laptops, phones, and embedded hardware. Faster is good. Faster without extra drain is what changes product categories.',
    author: 'Usman Tariq',
    source: 'PulseWire Tech',
    imageUrl:
        'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=1200&q=80',
    category: 'technology',
    publishedAt: DateTime.now().subtract(const Duration(days: 2)),
    readTimeMinutes: 5,
    isBreaking: false,
    views: 7770,
    likes: 589,
    tags: const ['chips', 'hardware', 'devices'],
  ),
  NewsArticle(
    id: 'pw-010',
    title:
        'Consumers are choosing fewer luxury purchases but expecting more meaning',
    subtitle: 'Brands are leaning into craftsmanship, repair, and permanence.',
    summary:
        'Luxury demand is holding up best where products can justify emotional and practical staying power instead of constant novelty.',
    content:
        'Luxury brands are adapting to a consumer mood that feels more selective than expansive. Customers may still spend, but they increasingly want a story of permanence, repairability, or craft depth that justifies the price.\n\nThat shift favors products that can survive beyond the moment of purchase. Repair programs, limited production runs, and transparent material sourcing are becoming part of the value narrative rather than niche afterthoughts.\n\nIn uncertain economies, meaning itself becomes a commercial variable. Items that feel durable in both quality and identity tend to outperform those that rely only on hype.',
    author: 'Ayla Rehman',
    source: 'PulseWire Business',
    imageUrl:
        'https://images.unsplash.com/photo-1523381210434-271e8be1f52b?auto=format&fit=crop&w=1200&q=80',
    category: 'business',
    publishedAt: DateTime.now().subtract(const Duration(days: 2, hours: 6)),
    readTimeMinutes: 4,
    isBreaking: false,
    views: 4690,
    likes: 321,
    tags: const ['luxury', 'retail', 'consumer'],
  ),
];

# PulseWire

PulseWire is a premium news platform scaffold built as a full-stack starter:

- Flutter mobile client in `D:\newsapp\news_app`
- Node.js + Express backend in `D:\newsapp\backend`
- Firebase-ready architecture using Firestore, Auth, and Storage
- Riverpod state management with a clean layered structure
- Premium UI with Material 3, glassmorphism accents, onboarding, auth, home feed, search, detail, bookmarks, and profile

## Project Structure

```text
D:\newsapp
|- backend
|  |- src
|  |  |- config
|  |  |- controllers
|  |  |- middlewares
|  |  |- routes
|  |  |- services
|  |  |- utils
|- news_app
|  |- lib
|  |  |- app
|  |  |- core
|  |  |- features
|  |  |  |- auth
|  |  |  |- news
|  |  |  |- onboarding
|  |  |  |- profile
|  |  |  |- settings
|  |  |  |- shell
```

## Flutter Setup

1. Open `D:\newsapp\news_app`
2. Install dependencies:

```bash
flutter pub get
```

3. Configure Firebase for the app:

```bash
flutterfire configure
```

4. Run the app with a backend URL:

```bash
flutter run --dart-define=BACKEND_BASE_URL=http://10.0.2.2:4000/api/v1
```

For iOS Simulator, replace the backend URL with `http://localhost:4000/api/v1`.

### Windows Notes

- Enable Windows Developer Mode so Flutter can create plugin symlinks.
- Install Visual Studio Build Tools with C/C++ support if native asset hooks are required during tests on Windows.

## Backend Setup

1. Open `D:\newsapp\backend`
2. Create `.env` from `.env.example`
3. Install dependencies:

```bash
npm install
```

4. Start the API:

```bash
npm run dev
```

The backend starts on `http://localhost:4000` by default and exposes routes under `/api/v1`.

## Firebase Notes

The scaffold is designed to work in two modes:

- Full cloud mode using Firebase Admin and FlutterFire configuration
- Local fallback mode using sample data so the UI and API shape can be previewed before Firebase is wired

### Mobile Firebase services used

- `firebase_core`
- `firebase_auth`
- `cloud_firestore`
- `firebase_storage`
- `firebase_messaging`
- `google_sign_in`

### Backend Firebase services used

- Firestore for articles, categories, and interactions
- Firebase Auth for token verification and user management
- Firebase Storage for media hosting

## Key Mobile Features Implemented

- Animated splash screen
- 4-step onboarding
- Email/password auth
- Google sign-in wiring
- Forgot password flow
- Guest preview mode
- Home screen with:
  - Breaking carousel
  - Category chips
  - Trending section
  - Personalized section
  - Infinite scroll
  - Pull-to-refresh
  - Skeleton loading
- Search with:
  - Debounced queries
  - Suggestions
  - Category, date, and popularity filters
  - Voice search hook
- Article detail with:
  - Hero image
  - Share
  - Bookmark
  - Text-to-speech hook
  - Related stories
- Bookmarks with local cache
- Profile with:
  - Avatar card
  - Reading history
  - Theme toggle
  - Category preferences
  - Language toggle

## Key Backend Features Implemented

- Health route
- Public news endpoints:
  - `GET /api/v1/news/home`
  - `GET /api/v1/news/search`
  - `GET /api/v1/news/:articleId`
  - `POST /api/v1/news/:articleId/interactions`
- Admin auth:
  - `POST /api/v1/auth/session`
- JWT-protected admin endpoints:
  - `GET /api/v1/admin/news`
  - `POST /api/v1/admin/news`
  - `PUT /api/v1/admin/news/:articleId`
  - `DELETE /api/v1/admin/news/:articleId`
  - `GET /api/v1/admin/categories`
  - `PUT /api/v1/admin/categories/:slug`
  - `DELETE /api/v1/admin/categories/:slug`
  - `GET /api/v1/admin/users`
  - `GET /api/v1/admin/analytics/overview`

## Architecture Notes

### Flutter

- `app`: bootstrap + routing
- `core`: constants, theme, shared services, widgets
- `features/*/domain`: entities and repository contracts
- `features/*/data`: remote data sources, cache-aware repositories, sample fallback
- `features/*/presentation`: controllers, screens, widgets

### Backend

- `config`: environment and Firebase Admin setup
- `controllers`: request/response orchestration
- `services`: Firestore-aware business logic with sample fallback
- `middlewares`: validation, auth, error handling
- `routes`: API composition

## Production Hardening To Do Next

- Add generated `firebase_options.dart` after running FlutterFire CLI
- Add real push notification token registration endpoint
- Replace sample fallback media with managed Storage assets
- Add unit and widget tests around controllers and repositories
- Add request logging persistence and rate limiting
- Add image upload APIs for admin content workflows
- Add CI for `flutter analyze`, `flutter test`, and backend route tests

# Loop — Social App (Long Exam)

A Flutter social app built on top of a Facebook-clone base, redesigned with a
custom **"Loop"** identity (teal `#0D9488` + emerald, Material 3, minimal cards).

**Backend:** [DummyJSON](https://dummyjson.com/) — a free fake REST API that
returns pretend `users`, `posts`, and `comments` as JSON, so the app has
realistic data without running a real server.

**Demo login:** `emilys` / `emilyspass` (any account from
<https://dummyjson.com/users>, password = `<username>` + `pass`).

---

## Enhancements

### 1. Authentication + splash screen
- `POST https://dummyjson.com/auth/login` verifies the credentials and returns
  the user + an access token.
- The token and the user JSON are saved to **`shared_preferences`**.
- `SplashScreen` is the launch route. It reads `shared_preferences`:
  token present → go straight to `/home`; otherwise → `/login`.

### 2. Profile posts by userID + Settings + Sign Out
- The profile screen takes the logged-in user's `id` and calls
  `GET https://dummyjson.com/posts/user/{id}` to render only that user's posts.
- `SettingsScreen` stores user preferences (dark mode, notifications, autoplay)
  in `shared_preferences` and has a **Sign Out** button that clears the saved
  session and returns to `/login`.

### 3. Comments + likes
- Each profile post loads its comments from
  `GET https://dummyjson.com/comments/post/{postId}`.
- A new comment is sent with `POST https://dummyjson.com/comments/add`
  (DummyJSON simulates the write and echoes the comment back).
- Like buttons (posts and comments) toggle a local counter.
- Newsfeed posts are mock data, so their comment thread is kept locally
  in memory.

---

## Architecture: models → services → screens

The app is a one-directional pipeline. **Screens never talk to `http` or
`shared_preferences` directly** — they always go through a service, and a
service always hands back a typed **model**.

```
   DummyJSON API  /  shared_preferences
            │
            ▼
      ┌───────────┐     parses JSON into
      │ SERVICES  │ ─────────────────────────►  ┌────────┐
      │           │                             │ MODELS │
      │ UserService                             │        │
      │ PostService                             │ User   │
      │ CommentService                          │ Post   │
      └───────────┘                             │ Comment│
            ▲                                   └────────┘
            │ calls methods, awaits Futures          │
            │                                        │ typed objects
      ┌───────────┐                                  │
      │  SCREENS  │ ◄────────────────────────────────┘
      │           │   rebuild with setState / FutureBuilder
      │ Splash · Login · Register · Home
      │ Newsfeed · Profile · Settings · Detail
      └───────────┘
```

### Models — `lib/models/`
Plain Dart classes. Their only job is to convert JSON ↔ Dart.

| Model | Fields | Built from |
|-------|--------|-----------|
| `User` | `id, username, email, firstName, lastName, gender, image, phone` (+ `fullName` getter) | `/auth/login` response |
| `Post` | `id, userId, body, likes, dislikes, createdAt` | `/posts/*` items |
| `Comment` | `id, body, postId, userId, username, fullName, likes, likedByMe` | `/comments/*` items |

Each has a `factory X.fromJson(Map)` (and `toJson()` where it needs to be
persisted). Models hold **no logic** and never import `http`.

### Services — `lib/services/`
The only layer that performs I/O (network + local storage). Each method returns
a `Future` of a model (or a list of models), or throws an `Exception` the screen
can show.

| Service | Methods | Talks to |
|---------|---------|----------|
| `UserService` | `login()`, `isLoggedIn()`, `getSavedUser()`, `getToken()`, `signOut()` | `POST /auth/login`, `shared_preferences` |
| `PostService` | `getPosts()`, `getPostsByUser(id)` | `GET /posts`, `GET /posts/user/{id}` |
| `CommentService` | `getCommentsByPost(id)`, `addComment(...)` | `GET /comments/post/{id}`, `POST /comments/add` |

`UserService.login()` is the hub of enhancement 1: it calls the API, then calls
`SharedPreferences.setString(...)` for the token + user, so every later screen
can read the session without another network call.

### Screens — `lib/screens/` (+ widgets in `lib/widgets/`)
UI only. They own an instance of the service(s) they need, call a method in
`initState()` / an event handler, and render the returned model with
`setState` or a `FutureBuilder`.

| Screen | Service(s) | Model(s) shown |
|--------|-----------|----------------|
| `SplashScreen` | `UserService.isLoggedIn()` | — (routes only) |
| `LoginScreen` | `UserService.login()` | `User` (persisted) |
| `RegisterScreen` | `UserDatabase` (local file) | — |
| `HomeScreen` | `UserService.getSavedUser()` | `User` (name + avatar in bar) |
| `ProfileScreen` | `UserService.getSavedUser()` + `PostService.getPostsByUser()` | `User`, `List<Post>` |
| `ApiPostCard` (widget) | `CommentService` | `List<Comment>` |
| `SettingsScreen` | `UserService.signOut()` + `shared_preferences` | — |
| `NewsfeedScreen` | none (mock data) | — |

### End-to-end example — opening the Profile tab
1. `ProfileScreen.initState()` → `UserService.getSavedUser()`
   → reads `shared_preferences` → returns a **`User`**.
2. With `user.id`, it calls `PostService.getPostsByUser(user.id)`
   → `GET /posts/user/{id}` → parses each item with `Post.fromJson`
   → returns **`List<Post>`**.
3. A `FutureBuilder<List<Post>>` renders one `ApiPostCard` per post.
4. Tapping **Comment** on a card → `CommentService.getCommentsByPost(post.id)`
   → `GET /comments/post/{id}` → **`List<Comment>`** → shown under the post.
5. Typing a comment → `CommentService.addComment(...)`
   → `POST /comments/add` → returns the new **`Comment`**, prepended to the list.

The screen never sees a raw JSON map — the service boundary guarantees it only
ever works with `User` / `Post` / `Comment`.

---

## Project layout

```
lib/
├── constants.dart          # Loop design tokens (colors, radii) + API host
├── main.dart               # MaterialApp, Material 3 theme, routes
├── models/                 # User, Post, Comment  (JSON ↔ Dart)
├── services/               # UserService, PostService, CommentService  (I/O)
├── providers/              # ThemeProvider (light/dark app state)
├── screens/                # Splash, Login, Register, Home, Newsfeed,
│                           # Profile, Settings, Detail, Notification
└── widgets/                # PostCard, ApiPostCard, LoopLogo, custom fields…
```

## Run

```bash
flutter pub get
flutter run
```

Requires internet (DummyJSON). The Android `INTERNET` permission is declared in
`android/app/src/main/AndroidManifest.xml`.

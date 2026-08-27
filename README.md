# Loop — Social App (Long Exam)

A Flutter social app built on a Facebook-clone base, restyled with a custom
**"Loop"** identity (teal `#0D9488` + emerald, Material 3).

**Backend:** [DummyJSON](https://dummyjson.com/) — a free fake REST API that
returns pretend `users`, `posts`, and `comments`, so the app has realistic data
with no real server.

**Demo login:** `emilys` / `emilyspass`
(any user from <https://dummyjson.com/users>, password = username + `pass`).

## Run

```bash
flutter pub get
flutter run
```

Needs internet. Android `INTERNET` permission is set in `AndroidManifest.xml`.

---

## Enhancements

**1. Auth + splash**
`POST /auth/login` verifies credentials and returns a token. The token + user
JSON are saved to `shared_preferences`. `SplashScreen` is the launch route: if a
token exists it goes to `/home`, otherwise `/login`.

**2. Profile posts + Settings + Sign Out**
`ProfileScreen` uses the logged-in user's `id` to call `GET /posts/user/{id}`
and shows only that user's posts. `SettingsScreen` keeps preferences (dark mode,
notifications, autoplay) in `shared_preferences` and has a **Sign Out** button
that clears the session and returns to `/login`.

**3. Comments + likes**
Each post loads comments from `GET /comments/post/{postId}`. New comments are
sent with `POST /comments/add`. Like buttons toggle a local counter. Mock
newsfeed posts keep their comment thread in memory.

---

## Architecture: models → services → screens

One-directional pipeline. **Screens never touch `http` or `shared_preferences`
directly** — they call a service, and a service returns a typed **model**.

```
  DummyJSON API / shared_preferences
            │
        ┌───────────┐   parses JSON
        │ SERVICES  │ ────────────►  MODELS (User, Post, Comment)
        │ UserService                    │
        │ PostService                    │ typed objects
        │ CommentService                 │
        └───────────┘                    │
            ▲                            ▼
        ┌───────────┐   rebuild with FutureBuilder / setState
        │  SCREENS  │
        │ Splash · Login · Home · Profile · Settings · Newsfeed · Detail
        └───────────┘
```

**Models** (`lib/models/`) — plain Dart classes, JSON ↔ Dart only, no logic,
never import `http`.

| Model | Key fields | From |
|-------|-----------|------|
| `User` | `id, username, email, firstName, lastName, image` | `/auth/login` |
| `Post` | `id, userId, body, likes, dislikes` | `/posts/*` |
| `Comment` | `id, body, postId, userId, username, likes` | `/comments/*` |

**Services** (`lib/services/`) — the only layer doing I/O. Each method returns a
`Future` of a model (or list), or throws.

| Service | Methods | Talks to |
|---------|---------|----------|
| `UserService` | `login`, `isLoggedIn`, `getSavedUser`, `getToken`, `signOut` | `/auth/login`, `shared_preferences` |
| `PostService` | `getPosts`, `getPostsByUser(id)` | `/posts`, `/posts/user/{id}` |
| `CommentService` | `getCommentsByPost(id)`, `addComment(...)` | `/comments/post/{id}`, `/comments/add` |

**Screens** (`lib/screens/`) — UI only. Own a service instance, call it in
`initState()` or an event handler, render the returned model.

### Example — opening the Profile tab
1. `getSavedUser()` reads `shared_preferences` → returns a `User`.
2. `getPostsByUser(user.id)` → `GET /posts/user/{id}` → `List<Post>`.
3. `FutureBuilder` renders one card per post.
4. Tapping **Comment** → `getCommentsByPost(post.id)` → `List<Comment>`.
5. Sending a comment → `addComment(...)` → new `Comment` prepended.

The screen only ever works with `User` / `Post` / `Comment`, never raw JSON.

---

## Project layout

```
lib/
├── constants.dart   # design tokens + API host
├── main.dart        # MaterialApp, theme, routes
├── models/          # User, Post, Comment
├── services/        # UserService, PostService, CommentService
├── providers/       # ThemeProvider
├── screens/         # Splash, Login, Register, Home, Newsfeed,
│                    # Profile, Settings, Detail, Notification
└── widgets/         # PostCard, ApiPostCard, LoopLogo, custom fields
```

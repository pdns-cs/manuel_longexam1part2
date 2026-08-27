# Loop — Social App (Long Exam)

A Flutter social app built on a Facebook-clone base, restyled with a custom
"Loop" identity (teal + emerald, Material 3).

The backend is DummyJSON (https://dummyjson.com) — a free fake REST API that
returns pretend users, posts, and comments, so the app has realistic data with
no real server.

Demo login: `emilys` / `emilyspass` (any user from https://dummyjson.com/users,
password = username + "pass").


## Run

    flutter pub get
    flutter run

Needs internet. The Android INTERNET permission is set in AndroidManifest.xml.


## Enhancements

1. Auth + splash screen.
   POST /auth/login checks the credentials and returns a token. The token and
   the user are saved to shared_preferences. SplashScreen is the first screen:
   if a token is saved it goes to Home, otherwise to Login.

2. Profile posts, Settings, and Sign Out.
   ProfileScreen uses the logged-in user's id to call GET /posts/user/{id} and
   shows only that user's posts. SettingsScreen keeps preferences (dark mode,
   notifications, autoplay) in shared_preferences and has a Sign Out button that
   clears the session and returns to Login.

3. Comments and likes.
   Each post loads its comments from GET /comments/post/{postId}. A new comment
   is sent with POST /comments/add. Like buttons toggle a local counter. The
   mock newsfeed posts keep their comments in memory.


## How it is organized: models, services, screens

The app flows in one direction. Screens never call http or shared_preferences
directly. A screen calls a service, and the service gives back a typed model.

Models (lib/models/) are plain Dart classes that only convert JSON to and from
Dart. They hold no logic. There are three: User, Post, and Comment.

Services (lib/services/) are the only layer that does input/output — network
calls and local storage. Each method returns a Future of a model, or throws.

  - UserService: login, isLoggedIn, getSavedUser, getToken, signOut.
    Talks to /auth/login and shared_preferences.
  - PostService: getPosts, getPostsByUser(id).
    Talks to /posts and /posts/user/{id}.
  - CommentService: getCommentsByPost(id), addComment(...).
    Talks to /comments/post/{id} and /comments/add.

Screens (lib/screens/) are UI only. A screen holds the service it needs, calls
it in initState or on a button press, and shows the returned model with a
FutureBuilder or setState.

Example — opening the Profile tab:

  1. getSavedUser() reads shared_preferences and returns a User.
  2. getPostsByUser(user.id) calls GET /posts/user/{id} and returns a list of
     Post objects.
  3. A FutureBuilder shows one card per post.
  4. Tapping Comment calls getCommentsByPost(post.id) and returns a list of
     Comment objects.
  5. Sending a comment calls addComment(...) and the new Comment is added to
     the top of the list.

The screen only ever works with User, Post, and Comment — never raw JSON.


## Project layout

  lib/
    constants.dart   design tokens and API host
    main.dart        MaterialApp, theme, routes
    models/          User, Post, Comment
    services/        UserService, PostService, CommentService
    providers/       ThemeProvider
    screens/         Splash, Login, Register, Home, Newsfeed,
                     Profile, Settings, Detail, Notification
    widgets/         PostCard, ApiPostCard, LoopLogo, custom fields

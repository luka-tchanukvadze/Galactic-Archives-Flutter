# Chanu Wars

A Star Wars themed Flutter app. It has lore, a list of characters from an API,
an online shop with login, and reviews.

Live Demo - https://galactic-archives-flutter.vercel.app/

This Flutter app is a simpler version of my bigger full-stack project (Next.js
frontend with its own backend). The Flutter version uses Firebase instead of
that backend.

- Full-stack code: https://github.com/luka-tchanukvadze/CHANU-WARS
- Full-stack demo: https://chanu-wars.vercel.app/

## How to run

```
flutter pub get
flutter run -d chrome
```

You can also run it on Windows with `flutter run -d windows`.

Firebase keys are read from a `.env` file (login, reviews and orders need them).
The `.env` is not in git. Make a `.env` and add your Firebase web values to use
auth and the database.

## Folder structure

```
lib/
  main.dart              app start, loads .env and Firebase
  app.dart               root widget, sets up providers and theme
  firebase_options.dart  Firebase config, reads values from .env

  core/                  theme, colors, constants, shared widgets (starfield, etc.)
  models/                plain data classes (Product, Order, Review, ApiCharacter...)
  data/                  local mock data (shop products, lore text, characters)
  services/              data sources (auth, firestore, the Dio api)
  repositories/          sits between the api and the app
  providers/             app state (auth, cart, api characters)
  screens/               the pages (home, auth, shop, lore, reviews)
  widgets/               small reusable ui pieces

assets/                  product/character images and the Lottie file
```

## Exam requirements and where to find them

| Requirement | Where in the code |
|---|---|
| Responsive (MediaQuery) | `screens/home_screen.dart`, `screens/lore/api_characters_screen.dart` |
| Responsive (LayoutBuilder) | `screens/shop/shop_screen.dart` |
| Responsive (max width) | `core/widgets/responsive_center.dart` |
| State Management (Provider) | `providers/` and `app.dart` |
| Architecture (layered) | whole `lib/` split, see `ARCHITECTURE.md` |
| API + Dio | `services/star_wars_api.dart`, `repositories/character_repository.dart`, `screens/lore/api_characters_screen.dart` |
| Animation (explicit) | `core/widgets/star_field.dart` (twinkling stars) |
| Animation (implicit) | `screens/shop/shop_screen.dart` (AnimatedSwitcher) |
| Animation (Lottie) | `screens/lore/api_characters_screen.dart` (loading) |
| Firebase Auth | `services/auth_service.dart`, `screens/auth/` |
| Firebase Firestore | `services/firestore_service.dart` (reviews and orders) |

To see the API page: open Lore, then tap the globe icon (top right).

## More details

- State management: Provider with ChangeNotifier. Simple and official, good for
  an app this size.
- API: characters come from the free swapi.info Star Wars API over Dio.
- Firebase: email and password login. Reviews and each user's orders are saved
  in Firestore, not on the device.
- Theme: dark space look, gold and cyan colors, Google Fonts (Orbitron).
- Packages: provider, dio, lottie, firebase_core, firebase_auth, cloud_firestore,
  flutter_dotenv, google_fonts.

There is a longer writeup for the presentation in `ARCHITECTURE.md`.

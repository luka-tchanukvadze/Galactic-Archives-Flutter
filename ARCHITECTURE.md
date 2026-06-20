# Chanu Wars - notes for the presentation

A small Star Wars themed Flutter app: a lore section, an online shop, reviews,
and login. Below is how it is built and why, in plain words. Each part ends with
the files to open if I want to show it.

This is a simpler Flutter port of my full-stack project (Next.js frontend with a
custom backend). For Flutter I replaced that backend with Firebase.
Full-stack code: https://github.com/luka-tchanukvadze/CHANU-WARS
Full-stack demo: https://chanu-wars.vercel.app/

## Architecture (layered, MVVM style)

I split the code by responsibility so each part has one job:

- **Data layer** - `lib/services/` and `lib/data/`
  - `star_wars_api.dart` (Dio http calls), `auth_service.dart`,
    `firestore_service.dart` are the data sources.
  - `lib/data/` holds the local mock data for the shop and lore.
- **Domain layer** - `lib/repositories/` and `lib/models/`
  - `character_repository.dart` sits between the api and the app. The ui asks
    the repo for characters and never talks to Dio directly.
  - `lib/models/` are plain Dart classes (Product, Order, Review, ApiCharacter...).
- **Presentation layer** - `lib/providers/`, `lib/screens/`, `lib/widgets/`
  - Providers are my view models (they hold state and call the data layer).
  - Screens and widgets only build UI and read from providers.

Why this way: it keeps UI dumb and logic testable. If the api changes, I only
touch the data layer, the screens stay the same.

Where to look: the whole `lib/` folder split. Good example of the full chain:
`screens/lore/api_characters_screen.dart` -> `providers/api_characters_provider.dart`
-> `repositories/character_repository.dart` -> `services/star_wars_api.dart`.

## State management - Provider

I used `provider` with `ChangeNotifier`:
- `AuthProvider` - who is logged in.
- `CartProvider` - what is in the cart.
- `ApiCharactersProvider` - loading / error / done state for the api page.

Why Provider: it is the official, simplest option and the app is not huge, so
Bloc would be overkill. `notifyListeners()` rebuilds only the widgets that
`watch` the provider.

Where to look: `lib/providers/`, and `lib/app.dart` where the providers are set
up. Used in the UI in `screens/shop/shop_screen.dart` (reads `CartProvider`).

## API + Dio

The "API Characters" page (inside Lore) loads characters from a free public
Star Wars API (swapi.info) using **Dio**. Flow: screen -> provider -> repository ->
Dio. The provider exposes loading / error / done so the UI can show a Lottie
spinner, a retry button, or the grid.

Where to look: `lib/services/star_wars_api.dart` (the Dio call),
`lib/repositories/character_repository.dart`,
`lib/screens/lore/api_characters_screen.dart` (the page). Open Lore and tap the
globe icon to see it.

## Firebase

- **Authentication**: email/password login and signup.
- **Firestore**: reviews and per-user order history are stored online (not on
  the device). Config keys are loaded from a gitignored `.env` via flutter_dotenv.

Where to look: `lib/services/auth_service.dart`, `lib/services/firestore_service.dart`,
`lib/screens/auth/` (login and signup), `lib/firebase_options.dart` (reads `.env`).

## Responsive design

- `MediaQuery` - title size on Home, column count on the API page.
- `LayoutBuilder` - the shop grid picks 1 / 2 / 3 columns by width.
- `ResponsiveCenter` (a `ConstrainedBox`) - caps content width on big screens.

Where to look: `lib/screens/home_screen.dart` (MediaQuery title),
`lib/screens/lore/api_characters_screen.dart` (MediaQuery columns),
`lib/screens/shop/shop_screen.dart` (LayoutBuilder),
`lib/core/widgets/responsive_center.dart`.

## Animations

- **Implicit**: `AnimatedSwitcher` cross-fades the shop between products and cart.
- **Explicit**: the starfield uses an `AnimationController` so the stars twinkle.
- **Lottie**: a Lottie animation plays while the API page is loading.

Where to look: `lib/screens/shop/shop_screen.dart` (AnimatedSwitcher),
`lib/core/widgets/star_field.dart` (AnimationController),
`lib/screens/lore/api_characters_screen.dart` (Lottie).

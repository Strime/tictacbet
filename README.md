# Tic Tac Bet

Casino-themed Tic-Tac-Toe with betting, AI opponent and a wallet system.

## About me

Hello, I'm Gaëtan. I did this exercise with pleasure, hope the review will be enjoyable for you too.
I'd enjoy working with you one day, I'm sure I still have some advice to take from you.

## Features

- **Tic-Tac-Toe vs AI** — Minimax with alpha-beta pruning, 4 difficulty levels
- **Betting system** — Place bets before each game, difficulty scales with bet amount
- **Wallet** — Persistent balance, daily bonus (10 chips), win/draw/loss settlement
- **Card-based board** — Each cell hides a card with random bonuses (coins, XP)
- **Cash out** — Leave a game early and collect a payout based on board evaluation
- **Progression** — XP, levels and win streaks with streak bonus multipliers
- **Profile** — Lifetime stats and 13 unlockable achievements
- **Game history** — Last 50 results stored locally (Hive), browsable list with outcome & stats
- **Onboarding** — 4-step interactive tutorial introducing gameplay, cards, betting and achievements

## Tech Stack

| Layer | Tools |
|-------|-------|
| State management | flutter_bloc / BLoC |
| Navigation | go_router (stateful shell) |
| DI | get_it + injectable |
| Code generation | freezed, json_serializable |
| Persistence | shared_preferences, Hive |
| UI | Material 3 dark theme, flutter_animate, Google Fonts |
| i18n | Flutter intl (EN / FR) |

## Architecture

Clean Architecture — 3 layers per feature:

```
feature/
├── domain/       # Entities, repositories (abstract), use cases
├── data/         # Repository impls, data sources
└── presentation/ # BLoC, pages, widgets
```

## Project Structure

```
lib/
├── core/
│   ├── config/        # Game constants & balance tuning
│   ├── di/            # DI module
│   ├── analytics/     # Pluggable analytics (debug logger → Firebase/Mixpanel)
│   ├── error/         # Typed failures (Freezed)
│   ├── navigation/    # Bottom nav bar
│   ├── router/        # GoRouter config
│   ├── theme/         # Colors, spacing, text styles, decorations
│   └── utils/         # Shared helpers
│
├── features/
│   ├── ai/            # Minimax AI service & use case
│   ├── game/          # Board, cells, cards, game logic & UI
│   ├── lobby/         # Bet placement & auto-alternating sides
│   ├── wallet/        # Balance, bets, daily bonus, persistence
│   ├── history/       # Game results log (Hive storage)
│   ├── profile/       # Stats dashboard & achievements
│   ├── onboarding/    # 4-step interactive tutorial
│   └── progression/   # XP, levels, win streaks
│
└── l10n/              # Localization (EN, FR)
```

## Getting Started

```bash
# Install dependencies
flutter pub get

# Run code generation
dart run build_runner build --delete-conflicting-outputs

# Run the app
flutter run
```

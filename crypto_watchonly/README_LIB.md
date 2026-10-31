# Crypto Watchonly - Flutter source

This archive contains the complete `lib/` directory for the Flutter application.

## Copy into your project

1. Back up or rename your existing `lib` folder.
2. Extract this archive into your Flutter project root.
3. Keep the included `lib/` directory structure unchanged.
4. Make sure your `pubspec.yaml` includes the dependencies listed below.
5. Run `flutter pub get`, then `dart format lib test`, `flutter analyze`, and `flutter test`.

## Dependencies

- `flutter_bloc: ^9.1.1`
- `equatable: ^2.0.7`
- `dio: ^5.8.0+1`
- `fl_chart: ^0.71.0`
- `shared_preferences: ^2.5.3`
- `intl: ^0.20.2`

## Backend contract

The app expects the Node backend to provide:

- `GET /api/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false`
- `GET /api/coins/:id`
- `GET /api/coins/:id/market-chart?vs_currency=usd&days=7`

The market endpoint may return a CoinGecko-style JSON array or `{\"data\": [...]}`. The details endpoint may return a coin object or `{\"data\": {...}}`. The chart endpoint should return `{\"prices\": [[timestamp, price], ...]}` or `{\"data\": {\"prices\": [...]}}`.

## Backend URL

Edit `lib/core/constants/api_constants.dart` for your environment. Android emulator uses `http://10.0.2.2:3000/api`; a physical phone must use your computer's LAN IP. The CoinGecko API key belongs only in the Node backend `.env`, never in Flutter.

## Architecture

- `core/`: shared networking, errors, constants and formatting
- `features/coin/domain/`: entities and repository contract
- `features/coin/data/`: API data source, models and repository implementation
- `features/coin/presentation/`: detail state and screen
- `features/market/presentation/`: market state and screen
- `features/watchlist/`: local persistence and watchlist state/screen

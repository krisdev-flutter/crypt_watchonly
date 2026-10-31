# Crypto Watchonly Flutter app

## Included
- Feature-first Clean Architecture (`data`, `domain`, `presentation`)
- Dio HTTP client
- BLoC state management
- Market list, search, sorting and pull-to-refresh
- Coin detail, market statistics and price chart (1D / 7D / 30D / 90D)
- Local watchlist persistence using SharedPreferences
- Loading, error, retry and empty states

## 1. Install dependencies

From the Flutter project root:

```bash
flutter pub get
```

Copy the `lib/` folder and `pubspec.yaml` into your Flutter project, or unzip this package into a fresh project.

## 2. Configure backend URL

Edit `lib/core/constants/api_constants.dart`.

- Android Emulator: `http://10.0.2.2:3000/api`
- Physical Android device: `http://YOUR_COMPUTER_LAN_IP:3000/api`
- Windows / macOS / Linux desktop: `http://localhost:3000/api`
- iOS Simulator: `http://localhost:3000/api`

The phone and computer must be on the same Wi-Fi for a physical-device test. The Node server must listen on `0.0.0.0` (not only `localhost`) for LAN access.

## 3. Android local HTTP

For local development only, add `android:usesCleartextTraffic="true"` to the `<application>` element in `android/app/src/main/AndroidManifest.xml`:

```xml
<application
    android:label="crypto_watchonly"
    android:usesCleartextTraffic="true"
    android:name="${applicationName}"
    android:icon="@mipmap/ic_launcher">
```

Use HTTPS for production and remove the cleartext allowance.

## 4. Backend contract required by this Flutter app

The Flutter app calls these endpoints on your Node/Express backend:

| Method | Endpoint | Expected response |
|---|---|---|
| GET | `/api/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false` | CoinGecko-style array of market coin objects, or `{ "data": [...] }` |
| GET | `/api/coins/:id` | CoinGecko-style coin detail object, or `{ "data": {...} }` |
| GET | `/api/coins/:id/market-chart?vs_currency=usd&days=7` | `{ "prices": [[timestamp, price], ...] }`, or `{ "data": { "prices": [...] } }` |

Each market coin item should include:
`id`, `name`, `symbol`, `image`, `current_price`, `market_cap`, `market_cap_rank`,
`price_change_percentage_24h`, `total_volume`, `circulating_supply`.

Detail response should preserve CoinGecko's `market_data`, `description`, and `image` structure.

**Important:** your current backend milestone only includes `/api/health` and `/api/coins/bitcoin/price`. The market, detail and chart endpoints above still need to be added to Node before the complete Flutter screens can load. This Flutter app does not call CoinGecko directly and does not contain your API key.

## 5. Run

```bash
flutter run
```

## Notes
- Watchlist IDs are ordinary app preferences, so SharedPreferences is used instead of secure storage. Never store API keys in the Flutter app.
- The chart displays the price series returned by your backend. The backend should cache upstream responses and respect CoinGecko plan limits.
- Run `dart format lib` and `flutter analyze` after integrating.

# 🪙 Crypt Watchonly

**Crypt Watchonly** is a cryptocurrency tracking application built with Flutter. It allows users to explore cryptocurrency market prices, view detailed coin information, track historical price movements, and manage a personalized watchlist.

The application uses a Flutter frontend and a Node.js backend that integrates with the CoinGecko API to retrieve cryptocurrency market data.

**GitHub Repository:** https://github.com/krisdev-flutter/crypt_watchonly

---

## ✨ Features

- **Cryptocurrency Market:** Browse cryptocurrency prices and market information.
- **Market Data:** Retrieve the latest available cryptocurrency prices.
- **Coin Details:** View detailed information about individual cryptocurrencies.
- **Historical Price Charts:** Explore cryptocurrency price movements over time.
- **Search:** Find cryptocurrencies by name.
- **Sorting and Filtering:** Organize market data using available sorting and filtering options.
- **Watchlist:** Keep track of favorite cryptocurrencies.
- **Backend Integration:** Retrieve cryptocurrency data through a Node.js REST API.
- **CoinGecko Integration:** Use CoinGecko as the cryptocurrency market data provider.

---

## 🛠️ Technologies Used

| Technology | Purpose |
|---|---|
| Flutter | Cross-platform application development |
| Dart | Flutter application programming language |
| Node.js | Backend runtime |
| CoinGecko API | Cryptocurrency market data |
| REST API | Communication between the frontend and backend |

---

## 📋 Prerequisites

Before running the project, make sure the following tools are installed on your computer:

1. **Git** — To clone the repository.
2. **Flutter SDK** — To run the Flutter application.
3. **Node.js and npm** — To run the backend.
4. **Android Studio or Visual Studio Code** — To develop and run the application.
5. **An emulator or physical device** — To launch the app.

### Installation Resources

- Flutter: https://docs.flutter.dev/get-started/install
- Dart: https://dart.dev/get-dart
- Node.js: https://nodejs.org/
- Git: https://git-scm.com/downloads
- Android Studio: https://developer.android.com/studio
- Visual Studio Code: https://code.visualstudio.com/

---

## 🚀 Getting Started

Follow these steps to download and run the project.

### Step 1: Clone the Repository

Open your terminal and run:

```bash
git clone https://github.com/krisdev-flutter/crypt_watchonly.git
```

Navigate into the project directory:

```bash
cd crypt_watchonly
```

### Step 2: Install Flutter Dependencies

From the directory containing the Flutter app's `pubspec.yaml` file, run:

```bash
flutter pub get
```

This command downloads the Flutter packages required by the application.

### Step 3: Get a CoinGecko API Key

The backend uses the CoinGecko API to retrieve cryptocurrency market data.

If you do not already have an API key:

1. Visit the official CoinGecko API website: https://www.coingecko.com/en/api
2. Create an account or sign in.
3. Follow CoinGecko's instructions to obtain an API key.
4. Check the applicable API plan and usage limits.

Keep your API key private.

### Step 4: Configure the Backend

Locate the Node.js backend directory in the repository.

Create a `.env` file in the backend directory. If the project contains a `.env.example` file, use it as a template.

Add the required configuration:

```env
PORT=3000
COINGECKO_BASE_URL=https://api.coingecko.com/api/v3
COINGECKO_API_KEY=your_coingecko_api_key_here
```

Replace `your_coingecko_api_key_here` with your actual CoinGecko API key.

**Important:** Never upload your real `.env` file or API key to GitHub. The `.env` file should be excluded through `.gitignore`.

### Step 5: Install Backend Dependencies

Open a terminal and navigate to the backend directory.

For example, if the backend folder is named `backend`:

```bash
cd backend
npm install
```

This installs the Node.js packages required by the backend.

### Step 6: Start the Backend

Start the backend using the script configured in its `package.json`.

For example:

```bash
npm start
```

If the project uses a development script instead, run:

```bash
npm run dev
```

Use the command supported by your backend configuration.

Keep the backend running while using the Flutter application.

### Step 7: Configure the Backend Connection

The Flutter application must connect to the correct backend URL.

The URL depends on the device or emulator running the application.

| Environment | Example backend API URL |
|---|---|
| Android Emulator | `http://10.0.2.2:3000/api` |
| iOS Simulator on the same Mac | `http://localhost:3000/api` |
| Physical Android or iOS device | `http://<computer-LAN-IP>:3000/api` |
| Deployed backend | `https://your-backend-domain/api` |

**Note:** These are example URLs. Use the actual port and API prefix configured in your backend.

For a physical device, the computer and device generally need to be on the same reachable network when using a local backend. Ensure your firewall permits the connection.

If the Flutter app already has the correct API URL configured, you do not need to change it.

### Step 8: Run the Flutter Application

Return to the Flutter project directory containing `pubspec.yaml`.

Run:

```bash
flutter pub get
```

Then launch the application:

```bash
flutter run
```

Alternatively, open the project in Android Studio or Visual Studio Code, select a device, and run the application.

**Before launching the app, make sure the backend is running and the API URL is configured correctly.**

---

## 🔌 Backend API Endpoints

The backend provides endpoints for retrieving cryptocurrency market data.

| HTTP Method | Endpoint | Description |
|---|---|---|
| GET | `/api/coins/markets` | Retrieves cryptocurrency market data |
| GET | `/api/coins/:id` | Retrieves details for a specific cryptocurrency |
| GET | `/api/coins/:id/market-chart` | Retrieves historical price chart data |
| GET | `/api/coins/bitcoin/price` | Retrieves Bitcoin price information |

The `:id` parameter represents the cryptocurrency identifier expected by the backend.

For example, `bitcoin` may be used as a coin identifier when requesting Bitcoin information.

---

## 📁 Project Structure

The repository includes a Flutter application and its associated backend.

A typical Flutter project structure looks like this:

```text
crypt_watchonly/
├── android/
├── ios/
├── lib/
├── test/
├── assets/
├── pubspec.yaml
├── pubspec.lock
├── .gitignore
└── README.md
```

The backend may be located in a separate directory or repository, depending on the actual project setup.

- `lib/` — Flutter application source code.
- `android/` — Android platform files.
- `ios/` — iOS platform files.
- `test/` — Flutter tests.
- `assets/` — Application assets, if configured.
- `pubspec.yaml` — Flutter dependencies and project configuration.
- `.gitignore` — Files and directories excluded from Git.

---

## 🧪 Testing and Troubleshooting

### Check the Flutter Installation

```bash
flutter doctor
```

This command checks the Flutter development environment and reports common setup issues.

### Run Flutter Tests

```bash
flutter test
```

This runs the project's configured Flutter tests.

### If the App Cannot Connect to the Backend

1. Confirm that the backend is running.
2. Check that the backend starts without errors.
3. Verify the API base URL configured in the Flutter application.
4. Make sure the URL is correct for the selected emulator or device.
5. Confirm that the backend can reach the CoinGecko API.
6. Check network connectivity and firewall settings.

### If Cryptocurrency Data Does Not Load

1. Verify that the CoinGecko API key is valid.
2. Check the backend logs for API errors.
3. Confirm that your CoinGecko plan permits the requested endpoint and usage.
4. Check whether the API has reached its rate limit.
5. Test the relevant backend endpoint independently.

---

## 🔐 Security Guidelines

- Never commit API keys, passwords, or other secrets to GitHub.
- Keep your `.env` file private.
- Use `.env.example` to document the required environment variables without including real credentials.
- Do not place private backend API credentials directly in Flutter application code.
- Use HTTPS for deployed backend connections.
- Share credentials only through an approved private channel when necessary.

---

## 🤝 Contributing

Contributions and improvements are welcome.

1. Clone the repository.
2. Create a branch for your changes.
3. Implement your changes.
4. Test the application.
5. Commit your changes with a descriptive message.
6. Push your branch and create a pull request.

---

## 📄 License

No license has been specified in this README. Add a license if you intend to distribute the project under particular open-source terms.

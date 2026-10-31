# 🪙 Crypt Watchonly

**Crypt Watchonly** is a cryptocurrency tracking application developed using Flutter and Dart, with a Node.js backend integrated with the CoinGecko API.

The application allows users to explore cryptocurrency market data, search for coins, view detailed cryptocurrency information, analyze historical price charts, and maintain a personalized watchlist.

## ✨ Features

- **Cryptocurrency Market:** Browse cryptocurrency prices and market information.
- **Market Data:** Retrieve the latest available cryptocurrency market data.
- **Coin Details:** View detailed information about individual cryptocurrencies.
- **Historical Price Charts:** Explore historical cryptocurrency price movements.
- **Search:** Search for cryptocurrencies by name.
- **Sorting and Filtering:** Organize cryptocurrency market data using available sorting and filtering options.
- **Watchlist:** Keep track of favorite cryptocurrencies.
- **REST API Integration:** Retrieve cryptocurrency data through a Node.js backend.
- **CoinGecko Integration:** Use CoinGecko as the cryptocurrency market data provider.

## 🛠️ Technology Stack

| Technology | Purpose |
|---|---|
| Flutter | Cross-platform mobile application development |
| Dart | Frontend programming language |
| Node.js | Backend runtime |
| Express.js | Backend API framework, if used in this project |
| CoinGecko API | Cryptocurrency market data |
| REST API | Communication between the frontend and backend |

## 📋 Prerequisites

Install the following tools before running the application.

| Requirement | Download |
|---|---|
| Git | https://git-scm.com/downloads |
| Flutter SDK | https://docs.flutter.dev/get-started/install |
| Node.js and npm | https://nodejs.org/ |
| Android Studio | https://developer.android.com/studio |
| Visual Studio Code (optional) | https://code.visualstudio.com/ |

You will also need an Android emulator, iOS simulator, or compatible physical device.

For iOS development, a Mac with Xcode is required.

## 🚀 Getting Started

Follow these steps to clone, configure, and run the project.

### Step 1: Clone the Repository

Open a terminal and execute:

```bash
git clone https://github.com/krisdev-flutter/crypt_watchonly.git
```

Navigate to the project directory:

```bash
cd crypt_watchonly
```

### Step 2: Install Flutter Dependencies

Navigate to the directory containing the Flutter application's `pubspec.yaml` file.

If the Flutter project is located in the repository root, run:

```bash
flutter pub get
```

This command downloads the packages required by the Flutter application.

### Step 3: Obtain a CoinGecko API Key

The backend uses the CoinGecko API to retrieve cryptocurrency market data.

If you do not already have an API key:

1. Visit the official CoinGecko API website: https://www.coingecko.com/en/api
2. Create an account or sign in.
3. Follow the instructions to obtain your API key.
4. Review the API plan, supported endpoints, and usage limits.

Keep your API key private.

### Step 4: Configure the Backend Environment

Navigate to the `backend` directory:

```bash
cd backend
```

Install the backend dependencies:

```bash
npm install
```

Create a `.env` file in the backend directory.

If a `backend/.env.example` file is provided, copy it to `.env`.

**Windows PowerShell:**

```powershell
Copy-Item .env.example .env
```

**macOS or Linux:**

```bash
cp .env.example .env
```

Open the new `.env` file and configure the required values:

```env
PORT=3000
COINGECKO_BASE_URL=https://api.coingecko.com/api/v3
COINGECKO_API_KEY=your_coingecko_api_key_here
```

Replace `your_coingecko_api_key_here` with your own valid API key.

**Important:** The `.env` file contains private configuration and must not be committed to GitHub. The `.env.example` file should contain placeholders rather than real credentials.

### Step 5: Start the Backend

From the `backend` directory, start the server using the script defined in `package.json`.

Try:

```bash
npm start
```

If the project defines a development script instead, use:

```bash
npm run dev
```

Use the command supported by the backend's `package.json`.

If the server starts successfully, it should listen on the configured port, for example:

```text
http://localhost:3000
```

Keep the backend terminal open while running the Flutter application.

**Note:** The server URL above is an example. The actual port and startup message depend on the backend configuration.

### Step 6: Configure the Backend URL in Flutter

The Flutter application must connect to the running backend.

For local development, select the appropriate URL for your target device.

| Target environment | Example API base URL |
|---|---|
| Android Emulator | `http://10.0.2.2:3000/api` |
| iOS Simulator on the same Mac | `http://localhost:3000/api` |
| Physical Android or iOS device | `http://<computer-LAN-IP>:3000/api` |
| Deployed backend | `https://your-backend-domain/api` |

These URLs assume that the backend uses port `3000` and the `/api` prefix.

**Important:**

- `10.0.2.2` allows the standard Android Emulator to access the development computer's localhost.
- `localhost` on a physical phone refers to the phone itself, not your computer.
- For a physical device, use your computer's reachable local network IP address and ensure the backend accepts connections from that device.
- If the Flutter application already has a configurable API base URL, set it to the appropriate address before running the app.
- If your backend is deployed, use its actual HTTPS URL instead of a local development address.

### Step 7: Run the Flutter Application

Open a **second terminal** and return to the Flutter project directory containing `pubspec.yaml`.

Install the Flutter dependencies if you have not already done so:

```bash
flutter pub get
```

Check the available devices:

```bash
flutter devices
```

Run the application:

```bash
flutter run
```

Alternatively, open the project in Android Studio or Visual Studio Code, select a device, and launch the app.

Before running the application, make sure the backend is running and the Flutter API base URL is correct.

## 🔌 Backend API Endpoints

The backend exposes endpoints for cryptocurrency market information.

| HTTP Method | Endpoint | Description |
|---|---|---|
| GET | `/api/coins/markets` | Retrieves cryptocurrency market data |
| GET | `/api/coins/:id` | Retrieves details for a specific cryptocurrency |
| GET | `/api/coins/:id/market-chart` | Retrieves historical price chart data |
| GET | `/api/coins/bitcoin/price` | Retrieves Bitcoin price information |

The `:id` parameter represents the cryptocurrency identifier expected by the backend.

For example, `bitcoin` can be used as the identifier for Bitcoin.

These endpoints should be available at the backend host and port configured for the application.

## 📁 Project Structure

The following is an example of the expected project organization. Actual folders may differ depending on the repository layout.

```text
crypt_watchonly/
├── android/
├── ios/
├── lib/
├── test/
├── backend/
│   ├── .env.example
│   ├── package.json
│   └── ...
├── pubspec.yaml
├── pubspec.lock
├── .gitignore
└── README.md
```

### Important Files and Directories

- `lib/` — Flutter application source code.
- `android/` — Android platform configuration.
- `ios/` — iOS platform configuration.
- `test/` — Flutter tests.
- `backend/` — Node.js backend, if maintained in this repository.
- `backend/.env.example` — Template for backend environment variables.
- `pubspec.yaml` — Flutter project configuration and dependencies.
- `pubspec.lock` — Locked Flutter dependency versions.
- `.gitignore` — Files and directories excluded from Git.
- `README.md` — Project documentation and setup instructions.

## 🧪 Testing and Troubleshooting

### Check the Flutter Environment

Run:

```bash
flutter doctor
```

Resolve any required setup issues reported by Flutter.

### Check Connected Devices

Run:

```bash
flutter devices
```

Ensure an emulator or compatible physical device is available.

### Run Flutter Tests

From the Flutter project directory, run:

```bash
flutter test
```

This executes the tests included in the project.

### Backend Does Not Start

1. Confirm Node.js and npm are installed.
2. Ensure you are inside the backend directory.
3. Run `npm install`.
4. Verify that the `.env` file contains the required configuration.
5. Check the startup scripts in `package.json`.
6. Review the terminal output for errors.

### Cryptocurrency Data Does Not Load

1. Confirm that the backend is running.
2. Verify the API base URL configured in Flutter.
3. Confirm that the CoinGecko API key is valid.
4. Check the backend logs for errors returned by CoinGecko.
5. Review the API plan, endpoint permissions, and rate limits.
6. Check network connectivity and firewall settings.

### The App Cannot Connect to the Backend

Confirm that the backend URL matches the selected environment.

For example, the Android Emulator normally needs `10.0.2.2` rather than `localhost` when the backend runs on the development computer.

For a physical device, use a reachable computer IP address or a deployed backend URL.

## 🔐 Security

- Never commit API keys, passwords, or private credentials to GitHub.
- Keep the backend `.env` file private.
- Use `.env.example` to document the required configuration.
- Do not expose private backend API credentials in Flutter source code.
- Use HTTPS when connecting to a deployed backend.
- If a secret is accidentally published, revoke or rotate it.

## 🤝 Submission

This project was developed as a technical assignment.

**Repository:** https://github.com/krisdev-flutter/crypt_watchonly

The repository contains the application source code and setup documentation needed to install, configure, and run the project.

## 📄 License

No license has been specified. Add a license if you intend to distribute the project under particular open-source terms.
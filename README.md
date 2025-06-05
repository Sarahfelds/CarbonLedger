# CarbonLedger – Green Blockchain Simulator

CarbonLedger is a Flutter-based mobile application developed as part of the thesis project _“Green Blockchain: Can Blockchain Be Sustainable?”_.

The app helps users measure and compare the carbon footprint of blockchain transactions, simulate transaction emissions, and explore greener alternatives like Solana, Algorand, and Polkadot. It integrates Firebase and live APIs to ensure all data is real-time and accurate.

## Features

- 🔍 **Emission Calculator:** Estimate energy and carbon emissions of blockchain transactions (e.g., Bitcoin, Ethereum).
- ♻️ **Greener Alternatives:** Suggests lower-emission blockchain options using real-time data from Firebase and APIs.
- 📊 **Live Charts & Comparisons:** Visualize emissions, energy use, fees, and profit margins.
- 🔖 **Bookmark Reports:** Save and manage previously calculated emissions reports.
- 📤 **Carbon Offsetting & Migration:** Simulate converting your transaction to a greener blockchain.
- 🌙 **Modern UI:** Fully responsive dark theme with interactive components.

## Technologies Used

- **Flutter** & Dart
- **Firebase Firestore** – Real-time data storage
- **Firebase Authentication**
- **Firebase Hosting**
- **CoinGecko API** – For live crypto prices
- **Blockchain.info API** – For Bitcoin stats

## Firebase Setup

> To run this project, you’ll need to configure Firebase:

1. Create a Firebase project in [Firebase Console](https://console.firebase.google.com/).
2. Add Android and iOS apps to the project.
3. Download `google-services.json` and `GoogleService-Info.plist`.
4. Place them in:
   - `android/app/google-services.json`
   - `ios/Runner/GoogleService-Info.plist`
5. Enable Firestore Database, Authentication (email/password), and Hosting (optional).

## Installation & Running Locally

```bash
git clone https://github.com/Sarahfelds/CarbonLedger.git
cd CarbonLedger
flutter pub get
flutter run


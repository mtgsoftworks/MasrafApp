# MasrafApp

Cross-platform expense tracking application

## Table of Contents

- [About](#about)
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Requirements](#requirements)
- [Installation](#installation)
- [Firebase Configuration](#firebase-configuration)
- [Usage](#usage)
- [Folder Structure](#folder-structure)
- [Contributing](#contributing)
- [License](#license)

## About

masraf_app is a modern expense tracking application built with Flutter that helps users manage their personal finances across mobile, web, and desktop platforms. It provides intuitive UI, secure authentication, and powerful analytics.

## Features

- User authentication (email/password, Google Sign-In)
- Add, edit, and delete expenses
- Category-wise breakdown and total calculations
- Date range filtering (current month, last 7 days, last 30 days)
- Interactive charts with `fl_chart`
- Theme switching (light/dark) and font size adjustment
- Localization (English, Turkish)
- Profile settings and customizations
- Receipt image attachments and Firebase Storage integration

## Tech Stack

- **Flutter** (Dart)
- **State Management**: Riverpod
- **Routing**: GoRouter
- **Backend**: Firebase Auth, Firestore, Firebase Storage
- **Charts**: fl_chart
- **Localization**: flutter_localizations, intl
- **Local Storage**: shared_preferences
- **SVG Support**: flutter_svg
- **Fonts**: google_fonts
- **UUID Generation**: uuid

## Requirements

- Flutter SDK >= 3.0.0
- Dart SDK (bundled with Flutter)
- Firebase project setup with platform configurations for Android, iOS, web, and desktop

## Installation

```bash
# Clone the repository
git clone https://github.com/mtgsoftworks/MasrafApp.git
cd MasrafApp

# Install dependencies
flutter pub get
```

## Firebase Configuration

1. Create a Firebase project.
2. Add Android, iOS, web, and desktop apps in the Firebase console.
3. Download `google-services.json` and place it in `android/app/`.
4. Download `GoogleService-Info.plist` and place it in `ios/Runner/`.
5. Update `firebase_options.dart` using FlutterFire CLI if needed.

## Usage

```bash
# Run on Android
flutter run -d android

# Run on Web
flutter run -d chrome

# Run on Windows
flutter run -d windows
```

## Folder Structure

```
masraf_app/
├── android/
├── ios/
├── web/
├── windows/
├── lib/
│   ├── auth/
│   ├── features/
│   ├── home/
│   ├── shared/
│   ├── main.dart
│   └── firebase_options.dart
├── assets/
│   ├── images/
│   └── icons/
├── pubspec.yaml
├── .gitignore
└── README.md
```

## Contributing

1. Fork the repository.
2. Create a new branch:
   ```bash
git checkout -b feature/your-feature
```
3. Make your changes and commit:
   ```bash
git commit -m "Add new feature"
```
4. Push to your branch:
   ```bash
git push origin feature/your-feature
```
5. Open a pull request for review.

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details. 

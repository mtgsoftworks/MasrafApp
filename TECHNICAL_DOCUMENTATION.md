# Technical Documentation - masraf_app

## 1. Introduction

masraf_app is a modern expense tracking mobile, web, and desktop application built with Flutter and Firebase. It enables users to securely track their expenses, view analytics, and manage personal settings.

## 2. Architecture Overview

masraf_app follows a modular, feature-driven architecture:

- **Presentation Layer**: UI components and screens located under `lib/` in feature-specific `presentation` directories.
- **State Management**: Handled by Riverpod using `StateNotifier` providers under `lib/.../providers`.
- **Data Models**: Plain Dart classes under `lib/.../models`.
- **Routing**: Configured via GoRouter in `lib/shared/router/app_router.dart`.
- **Theming & Localization**: Defined in `lib/shared/constants`.
- **Firebase Initialization**: Performed in `main.dart` using `Firebase.initializeApp`.

## 3. Tech Stack

- **Language**: Dart 3.0+
- **Framework**: Flutter 3.x
- **State Management**: Flutter Riverpod
- **Routing**: GoRouter
- **Backend Services**: Firebase (Auth, Firestore, Storage)
- **Localization**: `flutter_localizations`, `intl`
- **Charting**: `fl_chart`
- **Local Storage**: `shared_preferences`
- **SVG Support**: `flutter_svg`
- **Image Picking**: `image_picker`
- **Fonts**: `google_fonts`
- **UUID Generation**: `uuid`

## 4. Folder Structure

```
masraf_app/
├── lib/
│   ├── auth/
│   │   ├── models/
│   │   ├── providers/
│   │   └── presentation/
│   ├── features/
│   │   └── expenses/
│   │       ├── models/
│   │       ├── providers/
│   │       └── presentation/
│   ├── home/
│   │   └── presentation/
│   ├── shared/
│   │   ├── constants/
│   │   ├── router/
│   │   └── widgets/
│   ├── main.dart
│   └── firebase_options.dart
├── assets/
│   ├── images/
│   └── icons/
├── android/
├── web/
├── windows/
├── pubspec.yaml
├── analysis_options.yaml
└── README.md
```

## 5. Key Components

### 5.1. Authentication Module
- **AuthNotifier** (`lib/auth/providers/auth_provider.dart`): Manages Firebase authentication, Google Sign-In, session state.
- **Screens**: `LoginScreen`, `RegisterScreen`.

### 5.2. Expense Management
- **ExpenseNotifier** (`lib/features/expenses/providers/expense_provider.dart`): CRUD operations for expenses in Cloud Firestore.
- **Models**: `Expense` (`lib/features/expenses/models/expense.dart`).
- Providers for filtering, categorization, and total calculations.

### 5.3. Home & Dashboard
- **HomeScreen** (`lib/home/presentation/screens/home_screen.dart`): Displays spending dashboard, date range filters, and charts.

## 6. State Management

The application uses **Riverpod**:

- `StateNotifierProvider` for mutable state.
- `Provider` and `Provider.family` for derived state and parameterized providers.

## 7. Routing

Configured via **GoRouter**:

- Central router in `app_router.dart` with authentication guards and named routes.

## 8. Theming & Localization

- Themes defined in `lib/shared/constants/app_theme.dart` using Material 3 standards and `google_fonts`.
- Supports English (`en`) and Turkish (`tr`).
- Theme mode, locale, and font size managed via `settingsProvider`.

## 9. Data Model (Expense)

`Expense` fields:
- `id`, `userId`, `amount`, `description`, `date`, `category`, `notes`, `isRecurring`, `receiptUrl`, `tags`.

## 10. Features

- User authentication (email/password, Google).
- Expense CRUD (add, edit, delete).
- Date range filtering and category breakdown.
- Chart-based reports with `fl_chart`.
- Settings: theme, language, font size.
- Profile management and receipt image storage.

## 11. Dependencies

Key dependencies are listed in `pubspec.yaml`. Notable ones:
- `flutter_riverpod` ^2.4.0
- `go_router` ^10.1.2
- `cloud_firestore` ^4.8.0
- `firebase_auth` ^4.4.0
- `fl_chart` ^0.63.0
- `google_fonts` ^5.1.0

## 12. Setup & Installation

### Prerequisites
- Flutter SDK >=3.0.0
- Dart SDK (bundled with Flutter)
- Firebase project and appropriate configuration files.

### Installation
```bash
git clone <repo-url>
cd masraf_app
flutter pub get
```

### Firebase Configuration

Add your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) to the respective folders. Update `firebase_options.dart` via FlutterFire CLI if needed.

## 13. Running the Application

```bash
# Android
flutter run -d android

# Web
flutter run -d chrome

# Windows
flutter run -d windows
```

## 14. Testing

```bash
flutter test
```

## 15. Contributing

1. Fork the repository.
2. Create a feature branch.
3. Commit changes with descriptive messages.
4. Open a pull request for review.

## 16. License

This project is licensed under the MIT License. 
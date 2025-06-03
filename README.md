# MasrafApp 💰

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-FFA611?style=for-the-badge&logo=firebase&logoColor=white)](https://firebase.google.com)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)

**MasrafApp** is a sleek, cross-platform Flutter application designed to simplify personal expense tracking. Built with modern architecture and powerful features, it provides users with an intuitive interface to manage their finances across mobile, web, and desktop platforms.

## 🚀 About

MasrafApp transforms the way you handle personal finance management by offering a comprehensive expense tracking solution. Whether you're monitoring daily expenses, analyzing spending patterns, or setting financial goals, this application provides all the tools you need in a beautifully crafted interface.

The application leverages Flutter's cross-platform capabilities to deliver a consistent experience across all devices, while Firebase integration ensures your data is securely stored and synchronized in real-time. With support for multiple languages, customizable themes, and powerful analytics, MasrafApp adapts to your personal preferences and financial tracking needs.

## ✨ Key Features

### 🔐 Authentication & Security
- **Secure User Authentication**: Email/password login with robust validation
- **Google Sign-In Integration**: Quick and secure authentication via Google
- **Account Management**: Profile settings and user customization options

### 💸 Expense Management
- **Easy Expense Entry**: Add, edit, and delete expenses with intuitive forms
- **Category Organization**: Customizable expense categories for better organization
- **Receipt Attachments**: Upload and store receipt images using Firebase Storage
- **Bulk Operations**: Manage multiple expenses efficiently

### 📊 Analytics & Insights
- **Interactive Charts**: Beautiful visualizations powered by fl_chart library
- **Category Breakdown**: Detailed analysis of spending by categories
- **Time-based Filtering**: View expenses by current month, last 7 days, or last 30 days
- **Total Calculations**: Automatic computation of totals and subtotals
- **Spending Trends**: Track financial patterns over time

### 🎨 User Experience
- **Theme Switching**: Toggle between light and dark modes
- **Font Size Adjustment**: Customize text size for better readability
- **Responsive Design**: Optimized for mobile, tablet, web, and desktop
- **Smooth Animations**: Polished transitions and micro-interactions

### 🌍 Localization
- **Multi-language Support**: Available in English and Turkish
- **Cultural Adaptation**: Localized date formats and currency symbols
- **Easy Language Switching**: Change language preferences on-the-fly

### ☁️ Cloud Integration
- **Real-time Sync**: Seamless data synchronization across all devices
- **Firebase Backend**: Reliable cloud storage with Firestore database
- **Offline Support**: Continue using the app even without internet connection
- **Data Backup**: Automatic cloud backup ensures data safety

## 🛠️ Technology Stack

### Frontend
- **Flutter**: Cross-platform UI framework for mobile, web, and desktop
- **Dart**: Programming language optimized for client development

### State Management
- **Riverpod**: Modern, compile-safe state management solution
- **Provider Pattern**: Efficient dependency injection and state handling

### Navigation
- **GoRouter**: Declarative routing solution for Flutter applications
- **Deep Linking**: Support for URL-based navigation

### Backend Services
- **Firebase Authentication**: Secure user authentication and authorization
- **Cloud Firestore**: NoSQL document database for storing expense data
- **Firebase Storage**: Cloud storage for receipt images and attachments

### UI & Visualization
- **fl_chart**: Beautiful and interactive charts for data visualization
- **Google Fonts**: Wide selection of fonts for enhanced typography
- **flutter_svg**: SVG support for crisp icons and graphics

### Utilities
- **shared_preferences**: Local storage for user preferences
- **intl**: Internationalization and localization support
- **uuid**: Unique identifier generation for data integrity

## 📋 System Requirements

### Development Environment
- **Flutter SDK**: Version 3.0.0 or higher
- **Dart SDK**: Bundled with Flutter (latest stable version)
- **IDE**: Android Studio, VS Code, or IntelliJ IDEA with Flutter plugins

### Target Platforms
- **Android**: API level 21 (Android 5.0) or higher
- **iOS**: iOS 11.0 or higher
- **Web**: Modern browsers (Chrome, Firefox, Safari, Edge)
- **Desktop**: Windows 10+, macOS 10.14+, Linux (Ubuntu 18.04+)

### Firebase Requirements
- Active Firebase project with the following services enabled:
  - Firebase Authentication
  - Cloud Firestore
  - Firebase Storage
- Platform-specific configuration files properly set up

## 🚀 Installation & Setup

### 1. Clone the Repository
```bash
git clone https://github.com/mtgsoftworks/MasrafApp.git
cd MasrafApp
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Firebase Configuration

#### Create Firebase Project
1. Visit the [Firebase Console](https://console.firebase.google.com)
2. Create a new project or select an existing one
3. Enable Authentication, Firestore, and Storage services

#### Platform Configuration

**Android Setup:**
1. Add an Android app in Firebase Console
2. Download `google-services.json`
3. Place it in `android/app/` directory

**iOS Setup:**
1. Add an iOS app in Firebase Console
2. Download `GoogleService-Info.plist`
3. Place it in `ios/Runner/` directory

**Web Setup:**
1. Add a web app in Firebase Console
2. Copy the configuration
3. Update `web/index.html` with Firebase config

**Desktop Setup:**
1. Configure Firebase for desktop platforms
2. Update `firebase_options.dart` using FlutterFire CLI

### 4. FlutterFire CLI Configuration
```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase for your project
flutterfire configure
```

## 🏃‍♂️ Running the Application

### Mobile Development
```bash
# Run on Android device/emulator
flutter run -d android

# Run on iOS device/simulator (macOS only)
flutter run -d ios
```

### Web Development
```bash
# Run on web browser
flutter run -d chrome

# Build for web deployment
flutter build web
```

### Desktop Development
```bash
# Run on Windows
flutter run -d windows

# Run on macOS
flutter run -d macos

# Run on Linux
flutter run -d linux
```

## 📁 Project Structure

```
masraf_app/
├── android/                    # Android-specific files
├── ios/                       # iOS-specific files
├── web/                       # Web-specific files
├── windows/                   # Windows-specific files
├── macos/                     # macOS-specific files
├── linux/                     # Linux-specific files
├── lib/                       # Main application code
│   ├── auth/                  # Authentication related code
│   │   ├── providers/         # Auth state providers
│   │   ├── services/          # Auth services
│   │   └── widgets/           # Auth UI components
│   ├── features/              # Feature-specific modules
│   │   ├── expenses/          # Expense management
│   │   ├── analytics/         # Charts and analytics
│   │   ├── categories/        # Category management
│   │   └── settings/          # App settings
│   ├── home/                  # Home screen components
│   ├── shared/                # Shared utilities and widgets
│   │   ├── constants/         # App constants
│   │   ├── models/            # Data models
│   │   ├── providers/         # Global providers
│   │   ├── services/          # API services
│   │   ├── utils/             # Utility functions
│   │   └── widgets/           # Reusable widgets
│   ├── l10n/                  # Localization files
│   ├── main.dart              # Application entry point
│   └── firebase_options.dart  # Firebase configuration
├── assets/                    # Static assets
│   ├── images/                # Image files
│   ├── icons/                 # Icon files
│   └── fonts/                 # Custom fonts
├── test/                      # Unit and widget tests
├── integration_test/          # Integration tests
├── pubspec.yaml              # Project dependencies
├── .gitignore                # Git ignore rules
├── README.md                 # Project documentation
└── LICENSE                   # License information
```

## 🎯 Usage Guide

### Getting Started
1. **Sign Up/Sign In**: Create an account or sign in with existing credentials
2. **Set Up Categories**: Customize expense categories to match your needs
3. **Add Your First Expense**: Record an expense with amount, category, and optional receipt
4. **Explore Analytics**: View charts and insights about your spending patterns

### Key Workflows

**Adding an Expense:**
1. Tap the '+' button on the home screen
2. Enter expense amount and description
3. Select or create a category
4. Optionally attach a receipt photo
5. Save the expense

**Viewing Analytics:**
1. Navigate to the Analytics tab
2. Select desired time range (7 days, 30 days, current month)
3. Explore category breakdowns and trends
4. Use interactive charts to drill down into data

**Managing Categories:**
1. Go to Settings > Categories
2. Add, edit, or delete expense categories
3. Customize category colors and icons
4. Set category-specific budgets

## 🤝 Contributing

We welcome contributions from the community! Here's how you can help improve MasrafApp:

### Development Workflow
1. **Fork the Repository**: Create your own fork of the project
2. **Create a Feature Branch**: `git checkout -b feature/amazing-feature`
3. **Make Your Changes**: Implement your feature or bug fix
4. **Write Tests**: Add unit tests for your changes
5. **Commit Changes**: `git commit -m 'Add amazing feature'`
6. **Push to Branch**: `git push origin feature/amazing-feature`
7. **Open Pull Request**: Submit your changes for review

### Contribution Guidelines
- Follow Flutter and Dart coding conventions
- Write clear, concise commit messages
- Include tests for new features
- Update documentation as needed
- Ensure all tests pass before submitting

### Areas for Contribution
- 🐛 Bug fixes and improvements
- ✨ New features and enhancements
- 🌍 Additional language translations
- 📚 Documentation improvements
- 🧪 Test coverage expansion
- 🎨 UI/UX enhancements

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

### MIT License Summary
- ✅ Commercial use
- ✅ Modification
- ✅ Distribution
- ✅ Private use
- ❌ Liability
- ❌ Warranty

## 🏷️ Topics

`flutter` `dart` `expense-tracker` `finance-management` `cross-platform` `mobile-app` `web-app` `desktop-app` `firebase` `riverpod` `material-design` `analytics` `charts` `localization` `authentication` `cloud-storage` `responsive-design` `money-management` `budget-tracker` `personal-finance`

## 📞 Support & Contact

- **Issues**: [GitHub Issues](https://github.com/mtgsoftworks/MasrafApp/issues)
- **Discussions**: [GitHub Discussions](https://github.com/mtgsoftworks/MasrafApp/discussions)
- **Developer**: [MTG Softworks](https://github.com/mtgsoftworks)

---

**Made with ❤️ by MTG Softworks**

*Transform your financial tracking experience with MasrafApp - where simplicity meets powerful functionality

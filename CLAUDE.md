# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

6Cash (six_cash) is a Flutter mobile financial services app supporting money transfers, cash out, add money, international transfers, KYC verification, and QR payments. It targets Android (minSdk 21, targetSdk 34) and iOS (16.0+).

## Build & Development Commands

```bash
# Flutter version (managed via FVM)
fvm use 3.27.0            # or use Flutter 3.27.0 directly

# Dependencies
flutter pub get

# Run
flutter run                # debug mode
flutter run --release      # release mode

# Build
flutter build apk          # Android APK
flutter build appbundle    # Android App Bundle
flutter build ios          # iOS

# Analysis
flutter analyze            # static analysis (uses flutter_lints)

# Tests
flutter test               # run all tests
flutter test test/widget_test.dart  # run single test

# iOS-specific
cd ios && pod install       # install CocoaPods dependencies

# Android-specific
cd android && ./gradlew assembleRelease
```

## Architecture

**Pattern**: Feature-based architecture with GetX for state management, routing, and dependency injection.

### Key directories under `lib/`:

- **`features/`** — Each feature is a self-contained module with `controllers/`, `domain/` (models + repos), `screens/`, and `widgets/` subdirectories. Features: `auth`, `transaction_money`, `requested_money`, `add_money`, `home`, `history`, `inter-reseaux` (international transfers), `camera_verification`, `kyc_verification`, `forget_pin`, `notification`, `setting`, `language`, `onboarding`, `splash`, `verification`.
- **`common/`** — Shared models (`config_model`, `contact_model`, `response_model`, `signup_body_model`) and reusable widgets (`custom_button_widget`, `custom_text_field_widget`, `custom_app_bar_widget`, etc.).
- **`data/api/`** — HTTP client (`api_client.dart`) and response validation (`api_checker.dart`).
- **`helper/`** — Dependency injection setup (`get_di.dart`), route definitions (`route_helper.dart`), and utility helpers (snackbar, date conversion, price formatting, phone validation).
- **`util/`** — App-wide constants, colors, dimensions, image paths, styles.
- **`theme/`** — Light and dark theme definitions.
- **`firebase/`** — FCM push notifications and Crashlytics integration (project: Buudi).

### Dependency Injection & Routing

All services, repositories, and controllers are registered in `lib/helper/get_di.dart` using GetX bindings. Routes are defined in `lib/helper/route_helper.dart` using GetX named routes.

### API Layer

`ApiClient` in `lib/data/api/api_client.dart` is a centralized HTTP client. Feature-specific repositories (in each feature's `domain/` folder) call ApiClient methods. `ApiChecker` handles error responses globally.

### Localization

Three languages supported: English (`en.json`), French (`fr.json`), Arabic (`ar.json`) in `assets/language/`. Managed through GetX internationalization.

## Key Technical Details

- **Dart SDK**: >=2.12.0 <4.0.0 (null safety enabled)
- **State management**: GetX (GetxController subclasses in each feature's `controllers/`)
- **Android signing**: configured via `android/key.properties`
- **Kotlin version**: 2.1.0
- **Linting**: `flutter_lints` package (config in `analysis_options.yaml`)
- **Firebase**: Core, Messaging (FCM), Crashlytics
- **Biometric auth**: `local_auth` package
- **Camera/ML**: `google_mlkit_face_detection` and `google_mlkit_barcode_scanning` for KYC and QR

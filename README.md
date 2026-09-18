# Retailer Scanner App

A Flutter project for the BuyEasy Retailer Scanner (OrderEasy). Catalog capture only — not POS.

**Help wiki (18 Sep 2026):** see [`ordereasy-help-wiki/`](ordereasy-help-wiki/README.md). Canonical copy belongs in `RetailerCustomerPlatform/wiki/`.

## Android Build Setup

The Android SDK has been configured locally in `~/android_sdk`.

### Building the APK
To build the debug APK, run:
```bash
flutter build apk --debug
```

To build for release:
```bash
flutter build apk --release
```

The APK will be located at `build/app/outputs/flutter-apk/app-debug.apk`.

### Dependencies
This project uses `.env` for configuration. Ensure the `.env` file exists in the root directory.

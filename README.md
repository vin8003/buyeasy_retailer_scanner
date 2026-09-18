# Retailer Scanner App

A Flutter project for the BuyEasy Retailer Scanner (OrderEasy). Catalog capture only — not POS.

**Help wiki (18 Sep 2026):** see [`ordereasy-help-wiki/`](ordereasy-help-wiki/README.md). Canonical copy belongs in `RetailerCustomerPlatform/wiki/`. To land it: add scanner secret `RCP_PUSH_TOKEN` and run Actions → **Apply OrderEasy help wiki to RCP**, or `git am` the [release patches](https://github.com/vin8003/buyeasy_retailer_scanner/releases/tag/wiki-sep-2026-2c2e).

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

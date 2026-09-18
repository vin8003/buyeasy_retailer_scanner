# Retailer Scanner App

A Flutter project for the BuyEasy Retailer Scanner.

## OrderEasy help wiki (18 Sep 2026)

Canonical copy belongs in `RetailerCustomerPlatform/wiki/` on `main` (still August `e9420db`). Do **not** merge branch `rcp-wiki-applied` into this Flutter `master` — that branch is the RCP git tree.

On a machine with RCP push access:

```bash
git clone git@github.com:vin8003/RetailerCustomerPlatform.git
curl -fsSL https://raw.githubusercontent.com/vin8003/buyeasy_retailer_scanner/feature/wiki-content-update-2c2e/ordereasy-help-wiki/fetch-apply-from-scanner.sh | bash -s -- ./RetailerCustomerPlatform
```

Ticket: https://github.com/vin8003/RetailerCustomerPlatform/issues/178 · secret `RCP_PUSH_TOKEN`: https://github.com/vin8003/buyeasy_retailer_scanner/issues/3 · Release: https://github.com/vin8003/buyeasy_retailer_scanner/releases/tag/wiki-sep-2026-2c2e

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

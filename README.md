# Retailer Scanner App

A Flutter project for the BuyEasy Retailer Scanner (OrderEasy). Catalog capture only — not POS.

**Help wiki (18 Sep 2026):** see [`ordereasy-help-wiki/`](ordereasy-help-wiki/README.md). Canonical copy belongs in `RetailerCustomerPlatform/wiki/`. Gmail blocked the patch tarball; land with [issue 137](https://github.com/vin8003/RetailerCustomerPlatform/issues/137) (patches in the issue body), the [Release](https://github.com/vin8003/buyeasy_retailer_scanner/releases/tag/wiki-sep-2026-2c2e), [`curl-apply-from-release.sh`](ordereasy-help-wiki/curl-apply-from-release.sh), or Actions secret `RCP_PUSH_TOKEN` → **Apply OrderEasy help wiki to RCP**.

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

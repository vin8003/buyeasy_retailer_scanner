---
description: Build Android APK for Retailer Scanner
---

This workflow automates the process of building a debug or release APK for the BuyEasy Retailer Scanner app.

### Prerequisites
- Flutter SDK installed
- Android SDK configured in `~/android_sdk` (already set up by Antigravity)

### Build Steps

1. **Get Dependencies**
// turbo
```bash
flutter pub get
```

2. **Build Debug APK**
// turbo
```bash
flutter build apk --debug
```

3. **Build Release APK**
Note: This requires signing configuration if not already set.
// turbo
```bash
flutter build apk --release
```

The resulting APK will be available in `build/app/outputs/flutter-apk/`.

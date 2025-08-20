# Open The Store

A Flutter plugin to open the app store page for your app on Android and iOS.

## Features

- ✅  Open the app store on Android and iOS.
- ✅  Fallback to a web URL if the app store cannot be opened.
- ✅  Get the app store URL for your app.

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  open_the_store:
```

Then, run `flutter pub get` to install the package.

## Usage

```dart
import 'package:open_the_store/open_the_store.dart';

// Open the app store page for your app.
final openAppStore = OpenAppStore();
openAppStore.open();

// Open the app store page for your app with a fallback URL.
openAppStore.open(fallbackUrl: 'https://example.com');
```

## Contributing

Contributions are welcome! Please feel free to submit a pull request or open an issue.

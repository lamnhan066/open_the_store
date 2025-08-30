# Open The Store

A Flutter plugin to open the app store page for your app on Android, iOS and macOS.

## Features

- ✅  Open the app store on Android, iOS and macOS.
- ✅  Fallback to a web URL if the app store cannot be opened.

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
OpenTheStore.instance.open();

// Open the app store page for your app with a fallback URL.
OpenTheStore.instance.open(fallbackUrl: 'https://example.com');
```

## Contributing

Contributions are welcome! Please feel free to submit a pull request or open an issue.

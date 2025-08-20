import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

class OpenTheStore {
  /// Private constructor for the singleton.
  OpenTheStore._();

  /// The singleton instance of [OpenTheStore].
  static final OpenTheStore instance = OpenTheStore._();

  /// Opens the app store page for the current app.
  /// If [fallbackUrl] is provided, it will be used if the store URL cannot be opened.
  /// Set [debug] to true to enable debug logging.
  Future<void> open({String? fallbackUrl, bool debug = false}) async {
    void debugPrint(String message) {
      if (debug) {
        // ignore: avoid_print
        print(message);
      }
    }

    if (kIsWeb) {
      if (fallbackUrl != null && await canLaunchUrlString(fallbackUrl)) {
        debugPrint('Web: Opening fallbackUrl: $fallbackUrl');
        await launchUrlString(fallbackUrl);
      } else {
        debugPrint('Web: No fallbackUrl provided or cannot launch.');
      }
      return;
    }

    final packageInfo = await PackageInfo.fromPlatform();
    final packageName = packageInfo.packageName;

    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        final androidMarketUrl = 'market://details?id=$packageName';
        final androidPlayUrl =
            'https://play.google.com/store/apps/details?id=$packageName';

        if (await canLaunchUrlString(androidMarketUrl)) {
          debugPrint('Android: Launching market URL.');
          await launchUrlString(
            androidMarketUrl,
            mode: LaunchMode.externalApplication,
          );
        } else if (await canLaunchUrlString(androidPlayUrl)) {
          debugPrint('Android: Launching Play Store URL.');
          await launchUrlString(
            androidPlayUrl,
            mode: LaunchMode.externalApplication,
          );
        } else if (fallbackUrl != null &&
            await canLaunchUrlString(fallbackUrl)) {
          debugPrint('Android: Launching fallbackUrl.');
          await launchUrlString(
            fallbackUrl,
            mode: LaunchMode.externalApplication,
          );
        } else {
          throw Exception('Cannot launch Android store or fallback URL.');
        }
        return;
      }

      if (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.macOS) {
        try {
          final lookupUrl =
              'https://itunes.apple.com/lookup?bundleId=$packageName';
          final response = await http.get(Uri.parse(lookupUrl));
          final json = jsonDecode(response.body) as Map<String, dynamic>;

          if (json['results'] != null &&
              json['results'].isNotEmpty &&
              json['results'][0]['trackId'] != null) {
            final trackId = json['results'][0]['trackId'];
            final appStoreUrl = 'https://apps.apple.com/app/id$trackId';
            debugPrint('iOS/macOS: Launching App Store URL: $appStoreUrl');
            await launchUrlString(
              appStoreUrl,
              mode: LaunchMode.externalApplication,
            );
          } else {
            throw Exception('No trackId found in App Store lookup.');
          }
        } catch (e) {
          debugPrint(
            'iOS/macOS: Failed to get App Store URL, trying fallbackUrl.',
          );
          if (fallbackUrl != null && await canLaunchUrlString(fallbackUrl)) {
            await launchUrlString(
              fallbackUrl,
              mode: LaunchMode.externalApplication,
            );
          } else {
            rethrow;
          }
        }
        return;
      }

      // Other platforms
      if (fallbackUrl != null && await canLaunchUrlString(fallbackUrl)) {
        debugPrint('Other: Launching fallbackUrl.');
        await launchUrlString(
          fallbackUrl,
          mode: LaunchMode.externalApplication,
        );
      } else {
        throw Exception('Cannot launch fallback URL on this platform.');
      }
    } catch (e) {
      debugPrint('Error: Cannot open the App Store automatically!');
      rethrow;
    }
  }
}

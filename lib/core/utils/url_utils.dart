import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlUtils {
  static const String privacyPolicyUrl = 'https://rubimedik.com/privacy.html';
  static const String termsUrl = 'https://rubimedik.com/terms.html';

  static Future<void> openPrivacyPolicy(BuildContext context) =>
      _launch(context, privacyPolicyUrl);

  static Future<void> openTerms(BuildContext context) =>
      _launch(context, termsUrl);

  static Future<void> _launch(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open link')),
        );
      }
    }
  }
}

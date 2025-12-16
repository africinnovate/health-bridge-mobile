import 'package:flutter/material.dart';
import '../../presentation/widgets/thank_you_dialog.dart';

void showThankYouDialog(
  BuildContext context, {
  String? title,
  String? message,
  String? buttonText,
  VoidCallback? onContinue,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => ThankYouDialog(
      title: title ?? 'Thank You',
      message: message ??
          'Your consent helps us provide safe and personalized care.',
      buttonText: buttonText ?? 'Continue',
      onContinue: onContinue,
    ),
  );
}

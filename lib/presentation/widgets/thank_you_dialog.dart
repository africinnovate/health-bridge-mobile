import 'package:flutter/material.dart';

import 'custom_button.dart';

class ThankYouDialog extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback? onContinue;

  const ThankYouDialog({
    super.key,
    this.title = 'Thank You',
    this.message = 'Your consent helps us provide safe and personalized care.',
    this.buttonText = 'Continue',
    this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Green check icon
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green.withOpacity(0.1),
              ),
              child: Center(
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green.withOpacity(0.2),
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.green,
                    size: 36,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            /// Message
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 24),

            /// Continue button
            CustomButton(
              onPressed: () {
                Navigator.pop(context);
                onContinue?.call();
              },
              text: buttonText,
              // shouldProceed: canContinue,
              showLoading: false,
            ),
          ],
        ),
      ),
    );
  }
}

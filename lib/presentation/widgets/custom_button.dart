import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

import 'custom_text.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color? color;
  final bool? shouldFullScreen;
  final bool shouldProceed;
  final bool showLoading;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.color,
    this.shouldFullScreen = true,
    this.shouldProceed = true,
    this.showLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: shouldProceed && !showLoading ? onPressed : null,
      style: ElevatedButton.styleFrom(
        padding: shouldFullScreen == true
            ? null
            : const EdgeInsets.symmetric(horizontal: 150, vertical: 10),
        minimumSize:
            shouldFullScreen == true ? const Size(double.infinity, 48) : null,
        backgroundColor: color ?? AppColors.red,
        disabledBackgroundColor: color ?? AppColors.red.withOpacity(0.4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: showLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : CustomText(
              text: text,
              size: 18,
              color: AppColors.white,
            ),
    );
  }
}

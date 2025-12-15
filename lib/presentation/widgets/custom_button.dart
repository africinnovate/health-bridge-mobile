import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color? color;
  final bool? shouldFullScreen;
  final bool shouldProceed;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.color,
    this.shouldFullScreen = true,
    this.shouldProceed = true,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: shouldProceed ? onPressed : null,
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
      child: Text(
        text, // Localize the button text
        maxLines: 1,
        overflow: TextOverflow.visible,
        style: TextStyle(
          fontSize: 18,
          color: AppColors.white,
        ),
      ),
    );
  }
}

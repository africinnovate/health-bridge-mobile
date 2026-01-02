import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:flutter/material.dart';

class CancelButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const CancelButton({
    super.key,
    this.text = 'Cancel',
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.red,
          backgroundColor: AppColors.transRed10,
          side: BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: onPressed ?? () => context.goBack(),
        child: Text(text),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class InputTextFieldWG extends StatelessWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;
  final Color? textColor;
  final Color? hintColor;
  final String hintText;
  final Color focusedBorderColor;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Widget? suffixIconWidget;
  final int? maxLines;
  // final int? maxLength;

  const InputTextFieldWG({
    super.key,
    required this.controller,
    this.onChanged,
    this.textColor,
    this.hintColor,
    required this.hintText,
    this.focusedBorderColor = AppColors.green,
    this.prefixIcon,
    this.suffixIcon,
    this.suffixIconWidget,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final textColor_ = textColor ?? AppColors.textPrimary;
    final hintColor_ = hintColor ?? textColor_;

    return TextField(
      controller: controller,
      onChanged: onChanged,
      maxLines: maxLines,
      style: TextStyle(color: textColor_, fontSize: 16),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: hintColor_.withOpacity(0.6),
          fontWeight: FontWeight.w300,
        ),
        prefixIcon: prefixIcon != null
            ? Icon(
                prefixIcon,
                color: hintColor_.withOpacity(0.6),
                size: 24,
              )
            : null,
        suffixIcon: suffixIconWidget ??
            (suffixIcon != null
                ? Icon(
                    suffixIcon,
                    color: hintColor_.withOpacity(0.6),
                    size: 24,
                  )
                : null),
        // border: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(12),
        //   borderSide: BorderSide(
        //     color: context.blueCoolBlue.withOpacity(0.3),
        //   ),
        // ),
        fillColor: AppColors.backgroundGray,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.backgroundGray),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: focusedBorderColor),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 13,
        ),
      ),
    );
  }
}

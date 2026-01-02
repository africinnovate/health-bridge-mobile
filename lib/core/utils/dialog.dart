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

void showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  required VoidCallback onConfirm,
  VoidCallback? onCancel,
  String confirmText = 'Confirm',
  String cancelText = 'Cancel',
  IconData icon = Icons.help_outline,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => ConfirmationDialog(
      title: title,
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
      icon: icon,
      onConfirm: () {
        Navigator.pop(context);
        onConfirm();
      },
      onCancel: () {
        Navigator.pop(context);
        onCancel?.call();
      },
    ),
  );
}

/* == logout
showConfirmDialog(
  context,
  title: 'Log out?',
  message: 'You will need to login again.',
  confirmText: 'Log out',
  cancelText: 'Stay',
  icon: Icons.logout,
  onConfirm: logoutUser,
);
 */

/*  == delete
showConfirmDialog(
  context,
  title: 'Delete Item?',
  message: 'This action cannot be undone.',
  confirmText: 'Delete',
  cancelText: 'Cancel',
  icon: Icons.delete_outline,
  onConfirm: deleteItem,
);
 */

import 'package:HealthBridge/core/constants/app_routes.dart';
import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../presentation/widgets/thank_you_dialog.dart';
import 'snackbar_utils.dart';

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

/// Shows a confirmation dialog then permanently deletes the account.
/// Navigates to [AppRoutes.login] on success.
void showDeleteAccountDialog(BuildContext context) {
  showConfirmDialog(
    context,
    title: 'Delete Account',
    message:
        'Are you sure you want to permanently delete your account? This action cannot be undone.',
    confirmText: 'Delete',
    cancelText: 'Cancel',
    icon: Icons.delete_forever_outlined,
    onConfirm: () => _performDeleteAccount(context),
  );
}

Future<void> _performDeleteAccount(BuildContext context) async {
  final authProvider = Provider.of<AuthProvider>(context, listen: false);

  context.showLoadingDialog();

  try {
    final error = await authProvider.deleteAccount();

    if (error != null) {
      if (context.mounted) {
        context.hideLoadingDialog();
        SnackBarUtils.showError(context, error);
      }
      return;
    }

    if (context.mounted) context.go(AppRoutes.login);
  } catch (e) {
    if (context.mounted) {
      context.hideLoadingDialog();
      SnackBarUtils.showError(context, 'An error occurred while deleting account');
    }
  }
}

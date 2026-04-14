import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/core/utils/snackbar_utils.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:HealthBridge/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/utils/dialog.dart';
import '../../../../core/utils/url_utils.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/specialist_provider.dart';

class SpecialistSettingsScreen extends StatelessWidget {
  final bool? showBackArrow;
  const SpecialistSettingsScreen({super.key, this.showBackArrow});

  @override
  Widget build(BuildContext context) {
    return Consumer<SpecialistProvider>(
      builder: (context, specialistProvider, child) {
        final profile = specialistProvider.specialistProfileM;
        if (profile == null) {
          specialistProvider.getSpecialistProfile();
        }

        return Scaffold(
          // backgroundColor: const Color(0xFFF9FAFB),
          appBar: CustomAppBar(
            title: "Settings",
            showArrow: showBackArrow ?? false,
          ),
          body: profile == null
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _accountSection(context),
                      const SizedBox(height: 24),
                      CustomButton(
                          onPressed: () => logout(context), text: "Log Out"),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
        );
      },
    );
  }

  void logout(BuildContext context) {
    showConfirmDialog(
      context,
      title: 'Log out?',
      message: 'You will need to login again.',
      confirmText: 'Log out',
      cancelText: 'Stay',
      icon: Icons.logout,
      onConfirm: () {
        _performLogout(context);
      },
    );
  }

  /// Perform logout - call API and clear storage
  Future<void> _performLogout(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Show loading
    context.showLoadingDialog();

    try {
      // Call logout API (also clears SecureStorage)
      final error = await authProvider.logout();

      if (error != null) {
        // if (!mounted) return;
        SnackBarUtils.showError(context, error);
        authProvider.setIsLoadingToFalse();
        return;
      }

      // Success - navigate to login screen
      // if (!mounted) return;
      SnackBarUtils.showSuccess(context, "Logged out successfully");

      // Navigate to login and clear navigation stack
      context.go(AppRoutes.login);
    } catch (e) {
      // if (!mounted) return;
      SnackBarUtils.showError(context, "An error occurred during logout");
      context.hideLoadingDialog();
    }
  }

  /// ---------------- Account ----------------
  Widget _accountSection(BuildContext context) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Account',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          _accountTile(Icons.person, 'Profile',
              onTap: () => context.goNextScreen(AppRoutes.specialistProfile)),
          _accountTile(Icons.wallet, 'Bank Account',
              onTap: () => SnackBarUtils.showInfo(
                  context, "Bank account feature coming soon!")),
          _accountTile(
            Icons.lock,
            'Change Password',
            onTap: () async {
              // Refresh token in background to ensure valid token for password change
              final authProvider =
                  Provider.of<AuthProvider>(context, listen: false);
              authProvider.refreshAccessToken();

              // Navigate immediately while token refresh happens in background
              context.goNextScreen(AppRoutes.changePassword);
            },
          ),
          _accountTile(Icons.insert_invitation, 'Referral',
              onTap: () => context.push(AppRoutes.referralWallet)),
          _accountTile(Icons.description, 'Terms & Conditions',
              onTap: () => UrlUtils.openTerms(context)),
          _accountTile(Icons.language, 'Language', trailing: 'English'),
          _accountTile(Icons.privacy_tip, 'Privacy Policy',
              onTap: () => UrlUtils.openPrivacyPolicy(context)),
          _accountTile(Icons.support_agent, 'Contact Support',
              onTap: () => SnackBarUtils.showInfo(
                  context, "Contact support feature coming soon!")),
          _accountTile(Icons.delete, 'Delete Account',
              onTap: () => showDeleteAccountDialog(context)),
        ],
      ),
    );
  }

  /// ---------------- Helpers ----------------
  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }

  Widget _accountTile(IconData icon, String title,
      {String? trailing, VoidCallback? onTap}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.grey),
      title: Text(title),
      trailing: trailing != null
          ? Text(trailing, style: const TextStyle(color: Colors.grey))
          : const Icon(Icons.chevron_right),
      onTap: onTap ?? () {},
    );
  }
}

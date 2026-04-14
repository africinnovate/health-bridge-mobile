import 'dart:io';

import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:HealthBridge/core/constants/app_routes.dart';
import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/core/utils/snackbar_utils.dart';
import 'package:HealthBridge/presentation/providers/hospital_provider.dart';
import 'package:HealthBridge/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/dialog.dart';
import '../../../../core/utils/url_utils.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/blood_request_provider.dart';

class HospitalSettingsScreen extends StatefulWidget {
  const HospitalSettingsScreen({super.key});

  @override
  State<HospitalSettingsScreen> createState() => _HospitalSettingsScreenState();
}

class _HospitalSettingsScreenState extends State<HospitalSettingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<HospitalProvider>();
      if (provider.hospitalProfile == null) {
        provider.getHospitalProfile();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      appBar: CustomAppBar(title: "Settings", showArrow: false),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Account Section
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Text(
                        'Account',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    _menuItem(
                      Icons.person,
                      'Profile',
                      Icons.chevron_right,
                      () => context.push(AppRoutes.hospitalProfile),
                    ),
                    const Divider(height: 1),
                    _menuItem(
                      Icons.wallet,
                      'Bank Account',
                      Icons.chevron_right,
                      () => SnackBarUtils.showInfo(
                          context, "Wallet feature coming soon!"),
                    ),
                    const Divider(height: 1),
                    _menuItem(
                      Icons.lock_outline,
                      'Change Password',
                      Icons.chevron_right,
                      () => context.push(AppRoutes.changePassword),
                    ),
                    const Divider(height: 1),
                    _menuItem(
                      Icons.insert_invitation,
                      'Referral',
                      Icons.chevron_right,
                      () => context.push(AppRoutes.referralWallet),
                    ),
                    const Divider(height: 1),
                    _menuItem(
                      Icons.notifications,
                      'Notification',
                      Icons.chevron_right,
                      () => context.push(AppRoutes.notificationsHospital,
                          extra: true),
                      // unused - notificationsSettings
                    ),
                    const Divider(height: 1),
                    _menuItem(
                      Icons.description_outlined,
                      'Terms & Conditions',
                      Icons.chevron_right,
                      () => UrlUtils.openTerms(context),
                    ),
                    const Divider(height: 1),
                    _menuItem(
                      Icons.shield_outlined,
                      'Privacy Policy',
                      Icons.chevron_right,
                      () => UrlUtils.openPrivacyPolicy(context),
                    ),
                    const Divider(height: 1),
                    _menuItem(
                      Icons.delete,
                      'Delete Account',
                      Icons.chevron_right,
                      () => showDeleteAccountDialog(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              /// Logout Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: CustomButton(
                  onPressed: _showLogoutDialog,
                  text: 'Log Out',
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  /// Show logout confirmation dialog
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Log Out',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        content: const Text(
          'Are you sure you want to log out?',
          style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF6B7280)),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog
              await _performLogout();
            },
            child: const Text(
              'Log Out',
              style:
                  TextStyle(color: AppColors.red, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  /// Perform logout - call API and clear storage
  Future<void> _performLogout() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Show loading
    context.showLoadingDialog();

    try {
      // Call logout API (also clears SecureStorage)
      final error = await authProvider.logout();

      if (error != null) {
        if (!mounted) return;
        SnackBarUtils.showError(context, error);
        authProvider.setIsLoadingToFalse();
        return;
      }

      // Clear cached blood request data so it doesn't leak to the next session
      if (mounted) {
        context.read<BloodRequestProvider>().clearRequests();
      }

      // Success - navigate to login screen
      if (!mounted) return;

      // Navigate to login and clear navigation stack
      context.go(AppRoutes.login);
    } catch (e) {
      if (!mounted) return;
      SnackBarUtils.showError(context, "An error occurred during logout");
      context.hideLoadingDialog();
    }
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: const Color(0xFF6B7280)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style:
                      const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
              const SizedBox(height: 4),
              Text(value,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF111827))),
            ],
          ),
        ),
      ],
    );
  }

  Widget _statusRow(IconData icon, String label, String status, bool active) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: const Color(0xFF6B7280)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style:
                      const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
              const SizedBox(height: 4),
              Text(status,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color:
                          active ? AppColors.green : const Color(0xFFD97706))),
            ],
          ),
        ),
      ],
    );
  }

  Widget _documentRow(
      IconData icon, String label, String linkText, String url) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: const Color(0xFF6B7280)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style:
                      const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: () => context.push(AppRoutes.documentViewer, extra: url),
                child: Text(
                  linkText,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _bloodTypeBadge(String type, Color color) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Center(
        child: Text(
          type,
          style: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  Widget _editButton() {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () =>
            context.push(AppRoutes.setProfileHospital, extra: true),
        style: TextButton.styleFrom(
          backgroundColor: AppColors.backgroundGray,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'Edit',
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary),
        ),
      ),
    );
  }

  Widget _editServicesButton() {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () =>
            context.push(AppRoutes.bloodServiceHospital, extra: true),
        style: TextButton.styleFrom(
          backgroundColor: AppColors.backgroundGray,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'Edit Services',
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary),
        ),
      ),
    );
  }

  Widget _menuItem(IconData leadingIcon, String title, IconData trailingIcon,
      VoidCallback onTap) {
    return ListTile(
      leading: Icon(leadingIcon, color: const Color(0xFF6B7280), size: 22),
      title: Text(title,
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF111827))),
      trailing: Icon(trailingIcon, color: const Color(0xFF9CA3AF), size: 20),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }
}

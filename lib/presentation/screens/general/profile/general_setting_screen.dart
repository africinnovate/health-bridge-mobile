import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/constants/app_routes.dart';
import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/core/utils/snackbar_utils.dart';
import 'package:HealthBridge/core/utils/url_utils.dart';
import 'package:HealthBridge/presentation/providers/auth_provider.dart';
import 'package:HealthBridge/presentation/providers/patient_provider.dart';
import 'package:HealthBridge/presentation/widgets/custom_button.dart';
import 'package:HealthBridge/presentation/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// this screen is used by patient and donor
class GeneralSettingScreen extends StatefulWidget {
  const GeneralSettingScreen({super.key});

  @override
  State<GeneralSettingScreen> createState() => _GeneralSettingScreenState();
}

class _GeneralSettingScreenState extends State<GeneralSettingScreen> {
  bool isPatient = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Consumer<PatientProvider>(
            builder: (context, provider, child) {
              final profile = provider.patientProfileM;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  /// Title
                  const Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  /// Subtitle
                  const Text(
                    'Manage your personal information, preferences, and account settings.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 18),

                  RoleToggle(
                    isPatient: isPatient,
                    onChanged: (value) {
                      setState(() {
                        isPatient = value;
                      });
                    },
                  ),

                  const SizedBox(height: 18),

                  /// Account
                  _sectionTitle('Account'),
                  const SizedBox(height: 12),
                  _buildAccountSection(),
                  const SizedBox(height: 24),

                  /// Preferences
                  _sectionTitle('Preferences'),
                  const SizedBox(height: 12),
                  _buildPreferencesSection(),
                  const SizedBox(height: 24),

                  /// My Records
                  _sectionTitle('My Records'),
                  const SizedBox(height: 12),
                  _buildMyRecordsSection(),
                  const SizedBox(height: 24),

                  /// Others
                  _sectionTitle('Others'),
                  const SizedBox(height: 12),
                  _buildOthersSection(),
                  const SizedBox(height: 24),

                  /// Log Out Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: CustomButton(
                        onPressed: () {
                          _showLogoutDialog();
                        },
                        text: 'Log Out'),
                  ),
                  const SizedBox(height: 40),
                ],
              );
            },
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

  Widget _buildPreferencesSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundGray.withOpacity(0.3),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          _menuItem(
            icon: Icons.description_outlined,
            title: 'Consultation Preference',
            onTap: () {
              context.goNextScreen(AppRoutes.consultationPreference);
            },
          ),
          const Divider(height: 1, indent: 56),
          _menuItem(
            icon: Icons.notifications_outlined,
            title: 'Notification Settings',
            onTap: () {
              context.goNextScreen(AppRoutes.notificationSettings);
            },
          ),
          const Divider(height: 1, indent: 56),
          _menuItemWithTrailing(
            icon: Icons.language,
            title: 'Language',
            trailing: 'English',
            onTap: () {
              context.goNextScreen(AppRoutes.languageSettings);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMyRecordsSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundGray.withOpacity(0.3),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          _menuItemWithSubtitle(
            icon: Icons.water_drop_outlined,
            iconColor: AppColors.red,
            title: 'Donation History',
            subtitle: 'View completed and missed donations',
            onTap: () {
              context.goNextScreen(AppRoutes.donationHistory);
            },
          ),
          const Divider(height: 1, indent: 56),
          _menuItemWithSubtitle(
            icon: Icons.calendar_today,
            iconColor: const Color(0xFF6366F1),
            title: 'Appointments',
            subtitle: 'All upcoming and past appointments',
            onTap: () {
              context.goNextScreen(AppRoutes.appointments);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOthersSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          _menuItem(
            icon: Icons.description_outlined,
            iconColor: const Color(0xFF6B7280),
            title: 'Terms & Conditions',
            onTap: () => UrlUtils.openTerms(context),
          ),
          const Divider(height: 1, indent: 56),
          _menuItem(
            icon: Icons.shield_outlined,
            iconColor: const Color(0xFF6B7280),
            title: 'Privacy Policy',
            onTap: () => UrlUtils.openPrivacyPolicy(context),
          ),
          const Divider(height: 1, indent: 56),
          _menuItem(
            icon: Icons.chat_bubble_outline,
            iconColor: AppColors.green,
            title: 'Contact Support',
            onTap: () {
              context.goNextScreen(AppRoutes.contactSupport);
            },
          ),
          const Divider(height: 1, indent: 56),
          _menuItem(
            iconColor: AppColors.red,
            titleColor: AppColors.red,
            icon: Icons.lock_outline,
            title:
                'Delete Account', // TODO - implement the logic from privacySettings, move it here and delete that screen
            onTap: () {
              context.goNextScreen(AppRoutes.privacySettings);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          _menuItem(
            icon: Icons.person,
            iconColor: const Color(0xFF6B7280),
            title: 'Profile',
            onTap: () async {
              context.goNextScreen(AppRoutes.profilePatientAndDonor);
            },
          ),
          const Divider(height: 1, indent: 56),
          _menuItem(
            icon: Icons.wallet_outlined,
            iconColor: const Color(0xFF6B7280),
            title: 'Bank Account',
            onTap: () => SnackBarUtils.showInfo(
                context, "Bank account feature coming soon!"),
          ),
          const Divider(height: 1, indent: 56),
          _menuItem(
            icon: Icons.key_outlined,
            iconColor: const Color(0xFF6B7280),
            title: 'Change Password',
            onTap: () async {
              // Refresh token in background to ensure valid token for password change
              final authProvider =
                  Provider.of<AuthProvider>(context, listen: false);
              authProvider.refreshAccessToken();

              // Navigate immediately while token refresh happens in background
              context.goNextScreen(AppRoutes.changePassword);
            },
          ),
          const Divider(height: 1, indent: 56),
          _menuItem(
            icon: Icons.shield_outlined,
            iconColor: const Color(0xFF6B7280),
            title: 'Referrals',
            onTap: () => context.push(AppRoutes.referralWallet),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textGray,
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _menuItem({
    required IconData icon,
    Color? iconColor,
    Color? titleColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading:
          Icon(icon, color: iconColor ?? const Color(0xFF6B7280), size: 22),
      title: CustomText(
          text: title,
          color: titleColor == null ? AppColors.textPrimary : titleColor,
          size: 14),
      trailing: const Icon(Icons.chevron_right, color: Color(0xFF9CA3AF)),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  Widget _menuItemWithSubtitle({
    required IconData icon,
    Color? iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading:
          Icon(icon, color: iconColor ?? const Color(0xFF6B7280), size: 22),
      title: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
      ),
      trailing: const Icon(Icons.chevron_right, color: Color(0xFF9CA3AF)),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  Widget _menuItemWithTrailing({
    required IconData icon,
    required String title,
    required String trailing,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF6B7280), size: 22),
      title: CustomText(text: title, size: 14),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            trailing,
            style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right, color: Color(0xFF9CA3AF)),
        ],
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}

class RoleToggle extends StatelessWidget {
  final bool isPatient;
  final ValueChanged<bool> onChanged;

  const RoleToggle({
    super.key,
    required this.isPatient,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: _item(
              title: 'PATIENT',
              selected: isPatient,
              onTap: () => onChanged(true),
            ),
          ),
          Expanded(
            child: _item(
              title: 'DONOR',
              selected: !isPatient,
              onTap: () => onChanged(false),
            ),
          ),
        ],
      ),
    );
  }

  Widget _item({
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.red : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : const Color(0xFF9CA3AF),
            ),
          ),
        ),
      ),
    );
  }
}

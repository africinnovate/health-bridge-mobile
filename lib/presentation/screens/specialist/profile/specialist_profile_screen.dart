import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/core/utils/snackbar_utils.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:HealthBridge/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/utils/dialog.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/specialist_provider.dart';

class SpecialistProfileScreen extends StatelessWidget {
  final bool? showBackArrow;
  const SpecialistProfileScreen({super.key, this.showBackArrow});

  @override
  Widget build(BuildContext context) {
    return Consumer<SpecialistProvider>(
      builder: (context, specialistProvider, child) {
        final profile = specialistProvider.specialistProfileM;

        return Scaffold(
          backgroundColor: const Color(0xFFF9FAFB),
          appBar: CustomAppBar(
            title: "My Profile",
            showArrow: showBackArrow ?? false,
          ),
          body: profile == null
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _profileHeader(profile),
                      const SizedBox(height: 16),
                      _personalInformation(context, profile),
                      const SizedBox(height: 16),
                      _professionalInformation(context, profile),
                      const SizedBox(height: 16),
                      _consultationTypes(context, profile),
                      const SizedBox(height: 16),
                      _schedule(context, profile),
                      const SizedBox(height: 16),
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

  /// ---------------- Header ----------------
  Widget _profileHeader(profile) {
    final fullName = profile.firstName.isNotEmpty || profile.lastName.isNotEmpty
        ? '${profile.firstName} ${profile.lastName}'.trim()
        : profile.email;

    return _card(
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 52,
                backgroundImage: profile.imageUrl != null
                    ? NetworkImage(profile.imageUrl!)
                    : const AssetImage('assets/images/patient.png')
                        as ImageProvider,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFD32F2F),
                  ),
                  child: const Icon(Icons.camera_alt,
                      size: 16, color: Colors.white),
                ),
              )
            ],
          ),
          const SizedBox(height: 12),
          Text(
            fullName,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFE7F7EC),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Specialist',
              style: TextStyle(color: AppColors.green, fontSize: 12),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                profile.verified ? Icons.verified : Icons.pending,
                size: 16,
                color: profile.verified ? Colors.green : Colors.orange,
              ),
              const SizedBox(width: 4),
              Text(
                profile.verified ? 'Verified' : 'Pending Verification',
                style: TextStyle(
                  fontSize: 12,
                  color: profile.verified ? Colors.green : Colors.orange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ---------------- Personal Info ----------------
  Widget _personalInformation(BuildContext context, profile) {
    return _infoSection(
      title: 'Personal Information',
      onEdit: () {
        context.goNextScreen(AppRoutes.editPersonalSpecialist);
      },
      children: [
        _InfoRow(Icons.email, 'Email Address', profile.email),
        _InfoRow(Icons.call, 'Phone Number',
            profile.primaryPhone ?? profile.phone ?? 'Not provided'),
        if (profile.secondaryPhone != null)
          _InfoRow(Icons.call, 'Secondary Phone', profile.secondaryPhone!),
        _InfoRow(Icons.public, 'Country', profile.country ?? 'Not provided'),
        if (profile.gender != null)
          _InfoRow(Icons.person, 'Gender',
              profile.gender!.capitalizeFirst() ?? 'Not provided'),
      ],
    );
  }

  /// ---------------- Professional Info ----------------
  Widget _professionalInformation(BuildContext context, profile) {
    // Get specialty name from provider
    final specialistProvider =
        Provider.of<SpecialistProvider>(context, listen: false);
    String specialtyName = 'Not specified';

    if (profile.specialtyId != null) {
      try {
        final specialty = specialistProvider.specialties.firstWhere(
          (s) => s.id == profile.specialtyId,
        );
        specialtyName = specialty.name;
      } catch (e) {
        specialtyName = 'Unknown specialty';
      }
    }

    return _infoSection(
      title: 'Professional Information',
      onEdit: () {
        context.goNextScreenWithData(
          AppRoutes.setProfileSpecialist,
          extra: true, // isUpdateMode = true
        );
      },
      children: [
        _InfoRow(Icons.medical_services, 'Specialty', specialtyName),
        _InfoRow(Icons.work, 'Years of Experience',
            '${profile.yearsOfExperience ?? 0} years'),
        _InfoRow(
          Icons.article,
          'Bio',
          profile.bio ?? 'No bio provided',
        ),
        if (profile.languagesSpoken != null)
          _InfoRow(
              Icons.language, 'Languages Spoken', profile.languagesSpoken!),
      ],
    );
  }

  /// ---------------- Consultation ----------------
  Widget _consultationTypes(BuildContext context, profile) {
    // Format consultation type
    String consultationType = profile.consultationType
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');

    return _infoSection(
      title: 'Consultation Types',
      onEdit: () {
        context.goNextScreenWithData(
          AppRoutes.availabilitySpecialist,
          extra: true, // isUpdateMode = true
        );
      },
      children: [
        _ChipRow('Modes', [consultationType]),
        _InfoRow(Icons.access_time, 'Session Duration',
            '${profile.sessionDurationMinutes ?? 0} minutes'),
        if (profile.timeZone != null)
          _InfoRow(Icons.schedule, 'Time Zone', profile.timeZone!),
      ],
    );
  }

  /// ---------------- Schedule ----------------
  Widget _schedule(BuildContext context, profile) {
    return _infoSection(
      title: 'My Schedule',
      onEdit: () {
        context.goNextScreenWithData(
          AppRoutes.availabilitySpecialist,
          extra: true, // isUpdateMode = true
        );
      },
      children: [
        if (profile.availability.isNotEmpty)
          ...profile.availability.map(
            (avail) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                '${avail.dayOfWeek}: ${avail.opensAt} - ${avail.closesAt}',
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          )
        else
          const Text(
            'No availability set',
            style: TextStyle(color: Colors.grey),
          ),
      ],
    );
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
          _accountTile(Icons.description, 'Terms & Conditions'),
          _accountTile(Icons.language, 'Language', trailing: 'English'),
          _accountTile(Icons.privacy_tip, 'Privacy Policy'),
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

  Widget _infoSection({
    required String title,
    required List<Widget> children,
    required VoidCallback onEdit,
  }) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600)),
              TextButton(onPressed: onEdit, child: const Text('Edit')),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
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

/// ---------------- Reusable Rows ----------------

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow(this.icon, this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChipRow extends StatelessWidget {
  final String label;
  final List<String> values;

  const _ChipRow(this.label, this.values);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: values
            .map(
              (e) => Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  e,
                  style: const TextStyle(color: Colors.blue, fontSize: 12),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

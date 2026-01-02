import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/core/utils/snackbar_utils.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:HealthBridge/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/utils/dialog.dart';

class SpecialistProfileScreen extends StatelessWidget {
  final bool? showBackArrow;
  const SpecialistProfileScreen({super.key, required this.showBackArrow});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: CustomAppBar(
        title: "My Profile",
        showArrow: showBackArrow ?? false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _profileHeader(),
            const SizedBox(height: 16),
            _personalInformation(context),
            const SizedBox(height: 16),
            _professionalInformation(context),
            const SizedBox(height: 16),
            _consultationTypes(),
            const SizedBox(height: 16),
            _schedule(),
            const SizedBox(height: 16),
            _accountSection(),
            const SizedBox(height: 24),
            CustomButton(onPressed: () => logout(context), text: "Log Out"),
            const SizedBox(height: 80),
          ],
        ),
      ),
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
        SnackBarUtils.showInfo(context, "In progress");
      },
    );
  }

  /// ---------------- Header ----------------
  Widget _profileHeader() {
    return _card(
      child: Column(
        children: [
          Stack(
            children: [
              const CircleAvatar(
                radius: 52,
                backgroundImage: AssetImage('assets/images/patient.png'),
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
          const Text(
            'Dr. Sarah Okonkwo',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFE7F7EC),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Cardiology',
              style: TextStyle(color: AppColors.green, fontSize: 12),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            '⭐ 4.5 • 238 reviews',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  /// ---------------- Personal Info ----------------
  Widget _personalInformation(BuildContext context) {
    return _infoSection(
      title: 'Personal Information',
      onEdit: () {
        context.goNextScreen(AppRoutes.editPersonalSpecialist);
      },
      children: const [
        _InfoRow(Icons.email, 'Email Address', 'Sarahoknkwo@gmail.com'),
        _InfoRow(Icons.call, 'Phone Number', '+2348023476400'),
        _InfoRow(Icons.location_on, 'Address',
            '123 Medical Center Drive, Lagos Island,\nLagos State, Nigeria'),
        _InfoRow(Icons.warning, 'Emergency Hotline', '+2348023476400'),
        _InfoRow(Icons.public, 'Country', 'Nigeria'),
      ],
    );
  }

  /// ---------------- Professional Info ----------------
  Widget _professionalInformation(BuildContext context) {
    return _infoSection(
      title: 'Professional Information',
      onEdit: () {
        SnackBarUtils.showInfo(context, "In progress");
      },
      children: const [
        _ChipRow('Specialties', ['Cardiology']),
        _InfoRow(Icons.work, 'Years of Experience', '12+ years'),
        _InfoRow(
          Icons.article,
          'Bio',
          'Board-certified cardiologist with extensive experience in preventive cardiology and heart disease management. '
              'Committed to providing patient-centered care with a focus on evidence-based treatment.',
        ),
      ],
    );
  }

  /// ---------------- Consultation ----------------
  Widget _consultationTypes() {
    return _infoSection(
      title: 'Consultation Types',
      onEdit: () {},
      children: const [
        _ChipRow('Modes', ['Video Call', 'Voice Call', 'In Person']),
        _InfoRow(Icons.location_on, 'In-Person Location',
            'Lagos University Teaching Hospital'),
      ],
    );
  }

  /// ---------------- Schedule ----------------
  Widget _schedule() {
    return _infoSection(
      title: 'My Schedule',
      onEdit: () {},
      children: const [
        Text(
          'Monday - Friday: 9:00 AM - 5:00 PM\nSaturday: 10:00 AM - 2:00 PM',
          style: TextStyle(color: Colors.grey),
        )
      ],
    );
  }

  /// ---------------- Account ----------------
  Widget _accountSection() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Account',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          _accountTile(Icons.lock, 'Change Password'),
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

  Widget _accountTile(IconData icon, String title, {String? trailing}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.grey),
      title: Text(title),
      trailing: trailing != null
          ? Text(trailing, style: const TextStyle(color: Colors.grey))
          : const Icon(Icons.chevron_right),
      onTap: () {},
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

import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/constants/app_routes.dart';
import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/core/utils/snackbar_utils.dart';
import 'package:HealthBridge/presentation/widgets/custom_button.dart';
import 'package:HealthBridge/presentation/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class GeneralProfileScreen extends StatefulWidget {
  const GeneralProfileScreen({super.key});

  @override
  State<GeneralProfileScreen> createState() => _GeneralProfileScreenState();
}

class _GeneralProfileScreenState extends State<GeneralProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              /// Title
              const Text(
                'My Profile',
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
              const SizedBox(height: 24),

              /// Profile Card
              _buildProfileCard(),
              const SizedBox(height: 24),

              /// Personal Information
              _sectionTitle('Personal Information'),
              const SizedBox(height: 12),
              _buildPersonalInfoSection(),
              const SizedBox(height: 5),
              _editMedButton(() {
                context.goNextScreen(AppRoutes.editPersonalInfoDonor);
              }),
              const SizedBox(height: 24),

              /// Medical Information
              _sectionTitle('Medical Information'),
              const SizedBox(height: 12),
              _buildMedicalInfoSection(),
              const SizedBox(height: 5),
              _editMedButton(() {
                context.goNextScreen(AppRoutes.editMedicalInfoDonor);
              }),
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

              /// Support & Help
              _sectionTitle('Support & Help'),
              const SizedBox(height: 12),
              _buildSupportSection(),
              const SizedBox(height: 24),

              /// Account
              _sectionTitle('Account'),
              const SizedBox(height: 12),
              _buildAccountSection(),
              const SizedBox(height: 24),

              /// Log Out Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: CustomButton(
                    onPressed: () {
                      SnackBarUtils.showInfo(context, "in progress");
                    },
                    text: 'Log Out'),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.backgroundGray,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.facebook.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          /// Profile Image
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.red,
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/images/patient.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.red,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          /// Name
          const Text(
            'Chisom Emmanuel',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),

          /// Phone
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.phone, size: 16, color: Color(0xFF6B7280)),
              SizedBox(width: 6),
              Text(
                '+234 803 456 7890',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          /// Email
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.email_outlined, size: 16, color: Color(0xFF6B7280)),
              SizedBox(width: 6),
              Text(
                'chisomchukwukwe@gmail.com',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          /// Edit Profile Button
          OutlinedButton.icon(
            onPressed: () {
              context.goNextScreen(AppRoutes.editProfileDonor);
            },
            icon: const Icon(Icons.edit_outlined, size: 16),
            label: const Text('Edit Profile'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF6B7280),
              side: const BorderSide(color: Color(0xFFD1D5DB)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.backgroundGray.withOpacity(0.5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          _infoRow('Full Name', 'Chisom Emmanuel'),
          const Divider(height: 24),
          _infoRow('Date of Birth', '12 March 1995'),
          const Divider(height: 24),
          _infoRow('Gender', 'Male'),
          const Divider(height: 24),
          _infoRow('Blood Type', 'O+'),
          const Divider(height: 24),
          _infoRow('Address', 'Lagos, Nigeria'),
          // const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildMedicalInfoSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.backgroundGray.withOpacity(0.5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          _infoRow('Allergies', 'Penicillin, Peanuts'),
          const Divider(height: 24),
          _infoRow('Existing Conditions', 'Hypertension'),
          const Divider(height: 24),
          _infoRow('Medications', 'Lisinopril 10mg'),
          const Divider(height: 24),
          _infoRow('Primary Physician', 'Dr. Sarah Okonkwo'),
        ],
      ),
    );
  }

  Widget _editMedButton(VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: AppColors.backgroundGray, // your background
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'Edit',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
          ),
        ),
      ),
    );
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
          const Divider(height: 1, indent: 56),
          _menuItem(
            icon: Icons.lock_outline,
            title: 'Privacy Settings',
            onTap: () {
              context.goNextScreen(AppRoutes.privacySettings);
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

  Widget _buildSupportSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          _menuItem(
            icon: Icons.help_outline,
            iconColor: AppColors.green,
            title: 'Help Center',
            onTap: () {
              context.goNextScreen(AppRoutes.helpCenter);
            },
          ),
          const Divider(height: 1, indent: 56),
          _menuItem(
            icon: Icons.quiz_outlined,
            iconColor: AppColors.green,
            title: 'FAQs',
            onTap: () {
              context.goNextScreen(AppRoutes.faqs);
            },
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
            icon: Icons.key_outlined,
            iconColor: const Color(0xFF6B7280),
            title: 'Change Password',
            onTap: () {
              context.goNextScreen(AppRoutes.changePassword);
            },
          ),
          const Divider(height: 1, indent: 56),
          _menuItem(
            icon: Icons.link,
            iconColor: const Color(0xFF6B7280),
            title: 'Linked Accounts',
            onTap: () {
              context.goNextScreen(AppRoutes.linkedAccounts);
            },
          ),
          const Divider(height: 1, indent: 56),
          _menuItem(
            icon: Icons.description_outlined,
            iconColor: const Color(0xFF6B7280),
            title: 'Terms & Conditions',
            onTap: () {},
          ),
          const Divider(height: 1, indent: 56),
          _menuItem(
            icon: Icons.shield_outlined,
            iconColor: const Color(0xFF6B7280),
            title: 'Privacy Policy',
            onTap: () {},
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
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textGray,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _menuItem({
    required IconData icon,
    Color? iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading:
          Icon(icon, color: iconColor ?? const Color(0xFF6B7280), size: 22),
      title: CustomText(text: title, color: AppColors.textPrimary, size: 14),
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

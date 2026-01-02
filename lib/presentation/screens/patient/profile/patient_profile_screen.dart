import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/constants/app_routes.dart';
import 'package:HealthBridge/core/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PatientProfileScreen extends StatefulWidget {
  const PatientProfileScreen({super.key});

  @override
  State<PatientProfileScreen> createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'My Profile',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Manage your personal information, preferences, and account settings',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              /// Profile Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/images/patient.png'),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Chisom Emenuel',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.phone, size: 14, color: Color(0xFF9CA3AF)),
                          SizedBox(width: 6),
                          Text(
                            '+234 803 456 7890',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.email, size: 14, color: Color(0xFF9CA3AF)),
                          SizedBox(width: 6),
                          Text(
                            'chisom@healthbridge.com',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          context.push(AppRoutes.editProfilePatient);
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: AppColors.backgroundGray,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Edit Profile',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF374151),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              /// Personal Information
              _sectionHeader('Personal Information'),
              _menuItem(
                icon: Icons.person_outline,
                title: 'Full Name',
                subtitle: 'Chisom Emenuel',
                onTap: () {
                  context.push(AppRoutes.personalInfoPatient);
                },
              ),
              _menuItem(
                icon: Icons.calendar_today,
                title: 'Date of Birth',
                subtitle: 'January 15, 1995',
                onTap: () {
                  context.push(AppRoutes.personalInfoPatient);
                },
              ),
              _menuItem(
                icon: Icons.wc,
                title: 'Gender',
                subtitle: 'Male',
                onTap: () {
                  context.push(AppRoutes.personalInfoPatient);
                },
              ),
              _menuItem(
                icon: Icons.bloodtype,
                title: 'Blood Type',
                subtitle: 'O+',
                onTap: () {
                  context.push(AppRoutes.personalInfoPatient);
                },
              ),
              _menuItem(
                icon: Icons.location_on,
                title: 'Address',
                subtitle: 'Lagos, Nigeria',
                onTap: () {
                  context.push(AppRoutes.personalInfoPatient);
                },
              ),
              const SizedBox(height: 8),

              /// Medical Information
              _sectionHeader('Medical Information'),
              _menuItem(
                icon: Icons.medical_services_outlined,
                title: 'Allergies',
                subtitle: 'Peanuts, Penicillin',
                onTap: () {
                  context.push(AppRoutes.medicalInfoPatient);
                },
              ),
              _menuItem(
                icon: Icons.healing,
                title: 'Existing Conditions',
                subtitle: 'Hypertension',
                onTap: () {
                  context.push(AppRoutes.medicalInfoPatient);
                },
              ),
              _menuItem(
                icon: Icons.history,
                title: 'Medications',
                subtitle: 'Lisinopril 10mg',
                onTap: () {
                  context.push(AppRoutes.medicalInfoPatient);
                },
              ),
              _menuItem(
                icon: Icons.local_hospital,
                title: 'Primary Physician',
                subtitle: 'Dr. Sarah Okonkwo',
                onTap: () {
                  context.push(AppRoutes.medicalInfoPatient);
                },
              ),
              const SizedBox(height: 8),

              /// Preferences
              _sectionHeader('Preferences'),
              _menuItem(
                icon: Icons.videocam_outlined,
                title: 'Consultation Preference',
                subtitle: 'Video Call',
                onTap: () {
                  context.push(AppRoutes.consultationPreferencePatient);
                },
              ),
              _menuItem(
                icon: Icons.notifications_outlined,
                title: 'Notification Settings',
                subtitle: '',
                onTap: () {
                  context.push(AppRoutes.notificationSettings);
                },
              ),
              _menuItem(
                icon: Icons.language,
                title: 'Language',
                subtitle: 'English',
                onTap: () {
                  context.push(AppRoutes.languageSettings);
                },
              ),
              _menuItem(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy Settings',
                subtitle: '',
                onTap: () {
                  context.push(AppRoutes.privacySettings);
                },
              ),
              const SizedBox(height: 8),

              /// Records
              _sectionHeader('My Records'),
              _menuItem(
                icon: Icons.history,
                title: 'Care History',
                subtitle: 'View all previous consultations',
                onTap: () {
                  context.push(AppRoutes.careHistory);
                },
              ),
              _menuItem(
                icon: Icons.calendar_today_outlined,
                title: 'Appointment History',
                subtitle: 'View past appointments',
                onTap: () {
                  SnackBarUtils.showInfo(context, "Appointment History");
                },
              ),
              const SizedBox(height: 8),

              /// Support & Help
              _sectionHeader('Support & Help'),
              _menuItem(
                icon: Icons.help_outline,
                title: 'Help Center',
                subtitle: '',
                onTap: () {
                  context.push(AppRoutes.helpCenter);
                },
              ),
              _menuItem(
                icon: Icons.quiz_outlined,
                title: 'FAQs',
                subtitle: '',
                onTap: () {
                  context.push(AppRoutes.faqs);
                },
              ),
              _menuItem(
                icon: Icons.support_agent,
                title: 'Contact Support',
                subtitle: '',
                onTap: () {
                  context.push(AppRoutes.contactSupport);
                },
              ),
              const SizedBox(height: 8),

              /// Account
              _sectionHeader('Account'),
              _menuItem(
                icon: Icons.lock_outline,
                title: 'Change Password',
                subtitle: '',
                onTap: () {
                  context.push(AppRoutes.changePassword);
                },
              ),
              _menuItem(
                icon: Icons.link,
                title: 'Linked Accounts',
                subtitle: '',
                onTap: () {
                  context.push(AppRoutes.linkedAccounts);
                },
              ),
              _menuItem(
                icon: Icons.policy_outlined,
                title: 'Privacy Policy',
                subtitle: '',
                onTap: () {
                  SnackBarUtils.showInfo(context, "Privacy Policy");
                },
              ),
              const SizedBox(height: 32),

              /// Log Out Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  onTap: () {
                    _showLogoutDialog();
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: AppColors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Log Out',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF6B7280),
        ),
      ),
    );
  }

  Widget _menuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 20, color: const Color(0xFF6B7280)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF9CA3AF), size: 20),
          ],
        ),
      ),
    );
  }

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
            onPressed: () {
              Navigator.pop(context);
              SnackBarUtils.showInfo(context, "Logged out successfully");
            },
            child: const Text(
              'Log Out',
              style: TextStyle(color: AppColors.red, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

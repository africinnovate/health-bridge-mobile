import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/utils/snackbar_utils.dart';
import 'package:HealthBridge/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class HospitalProfileScreen extends StatefulWidget {
  const HospitalProfileScreen({super.key});

  @override
  State<HospitalProfileScreen> createState() => _HospitalProfileScreenState();
}

class _HospitalProfileScreenState extends State<HospitalProfileScreen> {
  // Sample blood types data
  final List<Map<String, dynamic>> bloodTypes = [
    {'type': 'A+', 'color': AppColors.red},
    {'type': 'A-', 'color': AppColors.red},
    {'type': 'B+', 'color': AppColors.green},
    {'type': 'B-', 'color': AppColors.green},
    {'type': 'O+', 'color': AppColors.aPlusAndABPlus},
    {'type': 'O-', 'color': AppColors.aPlusAndABPlus},
    {'type': 'AB+', 'color': const Color(0xFF3B82F6)},
    {'type': 'AB-', 'color': const Color(0xFF3B82F6)},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              /// Title
              const Text(
                'Hospital Profile',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              /// Hospital Image & Name
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: const DecorationImage(
                              image: AssetImage('assets/images/patient.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 5,
                          right: 5,
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: AppColors.red,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(
                              Icons.local_hospital,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'City General Hospital',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'General Hospital',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Verified',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              /// Contact Information

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Contact Information',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _infoRow(
                      Icons.location_on_outlined,
                      'Address',
                      '123 Medical Center Drive, Lagos Island, Lagos State, Nigeria',
                    ),
                    const SizedBox(height: 16),
                    _infoRow(
                      Icons.phone_outlined,
                      'Phone Number',
                      '+234802347​6400',
                    ),
                    const SizedBox(height: 16),
                    _infoRow(
                      Icons.email_outlined,
                      'Email Address',
                      'Sarahoknkwo@gmail.com',
                    ),
                    const SizedBox(height: 16),
                    _infoRow(
                      Icons.emergency_outlined,
                      'Emergency Hotline',
                      '+234802347​6400',
                    ),
                    const SizedBox(height: 20),
                    _editButton(),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              /// License Information
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'License Information',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _infoRow(
                      Icons.description_outlined,
                      'Registration Number',
                      'HF-LG-2019-08421',
                    ),
                    const SizedBox(height: 16),
                    _statusRow(
                      Icons.verified_outlined,
                      'License Status',
                      'Active',
                    ),
                    const SizedBox(height: 16),
                    _documentRow(
                      Icons.insert_drive_file_outlined,
                      'License Document',
                      'View Document',
                    ),
                    const SizedBox(height: 20),
                    _editButton(),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              /// Blood Services
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Blood Services',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _statusRow(
                      Icons.description_outlined,
                      'Blood Bank Status',
                      'Active',
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.verified_outlined,
                          size: 20,
                          color: Color(0xFF6B7280),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Available Blood Types',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: bloodTypes.map((bloodType) {
                                  return _bloodTypeBadge(
                                    bloodType['type'] as String,
                                    bloodType['color'] as Color,
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _infoRow(
                      Icons.access_time_outlined,
                      'Donation Hours',
                      'Monday - Friday: 8:00 AM - 5:00 PM',
                    ),
                    const SizedBox(height: 20),
                    _editServicesButton(),
                  ],
                ),
              ),
              const SizedBox(height: 24),

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
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    _menuItem(
                      Icons.lock_outline,
                      'Change Password',
                      Icons.chevron_right,
                      () {
                        SnackBarUtils.showInfo(context, "Change password");
                      },
                    ),
                    const Divider(height: 1),
                    _menuItem(
                      Icons.description_outlined,
                      'Terms & Conditions',
                      Icons.chevron_right,
                      () {
                        SnackBarUtils.showInfo(context, "Terms & Conditions");
                      },
                    ),
                    const Divider(height: 1),
                    _menuItem(
                      Icons.shield_outlined,
                      'Privacy Policy',
                      Icons.chevron_right,
                      () {
                        SnackBarUtils.showInfo(context, "Privacy Policy");
                      },
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
                  onPressed: () {
                    SnackBarUtils.showInfo(context, "Logout");
                  },
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
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF111827),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _statusRow(IconData icon, String label, String status) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: const Color(0xFF6B7280)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                status,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.green,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _documentRow(IconData icon, String label, String linkText) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: const Color(0xFF6B7280)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: () {
                  SnackBarUtils.showInfo(context, "View document");
                },
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
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          type,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _editButton() {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () {
          SnackBarUtils.showInfo(context, "Edit");
        },
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
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _editServicesButton() {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () {
          SnackBarUtils.showInfo(context, "Edit services");
        },
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
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _menuItem(IconData leadingIcon, String title, IconData trailingIcon,
      VoidCallback onTap) {
    return ListTile(
      leading: Icon(leadingIcon, color: const Color(0xFF6B7280), size: 22),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF111827),
        ),
      ),
      trailing: Icon(trailingIcon, color: const Color(0xFF9CA3AF), size: 20),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }
}

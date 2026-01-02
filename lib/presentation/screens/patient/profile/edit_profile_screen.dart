import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/utils/snackbar_utils.dart';
import 'package:HealthBridge/presentation/widgets/cancel_button.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:HealthBridge/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class EditProfilePatientScreen extends StatefulWidget {
  const EditProfilePatientScreen({super.key});

  @override
  State<EditProfilePatientScreen> createState() =>
      _EditProfilePatientScreenState();
}

class _EditProfilePatientScreenState extends State<EditProfilePatientScreen> {
  final TextEditingController _fullNameController =
      TextEditingController(text: 'Chisom Emenuel');
  final TextEditingController _phoneController =
      TextEditingController(text: '+234 803 456 7890');
  final TextEditingController _emailController =
      TextEditingController(text: 'chisom@healthbridge.com');

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      appBar: const CustomAppBar(title: 'Edit Profile'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Profile Photo
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundImage:
                                AssetImage('assets/images/patient.png'),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                _showPhotoOptions();
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: AppColors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          SnackBarUtils.showInfo(context, "Remove photo");
                        },
                        child: const Text(
                          'Remove Photo',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    /// Full Name
                    const Text(
                      'Full Name',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: TextField(
                        controller: _fullNameController,
                        decoration: const InputDecoration(
                          hintText: 'Enter full name',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                          prefixIcon:
                              Icon(Icons.person_outline, color: Color(0xFF9CA3AF)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    /// Phone Number
                    const Text(
                      'Phone Number',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          hintText: 'Enter phone number',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                          prefixIcon:
                              Icon(Icons.phone_outlined, color: Color(0xFF9CA3AF)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    /// Email
                    const Text(
                      'Email address',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: 'Enter email address',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                          prefixIcon:
                              Icon(Icons.email_outlined, color: Color(0xFF9CA3AF)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'We\'ll send a confirmation code to this email',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// Bottom Buttons
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  CustomButton(
                    onPressed: () {
                      SnackBarUtils.showInfo(context, "Profile updated");
                      Navigator.pop(context);
                    },
                    text: 'Save Changes',
                  ),
                  const SizedBox(height: 12),
                  CancelButton(
                    text: 'Cancel',
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppColors.red),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                SnackBarUtils.showInfo(context, "Camera opened");
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: AppColors.red),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                SnackBarUtils.showInfo(context, "Gallery opened");
              },
            ),
          ],
        ),
      ),
    );
  }
}

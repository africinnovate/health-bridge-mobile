import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/presentation/widgets/cancel_button.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:HealthBridge/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _fullNameController = TextEditingController(text: 'Chison Emmanuel');
  final _phoneController = TextEditingController(text: '+234 803 456 7830');
  final _emailController = TextEditingController(text: 'chison.e@email.com');

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
      appBar: const CustomAppBar(
        title: 'Edit Profile',
        showArrow: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// Profile Photo
            Stack(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.red,
                    shape: BoxShape.circle,
                    image: const DecorationImage(
                      image: AssetImage('assets/images/patient.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 36,
                    height: 36,
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
              ],
            ),
            const SizedBox(height: 12),

            /// Change Photo
            TextButton(
              onPressed: () {
                // Handle change photo
              },
              child: const Text(
                'Change Photo',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.red,
                ),
              ),
            ),

            /// Remove Photo
            TextButton(
              onPressed: () {
                // Handle remove photo
              },
              child: const Text(
                'Remove Photo',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.red,
                ),
              ),
            ),
            const SizedBox(height: 24),

            /// Full Name
            _buildTextField(
              label: 'Full Name',
              controller: _fullNameController,
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 20),

            /// Phone Number
            _buildTextField(
              label: 'Phone Number',
              controller: _phoneController,
              icon: Icons.phone_outlined,
            ),
            const SizedBox(height: 20),

            /// Email Address
            _buildTextField(
              label: 'Email Address',
              controller: _emailController,
              icon: Icons.email_outlined,
            ),
            const SizedBox(height: 8),

            /// Helper text
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'We\'ll send important updates here',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF9CA3AF),
                ),
              ),
            ),
            const SizedBox(height: 32),

            /// Save Button
            CustomButton(
              onPressed: () {
                // Handle save changes
                context.goBack();
              },
              text: 'Save Changes',
            ),
            const SizedBox(height: 12),

            /// Cancel Button
            CancelButton(
              text: 'Cancel',
              onPressed: () {
                context.goBack();
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: TextField(
            controller: controller,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              icon: Icon(
                icon,
                color: const Color(0xFF9CA3AF),
                size: 20,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ],
    );
  }
}

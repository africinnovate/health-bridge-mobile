import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/presentation/widgets/cancel_button.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:HealthBridge/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class ConsultationPreferenceScreen extends StatefulWidget {
  const ConsultationPreferenceScreen({super.key});

  @override
  State<ConsultationPreferenceScreen> createState() =>
      _ConsultationPreferenceScreenState();
}

class _ConsultationPreferenceScreenState
    extends State<ConsultationPreferenceScreen> {
  String selectedPreference = 'video';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      appBar: const CustomAppBar(
        title: 'Consultation Preference',
        showArrow: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Subtitle
            const Text(
              'Choose your preferred consultation method. You can always change this later.',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 24),

            /// Info Box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFBFDBFE)),
              ),
              child: const Text(
                'Your specialist may offer both options. This is your default preference.',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF1E40AF),
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 24),

            /// Video Call Option
            _consultationOption(
              value: 'video',
              icon: Icons.videocam,
              iconColor: AppColors.green,
              title: 'Video Call',
              description: 'See your doctor face-to-face with video consultations',
            ),
            const SizedBox(height: 16),

            /// Voice Call Option
            _consultationOption(
              value: 'voice',
              icon: Icons.phone,
              iconColor: const Color(0xFF6B7280),
              title: 'Voice Call',
              description:
                  'Connect with your doctor through audio-only calls',
            ),
            const SizedBox(height: 16),

            /// In-Person Option
            _consultationOption(
              value: 'in-person',
              icon: Icons.person_pin_circle,
              iconColor: const Color(0xFF6B7280),
              title: 'In-Person',
              description:
                  'See your doctor face-to-face with physical consultations',
            ),
            const SizedBox(height: 32),

            /// Save Button
            CustomButton(
              onPressed: () {
                // Handle save preference
                context.goBack();
              },
              text: 'Save Preference',
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

  Widget _consultationOption({
    required String value,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
  }) {
    final isSelected = selectedPreference == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPreference = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.green.withOpacity(0.05)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.green : const Color(0xFFE5E7EB),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            /// Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.green.withOpacity(0.1)
                    : const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isSelected ? AppColors.green : iconColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),

            /// Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? AppColors.green
                          : const Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF6B7280),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            /// Radio Button
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.green : const Color(0xFFD1D5DB),
                  width: 2,
                ),
                color: isSelected ? AppColors.green : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(
                      Icons.circle,
                      size: 12,
                      color: Colors.white,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/utils/snackbar_utils.dart';
import 'package:HealthBridge/presentation/widgets/cancel_button.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:HealthBridge/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class ConsultationPreferencePatientScreen extends StatefulWidget {
  const ConsultationPreferencePatientScreen({super.key});

  @override
  State<ConsultationPreferencePatientScreen> createState() =>
      _ConsultationPreferencePatientScreenState();
}

class _ConsultationPreferencePatientScreenState
    extends State<ConsultationPreferencePatientScreen> {
  String selectedPreference = 'Video Call';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      appBar: const CustomAppBar(title: 'Consultation Preference'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Consultation Preference',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Your specialist may offer these options. This is your default preference.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _preferenceOption(
                      icon: Icons.videocam,
                      title: 'Video Call',
                      subtitle: 'Face-to-face video consultation',
                      value: 'Video Call',
                    ),
                    const SizedBox(height: 12),
                    _preferenceOption(
                      icon: Icons.call,
                      title: 'Voice Call',
                      subtitle: 'Audio-only consultation',
                      value: 'Voice Call',
                    ),
                    const SizedBox(height: 12),
                    _preferenceOption(
                      icon: Icons.location_on,
                      title: 'In Person',
                      subtitle: 'Visit the clinic in person',
                      value: 'In Person',
                    ),
                  ],
                ),
              ),
            ),
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
                      SnackBarUtils.showInfo(
                          context, "Consultation preference updated");
                      Navigator.pop(context);
                    },
                    text: 'Save Changes',
                  ),
                  const SizedBox(height: 12),
                  CancelButton(text: 'Cancel'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _preferenceOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
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
          color: isSelected ? const Color(0xFFDCFCE7) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.green : const Color(0xFFE5E7EB),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.green.withOpacity(0.1)
                    : const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 24,
                color: isSelected ? AppColors.green : const Color(0xFF6B7280),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? AppColors.green : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.green, size: 24),
          ],
        ),
      ),
    );
  }
}

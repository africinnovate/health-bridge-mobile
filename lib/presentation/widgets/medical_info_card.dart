import 'package:HealthBridge/core/constants/app_constants.dart';
import 'package:HealthBridge/core/constants/app_routes.dart';
import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/core/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';

class MedicalInfoCard extends StatelessWidget {
  const MedicalInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Medical Information',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 16),
              _InfoRow(
                icon: Icons.warning_amber_rounded,
                label: 'Allergies',
                value: 'Penicillin, Shellfish',
              ),
              SizedBox(height: 12),
              _InfoRow(
                icon: Icons.add_box_outlined,
                label: 'Existing Conditions',
                value: 'Hypertension',
              ),
              SizedBox(height: 12),
              _InfoRow(
                icon: Icons.monitor_heart_outlined,
                label: 'Medications',
                value: 'Lisinopril 10mg (Daily)',
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _primaryButton('Confirm Appointment', context),
        const SizedBox(height: 12),
        _secondaryButton('Re-Schedule Appointment', context),
      ],
    );
  }

  /// ---------------- Buttons ----------------
  static Widget _primaryButton(String text, BuildContext context) {
    return GestureDetector(
      onTap: () => SnackBarUtils.showInfo(context, "In progress"),
      child: Container(
        height: 52,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFF15803D),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  static Widget _secondaryButton(String text, BuildContext context) {
    return GestureDetector(
      onTap: () => context.goNextScreen(AppRoutes.rescheduleOnSpecialist),
      child: Container(
        height: 52,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFFDECEC),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

/// ------------------------------------------------
/// Reusable Info Row
/// ------------------------------------------------
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 22, color: Colors.grey),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

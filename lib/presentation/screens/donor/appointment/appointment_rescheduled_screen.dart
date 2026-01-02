import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/core/utils/dialog.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:HealthBridge/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_routes.dart';

class AppointmentRescheduledScreen extends StatelessWidget {
  const AppointmentRescheduledScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      appBar: const CustomAppBar(
        title: 'Appointment Rescheduled',
        showArrow: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Subtitle
            const Text(
              'Your appointment has been rescheduled. Compare the times below.',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),

            /// Previous Appointment Card
            _appointmentCard(
              icon: Icons.event_busy,
              iconColor: AppColors.red,
              label: 'Previous',
              badgeText: 'Cancelled',
              badgeColor: const Color(0xFFFEE2E2),
              badgeTextColor: AppColors.red,
              date: 'Tuesday, 11th March',
              time: '09:00 AM',
              timeColor: const Color(0xFF6B7280),
            ),
            const SizedBox(height: 16),

            /// New Appointment Card
            _appointmentCard(
              icon: Icons.event_available,
              iconColor: AppColors.green,
              label: 'New',
              badgeText: 'Proposed',
              badgeColor: const Color(0xFFDCFCE7),
              badgeTextColor: AppColors.green,
              date: 'Wednesday, 11th March',
              time: '09:00 AM',
              timeColor: AppColors.green,
            ),
            const SizedBox(height: 24),

            /// Details Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  _detailRow('Hospital:', 'Emmanuel General Hospital'),
                  const SizedBox(height: 12),
                  _detailRow('Service:', 'Blood Donation'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            /// Reason Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: const [
                  Icon(
                    Icons.info_outline,
                    color: Color(0xFF92400E),
                    size: 20,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Reason: Scheduling conflict',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF92400E),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            /// Action Buttons
            CustomButton(
              onPressed: () {
                showThankYouDialog(
                  context,
                  title: "New Time Confirmed",
                  message: "Your appointment has been updated successfully",
                  buttonText: "Done",
                  onContinue: context.goBack,
                );
              },
              text: 'Confirm New Time',
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: () {
                  context.goNextScreen(AppRoutes.bloodRequestBooking);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF6B7280),
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Color(0xFFE5E7EB)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Request Another Time',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _appointmentCard({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String badgeText,
    required Color badgeColor,
    required Color badgeTextColor,
    required String date,
    required String time,
    required Color timeColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    color: iconColor,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  badgeText,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: badgeTextColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            date,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            time,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: timeColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF6B7280),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

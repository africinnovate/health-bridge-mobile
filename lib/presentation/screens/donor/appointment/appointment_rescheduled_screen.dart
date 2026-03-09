import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/core/utils/dialog.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:HealthBridge/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../data/models/appointment/appointment_model.dart';

class AppointmentRescheduledScreen extends StatelessWidget {
  final AppointmentModel? oldAppointment;
  final AppointmentModel? newAppointment;

  const AppointmentRescheduledScreen({
    super.key,
    this.oldAppointment,
    this.newAppointment,
  });

  @override
  Widget build(BuildContext context) {
    if (oldAppointment == null || newAppointment == null) {
      return Scaffold(
        backgroundColor: AppColors.backgroundGray,
        appBar: const CustomAppBar(
          title: 'Appointment Rescheduled',
          showArrow: true,
        ),
        body: const Center(
          child: Text('No reschedule information available'),
        ),
      );
    }

    // Format old appointment date/time
    String oldDate = 'N/A';
    String oldTime = 'N/A';
    try {
      oldDate = DateFormat('EEEE, d MMMM').format(oldAppointment!.scheduledTime);
      oldTime = DateFormat('h:mm a').format(oldAppointment!.scheduledTime);
    } catch (e) {
      debugPrint('Error formatting old date: $e');
    }

    // Format new appointment date/time
    String newDate = 'N/A';
    String newTime = 'N/A';
    try {
      newDate = DateFormat('EEEE, d MMMM').format(newAppointment!.scheduledTime);
      newTime = DateFormat('h:mm a').format(newAppointment!.scheduledTime);
    } catch (e) {
      debugPrint('Error formatting new date: $e');
    }

    final appointmentType = oldAppointment!.specialistId.isNotEmpty
        ? 'Specialist Appointment'
        : 'Blood Donation';

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
              date: oldDate,
              time: oldTime,
              timeColor: const Color(0xFF6B7280),
            ),
            const SizedBox(height: 16),

            /// New Appointment Card
            _appointmentCard(
              icon: Icons.event_available,
              iconColor: AppColors.green,
              label: 'New',
              badgeText: 'Confirmed',
              badgeColor: const Color(0xFFDCFCE7),
              badgeTextColor: AppColors.green,
              date: newDate,
              time: newTime,
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
                  _detailRow('Hospital:', oldAppointment!.hospitalId),
                  const SizedBox(height: 12),
                  _detailRow('Service:', appointmentType),
                ],
              ),
            ),
            const SizedBox(height: 20),

            /// Success Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFDCFCE7),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: const [
                  Icon(
                    Icons.check_circle_outline,
                    color: AppColors.green,
                    size: 20,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Your appointment has been successfully rescheduled',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            /// Action Button
            CustomButton(
              onPressed: () {
                showThankYouDialog(
                  context,
                  title: "All Set!",
                  message: "Your appointment has been updated successfully",
                  buttonText: "Done",
                  onContinue: () {
                    context.goBack();
                    context.goBack();
                  },
                );
              },
              text: 'Done',
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

import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/constants/app_routes.dart';
import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:HealthBridge/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class DonorNotificationScreen extends StatelessWidget {
  const DonorNotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      appBar: const CustomAppBar(
        title: 'Notification',
        showArrow: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _notificationCard(
            icon: Icons.check,
            iconColor: AppColors.green,
            title: 'Appointment Confirmed',
            message:
                'The hospital has accepted your appointment request. Your date and time remain the same.',
            time: '10 mins ago',
            buttonText: 'View Appointment',
            onButtonPressed: () {
              context.goNextScreenWithData(AppRoutes.donorAppointmentDetail,
                  extra: "upcoming");
            },
          ),
          const SizedBox(height: 16),
          _notificationCard(
            icon: Icons.check,
            iconColor: AppColors.green,
            title: 'Appointment Confirmed',
            message:
                'The hospital has accepted your appointment request. Your date and time remain the same.',
            time: '10 mins ago',
            buttonText: 'View Appointment',
            onButtonPressed: () {
              context.goNextScreenWithData(AppRoutes.donorAppointmentDetail,
                  extra: "upcoming");
            },
          ),
          const SizedBox(height: 16),
          _notificationCard(
            icon: Icons.calendar_today,
            iconColor: AppColors.green,
            title: 'Appointment Rescheduled',
            message:
                'The hospital has picked a new time for your appointment. Please review and confirm the updated schedule.',
            time: '10 mins ago',
            buttonText: 'Review New Time',
            onButtonPressed: () {
              context.goNextScreen(AppRoutes.donorAppointmentRescheduled);
            },
          ),
          const SizedBox(height: 16),
          _notificationCard(
            icon: Icons.notifications,
            iconColor: AppColors.green,
            title: 'Blood Request Approved',
            message:
                'The hospital has accepted your request and is preparing the required blood units. We\'ll notify you once they\'re ready for pickup.',
            time: '10 mins ago',
          ),
          const SizedBox(height: 16),
          _notificationCard(
            icon: Icons.local_hospital,
            iconColor: AppColors.green,
            title: 'Blood Is Now Available',
            message:
                'A hospital has confirmed that the required blood units are available for your request.',
            time: '10 mins ago',
            buttonText: 'View Details',
            onButtonPressed: () {
              context.goNextScreenWithData(AppRoutes.donorAppointmentDetail,
                  extra: "upcoming");
            },
          ),
          const SizedBox(height: 16),
          _notificationCard(
            icon: Icons.notifications,
            iconColor: AppColors.green,
            title: 'Appointment Reminder',
            message:
                'You have an appointment tomorrow at 10:30 AM at City Hospital. Please arrive a few minutes early and bring any required documents.',
            time: '10 mins ago',
            buttonText: 'View Appointment',
            onButtonPressed: () {
              context.goNextScreenWithData(AppRoutes.donorAppointmentDetail,
                  extra: "upcoming");
            },
            badge: 'Blood Collection',
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _notificationCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String message,
    required String time,
    String? buttonText,
    VoidCallback? onButtonPressed,
    String? badge,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),

              /// Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (badge != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEE2E2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              badge,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppColors.red,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      message,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6B7280),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      time,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          /// Button (if provided)
          if (buttonText != null && onButtonPressed != null) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                onPressed: onButtonPressed,
                text: buttonText,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

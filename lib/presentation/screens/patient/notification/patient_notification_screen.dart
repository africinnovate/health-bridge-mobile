import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/utils/snackbar_utils.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class PatientNotificationScreen extends StatefulWidget {
  const PatientNotificationScreen({super.key});

  @override
  State<PatientNotificationScreen> createState() =>
      _PatientNotificationScreenState();
}

class _PatientNotificationScreenState
    extends State<PatientNotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      appBar: const CustomAppBar(title: 'Notifications'),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            /// Today Section
            const Text(
              'Today',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 12),
            _notificationCard(
              icon: Icons.calendar_today,
              iconColor: const Color(0xFF3B82F6),
              iconBg: const Color(0xFFEFF6FF),
              title: 'Appointment Reminder',
              message:
                  'You have an appointment with Dr. Chibundu at 14:00 PM today',
              time: '10 min ago',
              isUnread: true,
            ),
            const SizedBox(height: 12),
            _notificationCard(
              icon: Icons.videocam,
              iconColor: AppColors.green,
              iconBg: const Color(0xFFDCFCE7),
              title: 'Video Call Started',
              message: 'Dr. Adeyemi is waiting for you to join the consultation',
              time: '1 hour ago',
              isUnread: true,
            ),
            const SizedBox(height: 12),
            _notificationCard(
              icon: Icons.check_circle,
              iconColor: AppColors.green,
              iconBg: const Color(0xFFDCFCE7),
              title: 'Appointment Confirmed',
              message:
                  'Your appointment with Dr. Grace Eze has been confirmed for May 5th',
              time: '3 hours ago',
              isUnread: false,
            ),
            const SizedBox(height: 24),

            /// Yesterday Section
            const Text(
              'Yesterday',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 12),
            _notificationCard(
              icon: Icons.description,
              iconColor: const Color(0xFF8B5CF6),
              iconBg: const Color(0xFFF3E8FF),
              title: 'Prescription Ready',
              message: 'Your prescription from Dr. Oluwaseun is ready to download',
              time: 'Yesterday',
              isUnread: false,
            ),
            const SizedBox(height: 12),
            _notificationCard(
              icon: Icons.cancel,
              iconColor: AppColors.red,
              iconBg: const Color(0xFFFEE2E2),
              title: 'Appointment Cancelled',
              message: 'Dr. James Adekunle cancelled your appointment for May 2nd',
              time: 'Yesterday',
              isUnread: false,
            ),
            const SizedBox(height: 24),

            /// Earlier Section
            const Text(
              'Earlier',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 12),
            _notificationCard(
              icon: Icons.favorite,
              iconColor: AppColors.red,
              iconBg: const Color(0xFFFEE2E2),
              title: 'Blood Donation Reminder',
              message:
                  'You are eligible to donate blood. Book your appointment now',
              time: '3 days ago',
              isUnread: false,
            ),
            const SizedBox(height: 12),
            _notificationCard(
              icon: Icons.star,
              iconColor: const Color(0xFFFBBF24),
              iconBg: const Color(0xFFFEF3C7),
              title: 'Rate Your Experience',
              message:
                  'How was your consultation with Dr. Chinedu? Leave a review',
              time: '5 days ago',
              isUnread: false,
            ),
            const SizedBox(height: 12),
            _notificationCard(
              icon: Icons.notifications_active,
              iconColor: const Color(0xFF3B82F6),
              iconBg: const Color(0xFFEFF6FF),
              title: 'New Feature Available',
              message:
                  'You can now book in-person consultations with specialists',
              time: '1 week ago',
              isUnread: false,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _notificationCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String message,
    required String time,
    required bool isUnread,
  }) {
    return GestureDetector(
      onTap: () {
        SnackBarUtils.showInfo(context, "View notification");
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isUnread ? Colors.white : const Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isUnread
                ? const Color(0xFF3B82F6).withOpacity(0.2)
                : Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight:
                                isUnread ? FontWeight.w600 : FontWeight.w500,
                          ),
                        ),
                      ),
                      if (isUnread)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFF3B82F6),
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF6B7280),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    time,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

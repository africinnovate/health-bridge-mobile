import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool appointmentReminders = true;
  bool donationAlerts = true;
  bool accountNotifications = true;
  bool emailNotifications = true;
  bool smsNotifications = true;
  bool pushNotifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      appBar: const CustomAppBar(
        title: 'Notification Settings',
        showArrow: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Subtitle
            const Text(
              'Manage how and when you receive notifications',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 24),

            /// Notification Types
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  _notificationToggle(
                    icon: Icons.notifications,
                    iconColor: const Color(0xFF3B82F6),
                    iconBg: const Color(0xFFEFF6FF),
                    title: 'Appointment Reminders',
                    subtitle: 'Get notified before upcoming appointments',
                    value: appointmentReminders,
                    onChanged: (value) {
                      setState(() => appointmentReminders = value);
                    },
                  ),
                  const Divider(height: 1, indent: 72),
                  _notificationToggle(
                    icon: Icons.favorite,
                    iconColor: AppColors.red,
                    iconBg: const Color(0xFFFEE2E2),
                    title: 'Donation Alerts',
                    subtitle: 'Updates about blood donation opportunities',
                    value: donationAlerts,
                    onChanged: (value) {
                      setState(() => donationAlerts = value);
                    },
                  ),
                  const Divider(height: 1, indent: 72),
                  _notificationToggle(
                    icon: Icons.shield_outlined,
                    iconColor: const Color(0xFF6B7280),
                    iconBg: const Color(0xFFF3F4F6),
                    title: 'Account Notifications',
                    subtitle: 'Security and account-related updates',
                    value: accountNotifications,
                    onChanged: (value) {
                      setState(() => accountNotifications = value);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            /// Notification Methods
            const Text(
              'Notification Methods',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  _notificationToggle(
                    icon: Icons.email_outlined,
                    iconColor: const Color(0xFF3B82F6),
                    iconBg: const Color(0xFFEFF6FF),
                    title: 'Email Notifications',
                    subtitle: 'Receive updates via email',
                    value: emailNotifications,
                    onChanged: (value) {
                      setState(() => emailNotifications = value);
                    },
                  ),
                  const Divider(height: 1, indent: 72),
                  _notificationToggle(
                    icon: Icons.phone_android,
                    iconColor: AppColors.green,
                    iconBg: AppColors.green.withOpacity(0.1),
                    title: 'SMS Notifications',
                    subtitle: 'Receive text message alerts',
                    value: smsNotifications,
                    onChanged: (value) {
                      setState(() => smsNotifications = value);
                    },
                  ),
                  const Divider(height: 1, indent: 72),
                  _notificationToggle(
                    icon: Icons.notifications_active_outlined,
                    iconColor: const Color(0xFF6B7280),
                    iconBg: const Color(0xFFF3F4F6),
                    title: 'Push Notifications',
                    subtitle: 'Get instant app notifications',
                    value: pushNotifications,
                    onChanged: (value) {
                      setState(() => pushNotifications = value);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            /// Auto-save indicator
            Row(
              children: const [
                Icon(
                  Icons.check_circle,
                  color: AppColors.green,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  'Changes are saved automatically',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _notificationToggle({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          /// Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
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
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
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
          const SizedBox(width: 12),

          /// Toggle
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.green,
          ),
        ],
      ),
    );
  }
}

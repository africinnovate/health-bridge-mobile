import 'package:HealthBridge/core/constants/app_routes.dart';
import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:HealthBridge/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class NotificationHospitalScreen extends StatefulWidget {
  const NotificationHospitalScreen({super.key});

  @override
  State<NotificationHospitalScreen> createState() =>
      _NotificationHospitalScreenState();
}

class _NotificationHospitalScreenState
    extends State<NotificationHospitalScreen> {
  /// Toggles
  bool donationRequests = true;
  bool newDonorAppointment = true;
  bool donorReminders = true;
  bool loginAlerts = true;
  bool accountNotifications = true;
  bool emailNotifications = true;
  bool smsNotifications = true;
  bool pushNotifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),

                    /// Title
                    const Text(
                      'Set Your Notification Preferences',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    /// Subtitle
                    const Text(
                      'Choose how your hospital receives updates about blood '
                      'requests, donor appointments, and system activity.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 24),

                    _sectionTitle('Blood Request Notifications'),

                    _notificationTile(
                      icon: Icons.favorite,
                      iconColor: Colors.red,
                      title: 'Donation Requests',
                      subtitle:
                          'Updates about blood requests by other hospitals',
                      value: donationRequests,
                      onChanged: (v) => setState(() => donationRequests = v),
                    ),

                    const SizedBox(height: 24),

                    _sectionTitle('Blood Request Notifications'),

                    _notificationTile(
                      icon: Icons.person,
                      title: 'New Donor Appointment',
                      subtitle: 'Get notified for all new donor appointment.',
                      value: newDonorAppointment,
                      onChanged: (v) => setState(() => newDonorAppointment = v),
                    ),

                    _notificationTile(
                      icon: Icons.notifications,
                      title: 'Donor Appointment Reminders',
                      subtitle:
                          'Get notified on schedules before upcoming appointments.',
                      value: donorReminders,
                      onChanged: (v) => setState(() => donorReminders = v),
                    ),

                    const SizedBox(height: 24),

                    _sectionTitle('System Activity'),

                    _notificationTile(
                      icon: Icons.login,
                      title: 'Login Alerts',
                      subtitle:
                          'Receive all login alerts including devices and locations.',
                      value: loginAlerts,
                      onChanged: (v) => setState(() => loginAlerts = v),
                    ),

                    _notificationTile(
                      icon: Icons.shield,
                      title: 'Account Notifications',
                      subtitle: 'Security and account-related updates',
                      value: accountNotifications,
                      onChanged: (v) =>
                          setState(() => accountNotifications = v),
                    ),

                    const SizedBox(height: 24),

                    _sectionTitle('Delivery Options'),

                    _notificationTile(
                      icon: Icons.email,
                      title: 'Email Notifications',
                      subtitle: 'Receive updates via email',
                      value: emailNotifications,
                      onChanged: (v) => setState(() => emailNotifications = v),
                    ),

                    _notificationTile(
                      icon: Icons.phone,
                      title: 'SMS Notifications',
                      subtitle: 'Receive text message alerts',
                      value: smsNotifications,
                      onChanged: (v) => setState(() => smsNotifications = v),
                    ),

                    _notificationTile(
                      icon: Icons.chat_bubble,
                      title: 'Push Notifications',
                      subtitle: 'Get instant app notifications',
                      value: pushNotifications,
                      onChanged: (v) => setState(() => pushNotifications = v),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            /// Bottom button
            Padding(
              padding: const EdgeInsets.all(20),
              child: CustomButton(
                onPressed: () {
                  // TODO: Save preferences + navigate
                  context.goNextScreen(AppRoutes.hospitalComplete);
                },
                text: "Finish Set Up",
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ---------- Section Title ----------
  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// ---------- Notification Tile ----------
  Widget _notificationTile({
    required IconData icon,
    Color iconColor = const Color(0xFF6B7280),
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
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
          Switch(
            value: value,
            activeColor: Colors.green,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

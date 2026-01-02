import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacySettingsScreen extends StatefulWidget {
  const PrivacySettingsScreen({super.key});

  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  bool allowSpecialistsViewHistory = true;
  bool allowAppAnalytics = true;
  bool allowMarketingNotifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      appBar: const CustomAppBar(
        title: 'Privacy Settings',
        showArrow: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Subtitle
            const Text(
              'Control who can access your information and how it\'s used',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 24),

            /// Privacy Options
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  /// Who can view my medical profile
                  _privacyOption(
                    icon: Icons.shield_outlined,
                    iconColor: const Color(0xFF3B82F6),
                    iconBg: const Color(0xFFEFF6FF),
                    title: 'Who can view my medical profile',
                    subtitle:
                        'Control which specialists can see your full medical history',
                    badge: 'Only Assigned',
                    showToggle: false,
                  ),
                  const Divider(height: 1, indent: 72),

                  /// Allow specialists to view history
                  _privacyOption(
                    icon: Icons.close,
                    iconColor: Colors.white,
                    iconBg: AppColors.red,
                    title: 'Allow specialists to view history',
                    subtitle:
                        'Let specialists see your past consultations with other doctors',
                    value: allowSpecialistsViewHistory,
                    onChanged: (value) {
                      setState(() => allowSpecialistsViewHistory = value);
                    },
                  ),
                  const Divider(height: 1, indent: 72),

                  /// Allow app analytics
                  _privacyOption(
                    icon: Icons.bar_chart,
                    iconColor: const Color(0xFF3B82F6),
                    iconBg: const Color(0xFFEFF6FF),
                    title: 'Allow app analytics',
                    subtitle:
                        'Help us improve by sharing anonymous usage data',
                    value: allowAppAnalytics,
                    onChanged: (value) {
                      setState(() => allowAppAnalytics = value);
                    },
                  ),
                  const Divider(height: 1, indent: 72),

                  /// Allow marketing notifications
                  _privacyOption(
                    icon: Icons.campaign,
                    iconColor: const Color(0xFFF97316),
                    iconBg: const Color(0xFFFED7AA),
                    title: 'Allow marketing notifications',
                    subtitle:
                        'Receive updates about new features and health tips',
                    value: allowMarketingNotifications,
                    onChanged: (value) {
                      setState(() => allowMarketingNotifications = value);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            /// Data Management
            const Text(
              'Data Management',
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
                  ListTile(
                    onTap: () {
                      // Handle download data
                    },
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.download,
                        color: Color(0xFF6B7280),
                        size: 20,
                      ),
                    ),
                    title: const Text(
                      'Download My Data',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                  const Divider(height: 1, indent: 72),
                  ListTile(
                    onTap: () {
                      // Handle delete account
                    },
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEE2E2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.delete_outline,
                        color: AppColors.red,
                        size: 20,
                      ),
                    ),
                    title: const Text(
                      'Delete My Account',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.red,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            /// Privacy Policy Link
            Center(
              child: TextButton(
                onPressed: () async {
                  // Handle privacy policy link
                  final url = Uri.parse('https://healthbridge.com/privacy');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }
                },
                child: const Text(
                  'Read our Privacy Policy',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF3B82F6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            /// Auto-save indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
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

  Widget _privacyOption({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
    String? badge,
    bool showToggle = true,
    bool? value,
    ValueChanged<bool>? onChanged,
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
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (badge != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFFBFDBFE)),
                        ),
                        child: Text(
                          badge,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1E40AF),
                          ),
                        ),
                      ),
                    ],
                  ],
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

          /// Toggle or Chevron
          if (showToggle && value != null && onChanged != null)
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: AppColors.green,
            )
          else if (!showToggle)
            const Icon(
              Icons.chevron_right,
              color: Color(0xFF9CA3AF),
            ),
        ],
      ),
    );
  }
}

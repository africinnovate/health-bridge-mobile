import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactSupportScreen extends StatelessWidget {
  const ContactSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      appBar: const CustomAppBar(
        title: 'Contact Support',
        showArrow: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Subtitle
            const Text(
              'Choose how you\'d like to reach our support team. We\'re here to help.',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 32),

            /// Chat with Support
            _contactCard(
              icon: Icons.chat_bubble,
              iconColor: const Color(0xFF8B5CF6),
              iconBg: const Color(0xFFF3E8FF),
              title: 'Chat with Support',
              description: 'Get instant help from our support team',
              badge: 'Available now',
              badgeBg: const Color(0xFFDCFCE7),
              badgeColor: AppColors.green,
              onTap: () {
                // Handle chat support
              },
            ),
            const SizedBox(height: 16),

            /// Email Support
            _contactCard(
              icon: Icons.email,
              iconColor: const Color(0xFF8B5CF6),
              iconBg: const Color(0xFFF3E8FF),
              title: 'Email Support',
              description: 'Send us a message and we\'ll respond within 24 hours',
              contactInfo: 'support@healthbridge.com',
              contactColor: const Color(0xFF3B82F6),
              onTap: () async {
                final url = Uri.parse('mailto:support@healthbridge.com');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                }
              },
            ),
            const SizedBox(height: 16),

            /// Call Support
            _contactCard(
              icon: Icons.phone,
              iconColor: AppColors.green,
              iconBg: AppColors.green.withOpacity(0.1),
              title: 'Call Support',
              description: 'Speak directly with a support specialist',
              contactInfo: '+234 700 445 2211',
              contactColor: AppColors.green,
              subInfo: 'Mon-Fri: 8AM - 6PM',
              onTap: () async {
                final url = Uri.parse('tel:+2347004452211');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                }
              },
            ),
            const SizedBox(height: 32),

            /// Support Hours
            const Text(
              'Support Hours',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  _infoRow('Chat:', '24/7'),
                  const Divider(height: 24),
                  _infoRow('Email:', '24/7 (response within 24hrs)'),
                  const Divider(height: 24),
                  _infoRow('Phone:', 'Mon-Fri: 8AM - 6PM WAT'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            /// Emergency Notice
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFEE2E2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFECACA)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.red,
                    size: 20,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'For medical emergencies, please call 911 or your local emergency number',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.red,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _contactCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String description,
    String? badge,
    Color? badgeBg,
    Color? badgeColor,
    String? contactInfo,
    Color? contactColor,
    String? subInfo,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (badge != null && badgeBg != null && badgeColor != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: badgeBg,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      badge,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: badgeColor,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF6B7280),
                height: 1.5,
              ),
            ),
            if (contactInfo != null) ...[
              const SizedBox(height: 12),
              Text(
                contactInfo,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: contactColor ?? const Color(0xFF111827),
                ),
              ),
            ],
            if (subInfo != null) ...[
              const SizedBox(height: 4),
              Text(
                subInfo,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
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

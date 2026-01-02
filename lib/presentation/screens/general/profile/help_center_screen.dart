import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/constants/app_routes.dart';
import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      appBar: const CustomAppBar(
        title: 'Help Center',
        showArrow: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Search Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.search, color: Color(0xFF9CA3AF)),
                  hintText: 'Search for help...',
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF9CA3AF),
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 32),

            /// Popular Articles
            const Text(
              'Popular Articles',
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
                  _articleItem(
                    title: 'How do I book an appointment with a specialist?',
                    views: '1.2k views',
                    readTime: '1.2k views',
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 16),
                  _articleItem(
                    title: 'What should I do if I miss an appointment?',
                    views: '1.2k views',
                    readTime: '1.2k views',
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 16),
                  _articleItem(
                    title: 'How do I prepare for a blood donation?',
                    views: '943 views',
                    readTime: '4 min read',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            /// Browse by Category
            const Text(
              'Browse by Category',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            _categoryCard(
              icon: Icons.search,
              iconColor: AppColors.green,
              iconBg: AppColors.green.withOpacity(0.1),
              title: 'Getting Started',
              articleCount: '5 articles',
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _categoryCard(
              icon: Icons.calendar_today,
              iconColor: AppColors.green,
              iconBg: AppColors.green.withOpacity(0.1),
              title: 'Appointment Support',
              articleCount: '12 articles',
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _categoryCard(
              icon: Icons.favorite,
              iconColor: AppColors.red,
              iconBg: const Color(0xFFFEE2E2),
              title: 'Donations Support',
              articleCount: '8 articles',
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _categoryCard(
              icon: Icons.shield_outlined,
              iconColor: const Color(0xFFF59E0B),
              iconBg: const Color(0xFFFEF3C7),
              title: 'Account & Privacy',
              articleCount: '10 articles',
              onTap: () {},
            ),
            const SizedBox(height: 32),

            /// Quick Actions
            const Text(
              'Quick Actions',
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
                  _quickActionItem(
                    icon: Icons.chat_bubble_outline,
                    title: 'Chat With Support',
                    onTap: () {
                      context.goNextScreen(AppRoutes.contactSupport);
                    },
                  ),
                  const Divider(height: 1, indent: 60),
                  _quickActionItem(
                    icon: Icons.phone_outlined,
                    title: 'Call Support',
                    onTap: () {
                      context.goNextScreen(AppRoutes.contactSupport);
                    },
                  ),
                  const Divider(height: 1, indent: 60),
                  _quickActionItem(
                    icon: Icons.email_outlined,
                    title: 'Email Support',
                    onTap: () {
                      context.goNextScreen(AppRoutes.contactSupport);
                    },
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

  Widget _articleItem({
    required String title,
    required String views,
    required String readTime,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Row(
          children: [
            const Icon(Icons.remove_red_eye, size: 14, color: Color(0xFF9CA3AF)),
            const SizedBox(width: 4),
            Text(
              views,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF9CA3AF),
              ),
            ),
            const SizedBox(width: 12),
            const Icon(Icons.access_time, size: 14, color: Color(0xFF9CA3AF)),
            const SizedBox(width: 4),
            Text(
              readTime,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF9CA3AF),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _categoryCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String articleCount,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
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
                    articleCount,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Color(0xFF9CA3AF),
            ),
          ],
        ),
      ),
    );
  }

  Widget _quickActionItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Icon(icon, color: const Color(0xFF6B7280), size: 22),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: Color(0xFF9CA3AF),
      ),
    );
  }
}

import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/utils/snackbar_utils.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:HealthBridge/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class HospitalNotificationScreen extends StatefulWidget {
  const HospitalNotificationScreen({super.key});

  @override
  State<HospitalNotificationScreen> createState() =>
      _HospitalNotificationScreenState();
}

class _HospitalNotificationScreenState
    extends State<HospitalNotificationScreen> {
  String selectedTab = 'All';

  final List<String> tabs = [
    'All',
    'Blood Request',
    'Donations',
    'Inventory',
    'System',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Notification", showArrow: true),
      backgroundColor: AppColors.backgroundGray,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),

          /// Scrollable Tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: tabs.map((tab) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _tabButton(tab),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),

          /// Notifications List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _notificationItem(
                  icon: Icons.favorite,
                  iconColor: AppColors.red,
                  iconBg: const Color(0xFFFEE2E2),
                  title: 'Your request for O+ was accepted',
                  subtitle:
                      'The hospital has accepted your appointment request. Your date and time remain the same.',
                  time: '10 mins ago',
                ),
                const SizedBox(height: 16),
                _notificationItem(
                  icon: Icons.check,
                  iconColor: AppColors.green,
                  iconBg: const Color(0xFFDCFCE7),
                  title: 'New donation appointment scheduled',
                  subtitle: 'John Doe - B+ - Today at 3:00 PM',
                  time: '4 hours ago',
                  hasButton: true,
                ),
                const SizedBox(height: 16),
                _notificationItem(
                  icon: Icons.shield_outlined,
                  iconColor: const Color(0xFF8B5CF6),
                  iconBg: const Color(0xFFF3E8FF),
                  title: 'New login detected',
                  subtitle: 'Your account was accessed from Lagos, Nigeria',
                  time: '1 week ago',
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabButton(String title) {
    final isSelected = selectedTab == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.red : Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF6B7280),
          ),
        ),
      ),
    );
  }

  Widget _notificationItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
    required String time,
    bool hasButton = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
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
          /// Icon
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),

          /// Title
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 8),

          /// Subtitle
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),

          /// Time
          Text(
            time,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF9CA3AF),
            ),
          ),

          /// Button (if applicable)
          if (hasButton) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: CustomButton(
                onPressed: () {
                  SnackBarUtils.showInfo(context, "View appointment");
                },
                text: 'View Appointment',
              ),
            ),
          ],
        ],
      ),
    );
  }
}

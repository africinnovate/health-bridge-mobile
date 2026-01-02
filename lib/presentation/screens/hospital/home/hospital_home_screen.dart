import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/constants/app_routes.dart';
import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/core/utils/snackbar_utils.dart';
import 'package:HealthBridge/presentation/widgets/AppSvg.dart';
import 'package:HealthBridge/presentation/widgets/app_image.dart';
import 'package:HealthBridge/presentation/widgets/custom_button.dart';
import 'package:HealthBridge/presentation/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class HospitalHomeScreen extends StatefulWidget {
  final Function(int)? onNavigateToTab;

  const HospitalHomeScreen({super.key, this.onNavigateToTab});

  @override
  State<HospitalHomeScreen> createState() => _HospitalHomeScreenState();
}

class _HospitalHomeScreenState extends State<HospitalHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      body: Column(
        children: [
          /// fix header
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),

                  /// Stats Cards
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            icon: Icon(
                              Icons.water_drop,
                              color: AppColors.white,
                              size: 24,
                            ),
                            number: '3',
                            label: 'Active Blood Requests',
                            textColor: AppColors.white,
                            backgroundColor: AppColors.red,
                            onTap: () {
                              // Navigate to Request tab (index 1)
                              widget.onNavigateToTab?.call(1);
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            icon: AppImage("assets/images/warning.png"),
                            number: '2',
                            label: 'Urgent Requests Nearby',
                            textColor: AppColors.textPrimary,
                            backgroundColor: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  /// Small Stats
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: _appointmentCard(
                            count: 8,
                            period: "This week",
                            onPeriodTap: () {},
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: SizedBox.shrink()),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  /// Recent Activity
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Text(
                      'Recent Activity',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        children: [
                          _activityItem(
                            icon: Icons.check_circle,
                            iconColor: AppColors.green,
                            iconBg: const Color(0xFFDCFCE7),
                            title: 'Your request for O+ was accepted',
                            time: '2 hours ago',
                          ),
                          const Divider(height: 1),
                          _activityItem(
                            icon: Icons.calendar_month,
                            iconColor: const Color(0xFF8B5CF6),
                            iconBg: const Color(0xFFF3E8FF),
                            title: 'Donation scheduled for 5:00 PM today',
                            time: '4 hours ago',
                          ),
                          const Divider(height: 1),
                          _activityItem(
                            icon: Icons.warning_rounded,
                            iconColor: const Color(0xFFF59E0B),
                            iconBg: const Color(0xFFFEF3C7),
                            title: 'O- stock is running low',
                            time: '6 hours ago',
                          ),
                          const Divider(height: 1),
                          _activityItem(
                            icon: Icons.check_circle,
                            iconColor: AppColors.green,
                            iconBg: const Color(0xFFDCFCE7),
                            title: 'Blood request marked as fulfilled',
                            time: '7 days ago',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  /// Quick Actions
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Text(
                      'Quick Actions',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 48,
                                child: CustomButton(
                                  onPressed: () {
                                    context.goNextScreen(
                                        AppRoutes.newBloodRequest);
                                  },
                                  text: 'Request Blood',
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _actionButton(
                                icon: Icons.water_drop_outlined,
                                label: 'Record Donation',
                                onTap: () {
                                  SnackBarUtils.showInfo(
                                      context, "in progress");
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _actionButton(
                                icon: Icons.edit_outlined,
                                label: 'Update Units',
                                onTap: () {
                                  SnackBarUtils.showInfo(
                                      context, "in progress");
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _actionButton(
                                icon: Icons.list_alt_outlined,
                                label: 'Donor List',
                                onTap: () {
                                  SnackBarUtils.showInfo(
                                      context, "in progress");
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 16, top: 35),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textGray,
                  ),
                ),
                SizedBox(height: 2),
                CustomText(
                  text: "City General Hospital",
                  size: 16,
                  shouldBold: true,
                )
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              context.goNextScreen(AppRoutes.hospitalNotification);
              // SnackBarUtils.showInfo(context, "in progress");
            },
            icon: Stack(
              children: [
                const Icon(Icons.notifications_outlined, size: 24),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required Color backgroundColor,
    required Widget icon,
    required String number,
    required String label,
    required Color textColor,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: textColor.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            icon,
            const SizedBox(height: 8),
            Text(
              number,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: backgroundColor == AppColors.red
                    ? AppColors.white
                    : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _appointmentCard(
      {required int count,
      required String period,
      required VoidCallback? onPeriodTap}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          /// Top Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(
                Icons.calendar_month,
                color: AppColors.green,
              ),
              InkWell(
                onTap: onPeriodTap,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 6),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Text(
                        period,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 3),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        size: 14,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// Count
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$count ',
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const TextSpan(
                  text: 'appointments',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          /// Subtitle
          const Text(
            'Upcoming Donations',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallStat({
    required IconData icon,
    required String number,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: const Color(0xFF6B7280),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  number,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _activityItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String time,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
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
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: const Color(0xFF6B7280),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

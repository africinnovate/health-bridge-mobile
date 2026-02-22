import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/constants/app_routes.dart';
import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/data/models/appointment/appointment_model.dart';
import 'package:HealthBridge/presentation/providers/appointment_provider.dart';
import 'package:HealthBridge/presentation/providers/hospital_provider.dart';
import 'package:HealthBridge/presentation/widgets/AppSvg.dart';
import 'package:HealthBridge/presentation/widgets/app_image.dart';
import 'package:HealthBridge/presentation/widgets/custom_button.dart';
import 'package:HealthBridge/presentation/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class _ActivityIconData {
  final IconData icon;
  final Color color;
  final Color bgColor;

  _ActivityIconData({
    required this.icon,
    required this.color,
    required this.bgColor,
  });
}

class HospitalHomeScreen extends StatefulWidget {
  final Function(int)? onNavigateToTab;

  const HospitalHomeScreen({super.key, this.onNavigateToTab});

  @override
  State<HospitalHomeScreen> createState() => _HospitalHomeScreenState();
}

class _HospitalHomeScreenState extends State<HospitalHomeScreen> {
  String selectedPeriod = 'This week';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final hospitalProvider = context.read<HospitalProvider>();
    final appointmentProvider = context.read<AppointmentProvider>();

    // Fetch dashboard stats for blood requests and urgent count
    await hospitalProvider.getHospitalDashboardStats();
    // Fetch recent activity
    await hospitalProvider.getHospitalRecentActivity();
    // Still fetch appointments for period filtering
    await appointmentProvider.getAppointments('hospital', 'confirmed');
  }

  int _getFilteredAppointmentCount(List<AppointmentModel>? appointments) {
    if (appointments == null || appointments.isEmpty) return 0;

    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);

    return appointments.where((apt) {
      final aptDate = apt.scheduledTime;
      switch (selectedPeriod) {
        case 'This week':
          final startOfWeek = startOfToday
              .subtract(Duration(days: startOfToday.weekday - 1));
          final endOfWeek = startOfWeek.add(const Duration(days: 6));
          return aptDate.isAfter(startOfWeek) && aptDate.isBefore(endOfWeek);
        case 'This month':
          return aptDate.month == now.month && aptDate.year == now.year;
        case 'All time':
          return true;
        default:
          return true;
      }
    }).length;
  }

  void _showPeriodMenu() {
    showMenu<String>(
      context: context,
      position: const RelativeRect.fromLTRB(0, 0, 0, 0),
      items: [
        const PopupMenuItem(
          value: 'This week',
          child: Text('This week'),
        ),
        const PopupMenuItem(
          value: 'This month',
          child: Text('This month'),
        ),
        const PopupMenuItem(
          value: 'All time',
          child: Text('All time'),
        ),
      ],
    ).then((value) {
      if (value != null) {
        setState(() {
          selectedPeriod = value;
        });
      }
    });
  }

  _ActivityIconData _getActivityIcon(String activityType) {
    switch (activityType.toLowerCase()) {
      case 'blood_request_accepted':
      case 'blood_request_fulfilled':
      case 'donation_completed':
        return _ActivityIconData(
          icon: Icons.check_circle,
          color: AppColors.green,
          bgColor: const Color(0xFFDCFCE7),
        );
      case 'appointment_scheduled':
      case 'appointment_reminder':
        return _ActivityIconData(
          icon: Icons.calendar_month,
          color: const Color(0xFF8B5CF6),
          bgColor: const Color(0xFFF3E8FF),
        );
      case 'inventory_warning':
      case 'low_stock':
        return _ActivityIconData(
          icon: Icons.warning_rounded,
          color: const Color(0xFFF59E0B),
          bgColor: const Color(0xFFFEF3C7),
        );
      case 'blood_request_created':
      case 'new_request':
        return _ActivityIconData(
          icon: Icons.water_drop,
          color: AppColors.red,
          bgColor: const Color(0xFFFFE4E6),
        );
      case 'appointment_cancelled':
      case 'blood_request_cancelled':
        return _ActivityIconData(
          icon: Icons.cancel,
          color: Colors.red,
          bgColor: const Color(0xFFFFE4E6),
        );
      default:
        return _ActivityIconData(
          icon: Icons.info_outline,
          color: const Color(0xFF3B82F6),
          bgColor: const Color(0xFFDBeafe),
        );
    }
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      body: Column(
        children: [
          /// fix header
          _buildHeader(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadData,
              color: AppColors.red,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),

                  /// Stats Cards
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Consumer<HospitalProvider>(
                      builder: (context, hospitalProvider, _) {
                        final activeCount =
                            hospitalProvider.dashboardStats?.activeBloodRequests ?? 0;
                        final urgentCount =
                            hospitalProvider.dashboardStats?.urgentRequestsNearby ?? 0;

                        return Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                icon: Icon(
                                  Icons.water_drop,
                                  color: AppColors.white,
                                  size: 24,
                                ),
                                number: activeCount.toString(),
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
                                number: urgentCount.toString(),
                                label: 'Urgent Requests',
                                textColor: AppColors.textPrimary,
                                backgroundColor: AppColors.white,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),

                  /// Small Stats
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Consumer<AppointmentProvider>(
                      builder: (context, appointmentProvider, _) {
                        final appointmentCount = _getFilteredAppointmentCount(
                            appointmentProvider.appointments);

                        return Row(
                          children: [
                            Expanded(
                              child: _appointmentCard(
                                count: appointmentCount,
                                period: selectedPeriod,
                                onPeriodTap: () {
                                  _showPeriodMenu();
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(child: SizedBox.shrink()),
                          ],
                        );
                      },
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
                    child: Consumer<HospitalProvider>(
                      builder: (context, hospitalProvider, _) {
                        final activities = hospitalProvider.recentActivities;

                        if (activities.isEmpty) {
                          return Container(
                            padding: const EdgeInsets.all(40),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.history,
                                    size: 48,
                                    color: Colors.grey[300],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'No recent activity',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[500],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'You\'re all caught up!',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Column(
                            children: List.generate(
                              activities.length,
                              (index) {
                                final activity = activities[index];
                                final isLast = index == activities.length - 1;
                                final iconData =
                                    _getActivityIcon(activity.activityType);

                                return Column(
                                  children: [
                                    _activityItem(
                                      icon: iconData.icon,
                                      iconColor: iconData.color,
                                      iconBg: iconData.bgColor,
                                      title: activity.description,
                                      time: _getTimeAgo(activity.timestamp),
                                    ),
                                    if (!isLast) const Divider(height: 1),
                                  ],
                                );
                              },
                            ),
                          ),
                        );
                      },
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
                                  widget.onNavigateToTab?.call(2);
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
                                  widget.onNavigateToTab?.call(3);
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _actionButton(
                                icon: Icons.list_alt_outlined,
                                label: 'Donor List',
                                onTap: () {
                                  context.goNextScreen(AppRoutes.donorList);
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
              children: [
                const Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textGray,
                  ),
                ),
                const SizedBox(height: 2),
                Consumer<HospitalProvider>(
                  builder: (context, hospitalProvider, _) {
                    final hospitalName =
                        hospitalProvider.hospitalProfile?.name ??
                            'Hospital';
                    return CustomText(
                      text: hospitalName,
                      size: 16,
                      shouldBold: true,
                    );
                  },
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

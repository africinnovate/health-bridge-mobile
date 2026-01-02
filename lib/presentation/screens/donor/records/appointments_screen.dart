import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/constants/app_routes.dart';
import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/core/utils/dialog.dart';
import 'package:HealthBridge/core/utils/snackbar_utils.dart';
import 'package:HealthBridge/presentation/widgets/cancel_button.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  String selectedTab = 'Upcoming';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      appBar: const CustomAppBar(
        title: 'Appointments',
        showArrow: true,
      ),
      body: Column(
        children: [
          /// Tab Toggle
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _tabButton('Upcoming'),
                  ),
                  Expanded(
                    child: _tabButton('Past'),
                  ),
                ],
              ),
            ),
          ),

          /// Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  if (selectedTab == 'Upcoming') ...[
                    _buildUpcomingAppointmentCard('Blood Donation', false),
                    const SizedBox(height: 16),
                    _buildUpcomingAppointmentCard('Blood Donation', false),
                    const SizedBox(height: 16),
                    _buildUpcomingAppointmentCard('Missed Appointment', true),
                  ] else ...[
                    _buildPastAppointmentCard(),
                    const SizedBox(height: 16),
                    _buildPastAppointmentCard(),
                  ],
                  const SizedBox(height: 40),
                ],
              ),
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
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.red : Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF6B7280),
          ),
        ),
      ),
    );
  }

  Widget _buildUpcomingAppointmentCard(String badgeText, bool isMissed) {
    return GestureDetector(
      onTap: () {
        context.goNextScreenWithData(
          AppRoutes.donorAppointmentDetail,
          extra: isMissed ? "missed" : "upcoming",
        );
      },
      child: Container(
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
            /// Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isMissed
                    ? const Color(0xFFFEE2E2)
                    : const Color(0xFFDCFCE7),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                badgeText,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isMissed ? AppColors.red : AppColors.green,
                ),
              ),
            ),
            const SizedBox(height: 16),

            /// Hospital Info
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/images/patient.png',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Emmanuel General Hospital',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '16 Hospital Road, Eket Akwal-bom State',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            /// Info Row
            Row(
              children: [
                Expanded(
                  child: _infoColumn('Requested', '500 ml'),
                ),
                Expanded(
                  child: _infoColumn('Time', '14:00 AM'),
                ),
                Expanded(
                  child: _infoColumn('Date', 'May 3rd'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            /// Cancel Button
            CancelButton(
              text: 'Cancel',
              onPressed: () {
                showConfirmDialog(
                  context,
                  title: "Cancel Appointment",
                  message:
                      "Are you sure you want to cancel this appointment? You won't be able to undo this action.",
                  confirmText: "Yes, Cancel Appointment",
                  cancelText: "Keep Appointment",
                  onConfirm: () {
                    SnackBarUtils.showInfo(context, "in progress");
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPastAppointmentCard() {
    return GestureDetector(
      onTap: () {
        context.goNextScreenWithData(
          AppRoutes.donorAppointmentDetail,
          extra: "completed",
        );
      },
      child: Container(
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
            /// Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFDCFCE7),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'Completed',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.green,
                ),
              ),
            ),
            const SizedBox(height: 16),

            /// Hospital Info
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/images/patient.png',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Emmanuel General Hospital',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '16 Hospital Road, Eket Akwal-bom State',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            /// Info Row
            Row(
              children: [
                Expanded(
                  child: _infoColumn('Requested', '500 ml'),
                ),
                Expanded(
                  child: _infoColumn('Time', '14:00 AM'),
                ),
                Expanded(
                  child: _infoColumn('Date', 'May 3rd'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 4),
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

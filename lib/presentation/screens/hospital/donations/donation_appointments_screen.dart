import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/constants/app_routes.dart';
import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/core/utils/snackbar_utils.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class DonationAppointmentsScreen extends StatefulWidget {
  const DonationAppointmentsScreen({super.key});

  @override
  State<DonationAppointmentsScreen> createState() =>
      _DonationAppointmentsScreenState();
}

class _DonationAppointmentsScreenState
    extends State<DonationAppointmentsScreen> {
  String selectedTab = 'Unconfirmed';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      appBar: const CustomAppBar(
        title: 'Donation Appointments',
        showArrow: false,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),

          /// Tab Toggle
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                _tabButton('Unconfirmed'),
                _tabButton('Upcoming'),
                _tabButton('Completed'),
                _tabButton('Missed'),
              ],
            ),
          ),

          /// Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  if (selectedTab == 'Unconfirmed') ...[
                    _buildRequestCard('A+', 'Sarah Okonkwo', 'Tomorrow, 10:00 AM',
                        'HB-BR-3425', 'Pending', const Color(0xFFF59E0B)),
                    const SizedBox(height: 16),
                    _buildRequestCard('O+', 'John Doe', 'Today, 2:00 PM',
                        'HB-BR-3426', 'Pending', const Color(0xFFF59E0B)),
                    const SizedBox(height: 16),
                    _buildRequestCard('B-', 'Jane Smith', 'Tomorrow, 3:30 PM',
                        'HB-BR-3427', 'Pending', const Color(0xFFF59E0B)),
                    const SizedBox(height: 16),
                    _buildRequestCard('AB+', 'David Wilson', 'Today, 11:00 AM',
                        'HB-BR-3428', 'Pending', const Color(0xFFF59E0B)),
                  ] else if (selectedTab == 'Upcoming') ...[
                    _buildRequestCard('A+', 'Sarah Okonkwo', 'Tomorrow, 10:00 AM',
                        'HB-BR-3425', 'Confirmed', AppColors.green),
                    const SizedBox(height: 16),
                    _buildRequestCard('O-', 'Michael Brown', 'Dec 25, 9:00 AM',
                        'HB-BR-3429', 'Confirmed', AppColors.green),
                    const SizedBox(height: 16),
                    _buildRequestCard('A-', 'Emma Davis', 'Dec 26, 1:00 PM',
                        'HB-BR-3430', 'Confirmed', AppColors.green),
                    const SizedBox(height: 16),
                    _buildRequestCard('B+', 'Robert Taylor', 'Dec 27, 4:00 PM',
                        'HB-BR-3431', 'Confirmed', AppColors.green),
                  ] else if (selectedTab == 'Completed') ...[
                    _buildRequestCard('O+', 'John Doe', 'Dec 20, 2:00 PM',
                        'HB-BR-3420', 'Completed', AppColors.green),
                    const SizedBox(height: 16),
                    _buildRequestCard('A+', 'Lisa Anderson', 'Dec 19, 10:30 AM',
                        'HB-BR-3419', 'Completed', AppColors.green),
                    const SizedBox(height: 16),
                    _buildRequestCard('B-', 'James Wilson', 'Dec 18, 3:00 PM',
                        'HB-BR-3418', 'Completed', AppColors.green),
                    const SizedBox(height: 16),
                    _buildRequestCard('AB-', 'Mary Johnson', 'Dec 17, 11:00 AM',
                        'HB-BR-3417', 'Completed', AppColors.green),
                  ] else ...[
                    _buildRequestCard('A-', 'Tom Harris', 'Dec 15, 9:00 AM',
                        'HB-BR-3415', 'Missed', AppColors.red),
                    const SizedBox(height: 16),
                    _buildRequestCard('O+', 'Susan White', 'Dec 14, 2:30 PM',
                        'HB-BR-3414', 'Missed', AppColors.red),
                    const SizedBox(height: 16),
                    _buildRequestCard('B+', 'Kevin Martin', 'Dec 13, 11:30 AM',
                        'HB-BR-3413', 'Missed', AppColors.red),
                    const SizedBox(height: 16),
                    _buildRequestCard('AB+', 'Nancy Lee', 'Dec 12, 4:00 PM',
                        'HB-BR-3412', 'Missed', AppColors.red),
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
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTab = title;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.red : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : const Color(0xFF6B7280),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRequestCard(String bloodType, String donorName, String time,
      String refId, String status, Color statusColor) {
    return GestureDetector(
      onTap: () {
        // Determine the detail screen status based on the current tab and status
        String detailStatus = 'unconfirmed';
        if (selectedTab == 'Upcoming' || status == 'Confirmed') {
          detailStatus = 'confirmed';
        } else if (selectedTab == 'Completed' || status == 'Completed') {
          detailStatus = 'completed';
        } else if (selectedTab == 'Missed' || status == 'Missed') {
          detailStatus = 'missed';
        }
        context.goNextScreenWithData(
          AppRoutes.donationAppointmentDetail,
          extra: detailStatus,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// Blood Type Badge
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      bloodType,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                /// Status Badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            /// Donor Name
            Text(
              donorName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),

            /// Time
            Row(
              children: [
                const Icon(
                  Icons.access_time,
                  size: 14,
                  color: AppColors.textGray,
                ),
                const SizedBox(width: 4),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textGray,
                  ),
                ),
              ],
            ),

            /// Reference ID
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  refId,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textGray,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    String detailStatus = 'unconfirmed';
                    if (selectedTab == 'Upcoming' || status == 'Confirmed') {
                      detailStatus = 'confirmed';
                    } else if (selectedTab == 'Completed' ||
                        status == 'Completed') {
                      detailStatus = 'completed';
                    } else if (selectedTab == 'Missed' || status == 'Missed') {
                      detailStatus = 'missed';
                    }
                    context.goNextScreenWithData(
                      AppRoutes.donationAppointmentDetail,
                      extra: detailStatus,
                    );
                  },
                  child: const Text(
                    'View Details',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

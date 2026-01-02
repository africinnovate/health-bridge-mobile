import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/constants/app_routes.dart';
import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class BloodRequestsScreen extends StatefulWidget {
  const BloodRequestsScreen({super.key});

  @override
  State<BloodRequestsScreen> createState() => _BloodRequestsScreenState();
}

class _BloodRequestsScreenState extends State<BloodRequestsScreen> {
  String selectedTab = 'Active';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      appBar: const CustomAppBar(
        title: 'Blood Requests',
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
                _tabButton('Active'),
                _tabButton('Fulfilled'),
                _tabButton('Canceled'),
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
                  if (selectedTab == 'Active') ...[
                    _buildRequestCard('O+', '8', '2 hours ago',
                        'REF I 46-B11-3u25', 'Urgent', AppColors.red),
                    const SizedBox(height: 16),
                    _buildRequestCard(
                        'A-',
                        '5',
                        '4 hours ago',
                        'REF I 46-B11-3u26',
                        'Pending',
                        const Color(0xFFF59E0B)),
                    const SizedBox(height: 16),
                    _buildRequestCard('O+', '5', '6 hours ago',
                        'REF I 46-B11-3u27', 'Accepted', AppColors.green),
                    const SizedBox(height: 16),
                    _buildRequestCard('AB-', '2', '10 minutes ago',
                        'REF I 46-B11-3u28', 'Urgent', AppColors.red),
                    const SizedBox(height: 16),
                    _buildRequestCard(
                        'O-',
                        '6',
                        '1 hours ago',
                        'REF I 46-B11-3u30',
                        'Pending',
                        const Color(0xFFF59E0B)),
                  ] else if (selectedTab == 'Fulfilled') ...[
                    _buildRequestCard('O+', '8', '2 hours ago',
                        'REF I 46-B11-3u25', 'Completed', AppColors.green),
                    const SizedBox(height: 16),
                    _buildRequestCard('A-', '5', '4 hours ago',
                        'REF I 46-B11-3u26', 'Completed', AppColors.green),
                    const SizedBox(height: 16),
                    _buildRequestCard('B+', '5', '6 hours ago',
                        'REF I 46-B11-3u27', 'Completed', AppColors.green),
                    const SizedBox(height: 16),
                    _buildRequestCard('AB-', '2', '10 minutes ago',
                        'REF I 46-B11-3u28', 'Completed', AppColors.green),
                  ] else ...[
                    _buildRequestCard('O+', '8', '2 hours ago',
                        'REF I 46-B11-3u25', 'Canceled', AppColors.red),
                    const SizedBox(height: 16),
                    _buildRequestCard('A-', '5', '4 hours ago',
                        'REF I 46-B11-3u26', 'Canceled', AppColors.red),
                    const SizedBox(height: 16),
                    _buildRequestCard('B+', '5', '6 hours ago',
                        'REF I 46-B11-3u27', 'Canceled', AppColors.red),
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
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : const Color(0xFF6B7280),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRequestCard(String bloodType, String units, String time,
      String refId, String status, Color statusColor) {
    return GestureDetector(
      onTap: () {
        // Determine the detail screen status based on the current tab and status
        String detailStatus = 'confirmed';
        if (selectedTab == 'Fulfilled') {
          detailStatus = 'completed';
        } else if (selectedTab == 'Canceled') {
          detailStatus = 'cancelled';
        } else if (status == 'Accepted') {
          detailStatus = 'accepted';
        }
        context.goNextScreenWithData(AppRoutes.requestDetails,
            extra: detailStatus);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: status == 'Urgent'
              ? AppColors.red.withOpacity(0.1)
              : Colors.white,
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

            /// Units requested
            Text(
              '$units units requested',
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
            // const SizedBox(height: 8),

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
                    String detailStatus = 'confirmed';
                    if (selectedTab == 'Fulfilled') {
                      detailStatus = 'completed';
                    } else if (selectedTab == 'Canceled') {
                      detailStatus = 'cancelled';
                    } else if (status == 'Accepted') {
                      detailStatus = 'accepted';
                    }
                    context.goNextScreenWithData(AppRoutes.requestDetails,
                        extra: detailStatus);
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

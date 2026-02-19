import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/constants/app_routes.dart';
import 'package:HealthBridge/presentation/providers/blood_request_provider.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class BloodRequestsScreen extends StatefulWidget {
  const BloodRequestsScreen({super.key});

  @override
  State<BloodRequestsScreen> createState() => _BloodRequestsScreenState();
}

class _BloodRequestsScreenState extends State<BloodRequestsScreen> {
  String selectedTab = 'Active';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BloodRequestProvider>().fetchBloodRequests();
    });
  }

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
            child: Consumer<BloodRequestProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                final requests = selectedTab == 'Active'
                    ? provider.activeRequests
                    : selectedTab == 'Fulfilled'
                        ? provider.fulfilledRequests
                        : provider.cancelledRequests;

                if (requests.isEmpty) {
                  return Center(
                    child: Text(
                      'No ${selectedTab.toLowerCase()} requests',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                  );
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      ...requests.asMap().entries.map((entry) {
                        final request = entry.value;
                        final isLast = entry.key == requests.length - 1;
                        return Column(
                          children: [
                            _buildRequestCard(request),
                            if (!isLast) const SizedBox(height: 16),
                          ],
                        );
                      }),
                      const SizedBox(height: 40),
                    ],
                  ),
                );
              },
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

  String _getStatusDisplayText(String? status) {
    if (status == null) return 'Pending';
    final lower = status.toLowerCase();
    if (lower == 'confirmed') return 'Confirmed';
    if (lower == 'accepted') return 'Accepted';
    if (lower == 'completed') return 'Completed';
    if (lower == 'cancelled') return 'Cancelled';
    return status;
  }

  Color _getStatusColor(String? status) {
    if (status == null) return const Color(0xFFF59E0B);
    final lower = status.toLowerCase();
    if (lower == 'confirmed') return const Color(0xFFF59E0B);
    if (lower == 'accepted') return AppColors.green;
    if (lower == 'completed') return AppColors.green;
    if (lower == 'cancelled') return AppColors.red;
    return const Color(0xFFF59E0B);
  }

  String _formatTimeAgo(DateTime createdAt) {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inMinutes < 1) return 'just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';
    return '${createdAt.month}/${createdAt.day}/${createdAt.year}';
  }

  Widget _buildRequestCard(request) {
    final status = _getStatusDisplayText(request.requestStatus);
    final statusColor = _getStatusColor(request.requestStatus);
    final timeAgo = _formatTimeAgo(request.createdAt);

    return GestureDetector(
      onTap: () => _navigateToDetails(request.requestStatus),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: request.urgency?.toLowerCase() == 'urgent'
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
                      request.bloodType ?? 'N/A',
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
              '${request.units} units requested',
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
                  timeAgo,
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
                  request.refId,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textGray,
                  ),
                ),
                TextButton(
                  onPressed: () => _navigateToDetails(request.requestStatus),
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

  void _navigateToDetails(String? status) {
    String detailStatus = 'confirmed';
    if (selectedTab == 'Fulfilled') {
      detailStatus = 'completed';
    } else if (selectedTab == 'Canceled') {
      detailStatus = 'cancelled';
    } else if (status?.toLowerCase() == 'accepted') {
      detailStatus = 'accepted';
    }
    context.push(AppRoutes.requestDetails, extra: detailStatus);
  }
}

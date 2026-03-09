import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/constants/app_routes.dart';
import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/core/utils/snackbar_utils.dart';
import 'package:HealthBridge/presentation/providers/appointment_provider.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DonationAppointmentsScreen extends StatefulWidget {
  const DonationAppointmentsScreen({super.key});

  @override
  State<DonationAppointmentsScreen> createState() =>
      _DonationAppointmentsScreenState();
}

class _DonationAppointmentsScreenState
    extends State<DonationAppointmentsScreen> {
  String selectedTab = 'created';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchAppointments();
    });
  }

  Future<void> _fetchAppointments() async {
    final provider = context.read<AppointmentProvider>();
    final error =
        await provider.getAppointments('donor', status: selectedTab);
    if (mounted && error != null) {
      SnackBarUtils.showError(context, error);
    }
  }

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
                _tabButton('created', 'Created'),
                _tabButton('confirmed', 'Upcoming'),
                _tabButton('completed', 'Completed'),
                _tabButton('cancelled', 'Missed'),
              ],
            ),
          ),

          /// Content
          Expanded(
            child: Consumer<AppointmentProvider>(
              builder: (context, appointmentProvider, _) {
                if (appointmentProvider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final appointments = appointmentProvider.appointments ?? [];

                if (appointments.isEmpty) {
                  return Center(
                    child: Text(
                      'No appointments found',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  );
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      ...appointments.asMap().entries.map((entry) {
                        final appointment = entry.value;
                        final index = entry.key;
                        final statusColor =
                            _getStatusColor(appointment.status ?? '');
                        final scheduledTime = appointment.scheduledTime;
                        final formattedTime = _formatDateTime(scheduledTime);

                        return Column(
                          children: [
                            _buildRequestCard(
                              appointment.appointmentType.substring(0, 1).toUpperCase() +
                                  appointment.appointmentType.substring(1),
                              'Donor - ${appointment.userId.substring(0, 8)}',
                              formattedTime,
                              appointment.id,
                              _getDisplayStatus(appointment.status ?? ''),
                              statusColor,
                            ),
                            if (index < appointments.length - 1)
                              const SizedBox(height: 16),
                          ],
                        );
                      }).toList(),
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

  Widget _tabButton(String statusValue, String displayLabel) {
    final isSelected = selectedTab == statusValue;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTab = statusValue;
          });
          _fetchAppointments();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.red : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            displayLabel,
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'created':
        return const Color(0xFFF59E0B);
      case 'confirmed':
        return AppColors.green;
      case 'completed':
        return AppColors.green;
      case 'cancelled':
        return AppColors.red;
      case 'rescheduled':
        return const Color(0xFF3B82F6);
      default:
        return Colors.grey;
    }
  }

  String _getDisplayStatus(String status) {
    switch (status.toLowerCase()) {
      case 'created':
        return 'Pending';
      case 'confirmed':
        return 'Confirmed';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Missed';
      case 'rescheduled':
        return 'Rescheduled';
      default:
        return status;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = dateTime.difference(now);

    if (difference.inDays == 0) {
      return 'Today, ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')} ${dateTime.hour >= 12 ? 'PM' : 'AM'}';
    } else if (difference.inDays == 1) {
      return 'Tomorrow, ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')} ${dateTime.hour >= 12 ? 'PM' : 'AM'}';
    } else {
      return '${dateTime.month}/${dateTime.day}/${dateTime.year}, ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')} ${dateTime.hour >= 12 ? 'PM' : 'AM'}';
    }
  }

  Widget _buildRequestCard(String bloodType, String donorName, String time,
      String refId, String status, Color statusColor) {
    return GestureDetector(
      onTap: () {
        // Determine the detail screen status based on the current tab and status
        String detailStatus = 'Created';
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
                    String detailStatus = 'Created';
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

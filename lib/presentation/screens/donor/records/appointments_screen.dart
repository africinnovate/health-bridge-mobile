import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/constants/app_routes.dart';
import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/core/utils/dialog.dart';
import 'package:HealthBridge/core/utils/snackbar_utils.dart';
import 'package:HealthBridge/data/models/appointment/appointment_model.dart';
import 'package:HealthBridge/presentation/providers/appointment_provider.dart';
import 'package:HealthBridge/presentation/widgets/cancel_button.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  String selectedTab = 'Upcoming';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppointmentProvider>().getAllAppointments('donor');
    });
  }

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
                  Expanded(child: _tabButton('Upcoming')),
                  Expanded(child: _tabButton('Past')),
                ],
              ),
            ),
          ),

          /// Content
          Expanded(
            child: Consumer<AppointmentProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                final all = provider.appointments ?? [];

                final upcoming = all
                    .where((a) =>
                        a.status == 'confirmed' || a.status == 'rescheduled')
                    .toList()
                  ..sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));

                final past = all
                    .where((a) =>
                        a.status == 'completed' || a.status == 'cancelled')
                    .toList()
                  ..sort((a, b) => b.scheduledTime.compareTo(a.scheduledTime));

                final list = selectedTab == 'Upcoming' ? upcoming : past;

                if (list.isEmpty) {
                  return Center(
                    child: Text(
                      selectedTab == 'Upcoming'
                          ? 'No upcoming appointments'
                          : 'No past appointments',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () =>
                      provider.getAllAppointments('donor'),
                  color: AppColors.red,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: list.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final appointment = list[index];
                      return _buildAppointmentCard(
                        appointment,
                        showCancel: selectedTab == 'Upcoming',
                      );
                    },
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
    return GestureDetector(
      onTap: () => setState(() => selectedTab = title),
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

  Widget _buildAppointmentCard(AppointmentModel appointment,
      {required bool showCancel}) {
    final isCancelled = appointment.status == 'cancelled';
    final isCompleted = appointment.status == 'completed';

    final badgeText = isCancelled
        ? 'Cancelled'
        : isCompleted
            ? 'Completed'
            : 'Blood Donation';

    final badgeBg = isCancelled
        ? const Color(0xFFFEE2E2)
        : isCompleted
            ? const Color(0xFFDCFCE7)
            : const Color(0xFFDCFCE7);

    final badgeColor = isCancelled
        ? AppColors.red
        : AppColors.green;

    String formattedDate = 'N/A';
    String formattedTime = 'N/A';
    try {
      formattedDate =
          DateFormat('MMM d, yyyy').format(appointment.scheduledTime);
      formattedTime = DateFormat('h:mm a').format(appointment.scheduledTime);
    } catch (_) {}

    return GestureDetector(
      onTap: () {
        context.goNextScreenWithData(
          AppRoutes.donorAppointmentDetail,
          extra: appointment,
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: badgeBg,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                badgeText,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: badgeColor,
                ),
              ),
            ),
            const SizedBox(height: 16),

            /// Appointment Info
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
                    children: [
                      const Text(
                        'Blood Donation Appointment',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Ref: ${appointment.id.substring(0, 8).toUpperCase()}',
                        style: const TextStyle(
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
                  child: _infoColumn('Type', appointment.appointmentType),
                ),
                Expanded(
                  child: _infoColumn('Time', formattedTime),
                ),
                Expanded(
                  child: _infoColumn('Date', formattedDate),
                ),
              ],
            ),

            /// Cancel Button (upcoming only)
            if (showCancel) ...[
              const SizedBox(height: 16),
              CancelButton(
                text: 'Cancel',
                onPressed: () {
                  showConfirmDialog(
                    context,
                    title: 'Cancel Appointment',
                    message:
                        "Are you sure you want to cancel this appointment? You won't be able to undo this action.",
                    confirmText: 'Yes, Cancel Appointment',
                    cancelText: 'Keep Appointment',
                    onConfirm: () async {
                      final provider = context.read<AppointmentProvider>();
                      final error = await provider.cancelAppointment(
                        appointment.id,
                        'Cancelled by user',
                        appointmentType: 'donor',
                      );
                      if (mounted) {
                        if (error != null) {
                          SnackBarUtils.showError(context, error);
                        } else {
                          SnackBarUtils.showSuccess(
                              context, 'Appointment cancelled');
                        }
                      }
                    },
                  );
                },
              ),
            ],
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
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

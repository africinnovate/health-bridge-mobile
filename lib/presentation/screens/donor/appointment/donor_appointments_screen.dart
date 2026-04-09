import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/constants/app_routes.dart';
import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/core/utils/dialog.dart';
import 'package:HealthBridge/core/utils/snackbar_utils.dart';
import 'package:HealthBridge/data/models/appointment/appointment_model.dart';
import 'package:HealthBridge/presentation/providers/appointment_provider.dart';
import 'package:HealthBridge/presentation/widgets/cancel_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class DonorAppointmentsScreen extends StatefulWidget {
  final String appointmentType; // 'donor' or 'patient'

  const DonorAppointmentsScreen({
    super.key,
    this.appointmentType = 'donor',
  });

  @override
  State<DonorAppointmentsScreen> createState() =>
      _DonorAppointmentsScreenState();
}

class _DonorAppointmentsScreenState extends State<DonorAppointmentsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAppointments();
    });
  }

  Future<void> _loadAppointments() async {
    final appointmentProvider = context.read<AppointmentProvider>();

    // Load all appointments (both upcoming and past)
    await appointmentProvider.getAllAppointments(widget.appointmentType);
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
            child: Consumer<AppointmentProvider>(
              builder: (context, appointmentProvider, _) {
                if (appointmentProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                final appointments = appointmentProvider.appointments ?? [];

                if (appointments.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'No appointments scheduled',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  );
                }

                // Separate appointments by status
                final upcomingAppointments = appointments
                    .where((apt) =>
                        apt.status == 'created' ||
                        apt.status == 'confirmed' ||
                        apt.status == 'rescheduled')
                    .toList();
                final pastAppointments = appointments
                    .where((apt) =>
                        apt.status == 'completed' ||
                        apt.status == 'cancelled')
                    .toList();

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// UPCOMING SECTION
                      if (upcomingAppointments.isNotEmpty) ...[
                        _statusBadge('Upcoming',
                            const Color(0xFFDCFCE7), Colors.green),
                        const SizedBox(height: 12),
                        ...upcomingAppointments.asMap().entries.map((entry) {
                          final index = entry.key;
                          final appointment = entry.value;
                          return Column(
                            children: [
                              _buildAppointmentCard(appointment,
                                  showCancelButton: true),
                              if (index < upcomingAppointments.length - 1)
                                const SizedBox(height: 12),
                            ],
                          );
                        }).toList(),
                        const SizedBox(height: 24),
                      ],

                      /// PAST SECTION
                      if (pastAppointments.isNotEmpty) ...[
                        _statusBadge('Past', const Color(0xFFFEE2E2),
                            const Color(0xFFEF4444)),
                        const SizedBox(height: 12),
                        ...pastAppointments.asMap().entries.map((entry) {
                          final index = entry.key;
                          final appointment = entry.value;
                          return Column(
                            children: [
                              _buildAppointmentCard(appointment,
                                  showCancelButton: false),
                              if (index < pastAppointments.length - 1)
                                const SizedBox(height: 12),
                            ],
                          );
                        }).toList(),
                      ],

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

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 16, top: 35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title
          const Text(
            'My Appointments',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          /// Subtitle
          const Text(
            'Manage all your specialist sessions and blood donation appointments in one place.',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildAppointmentCard(AppointmentModel appointment,
      {required bool showCancelButton}) {
    // Format appointment date
    String formattedDate = 'N/A';
    String formattedTime = 'N/A';
    try {
      final dateTime = appointment.scheduledTime;
      formattedDate = DateFormat('MMM d, yyyy').format(dateTime);
      formattedTime = DateFormat('h:mm a').format(dateTime);
    } catch (e) {
      debugPrint('Error formatting date: $e');
    }

    // Determine status display
    String statusDisplay = appointment.status;
    if (appointment.status == 'created') {
      statusDisplay = 'Pending';
    } else if (appointment.status == 'confirmed' || appointment.status == 'rescheduled') {
      statusDisplay = 'Upcoming';
    } else if (appointment.status == 'completed') {
      statusDisplay = 'Completed';
    } else if (appointment.status == 'cancelled') {
      statusDisplay = 'Cancelled';
    }

    return GestureDetector(
      onTap: () {
        context.goNextScreenWithData(AppRoutes.donorAppointmentDetail,
            extra: appointment);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status badge for past appointments
            if (appointment.status == 'completed')
              _statusBadge('Completed', AppColors.green.withOpacity(0.1),
                  Colors.green),
            if (appointment.status == 'cancelled')
              _statusBadge('Cancelled', const Color(0xFFFEE2E2),
                  const Color(0xFFEF4444)),
            if (appointment.status == 'completed' || appointment.status == 'cancelled')
              const SizedBox(height: 10),

            // Hospital/Specialist info
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: appointment.specialistImageUrl != null
                      ? Image.network(
                          appointment.specialistImageUrl!,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Image.asset(
                            'assets/images/patient.png',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Image.asset(
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
                      Text(
                        (appointment.specialistId?.isNotEmpty ?? false)
                            ? 'Dr. ${appointment.specialistName}'
                            : 'Blood Donation Appointment',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        appointment.appointmentType == 'patient'
                            ? 'Specialist Consultation'
                            : 'Blood Donation',
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

            // Appointment details
            Container(
              decoration: BoxDecoration(
                color: AppColors.backgroundGray,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _infoColumn('Date', formattedDate),
                      ),
                      Expanded(
                        child: _infoColumn('Time', formattedTime),
                      ),
                      Expanded(
                        child: _infoColumn('Status', statusDisplay),
                      ),
                    ],
                  ),
                  if (showCancelButton &&
                      (appointment.status == 'created' ||
                       appointment.status == 'confirmed' ||
                       appointment.status == 'rescheduled')) ...[
                    const SizedBox(height: 16),
                    CancelButton(
                      text: 'Cancel',
                      onPressed: () {
                        showConfirmDialog(
                          context,
                          title: "Cancel Appointment",
                          message:
                              "Are you sure you want to cancel this appointment? You won't be able to undo this action.",
                          cancelText: "Keep Appointment",
                          confirmText: "Yes, Cancel Appointment",
                          onConfirm: () async {
                            final error = await context
                                .read<AppointmentProvider>()
                                .cancelAppointment(
                                  appointment.id,
                                  'Cancelled by user',
                                  appointmentType: widget.appointmentType,
                                );
                            if (!context.mounted) return;
                            if (error != null) {
                              SnackBarUtils.showError(context, error);
                            } else {
                              SnackBarUtils.showSuccess(
                                  context, 'Appointment cancelled');
                            }
                          },
                        );
                      },
                    ),
                  ],
                ],
              ),
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

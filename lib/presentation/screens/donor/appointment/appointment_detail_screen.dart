import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/core/utils/dialog.dart';
import 'package:HealthBridge/core/utils/snackbar_utils.dart';
import 'package:HealthBridge/presentation/widgets/cancel_button.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:HealthBridge/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../data/models/appointment/appointment_model.dart';
import '../../../providers/appointment_provider.dart';

class DonorAppointmentDetailScreen extends StatefulWidget {
  final AppointmentModel? appointment;

  const DonorAppointmentDetailScreen({
    super.key,
    this.appointment,
  });

  @override
  State<DonorAppointmentDetailScreen> createState() =>
      _DonorAppointmentDetailScreenState();
}

class _DonorAppointmentDetailScreenState
    extends State<DonorAppointmentDetailScreen> {
  bool _remindersEnabled = true;

  @override
  Widget build(BuildContext context) {
    if (widget.appointment == null) {
      return Scaffold(
        backgroundColor: AppColors.backgroundGray,
        appBar: const CustomAppBar(
          title: 'Appointment Details',
          showArrow: true,
        ),
        body: const Center(
          child: Text('No appointment details available'),
        ),
      );
    }

    final appointment = widget.appointment!;

    // Format date and time
    String formattedDate = 'N/A';
    String formattedTime = 'N/A';
    try {
      formattedDate =
          DateFormat('EEEE, d MMMM yyyy').format(appointment.scheduledTime);
      formattedTime = DateFormat('h:mm a').format(appointment.scheduledTime);
    } catch (e) {
      debugPrint('Error formatting date: $e');
    }

    // Determine status display
    String statusDisplay = appointment.status;
    if (appointment.status == 'created') {
      statusDisplay = 'Pending';
    } else if (appointment.status == 'confirmed' ||
        appointment.status == 'rescheduled') {
      statusDisplay = 'Confirmed';
    } else if (appointment.status == 'completed') {
      statusDisplay = 'Completed';
    } else if (appointment.status == 'cancelled') {
      statusDisplay = 'Cancelled';
    }

    final isUpcoming = appointment.status == 'created' ||
        appointment.status == 'confirmed' ||
        appointment.status == 'rescheduled';
    final isSpecialist = appointment.specialistId?.isNotEmpty ?? false;
    final appointmentType =
        isSpecialist ? 'Specialist Appointment' : 'Blood Donation';

    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      appBar: const CustomAppBar(
        title: 'Appointment Details',
        showArrow: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Status badges
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    appointmentType,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.green,
                    ),
                  ),
                ),
                Text(
                  statusDisplay,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isUpcoming ? AppColors.green : AppColors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            /// Specialist / Hospital Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundImage: isSpecialist &&
                            appointment.specialistImageUrl != null
                        ? NetworkImage(appointment.specialistImageUrl!)
                            as ImageProvider
                        : const AssetImage('assets/images/patient.png'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isSpecialist
                              ? 'Dr. ${appointment.specialistName}'
                              : (appointment.hospitalName ?? 'Hospital'),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isSpecialist
                              ? (appointment.specialistPhone ?? '')
                              : (appointment.hospitalAddress ?? ''),
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            /// Appointment Info Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isUpcoming
                    ? AppColors.green.withOpacity(0.05)
                    : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isUpcoming
                      ? AppColors.green.withOpacity(0.2)
                      : const Color(0xFFE5E7EB),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Large calendar icon
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: isUpcoming
                          ? AppColors.green
                          : const Color(0xFF9CA3AF),
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                    ),
                    child: const Icon(
                      Icons.calendar_today,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 20),

                  /// Date
                  _infoRow(
                    icon: Icons.calendar_today,
                    label: 'Date',
                    value: formattedDate,
                    iconColor:
                        isUpcoming ? AppColors.green : const Color(0xFF9CA3AF),
                  ),
                  const SizedBox(height: 16),

                  /// Time
                  _infoRow(
                    icon: Icons.access_time,
                    label: 'Time',
                    value: formattedTime,
                    iconColor:
                        isUpcoming ? AppColors.green : const Color(0xFF9CA3AF),
                  ),
                  const SizedBox(height: 16),

                  /// Reference
                  _infoRow(
                    icon: Icons.tag,
                    label: 'Reference',
                    value: appointment.id.substring(0, 8),
                    iconColor:
                        isUpcoming ? AppColors.green : const Color(0xFF9CA3AF),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            /// Conditional Content based on status
            if (appointment.status == "completed" ||
                appointment.status == "cancelled")

              /// Donation Summary (for completed)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Donation Summary',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Your donation was successfully completed.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6B7280),
                        height: 1.6,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Thank you for helping save a life ❤️',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6B7280),
                        height: 1.6,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Your donation history has been updated.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6B7280),
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              )
            else

              /// Appointment Notes
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Notes',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      appointment.notes?.isNotEmpty == true
                          ? appointment.notes!
                          : 'No notes added.',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6B7280),
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 24),

            /// Reminders (only for upcoming)
            if (isUpcoming) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Reminders',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'You\'ll receive a reminder 24 hours before the appointment.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6B7280),
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'You\'ll also receive a reminder 1 hour before.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6B7280),
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Enable Reminders',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Switch(
                          value: _remindersEnabled,
                          onChanged: (value) {
                            setState(() {
                              _remindersEnabled = value;
                            });
                          },
                          activeColor: AppColors.green,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            /// Action Buttons
            if (appointment.status == "completed") ...[
              CustomButton(
                onPressed: () {
                  context.goNextScreen(AppRoutes.donationDetails);
                },
                text: 'View Donation Details',
              ),
            ] else ...[
              // only hospital should be able to reschedule, restrict donor donor
              CustomButton(
                onPressed: () {
                  // Navigate to blood request booking with appointment context for rescheduling
                  context.goNextScreenWithData(AppRoutes.bloodRequestBooking,
                      extra: appointment);
                },
                text: 'Reschedule Appointment',
              ),
              const SizedBox(height: 12),
              CancelButton(
                text: 'Cancel Appointment',
                onPressed: () {
                  _handleCancelAppointment(context, appointment);
                },
              ),
            ],
            const SizedBox(height: 24),

            /// Contact Information
            if (isSpecialist
                ? appointment.specialistPhone != null
                : appointment.hospitalPhone != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: _contactRow(
                  label: isSpecialist ? 'Specialist Phone:' : 'Hospital Phone:',
                  value: isSpecialist
                      ? appointment.specialistPhone!
                      : appointment.hospitalPhone!,
                ),
              ),
            ],
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _infoRow({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 20,
            color: iconColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
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
          ),
        ),
      ],
    );
  }

  Widget _contactRow({
    required String label,
    required String value,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF6B7280),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.green,
          ),
        ),
      ],
    );
  }

  void _handleCancelAppointment(
      BuildContext context, AppointmentModel appointment) {
    showConfirmDialog(
      context,
      title: "Cancel Appointment",
      message:
          "Are you sure you want to cancel this appointment? You won't be able to undo this action.",
      cancelText: "Keep Appointment",
      confirmText: "Yes, Cancel Appointment",
      onConfirm: () {
        _cancelAppointmentAPI(context, appointment);
      },
    );
  }

  Future<void> _cancelAppointmentAPI(
    BuildContext context,
    AppointmentModel appointment,
  ) async {
    final appointmentProvider = context.read<AppointmentProvider>();

    final error = await appointmentProvider.cancelAppointment(
      appointment.id,
      'Cancelled by user',
      appointmentType: 'donor',
    );

    if (mounted) {
      if (error == null) {
        showThankYouDialog(
          context,
          title: 'Appointment Cancelled',
          message: 'Your appointment has been cancelled successfully',
          buttonText: 'Done',
          onContinue: () {
            context.goBack();
            context.goBack();
          },
        );
      } else {
        SnackBarUtils.showError(context, error);
      }
    }
  }
}

import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/constants/app_routes.dart';
import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/core/utils/dialog.dart';
import 'package:HealthBridge/core/utils/snackbar_utils.dart';
import 'package:HealthBridge/data/models/appointment/appointment_model.dart';
import 'package:HealthBridge/presentation/providers/appointment_provider.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AppointmentDetailScreen extends StatefulWidget {
  final AppointmentModel? appointment;

  const AppointmentDetailScreen({super.key, required this.appointment});

  @override
  State<AppointmentDetailScreen> createState() =>
      _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState extends State<AppointmentDetailScreen> {
  bool _isConfirming = false;
  bool _isCancelling = false;

  AppointmentModel? get _appointment => widget.appointment;

  String get _formattedDate {
    if (_appointment == null) return 'N/A';
    return DateFormat('EEEE, d MMMM yyyy').format(_appointment!.scheduledTime);
  }

  String get _formattedTime {
    if (_appointment == null) return 'N/A';
    return DateFormat('h:mm a').format(_appointment!.scheduledTime);
  }

  String get _refId {
    if (_appointment == null) return 'N/A';
    return 'HB-${_appointment!.id.substring(0, 8).toUpperCase()}';
  }

  bool get _isCreated => _appointment?.status == 'created';
  bool get _isUpcoming =>
      _appointment?.status == 'confirmed' ||
      _appointment?.status == 'rescheduled';

  Future<void> _confirmAppointment() async {
    if (_appointment == null) return;
    setState(() => _isConfirming = true);

    final provider = context.read<AppointmentProvider>();
    final error = await provider.confirmAppointment(
      _appointment!.id,
      appointmentType: 'patient',
    );

    if (mounted) {
      setState(() => _isConfirming = false);
      if (error != null) {
        SnackBarUtils.showError(context, error);
      } else {
        SnackBarUtils.showSuccess(context, 'Appointment confirmed');
        Navigator.pop(context);
      }
    }
  }

  void _cancelAppointment() {
    if (_appointment == null) return;
    showConfirmDialog(
      context,
      title: 'Cancel Appointment?',
      message:
          "Are you sure you want to cancel this appointment? You won't be able to undo this action.",
      confirmText: 'Yes, Cancel Appointment',
      cancelText: 'Keep Appointment',
      icon: Icons.question_mark,
      onConfirm: () async {
        setState(() => _isCancelling = true);
        final provider = context.read<AppointmentProvider>();
        final error = await provider.cancelAppointment(
          _appointment!.id,
          'Cancelled by specialist',
          appointmentType: 'patient',
        );
        if (mounted) {
          setState(() => _isCancelling = false);
          if (error != null) {
            SnackBarUtils.showError(context, error);
          } else {
            SnackBarUtils.showSuccess(context, 'Appointment cancelled');
            Navigator.pop(context);
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_appointment == null) {
      return Scaffold(
        backgroundColor: AppColors.backgroundGray,
        appBar: const CustomAppBar(title: 'Appointment Details'),
        body: const Center(child: Text('No appointment details available')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      appBar: const CustomAppBar(title: 'Appointment Details'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _patientCard(),
                    const SizedBox(height: 16),
                    _appointmentInfo(),
                    const SizedBox(height: 16),
                    _statusCard(),
                    const SizedBox(height: 20),

                    if (_isCreated) ...[
                      _primaryButton(
                        _isConfirming
                            ? 'Confirming...'
                            : 'Confirm Appointment',
                        AppColors.green,
                        onTap: _isConfirming ? null : _confirmAppointment,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _secondaryButton(
                              'Re-Schedule',
                              () => context.goNextScreenWithData(
                                AppRoutes.rescheduleOnSpecialist,
                                extra: _appointment,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _secondaryButton(
                              'View Profile',
                              () => context.goNextScreen(
                                  AppRoutes.patientProfileOnSpecialist),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _dangerButton(
                        _isCancelling
                            ? 'Cancelling...'
                            : 'Cancel Appointment',
                        onTap: _isCancelling ? null : _cancelAppointment,
                      ),
                    ] else if (_isUpcoming) ...[
                      _primaryButton(
                        'Start Consultation',
                        AppColors.green,
                        onTap: () => SnackBarUtils.showInfo(
                            context, 'Consultation feature coming soon'),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _secondaryButton(
                              'Re-Schedule',
                              () => context.goNextScreenWithData(
                                AppRoutes.rescheduleOnSpecialist,
                                extra: _appointment,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _secondaryButton(
                              'View Profile',
                              () => context.goNextScreen(
                                  AppRoutes.patientProfileOnSpecialist),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _dangerButton(
                        _isCancelling
                            ? 'Cancelling...'
                            : 'Cancel Appointment',
                        onTap: _isCancelling ? null : _cancelAppointment,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _patientCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/images/patient.png'),
            backgroundColor: Colors.transparent,
          ),
          const SizedBox(height: 12),
          _consultationTypeTag(),
          const SizedBox(height: 12),
          const Text(
            'Patient Appointment',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            'Ref: ${_appointment!.id.substring(0, 8).toUpperCase()}',
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _appointmentInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoRow(
            icon: Icons.calendar_today,
            label: 'Date',
            value: _formattedDate,
          ),
          const Divider(height: 1),
          _InfoRow(
            icon: Icons.access_time,
            label: 'Time',
            value: _formattedTime,
          ),
          const Divider(height: 1),
          _InfoRow(
            icon: Icons.tag,
            label: 'Reference',
            value: _refId,
          ),
          const Divider(height: 1),
          _InfoRow(
            icon: Icons.category_outlined,
            label: 'Type',
            value: _appointment!.appointmentType.toUpperCase(),
          ),
        ],
      ),
    );
  }

  Widget _statusCard() {
    final status = _appointment!.status;
    Color statusColor;
    Color statusBg;
    String statusLabel;
    String statusDesc;

    switch (status) {
      case 'confirmed':
        statusColor = AppColors.green;
        statusBg = const Color(0xFFDCFCE7);
        statusLabel = 'Confirmed';
        statusDesc = 'Appointment is confirmed and scheduled';
        break;
      case 'rescheduled':
        statusColor = const Color(0xFF3B82F6);
        statusBg = const Color(0xFFEFF6FF);
        statusLabel = 'Rescheduled';
        statusDesc = 'Appointment has been rescheduled';
        break;
      case 'completed':
        statusColor = AppColors.green;
        statusBg = const Color(0xFFDCFCE7);
        statusLabel = 'Completed';
        statusDesc = 'This appointment has been completed';
        break;
      case 'cancelled':
        statusColor = AppColors.red;
        statusBg = const Color(0xFFFEE2E2);
        statusLabel = 'Cancelled';
        statusDesc = _appointment!.cancelledReason ?? 'Appointment was cancelled';
        break;
      default:
        statusColor = const Color(0xFFD97706);
        statusBg = const Color(0xFFFEF3C7);
        statusLabel = 'Pending';
        statusDesc = 'Awaiting your confirmation';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              statusLabel,
              style: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              statusDesc,
              style: const TextStyle(
                  fontSize: 13, color: Color(0xFF6B7280)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _primaryButton(String text, Color color,
      {required VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: onTap == null ? color.withOpacity(0.6) : color,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          text,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _secondaryButton(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child:
            Text(text, style: const TextStyle(fontWeight: FontWeight.w500)),
      ),
    );
  }

  Widget _dangerButton(String text, {required VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFFDECEC),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          text,
          style: const TextStyle(
              color: AppColors.red, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _consultationTypeTag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFE7F6EC),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.videocam, size: 14, color: AppColors.green),
          SizedBox(width: 6),
          Text(
            'Consultation',
            style: TextStyle(
                color: AppColors.green, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 2),
                Text(value,
                    style:
                        const TextStyle(fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

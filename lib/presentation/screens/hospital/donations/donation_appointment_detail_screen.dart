import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/constants/app_routes.dart';
import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/core/utils/dialog.dart';
import 'package:HealthBridge/core/utils/snackbar_utils.dart';
import 'package:HealthBridge/presentation/widgets/cancel_button.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:HealthBridge/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class DonationAppointmentDetailScreen extends StatefulWidget {
  final String status; // "unconfirmed", "confirmed", "completed", "missed"

  const DonationAppointmentDetailScreen({
    super.key,
    this.status = "unconfirmed",
  });

  @override
  State<DonationAppointmentDetailScreen> createState() =>
      _DonationAppointmentDetailScreenState();
}

class _DonationAppointmentDetailScreenState
    extends State<DonationAppointmentDetailScreen> {
  @override
  Widget build(BuildContext context) {
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
            /// Status Badge
            Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: _getStatusColor(widget.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _getStatusText(widget.status),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(widget.status),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            /// Alert for Missed Status
            if (widget.status == 'missed') ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.red.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Donor Did Not Show Up',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.red,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'This appointment was missed. You can reschedule with the donor or mark it as canceled.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            /// Donor Profile
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.red, width: 3),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/patient.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.red, width: 2),
                          ),
                          child: const Text(
                            'A+',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.red,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Chisom Emmanuel',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.phone, size: 14, color: Color(0xFF6B7280)),
                      SizedBox(width: 4),
                      Text(
                        '+234 803 456 7890',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.email, size: 14, color: Color(0xFF6B7280)),
                      SizedBox(width: 4),
                      Text(
                        'chisomchukwukwe@gmail.com',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            /// Appointment Information
            const Text(
              'Appointment Information',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  _infoRow(Icons.calendar_today, 'Wednesday, 12 March 2025'),
                  const SizedBox(height: 16),
                  _infoRow(Icons.access_time, '10:30 AM'),
                  const SizedBox(height: 16),
                  _infoRow(Icons.location_on,
                      'City General Hospital, 45 Marina Road, Lagos Island, Lagos, Nigeria'),
                  const SizedBox(height: 16),
                  _infoRow(Icons.confirmation_number, 'HB-APT-2746'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            /// Donation Record (for completed)
            if (widget.status == 'completed') ...[
              const Text(
                'Donation Record',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    _detailRow('Units Donated', '450ml (1 unit)'),
                    const SizedBox(height: 12),
                    _detailRow('Completion Time', 'March 15, 2025 at 11:30 AM'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            /// Hospital Notes
            if (widget.status == 'completed' || widget.status == 'missed') ...[
              const Text(
                'Hospital Notes',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  widget.status == 'completed'
                      ? 'Donor was in excellent health and had no complications during the donation process. Vitals remained stable throughout. Post-donation recovery was smooth. Donor was provided with refreshments and advised to rest for 15 minutes before leaving. No adverse reactions observed. Until next donation time.'
                      : 'Donor did not arrive for scheduled appointment. No prior communication. Phone call attempted - no answer.',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF6B7280),
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

            /// Missed timestamp
            if (widget.status == 'missed') ...[
              const Text(
                'Marked as missed on March 15, 2025 at 3:45 PM',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF9CA3AF),
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 24),
            ],

            /// Action Buttons
            if (widget.status == 'unconfirmed') ...[
              SizedBox(
                width: double.infinity,
                height: 50,
                child: CustomButton(
                  onPressed: () {
                    SnackBarUtils.showSuccess(
                        context, "Appointment confirmed");
                  },
                  text: 'Confirm Appointment',
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: CancelButton(
                  text: 'Reschedule Appointment',
                  onPressed: () {
                    context.goNextScreen(AppRoutes.rescheduleAppointment);
                  },
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    showConfirmDialog(
                      context,
                      title: "Cancel Appointment",
                      message:
                          "Are you sure you want to cancel this appointment?",
                      confirmText: "Yes, Cancel",
                      cancelText: "Keep Appointment",
                      onConfirm: () {
                        context.goBack();
                      },
                    );
                  },
                  child: const Text(
                    'Cancel Appointment',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.red,
                    ),
                  ),
                ),
              ),
            ] else if (widget.status == 'confirmed') ...[
              SizedBox(
                width: double.infinity,
                height: 50,
                child: CustomButton(
                  onPressed: () {
                    _showRecordDonationDialog();
                  },
                  text: 'Mark As Completed',
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: CancelButton(
                  text: 'Mark As Missed',
                  onPressed: () {
                    _showMarkAsMissedDialog();
                  },
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    showConfirmDialog(
                      context,
                      title: "Cancel Appointment",
                      message:
                          "Are you sure you want to cancel this appointment?",
                      confirmText: "Yes, Cancel",
                      cancelText: "Keep Appointment",
                      onConfirm: () {
                        context.goBack();
                      },
                    );
                  },
                  child: const Text(
                    'Cancel Appointment',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.red,
                    ),
                  ),
                ),
              ),
            ] else if (widget.status == 'completed') ...[
              TextButton(
                onPressed: () {
                  SnackBarUtils.showInfo(context, "View donor profile");
                },
                child: const Text(
                  'View Donor Profile',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.red,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  SnackBarUtils.showInfo(context, "View donation history");
                },
                child: const Text(
                  'View Donation History',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.red,
                  ),
                ),
              ),
            ] else if (widget.status == 'missed') ...[
              SizedBox(
                width: double.infinity,
                height: 50,
                child: CancelButton(
                  text: 'Reschedule Appointment',
                  onPressed: () {
                    context.goNextScreen(AppRoutes.rescheduleAppointment);
                  },
                ),
              ),
            ],
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'unconfirmed':
        return const Color(0xFF8B5CF6);
      case 'confirmed':
      case 'completed':
        return AppColors.green;
      case 'missed':
        return AppColors.red;
      default:
        return AppColors.green;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'unconfirmed':
        return 'Unconfirmed';
      case 'confirmed':
        return 'Confirmed';
      case 'completed':
        return 'Completed';
      case 'missed':
        return 'Missed';
      default:
        return 'Unconfirmed';
    }
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.red),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF374151),
            ),
          ),
        ),
      ],
    );
  }

  Widget _detailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF9CA3AF),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void _showRecordDonationDialog() {
    final TextEditingController unitsController = TextEditingController();
    final TextEditingController notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Record Donation Form',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Units Donated',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: unitsController,
                decoration: InputDecoration(
                  hintText: 'Enter quantity (litre donated)',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Notes (Optional)',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: notesController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Any specific requirement',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            height: 48,
            child: CustomButton(
              onPressed: () {
                Navigator.pop(context);
                SnackBarUtils.showSuccess(context, "Donation recorded");
              },
              text: 'Submit',
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showMarkAsMissedDialog() {
    final TextEditingController reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Mark Appointment as Missed',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Provide a brief note explaining why this donor could not complete the scheduled appointment.',
                style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
              ),
              const SizedBox(height: 16),
              const Text(
                'Reason for Marking as Missed',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: reasonController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Reason for Missed Appointment',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            height: 48,
            child: CancelButton(
              text: 'Mark as Missed',
              onPressed: () {
                Navigator.pop(context);
                SnackBarUtils.showSuccess(
                    context, "Appointment marked as missed");
              },
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

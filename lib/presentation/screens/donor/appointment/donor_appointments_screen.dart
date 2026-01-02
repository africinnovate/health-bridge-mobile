import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/constants/app_routes.dart';
import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/core/utils/dialog.dart';
import 'package:HealthBridge/core/utils/snackbar_utils.dart';
import 'package:HealthBridge/presentation/widgets/cancel_button.dart';
import 'package:flutter/material.dart';

class DonorAppointmentsScreen extends StatefulWidget {
  const DonorAppointmentsScreen({super.key});

  @override
  State<DonorAppointmentsScreen> createState() =>
      _DonorAppointmentsScreenState();
}

class _DonorAppointmentsScreenState extends State<DonorAppointmentsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      body: Column(
        children: [
          /// fix header
          _buildHeader(),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// UPCOMING SECTION
                  _statusBadge(
                      'Upcoming', const Color(0xFFDCFCE7), Colors.green),
                  const SizedBox(height: 12),
                  _appointmentCard(
                    showCancelButton: true,
                  ),
                  const SizedBox(height: 12),
                  _appointmentCard(showCancelButton: true),
                  const SizedBox(height: 24),

                  /// PAST SECTION
                  _statusBadge(
                      'Past', const Color(0xFFFEE2E2), const Color(0xFFEF4444)),
                  const SizedBox(height: 12),

                  /// Completed
                  const SizedBox(height: 12),
                  _appointmentCard(
                      showCancelButton: false, showInfo: "complete"),

                  /// Missed Appointment
                  const SizedBox(height: 12),
                  _appointmentCard(showCancelButton: false, showInfo: "miss"),
                  const SizedBox(height: 12),
                  _appointmentCard(
                      showCancelButton: false, showInfo: "complete"),
                  const SizedBox(
                    height: 40,
                  ),
                ],
              ),
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

  Widget _appointmentCard(
      {required bool showCancelButton, String showInfo = ""}) {
    // Determine status based on card type
    String status = "upcoming";
    if (showInfo == "complete") {
      status = "completed";
    } else if (showInfo == "miss") {
      status = "missed";
    }

    return GestureDetector(
      onTap: () {
        context.goNextScreenWithData(AppRoutes.donorAppointmentDetail,
            extra: status);
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
            if (showInfo == "complete")
              _statusBadge(
                  'Completed', AppColors.green.withOpacity(0.1), Colors.green),
            if (showInfo == "miss")
              _statusBadge('Missed Appointment', const Color(0xFFFEE2E2),
                  const Color(0xFFEF4444)),

            SizedBox(height: 10),
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
                  if (showCancelButton) ...[
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
                          onConfirm: () {
                            // handle cancel logic here
                            SnackBarUtils.showInfo(context, "in progress");
                            // context.goBack();
                          },
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),

            /// Info Row
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

import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/constants/app_routes.dart';
import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/core/utils/dialog.dart';
import 'package:HealthBridge/core/utils/snackbar_utils.dart';
import 'package:HealthBridge/presentation/widgets/cancel_button.dart';
import 'package:HealthBridge/presentation/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class PatientAppointmentsScreen extends StatefulWidget {
  const PatientAppointmentsScreen({super.key});

  @override
  State<PatientAppointmentsScreen> createState() =>
      _PatientAppointmentsScreenState();
}

class _PatientAppointmentsScreenState extends State<PatientAppointmentsScreen> {
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
                      showCancelButton: false,
                      showInfo: "complete",
                      communicate: "person"),

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
      width: double.infinity,
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
      {required bool showCancelButton,
      String showInfo = "",
      String communicate = "video"}) {
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
            SizedBox(height: 15),

            /// show mode of communication
            Row(
              children: [
                Icon(
                    communicate == "video"
                        ? Icons.video_call
                        : Icons.location_on_rounded,
                    color: AppColors.textGray),
                SizedBox(width: 10),
                CustomText(
                    text: communicate == "video" ? "Video call" : "person"),
              ],
            ),
            SizedBox(height: 15),

            /// image and name and address
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

            /// location address
            if (communicate == "person") ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.backgroundGray,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.location_on_rounded),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Private Clinic',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        // SizedBox(height: 4),
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
            ],

            const SizedBox(height: 16),

            // date and time
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
                      // Expanded(
                      //   child: _infoColumn('Requested', '500 ml'),
                      // ),
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

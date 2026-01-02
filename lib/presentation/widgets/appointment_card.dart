import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/presentation/widgets/upcoming_appointment_card.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/app_routes.dart';
import '../../core/utils/dialog.dart';
import '../../core/utils/snackbar_utils.dart';

class AppointmentCard extends StatelessWidget {
  final bool showActions;

  const AppointmentCard({super.key, required this.showActions});

  @override
  Widget build(BuildContext context) {
    /// show different card from showActions reference
    return UpcomingAppointmentCard(
      patientName: 'James Adebayo',
      appointmentInfo: 'Video Call • Tomorrow, 2:00 PM',
      avatar: const AssetImage('assets/images/patient.png'),
      onTap: () {
        context.goNextScreenWithData(AppRoutes.specialistAppointDetailScreen,
            extra: AppConstants.upcomingAppointment);
      },
      onReschedule: () {
        context.goNextScreen(AppRoutes.rescheduleOnSpecialist);
      },
      onCancel: () {
        showConfirmDialog(
          context,
          title: 'Cancel Appointment?',
          message:
              'Are you sure you want to cancel this appointment? You won’t be able to undo this action.',
          confirmText: 'Yes, Cancel Appointment',
          cancelText: 'Keep Appointment',
          icon: Icons.question_mark,
          onConfirm: () {
            SnackBarUtils.showInfo(context, "In progress");
          },
        );
      },
    );
  }
}

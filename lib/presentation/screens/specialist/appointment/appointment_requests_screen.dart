import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/constants/app_constants.dart';
import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/core/utils/dialog.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_routes.dart';

class AppointmentRequestsScreen extends StatefulWidget {
  final bool? showBackArrow;

  const AppointmentRequestsScreen({super.key, this.showBackArrow});

  @override
  State<AppointmentRequestsScreen> createState() =>
      _AppointmentRequestsScreenState();
}

class _AppointmentRequestsScreenState extends State<AppointmentRequestsScreen> {
  @override
  Widget build(BuildContext context) {
    print("What is show arrow ${widget.showBackArrow}");
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Appointment Requests',
        showArrow: widget.showBackArrow ?? false,
      ),
      backgroundColor: AppColors.backgroundGray,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: 3,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (_, index) {
                  return AppointmentRequestCard(
                    isVideo: index != 2,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ======================================================
/// Appointment Request Card
/// ======================================================
class AppointmentRequestCard extends StatelessWidget {
  final bool isVideo;

  const AppointmentRequestCard({
    super.key,
    required this.isVideo,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.goNextScreenWithData(AppRoutes.specialistAppointDetailScreen,
            extra: AppConstants.appointmentRequest);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _headerRow(),
            const SizedBox(height: 12),
            _metaRow(),
            const SizedBox(height: 12),
            _symptomPreview(),
            const SizedBox(height: 16),
            _actions(context),
          ],
        ),
      ),
    );
  }

  /// --------------------------------------------------
  Widget _headerRow() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 22,
          backgroundImage: AssetImage('assets/images/patient.png'),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Text(
            'James Adebayo',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _metaRow() {
    return Row(
      children: [
        Icon(
          isVideo ? Icons.videocam : Icons.location_on,
          size: 16,
          color: Colors.grey,
        ),
        const SizedBox(width: 6),
        Text(
          isVideo ? 'Video Call' : 'In Person',
          style: const TextStyle(fontSize: 13, color: Colors.grey),
        ),
        const SizedBox(width: 12),
        const Icon(Icons.access_time, size: 16, color: Colors.grey),
        const SizedBox(width: 6),
        const Text(
          'Tomorrow, 2:00 PM',
          style: TextStyle(fontSize: 13, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _symptomPreview() {
    return const Text(
      'Experiencing chest pain and shortness of breath for 2 days. '
      'Pain is mild to moderate, occurs mostly during physical activity. '
      'Also feeling occasional dizziness...',
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
    );
  }

  Widget _actions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _confirmButton(context),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _rescheduleButton(
            onTap: () => context.goNextScreen(
              AppRoutes.rescheduleOnSpecialist,
            ),
          ),
        ),
      ],
    );
  }

  Widget _confirmButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showThankYouDialog(context,
            title: "Appointment confirm",
            message:
                "The appointment has been confirmed and the user has been notified",
            buttonText: "Done", onContinue: () {
          context.goNextScreenWithData(AppRoutes.specialistAppointDetailScreen,
              extra: AppConstants.appointmentRequest);
        });
      },
      child: Container(
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFF15803D),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'Confirm',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _rescheduleButton({required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: const Text(
          'Re-schedule',
          style: TextStyle(
            color: AppColors.red,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

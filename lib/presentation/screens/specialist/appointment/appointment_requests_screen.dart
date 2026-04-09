import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/data/models/appointment/appointment_model.dart';
import 'package:HealthBridge/presentation/providers/appointment_provider.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAppointmentRequests();
    });
  }

  Future<void> _loadAppointmentRequests() async {
    final provider = context.read<AppointmentProvider>();
    await provider.getAppointments('specialist', status: 'created');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Appointment Requests',
        showArrow: widget.showBackArrow ?? false,
      ),
      backgroundColor: AppColors.backgroundGray,
      body: SafeArea(
        child: Consumer<AppointmentProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final requests = (provider.appointments ?? [])
                .where((a) => a.status == 'created')
                .toList();

            if (requests.isEmpty) {
              return const Center(
                child: Text(
                  'No pending appointment requests',
                  style: TextStyle(color: Color(0xFF6B7280)),
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: requests.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (_, index) {
                return AppointmentRequestCard(appointment: requests[index]);
              },
            );
          },
        ),
      ),
    );
  }
}

/// ======================================================
/// Appointment Request Card
/// ======================================================
class AppointmentRequestCard extends StatelessWidget {
  final AppointmentModel appointment;

  const AppointmentRequestCard({
    super.key,
    required this.appointment,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.goNextScreenWithData(AppRoutes.specialistAppointDetailScreen,
            extra: appointment);
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
        Expanded(
          child: Text(
            appointment.userName.isNotEmpty && appointment.userName != 'Unknown'
                ? appointment.userName
                : appointment.userId ?? 'Unknown',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _metaRow() {
    final isVideo =
        appointment.appointmentType.toLowerCase().contains('video');
    final formattedTime =
        DateFormat('MMM d, h:mm a').format(appointment.scheduledTime);

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
        Expanded(
          child: Text(
            formattedTime,
            style: const TextStyle(fontSize: 13, color: Colors.grey),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _symptomPreview() {
    // Placeholder since model doesn't have description field
    return const Text(
      'Appointment request - tap to view details',
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
          child: _rescheduleButton(context),
        ),
      ],
    );
  }

  Widget _confirmButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.goNextScreenWithData(AppRoutes.specialistAppointDetailScreen,
            extra: appointment);
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

  Widget _rescheduleButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.goNextScreenWithData(AppRoutes.rescheduleOnSpecialist,
            extra: appointment);
      },
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

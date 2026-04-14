import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/constants/app_routes.dart';
import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/core/utils/dialog.dart';
import 'package:HealthBridge/core/utils/snackbar_utils.dart';
import 'package:HealthBridge/data/models/appointment/appointment_model.dart';
import 'package:HealthBridge/presentation/providers/appointment_provider.dart';
import 'package:HealthBridge/presentation/providers/specialist_provider.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SpecialistAppointmentsScreen extends StatefulWidget {
  final bool? showArrow;

  const SpecialistAppointmentsScreen({super.key, this.showArrow});

  @override
  State<SpecialistAppointmentsScreen> createState() =>
      _SpecialistAppointmentsScreenState();
}

class _SpecialistAppointmentsScreenState
    extends State<SpecialistAppointmentsScreen> {
  int selectedTab = 0;
  bool _isFirstLoad = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAppointments();
    });
  }

  Future<void> _loadAppointments() async {
    final specialistProvider = context.read<SpecialistProvider>();
    final appointmentProvider = context.read<AppointmentProvider>();

    // Check if we already have data loaded
    final hasData = appointmentProvider.appointments != null &&
        appointmentProvider.appointments!.isNotEmpty;

    final specialistId = specialistProvider.specialistProfileM?.userId;
    if (specialistId != null && specialistId.isNotEmpty) {
      if (_isFirstLoad || !hasData) {
        _isFirstLoad = false;
        // First load - wait for data to show
        await appointmentProvider.getAllAppointmentsBySpecialistId(specialistId);
      } else {
        // Data already loaded, refresh in background without awaiting
        appointmentProvider.getAllAppointmentsBySpecialistId(specialistId);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: "Appointments", showArrow: widget.showArrow ?? false),
      backgroundColor: AppColors.backgroundGray,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            _tabs(),
            Expanded(
              child: Consumer<AppointmentProvider>(
                builder: (context, provider, _) {
                  final all = provider.appointments ?? [];

                  // Only show loading if we have no data yet and still loading
                  if (all.isEmpty && provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final List<AppointmentModel> list;
                  if (selectedTab == 0) {
                    list = all
                        .where((a) =>
                            a.status == 'confirmed' ||
                            a.status == 'rescheduled' ||
                            a.status == 'created')
                        .toList()
                      ..sort(
                          (a, b) => a.scheduledTime.compareTo(b.scheduledTime));
                  } else if (selectedTab == 1) {
                    list = all.where((a) => a.status == 'completed').toList()
                      ..sort(
                          (a, b) => b.scheduledTime.compareTo(a.scheduledTime));
                  } else {
                    list = all.where((a) => a.status == 'cancelled').toList()
                      ..sort(
                          (a, b) => b.scheduledTime.compareTo(a.scheduledTime));
                  }

                  if (list.isEmpty) {
                    return Center(
                      child: Text(
                        selectedTab == 0
                            ? 'No upcoming appointments'
                            : selectedTab == 1
                                ? 'No completed appointments'
                                : 'No missed appointments',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () => provider.getAllAppointments('patient'),
                    color: AppColors.red,
                    child: ListView.separated(
                      padding: const EdgeInsets.all(20),
                      itemCount: list.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (_, index) {
                        return _appointmentCard(list[index]);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          _tabItem('Up Coming', 0),
          _tabItem('Completed', 1),
          _tabItem('Missed', 2),
        ],
      ),
    );
  }

  Widget _tabItem(String text, int index) {
    final selected = selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: selected ? AppColors.red : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: selected ? Colors.white : Colors.black,
              fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _appointmentCard(AppointmentModel appointment) {
    String formattedDate = 'N/A';
    String formattedTime = 'N/A';
    try {
      formattedDate =
          DateFormat('MMM d, yyyy').format(appointment.scheduledTime);
      formattedTime = DateFormat('h:mm a').format(appointment.scheduledTime);
    } catch (_) {}

    final isUpcoming = selectedTab == 0;

    return GestureDetector(
      onTap: () => context.goNextScreenWithData(
        AppRoutes.specialistAppointDetailScreen,
        extra: appointment,
      ),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage('assets/images/patient.png'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Patient Appointment',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            '$formattedDate • $formattedTime',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (appointment.status == 'created')
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Pending',
                      style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFFD97706),
                          fontWeight: FontWeight.w600),
                    ),
                  ),
              ],
            ),
            if (isUpcoming) ...[
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _actionButton(
                      'Re-Schedule',
                      AppColors.red,
                      Colors.white,
                      onTap: () => context.goNextScreenWithData(
                        AppRoutes.rescheduleOnSpecialist,
                        extra: appointment,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _actionButton(
                      'Cancel',
                      const Color(0xFFFDECEC),
                      AppColors.red,
                      onTap: () => showConfirmDialog(
                        context,
                        title: 'Cancel Appointment?',
                        message:
                            "Are you sure you want to cancel this appointment?",
                        confirmText: 'Yes, Cancel',
                        cancelText: 'Keep',
                        icon: Icons.question_mark,
                        onConfirm: () async {
                          final provider = context.read<AppointmentProvider>();
                          final error = await provider.cancelAppointment(
                            appointment.id,
                            'Cancelled by specialist',
                            appointmentType: 'patient',
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
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _actionButton(
    String text,
    Color bg,
    Color textColor, {
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
          border: textColor == AppColors.red
              ? Border.all(color: AppColors.red)
              : null,
        ),
        child: Text(
          text,
          style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/constants/app_routes.dart';
import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/core/utils/dialog.dart';
import 'package:HealthBridge/core/utils/snackbar_utils.dart';
import 'package:HealthBridge/data/models/appointment/appointment_model.dart';
import 'package:HealthBridge/presentation/providers/appointment_provider.dart';
import 'package:HealthBridge/presentation/providers/specialist_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SpecialistHomeScreen extends StatefulWidget {
  const SpecialistHomeScreen({super.key});

  @override
  State<SpecialistHomeScreen> createState() => _SpecialistHomeScreenState();
}

class _SpecialistHomeScreenState extends State<SpecialistHomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  Future<void> _loadData() async {
    await Future.wait([
      context.read<SpecialistProvider>().getSpecialistProfile(),
      context.read<AppointmentProvider>().getAllAppointments('patient'),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<SpecialistProvider, AppointmentProvider>(
      builder: (context, specialistProvider, appointmentProvider, _) {
        final profile = specialistProvider.specialistProfileM;
        final all = appointmentProvider.appointments ?? [];

        final upcoming = all
            .where((a) =>
                a.status == 'confirmed' || a.status == 'rescheduled')
            .toList()
          ..sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));

        final nextAppointment = upcoming.isNotEmpty ? upcoming.first : null;
        final upcomingList = upcoming.take(3).toList();

        final recentActivity = all
            .where(
                (a) => a.status == 'completed' || a.status == 'cancelled')
            .toList()
          ..sort((a, b) => b.scheduledTime.compareTo(a.scheduledTime));

        return Scaffold(
          backgroundColor: AppColors.backgroundGray,
          body: RefreshIndicator(
            onRefresh: _loadData,
            color: AppColors.red,
            child: Column(
              children: [
                _buildHeader(profile),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),

                        /// Next Appointment
                        _sectionTitle('Next Appointment'),
                        const SizedBox(height: 12),
                        appointmentProvider.isLoading
                            ? const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(20),
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : nextAppointment != null
                                ? _nextAppointmentCard(nextAppointment)
                                : _emptyCard('No upcoming appointments'),

                        const SizedBox(height: 24),

                        /// Appointment Requests (seed data)
                        _sectionHeader(
                          'Appointment Requests',
                          onPress: () => context.goNextScreenWithData(
                            AppRoutes.specialistRequestScreen,
                            extra: true,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _requestCard(
                          name: 'James Adebayo',
                          info: 'Video Call • Tomorrow, 2:00 PM',
                        ),
                        const SizedBox(height: 12),
                        _requestCard(
                          name: 'Amaka Okonkwo',
                          info: 'Audio Call • Friday, 10:00 AM',
                        ),

                        const SizedBox(height: 24),

                        /// Upcoming Appointments
                        _sectionHeader(
                          'Upcoming Appointments',
                          onPress: () => context.goNextScreenWithData(
                            AppRoutes.appointmentTapOnSpecialist,
                            extra: true,
                          ),
                        ),
                        const SizedBox(height: 12),

                        if (upcomingList.isEmpty &&
                            !appointmentProvider.isLoading)
                          _emptyCard('No upcoming appointments')
                        else
                          ...upcomingList.map((apt) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _upcomingCard(apt),
                              )),

                        const SizedBox(height: 24),

                        /// Recent Activity
                        _sectionTitle('Recent Activity'),
                        const SizedBox(height: 12),

                        if (recentActivity.isEmpty &&
                            !appointmentProvider.isLoading)
                          _emptyCard('No recent activity')
                        else
                          ...recentActivity.take(3).map((apt) {
                            final isCompleted = apt.status == 'completed';
                            return _activityItem(
                              icon: isCompleted
                                  ? Icons.check_circle
                                  : Icons.cancel_outlined,
                              color: isCompleted
                                  ? AppColors.green
                                  : AppColors.red,
                              title: isCompleted
                                  ? 'Consultation completed'
                                  : 'Appointment cancelled',
                              time: _timeAgo(apt.scheduledTime),
                            );
                          }),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(dynamic profile) {
    final firstName = profile?.firstName as String? ?? '';
    final imageUrl = profile?.imageUrl as String?;

    return Container(
      color: Colors.white,
      padding:
          const EdgeInsets.only(left: 20, right: 20, bottom: 16, top: 35),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.goNextScreenWithData(
              AppRoutes.specialistProfile,
              extra: true,
            ),
            child: CircleAvatar(
              radius: 22,
              backgroundImage: imageUrl != null
                  ? NetworkImage(imageUrl) as ImageProvider
                  : const AssetImage('assets/images/patient.png'),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                firstName.isNotEmpty
                    ? 'Hello, Dr $firstName'
                    : 'Hello, Doctor',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Text(
                'Your schedule at a glance.',
                style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
              ),
            ],
          ),
          const Spacer(),
          Stack(
            children: [
              const Icon(Icons.notifications_none, size: 26),
              Positioned(
                right: 2,
                top: 2,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _nextAppointmentCard(AppointmentModel apt) {
    final date = DateFormat('EEEE, MMMM d').format(apt.scheduledTime);
    final time = DateFormat('hh:mm a').format(apt.scheduledTime);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFB00000),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 22,
                backgroundImage: AssetImage('assets/images/patient.png'),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Patient Appointment',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    apt.appointmentType.toUpperCase(),
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                    color: Colors.white24, shape: BoxShape.circle),
                child:
                    const Icon(Icons.videocam, color: Colors.white),
              ),
            ],
          ),
          const Divider(color: Colors.white24, height: 24),
          Row(
            children: [
              Expanded(child: _Info(label: 'Date', value: date)),
              Expanded(child: _Info(label: 'Time', value: time)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _outlinedButton(
                  'Re-Schedule',
                  Colors.white,
                  AppColors.red,
                  onTap: () => context.goNextScreenWithData(
                    AppRoutes.rescheduleOnSpecialist,
                    extra: apt,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _filledButton(
                  'View Details',
                  Colors.white24,
                  onTap: () => context.goNextScreenWithData(
                    AppRoutes.specialistAppointDetailScreen,
                    extra: apt,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _upcomingCard(AppointmentModel apt) {
    final dateTime =
        DateFormat('MMM d • h:mm a').format(apt.scheduledTime);

    return GestureDetector(
      onTap: () => context.goNextScreenWithData(
        AppRoutes.specialistAppointDetailScreen,
        extra: apt,
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
                  backgroundImage:
                      AssetImage('assets/images/patient.png'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Patient Appointment',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 14),
                          const SizedBox(width: 4),
                          Text(dateTime,
                              style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
                if (apt.status == 'rescheduled')
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Rescheduled',
                      style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFF3B82F6),
                          fontWeight: FontWeight.w600),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _filledButton(
                    'Re-Schedule',
                    AppColors.red,
                    onTap: () => context.goNextScreenWithData(
                      AppRoutes.rescheduleOnSpecialist,
                      extra: apt,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _outlinedButton(
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
                        final error = await context
                            .read<AppointmentProvider>()
                            .cancelAppointment(
                              apt.id,
                              'Cancelled by specialist',
                              appointmentType: 'patient',
                            );
                        if (mounted) {
                          error != null
                              ? SnackBarUtils.showError(context, error)
                              : SnackBarUtils.showSuccess(
                                  context, 'Appointment cancelled');
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _requestCard({required String name, required String info}) {
    return GestureDetector(
      onTap: () => context.goNextScreenWithData(
        AppRoutes.specialistAppointDetailScreen,
        extra: null,
      ),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                        style:
                            const TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.videocam, size: 14),
                        const SizedBox(width: 4),
                        Text(info,
                            style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _filledButton(
                    'Confirm',
                    AppColors.green,
                    onTap: () => showThankYouDialog(
                      context,
                      title: 'Appointment Confirmed',
                      message:
                          'The appointment has been confirmed and the patient has been notified.',
                      buttonText: 'Done',
                      onContinue: () {},
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _outlinedButton(
                    'Re-schedule',
                    AppColors.backgroundGray,
                    AppColors.red,
                    onTap: () => context.goNextScreen(
                      AppRoutes.rescheduleOnSpecialist,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyCard(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontSize: 13, color: Color(0xFF6B7280)),
      ),
    );
  }

  Widget _activityItem({
    required IconData icon,
    required Color color,
    required String title,
    required String time,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
                color: color.withOpacity(.15),
                shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style:
                        const TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text(time,
                    style: const TextStyle(
                        fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(title,
        style: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.w600));
  }

  Widget _sectionHeader(String title,
      {required VoidCallback onPress}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _sectionTitle(title),
        GestureDetector(
          onTap: onPress,
          child: const Text('View All',
              style:
                  TextStyle(fontSize: 13, color: AppColors.red)),
        ),
      ],
    );
  }

  Widget _filledButton(String text, Color color,
      {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10)),
        child: Text(text,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500)),
      ),
    );
  }

  Widget _outlinedButton(String text, Color bg, Color textColor,
      {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: textColor),
        ),
        child: Text(text,
            style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w500)),
      ),
    );
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'Just now';
  }
}

class _Info extends StatelessWidget {
  final String label;
  final String value;

  const _Info({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: Colors.white70, fontSize: 12)),
        const SizedBox(height: 2),
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500)),
      ],
    );
  }
}

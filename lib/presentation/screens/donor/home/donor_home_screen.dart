import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/constants/app_routes.dart';
import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/core/utils/dialog.dart';
import 'package:HealthBridge/data/models/appointment/appointment_model.dart';
import 'package:HealthBridge/presentation/providers/appointment_provider.dart';
import 'package:HealthBridge/presentation/providers/hospital_provider.dart';
import 'package:HealthBridge/presentation/providers/patient_provider.dart';
import 'package:HealthBridge/presentation/widgets/cancel_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DonorHomeScreen extends StatefulWidget {
  const DonorHomeScreen({super.key});

  @override
  State<DonorHomeScreen> createState() => _DonorHomeScreenState();
}

class _DonorHomeScreenState extends State<DonorHomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final patientProvider = context.read<PatientProvider>();
    final hospitalProvider = context.read<HospitalProvider>();
    final appointmentProvider = context.read<AppointmentProvider>();

    // Load donor profile to get donor ID
    await patientProvider.getPatientOrDonorProfile();
    final donorId = patientProvider.patientProfileM?.id;

    if (donorId != null) {
      // Load stats and history in parallel with upcoming appointment
      await Future.wait([
        hospitalProvider.loadDonorData(donorId),
        appointmentProvider.getAppointments('donor', timeline: 'upcoming'),
      ]);
    } else {
      // Still load appointments if donor ID unavailable
      await appointmentProvider.getAppointments('donor', timeline: 'upcoming');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      body: Column(
        children: [
          /// FIXED HEADER
          _buildHeader(),

          /// SCROLLABLE CONTENT
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadData,
              color: AppColors.red,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),

                    /// Hero Banner
                    _buildHeroBanner(),
                    const SizedBox(height: 20),

                    /// Action Cards Row
                    _buildActionCards(),
                    const SizedBox(height: 24),

                    /// Stats Row
                    _buildStatsSection(),
                    const SizedBox(height: 24),

                    /// Next Appointment
                    _sectionTitle('Your next Appointment'),
                    const SizedBox(height: 12),
                    _buildNextAppointmentCard(),
                    const SizedBox(height: 24),

                    /// Nearby Blood Requests
                    _sectionTitle('Nearby Blood Requests'),
                    const SizedBox(height: 12),
                    _buildBloodRequestCard(isUrgent: true),
                    const SizedBox(height: 12),
                    _buildBloodRequestCard(isUrgent: false),
                    const SizedBox(height: 12),
                    _buildBloodRequestCard(isUrgent: false),
                    const SizedBox(height: 24),

                    /// Your Impact
                    _buildYourImpactSection(),
                    const SizedBox(height: 24),

                    /// Tips & Safety
                    _buildTipsSection(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Consumer<PatientProvider>(
      builder: (context, patientProvider, _) {
        final firstName = patientProvider.patientProfileM?.firstName ?? 'there';
        return Container(
          color: Colors.white,
          padding:
              const EdgeInsets.only(left: 20, right: 20, bottom: 16, top: 35),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.green.withOpacity(0.1),
                child: Text(
                  firstName.isNotEmpty ? firstName[0].toUpperCase() : 'D',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.green,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, $firstName',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Text(
                    'Ready to make a difference today?',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  context.goNextScreen(AppRoutes.donorNotification);
                },
                child: Stack(
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
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeroBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0x1AB60000),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'A Small Act. A Big Impact.',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'See blood requests around you and donate when you\'re ready.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      context.goNextScreen(AppRoutes.nearbyHospitals);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Donate Now',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.red,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.medical_services,
              color: Colors.white,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCards() {
    return Row(
      children: [
        Expanded(
          child: _actionCard(
            icon: Icons.search,
            iconColor: AppColors.red,
            title: 'Find a Hospital Request',
            subtitle: 'See blood requests around you.',
            onTap: () {
              context.goNextScreen(AppRoutes.nearbyHospitals);
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _actionCard(
            icon: Icons.calendar_today,
            iconColor: AppColors.green,
            title: 'Book a Donation',
            subtitle: 'Choose a hospital and book a visit.',
            onTap: () {
              context.goNextScreen(AppRoutes.nearbyHospitals);
            },
          ),
        ),
      ],
    );
  }

  Widget _actionCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 160,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              maxLines: 2,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              maxLines: 2,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    return Consumer<HospitalProvider>(
      builder: (context, hospitalProvider, _) {
        final stats = hospitalProvider.donorStats;
        final history = hospitalProvider.donorHistory;

        // Get last completed donation date
        String lastDonation = 'No donations yet';
        final completed =
            history.where((d) => d.isCompleted && d.date != null).toList();
        if (completed.isNotEmpty) {
          completed.sort((a, b) => b.date!.compareTo(a.date!));
          lastDonation = completed.first.formattedDate;
        }

        final donationCount = stats?.totalDonations ?? 0;
        final bloodType = stats?.formattedBloodType ?? '—';
        final volume = stats?.formattedVolume ?? '0.0L';

        return Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    width: 1,
                    color: const Color(0xFF6B7280).withOpacity(0.10),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Donation Count',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$donationCount',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.green,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Blood Type: $bloodType',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  _smallStatCard('Last Donation', lastDonation),
                  const SizedBox(height: 7),
                  _unitsDonatedCard(volume),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _smallStatCard(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _unitsDonatedCard(String volume) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Volume Donated',
            style: TextStyle(
              fontSize: 10,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                volume,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Text(
                'Keep it up!',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNextAppointmentCard() {
    return Consumer<AppointmentProvider>(
      builder: (context, appointmentProvider, _) {
        if (appointmentProvider.isLoading) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        // Get the nearest upcoming appointment
        final upcoming = (appointmentProvider.appointments ?? [])
            .where((a) =>
                a.status == 'confirmed' || a.status == 'rescheduled')
            .toList();

        if (upcoming.isEmpty) {
          return GestureDetector(
            onTap: () => context.goNextScreen(AppRoutes.nearbyHospitals),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  Icon(Icons.calendar_today,
                      size: 40, color: Colors.grey[300]),
                  const SizedBox(height: 12),
                  const Text(
                    'No upcoming appointments',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Book a donation to get started',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Sort by scheduled time and take the nearest one
        upcoming.sort(
            (a, b) => a.scheduledTime.compareTo(b.scheduledTime));
        final next = upcoming.first;

        String formattedTime = 'N/A';
        String formattedDate = 'N/A';
        try {
          formattedTime = DateFormat('h:mm a').format(next.scheduledTime);
          formattedDate =
              DateFormat('MMM d').format(next.scheduledTime);
        } catch (_) {}

        return GestureDetector(
          onTap: () => context.goNextScreenWithData(
              AppRoutes.donorAppointmentDetail,
              extra: next),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.local_hospital,
                          color: AppColors.green, size: 28),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            next.specialistId.isNotEmpty
                                ? 'Specialist Appointment'
                                : 'Blood Donation Appointment',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Ref: ${next.id.substring(0, 8)}...',
                            style: const TextStyle(
                              fontSize: 11,
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
                            child: _appointmentInfo(
                                'Status',
                                next.status == 'rescheduled'
                                    ? 'Rescheduled'
                                    : 'Confirmed'),
                          ),
                          Expanded(
                            child: _appointmentInfo('Time', formattedTime),
                          ),
                          Expanded(
                            child: _appointmentInfo('Date', formattedDate),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      CancelButton(
                        text: 'Cancel',
                        onPressed: () {
                          showConfirmDialog(
                            context,
                            title: "Cancel Appointment",
                            cancelText: "Keep Appointment",
                            confirmText: "Yes, Cancel Appointment",
                            message:
                                "Are you sure you want to cancel this appointment? You won't be able to undo this action.",
                            onConfirm: () {
                              _cancelAppointment(next);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _cancelAppointment(AppointmentModel appointment) async {
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
          title: 'Cancelled',
          message: 'Your appointment has been cancelled successfully',
          buttonText: 'Done',
          onContinue: () {},
        );
      }
    }
  }

  Widget _appointmentInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildBloodRequestCard({required bool isUrgent}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isUrgent
                  ? const Color(0xFFFEE2E2)
                  : const Color(0xFFDCFCE7),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              isUrgent ? 'Urgent' : 'Standard',
              style: TextStyle(
                fontSize: 10,
                color: isUrgent ? AppColors.red : AppColors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.local_hospital,
                    color: AppColors.red, size: 22),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nearby Hospital',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Tap "Donate Now" to view details',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.water_drop, size: 14, color: AppColors.red),
                    SizedBox(width: 4),
                    Text(
                      '3 units',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  context.goNextScreen(AppRoutes.nearbyHospitals);
                },
                child: const Text(
                  'Donate Now',
                  style: TextStyle(
                    color: AppColors.red,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildYourImpactSection() {
    return Consumer<HospitalProvider>(
      builder: (context, hospitalProvider, _) {
        final stats = hospitalProvider.donorStats;
        final totalDonations = stats?.totalDonations ?? 0;
        final totalLitres = stats?.totalLitresDonated ?? 0.0;

        // Progress toward next milestone (every 5 donations)
        final nextMilestone =
            ((totalDonations ~/ 5) + 1) * 5;
        final progress =
            totalDonations == 0 ? 0.0 : (totalDonations % 5) / 5.0;

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/impart_icon_.png',
                width: 40,
                height: 40,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.favorite,
                  color: AppColors.red,
                  size: 40,
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'Your Impact',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Volume Donated: ${totalLitres.toStringAsFixed(1)}L',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.red,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Next Milestone: $nextMilestone Donations',
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: const Color(0xFFF3F4F6),
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(AppColors.red),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                totalDonations == 0
                    ? 'Make your first donation today!'
                    : '$totalDonations donation${totalDonations == 1 ? '' : 's'} — keep saving lives!',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTipsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tips & Safety',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _tipItem('Eat before donating for steady energy'),
          const SizedBox(height: 12),
          _tipItem('Stay hydrated 24 hours before donation'),
          const SizedBox(height: 12),
          _tipItem('Avoid strenuous exercises on donation day'),
        ],
      ),
    );
  }

  Widget _tipItem(String text) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: const BoxDecoration(
            color: AppColors.green,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check,
            size: 16,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF374151),
            ),
          ),
        ),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }
}

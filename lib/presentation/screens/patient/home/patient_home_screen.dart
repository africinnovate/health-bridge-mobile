import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/constants/app_routes.dart';
import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/core/utils/dialog.dart';
import 'package:HealthBridge/core/utils/snackbar_utils.dart';
import 'package:HealthBridge/data/models/appointment/appointment_model.dart';
import 'package:HealthBridge/data/models/specialist/specialist_profile_model.dart';
import 'package:HealthBridge/presentation/providers/appointment_provider.dart';
import 'package:HealthBridge/presentation/providers/patient_provider.dart';
import 'package:HealthBridge/presentation/providers/specialist_provider.dart';
import 'package:HealthBridge/presentation/widgets/cancel_button.dart';
import 'package:HealthBridge/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PatientHomeScreen extends StatefulWidget {
  final Function(int)? onNavigateToTab;

  const PatientHomeScreen({super.key, this.onNavigateToTab});

  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  List<String> _recentlyViewedIds = [];
  static const String _recentlyViewedKey = 'recently_viewed_specialists';

  final List<Map<String, dynamic>> quickActions = [
    {
      'icon': Icons.calendar_today,
      'iconColor': const Color(0xFF3B82F6),
      'iconBg': const Color(0xFFEFF6FF),
      'title': 'Book Consultation',
      'subtitle': 'Find a specialist and schedule',
    },
    {
      'icon': Icons.description,
      'iconColor': AppColors.green,
      'iconBg': const Color(0xFFDCFCE7),
      'title': 'My Care History',
      'subtitle': 'View past consultations',
    },
    // {
    //   'icon': Icons.person_search,
    //   'iconColor': const Color(0xFF8B5CF6),
    //   'iconBg': const Color(0xFFF3E8FF),
    //   'title': 'Find Specialist',
    //   'subtitle': 'Browse by specialty',
    // },
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final appointmentProvider = context.read<AppointmentProvider>();
    final specialistProvider = context.read<SpecialistProvider>();

    await Future.wait([
      appointmentProvider.getAppointments('patient', timeline: 'upcoming'),
      specialistProvider.getSpecialists(verified: true),
      specialistProvider.getSpecialties(),
    ]);

    await _loadRecentlyViewed();
  }

  Future<void> _loadRecentlyViewed() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList(_recentlyViewedKey) ?? [];
    if (mounted) {
      setState(() => _recentlyViewedIds = ids);
    }
  }

  String _getSpecialtyName(SpecialistProfileModel specialist) {
    final provider = context.read<SpecialistProvider>();
    try {
      return provider.specialties
          .firstWhere((s) => s.id == specialist.specialtyId)
          .name;
    } catch (_) {
      return 'Specialist';
    }
  }

  List<SpecialistProfileModel> get _recentlyViewedSpecialists {
    final provider = context.read<SpecialistProvider>();
    return _recentlyViewedIds
        .map((id) {
          try {
            return provider.specialists.firstWhere((s) => s.id == id);
          } catch (_) {
            return null;
          }
        })
        .whereType<SpecialistProfileModel>()
        .toList();
  }

  List<SpecialistProfileModel> get _nearbySpecialists {
    final all = context.read<SpecialistProvider>().specialists;
    final sorted = [...all]..sort((a, b) {
        if (a.rate == null && b.rate == null) return 0;
        if (a.rate == null) return 1;
        if (b.rate == null) return -1;
        return b.rate!.compareTo(a.rate!);
      });
    return sorted.take(4).toList();
  }

  AppointmentModel? get _nextAppointment {
    final all = context.read<AppointmentProvider>().appointments ?? [];
    final upcoming = all
        .where((a) => a.status == 'confirmed' || a.status == 'rescheduled')
        .toList();
    if (upcoming.isEmpty) return null;
    upcoming.sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));
    return upcoming.first;
  }

  SpecialistProfileModel? _findSpecialist(String specialistId) {
    if (specialistId.isEmpty) return null;
    final provider = context.read<SpecialistProvider>();
    try {
      return provider.specialists.firstWhere((s) => s.id == specialistId);
    } catch (_) {
      return null;
    }
  }

  Future<void> _onSpecialistTap(SpecialistProfileModel specialist) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> ids = prefs.getStringList(_recentlyViewedKey) ?? [];
    ids.remove(specialist.id);
    ids.insert(0, specialist.id);
    if (ids.length > 5) ids = ids.take(5).toList();
    await prefs.setStringList(_recentlyViewedKey, ids);
    if (mounted) {
      setState(() => _recentlyViewedIds = ids);
      context.goNextScreenWithData(AppRoutes.specialistDetails,
          extra: specialist);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      body: Consumer3<PatientProvider, AppointmentProvider, SpecialistProvider>(
        builder: (context, patientProvider, appointmentProvider,
            specialistProvider, _) {
          return Column(
            children: [
              _buildHeader(patientProvider),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _loadData,
                  color: AppColors.green,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        _buildHeroBanner(),
                        const SizedBox(height: 20),

                        /// Quick Actions
                        _buildQuickActions(),
                        const SizedBox(height: 32),

                        /// Recently Viewed
                        if (_recentlyViewedSpecialists.isNotEmpty) ...[
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              'Recently Viewed',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildRecentViewed(),
                          const SizedBox(height: 32),
                        ],

                        /// Your Next Appointment
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Your next Appointment',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildNextAppointmentCard(appointmentProvider),
                        const SizedBox(height: 24),

                        /// Nearby Specialists
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Nearby Specialists',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  context.goNextScreenWithData(
                                    AppRoutes.allSpecialists,
                                    extra: specialistProvider.specialists,
                                  );
                                },
                                child: const Text(
                                  'See all',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildNearbySpecialists(specialistProvider),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(PatientProvider patientProvider) {
    final firstName = patientProvider.patientProfileM?.firstName;
    final greetingName =
        (firstName != null && firstName.isNotEmpty) ? firstName : null;

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 16, top: 35),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.green.withOpacity(0.1),
            child: Text(
              greetingName != null ? greetingName[0].toUpperCase() : 'P',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.green,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greetingName != null ? 'Hello, $greetingName' : 'Hello there',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Here\'s your health activity at a glance',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () =>
                context.goNextScreen(AppRoutes.patientNotification),
            icon: Stack(
              children: [
                const Icon(Icons.notifications_outlined, size: 24),
                Positioned(
                  right: 0,
                  top: 0,
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
          ),
        ],
      ),
    );
  }

  Widget _buildHeroBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Health\nMatters',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Get quick access to licensed specialists—any time you need care.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 16),
                CustomButton(
                  color: AppColors.green,
                  shouldFullScreen: false,
                  onPressed: () => widget.onNavigateToTab?.call(2),
                  text: 'Get Medical Help',
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.green,
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

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.2,
        ),
        itemCount: quickActions.length,
        itemBuilder: (context, index) {
          final action = quickActions[index];
          return _quickActionCard(
            icon: action['icon'] as IconData,
            iconColor: action['iconColor'] as Color,
            iconBg: action['iconBg'] as Color,
            title: action['title'] as String,
            subtitle: action['subtitle'] as String,
            onTap: () {
              if (action['title'] == 'Book Consultation' ||
                  action['title'] == 'Find Specialist') {
                widget.onNavigateToTab?.call(2);
              } else {
                context.goNextScreen(AppRoutes.careHistory);
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildRecentViewed() {
    final items = _recentlyViewedSpecialists;
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final specialist = items[index];
          return GestureDetector(
            onTap: () => _onSpecialistTap(specialist),
            child: Container(
              width: 190,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: specialist.imageUrl != null
                        ? NetworkImage(specialist.imageUrl!) as ImageProvider
                        : const AssetImage('assets/images/patient.png'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Dr. ${specialist.firstName}',
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          _getSpecialtyName(specialist),
                          style: const TextStyle(
                              fontSize: 11, color: Color(0xFF6B7280)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (specialist.rate != null) ...[
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              const Icon(Icons.star,
                                  color: Color(0xFFFBBF24), size: 12),
                              const SizedBox(width: 2),
                              Text(
                                specialist.rate!.toStringAsFixed(1),
                                style: const TextStyle(
                                    fontSize: 11, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNextAppointmentCard(AppointmentProvider appointmentProvider) {
    if (appointmentProvider.isLoading) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final appointment = _nextAppointment;

    if (appointment == null) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            const Icon(Icons.calendar_today_outlined,
                size: 40, color: Color(0xFF9CA3AF)),
            const SizedBox(height: 12),
            const Text(
              'No upcoming appointments',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF6B7280)),
            ),
            const SizedBox(height: 16),
            CustomButton(
              color: AppColors.green,
              shouldFullScreen: false,
              onPressed: () => widget.onNavigateToTab?.call(2),
              text: 'Book Appointment',
            ),
          ],
        ),
      );
    }

    final specialist = appointment.specialistId != null
        ? _findSpecialist(appointment.specialistId!)
        : null;
    final specialistName = specialist != null
        ? 'Dr. ${specialist.firstName} ${specialist.lastName}'
        : 'Specialist';
    final specialtyName =
        specialist != null ? _getSpecialtyName(specialist) : 'Consultation';
    final isSpecialist = appointment.specialistId?.isNotEmpty ?? false;
    final consultationType = isSpecialist ? 'Specialist' : 'Blood Donation';

    String formattedDate = 'N/A';
    String formattedTime = 'N/A';
    try {
      formattedDate = DateFormat('MMM d').format(appointment.scheduledTime);
      formattedTime = DateFormat('h:mm a').format(appointment.scheduledTime);
    } catch (_) {}

    return GestureDetector(
      onTap: () => context.goNextScreenWithData(
          AppRoutes.patientAppointmentDetail,
          extra: appointment),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: specialist?.imageUrl != null
                      ? NetworkImage(specialist!.imageUrl!) as ImageProvider
                      : const AssetImage('assets/images/patient.png'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        specialistName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        specialtyName,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Confirmed',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.green,
                    ),
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
                        child: _appointmentInfo('Type', consultationType),
                      ),
                      Container(
                          width: 1, height: 30, color: const Color(0xFFE5E7EB)),
                      Expanded(
                        child: _appointmentInfo('Date', formattedDate),
                      ),
                      Container(
                          width: 1, height: 30, color: const Color(0xFFE5E7EB)),
                      Expanded(
                        child: _appointmentInfo('Time', formattedTime),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  CancelButton(
                    text: 'Cancel',
                    onPressed: () => _handleCancelAppointment(appointment),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNearbySpecialists(SpecialistProvider specialistProvider) {
    if (specialistProvider.isLoading) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final items = _nearbySpecialists;

    if (items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          'No specialists available',
          style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.65,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final specialist = items[index];
          return GestureDetector(
            onTap: () => _onSpecialistTap(specialist),
            child: _specialistCard(specialist),
          );
        },
      ),
    );
  }

  void _handleCancelAppointment(AppointmentModel appointment) {
    showConfirmDialog(
      context,
      title: 'Cancel Appointment',
      cancelText: 'Keep Appointment',
      confirmText: 'Yes, Cancel',
      message:
          "Are you sure you want to cancel this appointment? You won't be able to undo this action.",
      onConfirm: () async {
        final appointmentProvider = context.read<AppointmentProvider>();
        final error = await appointmentProvider.cancelAppointment(
          appointment.id,
          'Cancelled by user',
          appointmentType: 'patient',
        );
        if (mounted) {
          if (error == null) {
            SnackBarUtils.showSuccess(context, 'Appointment cancelled');
          } else {
            SnackBarUtils.showError(context, error);
          }
        }
      },
    );
  }

  Widget _quickActionCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _appointmentInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _specialistCard(SpecialistProfileModel specialist) {
    final specialty = _getSpecialtyName(specialist);
    String availabilityText = 'On schedule';
    if (specialist.availability.isNotEmpty) {
      final first = specialist.availability.first;
      availabilityText =
          '${first.dayOfWeek} • ${first.opensAt} - ${first.closesAt}';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: 32,
                backgroundImage: specialist.imageUrl != null
                    ? NetworkImage(specialist.imageUrl!) as ImageProvider
                    : const AssetImage('assets/images/patient.png'),
              ),
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: AppColors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 26,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Dr. ${specialist.firstName} ${specialist.lastName}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Flexible(
                child: Text(
                  specialty,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.green,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (specialist.rate != null) ...[
                const SizedBox(width: 8),
                const Icon(Icons.star, color: Color(0xFFFBBF24), size: 14),
                const SizedBox(width: 2),
                Text(
                  specialist.rate!.toStringAsFixed(1),
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Available Hours:',
            style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
          ),
          const SizedBox(height: 4),
          Text(
            availabilityText,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

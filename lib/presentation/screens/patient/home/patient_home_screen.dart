import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/constants/app_routes.dart';
import 'package:HealthBridge/core/utils/dialog.dart';
import 'package:HealthBridge/core/utils/snackbar_utils.dart';
import 'package:HealthBridge/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../widgets/cancel_button.dart';

class PatientHomeScreen extends StatefulWidget {
  final Function(int)? onNavigateToTab;

  const PatientHomeScreen({super.key, this.onNavigateToTab});

  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  // Quick action items
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
    {
      'icon': Icons.person_search,
      'iconColor': const Color(0xFF8B5CF6),
      'iconBg': const Color(0xFFF3E8FF),
      'title': 'Find Specialist',
      'subtitle': 'Browse by specialty',
    },
  ];

  // Sample recently viewed doctors
  final List<Map<String, dynamic>> recentlyViewed = [
    {
      'name': 'Dr. Adeyemi',
      'specialty': 'Cardiologist',
      'rating': 4.6,
    },
    {
      'name': 'Dr. Sarah Okonkwo',
      'specialty': 'Dermatology',
      'rating': 4.5,
    },
  ];

  // Sample specialist data
  final List<Map<String, dynamic>> specialists = [
    {
      'name': 'Dr. Chinedu',
      'specialty': 'Cardiologist',
      'rating': 4.5,
      'hours': 'Mon-Fri • 9:00 AM - 6:00 PM',
    },
    {
      'name': 'Dr. Grace Eze',
      'specialty': 'Physiotherapy',
      'rating': 4.5,
      'hours': 'Mon-Fri • 9:00 AM - 6:00 PM',
    },
    {
      'name': 'Dr. Oluwaseun',
      'specialty': 'General Medicine',
      'rating': 4.5,
      'hours': 'Mon-Fri • 9:00 AM - 6:00 PM',
    },
    {
      'name': 'Dr. James',
      'specialty': 'Dermatology',
      'rating': 4.5,
      'hours': 'Mon-Fri • 9:00 AM - 6:00 PM',
    },
    {
      'name': 'Dr. Mercy John',
      'specialty': 'Cardiologist',
      'rating': 4.5,
      'hours': 'Mon-Fri • 9:00 AM - 6:00 PM',
    },
    {
      'name': 'Dr. Adeyemi',
      'specialty': 'Cardiologist',
      'rating': 4.6,
      'hours': 'Mon-Fri • 9:00 AM - 6:00 PM',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      body: Column(
        children: [
          /// FIXED HEADER
          _buildHeader(),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),

                  _buildHeroBanner(),
                  const SizedBox(height: 20),

                  /// Quick Actions
                  _buildQuickActions(),
                  const SizedBox(height: 32),

                  /// Recently Viewed
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Text(
                      'Recently Viewed',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _recentViewed(),
                  const SizedBox(height: 32),

                  /// Your next Appointment
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Text(
                      'Your next Appointment',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  _buildNextAppointmentCard(),
                  const SizedBox(height: 12),

                  /// Nearby Specialists
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Text(
                      'Nearby Specialists',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.65,
                      ),
                      itemCount: specialists.length,
                      itemBuilder: (context, index) {
                        final specialist = specialists[index];
                        return _specialistCard(
                          specialist['name'] as String,
                          specialist['specialty'] as String,
                          specialist['rating'] as double,
                          specialist['hours'] as String,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 40),
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
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage('assets/images/patient.png'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Hello, Chisom',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2),
                Text(
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
            onPressed: () {
              context.push(AppRoutes.patientNotification);
            },
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
                  onPressed: () {
                    SnackBarUtils.showInfo(context, "Get Medical Help");
                  },
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
              // Navigate to Care tab if "Book Consultation" is clicked
              if (action['title'] == 'Book Consultation') {
                widget.onNavigateToTab?.call(2); // Care tab is index 2
              } else {
                SnackBarUtils.showInfo(context, action['title'] as String);
              }
            },
          );
        },
      ),
    );
  }

  Widget _recentViewed() {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: recentlyViewed.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final doctor = recentlyViewed[index];
          return _recentDoctorCard(
            doctor['name'] as String,
            doctor['specialty'] as String,
            doctor['rating'] as double,
          );
        },
      ),
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
        // height: 150,
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
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF9CA3AF),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _recentDoctorCard(String name, String specialty, double rating) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage('assets/images/patient.png'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  specialty,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF6B7280),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const Icon(Icons.star, color: Color(0xFFFBBF24), size: 12),
                    const SizedBox(width: 2),
                    Text(
                      rating.toString(),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextAppointmentCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
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
                      'Chibundu Nwakaego Jackson',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Cardiologist',
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
                      child:
                          _appointmentInfo('Consultation Type', 'Video Call'),
                    ),
                    const VerticalDivider(color: AppColors.textPrimary),
                    Expanded(
                      child: _appointmentInfo('Date', 'May 3rd'),
                    ),
                    const VerticalDivider(),
                    Expanded(
                      child: _appointmentInfo('Time', '14:00 AM'),
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
                          "Are you sure you want to cancel this appointment? You won’t be able to undo this action.",
                      onConfirm: () {
                        SnackBarUtils.showInfo(context, "in progress");
                      },
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // Widget _appointmentInfo(String label, String value) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         label,
  //         style: const TextStyle(
  //           fontSize: 11,
  //           color: Color(0xFF6B7280),
  //         ),
  //       ),
  //       const SizedBox(height: 4),
  //       Text(
  //         value,
  //         style: const TextStyle(
  //           fontSize: 13,
  //           fontWeight: FontWeight.w600,
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _appointmentInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF9CA3AF),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _specialistCard(
    String name,
    String specialty,
    double rating,
    String hours,
  ) {
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
          /// TOP ROW: PHOTO + ARROW
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CircleAvatar(
                radius: 32,
                backgroundImage: AssetImage('assets/images/patient.png'),
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

          /// NAME
          Text(
            name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 6),

          /// SPECIALTY + RATING
          Row(
            children: [
              Flexible(
                child: Text(
                  specialty,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.green,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.star,
                color: Color(0xFFFBBF24),
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                rating.toString(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          /// AVAILABLE HOURS
          const Text(
            'Available Hours:',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF9CA3AF),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            hours,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

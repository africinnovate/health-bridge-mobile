import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/constants/app_routes.dart';
import 'package:HealthBridge/core/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PatientCareScreen extends StatefulWidget {
  final Function(int)? onNavigateToTab;

  const PatientCareScreen({super.key, this.onNavigateToTab});

  @override
  State<PatientCareScreen> createState() => _PatientCareScreenState();
}

class _PatientCareScreenState extends State<PatientCareScreen> {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// fix Header
          _buildHeader(),

          /// Content
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),

                    /// Search Bar
                    GestureDetector(
                      onTap: () {
                        SnackBarUtils.showInfo(context, "Search specialists");
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.search,
                                color: Color(0xFF9CA3AF), size: 20),
                            SizedBox(width: 12),
                            Text(
                              'Search specialists, symptoms...',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF9CA3AF),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    /// Recently Viewed
                    const Text(
                      'Recently Viewed',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _recentViewed(),
                    const SizedBox(height: 32),

                    /// Top Specialists
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Top Specialists',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            SnackBarUtils.showInfo(context, "See all");
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
                    GridView.builder(
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
            'Find the right specialist for your health needs.',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.3,
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
            SnackBarUtils.showInfo(context, action['title'] as String);
          },
        );
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

  Widget _recentViewed() {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
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
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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

import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/constants/app_routes.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:HealthBridge/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SpecialistDetailsScreen extends StatefulWidget {
  const SpecialistDetailsScreen({super.key});

  @override
  State<SpecialistDetailsScreen> createState() =>
      _SpecialistDetailsScreenState();
}

class _SpecialistDetailsScreenState extends State<SpecialistDetailsScreen> {
  String selectedTab = 'About';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      appBar: const CustomAppBar(title: 'Specialist Details'),
      body: Column(
        children: [
          /// Specialist Header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/images/patient.png'),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Dr. Chinedu Okeke',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Cardiologist',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: const [
                              Icon(Icons.star,
                                  color: Color(0xFFFBBF24), size: 16),
                              SizedBox(width: 4),
                              Text(
                                '4.5',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                ' (127 reviews)',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF9CA3AF),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                /// Stats Row
                Row(
                  children: [
                    Expanded(
                      child: _statItem('Patients', '1,200+'),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: const Color(0xFFE5E7EB),
                    ),
                    Expanded(
                      child: _statItem('Experience', '15 years'),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: const Color(0xFFE5E7EB),
                    ),
                    Expanded(
                      child: _statItem('Rating', '4.5'),
                    ),
                  ],
                ),
              ],
            ),
          ),

          /// Tab Toggle
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                Expanded(child: _tabButton('About')),
                const SizedBox(width: 12),
                Expanded(child: _tabButton('Reviews')),
              ],
            ),
          ),

          /// Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: selectedTab == 'About' ? _buildAboutTab() : _buildReviewsTab(),
            ),
          ),

          /// Bottom Button
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: CustomButton(
                onPressed: () {
                  context.push(AppRoutes.pickDateTime);
                },
                text: 'Book Appointment',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF9CA3AF),
          ),
        ),
      ],
    );
  }

  Widget _tabButton(String title) {
    final isSelected = selectedTab == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.red : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.red : const Color(0xFFE5E7EB),
          ),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF6B7280),
          ),
        ),
      ),
    );
  }

  Widget _buildAboutTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Dr. Chinedu Okeke is a highly experienced cardiologist with over 15 years of practice. He specializes in heart disease prevention, diagnosis, and treatment. Dr. Okeke is known for his patient-centered approach and has helped thousands of patients manage their cardiovascular health.',
          style: TextStyle(
            fontSize: 13,
            color: Color(0xFF6B7280),
            height: 1.5,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Specializations',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _specializationChip('Heart Disease'),
            _specializationChip('Hypertension'),
            _specializationChip('Arrhythmia'),
            _specializationChip('Heart Failure'),
          ],
        ),
        const SizedBox(height: 24),
        const Text(
          'Consultation Types',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        _consultationTypeItem(Icons.videocam, 'Video Call', 'Available'),
        const SizedBox(height: 12),
        _consultationTypeItem(Icons.call, 'Voice Call', 'Available'),
        const SizedBox(height: 12),
        _consultationTypeItem(Icons.location_on, 'In Person', 'Available'),
        const SizedBox(height: 24),
        const Text(
          'Working Hours',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _workingHourRow('Monday - Friday', '9:00 AM - 6:00 PM'),
              const Divider(height: 16),
              _workingHourRow('Saturday', '9:00 AM - 2:00 PM'),
              const Divider(height: 16),
              _workingHourRow('Sunday', 'Closed'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReviewsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Rating Summary
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Column(
                children: const [
                  Text(
                    '4.5',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.star, color: Color(0xFFFBBF24), size: 20),
                      Icon(Icons.star, color: Color(0xFFFBBF24), size: 20),
                      Icon(Icons.star, color: Color(0xFFFBBF24), size: 20),
                      Icon(Icons.star, color: Color(0xFFFBBF24), size: 20),
                      Icon(Icons.star_half, color: Color(0xFFFBBF24), size: 20),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    '127 reviews',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 32),
              Expanded(
                child: Column(
                  children: [
                    _ratingBar(5, 85),
                    const SizedBox(height: 6),
                    _ratingBar(4, 10),
                    const SizedBox(height: 6),
                    _ratingBar(3, 3),
                    const SizedBox(height: 6),
                    _ratingBar(2, 1),
                    const SizedBox(height: 6),
                    _ratingBar(1, 1),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        /// Reviews List
        const Text(
          'Patient Reviews',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        _reviewCard(
          name: 'Chisom Adebayo',
          rating: 5,
          date: '2 days ago',
          review:
              'Dr. Okeke is an excellent cardiologist. He took the time to explain my condition and answered all my questions. Highly recommended!',
        ),
        const SizedBox(height: 12),
        _reviewCard(
          name: 'Emeka Johnson',
          rating: 4,
          date: '1 week ago',
          review:
              'Very professional and knowledgeable. The consultation was thorough and helpful.',
        ),
        const SizedBox(height: 12),
        _reviewCard(
          name: 'Ngozi Okafor',
          rating: 5,
          date: '2 weeks ago',
          review:
              'Best cardiologist I have ever visited. He really cares about his patients and provides excellent care.',
        ),
      ],
    );
  }

  Widget _specializationChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Color(0xFF6B7280),
        ),
      ),
    );
  }

  Widget _consultationTypeItem(IconData icon, String type, String status) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: const Color(0xFF6B7280)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              type,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              status,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _workingHourRow(String day, String hours) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          day,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF6B7280),
          ),
        ),
        Text(
          hours,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _ratingBar(int stars, int percentage) {
    return Row(
      children: [
        Text(
          '$stars',
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF6B7280),
          ),
        ),
        const SizedBox(width: 8),
        const Icon(Icons.star, color: Color(0xFFFBBF24), size: 14),
        const SizedBox(width: 8),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: const Color(0xFFE5E7EB),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFBBF24)),
              minHeight: 6,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$percentage%',
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF9CA3AF),
          ),
        ),
      ],
    );
  }

  Widget _reviewCard({
    required String name,
    required int rating,
    required String date,
    required String review,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage('assets/images/patient.png'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    index < rating ? Icons.star : Icons.star_border,
                    color: const Color(0xFFFBBF24),
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            review,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF6B7280),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

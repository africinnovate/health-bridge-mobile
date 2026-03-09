import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/constants/app_routes.dart';
import 'package:HealthBridge/data/models/specialist/specialist_profile_model.dart';
import 'package:HealthBridge/presentation/providers/specialist_provider.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:HealthBridge/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SpecialistDetailsScreen extends StatefulWidget {
  final SpecialistProfileModel? specialist;

  const SpecialistDetailsScreen({super.key, this.specialist});

  @override
  State<SpecialistDetailsScreen> createState() =>
      _SpecialistDetailsScreenState();
}

class _SpecialistDetailsScreenState extends State<SpecialistDetailsScreen> {
  String selectedTab = 'About';

  String _getSpecialtyName() {
    if (widget.specialist == null) return 'Specialist';
    final provider = context.read<SpecialistProvider>();
    try {
      return provider.specialties
          .firstWhere((s) => s.id == widget.specialist!.specialtyId)
          .name;
    } catch (_) {
      return 'Specialist';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.specialist == null) {
      return Scaffold(
        backgroundColor: AppColors.backgroundGray,
        appBar: const CustomAppBar(title: 'Specialist Details'),
        body: const Center(child: Text('No specialist details available')),
      );
    }

    final specialist = widget.specialist!;
    final specialtyName = _getSpecialtyName();
    final fullName = 'Dr. ${specialist.firstName} ${specialist.lastName}';
    final experience = specialist.yearsOfExperience != null
        ? '${specialist.yearsOfExperience} yrs'
        : 'N/A';
    final session = specialist.sessionDurationMinutes != null
        ? '${specialist.sessionDurationMinutes} min'
        : 'N/A';
    final rateDisplay =
        specialist.rate != null ? specialist.rate!.toStringAsFixed(1) : 'N/A';

    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      appBar: const CustomAppBar(title: 'Specialist Details'),
      body: Column(
        children: [
          /// Header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: specialist.imageUrl != null
                          ? NetworkImage(specialist.imageUrl!) as ImageProvider
                          : const AssetImage('assets/images/patient.png'),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            fullName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            specialtyName,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.star,
                                  color: Color(0xFFFBBF24), size: 16),
                              const SizedBox(width: 4),
                              Text(
                                rateDisplay,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (specialist.city != null) ...[
                                const SizedBox(width: 8),
                                const Text('•',
                                    style:
                                        TextStyle(color: Color(0xFF9CA3AF))),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    specialist.city!,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF9CA3AF),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
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
                    Expanded(child: _statItem('Experience', experience)),
                    Container(
                        width: 1, height: 40, color: const Color(0xFFE5E7EB)),
                    Expanded(child: _statItem('Session', session)),
                    Container(
                        width: 1, height: 40, color: const Color(0xFFE5E7EB)),
                    Expanded(child: _statItem('Rating', rateDisplay)),
                  ],
                ),
              ],
            ),
          ),

          /// Tab Toggle
          Container(
            color: Colors.white,
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
              child: selectedTab == 'About'
                  ? _buildAboutTab(specialist, specialtyName)
                  : _buildReviewsTab(specialist),
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
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style:
              const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
        ),
      ],
    );
  }

  Widget _tabButton(String title) {
    final isSelected = selectedTab == title;
    return GestureDetector(
      onTap: () => setState(() => selectedTab = title),
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

  Widget _buildAboutTab(
      SpecialistProfileModel specialist, String specialtyName) {
    final consultationTypes = _parseConsultationTypes(specialist.consultationType);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Bio
        if (specialist.bio != null && specialist.bio!.isNotEmpty) ...[
          const Text(
            'About',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Text(
            specialist.bio!,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF6B7280),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
        ],

        /// Specialization chip
        const Text(
          'Specialization',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _specializationChip(specialtyName),
          ],
        ),
        const SizedBox(height: 24),

        /// Languages
        if (specialist.languagesSpoken != null &&
            specialist.languagesSpoken!.isNotEmpty) ...[
          const Text(
            'Languages',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: specialist.languagesSpoken!
                .split(',')
                .map((l) => _specializationChip(l.trim()))
                .toList(),
          ),
          const SizedBox(height: 24),
        ],

        /// Consultation Types
        const Text(
          'Consultation Types',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        ...consultationTypes.map((type) {
          final icon = type == 'video_call'
              ? Icons.videocam
              : type == 'audio_call'
                  ? Icons.call
                  : Icons.location_on;
          final label = type == 'video_call'
              ? 'Video Call'
              : type == 'audio_call'
                  ? 'Voice Call'
                  : 'In Person';
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _consultationTypeItem(icon, label, 'Available'),
          );
        }),
        const SizedBox(height: 24),

        /// Working Hours
        if (specialist.availability.isNotEmpty) ...[
          const Text(
            'Working Hours',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: specialist.availability
                  .asMap()
                  .entries
                  .map((entry) {
                final index = entry.key;
                final avail = entry.value;
                return Column(
                  children: [
                    if (index != 0) const Divider(height: 16),
                    _workingHourRow(
                      avail.dayOfWeek,
                      '${avail.opensAt} - ${avail.closesAt}',
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildReviewsTab(SpecialistProfileModel specialist) {
    final rateDisplay = specialist.rate != null
        ? specialist.rate!.toStringAsFixed(1)
        : 'N/A';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Column(
                children: [
                  Text(
                    rateDisplay,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    children: [
                      Icon(Icons.star, color: Color(0xFFFBBF24), size: 20),
                      Icon(Icons.star, color: Color(0xFFFBBF24), size: 20),
                      Icon(Icons.star, color: Color(0xFFFBBF24), size: 20),
                      Icon(Icons.star, color: Color(0xFFFBBF24), size: 20),
                      Icon(Icons.star_half,
                          color: Color(0xFFFBBF24), size: 20),
                    ],
                  ),
                ],
              ),
              const SizedBox(width: 32),
              const Expanded(
                child: Center(
                  child: Text(
                    'Reviews coming soon',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<String> _parseConsultationTypes(String consultationType) {
    if (consultationType.toLowerCase() == 'all') {
      return ['video_call', 'audio_call', 'in_person'];
    }
    return consultationType.split(',').map((e) => e.trim()).toList();
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
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
          style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
        ),
        Text(
          hours,
          style:
              const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

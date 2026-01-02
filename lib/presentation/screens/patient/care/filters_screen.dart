import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/utils/snackbar_utils.dart';
import 'package:HealthBridge/presentation/widgets/cancel_button.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:HealthBridge/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class FiltersScreen extends StatefulWidget {
  const FiltersScreen({super.key});

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  String? selectedSpecialty;
  String? selectedConsultationType;
  String? selectedLocation;
  int minExperience = 0;
  double minRating = 0;
  String? selectedAvailability;

  final List<String> specialties = [
    'Cardiologist',
    'Dermatology',
    'General Medicine',
    'Physiotherapy',
    'Pediatrics',
    'Psychiatry',
  ];

  final List<String> consultationTypes = [
    'Video Call',
    'Voice Call',
    'In Person',
  ];

  final List<String> locations = [
    'Within 5km',
    'Within 10km',
    'Within 20km',
    'Any Distance',
  ];

  final List<String> availabilities = [
    'Today',
    'This Week',
    'This Month',
    'Anytime',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      appBar: CustomAppBar(
        title: 'Filters',
        actions: [
          TextButton(
            onPressed: _clearAllFilters,
            child: const Text(
              'Clear All',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Specialty
                  const Text(
                    'Specialty',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: specialties
                        .map((specialty) => _filterChip(
                              specialty,
                              selectedSpecialty == specialty,
                              () {
                                setState(() {
                                  selectedSpecialty =
                                      selectedSpecialty == specialty
                                          ? null
                                          : specialty;
                                });
                              },
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 24),

                  /// Consultation Type
                  const Text(
                    'Consultation Type',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: consultationTypes
                        .map((type) => _filterChip(
                              type,
                              selectedConsultationType == type,
                              () {
                                setState(() {
                                  selectedConsultationType =
                                      selectedConsultationType == type
                                          ? null
                                          : type;
                                });
                              },
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 24),

                  /// Location
                  const Text(
                    'Location',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: locations
                        .map((location) => _filterChip(
                              location,
                              selectedLocation == location,
                              () {
                                setState(() {
                                  selectedLocation =
                                      selectedLocation == location
                                          ? null
                                          : location;
                                });
                              },
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 24),

                  /// Experience
                  const Text(
                    'Minimum Experience',
                    style: TextStyle(
                      fontSize: 14,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Years',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                            Text(
                              '$minExperience+ years',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Slider(
                          value: minExperience.toDouble(),
                          min: 0,
                          max: 20,
                          divisions: 20,
                          activeColor: AppColors.red,
                          inactiveColor: const Color(0xFFE5E7EB),
                          onChanged: (value) {
                            setState(() {
                              minExperience = value.toInt();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  /// Rating
                  const Text(
                    'Minimum Rating',
                    style: TextStyle(
                      fontSize: 14,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Rating',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.star,
                                    color: Color(0xFFFBBF24), size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  '${minRating.toStringAsFixed(1)}+',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Slider(
                          value: minRating,
                          min: 0,
                          max: 5,
                          divisions: 10,
                          activeColor: AppColors.red,
                          inactiveColor: const Color(0xFFE5E7EB),
                          onChanged: (value) {
                            setState(() {
                              minRating = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  /// Availability
                  const Text(
                    'Availability',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: availabilities
                        .map((availability) => _filterChip(
                              availability,
                              selectedAvailability == availability,
                              () {
                                setState(() {
                                  selectedAvailability =
                                      selectedAvailability == availability
                                          ? null
                                          : availability;
                                });
                              },
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),

          /// Bottom Buttons
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
              child: Column(
                children: [
                  CustomButton(
                    onPressed: () {
                      SnackBarUtils.showInfo(context, "Filters applied");
                    },
                    text: 'Apply Filters',
                  ),
                  const SizedBox(height: 12),
                  CancelButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    text: 'Cancel',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.red : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.red : const Color(0xFFE5E7EB),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF6B7280),
          ),
        ),
      ),
    );
  }

  void _clearAllFilters() {
    setState(() {
      selectedSpecialty = null;
      selectedConsultationType = null;
      selectedLocation = null;
      minExperience = 0;
      minRating = 0;
      selectedAvailability = null;
    });
    SnackBarUtils.showInfo(context, "All filters cleared");
  }
}

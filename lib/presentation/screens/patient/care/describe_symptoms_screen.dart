import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/constants/app_routes.dart';
import 'package:HealthBridge/core/utils/snackbar_utils.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:HealthBridge/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DescribeSymptomsScreen extends StatefulWidget {
  const DescribeSymptomsScreen({super.key});

  @override
  State<DescribeSymptomsScreen> createState() => _DescribeSymptomsScreenState();
}

class _DescribeSymptomsScreenState extends State<DescribeSymptomsScreen> {
  final TextEditingController _symptomsController = TextEditingController();
  final List<String> _selectedPhotos = [];

  @override
  void dispose() {
    _symptomsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      appBar: const CustomAppBar(title: 'Describe Symptoms'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Info Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF3B82F6).withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.info_outline,
                              color: Color(0xFF3B82F6), size: 20),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Describing your symptoms helps the specialist prepare for your consultation',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF3B82F6),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    /// Symptoms Field
                    const Text(
                      'What symptoms are you experiencing?',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: TextField(
                        controller: _symptomsController,
                        maxLines: 8,
                        decoration: const InputDecoration(
                          hintText:
                              'Describe your symptoms in detail... (e.g., When did they start? How severe are they? Any specific triggers?)',
                          hintStyle: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF9CA3AF),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    /// Common Symptoms
                    const Text(
                      'Common Symptoms',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _symptomChip('Fever'),
                        _symptomChip('Headache'),
                        _symptomChip('Cough'),
                        _symptomChip('Fatigue'),
                        _symptomChip('Body aches'),
                        _symptomChip('Shortness of breath'),
                        _symptomChip('Chest pain'),
                        _symptomChip('Dizziness'),
                      ],
                    ),
                    const SizedBox(height: 24),

                    /// Attach Photos
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Attach Photos (Optional)',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${_selectedPhotos.length}/3',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _photoBox(0),
                        const SizedBox(width: 12),
                        _photoBox(1),
                        const SizedBox(width: 12),
                        _photoBox(2),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Photos help the specialist better understand your condition',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
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
              child: CustomButton(
                onPressed: () {
                  if (_symptomsController.text.trim().isEmpty) {
                    SnackBarUtils.showError(
                        context, "Please describe your symptoms");
                    return;
                  }
                  context.push(AppRoutes.pickDateTime);
                },
                text: 'Continue to Booking',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _symptomChip(String symptom) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_symptomsController.text.isEmpty) {
            _symptomsController.text = symptom;
          } else {
            _symptomsController.text += ', $symptom';
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Text(
          symptom,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF6B7280),
          ),
        ),
      ),
    );
  }

  Widget _photoBox(int index) {
    final hasPhoto = _selectedPhotos.length > index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (hasPhoto) {
              _selectedPhotos.removeAt(index);
            } else {
              _selectedPhotos.add('photo_$index');
            }
          });
          SnackBarUtils.showInfo(
              context, hasPhoto ? "Photo removed" : "Photo added");
        },
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              color: hasPhoto ? const Color(0xFFF3F4F6) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: hasPhoto
                    ? Colors.transparent
                    : const Color(0xFFE5E7EB),
              ),
            ),
            child: hasPhoto
                ? Stack(
                    children: [
                      Center(
                        child: const Icon(
                          Icons.image,
                          size: 40,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppColors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.add_photo_alternate_outlined,
                        size: 32,
                        color: Color(0xFF9CA3AF),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Add Photo',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

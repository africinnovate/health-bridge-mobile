import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/utils/snackbar_utils.dart';
import 'package:HealthBridge/presentation/widgets/cancel_button.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:HealthBridge/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class MedicalInformationPatientScreen extends StatefulWidget {
  const MedicalInformationPatientScreen({super.key});

  @override
  State<MedicalInformationPatientScreen> createState() =>
      _MedicalInformationPatientScreenState();
}

class _MedicalInformationPatientScreenState
    extends State<MedicalInformationPatientScreen> {
  final TextEditingController _allergiesController =
      TextEditingController(text: 'Peanuts, Penicillin');
  final TextEditingController _medicationsController =
      TextEditingController(text: 'Lisinopril 10mg');
  final TextEditingController _pastIllnessesController =
      TextEditingController(text: '');
  final TextEditingController _currentMedicationsController =
      TextEditingController(text: '');
  final TextEditingController _recentSurgeryController =
      TextEditingController(text: '');
  final TextEditingController _primaryPhysicianController =
      TextEditingController(text: 'Dr. Sarah Okonkwo');

  @override
  void dispose() {
    _allergiesController.dispose();
    _medicationsController.dispose();
    _pastIllnessesController.dispose();
    _currentMedicationsController.dispose();
    _recentSurgeryController.dispose();
    _primaryPhysicianController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      appBar: const CustomAppBar(title: 'Medical Information'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Medical Information',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'This information helps specialists provide better care and prepare for your consultation',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 24),

                    /// Allergies
                    const Text(
                      'Allergies (Optional)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: TextField(
                        controller: _allergiesController,
                        decoration: const InputDecoration(
                          hintText: 'List any allergies',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    /// Medications
                    const Text(
                      'Medications',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: TextField(
                        controller: _medicationsController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          hintText: 'List current medications',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    /// Past Illnesses
                    const Text(
                      'Past Illnesses',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: TextField(
                        controller: _pastIllnessesController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          hintText: 'List any past medical conditions',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    /// Current Medications
                    const Text(
                      'Current Medications',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: TextField(
                        controller: _currentMedicationsController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          hintText: 'List medications you are currently taking',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    /// Recent Surgery
                    const Text(
                      'Recent Surgery (MAY)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: TextField(
                        controller: _recentSurgeryController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          hintText: 'Describe any recent surgeries',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    /// Primary Physician
                    const Text(
                      'Primary Physician (Optional)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: TextField(
                        controller: _primaryPhysicianController,
                        decoration: const InputDecoration(
                          hintText: 'Enter your primary physician name',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                        ),
                      ),
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
              child: Column(
                children: [
                  CustomButton(
                    onPressed: () {
                      SnackBarUtils.showInfo(
                          context, "Medical information updated");
                      Navigator.pop(context);
                    },
                    text: 'Save Changes',
                  ),
                  const SizedBox(height: 12),
                  CancelButton(
                    text: 'Cancel',
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

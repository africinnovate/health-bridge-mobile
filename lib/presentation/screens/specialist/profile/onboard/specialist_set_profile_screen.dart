import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/core/utils/snackbar_utils.dart';
import 'package:HealthBridge/data/dataSource/secureData/secure_storage.dart';
import 'package:HealthBridge/presentation/providers/specialist_provider.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:HealthBridge/presentation/widgets/custom_text.dart';
import 'package:HealthBridge/presentation/widgets/input_text_field_wg.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_routes.dart';
import '../../../../widgets/custom_button.dart';

class SpecialistSetProfileScreen extends StatefulWidget {
  final bool isUpdateMode;

  const SpecialistSetProfileScreen({
    super.key,
    this.isUpdateMode = false,
  });

  @override
  State<SpecialistSetProfileScreen> createState() =>
      _SpecialistSetProfileScreenState();
}

class _SpecialistSetProfileScreenState
    extends State<SpecialistSetProfileScreen> {
  final TextEditingController bioController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController altPhoneController = TextEditingController();
  int? selectedYears;
  String? selectedLanguage;
  String? selectedCountry;

  final languages = [
    'English',
    'French',
    'Spanish',
    'German',
    'Arabic',
  ];

  final countries = [
    'Nigeria',
    'Ghana',
    'Canada',
    'USA',
    'Uganda',
  ];

  String? selectedSpecialtyId;
  final Set<String> selectedSpecialties = {};

  String consultationType = 'video_call';

  int bioLength = 0;

  @override
  void initState() {
    super.initState();
    _loadSpecialties();
    if (widget.isUpdateMode) {
      _loadExistingData();
    }
  }

  void _loadExistingData() {
    final provider = Provider.of<SpecialistProvider>(context, listen: false);
    final profile = provider.specialistProfileM;

    if (profile != null) {
      setState(() {
        bioController.text = profile.bio ?? '';
        phoneController.text = profile.primaryPhone ?? '';
        altPhoneController.text = profile.secondaryPhone ?? '';
        selectedYears = profile.yearsOfExperience;
        selectedLanguage = profile.languagesSpoken;
        selectedCountry = profile.country;
        selectedSpecialtyId = profile.specialtyId;
        selectedSpecialties.add(profile.specialtyId);
        consultationType = profile.consultationType;
        bioLength = (profile.bio ?? '').length;
      });
    }
  }

  void _showAddSpecialtyDialog() {
    final nameController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context1) {
        return AlertDialog(
          title: const Text('Add New Specialty'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InputTextFieldWG(
                controller: nameController,
                hintText: 'Specialty Name',
              ),
              const SizedBox(height: 12),
              InputTextFieldWG(
                controller: descController,
                hintText: 'Description',
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context1).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (nameController.text.trim().isEmpty) {
                  SnackBarUtils.showError(
                      context, 'Please enter specialty name');
                  return;
                }
                if (descController.text.trim().isEmpty) {
                  SnackBarUtils.showError(context, 'Please enter description');
                  return;
                }

                // Close dialog first
                Navigator.of(context1).pop();
                context.showLoadingDialog();

                // Call API to add specialty
                final provider =
                    Provider.of<SpecialistProvider>(context, listen: false);
                final error = await provider.addSpecialty(
                  name: nameController.text.trim(),
                  description: descController.text.trim(),
                );

                context.hideLoadingDialog();
                if (error != null) {
                  SnackBarUtils.showError(context, error);
                } else {
                  SnackBarUtils.showSuccess(
                      context, 'Specialty added successfully!');
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _loadSpecialties() async {
    final provider = Provider.of<SpecialistProvider>(context, listen: false);
    final error = await provider.getSpecialties();
    if (error != null) {
      SnackBarUtils.showError(context, error);
    }
  }

  Future<void> _saveAndContinue() async {
    // Validate required fields
    if (selectedSpecialtyId == null) {
      SnackBarUtils.showError(context, "Please select at least one specialty");
      return;
    }
    if (bioController.text.trim().isEmpty) {
      SnackBarUtils.showError(context, "Please enter your professional bio");
      return;
    }
    if (selectedYears == null) {
      SnackBarUtils.showError(context, "Please select years of experience");
      return;
    }
    if (phoneController.text.trim().isEmpty) {
      SnackBarUtils.showError(
          context, "Please enter your primary contact number");
      return;
    }
    if (selectedLanguage == null) {
      SnackBarUtils.showError(context, "Please select a language");
      return;
    }
    if (selectedCountry == null) {
      SnackBarUtils.showError(context, "Please select your country of service");
      return;
    }

    final provider = Provider.of<SpecialistProvider>(context, listen: false);
    context.showLoadingDialog();

    if (widget.isUpdateMode) {
      // Update mode - call update API
      final error = await provider.updateSpecialistProfile(
        bio: bioController.text.trim(),
        consultationType: consultationType,
        languagesSpoken: selectedLanguage,
        yearsOfExperience: selectedYears,
        primaryPhone: phoneController.text.trim(),
        secondaryPhone: altPhoneController.text.trim().isEmpty
            ? null
            : altPhoneController.text.trim(),
        country: selectedCountry,
      );

      context.hideLoadingDialog();
      if (error != null) {
        SnackBarUtils.showError(context, error);
        return;
      }

      SnackBarUtils.showSuccess(
          context, "Professional information updated successfully!");
      context.goBack();
    } else {
      // Create mode - save to provider and navigate to availability screen
      provider.tempBio = bioController.text.trim();
      provider.tempConsultationType = consultationType;
      provider.tempLanguagesSpoken = selectedLanguage;
      provider.tempYearsOfExperience = selectedYears;
      provider.tempPrimaryPhone = phoneController.text.trim();
      provider.tempSecondaryPhone = altPhoneController.text.trim().isEmpty
          ? null
          : altPhoneController.text.trim();
      provider.tempCountry = selectedCountry;
      provider.tempSpecialtyId = selectedSpecialtyId;

      // Navigate to availability screen
      context.goNextScreen(AppRoutes.availabilitySpecialist);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            const Text(
              'Set Up Your Specialist Profile',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              'Provide your professional details so patients can understand '
              'your expertise and choose the right specialist.',
              style: TextStyle(color: Color(0xFF6B7280), height: 1.4),
            ),

            const SizedBox(height: 24),

            /// Profile image
            Center(
              child: Stack(
                children: [
                  const CircleAvatar(
                    radius: 52,
                    backgroundColor: Color(0xFFE5E7EB),
                    // backgroundImage: AssetImage('assets/images/avatar.png'),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFD32F2F),
                      ),
                      child: const Icon(Icons.camera_alt,
                          size: 16, color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 6),
            const Center(
              child: Text(
                'Profile Photo (Required)',
                style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
              ),
            ),

            const SizedBox(height: 20),

            /// Specialty
            _label('Select Specialty'),
            Consumer<SpecialistProvider>(
              builder: (BuildContext context, provider, Widget? child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: provider.specialties.map((item) {
                        final selected = selectedSpecialties.contains(item.id);
                        return ChoiceChip(
                          backgroundColor: AppColors.backgroundGray,
                          side: BorderSide.none,
                          label: CustomText(
                            text: item.name,
                            size: 13,
                            color: selected ? Colors.white : Colors.black87,
                          ),
                          selected: selected,
                          selectedColor: AppColors.red,
                          onSelected: (_) {
                            selectedSpecialtyId = item.id;
                            setState(() {
                              selected
                                  ? selectedSpecialties.remove(item.id)
                                  : selectedSpecialties.add(item.id);
                            });
                          },
                        );
                      }).toList(),
                    ),
                    TextButton.icon(
                      onPressed: _showAddSpecialtyDialog,
                      icon: const Icon(Icons.add),
                      label: const Text('Add Specialty'),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 16),

            /// Bio
            _label('Professional Bio'),
            InputTextFieldWG(
              hintText:
                  'Short introduction about yourself and your approach to patient care',
              controller: bioController,
              maxLines: 4,
              // maxLength: 500,
              onChanged: (v) => setState(() => bioLength = v.length),
            ),

            const SizedBox(height: 16),

            /// Years of experience
            _label('Years of experience'),
            _dropdownYears(
              hint: 'Select years',
              value: selectedYears,
              onChanged: (val) {
                setState(() {
                  selectedYears = val;
                });
              },
            ),

            const SizedBox(height: 20),

            /// Consultation type
            _label('Consultation Type'),
            Row(
              children: [
                _consultationButton('Video call', 'video_call', Icons.videocam),
                const SizedBox(width: 12),
                _consultationButton('Voice call', 'voice_call', Icons.call),
                const SizedBox(width: 12),
                _consultationButton(
                    'In-person', 'in_person', Icons.location_on),
              ],
            ),

            const SizedBox(height: 24),

            /// Contact info
            _label('Contact Information'),
            const Text(
              'Patients will use this to call during appointment times.',
              style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
            ),

            const SizedBox(height: 12),
            InputTextFieldWG(
              controller: phoneController,
              hintText: "Primary contact number (Required)",
            ),
            const SizedBox(height: 12),
            InputTextFieldWG(
              controller: altPhoneController,
              hintText: "Alternative line (optional)",
            ),

            const SizedBox(height: 20),

            /// Languages
            _label('Languages Spoken'),
            _dropdownItems(
              hint: 'Select Language',
              value: selectedLanguage,
              onChanged: (val) {
                setState(() {
                  selectedLanguage = val;
                });
              },
              listItem: languages,
            ),
            // TextButton.icon(
            //   onPressed: () {},
            //   icon: const Icon(Icons.add),
            //   label: const Text('Add Another Language'),
            // ),
            const SizedBox(height: 24),

            /// country of service
            _label('Country of Service'),
            _dropdownItems(
              hint: 'Select Country',
              value: selectedCountry,
              onChanged: (val) {
                setState(() {
                  selectedCountry = val;
                });
              },
              listItem: countries,
            ),

            const SizedBox(height: 18),

            _label('Upload License or Accreditation Document'),
            const SizedBox(height: 5),
            _uploadBox(),

            const SizedBox(height: 8),
            const Text(
              'Max file size: 5MB',
              style: TextStyle(fontSize: 12, color: AppColors.textGray),
            ),

            const SizedBox(height: 32),

            /// Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      context.goBack();
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide.none,
                      backgroundColor: const Color(0xFFF5F5F5),
                    ),
                    child: const Text(
                      'Save & Finish later',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    onPressed: () {
                      _saveAndContinue();
                    },
                    text: "Continue",
                    // shouldProceed: true,
                    // showLoading: false,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  /// ---------------- Widgets ----------------

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _dropdownYears({
    required String hint,
    required int? value,
    required ValueChanged<int?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: value,
          hint: Text(
            hint,
            style: const TextStyle(color: Color(0xFF9CA3AF)),
          ),
          icon: const Icon(Icons.keyboard_arrow_down),
          isExpanded: true,
          items: List.generate(
            19,
            (index) {
              final number = index + 2; // 2 → 20
              return DropdownMenuItem<int>(
                value: number,
                child: Text(number.toString()),
              );
            },
          ),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _dropdownItems({
    required String hint,
    required List<String> listItem,
    required String? value,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(
            hint,
            style: const TextStyle(color: Color(0xFF9CA3AF)),
          ),
          icon: const Icon(Icons.keyboard_arrow_down),
          isExpanded: true,
          items: listItem
              .map(
                (lang) => DropdownMenuItem<String>(
                  value: lang,
                  child: Text(lang),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _uploadBox() {
    return Container(
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.image_outlined, size: 32, color: Color(0xFF6B7280)),
          SizedBox(height: 8),
          Text(
            'Tap to upload PDF, JPG, PNG',
            style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
          ),
        ],
      ),
    );
  }

  Widget _consultationButton(String label, String value, IconData icon) {
    final selected = consultationType == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => consultationType = value),
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            color: selected ? AppColors.red : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? Colors.transparent : const Color(0xFFE5E7EB),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 18, color: selected ? Colors.white : Colors.grey),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: selected ? Colors.white : Colors.grey,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

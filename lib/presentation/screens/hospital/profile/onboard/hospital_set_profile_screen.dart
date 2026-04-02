import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/core/utils/snackbar_utils.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_routes.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/input_text_field_wg.dart';
import '../../../../../presentation/providers/hospital_provider.dart';

class HospitalSetupProfileScreen extends StatefulWidget {
  final bool isEditMode;
  const HospitalSetupProfileScreen({super.key, this.isEditMode = false});

  @override
  State<HospitalSetupProfileScreen> createState() => _HospitalSetupProfileScreenState();
}

class _HospitalSetupProfileScreenState extends State<HospitalSetupProfileScreen> {
  // Form controllers
  final TextEditingController hospitalNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController primaryPhoneController = TextEditingController();
  final TextEditingController emergencyPhoneController =
      TextEditingController();
  final TextEditingController licenseNumberController = TextEditingController();

  // Dropdown values
  String? hospitalType;
  String? country;
  String? accreditationDocUrl;

  // Upload state
  bool isUploading = false;
  String? uploadedFileName;
  String? uploadError;

  @override
  void initState() {
    super.initState();
    if (widget.isEditMode) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _prefillFromProfile());
    }
  }

  void _prefillFromProfile() {
    final profile = context.read<HospitalProvider>().hospitalProfile;
    if (profile == null) return;
    setState(() {
      hospitalNameController.text = profile.name;
      hospitalType = profile.hospitalType;
      addressController.text = profile.address;
      country = profile.country;
      cityController.text = profile.city;
      emailController.text = profile.email;
      primaryPhoneController.text = profile.primaryPhone;
      emergencyPhoneController.text = profile.emergencyPhone ?? '';
      licenseNumberController.text = profile.licenseNumber;
      accreditationDocUrl = profile.accreditationDocUrl;
      if (profile.accreditationDocUrl?.isNotEmpty == true) {
        uploadedFileName = 'Existing document';
      }
    });
  }

  @override
  void dispose() {
    hospitalNameController.dispose();
    addressController.dispose();
    cityController.dispose();
    stateController.dispose();
    emailController.dispose();
    primaryPhoneController.dispose();
    emergencyPhoneController.dispose();
    licenseNumberController.dispose();
    super.dispose();
  }

  void _handleSaveAndFinishLater() {
    _saveHospitalData();
    context.goBack();
    // context.goNextScreen(AppRoutes.bloodServiceHospital);
  }

  void _handleContinue() {
    if (!_validateInputs()) return;
    _saveHospitalData();
    context.goNextScreen(AppRoutes.bloodServiceHospital);
  }

  bool _validateInputs() {
    if (hospitalNameController.text.isEmpty) {
      _showError('Please enter hospital name');
      return false;
    }
    if (hospitalType == null) {
      _showError('Please select hospital type');
      return false;
    }
    if (addressController.text.isEmpty) {
      _showError('Please enter address');
      return false;
    }
    if (country == null) {
      _showError('Please select country');
      return false;
    }
    if (stateController.text.trim().isEmpty) {
      _showError('Please enter state/region');
      return false;
    }
    if (cityController.text.isEmpty) {
      _showError('Please enter city');
      return false;
    }
    if (emailController.text.isEmpty) {
      _showError('Please enter email');
      return false;
    }
    if (primaryPhoneController.text.isEmpty) {
      _showError('Please enter primary phone');
      return false;
    }
    if (licenseNumberController.text.isEmpty) {
      _showError('Please enter license number');
      return false;
    }
    if (!widget.isEditMode && (accreditationDocUrl == null || accreditationDocUrl!.isEmpty)) {
      _showError('Please upload accreditation document');
      return false;
    }
    return true;
  }

  Future<void> _handleSave() async {
    if (!_validateInputs()) return;

    context.showLoadingDialog();
    final hospitalProvider = context.read<HospitalProvider>();
    final existingProfile = hospitalProvider.hospitalProfile!;

    String docUrl = existingProfile.accreditationDocUrl ?? '';

    // If user picked a new file, upload it first
    final filePath = hospitalProvider.pickedDocFilePath;
    if (filePath != null) {
      final uploadError = await hospitalProvider.uploadAccreditationDoc(filePath, existingProfile.id);
      if (uploadError != null) {
        context.hideLoadingDialog();
        if (mounted) SnackBarUtils.showError(context, uploadError);
        return;
      }
      docUrl = hospitalProvider.uploadedAccreditationUrl ?? docUrl;
    }

    final payload = {
      'name': hospitalNameController.text,
      'hospital_type': hospitalType,
      'address': addressController.text,
      'country': country,
      'state': stateController.text,
      'city': cityController.text,
      'email': emailController.text,
      'primary_phone': primaryPhoneController.text,
      'emergency_phone': emergencyPhoneController.text.isNotEmpty ? emergencyPhoneController.text : null,
      'license_number': licenseNumberController.text,
      'accreditation_doc_url': docUrl,
      'has_blood_bank': existingProfile.hasBloodBank,
      'accepting_donors': existingProfile.acceptingDonors,
      'blood_inventory': existingProfile.bloodInventory.map((e) => {
        'blood_type': e.bloodType,
        'units_available': e.unitsAvailable,
        'bank_capacity': e.bankCapacity,
      }).toList(),
      'donating_operating_hours': existingProfile.donatingOperatingHours,
    };

    try {
      final error = await hospitalProvider.createHospital(payload,
          hospitalId: existingProfile.id);
      context.hideLoadingDialog();
      if (error == null) {
        if (mounted) context.goBack();
      } else {
        if (mounted) SnackBarUtils.showError(context, error);
      }
    } catch (e) {
      context.hideLoadingDialog();
      if (mounted) SnackBarUtils.showError(context, 'Failed to update profile');
    }
  }

  void _saveHospitalData() {
    // Save hospital profile data to provider for later use
    final hospitalData = {
      'name': hospitalNameController.text,
      'hospital_type': hospitalType,
      'address': addressController.text,
      'country': country,
      'state': stateController.text,
      'city': cityController.text,
      'email': emailController.text,
      'primary_phone': primaryPhoneController.text,
      'emergency_phone': emergencyPhoneController.text,
      'license_number': licenseNumberController.text,
      'accreditation_doc_url': null, // set after hospital creation via upload
    };
    // Store in provider for later use when building complete payload
    context.read<HospitalProvider>().saveHospitalProfileData(hospitalData);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(),
      body: GestureDetector(
        onTap: context.hideKeyboard,
        behavior: HitTestBehavior.opaque,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),

              /// Title
              Text(
                widget.isEditMode ? 'Edit Hospital Profile' : 'Set Up Your Hospital Profile',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 8),

              /// Subtitle
              const Text(
                'Provide your hospital details to access referrals, manage blood requests, and collaborate across the HealthBridge network.',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                ),
              ),

              const SizedBox(height: 28),

              _label('Hospital Name'),
              const SizedBox(height: 5),
              InputTextFieldWG(
                controller: hospitalNameController,
                hintText: "Enter hospital name",
              ),

              const SizedBox(height: 18),

              _label('Hospital Type'),
              _dropdown(
                hint: 'Select Type',
                value: hospitalType,
                // clinic""general""teaching""specialist""diagnostic"
                items: const [
                  'clinic',
                  'general',
                  'teaching',
                  'specialist',
                  'diagnostic',
                ],
                onChanged: (v) => setState(() => hospitalType = v),
              ),

              const SizedBox(height: 18),

              _label('Address'),
              const SizedBox(height: 5),
              InputTextFieldWG(
                controller: addressController,
                hintText: "Street, City, State.",
              ),

              const SizedBox(height: 18),

              _label('Country'),
              _dropdown(
                hint: 'Select Country',
                value: country,
                items: const ['Nigeria', 'Ghana', 'Kenya', 'USA'],
                onChanged: (v) => setState(() => country = v),
              ),

              const SizedBox(height: 18),

              _label('State / Region / Province'),
              const SizedBox(height: 5),
              InputTextFieldWG(
                controller: stateController,
                hintText: "Enter State.",
              ),

              const SizedBox(height: 18),

              _label('City'),
              const SizedBox(height: 5),
              InputTextFieldWG(
                controller: cityController,
                hintText: "Enter City.",
              ),

              const SizedBox(height: 18),

              _label('Official Email Address'),
              const SizedBox(height: 5),
              InputTextFieldWG(
                controller: emailController,
                hintText: "e.g, hospitalemail@example.com",
              ),

              const SizedBox(height: 18),

              _label('Primary Contact Number'),
              const SizedBox(height: 5),
              InputTextFieldWG(
                controller: primaryPhoneController,
                hintText: "e.g, +234123456789",
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 18),

              _label('Emergency Hotline (Optional)'),
              const SizedBox(height: 5),
              InputTextFieldWG(
                controller: emergencyPhoneController,
                hintText: "e.g, +234123456789",
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 6),
              const Text(
                'This number will be shared for critical blood requests.',
                style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
              ),

              const SizedBox(height: 28),

              /// Verification
              const Text(
                'Verification',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 18),

              _label('Medical Registration / License Number'),
              const SizedBox(height: 5),
              InputTextFieldWG(
                controller: licenseNumberController,
                hintText: "Enter ID",
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
              if (widget.isEditMode)
                CustomButton(onPressed: _handleSave, text: "Save")
              else
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _handleSaveAndFinishLater,
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
                        onPressed: _handleContinue,
                        text: "Continue",
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  /// ------------------------------------------------------------
  /// Reusable widgets
  /// ------------------------------------------------------------

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        // fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _dropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      hint: Text(hint),
      items:
          items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      icon: const Icon(Icons.keyboard_arrow_down),
    );
  }

  Widget _uploadBox() {
    return GestureDetector(
      onTap: isUploading ? null : _pickAndUploadFile,
      child: Container(
        width: double.infinity,
        height: 120,
        decoration: BoxDecoration(
          color: uploadError != null
              ? const Color(0xFFFFEBEE)
              : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: uploadError != null ? Colors.red : const Color(0xFFE5E7EB),
            style: BorderStyle.solid,
          ),
        ),
        child: isUploading
            ? const Center(
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
              )
            : accreditationDocUrl != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check_circle,
                          size: 40, color: Colors.green),
                      const SizedBox(height: 8),
                      Text(
                        uploadedFileName ?? 'Document uploaded',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.green,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      GestureDetector(
                        onTap: _pickAndUploadFile,
                        child: const Text(
                          'Tap to change',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6B7280),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.image_outlined,
                          size: 32, color: Color(0xFF6B7280)),
                      const SizedBox(height: 8),
                      const Text(
                        'tap to upload PDF, JPG, PNG',
                        style:
                            TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
                      ),
                      if (uploadError != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          uploadError!,
                          style:
                              const TextStyle(fontSize: 11, color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
      ),
    );
  }

  Future<void> _pickAndUploadFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
        withData: false,
      );

      if (result != null && result.files.single.path != null) {
        final filePath = result.files.single.path!;
        final fileName = result.files.single.name;

        // Store file path in provider — actual upload happens after hospital creation
        context.read<HospitalProvider>().savePickedDocFilePath(filePath);

        setState(() {
          uploadedFileName = fileName;
          accreditationDocUrl = filePath; // non-null so validation passes
          uploadError = null;
        });
      }
    } catch (e) {
      setState(() {
        uploadError = 'Error picking file: $e';
      });
      SnackBarUtils.showError(context, 'Error picking file');
    }
  }
}

import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/constants/app_routes.dart';
import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/core/utils/snackbar_utils.dart';
import 'package:HealthBridge/data/models/specialist/specialist_profile_model.dart';
import 'package:HealthBridge/presentation/providers/patient_provider.dart';
import 'package:HealthBridge/presentation/providers/specialist_provider.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:HealthBridge/presentation/widgets/custom_button.dart';
import 'package:HealthBridge/presentation/widgets/input_text_field_wg.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class PatientSetProfileScreen extends StatefulWidget {
  const PatientSetProfileScreen({super.key});

  @override
  State<PatientSetProfileScreen> createState() =>
      _PatientSetProfileScreenState();
}

class _PatientSetProfileScreenState extends State<PatientSetProfileScreen> {
  String? bloodType;
  final TextEditingController _chronicIllnessesController =
      TextEditingController();
  final TextEditingController _allergiesController = TextEditingController();
  final TextEditingController _medicationsController = TextEditingController();
  final TextEditingController _existingConditionsController =
      TextEditingController();
  final TextEditingController _HMOController = TextEditingController();
  final TextEditingController _emergenceNameController =
      TextEditingController();
  final TextEditingController _emergencePhoneController =
      TextEditingController();
  final TextEditingController _primaryPhysicianController =
      TextEditingController();
  final TextEditingController _medicalNotesController = TextEditingController();

  List<SpecialistProfileModel> _specialists = [];
  SpecialistProfileModel? _selectedSpecialist;
  bool _loadingSpecialists = false;

  @override
  void initState() {
    super.initState();
    _loadMedicalData();
    _loadSpecialists();
  }

  void _loadMedicalData() {
    final provider = Provider.of<PatientProvider>(context, listen: false);
    final profile = provider.patientProfileM;

    if (profile != null && profile.role == "patient") {
      // Load existing medical data
      bloodType = profile.bloodType;
      _allergiesController.text = profile.allergies ?? '';
      _chronicIllnessesController.text = profile.chronicIllnesses ?? '';
      _existingConditionsController.text = profile.existing_conditions ?? '';
      _medicationsController.text = profile.medications ?? '';
      _HMOController.text = profile.hmoNumber ?? '';
      _primaryPhysicianController.text = profile.primary_physician ?? '';
      _emergenceNameController.text = profile.emergencyContactName ?? '';
      _emergencePhoneController.text = profile.emergencyContactPhone ?? '';
      _medicalNotesController.text = profile.medicalNotes ?? '';
    }
  }

  Future<void> _loadSpecialists() async {
    setState(() {
      _loadingSpecialists = true;
    });

    final specialistProvider =
        Provider.of<SpecialistProvider>(context, listen: false);

    // Fetch only non-suspended specialists
    final error = await specialistProvider.getSpecialists(
      suspended: false,
      verified: true,
    );

    if (error == null) {
      setState(() {
        _specialists = specialistProvider.specialists;

        // If there's a saved primary physician, try to find and select them
        if (_primaryPhysicianController.text.isNotEmpty) {
          try {
            _selectedSpecialist = _specialists.firstWhere(
              (s) => s.userId == _primaryPhysicianController.text,
            );
          } catch (e) {
            // Specialist not found in the list
            _selectedSpecialist = null;
          }
        }
      });
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not load specialists: $error')),
        );
      }
      debugPrint("General log: error is- $error");
    }

    setState(() {
      _loadingSpecialists = false;
    });
  }

  @override
  void dispose() {
    _chronicIllnessesController.dispose();
    _allergiesController.dispose();
    _medicationsController.dispose();
    _existingConditionsController.dispose();
    _HMOController.dispose();
    _emergenceNameController.dispose();
    _emergencePhoneController.dispose();
    _primaryPhysicianController.dispose();
    _medicalNotesController.dispose();
    super.dispose();
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
            const SizedBox(height: 8),

            /// Title
            const Text(
              'Complete Your Medical Profile',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 8),

            /// Subtitle
            const Text(
              'This helps us match you with the right specialists and ensure safe blood donation or requests.',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
              ),
            ),

            const SizedBox(height: 28),

            _label('Blood Type'),
            _bloodTypeDropdown(),

            const SizedBox(height: 18),

            _label('Allergies (Optional)'),
            const SizedBox(height: 5),
            InputTextFieldWG(
              controller: _allergiesController,
              hintText: "e.g., Peanuts, Penicillin",
            ),

            const SizedBox(height: 18),

            _label('Chronic Illnesses (Optional)'),
            const SizedBox(height: 5),
            InputTextFieldWG(
              controller: _chronicIllnessesController,
              hintText: "e.g., Hypertension, Diabetes",
              maxLines: 2,
            ),

            const SizedBox(height: 18),

            _label('Existing Conditions (Optional)'),
            const SizedBox(height: 5),
            InputTextFieldWG(
              controller: _existingConditionsController,
              hintText: "Any current medical conditions",
              maxLines: 2,
            ),

            const SizedBox(height: 18),

            _label('Current Medications (Optional)'),
            const SizedBox(height: 5),
            InputTextFieldWG(
              controller: _medicationsController,
              hintText: "e.g., Lisinopril 10mg",
              maxLines: 2,
            ),

            const SizedBox(height: 18),

            _label('HMO Number (Optional)'),
            const SizedBox(height: 5),
            InputTextFieldWG(
              controller: _HMOController,
              hintText: "Enter your HMO membership number",
            ),

            const SizedBox(height: 18),

            _label('Primary Physician (Optional)'),
            const SizedBox(height: 5),
            _primaryPhysicianDropdown(),

            const SizedBox(height: 28),

            /// Emergency Contact
            Row(
              children: const [
                Icon(Icons.star, color: Colors.amber, size: 18),
                SizedBox(width: 6),
                Text(
                  'Emergency Contact',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            _label('Contact Name'),
            const SizedBox(height: 5),
            InputTextFieldWG(
              controller: _emergenceNameController,
              hintText: "Full name of emergency contact",
            ),

            const SizedBox(height: 18),

            _label('Contact Phone Number'),
            const SizedBox(height: 5),
            InputTextFieldWG(
              controller: _emergencePhoneController,
              hintText: "Phone number to reach them in emergencies",
            ),

            const SizedBox(height: 18),

            _label('Medical Notes (Optional)'),
            const SizedBox(height: 5),
            InputTextFieldWG(
              controller: _medicalNotesController,
              hintText: "Any additional medical information...",
              maxLines: 3,
            ),

            const SizedBox(height: 32),

            /// Save Button
            Consumer<PatientProvider>(
              builder: (context, provider, child) {
                return CustomButton(
                  onPressed: _saveMedicalProfile,
                  text: "Save Medical Profile",
                  showLoading: provider.isLoading,
                );
              },
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  /// ------------------------------------------------------------
  /// Methods
  /// ------------------------------------------------------------

  Future<void> _saveMedicalProfile() async {
    context.hideKeyboard();
    // Validation
    if (bloodType == null || bloodType!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your blood type')),
      );
      return;
    }

    if (_emergenceNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an emergency contact name')),
      );
      return;
    }

    if (_emergencePhoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter an emergency contact phone')),
      );
      return;
    }

    final provider = Provider.of<PatientProvider>(context, listen: false);
    var primaryPhysician = _primaryPhysicianController.text.trim().isEmpty
        ? null
        : _primaryPhysicianController.text.trim();

    final error = await provider.updateMedicalInfo(
      allergies: _allergiesController.text.trim(),
      bloodType: bloodType!,
      chronicIllnesses: _chronicIllnessesController.text.trim(),
      existingConditions: _existingConditionsController.text.trim(),
      medications: _medicationsController.text.trim(),
      emergencyContactName: _emergenceNameController.text.trim(),
      emergencyContactPhone: _emergencePhoneController.text.trim(),
      hmoNumber: _HMOController.text.trim(),
      primaryPhysician: primaryPhysician, // I get "" here
      medicalNotes: _medicalNotesController.text.trim(),
    );

    if (error != null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
      debugPrint("General log: error is- $error");
      return;
    }

    // Success - navigate to next screen
    if (!mounted) return;
    SnackBarUtils.showSuccess(context, "Medical profile saved successfully!");
    context.replace(AppRoutes.patientConsent);
  }

  /// ------------------------------------------------------------
  /// Reusable Widgets
  /// ------------------------------------------------------------

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _bloodTypeDropdown() {
    return DropdownButtonFormField<String>(
      value: bloodType,
      hint: const Text('Select your blood type'),
      style: TextStyle(
        color: Colors.black,
        fontSize: 16,
      ),
      items: const [
        'A+',
        'A-',
        'B+',
        'B-',
        'AB+',
        'AB-',
        'O+',
        'O-',
      ]
          .map(
            (type) => DropdownMenuItem(
              value: type,
              child: Text(type),
            ),
          )
          .toList(),
      onChanged: (value) {
        setState(() => bloodType = value);
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.backgroundGray,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF10B981)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF10B981)),
        ),
      ),
      icon: const Icon(Icons.keyboard_arrow_down),
    );
  }

  Widget _primaryPhysicianDropdown() {
    if (_loadingSpecialists) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.backgroundGray,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF10B981)),
        ),
        child: const Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
              ),
            ),
            SizedBox(width: 12),
            Text('Loading specialists...'),
          ],
        ),
      );
    }

    return DropdownButtonFormField<SpecialistProfileModel>(
      value: _selectedSpecialist,
      hint: const Text('Select a specialist'),
      style: const TextStyle(
        color: Colors.black,
        fontSize: 16,
      ),
      items: _specialists.map(
        (specialist) {
          // Build display name
          String displayName;
          if (specialist.firstName.isNotEmpty ||
              specialist.lastName.isNotEmpty) {
            displayName =
                '${specialist.firstName} ${specialist.lastName}'.trim();
          } else {
            // Fallback to email if name is not available
            displayName = specialist.email;
          }

          return DropdownMenuItem<SpecialistProfileModel>(
            value: specialist,
            child: Text(displayName),
          );
        },
      ).toList(),
      onChanged: (value) {
        setState(() {
          _selectedSpecialist = value;
          // Store the user_id in the controller
          _primaryPhysicianController.text = value?.userId ?? '';
        });
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.backgroundGray,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.green),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.green),
        ),
      ),
      icon: const Icon(Icons.keyboard_arrow_down),
    );
  }
}

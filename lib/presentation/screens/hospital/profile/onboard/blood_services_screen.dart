import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/core/utils/snackbar_utils.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:HealthBridge/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_routes.dart';
import '../../../../../presentation/providers/hospital_provider.dart';

class BloodServicesScreen extends StatefulWidget {
  final bool isEditMode;
  const BloodServicesScreen({super.key, this.isEditMode = false});

  @override
  State<BloodServicesScreen> createState() => _BloodServicesScreenState();
}

class _BloodServicesScreenState extends State<BloodServicesScreen> {
  bool hasBloodBank = true;
  bool acceptingDonors = true;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  // Blood inventory controllers
  final Map<String, TextEditingController> bloodUnitsControllers = {};
  final Map<String, TextEditingController> bloodCapacityControllers = {};
  final Set<String> selectedBloodTypes = {};

  @override
  void initState() {
    super.initState();
    for (var bloodType in _bloodTypes) {
      bloodUnitsControllers[bloodType] = TextEditingController();
      bloodCapacityControllers[bloodType] = TextEditingController();
    }
    if (widget.isEditMode) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _prefillFromProfile());
    }
  }

  void _prefillFromProfile() {
    final profile = context.read<HospitalProvider>().hospitalProfile;
    if (profile == null) return;
    setState(() {
      hasBloodBank = profile.hasBloodBank;
      acceptingDonors = profile.acceptingDonors;
      for (var inv in profile.bloodInventory) {
        final displayType = _apiToDisplay(inv.bloodType);
        selectedBloodTypes.add(displayType);
        bloodUnitsControllers[displayType]?.text = inv.unitsAvailable.toString();
        bloodCapacityControllers[displayType]?.text = inv.bankCapacity.toString();
      }
      final hours = profile.donatingOperatingHours;
      if (hours.contains('-')) {
        final parts = hours.split('-');
        startTime = _parseTime(parts[0].trim());
        endTime = _parseTime(parts[1].trim());
      }
    });
  }

  String _apiToDisplay(String api) {
    const map = {
      'apositive': 'A+', 'anegative': 'A-',
      'bpositive': 'B+', 'bnegative': 'B-',
      'abpositive': 'AB+', 'abnegative': 'AB-',
      'opositive': 'O+', 'onegative': 'O-',
    };
    return map[api] ?? api;
  }

  TimeOfDay? _parseTime(String s) {
    try {
      final isPm = s.toUpperCase().contains('PM');
      final clean = s.replaceAll(RegExp(r'[AaPpMm\s]'), '');
      final parts = clean.split(':');
      int h = int.parse(parts[0]);
      final m = parts.length > 1 ? int.parse(parts[1]) : 0;
      if (isPm && h != 12) h += 12;
      if (!isPm && h == 12) h = 0;
      return TimeOfDay(hour: h, minute: m);
    } catch (_) {
      return null;
    }
  }

  @override
  void dispose() {
    // Dispose all controllers
    bloodUnitsControllers.forEach((_, controller) => controller.dispose());
    bloodCapacityControllers.forEach((_, controller) => controller.dispose());
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
              'Configure Your Blood Services',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 8),

            /// Subtitle
            const Text(
              'Tell us how your hospital manages blood availability and donation scheduling. This helps us match requests accurately.',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
              ),
            ),

            const SizedBox(height: 24),

            _label('Does Your Hospital Have a Blood Bank?'),
            const SizedBox(height: 10),
            _yesNoToggle(),

            const SizedBox(height: 24),

            /// Conditional Content
            hasBloodBank ? _bloodBankContent() : _noBloodBankContent(),

            const SizedBox(height: 32),

            CustomButton(
              onPressed: () => _handleContinue(),
              text: widget.isEditMode ? "Save" : "Continue",
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  /// ------------------------------------------------------------
  /// Widgets
  /// ------------------------------------------------------------

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    );
  }

  Widget _yesNoToggle() {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          _toggleItem('Yes', true),
          _toggleItem('No', false),
        ],
      ),
    );
  }

  Widget _toggleItem(String text, bool value) {
    final selected = hasBloodBank == value;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => hasBloodBank = value),
        child: Container(
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFB00000) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: selected ? Colors.white : Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  /// YES STATE --------------------------------------------------
  Widget _bloodBankContent() {
    return Column(
      children: [
        ..._bloodTypes.map(_bloodRow).toList(),

        const SizedBox(height: 20),

        /// Accepting donors
        Container(
          padding: const EdgeInsets.all(16),
          decoration: _cardDecoration(),
          child: Row(
            children: [
              const Icon(Icons.favorite, color: Colors.red),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Accepting Donors?',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Enable to accept new blood donation appointments.',
                      style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                    ),
                  ],
                ),
              ),
              Switch(
                value: acceptingDonors,
                activeColor: Colors.green,
                onChanged: (v) => setState(() => acceptingDonors = v),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        _label('Donation Operating Hours'),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: _timeBox('From', true)),
            const SizedBox(width: 12),
            Expanded(child: _timeBox('To', false)),
          ],
        ),
      ],
    );
  }

  Widget _bloodRow(String type) {
    final isSelected = selectedBloodTypes.contains(type);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedBloodTypes.remove(type);
          } else {
            selectedBloodTypes.add(type);
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: _cardDecoration(),
        child: Row(
          children: [
            _checkbox(isSelected),
            const SizedBox(width: 8),
            _chip(type),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Expanded(
                child: _inputSmall(
                    'Units available', bloodUnitsControllers[type]!),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _inputSmall(
                    'Bank Capacity', bloodCapacityControllers[type]!),
              ),
            ]
          ],
        ),
      ),
    );
  }

  /// NO STATE ---------------------------------------------------
  Widget _noBloodBankContent() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: _cardDecoration(),
      child: Column(
        children: const [
          Icon(Icons.favorite, size: 40, color: Colors.red),
          SizedBox(height: 12),
          Text(
            'Your hospital will still be able to request blood through HealthBridge when needed.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF6B7280)),
          ),
        ],
      ),
    );
  }

  /// Helpers ---------------------------------------------------
  Future<void> _handleContinue() async {
    if (!hasBloodBank) {
      widget.isEditMode ? _saveEditedBloodServices({
        'hasBloodBank': false,
        'acceptingDonors': false,
        'bloodInventory': [],
        'donatingOperatingHours': '',
      }) : _submitHospitalProfile();
      return;
    }

    // Validate blood services data
    if (startTime == null || endTime == null) {
      SnackBarUtils.showError(context, "Please select donation hours");
      return;
    }

    if (selectedBloodTypes.isEmpty) {
      SnackBarUtils.showError(context, "Please select at least one blood type");
      return;
    }

    // Validate that all selected blood types have units and capacity
    for (var bloodType in selectedBloodTypes) {
      if (bloodUnitsControllers[bloodType]!.text.isEmpty ||
          bloodCapacityControllers[bloodType]!.text.isEmpty) {
        SnackBarUtils.showError(
          context,
          "Please enter units and capacity for all selected blood types",
        );
        return;
      }
    }

    // Build blood inventory data
    final bloodInventory = _buildBloodInventory();

    final bloodServicesData = {
      'hasBloodBank': hasBloodBank,
      'acceptingDonors': acceptingDonors,
      'bloodInventory': bloodInventory,
      'donatingOperatingHours':
          '${startTime!.format(context)}-${endTime!.format(context)}',
    };

    if (widget.isEditMode) {
      await _saveEditedBloodServices(bloodServicesData);
    } else {
      context.read<HospitalProvider>().saveBloodServicesData(bloodServicesData);
      await _submitHospitalProfile();
    }
  }

  Future<void> _saveEditedBloodServices(Map<String, dynamic> bloodServicesData) async {
    context.showLoadingDialog();
    final hospitalProvider = context.read<HospitalProvider>();
    final existingProfile = hospitalProvider.hospitalProfile!;

    final payload = {
      'name': existingProfile.name,
      'hospital_type': existingProfile.hospitalType,
      'address': existingProfile.address,
      'country': existingProfile.country,
      'city': existingProfile.city,
      'email': existingProfile.email,
      'primary_phone': existingProfile.primaryPhone,
      'emergency_phone': existingProfile.emergencyPhone,
      'license_number': existingProfile.licenseNumber,
      'accreditation_doc_url': existingProfile.accreditationDocUrl ?? '',
      'has_blood_bank': bloodServicesData['hasBloodBank'],
      'accepting_donors': bloodServicesData['acceptingDonors'],
      'blood_inventory': bloodServicesData['bloodInventory'],
      'donating_operating_hours': bloodServicesData['donatingOperatingHours'],
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
      if (mounted) SnackBarUtils.showError(context, 'Failed to update blood services');
    }
  }

  Future<void> _submitHospitalProfile() async {
    context.showLoadingDialog();
    final hospitalProvider = context.read<HospitalProvider>();
    final payload = hospitalProvider.buildCompletePayload();

    try {
      // Step 1: Create hospital — send empty string since server expects a string type
      payload['accreditation_doc_url'] = '';
      final createError = await hospitalProvider.createHospital(payload);
      if (createError != null) {
        context.hideLoadingDialog();
        debugPrint("General log: createHospital error: $createError");
        if (mounted) SnackBarUtils.showError(context, createError);
        return;
      }

      // Step 2: Upload accreditation doc using the newly created hospital ID
      final hospitalId = hospitalProvider.hospitalProfile!.id;
      final filePath = hospitalProvider.pickedDocFilePath;

      if (filePath != null) {
        final uploadError =
            await hospitalProvider.uploadAccreditationDoc(filePath, hospitalId);
        if (uploadError != null) {
          context.hideLoadingDialog();
          debugPrint("General log: uploadAccreditationDoc error: $uploadError");
          if (mounted) SnackBarUtils.showError(context, uploadError);
          return;
        }

        // Step 3: Re-call createHospital with docUrl to update the record
        final docUrl = hospitalProvider.uploadedAccreditationUrl;
        if (docUrl != null) {
          payload['accreditation_doc_url'] = docUrl;
          final updateError = await hospitalProvider.createHospital(payload,
              hospitalId: hospitalId);
          if (updateError != null) {
            debugPrint("General log: doc url update error: $updateError");
          }
        }
      }

      context.hideLoadingDialog();
      if (mounted) {
        hospitalProvider.clearFormData();
        context.goNextScreen(AppRoutes.notificationsHospital);
      }
    } catch (e) {
      debugPrint("General log: Exception in _submitHospitalProfile - $e");
      if (mounted) {
        SnackBarUtils.showError(context, "Failed to create hospital profile");
      }
      context.hideLoadingDialog();
    }
  }

  List<Map<String, dynamic>> _buildBloodInventory() {
    final inventory = <Map<String, dynamic>>[];

    if (hasBloodBank) {
      for (var bloodType in selectedBloodTypes) {
        final units = bloodUnitsControllers[bloodType]?.text;
        final capacity = bloodCapacityControllers[bloodType]?.text;

        if (units != null &&
            units.isNotEmpty &&
            capacity != null &&
            capacity.isNotEmpty) {
          inventory.add({
            'blood_type': _mapBloodTypeToApi(bloodType),
            'units_available': int.tryParse(units) ?? 0,
            'bank_capacity': int.tryParse(capacity) ?? 0,
          });
        }
      }
    }

    return inventory;
  }

  String _mapBloodTypeToApi(String bloodType) {
    // Map UI blood types to API format (e.g., 'A+' -> 'apositive')
    final typeMap = {
      'A+': 'apositive',
      'A-': 'anegative',
      'B+': 'bpositive',
      'B-': 'bnegative',
      'AB+': 'abpositive',
      'AB-': 'abnegative',
      'O+': 'opositive',
      'O-': 'onegative',
    };
    return typeMap[bloodType] ?? 'apositive';
  }

  Widget _checkbox(bool selected) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: selected ? Colors.red : const Color(0xFFD1D5DB),
          width: 2,
        ),
        color: selected ? Colors.red : Colors.transparent,
      ),
      child: selected
          ? const Center(
              child: Icon(Icons.check, color: Colors.white, size: 14),
            )
          : null,
    );
  }

  Widget _inputSmall(String hint, TextEditingController controller) {
    return Expanded(
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
          filled: true,
          fillColor: const Color(0xFFF5F5F5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text),
    );
  }

  Widget _timeBox(String label, bool isStartTime) {
    final timeValue = isStartTime ? startTime : endTime;

    return InkWell(
      onTap: () async {
        context.hideKeyboard();
        final selectedTime = await showTimePicker(
          context: context,
          initialTime: timeValue ?? TimeOfDay.now(),
        );
        if (selectedTime != null) {
          setState(() {
            if (isStartTime) {
              startTime = selectedTime;
            } else {
              endTime = selectedTime;
            }
          });
        }
      },
      child: Container(
        height: 44,
        alignment: Alignment.center,
        decoration: _cardDecoration(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.access_time, color: Color(0xFF6B7280), size: 18),
            const SizedBox(width: 8),
            Text(
              timeValue != null ? timeValue.format(context) : label,
              style: TextStyle(
                fontSize: 13,
                color:
                    timeValue != null ? Colors.black : const Color(0xFF9CA3AF),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFFE5E7EB)),
    );
  }

  final List<String> _bloodTypes = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-'
  ];
}

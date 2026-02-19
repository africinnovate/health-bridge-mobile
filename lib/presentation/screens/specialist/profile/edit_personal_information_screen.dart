import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/core/utils/snackbar_utils.dart';
import 'package:HealthBridge/presentation/providers/specialist_provider.dart';
import 'package:HealthBridge/presentation/widgets/input_text_field_wg.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../widgets/cancel_button.dart';
import '../../../widgets/custom_button.dart';

class EditPersonalInformationScreen extends StatefulWidget {
  const EditPersonalInformationScreen({super.key});

  @override
  State<EditPersonalInformationScreen> createState() =>
      _EditPersonalInformationScreenState();
}

class _EditPersonalInformationScreenState
    extends State<EditPersonalInformationScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController primaryPhoneController = TextEditingController();

  String? selectedCountry;
  String? selectedState;

  final countries = [
    'Nigeria',
    'Ghana',
    'Kenya',
    'South Africa',
    'USA',
    'Canada',
    'UK',
  ];

  final Map<String, List<String>> statesByCountry = {
    'Nigeria': [
      'Lagos',
      'Abuja',
      'Rivers',
      'Kano',
      'Oyo',
      'Kaduna',
    ],
    'Ghana': ['Accra', 'Kumasi', 'Tema'],
    'Kenya': ['Nairobi', 'Mombasa', 'Kisumu'],
    'South Africa': ['Gauteng', 'Western Cape', 'KwaZulu-Natal'],
    'USA': ['California', 'New York', 'Texas', 'Florida'],
    'Canada': ['Ontario', 'Quebec', 'British Columbia'],
    'UK': ['England', 'Scotland', 'Wales', 'Northern Ireland'],
  };

  @override
  void initState() {
    super.initState();
    _loadExistingData();
  }

  void _loadExistingData() {
    final provider = Provider.of<SpecialistProvider>(context, listen: false);
    final profile = provider.specialistProfileM;

    if (profile != null) {
      setState(() {
        firstNameController.text = profile.firstName;
        lastNameController.text = profile.lastName;
        addressController.text = profile.address ?? '';
        cityController.text = profile.city ?? '';
        emailController.text = profile.email;
        primaryPhoneController.text = profile.primaryPhone ?? profile.phone ?? '';
        selectedCountry = profile.country;
        selectedState = profile.state;
      });
    }
  }

  Future<void> _saveChanges() async {
    context.hideKeyboard();

    // Validation
    if (firstNameController.text.trim().isEmpty) {
      SnackBarUtils.showError(context, 'Please enter first name');
      return;
    }
    if (lastNameController.text.trim().isEmpty) {
      SnackBarUtils.showError(context, 'Please enter last name');
      return;
    }
    if (addressController.text.trim().isEmpty) {
      SnackBarUtils.showError(context, 'Please enter address');
      return;
    }
    if (selectedCountry == null) {
      SnackBarUtils.showError(context, 'Please select country');
      return;
    }
    if (selectedState == null) {
      SnackBarUtils.showError(context, 'Please select state/region');
      return;
    }
    if (cityController.text.trim().isEmpty) {
      SnackBarUtils.showError(context, 'Please enter city');
      return;
    }
    if (primaryPhoneController.text.trim().isEmpty) {
      SnackBarUtils.showError(context, 'Please enter primary phone number');
      return;
    }

    final provider = Provider.of<SpecialistProvider>(context, listen: false);

    final error = await provider.updateSpecialistProfile(
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      address: addressController.text.trim(),
      city: cityController.text.trim(),
      state: selectedState,
      country: selectedCountry,
      primaryPhone: primaryPhoneController.text.trim(),
    );

    if (error != null) {
      SnackBarUtils.showError(context, error);
      return;
    }

    SnackBarUtils.showSuccess(context, "Personal information updated successfully!");
    context.goBack();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    addressController.dispose();
    cityController.dispose();
    emailController.dispose();
    primaryPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          'Edit Personal Information',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  Consumer<SpecialistProvider>(
                    builder: (context, provider, child) {
                      final profile = provider.specialistProfileM;
                      return CircleAvatar(
                        radius: 52,
                        backgroundImage: profile?.imageUrl != null
                            ? NetworkImage(profile!.imageUrl!)
                            : const AssetImage('assets/images/patient.png')
                                as ImageProvider,
                      );
                    },
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 30,
                      height: 30,
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
            const SizedBox(height: 30),
            const Text("First Name",
                style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 6),
            InputTextFieldWG(
              controller: firstNameController,
              hintText: "e.g, Sarah",
            ),
            const SizedBox(height: 10),
            const Text("Last Name",
                style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 6),
            InputTextFieldWG(
              controller: lastNameController,
              hintText: "e.g, Okonkwo",
            ),
            const SizedBox(height: 10),
            const Text("Address",
                style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 6),
            InputTextFieldWG(
              controller: addressController,
              hintText: "e.g, 123 Hospital Road, Victoria Island",
            ),
            const SizedBox(height: 4),
            const Text(
              "Supports any global address format.",
              style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
            ),
            const SizedBox(height: 10),
            _dropdown(
              'Country',
              selectedCountry,
              countries,
              (value) {
                setState(() {
                  selectedCountry = value;
                  selectedState = null; // Reset state when country changes
                });
              },
            ),
            Row(
              children: [
                Expanded(
                  child: _dropdown(
                    'State / Region',
                    selectedState,
                    selectedCountry != null
                        ? (statesByCountry[selectedCountry!] ?? [])
                        : [],
                    (value) {
                      setState(() {
                        selectedState = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("City",
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      const SizedBox(height: 6),
                      InputTextFieldWG(
                        controller: cityController,
                        hintText: "Lagos",
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text("Official Email Address",
                style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                emailController.text,
                style: const TextStyle(color: Color(0xFF9CA3AF)),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "Email cannot be changed",
              style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
            ),
            const SizedBox(height: 10),
            const Text("Primary Number",
                style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 6),
            InputTextFieldWG(
              controller: primaryPhoneController,
              hintText: "+234 800 555 1234",
            ),
            const SizedBox(height: 24),
            Consumer<SpecialistProvider>(
              builder: (context, provider, child) {
                return CustomButton(
                  onPressed: _saveChanges,
                  text: "Save Changes",
                  showLoading: provider.isLoading,
                );
              },
            ),
            const SizedBox(height: 12),
            CancelButton(),
          ],
        ),
      ),
    );
  }

  Widget _dropdown(String label, String? value, List<String> items,
      ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                hint: Text('Select $label'),
                items: items
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: onChanged,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
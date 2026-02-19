import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/core/utils/snackbar_utils.dart';
import 'package:HealthBridge/presentation/providers/patient_provider.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:HealthBridge/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String? selectedGender;
  String? selectedBloodType;
  DateTime? selectedDate;

  final List<String> bloodTypes = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-'
  ];

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  void _loadProfileData() {
    final provider = Provider.of<PatientProvider>(context, listen: false);
    final profile = provider.patientProfileM;

    if (profile != null) {
      _firstNameController.text = profile.firstName ?? '';
      _lastNameController.text = profile.lastName ?? '';
      _phoneController.text = profile.phone ?? '';
      _emailController.text = profile.email;
      _addressController.text = profile.address ?? '';
      selectedGender = profile.gender;

      // Use DOB directly if available
      if (profile.dob != null) {
        selectedDate = profile.dob!;
      }

      // Load blood type if role is patient
      // if (profile.role.toLowerCase() == 'patient') {
      selectedBloodType = profile.bloodType;
      // }
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      appBar: const CustomAppBar(
        title: 'Edit Profile',
        showArrow: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Profile Photo
                    Center(
                      child: Stack(
                        children: [
                          Consumer<PatientProvider>(
                            builder: (context, provider, child) {
                              final imageUrl =
                                  provider.patientProfileM?.image_url;
                              return Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  color: AppColors.red,
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image:
                                        imageUrl != null && imageUrl.isNotEmpty
                                            ? NetworkImage(imageUrl)
                                            : const AssetImage(
                                                    'assets/images/patient.png')
                                                as ImageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                _showPhotoOptions();
                              },
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: const BoxDecoration(
                                  color: AppColors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    /// Remove Photo
                    Center(
                      child: TextButton(
                        onPressed: () {
                          SnackBarUtils.showInfo(context, "Remove photo");
                        },
                        child: const Text(
                          'Remove Photo',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    /// First Name
                    const Text(
                      'First Name',
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
                        controller: _firstNameController,
                        decoration: const InputDecoration(
                          hintText: 'Enter first name',
                          hintStyle: TextStyle(fontWeight: FontWeight.w200),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                          prefixIcon: Icon(Icons.person_outline,
                              color: Color(0xFF9CA3AF)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    /// Last Name
                    const Text(
                      'Last Name',
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
                        controller: _lastNameController,
                        decoration: const InputDecoration(
                          hintText: 'Enter last name',
                          hintStyle: TextStyle(fontWeight: FontWeight.w200),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                          prefixIcon: Icon(Icons.person_outline,
                              color: Color(0xFF9CA3AF)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    /// Phone Number
                    const Text(
                      'Phone Number',
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
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          hintText: 'Enter phone number',
                          hintStyle: TextStyle(fontWeight: FontWeight.w200),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                          prefixIcon: Icon(Icons.phone_outlined,
                              color: Color(0xFF9CA3AF)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    /// Email Address (Non-editable)
                    const Text(
                      'Email Address',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: TextField(
                        controller: _emailController,
                        enabled: false,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                          prefixIcon: Icon(Icons.email_outlined,
                              color: Color(0xFF9CA3AF)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Email cannot be changed',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                    const SizedBox(height: 20),

                    /// Date of Birth
                    const Text(
                      'Date of Birth',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate ?? DateTime(1995, 1, 15),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: AppColors.red,
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null) {
                          setState(() {
                            selectedDate = picked;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today,
                                color: Color(0xFF9CA3AF), size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                selectedDate != null
                                    ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                                    : 'Select date of birth',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: selectedDate != null
                                      ? const Color(0xFF374151)
                                      : const Color(0xFF9CA3AF),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    /// Gender
                    const Text(
                      'Gender',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _genderOption('Male'),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _genderOption('Female'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    /// Blood Type
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Blood Type',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedBloodType,
                              hint: const Text('Select blood type'),
                              isExpanded: true,
                              icon: const Icon(Icons.keyboard_arrow_down,
                                  color: Color(0xFF9CA3AF)),
                              items: bloodTypes.map((String type) {
                                return DropdownMenuItem<String>(
                                  value: type,
                                  child: Text(type),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedBloodType = newValue;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),

                    /// Address
                    const Text(
                      'Address',
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
                        controller: _addressController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          hintText: 'Enter address',
                          hintStyle: TextStyle(fontWeight: FontWeight.w200),
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
              padding: const EdgeInsets.all(10),
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
                  Consumer<PatientProvider>(
                    builder: (context, provider, child) {
                      return CustomButton(
                        onPressed: _saveProfile,
                        text: 'Save Changes',
                        showLoading: provider.isLoading,
                      );
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

  Widget _genderOption(String gender) {
    final isSelected = selectedGender == gender;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedGender = gender;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFEE2E2) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.red : const Color(0xFFE5E7EB),
          ),
        ),
        child: Center(
          child: Text(
            gender,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isSelected ? AppColors.red : const Color(0xFF6B7280),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveProfile() async {
    context.hideKeyboard();
    // Validation
    if (_firstNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your first name')),
      );
      return;
    }

    if (_lastNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your last name')),
      );
      return;
    }

    if (_phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your phone number')),
      );
      return;
    }

    final provider = Provider.of<PatientProvider>(context, listen: false);

    // Format date to ISO 8601 string (YYYY-MM-DD)
    String? dobString;
    if (selectedDate != null) {
      dobString =
          '${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}';
    }

    final error = await provider.updateProfile(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      phone: _phoneController.text.trim(),
      gender: (selectedGender ?? "male").toLowerCase(),
      dob: dobString,
      address: _addressController.text.trim(),
      // imageUrl will be updated separately when photo upload is implemented
    );

    if (error != null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
      debugPrint("General log: error is $error");
      return;
    }

    // Success
    if (!mounted) return;
    SnackBarUtils.showSuccess(context, "Profile updated successfully!");
    Navigator.pop(context);
  }

  void _showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppColors.red),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                SnackBarUtils.showInfo(context, "Camera opened");
                // TODO: Implement camera photo upload
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: AppColors.red),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                SnackBarUtils.showInfo(context, "Gallery opened");
                // TODO: Implement gallery photo upload
              },
            ),
          ],
        ),
      ),
    );
  }
}

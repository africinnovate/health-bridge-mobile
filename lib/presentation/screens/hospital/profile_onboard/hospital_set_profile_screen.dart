import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/input_text_field_wg.dart';

class HospitalProfileScreen extends StatefulWidget {
  const HospitalProfileScreen({super.key});

  @override
  State<HospitalProfileScreen> createState() => _HospitalProfileScreenState();
}

class _HospitalProfileScreenState extends State<HospitalProfileScreen> {
  String? hospitalType;
  String? country;
  String? state;

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
              const Text(
                'Set Up Your Hospital Profile',
                style: TextStyle(
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
              InputTextFieldWG(hintText: "Enter hospital name"),

              const SizedBox(height: 18),

              _label('Hospital Type'),
              _dropdown(
                hint: 'Select Type',
                value: hospitalType,
                items: const [
                  'General Hospital',
                  'Specialist Hospital',
                  'Clinic',
                  'Teaching Hospital',
                ],
                onChanged: (v) => setState(() => hospitalType = v),
              ),

              const SizedBox(height: 18),

              _label('Address'),
              const SizedBox(height: 5),
              InputTextFieldWG(hintText: "Street, City, State."),

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
              InputTextFieldWG(hintText: "Enter State."),
              // _dropdown(
              //   hint: 'Select State / Region',
              //   value: state,
              //   items: const ['Lagos', 'Abuja', 'Rivers'],
              //   onChanged: (v) => setState(() => state = v),
              // ),

              const SizedBox(height: 18),

              _label('City'),
              const SizedBox(height: 5),
              InputTextFieldWG(hintText: "Enter City."),

              const SizedBox(height: 18),

              _label('Official Email Address'),
              const SizedBox(height: 5),
              InputTextFieldWG(hintText: "e.g, hospitalemail@example.com"),

              const SizedBox(height: 18),

              _label('Primary Contact Number'),
              const SizedBox(height: 5),
              InputTextFieldWG(hintText: "e.g, +234123456789"),

              const SizedBox(height: 18),

              _label('Emergency Hotline (Optional)'),
              const SizedBox(height: 5),
              InputTextFieldWG(hintText: "e.g, +234123456789"),

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
              InputTextFieldWG(hintText: "Enter ID"),

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
                        context.goNextScreen(AppRoutes.bloodServiceHospital);
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
                        // TODO: Save profile to api before going to next screen
                        context.goNextScreen(AppRoutes.bloodServiceHospital);
                      },
                      text: "Continue",
                      // shouldProceed: true,
                      // showLoading: false,
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
            'tap to upload PDF, JPG, PNG',
            style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
          ),
        ],
      ),
    );
  }
}

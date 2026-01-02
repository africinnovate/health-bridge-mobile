import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/constants/app_routes.dart';
import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:HealthBridge/presentation/widgets/custom_button.dart';
import 'package:HealthBridge/presentation/widgets/input_text_field_wg.dart';
import 'package:flutter/material.dart';

class PatientSetProfileScreen extends StatefulWidget {
  const PatientSetProfileScreen({super.key});

  @override
  State<PatientSetProfileScreen> createState() =>
      _PatientSetProfileScreenState();
}

class _PatientSetProfileScreenState extends State<PatientSetProfileScreen> {
  String? bloodType;
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _illnessController = TextEditingController();
  final TextEditingController _allergiesController = TextEditingController();
  final TextEditingController _HMOController = TextEditingController();
  final TextEditingController _emergenceNameController =
      TextEditingController();
  final TextEditingController _emergencePhoneController =
      TextEditingController();

  final List<String> illnesses = ['Nuts', 'Penicillin'];
  final List<String> allergies = ['Nuts', 'Penicillin'];

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

            _label('Your Full Name'),
            const SizedBox(height: 5),
            InputTextFieldWG(
              controller: _fullNameController,
              hintText: "Enter your full name",
            ),
            // _inputField('Enter your full name'),

            const SizedBox(height: 18),

            _label('Blood Type'),
            _bloodTypeDropdown(),

            const SizedBox(height: 18),

            _label('Chronic Illnesses (Optional)'),
            const SizedBox(height: 5),
            InputTextFieldWG(
              controller: _illnessController,
              hintText: "Start typing...",
            ),
            const SizedBox(height: 8),
            _chipWrap(illnesses),

            const SizedBox(height: 18),

            _label('Allergies (Optional)'),
            const SizedBox(height: 5),
            InputTextFieldWG(
              controller: _allergiesController,
              hintText: "Start typing...",
            ),
            const SizedBox(height: 8),
            _chipWrap(allergies),

            const SizedBox(height: 18),

            _label('HMO Number'),
            const SizedBox(height: 5),
            InputTextFieldWG(
              controller: _HMOController,
              hintText: "Enter your HMO membership number.",
            ),

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
              controller: _HMOController,
              hintText: "Full name of your emergency contact.",
            ),

            const SizedBox(height: 18),

            _label('Contact Phone Number'),
            const SizedBox(height: 5),
            InputTextFieldWG(
              controller: _HMOController,
              hintText: "Phone number to reach them in emergencies",
            ),

            const SizedBox(height: 32),

            /// Save Button
            CustomButton(
              onPressed: () {
                context.goNextScreen(AppRoutes.patientConsent);
              },
              text: "Save Medical Profile",
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
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
        color: Color(0xFF9CA3AF).withOpacity(0.3),
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

  Widget _chipWrap(List<String> items) {
    return Wrap(
      spacing: 8,
      children: items
          .map(
            (item) => Chip(
              label: Text(item),
              backgroundColor: Color(0xFFF5F5F5).withOpacity(0.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide.none,
              ),
            ),
          )
          .toList(),
    );
  }
}

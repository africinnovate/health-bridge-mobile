import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/core/utils/snackbar_utils.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:HealthBridge/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/app_routes.dart';

class BloodServicesScreen extends StatefulWidget {
  const BloodServicesScreen({super.key});

  @override
  State<BloodServicesScreen> createState() => _BloodServicesScreenState();
}

class _BloodServicesScreenState extends State<BloodServicesScreen> {
  bool hasBloodBank = true;
  bool acceptingDonors = true;

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

            /// Continue
            CustomButton(
              onPressed: () {
                // TODO: Save to api first if hasBloodBank == true,
                context.goNextScreen(AppRoutes.notificationsHospital);
              },
              text: "Continue",
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
            Expanded(child: _timeBox()),
            const SizedBox(width: 12),
            Expanded(child: _timeBox()),
          ],
        ),
      ],
    );
  }

  Widget _bloodRow(String type) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          _radio(type == 'A+'),
          const SizedBox(width: 8),
          _chip(type),
          const SizedBox(width: 8),
          _inputSmall('Units available'),
          const SizedBox(width: 8),
          _inputSmall('Bank Capacity'),
        ],
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
  Widget _radio(bool selected) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? Colors.red : const Color(0xFFD1D5DB),
          width: 2,
        ),
      ),
      child: selected
          ? const Center(
              child: CircleAvatar(radius: 4, backgroundColor: Colors.red),
            )
          : null,
    );
  }

  Widget _inputSmall(String hint) {
    return Expanded(
      child: TextField(
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

  Widget _timeBox() {
    return InkWell(
      onTap: () {
        SnackBarUtils.showInfo(context, "In progress");
      },
      child: Container(
        height: 44,
        alignment: Alignment.center,
        decoration: _cardDecoration(),
        child: const Icon(Icons.access_time, color: Color(0xFF6B7280)),
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

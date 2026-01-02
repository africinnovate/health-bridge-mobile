import 'package:HealthBridge/core/utils/snackbar_utils.dart';
import 'package:HealthBridge/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import '../../../../../core/utils/dialog.dart';

class PatientConsentScreen extends StatefulWidget {
  const PatientConsentScreen({super.key});

  @override
  State<PatientConsentScreen> createState() => _PatientConsentScreenState();
}

class _PatientConsentScreenState extends State<PatientConsentScreen> {
  bool medicalPolicy = false;
  bool specialistAccess = false;
  bool hospitalAccess = false;
  bool termsAccepted = false;

  bool get canContinue =>
      medicalPolicy && specialistAccess && hospitalAccess && termsAccepted;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            /// Title
            const Text(
              'Before You Continue',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            /// Subtitle
            const Text(
              'We need your permission to securely use your medical '
              'information to provide safe care and accurate matches.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 24),

            /// Checkboxes
            _buildCheckbox(
              value: medicalPolicy,
              onChanged: (v) => setState(() => medicalPolicy = v!),
              title: 'I agree to HealthBridge’s medical data handling policy.',
              subtitle:
                  'We securely store and use your health information to support your care.',
            ),

            _buildCheckbox(
              value: specialistAccess,
              onChanged: (v) => setState(() => specialistAccess = v!),
              title:
                  'I allow verified specialists to access my medical profile '
                  'for consultations and referrals.',
            ),

            _buildCheckbox(
              value: hospitalAccess,
              onChanged: (v) => setState(() => hospitalAccess = v!),
              title: 'I allow partner hospitals to access my information '
                  'for blood donation and request coordination.',
            ),

            _buildCheckbox(
              value: termsAccepted,
              onChanged: (v) => setState(() => termsAccepted = v!),
              title: 'I agree to the Terms of Use and Privacy Policy.',
            ),

            const Spacer(),

            /// Footer note
            const Text(
              'Your data is protected and only shared with verified '
              'medical professionals when necessary.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.black45,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 16),

            /// Button
            CustomButton(
              onPressed: () {
                showThankYouDialog(
                  context,
                  onContinue: () {
                    SnackBarUtils.showInfo(context, "on it");
                  },
                );
              },
              text: "Accept & Continue",
              shouldProceed: canContinue,
              showLoading: false,
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckbox({
    required bool value,
    required ValueChanged<bool?> onChanged,
    required String title,
    String? subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFFD32F2F),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 14),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }
}

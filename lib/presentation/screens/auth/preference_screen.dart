import 'package:HealthBridge/core/constants/app_routes.dart';
import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/presentation/providers/auth_provider.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:HealthBridge/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PreferenceScreen extends StatefulWidget {
  const PreferenceScreen({super.key});

  @override
  State<PreferenceScreen> createState() => _PreferenceScreenState();
}

class _PreferenceScreenState extends State<PreferenceScreen> {
  String? selectedRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),

            /// Title
            const Text(
              'Start Your HealthBridge Journey',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 8),

            /// Subtitle
            const Text(
              'Select your role to unlock tools built for Patients, Hospitals, and Specialists.',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
              ),
            ),

            const SizedBox(height: 24),

            /// Cards
            RoleCard(
              title: 'Patient',
              description:
                  'Get medical support, book sick calls, access partnered specialists, and manage your care in one place.',
              value: 'patient',
              groupValue: selectedRole,
              onChanged: (value) {
                setState(() => selectedRole = value);
              },
            ),

            const SizedBox(height: 12),

            RoleCard(
              title: 'Donor',
              description: 'Donate to hospitals and support patients in need.',
              value: 'donor',
              groupValue: selectedRole,
              onChanged: (value) {
                setState(() => selectedRole = value);
              },
            ),

            const SizedBox(height: 12),

            RoleCard(
              title: 'Specialist',
              description:
                  'Consult with patients, manage your appointments, and provide reports through the HealthBridge network.',
              value: 'specialist',
              groupValue: selectedRole,
              onChanged: (value) {
                setState(() => selectedRole = value);
              },
            ),

            const SizedBox(height: 12),

            RoleCard(
              title: 'Hospital',
              description:
                  'Receive patient referrals, manage blood requests, update availability, and collaborate with specialists.',
              value: 'hospital',
              groupValue: selectedRole,
              onChanged: (value) {
                setState(() => selectedRole = value);
              },
            ),

            const Spacer(),

            /// Continue Button
            CustomButton(
              onPressed: () async {
                var authProvider = context.read<AuthProvider>();
                authProvider.role = selectedRole!;
                // Handle navigation
                context.goNextScreen(AppRoutes.createAccount);
              },
              text: "Continues",
              shouldProceed: selectedRole != null,
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

/// Role Card Widget
class RoleCard extends StatelessWidget {
  final String title;
  final String description;
  final String value;
  final String? groupValue;
  final ValueChanged<String> onChanged;

  const RoleCard({
    super.key,
    required this.title,
    required this.description,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;

    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color:
                isSelected ? const Color(0xFFB00000) : const Color(0x1A6B7280),
            width: 1.2,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            /// Radio Indicator
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFB00000)
                      : const Color(0xFF9CA3AF),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Color(0xFFB00000),
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:HealthBridge/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class HospitalSetupCompleteScreen extends StatelessWidget {
  const HospitalSetupCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 40),

                    /// Success icon
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green.withOpacity(0.08),
                      ),
                      child: Center(
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green.withOpacity(0.18),
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.green,
                            size: 42,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    /// Title
                    const Text(
                      'Your Hospital Is Ready',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// Description
                    const Text(
                      'You’ve successfully completed all setup steps. Your '
                      'hospital can now request blood, manage donation '
                      'appointments, and stay updated in real time.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 28),

                    /// What you can do next card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Text(
                            'What You Can Do Next',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 12),
                          _NextActionItem('Request blood when needed'),
                          _NextActionItem('View incoming donors'),
                          _NextActionItem('Update blood availability'),
                          _NextActionItem('Track past and pending requests'),
                          _NextActionItem('Manage hospital notifications'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// Footer text
                    const Text(
                      'You can update your settings anytime in your profile.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// Bottom button

            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: CustomButton(
                  onPressed: () {
                    // TODO: Navigate to dashboard
                  },
                  text: "Go to Dashboard",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ---------- Small reusable text row ----------
class _NextActionItem extends StatelessWidget {
  final String text;

  const _NextActionItem(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF4B5563),
        ),
      ),
    );
  }
}

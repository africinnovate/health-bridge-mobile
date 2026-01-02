import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/presentation/widgets/cancel_button.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:HealthBridge/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class DonationReceiptScreen extends StatelessWidget {
  const DonationReceiptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      appBar: const CustomAppBar(
        title: 'Donation Receipt',
        showArrow: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Subtitle
            const Text(
              'Here are the official details of your completed donation.',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 24),

            /// Receipt Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  /// HealthBridge Icon
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.green.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.receipt,
                      color: AppColors.green,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 12),

                  /// App Name
                  const Text(
                    'HealthBridge',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),

                  /// Details
                  _detailRow('Donation Type:', 'Whole Blood'),
                  const SizedBox(height: 16),
                  _detailRow('Date:', 'Sun, Nov 23, 2025'),
                  const SizedBox(height: 16),
                  _detailRow('Time:', '9 AM'),
                  const SizedBox(height: 16),
                  _detailRow('Hospital:', 'St. Catherine Medical Center'),
                  const SizedBox(height: 16),
                  _detailRow('Units Donated:', '1 Unit (~450ml)'),
                  const SizedBox(height: 16),
                  _detailRow('Donor ID:', 'HB-DN-88402'),
                  const SizedBox(height: 16),
                  _detailRow('Reference ID:', 'HB-DB-39402'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            /// Verify Donation Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  const Text(
                    'Verify Donation',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Scan this code to confirm donation details at any\npartnered center.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF6B7280),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),

                  /// QR Code Placeholder
                  Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.qr_code_2,
                        size: 140,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  /// Receipt Info
                  const Text(
                    'This receipt serves as an official record of your\nvoluntary blood donation.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Receipt generated on 15 Aug 2025 at 10:15 AM',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Receipt No: RCP-2025-08-15-88402',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            /// Download Button
            CustomButton(
              onPressed: () {
                // Handle download PDF logic
              },
              text: 'Download PDF Receipt',
            ),
            const SizedBox(height: 12),

            /// Share Button
            CancelButton(
              text: 'Share Receipt',
              onPressed: () {
                // Handle share receipt logic
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF6B7280),
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

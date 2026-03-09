import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/constants/app_routes.dart';
import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/data/models/donor/donation_history_model.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:HealthBridge/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class DonationDetailsScreen extends StatelessWidget {
  final DonationHistoryModel? donation;

  const DonationDetailsScreen({super.key, this.donation});

  @override
  Widget build(BuildContext context) {
    if (donation == null) {
      return Scaffold(
        backgroundColor: AppColors.backgroundGray,
        appBar: const CustomAppBar(
          title: 'Donation Details',
          showArrow: true,
        ),
        body: const Center(
          child: Text('No donation details available'),
        ),
      );
    }

    final statusColor = donation!.statusColor == 'green'
        ? AppColors.green
        : donation!.statusColor == 'red'
            ? Colors.red
            : Colors.orange;

    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      appBar: const CustomAppBar(
        title: 'Donation Details',
        showArrow: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            /// Status Icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                donation!.isCompleted ? Icons.check : Icons.hourglass_empty,
                color: statusColor,
                size: 60,
              ),
            ),
            const SizedBox(height: 20),

            /// Title
            Text(
              donation!.isCompleted
                  ? 'Donation Completed'
                  : donation!.requestStatus[0].toUpperCase() +
                      donation!.requestStatus.substring(1),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            /// Subtitle
            Text(
              donation!.isCompleted
                  ? 'Your donation has been successfully recorded.'
                  : 'Status: ${donation!.requestStatus}',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 32),

            /// Details Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  _detailRow('Donation Type:', 'Whole Blood'),
                  const SizedBox(height: 16),
                  _detailRow('Date:', donation!.formattedDate),
                  const SizedBox(height: 16),
                  _detailRow('Status:', donation!.requestStatus[0].toUpperCase() +
                      donation!.requestStatus.substring(1)),
                  const SizedBox(height: 16),
                  _detailRow('Reference ID:', donation!.refId),
                  const SizedBox(height: 16),
                  _detailRow('Units Donated:', donation!.formattedUnits),
                ],
              ),
            ),
            const SizedBox(height: 20),

            /// Take Care Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFEE2E2),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Take Care of Yourself',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Drink plenty of water',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF6B7280),
                      height: 1.6,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Avoid heavy exercise for 24 hours',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF6B7280),
                      height: 1.6,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Eat iron-rich meals (spinach, red meat, beans)',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF6B7280),
                      height: 1.6,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Rest if you feel dizzy or lightheaded',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF6B7280),
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            /// Impact Section (only for completed donations)
            if (donation!.isCompleted)
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: AppColors.green.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.waves,
                            color: AppColors.green,
                            size: 30,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'You Made a Difference',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Your donation can help save up to\nthree lives.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Join 10,000+ donors making an impact',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              )
            else
              const SizedBox(height: 20),

            /// View Receipt Button
            CustomButton(
              onPressed: () {
                context.goNextScreenWithData(AppRoutes.donationReceipt,
                    extra: donation);
              },
              text: 'View Donation Receipt',
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
            fontSize: 14,
            color: Color(0xFF6B7280),
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

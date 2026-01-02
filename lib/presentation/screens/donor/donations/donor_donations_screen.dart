import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/constants/app_routes.dart';
import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/core/utils/dialog.dart';
import 'package:HealthBridge/core/utils/snackbar_utils.dart';
import 'package:HealthBridge/presentation/widgets/cancel_button.dart';
import 'package:HealthBridge/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class DonorDonationsScreen extends StatefulWidget {
  const DonorDonationsScreen({super.key});

  @override
  State<DonorDonationsScreen> createState() => _DonorDonationsScreenState();
}

class _DonorDonationsScreenState extends State<DonorDonationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              /// Title
              const Text(
                'Donate Blood',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              /// Subtitle
              const Text(
                'Give hope, save lives. Track your donation journey and manage your appointments.',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 24),

              /// Become a Donor Card
              _buildBecomeDonorCard(),
              const SizedBox(height: 32),

              /// Your next Appointment
              const Text(
                'Your next Appointment',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              _buildAppointmentCard(),
              const SizedBox(height: 32),

              /// Past Donations
              const Text(
                'Past Donations',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              _buildDonationHistoryCard(),
              const SizedBox(height: 16),
              _buildDonationHistoryCard(),
              const SizedBox(height: 16),
              _buildDonationHistoryCard(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBecomeDonorCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5F5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFFE4E6), width: 1),
      ),
      child: Column(
        children: [
          /// Icon
          Container(
            width: 64,
            height: 64,
            child: Image.asset(
              'assets/images/drip_icon.jpg',
              width: 32,
              height: 32,
            ),
          ),
          const SizedBox(height: 16),

          /// Title
          const Text(
            'Become a Donor',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),

          /// Subtitle
          const Text(
            'Check if you\'re eligible and book a donation appointment.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 20),

          /// Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: CustomButton(
              onPressed: () {
                context.goNextScreen(AppRoutes.nearbyHospitals);
              },
              text: "Start Donation",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentCard() {
    return GestureDetector(
      onTap: () {
        context.goNextScreenWithData(AppRoutes.donorAppointmentDetail,
            extra: "upcoming");
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/images/patient.png',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Emmanuel General Hospital',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '16 Hospital Road, Eket Akwal-bom State',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            /// Info Row
            Row(
              children: [
                Expanded(
                  child: _infoColumn('Requested', '500 ml'),
                ),
                Expanded(
                  child: _infoColumn('Time', '14:00 AM'),
                ),
                Expanded(
                  child: _infoColumn('Date', 'May 3rd'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CancelButton(
              text: 'Cancel',
              onPressed: () {
                showConfirmDialog(
                  context,
                  title: "Cancel Appointment",
                  message:
                      "Are you sure you want to cancel this appointment? You won't be able to undo this action.",
                  confirmText: "Yes, Cancel Appointment",
                  cancelText: "Keep Appointment",
                  onConfirm: () {
                    // handle cancel logic here
                    SnackBarUtils.showInfo(context, "in progress");
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDonationHistoryCard() {
    return GestureDetector(
      onTap: () {
        context.goNextScreen(AppRoutes.donationDetails);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                /// Blood drop icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFEE2E2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.water_drop,
                    color: Colors.red,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Blood Donation',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Completed',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            /// Info Grid
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _historyInfoItem('Date', 'March 8, 2025'),
                      const SizedBox(height: 12),
                      _historyInfoItem('Blood Type', 'O+'),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _historyInfoItem('Location', 'City Hospital'),
                      const SizedBox(height: 12),
                      _historyInfoItem('Units Donated', '450ml'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            /// Impact Banner
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFDCFCE7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: const [
                  Icon(
                    Icons.favorite,
                    color: AppColors.green,
                    size: 16,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Your donation can save up to 3 lives',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _historyInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

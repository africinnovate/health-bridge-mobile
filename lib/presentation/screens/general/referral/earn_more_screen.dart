import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class EarnMoreScreen extends StatelessWidget {
  const EarnMoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _Header(),
            SizedBox(height: 24),
            _InviteCard(),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Invite & Earn\nRewards',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),
        SizedBox(height: 12),
        Text(
          'Help us build a healthier community while earning exclusive benefits.',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }
}

class _InviteCard extends StatelessWidget {
  const _InviteCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Icon
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFEE2E2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.share,
              color: AppColors.red,
            ),
          ),

          const SizedBox(height: 20),

          /// Title
          const Text(
            'Grow the\nRubiMedik\nCommunity',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),

          const SizedBox(height: 12),

          /// Description
          const Text(
            'Invite patients, specialists, or medical centers using a single link. Earn exclusive rewards for every successful connection you facilitate.',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
              height: 1.5,
            ),
          ),

          const SizedBox(height: 16),

          /// Reward Tag
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFDECEC),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'REWARDS: 1 POINT = ₦500',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 24),

          /// Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO - use the actual link from api later
                context.copyText(
                    textToCopy: "https://rubimedik.com/invite?code=ABCD1234");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(
                Icons.copy,
                size: 18,
                color: AppColors.white,
              ),
              label: const Text(
                'Copy Invite Link',
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: AppColors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

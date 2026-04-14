import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/constants/app_routes.dart';
import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:flutter/material.dart';

class ReferralWalletScreen extends StatelessWidget {
  const ReferralWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Referral Wallet',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        leading: const BackButton(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _WalletCard(),
            SizedBox(height: 24),
            _RewardHeader(),
            SizedBox(height: 12),
            // TODO _ change later to real api data
            _RewardItem(
              title: 'Free consultation credit earned',
              date: 'NOV 24, 2023',
              points: '+1.0 Point',
              isPositive: true,
              icon: Icons.card_giftcard,
            ),
            _RewardItem(
              title: 'Referral pending verification',
              date: 'NOV 22, 2023',
              points: 'Pending',
              isPending: true,
              icon: Icons.group,
            ),
            _RewardItem(
              title: 'Reward applied',
              date: 'NOV 18, 2023',
              points: '-20.0 Point',
              isPositive: false,
              icon: Icons.shopping_bag,
            ),
          ],
        ),
      ),
    );
  }
}

class _WalletCard extends StatelessWidget {
  const _WalletCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFFB91C1C), Color(0xFFEF4444)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'TOTAL REWARD CREDITS',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: '20.0 ',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: 'Point',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            '₦10,000',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 20),

          /// Buttons
          Row(
            children: [
              Expanded(
                child: InkWell(
                    onTap: () =>
                        context.goNextScreen(AppRoutes.referralAnalytic),
                    child: _ghostButton('Analytics')),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InkWell(
                  onTap: () => context.goNextScreen(AppRoutes.referralEarnMore),
                  child: _whiteButton('Earn More'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _ghostButton(String text) {
    return Container(
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _whiteButton(String text) {
    return Container(
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.red,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _RewardHeader extends StatelessWidget {
  const _RewardHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Text(
          'Reward History',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          'Filter',
          style: TextStyle(
            color: AppColors.red,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _RewardItem extends StatelessWidget {
  final String title;
  final String date;
  final String points;
  final bool isPositive;
  final bool isPending;
  final IconData icon;

  const _RewardItem({
    required this.title,
    required this.date,
    required this.points,
    this.isPositive = false,
    this.isPending = false,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          /// Icon
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20),
          ),
          const SizedBox(width: 12),

          /// Texts
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          /// Status / Points
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                points,
                style: TextStyle(
                  color: isPending
                      ? AppColors.textGray
                      : isPositive
                          ? AppColors.green
                          : AppColors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              if (!isPending)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isPositive
                        ? AppColors.green.withOpacity(0.1)
                        : AppColors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    points.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      color: isPositive ? AppColors.green : AppColors.red,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

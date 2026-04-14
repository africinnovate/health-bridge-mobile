import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:flutter/material.dart';

class NetworkGrowthScreen extends StatelessWidget {
  const NetworkGrowthScreen({super.key});

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
            SizedBox(height: 20),
            _StatCard(
              title: 'PATIENTS REFERRED',
              count: '3',
              label: 'Active',
              progress: 0.7,
              icon: Icons.people,
              isPrimary: true,
            ),
            SizedBox(height: 16),
            _StatCard(
              title: 'SPECIALISTS REFERRED',
              count: '1',
              label: 'Verified',
              progress: 0.3,
              icon: Icons.medical_services,
            ),
            SizedBox(height: 16),
            _StatCard(
              title: 'HOSPITALS REFERRED',
              count: '0',
              label: 'Pending',
              progress: 0.0,
              icon: Icons.local_hospital,
              isDashed: true,
            ),
            SizedBox(height: 24),
            _EarnedRewardsCard(),
            SizedBox(height: 24),
            _RecentActivity(),
            SizedBox(height: 24),
            _ShareCard(),
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
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Network Growth',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 6),
        Text(
          'Tracking your impact on the healthcare community.',
          style: TextStyle(color: Color(0xFF6B7280)),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String count;
  final String label;
  final double progress;
  final IconData icon;
  final bool isPrimary;
  final bool isDashed;

  const _StatCard({
    required this.title,
    required this.count,
    required this.label,
    required this.progress,
    required this.icon,
    this.isPrimary = false,
    this.isDashed = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isDashed
            ? Border.all(
                color: AppColors.red.withOpacity(0.2),
                style: BorderStyle.solid, // dashed needs custom painter
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title + Icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  letterSpacing: 2,
                  color: Color(0xFF9CA3AF),
                ),
              ),
              Icon(icon, color: Colors.grey.shade300, size: 32),
            ],
          ),

          const SizedBox(height: 16),

          /// Count
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                count,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: isPrimary ? AppColors.red : Colors.black,
                ),
              ),
              const SizedBox(width: 6),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(label),
              )
            ],
          ),

          const SizedBox(height: 12),

          /// Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: const Color(0xFFE5E7EB),
              color: isPrimary ? AppColors.red : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class _EarnedRewardsCard extends StatelessWidget {
  const _EarnedRewardsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFFFEE2E2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.card_giftcard, color: Colors.red),
          ),
          const SizedBox(width: 12),

          /// Text
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '2 Credits Earned',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '03 Invited • Available for immediate use across any specialist network.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),

          /// Button
          ElevatedButton(
            onPressed: null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.red,
              shape: StadiumBorder(),
            ),
            child: const Text('Redeem Now'),
          ),
        ],
      ),
    );
  }
}

class _RecentActivity extends StatelessWidget {
  const _RecentActivity();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'Recent Activity',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Icon(Icons.history, size: 18, color: AppColors.red),
          ],
        ),

        const SizedBox(height: 12),

        _activityItem(
          name: 'Dr. Sarah Jenkins joined',
          subtitle: 'Specialist Referral • 2 days ago',
          trailing: '+500 pts',
          isPositive: true,
        ),

        _activityItem(
          name: 'Mark Thompson invited',
          subtitle: 'Patient Referral • 5 days ago',
          trailing: 'Pending',
        ),
      ],
    );
  }

  Widget _activityItem({
    required String name,
    required String subtitle,
    required String trailing,
    bool isPositive = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 18,
            backgroundColor: Color(0xFFE5E7EB),
            child: Icon(Icons.person, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Text(
            trailing,
            style: TextStyle(
              color: isPositive ? Colors.green : Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }
}

class _ShareCard extends StatelessWidget {
  const _ShareCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFFEF4444), Color(0xFFB91C1C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Grow the mission.',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Earn premium rewards for every successful healthcare connection you facilitate.',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.white,
              foregroundColor: AppColors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Share Link'),
          )
        ],
      ),
    );
  }
}

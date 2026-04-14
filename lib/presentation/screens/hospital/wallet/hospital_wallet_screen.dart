import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class HospitalWalletScreen extends StatelessWidget {
  const HospitalWalletScreen({super.key});

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
              const SizedBox(height: 8),
              const Text(
                'My Wallet',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                'Manage your clinical funds and operation liquidity',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 24),
              _BalanceCard(
                onAddFunds: () {},
                onWithdraw: () {},
              ),
              const SizedBox(height: 20),
              _TransactionsCard(),
              const SizedBox(height: 20),
              _AnnualSavingsBanner(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final VoidCallback onAddFunds;
  final VoidCallback onWithdraw;

  const _BalanceCard({required this.onAddFunds, required this.onWithdraw});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.red,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'BALANCE',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 14,
                  letterSpacing: 1,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.account_balance_wallet_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
          // const SizedBox(height: 12),
          const Text(
            '₦0.00',
            style: TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 34),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onAddFunds,
                  icon: const Icon(Icons.add_circle_outline,
                      color: AppColors.red, size: 18),
                  label: const Text(
                    'Add Funds',
                    style: TextStyle(
                        color: AppColors.red, fontWeight: FontWeight.w600),
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: AppColors.white,
                    side: const BorderSide(color: Colors.white54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onWithdraw,
                  icon: const Icon(Icons.account_balance_outlined,
                      color: Colors.white, size: 18),
                  label: const Text(
                    'Withdraw',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: AppColors.white.withOpacity(0.2),
                    side: const BorderSide(color: Colors.white54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
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

class _TransactionsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Transactions',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'View All',
                  style: TextStyle(
                    color: AppColors.red,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _TransactionTile(
            icon: Icons.refresh,
            iconColor: Colors.grey,
            iconBg: const Color(0xFFF3F3F3),
            title: 'Subscription Renewal',
            date: 'May 1, 2024',
            amount: '- ₦75,000',
            statusLabel: 'SUCCESSFUL',
            isDebit: true,
          ),
          _TransactionTile(
            icon: Icons.person_add_outlined,
            iconColor: AppColors.green,
            iconBg: const Color(0xFFE8F5E9),
            title: 'Patient Payment Received',
            date: 'Apr 30, 2024',
            amount: '+₦45,000',
            statusLabel: 'RECEIVED',
            isDebit: false,
          ),
          _TransactionTile(
            icon: Icons.account_balance_wallet_outlined,
            iconColor: AppColors.red,
            iconBg: const Color(0xFFFDECEC),
            title: 'Wallet Funding',
            date: 'Apr 28, 2024',
            amount: '+₦500,000',
            statusLabel: 'CREDITED',
            isDebit: false,
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String date;
  final String amount;
  final String statusLabel;
  final bool isDebit;
  final bool isLast;

  const _TransactionTile({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.date,
    required this.amount,
    required this.statusLabel,
    required this.isDebit,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14)),
                    const SizedBox(height: 2),
                    Text(date,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    amount,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: isDebit ? AppColors.red : AppColors.green,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    statusLabel,
                    style: TextStyle(
                      fontSize: 10,
                      color: isDebit ? AppColors.red : AppColors.green,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (!isLast) Divider(height: 1, color: Colors.grey.withOpacity(0.15)),
      ],
    );
  }
}

class _AnnualSavingsBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1A3A2A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ANNUAL SAVINGS',
            style: TextStyle(
              color: Color(0xFF7AE87A),
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Switch to yearly billing and save up to 20% on all RubyMedik enterprise features.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2D5A3D),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              elevation: 0,
            ),
            child: const Text(
              'LEARN MORE',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

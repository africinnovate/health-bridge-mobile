import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class SpecialistWalletScreen extends StatelessWidget {
  const SpecialistWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.walletBackground,
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
                'Track your clinical professional income',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 24),
              _BalanceCard(onWithdraw: () {}),
              const SizedBox(height: 22),
              _OutlinedActionButton(
                label: 'Add fund +',
                onTap: () {},
              ),
              const SizedBox(height: 44),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Activity',
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
                icon: Icons.add_box_outlined,
                iconColor: AppColors.green,
                iconBg: const Color(0xFFE8F5E9),
                title: 'Consultation payment received',
                date: 'Today • 10:45 AM',
                amount: '+₦9,500',
                isDebit: false,
              ),
              _TransactionTile(
                icon: Icons.account_balance_wallet_outlined,
                iconColor: AppColors.red,
                iconBg: const Color(0xFFFDECEC),
                title: 'Withdrawal',
                date: 'Yesterday • 04:20 PM',
                amount: '-₦25,000',
                isDebit: true,
              ),
              _TransactionTile(
                icon: Icons.phone_outlined,
                iconColor: AppColors.green,
                iconBg: const Color(0xFFE8F5E9),
                title: 'Emergency Call Payout',
                date: '2 days ago • 09:12 AM',
                amount: '+₦18,200',
                isDebit: false,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final VoidCallback onWithdraw;

  const _BalanceCard({required this.onWithdraw});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(34),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'AVAILABLE BALANCE',
            style: TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            '₦0.00',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onWithdraw,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 0,
              ),
              child: const Text(
                'Withdraw Funds →',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OutlinedActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _OutlinedActionButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: AppColors.red.withOpacity(0.18),
            blurRadius: 16,
            spreadRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: AppColors.red),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Colors.white,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: AppColors.red,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
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
  final bool isDebit;

  const _TransactionTile({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.date,
    required this.amount,
    required this.isDebit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
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
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: isDebit ? AppColors.red : AppColors.green,
            ),
          ),
        ],
      ),
    );
  }
}

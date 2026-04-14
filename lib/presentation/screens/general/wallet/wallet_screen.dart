import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

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
                'Manage your healthcare funds',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 24),
              _BalanceCard(),
              const SizedBox(height: 34),
              _ActionButton(
                label: 'Withdraw Funds',
                onTap: () {},
              ),
              const SizedBox(height: 12),
              _ActionButton(
                label: 'Add fund +',
                onTap: () {},
              ),
              const SizedBox(height: 34),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Transactions',
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
                iconColor: AppColors.red,
                iconBg: AppColors.white,
                title: 'Withdraw',
                date: 'May 1',
                amount: '-₦12,000',
                isDebit: true,
              ),
              _TransactionTile(
                icon: Icons.chat_bubble_outline,
                iconColor: AppColors.red,
                iconBg: AppColors.white,
                title: 'Consultation',
                date: 'Apr 28',
                amount: '-₦10,500',
                isDebit: true,
              ),
              _TransactionTile(
                icon: Icons.account_balance_wallet_outlined,
                iconColor: AppColors.green,
                iconBg: AppColors.white,
                title: 'Wallet funding',
                date: 'Apr 25',
                amount: '+₦20,000',
                isDebit: false,
              ),
              const SizedBox(height: 20),
              _HelpCard(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.red,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'AVAILABLE BALANCE',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  letterSpacing: 1,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.account_balance_wallet_outlined,
                    color: Colors.white, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            '₦0.00',
            style: TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: const [
              Icon(Icons.shield_outlined, color: Colors.white70, size: 16),
              SizedBox(width: 6),
              Text(
                'Secure Clinical Account',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _ActionButton({required this.label, required this.onTap});

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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
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
        color: const Color(0xFFF3F3F3),
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

class _HelpCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8E8E8),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.red.withOpacity(0.3)),
            ),
            child: Icon(Icons.help_outline, color: AppColors.red, size: 22),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Need help with payments?',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                SizedBox(height: 2),
                Text(
                  'Contact our 24/7 medical finance desk.',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

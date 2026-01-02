import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class LinkedAccountsScreen extends StatefulWidget {
  const LinkedAccountsScreen({super.key});

  @override
  State<LinkedAccountsScreen> createState() => _LinkedAccountsScreenState();
}

class _LinkedAccountsScreenState extends State<LinkedAccountsScreen> {
  bool googleConnected = true;
  bool appleConnected = true;
  bool facebookConnected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      appBar: const CustomAppBar(
        title: 'Linked Accounts',
        showArrow: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Subtitle
            const Text(
              'Connect your social accounts for quick sign-in and enhanced features',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 24),

            /// Google Account
            _accountCard(
              icon: Icons.g_mobiledata,
              iconColor: const Color(0xFFEA4335),
              iconBg: const Color(0xFFFEE2E2),
              title: 'Google',
              email: 'chison.e@gmail.com',
              connectedTime: 'Connected 3 months ago',
              isConnected: googleConnected,
              onConnect: () {
                setState(() {
                  googleConnected = true;
                });
              },
              onDisconnect: () {
                setState(() {
                  googleConnected = false;
                });
              },
            ),
            const SizedBox(height: 16),

            /// Apple Account (Highlighted)
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFF3B82F6),
                  width: 2,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: _accountCard(
                icon: Icons.apple,
                iconColor: Colors.black,
                iconBg: const Color(0xFFF3F4F6),
                title: 'Apple',
                email: 'chison.e@icloud.com',
                connectedTime: 'Connected 1 month ago',
                isConnected: appleConnected,
                onConnect: () {
                  setState(() {
                    appleConnected = true;
                  });
                },
                onDisconnect: () {
                  setState(() {
                    appleConnected = false;
                  });
                },
              ),
            ),
            const SizedBox(height: 16),

            /// Facebook Account
            _accountCard(
              icon: Icons.facebook,
              iconColor: const Color(0xFF1877F2),
              iconBg: const Color(0xFFEFF6FF),
              title: 'Facebook',
              isConnected: facebookConnected,
              onConnect: () {
                setState(() {
                  facebookConnected = true;
                });
              },
              onDisconnect: () {
                setState(() {
                  facebookConnected = false;
                });
              },
            ),
            const SizedBox(height: 32),

            /// Why link accounts
            const Text(
              'Why link accounts?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            _benefit('Quick sign-in without password'),
            const SizedBox(height: 12),
            _benefit('Sync profile information'),
            const SizedBox(height: 12),
            _benefit('Enhanced security with 2FA'),
            const SizedBox(height: 12),
            _benefit('Access across devices'),
            const SizedBox(height: 24),

            /// Footer Note
            const Text(
              'Your linked accounts are secure and can be disconnected anytime',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF9CA3AF),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _accountCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    String? email,
    String? connectedTime,
    required bool isConnected,
    required VoidCallback onConnect,
    required VoidCallback onDisconnect,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Row(
            children: [
              /// Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),

              /// Title & Status
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        if (isConnected)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDCFCE7),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'Connected',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.green,
                              ),
                            ),
                          )
                        else
                          const Text(
                            'Not Connected',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                      ],
                    ),
                    if (isConnected && email != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        email,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                    if (isConnected && connectedTime != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        connectedTime,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),

          /// Connect/Disconnect Button
          if (!isConnected) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: onConnect,
                style: OutlinedButton.styleFrom(
                  backgroundColor: const Color(0xFFEFF6FF),
                  foregroundColor: const Color(0xFF3B82F6),
                  side: const BorderSide(color: const Color(0xFFBFDBFE)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  'Connect with $title',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ] else ...[
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onDisconnect,
                child: const Text(
                  'Disconnect',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.red,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _benefit(String text) {
    return Row(
      children: [
        const Icon(
          Icons.circle,
          size: 6,
          color: Color(0xFF6B7280),
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }
}

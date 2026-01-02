import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/presentation/widgets/cancel_button.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:HealthBridge/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class LanguageSettingsScreen extends StatefulWidget {
  const LanguageSettingsScreen({super.key});

  @override
  State<LanguageSettingsScreen> createState() => _LanguageSettingsScreenState();
}

class _LanguageSettingsScreenState extends State<LanguageSettingsScreen> {
  String selectedLanguage = 'English';

  final List<Map<String, String>> languages = [
    {'name': 'English', 'icon': '🇬🇧'},
    {'name': 'French', 'icon': '🇫🇷'},
    {'name': 'Yoruba', 'icon': '🇳🇬'},
    {'name': 'Igbo', 'icon': '🇳🇬'},
    {'name': 'Hausa', 'icon': '🇳🇬'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      appBar: const CustomAppBar(
        title: 'Language',
        showArrow: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Subtitle
            const Text(
              'Select your preferred language for the app',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 24),

            /// Language Options
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  for (int i = 0; i < languages.length; i++) ...[
                    _languageOption(
                      name: languages[i]['name']!,
                      icon: languages[i]['icon']!,
                    ),
                    if (i < languages.length - 1)
                      const Divider(height: 1, indent: 60),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            /// Info Text
            const Text(
              'The app will restart to apply the new language',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 32),

            /// Apply Button
            CustomButton(
              onPressed: () {
                // Handle apply language
                context.goBack();
              },
              text: 'Apply Language',
            ),
            const SizedBox(height: 12),

            /// Cancel Button
            CancelButton(
              text: 'Cancel',
              onPressed: () {
                context.goBack();
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _languageOption({
    required String name,
    required String icon,
  }) {
    final isSelected = selectedLanguage == name;
    return ListTile(
      onTap: () {
        setState(() {
          selectedLanguage = name;
        });
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            icon,
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ),
      title: Text(
        name,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? AppColors.green : const Color(0xFFD1D5DB),
            width: 2,
          ),
          color: isSelected ? AppColors.green : Colors.transparent,
        ),
        child: isSelected
            ? const Icon(
                Icons.circle,
                size: 12,
                color: Colors.white,
              )
            : null,
      ),
    );
  }
}

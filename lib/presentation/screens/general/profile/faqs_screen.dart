import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FaqsScreen extends StatefulWidget {
  const FaqsScreen({super.key});

  @override
  State<FaqsScreen> createState() => _FaqsScreenState();
}

class _FaqsScreenState extends State<FaqsScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  int? expandedIndex;

  static const List<Map<String, String>> _allFaqs = [
    {
      'question': 'How do I book an appointment?',
      'answer':
          'To book an appointment, navigate to the Care section, select a specialist, choose an available time slot, and confirm your booking. You\'ll receive a confirmation notification immediately after booking.',
    },
    {
      'question': 'How do I donate blood',
      'answer':
          'To donate blood, go to the Donations tab, select a nearby blood bank or hospital, choose a convenient time, and confirm your appointment.',
    },
    {
      'question': 'What if I miss an appointment',
      'answer':
          'If you miss an appointment, you can reschedule it from your appointments list. Please note that repeated missed appointments may affect your ability to book future appointments.',
    },
    {
      'question': 'Are my medical records secure',
      'answer':
          'Yes, all your medical records are encrypted and stored securely. We follow strict privacy protocols to ensure your data is protected.',
    },
    {
      'question': 'How do I change my consultation preference',
      'answer':
          'You can change your consultation preference from Settings > Preferences > Consultation Preference. Choose between video call, voice call, or in-person consultation.',
    },
  ];

  List<Map<String, String>> get _filteredFaqs {
    if (_searchQuery.isEmpty) return _allFaqs;
    final query = _searchQuery.toLowerCase();
    return _allFaqs
        .where((faq) =>
            faq['question']!.toLowerCase().contains(query) ||
            faq['answer']!.toLowerCase().contains(query))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      appBar: const CustomAppBar(
        title: 'Frequently Asked Questions',
        showArrow: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Search Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) => setState(() {
                  _searchQuery = value;
                  expandedIndex = null;
                }),
                decoration: InputDecoration(
                  icon: const Icon(Icons.search, color: Color(0xFF9CA3AF)),
                  hintText: 'Search FAQs...',
                  hintStyle: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF9CA3AF),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                              expandedIndex = null;
                            });
                          },
                          child: const Icon(Icons.close,
                              color: Color(0xFF9CA3AF), size: 20),
                        )
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 24),

            /// FAQ Items
            if (_filteredFaqs.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Text(
                  'No FAQs found matching your search.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                ),
              )
            else
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    for (int i = 0; i < _filteredFaqs.length; i++) ...[
                      _faqItem(
                        question: _filteredFaqs[i]['question']!,
                        answer: _filteredFaqs[i]['answer']!,
                        isExpanded: expandedIndex == i,
                        onTap: () {
                          setState(() {
                            expandedIndex = expandedIndex == i ? null : i;
                          });
                        },
                      ),
                      if (i < _filteredFaqs.length - 1)
                        const Divider(height: 1),
                    ],
                  ],
                ),
              ),
            const SizedBox(height: 32),

            /// Contact Support Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  const Text(
                    'Didn\'t find what you\'re looking for?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final url = Uri.parse(
                            'mailto:Support@africinnovate.com?subject=HealthBridge Support Request');
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        }
                      },
                      icon: const Icon(Icons.email_outlined, size: 18),
                      label: const Text('Contact Support'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF6B7280),
                        side: const BorderSide(color: Color(0xFFE5E7EB)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _faqItem({
    required String question,
    required String answer,
    required bool isExpanded,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    question,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: const Color(0xFF6B7280),
                ),
              ],
            ),
            if (isExpanded) ...[
              const SizedBox(height: 12),
              Text(
                answer,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF6B7280),
                  height: 1.6,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

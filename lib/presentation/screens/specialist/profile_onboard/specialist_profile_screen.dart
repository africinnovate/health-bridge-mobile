import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/utils/snackbar_utils.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:HealthBridge/presentation/widgets/custom_text.dart';
import 'package:HealthBridge/presentation/widgets/input_text_field_wg.dart';
import 'package:flutter/material.dart';

class SpecialistProfileScreen extends StatefulWidget {
  const SpecialistProfileScreen({super.key});

  @override
  State<SpecialistProfileScreen> createState() =>
      _SpecialistProfileScreenState();
}

class _SpecialistProfileScreenState extends State<SpecialistProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController altPhoneController = TextEditingController();
  int? selectedYears;
  String? selectedLanguage;

  final List<String> specialties = [
    'Cardiology',
    'Dermatology',
    'Neurology',
    'General Medicine',
    'Psychiatry',
    'Orthopedics',
    'Oncology',
    'Gynecology',
    'Physiotherapy',
  ];

  final Set<String> selectedSpecialties = {};
  String consultationType = 'video';

  int bioLength = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            const Text(
              'Set Up Your Specialist Profile',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              'Provide your professional details so patients can understand '
              'your expertise and choose the right specialist.',
              style: TextStyle(color: Color(0xFF6B7280), height: 1.4),
            ),

            const SizedBox(height: 24),

            /// Profile image
            Center(
              child: Stack(
                children: [
                  const CircleAvatar(
                    radius: 52,
                    backgroundColor: Color(0xFFE5E7EB),
                    // backgroundImage: AssetImage('assets/images/avatar.png'),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFD32F2F),
                      ),
                      child: const Icon(Icons.camera_alt,
                          size: 16, color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 6),
            const Center(
              child: Text(
                'Profile Photo (Required)',
                style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
              ),
            ),

            const SizedBox(height: 24),

            /// Full name
            _label('Your Full Name'),
            InputTextFieldWG(
              controller: nameController,
              hintText: "Enter your full name",
            ),

            const SizedBox(height: 20),

            /// Specialty
            _label('Select Specialty'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: specialties.map((item) {
                final selected = selectedSpecialties.contains(item);
                return ChoiceChip(
                  backgroundColor: AppColors.backgroundGray,
                  side: BorderSide.none,
                  label: CustomText(
                    text: item,
                    size: 13,
                    color: selected ? Colors.white : Colors.black87,
                  ),
                  selected: selected,
                  selectedColor: const Color(0xFFD32F2F),
                  onSelected: (_) {
                    setState(() {
                      selected
                          ? selectedSpecialties.remove(item)
                          : selectedSpecialties.add(item);
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 6),
            TextButton.icon(
              onPressed: () {
                SnackBarUtils.showInfo(context, "in progress");
              },
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add New'),
            ),

            const SizedBox(height: 16),

            /// Bio
            _label('Professional Bio'),
            InputTextFieldWG(
              hintText:
                  'Short introduction about yourself and your approach to patient care',
              controller: bioController,
              maxLines: 4,
              // maxLength: 500,
              onChanged: (v) => setState(() => bioLength = v.length),
            ),

            const SizedBox(height: 16),

            /// Years of experience
            _label('Years of experience'),
            _dropdownYears(
              hint: 'Select years',
              value: selectedYears,
              onChanged: (val) {
                setState(() {
                  selectedYears = val;
                });
              },
            ),

            const SizedBox(height: 20),

            /// Consultation type
            _label('Consultation Type'),
            Row(
              children: [
                _consultationButton('Video call', 'video', Icons.videocam),
                const SizedBox(width: 12),
                _consultationButton('Voice call', 'voice', Icons.call),
                const SizedBox(width: 12),
                _consultationButton('In-person', 'inperson', Icons.location_on),
              ],
            ),

            const SizedBox(height: 24),

            /// Contact info
            _label('Contact Information'),
            const Text(
              'Patients will use this to call during appointment times.',
              style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
            ),

            const SizedBox(height: 12),
            InputTextFieldWG(
              controller: phoneController,
              hintText: "Primary contact number (Required)",
            ),
            const SizedBox(height: 12),
            InputTextFieldWG(
              controller: altPhoneController,
              hintText: "Alternative line (optional)",
            ),

            const SizedBox(height: 20),

            /// Languages
            _label('Languages Spoken'),
            _dropdownLanguage(
              hint: 'Select Language',
              value: selectedLanguage,
              onChanged: (val) {
                setState(() {
                  selectedLanguage = val;
                });
              },
            ),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text('Add Another Language'),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  /// ---------------- Widgets ----------------

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _dropdownYears({
    required String hint,
    required int? value,
    required ValueChanged<int?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: value,
          hint: Text(
            hint,
            style: const TextStyle(color: Color(0xFF9CA3AF)),
          ),
          icon: const Icon(Icons.keyboard_arrow_down),
          isExpanded: true,
          items: List.generate(
            19,
            (index) {
              final number = index + 2; // 2 → 20
              return DropdownMenuItem<int>(
                value: number,
                child: Text(number.toString()),
              );
            },
          ),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _dropdownLanguage({
    required String hint,
    required String? value,
    required ValueChanged<String?> onChanged,
  }) {
    final languages = [
      'English',
      'French',
      'Spanish',
      'German',
      'Arabic',
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(
            hint,
            style: const TextStyle(color: Color(0xFF9CA3AF)),
          ),
          icon: const Icon(Icons.keyboard_arrow_down),
          isExpanded: true,
          items: languages
              .map(
                (lang) => DropdownMenuItem<String>(
                  value: lang,
                  child: Text(lang),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _consultationButton(String label, String value, IconData icon) {
    final selected = consultationType == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => consultationType = value),
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFD32F2F) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? Colors.transparent : const Color(0xFFE5E7EB),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 18, color: selected ? Colors.white : Colors.grey),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: selected ? Colors.white : Colors.grey,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

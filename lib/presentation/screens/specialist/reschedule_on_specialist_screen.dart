import 'package:HealthBridge/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../widgets/input_text_field_wg.dart';

class RescheduleOnSpecialistScreen extends StatefulWidget {
  const RescheduleOnSpecialistScreen({super.key});

  @override
  State<RescheduleOnSpecialistScreen> createState() =>
      _RescheduleOnSpecialistScreenState();
}

class _RescheduleOnSpecialistScreenState
    extends State<RescheduleOnSpecialistScreen> {
  int selectedDay = 1;
  String selectedTime = '12:00 PM';

  final List<String> timeSlots = [
    '9:00 AM',
    '9:30 AM',
    '10:00 AM',
    '10:30 AM',
    '11:00 AM',
    '11:30 AM',
    '12:00 PM',
    '12:30 PM',
    '1:00 PM',
    '1:30 PM',
    '2:00 PM',
    '2:30 PM',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          /// FIXED HEADER
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Pick a Date & Time',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  'Choose a convenient time for your appointment.',
                  style: TextStyle(color: Color(0xFF6B7280)),
                ),
              ],
            ),
          ),

          /// SCROLLABLE CONTENT
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _currentAppointment(),
                  const SizedBox(height: 20),
                  _selectDate(),
                  const SizedBox(height: 20),
                  _selectTime(),
                  const SizedBox(height: 20),
                  _optionalNote(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),

          /// ACTION BUTTONS
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                CustomButton(onPressed: () {}, text: 'Send New Time'),
                const SizedBox(height: 12),
                _secondaryButton('Cancel', onTap: () {
                  Navigator.pop(context);
                }),
              ],
            ),
          )
        ],
      ),
    );
  }

  /// ---------------- Current Appointment ----------------
  Widget _currentAppointment() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Current Appointment',
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8),
          Text('Adaobi Nkemdilim'),
          SizedBox(height: 4),
          Text('Wednesday, March 15, 2025',
              style: TextStyle(color: Colors.grey)),
          SizedBox(height: 4),
          Text('10:30 AM'),
        ],
      ),
    );
  }

  /// ---------------- Date Picker ----------------
  Widget _selectDate() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Select Date', 'Step 1 of 2'),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'December 2022',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Row(
                children: [
                  Icon(Icons.chevron_left),
                  Icon(Icons.chevron_right),
                ],
              )
            ],
          ),
          const SizedBox(height: 12),
          _calendarGrid(),
        ],
      ),
    );
  }

  Widget _calendarGrid() {
    final days = List.generate(31, (index) => index + 1);

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: days.map((day) {
        final isSelected = selectedDay == day;
        return GestureDetector(
          onTap: () => setState(() => selectedDay = day),
          child: Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFD32F2F) : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$day',
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  /// ---------------- Time Picker ----------------
  Widget _selectTime() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Select Time', 'Step 2 of 2'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: timeSlots.map((time) {
              final isSelected = selectedTime == time;
              return GestureDetector(
                onTap: () => setState(() => selectedTime = time),
                child: Container(
                  width: 90,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.transRed10 : Colors.white,
                    border: Border.all(
                      color:
                          isSelected ? AppColors.red : const Color(0xFFE5E7EB),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    time,
                    style: TextStyle(
                      color: isSelected ? const Color(0xFFD32F2F) : Colors.grey,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  /// ---------------- Optional Note ----------------
  Widget _optionalNote() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Optional Note',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        InputTextFieldWG(
          hintText: 'Reason for rescheduling (optional)',
          maxLines: 3,
        ),
      ],
    );
  }

  /// ---------------- Helpers ----------------
  Widget _sectionTitle(String title, String subtitle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        Text(subtitle,
            style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }

  Widget _primaryButton(String text, {required VoidCallback onTap}) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFD32F2F),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: onTap,
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _secondaryButton(String text, {required VoidCallback onTap}) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: const Color(0xFFFDECEC),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: onTap,
        child: Text(
          text,
          style: const TextStyle(color: Color(0xFFD32F2F)),
        ),
      ),
    );
  }
}

import 'package:HealthBridge/core/utils/snackbar_utils.dart';
import 'package:HealthBridge/data/models/appointment/appointment_model.dart';
import 'package:HealthBridge/presentation/providers/appointment_provider.dart';
import 'package:HealthBridge/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../widgets/input_text_field_wg.dart';

class RescheduleOnSpecialistScreen extends StatefulWidget {
  final AppointmentModel? appointment;

  const RescheduleOnSpecialistScreen({super.key, this.appointment});

  @override
  State<RescheduleOnSpecialistScreen> createState() =>
      _RescheduleOnSpecialistScreenState();
}

class _RescheduleOnSpecialistScreenState
    extends State<RescheduleOnSpecialistScreen> {
  late DateTime _selectedDate;
  String _selectedTime = '10:00 AM';
  bool _isSaving = false;

  final List<String> timeSlots = [
    '9:00 AM', '9:30 AM', '10:00 AM', '10:30 AM',
    '11:00 AM', '11:30 AM', '12:00 PM', '12:30 PM',
    '1:00 PM', '1:30 PM', '2:00 PM', '2:30 PM',
  ];

  @override
  void initState() {
    super.initState();
    // Default to tomorrow or current appointment time
    _selectedDate = widget.appointment?.scheduledTime.add(const Duration(days: 1)) ??
        DateTime.now().add(const Duration(days: 1));
  }

  DateTime get _newScheduledTime {
    final timeParsed = DateFormat('h:mm a').parse(_selectedTime);
    return DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      timeParsed.hour,
      timeParsed.minute,
    );
  }

  Future<void> _submit() async {
    if (widget.appointment == null) return;
    setState(() => _isSaving = true);

    final provider = context.read<AppointmentProvider>();
    final error = await provider.rescheduleAppointment(
      widget.appointment!.id,
      _newScheduledTime,
      appointmentType: 'patient',
    );

    if (mounted) {
      setState(() => _isSaving = false);
      if (error != null) {
        SnackBarUtils.showError(context, error);
      } else {
        SnackBarUtils.showSuccess(context, 'Appointment rescheduled');
        Navigator.pop(context);
        Navigator.pop(context); // back to list
      }
    }
  }

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
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pick a Date & Time',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  'Choose a convenient time for the appointment.',
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
                  if (widget.appointment != null) _currentAppointment(),
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
                CustomButton(
                  onPressed: _isSaving ? () {} : _submit,
                  text: _isSaving ? 'Sending...' : 'Send New Time',
                ),
                const SizedBox(height: 12),
                _secondaryButton('Cancel', onTap: () => Navigator.pop(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _currentAppointment() {
    final apt = widget.appointment!;
    final date = DateFormat('EEEE, MMMM d, yyyy').format(apt.scheduledTime);
    final time = DateFormat('h:mm a').format(apt.scheduledTime);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Current Appointment',
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text('Ref: ${apt.id.substring(0, 8).toUpperCase()}'),
          const SizedBox(height: 4),
          Text(date, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 4),
          Text(time),
        ],
      ),
    );
  }

  Widget _selectDate() {
    final now = DateTime.now();
    final monthYear = DateFormat('MMMM yyyy').format(_selectedDate);

    // Days in the selected month
    final daysInMonth =
        DateUtils.getDaysInMonth(_selectedDate.year, _selectedDate.month);

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Select Date', 'Step 1 of 2'),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                monthYear,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: () {
                      setState(() {
                        _selectedDate = DateTime(
                          _selectedDate.year,
                          _selectedDate.month - 1,
                          1,
                        );
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: () {
                      setState(() {
                        _selectedDate = DateTime(
                          _selectedDate.year,
                          _selectedDate.month + 1,
                          1,
                        );
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(daysInMonth, (index) {
              final day = index + 1;
              final date = DateTime(
                  _selectedDate.year, _selectedDate.month, day);
              final isSelected = _selectedDate.day == day &&
                  _selectedDate.month == date.month;
              final isPast = date.isBefore(
                  DateTime(now.year, now.month, now.day));

              return GestureDetector(
                onTap: isPast
                    ? null
                    : () => setState(() => _selectedDate = date),
                child: Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.red
                        : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$day',
                    style: TextStyle(
                      color: isPast
                          ? Colors.grey.shade300
                          : isSelected
                              ? Colors.white
                              : Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

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
              final isSelected = _selectedTime == time;
              return GestureDetector(
                onTap: () => setState(() => _selectedTime = time),
                child: Container(
                  width: 90,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.transRed10
                        : Colors.white,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.red
                          : const Color(0xFFE5E7EB),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    time,
                    style: TextStyle(
                      color: isSelected
                          ? AppColors.red
                          : Colors.grey,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
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

  Widget _sectionTitle(String title, String subtitle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600)),
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

  Widget _secondaryButton(String text, {required VoidCallback onTap}) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: const Color(0xFFFDECEC),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
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

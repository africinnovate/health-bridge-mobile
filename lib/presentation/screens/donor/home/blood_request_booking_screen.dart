import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/data/models/appointment/appointment_model.dart';
import 'package:HealthBridge/presentation/providers/appointment_provider.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:HealthBridge/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../core/utils/dialog.dart';
import '../../../../core/utils/snackbar_utils.dart';

class BloodRequestBookingScreen extends StatefulWidget {
  final AppointmentModel? appointment;

  const BloodRequestBookingScreen({super.key, this.appointment});

  @override
  State<BloodRequestBookingScreen> createState() =>
      _BloodRequestBookingScreenState();
}

class _BloodRequestBookingScreenState extends State<BloodRequestBookingScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String? _selectedTime;

  // 30-min slots from 8:00 AM to 5:00 PM
  final List<String> _timeSlots = List.generate(18, (i) {
    final totalMinutes = 8 * 60 + i * 30;
    final h = totalMinutes ~/ 60;
    final m = totalMinutes % 60;
    final period = h < 12 ? 'AM' : 'PM';
    final displayH = h == 0 ? 12 : (h > 12 ? h - 12 : h);
    return '${displayH.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')} $period';
  });

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      appBar: const CustomAppBar(
        title: 'Donate',
        showArrow: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Title
                  const Text(
                    'Pick a Date & Time',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  /// Subtitle
                  const Text(
                    'Choose a convenient time for your appointment.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 32),

                  /// Select Date Section
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Select Date',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Step 1 of 2',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                        const SizedBox(height: 20),

                        /// Calendar
                        TableCalendar(
                          firstDay: DateTime.now(),
                          lastDay:
                              DateTime.now().add(const Duration(days: 365)),
                          focusedDay: _focusedDay,
                          selectedDayPredicate: (day) {
                            return isSameDay(_selectedDay, day);
                          },
                          onDaySelected: (selectedDay, focusedDay) {
                            setState(() {
                              _selectedDay = selectedDay;
                              _focusedDay = focusedDay;
                            });
                          },
                          calendarFormat: CalendarFormat.month,
                          headerStyle: HeaderStyle(
                            formatButtonVisible: false,
                            titleCentered: true,
                            titleTextStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            leftChevronIcon: const Icon(
                              Icons.chevron_left,
                              color: Color(0xFF6B7280),
                            ),
                            rightChevronIcon: const Icon(
                              Icons.chevron_right,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                          calendarStyle: CalendarStyle(
                            todayDecoration: BoxDecoration(
                              color: AppColors.red.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            selectedDecoration: const BoxDecoration(
                              color: AppColors.red,
                              shape: BoxShape.circle,
                            ),
                            todayTextStyle: const TextStyle(
                              color: AppColors.red,
                              fontWeight: FontWeight.bold,
                            ),
                            selectedTextStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  /// Select Time Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Select Time',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Step 2 of 2',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                        const SizedBox(height: 20),

                        /// Time Slots Grid (3 columns)
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 2.2,
                          ),
                          itemCount: _timeSlots.length,
                          itemBuilder: (context, index) {
                            final time = _timeSlots[index];
                            final isSelected = _selectedTime == time;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedTime = time;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.white
                                      : const Color(0xFFF9FAFB),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.red
                                        : const Color(0xFFE5E7EB),
                                    width: isSelected ? 2 : 1,
                                  ),
                                ),
                                child: Center(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      time,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.normal,
                                        color: isSelected
                                            ? AppColors.red
                                            : const Color(0xFF374151),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  /// Summary Section
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        if (widget.appointment?.specialistId?.isNotEmpty == true)
                          _summaryRow(
                            'Specialist:',
                            'Dr. ${widget.appointment!.specialistName}',
                          )
                        else if (widget.appointment?.hospitalName != null)
                          _summaryRow(
                            'Hospital:',
                            widget.appointment!.hospitalName!,
                          ),
                        const SizedBox(height: 12),
                        _summaryRow(
                          'Type:',
                          widget.appointment?.appointmentType == 'patient'
                              ? 'Specialist Consultation'
                              : 'Blood Donation',
                        ),
                        const SizedBox(height: 12),
                        _summaryRow(
                          'Date:',
                          _selectedDay != null
                              ? _formatDate(_selectedDay!)
                              : 'Not selected',
                        ),
                        const SizedBox(height: 12),
                        _summaryRow(
                          'Time:',
                          _selectedTime ?? 'Not selected',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          /// Submit Button (Fixed at bottom)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: CustomButton(
              onPressed: _submit,
              text: 'Reschedule Appointment',
              shouldProceed: _selectedDay != null && _selectedTime != null,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (_selectedDay == null || _selectedTime == null) return;

    // Parse selected time "HH:mm AM/PM"
    final timeParts = _selectedTime!.split(' ');
    final hmParts = timeParts[0].split(':');
    int hour = int.parse(hmParts[0]);
    final int minute = int.parse(hmParts[1]);
    if (timeParts[1] == 'PM' && hour != 12) hour += 12;
    if (timeParts[1] == 'AM' && hour == 12) hour = 0;

    final newTime = DateTime.utc(
      _selectedDay!.year,
      _selectedDay!.month,
      _selectedDay!.day,
      hour,
      minute,
    );

    context.showLoadingDialog();

    final error = await context.read<AppointmentProvider>().rescheduleAppointment(
          widget.appointment!.id,
          newTime,
          appointmentType: widget.appointment!.appointmentType,
        );

    if (!mounted) return;
    context.hideLoadingDialog();

    if (error == null) {
      showThankYouDialog(
        context,
        title: 'Appointment Rescheduled',
        message: 'Your appointment has been rescheduled successfully.',
        buttonText: 'Done',
        onContinue: () {
          context.goBack();
          context.goBack();
        },
      );
    } else {
      SnackBarUtils.showError(context, error);
    }
  }

  Widget _summaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF6B7280),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    return '${days[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/core/utils/dialog.dart';
import 'package:HealthBridge/core/utils/snackbar_utils.dart';
import 'package:HealthBridge/data/models/specialist/specialist_availability_model.dart';
import 'package:HealthBridge/data/models/specialist/specialist_profile_model.dart';
import 'package:HealthBridge/presentation/providers/appointment_provider.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:HealthBridge/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class PickDateTimeScreen extends StatefulWidget {
  final SpecialistProfileModel? specialist;
  final String? symptoms;

  const PickDateTimeScreen({super.key, this.specialist, this.symptoms});

  @override
  State<PickDateTimeScreen> createState() => _PickDateTimeScreenState();
}

class _PickDateTimeScreenState extends State<PickDateTimeScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String? _selectedTime;
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  /// Returns the day-of-week name for a given DateTime (matches API format).
  String _dayName(DateTime date) {
    const days = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday',
    ];
    return days[date.weekday - 1];
  }

  /// Returns the availability entry for the selected day, or null if unavailable.
  SpecialistAvailabilityModel? _availabilityForDay(DateTime day) {
    final name = _dayName(day);
    try {
      return widget.specialist?.availability
          .firstWhere((a) => a.dayOfWeek.toLowerCase() == name);
    } catch (_) {
      return null;
    }
  }

  /// Generates time slots for the selected day based on specialist availability
  /// and session duration.
  List<String> _timeSlotsForDay(DateTime day) {
    final avail = _availabilityForDay(day);
    if (avail == null) return [];

    final raw = widget.specialist?.sessionDurationMinutes ?? 0;
    final duration = raw > 0 ? raw : 60;

    // Parse "HH:mm" or "H:mm"
    TimeOfDay? parseTime(String t) {
      final parts = t.split(':');
      if (parts.length < 2) return null;
      return TimeOfDay(
          hour: int.tryParse(parts[0]) ?? 0,
          minute: int.tryParse(parts[1]) ?? 0);
    }

    final start = parseTime(avail.opensAt);
    final end = parseTime(avail.closesAt);
    if (start == null || end == null) return [];

    final slots = <String>[];
    int currentMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;

    while (currentMinutes + duration <= endMinutes) {
      final h = currentMinutes ~/ 60;
      final m = currentMinutes % 60;
      final period = h < 12 ? 'AM' : 'PM';
      final displayH = h == 0 ? 12 : (h > 12 ? h - 12 : h);
      slots.add(
          '${displayH.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')} $period');
      currentMinutes += duration;
    }

    return slots;
  }

  /// Whether a calendar day should be enabled (specialist works that day).
  bool _isDayEnabled(DateTime day) {
    if (day.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
      return false;
    }
    if (widget.specialist == null) return true; // no data — allow all
    return _availabilityForDay(day) != null;
  }

  String get _specialistName {
    final s = widget.specialist;
    if (s == null) return 'Specialist';
    return 'Dr. ${s.firstName} ${s.lastName}'.trim();
  }

  String get _specialtyLabel {
    return widget.specialist?.consultationType ?? 'Specialist';
  }

  String get _consultationTypeLabel {
    final t = widget.specialist?.consultationType.toLowerCase() ?? '';
    if (t.contains('video')) return 'Video';
    if (t.contains('voice') || t.contains('audio')) return 'Voice';
    return 'In Person';
  }

  IconData get _consultationIcon {
    final t = widget.specialist?.consultationType.toLowerCase() ?? '';
    if (t.contains('video')) return Icons.videocam;
    if (t.contains('voice') || t.contains('audio')) return Icons.call;
    return Icons.location_on;
  }

  @override
  Widget build(BuildContext context) {
    final timeSlots =
        _selectedDay != null ? _timeSlotsForDay(_selectedDay!) : <String>[];

    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      appBar: const CustomAppBar(title: 'Select Date & Time'),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Specialist Info
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundImage: widget.specialist?.imageUrl != null
                              ? NetworkImage(widget.specialist!.imageUrl!)
                                  as ImageProvider
                              : const AssetImage('assets/images/patient.png'),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _specialistName,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _specialtyLabel,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(_consultationIcon,
                                  size: 14, color: AppColors.green),
                              const SizedBox(width: 4),
                              Text(
                                _consultationTypeLabel,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  /// Calendar
                  const Text(
                    'Select Date',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: TableCalendar(
                      firstDay: DateTime.now(),
                      lastDay: DateTime.now().add(const Duration(days: 90)),
                      focusedDay: _focusedDay,
                      selectedDayPredicate: (day) =>
                          isSameDay(_selectedDay, day),
                      enabledDayPredicate: _isDayEnabled,
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                          _selectedTime = null; // reset time on new date
                        });
                      },
                      calendarStyle: CalendarStyle(
                        selectedDecoration: const BoxDecoration(
                          color: AppColors.red,
                          shape: BoxShape.circle,
                        ),
                        todayDecoration: BoxDecoration(
                          color: AppColors.red.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        disabledTextStyle: const TextStyle(
                          color: Color(0xFFD1D5DB),
                        ),
                        outsideDaysVisible: false,
                      ),
                      headerStyle: const HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                        titleTextStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  /// Time Slots
                  const Text(
                    'Select Time',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),

                  if (_selectedDay == null)
                    const Text(
                      'Please select a date first',
                      style: TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
                    )
                  else if (timeSlots.isEmpty)
                    const Text(
                      'No available slots for this day',
                      style: TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
                    )
                  else
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 2.5,
                      ),
                      itemCount: timeSlots.length,
                      itemBuilder: (context, index) {
                        final time = timeSlots[index];
                        final isSelected = _selectedTime == time;

                        return GestureDetector(
                          onTap: () => setState(() => _selectedTime = time),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.red : Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.red
                                    : const Color(0xFFE5E7EB),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                time,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? Colors.white
                                      : const Color(0xFF374151),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  const SizedBox(height: 24),

                  /// Notes
                  const Text(
                    'Notes (optional)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: TextField(
                      controller: _notesController,
                      maxLines: 4,
                      textInputAction: TextInputAction.newline,
                      decoration: const InputDecoration(
                        hintText:
                            'Describe your symptoms or add any notes for the specialist...',
                        hintStyle: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF9CA3AF),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// Bottom Button
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: CustomButton(
                onPressed: _confirmAppointment,
                text: 'Confirm Appointment',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmAppointment() async {
    context.hideKeyboard();
    if (_selectedDay == null) {
      SnackBarUtils.showError(context, 'Please select a date');
      return;
    }
    if (_selectedTime == null) {
      SnackBarUtils.showError(context, 'Please select a time');
      return;
    }

    // Parse selected time string "HH:mm AM/PM" into hour/minute
    final timeParts = _selectedTime!.split(' ');
    final hmParts = timeParts[0].split(':');
    int hour = int.parse(hmParts[0]);
    final int minute = int.parse(hmParts[1]);
    final bool isPM = timeParts[1] == 'PM';
    if (isPM && hour != 12) hour += 12;
    if (!isPM && hour == 12) hour = 0;

    final scheduledTime = DateTime(
      _selectedDay!.year,
      _selectedDay!.month,
      _selectedDay!.day,
      hour,
      minute,
    );

    context.showLoadingDialog();

    final error = await context.read<AppointmentProvider>().createAppointment(
          appointmentType: 'patient',
          scheduledTime: scheduledTime,
          specialistId: widget.specialist?.userId,
          // bloodRequestId: widget.specialist?.hospitalId,
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
        );

    if (!mounted) return;
    context.hideLoadingDialog();

    if (error == null) {
      showThankYouDialog(
        context,
        title: 'Appointment Booked!',
        message:
            'Your appointment with $_specialistName has been booked successfully.',
        buttonText: 'Done',
        onContinue: () {
          // Pop back to root patient screen
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
      );
    } else {
      SnackBarUtils.showError(context, error);
    }
  }
}

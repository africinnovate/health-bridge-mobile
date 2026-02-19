import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/constants/app_routes.dart';
import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/core/utils/snackbar_utils.dart';
import 'package:HealthBridge/presentation/providers/specialist_provider.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:HealthBridge/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../widgets/cancel_button.dart';

class DaySchedule {
  String day;
  List<TimeSlot> timeSlots;
  bool isSelected;

  DaySchedule({
    required this.day,
    required this.timeSlots,
    this.isSelected = false,
  });
}

class TimeSlot {
  TimeOfDay startTime;
  TimeOfDay endTime;

  TimeSlot({required this.startTime, required this.endTime});
}

class SpecialistAvailabilityScreen extends StatefulWidget {
  final bool isUpdateMode;

  const SpecialistAvailabilityScreen({
    super.key,
    this.isUpdateMode = false,
  });

  @override
  State<SpecialistAvailabilityScreen> createState() =>
      _SpecialistAvailabilityScreenState();
}

class _SpecialistAvailabilityScreenState
    extends State<SpecialistAvailabilityScreen> {
  int sessionMinutes = 15;
  final Set<String> selectedConsultationTypes = {'video_call'};
  final TextEditingController maxAppointmentsController =
      TextEditingController(text: '7');
  String selectedTimeZone = 'GMT+1 (West African Standard Time)';
  bool showBreakTimes = false;

  @override
  void initState() {
    super.initState();
    if (widget.isUpdateMode) {
      _loadExistingData();
    }
  }

  void _loadExistingData() {
    final provider = Provider.of<SpecialistProvider>(context, listen: false);
    final profile = provider.specialistProfileM;

    if (profile != null) {
      // Load session duration and timezone
      setState(() {
        sessionMinutes = profile.sessionDurationMinutes ?? 15;
        selectedTimeZone = profile.timeZone ?? selectedTimeZone;
      });

      // Load availability data
      if (profile.availability.isNotEmpty) {
        for (var daySchedule in daySchedules) {
          // Find matching availability from profile
          final matchingAvail = profile.availability.where(
            (avail) => avail.dayOfWeek.toLowerCase() == daySchedule.day.toLowerCase(),
          );

          if (matchingAvail.isNotEmpty) {
            daySchedule.isSelected = true;
            daySchedule.timeSlots.clear();

            for (var avail in matchingAvail) {
              // Parse time strings (format: "HH:MM:SS" or "HH:MM")
              final opensParts = avail.opensAt.split(':');
              final closesParts = avail.closesAt.split(':');

              daySchedule.timeSlots.add(
                TimeSlot(
                  startTime: TimeOfDay(
                    hour: int.parse(opensParts[0]),
                    minute: int.parse(opensParts[1]),
                  ),
                  endTime: TimeOfDay(
                    hour: int.parse(closesParts[0]),
                    minute: int.parse(closesParts[1]),
                  ),
                ),
              );
            }
          }
        }
        setState(() {});
      }
    }
  }

  // Available time zones
  final List<String> timeZones = [
    'GMT-12 (Baker Island)',
    'GMT-11 (American Samoa)',
    'GMT-10 (Hawaii)',
    'GMT-9 (Alaska)',
    'GMT-8 (Pacific Time)',
    'GMT-7 (Mountain Time)',
    'GMT-6 (Central Time)',
    'GMT-5 (Eastern Time)',
    'GMT-4 (Atlantic Time)',
    'GMT-3 (Buenos Aires)',
    'GMT-2 (South Georgia)',
    'GMT-1 (Azores)',
    'GMT+0 (London, Dublin)',
    'GMT+1 (West African Standard Time)',
    'GMT+2 (South Africa)',
    'GMT+3 (East Africa, Moscow)',
    'GMT+4 (Dubai)',
    'GMT+5 (Pakistan)',
    'GMT+5:30 (India)',
    'GMT+6 (Bangladesh)',
    'GMT+7 (Bangkok)',
    'GMT+8 (Singapore, Beijing)',
    'GMT+9 (Tokyo)',
    'GMT+10 (Sydney)',
    'GMT+11 (Solomon Islands)',
    'GMT+12 (New Zealand)',
  ];

  // Day schedules
  final List<DaySchedule> daySchedules = [
    DaySchedule(
      day: 'monday',
      timeSlots: [],
      isSelected: false,
    ),
    DaySchedule(
      day: 'tuesday',
      timeSlots: [
        TimeSlot(
          startTime: const TimeOfDay(hour: 9, minute: 0),
          endTime: const TimeOfDay(hour: 17, minute: 0),
        ),
      ],
      isSelected: true,
    ),
    DaySchedule(
      day: 'wednesday',
      timeSlots: [
        TimeSlot(
          startTime: const TimeOfDay(hour: 9, minute: 0),
          endTime: const TimeOfDay(hour: 17, minute: 0),
        ),
      ],
      isSelected: true,
    ),
    DaySchedule(
      day: 'thursday',
      timeSlots: [
        TimeSlot(
          startTime: const TimeOfDay(hour: 9, minute: 0),
          endTime: const TimeOfDay(hour: 17, minute: 0),
        ),
      ],
      isSelected: true,
    ),
    DaySchedule(
      day: 'friday',
      timeSlots: [
        TimeSlot(
          startTime: const TimeOfDay(hour: 9, minute: 0),
          endTime: const TimeOfDay(hour: 17, minute: 0),
        ),
      ],
      isSelected: true,
    ),
    DaySchedule(
      day: 'saturday',
      timeSlots: [],
      isSelected: false,
    ),
    DaySchedule(
      day: 'sunday',
      timeSlots: [],
      isSelected: false,
    ),
  ];

  Future<void> _saveSchedule() async {
    final provider = Provider.of<SpecialistProvider>(context, listen: false);

    // Validate that at least one day is selected
    final selectedDays = daySchedules.where((d) => d.isSelected).toList();
    if (selectedDays.isEmpty) {
      SnackBarUtils.showError(
          context, "Please select at least one available day");
      return;
    }

    // Build availabilities array from selected days
    final availabilities = selectedDays.map((daySchedule) {
      // Use first time slot for each day
      final timeSlot = daySchedule.timeSlots.isNotEmpty
          ? daySchedule.timeSlots.first
          : TimeSlot(
              startTime: const TimeOfDay(hour: 9, minute: 0),
              endTime: const TimeOfDay(hour: 17, minute: 0),
            );

      return {
        "day_of_week": daySchedule.day,
        "opens_at":
            "${timeSlot.startTime.hour.toString().padLeft(2, '0')}:${timeSlot.startTime.minute.toString().padLeft(2, '0')}:00",
        "closes_at":
            "${timeSlot.endTime.hour.toString().padLeft(2, '0')}:${timeSlot.endTime.minute.toString().padLeft(2, '0')}:00",
      };
    }).toList();

    String? error;

    if (widget.isUpdateMode) {
      // Update mode - only update availability, session duration, and timezone
      error = await provider.updateSpecialistProfile(
        availabilities: availabilities,
        sessionDurationMinutes: sessionMinutes,
        timeZone: selectedTimeZone,
      );
    } else {
      // Create mode - validate temp data and create profile
      if (provider.tempBio == null || provider.tempPrimaryPhone == null) {
        SnackBarUtils.showError(
            context, "Please complete the profile setup first");
        return;
      }

      error = await provider.createProfile(
        bio: provider.tempBio!,
        consultationType: provider.tempConsultationType!,
        languagesSpoken: provider.tempLanguagesSpoken ?? '',
        yearsOfExperience: provider.tempYearsOfExperience ?? 0,
        sessionDurationMinutes: sessionMinutes,
        specialtyId: provider.tempSpecialtyId ?? '',
        primaryPhone: provider.tempPrimaryPhone!,
        secondaryPhone: provider.tempSecondaryPhone,
        availabilities: availabilities,
        country: provider.tempCountry!,
        timeZone: selectedTimeZone,
      );
    }

    if (error != null) {
      print("General log: the error is $error");

      // log out user from authProvider if token is expired
      if (error == AppConstants.invalidOrExpiredToken) {
        final authProvider = context.read<AuthProvider>();
        authProvider.logout();
        context.go(AppRoutes.login);
        return;
      }
      // Send code and go to verification screen
      if (error == AppConstants.emailUnverified2) {
        SnackBarUtils.showWarning(context, error);
        final authProvider = context.read<AuthProvider>();
        await authProvider.resendOtp();
        context.hideLoadingDialog();
        context.goNextScreen(AppRoutes.verifyOtp);
      }
      SnackBarUtils.showError(context, error);
      return;
    }

    if (!widget.isUpdateMode) {
      // Clear temp data only in create mode
      provider.tempBio = null;
      provider.tempConsultationType = null;
      provider.tempLanguagesSpoken = null;
      provider.tempYearsOfExperience = null;
      provider.tempSpecialtyId = null;
      provider.tempPrimaryPhone = null;
      provider.tempSecondaryPhone = null;
      provider.tempCountry = null;
    }

    // Navigate based on mode
    SnackBarUtils.showSuccess(
      context,
      widget.isUpdateMode
          ? "Schedule updated successfully!"
          : "Profile created successfully!",
    );

    if (widget.isUpdateMode) {
      context.goBack();
    } else {
      context.goNextScreen(AppRoutes.specialistRootScreen);
    }
  }

  Future<void> _pickTime(BuildContext context, DaySchedule daySchedule,
      int slotIndex, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime
          ? daySchedule.timeSlots[slotIndex].startTime
          : daySchedule.timeSlots[slotIndex].endTime,
    );

    if (picked != null) {
      setState(() {
        if (isStartTime) {
          daySchedule.timeSlots[slotIndex].startTime = picked;
        } else {
          daySchedule.timeSlots[slotIndex].endTime = picked;
        }
      });
    }
  }

  void _toggleDay(int index) {
    setState(() {
      daySchedules[index].isSelected = !daySchedules[index].isSelected;
      // Add default time slot if day is selected and has no slots
      if (daySchedules[index].isSelected &&
          daySchedules[index].timeSlots.isEmpty) {
        daySchedules[index].timeSlots.add(
              TimeSlot(
                startTime: const TimeOfDay(hour: 9, minute: 0),
                endTime: const TimeOfDay(hour: 17, minute: 0),
              ),
            );
      }
    });
  }

  void _addTimeSlot(DaySchedule daySchedule) {
    setState(() {
      daySchedule.timeSlots.add(
        TimeSlot(
          startTime: const TimeOfDay(hour: 9, minute: 0),
          endTime: const TimeOfDay(hour: 17, minute: 0),
        ),
      );
    });
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour : $minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),

            /// Title
            const Text(
              'Set Your Availability',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            const Text(
              'Define when patients can book consultations with you.',
              style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
            ),

            const SizedBox(height: 24),

            _section('How long is each session?'),
            const SizedBox(height: 5),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [10, 15, 20, 30, 45, 60]
                  .map((m) => _chip('$m mins', sessionMinutes == m,
                      () => setState(() => sessionMinutes = m)))
                  .toList(),
            ),

            const SizedBox(height: 24),

            _section("Set the days and times you're available."),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (index) {
                final dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                return _dayChip(
                  dayLabels[index],
                  daySchedules[index].isSelected,
                  () => _toggleDay(index),
                );
              }),
            ),

            const SizedBox(height: 16),

            ...daySchedules
                .where((d) => d.isSelected)
                .map((daySchedule) => _dayScheduleWidget(daySchedule))
                .toList(),

            const SizedBox(height: 20),

            _expandable('Break Times (Optional)'),

            const SizedBox(height: 20),

            _section('Maximum Daily Appointments'),
            _input(maxAppointmentsController),
            const SizedBox(height: 4),
            const Text(
              'How many consultations can you take per day?',
              style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
            ),

            const SizedBox(height: 20),

            _section('Time Zone'),
            _dropdown(selectedTimeZone),
            const SizedBox(height: 6),
            const Text(
              'Auto-detected default but editable.',
              style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
            ),

            const SizedBox(height: 28),

            /// Actions
            Consumer<SpecialistProvider>(
              builder: (context, provider, child) {
                return CustomButton(
                  onPressed: _saveSchedule,
                  text: "Save Schedule",
                  showLoading: provider.isLoading,
                );
              },
            ),

            const SizedBox(height: 12),

            CancelButton(),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  /// ------------------------------------------------------------
  /// Widgets
  /// ------------------------------------------------------------

  Widget _section(String text) => Text(
        text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      );

  Widget _chip(String text, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.transRed10 : Colors.white,
          border: Border.all(
              color: selected ? AppColors.red : const Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: selected ? AppColors.red : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _dayChip(String d, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFB00000) : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          d,
          style: TextStyle(color: selected ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  Widget _dayScheduleWidget(DaySchedule daySchedule) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          daySchedule.day[0].toUpperCase() + daySchedule.day.substring(1),
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
        const SizedBox(height: 8),
        ...daySchedule.timeSlots.asMap().entries.map((entry) {
          final index = entry.key;
          final timeSlot = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Expanded(
                  child: _timeBox(
                    _formatTimeOfDay(timeSlot.startTime),
                    () => _pickTime(context, daySchedule, index, true),
                  ),
                ),
                const SizedBox(width: 10),
                const Text('—'),
                const SizedBox(width: 10),
                Expanded(
                  child: _timeBox(
                    _formatTimeOfDay(timeSlot.endTime),
                    () => _pickTime(context, daySchedule, index, false),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        TextButton(
          onPressed: () => _addTimeSlot(daySchedule),
          child: const Text('Add Another Time Slot'),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _timeBox(String time, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(child: Text(time)),
            const Icon(Icons.access_time, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _input(TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _dropdown(String text) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedTimeZone,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: timeZones
              .map((timezone) => DropdownMenuItem<String>(
                    value: timezone,
                    child: Text(
                      timezone,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ))
              .toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                selectedTimeZone = value;
              });
            }
          },
        ),
      ),
    );
  }

  Widget _expandable(String title) {
    return GestureDetector(
      onTap: () {
        setState(() {
          showBreakTimes = !showBreakTimes;
        });
      },
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(child: Text(title)),
            Icon(showBreakTimes
                ? Icons.keyboard_arrow_up
                : Icons.keyboard_arrow_down),
          ],
        ),
      ),
    );
  }
}

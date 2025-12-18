import 'package:flutter/material.dart';

class SpecialistAvailabilityScreen extends StatefulWidget {
  const SpecialistAvailabilityScreen({super.key});

  @override
  State<SpecialistAvailabilityScreen> createState() =>
      _SpecialistAvailabilityScreenState();
}

class _SpecialistAvailabilityScreenState
    extends State<SpecialistAvailabilityScreen> {
  int sessionMinutes = 15;
  String consultationType = 'In-person';
  final Set<String> selectedDays = {'T', 'W', 'T2', 'F'};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
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
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [10, 15, 20, 30, 45, 60]
                  .map((m) => _chip('$m mins', sessionMinutes == m,
                      () => setState(() => sessionMinutes = m)))
                  .toList(),
            ),

            const SizedBox(height: 24),

            _section('Available Consultation Types'),
            Row(
              children: [
                _typeButton(Icons.videocam, 'Video call'),
                const SizedBox(width: 10),
                _typeButton(Icons.call, 'Voice call'),
                const SizedBox(width: 10),
                _typeButton(Icons.location_on, 'In-person', selected: true),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              'In-person location: City General Hospital, Lagos.',
              style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
            ),

            const SizedBox(height: 24),

            _section('Set the days and times you’re available.'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (final d in ['M', 'T', 'W', 'T', 'F', 'S', 'S'])
                  _dayChip(d, ['T', 'W', 'T2', 'F'].contains(d)),
              ],
            ),

            const SizedBox(height: 16),

            ...['Tuesday', 'Wednesday', 'Thursday', 'Friday']
                .map(_daySchedule)
                .toList(),

            const SizedBox(height: 20),

            _expandable('Break Times (Optional)'),

            const SizedBox(height: 20),

            _section('Maximum Daily Appointments'),
            _input('7'),
            const SizedBox(height: 4),
            const Text(
              'How many consultations can you take per day?',
              style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
            ),

            const SizedBox(height: 20),

            _section('Time Zone'),
            _dropdown('GMT+1 (West African Standard Time)'),
            const SizedBox(height: 6),
            const Text(
              'Auto-detected default but editable.',
              style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
            ),

            const SizedBox(height: 28),

            /// Actions
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB00000),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Save Schedule',
                    style: TextStyle(color: Colors.white)),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  backgroundColor: const Color(0xFFFDECEC),
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child:
                    const Text('Cancel', style: TextStyle(color: Colors.red)),
              ),
            ),

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
          color: selected ? const Color(0xFFFDECEC) : Colors.white,
          border: Border.all(
              color: selected ? Colors.red : const Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: selected ? Colors.red : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _typeButton(IconData icon, String label, {bool selected = false}) {
    return Expanded(
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFB00000) : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: selected ? Colors.white : Colors.grey),
            const SizedBox(width: 6),
            Text(label,
                style: TextStyle(color: selected ? Colors.white : Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _dayChip(String d, bool selected) {
    return Container(
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
    );
  }

  Widget _daySchedule(String day) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(day,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _timeBox('09 : 00 AM')),
            const SizedBox(width: 10),
            const Text('—'),
            const SizedBox(width: 10),
            Expanded(child: _timeBox('05 : 00 PM')),
          ],
        ),
        TextButton(
          onPressed: () {},
          child: const Text('Add Another Time Slot'),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _timeBox(String time) {
    return Container(
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
    );
  }

  Widget _input(String value) {
    return TextField(
      controller: TextEditingController(text: value),
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
      child: Row(
        children: [
          Expanded(child: Text(text)),
          const Icon(Icons.keyboard_arrow_down),
        ],
      ),
    );
  }

  Widget _expandable(String title) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(child: Text(title)),
          const Icon(Icons.keyboard_arrow_down),
        ],
      ),
    );
  }
}

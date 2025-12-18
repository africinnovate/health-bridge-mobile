import 'package:flutter/material.dart';

class AppointmentRequestsScreen extends StatelessWidget {
  const AppointmentRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            _header(context),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: 3,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (_, index) {
                  return AppointmentRequestCard(
                    isVideo: index != 2,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// --------------------------------------------------
  /// Header
  /// --------------------------------------------------
  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.arrow_back),
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            'Appointment Requests',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }
}

/// ======================================================
/// Appointment Request Card
/// ======================================================
class AppointmentRequestCard extends StatelessWidget {
  final bool isVideo;

  const AppointmentRequestCard({
    super.key,
    required this.isVideo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _headerRow(),
          const SizedBox(height: 12),
          _metaRow(),
          const SizedBox(height: 12),
          _symptomPreview(),
          const SizedBox(height: 16),
          _actions(),
        ],
      ),
    );
  }

  /// --------------------------------------------------
  Widget _headerRow() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 22,
          backgroundImage: AssetImage('assets/patient.png'),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Text(
            'James Adebayo',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _metaRow() {
    return Row(
      children: [
        Icon(
          isVideo ? Icons.videocam : Icons.location_on,
          size: 16,
          color: Colors.grey,
        ),
        const SizedBox(width: 6),
        Text(
          isVideo ? 'Video Call' : 'In Person',
          style: const TextStyle(fontSize: 13, color: Colors.grey),
        ),
        const SizedBox(width: 12),
        const Icon(Icons.access_time, size: 16, color: Colors.grey),
        const SizedBox(width: 6),
        const Text(
          'Tomorrow, 2:00 PM',
          style: TextStyle(fontSize: 13, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _symptomPreview() {
    return const Text(
      'Experiencing chest pain and shortness of breath for 2 days. '
      'Pain is mild to moderate, occurs mostly during physical activity. '
      'Also feeling occasional dizziness...',
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
    );
  }

  Widget _actions() {
    return Row(
      children: [
        Expanded(
          child: _confirmButton(),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _rescheduleButton(),
        ),
      ],
    );
  }

  Widget _confirmButton() {
    return Container(
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFF15803D),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        'Confirm',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _rescheduleButton() {
    return Container(
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: const Text(
        'Re-schedule',
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

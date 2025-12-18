import 'package:flutter/material.dart';

class AppointmentCard extends StatelessWidget {
  final bool showActions;

  const AppointmentCard({super.key, required this.showActions});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
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
          ),
          const SizedBox(height: 8),
          const Row(
            children: [
              Icon(Icons.videocam, size: 16, color: Colors.grey),
              SizedBox(width: 6),
              Text('Video Call',
                  style: TextStyle(fontSize: 13, color: Colors.grey)),
              SizedBox(width: 12),
              Icon(Icons.access_time, size: 16, color: Colors.grey),
              SizedBox(width: 6),
              Text('Tomorrow, 2:00 PM',
                  style: TextStyle(fontSize: 13, color: Colors.grey)),
            ],
          ),
          if (showActions) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _reschedule()),
                const SizedBox(width: 12),
                Expanded(child: _cancel()),
              ],
            )
          ]
        ],
      ),
    );
  }

  Widget _reschedule() {
    return Container(
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFB00000),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        'Re-Schedule',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _cancel() {
    return Container(
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFFDECEC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        'Cancel',
        style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
      ),
    );
  }
}

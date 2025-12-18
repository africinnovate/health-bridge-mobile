import 'package:flutter/material.dart';

class SpecialistHomeScreen extends StatelessWidget {
  const SpecialistHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // bottomNavigationBar: _bottomNav(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              /// Header
              Row(
                children: [
                  const CircleAvatar(
                    radius: 22,
                    backgroundImage: AssetImage('assets/avatar.png'),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Hello, Dr Martins',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                      SizedBox(height: 2),
                      Text('Your schedule at a glance.',
                          style: TextStyle(
                              fontSize: 13, color: Color(0xFF6B7280))),
                    ],
                  ),
                  const Spacer(),
                  Stack(
                    children: [
                      Icon(Icons.notifications_none, size: 26),
                      Positioned(
                        right: 2,
                        top: 2,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                              color: Colors.red, shape: BoxShape.circle),
                        ),
                      )
                    ],
                  )
                ],
              ),

              const SizedBox(height: 24),

              _sectionTitle('Next Appointment'),
              _nextAppointmentCard(),

              const SizedBox(height: 24),

              _sectionHeader('Appointment Requests'),
              _requestCard(),
              _requestCard(),

              const SizedBox(height: 24),

              _sectionHeader('Upcoming Appointments'),
              _upcomingCard(),
              _upcomingCard(),
              _upcomingCard(),

              const SizedBox(height: 24),

              _sectionTitle('Recent Activity'),
              _activityItem(
                icon: Icons.check_circle,
                color: Colors.green,
                title: 'Consultation completed with Adaobi',
                time: '2 hours ago',
              ),
              _activityItem(
                icon: Icons.warning_amber_rounded,
                color: Colors.orange,
                title: 'Missed appointment marked for James',
                time: '2 hours ago',
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  /// ------------------------------------------------------------
  /// Widgets
  /// ------------------------------------------------------------

  Widget _sectionTitle(String title) {
    return Text(title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600));
  }

  Widget _sectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _sectionTitle(title),
        const Text('View All',
            style: TextStyle(fontSize: 13, color: Colors.red)),
      ],
    );
  }

  Widget _nextAppointmentCard() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFB00000),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 22,
                backgroundImage: AssetImage('assets/patient.png'),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Chisom Chukwukwe',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600)),
                  SizedBox(height: 2),
                  Text('Video Call', style: TextStyle(color: Colors.white70)),
                ],
              ),
              const Spacer(),
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                    color: Colors.white24, shape: BoxShape.circle),
                child: const Icon(Icons.videocam, color: Colors.white),
              )
            ],
          ),
          const Divider(color: Colors.white24, height: 24),
          Row(
            children: const [
              Expanded(
                child: _Info(label: 'Date', value: 'Monday May 3rd'),
              ),
              Expanded(
                child: _Info(label: 'Time', value: '09:00 AM - 09:30AM'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _outlinedButton('Re-Schedule', Colors.white, Colors.red),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _filledButton('View Profile', Colors.white24),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _requestCard() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundImage: AssetImage('assets/patient.png'),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('James Adebayo',
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.videocam, size: 14),
                      SizedBox(width: 4),
                      Text('Video Call • Tomorrow, 2:00 PM',
                          style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _filledButton('Confirm', Colors.green),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _outlinedButton('Re-schedule', Colors.red, Colors.red),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _upcomingCard() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Row(
            children: const [
              CircleAvatar(
                backgroundImage: AssetImage('assets/patient.png'),
              ),
              SizedBox(width: 12),
              Text('James Adebayo',
                  style: TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _filledButton('Re-Schedule', Colors.red),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _outlinedButton(
                    'Cancel', const Color(0xFFFDECEC), Colors.red),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _activityItem(
      {required IconData icon,
      required Color color,
      required String title,
      required String time}) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
                color: color.withOpacity(.15), shape: BoxShape.circle),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text(time,
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          )
        ],
      ),
    );
  }

  static Widget _filledButton(String text, Color color) {
    return Container(
      height: 44,
      alignment: Alignment.center,
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
      child: Text(text,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w500)),
    );
  }

  static Widget _outlinedButton(String text, Color bg, Color textColor) {
    return Container(
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: textColor),
      ),
      child: Text(text,
          style: TextStyle(color: textColor, fontWeight: FontWeight.w500)),
    );
  }

  Widget _bottomNav() {
    return BottomNavigationBar(
      currentIndex: 0,
      selectedItemColor: Colors.red,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today), label: 'Appointment'),
        BottomNavigationBarItem(icon: Icon(Icons.inbox), label: 'Requests'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}

class _Info extends StatelessWidget {
  final String label;
  final String value;

  const _Info({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(color: Colors.white70, fontSize: 12)),
        const SizedBox(height: 2),
        Text(value,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w500)),
      ],
    );
  }
}

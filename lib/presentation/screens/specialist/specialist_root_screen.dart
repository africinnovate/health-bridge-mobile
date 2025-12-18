import 'package:HealthBridge/presentation/screens/specialist/profile/specialist_profile_screen.dart';
import 'package:flutter/material.dart';

import 'appointment/appointment_requests_screen.dart';
import 'appointment/appointment_specialist_screen.dart';
import 'home/specialist_home_screen.dart';

class SpecialistRootScreen extends StatefulWidget {
  const SpecialistRootScreen({super.key});

  @override
  State<SpecialistRootScreen> createState() => _SpecialistRootScreenState();
}

class _SpecialistRootScreenState extends State<SpecialistRootScreen> {
  int _currentIndex = 0;

  final _screens = const [
    SpecialistHomeScreen(),
    SpecialistAppointmentsScreen(),
    AppointmentRequestsScreen(),
    SpecialistProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: 'Appointment'),
          BottomNavigationBarItem(icon: Icon(Icons.inbox), label: 'Requests'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

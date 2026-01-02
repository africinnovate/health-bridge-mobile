import 'package:HealthBridge/core/constants/app_colors.dart';
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
    SpecialistAppointmentsScreen(showArrow: false),
    AppointmentRequestsScreen(showBackArrow: false),
    SpecialistProfileScreen(showBackArrow: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.background,
        currentIndex: _currentIndex,
        selectedItemColor: AppColors.red,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed, // important for text to show
        showUnselectedLabels: true, // <— make sure unselected text shows
        showSelectedLabels: true,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 10,
        ),
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

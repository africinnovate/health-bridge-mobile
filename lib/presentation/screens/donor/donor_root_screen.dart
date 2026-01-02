import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

import '../general/profile/general_profile_screen.dart';
import 'appointment/donor_appointments_screen.dart';
import 'donations/donor_donations_screen.dart';
import 'home/donor_home_screen.dart';

class DonorRootScreen extends StatefulWidget {
  const DonorRootScreen({super.key});

  @override
  State<DonorRootScreen> createState() => _DonorRootScreenState();
}

class _DonorRootScreenState extends State<DonorRootScreen> {
  int _currentIndex = 0;

  final _screens = const [
    DonorHomeScreen(),
    DonorAppointmentsScreen(),
    DonorDonationsScreen(),
    GeneralProfileScreen(),
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
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
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
              icon: Icon(Icons.calendar_today), label: 'Appointments'),
          BottomNavigationBarItem(
              icon: Icon(Icons.water_drop_outlined), label: 'Donations'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

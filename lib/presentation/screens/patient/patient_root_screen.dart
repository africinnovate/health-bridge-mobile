import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/presentation/screens/patient/appointments/patient_appointments_screen.dart';
import 'package:HealthBridge/presentation/screens/patient/care/patient_care_screen.dart';
import 'package:HealthBridge/presentation/screens/patient/home/patient_home_screen.dart';
import 'package:flutter/material.dart';

import '../general/profile/general_profile_screen.dart';

class PatientRootScreen extends StatefulWidget {
  const PatientRootScreen({super.key});

  @override
  State<PatientRootScreen> createState() => _PatientRootScreenState();
}

class _PatientRootScreenState extends State<PatientRootScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  void _navigateToTab(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  List<Widget> get _screens => [
        PatientHomeScreen(onNavigateToTab: _navigateToTab),
        PatientAppointmentsScreen(),
        PatientCareScreen(onNavigateToTab: _navigateToTab),
        GeneralProfileScreen(),
      ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _currentIndex == 0,
      onPopInvoked: (didPop) {
        if (!didPop && _currentIndex != 0) {
          setState(() {
            _currentIndex = 0;
          });
          _pageController.animateToPage(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      },
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          children: _screens,
        ),
      bottomNavigationBar: Container(
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.home_outlined, Icons.home, 'Home', 0),
                _buildNavItem(Icons.calendar_today_outlined,
                    Icons.calendar_today, 'Appointments', 1),
                _buildNavItem(
                    Icons.favorite_outline, Icons.favorite, 'Care', 2),
                _buildNavItem(Icons.person_outline, Icons.person, 'Profile', 3),
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }

  Widget _buildNavItem(
      IconData outlinedIcon, IconData filledIcon, String label, int index) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? filledIcon : outlinedIcon,
              color: isSelected ? AppColors.red : const Color(0xFF9CA3AF),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? AppColors.red : const Color(0xFF9CA3AF),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

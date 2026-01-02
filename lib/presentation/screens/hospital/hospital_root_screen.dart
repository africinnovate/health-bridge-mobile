import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/presentation/screens/hospital/donations/donation_appointments_screen.dart';
import 'package:HealthBridge/presentation/screens/hospital/home/hospital_home_screen.dart';
import 'package:HealthBridge/presentation/screens/hospital/inventory/blood_inventory_screen.dart';
import 'package:HealthBridge/presentation/screens/hospital/profile/hospital_profile_screen.dart';
import 'package:HealthBridge/presentation/screens/hospital/requests/blood_requests_screen.dart';
import 'package:flutter/material.dart';

class HospitalRootScreen extends StatefulWidget {
  const HospitalRootScreen({super.key});

  @override
  State<HospitalRootScreen> createState() => _HospitalRootScreenState();
}

class _HospitalRootScreenState extends State<HospitalRootScreen> {
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
        HospitalHomeScreen(onNavigateToTab: _navigateToTab),
        const BloodRequestsScreen(),
        const DonationAppointmentsScreen(),
        const BloodInventoryScreen(),
        const HospitalProfileScreen(),
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
                _buildNavItem(
                    Icons.water_drop_outlined, Icons.water_drop, 'Requests', 1),
                _buildNavItem(Icons.monitor_heart_outlined, Icons.monitor_heart,
                    'Donations', 2),
                _buildNavItem(Icons.inventory_2_outlined, Icons.inventory_2,
                    'Inventory', 3),
                _buildNavItem(
                    Icons.person_outline, Icons.person, 'Profile', 4),
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

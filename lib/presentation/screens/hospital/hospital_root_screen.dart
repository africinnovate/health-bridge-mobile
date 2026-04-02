import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/core/utils/snackbar_utils.dart';
import 'package:HealthBridge/presentation/providers/hospital_provider.dart';
import 'package:HealthBridge/presentation/screens/hospital/donations/donation_appointments_screen.dart';
import 'package:HealthBridge/presentation/screens/hospital/home/hospital_home_screen.dart';
import 'package:HealthBridge/presentation/screens/hospital/inventory/blood_inventory_screen.dart';
import 'package:HealthBridge/presentation/screens/hospital/profile/hospital_profile_screen.dart';
import 'package:HealthBridge/presentation/screens/hospital/requests/blood_requests_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_routes.dart';
import '../../providers/auth_provider.dart';

class HospitalRootScreen extends StatefulWidget {
  const HospitalRootScreen({super.key});

  @override
  State<HospitalRootScreen> createState() => _HospitalRootScreenState();
}

class _HospitalRootScreenState extends State<HospitalRootScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  DateTime? _lastBackPressTime;

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
  void initState() {
    getProfile();
    super.initState();
  }

  Future<void> getProfile() async {
    // await Future.delayed(Duration(seconds: 3));
    var hospitalProvider = context.read<HospitalProvider>();
    debugPrint("General log: the res issue");
    String? res = await hospitalProvider.getHospitalProfile();
    debugPrint("General log: the res is - $res");

    if (res != null) {
      // check if email is verify
      if (res == AppConstants.emailUnverified) {
        // print("General log: the res is - $res");
        SnackBarUtils.showWarning(context, res);
        // Email not verified, navigate to OTP verification screen
        final authProvider = context.read<AuthProvider>();
        await authProvider.resendOtp();
        context.hideLoadingDialog();
        context.goNextScreen(AppRoutes.verifyOtp);
      } else if (res == "Hospital not found") {
        // go to complete profile onboard screen is user not found
        context.goNextScreen(AppRoutes.setProfileHospital);
      } else {
        SnackBarUtils.showWarning(context, res);
      }
      return;
    }

    // if firstname is empty, go to profile completion
    // if (hospitalProvider.hospitalProfile?.licenseNumber == null) {
    //   context.goNextScreen(AppRoutes.setProfileHospital);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        // If not on home tab, navigate to home tab first
        if (_currentIndex != 0) {
          setState(() {
            _currentIndex = 0;
          });
          _pageController.animateToPage(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
          return;
        }

        // On home tab, use double-tap to exit
        final now = DateTime.now();
        final backButtonHasNotBeenPressedTwice = _lastBackPressTime == null ||
            now.difference(_lastBackPressTime!) > const Duration(seconds: 2);

        if (backButtonHasNotBeenPressedTwice) {
          _lastBackPressTime = now;
          SnackBarUtils.showInfo(context, "Press back again to exit");
          return;
        }

        // Exit app safely
        WidgetsBinding.instance.addPostFrameCallback((_) {
          SystemNavigator.pop();
        });
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
                  _buildNavItem(Icons.water_drop_outlined, Icons.water_drop,
                      'Requests', 1),
                  _buildNavItem(Icons.monitor_heart_outlined,
                      Icons.monitor_heart, 'Donations', 2),
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

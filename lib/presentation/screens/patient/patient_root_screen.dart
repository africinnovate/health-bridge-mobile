import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/constants/app_constants.dart';
import 'package:HealthBridge/core/constants/app_routes.dart';
import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/core/utils/snackbar_utils.dart';
import 'package:HealthBridge/main.dart';
import 'package:HealthBridge/presentation/providers/patient_provider.dart';
import 'package:HealthBridge/presentation/screens/patient/appointments/patient_appointments_screen.dart';
import 'package:HealthBridge/presentation/screens/patient/care/patient_care_screen.dart';
import 'package:HealthBridge/presentation/screens/patient/home/patient_home_screen.dart';
import 'package:HealthBridge/presentation/screens/patient/profile/patient_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../donor/appointment/donor_appointments_screen.dart';
import '../general/profile/general_profile_screen.dart';

class PatientRootScreen extends StatefulWidget {
  const PatientRootScreen({super.key});

  @override
  State<PatientRootScreen> createState() => _PatientRootScreenState();
}

class _PatientRootScreenState extends State<PatientRootScreen> {
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
        PatientHomeScreen(onNavigateToTab: _navigateToTab),
        // PatientAppointmentsScreen(),
        const DonorAppointmentsScreen(appointmentType: 'patient'),

        PatientCareScreen(onNavigateToTab: _navigateToTab),
        // PatientProfileScreen()
        GeneralProfileScreen(),
      ];

  @override
  void initState() {
    getProfile();
    super.initState();
  }

  Future<void> getProfile() async {
    // await Future.delayed(Duration(seconds: 3));
    var patientApi = context.read<PatientProvider>();
    String? res = await patientApi.getPatientOrDonorProfile();

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
      } else {
        SnackBarUtils.showWarning(context, res);
      }
      return;
    }

    // if firstname is empty, go to profile completion
    if (patientApi.patientProfileM?.bloodType == null) {
      context.goNextScreen(AppRoutes.setProfilePatient);
    } else if (patientApi.patientProfileM!.firstName!.isEmpty) {
      context.goNextScreen(AppRoutes.editProfileDonor);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
                  _buildNavItem(Icons.calendar_today_outlined,
                      Icons.calendar_today, 'Appointments', 1),
                  _buildNavItem(
                      Icons.favorite_outline, Icons.favorite, 'Care', 2),
                  _buildNavItem(
                      Icons.person_outline, Icons.person, 'Profile', 3),
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

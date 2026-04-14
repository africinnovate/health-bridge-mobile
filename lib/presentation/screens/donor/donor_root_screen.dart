import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/core/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_routes.dart';
import '../../providers/auth_provider.dart';
import '../../providers/patient_provider.dart';
import '../general/profile/general_profile_screen.dart';
import '../general/profile/general_setting_screen.dart';
import '../general/wallet/wallet_screen.dart';
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
  DateTime? _lastBackPressTime;

  final _screens = const [
    DonorHomeScreen(),
    DonorAppointmentsScreen(),
    DonorDonationsScreen(),
    WalletScreen(),
    GeneralSettingScreen(),
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

    // if bloodType is empty, go to 'set profile' completion
    if (patientApi.patientProfileM?.bloodType == null) {
      context.goNextScreen(AppRoutes.setProfilePatient);
      return;
    }

    // if firstname is empty, go to profile completion
    if (patientApi.patientProfileM!.firstName.isNullExt) {
      context.goNextScreen(AppRoutes.editProfileDonor);
      return;
    }
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
            BottomNavigationBarItem(
                icon: Icon(Icons.account_balance_wallet_outlined),
                label: 'Wallet'),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined), label: 'Settings'),
          ],
        ),
      ),
    );
  }
}

import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/core/utils/snackbar_utils.dart';
import 'package:HealthBridge/presentation/providers/specialist_provider.dart';
import 'package:HealthBridge/presentation/screens/specialist/profile/specialist_profile_screen.dart';
import 'package:HealthBridge/presentation/screens/specialist/profile/specialist_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_routes.dart';
import '../../providers/auth_provider.dart';
import 'appointment/appointment_requests_screen.dart';
import 'appointment/appointment_specialist_screen.dart';
import 'home/specialist_home_screen.dart';
import 'wallet/specialist_wallet_screen.dart';

class SpecialistRootScreen extends StatefulWidget {
  const SpecialistRootScreen({super.key});

  @override
  State<SpecialistRootScreen> createState() => _SpecialistRootScreenState();
}

class _SpecialistRootScreenState extends State<SpecialistRootScreen> {
  int _currentIndex = 0;
  DateTime? _lastBackPressTime;

  final _screens = const [
    SpecialistHomeScreen(),
    SpecialistAppointmentsScreen(showArrow: false),
    AppointmentRequestsScreen(showBackArrow: false),
    SpecialistWalletScreen(),
    SpecialistSettingsScreen(showBackArrow: false),
  ];

  @override
  void initState() {
    getProfile();
    super.initState();
  }

  Future<void> getProfile() async {
    // await Future.delayed(Duration(seconds: 3));
    var specialistApi = context.read<SpecialistProvider>();
    String? res = await specialistApi.getSpecialistProfile();

    if (res != null) {
      final authProvider = context.read<AuthProvider>();

      // check if email is verify | role verification
      if (res == AppConstants.emailUnverified) {
        // print("General log: the res is - $res");
        SnackBarUtils.showWarning(context, res);
        // Email not verified, navigate to OTP verification screen
        await authProvider.resendOtp();
        context.hideLoadingDialog();
        context.goNextScreen(AppRoutes.verifyOtp);
        return;
      }

      // User id is null, navigate to login screen and re-login
      if (res == AppConstants.login) {
        // print("General log: the res is - $res");
        SnackBarUtils.showWarning(context, res);
        context.goNextScreen(AppRoutes.login);
        return;
      }

      if (res == AppConstants.specialistNotFound) {
        var value = await specialistApi.getSpecialties();
        if (value != null) {
          SnackBarUtils.showError(context, value);
          return;
        }
        context.goNextScreen(AppRoutes.setProfileSpecialist);
      } else {
        SnackBarUtils.showWarning(context, res);
      }
    } else {
      // Profile loaded successfully, also load specialties for display
      if (specialistApi.specialistProfileM!.firstName.isEmpty) {
        context.goNextScreen(AppRoutes.editPersonalSpecialist);
      }
      await specialistApi.getSpecialties();
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
                icon: Icon(Icons.calendar_today), label: 'Appointments'),
            BottomNavigationBarItem(icon: Icon(Icons.inbox), label: 'Requests'),
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

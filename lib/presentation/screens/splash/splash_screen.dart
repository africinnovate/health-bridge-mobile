import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/constants/app_routes.dart';
import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/data/dataSource/secureData/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Add a small delay for splash screen visibility
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    try {
      // Check if user is logged in
      final authData = await SecureStorage.getAuthData();

      if (authData == null) {
        // No auth data, navigate to login
        print("General log: Auth is empty");

        _navigateToLogin();
        return;
      }

      // Check if token and refresh_token exist
      final token = authData.token;
      final refreshToken = authData.refresh_token;

      if (token == null || token.isEmpty) {
        // Token is null or empty, navigate to login
        print("General log: Token is empty");
        _navigateToLogin();
        return;
      }

      // Token exists, check user role and navigate accordingly
      final role = authData.user.role;

      if (role.isEmpty) {
        print("General log: Role is empty");

        // No role found, navigate to login
        _navigateToLogin();
        return;
      }

      // Navigate based on role
      _navigateToRoleScreen(role);
    } catch (e) {
      print('Error during auth check: $e');
      // On error, navigate to login
      _navigateToLogin();
    }
  }

  void _navigateToLogin() {
    if (!mounted) return;
    context.go(AppRoutes.login);
  }

  void _navigateToRoleScreen(String role) {
    if (!mounted) return;

    if (role == "donor") {
      context.go(AppRoutes.donorRootScreen);
    } else if (role == "specialist") {
      context.go(AppRoutes.specialistRootScreen);
    } else if (role == "patient") {
      context.go(AppRoutes.patientRootScreen);
    } else {
      context.go(AppRoutes.hospitalRootScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo or App Icon
            Icon(
              Icons.health_and_safety,
              size: 100,
              color: AppColors.red,
            ),
            const SizedBox(height: 24),
            // App Name
            const Text(
              'HealthBridge',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            // Tagline
            const Text(
              'Connecting Lives, Saving Lives',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textGray,
              ),
            ),
            const SizedBox(height: 40),
            // Loading Indicator
            CircularProgressIndicator(
              color: AppColors.red,
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/core/utils/snackbar_utils.dart';
import 'package:HealthBridge/core/utils/validators.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:HealthBridge/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_routes.dart';
import '../../providers/auth_provider.dart';

class VerifyAccountScreen extends StatefulWidget {
  const VerifyAccountScreen({super.key});

  @override
  State<VerifyAccountScreen> createState() => _VerifyAccountScreenState();
}

class _VerifyAccountScreenState extends State<VerifyAccountScreen> {
  final TextEditingController _otpController = TextEditingController();
  int _resendCountdown = AppConstants.otpResendDelay;
  Timer? _timer;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  void _startResendTimer() {
    setState(() {
      _canResend = false;
      _resendCountdown = AppConstants.otpResendDelay;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown > 0) {
        setState(() {
          _resendCountdown--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      }
    });
  }

  Future<void> _verifyOtp() async {
    context.hideKeyboard();
    if (_otpController.text.length != AppConstants.otpLength) {
      SnackBarUtils.showError(
        context,
        'Please enter the complete ${AppConstants.otpLength}-digit code',
      );
      return;
    }

    final authProvider = context.read<AuthProvider>();

    final success = await authProvider.verifyOtp(
      otp: _otpController.text,
    );

    // TODO: Handle navigation based on verification result and role
    if (!mounted) return;

    if (Validators.role == "donor") {
      // adjust later | share profile with specialist
      context.goNextScreen(AppRoutes.donorRootScreen);
    } else if (Validators.role == "specialist") {
      context.goNextScreen(AppRoutes.setProfileSpecialist);
    } else if (Validators.role == "patient") {
      context.goNextScreen(AppRoutes.setProfilePatient);
    } else {
      context.goNextScreen(AppRoutes.setProfileHospital);
    }

    ;
  }

  Future<void> _resendOtp() async {
    final authProvider = context.read<AuthProvider>();

    final success = await authProvider.resendOtp();

    if (!mounted) return;

    if (success) {
      SnackBarUtils.showSuccess(context, 'OTP resent successfully!');
      _startResendTimer();
    } else {
      SnackBarUtils.showError(
        context,
        'Failed to resend OTP',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        onBack: context.goBack,
        actions: [
          IconButton(
            icon: const Icon(Icons.support_agent, color: Colors.black),
            onPressed: () {
              // Handle help action
              SnackBarUtils.showInfo(context, "Support in progress");
            },
          ),
        ],
      ),
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: context.hideKeyboard,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // Title
                const Text(
                  'Verify Your Account',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 8),

                // Subtitle with email
                Text(
                  "We sent a 6-digit code to your email/phone. \nEnter it below to continue.",
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textGray,
                  ),
                ),

                const SizedBox(height: 40),

                // PIN input
                PinCodeTextField(
                  appContext: context,
                  length: AppConstants.otpLength,
                  controller: _otpController,
                  // readOnly: true,
                  enablePinAutofill: false,
                  showCursor: true,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(12),
                    fieldHeight: 60,
                    fieldWidth: 60,
                    activeFillColor: AppColors.backgroundGray,
                    inactiveFillColor: AppColors.white,
                    selectedFillColor: AppColors.transRed10,
                    activeColor: AppColors.backgroundGray,
                    inactiveColor: AppColors.border,
                    selectedColor: AppColors.red,
                  ),
                  animationDuration: const Duration(milliseconds: 200),
                  backgroundColor: Colors.transparent,
                  enableActiveFill: true,
                  onCompleted: (code) {
                    _verifyOtp();
                  },
                  onChanged: (value) {},
                ),

                const SizedBox(height: 24),

                // Resend code
                Center(
                  child: _canResend
                      ? TextButton(
                          onPressed: _resendOtp,
                          child: const Text('Resend Code'),
                        )
                      : Text(
                          'Resend code in $_resendCountdown seconds',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                ),

                const Spacer(),

                // Numeric keypad (custom)
                // _buildNumericKeypad(),

                const SizedBox(height: 24),

                // // Verify button
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return CustomButton(
                      onPressed: _verifyOtp,
                      text: 'Verify',
                      showLoading: authProvider.isLoading,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

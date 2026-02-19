import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/constants/app_constants.dart';
import 'package:HealthBridge/core/constants/app_routes.dart';
import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/core/services/validation_service.dart';
import 'package:HealthBridge/core/utils/snackbar_utils.dart';
import 'package:HealthBridge/presentation/providers/auth_provider.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:HealthBridge/presentation/widgets/custom_button.dart';
import 'package:HealthBridge/presentation/widgets/input_text_field_wg.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;

  const ResetPasswordScreen({
    super.key,
    required this.email,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final ValidationService _validationService = ValidationService();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  bool get shouldProceed =>
      _codeController.text.length == 6 &&
      _passwordController.text.trim().isNotEmpty &&
      _confirmPasswordController.text.trim().isNotEmpty;

  void _resetPassword() async {
    context.hideKeyboard();

    // Validate code
    if (_codeController.text.length != 6) {
      SnackBarUtils.showError(
        context,
        'Please enter the complete ${AppConstants.otpLength}-digit code',
      );
      return;
    }

    // Validate password
    final passwordError =
        _validationService.validatePassword(_passwordController.text);
    if (passwordError != null) {
      SnackBarUtils.showError(context, passwordError);
      return;
    }

    // Validate password confirmation
    if (_passwordController.text != _confirmPasswordController.text) {
      SnackBarUtils.showError(context, 'Passwords do not match');
      return;
    }

    context.showLoadingDialog();

    final authProvider = context.read<AuthProvider>();
    final error = await authProvider.resetPasswordWithCode(
      code: _codeController.text,
      newPassword: _passwordController.text,
    );

    context.hideLoadingDialog();

    if (error == null) {
      // Success
      if (!mounted) return;
      SnackBarUtils.showSuccess(
        context,
        'Password reset successfully! Please log in with your new password.',
      );
      context.go(AppRoutes.login);
    } else {
      // Error
      if (!mounted) return;
      SnackBarUtils.showError(context, error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: 'Reset Password',
        showArrow: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: context.hideKeyboard,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              /// Icon
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.green.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock_reset,
                    size: 40,
                    color: AppColors.green,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              /// Title
              const Text(
                'Create New Password',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 12),

              /// Subtitle
              Text(
                'We sent a 4-digit code to ${widget.email}. Enter it below along with your new password.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                ),
              ),

              const SizedBox(height: 32),

              /// Verification Code
              const Text(
                'Verification Code',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              PinCodeTextField(
                appContext: context,
                length: 6,
                controller: _codeController,
                keyboardType: TextInputType.number,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(10),
                  fieldHeight: 55,
                  fieldWidth: 55,
                  activeFillColor: Colors.white,
                  inactiveFillColor: AppColors.backgroundGray,
                  selectedFillColor: AppColors.backgroundGray,
                  activeColor: AppColors.green,
                  inactiveColor: const Color(0xFFE5E7EB),
                  selectedColor: AppColors.green,
                ),
                animationDuration: const Duration(milliseconds: 300),
                backgroundColor: Colors.transparent,
                enableActiveFill: true,
                onChanged: (value) => setState(() {}),
                beforeTextPaste: (text) => true,
              ),

              const SizedBox(height: 24),

              /// New Password
              const Text(
                'New Password',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _passwordController,
                onChanged: (value) => setState(() {}),
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintStyle: TextStyle(
                    color: AppColors.textGray.withOpacity(0.8),
                    fontWeight: FontWeight.w300,
                  ),
                  hintText: 'Enter new password',
                  filled: true,
                  fillColor: AppColors.backgroundGray,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: const Color(0xFF9CA3AF),
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                ),
              ),

              const SizedBox(height: 18),

              /// Confirm Password
              const Text(
                'Confirm Password',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _confirmPasswordController,
                onChanged: (value) => setState(() {}),
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  hintStyle: TextStyle(
                    color: AppColors.textGray.withOpacity(0.8),
                    fontWeight: FontWeight.w300,
                  ),
                  hintText: 'Confirm your new password',
                  filled: true,
                  fillColor: AppColors.backgroundGray,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: const Color(0xFF9CA3AF),
                    ),
                    onPressed: () {
                      setState(() =>
                          _obscureConfirmPassword = !_obscureConfirmPassword);
                    },
                  ),
                ),
              ),

              const SizedBox(height: 32),

              /// Reset Password Button
              Consumer<AuthProvider>(
                builder: (context, provider, child) {
                  return CustomButton(
                    onPressed: _resetPassword,
                    text: "Reset Password",
                    shouldProceed: shouldProceed,
                    showLoading: provider.isLoading,
                  );
                },
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}

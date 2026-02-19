import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/constants/app_routes.dart';
import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/core/utils/snackbar_utils.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:HealthBridge/presentation/widgets/custom_button.dart';
import 'package:HealthBridge/presentation/widgets/input_text_field_wg.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/services/validation_service.dart';
import '../../providers/auth_provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  final ValidationService _validationService = ValidationService();
  bool _emailSent = false;

  bool get shouldProceed => emailController.text.trim().isNotEmpty;

  void sendResetLink() async {
    context.hideKeyboard();

    final email = emailController.text.trim();

    // // Validate email
    // final emailError = _validationService.validateEmail(email);
    // if (emailError != null) {
    //   SnackBarUtils.showError(context, emailError);
    //   return;
    // }

    context.showLoadingDialog();

    final authProvider = context.read<AuthProvider>();
    final error = await authProvider.forgotPassword(email);

    context.hideLoadingDialog();

    if (error == null) {
      // Success - navigate to reset password screen
      if (!mounted) return;
      SnackBarUtils.showSuccess(
        context,
        'Password reset code sent to your email',
      );
      context.push(AppRoutes.resetPassword, extra: email);
    } else {
      // Error
      SnackBarUtils.showError(context, error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: 'Forgot Password',
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
                    color: AppColors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock_reset,
                    size: 40,
                    color: AppColors.red,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              /// Title
              const Text(
                'Reset Your Password',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 12),

              /// Subtitle
              Text(
                _emailSent
                    ? 'We\'ve sent a password reset link to your email. Please check your inbox and follow the instructions.'
                    : 'Enter your email address and we\'ll send you a code to reset your password.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                ),
              ),

              const SizedBox(height: 32),

              if (!_emailSent) ...[
                /// Email Field
                const Text(
                  'Email Address',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                InputTextFieldWG(
                  controller: emailController,
                  hintText: "Enter your email",
                  onChanged: (value) => setState(() {}),
                  // keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 32),

                /// Send Reset Link Button
                CustomButton(
                  onPressed: sendResetLink,
                  text: "Send Reset Link",
                  shouldProceed: shouldProceed,
                ),
              ] else ...[
                /// Email Sent Icon
                Center(
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.green.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      size: 35,
                      color: AppColors.green,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                /// Resend Link Button
                CustomButton(
                  onPressed: sendResetLink,
                  text: "Resend Link",
                  shouldProceed: true,
                ),

                const SizedBox(height: 16),

                /// Back to Login Button
                CustomButton(
                  onPressed: () {
                    context.pop();
                  },
                  text: "Back to Login",
                  shouldProceed: true,
                ),
              ],

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}

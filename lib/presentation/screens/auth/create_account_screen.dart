import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/constants/app_routes.dart';
import 'package:HealthBridge/core/extension/inbuilt_ext.dart';
import 'package:HealthBridge/core/utils/snackbar_utils.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:HealthBridge/presentation/widgets/input_text_field_wg.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/services/validation_service.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_button.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscurePassword = true;
  final ValidationService _validationService = ValidationService();

  bool get shouldProceed =>
      emailController.text.trim().isNotEmpty &&
      passwordController.text.trim().isNotEmpty;

  void createAccount() async {
    context.hideKeyboard();
    var authProvider = context.read<AuthProvider>();
    authProvider.email = emailController.text.trim();
    authProvider.password = passwordController.text.trim();
    print(
        "General log: the api is ${authProvider.role} ${authProvider.email} ${authProvider.password}");

    final emailError = _validationService.validateEmail(authProvider.email);
    if (emailError != null) {
      SnackBarUtils.showError(context, emailError);
      return;
    }
    final passwordError =
        _validationService.validatePassword(authProvider.password);
    if (passwordError != null) {
      SnackBarUtils.showError(context, passwordError);
      return;
    }

    // Handle navigation
    context.goNextScreen(AppRoutes.verifyOtp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: context.hideKeyboard,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              /// Title
              const Text(
                'Create Your Account',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 8),

              /// Subtitle
              const Text(
                'Join HealthBridge to request blood, donate, or connect with verified specialists.',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                ),
              ),

              const SizedBox(height: 28),

              /// Email / Phone
              const Text(
                'Email ',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              InputTextFieldWG(
                controller: emailController,
                hintText: "Enter email",
                onChanged: (value) => setState(() {}),
              ),

              const SizedBox(height: 18),

              /// Password
              const Text(
                'Password',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: passwordController,
                onChanged: (value) => setState(() {}),
                obscureText: obscurePassword,
                decoration: InputDecoration(
                  hintStyle: TextStyle(
                    color: AppColors.textGray.withOpacity(0.8),
                    fontWeight: FontWeight.w300,
                  ),
                  hintText: 'Enter password',
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
                      obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: const Color(0xFF6B7280),
                    ),
                    onPressed: () {
                      setState(() => obscurePassword = !obscurePassword);
                    },
                  ),
                ),
              ),

              const SizedBox(height: 24),

              /// Continue Button
              CustomButton(
                onPressed: createAccount,
                text: "Continues",
                shouldProceed: shouldProceed,
              ),

              const SizedBox(height: 24),

              /// OR Divider
              Row(
                children: const [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'Or',
                      style: TextStyle(color: Color(0xFF6B7280)),
                    ),
                  ),
                  Expanded(child: Divider()),
                ],
              ),

              const SizedBox(height: 20),

              /// Google Button
              SocialButton(
                icon: 'G',
                label: 'Continue with Google',
                onTap: () {
                  SnackBarUtils.showInfo(context, "Google Sign-In coming soon");
                },
              ),

              const SizedBox(height: 12),

              /// Apple Button
              SocialButton(
                icon: '',
                label: 'Continue with Apple',
                onTap: () {
                  SnackBarUtils.showInfo(context, "Apple Sign-In coming soon");
                },
              ),

              const SizedBox(height: 28),

              /// Login
              Center(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 14),
                    children: [
                      TextSpan(
                        text: 'Already Have an Account? ',
                        style: TextStyle(
                          color: AppColors.textGray,
                        ),
                      ),
                      TextSpan(
                        text: 'Login',
                        style: TextStyle(
                          color: AppColors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              /// Terms
              Center(
                child: Text(
                  'By creating an account, you agree to our Terms of Use and Privacy Policy.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textGray,
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

/// ------------------------------------------------------------
/// Social Button
/// ------------------------------------------------------------
class SocialButton extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;

  const SocialButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.backgroundGray,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              icon,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

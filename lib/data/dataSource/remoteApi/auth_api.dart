import 'package:HealthBridge/core/constants/app_constants.dart';
import 'package:HealthBridge/core/utils/response_utils.dart';
import 'package:HealthBridge/data/models/auth/auth_model.dart';
import '../../../core/di/injection.dart';
import '../../../core/network/api_client.dart';
import '../../models/response_status_m.dart';

class AuthApi {
  final ApiClient apiClient;

  AuthApi({required this.apiClient});

  Future<ResponseStatusM> registerUser(RegisterModel registerModel) async {
    final response = await apiClient.post(
      AppConstants.registerEndpoint,
      data: registerModel.toJson(),
    );

    return ResponseUtils.getApiResponse(response);
  }

  Future<ResponseStatusM> loginUser(RegisterModel registerModel) async {
    final response = await apiClient.post(
      AppConstants.loginEndpoint,
      data: registerModel.toJson(),
    );

    return ResponseUtils.getApiResponse(response);
  }

  Future<ResponseStatusM> verifyEmailViaOtp(Map<String, dynamic> load) async {
    final response = await apiClient.post(
      AppConstants.verifyEmailOtpEndpoint,
      data: load,
    );

    return ResponseUtils.getApiResponse(response);
  }

  /// Resend verification code to user's email
  Future<ResponseStatusM> resendVerificationCode(
      Map<String, dynamic> load) async {
    final response = await apiClient.post(
      AppConstants.resendOtpEndpoint,
      data: load,
    );

    return ResponseUtils.getApiResponse(response);
  }

  /// Refresh access token using refresh token
  Future<ResponseStatusM> refreshToken(String refreshToken) async {
    final response = await apiClient.post(
      AppConstants.refreshTokenEndpoint,
      data: {'refresh_token': refreshToken},
    );

    return ResponseUtils.getApiResponse(response);
  }

  /// Logout user - revokes refresh token
  Future<ResponseStatusM> logout(String refreshToken) async {
    final response = await apiClient.post(
      AppConstants.logoutEndpoint,
      data: {'refresh_token': refreshToken},
    );

    return ResponseUtils.getApiResponse(response);
  }

  /// Send password reset link to user's email
  Future<ResponseStatusM> forgotPassword(String email) async {
    final response = await apiClient.post(
      AppConstants.forgotPasswordEndpoint,
      data: {'email': email},
    );

    return ResponseUtils.getApiResponse(response);
  }

  /// Reset password using code from email
  Future<ResponseStatusM> resetPasswordWithCode({
    required String code,
    required String newPassword,
  }) async {
    final response = await apiClient.post(
      AppConstants.resetPasswordWithCodeEndpoint,
      data: {
        'code': code,
        'new_password': newPassword,
      },
    );

    return ResponseUtils.getApiResponse(response);
  }

  /// Reset/Change password for authenticated user
  Future<ResponseStatusM> resetPassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    var header = await Injection.tokenHeaders();

    final response = await apiClient.post(
      AppConstants.resetPasswordEndpoint,
      headers: header,
      data: {
        'new_password': newPassword,
        'old_password': currentPassword,
      },
    );

    return ResponseUtils.getApiResponse(response);
  }
}

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

    return ResponseUtils.getApiResponse(response,
        endpoint:
            "POST - ${AppConstants.registerEndpoint} \nData: ${registerModel.toJson()}");
  }

  Future<ResponseStatusM> loginUser(RegisterModel registerModel) async {
    final response = await apiClient.post(
      AppConstants.loginEndpoint,
      data: registerModel.toJson(),
    );

    return ResponseUtils.getApiResponse(response,
        endpoint:
            "POST - ${AppConstants.loginEndpoint} \nData: ${registerModel.toJson()}");
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

  /// Get consultation preference for authenticated user
  Future<ResponseStatusM> getConsultationPreference() async {
    var header = await Injection.tokenHeaders();

    final response = await apiClient.get(
      AppConstants.consultationPreferenceEP,
      headers: header,
    );

    return ResponseUtils.getApiResponse(response,
        endpoint: "GET - ${AppConstants.consultationPreferenceEP}");
  }

  /// Update consultation preference for authenticated user
  Future<ResponseStatusM> updateConsultationPreference(
      String preference) async {
    var header = await Injection.tokenHeaders();

    final response = await apiClient.put(
      AppConstants.consultationPreferenceEP,
      headers: header,
      data: {'preference': preference},
    );

    return ResponseUtils.getApiResponse(response);
  }

  /// Get user notification settings
  Future<ResponseStatusM> getUserSettings() async {
    var header = await Injection.tokenHeaders();

    final response = await apiClient.get(
      AppConstants.userSettingsEP,
      headers: header,
    );

    return ResponseUtils.getApiResponse(response);
  }

  /// Update user notification settings
  Future<ResponseStatusM> updateUserSettings(
      Map<String, dynamic> settings) async {
    var header = await Injection.tokenHeaders();

    final response = await apiClient.put(
      AppConstants.userSettingsEP,
      headers: header,
      data: settings,
    );

    return ResponseUtils.getApiResponse(response);
  }

  /// Social login/register (Google, etc.)
  Future<ResponseStatusM> socialLogin({
    required String accessToken,
    required String provider,
    String? role,
  }) async {
    final body = {
      'access_token': accessToken,
      'provider': provider,
      if (role != null) 'role': role,
    };

    final response = await apiClient.post(
      AppConstants.socialLoginEndpoint,
      data: body,
    );

    return ResponseUtils.getApiResponse(response);
  }

  /// Permanently delete the authenticated user's account
  Future<ResponseStatusM> deleteAccount() async {
    var header = await Injection.tokenHeaders();

    final response = await apiClient.post(
      AppConstants.deleteAccountEP,
      headers: header,
    );

    return ResponseUtils.getApiResponse(response);
  }

  /// Upload user profile image (multipart/form-data, field name: 'image')
  Future<ResponseStatusM> uploadImage(String filePath) async {
    var header = await Injection.tokenHeaders();

    final response = await apiClient.uploadFile(
      AppConstants.uploadImageEP,
      filePath: filePath,
      fieldName: 'image',
      headers: header,
    );

    return ResponseUtils.getApiResponse(response);
  }
}

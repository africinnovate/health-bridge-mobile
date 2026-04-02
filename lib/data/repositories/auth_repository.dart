import 'package:HealthBridge/data/dataSource/remoteApi/auth_api.dart';
import 'package:HealthBridge/data/models/response_status_m.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:HealthBridge/core/utils/response_utils.dart';
import '../models/auth/auth_model.dart';

class AuthRepository {
  final AuthApi authApi;
  final FlutterSecureStorage secureStorage;

  AuthRepository({
    required this.authApi,
    required this.secureStorage,
  });

  Future<ResponseStatusM> registerUser(RegisterModel registerModel) async {
    try {
      return await authApi.registerUser(registerModel);
    } catch (e) {
      return ResponseUtils.checkError(e);
    }
  }

  Future<ResponseStatusM> loginUser(RegisterModel registerModel) async {
    try {
      return await authApi.loginUser(registerModel);
    } catch (e) {
      return ResponseUtils.checkError(e);
    }
  }

  /// verify email via otp. Payload -  code and email
  Future<ResponseStatusM> verifyEmailViaOtp(Map<String, dynamic> load) async {
    try {
      return await authApi.verifyEmailViaOtp(load);
    } catch (e) {
      return ResponseUtils.checkError(e);
    }
  }

  /// Resend verification code. Payload - email
  Future<ResponseStatusM> resendVerificationCode(
      Map<String, dynamic> load) async {
    try {
      return await authApi.resendVerificationCode(load);
    } catch (e) {
      return ResponseUtils.checkError(e);
    }
  }

  /// Refresh access token using refresh token
  Future<ResponseStatusM> refreshToken(String refreshToken) async {
    try {
      return await authApi.refreshToken(refreshToken);
    } catch (e) {
      return ResponseUtils.checkError(e);
    }
  }

  /// Logout user - revokes refresh token
  Future<ResponseStatusM> logout(String refreshToken) async {
    try {
      return await authApi.logout(refreshToken);
    } catch (e) {
      return ResponseUtils.checkError(e);
    }
  }

  /// Reset/Change password for authenticated user
  Future<ResponseStatusM> resetPassword({
    required String currentPass,
    required String newPassword,
  }) async {
    try {
      return await authApi.resetPassword(
        currentPassword: currentPass,
        newPassword: newPassword,
      );
    } catch (e) {
      return ResponseUtils.checkError(e);
    }
  }

  /// Send password reset link to user's email
  Future<ResponseStatusM> forgotPassword(String email) async {
    try {
      return await authApi.forgotPassword(email);
    } catch (e) {
      return ResponseUtils.checkError(e);
    }
  }

  /// Reset password using code from email
  Future<ResponseStatusM> resetPasswordWithCode({
    required String code,
    required String newPassword,
  }) async {
    try {
      return await authApi.resetPasswordWithCode(
        code: code,
        newPassword: newPassword,
      );
    } catch (e) {
      return ResponseUtils.checkError(e);
    }
  }

  /// Get consultation preference for authenticated user
  Future<ResponseStatusM> getConsultationPreference() async {
    try {
      return await authApi.getConsultationPreference();
    } catch (e) {
      return ResponseUtils.checkError(e);
    }
  }

  /// Update consultation preference for authenticated user
  Future<ResponseStatusM> updateConsultationPreference(
      String preference) async {
    try {
      return await authApi.updateConsultationPreference(preference);
    } catch (e) {
      return ResponseUtils.checkError(e);
    }
  }

  /// Get user notification settings
  Future<ResponseStatusM> getUserSettings() async {
    try {
      return await authApi.getUserSettings();
    } catch (e) {
      return ResponseUtils.checkError(e);
    }
  }

  /// Update user notification settings
  Future<ResponseStatusM> updateUserSettings(
      Map<String, dynamic> settings) async {
    try {
      return await authApi.updateUserSettings(settings);
    } catch (e) {
      return ResponseUtils.checkError(e);
    }
  }

  /// Social login/register
  Future<ResponseStatusM> socialLogin({
    required String accessToken,
    required String provider,
    String? role,
  }) async {
    try {
      return await authApi.socialLogin(
        accessToken: accessToken,
        provider: provider,
        role: role,
      );
    } catch (e) {
      return ResponseUtils.checkError(e);
    }
  }

  /// Permanently delete the authenticated user's account
  Future<ResponseStatusM> deleteAccount() async {
    try {
      return await authApi.deleteAccount();
    } catch (e) {
      return ResponseUtils.checkError(e);
    }
  }

  /// Upload user profile image
  Future<ResponseStatusM> uploadImage(String filePath) async {
    try {
      return await authApi.uploadImage(filePath);
    } catch (e) {
      return ResponseUtils.checkError(e);
    }
  }
}

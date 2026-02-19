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
}

import 'dart:core';

import 'package:HealthBridge/core/constants/app_constants.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:HealthBridge/core/utils/response_utils.dart';
import 'package:HealthBridge/data/dataSource/secureData/secure_storage.dart';
import 'package:HealthBridge/data/models/auth/auth_model.dart';
import 'package:HealthBridge/data/models/response_status_m.dart';
import 'package:flutter/cupertino.dart';

import '../../data/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository authRepository;

  AuthProvider({
    required this.authRepository,
  });

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String email = '';
  String password = '';
  String role = '';

  // RegisterModel _registerModel;
  RegisterModel get registerModel => RegisterModel(
        email: email,
        password: password,
        role: role,
      );

  String? token;
  String? refreshToken;
  UserModel? userModel;

  Future<void> loadAuthData() async {
    final authData = await SecureStorage.getAuthData();
    if (authData != null) {
      token = authData.token;
      refreshToken = authData.refresh_token;
      userModel = authData.user;
      notifyListeners();
    }
  }

  /// login|register user with email, password, role(optional for login)
  Future<String?> authUser(String option) async {
    final res = option == AppConstants.register
        ? await getResponse(authRepository.registerUser(registerModel))
        : await getResponse(authRepository.loginUser(registerModel));

    if (ResponseUtils.isSuccessful(res)) {
      if (res.data == null) return 'Invalid server response';

      final authData = AuthDataModel.fromJson(res.data);

      token = authData.token;
      refreshToken = authData.refresh_token;
      userModel = authData.user;

      await SecureStorage.saveAuthData(authData);

      return null; // success
    }
    print("General log: authUser error message: ${res.message}");
    return res.message;
  }

  /* Details
  donor - ronokinno+01@gmail.com
  hospital - ronokinno+02@gmail.com
  patient - ronokinno+03@gmail.com
  specialist - ronokinno+04@gmail.com,

Hospital
  africinnovate@gmail.com
  password

Specialist
  gdgeket@gmail.com
  password

  ResponseStatusM {
   status_code: 201,
   message: User registered successfully,
   data: {token: , refresh_token: , user: {id: 7faae0ea-31f6-4263-b4e5-aa92d8899305, first_name: , last_name: , email: ronokinno@gmail.com, role: specialist}},
   time: 1768055828095 (2026-01-10 15:37:08.095)
 }

 {id: ae07caac-c931-4e0c-8d39-49c22e826b42, first_name: Seleh, last_name: Nowy, email: ronokinno+01@gmail.com, phone: 09098774433, gender: male, dob: 1995-01-15, role: donor, email_verified: true, address: 55 Abak road, image_url: null, blood_type: B+, chronic_illnesses: , allergies: , medications: , existing_conditions: , primary_physician: null, hmo_number: , emergency_contact_name: John Prince, emergency_contact_phone: 09097834343, medical_notes: I am healthy}
   */

  /// Resend verification code to user's email
  Future<String?> resendOtp() async {
    var authData = await SecureStorage.getAuthData();

    var payload = {"email": userModel?.email ?? authData?.user.email ?? email};
    // print("General log: payload is $payload");
    final res =
        await getResponse(authRepository.resendVerificationCode(payload));

    if (ResponseUtils.isSuccessful(res)) {
      return null; // success
    }
    return res.message ?? "Failed to resend verification code";
  }

  /// verify email via otp. Payload -  code and email
  Future<String?> verifyEmailViaOtp({required String otp}) async {
    var payload = {"code": otp, "email": email};
    final res = await getResponse(authRepository.verifyEmailViaOtp(payload));

    if (ResponseUtils.isSuccessful(res)) {
      // Check if data is null or empty object
      if (res.data == null || res.data.isEmpty) {
        // Email verified successfully but no new tokens returned
        // This is normal - just return success
        return null;
      }

      // Check if data contains token and user (some APIs return new tokens after verification)
      if (res.data.containsKey('token') && res.data.containsKey('user')) {
        final authData = AuthDataModel.fromJson(res.data);

        // update the authData
        if (authData.token != null && authData.token!.isNotEmpty) {
          token = authData.token;
          refreshToken = authData.refresh_token;
          var auth = AuthDataModel(
              token: token!, refresh_token: refreshToken!, user: userModel!);
          await SecureStorage.saveAuthData(auth);
        }
      }

      return null; // success
    }
    return res.message ?? "An error occurred";
  }

  Future<bool> isUserLoggedIn() async {
    return await SecureStorage.getAuthData() != null;
  }

  /// Logout user - revokes refresh token and clears local data
  Future<String?> logout() async {
    // Get refresh token from storage
    final authData = await SecureStorage.getAuthData();
    if (authData == null || authData.refresh_token == null) {
      // No auth data, just clear local storage
      await SecureStorage.clearProfile();
      token = null;
      refreshToken = null;
      userModel = null;
      notifyListeners();
      return null; // success (nothing to logout from)
    }

    // Call logout API to revoke refresh token
    final res =
        await getResponse(authRepository.logout(authData.refresh_token!));

    // Clear local storage regardless of API response
    // (user should be logged out locally even if API call fails)
    await SecureStorage.clearProfile();
    token = null;
    refreshToken = null;
    userModel = null;
    notifyListeners();

    if (ResponseUtils.isSuccessful(res)) {
      return null; // success
    }

    // Even if API failed, we still cleared local data
    // So return success to avoid confusing the user
    return null;
  }

  /// Refresh access token using refresh token
  /// This method can be called proactively to refresh the token before it expires
  /// Returns null on success, error message on failure
  Future<String?> refreshAccessToken() async {
    // Get refresh token from storage
    final authData = await SecureStorage.getAuthData();
    if (authData == null || authData.refresh_token == null) {
      return 'No refresh token available';
    }

    final res = await getResponse(
      authRepository.refreshToken(authData.refresh_token!),
      shouldLoad: false, // Don't show loading indicator for background refresh
    );

    if (ResponseUtils.isSuccessful(res)) {
      if (res.data == null) return 'Invalid server response';

      // Extract new tokens from response
      final newAccessToken = res.data['access_token'];
      final newRefreshToken = res.data['refresh_token'];

      if (newAccessToken == null || newRefreshToken == null) {
        return 'Invalid token response';
      }

      // Update stored auth data with new tokens
      final updatedAuthData = AuthDataModel(
        token: newAccessToken,
        refresh_token: newRefreshToken,
        user: authData.user,
      );

      await SecureStorage.saveAuthData(updatedAuthData);

      // Update provider state
      token = newAccessToken;
      refreshToken = newRefreshToken;
      notifyListeners();
      // debugPrint("General log: the new token is $newAccessToken");
      return null; // success
    }

    return res.message ?? 'Failed to refresh token';
  }

  /// Send password reset link to user's email
  Future<String?> forgotPassword(String email) async {
    final res = await getResponse(
      authRepository.forgotPassword(email),
    );

    if (ResponseUtils.isSuccessful(res)) {
      return null; // success
    }

    return res.message ?? 'Failed to send reset link';
  }

  /// Reset password using code from email
  Future<String?> resetPasswordWithCode({
    required String code,
    required String newPassword,
  }) async {
    final res = await getResponse(
      authRepository.resetPasswordWithCode(
        code: code,
        newPassword: newPassword,
      ),
    );

    if (ResponseUtils.isSuccessful(res)) {
      return null; // success
    }

    return res.message ?? 'Failed to reset password';
  }

  /// Change password for authenticated user
  Future<String?> changePassword(String currentPass, String newPassword) async {
    final res = await getResponse(
      authRepository.resetPassword(
        currentPass: currentPass,
        newPassword: newPassword,
      ),
    );

    if (ResponseUtils.isSuccessful(res)) {
      return null; // success
    }

    return res.message ?? 'Failed to change password';
  }

  // reusable function
  Future<ResponseStatusM> getResponse(Future<ResponseStatusM> repoCall,
      {bool shouldLoad = true}) async {
    if (shouldLoad) {
      _isLoading = true;
      notifyListeners();
    }

    try {
      return await repoCall;
    } catch (e) {
      print("General log: Error in AuthProvider - $e");
      rethrow;
    } finally {
      if (shouldLoad) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  void setIsLoadingToTrue() {
    _isLoading = true;
    notifyListeners();
  }

  void setIsLoadingToFalse() {
    _isLoading = false;
    notifyListeners();
  }

  String? _consultationPreference;
  String? get consultationPreference => _consultationPreference;

  /// Get consultation preference for authenticated user
  Future<String?> getConsultationPreference() async {
    final res = await getResponse(authRepository.getConsultationPreference());

    if (ResponseUtils.isSuccessful(res)) {
      if (res.data == null) return 'Invalid server response';

      _consultationPreference = res.data['preference'];
      notifyListeners();

      return null; // success
    }
    return res.message ?? 'Failed to fetch consultation preference';
  }

  /// Update consultation preference for authenticated user
  /// Allowed values"video_call", "voice_call", "in_person"
  Future<String?> updateConsultationPreference(String preference) async {
    final res = await getResponse(
        authRepository.updateConsultationPreference(preference));

    if (ResponseUtils.isSuccessful(res)) {
      _consultationPreference = preference;
      notifyListeners();

      return null; // success
    }
    return res.message ?? 'Failed to update consultation preference';
  }

  Map<String, dynamic>? _userSettings;
  Map<String, dynamic>? get userSettings => _userSettings;

  /// Get user notification settings
  Future<String?> getUserSettings() async {
    final res = await getResponse(authRepository.getUserSettings());

    if (ResponseUtils.isSuccessful(res)) {
      if (res.data == null) return 'Invalid server response';
      _userSettings = Map<String, dynamic>.from(res.data);
      notifyListeners();
      return null;
    }
    return res.message ?? 'Failed to fetch notification settings';
  }

  /// Update user notification settings
  Future<String?> updateUserSettings(Map<String, dynamic> settings) async {
    final res = await getResponse(authRepository.updateUserSettings(settings));

    if (ResponseUtils.isSuccessful(res)) {
      _userSettings = {...?_userSettings, ...settings};
      notifyListeners();
      return null;
    }
    return res.message ?? 'Failed to update notification settings';
  }

  /// Google Sign-In — returns null on success, error message on failure.
  /// Pass [role] only when signing up (e.g. 'donor', 'patient').
  Future<String?> googleSignIn({String? role}) async {
    try {
      final googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
      await googleSignIn.signOut(); // ensure fresh account picker
      final account = await googleSignIn.signIn();
      if (account == null) return 'Sign-in cancelled';

      final auth = await account.authentication;
      final idToken = auth.idToken;
      if (idToken == null) return 'Failed to get Google token';

      final res = await getResponse(
        authRepository.socialLogin(
          accessToken: idToken,
          provider: 'google',
          role: role,
        ),
      );

      if (ResponseUtils.isSuccessful(res)) {
        if (res.data == null) return 'Invalid server response';

        final authData = AuthDataModel.fromJson(res.data);
        token = authData.token;
        refreshToken = authData.refresh_token;
        userModel = authData.user;

        await SecureStorage.saveAuthData(authData);
        return null; // success
      }

      return res.message ?? 'Google sign-in failed';
    } catch (e) {
      return 'Google sign-in error: $e';
    }
  }

  /// Permanently delete the authenticated user's account
  Future<String?> deleteAccount() async {
    final res = await getResponse(authRepository.deleteAccount());

    if (ResponseUtils.isSuccessful(res)) {
      await SecureStorage.clearProfile();
      token = null;
      refreshToken = null;
      userModel = null;
      notifyListeners();
      return null; // success
    }
    return res.message ?? 'Failed to delete account';
  }

  /// Upload user profile image. Returns (imageUrl, error) - imageUrl is non-null on success.
  Future<(String?, String?)> uploadImage(String filePath) async {
    final res = await getResponse(authRepository.uploadImage(filePath));

    if (ResponseUtils.isSuccessful(res)) {
      final imageUrl = res.data as String?;
      return (imageUrl, null);
    }
    return (null, res.message ?? 'Failed to upload image');
  }
}

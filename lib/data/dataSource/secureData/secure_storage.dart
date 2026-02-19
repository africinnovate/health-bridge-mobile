import 'dart:convert';

import 'package:HealthBridge/core/di/injection.dart';
import 'package:HealthBridge/data/models/auth/auth_model.dart';

abstract class JsonSerializable {
  Map<String, dynamic> toJson();
}

class SecureStorage {
  static var _storage = Injection.secureStorage;

  // Keys
  static const _savedAuth = 'saved_accounts';
  static const _userProfilesKey = 'user_profiles';

  /// contains token and user data
  static Future<void> saveAuthData(AuthDataModel authData) async {
    final authJson = jsonEncode(authData.toJson());

    await _storage.write(key: _savedAuth, value: authJson);
  }

  /// Fetch stored token and user data
  static Future<AuthDataModel?> getAuthData() async {
    final value = await _storage.read(key: _savedAuth);

    if (value == null) return null;

    final Map<String, dynamic> jsonMap = jsonDecode(value);
    return AuthDataModel.fromJson(jsonMap);
  }

  /// Save any profile model (Patient, Specialist, etc.)
  static Future<void> saveProfile<T extends JsonSerializable>(
    T profile,
  ) async {
    final jsonString = jsonEncode(profile.toJson());

    await _storage.write(
      key: _userProfilesKey,
      value: jsonString,
    );
  }

  /// Fetch any profile model using a fromJson factory
  static Future<T?> getProfile<T>(
    T Function(Map<String, dynamic> json) fromJson,
  ) async {
    final value = await _storage.read(key: _userProfilesKey);

    if (value == null) return null;

    final Map<String, dynamic> jsonMap = jsonDecode(value);
    return fromJson(jsonMap);
  }

  /// delete / clear auth data and user profile
  static Future<void> clearProfile() async {
    await _storage.delete(key: _userProfilesKey);
    await _storage.delete(key: _savedAuth);
  }
}

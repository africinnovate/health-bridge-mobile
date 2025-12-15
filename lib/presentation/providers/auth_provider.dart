import 'dart:core';

import 'package:HealthBridge/data/models/auth_model.dart';
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
  String firstName = '';
  String lastName = '';
  String gender = '';
  String password = '';
  String phone = '';
  String role = '';

  // RegisterModel _registerModel;
  RegisterModel get registerModel => RegisterModel(
        email: email,
        password: password,
        role: role,
      );

  Future<ResponseStatusM> registerUser() async {
    // RegisterModel _registerModel = RegisterModel(
    //   email: email,
    //   password: password,
    //   role: role,
    // );
    return getResponse(authRepository.registerUser(registerModel));
  }

  resendOtp() {}

  verifyOtp({required String otp}) {}

  login() {}

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
}

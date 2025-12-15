import 'package:HealthBridge/data/dataSource/remoteApi/auth_api.dart';
import 'package:HealthBridge/data/models/response_status_m.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:HealthBridge/core/utils/response_utils.dart';
import '../models/auth_model.dart';

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

    // try {
    //   return await authApi.registerUser(registerModel);
    // } on SocketException {
    //   return ResponseStatusM(
    //       code: AppConstants.networkErrorCode,
    //       message: 'No network connection');
    // } on ClientException catch (e) {
    //   return ResponseStatusM(
    //       code: AppConstants.errorCode, message: 'Error: ${e.toString()}');
    // }
  }
}

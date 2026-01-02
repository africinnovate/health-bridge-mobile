import 'package:HealthBridge/core/constants/app_constants.dart';
import 'package:HealthBridge/core/utils/response_utils.dart';
import 'package:HealthBridge/data/models/auth_model.dart';
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
}

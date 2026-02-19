import 'package:HealthBridge/core/constants/app_constants.dart';
import 'package:HealthBridge/core/di/injection.dart';
import 'package:HealthBridge/core/utils/response_utils.dart';
import '../../../core/network/api_client.dart';
import '../../models/response_status_m.dart';

class HospitalApi {
  final ApiClient apiClient;

  HospitalApi({required this.apiClient});

  Future<ResponseStatusM> getHospitalProfile(String hospitalId) async {
    var header = await Injection.tokenHeaders();
    final response = await apiClient.get(
      '${AppConstants.hospitalProfileEP}/$hospitalId',
      headers: header,
    );

    return ResponseUtils.getApiResponse(response);
  }

  /// Get Hospital notifications setting
  Future<ResponseStatusM> getHospitalNotification(String hospitalId) async {
    var header = await Injection.tokenHeaders();
    final response = await apiClient.get(
      '${AppConstants.hospitalNotificationSettingEP}/$hospitalId',
      headers: header,
    );

    return ResponseUtils.getApiResponse(response);
  }

  /// Update Hospital notifications setting
  Future<ResponseStatusM> updateHospitalNotification(
      Map<String, dynamic> payload, String hospitalId) async {
    var header = await Injection.tokenHeaders();
    final response = await apiClient.patch(
      '${AppConstants.hospitalNotificationSettingEP}/$hospitalId',
      data: payload,
      headers: header,
    );

    return ResponseUtils.getApiResponse(response);
  }

  /// set up hospital profile
  /// Uses POST for creation, PUT for editing
  Future<ResponseStatusM> createHospital(Map<String, dynamic> payload,
      {String? hospitalId}) async {
    var header = await Injection.tokenHeaders();

    // If hospitalId is provided, this is an edit operation
    if (hospitalId != null) {
      final response = await apiClient.put(
        '/api/hospitals/update/$hospitalId',
        data: payload,
        headers: header,
      );
      return ResponseUtils.getApiResponse(response);
    }

    // Otherwise, this is a create operation
    final response = await apiClient.post(
      AppConstants.createHospitalEP,
      data: payload,
      headers: header,
    );

    return ResponseUtils.getApiResponse(response);
  }

  /// Upload hospital accreditation document
  Future<ResponseStatusM> uploadAccreditationDoc(
      String filePath, String hospitalId) async {
    var header = await Injection.tokenHeaders();
    final response = await apiClient.uploadFile(
      '/api/hospitals/upload-accreditation/$hospitalId',
      filePath: filePath,
      fieldName: 'file',
      headers: header,
    );

    return ResponseUtils.getApiResponse(response);
  }

  /// Get blood requests for hospital
  Future<ResponseStatusM> getBloodRequests({String? status}) async {
    var header = await Injection.tokenHeaders();
    final queryParams = status != null ? {'request_status': status} : <String, String>{};

    final response = await apiClient.get(
      '/api/hospitals/blood-request',
      query: queryParams,
      headers: header,
    );

    return ResponseUtils.getApiResponse(response);
  }
}

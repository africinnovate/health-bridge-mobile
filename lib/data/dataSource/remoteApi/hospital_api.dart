import 'package:HealthBridge/core/constants/app_constants.dart';
import 'package:HealthBridge/core/di/injection.dart';
import 'package:HealthBridge/core/utils/response_utils.dart';
import '../../../core/network/api_client.dart';
import '../../models/response_status_m.dart';

class HospitalApi {
  final ApiClient apiClient;

  HospitalApi({required this.apiClient});

  /// Get all hospitals
  Future<ResponseStatusM> getAllHospitals() async {
    var header = await Injection.tokenHeaders();
    final response = await apiClient.get(
      AppConstants.allHospitalsEP,
      headers: header,
    );

    return ResponseUtils.getApiResponse(response);
  }

  /// Get nearby hospitals
  Future<ResponseStatusM> getNearbyHospitals() async {
    var header = await Injection.tokenHeaders();
    final response = await apiClient.get(
      AppConstants.nearbyHospitalsEP,
      headers: header,
    );

    return ResponseUtils.getApiResponse(response,
        endpoint: "GET - ${AppConstants.nearbyHospitalsEP}");
  }

  /// Get my hospital profile
  Future<ResponseStatusM> getHospitalProfile() async {
    var header = await Injection.tokenHeaders();
    final response = await apiClient.get(
      AppConstants.hospitalProfileEP,
      headers: header,
    );

    return ResponseUtils.getApiResponse(response,
        endpoint: "GET - ${AppConstants.hospitalProfileEP}");
  }

  Future<ResponseStatusM> getHospitalProfileById(String hospitalId) async {
    var header = await Injection.tokenHeaders();
    final response = await apiClient.get(
      '${AppConstants.hospitalProfileByIdEP}/$hospitalId',
      headers: header,
    );

    return ResponseUtils.getApiResponse(response,
        endpoint: "GET - ${AppConstants.hospitalProfileByIdEP}/$hospitalId");
  }

  /// Get Hospital notifications setting
  Future<ResponseStatusM> getHospitalNotification(String hospitalId) async {
    var header = await Injection.tokenHeaders();
    final response = await apiClient.get(
      '${AppConstants.hospitalNotificationSettingEP}/$hospitalId',
      headers: header,
    );

    return ResponseUtils.getApiResponse(response,
        endpoint:
            "GET - ${AppConstants.hospitalNotificationSettingEP}/$hospitalId");
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

    return ResponseUtils.getApiResponse(response,
        endpoint:
            "PATCH - ${AppConstants.hospitalNotificationSettingEP}/$hospitalId");
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

    return ResponseUtils.getApiResponse(response,
        endpoint: "POST - ${AppConstants.createHospitalEP}");
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

    return ResponseUtils.getApiResponse(response,
        endpoint: "POST - /api/hospitals/upload-accreditation/$hospitalId");
  }

  /// Upload hospital profile image
  Future<ResponseStatusM> uploadHospitalImage(
      String filePath, String hospitalId) async {
    var header = await Injection.tokenHeaders();
    final response = await apiClient.uploadFile(
      '${AppConstants.uploadHospitalImageEP}/$hospitalId',
      filePath: filePath,
      fieldName: 'image',
      headers: header,
    );

    return ResponseUtils.getApiResponse(response);
  }

  /// Get blood requests for hospital
  /// Status -   confirmed, accepted, completed, cancelled
  Future<ResponseStatusM> getBloodRequests({String? status}) async {
    var header = await Injection.tokenHeaders();
    final queryParams =
        status != null ? {'request_status': status} : <String, String>{};

    final response = await apiClient.get(
      AppConstants.bloodRequestEP,
      query: queryParams,
      headers: header,
    );

    return ResponseUtils.getApiResponse(response,
        endpoint: "GET - ${AppConstants.bloodRequestEP} \nquery: $queryParams");
  }

  /// Create a new blood request
  Future<ResponseStatusM> createBloodRequest(
      Map<String, dynamic> payload) async {
    var header = await Injection.tokenHeaders();
    final response = await apiClient.post(
      AppConstants.bloodRequestEP,
      data: payload,
      headers: header,
    );

    return ResponseUtils.getApiResponse(response,
        endpoint: "POST - ${AppConstants.bloodRequestEP}");
  }

  /// Update blood inventory units
  Future<ResponseStatusM> updateBloodInventory(
      String hospitalId, String bloodType, Map<String, dynamic> payload) async {
    var header = await Injection.tokenHeaders();
    final response = await apiClient.patch(
      '${AppConstants.updateBloodInventoryEP}/$hospitalId/$bloodType',
      data: payload,
      headers: header,
    );

    return ResponseUtils.getApiResponse(response,
        endpoint:
            "PATCH - ${AppConstants.updateBloodInventoryEP}/$hospitalId/$bloodType");
  }

  /// Update blood request ("confirmed""accepted""completed""cancelled" etc.)
  Future<ResponseStatusM> updateBloodRequest(
      String bloodRequestId, Map<String, dynamic> payload) async {
    var header = await Injection.tokenHeaders();
    final response = await apiClient.put(
      '${AppConstants.bloodRequestEP}/$bloodRequestId',
      data: payload,
      headers: header,
    );

    return ResponseUtils.getApiResponse(response,
        endpoint: "PUT - ${AppConstants.bloodRequestEP}/$bloodRequestId");
  }

  /// Get hospital dashboard stats
  Future<ResponseStatusM> getHospitalDashboardStats() async {
    var header = await Injection.tokenHeaders();
    final response = await apiClient.get(
      AppConstants.hospitalDashboardStatsEP,
      headers: header,
    );

    return ResponseUtils.getApiResponse(response,
        endpoint: "GET - ${AppConstants.hospitalDashboardStatsEP}");
  }

  /// Get hospital recent activity
  Future<ResponseStatusM> getHospitalRecentActivity() async {
    var header = await Injection.tokenHeaders();
    final response = await apiClient.get(
      AppConstants.hospitalRecentActivityEP,
      headers: header,
    );

    return ResponseUtils.getApiResponse(response,
        endpoint: "GET - ${AppConstants.hospitalRecentActivityEP}");
  }

  /// Get donor list
  Future<ResponseStatusM> getDonorList({
    bool? eligibleToDonate,
    String? bloodType,
  }) async {
    var header = await Injection.tokenHeaders();

    Map<String, String> queryParams = {};
    if (eligibleToDonate != null) {
      queryParams['eligible_to_donate'] = eligibleToDonate.toString();
    }
    if (bloodType != null && bloodType.isNotEmpty) {
      queryParams['blood_type'] = bloodType;
    }

    final response = await apiClient.get(
      AppConstants.hospitalDonorsEP,
      query: queryParams,
      headers: header,
    );

    return ResponseUtils.getApiResponse(response,
        endpoint:
            "GET - ${AppConstants.hospitalDonorsEP} \nquery: $queryParams");
  }

  /// Get donor stats
  Future<ResponseStatusM> getDonorStats(String donorId) async {
    var header = await Injection.tokenHeaders();
    final response = await apiClient.get(
      '${AppConstants.donorStatsEP}/$donorId',
      headers: header,
    );

    return ResponseUtils.getApiResponse(response,
        endpoint: "GET - ${AppConstants.donorStatsEP}/$donorId");
  }

  /// Get donor donation history
  Future<ResponseStatusM> getDonorHistory(String donorId) async {
    var header = await Injection.tokenHeaders();
    final response = await apiClient.get(
      '${AppConstants.donorHistoryEP}/$donorId',
      headers: header,
    );

    return ResponseUtils.getApiResponse(response,
        endpoint: "GET - ${AppConstants.donorHistoryEP}/$donorId");
  }

  /// Update donor notes and eligibility
  Future<ResponseStatusM> updateDonor(
      String donorId, Map<String, dynamic> payload) async {
    var header = await Injection.tokenHeaders();
    final response = await apiClient.patch(
      '${AppConstants.updateDonorEP}/$donorId',
      data: payload,
      headers: header,
    );

    return ResponseUtils.getApiResponse(response,
        endpoint: "PATCH - ${AppConstants.updateDonorEP}/$donorId");
  }

  /// add endpoint to get all hospital
}

/*  ============== original blood request response
{
  "status_code": 201,
  "message": "Blood requests retrieved successfully",
  "data": [
    {
      "blood_request": {
        "id": "78c24bce-ca8d-4cb6-b2e5-d3bf8c7e0596",
        ...
        "created_at": "2026-02-02T22:30:45.483453Z"
      },
      "donor": {
        "id": "893d86e2-39f6-4182-81ff-1376d7b4d70c",
        "first_name": "Mary",
        ...
      }
    }
  ]
}
*/

/* =========== doc blood request response
{
  "data": [
    {
      "administered_at": "2026-02-19T16:28:23.511Z",
      ...
      "urgency": null
    }
  ],
  "message": "string",
  "status_code": 1073741824
}
 */

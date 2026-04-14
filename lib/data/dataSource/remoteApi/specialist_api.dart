import 'package:HealthBridge/core/constants/app_constants.dart';
import 'package:HealthBridge/core/di/injection.dart';
import 'package:HealthBridge/core/utils/response_utils.dart';
import 'package:HealthBridge/data/models/patient/patient_profile_model.dart';
import '../../../core/network/api_client.dart';
import '../../models/response_status_m.dart';

class SpecialistApi {
  final ApiClient apiClient;

  SpecialistApi({required this.apiClient});

  /// GET /api/specialists/patients/{id}
  Future<ResponseStatusM> getPatientProfileForSpecialist(String patientId) async {
    var header = await Injection.tokenHeaders();
    final response = await apiClient.get(
      '${AppConstants.specialistPatientProfileEP}/$patientId',
      headers: header,
    );
    return ResponseUtils.getApiResponse(response,
        endpoint: "GET - ${AppConstants.specialistPatientProfileEP}/$patientId");
  }

  Future<ResponseStatusM> getSpecialistProfile(String specialistId) async {
    var header = await Injection.tokenHeaders();
    final response = await apiClient.get(
      '${AppConstants.specialistProfileEP}/$specialistId',
      headers: header,
    );

    return ResponseUtils.getApiResponse(response);
  }

  Future<ResponseStatusM> getSpecialties() async {
    var header = await Injection.tokenHeaders();
    final response = await apiClient.get(
      AppConstants.specialtiesEP,
      headers: header,
    );

    return ResponseUtils.getApiResponse(response);
  }

  Future<ResponseStatusM> addSpecialty({
    required String name,
    required String description,
  }) async {
    var header = await Injection.tokenHeaders();
    final body = {
      "name": name,
      "description": description,
    };

    final response = await apiClient.post(
      AppConstants.specialtiesEP,
      data: body,
      headers: header,
    );

    return ResponseUtils.getApiResponse(response);
  }

  Future<ResponseStatusM> createProfile({
    required String bio,
    required String consultationType,
    required String languagesSpoken,
    required int yearsOfExperience,
    required int sessionDurationMinutes,
    required String specialtyId,
    required String primaryPhone,
    String? secondaryPhone,
    required String country,
    required String timeZone,
    required List<Map<String, dynamic>> availabilities,
  }) async {
    var header = await Injection.tokenHeaders();
    final body = {
      "bio": bio,
      "consultation_type": consultationType,
      "languages_spoken": languagesSpoken,
      "years_of_experience": yearsOfExperience,
      "session_duration_minutes": sessionDurationMinutes,
      "specialty_id": specialtyId,
      "primary_phone": primaryPhone,
      "secondary_phone": secondaryPhone ?? "",
      "country": country,
      "time_zone": timeZone,
      "availabilities": availabilities,
    };

    final response = await apiClient.post(
      AppConstants.specialistProfileEP,
      data: body,
      headers: header,
    );

    return ResponseUtils.getApiResponse(response);
  }

  Future<ResponseStatusM> getSpecialists({
    bool? verified,
    bool? suspended,
    String? specialtyId,
  }) async {
    var header = await Injection.tokenHeaders();

    // Build query parameters
    final queryParams = <String, String>{};
    if (verified != null) queryParams['verified'] = verified.toString();
    if (suspended != null) queryParams['suspended'] = suspended.toString();
    if (specialtyId != null) queryParams['specialty_id'] = specialtyId;

    final response = await apiClient.get(
      AppConstants.specialistProfileEP,
      headers: header,
      query: queryParams,
    );

    return ResponseUtils.getApiResponse(response);
  }

  Future<ResponseStatusM> updateSpecialistProfile({
    required String specialistId,
    List<Map<String, dynamic>>? availabilities,
    String? firstName,
    String? lastName,
    String? bio,
    String? consultationType,
    String? country,
    String? languagesSpoken,
    String? licenseUrl,
    String? primaryPhone,
    String? secondaryPhone,
    int? sessionDurationMinutes,
    bool? suspended,
    String? timeZone,
    int? yearsOfExperience,
    String? address,
    String? city,
    String? state,
  }) async {
    var header = await Injection.tokenHeaders();
    final body = <String, dynamic>{};

    // Add availabilities if provided
    if (availabilities != null) {
      body['availabilities'] = availabilities;
    }

    // Build specialist object with only provided fields
    final specialist = <String, dynamic>{};
    if (firstName != null) specialist['first_name'] = firstName;
    if (lastName != null) specialist['last_name'] = lastName;
    if (address != null) specialist['address'] = address;
    if (city != null) specialist['city'] = city;
    if (state != null) specialist['state'] = state;
    if (bio != null) specialist['bio'] = bio;
    if (consultationType != null)
      specialist['consultation_type'] = consultationType;
    if (country != null) specialist['country'] = country;
    if (languagesSpoken != null)
      specialist['languages_spoken'] = languagesSpoken;
    if (licenseUrl != null) specialist['license_url'] = licenseUrl;
    if (primaryPhone != null) specialist['primary_phone'] = primaryPhone;
    if (secondaryPhone != null) specialist['secondary_phone'] = secondaryPhone;
    if (sessionDurationMinutes != null)
      specialist['session_duration_minutes'] = sessionDurationMinutes;
    if (suspended != null) specialist['suspended'] = suspended;
    if (timeZone != null) specialist['time_zone'] = timeZone;
    if (yearsOfExperience != null)
      specialist['years_of_experience'] = yearsOfExperience;

    // Only add specialist object if it has fields
    if (specialist.isNotEmpty) {
      body['specialist'] = specialist;
    }

    final response = await apiClient.put(
      '${AppConstants.specialistProfileEP}/$specialistId',
      data: body,
      headers: header,
    );

    return ResponseUtils.getApiResponse(response);
  }
}

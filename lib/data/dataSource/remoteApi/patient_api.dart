import 'package:HealthBridge/core/constants/app_constants.dart';
import 'package:HealthBridge/core/di/injection.dart';
import 'package:HealthBridge/core/utils/response_utils.dart';
import '../../../core/network/api_client.dart';
import '../../models/response_status_m.dart';

class PatientApi {
  final ApiClient apiClient;

  PatientApi({required this.apiClient});

  Future<ResponseStatusM> getPatientProfile() async {
    var header = await Injection.tokenHeaders();
    final response = await apiClient.get(
      AppConstants.patientProfileEP,
      headers: header,
    );

    return ResponseUtils.getApiResponse(response);
  }

  Future<ResponseStatusM> updateMedicalInfo({
    required String allergies,
    required String bloodType,
    required String chronicIllnesses,
    required String emergencyContactName,
    required String emergencyContactPhone,
    required String hmoNumber,
    String? existingConditions,
    String? medications,
    String? primaryPhysician,
    String? medicalNotes,
  }) async {
    var header = await Injection.tokenHeaders();
    final body = {
      "allergies": allergies,
      "blood_type": bloodType,
      "chronic_illnesses": chronicIllnesses,
      "emergency_contact_name": emergencyContactName,
      "emergency_contact_phone": emergencyContactPhone,
      "existing_conditions": existingConditions,
      "hmo_number": hmoNumber,
      "medications": medications,
      "primary_physician": primaryPhysician,
      "medical_notes": medicalNotes,
    };

    final response = await apiClient.put(
      AppConstants.patientMedicalInfoEP,
      headers: header,
      data: body,
    );

    return ResponseUtils.getApiResponse(response);
  }

  Future<ResponseStatusM> updateProfile({
    String? imageUrl,
    String? address,
    String? dob,
    String? firstName,
    String? lastName,
    String? gender,
    String? phone,
  }) async {
    var header = await Injection.tokenHeaders();
    print("General log: header is $header");
    final body = {
      "imageUrl": imageUrl ?? "",
      "address": address ?? "",
      "dob": dob ?? "",
      "first_name": firstName ?? "",
      "last_name": lastName ?? "",
      "gender": gender,
      "phone": phone ?? "",
    };

    final response = await apiClient.put(
      AppConstants.patientProfileEP,
      headers: header,
      data: body,
    );

    return ResponseUtils.getApiResponse(response);
  }
}

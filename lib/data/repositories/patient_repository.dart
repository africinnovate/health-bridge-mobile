import 'package:HealthBridge/data/models/response_status_m.dart';
import 'package:HealthBridge/core/utils/response_utils.dart';
import '../dataSource/remoteApi/patient_api.dart';

class PatientRepository {
  final PatientApi patientApi;

  PatientRepository({
    required this.patientApi,
  });

  Future<ResponseStatusM> getPatientProfile() async {
    try {
      return await patientApi.getPatientProfile();
    } catch (e) {
      return ResponseUtils.checkError(e);
    }
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
    try {
      return await patientApi.updateMedicalInfo(
        allergies: allergies,
        bloodType: bloodType,
        chronicIllnesses: chronicIllnesses,
        emergencyContactName: emergencyContactName,
        emergencyContactPhone: emergencyContactPhone,
        hmoNumber: hmoNumber,
        existingConditions: existingConditions,
        medications: medications,
        primaryPhysician: primaryPhysician,
        medicalNotes: medicalNotes,
      );
    } catch (e) {
      return ResponseUtils.checkError(e);
    }
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
    try {
      return await patientApi.updateProfile(
        imageUrl: imageUrl,
        address: address,
        dob: dob,
        firstName: firstName,
        lastName: lastName,
        gender: gender,
        phone: phone,
      );
    } catch (e) {
      return ResponseUtils.checkError(e);
    }
  }
}

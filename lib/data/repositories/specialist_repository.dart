import 'package:HealthBridge/data/dataSource/remoteApi/specialist_api.dart';
import 'package:HealthBridge/data/models/response_status_m.dart';
import 'package:HealthBridge/core/utils/response_utils.dart';

class SpecialistRepository {
  final SpecialistApi specialistApi;

  SpecialistRepository({
    required this.specialistApi,
  });

  Future<ResponseStatusM> getSpecialistProfile(String specialistId) async {
    try {
      return await specialistApi.getSpecialistProfile(specialistId);
    } catch (e) {
      return ResponseUtils.checkError(e);
    }
  }

  Future<ResponseStatusM> getPatientProfileForSpecialist(String patientId) async {
    try {
      return await specialistApi.getPatientProfileForSpecialist(patientId);
    } catch (e) {
      return ResponseUtils.checkError(e);
    }
  }

  Future<ResponseStatusM> getSpecialties() async {
    try {
      return await specialistApi.getSpecialties();
    } catch (e) {
      return ResponseUtils.checkError(e);
    }
  }

  Future<ResponseStatusM> addSpecialty({
    required String name,
    required String description,
  }) async {
    try {
      return await specialistApi.addSpecialty(
        name: name,
        description: description,
      );
    } catch (e) {
      return ResponseUtils.checkError(e);
    }
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
    try {
      return await specialistApi.createProfile(
        bio: bio,
        consultationType: consultationType,
        languagesSpoken: languagesSpoken,
        yearsOfExperience: yearsOfExperience,
        sessionDurationMinutes: sessionDurationMinutes,
        specialtyId: specialtyId,
        primaryPhone: primaryPhone,
        secondaryPhone: secondaryPhone,
        country: country,
        timeZone: timeZone,
        availabilities: availabilities,
      );
    } catch (e) {
      return ResponseUtils.checkError(e);
    }
  }

  Future<ResponseStatusM> getSpecialists({
    bool? verified,
    bool? suspended,
    String? specialtyId,
  }) async {
    try {
      return await specialistApi.getSpecialists(
        verified: verified,
        suspended: suspended,
        specialtyId: specialtyId,
      );
    } catch (e) {
      return ResponseUtils.checkError(e);
    }
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
    try {
      return await specialistApi.updateSpecialistProfile(
        specialistId: specialistId,
        availabilities: availabilities,
        firstName: firstName,
        lastName: lastName,
        bio: bio,
        consultationType: consultationType,
        country: country,
        languagesSpoken: languagesSpoken,
        licenseUrl: licenseUrl,
        primaryPhone: primaryPhone,
        secondaryPhone: secondaryPhone,
        sessionDurationMinutes: sessionDurationMinutes,
        suspended: suspended,
        timeZone: timeZone,
        yearsOfExperience: yearsOfExperience,
        address: address,
        city: city,
        state: state,
      );
    } catch (e) {
      return ResponseUtils.checkError(e);
    }
  }
}

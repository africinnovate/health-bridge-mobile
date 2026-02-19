import 'package:HealthBridge/data/dataSource/remoteApi/hospital_api.dart';
import 'package:HealthBridge/data/models/response_status_m.dart';
import 'package:HealthBridge/core/utils/response_utils.dart';

class HospitalRepository {
  final HospitalApi hospitalApi;

  HospitalRepository({
    required this.hospitalApi,
  });

  Future<ResponseStatusM> getSpecialistProfile(String hospitalId) async {
    try {
      return await hospitalApi.getHospitalProfile(hospitalId);
    } catch (e) {
      return ResponseUtils.checkError(e);
    }
  }

  /// set up hospital profile or update existing profile
  Future<ResponseStatusM> createHospital(Map<String, dynamic> payload,
      {String? hospitalId}) async {
    try {
      return await hospitalApi.createHospital(payload, hospitalId: hospitalId);
    } catch (e) {
      return ResponseUtils.checkError(e);
    }
  }

  /// Get Hospital notifications setting
  Future<ResponseStatusM> getHospitalNotification(String hospitalId) async {
    try {
      return await hospitalApi.getHospitalNotification(hospitalId);
    } catch (e) {
      return ResponseUtils.checkError(e);
    }
  }

  /// Update Hospital notifications setting
  Future<ResponseStatusM> updateHospitalNotification(
      Map<String, dynamic> payload, String hospitalId) async {
    try {
      return await hospitalApi.updateHospitalNotification(payload, hospitalId);
    } catch (e) {
      return ResponseUtils.checkError(e);
    }
  }

  /// Upload hospital accreditation document
  Future<ResponseStatusM> uploadAccreditationDoc(
      String filePath, String hospitalId) async {
    try {
      return await hospitalApi.uploadAccreditationDoc(filePath, hospitalId);
    } catch (e) {
      return ResponseUtils.checkError(e);
    }
  }

  /// Get blood requests for hospital
  Future<ResponseStatusM> getBloodRequests({String? status}) async {
    try {
      return await hospitalApi.getBloodRequests(status: status);
    } catch (e) {
      return ResponseUtils.checkError(e);
    }
  }
}

import 'package:HealthBridge/data/dataSource/remoteApi/hospital_api.dart';
import 'package:HealthBridge/data/models/response_status_m.dart';
import 'package:HealthBridge/core/utils/response_utils.dart';

class HospitalRepository {
  final HospitalApi hospitalApi;

  HospitalRepository({
    required this.hospitalApi,
  });

  Future<ResponseStatusM> getHospitalProfile() async {
    try {
      return await hospitalApi.getHospitalProfile();
    } catch (e) {
      return ResponseUtils.checkError(e);
    }
  }

  Future<ResponseStatusM> getHospitalProfileById(String hospitalId) async {
    try {
      return await hospitalApi.getHospitalProfileById(hospitalId);
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

  /// Create a new blood request
  Future<ResponseStatusM> createBloodRequest(
      Map<String, dynamic> payload) async {
    try {
      return await hospitalApi.createBloodRequest(payload);
    } catch (e) {
      return ResponseUtils.checkError(e);
    }
  }

  /// Update blood inventory units
  Future<ResponseStatusM> updateBloodInventory(
      String hospitalId, String bloodType, Map<String, dynamic> payload) async {
    try {
      return await hospitalApi.updateBloodInventory(hospitalId, bloodType, payload);
    } catch (e) {
      return ResponseUtils.checkError(e);
    }
  }

  /// Update blood request (cancel, complete, etc.)
  Future<ResponseStatusM> updateBloodRequest(
      String bloodRequestId, Map<String, dynamic> payload) async {
    try {
      return await hospitalApi.updateBloodRequest(bloodRequestId, payload);
    } catch (e) {
      return ResponseUtils.checkError(e);
    }
  }

  /// Get hospital dashboard stats
  Future<ResponseStatusM> getHospitalDashboardStats() async {
    try {
      return await hospitalApi.getHospitalDashboardStats();
    } catch (e) {
      return ResponseUtils.checkError(e);
    }
  }

  /// Get hospital recent activity
  Future<ResponseStatusM> getHospitalRecentActivity() async {
    try {
      return await hospitalApi.getHospitalRecentActivity();
    } catch (e) {
      return ResponseUtils.checkError(e);
    }
  }

  /// Get donor list
  Future<ResponseStatusM> getDonorList({
    bool? eligibleToDonate,
    String? bloodType,
  }) async {
    try {
      return await hospitalApi.getDonorList(
        eligibleToDonate: eligibleToDonate,
        bloodType: bloodType,
      );
    } catch (e) {
      return ResponseUtils.checkError(e);
    }
  }

  /// Get donor stats
  Future<ResponseStatusM> getDonorStats(String donorId) async {
    try {
      return await hospitalApi.getDonorStats(donorId);
    } catch (e) {
      return ResponseUtils.checkError(e);
    }
  }

  /// Get donor donation history
  Future<ResponseStatusM> getDonorHistory(String donorId) async {
    try {
      return await hospitalApi.getDonorHistory(donorId);
    } catch (e) {
      return ResponseUtils.checkError(e);
    }
  }

  /// Update donor notes and eligibility
  Future<ResponseStatusM> updateDonor(
      String donorId, Map<String, dynamic> payload) async {
    try {
      return await hospitalApi.updateDonor(donorId, payload);
    } catch (e) {
      return ResponseUtils.checkError(e);
    }
  }
}

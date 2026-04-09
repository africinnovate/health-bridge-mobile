import 'dart:core';

import 'package:HealthBridge/core/constants/app_constants.dart';
import 'package:HealthBridge/core/utils/response_utils.dart';
import 'package:HealthBridge/data/dataSource/secureData/secure_storage.dart';
import 'package:HealthBridge/data/models/auth/auth_model.dart';
import 'package:HealthBridge/data/models/patient/patient_profile_model.dart';
import 'package:HealthBridge/data/models/response_status_m.dart';
import 'package:flutter/cupertino.dart';

import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/patient_repository.dart';

class PatientProvider extends ChangeNotifier {
  final PatientRepository patientRepository;

  PatientProvider({
    required this.patientRepository,
  });

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  PatientProfileModel? patientProfileM;

  /// get patient profile
  Future<String?> getPatientOrDonorProfile() async {
    // get from secure storage first
    patientProfileM = await SecureStorage.getProfile<PatientProfileModel>(
        (json) => PatientProfileModel.fromJson(json));
    notifyListeners();
    print("General log: patient Or donor is ${patientProfileM}");

    // fetch from api and update
    final res = await getResponse(patientRepository.getPatientProfile());

    if (ResponseUtils.isSuccessful(res)) {
      if (res.data == null) return 'Invalid server response';

      final profile = PatientProfileModel.fromJson(res.data);
      // return unverified so user can be navigated to email verification screen
      if (!profile.emailVerified) return AppConstants.emailUnverified;

      // save to secure storage (typed)
      await SecureStorage.saveProfile<PatientProfileModel>(profile);

      patientProfileM = profile;
      notifyListeners();

      return null; // success
    }

    return res.message ?? 'Failed to fetch patient profile';
  }

  // update patient medical info - ronokinno@gmail.com

  Future<String?> updateMedicalInfo({
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
    final res = await getResponse(
      patientRepository.updateMedicalInfo(
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
      ),
    );

    if (ResponseUtils.isSuccessful(res)) {
      // Refresh profile after successful update
      await getPatientOrDonorProfile();
      return null; // success
    }

    return res.message ?? 'Failed to update medical information';
  }

  Future<String?> updateProfile({
    String? imageUrl,
    String? address,
    String? city,
    String? state,
    String? dob,
    String? firstName,
    String? lastName,
    String? gender,
    String? phone,
  }) async {
    final res = await getResponse(
      patientRepository.updateProfile(
        imageUrl: imageUrl,
        address: address,
        city: city,
        state: state,
        dob: dob,
        firstName: firstName,
        lastName: lastName,
        gender: gender,
        phone: phone,
      ),
    );

    if (ResponseUtils.isSuccessful(res)) {
      // Refresh profile after successful update
      await getPatientOrDonorProfile();
      return null; // success
    }

    return res.message ?? 'Failed to update profile';
  }

  // reusable function
  Future<ResponseStatusM> getResponse(Future<ResponseStatusM> repoCall,
      {bool shouldLoad = true}) async {
    if (shouldLoad) {
      _isLoading = true;
      notifyListeners();
    }

    try {
      return await repoCall;
    } catch (e) {
      print("General log: Error in AuthProvider - $e");
      rethrow;
    } finally {
      if (shouldLoad) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  void setIsLoadingToTrue() {
    _isLoading = true;
    notifyListeners();
  }

  void setIsLoadingToFalse() {
    _isLoading = false;
    notifyListeners();
  }
}

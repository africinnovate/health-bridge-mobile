import 'dart:core';

import 'package:HealthBridge/core/constants/app_constants.dart';
import 'package:HealthBridge/core/di/injection.dart';
import 'package:HealthBridge/core/utils/response_utils.dart';
import 'package:HealthBridge/data/dataSource/secureData/secure_storage.dart';
import 'package:HealthBridge/data/models/auth/auth_model.dart';
import 'package:HealthBridge/data/models/patient/patient_profile_model.dart';
import 'package:HealthBridge/data/models/response_status_m.dart';
import 'package:HealthBridge/data/models/specialist/specialist_profile_model.dart';
import 'package:HealthBridge/data/models/specialist/specialty_model.dart';
import 'package:HealthBridge/data/repositories/specialist_repository.dart';
import 'package:flutter/cupertino.dart';

import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/patient_repository.dart';

class SpecialistProvider extends ChangeNotifier {
  final SpecialistRepository specialistRepository;

  SpecialistProvider({
    required this.specialistRepository,
  });

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  SpecialistProfileModel? specialistProfileM;
  List<SpecialtyModel> specialties = [];
  List<SpecialistProfileModel> specialists = [];

  // Temporary fields for profile creation flow
  String? tempBio;
  String? tempConsultationType;
  String? tempLanguagesSpoken;
  int? tempYearsOfExperience;
  String? tempSpecialtyId;
  String? tempPrimaryPhone;
  String? tempSecondaryPhone;
  String? tempCountry;

  //* update patient medical info - ronokinno@gmail.com

  /// get patient profile
  Future<String?> getSpecialistProfile() async {
    // get from secure storage first
    specialistProfileM = await SecureStorage.getProfile<SpecialistProfileModel>(
        (json) => SpecialistProfileModel.fromJson(json));
    notifyListeners();

    // fetch from api and update
    var id = specialistProfileM?.userId;

    if (id == null) {
      // call auth storage to get userModel data
      var authData = await SecureStorage.getAuthData();
      if (authData == null)
        return AppConstants.login;
      else
        id = authData.user.id;
      // print("General log: id id $id");
    }
    final res =
        await getResponse(specialistRepository.getSpecialistProfile(id));

    if (ResponseUtils.isSuccessful(res)) {
      if (res.data == null) return 'Invalid server response';

      final profile = SpecialistProfileModel.fromJson(res.data);
      if (!profile.emailVerified) return AppConstants.emailUnverified;

      // save to secure storage (typed)
      await SecureStorage.saveProfile<SpecialistProfileModel>(profile);

      specialistProfileM = profile;
      notifyListeners();

      return null; // success
    }

    return res.message ?? 'Failed to fetch patient profile';
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

  /// Get list of specialties
  Future<String?> getSpecialties() async {
    final res = await getResponse(specialistRepository.getSpecialties(),
        shouldLoad: false);

    if (ResponseUtils.isSuccessful(res)) {
      if (res.data == null) return 'Invalid server response';

      specialties = (res.data as List<dynamic>)
          .map((e) => SpecialtyModel.fromJson(e))
          .toList();
      notifyListeners();

      return null; // success
    }

    return res.message ?? 'Failed to fetch specialties';
  }

  /// Add a new specialty
  Future<String?> addSpecialty({
    required String name,
    required String description,
  }) async {
    final res = await getResponse(
      specialistRepository.addSpecialty(
        name: name,
        description: description,
      ),
    );

    if (ResponseUtils.isSuccessful(res)) {
      // Refresh specialties list after adding
      await getSpecialties();
      return null; // success
    }

    return res.message ?? 'Failed to add specialty';
  }

  /// Create specialist profile
  Future<String?> createProfile({
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
    final res = await getResponse(specialistRepository.createProfile(
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
    ));

    if (ResponseUtils.isSuccessful(res)) {
      if (res.data == null) return 'Invalid server response';
      print("General log: specialist profile created: ${res.data}");

      final profile = SpecialistProfileModel.fromJson(res.data);

      // save to secure storage (typed)
      await SecureStorage.saveProfile<SpecialistProfileModel>(profile);

      specialistProfileM = profile;
      notifyListeners();

      return null; // success
    }

    return res.message ?? 'Failed to create specialist profile';
  }

  /// Get list of specialists with optional filters
  Future<String?> getSpecialists({
    bool? verified,
    bool? suspended,
    String? specialtyId,
  }) async {
    final res = await getResponse(
      specialistRepository.getSpecialists(
        verified: verified,
        suspended: suspended,
        specialtyId: specialtyId,
      ),
      shouldLoad: false,
    );

    if (ResponseUtils.isSuccessful(res)) {
      if (res.data == null) return 'Invalid server response';

      specialists = (res.data as List<dynamic>)
          .map((e) => SpecialistProfileModel.fromJson(e))
          .toList();
      notifyListeners();
      debugPrint("General log: the specialist size is: ${specialists.length}");
      return null; // success
    }

    return res.message ?? 'Failed to fetch specialists';
  }

  /// Update specialist profile (partial update)
  Future<String?> updateSpecialistProfile({
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
    if (specialistProfileM == null) {
      return 'No specialist profile found';
    }

    final res = await getResponse(
      specialistRepository.updateSpecialistProfile(
        specialistId: specialistProfileM!.id,
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
      ),
    );

    if (ResponseUtils.isSuccessful(res)) {
      if (res.data == null) return 'Invalid server response';

      final profile = SpecialistProfileModel.fromJson(res.data);

      // save to secure storage (typed)
      await SecureStorage.saveProfile<SpecialistProfileModel>(profile);

      specialistProfileM = profile;
      notifyListeners();

      return null; // success
    }

    return res.message ?? 'Failed to update specialist profile';
  }
}

import 'package:HealthBridge/data/models/hospital/hospital_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:HealthBridge/data/repositories/hospital_repository.dart';
import 'package:HealthBridge/core/utils/response_utils.dart';
import 'package:HealthBridge/data/models/response_status_m.dart';

import '../../core/constants/app_constants.dart';
import '../../data/dataSource/secureData/secure_storage.dart';
import '../../data/models/hospital/hospital_notification_m.dart';

class HospitalProvider extends ChangeNotifier {
  final HospitalRepository hospitalRepository;

  HospitalProvider({
    required this.hospitalRepository,
  });

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  HospitalModel? hospitalProfile;

  // Temporary form data storage
  Map<String, dynamic> _hospitalProfileFormData = {};
  Map<String, dynamic> _bloodServicesFormData = {};
  String? _uploadedAccreditationUrl;

  String? _pickedDocFilePath;

  Map<String, dynamic> get hospitalProfileFormData => _hospitalProfileFormData;
  Map<String, dynamic> get bloodServicesFormData => _bloodServicesFormData;
  String? get uploadedAccreditationUrl => _uploadedAccreditationUrl;
  String? get pickedDocFilePath => _pickedDocFilePath;

  void savePickedDocFilePath(String path) {
    _pickedDocFilePath = path;
    notifyListeners();
  }

  Future<String?> getHospitalProfile() async {
    // Load from secure storage first
    hospitalProfile = await SecureStorage.getProfile<HospitalModel>(
      (json) => HospitalModel.fromJson(json),
    );
    notifyListeners();

    // fetch from api and update
    var id = hospitalProfile?.id;

    if (id == null) {
      // call auth storage to get userModel data
      var authData = await SecureStorage.getAuthData();
      if (authData == null)
        return AppConstants.login;
      else
        id = authData.user.id;
      // print("General log: id id $id");
    }

    // Fetch from API and update
    final res = await getResponse(hospitalRepository.getSpecialistProfile(id));
    if (ResponseUtils.isSuccessful(res)) {
      if (res.data == null) return 'Invalid server response';
      final profile = HospitalModel.fromJson(res.data);
      // if (!profile.verify) return AppConstants.emailUnverified;

      // save to secure storage (typed)
      await SecureStorage.saveProfile<HospitalModel>(profile);

      hospitalProfile = profile;
      notifyListeners();

      return null; // success
    }
    return res.message ?? 'Failed to fetch hospital profile';
  }

  /// set up hospital profile or update existing profile
  Future<String?> createHospital(Map<String, dynamic> payload,
      {String? hospitalId}) async {
    final res = await getResponse(
        hospitalRepository.createHospital(payload, hospitalId: hospitalId));
    if (ResponseUtils.isSuccessful(res)) {
      if (res.data == null) return 'Invalid server response';

      final profile = HospitalModel.fromJson(res.data);

      // save to secure storage (typed)
      await SecureStorage.saveProfile<HospitalModel>(profile);

      hospitalProfile = profile;
      notifyListeners();

      return null; // success
    }
    print("General log: createHospital error message: ${res.message}");
    return res.message;
  }

  HospitalNotificationM? hospitalNotification;

  /// get Hospital notifications setting
  Future<String?> getHospitalNotification(String hospitalId) async {
    final res = await getResponse(
        hospitalRepository.getHospitalNotification(hospitalId));
    if (ResponseUtils.isSuccessful(res)) {
      if (res.data == null) return 'Invalid server response';

      hospitalNotification = HospitalNotificationM.fromJson(res.data);
      notifyListeners();

      // Process notification settings as needed
      return null; // success
    }
    return res.message ?? 'Failed to fetch hospital notification settings';
  }

  /// update Hospital notifications setting
  Future<String?> updateHospitalNotification(
      Map<String, dynamic> payload, String hospitalId) async {
    final res = await getResponse(
        hospitalRepository.updateHospitalNotification(payload, hospitalId));
    if (ResponseUtils.isSuccessful(res)) {
      if (res.data == null) return 'Invalid server response';

      hospitalNotification = HospitalNotificationM.fromJson(res.data);
      notifyListeners();

      return null; // success
    }
    return res.message ?? 'Failed to update hospital notification settings';
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

  /// Store hospital profile form data
  void saveHospitalProfileData(Map<String, dynamic> data) {
    _hospitalProfileFormData = data;
    notifyListeners();
  }

  /// Store blood services form data
  void saveBloodServicesData(Map<String, dynamic> data) {
    _bloodServicesFormData = data;
    notifyListeners();
  }

  /// Build complete payload from both hospital profile and blood services data
  Map<String, dynamic> buildCompletePayload() {
    final payload = <String, dynamic>{
      // From hospital profile
      'name': _hospitalProfileFormData['name'] ?? '',
      'hospital_type': _hospitalProfileFormData['hospital_type'],
      'address': _hospitalProfileFormData['address'],
      'country': _hospitalProfileFormData['country'],
      'city': _hospitalProfileFormData['city'],
      'email': _hospitalProfileFormData['email'],
      'primary_phone': _hospitalProfileFormData['primary_phone'],
      'emergency_phone': (_hospitalProfileFormData['emergency_phone'] as String?)?.isNotEmpty == true
          ? _hospitalProfileFormData['emergency_phone']
          : null,
      'license_number': _hospitalProfileFormData['license_number'],
      'accreditation_doc_url':
          _hospitalProfileFormData['accreditation_doc_url'],

      // From blood services
      'has_blood_bank': _bloodServicesFormData['hasBloodBank'] ?? false,
      'accepting_donors': _bloodServicesFormData['acceptingDonors'] ?? false,
      'blood_inventory': _bloodServicesFormData['bloodInventory'] ?? [],
      'donating_operating_hours':
          _bloodServicesFormData['donatingOperatingHours'] ?? '',
    };

    return payload;
  }

  /// Clear temporary form data after successful submission
  void clearFormData() {
    _hospitalProfileFormData = {};
    _bloodServicesFormData = {};
    _pickedDocFilePath = null;
    notifyListeners();
  }

  /// Upload hospital accreditation document
  /// Returns null on success (URL is stored in _uploadedAccreditationUrl)
  /// Returns error message on failure
  Future<String?> uploadAccreditationDoc(
      String filePath, String hospitalId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final res = await getResponse(
          hospitalRepository.uploadAccreditationDoc(filePath, hospitalId),
          shouldLoad: false);

      if (ResponseUtils.isSuccessful(res)) {
        if (res.data == null) return 'Invalid server response';
        // res.data contains the URL string from the API response
        _uploadedAccreditationUrl = res.data.toString();
        _hospitalProfileFormData['accreditation_doc_url'] =
            _uploadedAccreditationUrl;
        _isLoading = false;
        notifyListeners();
        return null; // success
      }

      _isLoading = false;
      notifyListeners();
      return res.message ?? 'Failed to upload document';
    } catch (e) {
      print("General log: Error uploading accreditation doc - $e");
      _isLoading = false;
      notifyListeners();
      return 'Error uploading document';
    }
  }
}

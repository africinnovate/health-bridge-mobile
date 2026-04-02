import 'package:HealthBridge/data/models/blood_request/blood_request_model.dart';
import 'package:HealthBridge/data/models/hospital/hospital_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:HealthBridge/data/repositories/hospital_repository.dart';
import 'package:HealthBridge/core/utils/response_utils.dart';
import 'package:HealthBridge/data/models/response_status_m.dart';

import '../../data/dataSource/secureData/secure_storage.dart';
import '../../data/models/hospital/hospital_notification_m.dart';
import '../../data/models/hospital/hospital_dashboard_stats_model.dart';
import '../../data/models/hospital/hospital_activity_model.dart';
import '../../data/models/donor/donor_model.dart';
import '../../data/models/donor/donor_stats_model.dart';
import '../../data/models/donor/donation_history_model.dart';

class HospitalProvider extends ChangeNotifier {
  final HospitalRepository hospitalRepository;

  HospitalProvider({
    required this.hospitalRepository,
  });

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isDonorDataLoading = false;
  bool get isDonorDataLoading => _isDonorDataLoading;

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

    // Fetch from API and update
    final res = await getResponse(hospitalRepository.getHospitalProfile());

    if (ResponseUtils.isSuccessful(res)) {
      if (res.data == null) return 'Invalid server response';
      if ((res.data as List).isEmpty) return "Hospital not found";
      final profile = HospitalModel.fromJson(res.data[0]);
      // if (!profile.verify) return AppConstants.emailUnverified;

      // save to secure storage (typed)
      await SecureStorage.saveProfile<HospitalModel>(profile);

      hospitalProfile = profile;
      notifyListeners();

      return null; // success
    }
    debugPrint("General log: the hospital profile is333 $hospitalProfile");

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
  List<BloodRequestModel> bloodRequests = [];
  HospitalDashboardStatsModel? dashboardStats;
  List<HospitalActivityModel> recentActivities = [];
  List<DonorModel> donors = [];
  List<HospitalModel> allHospitals = [];
  List<HospitalModel> nearbyHospitals = [];
  DonorStatsModel? donorStats;
  List<DonationHistoryModel> donorHistory = [];

  /// Get all hospitals
  Future<String?> getAllHospitals() async {
    final res = await getResponse(hospitalRepository.getAllHospitals());

    if (ResponseUtils.isSuccessful(res)) {
      if (res.data == null) return 'Invalid server response';

      allHospitals = (res.data as List)
          .map((item) => HospitalModel.fromJson(item))
          .toList();
      notifyListeners();

      return null; // success
    }
    return res.message ?? 'Failed to fetch hospitals';
  }

  /// Get nearby hospitals (for donors to find nearby hospitals)
  Future<String?> getNearbyHospitals() async {
    final res = await getResponse(hospitalRepository.getNearbyHospitals(),
        shouldLoad: false);

    if (ResponseUtils.isSuccessful(res)) {
      if (res.data == null) return 'Invalid server response';

      nearbyHospitals = (res.data as List)
          .map((item) => HospitalModel.fromJson(item))
          .toList();
      notifyListeners();

      return null; // success
    }
    return res.message ?? 'Failed to fetch hospitals';
  }

  /// Get donor list
  Future<String?> getDonorList({
    bool? eligibleToDonate,
    String? bloodType,
  }) async {
    final res = await getResponse(
        hospitalRepository.getDonorList(
          eligibleToDonate: eligibleToDonate,
          bloodType: bloodType,
        ),
        shouldLoad: false);

    if (ResponseUtils.isSuccessful(res)) {
      if (res.data == null) return 'Invalid server response';

      donors =
          (res.data as List).map((item) => DonorModel.fromJson(item)).toList();
      notifyListeners();

      return null; // success
    }
    return res.message ?? 'Failed to fetch donor list';
  }

  /// Get donor stats
  Future<String?> getDonorStats(String donorId) async {
    final res = await getResponse(hospitalRepository.getDonorStats(donorId),
        shouldLoad: false);

    if (ResponseUtils.isSuccessful(res)) {
      if (res.data == null) return 'Invalid server response';

      donorStats = DonorStatsModel.fromJson(res.data);
      notifyListeners();

      return null; // success
    }
    return res.message ?? 'Failed to fetch donor stats';
  }

  /// Get donor donation history
  Future<String?> getDonorHistory(String donorId) async {
    final res = await getResponse(hospitalRepository.getDonorHistory(donorId),
        shouldLoad: false);

    if (ResponseUtils.isSuccessful(res)) {
      if (res.data == null) return 'Invalid server response';

      donorHistory = (res.data as List)
          .map((item) => DonationHistoryModel.fromJson(item))
          .toList();
      notifyListeners();

      return null; // success
    }
    return res.message ?? 'Failed to fetch donor history';
  }

  /// Update donor notes and eligibility
  Future<String?> updateDonor(
      String donorId, Map<String, dynamic> payload) async {
    final res =
        await getResponse(hospitalRepository.updateDonor(donorId, payload));

    if (ResponseUtils.isSuccessful(res)) {
      // Update successful - could refresh donor data here if needed
      return null; // success
    }
    return res.message ?? 'Failed to update donor';
  }

  /// Load both donor stats and history with loading state
  Future<void> loadDonorData(String donorId) async {
    _isDonorDataLoading = true;
    notifyListeners();

    await Future.wait([
      getDonorStats(donorId),
      getDonorHistory(donorId),
    ]);

    _isDonorDataLoading = false;
    notifyListeners();
  }

  /// Get hospital recent activity
  Future<String?> getHospitalRecentActivity() async {
    final res = await getResponse(
        hospitalRepository.getHospitalRecentActivity(),
        shouldLoad: false);

    if (ResponseUtils.isSuccessful(res)) {
      if (res.data == null) return 'Invalid server response';

      recentActivities = (res.data as List)
          .map((item) => HospitalActivityModel.fromJson(item))
          .toList();
      notifyListeners();

      return null; // success
    }
    return res.message ?? 'Failed to fetch recent activity';
  }

  /// Get hospital dashboard stats
  Future<String?> getHospitalDashboardStats() async {
    final res = await getResponse(
        hospitalRepository.getHospitalDashboardStats(),
        shouldLoad: false);

    if (ResponseUtils.isSuccessful(res)) {
      if (res.data == null) return 'Invalid server response';

      dashboardStats = HospitalDashboardStatsModel.fromJson(res.data);
      notifyListeners();

      return null; // success
    }
    return res.message ?? 'Failed to fetch dashboard stats';
  }

  /// Get blood requests for hospital
  Future<String?> getBloodRequests({String? status}) async {
    final res = await getResponse(
        hospitalRepository.getBloodRequests(status: status),
        shouldLoad: false);

    if (ResponseUtils.isSuccessful(res)) {
      if (res.data == null) return 'Invalid server response';

      bloodRequests = (res.data as List)
          .map((item) => BloodRequestModel.fromJson(item))
          .toList();
      notifyListeners();

      return null; // success
    }
    return res.message ?? 'Failed to fetch blood requests';
  }

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
      'state': _hospitalProfileFormData['state'] ?? '',
      'city': _hospitalProfileFormData['city'],
      'email': _hospitalProfileFormData['email'],
      'primary_phone': _hospitalProfileFormData['primary_phone'],
      'emergency_phone':
          (_hospitalProfileFormData['emergency_phone'] as String?)
                      ?.isNotEmpty ==
                  true
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

  /// Update blood inventory units
  Future<String?> updateBloodInventory(String hospitalId, String bloodType,
      int bankCapacity, int newUnits) async {
    final payload = {
      'bank_capacity': bankCapacity,
      'units_available': newUnits,
    };

    final res = await getResponse(hospitalRepository.updateBloodInventory(
        hospitalId, bloodType, payload));

    if (ResponseUtils.isSuccessful(res)) {
      // Refresh hospital profile to get updated inventory
      await getHospitalProfile();
      return null; // success
    }

    return res.message ?? 'Failed to update blood inventory';
  }

  /// Update blood request (cancel, complete, etc.)
  Future<String?> updateBloodRequest(
      String bloodRequestId, Map<String, dynamic> payload) async {
    final res = await getResponse(
        hospitalRepository.updateBloodRequest(bloodRequestId, payload));

    if (ResponseUtils.isSuccessful(res)) {
      return null; // success
    }

    return res.message ?? 'Failed to update blood request';
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

  /// Upload hospital profile image. Returns (imageUrl, error).
  Future<(String?, String?)> uploadHospitalImage(
      String filePath, String hospitalId) async {
    final res = await getResponse(
        hospitalRepository.uploadHospitalImage(filePath, hospitalId));

    if (ResponseUtils.isSuccessful(res)) {
      final imageUrl = res.data as String?;
      // Refresh profile so the new image reflects in the UI
      await getHospitalProfile();
      return (imageUrl, null);
    }
    return (null, res.message ?? 'Failed to upload image');
  }
}

import 'package:HealthBridge/data/models/blood_request/blood_request_model.dart';
import 'package:HealthBridge/data/models/response_status_m.dart';
import 'package:flutter/cupertino.dart';
import 'package:HealthBridge/data/repositories/hospital_repository.dart';
import 'package:HealthBridge/core/utils/response_utils.dart';

class BloodRequestProvider extends ChangeNotifier {
  final HospitalRepository hospitalRepository;

  BloodRequestProvider({required this.hospitalRepository});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<BloodRequestModel> _allRequests = [];
  List<BloodRequestModel> _activeRequests = [];
  List<BloodRequestModel> _fulfilledRequests = [];
  List<BloodRequestModel> _cancelledRequests = [];

  List<BloodRequestModel> get allRequests => _allRequests;
  List<BloodRequestModel> get activeRequests => _activeRequests;
  List<BloodRequestModel> get fulfilledRequests => _fulfilledRequests;
  List<BloodRequestModel> get cancelledRequests => _cancelledRequests;

  /// Fetch all blood requests and categorize them by status
  Future<String?> fetchBloodRequests() async {
    _isLoading = true;
    notifyListeners();

    try {
      final res = await hospitalRepository.getBloodRequests();

      if (ResponseUtils.isSuccessful(res)) {
        if (res.data == null) {
          _isLoading = false;
          notifyListeners();
          return 'Invalid server response';
        }

        // Parse the list of requests
        final List<dynamic> data = res.data is List ? res.data : [];
        _allRequests = data
            .map((json) =>
                BloodRequestModel.fromJson(json as Map<String, dynamic>))
            .toList();

        // Categorize by status
        _activeRequests = _allRequests
            .where((r) =>
                r.requestStatus?.toLowerCase() == 'confirmed' ||
                r.requestStatus?.toLowerCase() == 'accepted')
            .toList();

        _fulfilledRequests = _allRequests
            .where((r) => r.requestStatus?.toLowerCase() == 'completed')
            .toList();

        _cancelledRequests = _allRequests
            .where((r) => r.requestStatus?.toLowerCase() == 'cancelled')
            .toList();
        _isLoading = false;
        notifyListeners();
        return null; // success
      }
      debugPrint("General log: Error fetching blood requests");
      _isLoading = false;
      notifyListeners();
      return res.message ?? 'Failed to fetch blood requests';
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return 'Error fetching blood requests: $e';
    }
  }

  /// Get a specific request by ID
  BloodRequestModel? getRequestById(String requestId) {
    try {
      return _allRequests.firstWhere((r) => r.id == requestId);
    } catch (e) {
      return null;
    }
  }

  /// Clear all requests
  void clearRequests() {
    _allRequests = [];
    _activeRequests = [];
    _fulfilledRequests = [];
    _cancelledRequests = [];
    notifyListeners();
  }

  /// Create a new blood request
  Future<String?> createBloodRequest(Map<String, dynamic> payload) async {
    final res =
        await getResponse(hospitalRepository.createBloodRequest(payload));

    if (ResponseUtils.isSuccessful(res)) {
      if (res.data == null) return 'Invalid server response';

      final newRequest =
          BloodRequestModel.fromJson(res.data as Map<String, dynamic>);

      // Add to the appropriate list
      _allRequests.add(newRequest);
      if (newRequest.requestStatus?.toLowerCase() == 'confirmed' ||
          newRequest.requestStatus?.toLowerCase() == 'accepted') {
        _activeRequests.add(newRequest);
      }

      notifyListeners();
      return null; // success
    }
    debugPrint("General log: The error is - ${res.message}");
    return res.message ?? 'Failed to create blood request';
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
      print("General log: Error in BloodRequestProvider - $e");
      rethrow;
    } finally {
      if (shouldLoad) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }
}

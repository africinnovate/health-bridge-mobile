import 'package:flutter/cupertino.dart';
import '../../data/repositories/appointment_repository.dart';
import '../../data/models/appointment/appointment_model.dart';
import '../../core/utils/response_utils.dart'; // Ensure this import is correct
import '../../data/models/response_status_m.dart'; // Ensure this import is correct

class AppointmentProvider extends ChangeNotifier {
  final AppointmentRepository appointmentRepository;

  AppointmentProvider({
    required this.appointmentRepository,
  });

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<AppointmentModel>? appointments; // Adjusting this to fit the model

  // Fetch appointments and handle response
  Future<String?> getAppointments(String appointmentType, String status) async {
    // Fetch appointments from API
    final res = await getResponse(
        appointmentRepository.fetchAppointments(appointmentType, status));

    if (ResponseUtils.isSuccessful(res)) {
      appointments = res.data; // If res.data returns List<AppointmentModel>
      notifyListeners(); // Notify listeners of state change
      return null; // success
    }
    return res.message ?? 'Failed to fetch appointments'; // Error message
  }

  Future<ResponseStatusM> getResponse(Future<ResponseStatusM> repoCall,
      {bool shouldLoad = true}) async {
    if (shouldLoad) {
      _isLoading = true;
      notifyListeners(); // Update loading state
    }

    try {
      return await repoCall; // Await repository call
    } catch (e) {
      print("General log: Error in AppointmentProvider - \\$e"); // Log error
      rethrow; // Rethrow error
    } finally {
      if (shouldLoad) {
        _isLoading = false; // Reset loading state
        notifyListeners(); // Notify about loading state change
      }
    }
  }

  // Set loading state to true
  void setIsLoadingToTrue() {
    _isLoading = true;
    notifyListeners(); // Notify listeners
  }

  // Set loading state to false
  void setIsLoadingToFalse() {
    _isLoading = false;
    notifyListeners(); // Notify listeners
  }
}

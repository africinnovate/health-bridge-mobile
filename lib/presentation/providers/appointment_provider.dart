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

  /// Available values for status : created, confirmed, rescheduled, cancelled, completed
  /// appointment_type : donor, patient
  /// timeline : Filter by timeframe (today, this_week, this_month, upcoming)
  // Fetch appointments and handle response
  Future<String?> getAppointments(String appointmentType,
      {String? status, String? timeline}) async {
    // Fetch appointments from API
    final res = await getResponse(appointmentRepository.fetchAppointments(
        appointmentType,
        status: status,
        timeline: timeline));

    if (ResponseUtils.isSuccessful(res)) {
      if (res.data == null) {
        return 'Invalid server response';
      }

      // Parse the list of appointments
      final List<dynamic> data = res.data is List ? res.data : [];
      appointments = data
          .map(
              (json) => AppointmentModel.fromJson(json as Map<String, dynamic>))
          .toList();

      notifyListeners(); // Notify listeners of state change
      return null; // success
    }
    return res.message ?? 'Failed to fetch appointments'; // Error message
  }

  /// Fetch all appointments (both upcoming and past) for the given appointment type
  /// status: created, confirmed, rescheduled, cancelled, completed
  Future<String?> getAllAppointments(String appointmentType) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Fetch upcoming appointments using timeline filter
      final upcomingRes = await appointmentRepository.fetchAppointments(
        appointmentType,
        timeline: 'upcoming',
      );

      if (!ResponseUtils.isSuccessful(upcomingRes)) {
        _isLoading = false;
        notifyListeners();
        return upcomingRes.message ?? 'Failed to fetch upcoming appointments';
      }

      // Fetch past appointments using timeline filter
      final pastRes = await appointmentRepository.fetchAppointments(
        appointmentType,
        timeline: 'this_month',
      );

      if (!ResponseUtils.isSuccessful(pastRes)) {
        _isLoading = false;
        notifyListeners();
        return pastRes.message ?? 'Failed to fetch past appointments';
      }

      // Parse both lists
      final List<dynamic> upcomingData =
          upcomingRes.data is List ? upcomingRes.data : [];
      final List<dynamic> pastData = pastRes.data is List ? pastRes.data : [];

      // Merge both lists (upcoming first, then past)
      final allData = [...upcomingData, ...pastData];
      print("General log: Upcoming count - ${upcomingData.length}, Past count - ${pastData.length}, Total before dedup - ${allData.length}");

      // Deduplicate by appointment ID to avoid showing the same appointment twice
      final Set<String> seenIds = {};
      final uniqueData = <Map<String, dynamic>>[];

      for (final item in allData) {
        final json = item as Map<String, dynamic>;
        // Get ID from nested appointment object or top level
        final id = (json['appointment'] as Map<String, dynamic>?)?['id'] ?? json['id'];
        if (id != null) {
          final idStr = id.toString();
          if (!seenIds.contains(idStr)) {
            seenIds.add(idStr);
            uniqueData.add(json);
          } else {
            print("General log: Duplicate appointment ID found and removed - $idStr");
          }
        } else {
          // If no id, add it anyway to avoid losing data
          uniqueData.add(json);
        }
      }

      appointments =
          uniqueData.map((json) => AppointmentModel.fromJson(json)).toList();

      // get the appointments list size
      print(
          "General log: Total appointments fetched - ${appointments?.length}");
      _isLoading = false;
      notifyListeners();
      return null; // success
    } catch (e) {
      print("Error in getAllAppointments: $e");
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  /// Fetch all appointments (both upcoming and past) for a specialist by specialist ID
  Future<String?> getAllAppointmentsBySpecialistId(String specialistId) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Fetch upcoming appointments using timeline filter
      final upcomingRes = await appointmentRepository.fetchAppointmentsBySpecialistId(
        specialistId,
        timeline: 'upcoming',
      );

      if (!ResponseUtils.isSuccessful(upcomingRes)) {
        _isLoading = false;
        notifyListeners();
        return upcomingRes.message ?? 'Failed to fetch upcoming appointments';
      }

      // Fetch past appointments using timeline filter
      final pastRes = await appointmentRepository.fetchAppointmentsBySpecialistId(
        specialistId,
        timeline: 'this_month',
      );

      if (!ResponseUtils.isSuccessful(pastRes)) {
        _isLoading = false;
        notifyListeners();
        return pastRes.message ?? 'Failed to fetch past appointments';
      }

      // Parse both lists
      final List<dynamic> upcomingData =
          upcomingRes.data is List ? upcomingRes.data : [];
      final List<dynamic> pastData = pastRes.data is List ? pastRes.data : [];

      // Merge both lists (upcoming first, then past)
      final allData = [...upcomingData, ...pastData];

      // Deduplicate by appointment ID to avoid showing the same appointment twice
      final Set<String> seenIds = {};
      final uniqueData = <Map<String, dynamic>>[];

      for (final item in allData) {
        final json = item as Map<String, dynamic>;
        // Get ID from nested appointment object or top level
        final id = (json['appointment'] as Map<String, dynamic>?)?['id'] ?? json['id'];
        if (id != null) {
          final idStr = id.toString();
          if (!seenIds.contains(idStr)) {
            seenIds.add(idStr);
            uniqueData.add(json);
          }
        } else {
          // If no id, add it anyway to avoid losing data
          uniqueData.add(json);
        }
      }

      appointments =
          uniqueData.map((json) => AppointmentModel.fromJson(json)).toList();

      print(
          "General log: Total specialist appointments fetched - ${appointments?.length}");
      _isLoading = false;
      notifyListeners();
      return null; // success
    } catch (e) {
      print("Error in getAllAppointmentsBySpecialistId: $e");
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
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

  /// Create a new appointment (patient or donor)
  Future<String?> createAppointment({
    required String appointmentType,
    required DateTime scheduledTime,
    String? specialistId,
    String? bloodRequestId,
    String? notes,
  }) async {
    final res = await getResponse(appointmentRepository.createAppointment(
      appointmentType: appointmentType,
      scheduledTime: scheduledTime,
      specialistId: specialistId,
      bloodRequestId: bloodRequestId,
      notes: notes,
    ));

    if (ResponseUtils.isSuccessful(res)) {
      return null; // success
    }
    return res.message ?? 'Failed to create appointment';
  }

  /// Reschedule an appointment to a new time
  Future<String?> rescheduleAppointment(
    String appointmentId,
    DateTime newScheduledTime, {
    String appointmentType = 'donor',
  }) async {
    final res = await getResponse(appointmentRepository.rescheduleAppointment(
      appointmentId,
      newScheduledTime,
    ));

    if (ResponseUtils.isSuccessful(res)) {
      if (res.data == null) {
        return 'Invalid server response';
      }

      // Reload appointments after successful reschedule
      await getAllAppointments(appointmentType);
      return null; // success
    }
    return res.message ?? 'Failed to reschedule appointment';
  }

  /// Confirm an appointment (specialist action)
  Future<String?> confirmAppointment(
    String appointmentId, {
    String appointmentType = 'patient',
  }) async {
    final res = await getResponse(
        appointmentRepository.confirmAppointment(appointmentId));

    if (ResponseUtils.isSuccessful(res)) {
      await getAllAppointments(appointmentType);
      return null;
    }
    return res.message ?? 'Failed to confirm appointment';
  }

  /// Cancel an appointment with a reason
  Future<String?> cancelAppointment(
    String appointmentId,
    String reason, {
    String appointmentType = 'donor',
  }) async {
    final res = await getResponse(appointmentRepository.cancelAppointment(
      appointmentId,
      reason,
    ));

    if (ResponseUtils.isSuccessful(res)) {
      if (res.data == null) {
        return 'Invalid server response';
      }
      // Reload appointments after successful cancellation
      await getAllAppointments(appointmentType);
      return null; // success
    }
    return res.message ?? 'Failed to cancel appointment';
  }
}

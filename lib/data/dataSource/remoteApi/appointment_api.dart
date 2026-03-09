import 'package:HealthBridge/core/constants/app_constants.dart';
import 'package:HealthBridge/core/di/injection.dart';
import 'package:HealthBridge/core/utils/response_utils.dart';
import '../../../core/network/api_client.dart';
import '../../models/appointment/appointment_model.dart';
import '../../models/response_status_m.dart';

class AppointmentApi {
  final ApiClient apiClient;

  AppointmentApi({required this.apiClient});

  /// returns lists of appointment
  Future<ResponseStatusM> getAppointments(String appointmentType,
      {String? status, String? timeline}) async {
    var header = await Injection.tokenHeaders();
    final query = {
      "appointment_type": appointmentType,
      if (status != null) "status": status,
      if (timeline != null) "timeline": timeline,
    };

    final response = await apiClient.get(
      AppConstants.appointmentsEP,
      headers: header,
      query: query,
    );

    return ResponseUtils.getApiResponse(response);
  }

  /// Reschedule an appointment with a new scheduled time
  Future<ResponseStatusM> rescheduleAppointment(
    String appointmentId,
    DateTime newScheduledTime,
  ) async {
    var header = await Injection.tokenHeaders();
    final data = {
      "scheduled_time": newScheduledTime.toIso8601String(),
    };

    final response = await apiClient.put(
      '${AppConstants.appointmentRescheduleEP}/$appointmentId',
      headers: header,
      data: data,
    );

    return ResponseUtils.getApiResponse(response);
  }

  /// Confirm an appointment (specialist action)
  Future<ResponseStatusM> confirmAppointment(String appointmentId) async {
    var header = await Injection.tokenHeaders();

    final response = await apiClient.put(
      '${AppConstants.appointmentConfirmEP}/$appointmentId',
      headers: header,
    );

    return ResponseUtils.getApiResponse(response);
  }

  /// Cancel an appointment with a reason
  Future<ResponseStatusM> cancelAppointment(
    String appointmentId,
    String reason,
  ) async {
    var header = await Injection.tokenHeaders();
    final data = {
      "reason": reason,
    };

    final response = await apiClient.put(
      '${AppConstants.appointmentCancelEP}/$appointmentId',
      headers: header,
      data: data,
    );

    return ResponseUtils.getApiResponse(response);
  }
}

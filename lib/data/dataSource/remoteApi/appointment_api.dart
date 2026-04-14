import 'package:HealthBridge/core/constants/app_constants.dart';
import 'package:HealthBridge/core/di/injection.dart';
import 'package:HealthBridge/core/utils/response_utils.dart';
import 'package:flutter/cupertino.dart';
import '../../../core/network/api_client.dart';
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

    return ResponseUtils.getApiResponse(response,
        endpoint: "GET - ${AppConstants.appointmentsEP} \nquery: $query");
  }

  /// Get appointments for a specialist by specialist ID
  Future<ResponseStatusM> getAppointmentsBySpecialistId(
    String specialistId, {
    String? status,
    String? timeline,
  }) async {
    var header = await Injection.tokenHeaders();
    final query = {
      "specialist_id": specialistId,
      if (status != null) "status": status,
      if (timeline != null) "timeline": timeline,
    };

    final response = await apiClient.get(
      AppConstants.appointmentsEP,
      headers: header,
      query: query,
    );

    return ResponseUtils.getApiResponse(response,
        endpoint: "GET - ${AppConstants.appointmentsEP} \nquery: $query");
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
    debugPrint("Reschedule Response: ${response.statusCode}}");
    return ResponseUtils.getApiResponse(response,
        endpoint:
            "PUT - ${AppConstants.appointmentRescheduleEP}/$appointmentId \nData: $data");
  }

  /// Confirm an appointment (specialist action)
  Future<ResponseStatusM> confirmAppointment(String appointmentId) async {
    var header = await Injection.tokenHeaders();

    final response = await apiClient.put(
      '${AppConstants.appointmentConfirmEP}/$appointmentId',
      headers: header,
    );

    return ResponseUtils.getApiResponse(response,
        endpoint: "PUT - ${AppConstants.appointmentConfirmEP}/$appointmentId");
  }

  /// Create a new appointment (donor or patient initiates)
  Future<ResponseStatusM> createAppointment({
    required String appointmentType,
    required DateTime scheduledTime,
    String? specialistId,
    String? bloodRequestId,
    String? notes,
  }) async {
    var header = await Injection.tokenHeaders();
    final data = <String, dynamic>{
      'appointment_type': appointmentType,
      'scheduled_time': scheduledTime.toUtc().toIso8601String(),
      'blood_request_id': bloodRequestId,
      'specialist_id': specialistId,
      if (notes != null && notes.isNotEmpty) 'notes': notes,
    };

    final response = await apiClient.post(
      AppConstants.createAppointmentEP,
      headers: header,
      data: data,
    );

    return ResponseUtils.getApiResponse(response,
        endpoint: "POST - ${AppConstants.createAppointmentEP}");
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

    return ResponseUtils.getApiResponse(response,
        endpoint: "PUT - ${AppConstants.appointmentCancelEP}/$appointmentId");
  }
}

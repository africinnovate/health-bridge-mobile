import 'package:HealthBridge/data/models/response_status_m.dart';

import '../../core/utils/response_utils.dart';
import '../dataSource/remoteApi/appointment_api.dart';

class AppointmentRepository {
  final AppointmentApi appointmentApi;

  AppointmentRepository({required this.appointmentApi});

  Future<ResponseStatusM> fetchAppointments(String appointmentType,
      {String? status, String? timeline}) async {
    try {
      return await appointmentApi.getAppointments(appointmentType,
          status: status, timeline: timeline);
    } catch (e) {
      return ResponseUtils.checkError(e);
    }
  }

  Future<ResponseStatusM> fetchAppointmentsBySpecialistId(
    String specialistId, {
    String? status,
    String? timeline,
  }) async {
    try {
      return await appointmentApi.getAppointmentsBySpecialistId(
        specialistId,
        status: status,
        timeline: timeline,
      );
    } catch (e) {
      return ResponseUtils.checkError(e);
    }
  }

  Future<ResponseStatusM> createAppointment({
    required String appointmentType,
    required DateTime scheduledTime,
    String? specialistId,
    String? bloodRequestId,
    String? notes,
  }) async {
    try {
      return await appointmentApi.createAppointment(
        appointmentType: appointmentType,
        scheduledTime: scheduledTime,
        specialistId: specialistId,
        bloodRequestId: bloodRequestId,
        notes: notes,
      );
    } catch (e) {
      return ResponseUtils.checkError(e);
    }
  }

  Future<ResponseStatusM> rescheduleAppointment(
    String appointmentId,
    DateTime newScheduledTime,
  ) async {
    try {
      return await appointmentApi.rescheduleAppointment(
        appointmentId,
        newScheduledTime,
      );
    } catch (e) {
      return ResponseUtils.checkError(e);
    }
  }

  Future<ResponseStatusM> confirmAppointment(String appointmentId) async {
    try {
      return await appointmentApi.confirmAppointment(appointmentId);
    } catch (e) {
      return ResponseUtils.checkError(e);
    }
  }

  Future<ResponseStatusM> cancelAppointment(
    String appointmentId,
    String reason,
  ) async {
    try {
      return await appointmentApi.cancelAppointment(
        appointmentId,
        reason,
      );
    } catch (e) {
      return ResponseUtils.checkError(e);
    }
  }
}

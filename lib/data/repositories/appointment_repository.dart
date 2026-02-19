import 'package:HealthBridge/data/models/response_status_m.dart';

import '../../core/utils/response_utils.dart';
import '../dataSource/remoteApi/appointment_api.dart';

class AppointmentRepository {
  final AppointmentApi appointmentApi;

  AppointmentRepository({required this.appointmentApi});

  Future<ResponseStatusM> fetchAppointments(
      String appointmentType, String status) async {
    try {
      return await appointmentApi.getAppointments(appointmentType, status);
    } catch (e) {
      return ResponseUtils.checkError(e);
    }
  }
}

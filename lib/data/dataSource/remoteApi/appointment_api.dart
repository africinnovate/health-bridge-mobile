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
  Future<ResponseStatusM> getAppointments(
      String appointmentType, String status) async {
    var header = await Injection.tokenHeaders();
    final response = await apiClient.get(
      AppConstants.appointmentsEP,
      headers: header,
      query: {"appointment_type": appointmentType, "status": status},
    );

    return ResponseUtils.getApiResponse(response);
  }
}

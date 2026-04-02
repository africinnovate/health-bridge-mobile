import 'package:HealthBridge/core/constants/app_constants.dart';
import 'package:HealthBridge/core/di/injection.dart';
import 'package:HealthBridge/core/utils/response_utils.dart';
import 'package:HealthBridge/data/models/response_status_m.dart';
import '../../../core/network/api_client.dart';

class NotificationApi {
  final ApiClient apiClient;

  NotificationApi({required this.apiClient});

  Future<ResponseStatusM> getNotifications({bool? isRead, int page = 1, int pageSize = 20}) async {
    final header = await Injection.tokenHeaders();
    final query = <String, String>{'page': '$page', 'page_size': '$pageSize'};
    if (isRead != null) query['is_read'] = '$isRead';

    final response = await apiClient.get(
      AppConstants.notificationsEP,
      headers: header,
      query: query,
    );

    return ResponseUtils.getApiResponse(response);
  }

  Future<ResponseStatusM> markAllRead() async {
    final header = await Injection.tokenHeaders();

    final response = await apiClient.patch(
      AppConstants.markAllReadEP,
      headers: header,
    );

    return ResponseUtils.getApiResponse(response);
  }

  Future<ResponseStatusM> markRead(String id) async {
    final header = await Injection.tokenHeaders();

    final response = await apiClient.patch(
      '${AppConstants.notificationsEP}/$id/read',
      headers: header,
    );

    return ResponseUtils.getApiResponse(response);
  }
}

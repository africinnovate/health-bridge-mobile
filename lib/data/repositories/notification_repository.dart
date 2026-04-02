import 'package:HealthBridge/core/utils/response_utils.dart';
import 'package:HealthBridge/data/dataSource/remoteApi/notification_api.dart';
import 'package:HealthBridge/data/models/response_status_m.dart';

class NotificationRepository {
  final NotificationApi notificationApi;

  NotificationRepository({required this.notificationApi});

  Future<ResponseStatusM> getNotifications({bool? isRead, int page = 1, int pageSize = 20}) async {
    try {
      return await notificationApi.getNotifications(isRead: isRead, page: page, pageSize: pageSize);
    } catch (e) {
      return ResponseUtils.checkError(e);
    }
  }

  Future<ResponseStatusM> markAllRead() async {
    try {
      return await notificationApi.markAllRead();
    } catch (e) {
      return ResponseUtils.checkError(e);
    }
  }

  Future<ResponseStatusM> markRead(String id) async {
    try {
      return await notificationApi.markRead(id);
    } catch (e) {
      return ResponseUtils.checkError(e);
    }
  }
}

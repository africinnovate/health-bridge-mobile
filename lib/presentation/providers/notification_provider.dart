import 'package:HealthBridge/core/utils/response_utils.dart';
import 'package:HealthBridge/data/models/notification/notification_model.dart';
import 'package:HealthBridge/data/models/response_status_m.dart';
import 'package:HealthBridge/data/repositories/notification_repository.dart';
import 'package:flutter/material.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationRepository notificationRepository;

  NotificationProvider({required this.notificationRepository});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<NotificationModel> _notifications = [];
  List<NotificationModel> get notifications => _notifications;

  List<NotificationModel> get unread =>
      _notifications.where((n) => !n.isRead).toList();

  int get unreadCount => unread.length;

  Future<String?> getNotifications({bool? isRead}) async {
    final res = await _run(
      notificationRepository.getNotifications(isRead: isRead),
    );

    if (ResponseUtils.isSuccessful(res)) {
      if (res.data == null) return 'Invalid server response';

      final list = res.data['data'] as List<dynamic>? ?? [];
      _notifications = list
          .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
          .toList();
      notifyListeners();
      return null;
    }

    return res.message ?? 'Failed to load notifications';
  }

  Future<String?> markAllRead() async {
    final res = await _run(notificationRepository.markAllRead());

    if (ResponseUtils.isSuccessful(res)) {
      _notifications = _notifications
          .map((n) => n.copyWith(isRead: true, readAt: DateTime.now()))
          .toList();
      notifyListeners();
      return null;
    }

    return res.message ?? 'Failed to mark all as read';
  }

  Future<String?> markRead(String id) async {
    final res = await _run(
      notificationRepository.markRead(id),
      shouldLoad: false,
    );

    if (ResponseUtils.isSuccessful(res)) {
      _notifications = _notifications.map((n) {
        return n.id == id ? n.copyWith(isRead: true, readAt: DateTime.now()) : n;
      }).toList();
      notifyListeners();
      return null;
    }

    return res.message ?? 'Failed to mark as read';
  }

  Future<ResponseStatusM> _run(
    Future<ResponseStatusM> call, {
    bool shouldLoad = true,
  }) async {
    if (shouldLoad) {
      _isLoading = true;
      notifyListeners();
    }
    try {
      return await call;
    } catch (e) {
      rethrow;
    } finally {
      if (shouldLoad) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }
}

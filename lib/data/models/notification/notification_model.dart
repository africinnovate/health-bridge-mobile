import 'package:flutter/material.dart';
import 'package:HealthBridge/core/constants/app_colors.dart';

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String category;
  final bool isRead;
  final DateTime createdAt;
  final DateTime? readAt;
  final String? relatedId;
  final String? relatedType;
  final String? metadata;
  final String userId;
  final String? createdBy;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.category,
    required this.isRead,
    required this.createdAt,
    this.readAt,
    this.relatedId,
    this.relatedType,
    this.metadata,
    required this.userId,
    this.createdBy,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      category: json['category'] as String? ?? 'system',
      isRead: json['is_read'] as bool? ?? false,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      readAt: json['read_at'] != null
          ? DateTime.tryParse(json['read_at'])
          : null,
      relatedId: json['related_id'] as String?,
      relatedType: json['related_type'] as String?,
      metadata: json['metadata'] as String?,
      userId: json['user_id'] as String? ?? '',
      createdBy: json['created_by'] as String?,
    );
  }

  NotificationModel copyWith({bool? isRead, DateTime? readAt}) {
    return NotificationModel(
      id: id,
      title: title,
      message: message,
      category: category,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt,
      readAt: readAt ?? this.readAt,
      relatedId: relatedId,
      relatedType: relatedType,
      metadata: metadata,
      userId: userId,
      createdBy: createdBy,
    );
  }

  String get timeAgo {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
  }

  IconData get categoryIcon {
    switch (category) {
      case 'appointment':
        return Icons.calendar_today;
      case 'blood_request':
        return Icons.water_drop;
      case 'verification':
        return Icons.verified_user_outlined;
      default:
        return Icons.notifications;
    }
  }

  Color get categoryColor {
    switch (category) {
      case 'appointment':
        return const Color(0xFF6366F1);
      case 'blood_request':
        return AppColors.red;
      case 'verification':
        return AppColors.green;
      default:
        return const Color(0xFF6B7280);
    }
  }
}

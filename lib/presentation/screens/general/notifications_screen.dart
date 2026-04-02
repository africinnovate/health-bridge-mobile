import 'package:HealthBridge/core/constants/app_colors.dart';
import 'package:HealthBridge/core/utils/snackbar_utils.dart';
import 'package:HealthBridge/data/models/notification/notification_model.dart';
import 'package:HealthBridge/presentation/providers/notification_provider.dart';
import 'package:HealthBridge/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Used by patient, donor and hospital roles.
class GeneralNotificationsScreen extends StatefulWidget {
  const GeneralNotificationsScreen({super.key});

  @override
  State<GeneralNotificationsScreen> createState() =>
      _GeneralNotificationsScreenState();
}

class _GeneralNotificationsScreenState
    extends State<GeneralNotificationsScreen> {
  bool _showUnreadOnly = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationProvider>().getNotifications();
    });
  }

  Future<void> _refresh() =>
      context.read<NotificationProvider>().getNotifications();

  Future<void> _markAllRead() async {
    final error = await context.read<NotificationProvider>().markAllRead();
    if (error != null && mounted) SnackBarUtils.showError(context, error);
  }

  void _openDetail(NotificationModel n) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _NotificationDetailScreen(notification: n),
      ),
    );
  }

  Map<String, List<NotificationModel>> _group(List<NotificationModel> list) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final Map<String, List<NotificationModel>> groups = {};

    for (final n in list) {
      final d = DateTime(n.createdAt.year, n.createdAt.month, n.createdAt.day);
      final String key;
      if (d == today) {
        key = 'Today';
      } else if (d == yesterday) {
        key = 'Yesterday';
      } else {
        key = '${d.day}/${d.month}/${d.year}';
      }
      groups.putIfAbsent(key, () => []).add(n);
    }

    return groups;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      appBar: CustomAppBar(
        title: 'Notifications',
        showArrow: true,
        actions: [
          Consumer<NotificationProvider>(
            builder: (_, provider, __) {
              if (provider.unreadCount == 0) return const SizedBox.shrink();
              return TextButton(
                onPressed: _markAllRead,
                child: const Text(
                  'Mark all read',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.notifications.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          final all = provider.notifications;
          final displayed = _showUnreadOnly ? provider.unread : all;
          final groups = _group(displayed);

          return Column(
            children: [
              /// Filter tabs
              if (all.isNotEmpty) _buildFilterBar(provider.unreadCount),

              /// Grouped list
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _refresh,
                  color: AppColors.red,
                  child: displayed.isEmpty
                      ? _buildEmpty()
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          itemCount: groups.length,
                          itemBuilder: (_, groupIndex) {
                            final key = groups.keys.elementAt(groupIndex);
                            final items = groups[key]!;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// Date header
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 8, 20, 10),
                                  child: Text(
                                    key,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF6B7280),
                                    ),
                                  ),
                                ),
                                ...items.map(
                                  (n) => Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        16, 0, 16, 10),
                                    child: _NotificationCard(
                                      notification: n,
                                      onTap: () => _openDetail(n),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterBar(int unreadCount) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          _filterChip('All', !_showUnreadOnly,
              () => setState(() => _showUnreadOnly = false)),
          const SizedBox(width: 8),
          _filterChip(
            'Unread${unreadCount > 0 ? ' ($unreadCount)' : ''}',
            _showUnreadOnly,
            () => setState(() => _showUnreadOnly = true),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? AppColors.red : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: selected ? Colors.white : const Color(0xFF6B7280),
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return ListView(
      children: [
        const SizedBox(height: 100),
        Center(
          child: Column(
            children: [
              Icon(Icons.notifications_none,
                  size: 64, color: Colors.grey.shade300),
              const SizedBox(height: 16),
              Text(
                _showUnreadOnly
                    ? 'No unread notifications'
                    : 'No notifications yet',
                style: const TextStyle(
                    fontSize: 15, color: Color(0xFF6B7280)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Notification Card
// ---------------------------------------------------------------------------
class _NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const _NotificationCard({required this.notification, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final n = notification;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Rounded-square icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: n.categoryColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(n.categoryIcon, color: n.categoryColor, size: 24),
            ),
            const SizedBox(width: 12),

            /// Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Title + unread dot
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          n.title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight:
                                n.isRead ? FontWeight.w500 : FontWeight.w700,
                            color: const Color(0xFF111827),
                          ),
                        ),
                      ),
                      if (!n.isRead) ...[
                        const SizedBox(width: 8),
                        Container(
                          width: 9,
                          height: 9,
                          margin: const EdgeInsets.only(top: 4),
                          decoration: const BoxDecoration(
                            color: Color(0xFF3B82F6),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),

                  /// Message
                  Text(
                    n.message,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF6B7280),
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  /// Category chip + time
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: n.categoryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          n.category.replaceAll('_', ' '),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: n.categoryColor,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        n.timeAgo,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Notification Detail Screen
// ---------------------------------------------------------------------------
class _NotificationDetailScreen extends StatefulWidget {
  final NotificationModel notification;

  const _NotificationDetailScreen({required this.notification});

  @override
  State<_NotificationDetailScreen> createState() =>
      _NotificationDetailScreenState();
}

class _NotificationDetailScreenState
    extends State<_NotificationDetailScreen> {
  @override
  void initState() {
    super.initState();
    if (!widget.notification.isRead) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<NotificationProvider>().markRead(widget.notification.id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final n = widget.notification;
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      appBar: const CustomAppBar(title: 'Notification', showArrow: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Icon + category + time
              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: n.categoryColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child:
                        Icon(n.categoryIcon, color: n.categoryColor, size: 26),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: n.categoryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          n.category.replaceAll('_', ' ').toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: n.categoryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        n.timeAgo,
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xFF9CA3AF)),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 16),

              Text(
                n.title,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),

              Text(
                n.message,
                style: const TextStyle(
                    fontSize: 14, color: Color(0xFF374151), height: 1.6),
              ),

              if (n.relatedType != null || n.metadata != null) ...[
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),
                if (n.relatedType != null)
                  _detailRow('Related to', n.relatedType!),
                if (n.metadata != null) _detailRow('Details', n.metadata!),
              ],

              const SizedBox(height: 24),

              Row(
                children: [
                  Icon(Icons.check_circle,
                      size: 14,
                      color: n.isRead ? AppColors.green : Colors.grey),
                  const SizedBox(width: 6),
                  Text(
                    n.isRead ? 'Read' : 'Unread',
                    style: TextStyle(
                        fontSize: 12,
                        color: n.isRead ? AppColors.green : Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(label,
                style: const TextStyle(
                    fontSize: 13, color: Color(0xFF9CA3AF))),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}

class DonationHistoryModel {
  final String? cancelledAt;
  final String? donatedAt;
  final String refId;
  final String requestStatus;
  final int units;

  DonationHistoryModel({
    this.cancelledAt,
    this.donatedAt,
    required this.refId,
    required this.requestStatus,
    required this.units,
  });

  factory DonationHistoryModel.fromJson(Map<String, dynamic> json) {
    return DonationHistoryModel(
      cancelledAt: json['cancelled_at'] as String?,
      donatedAt: json['donated_at'] as String?,
      refId: json['ref_id'] as String? ?? '',
      requestStatus: json['request_status'] as String? ?? '',
      units: json['units'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cancelled_at': cancelledAt,
      'donated_at': donatedAt,
      'ref_id': refId,
      'request_status': requestStatus,
      'units': units,
    };
  }

  /// Get formatted date (either donated or cancelled)
  DateTime? get date {
    final dateStr = donatedAt ?? cancelledAt;
    if (dateStr == null) return null;
    try {
      return DateTime.parse(dateStr);
    } catch (e) {
      return null;
    }
  }

  /// Get formatted date string
  String get formattedDate {
    final dt = date;
    if (dt == null) return 'N/A';

    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }

  /// Check if donation was completed
  bool get isCompleted => requestStatus.toLowerCase() == 'completed';

  /// Check if donation was cancelled
  bool get isCancelled => requestStatus.toLowerCase() == 'cancelled';

  /// Get status color
  String get statusColor {
    if (isCompleted) return 'green';
    if (isCancelled) return 'red';
    return 'yellow';
  }

  /// Get formatted units (e.g., "2 units")
  String get formattedUnits {
    return '$units ${units == 1 ? 'unit' : 'units'}';
  }
}

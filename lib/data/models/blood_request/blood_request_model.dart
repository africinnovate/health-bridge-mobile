class BloodRequestModel {
  final String id;
  final String hospitalId;
  final String donorId;
  final String? recipientId;
  final String? bloodType;
  final int units;
  final String? urgency;
  final String? requestReason;
  final String refId;
  final String? requestStatus;
  final String? timelineStatus;
  final DateTime? preferredTime;
  final DateTime? donatedAt;
  final DateTime? administeredAt;
  final String? note;
  final DateTime createdAt;
  final DateTime? cancelledAt;
  final String? cancelledBy;
  final String? cancelledReason;

  BloodRequestModel({
    required this.id,
    required this.hospitalId,
    required this.donorId,
    this.recipientId,
    this.bloodType,
    required this.units,
    this.urgency,
    this.requestReason,
    required this.refId,
    this.requestStatus,
    this.timelineStatus,
    this.preferredTime,
    this.donatedAt,
    this.administeredAt,
    this.note,
    required this.createdAt,
    this.cancelledAt,
    this.cancelledBy,
    this.cancelledReason,
  });

  factory BloodRequestModel.fromJson(Map<String, dynamic> json) {
    return BloodRequestModel(
      id: json['id'] as String? ?? '',
      hospitalId: json['hospital_id'] as String? ?? '',
      donorId: json['donor_id'] as String? ?? '',
      recipientId: json['recipient_id'] as String?,
      bloodType: json['blood_type'] as String?,
      units: json['units'] as int? ?? 0,
      urgency: json['urgency'] as String?,
      requestReason: json['request_reason'] as String?,
      refId: json['ref_id'] as String? ?? '',
      requestStatus: json['request_status'] as String?,
      timelineStatus: json['timeline_status'] as String?,
      preferredTime: json['preferred_time'] != null
          ? DateTime.tryParse(json['preferred_time'] as String)
          : null,
      donatedAt: json['donated_at'] != null
          ? DateTime.tryParse(json['donated_at'] as String)
          : null,
      administeredAt: json['administered_at'] != null
          ? DateTime.tryParse(json['administered_at'] as String)
          : null,
      note: json['note'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String) ?? DateTime.now()
          : DateTime.now(),
      cancelledAt: json['cancelled_at'] != null
          ? DateTime.tryParse(json['cancelled_at'] as String)
          : null,
      cancelledBy: json['cancelled_by'] as String?,
      cancelledReason: json['cancelled_reason'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'hospital_id': hospitalId,
        'donor_id': donorId,
        'recipient_id': recipientId,
        'blood_type': bloodType,
        'units': units,
        'urgency': urgency,
        'request_reason': requestReason,
        'ref_id': refId,
        'request_status': requestStatus,
        'timeline_status': timelineStatus,
        'preferred_time': preferredTime?.toIso8601String(),
        'donated_at': donatedAt?.toIso8601String(),
        'administered_at': administeredAt?.toIso8601String(),
        'note': note,
        'created_at': createdAt.toIso8601String(),
        'cancelled_at': cancelledAt?.toIso8601String(),
        'cancelled_by': cancelledBy,
        'cancelled_reason': cancelledReason,
      };
}

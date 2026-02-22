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
    // Extract blood_request object if it exists (wrapped response structure)
    final bloodRequestData = json['blood_request'] as Map<String, dynamic>? ?? json;

    return BloodRequestModel(
      id: bloodRequestData['id'] as String? ?? '',
      hospitalId: bloodRequestData['hospital_id'] as String? ?? '',
      donorId: bloodRequestData['donor_id'] as String? ?? '',
      recipientId: bloodRequestData['recipient_id'] as String?,
      bloodType: bloodRequestData['blood_type'] as String?,
      units: bloodRequestData['units'] as int? ?? 0,
      urgency: bloodRequestData['urgency'] as String?,
      requestReason: bloodRequestData['request_reason'] as String?,
      refId: bloodRequestData['ref_id'] as String? ?? '',
      requestStatus: bloodRequestData['request_status'] as String?,
      timelineStatus: bloodRequestData['timeline_status'] as String?,
      preferredTime: bloodRequestData['preferred_time'] != null
          ? DateTime.tryParse(bloodRequestData['preferred_time'] as String)
          : null,
      donatedAt: bloodRequestData['donated_at'] != null
          ? DateTime.tryParse(bloodRequestData['donated_at'] as String)
          : null,
      administeredAt: bloodRequestData['administered_at'] != null
          ? DateTime.tryParse(bloodRequestData['administered_at'] as String)
          : null,
      note: bloodRequestData['note'] as String?,
      createdAt: bloodRequestData['created_at'] != null
          ? DateTime.tryParse(bloodRequestData['created_at'] as String) ?? DateTime.now()
          : DateTime.now(),
      cancelledAt: bloodRequestData['cancelled_at'] != null
          ? DateTime.tryParse(bloodRequestData['cancelled_at'] as String)
          : null,
      cancelledBy: bloodRequestData['cancelled_by'] as String?,
      cancelledReason: bloodRequestData['cancelled_reason'] as String?,
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

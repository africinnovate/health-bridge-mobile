class AppointmentModel {
  final String appointmentType;
  final String bloodRequestId;
  final DateTime? cancelledAt;
  final String? cancelledBy;
  final String? cancelledById;
  final String? cancelledReason;
  final DateTime createdAt;
  final String hospitalId;
  final String id;
  final DateTime previousTime;
  final DateTime scheduledTime;
  final String specialistId;
  final String status;
  final String userId;

  AppointmentModel({
    required this.appointmentType,
    required this.bloodRequestId,
    this.cancelledAt,
    this.cancelledBy,
    this.cancelledById,
    this.cancelledReason,
    required this.createdAt,
    required this.hospitalId,
    required this.id,
    required this.previousTime,
    required this.scheduledTime,
    required this.specialistId,
    required this.status,
    required this.userId,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      appointmentType: json['appointment_type'],
      bloodRequestId: json['blood_request_id'],
      cancelledAt: json['cancelled_at'] != null
          ? DateTime.parse(json['cancelled_at'])
          : null,
      cancelledBy: json['cancelled_by'],
      cancelledById: json['cancelled_by_id'],
      cancelledReason: json['cancelled_reason'],
      createdAt: DateTime.parse(json['created_at']),
      hospitalId: json['hospital_id'],
      id: json['id'],
      previousTime: DateTime.parse(json['previous_time']),
      scheduledTime: DateTime.parse(json['scheduled_time']),
      specialistId: json['specialist_id'],
      status: json['status'],
      userId: json['user_id'],
    );
  }
}

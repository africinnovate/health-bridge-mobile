class HospitalActivityModel {
  final String id;
  final String activityType;
  final String description;
  final DateTime timestamp;

  HospitalActivityModel({
    required this.id,
    required this.activityType,
    required this.description,
    required this.timestamp,
  });

  factory HospitalActivityModel.fromJson(Map<String, dynamic> json) {
    return HospitalActivityModel(
      id: json['id'] ?? '',
      activityType: json['activity_type'] ?? '',
      description: json['description'] ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'activity_type': activityType,
      'description': description,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

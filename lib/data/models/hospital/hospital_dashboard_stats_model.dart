class HospitalDashboardStatsModel {
  final int activeBloodRequests;
  final int appointmentsCount;
  final int urgentRequestsNearby;

  HospitalDashboardStatsModel({
    required this.activeBloodRequests,
    required this.appointmentsCount,
    required this.urgentRequestsNearby,
  });

  factory HospitalDashboardStatsModel.fromJson(Map<String, dynamic> json) {
    return HospitalDashboardStatsModel(
      activeBloodRequests: json['active_blood_requests'] ?? 0,
      appointmentsCount: json['appointments_count'] ?? 0,
      urgentRequestsNearby: json['urgent_requests_nearby'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'active_blood_requests': activeBloodRequests,
      'appointments_count': appointmentsCount,
      'urgent_requests_nearby': urgentRequestsNearby,
    };
  }
}

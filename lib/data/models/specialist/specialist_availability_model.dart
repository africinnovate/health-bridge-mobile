class SpecialistAvailabilityModel {
  final String dayOfWeek;
  final String opensAt;
  final String closesAt;

  SpecialistAvailabilityModel({
    required this.dayOfWeek,
    required this.opensAt,
    required this.closesAt,
  });

  factory SpecialistAvailabilityModel.fromJson(Map<String, dynamic> json) {
    return SpecialistAvailabilityModel(
      dayOfWeek: json['day_of_week'],
      opensAt: json['opens_at'],
      closesAt: json['closes_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day_of_week': dayOfWeek,
      'opens_at': opensAt,
      'closes_at': closesAt,
    };
  }

  @override
  String toString() {
    return '$dayOfWeek ($opensAt - $closesAt)';
  }
}

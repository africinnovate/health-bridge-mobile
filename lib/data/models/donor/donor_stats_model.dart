class DonorStatsModel {
  final String? bloodType;
  final int totalDonations;
  final double totalLitresDonated;

  DonorStatsModel({
    this.bloodType,
    required this.totalDonations,
    required this.totalLitresDonated,
  });

  factory DonorStatsModel.fromJson(Map<String, dynamic> json) {
    return DonorStatsModel(
      bloodType: json['blood_type'] as String?,
      totalDonations: json['total_donations'] as int? ?? 0,
      totalLitresDonated:
          (json['total_litres_donated'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'blood_type': bloodType,
      'total_donations': totalDonations,
      'total_litres_donated': totalLitresDonated,
    };
  }

  /// Format blood type from API format (e.g., "apositive") to display format (e.g., "A+")
  String get formattedBloodType {
    if (bloodType == null || bloodType!.isEmpty) return 'Unknown';

    final type = bloodType!.toLowerCase();
    if (type == 'apositive') return 'A+';
    if (type == 'anegative') return 'A-';
    if (type == 'bpositive') return 'B+';
    if (type == 'bnegative') return 'B-';
    if (type == 'opositive') return 'O+';
    if (type == 'onegative') return 'O-';
    if (type == 'abpositive') return 'AB+';
    if (type == 'abnegative') return 'AB-';

    return bloodType!;
  }

  /// Format total volume as string (e.g., "5.4L")
  String get formattedVolume {
    return '${totalLitresDonated.toStringAsFixed(1)}L';
  }
}

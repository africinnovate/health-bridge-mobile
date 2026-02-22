class DonorModel {
  final String userId;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? bloodType;
  final bool eligibleToDonate;
  final String? gender;
  final String? imageUrl;
  final String? note;

  DonorModel({
    required this.userId,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.bloodType,
    required this.eligibleToDonate,
    this.gender,
    this.imageUrl,
    this.note,
  });

  factory DonorModel.fromJson(Map<String, dynamic> json) {
    return DonorModel(
      userId: json['user_id'] ?? '',
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      phone: json['phone'],
      bloodType: json['blood_type'],
      eligibleToDonate: json['eligible_to_donate'] ?? false,
      gender: json['gender'],
      imageUrl: json['image_url'],
      note: json['note'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'blood_type': bloodType,
      'eligible_to_donate': eligibleToDonate,
      'gender': gender,
      'image_url': imageUrl,
      'note': note,
    };
  }

  String get fullName {
    if (firstName == null && lastName == null) return 'Unknown';
    return '${firstName ?? ''} ${lastName ?? ''}'.trim();
  }

  String get initials {
    final first = firstName?.isNotEmpty == true ? firstName![0].toUpperCase() : '';
    final last = lastName?.isNotEmpty == true ? lastName![0].toUpperCase() : '';
    return '$first$last'.isNotEmpty ? '$first$last' : '?';
  }

  String get formattedBloodType {
    if (bloodType == null) return '';
    // Convert API format to display format
    switch (bloodType!.toLowerCase()) {
      case 'apositive':
        return 'A+';
      case 'anegative':
        return 'A-';
      case 'bpositive':
        return 'B+';
      case 'bnegative':
        return 'B-';
      case 'opositive':
        return 'O+';
      case 'onegative':
        return 'O-';
      case 'abpositive':
        return 'AB+';
      case 'abnegative':
        return 'AB-';
      default:
        return bloodType!; // Return as-is if already formatted
    }
  }
}

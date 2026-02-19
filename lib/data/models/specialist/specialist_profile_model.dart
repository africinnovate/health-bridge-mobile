import 'package:HealthBridge/data/models/specialist/specialist_availability_model.dart';

import '../../dataSource/secureData/secure_storage.dart';

class SpecialistProfileModel implements JsonSerializable {
  final String id;
  final String userId;
  final String? hospitalId;
  final String specialtyId;

  final String email;
  final String firstName;
  final String lastName;

  final String? phone;
  final String? primaryPhone;
  final String? secondaryPhone;
  final String? gender;

  final String? bio;
  final String consultationType;
  final String? languagesSpoken;

  final int? yearsOfExperience;
  final int? sessionDurationMinutes;

  final bool emailVerified;
  final bool verified;
  final bool suspended;

  final DateTime createdAt;

  final List<SpecialistAvailabilityModel> availability;

  final String? country;
  final String? imageUrl;
  final String? licenseUrl;
  final String? timeZone;
  final String? address;
  final String? city;
  final String? state;

  SpecialistProfileModel({
    required this.id,
    required this.userId,
    this.hospitalId,
    required this.specialtyId,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.bio,
    required this.consultationType,
    this.languagesSpoken,
    this.yearsOfExperience,
    this.sessionDurationMinutes,
    required this.emailVerified,
    required this.verified,
    required this.suspended,
    required this.createdAt,
    required this.availability,
    this.phone,
    this.primaryPhone,
    this.secondaryPhone,
    this.gender,

    // NEW
    this.country,
    this.imageUrl,
    this.licenseUrl,
    this.timeZone,
    this.address,
    this.city,
    this.state,
  });

  factory SpecialistProfileModel.fromJson(Map<String, dynamic> json) {
    return SpecialistProfileModel(
      id: json['id'],
      userId: json['user_id'],
      hospitalId: json['hospital_id'],
      specialtyId: json['specialty_id'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      phone: json['phone'],
      primaryPhone: json['primary_phone'],
      secondaryPhone: json['secondary_phone'],
      gender: json['gender'],
      bio: json['bio'],
      consultationType: json['consultation_type'],
      languagesSpoken: json['languages_spoken'],
      yearsOfExperience: json['years_of_experience'] ?? 0,
      sessionDurationMinutes: json['session_duration_minutes'] ?? 0,
      emailVerified: json['email_verified'] ?? false,
      verified: json['verified'] ?? false,
      suspended: json['suspended'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      availability: (json['availability'] as List<dynamic>? ?? [])
          .map((e) => SpecialistAvailabilityModel.fromJson(e))
          .toList(),

      // NEW
      country: json['country'],
      imageUrl: json['image_url'],
      licenseUrl: json['license_url'],
      timeZone: json['time_zone'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'hospital_id': hospitalId,
      'specialty_id': specialtyId,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'primary_phone': primaryPhone,
      'secondary_phone': secondaryPhone,
      'gender': gender,
      'bio': bio,
      'consultation_type': consultationType,
      'languages_spoken': languagesSpoken,
      'years_of_experience': yearsOfExperience,
      'session_duration_minutes': sessionDurationMinutes,
      'email_verified': emailVerified,
      'verified': verified,
      'suspended': suspended,
      'created_at': createdAt.toIso8601String(),
      'availability': availability.map((e) => e.toJson()).toList(),

      // NEW
      'country': country,
      'image_url': imageUrl,
      'license_url': licenseUrl,
      'time_zone': timeZone,
      'address': address,
      'city': city,
      'state': state,
    };
  }

  @override
  String toString() {
    return 'SpecialistProfileModel('
        'id: $id, '
        'name: $firstName $lastName, '
        'email: $email, '
        'verified: $verified, '
        'suspended: $suspended, '
        'experience: ${yearsOfExperience ?? 0} yrs'
        ')';
  }
}

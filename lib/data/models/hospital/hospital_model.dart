import 'package:HealthBridge/data/dataSource/secureData/secure_storage.dart';

/// acceptingDonors, accreditationDocUrl, address, city, country, createdAt,
/// donatingOperatingHours, email, emergencyPhone, hasBloodBank, hospitalType,
/// id, licenseNumber, licenseStatus, name, primaryPhone, bloodInventory
class HospitalModel implements JsonSerializable {
  final bool acceptingDonors;
  final String? accreditationDocUrl;
  final String? profileImage;
  final String address;
  final String city;
  final String country;
  final String? state;
  final DateTime createdAt;
  final String donatingOperatingHours;
  final String email;
  final String? emergencyPhone;
  final bool hasBloodBank;
  final String? hospitalType;
  final String id;
  final String licenseNumber;
  final bool licenseStatus;
  final String name;
  final String primaryPhone;
  final List<BloodInventory> bloodInventory;

  HospitalModel({
    required this.acceptingDonors,
    this.accreditationDocUrl,
    this.profileImage,
    required this.address,
    required this.city,
    required this.country,
    this.state,
    required this.createdAt,
    required this.donatingOperatingHours,
    required this.email,
    this.emergencyPhone,
    required this.hasBloodBank,
    this.hospitalType,
    required this.id,
    required this.licenseNumber,
    required this.licenseStatus,
    required this.name,
    required this.primaryPhone,
    required this.bloodInventory,
  });

  factory HospitalModel.fromJson(Map<String, dynamic> json) => HospitalModel(
        acceptingDonors: json['accepting_donors'] as bool,
        accreditationDocUrl: json['accreditation_doc_url'] as String?,
        profileImage: json['profile_image'] as String?,
        address: json['address'] as String,
        city: json['city'] as String,
        country: json['country'] as String,
        state: json['state'] as String?,
        createdAt: DateTime.parse(json['created_at'] as String),
        donatingOperatingHours: json['donating_operating_hours'] as String,
        email: json['email'] as String,
        emergencyPhone: json['emergency_phone'] as String?,
        hasBloodBank: json['has_blood_bank'] as bool,
        hospitalType: json['hospital_type'] as String?,
        id: json['id'] as String,
        licenseNumber: json['license_number'] as String,
        licenseStatus: json['license_status'] as bool,
        name: json['name'] as String,
        primaryPhone: json['primary_phone'] as String,
        bloodInventory: (json['blood_inventory'] as List<dynamic>)
            .map((e) => BloodInventory.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'accepting_donors': acceptingDonors,
        'accreditation_doc_url': accreditationDocUrl,
        'address': address,
        'city': city,
        'country': country,
        if (state != null) 'state': state,
        'created_at': createdAt.toIso8601String(),
        'donating_operating_hours': donatingOperatingHours,
        'email': email,
        if (emergencyPhone != null) 'emergency_phone': emergencyPhone,
        'has_blood_bank': hasBloodBank,
        'hospital_type': hospitalType,
        'id': id,
        'license_number': licenseNumber,
        'license_status': licenseStatus,
        'name': name,
        'primary_phone': primaryPhone,
        'blood_inventory': bloodInventory.map((e) => e.toJson()).toList(),
      };
}

class BloodInventory {
  final int bankCapacity;
  final String bloodType;
  final String hospitalId;
  final String id;
  final int unitsAvailable;
  final DateTime updatedAt;

  BloodInventory({
    required this.bankCapacity,
    required this.bloodType,
    required this.hospitalId,
    required this.id,
    required this.unitsAvailable,
    required this.updatedAt,
  });

  factory BloodInventory.fromJson(Map<String, dynamic> json) => BloodInventory(
        bankCapacity: json['bank_capacity'] as int,
        bloodType: json['blood_type'] as String,
        hospitalId: json['hospital_id'] as String,
        id: json['id'] as String,
        unitsAvailable: json['units_available'] as int,
        updatedAt: DateTime.parse(json['updated_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'bank_capacity': bankCapacity,
        'blood_type': bloodType,
        'hospital_id': hospitalId,
        'id': id,
        'units_available': unitsAvailable,
        'updated_at': updatedAt.toIso8601String(),
      };
}

import '../../dataSource/secureData/secure_storage.dart';

// use for both patient and donor since they have the same fields, just different roles
class PatientProfileModel implements JsonSerializable {
  final String id;
  final String email;
  final bool emailVerified;
  final String role;

  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? gender;
  final String? image_url;
  final String? address;

  final DateTime? dob;

  final String? bloodType;
  final String? chronicIllnesses;
  final String? allergies;
  final String? hmoNumber;
  final String? emergencyContactName;
  final String? emergencyContactPhone;
  final String? medicalNotes;

  // NEW
  final String? medications;
  final String? primary_physician;
  final String? existing_conditions;

  PatientProfileModel({
    required this.id,
    required this.email,
    required this.emailVerified,
    required this.role,
    this.firstName,
    this.lastName,
    this.phone,
    this.gender,
    this.image_url,
    this.address,
    this.dob,
    this.bloodType,
    this.chronicIllnesses,
    this.allergies,
    this.hmoNumber,
    this.emergencyContactName,
    this.emergencyContactPhone,
    this.medicalNotes,
    this.medications,
    this.primary_physician,
    this.existing_conditions,
  });

  factory PatientProfileModel.fromJson(Map<String, dynamic> json) {
    return PatientProfileModel(
      id: json['id'],
      email: json['email'],
      emailVerified: json['email_verified'] ?? false,
      role: json['role'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      phone: json['phone'],
      gender: json['gender'],
      image_url: json['image_url'],
      address: json['address'],
      dob: json['dob'] != null ? DateTime.parse(json['dob']) : null,
      bloodType: json['blood_type'],
      chronicIllnesses: json['chronic_illnesses'],
      allergies: json['allergies'],
      hmoNumber: json['hmo_number'],
      emergencyContactName: json['emergency_contact_name'],
      emergencyContactPhone: json['emergency_contact_phone'],
      medicalNotes: json['medical_notes'],

      // NEW
      medications: json['medications'],
      primary_physician: json['primary_physician'] is Map
          ? json['primary_physician']['id']
          : json['primary_physician'],
      existing_conditions: json['existing_conditions'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'email_verified': emailVerified,
      'role': role,
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'gender': gender,
      'image_url': image_url,
      'address': address,
      'dob': dob?.toIso8601String().split('T').first,
      'blood_type': bloodType,
      'chronic_illnesses': chronicIllnesses,
      'allergies': allergies,
      'hmo_number': hmoNumber,
      'emergency_contact_name': emergencyContactName,
      'emergency_contact_phone': emergencyContactPhone,
      'medical_notes': medicalNotes,

      // NEW
      'medications': medications,
      'primary_physician': primary_physician,
      'existing_conditions': existing_conditions,
    };
  }

  @override
  String toString() {
    String display(String? value) =>
        value == null || value.trim().isEmpty ? '-' : value;

    return 'PatientProfileModel('
        'id: $id, '
        'name: ${display(firstName)} ${display(lastName)}, '
        'email: $email, '
        'phone: ${display(phone)}, '
        'gender: ${display(gender)}, '
        'address: ${display(address)}, '
        'dob: ${dob != null ? dob!.toIso8601String().split('T').first : '-'}, '
        'role: $role, '
        'emailVerified: $emailVerified'
        ')';
  }
}

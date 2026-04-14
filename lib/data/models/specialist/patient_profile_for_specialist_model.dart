class PatientProfileForSpecialistModel {
  final PatientDetailForSpecialist profile;
  final List<PatientAppointmentSummary> appointments;
  final List<PatientDonationSummary> donations;

  PatientProfileForSpecialistModel({
    required this.profile,
    required this.appointments,
    required this.donations,
  });

  factory PatientProfileForSpecialistModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    return PatientProfileForSpecialistModel(
      profile: PatientDetailForSpecialist.fromJson(
          data['profile'] as Map<String, dynamic>? ?? {}),
      appointments: (data['appointments'] as List<dynamic>? ?? [])
          .map((e) =>
              PatientAppointmentSummary.fromJson(e as Map<String, dynamic>))
          .toList(),
      donations: (data['donations'] as List<dynamic>? ?? [])
          .map((e) =>
              PatientDonationSummary.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class PatientDetailForSpecialist {
  final String id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? gender;
  final String? dob;
  final String? imageUrl;
  final String? address;
  final String? city;
  final String? state;
  final String? bloodType;
  final String? allergies;
  final String? existingConditions;
  final String? chronicIllnesses;
  final String? medications;
  final String? medicalNotes;
  final String? emergencyContactName;
  final String? emergencyContactPhone;
  final String? hmoNumber;
  final String? primaryPhysician;
  final String? consultationPreference;
  final bool? emailVerified;

  PatientDetailForSpecialist({
    required this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.gender,
    this.dob,
    this.imageUrl,
    this.address,
    this.city,
    this.state,
    this.bloodType,
    this.allergies,
    this.existingConditions,
    this.chronicIllnesses,
    this.medications,
    this.medicalNotes,
    this.emergencyContactName,
    this.emergencyContactPhone,
    this.hmoNumber,
    this.primaryPhysician,
    this.consultationPreference,
    this.emailVerified,
  });

  factory PatientDetailForSpecialist.fromJson(Map<String, dynamic> json) {
    return PatientDetailForSpecialist(
      id: json['id'] as String? ?? '',
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      gender: json['gender'] as String?,
      dob: json['dob'] as String?,
      imageUrl: json['image_url'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      bloodType: json['blood_type'] as String?,
      allergies: json['allergies'] as String?,
      existingConditions: json['existing_conditions'] as String?,
      chronicIllnesses: json['chronic_illnesses'] as String?,
      medications: json['medications'] as String?,
      medicalNotes: json['medical_notes'] as String?,
      emergencyContactName: json['emergency_contact_name'] as String?,
      emergencyContactPhone: json['emergency_contact_phone'] as String?,
      hmoNumber: json['hmo_number'] as String?,
      primaryPhysician: json['primary_physician'] as String?,
      consultationPreference: json['consultation_preference'] as String?,
      emailVerified: json['email_verified'] as bool?,
    );
  }

  String get fullName =>
      '${firstName ?? ''} ${lastName ?? ''}'.trim().isEmpty
          ? 'Patient'
          : '${firstName ?? ''} ${lastName ?? ''}'.trim();

  int? get age {
    if (dob == null) return null;
    try {
      final date = DateTime.parse(dob!);
      return DateTime.now().year - date.year;
    } catch (_) {
      return null;
    }
  }
}

class PatientAppointmentSummary {
  final String? scheduledTime;
  final String? specialistName;
  final String? specialty;
  final String? status;

  PatientAppointmentSummary({
    this.scheduledTime,
    this.specialistName,
    this.specialty,
    this.status,
  });

  factory PatientAppointmentSummary.fromJson(Map<String, dynamic> json) {
    return PatientAppointmentSummary(
      scheduledTime: json['scheduled_time'] as String?,
      specialistName: json['specialist_name'] as String?,
      specialty: json['specialty'] as String?,
      status: json['status'] as String?,
    );
  }
}

class PatientDonationSummary {
  final String? bloodType;
  final String? createdAt;
  final String? hospitalName;
  final String? status;
  final int? units;

  PatientDonationSummary({
    this.bloodType,
    this.createdAt,
    this.hospitalName,
    this.status,
    this.units,
  });

  factory PatientDonationSummary.fromJson(Map<String, dynamic> json) {
    return PatientDonationSummary(
      bloodType: json['blood_type'] as String?,
      createdAt: json['created_at'] as String?,
      hospitalName: json['hospital_name'] as String?,
      status: json['status'] as String?,
      units: json['units'] as int?,
    );
  }
}

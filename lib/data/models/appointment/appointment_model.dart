class AppointmentModel {
  // Core appointment fields
  final String id;
  final String status;
  final String appointmentType;
  final DateTime scheduledTime;
  final DateTime? previousTime;
  final DateTime createdAt;

  // Related IDs (nullable — not all appointment types have all of these)
  final String? bloodRequestId;
  final String? hospitalId;
  final String? specialistId;
  final String? userId;

  // Notes
  final String? notes;

  // Cancellation info
  final DateTime? cancelledAt;
  final String? cancelledBy;
  final String? cancelledById;
  final String? cancelledReason;

  // Enriched from hospital sub-object
  final String? hospitalName;
  final String? hospitalPhone;
  final String? hospitalAddress;
  final String? hospitalProfileImage;

  // Enriched from user sub-object
  final String? userFirstName;
  final String? userLastName;
  final String? userImageUrl;
  final String? userPhone;

  // Enriched from blood_request sub-object
  final String? bloodType;
  final String? bloodRequestRefId;
  final int? bloodUnits;
  final String? bloodRequestStatus;
  final String? urgency;

  // Enriched from specialist sub-object
  final String? specialistFirstName;
  final String? specialistLastName;
  final String? specialistImageUrl;
  final String? specialistPhone;

  AppointmentModel({
    required this.id,
    required this.status,
    required this.appointmentType,
    required this.scheduledTime,
    this.previousTime,
    required this.createdAt,
    this.bloodRequestId,
    this.hospitalId,
    this.specialistId,
    this.userId,
    this.notes,
    this.cancelledAt,
    this.cancelledBy,
    this.cancelledById,
    this.cancelledReason,
    // hospital
    this.hospitalName,
    this.hospitalPhone,
    this.hospitalAddress,
    this.hospitalProfileImage,
    // user
    this.userFirstName,
    this.userLastName,
    this.userImageUrl,
    this.userPhone,
    // blood_request
    this.bloodType,
    this.bloodRequestRefId,
    this.bloodUnits,
    this.bloodRequestStatus,
    this.urgency,
    // specialist
    this.specialistFirstName,
    this.specialistLastName,
    this.specialistImageUrl,
    this.specialistPhone,
  });

  /// Full name of the user/patient associated with this appointment.
  String get userName {
    final first = userFirstName ?? '';
    final last = userLastName ?? '';
    final full = '$first $last'.trim();
    return full.isNotEmpty ? full : 'Unknown';
  }

  /// Full name of the specialist associated with this appointment.
  String get specialistName {
    final first = specialistFirstName ?? '';
    final last = specialistLastName ?? '';
    final full = '$first $last'.trim();
    return full.isNotEmpty ? full : 'Unknown';
  }

  /// All endpoints return the nested format:
  /// { "appointment": {...}, "blood_request": {...}, "hospital": {...}, "specialist": {...}, "user": {...} }
  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    // If top-level has 'appointment' key, extract it; otherwise treat json itself as the appointment object
    final appt = (json['appointment'] as Map<String, dynamic>?) ?? json;
    final hospital = json['hospital'] as Map<String, dynamic>?;
    final user = json['user'] as Map<String, dynamic>?;
    final bloodRequest = json['blood_request'] as Map<String, dynamic>?;
    final specialist = json['specialist'] as Map<String, dynamic>?;

    return AppointmentModel(
      id: appt['id'],
      status: appt['status'] ?? 'created',
      appointmentType: appt['appointment_type'] ?? '',
      scheduledTime: DateTime.parse(appt['scheduled_time']),
      previousTime: appt['previous_time'] != null
          ? DateTime.parse(appt['previous_time'])
          : null,
      createdAt: DateTime.parse(appt['created_at']),
      bloodRequestId: appt['blood_request_id'],
      hospitalId: appt['hospital_id'],
      specialistId: appt['specialist_id'],
      userId: appt['user_id'],
      notes: appt['notes'],
      cancelledAt: appt['cancelled_at'] != null
          ? DateTime.parse(appt['cancelled_at'])
          : null,
      cancelledBy: appt['cancelled_by'],
      cancelledById: appt['cancelled_by_id'],
      cancelledReason: appt['cancelled_reason'],
      // hospital
      hospitalName: hospital?['name'],
      hospitalPhone: hospital?['primary_phone'],
      hospitalAddress: hospital?['address'],
      hospitalProfileImage: hospital?['profile_image'],
      // user
      userFirstName: user?['first_name'],
      userLastName: user?['last_name'],
      userImageUrl: user?['image_url'],
      userPhone: user?['phone'],
      // blood_request
      bloodType: bloodRequest?['blood_type'],
      bloodRequestRefId: bloodRequest?['ref_id'],
      bloodUnits: bloodRequest?['units'],
      bloodRequestStatus: bloodRequest?['request_status'],
      urgency: bloodRequest?['urgency'],
      // specialist
      specialistFirstName: specialist?['first_name'],
      specialistLastName: specialist?['last_name'],
      specialistImageUrl: specialist?['image_url'],
      specialistPhone: specialist?['phone'],
    );
  }
}

/*
 {
      "appointment": {
        "appointment_type": "donor",
        "blood_request_id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
        "cancelled_at": "2026-04-02T16:59:50.031Z",
        "cancelled_by": null,
        "cancelled_by_id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
        "cancelled_reason": "string",
        "created_at": "2026-04-02T16:59:50.031Z",
        "hospital_id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
        "id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
        "previous_time": "2026-04-02T16:59:50.031Z",
        "scheduled_time": "2026-04-02T16:59:50.031Z",
        "specialist_id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
        "status": "created",
        "user_id": "3fa85f64-5717-4562-b3fc-2c963f66afa6"
        "notes": null   // Newly added
      },
      "blood_request": {
        "administered_at": "2026-04-02T16:59:50.031Z",
        "blood_type": null,
        "cancelled_at": "2026-04-02T16:59:50.031Z",
        "cancelled_by": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
        "cancelled_reason": "string",
        "created_at": "2026-04-02T16:59:50.031Z",
        "donated_at": "2026-04-02T16:59:50.031Z",
        "donor_id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
        "hospital_id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
        "id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
        "note": "string",
        "preferred_time": "2026-04-02T16:59:50.031Z",
        "recipient_id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
        "ref_id": "string",
        "request_reason": "string",
        "request_status": null,
        "timeline_status": null,
        "units": 1073741824,
        "urgency": null
      },
      "hospital": {
        "accepting_donors": true,
        "accreditation_doc_url": "string",
        "address": "string",
        "city": "string",
        "country": "string",
        "created_at": "2026-04-02T16:59:50.031Z",
        "deleted_at": "2026-04-02T16:59:50.031Z",
        "donating_operating_hours": "string",
        "email": "string",
        "email_verified": true,
        "emergency_phone": "string",
        "has_blood_bank": true,
        "hospital_type": null,
        "id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
        "license_number": "string",
        "license_status": true,
        "name": "string",
        "primary_phone": "string",
        "profile_image": "string",
        "state": "string",
        "user_id": "3fa85f64-5717-4562-b3fc-2c963f66afa6"
      },
      "specialist": {
        "address": "string",
        "city": "string",
        "consultation_preference": null,
        "country": "string",
        "created_at": "2026-04-02T16:59:50.031Z",
        "deleted_at": "2026-04-02T16:59:50.031Z",
        "dob": "2026-04-02",
        "eligible_to_donate": true,
        "email": "string",
        "email_verified": true,
        "first_name": "string",
        "gender": null,
        "id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
        "image_url": "string",
        "last_name": "string",
        "note": "string",
        "phone": "string",
        "role": "patient",
        "state": "string"
      },
      "specialist_info": null,
      "specialty": null,
      "user": {
        "address": "string",
        "city": "string",
        "consultation_preference": null,
        "country": "string",
        "created_at": "2026-04-02T16:59:50.031Z",
        "deleted_at": "2026-04-02T16:59:50.031Z",
        "dob": "2026-04-02",
        "eligible_to_donate": true,
        "email": "string",
        "email_verified": true,
        "first_name": "string",
        "gender": null,
        "id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
        "image_url": "string",
        "last_name": "string",
        "note": "string",
        "phone": "string",
        "role": "patient",
        "state": "string"
      }
    }
 */

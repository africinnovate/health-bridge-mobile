class HospitalNotificationM {
  final bool accountNotifications;
  final bool donationRequests;
  final bool donorAppointmentReminders;
  final bool emailNotifications;
  final bool loginAlerts;
  final bool newDonorAppointments;
  final bool pushNotifications;
  final bool smsNotifications;

  final String hospitalId;
  final String id;

  final DateTime createdAt;
  final DateTime updatedAt;

  HospitalNotificationM({
    required this.accountNotifications,
    required this.donationRequests,
    required this.donorAppointmentReminders,
    required this.emailNotifications,
    required this.loginAlerts,
    required this.newDonorAppointments,
    required this.pushNotifications,
    required this.smsNotifications,
    required this.hospitalId,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  factory HospitalNotificationM.fromJson(Map<String, dynamic> json) {
    return HospitalNotificationM(
      accountNotifications: json['account_notifications'] as bool,
      donationRequests: json['donation_requests'] as bool,
      donorAppointmentReminders: json['donor_appointment_reminders'] as bool,
      emailNotifications: json['email_notifications'] as bool,
      loginAlerts: json['login_alerts'] as bool,
      newDonorAppointments: json['new_donor_appointments'] as bool,
      pushNotifications: json['push_notifications'] as bool,
      smsNotifications: json['sms_notifications'] as bool,
      hospitalId: json['hospital_id'] as String,
      id: json['id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'account_notifications': accountNotifications,
        'donation_requests': donationRequests,
        'donor_appointment_reminders': donorAppointmentReminders,
        'email_notifications': emailNotifications,
        'login_alerts': loginAlerts,
        'new_donor_appointments': newDonorAppointments,
        'push_notifications': pushNotifications,
        'sms_notifications': smsNotifications,
        'hospital_id': hospitalId,
        'id': id,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };
}

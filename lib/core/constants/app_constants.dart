class AppConstants {
  // App Info
  static const String appName = 'HealthBridge';
  // static const String appTagline = 'Need it fast? Just Zap it!';

  // Local API Configuration - Android emulator uses 10.0.2.2 instead of localhost
  // static const String baseUrl = 'http://10.0.2.2:5001/api/v1';
  // static const String deliveryBaseUrl = 'http://10.0.2.2:5003/api/v1';
  // static const String notificationBaseUrl = 'http://10.0.2.2:5002/api/v1';
  // static const String paymentBaseUrl = 'http://10.0.2.2:5004/api/v1';
  // static const String organizationBaseUrl = 'http://10.0.2.2:5005/api/v1';

  // Remote API Configuration
  static const String baseUrl = 'https://healthbridge.africinnovate.com';

  // API Endpoints
  static const String authenticationEndpoint = '/authentication';

  /// /api/auth/register
  static const String registerEndpoint = '/api/auth/register';

  /// /api/auth/login
  static const String loginEndpoint = '/api/auth/login';

  /// /api/auth/verify-email
  static const String verifyEmailOtpEndpoint = '/api/auth/verify-email';

  /// /api/auth/resend-verification-code
  static const String resendOtpEndpoint = '/api/auth/resend-verification-code';

  /// /api/auth/refresh-token
  static const String refreshTokenEndpoint = '/api/auth/refresh-token';

  /// /api/auth/logout
  static const String logoutEndpoint = '/api/auth/logout';

  /// /api/auth/forgot-password
  static const String forgotPasswordEndpoint = '/api/auth/forgot-password';

  /// /api/auth/reset-password (with code from email)
  static const String resetPasswordWithCodeEndpoint =
      '/api/auth/reset-password';

  /// /api/auth/update-password (for authenticated users)
  static const String resetPasswordEndpoint = '/api/auth/update-password';
  static const String profileEndpoint = '/profile/';
  static const String profileExportEndpoint = '/profile/export';
  static const String deliveriesEndpoint = '/delivery';
  static const String credentialsEndpoint = '/credential';

  static const int errorCode = 404;
  static const int serverErrorCode = 505;
  static const int databaseErrorCode = 507;
  static const int networkErrorCode = 510;
  static const int successCode = 200;

  /// /api/patients/profile
  static const String patientProfileEP = '/api/patients/profile';

  /// /api/patients/medical-info
  static const String patientMedicalInfoEP = '/api/patients/medical-info';

  /// /api/specialists/{id}
  static const String specialistProfileEP = '/api/specialists';

  /// /api/specialists/specialties
  static const String specialtiesEP = '/api/specialists/specialties';

  /// /api/hospitals - get all hospitals
  static const String allHospitalsEP = '/api/hospitals';

  /// /api/hospitals/nearby - get nearby hospital
  static const String nearbyHospitalsEP = '/api/hospitals/nearby';

  /// /api/hospitals/{hospital_id}
  static const String hospitalProfileByIdEP = '/api/hospitals';
  static const String hospitalProfileEP = '/api/hospitals/me';

  /// /api/appointments
  static const String appointmentsEP = '/api/appointments';

  /// /api/appointments/reschedule/{appointment_id}
  static const String appointmentRescheduleEP = '/api/appointments/reschedule';

  /// /api/appointments/cancel/{appointment_id}
  static const String appointmentCancelEP = '/api/appointments/cancel';

  /// /api/appointments/confirm/{appointment_id}
  static const String appointmentConfirmEP = '/api/appointments/confirm';

  /// /api/hospitals/create
  static const String createHospitalEP = "/api/hospitals/create";

  /// /api/hospitals/settings/{hospital_id}  -get hospital notification settings
  static const String hospitalNotificationSettingEP = "/api/hospitals/settings";

  /// /api/hospitals/blood-request - get and create blood requests
  static const String bloodRequestEP = "/api/hospitals/blood-request";

  /// /api/hospitals/inventory/{hospital_id}/{blood_type} - update blood inventory units
  static const String updateBloodInventoryEP = "/api/hospitals/inventory";

  /// /api/hospitals/dashboard/stats - get hospital dashboard stats
  static const String hospitalDashboardStatsEP =
      "/api/hospitals/dashboard/stats";

  /// /api/hospitals/dashboard/recent-activity - get hospital recent activity
  static const String hospitalRecentActivityEP =
      "/api/hospitals/dashboard/recent-activity";

  /// /api/hospitals/donors - get donor list
  static const String hospitalDonorsEP = "/api/hospitals/donors";

  /// /api/hospitals/blood-request/donor-stats/{donor_id} - get donor stats
  static const String donorStatsEP = "/api/hospitals/blood-request/donor-stats";

  /// /api/hospitals/blood-request/donor-history/{donor_id} - get donor donation history
  static const String donorHistoryEP =
      "/api/hospitals/blood-request/donor-history";

  /// /api/hospitals/donors/{donor_id} - update donor notes and eligibility
  static const String updateDonorEP = "/api/hospitals/donors";

  /// /api/user-settings/preference - get and update consultation preference
  static const String consultationPreferenceEP = "/api/user-settings/preference";

  /// /api/user-settings - get and update user notification settings
  static const String userSettingsEP = "/api/user-settings";

  // // OTP
  static const int otpLength = 4;
  static const int otpResendDelay = 60; // seconds
  //
  static const String appointmentRequest = "appointmentRequest";
  static const String upcomingAppointment = "upcomingAppointment";

  // Validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 32;
  static const int minNameLength = 2;
  static const int maxNameLength = 50;

  static const String login = "login";
  static const String register = "register";

  static const String emailUnverified = "email is not verified yet";
  static const String specialistNotFound = "Specialist not found";
  static const String invalidOrExpiredToken = "Invalid or expired token";
  static const String emailUnverified2 = "Email not verified";
}

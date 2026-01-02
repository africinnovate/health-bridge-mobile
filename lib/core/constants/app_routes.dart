class AppRoutes {
  // Initial Route
  static const String splash = '/';

  // Auth Routes
  static const String onboarding = '/onboarding';
  static const String preference = '/preference';
  static const String createAccount = '/create-account';
  static const String login = '/login';
  static const String verifyOtp = '/verify-otp';
  static const String setPassword = '/set-password';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';

  // Profile Routes
  static const String setProfilePatient = '/set-profile-patient';
  static const String setProfileHospital = '/set-profile-hospital';
  static const String setProfileDonor = '/set-profile-donor';
  static const String setProfileSpecialist = '/set-profile-specialist';
  static const String patientConsent = '/patient_consent';
  static const String hospitalComplete = '/hospital-complete-profile';
  static const String availabilitySpecialist = '/availability-specialist';

  // blood services
  static const String bloodServiceHospital = '/blood-service-hospital';
  static const String bloodDonorList = '/blood-donor-list';
  static const String bloodRequestDetails = '/blood-request-details';

  static const String notificationsHospital = '/notifications-hospital';

  // hospital
  static const String hospitalRootScreen = '/hospital-root-home';
  static const String newBloodRequest = '/new-blood-request';
  static const String requestDetails = '/request-details';
  static const String donationAppointmentDetail = '/donation-appointment-detail';
  static const String rescheduleAppointment = '/reschedule-appointment';
  static const String recordDonation = '/record-donation';
  static const String updateUnits = '/update-units';
  static const String donorList = '/donor-list';
  static const String hospitalNotification = '/hospital-notification';

  // Main App Routes
  static const String dashboardHospital = '/dashboard-hospital';
  static const String dashboardPatient = '/dashboard-patient';

  // patient
  static const String patientRootScreen = '/patient-root-home';
  static const String patientAppointmentDetail = '/patient-appointment-detail';
  static const String patientAppointmentRescheduled =
      '/patient-appointment-rescheduled';
  static const String patientNotification = '/patient-notification';
  static const String specialistDetails = '/specialist-details';
  static const String describeSymptoms = '/describe-symptoms';
  static const String filters = '/filters';
  static const String filterResults = '/filter-results';
  static const String pickDateTime = '/pick-date-time';
  static const String editProfilePatient = '/edit-profile-patient';
  static const String personalInfoPatient = '/personal-info-patient';
  static const String medicalInfoPatient = '/medical-info-patient';
  static const String consultationPreferencePatient =
      '/consultation-preference-patient';
  static const String notificationSettingsPatient =
      '/notification-settings-patient';
  static const String languageSettingsPatient = '/language-settings-patient';
  static const String privacySettingsPatient = '/privacy-settings-patient';
  static const String careHistory = '/care-history';
  static const String helpCenterPatient = '/help-center-patient';
  static const String faqsPatient = '/faqs-patient';
  static const String contactSupportPatient = '/contact-support-patient';
  static const String changePasswordPatient = '/change-password-patient';
  static const String linkedAccountsPatient = '/linked-accounts-patient';
  static const String dashboardDonor = '/dashboard-donor';
  static const String dashboardSpecialist = '/dashboard-specialist';

  // donor
  static const String donorRootScreen = '/donor-root-home';
  static const String nearbyHospitals = '/nearby-hospitals';
  static const String bloodRequestBooking = '/blood-request-booking';
  static const String donorNotification = '/donor-notification';
  static const String donorAppointmentDetail = '/donor-appointment-detail';
  static const String donorAppointmentRescheduled = '/donor-appointment-rescheduled';
  static const String donationDetails = '/donation-details';
  static const String donationReceipt = '/donation-receipt';
  static const String editProfileDonor = '/edit-profile-donor';
  static const String editPersonalInfoDonor = '/edit-personal-info-donor';
  static const String editMedicalInfoDonor = '/edit-medical-info-donor';
  static const String consultationPreference = '/consultation-preference';
  static const String notificationSettings = '/notification-settings';
  static const String languageSettings = '/language-settings';
  static const String privacySettings = '/privacy-settings';
  static const String helpCenter = '/help-center';
  static const String faqs = '/faqs';
  static const String contactSupport = '/contact-support';
  static const String changePassword = '/change-password';
  static const String linkedAccounts = '/linked-accounts';
  static const String donationHistory = '/donation-history';
  static const String appointments = '/appointments';

  // Specialist
  static const String specialistRootScreen = '/specialist-root-home';
  static const String specialistAppointDetailScreen = '/specialist-appointment';
  static const String specialistRequestScreen = '/specialist-request';
  static const String rescheduleOnSpecialist = '/reschedule-appoint';
  static const String appointmentTapOnSpecialist =
      '/appointment-tapOn-specialist';
  static const String specialistProfile = '/specialist-profile';
  static const String patientProfileOnSpecialist = '/patient_profile-appoint';
  static const String editPersonalSpecialist = '/edit_personal_specialist';
  static const String homeSpecialist = '/home-specialist';
  // static const String rescheduleOnSpecialist = '/reschedule-appoint';
  // static const String rescheduleOnSpecialist = '/reschedule-appoint';
  // static const String rescheduleOnSpecialist = '/reschedule-appoint';
}

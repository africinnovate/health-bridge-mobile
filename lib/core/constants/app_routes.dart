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

  // blood services
  static const String bloodServiceHospital = '/blood-service-hospital';
  static const String bloodDonorList = '/blood-donor-list';
  static const String bloodRequestDetails = '/blood-request-details';

  static const String notificationsHospital = '/notifications-hospital';

  // Main App Routes
  static const String dashboardHospital = '/dashboard-hospital';
  static const String dashboardPatient = '/dashboard-patient';
  static const String dashboardDonor = '/dashboard-donor';
  static const String dashboardSpecialist = '/dashboard-specialist';

  // Payment
  static const String addPaymentMethod = '/add-payment-method';
  static const String billingManagement = '/billing-management';
}

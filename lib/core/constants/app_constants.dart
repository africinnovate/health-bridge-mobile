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
  static const String registerEndpoint = '/api/auth/register';
  static const String loginEndpoint = '/api/auth/login';
  static const String verifyOtpEndpoint = '/authentication/verify/email';
  static const String resendOtpEndpoint = '/authentication/verify/resend';
  static const String refreshTokenEndpoint = '/authentication/token';
  static const String logoutEndpoint = '/authentication/logout';
  static const String profileEndpoint = '/profile/';
  static const String profileExportEndpoint = '/profile/export';
  static const String deliveriesEndpoint = '/delivery';
  static const String credentialsEndpoint = '/credential';

  static const int errorCode = 404;
  static const int serverErrorCode = 505;
  static const int databaseErrorCode = 507;
  static const int networkErrorCode = 510;
  static const int successCode = 200;

  // Storage Keys
  // static const String tokenKey = 'auth_token';
  // static const String refreshTokenKey = 'refresh_token';
  // static const String userKey = 'user_data';
  // static const String isLoggedInKey = 'is_logged_in';
  // static const String onboardingCompleteKey = 'onboarding_complete';
  // static const String apiKeyKey = 'active_api_key';
  // static const String apiKeyEnvironmentKey = 'api_key_environment';
  //
  // // Timeouts
  // static const int connectionTimeout = 30000; // 30 seconds
  // static const int receiveTimeout = 30000; // 30 seconds
  //
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
}

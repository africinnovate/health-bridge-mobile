import 'package:HealthBridge/core/constants/app_constants.dart';
import 'package:HealthBridge/data/dataSource/remoteApi/auth_api.dart';
import 'package:HealthBridge/data/dataSource/remoteApi/hospital_api.dart';
import 'package:HealthBridge/data/dataSource/remoteApi/notification_api.dart';
import 'package:HealthBridge/data/dataSource/remoteApi/patient_api.dart';
import 'package:HealthBridge/data/dataSource/remoteApi/specialist_api.dart';
import 'package:HealthBridge/data/repositories/hospital_repository.dart';
import 'package:HealthBridge/data/repositories/notification_repository.dart';
import 'package:HealthBridge/data/repositories/specialist_repository.dart';
import 'package:HealthBridge/presentation/providers/appointment_provider.dart';
import 'package:HealthBridge/presentation/providers/blood_request_provider.dart';
import 'package:HealthBridge/presentation/providers/hospital_provider.dart';
import 'package:HealthBridge/presentation/providers/notification_provider.dart';
import 'package:HealthBridge/presentation/providers/patient_provider.dart';
import 'package:HealthBridge/presentation/providers/specialist_provider.dart';

import '../../data/dataSource/remoteApi/appointment_api.dart';
import '../../data/dataSource/secureData/secure_storage.dart';
import '../../data/repositories/appointment_repository.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/patient_repository.dart';
import '../../presentation/providers/auth_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/network/api_client.dart';

class Injection {
  static late final SharedPreferences _sharedPreferences;
  static late final FlutterSecureStorage _secureStorage;
  static late final ApiClient _apiClient;

  // =============  Data sources - Api and Local
  static late final AuthApi _authApi;
  static late final PatientApi _patientApi;
  static late final SpecialistApi _specialistApi;
  static late final HospitalApi _hospitalApi;
  static late final AppointmentApi _appointmentApi;
  static late final NotificationApi _notificationApi;

  // =============  Repositories
  static late final AuthRepository _authRepository;
  static late final PatientRepository _patientRepository;
  static late final SpecialistRepository _specialistRepository;
  static late final HospitalRepository _hospitalRepository;
  static late final AppointmentRepository _appointmentRepository;
  static late final NotificationRepository _notificationRepository;

  // =============  Providers
  static late final AuthProvider authProvider;
  static late final PatientProvider patientProvider;
  static late final SpecialistProvider specialistProvider;
  static late final HospitalProvider hospitalProvider;
  static late final AppointmentProvider appointmentProvider;
  static late final BloodRequestProvider bloodRequestProvider;
  static late final NotificationProvider notificationProvider;

  /// initialise all dependencies
  static Future<void> init() async {
    // Core
    _sharedPreferences = await SharedPreferences.getInstance();
    _secureStorage = const FlutterSecureStorage();
    _apiClient = ApiClient(baseUrl: AppConstants.baseUrl);

    // =============  Data sources - Api and Local
    _authApi = AuthApi(apiClient: _apiClient);
    _patientApi = PatientApi(apiClient: apiClient);
    _specialistApi = SpecialistApi(apiClient: apiClient);
    _hospitalApi = HospitalApi(apiClient: apiClient);
    _appointmentApi = AppointmentApi(apiClient: apiClient);
    _notificationApi = NotificationApi(apiClient: apiClient);

    // =============  Repositories
    _authRepository = AuthRepository(
      authApi: _authApi,
      secureStorage: _secureStorage,
    );
    _patientRepository = PatientRepository(patientApi: _patientApi);
    _specialistRepository = SpecialistRepository(specialistApi: _specialistApi);
    _hospitalRepository = HospitalRepository(hospitalApi: _hospitalApi);
    _appointmentRepository =
        AppointmentRepository(appointmentApi: _appointmentApi);
    _notificationRepository =
        NotificationRepository(notificationApi: _notificationApi);

    // =============  Providers
    authProvider = AuthProvider(authRepository: _authRepository);
    patientProvider = PatientProvider(patientRepository: _patientRepository);
    specialistProvider = SpecialistProvider(
      specialistRepository: _specialistRepository,
    );
    hospitalProvider = HospitalProvider(
      hospitalRepository: _hospitalRepository,
    );
    appointmentProvider = AppointmentProvider(
      appointmentRepository: _appointmentRepository,
    );
    bloodRequestProvider = BloodRequestProvider(
      hospitalRepository: _hospitalRepository,
    );
    notificationProvider = NotificationProvider(
      notificationRepository: _notificationRepository,
    );

    // Initialize auth provider (will also load credentials if already logged in)
    // await authProvider.initialize();
  }

  // Getters for dependencies if needed elsewhere
  static ApiClient get apiClient => _apiClient;
  static SharedPreferences get sharedPreferences => _sharedPreferences;
  static FlutterSecureStorage get secureStorage => _secureStorage;

  static Future<Map<String, String>> tokenHeaders() async {
    var getAuth = await SecureStorage.getAuthData();
    var token = getAuth?.token;
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }
}

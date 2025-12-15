import 'package:HealthBridge/core/constants/app_constants.dart';
import 'package:HealthBridge/data/dataSource/remoteApi/auth_api.dart';

import '../../data/repositories/auth_repository.dart';
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

  // =============  Repositories
  static late final AuthRepository _authRepository;

  // =============  Providers
  static late final AuthProvider authProvider;

  static Future<void> init() async {
    // Core
    _sharedPreferences = await SharedPreferences.getInstance();
    _secureStorage = const FlutterSecureStorage();
    _apiClient = ApiClient(baseUrl: AppConstants.baseUrl);

    // =============  Data sources - Api and Local
    _authApi = AuthApi(apiClient: _apiClient);

    // =============  Repositories
    _authRepository = AuthRepository(
      authApi: _authApi,
      secureStorage: _secureStorage,
    );

    // =============  Providers
    authProvider = AuthProvider(
      authRepository: _authRepository,
    );

    // Initialize auth provider (will also load credentials if already logged in)
    // await authProvider.initialize();
  }

  // Getters for dependencies if needed elsewhere
  static ApiClient get apiClient => _apiClient;
  static SharedPreferences get sharedPreferences => _sharedPreferences;
  static FlutterSecureStorage get secureStorage => _secureStorage;
}

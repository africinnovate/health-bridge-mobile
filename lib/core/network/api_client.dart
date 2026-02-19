import 'dart:convert';
import 'package:HealthBridge/core/constants/app_constants.dart';
import 'package:HealthBridge/data/dataSource/secureData/secure_storage.dart';
import 'package:HealthBridge/data/models/auth/auth_model.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl;
  bool _isRefreshing = false;

  ApiClient({required this.baseUrl});

  // ---------- GET ----------
  Future<http.Response> get(
    String endpoint, {
    Map<String, String>? query,
    Map<String, String>? headers,
  }) async {
    print("General log: GET ======================================");
    print("General log: the endpoint is - $endpoint");
    final uri = Uri.parse('$baseUrl$endpoint').replace(queryParameters: query);

    var response = await http.get(uri, headers: headers ?? _defaultHeaders());

    // Handle 401 - Token expired
    if (response.statusCode == 401 && !_isRefreshing) {
      final refreshed = await _refreshTokenAndRetry(headers);
      if (refreshed) {
        // Retry the request with new token
        final newHeaders = await _getUpdatedHeaders(headers);
        response = await http.get(uri, headers: newHeaders);
      }
    }

    return response;
  }

  // ---------- POST ----------
  Future<http.Response> post(
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, String>? query,
    Map<String, String>? headers,
  }) async {
    print("General log: POST  ======================================");
    print("General log: the endpoint is - $endpoint");
    print("General log: the data is - $data");

    final uri = Uri.parse('$baseUrl$endpoint').replace(queryParameters: query);

    var response = await http.post(
      uri,
      headers: headers ?? _defaultHeaders(),
      body: json.encode(data),
    );

    // Handle 401 - Token expired (skip for refresh-token endpoint itself)
    if (response.statusCode == 401 &&
        !_isRefreshing &&
        endpoint != AppConstants.refreshTokenEndpoint) {
      final refreshed = await _refreshTokenAndRetry(headers);
      if (refreshed) {
        // Retry the request with new token
        final newHeaders = await _getUpdatedHeaders(headers);
        response = await http.post(
          uri,
          headers: newHeaders,
          body: json.encode(data),
        );
      }
    }

    return response;
  }

  // ---------- PUT ----------
  Future<http.Response> put(
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, String>? query,
    Map<String, String>? headers,
  }) async {
    print("General log: PUT ======================================");
    print("General log: the endpoint is - $endpoint");
    print("General log: the data is - $data");

    final uri = Uri.parse('$baseUrl$endpoint').replace(queryParameters: query);

    var response = await http.put(
      uri,
      headers: headers ?? _defaultHeaders(),
      body: json.encode(data),
    );

    // Handle 401 - Token expired
    if (response.statusCode == 401 && !_isRefreshing) {
      final refreshed = await _refreshTokenAndRetry(headers);
      if (refreshed) {
        // Retry the request with new token
        final newHeaders = await _getUpdatedHeaders(headers);
        response = await http.put(
          uri,
          headers: newHeaders,
          body: json.encode(data),
        );
      }
    }

    return response;
  }

  // ---------- PATCH ----------
  Future<http.Response> patch(
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, String>? query,
    Map<String, String>? headers,
  }) async {
    print("General log: PATCH ======================================");
    print("General log: the endpoint is - $endpoint");
    print("General log: the data is - $data");

    final uri = Uri.parse('$baseUrl$endpoint').replace(queryParameters: query);

    var response = await http.patch(
      uri,
      headers: headers ?? _defaultHeaders(),
      body: json.encode(data),
    );

    // Handle 401 - Token expired
    if (response.statusCode == 401 && !_isRefreshing) {
      final refreshed = await _refreshTokenAndRetry(headers);
      if (refreshed) {
        // Retry the request with new token
        final newHeaders = await _getUpdatedHeaders(headers);
        response = await http.patch(
          uri,
          headers: newHeaders,
          body: json.encode(data),
        );
      }
    }

    return response;
  }

  // ---------- MULTIPART UPLOAD ----------
  Future<http.Response> uploadFile(
    String endpoint, {
    required String filePath,
    required String fieldName,
    Map<String, String>? additionalFields,
    Map<String, String>? headers,
  }) async {
    print("General log: UPLOAD ======================================");
    print("General log: the endpoint is - $endpoint");
    print("General log: the file path is - $filePath");

    final uri = Uri.parse('$baseUrl$endpoint');
    final request = http.MultipartRequest('POST', uri);

    // Add headers
    final uploadHeaders = headers ?? _defaultHeaders();
    // Remove Content-Type for multipart - http will set it with boundary
    uploadHeaders.remove('Content-Type');
    request.headers.addAll(uploadHeaders);

    // Add file
    final file = await http.MultipartFile.fromPath(fieldName, filePath);
    request.files.add(file);

    // Add additional fields
    if (additionalFields != null) {
      request.fields.addAll(additionalFields);
    }

    // Send request
    var response = await request.send();

    return http.Response.fromStream(response);
  }

  // ---------- DELETE ----------
  Future<http.Response> delete(
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, String>? query,
    Map<String, String>? headers,
  }) async {
    print("General log: DELETE ======================================");
    print("General log: the endpoint is - $endpoint");
    print("General log: the data is - $data");

    final uri = Uri.parse('$baseUrl$endpoint').replace(queryParameters: query);

    var response = await http.delete(
      uri,
      headers: headers ?? _defaultHeaders(),
      body: data != null ? json.encode(data) : null,
    );

    // Handle 401 - Token expired
    if (response.statusCode == 401 && !_isRefreshing) {
      final refreshed = await _refreshTokenAndRetry(headers);
      if (refreshed) {
        // Retry the request with new token
        final newHeaders = await _getUpdatedHeaders(headers);
        response = await http.delete(
          uri,
          headers: newHeaders,
          body: data != null ? json.encode(data) : null,
        );
      }
    }

    return response;
  }

  // ---------- REFRESH TOKEN AND RETRY ----------
  Future<bool> _refreshTokenAndRetry(Map<String, String>? initialHeader) async {
    if (_isRefreshing || initialHeader == null) return false;

    _isRefreshing = true;

    try {
      print("General log: Token expired (401), attempting to refresh...");

      // Get stored auth data
      final authData = await SecureStorage.getAuthData();
      if (authData == null || authData.refresh_token == null) {
        print("General log: No refresh token found, cannot refresh");
        _isRefreshing = false;
        return false;
      }

      // Call refresh token endpoint directly (don't use ApiClient's post to avoid recursion)
      // The API requires BOTH the expired access token in Authorization header AND refresh_token in body
      final refreshHeaders = Map<String, String>.from(_defaultHeaders());
      if (authData.token != null) {
        refreshHeaders['Authorization'] = 'Bearer ${authData.token}';
      }

      print("General log: Refresh token is - : ${authData.refresh_token}");
      print("General log: token is - : ${authData.token}");

      final refreshResponse = await http.post(
        Uri.parse('$baseUrl${AppConstants.refreshTokenEndpoint}'),
        headers: refreshHeaders,
        body: json.encode({'refresh_token': authData.refresh_token}),
      );

      if (refreshResponse.statusCode == 200) {
        final responseData = json.decode(refreshResponse.body);

        // Extract new tokens from response
        final newAccessToken = responseData['data']['access_token'];
        final newRefreshToken = responseData['data']['refresh_token'];

        print("General log: Token refreshed successfully");

        // Update stored auth data with new tokens
        final updatedAuthData = AuthDataModel(
          token: newAccessToken,
          refresh_token: newRefreshToken,
          user: authData.user,
        );

        await SecureStorage.saveAuthData(updatedAuthData);

        _isRefreshing = false;
        return true;
      } else {
        print(
            "General log: Failed to refresh token. Status: ${refreshResponse.statusCode}");
        _isRefreshing = false;
        return false;
      }
    } catch (e) {
      print("General log: Error refreshing token - $e");
      _isRefreshing = false;
      return false;
    }
  }

  // ---------- GET UPDATED HEADERS WITH NEW TOKEN ----------
  Future<Map<String, String>> _getUpdatedHeaders(
      Map<String, String>? originalHeaders) async {
    final authData = await SecureStorage.getAuthData();

    if (originalHeaders != null && authData != null) {
      // Update Authorization header with new token
      final updatedHeaders = Map<String, String>.from(originalHeaders);
      updatedHeaders['Authorization'] = 'Bearer ${authData.token}';
      return updatedHeaders;
    }

    return originalHeaders ?? _defaultHeaders();
  }

  // ---------- DEFAULT HEADERS ----------
  Map<String, String> _defaultHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }
}

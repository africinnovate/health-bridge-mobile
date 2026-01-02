import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl;

  ApiClient({required this.baseUrl});

  // ---------- GET ----------
  Future<http.Response> get(
    String endpoint, {
    Map<String, String>? query,
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint').replace(queryParameters: query);

    return http.get(uri, headers: headers ?? _defaultHeaders());
  }

  // ---------- POST ----------
  Future<http.Response> post(
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, String>? query,
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint').replace(queryParameters: query);

    return http.post(
      uri,
      headers: headers ?? _defaultHeaders(),
      body: json.encode(data),
    );
  }

  // ---------- PUT ----------
  Future<http.Response> put(
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, String>? query,
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint').replace(queryParameters: query);

    return http.put(
      uri,
      headers: headers ?? _defaultHeaders(),
      body: json.encode(data),
    );
  }

  // ---------- PATCH ----------
  Future<http.Response> patch(
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, String>? query,
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint').replace(queryParameters: query);

    return http.patch(
      uri,
      headers: headers ?? _defaultHeaders(),
      body: json.encode(data),
    );
  }

  // ---------- DELETE ----------
  Future<http.Response> delete(
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, String>? query,
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint').replace(queryParameters: query);

    return http.delete(
      uri,
      headers: headers ?? _defaultHeaders(),
      body: data != null ? json.encode(data) : null,
    );
  }

  // ---------- DEFAULT HEADERS ----------
  Map<String, String> _defaultHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      // 'Authorization': 'Bearer $token',
    };
  }
}

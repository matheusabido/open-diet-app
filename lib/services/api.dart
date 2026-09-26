import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiException implements Exception {
  final int statusCode;
  final String? message;
  final Map<String, List<String>> errors;

  ApiException({
    required this.statusCode,
    this.message,
    this.errors = const {},
  });
}

class Api {
  static const _baseUrl = 'http://localhost:3000';

  Api._();
  static final Api instance = Api._();

  final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept-Language': 'pt-BR',
  };

  Future<dynamic> get(String path, [Map<String, String>? query]) async {
    final res = await http.get(
      Uri.parse('$_baseUrl$path').replace(queryParameters: query),
      headers: _headers,
    );
    return _handleResponse(res);
  }

  Future<dynamic> post(String path, Map<String, dynamic> body) async {
    final res = await http.post(
      Uri.parse('$_baseUrl$path'),
      headers: _headers,
      body: jsonEncode(body),
    );
    return _handleResponse(res);
  }

  Future<dynamic> put(String path, Map<String, dynamic> body) async {
    final res = await http.put(
      Uri.parse('$_baseUrl$path'),
      headers: _headers,
      body: jsonEncode(body),
    );
    return _handleResponse(res);
  }

  Future<dynamic> patch(String path, Map<String, dynamic> body) async {
    final res = await http.patch(
      Uri.parse('$_baseUrl$path'),
      headers: _headers,
      body: jsonEncode(body),
    );
    return _handleResponse(res);
  }

  Future<dynamic> delete(String path) async {
    final res = await http.delete(
      Uri.parse('$_baseUrl$path'),
      headers: _headers,
    );
    return _handleResponse(res);
  }

  dynamic _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

    if (statusCode >= 200 && statusCode < 300) {
      return body;
    } else {
      throw ApiException(
        statusCode: statusCode,
        message: body?['message'],
        errors: body?['errors'] ?? {},
      );
    }
  }

  void setHeader(String key, String value) {
    _headers[key] = value;
  }

  void removeHeader(String key) {
    _headers.remove(key);
  }
}

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:open_diet/models/food.dart';
import 'package:open_diet/models/food_draft.dart';
import 'package:open_diet/models/food_item.dart';
import 'package:open_diet/models/user.dart';
import 'package:open_diet/models/voice_food_item.dart';

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

class Api extends ChangeNotifier {
  static const _baseUrl = 'http://localhost:3000';
  static const _refreshThreshold = Duration(minutes: 2);
  static const _storage = FlutterSecureStorage();

  Api._();
  static final Api instance = Api._();

  final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept-Language': 'pt-BR',
  };

  User? user;
  String? _refreshToken;
  DateTime? _expiresAt;
  Future<void>? _refreshing;

  List<FoodItem> foodItems = [];
  int _nextPendingId = -1;

  bool get isLoggedIn => user != null;

  String get _today => DateTime.now().toIso8601String().substring(0, 10);

  Future<void> restoreSession() async {
    final session = await _storage.readAll();
    final userJson = session['user'];
    final accessToken = session['access_token'];
    final refreshToken = session['refresh_token'];
    final expiresAt = session['expires_at'];
    if (userJson == null ||
        accessToken == null ||
        refreshToken == null ||
        expiresAt == null) {
      return;
    }

    user = User.fromJson(jsonDecode(userJson));
    _refreshToken = refreshToken;
    _expiresAt = DateTime.parse(expiresAt);
    setHeader('Authorization', 'Bearer $accessToken');
    _restoreFoodItems(session['food_items']);

    _syncUser();
    syncFoodItems();
  }

  void _restoreFoodItems(String? json) {
    if (json == null) return;

    final today = _today;
    foodItems = (jsonDecode(json) as List)
        .map((item) => FoodItem.fromJson(item))
        .where((item) => item.date == today)
        .toList();
  }

  Future<void> syncFoodItems() async {
    try {
      final data = await get('/food-items', {'date': _today});
      final items = (data as List).map((json) => FoodItem.fromJson(json));

      foodItems = [...items, ...foodItems.where((item) => item.isPending)];
      _saveFoodItems();
      notifyListeners();
    } catch (_) {}
  }

  Future<void> addFoodItem(FoodItemDraft draft) async {
    final pending = FoodItem(
      id: _nextPendingId--,
      food: draft.food,
      date: _today,
      meal: draft.meal,
      amount: draft.amount,
      unit: draft.unit,
    );
    foodItems = [...foodItems, pending];
    notifyListeners();

    try {
      final data = await post('/food-items', _foodItemBody(pending));
      final item = FoodItem.fromJson(data);

      foodItems = [
        for (final i in foodItems)
          if (i.id == pending.id) item else if (i.id != item.id) i,
      ];
      _saveFoodItems();
    } catch (_) {
      foodItems = foodItems.where((i) => i.id != pending.id).toList();
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  Future<FoodDraft> foodFromBarcode(String barcode) async {
    return FoodDraft.fromJson(await get('/foods/barcode/$barcode'));
  }

  Future<FoodDraft> foodFromPhoto(String imagePath) async {
    return FoodDraft.fromJson(await upload('/foods/photo', 'image', imagePath));
  }

  Future<VoiceFoodItem> voiceFoodItem(String audioPath) async {
    final data = await upload('/food-items/voice', 'audio', audioPath);
    return VoiceFoodItem.fromJson(data);
  }

  Future<void> linkFoodAlias(int aliasId, Food food) async {
    await put('/food-aliases/$aliasId', {'food_id': food.id});
  }

  Future<void> updateFoodItem(FoodItem item, FoodItemDraft draft) async {
    final predicted = FoodItem(
      id: item.id,
      food: item.food,
      date: item.date,
      meal: draft.meal,
      amount: draft.amount,
      unit: draft.unit,
    );
    _replaceFoodItem(predicted);
    notifyListeners();

    try {
      final data = await put(
        '/food-items/${item.id}',
        _foodItemBody(predicted),
      );
      _replaceFoodItem(FoodItem.fromJson(data));
      _saveFoodItems();
    } catch (_) {
      _replaceFoodItem(item);
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  void _replaceFoodItem(FoodItem item) {
    foodItems = [for (final i in foodItems) i.id == item.id ? item : i];
  }

  Map<String, dynamic> _foodItemBody(FoodItem item) {
    return {
      'food_id': item.food.id,
      'date': item.date,
      'meal': item.meal,
      'amount': item.amount,
      'unit': item.unit,
    };
  }

  void _saveFoodItems() {
    final items = foodItems.where((item) => !item.isPending).toList();
    _storage.write(key: 'food_items', value: jsonEncode(items));
  }

  Future<void> _syncUser() async {
    try {
      _setUser(await get('/users/me'));
    } catch (_) {}
  }

  Future<void> login(String username, String password) async {
    final data = await post('/login', {
      'username': username,
      'password': password,
    });
    _setSession(data);
    syncFoodItems();
  }

  Future<void> register(
    String username,
    String password,
    String passwordConfirmation,
  ) async {
    final data = await post('/register', {
      'username': username,
      'password': password,
      'password_confirmation': passwordConfirmation,
    });
    _setSession(data);
    syncFoodItems();
  }

  Future<void> updateGoals({
    required int kcal,
    required int protein,
    required int carbohydrate,
    required int fat,
  }) async {
    final data = await patch('/users/me', {
      'kcal_goal': kcal,
      'protein_goal': protein,
      'carbohydrate_goal': carbohydrate,
      'fat_goal': fat,
    });
    _setUser(data);
  }

  Future<void> changePassword(
    String currentPassword,
    String password,
    String passwordConfirmation,
  ) async {
    final data = await patch('/users/me/password', {
      'current_password': currentPassword,
      'password': password,
      'password_confirmation': passwordConfirmation,
    });
    _setSession(data);
  }

  void logout() {
    user = null;
    _refreshToken = null;
    _expiresAt = null;
    foodItems = [];
    removeHeader('Authorization');
    _storage.deleteAll();
    notifyListeners();
  }

  Future<dynamic> get(String path, [Map<String, String>? query]) async {
    await _beforeRequest();
    final res = await http.get(
      Uri.parse('$_baseUrl$path').replace(queryParameters: query),
      headers: _headers,
    );
    return _handleResponse(res);
  }

  Future<dynamic> post(String path, Map<String, dynamic> body) async {
    await _beforeRequest();
    final res = await http.post(
      Uri.parse('$_baseUrl$path'),
      headers: _headers,
      body: jsonEncode(body),
    );
    return _handleResponse(res);
  }

  Future<dynamic> upload(String path, String field, String filePath) async {
    await _beforeRequest();
    final request = http.MultipartRequest('POST', Uri.parse('$_baseUrl$path'))
      ..headers.addAll(_headers)
      ..files.add(await http.MultipartFile.fromPath(field, filePath));
    final res = await http.Response.fromStream(await request.send());
    return _handleResponse(res);
  }

  Future<dynamic> put(String path, Map<String, dynamic> body) async {
    await _beforeRequest();
    final res = await http.put(
      Uri.parse('$_baseUrl$path'),
      headers: _headers,
      body: jsonEncode(body),
    );
    return _handleResponse(res);
  }

  Future<dynamic> patch(String path, Map<String, dynamic> body) async {
    await _beforeRequest();
    final res = await http.patch(
      Uri.parse('$_baseUrl$path'),
      headers: _headers,
      body: jsonEncode(body),
    );
    return _handleResponse(res);
  }

  Future<dynamic> delete(String path) async {
    await _beforeRequest();
    final res = await http.delete(
      Uri.parse('$_baseUrl$path'),
      headers: _headers,
    );
    return _handleResponse(res);
  }

  Future<void> _beforeRequest() async {
    final expiresAt = _expiresAt;
    if (expiresAt == null) return;

    final remaining = expiresAt.difference(DateTime.now());
    if (remaining > _refreshThreshold) return;

    final refreshing = _refreshing ??= _refresh().whenComplete(() {
      _refreshing = null;
    });

    if (remaining <= Duration.zero) {
      await refreshing;
    }
  }

  Future<void> _refresh() async {
    try {
      final res = await http.post(
        Uri.parse('$_baseUrl/refresh'),
        headers: _headers,
        body: jsonEncode({'refresh_token': _refreshToken}),
      );
      _setSession(_handleResponse(res));
    } catch (_) {}
  }

  void _setSession(Map<String, dynamic> data) {
    user = User.fromJson(data['user']);
    _refreshToken = data['refresh_token'];
    _expiresAt = DateTime.now().add(Duration(seconds: data['expires_in']));
    setHeader('Authorization', 'Bearer ${data['access_token']}');
    _storage.write(key: 'user', value: jsonEncode(data['user']));
    _storage.write(key: 'access_token', value: data['access_token']);
    _storage.write(key: 'refresh_token', value: _refreshToken);
    _storage.write(key: 'expires_at', value: _expiresAt!.toIso8601String());
    notifyListeners();
  }

  void _setUser(Map<String, dynamic> data) {
    user = User.fromJson(data);
    _storage.write(key: 'user', value: jsonEncode(data));
    notifyListeners();
  }

  dynamic _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

    if (statusCode == 401 && isLoggedIn) logout();

    if (statusCode >= 200 && statusCode < 300) {
      return body;
    } else {
      final errors = body?['errors'] as Map<String, dynamic>? ?? {};

      throw ApiException(
        statusCode: statusCode,
        message: body?['error'],
        errors: errors.map(
          (field, messages) => MapEntry(field, List<String>.from(messages)),
        ),
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

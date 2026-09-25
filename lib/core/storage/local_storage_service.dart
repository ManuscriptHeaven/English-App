import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Abstract contract for local key-value and serialized entity persistence.
abstract class ILocalStorageService {
  Future<void> init();
  Future<void> setString(String key, String value);
  String? getString(String key);
  Future<void> setBool(String key, bool value);
  bool? getBool(String key);
  Future<void> setInt(String key, int value);
  int? getInt(String key);
  Future<void> setObject(String key, Map<String, dynamic> jsonMap);
  Map<String, dynamic>? getObject(String key);
  Future<void> remove(String key);
  Future<void> clear();
}

/// SharedPreferences implementation of ILocalStorageService.
class SharedPreferencesStorageService implements ILocalStorageService {
  SharedPreferences? _prefs;

  @override
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  @override
  Future<void> setString(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  @override
  String? getString(String key) {
    return _prefs?.getString(key);
  }

  @override
  Future<void> setBool(String key, bool value) async {
    await _prefs?.setBool(key, value);
  }

  @override
  bool? getBool(String key) {
    return _prefs?.getBool(key);
  }

  @override
  Future<void> setInt(String key, int value) async {
    await _prefs?.setInt(key, value);
  }

  @override
  int? getInt(String key) {
    return _prefs?.getInt(key);
  }

  @override
  Future<void> setObject(String key, Map<String, dynamic> jsonMap) async {
    await _prefs?.setString(key, jsonEncode(jsonMap));
  }

  @override
  Map<String, dynamic>? getObject(String key) {
    final raw = _prefs?.getString(key);
    if (raw == null) return null;
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> remove(String key) async {
    await _prefs?.remove(key);
  }

  @override
  Future<void> clear() async {
    await _prefs?.clear();
  }
}

/// In-Memory implementation useful for testing and quick offline boots.
class InMemoryStorageService implements ILocalStorageService {
  final Map<String, dynamic> _memory = {};

  @override
  Future<void> init() async {}

  @override
  Future<void> setString(String key, String value) async => _memory[key] = value;

  @override
  String? getString(String key) => _memory[key] as String?;

  @override
  Future<void> setBool(String key, bool value) async => _memory[key] = value;

  @override
  bool? getBool(String key) => _memory[key] as bool?;

  @override
  Future<void> setInt(String key, int value) async => _memory[key] = value;

  @override
  int? getInt(String key) => _memory[key] as int?;

  @override
  Future<void> setObject(String key, Map<String, dynamic> jsonMap) async => _memory[key] = jsonMap;

  @override
  Map<String, dynamic>? getObject(String key) {
    final val = _memory[key];
    if (val is Map<String, dynamic>) return val;
    return null;
  }

  @override
  Future<void> remove(String key) async => _memory.remove(key);

  @override
  Future<void> clear() async => _memory.clear();
}

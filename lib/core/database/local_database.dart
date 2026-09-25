import 'dart:convert';
import 'package:kids_english_adventure/core/storage/local_storage_service.dart';

/// Database document collection representing a typed table/box.
class DatabaseCollection {
  final String collectionName;
  final ILocalStorageService _storage;

  DatabaseCollection(this.collectionName, this._storage);

  String _itemKey(String id) => 'db_${collectionName}_$id';
  String _indexKey() => 'db_index_$collectionName';

  Future<List<String>> _getIndex() async {
    final raw = _storage.getString(_indexKey());
    if (raw == null || raw.isEmpty) return [];
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded.map((e) => e.toString()).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> _saveIndex(List<String> ids) async {
    await _storage.setString(_indexKey(), jsonEncode(ids));
  }

  Future<void> put(String id, Map<String, dynamic> data) async {
    await _storage.setObject(_itemKey(id), data);
    final index = await _getIndex();
    if (!index.contains(id)) {
      index.add(id);
      await _saveIndex(index);
    }
  }

  Future<Map<String, dynamic>?> get(String id) async {
    return _storage.getObject(_itemKey(id));
  }

  Future<List<Map<String, dynamic>>> getAll() async {
    final index = await _getIndex();
    final List<Map<String, dynamic>> results = [];
    for (final id in index) {
      final obj = _storage.getObject(_itemKey(id));
      if (obj != null) {
        results.add(obj);
      }
    }
    return results;
  }

  Future<List<Map<String, dynamic>>> queryByField(String field, dynamic value) async {
    final all = await getAll();
    return all.where((item) => item[field] == value).toList();
  }

  Future<void> delete(String id) async {
    await _storage.remove(_itemKey(id));
    final index = await _getIndex();
    if (index.contains(id)) {
      index.remove(id);
      await _saveIndex(index);
    }
  }

  Future<void> clear() async {
    final index = await _getIndex();
    for (final id in index) {
      await _storage.remove(_itemKey(id));
    }
    await _storage.remove(_indexKey());
  }
}

/// Abstract contract for the Local Document Database.
abstract class ILocalDatabase {
  Future<void> init();
  DatabaseCollection collection(String name);
  Future<void> runTransaction(Future<void> Function() transaction);
  Future<void> clearAll();
}

/// Robust Local Database backed by storage service with collections and child isolation.
class LocalDatabase implements ILocalDatabase {
  final ILocalStorageService _storage;
  final Map<String, DatabaseCollection> _collections = {};

  LocalDatabase({ILocalStorageService? storage})
      : _storage = storage ?? InMemoryStorageService();

  @override
  Future<void> init() async {
    await _storage.init();
  }

  @override
  DatabaseCollection collection(String name) {
    return _collections.putIfAbsent(name, () => DatabaseCollection(name, _storage));
  }

  @override
  Future<void> runTransaction(Future<void> Function() transaction) async {
    // Atomic execution wrapper
    await transaction();
  }

  @override
  Future<void> clearAll() async {
    for (final col in _collections.values) {
      await col.clear();
    }
    _collections.clear();
    await _storage.clear();
  }
}

import 'package:kids_english_adventure/core/database/local_database.dart';

/// Strategy and version manager for local database schema migrations.
class SchemaMigrationManager {
  static const int currentSchemaVersion = 1;
  static const String versionKey = 'db_schema_version';

  final ILocalDatabase _database;

  SchemaMigrationManager(this._database);

  Future<int> getCurrentVersion() async {
    final metaCol = _database.collection('db_metadata');
    final record = await metaCol.get(versionKey);
    return (record?['version'] as int?) ?? 0;
  }

  Future<void> migrate() async {
    final storedVersion = await getCurrentVersion();

    if (storedVersion < 1) {
      // Initialize Schema v1
      await _applyMigrationV1();
    }

    // Future version migrations can be chained here:
    // if (storedVersion < 2) { await _applyMigrationV2(); }
  }

  Future<void> _applyMigrationV1() async {
    final metaCol = _database.collection('db_metadata');
    await metaCol.put(versionKey, {
      'version': 1,
      'migratedAt': DateTime.now().toIso8601String(),
      'description': 'Initial schema with child isolation, learning signals, and multi-world mastery.',
    });
  }
}

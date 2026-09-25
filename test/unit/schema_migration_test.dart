import 'package:flutter_test/flutter_test.dart';
import 'package:kids_english_adventure/core/database/local_database.dart';
import 'package:kids_english_adventure/core/database/schema_migration_manager.dart';
import 'package:kids_english_adventure/core/storage/local_storage_service.dart';

void main() {
  group('SchemaMigrationManager Tests', () {
    test('Initializes schema to Version 1 when database is fresh', () async {
      final storage = InMemoryStorageService();
      final db = LocalDatabase(storage: storage);
      await db.init();

      final migrationManager = SchemaMigrationManager(db);

      // Before migration
      expect(await migrationManager.getCurrentVersion(), equals(0));

      // Run migration
      await migrationManager.migrate();

      // After migration
      expect(await migrationManager.getCurrentVersion(), equals(1));
    });

    test('Preserves existing data when migration runs idempotently', () async {
      final storage = InMemoryStorageService();
      final db = LocalDatabase(storage: storage);
      await db.init();

      final migrationManager = SchemaMigrationManager(db);
      await migrationManager.migrate();

      // Put data in collection
      await db.collection('child_profiles').put('child_1', {'name': 'Ayaan'});

      // Run migration again
      await migrationManager.migrate();

      final record = await db.collection('child_profiles').get('child_1');
      expect(record, isNotNull);
      expect(record!['name'], equals('Ayaan'));
      expect(await migrationManager.getCurrentVersion(), equals(1));
    });
  });
}

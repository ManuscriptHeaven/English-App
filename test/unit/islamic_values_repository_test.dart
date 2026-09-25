import 'package:flutter_test/flutter_test.dart';
import 'package:kids_english_adventure/features/values/data/mock_islamic_values_repository.dart';
import 'package:kids_english_adventure/features/values/domain/models/islamic_value.dart';

void main() {
  group('MockIslamicValuesRepository Tests', () {
    late MockIslamicValuesRepository repo;

    setUp(() {
      repo = MockIslamicValuesRepository();
    });

    test('Provides core Islamic values (Kindness, Respect for Parents, Cleanliness, Gratitude)', () async {
      final values = await repo.getAllValues();
      expect(values.length, greaterThanOrEqualTo(4));

      final kindness = await repo.getValueById('value_kindness_animals');
      expect(kindness, isNotNull);
      expect(kindness!.category, equals(IslamicValueCategory.kindness));
      expect(kindness.arabicPhrase, contains('Rahmah'));

      final respect = await repo.getValueById('value_respect_parents');
      expect(respect, isNotNull);
      expect(respect!.category, equals(IslamicValueCategory.respectForParents));
    });

    test('Provides Sunnah manners connected to values', () async {
      final manners = await repo.getAllManners();
      expect(manners.isNotEmpty, isTrue);

      final gentle = await repo.getMannerById('manner_gentle_animals');
      expect(gentle, isNotNull);
      expect(gentle!.associatedValueId, equals('value_kindness_animals'));
    });

    test('Provides pedagogical Value Connections linking English curriculum to Islamic character', () async {
      final connections = await repo.getValueConnectionsForWorld('world_animal');
      expect(connections.isNotEmpty, isTrue);

      final conn = connections.first;
      expect(conn.islamicValueId, equals('value_kindness_animals'));
      expect(conn.exampleSentence, contains('hands'));
    });
  });
}

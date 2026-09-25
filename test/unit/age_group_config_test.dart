import 'package:flutter_test/flutter_test.dart';
import 'package:kids_english_adventure/core/theme/age_group_config.dart';

void main() {
  group('AgeGroupConfig Tests', () {
    test('Correctly maps ages 3-4 to toddler with large touch targets and autoplay', () {
      final config3 = AgeGroupConfig.forAge(3);
      final config4 = AgeGroupConfig.forAge(4);

      expect(config3.type, equals(AgeGroupType.toddler));
      expect(config4.type, equals(AgeGroupType.toddler));
      expect(config3.minButtonHeight, greaterThanOrEqualTo(64.0));
      expect(config3.autoPlayAudio, isTrue);
      expect(config3.maxChoicesPerQuiz, equals(2));
    });

    test('Correctly maps ages 5-6 to earlyLearner', () {
      final config5 = AgeGroupConfig.forAge(5);
      final config6 = AgeGroupConfig.forAge(6);

      expect(config5.type, equals(AgeGroupType.earlyLearner));
      expect(config6.type, equals(AgeGroupType.earlyLearner));
      expect(config5.autoPlayAudio, isTrue);
      expect(config5.showTextLabels, isTrue);
    });

    test('Correctly maps ages 7-8 to youngReader', () {
      final config7 = AgeGroupConfig.forAge(7);
      expect(config7.type, equals(AgeGroupType.youngReader));
      expect(config7.maxChoicesPerQuiz, equals(4));
    });

    test('Correctly maps ages 9-10 to masterLearner', () {
      final config10 = AgeGroupConfig.forAge(10);
      expect(config10.type, equals(AgeGroupType.masterLearner));
    });
  });
}

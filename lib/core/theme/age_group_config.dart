import 'package:equatable/equatable.dart';

/// Target developmental age groups for the learning engine and UI adaptivity.
enum AgeGroupType {
  toddler(3, 4, '3–4', 'Tiny Explorers', 'Audio-first, big buttons, playful picture prompts'),
  earlyLearner(5, 6, '5–6', 'Little Adventurers', 'Phonics, simple words, listening games'),
  youngReader(7, 8, '7–8', 'Word Voyagers', 'Sentences, grammar, reading stories'),
  masterLearner(9, 10, '9–10', 'Adventure Masters', 'Advanced grammar, writing, comprehension');

  final int minAge;
  final int maxAge;
  final String label;
  final String title;
  final String description;

  const AgeGroupType(this.minAge, this.maxAge, this.label, this.title, this.description);

  static AgeGroupType fromAge(int age) {
    if (age <= 4) return AgeGroupType.toddler;
    if (age <= 6) return AgeGroupType.earlyLearner;
    if (age <= 8) return AgeGroupType.youngReader;
    return AgeGroupType.masterLearner;
  }
}

/// Dynamic UI & Interaction Configuration tuned to the child's developmental age.
class AgeGroupConfig extends Equatable {
  final AgeGroupType type;
  final double minButtonHeight;
  final double fontScaleFactor;
  final double iconSize;
  final bool autoPlayAudio;
  final bool showTextLabels;
  final int maxChoicesPerQuiz;
  final bool enablePinyinOrPhonics;

  const AgeGroupConfig({
    required this.type,
    required this.minButtonHeight,
    required this.fontScaleFactor,
    required this.iconSize,
    required this.autoPlayAudio,
    required this.showTextLabels,
    required this.maxChoicesPerQuiz,
    required this.enablePinyinOrPhonics,
  });

  factory AgeGroupConfig.forAge(int age) {
    final group = AgeGroupType.fromAge(age);
    switch (group) {
      case AgeGroupType.toddler:
        return const AgeGroupConfig(
          type: AgeGroupType.toddler,
          minButtonHeight: 68.0,
          fontScaleFactor: 1.25,
          iconSize: 44.0,
          autoPlayAudio: true,
          showTextLabels: false,
          maxChoicesPerQuiz: 2,
          enablePinyinOrPhonics: true,
        );
      case AgeGroupType.earlyLearner:
        return const AgeGroupConfig(
          type: AgeGroupType.earlyLearner,
          minButtonHeight: 60.0,
          fontScaleFactor: 1.15,
          iconSize: 36.0,
          autoPlayAudio: true,
          showTextLabels: true,
          maxChoicesPerQuiz: 3,
          enablePinyinOrPhonics: true,
        );
      case AgeGroupType.youngReader:
        return const AgeGroupConfig(
          type: AgeGroupType.youngReader,
          minButtonHeight: 52.0,
          fontScaleFactor: 1.0,
          iconSize: 28.0,
          autoPlayAudio: false,
          showTextLabels: true,
          maxChoicesPerQuiz: 4,
          enablePinyinOrPhonics: false,
        );
      case AgeGroupType.masterLearner:
        return const AgeGroupConfig(
          type: AgeGroupType.masterLearner,
          minButtonHeight: 48.0,
          fontScaleFactor: 0.95,
          iconSize: 24.0,
          autoPlayAudio: false,
          showTextLabels: true,
          maxChoicesPerQuiz: 4,
          enablePinyinOrPhonics: false,
        );
    }
  }

  @override
  List<Object?> get props => [
        type,
        minButtonHeight,
        fontScaleFactor,
        iconSize,
        autoPlayAudio,
        showTextLabels,
        maxChoicesPerQuiz,
        enablePinyinOrPhonics,
      ];
}

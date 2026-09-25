import 'package:equatable/equatable.dart';

/// Islamic ethical and behavioral value themes woven into real communicative English scenarios.
class IslamicValueTheme extends Equatable {
  final String id;
  final String title;
  final String childFriendlyTitle;
  final String description;
  final String authenticReference; // e.g. "Hadith: 'The merciful will be shown mercy...'"
  final List<String> coreConceptWords; // e.g. ['kind', 'gentle', 'care']
  final List<String> dailyPractices; // e.g. ['Helping siblings', 'Cleaning up toys']
  final List<String> languagePhrases; // e.g. ['Can I help you?', 'Thank you', 'JazakAllah Khair']

  const IslamicValueTheme({
    required this.id,
    required this.title,
    required this.childFriendlyTitle,
    required this.description,
    required this.authenticReference,
    this.coreConceptWords = const [],
    this.dailyPractices = const [],
    this.languagePhrases = const [],
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'childFriendlyTitle': childFriendlyTitle,
        'description': description,
        'authenticReference': authenticReference,
        'coreConceptWords': coreConceptWords,
        'dailyPractices': dailyPractices,
        'languagePhrases': languagePhrases,
      };

  factory IslamicValueTheme.fromJson(Map<String, dynamic> json) => IslamicValueTheme(
        id: json['id'] as String,
        title: json['title'] as String,
        childFriendlyTitle: json['childFriendlyTitle'] as String,
        description: json['description'] as String,
        authenticReference: json['authenticReference'] as String? ?? '',
        coreConceptWords:
            (json['coreConceptWords'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
        dailyPractices:
            (json['dailyPractices'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
        languagePhrases:
            (json['languagePhrases'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      );

  @override
  List<Object?> get props => [
        id,
        title,
        childFriendlyTitle,
        description,
        authenticReference,
        coreConceptWords,
        dailyPractices,
        languagePhrases,
      ];
}

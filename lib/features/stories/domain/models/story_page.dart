import 'package:equatable/equatable.dart';

/// Single interactive illustrated page of a story.
class StoryPage extends Equatable {
  final int pageNumber;
  final String text;
  final String illustrationAssetPath;
  final String? narrationAudioUrl;
  final List<String> highlightedWords; // Key vocab highlighted for pronunciation
  final String? characterDialogue;
  final String? dialogueSpeaker;

  const StoryPage({
    required this.pageNumber,
    required this.text,
    required this.illustrationAssetPath,
    this.narrationAudioUrl,
    this.highlightedWords = const [],
    this.characterDialogue,
    this.dialogueSpeaker,
  });

  Map<String, dynamic> toJson() => {
        'pageNumber': pageNumber,
        'text': text,
        'illustrationAssetPath': illustrationAssetPath,
        'narrationAudioUrl': narrationAudioUrl,
        'highlightedWords': highlightedWords,
        'characterDialogue': characterDialogue,
        'dialogueSpeaker': dialogueSpeaker,
      };

  factory StoryPage.fromJson(Map<String, dynamic> json) => StoryPage(
        pageNumber: json['pageNumber'] as int,
        text: json['text'] as String,
        illustrationAssetPath: json['illustrationAssetPath'] as String,
        narrationAudioUrl: json['narrationAudioUrl'] as String?,
        highlightedWords: (json['highlightedWords'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            const [],
        characterDialogue: json['characterDialogue'] as String?,
        dialogueSpeaker: json['dialogueSpeaker'] as String?,
      );

  @override
  List<Object?> get props => [
        pageNumber,
        text,
        illustrationAssetPath,
        narrationAudioUrl,
        highlightedWords,
        characterDialogue,
        dialogueSpeaker,
      ];
}

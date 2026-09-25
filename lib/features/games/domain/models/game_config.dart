import 'package:equatable/equatable.dart';

/// Extensible catalogue of mini-game types supported by the game engine.
enum GameType {
  wordHunt('Word Hunt', 'Find the hidden vocabulary items'),
  matchCards('Match Cards', 'Match words to pictures or opposites'),
  listenAndChoose('Listen & Choose', 'Tap the picture corresponding to the sound'),
  sentenceBuilder('Sentence Builder', 'Arrange words to build complete sentences'),
  missingWord('Missing Word', 'Fill in the blank with correct grammar'),
  balloonPop('Balloon Pop', 'Pop balloons with matching phonics or words'),
  memoryMatch('Memory Match', 'Flip cards and find pairs'),
  grammarMonster('Grammar Monster', 'Feed the monster correct parts of speech'),
  wordRace('Word Race', 'Speedy word identification challenge'),
  pictureQuiz('Picture Quiz', 'Identify the image in English'),
  pronunciationChallenge('Pronunciation Challenge', 'Speak the word clearly'),
  storyQuiz('Story Quiz', 'Answer fun questions about the story'),
  sortingGame('Sorting Game', 'Sort items into categories or manners'),
  dragAndDrop('Drag and Drop', 'Place objects into the right locations'),
  findTheObject('Find the Object', 'Locate animals or objects in the scene');

  final String title;
  final String description;

  const GameType(this.title, this.description);
}

/// Generic configuration for initializing any mini-game within a lesson or arcade mode.
class GameConfig extends Equatable {
  final String id;
  final GameType type;
  final String title;
  final String worldId;
  final String? lessonId;
  final int timeLimitSeconds;
  final int maxMistakes;
  final List<String> targetWordIds;
  final Map<String, dynamic> gameParameters;

  const GameConfig({
    required this.id,
    required this.type,
    required this.title,
    required this.worldId,
    this.lessonId,
    this.timeLimitSeconds = 60,
    this.maxMistakes = 3,
    this.targetWordIds = const [],
    this.gameParameters = const {},
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'title': title,
        'worldId': worldId,
        'lessonId': lessonId,
        'timeLimitSeconds': timeLimitSeconds,
        'maxMistakes': maxMistakes,
        'targetWordIds': targetWordIds,
        'gameParameters': gameParameters,
      };

  factory GameConfig.fromJson(Map<String, dynamic> json) => GameConfig(
        id: json['id'] as String,
        type: GameType.values.firstWhere((e) => e.name == json['type']),
        title: json['title'] as String,
        worldId: json['worldId'] as String,
        lessonId: json['lessonId'] as String?,
        timeLimitSeconds: json['timeLimitSeconds'] as int? ?? 60,
        maxMistakes: json['maxMistakes'] as int? ?? 3,
        targetWordIds: (json['targetWordIds'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            const [],
        gameParameters: json['gameParameters'] as Map<String, dynamic>? ?? const {},
      );

  @override
  List<Object?> get props => [
        id,
        type,
        title,
        worldId,
        lessonId,
        timeLimitSeconds,
        maxMistakes,
        targetWordIds,
        gameParameters,
      ];
}

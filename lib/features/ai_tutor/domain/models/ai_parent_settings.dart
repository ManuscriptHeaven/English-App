import 'package:equatable/equatable.dart';

/// Parent-controlled settings for AI conversation limits and features.
class AiParentSettings extends Equatable {
  final bool aiTutorEnabled;
  final bool voiceConversationEnabled;
  final bool speakingPracticeEnabled;
  final bool storyVariationsEnabled;
  final bool aiFallbackEnabled;
  final int dailyMinutesLimit; // 5, 10, 15, 20, 30
  final int dailyTurnsLimit; // 5, 10, 20, 30, 50
  final bool costSaverMode; // prioritize compact responses

  const AiParentSettings({
    this.aiTutorEnabled = true,
    this.voiceConversationEnabled = true,
    this.speakingPracticeEnabled = true,
    this.storyVariationsEnabled = true,
    this.aiFallbackEnabled = true,
    this.dailyMinutesLimit = 10,
    this.dailyTurnsLimit = 20,
    this.costSaverMode = true,
  });

  AiParentSettings copyWith({
    bool? aiTutorEnabled,
    bool? voiceConversationEnabled,
    bool? speakingPracticeEnabled,
    bool? storyVariationsEnabled,
    bool? aiFallbackEnabled,
    int? dailyMinutesLimit,
    int? dailyTurnsLimit,
    bool? costSaverMode,
  }) {
    return AiParentSettings(
      aiTutorEnabled: aiTutorEnabled ?? this.aiTutorEnabled,
      voiceConversationEnabled: voiceConversationEnabled ?? this.voiceConversationEnabled,
      speakingPracticeEnabled: speakingPracticeEnabled ?? this.speakingPracticeEnabled,
      storyVariationsEnabled: storyVariationsEnabled ?? this.storyVariationsEnabled,
      aiFallbackEnabled: aiFallbackEnabled ?? this.aiFallbackEnabled,
      dailyMinutesLimit: dailyMinutesLimit ?? this.dailyMinutesLimit,
      dailyTurnsLimit: dailyTurnsLimit ?? this.dailyTurnsLimit,
      costSaverMode: costSaverMode ?? this.costSaverMode,
    );
  }

  Map<String, dynamic> toJson() => {
        'aiTutorEnabled': aiTutorEnabled,
        'voiceConversationEnabled': voiceConversationEnabled,
        'speakingPracticeEnabled': speakingPracticeEnabled,
        'storyVariationsEnabled': storyVariationsEnabled,
        'aiFallbackEnabled': aiFallbackEnabled,
        'dailyMinutesLimit': dailyMinutesLimit,
        'dailyTurnsLimit': dailyTurnsLimit,
        'costSaverMode': costSaverMode,
      };

  factory AiParentSettings.fromJson(Map<String, dynamic> json) => AiParentSettings(
        aiTutorEnabled: json['aiTutorEnabled'] as bool? ?? true,
        voiceConversationEnabled: json['voiceConversationEnabled'] as bool? ?? true,
        speakingPracticeEnabled: json['speakingPracticeEnabled'] as bool? ?? true,
        storyVariationsEnabled: json['storyVariationsEnabled'] as bool? ?? true,
        aiFallbackEnabled: json['aiFallbackEnabled'] as bool? ?? true,
        dailyMinutesLimit: json['dailyMinutesLimit'] as int? ?? 10,
        dailyTurnsLimit: json['dailyTurnsLimit'] as int? ?? 20,
        costSaverMode: json['costSaverMode'] as bool? ?? true,
      );

  @override
  List<Object?> get props => [
        aiTutorEnabled,
        voiceConversationEnabled,
        speakingPracticeEnabled,
        storyVariationsEnabled,
        aiFallbackEnabled,
        dailyMinutesLimit,
        dailyTurnsLimit,
        costSaverMode,
      ];
}

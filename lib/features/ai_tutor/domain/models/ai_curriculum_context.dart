import 'package:equatable/equatable.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/models/learning_signal.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/models/recommendation.dart';
import 'ai_mode.dart';
import 'verified_value_context.dart';

/// Minimal educational curriculum boundary sent to AI providers.
/// Enforces data minimization by never sending full historical transcripts or PII.
class AiCurriculumContext extends Equatable {
  final int childAge;
  final String childAgeGroup; // '3-4', '5-6', '7-8', '9-10'
  final String currentWorldId;
  final String currentLessonId;
  final AiMode mode;
  final SkillType targetSkill;
  final List<String> targetVocabulary;
  final String? targetGrammar;
  final String? targetValueId;
  final String? weaknessTarget;
  final String? storyTitle;
  final String? scenarioPrompt;
  final List<String> approvedManners;
  final List<VerifiedValueContext> approvedIslamicValues;
  final int difficultyLevel; // 1 to 5
  final String conversationObjective;
  final List<String> allowedTopics;
  final List<String> forbiddenTopics;
  final int maxResponseWords;
  final List<String> recentlyLearnedWords;
  final List<String> weakVocabulary;
  final List<String> familiarVocabulary;
  final String? currentSkillGoal;

  const AiCurriculumContext({
    required this.childAge,
    required this.childAgeGroup,
    required this.currentWorldId,
    required this.currentLessonId,
    required this.mode,
    required this.targetSkill,
    required this.targetVocabulary,
    this.targetGrammar,
    this.targetValueId,
    this.weaknessTarget,
    this.storyTitle,
    this.scenarioPrompt,
    this.approvedManners = const [],
    this.approvedIslamicValues = const [],
    this.difficultyLevel = 1,
    required this.conversationObjective,
    this.allowedTopics = const [],
    this.forbiddenTopics = const [
      'personal_address',
      'passwords',
      'secrets',
      'unapproved_religious_rulings',
      'violence',
      'scary_stories',
      'politics',
    ],
    required this.maxResponseWords,
    this.recentlyLearnedWords = const [],
    this.weakVocabulary = const [],
    this.familiarVocabulary = const [],
    this.currentSkillGoal,
  });

  /// Factory calculating age-appropriate max response words dynamically.
  factory AiCurriculumContext.forChild({
    required int childAge,
    required String currentWorldId,
    required String currentLessonId,
    required AiMode mode,
    required SkillType targetSkill,
    required List<String> targetVocabulary,
    String? targetGrammar,
    String? targetValueId,
    String? weaknessTarget,
    String? storyTitle,
    String? scenarioPrompt,
    List<String> approvedManners = const [],
    List<VerifiedValueContext> approvedIslamicValues = const [],
    int difficultyLevel = 1,
    required String conversationObjective,
    List<String> allowedTopics = const [],
  }) {
    final String ageGroup;
    final int maxWords;

    if (childAge <= 4) {
      ageGroup = '3-4';
      maxWords = 15;
    } else if (childAge <= 6) {
      ageGroup = '5-6';
      maxWords = 20;
    } else if (childAge <= 8) {
      ageGroup = '7-8';
      maxWords = 30;
    } else {
      ageGroup = '9-10';
      maxWords = 50;
    }

    return AiCurriculumContext(
      childAge: childAge,
      childAgeGroup: ageGroup,
      currentWorldId: currentWorldId,
      currentLessonId: currentLessonId,
      mode: mode,
      targetSkill: targetSkill,
      targetVocabulary: targetVocabulary,
      targetGrammar: targetGrammar,
      targetValueId: targetValueId,
      weaknessTarget: weaknessTarget,
      storyTitle: storyTitle,
      scenarioPrompt: scenarioPrompt,
      approvedManners: approvedManners,
      approvedIslamicValues: approvedIslamicValues,
      difficultyLevel: difficultyLevel,
      conversationObjective: conversationObjective,
      allowedTopics: allowedTopics,
      maxResponseWords: maxWords,
    );
  }

  /// Creates curriculum context dynamically from an Adventure Brain Recommendation.
  factory AiCurriculumContext.fromRecommendation({
    required Recommendation recommendation,
    required int childAge,
    List<String> targetVocabulary = const [],
    String? targetGrammar,
    List<VerifiedValueContext> approvedValues = const [],
  }) {
    AiMode mode = AiMode.vocabularyTalk;
    if (recommendation.skill == SkillType.speaking) {
      mode = AiMode.speakingChallenge;
    } else if (recommendation.skill == SkillType.grammar) {
      mode = AiMode.grammarTalk;
    } else if (recommendation.isReview || recommendation.priority == RecommendationPriority.criticalWeakness) {
      mode = AiMode.reviewTalk;
    }

    return AiCurriculumContext.forChild(
      childAge: childAge,
      currentWorldId: recommendation.worldId,
      currentLessonId: recommendation.activityId,
      mode: mode,
      targetSkill: recommendation.skill,
      targetVocabulary: targetVocabulary.isNotEmpty ? targetVocabulary : ['practice', 'words'],
      targetGrammar: targetGrammar ?? (recommendation.skill == SkillType.grammar ? 'Sentence structure' : null),
      difficultyLevel: recommendation.difficultyLevel,
      conversationObjective: recommendation.reason,
      approvedIslamicValues: approvedValues,
    );
  }

  Map<String, dynamic> toJson() => {
        'childAgeGroup': childAgeGroup,
        'currentWorldId': currentWorldId,
        'currentLessonId': currentLessonId,
        'mode': mode.name,
        'targetSkill': targetSkill.name,
        'targetVocabulary': targetVocabulary,
        'targetGrammar': targetGrammar,
        'targetValueId': targetValueId,
        'weaknessTarget': weaknessTarget,
        'storyTitle': storyTitle,
        'scenarioPrompt': scenarioPrompt,
        'approvedManners': approvedManners,
        'approvedIslamicValues': approvedIslamicValues.map((v) => v.toJson()).toList(),
        'difficultyLevel': difficultyLevel,
        'conversationObjective': conversationObjective,
        'allowedTopics': allowedTopics,
        'forbiddenTopics': forbiddenTopics,
        'maxResponseWords': maxResponseWords,
        'recentlyLearnedWords': recentlyLearnedWords,
        'weakVocabulary': weakVocabulary,
        'familiarVocabulary': familiarVocabulary,
        'currentSkillGoal': currentSkillGoal,
      };

  @override
  List<Object?> get props => [
        childAge,
        childAgeGroup,
        currentWorldId,
        currentLessonId,
        mode,
        targetSkill,
        targetVocabulary,
        targetGrammar,
        targetValueId,
        weaknessTarget,
        storyTitle,
        scenarioPrompt,
        approvedManners,
        approvedIslamicValues,
        difficultyLevel,
        conversationObjective,
        allowedTopics,
        forbiddenTopics,
        maxResponseWords,
        recentlyLearnedWords,
        weakVocabulary,
        familiarVocabulary,
        currentSkillGoal,
      ];
}

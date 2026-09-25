import 'dart:math' as math;

/// Broad category of learning activity mechanic.
enum ActivityCategory {
  discovery,
  recognition,
  listening,
  speaking,
  matching,
  animalHunt,
  story,
  comprehension,
  conversation,
  revision,
}

extension ActivityCategoryExtension on ActivityCategory {
  String get displayName {
    switch (this) {
      case ActivityCategory.discovery:
        return 'Word Discovery';
      case ActivityCategory.recognition:
        return 'Word Recognition';
      case ActivityCategory.listening:
        return 'Listen & Find';
      case ActivityCategory.speaking:
        return 'Speaking Practice';
      case ActivityCategory.matching:
        return 'Word Match';
      case ActivityCategory.animalHunt:
        return 'Animal Hunt';
      case ActivityCategory.story:
        return 'Picture Story';
      case ActivityCategory.comprehension:
        return 'Story Quiz';
      case ActivityCategory.conversation:
        return 'Talk With Pip';
      case ActivityCategory.revision:
        return 'Spaced Review';
    }
  }

  /// Maps an activity or lesson ID to its core [ActivityCategory].
  static ActivityCategory fromActivityId(String id) {
    if (id.contains('vocab') || id.contains('discovery')) return ActivityCategory.discovery;
    if (id.contains('hunt')) return ActivityCategory.animalHunt;
    if (id.contains('story_read') || id.contains('story_animal')) return ActivityCategory.story;
    if (id.contains('quiz')) return ActivityCategory.comprehension;
    if (id.contains('listen')) return ActivityCategory.listening;
    if (id.contains('speak') || id.contains('talk')) return ActivityCategory.speaking;
    if (id.contains('match')) return ActivityCategory.matching;
    if (id.contains('review') || id.contains('adaptive')) return ActivityCategory.revision;
    return ActivityCategory.recognition;
  }
}

/// Pure domain engine that prevents activity mechanic fatigue.
///
/// Ensures young children experience a healthy rotation of interactive mechanics
/// (discovery -> hunt -> story -> quiz -> conversation).
class ActivityVarietyEngine {
  final int maxConsecutiveSameCategory;
  final math.Random? _injectedRandom;

  const ActivityVarietyEngine({
    this.maxConsecutiveSameCategory = 2,
    math.Random? random,
  }) : _injectedRandom = random;

  /// Checks if the candidate [category] is eligible given recent [history].
  bool isCategoryEligible(
    ActivityCategory category,
    List<ActivityCategory> history,
  ) {
    if (history.isEmpty) return true;

    // Count how many consecutive times the candidate category was played recently
    int consecutive = 0;
    for (int i = history.length - 1; i >= 0; i--) {
      if (history[i] == category) {
        consecutive++;
      } else {
        break;
      }
    }

    return consecutive < maxConsecutiveSameCategory;
  }

  /// Selects the best category from a candidate list, prioritizing variety.
  ActivityCategory selectBestCategory({
    required List<ActivityCategory> candidates,
    required List<ActivityCategory> history,
  }) {
    if (candidates.isEmpty) return ActivityCategory.discovery;

    // Filter out categories that exceed consecutive repetition limit
    final eligible = candidates.where((c) => isCategoryEligible(c, history)).toList();
    final pool = eligible.isNotEmpty ? eligible : candidates;

    // Find the candidate least recently played
    int maxDistance = -1;
    final topCandidates = <ActivityCategory>[];

    for (final candidate in pool) {
      final lastIndex = history.lastIndexOf(candidate);
      final distance = lastIndex == -1 ? 999 : (history.length - 1 - lastIndex);
      if (distance > maxDistance) {
        maxDistance = distance;
        topCandidates.clear();
        topCandidates.add(candidate);
      } else if (distance == maxDistance) {
        topCandidates.add(candidate);
      }
    }

    if (topCandidates.length > 1 && _injectedRandom != null) {
      return topCandidates[_injectedRandom.nextInt(topCandidates.length)];
    }

    return topCandidates.first;
  }

  /// Suggests a complementary activity category when a child has completed multiple
  /// vocabulary-heavy activities.
  ActivityCategory suggestComplementaryCategory(List<ActivityCategory> recentHistory) {
    if (recentHistory.isEmpty) return ActivityCategory.discovery;

    final last = recentHistory.last;
    switch (last) {
      case ActivityCategory.discovery:
        return ActivityCategory.animalHunt;
      case ActivityCategory.animalHunt:
        return ActivityCategory.story;
      case ActivityCategory.story:
        return ActivityCategory.comprehension;
      case ActivityCategory.comprehension:
        return ActivityCategory.conversation;
      case ActivityCategory.conversation:
      case ActivityCategory.speaking:
        return ActivityCategory.listening;
      default:
        return ActivityCategory.discovery;
    }
  }
}

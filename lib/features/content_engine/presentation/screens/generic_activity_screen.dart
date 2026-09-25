import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kids_english_adventure/core/theme/app_colors.dart';
import 'package:kids_english_adventure/core/theme/app_radius.dart';
import 'package:kids_english_adventure/core/theme/app_typography.dart';
import 'package:kids_english_adventure/core/widgets/app_button.dart';
import 'package:kids_english_adventure/core/widgets/app_card.dart';
import 'package:kids_english_adventure/core/widgets/app_scaffold.dart';
import 'package:kids_english_adventure/core/widgets/guide_character.dart';
import 'package:kids_english_adventure/core/widgets/value_pill.dart';
import 'package:kids_english_adventure/features/child_profile/presentation/providers/child_profile_providers.dart';
import 'package:kids_english_adventure/features/content_engine/data/local_content_repository.dart';
import 'package:kids_english_adventure/features/content_engine/domain/models/activity_type.dart';
import 'package:kids_english_adventure/features/content_engine/domain/models/content_item.dart';
import 'package:kids_english_adventure/features/settings/presentation/providers/settings_providers.dart';

final localContentRepositoryProvider = Provider<LocalContentRepository>((ref) {
  return LocalContentRepository();
});

/// Generic interactive activity screen that dynamically renders ContentItems.
class GenericActivityScreen extends ConsumerStatefulWidget {
  final String contentId;

  const GenericActivityScreen({
    super.key,
    required this.contentId,
  });

  @override
  ConsumerState<GenericActivityScreen> createState() => _GenericActivityScreenState();
}

class _GenericActivityScreenState extends ConsumerState<GenericActivityScreen> {
  ContentItem? _contentItem;
  bool _isLoading = true;
  String? _selectedOption;
  bool? _isCorrect;

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  Future<void> _loadContent() async {
    final repo = ref.read(localContentRepositoryProvider);
    final item = await repo.getContentItemById(widget.contentId);
    if (mounted) {
      setState(() {
        _contentItem = item;
        _isLoading = false;
      });
    }
  }

  void _onOptionSelected(String option, String correctOption) {
    if (_isCorrect == true) return;
    final isRight = (option == correctOption);

    setState(() {
      _selectedOption = option;
      _isCorrect = isRight;
    });

    if (isRight) {
      ref.read(audioServiceProvider).playSuccess();
    } else {
      ref.read(audioServiceProvider).playRetry();
    }
  }

  void _onComplete() {
    if (_contentItem == null) return;
    ref.read(activeChildProfileProvider.notifier).completeActivity(
          _contentItem!.id,
          xp: 25,
          coins: 15,
          stars: 3,
        );
    ref.read(audioServiceProvider).playReward();
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final activeChild = ref.watch(activeChildProfileProvider);

    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_contentItem == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Activity')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Activity not found: ${widget.contentId}', style: AppTypography.bodyLarge),
              const SizedBox(height: 16),
              AppButton(text: 'Go Back', onPressed: () => context.pop()),
            ],
          ),
        ),
      );
    }

    final item = _contentItem!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: ChildHeaderBar(
        title: item.title,
        stars: activeChild?.stars ?? 0,
        coins: activeChild?.coins ?? 0,
        streak: activeChild?.streakDays ?? 0,
        showBack: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            GuideCharacterBanner(
              message: item.description,
            ),
            const SizedBox(height: 16),

            // Dynamic layout according to ActivityType
            if (item.activityType == ActivityType.vocabularyDiscovery)
              _buildDiscoveryCard(item)
            else if (item.activityType == ActivityType.imageHunt ||
                item.activityType == ActivityType.fillBlank ||
                item.activityType == ActivityType.multipleChoice ||
                item.activityType == ActivityType.scenarioChoice)
              _buildInteractiveQuizCard(item)
            else
              _buildFallbackCard(item),

            const SizedBox(height: 24),

            if (_isCorrect == true || item.activityType == ActivityType.vocabularyDiscovery)
              AppButton(
                text: 'Complete Activity 🎉 ▶',
                minWidth: double.infinity,
                height: 56,
                backgroundColor: AppColors.correctGreen,
                foregroundColor: Colors.white,
                onPressed: _onComplete,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscoveryCard(ContentItem item) {
    final data = item.contentData;
    final word = data['word'] as String? ?? item.title;
    final emoji = data['emoji'] as String? ?? '🍎';
    final phonetic = data['phonetic'] as String? ?? '';
    final sentence = data['sentence'] as String? ?? '';
    final valueTip = data['valueTip'] as String?;

    return Column(
      children: [
        AppCard(
          borderColor: AppColors.primary,
          child: Column(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 96)),
              const SizedBox(height: 12),
              Text(word, style: AppTypography.displayMedium.copyWith(color: AppColors.primaryDark)),
              if (phonetic.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(phonetic, style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
              ],
              const SizedBox(height: 16),
              IconButton(
                iconSize: 52,
                icon: const Icon(Icons.volume_up_rounded, color: AppColors.primary),
                onPressed: () => ref.read(audioServiceProvider).playWord(word),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: AppRadius.roundedLg,
                ),
                child: Text(
                  sentence,
                  style: AppTypography.headlineMedium.copyWith(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        if (valueTip != null) ...[
          const SizedBox(height: 14),
          ValuePill(title: valueTip, isLarge: true),
        ],
      ],
    );
  }

  Widget _buildInteractiveQuizCard(ContentItem item) {
    final data = item.contentData;
    final prompt = data['prompt'] as String? ?? item.description;
    final options = (data['options'] as List<dynamic>?) ?? [];
    final correctWord = data['correctWord'] as String?;
    final correctIndex = data['correctIndex'] as int?;

    return Column(
      children: [
        AppCard(
          borderColor: AppColors.secondary,
          child: Column(
            children: [
              Text(
                prompt,
                style: AppTypography.headlineLarge.copyWith(fontSize: 22),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: options.length,
          itemBuilder: (context, idx) {
            final opt = options[idx];
            String optText = '';
            if (opt is String) {
              optText = opt;
            } else if (opt is Map) {
              optText = '${opt['word']} ${opt['emoji'] ?? ''}';
            }

            final isSelected = _selectedOption == optText;

            Color bg = Colors.white;
            Color border = AppColors.cardBorder;

            if (isSelected) {
              if (_isCorrect == true) {
                bg = AppColors.correctGreen.withValues(alpha: 0.2);
                border = AppColors.correctGreen;
              } else {
                bg = AppColors.tryAgainOrange.withValues(alpha: 0.2);
                border = AppColors.tryAgainOrange;
              }
            }

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: AppCard(
                backgroundColor: bg,
                borderColor: border,
                padding: const EdgeInsets.all(16),
                onTap: () {
                  final correctString = correctIndex != null ? options[correctIndex].toString() : (correctWord ?? '');
                  _onOptionSelected(optText, correctIndex != null ? optText : correctString);
                },
                child: Text(
                  optText,
                  style: AppTypography.headlineMedium.copyWith(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildFallbackCard(ContentItem item) {
    return AppCard(
      borderColor: AppColors.primary,
      child: Column(
        children: [
          Text(item.title, style: AppTypography.displayMedium),
          const SizedBox(height: 8),
          Text(item.learningObjective, style: AppTypography.bodyLarge, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

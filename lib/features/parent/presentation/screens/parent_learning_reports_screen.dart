import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kids_english_adventure/core/routing/route_names.dart';
import 'package:kids_english_adventure/core/theme/app_colors.dart';
import 'package:kids_english_adventure/core/theme/app_radius.dart';
import 'package:kids_english_adventure/core/theme/app_typography.dart';
import 'package:kids_english_adventure/core/widgets/app_button.dart';
import 'package:kids_english_adventure/core/widgets/app_card.dart';
import 'package:kids_english_adventure/features/child_profile/presentation/providers/child_profile_providers.dart';

enum ReportPeriod {
  thisWeek,
  lastWeek,
  thisMonth,
}

/// Comprehensive, pedagogical Parent Learning Report.
class ParentLearningReportsScreen extends ConsumerStatefulWidget {
  const ParentLearningReportsScreen({super.key});

  @override
  ConsumerState<ParentLearningReportsScreen> createState() => _ParentLearningReportsScreenState();
}

class _ParentLearningReportsScreenState extends ConsumerState<ParentLearningReportsScreen> {
  ReportPeriod _selectedPeriod = ReportPeriod.thisWeek;

  @override
  Widget build(BuildContext context) {
    final activeChild = ref.watch(activeChildProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Learning Report 📊', style: AppTypography.headlineLarge),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () => context.go(RouteNames.parent),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Period Selector
            _buildPeriodSelector(),
            const SizedBox(height: 20),

            // Child Learning Overview Card
            if (activeChild != null) _buildOverviewCard(activeChild),
            const SizedBox(height: 20),

            // Skill Progress Report
            _buildSkillReportCard(),
            const SizedBox(height: 20),

            // AI Tutor & Practice Summary
            _buildAiPracticeSummaryCard(),
            const SizedBox(height: 20),

            // Strengths & Growth Areas
            _buildInsightsCard(),
            const SizedBox(height: 20),

            // Islamic Values Practiced
            _buildValuesReportCard(),
            const SizedBox(height: 20),

            // Parent Recommendation
            _buildParentRecommendationCard(),
            const SizedBox(height: 30),

            AppButton(
              text: 'Return to Parent Hub',
              minWidth: double.infinity,
              height: 54,
              backgroundColor: AppColors.primaryDark,
              onPressed: () => context.go(RouteNames.parent),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.roundedPill,
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          _buildPeriodButton('This Week', ReportPeriod.thisWeek),
          _buildPeriodButton('Last Week', ReportPeriod.lastWeek),
          _buildPeriodButton('This Month', ReportPeriod.thisMonth),
        ],
      ),
    );
  }

  Widget _buildPeriodButton(String label, ReportPeriod period) {
    final isSelected = _selectedPeriod == period;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedPeriod = period),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryDark : Colors.transparent,
            borderRadius: AppRadius.roundedPill,
          ),
          child: Text(
            label,
            style: AppTypography.headlineMedium.copyWith(
              fontSize: 14,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewCard(dynamic child) {
    final int minutes = _selectedPeriod == ReportPeriod.thisMonth ? 140 : 45;
    final int activities = _selectedPeriod == ReportPeriod.thisMonth ? 32 : 12;
    final int wordsLearned = _selectedPeriod == ReportPeriod.thisMonth ? 28 : 14;

    return AppCard(
      borderColor: AppColors.primary,
      backgroundColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.primaryLight,
                child: Text(child.name.isNotEmpty ? child.name[0] : 'A',
                    style: AppTypography.displayMedium.copyWith(color: AppColors.primaryDark)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${child.name}\'s Learning Journey', style: AppTypography.headlineLarge.copyWith(fontSize: 20)),
                    const SizedBox(height: 2),
                    Text('Age ${child.age} • ${child.xp} XP • ${child.streakDays}-day streak 🔥',
                        style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Minutes', '$minutes min', Icons.timer_outlined, AppColors.primaryDark),
              _buildStatItem('Activities', '$activities', Icons.check_circle_outline_rounded, AppColors.correctGreen),
              _buildStatItem('Words', '$wordsLearned', Icons.menu_book_rounded, AppColors.secondary),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 6),
        Text(value, style: AppTypography.headlineMedium.copyWith(fontSize: 18, color: color)),
        Text(label, style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildSkillReportCard() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Core Skill Progress', style: AppTypography.headlineMedium),
          const SizedBox(height: 16),
          _buildSkillRow('Vocabulary (Animal, Home, School, Food, Nature)', 0.85, AppColors.primaryDark, 'Strong'),
          const SizedBox(height: 12),
          _buildSkillRow('Interactive Conversations with Pip', 0.78, AppColors.secondary, 'Active Practice'),
          const SizedBox(height: 12),
          _buildSkillRow('Listening Comprehension', 0.80, AppColors.primary, 'Improving'),
          const SizedBox(height: 12),
          _buildSkillRow('Grammar & Plurals ("There is / are")', 0.75, AppColors.secondary, 'Developing'),
          const SizedBox(height: 12),
          _buildSkillRow('Speaking Practice & Pronunciation', 0.68, AppColors.tryAgainOrange, 'Practice Suggested'),
          const SizedBox(height: 12),
          _buildSkillRow('Story Reading & Meaning', 0.88, AppColors.correctGreen, 'Mastered'),
        ],
      ),
    );
  }

  Widget _buildSkillRow(String name, double progress, Color color, String trend) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(name, style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
            ),
            const SizedBox(width: 8),
            Text('$trend • ${(progress * 100).toInt()}%',
                style: AppTypography.badgeText.copyWith(color: color, fontSize: 13)),
          ],
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: AppColors.cardBorder,
          valueColor: AlwaysStoppedAnimation<Color>(color),
          borderRadius: AppRadius.roundedPill,
          minHeight: 8,
        ),
      ],
    );
  }

  Widget _buildInsightsCard() {
    return AppCard(
      backgroundColor: Colors.white,
      borderColor: AppColors.secondary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.psychology_outlined, color: AppColors.secondary, size: 26),
              const SizedBox(width: 8),
              Text('Learning Insights & Growth Areas', style: AppTypography.headlineMedium),
            ],
          ),
          const SizedBox(height: 14),
          _buildInsightBullet(
            '🌟 Strength:',
            'Vocabulary retention in Food and Animal words is strong and consistent.',
            AppColors.correctGreen,
          ),
          const SizedBox(height: 8),
          _buildInsightBullet(
            '📈 Growing:',
            'Reading comprehension in illustrated stories ("The Picnic of Sharing") is excellent.',
            AppColors.primaryDark,
          ),
          const SizedBox(height: 8),
          _buildInsightBullet(
            '🎯 Focus Area:',
            'Spoken pronunciation in the Speaking Lab benefits from 5 minutes of daily practice.',
            AppColors.tryAgainOrange,
          ),
        ],
      ),
    );
  }

  Widget _buildInsightBullet(String title, String desc, Color dotColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$title ', style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold, color: dotColor)),
        Expanded(
          child: Text(desc, style: AppTypography.bodyMedium),
        ),
      ],
    );
  }

  Widget _buildValuesReportCard() {
    final valuesList = [
      {'name': 'Gratitude (Shukr)', 'count': 8, 'color': AppColors.starGold, 'icon': '🌟'},
      {'name': 'Sharing (Ithaar)', 'count': 6, 'color': AppColors.secondary, 'icon': '🤝'},
      {'name': 'Cleanliness (Taharah)', 'count': 5, 'color': AppColors.valueMint, 'icon': '🧼'},
      {'name': 'Honesty (Sidq)', 'count': 4, 'color': AppColors.primary, 'icon': '💎'},
      {'name': 'Respect & Kindness', 'count': 7, 'color': AppColors.correctGreen, 'icon': '🤲'},
    ];

    return AppCard(
      borderColor: AppColors.valueEmerald,
      backgroundColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.favorite_rounded, color: AppColors.valueEmerald, size: 24),
              const SizedBox(width: 8),
              Text('Values & Good Manners Practiced', style: AppTypography.headlineMedium),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Character habits explored during interactive stories and scenario activities:',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: valuesList.map((v) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: AppRadius.roundedPill,
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(v['icon'] as String),
                    const SizedBox(width: 6),
                    Text(v['name'] as String, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.valueEmerald.withValues(alpha: 0.2),
                        borderRadius: AppRadius.roundedPill,
                      ),
                      child: Text('${v['count']}x', style: AppTypography.badgeText.copyWith(color: AppColors.valueEmerald, fontSize: 11)),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAiPracticeSummaryCard() {
    final sessions = _selectedPeriod == ReportPeriod.thisMonth ? 14 : 5;
    final minutes = _selectedPeriod == ReportPeriod.thisMonth ? 42 : 15;
    final successfulTurns = _selectedPeriod == ReportPeriod.thisMonth ? 38 : 12;

    return AppCard(
      borderColor: AppColors.primary,
      backgroundColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🦜', style: TextStyle(fontSize: 24)),
              const SizedBox(width: 8),
              Text('AI Practice with Pip', style: AppTypography.headlineMedium),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Child-friendly speaking and dialogue practice within approved curriculum themes.',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Sessions', '$sessions', Icons.chat_bubble_outline_rounded, AppColors.primaryDark),
              _buildStatItem('Practice Time', '$minutes min', Icons.timer_outlined, AppColors.secondary),
              _buildStatItem('Spoken Turns', '$successfulTurns', Icons.mic_none_rounded, AppColors.primary),
              _buildStatItem('Accuracy', '92%', Icons.check_circle_outline, AppColors.correctGreen),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(),
          const SizedBox(height: 8),
          Text('Curriculum Topics Practiced with Pip:', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            children: [
              Chip(
                backgroundColor: AppColors.primaryLight,
                label: Text('Outdoor Nature 🌳', style: AppTypography.badgeText.copyWith(color: AppColors.primaryDark)),
              ),
              Chip(
                backgroundColor: AppColors.secondaryLight,
                label: Text('Manners & Sharing 🤲', style: AppTypography.badgeText.copyWith(color: AppColors.secondaryDark)),
              ),
              Chip(
                backgroundColor: AppColors.cardBorder,
                label: Text('Animal Friends 🐘', style: AppTypography.badgeText),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildParentRecommendationCard() {
    return AppCard(
      backgroundColor: AppColors.primaryLight,
      borderColor: AppColors.primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lightbulb_rounded, color: AppColors.primaryDark, size: 26),
              const SizedBox(width: 8),
              Text('Parent Recommendation', style: AppTypography.headlineMedium.copyWith(color: AppColors.primaryDark)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Try 5 minutes of Food Speaking Practice together!\nPracticing sentences like "I have an apple" and "We share fresh fruit" builds speaking confidence and reinforces sharing.',
            style: AppTypography.bodyMedium,
          ),
        ],
      ),
    );
  }
}

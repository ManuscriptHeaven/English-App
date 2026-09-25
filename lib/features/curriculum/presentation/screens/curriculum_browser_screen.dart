import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kids_english_adventure/core/experience/age_experience_profile.dart';
import 'package:kids_english_adventure/core/experience/interactive_session_composer.dart';
import 'package:kids_english_adventure/core/theme/app_colors.dart';
import 'package:kids_english_adventure/features/curriculum/data/seed/v2/curriculum_content_v2.dart';
import 'package:kids_english_adventure/features/curriculum/domain/models/curriculum_lesson.dart';
import 'package:kids_english_adventure/features/curriculum/domain/models/curriculum_track.dart';
import 'package:kids_english_adventure/features/curriculum/domain/models/curriculum_unit.dart';
import 'package:kids_english_adventure/features/curriculum/domain/models/curriculum_world.dart';
import 'package:kids_english_adventure/features/games/presentation/screens/interactive_session_screen.dart';

/// Developer/QA Only: Comprehensive Curriculum V2 Browser & Playback Launchpad.
/// Allows QA to select any Age (3–12), Track, World, Unit, and Lesson,
/// inspect its educational objectives, and launch that exact lesson in the game player.
class CurriculumBrowserScreen extends ConsumerStatefulWidget {
  const CurriculumBrowserScreen({super.key});

  @override
  ConsumerState<CurriculumBrowserScreen> createState() =>
      _CurriculumBrowserScreenState();
}

class _CurriculumBrowserScreenState extends ConsumerState<CurriculumBrowserScreen> {
  int _selectedAge = 3;
  late CurriculumTrack _selectedTrack;
  CurriculumWorld? _selectedWorld;
  CurriculumUnit? _selectedUnit;
  CurriculumLesson? _selectedLesson;

  @override
  void initState() {
    super.initState();
    _selectedTrack = CurriculumContentV2.getTrackForAge(_selectedAge);
    _syncSelections();
  }

  void _onAgeChanged(int age) {
    setState(() {
      _selectedAge = age;
      _selectedTrack = CurriculumContentV2.getTrackForAge(age);
      _syncSelections();
    });
  }

  void _onTrackChanged(CurriculumTrack track) {
    setState(() {
      _selectedTrack = track;
      _selectedAge = track.minAge;
      _syncSelections();
    });
  }

  void _syncSelections() {
    final worlds = CurriculumContentV2.getWorldsForTrack(_selectedTrack);
    _selectedWorld = worlds.isNotEmpty ? worlds.first : null;

    if (_selectedWorld != null) {
      final units = CurriculumContentV2.getUnitsForWorld(_selectedWorld!.id);
      _selectedUnit = units.isNotEmpty ? units.first : null;
    } else {
      _selectedUnit = null;
    }

    if (_selectedUnit != null) {
      final lessons = CurriculumContentV2.getLessonsForUnit(_selectedUnit!.id);
      _selectedLesson = lessons.isNotEmpty ? lessons.first : null;
    } else {
      _selectedLesson = null;
    }
  }

  void _launchLesson(BuildContext context) {
    if (_selectedLesson == null) return;
    final profile = AgeExperienceProfile.forAge(_selectedAge);
    final session = InteractiveSessionComposer.composeSession(
      ageProfile: profile,
      lessonId: _selectedLesson!.id,
      title: _selectedLesson!.title,
    );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => InteractiveSessionScreen(session: session),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final stats = CurriculumContentV2.generateLiveStats();
    final worlds = CurriculumContentV2.getWorldsForTrack(_selectedTrack);
    final units = _selectedWorld != null
        ? CurriculumContentV2.getUnitsForWorld(_selectedWorld!.id)
        : <CurriculumUnit>[];
    final lessons = _selectedUnit != null
        ? CurriculumContentV2.getLessonsForUnit(_selectedUnit!.id)
        : <CurriculumLesson>[];
    final currentActivities = _selectedLesson != null
        ? CurriculumContentV2.getActivitiesForLesson(_selectedLesson!.id)
        : [];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Curriculum QA Browser (Dev)',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: AppColors.earthDark,
        foregroundColor: Colors.white,
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: AppColors.sunYellow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'DEV ONLY',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w900,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF5F7FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Live Counts Banner ──
            _buildMetricsBanner(stats),
            const SizedBox(height: 16),

            // ── 1. Age Selector ──
            const Text(
              'Select Child Age:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(10, (index) {
                  final age = index + 3; // 3 to 12
                  final isSelected = _selectedAge == age;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text('Age $age'),
                      selected: isSelected,
                      selectedColor: AppColors.meadowGreen,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      onSelected: (_) => _onAgeChanged(age),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 16),

            // ── 2. Track Selector ──
            const Text(
              'Production Track:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<CurriculumTrack>(
                  value: _selectedTrack,
                  isExpanded: true,
                  items: CurriculumTrack.values.map((t) {
                    return DropdownMenuItem(
                      value: t,
                      child: Text('${t.title} (${t.ageRange})'),
                    );
                  }).toList(),
                  onChanged: (track) {
                    if (track != null) _onTrackChanged(track);
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── 3. World Selector ──
            const Text(
              'World Domain:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<CurriculumWorld>(
                  value: _selectedWorld,
                  isExpanded: true,
                  items: worlds.map((w) {
                    return DropdownMenuItem(
                      value: w,
                      child: Text(w.childFriendlyTitle),
                    );
                  }).toList(),
                  onChanged: (world) {
                    if (world != null) {
                      setState(() {
                        _selectedWorld = world;
                        final u = CurriculumContentV2.getUnitsForWorld(world.id);
                        _selectedUnit = u.isNotEmpty ? u.first : null;
                        if (_selectedUnit != null) {
                          final l = CurriculumContentV2.getLessonsForUnit(_selectedUnit!.id);
                          _selectedLesson = l.isNotEmpty ? l.first : null;
                        } else {
                          _selectedLesson = null;
                        }
                      });
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── 4. Unit Selector ──
            const Text(
              'Unit:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<CurriculumUnit>(
                  value: _selectedUnit,
                  isExpanded: true,
                  items: units.map((u) {
                    return DropdownMenuItem(
                      value: u,
                      child: Text('${u.title} (${u.lessonIds.length} lessons)'),
                    );
                  }).toList(),
                  onChanged: (unit) {
                    if (unit != null) {
                      setState(() {
                        _selectedUnit = unit;
                        final l = CurriculumContentV2.getLessonsForUnit(unit.id);
                        _selectedLesson = l.isNotEmpty ? l.first : null;
                      });
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── 5. Lesson Selector ──
            const Text(
              'Select Lesson to Launch:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<CurriculumLesson>(
                  value: _selectedLesson,
                  isExpanded: true,
                  items: lessons.map((l) {
                    return DropdownMenuItem(
                      value: l,
                      child: Text('Lesson ${l.order}: ${l.title}'),
                    );
                  }).toList(),
                  onChanged: (lesson) {
                    if (lesson != null) {
                      setState(() => _selectedLesson = lesson);
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ── Selected Lesson Details Card ──
            if (_selectedLesson != null) ...[
              _buildLessonDetailCard(_selectedLesson!, currentActivities),
              const SizedBox(height: 20),

              // ── Launch Button ──
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.rocket_launch_rounded, size: 26),
                  label: const Text(
                    'LAUNCH EXACT LESSON IN PLAYER 🚀',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.sunYellow,
                    foregroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                  ),
                  onPressed: () => _launchLesson(context),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsBanner(Map<String, dynamic> stats) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.earthDark,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(40),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text('📊', style: TextStyle(fontSize: 20)),
              SizedBox(width: 8),
              Text(
                'LIVE CURRICULUM V2 REPOSITORY',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _metricItem('${stats['totalTracks']}', 'Tracks', '🧭'),
              _metricItem('${stats['totalWorlds']}', 'Worlds', '🌍'),
              _metricItem('${stats['totalUnits']}', 'Units', '📚'),
              _metricItem('${stats['totalLessons']}', 'Lessons', '🎯'),
              _metricItem('${stats['totalInteractions']}', 'Steps', '⚡'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _metricItem(String value, String label, String icon) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 18,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildLessonDetailCard(
    CurriculumLesson lesson,
    List<dynamic> activities,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  lesson.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: AppColors.earthDark,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.meadowLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${activities.length} Interactions',
                  style: const TextStyle(
                    color: AppColors.meadowDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          _detailRow('Speaking Goal', lesson.speakingOutcome),
          const SizedBox(height: 6),
          _detailRow('Listening Goal', lesson.listeningOutcome),
          const SizedBox(height: 6),
          _detailRow('Duration', '~${lesson.estimatedDurationMinutes} minutes'),
          const SizedBox(height: 12),
          const Text(
            'Interactive Activity Sequence:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 8),
          ...activities.asMap().entries.map((entry) {
            final idx = entry.key + 1;
            final act = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: AppColors.w3Accent,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$idx',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${act.mechanicType.name}: ${act.instructionOverride ?? ''}',
                      style: const TextStyle(fontSize: 12, color: Colors.black87),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return RichText(
      text: TextSpan(
        text: '$label: ',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black87,
          fontSize: 12,
        ),
        children: [
          TextSpan(
            text: value,
            style: const TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kids_english_adventure/core/theme/app_colors.dart';
import 'package:kids_english_adventure/core/theme/app_radius.dart';
import 'package:kids_english_adventure/core/theme/app_typography.dart';
import 'package:kids_english_adventure/features/content_engine/domain/models/content_item.dart';
import 'package:kids_english_adventure/features/content_engine/domain/services/content_validator.dart';
import 'package:kids_english_adventure/features/content_engine/presentation/screens/generic_activity_screen.dart';

/// Developer and content-reviewer preview screen.
/// Renders using the exact same activity renderer registry while showing validation metadata.
class ContentPreviewScreen extends ConsumerStatefulWidget {
  final String contentId;

  const ContentPreviewScreen({
    super.key,
    required this.contentId,
  });

  @override
  ConsumerState<ContentPreviewScreen> createState() => _ContentPreviewScreenState();
}

class _ContentPreviewScreenState extends ConsumerState<ContentPreviewScreen> {
  ContentItem? _item;
  List<String> _validationErrors = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAndValidate();
  }

  Future<void> _loadAndValidate() async {
    final repo = ref.read(localContentRepositoryProvider);
    final item = await repo.getContentItemById(widget.contentId);
    if (item != null) {
      final errors = ContentValidator.validateContentItem(item);
      if (mounted) {
        setState(() {
          _item = item;
          _validationErrors = errors;
          _isLoading = false;
        });
      }
    } else {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_item == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Content Studio Preview')),
        body: Center(child: Text('Content item not found: ${widget.contentId}')),
      );
    }

    final item = _item!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Studio Preview 🛠️', style: AppTypography.headlineLarge),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          // Reviewer Metadata Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: AppColors.primaryDark,
            child: Row(
              children: [
                const Icon(Icons.verified_outlined, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Previewing: ${item.id} (${item.activityType.name}) • Status: ${item.reviewStatus.name}',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _validationErrors.isEmpty ? AppColors.correctGreen : AppColors.tryAgainOrange,
                    borderRadius: AppRadius.roundedPill,
                  ),
                  child: Text(
                    _validationErrors.isEmpty ? 'VALID ✓' : '${_validationErrors.length} ISSUES ⚠️',
                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          // Render Child UI via GenericActivityScreen
          Expanded(
            child: GenericActivityScreen(contentId: widget.contentId),
          ),
        ],
      ),
    );
  }
}

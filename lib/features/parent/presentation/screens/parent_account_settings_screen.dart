import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kids_english_adventure/core/routing/route_names.dart';
import 'package:kids_english_adventure/core/theme/app_colors.dart';
import 'package:kids_english_adventure/core/theme/app_radius.dart';
import 'package:kids_english_adventure/core/theme/app_typography.dart';
import 'package:kids_english_adventure/core/widgets/app_button.dart';
import 'package:kids_english_adventure/core/widgets/app_card.dart';
import 'package:kids_english_adventure/features/ai_tutor/presentation/widgets/ai_parent_settings_card.dart';
import 'package:kids_english_adventure/features/auth/presentation/providers/auth_providers.dart';
import 'package:kids_english_adventure/features/child_profile/presentation/providers/child_profile_providers.dart';
import 'package:kids_english_adventure/features/sync/presentation/providers/sync_providers.dart';

/// Parent Account & Cloud Settings screen.
class ParentAccountSettingsScreen extends ConsumerStatefulWidget {
  const ParentAccountSettingsScreen({super.key});

  @override
  ConsumerState<ParentAccountSettingsScreen> createState() => _ParentAccountSettingsScreenState();
}

class _ParentAccountSettingsScreenState extends ConsumerState<ParentAccountSettingsScreen> {
  String? _exportedJson;
  bool _isExporting = false;

  void _triggerExport() async {
    setState(() => _isExporting = true);
    final activeChild = ref.read(activeChildProfileProvider);

    final exportMap = {
      'exportDate': DateTime.now().toIso8601String(),
      'child': activeChild?.toJson(),
      'version': '1.0',
      'privacy': 'Strictly confidential parental export',
    };

    final prettyJson = const JsonEncoder.withIndent('  ').convert(exportMap);
    await Future.delayed(const Duration(milliseconds: 300));

    if (mounted) {
      setState(() {
        _exportedJson = prettyJson;
        _isExporting = false;
      });
      _showExportDialog();
    }
  }

  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.roundedLg),
        title: const Text('Child Learning Data Exported 📦'),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Text(
              _exportedJson ?? '',
              style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showDeleteChildDialog() {
    final activeChild = ref.read(activeChildProfileProvider);
    if (activeChild == null) return;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.roundedLg),
        title: Text('Delete ${activeChild.name}\'s Profile? ⚠️'),
        content: Text(
          'This will permanently delete ${activeChild.name}\'s learning history, masteries, rewards, and progress. This action cannot be undone.',
          style: AppTypography.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.tryAgainOrange),
            onPressed: () async {
              Navigator.of(ctx).pop();
              // Delete child
              await ref.read(childProfileRepositoryProvider).deleteChildProfile(activeChild.id);
              ref.invalidate(childProfilesProvider);
              if (mounted) {
                context.go(RouteNames.childSelection);
              }
            },
            child: const Text('Delete Profile', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final parentAsync = ref.watch(currentParentAccountProvider);
    final syncStatusAsync = ref.watch(syncStatusProvider);
    final activeChild = ref.watch(activeChildProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Parent Account & Sync', style: AppTypography.headlineLarge),
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
            // Parent Profile
            parentAsync.when(
              loading: () => const LinearProgressIndicator(),
              error: (err, _) => Text('Error loading account: $err'),
              data: (account) {
                return AppCard(
                  borderColor: AppColors.primary,
                  backgroundColor: Colors.white,
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 28,
                        backgroundColor: AppColors.primaryLight,
                        child: Icon(Icons.admin_panel_settings_rounded, color: AppColors.primaryDark, size: 30),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(account?.displayName ?? 'Parent Account', style: AppTypography.titleLarge),
                            const SizedBox(height: 2),
                            Text(account?.email ?? 'parent@adventure.kids',
                                style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
                            const SizedBox(height: 4),
                            Text('Plan: Free Explorer Tier', style: AppTypography.badgeText.copyWith(color: AppColors.primaryDark)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            // Cloud Sync Status Card
            AppCard(
              borderColor: AppColors.secondary,
              backgroundColor: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.cloud_sync_rounded, color: AppColors.secondary, size: 24),
                          const SizedBox(width: 8),
                          Text('Cloud Data Sync', style: AppTypography.headlineMedium),
                        ],
                      ),
                      syncStatusAsync.when(
                        loading: () => const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                        error: (_, _) => Text('Offline', style: AppTypography.badgeText.copyWith(color: AppColors.tryAgainOrange)),
                        data: (info) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.correctGreen.withValues(alpha: 0.15),
                            borderRadius: AppRadius.roundedPill,
                          ),
                          child: Text(info.displayLabel, style: AppTypography.badgeText.copyWith(color: AppColors.correctGreen)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Progress saves locally and synchronizes to cloud when connected.',
                    style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 14),
                  AppButton(
                    text: 'Sync All Progress Now 🔄',
                    minWidth: double.infinity,
                    height: 48,
                    backgroundColor: AppColors.secondary,
                    onPressed: () async {
                      await ref.read(syncServiceProvider).processPendingQueue();
                      ref.invalidate(syncStatusProvider);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // AI Tutor & Conversation Settings Card
            const AiParentSettingsCard(),
            const SizedBox(height: 20),

            // Data Management Card
            AppCard(
              backgroundColor: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Child Profile Data', style: AppTypography.headlineMedium),
                  const SizedBox(height: 12),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: AppRadius.roundedMd,
                      onTap: _triggerExport,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            const Icon(Icons.file_download_outlined, color: AppColors.primaryDark, size: 28),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Export Learning History (JSON)', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                                  const SizedBox(height: 2),
                                  Text('Download ${activeChild?.name ?? 'Child'}\'s progress dataset', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
                                ],
                              ),
                            ),
                            _isExporting
                                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                                : const Icon(Icons.chevron_right_rounded),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Divider(),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: AppRadius.roundedMd,
                      onTap: _showDeleteChildDialog,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            const Icon(Icons.delete_outline_rounded, color: AppColors.tryAgainOrange, size: 28),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Delete ${activeChild?.name ?? 'Child'}\'s Profile',
                                      style: const TextStyle(color: AppColors.tryAgainOrange, fontWeight: FontWeight.w600, fontSize: 16)),
                                  const SizedBox(height: 2),
                                  Text('Permanently remove learning records', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right_rounded, color: AppColors.tryAgainOrange),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            AppButton(
              text: 'Sign Out Parent Account',
              minWidth: double.infinity,
              height: 52,
              backgroundColor: AppColors.cardBorder,
              foregroundColor: AppColors.textPrimary,
              onPressed: () async {
                await ref.read(authServiceProvider).logout();
                if (context.mounted) {
                  context.go(RouteNames.welcome);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

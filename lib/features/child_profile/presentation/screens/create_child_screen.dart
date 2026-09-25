import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/age_group_config.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import 'package:kids_english_adventure/features/child_profile/domain/models/avatar.dart';
import 'package:kids_english_adventure/features/child_profile/domain/models/child_profile.dart';
import '../providers/child_profile_providers.dart';

class CreateChildScreen extends ConsumerStatefulWidget {
  const CreateChildScreen({super.key});

  @override
  ConsumerState<CreateChildScreen> createState() => _CreateChildScreenState();
}

class _CreateChildScreenState extends ConsumerState<CreateChildScreen> {
  final TextEditingController _nameController = TextEditingController();
  int _selectedAge = 5;
  String _selectedGender = 'boy';

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveChild() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final id = 'child_${const Uuid().v4().substring(0, 8)}';
    final avatar = Avatar(
      id: 'avatar_$_selectedGender',
      name: name,
      assetPath: 'assets/avatars/${_selectedGender}_1.png',
    );

    final profile = ChildProfile(
      id: id,
      parentId: 'parent_1',
      name: name,
      age: _selectedAge,
      gender: _selectedGender,
      avatar: avatar,
    );

    ref.read(activeChildProfileProvider.notifier).createProfile(profile);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppStrings.addProfile, style: AppTypography.headlineLarge),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Explorer Name', style: AppTypography.titleLarge),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'e.g. Ayaan, Maryam, Zayd',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: AppRadius.roundedLg,
                  borderSide: const BorderSide(color: AppColors.cardBorder, width: 2),
                ),
              ),
              style: AppTypography.headlineMedium,
            ),
            const SizedBox(height: 24),
            Text(AppStrings.selectAge, style: AppTypography.titleLarge),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [3, 4, 5, 6, 7, 8, 9, 10].map((age) {
                final isSelected = _selectedAge == age;
                return GestureDetector(
                  onTap: () => setState(() => _selectedAge = age),
                  child: Container(
                    width: 38,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.secondary : Colors.white,
                      borderRadius: AppRadius.roundedMd,
                      border: Border.all(
                        color: isSelected ? AppColors.secondaryDark : AppColors.cardBorder,
                        width: 2,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '$age',
                      style: AppTypography.headlineMedium.copyWith(
                        color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: AppRadius.roundedMd,
              ),
              child: Text(
                'Adaptive Level: ${AgeGroupType.fromAge(_selectedAge).title} (${AgeGroupType.fromAge(_selectedAge).description})',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.primaryDark),
              ),
            ),
            const SizedBox(height: 24),
            Text('Select Character', style: AppTypography.titleLarge),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: AppCard(
                    borderColor: _selectedGender == 'boy' ? AppColors.primary : AppColors.cardBorder,
                    backgroundColor: _selectedGender == 'boy' ? AppColors.primaryLight : Colors.white,
                    onTap: () => setState(() => _selectedGender = 'boy'),
                    child: Column(
                      children: [
                        const Icon(Icons.face_rounded, size: 54, color: AppColors.primary),
                        const SizedBox(height: 8),
                        Text('Boy Explorer', style: AppTypography.titleLarge),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AppCard(
                    borderColor: _selectedGender == 'girl' ? AppColors.accent : AppColors.cardBorder,
                    backgroundColor: _selectedGender == 'girl' ? AppColors.accentLight : Colors.white,
                    onTap: () => setState(() => _selectedGender = 'girl'),
                    child: Column(
                      children: [
                        const Icon(Icons.face_3_rounded, size: 54, color: AppColors.accent),
                        const SizedBox(height: 8),
                        Text('Girl Explorer', style: AppTypography.titleLarge),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            AppButton(
              text: 'Save & Start Exploring! ✨',
              minWidth: double.infinity,
              height: 60,
              backgroundColor: AppColors.secondary,
              onPressed: _saveChild,
            ),
          ],
        ),
      ),
    );
  }
}

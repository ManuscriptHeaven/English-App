import 'package:flutter/material.dart';
import '../services/parent_gate_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_radius.dart';
import '../constants/app_strings.dart';
import 'app_button.dart';

/// Modal dialog that presents an age challenge or PIN entry for parent verification.
class ParentGateDialog extends StatefulWidget {
  final ParentGateService gateService;
  final VoidCallback onVerified;

  const ParentGateDialog({
    super.key,
    required this.gateService,
    required this.onVerified,
  });

  static Future<bool?> show(BuildContext context, ParentGateService gateService) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => ParentGateDialog(
        gateService: gateService,
        onVerified: () => Navigator.of(context).pop(true),
      ),
    );
  }

  @override
  State<ParentGateDialog> createState() => _ParentGateDialogState();
}

class _ParentGateDialogState extends State<ParentGateDialog> {
  late ParentGateChallenge _challenge;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _refreshChallenge();
  }

  void _refreshChallenge() {
    setState(() {
      _challenge = widget.gateService.generateMathChallenge();
      _errorMessage = null;
    });
  }

  void _selectAnswer(int answer) {
    if (widget.gateService.verifyChallengeAnswer(answer, _challenge.correctAnswer)) {
      widget.onVerified();
    } else {
      setState(() {
        _errorMessage = AppStrings.incorrectAnswer;
      });
      Future.delayed(const Duration(seconds: 1), _refreshChallenge);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.roundedXl),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 32),
                Text(
                  AppStrings.parentGateTitle,
                  style: AppTypography.headlineLarge,
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  icon: const Icon(Icons.close_rounded, size: 28),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              AppStrings.parentGateSubtitle,
              style: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: AppRadius.roundedLg,
              ),
              child: Text(
                _challenge.question,
                style: AppTypography.displayMedium.copyWith(
                  color: AppColors.primaryDark,
                  letterSpacing: 2,
                ),
              ),
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 12),
              Text(
                _errorMessage!,
                style: AppTypography.bodyMedium.copyWith(color: AppColors.errorRed),
              ),
            ],
            const SizedBox(height: 24),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: _challenge.options.map((option) {
                return AppButton(
                  text: '$option',
                  minWidth: 80,
                  height: 52,
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  onPressed: () => _selectAnswer(option),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

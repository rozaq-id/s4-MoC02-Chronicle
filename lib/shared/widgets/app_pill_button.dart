import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// A stylized pill button used across the auth flow.
/// Variants: filled gold (primary) and outline (secondary / social).
class AppPillButton extends StatelessWidget {
  const AppPillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.variant = AppPillButtonVariant.filled,
    this.iconOnRight = false,
  });

  final String label;
  final Widget? icon;
  final VoidCallback onPressed;
  final AppPillButtonVariant variant;
  final bool iconOnRight;

  @override
  Widget build(BuildContext context) {
    final bool isFilled = variant == AppPillButtonVariant.filled;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: isFilled ? 8 : 0,
          shadowColor: isFilled
              ? Colors.black.withValues(alpha: 0.5)
              : Colors.transparent,
          backgroundColor: isFilled ? AppColors.gold : AppColors.inputBg,
          foregroundColor: isFilled
              ? AppColors.textOnGold
              : AppColors.textPrimary,
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
          shape: const StadiumBorder(),
          side: isFilled ? null : BorderSide(color: AppColors.border, width: 1),
          textStyle: AppTextStyles.button.copyWith(
            color: isFilled ? AppColors.textOnGold : AppColors.textPrimary,
          ),
        ),
        child: icon == null
            ? Text(label)
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!iconOnRight) ...[
                    if (icon is Icon) icon! else SizedBox(height: 20, width: 20, child: icon!),
                    const SizedBox(width: 8),
                  ],
                  Text(label),
                  if (iconOnRight) ...[
                    const SizedBox(width: 8),
                    if (icon is Icon) icon! else SizedBox(height: 20, width: 20, child: icon!),
                  ],
                ],
              ),
      ),
    );
  }
}

enum AppPillButtonVariant { filled, outline }

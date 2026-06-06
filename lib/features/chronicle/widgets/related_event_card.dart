import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Related event shown in the horizontal scroll at the bottom of EventDetail.
class RelatedEventCard extends StatelessWidget {
  const RelatedEventCard({
    super.key,
    required this.year,
    required this.title,
    required this.onTap,
  });

  final String year;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 192,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.cardAlt,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.42)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              year,
              style: AppTextStyles.ui(weight: FontWeight.w600).copyWith(
                fontSize: 12,
                color: AppColors.gold,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.display(weight: FontWeight.w600).copyWith(
                  fontSize: 18,
                  color: AppColors.textPrimary,
                  height: 24 / 18,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

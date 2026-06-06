import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Category tab used in the Home page segmented control.
enum ChronicleCategory { events, births, deaths }

/// Segmented control / pill tabs for the Home page.
class CategoryTabs extends StatelessWidget {
  const CategoryTabs({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final ChronicleCategory selected;
  final ValueChanged<ChronicleCategory> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: const Color(0xFF201B11),
          borderRadius: BorderRadius.circular(9999),
          border: Border.all(color: const Color(0xFF30363D)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: ChronicleCategory.values.map((cat) {
            final isActive = cat == selected;
            return GestureDetector(
              onTap: () => onChanged(cat),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.goldDeep : Colors.transparent,
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Text(
                  _label(cat),
                  style: AppTextStyles.ui(weight: FontWeight.w600).copyWith(
                    fontSize: 14,
                    color: isActive
                        ? const Color(0xFF181309)
                        : AppColors.textPrimary,
                    letterSpacing: 0.05 * 14,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  String _label(ChronicleCategory cat) {
    switch (cat) {
      case ChronicleCategory.events:
        return 'Events';
      case ChronicleCategory.births:
        return 'Births';
      case ChronicleCategory.deaths:
        return 'Deaths';
    }
  }
}

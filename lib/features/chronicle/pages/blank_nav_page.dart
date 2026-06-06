import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/bottom_nav_bar.dart';

class BlankNavPage extends StatelessWidget {
  const BlankNavPage({super.key, required this.currentIndex});

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: const SizedBox.expand(),
      bottomNavigationBar: BottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) => _goToTab(context, index),
      ),
    );
  }

  void _goToTab(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
        return;
      case 1:
        context.go('/explore');
        return;
      case 2:
        context.go('/bookmarks');
        return;
      case 3:
        context.go('/settings');
        return;
    }
  }
}

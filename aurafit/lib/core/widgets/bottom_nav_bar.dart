import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Redesigned floating capsule bottom navigation bar
class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      // Padding for the whole nav bar to make it float
      padding: const EdgeInsets.only(bottom: 24, left: 20, right: 20),
      color: Colors.transparent,
      child: Container(
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: isDark ? Colors.black : context.colors.surface,
          borderRadius: BorderRadius.circular(35),
          border: Border.all(
            color: context.colors.border.withOpacity(isDark ? 0.3 : 1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNavItem(context, 0, Icons.home_outlined, 'Home'),
            _buildNavItem(context, 1, Icons.grid_view_rounded, 'Workouts'),
            _buildNavItem(context, 2, Icons.shopping_bag_outlined, 'Coach'),
            _buildNavItem(context, 3, Icons.bookmark_border_rounded, 'Stats'),
            _buildNavItem(context, 4, Icons.person_outline_rounded, 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, IconData icon, String label) {
    final isActive = currentIndex == index;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: isActive ? 16 : 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isActive
            ? (isDark ? Colors.white.withOpacity(0.15) : context.colors.primary.withOpacity(0.1))
            : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: isActive
                ? (isDark ? Colors.white : context.colors.primary)
                : (isDark ? Colors.white.withOpacity(0.5) : context.colors.textMuted),
            ),
            if (isActive) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isDark ? Colors.white : context.colors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}


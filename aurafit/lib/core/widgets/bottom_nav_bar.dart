import 'dart:ui';
import 'package:flutter/material.dart';

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
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
        child: Container(
          width: double.infinity,
          height: 82,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 44),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(0, Icons.home_filled),
              _buildNavItem(1, Icons.grid_view_rounded),
              _buildNavItem(2, Icons.work_rounded),
              _buildNavItem(3, Icons.bookmark_rounded),
              _buildNavItem(4, Icons.person_rounded),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon) {
    final isActive = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Icon(
        icon,
        size: 28,
        color: isActive ? const Color(0xFFC6FF00) : Colors.white,
      ),
    );
  }
}

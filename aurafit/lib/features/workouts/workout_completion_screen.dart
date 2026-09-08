import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/gradient_button.dart';
import '../../core/constants/app_routes.dart';

class WorkoutCompletionScreen extends StatelessWidget {
  const WorkoutCompletionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // Celebration header
                    _buildCelebrationHeader()
                        .animate()
                        .scale(duration: 600.ms, curve: Curves.elasticOut),
                    const SizedBox(height: 32),
                    // Stats grid
                    _buildStatsGrid()
                        .animate()
                        .fadeIn(delay: 400.ms)
                        .slideY(begin: 0.1),
                    const SizedBox(height: 24),
                    // AI Recovery insight
                    _buildAIRecoveryCard()
                        .animate()
                        .fadeIn(delay: 600.ms)
                        .slideY(begin: 0.1),
                    const SizedBox(height: 24),
                    // Rating
                    _buildRatingSection()
                        .animate()
                        .fadeIn(delay: 800.ms),
                    const SizedBox(height: 32),
                    // Actions
                    GradientButton(
                      label: '🎉  Share Achievement',
                      gradient: AppColors.greenGradient,
                      onTap: () {},
                    ).animate().fadeIn(delay: 900.ms),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoutes.home,
                          (r) => false,
                        ),
                        child: Text('Back to Home',
                            style: AppTextStyles.labelLarge
                                .copyWith(color: AppColors.primary)),
                      ),
                    ).animate().fadeIn(delay: 1000.ms),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCelebrationHeader() {
    return Column(
      children: [
        // Trophy / glow
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const RadialGradient(
              colors: [
                Color(0xFF22C55E),
                Color(0xFF10B981),
                AppColors.background,
              ],
              stops: [0, 0.5, 1],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.accentGreen.withOpacity(0.4),
                blurRadius: 40,
                spreadRadius: 10,
              ),
            ],
          ),
          child: const Icon(Icons.emoji_events_rounded,
              color: Colors.white, size: 56),
        ),
        const SizedBox(height: 20),
        Text(
          'Workout Complete! 🔥',
          style: AppTextStyles.displayMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'You crushed it! Full Body HIIT done.',
          style: AppTextStyles.bodyMedium
              .copyWith(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildStatsGrid() {
    final stats = [
      _CompletionStat(
          icon: Icons.timer_outlined, value: '32:14', label: 'Duration',
          color: AppColors.primary),
      _CompletionStat(
          icon: Icons.local_fire_department_rounded, value: '324', label: 'kcal',
          color: AppColors.accentOrange),
      _CompletionStat(
          icon: Icons.favorite_rounded, value: '128', label: 'Avg BPM',
          color: AppColors.accentRed),
      _CompletionStat(
          icon: Icons.calendar_today_rounded, value: '5', label: 'Day Streak',
          color: AppColors.secondary),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.4,
      children: stats.map((s) => _buildStatCard(s)).toList(),
    );
  }

  Widget _buildStatCard(_CompletionStat stat) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: stat.color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(stat.icon, color: stat.color, size: 18),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(stat.value,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: stat.color,
                  )),
              Text(stat.label, style: AppTextStyles.caption),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAIRecoveryCard() {
    return GlassCard(
      gradient: const LinearGradient(
        colors: [Color(0xFF0D1A2D), Color(0xFF0D0D2D)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderColor: AppColors.primary.withOpacity(0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.auto_awesome_rounded,
                    color: AppColors.primary, size: 18),
              ),
              const SizedBox(width: 10),
              Text('Aura AI Recovery Insight',
                  style: AppTextStyles.labelLarge
                      .copyWith(color: AppColors.primary)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Great session! Your intensity was optimal. Drink 500ml water and have a protein-rich meal within the next 45 minutes. Schedule your next workout in 48 hours for maximum recovery.',
            style: AppTextStyles.bodySmall
                .copyWith(color: AppColors.textSecondary, height: 1.6),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _buildRecoveryBadge('💧 Hydrate', AppColors.primary),
              const SizedBox(width: 8),
              _buildRecoveryBadge('🥩 Protein', AppColors.accentOrange),
              const SizedBox(width: 8),
              _buildRecoveryBadge('😴 Rest 48h', AppColors.secondary),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecoveryBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(label,
          style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color)),
    );
  }

  Widget _buildRatingSection() {
    return GlassCard(
      child: Column(
        children: [
          Text('How was this workout?', style: AppTextStyles.h4),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
              (i) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: GestureDetector(
                  onTap: () {},
                  child: Icon(
                    i < 4 ? Icons.star_rounded : Icons.star_border_rounded,
                    color: i < 4
                        ? AppColors.accentOrange
                        : AppColors.textMuted,
                    size: 36,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CompletionStat {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _CompletionStat({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/gradient_button.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen>
    with SingleTickerProviderStateMixin {
  bool _isAnnual = true;
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  final List<_Feature> _features = const [
    _Feature(Icons.auto_awesome_rounded, 'Unlimited AI Coach Chat',
        'Real-time personalized guidance'),
    _Feature(Icons.mic_rounded, 'AI Voice Coaching',
        'Hands-free coaching during workouts'),
    _Feature(Icons.calendar_month_rounded, 'Custom AI Workout Plans',
        'Auto-adjusting programs'),
    _Feature(Icons.bar_chart_rounded, 'Advanced Analytics',
        'Deep performance insights'),
    _Feature(Icons.watch_rounded, 'Wearable Integration',
        'Apple Watch, Garmin & more'),
    _Feature(Icons.block_rounded, 'Ad-Free Experience',
        'Pure, uninterrupted training'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Close button
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Icon(Icons.close_rounded,
                          color: AppColors.textSecondary, size: 18),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Hero
                    _buildHero()
                        .animate()
                        .scale(duration: 600.ms, curve: Curves.elasticOut)
                        .fadeIn(),
                    const SizedBox(height: 28),
                    // Pricing toggle
                    _buildPricingToggle()
                        .animate()
                        .fadeIn(delay: 300.ms)
                        .slideY(begin: 0.05),
                    const SizedBox(height: 20),
                    // Price cards
                    _buildPriceCards()
                        .animate()
                        .fadeIn(delay: 400.ms)
                        .slideY(begin: 0.05),
                    const SizedBox(height: 24),
                    // Features
                    GlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Everything in Aura Pro',
                              style: AppTextStyles.h4),
                          const SizedBox(height: 16),
                          ..._features
                              .asMap()
                              .entries
                              .map((e) => Padding(
                                    padding: const EdgeInsets.only(bottom: 14),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 36,
                                          height: 36,
                                          decoration: BoxDecoration(
                                            color: AppColors.primary
                                                .withOpacity(0.12),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Icon(e.value.icon,
                                              color: AppColors.primary,
                                              size: 18),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(e.value.title,
                                                  style: AppTextStyles.labelLarge),
                                              Text(e.value.subtitle,
                                                  style: AppTextStyles.caption),
                                            ],
                                          ),
                                        ),
                                        const Icon(
                                            Icons.check_circle_rounded,
                                            color: AppColors.accentGreen,
                                            size: 20),
                                      ],
                                    ),
                                  ))
                              ,
                        ],
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 500.ms)
                        .slideY(begin: 0.05),
                    const SizedBox(height: 24),
                    // CTA
                    GradientButton(
                      label: '🚀  Start 7-Day Free Trial',
                      gradient: AppColors.cyanPurpleGradient,
                      onTap: () => Navigator.pop(context),
                    ).animate().fadeIn(delay: 700.ms),
                    const SizedBox(height: 12),
                    Text(
                      'Cancel anytime. No commitment.',
                      style: AppTextStyles.caption,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: Text('Privacy Policy',
                              style: AppTextStyles.caption
                                  .copyWith(color: AppColors.primary)),
                        ),
                        Text('·', style: AppTextStyles.caption),
                        TextButton(
                          onPressed: () {},
                          child: Text('Terms of Service',
                              style: AppTextStyles.caption
                                  .copyWith(color: AppColors.primary)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHero() {
    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        return Column(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const RadialGradient(
                  colors: [Color(0xFF00F0FF), Color(0xFFA855F7)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(
                        0.3 + _glowController.value * 0.3),
                    blurRadius: 30 + _glowController.value * 20,
                    spreadRadius: 5 + _glowController.value * 5,
                  ),
                  BoxShadow(
                    color: AppColors.secondary.withOpacity(
                        0.2 + _glowController.value * 0.2),
                    blurRadius: 40,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(Icons.workspace_premium_rounded,
                  color: Colors.white, size: 48),
            ),
            const SizedBox(height: 20),
            Text('Unlock Your Full Potential',
                style: AppTextStyles.displayMedium,
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              'Join thousands of athletes training smarter with Aura AI',
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        );
      },
    );
  }

  Widget _buildPricingToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isAnnual = true),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  gradient:
                      _isAnnual ? AppColors.cyanPurpleGradient : null,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Text(
                      'Annual',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: _isAnnual
                            ? Colors.white
                            : AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      'Save 42%',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: _isAnnual
                            ? Colors.white.withOpacity(0.8)
                            : AppColors.accentGreen,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isAnnual = false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: !_isAnnual
                      ? AppColors.primary.withOpacity(0.15)
                      : null,
                  borderRadius: BorderRadius.circular(10),
                  border: !_isAnnual
                      ? Border.all(
                          color: AppColors.primary.withOpacity(0.4))
                      : null,
                ),
                child: Text(
                  'Monthly',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: !_isAnnual
                        ? AppColors.primary
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceCards() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: _isAnnual
          ? _buildPriceCard('\$9.99', 'month', '\$119.88 billed annually',
              true, const ValueKey('annual'))
          : _buildPriceCard('\$19.99', 'month', 'Cancel anytime',
              false, const ValueKey('monthly')),
    );
  }

  Widget _buildPriceCard(
      String price, String period, String note, bool isBest, Key key) {
    return Container(
      key: key,
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: isBest
            ? const LinearGradient(
                colors: [Color(0xFF0D1D30), Color(0xFF1A0D30)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: isBest ? null : AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isBest
              ? AppColors.primary.withOpacity(0.5)
              : AppColors.border,
          width: isBest ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isBest)
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: AppColors.cyanPurpleGradient,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '✦ BEST VALUE',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    price,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      color: isBest ? AppColors.primary : AppColors.textPrimary,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8, left: 4),
                    child: Text('/$period',
                        style: AppTextStyles.bodySmall),
                  ),
                ],
              ),
              Text(note, style: AppTextStyles.caption),
            ],
          ),
          const Spacer(),
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: isBest
                  ? AppColors.primary.withOpacity(0.2)
                  : AppColors.border,
              shape: BoxShape.circle,
              border: Border.all(
                color: isBest ? AppColors.primary : AppColors.border,
                width: isBest ? 2 : 1,
              ),
            ),
            child: isBest
                ? const Icon(Icons.check_rounded,
                    color: AppColors.primary, size: 16)
                : null,
          ),
        ],
      ),
    );
  }
}

class _Feature {
  final IconData icon;
  final String title;
  final String subtitle;

  const _Feature(this.icon, this.title, this.subtitle);
}

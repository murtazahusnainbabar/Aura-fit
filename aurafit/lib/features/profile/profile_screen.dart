import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/constants/app_routes.dart';
import '../../models/user_profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserProfile _user = UserProfile.demo;
  bool _notificationsEnabled = true;
  bool _darkMode = true;
  String _units = 'Metric';

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Profile', style: context.textStyles.h1),
                    const SizedBox(height: 20),
                    // User card
                    _buildUserCard()
                        .animate()
                        .fadeIn(duration: 400.ms)
                        .slideY(begin: 0.05),
                    const SizedBox(height: 16),
                    // Stats row
                    _buildStatsRow()
                        .animate()
                        .fadeIn(delay: 100.ms)
                        .slideY(begin: 0.05),
                    const SizedBox(height: 24),
                    // Connected devices
                    Text('Connected Devices', style: context.textStyles.h4),
                    const SizedBox(height: 12),
                    _buildConnectedDevices()
                        .animate()
                        .fadeIn(delay: 200.ms),
                    const SizedBox(height: 24),
                    // AI Coach prefs
                    Text('AI Coach', style: context.textStyles.h4),
                    const SizedBox(height: 12),
                    _buildAICoachSection(context)
                        .animate()
                        .fadeIn(delay: 300.ms),
                    const SizedBox(height: 24),
                    // Settings
                    Text('Settings', style: context.textStyles.h4),
                    const SizedBox(height: 12),
                    _buildSettings()
                        .animate()
                        .fadeIn(delay: 400.ms),
                    const SizedBox(height: 24),
                    // Danger zone
                    _buildDangerZone()
                        .animate()
                        .fadeIn(delay: 500.ms),
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

  Widget _buildUserCard() {
    return GlassCard(
      child: Row(
        children: [
          // Avatar
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              gradient: context.colors.cyanPurpleGradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: Text(
                'AC',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(_user.name, style: context.textStyles.h3),
                    const SizedBox(width: 8),
                    if (_user.membershipTier == 'pro')
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          gradient: context.colors.cyanPurpleGradient,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'PRO',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(_user.email,
                    style: context.textStyles.bodySmall
                        .copyWith(color: context.colors.textMuted)),
                const SizedBox(height: 8),
                Text(
                  _user.fitnessGoal,
                  style: context.textStyles.labelSmall
                      .copyWith(color: context.colors.primary),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: context.colors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: context.colors.border),
              ),
              child: Icon(Icons.edit_outlined,
                  color: context.colors.textSecondary, size: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    final items = [
      ('${_user.totalWorkouts}', 'Workouts'),
      ('${_user.currentStreak}', 'Day Streak'),
      ('${_user.weightKg}', 'kg'),
    ];
    return Row(
      children: items
          .asMap()
          .entries
          .map(
            (e) => Expanded(
              child: Container(
                margin: EdgeInsets.only(right: e.key < 2 ? 10 : 0),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: context.colors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: context.colors.border),
                ),
                child: Column(
                  children: [
                    Text(e.value.$1,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: [
                            context.colors.primary,
                            context.colors.accentOrange,
                            context.colors.accentGreen,
                          ][e.key],
                        )),
                    Text(e.value.$2, style: context.textStyles.caption),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildConnectedDevices() {
    final devices = [
      ('Apple Watch Series 9', Icons.watch_rounded, context.colors.primary),
      ('Samsung Galaxy Fit', Icons.phone_android_rounded, context.colors.secondary),
    ];
    return GlassCard(
      child: Column(
        children: devices
            .asMap()
            .entries
            .map(
              (e) => Padding(
                padding: EdgeInsets.only(
                    bottom: e.key < devices.length - 1 ? 12 : 0),
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: e.value.$3.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(e.value.$2, color: e.value.$3, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(e.value.$1, style: context.textStyles.labelLarge),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: context.colors.accentGreen.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text('Connected',
                          style: context.textStyles.caption
                              .copyWith(color: context.colors.accentGreen)),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildAICoachSection(BuildContext context) {
    return GlassCard(
      child: Column(
        children: [
          _buildTileButton(
            Icons.auto_awesome_rounded,
            'AI Chat',
            'Ask your coach anything',
            context.colors.primary,
            () => Navigator.pushNamed(context, AppRoutes.aiCoachChat),
          ),
          Divider(height: 20),
          _buildTileButton(
            Icons.mic_rounded,
            'Voice Mode',
            'Real-time voice coaching',
            context.colors.secondary,
            () => Navigator.pushNamed(context, AppRoutes.aiVoiceMode),
          ),
          Divider(height: 20),
          _buildTileButton(
            Icons.calendar_month_rounded,
            'Rebuild AI Plan',
            'Adjust your fitness program',
            context.colors.accentGreen,
            () => Navigator.pushNamed(context, AppRoutes.aiPlanGeneration),
          ),
        ],
      ),
    );
  }

  Widget _buildSettings() {
    return GlassCard(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: context.colors.textMuted.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.notifications_outlined,
                    color: context.colors.textSecondary, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text('Notifications',
                    style: context.textStyles.labelLarge),
              ),
              Switch.adaptive(
                value: _notificationsEnabled,
                onChanged: (v) =>
                    setState(() => _notificationsEnabled = v),
                activeColor: context.colors.primary,
              ),
            ],
          ),
          Divider(height: 20),
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: context.colors.textMuted.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.dark_mode_outlined,
                    color: context.colors.textSecondary, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                  child: Text('Dark Mode', style: context.textStyles.labelLarge)),
              Switch.adaptive(
                value: isDark,
                onChanged: (v) => context.read<ThemeProvider>().toggleTheme(),
                activeColor: context.colors.primary,
              ),
            ],
          ),
          Divider(height: 20),
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: context.colors.textMuted.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.straighten_rounded,
                    color: context.colors.textSecondary, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                  child: Text('Units', style: context.textStyles.labelLarge)),
              GestureDetector(
                onTap: () => setState(() =>
                    _units = _units == 'Metric' ? 'Imperial' : 'Metric'),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: context.colors.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: context.colors.border),
                  ),
                  child: Text(_units,
                      style: context.textStyles.labelMedium
                          .copyWith(color: context.colors.primary)),
                ),
              ),
            ],
          ),
          Divider(height: 20),
          _buildTileButton(
            Icons.workspace_premium_rounded,
            'Upgrade to Aura Pro',
            'Unlock all features',
            context.colors.accentOrange,
            () => Navigator.pushNamed(context, AppRoutes.subscription),
          ),
        ],
      ),
    );
  }

  Widget _buildTileButton(IconData icon, String title, String subtitle,
      Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: context.textStyles.labelLarge),
                Text(subtitle,
                    style: context.textStyles.caption
                        .copyWith(color: context.colors.textMuted)),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded,
              color: context.colors.textMuted, size: 20),
        ],
      ),
    );
  }

  Widget _buildDangerZone() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.colors.accentRed.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border:
              Border.all(color: context.colors.accentRed.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded,
                color: context.colors.accentRed, size: 18),
            const SizedBox(width: 8),
            Text('Sign Out',
                style: context.textStyles.labelLarge
                    .copyWith(color: context.colors.accentRed)),
          ],
        ),
      ),
    );
  }
}

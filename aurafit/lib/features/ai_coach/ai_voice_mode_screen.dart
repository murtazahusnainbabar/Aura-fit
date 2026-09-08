import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/glass_card.dart';

class AiVoiceModeScreen extends StatefulWidget {
  const AiVoiceModeScreen({super.key});

  @override
  State<AiVoiceModeScreen> createState() => _AiVoiceModeScreenState();
}

class _AiVoiceModeScreenState extends State<AiVoiceModeScreen>
    with TickerProviderStateMixin {
  bool _isMuted = false;
  bool _isListening = true;
  late AnimationController _pulseController;
  late AnimationController _waveController;

  final List<String> _transcript = [
    'Aura is listening…',
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    // Simulate AI response
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _transcript.add(
            'How many sets should I do for bench press?',
          );
          _isListening = false;
        });
      }
    });

    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _transcript.add(
            'Great question! For hypertrophy, aim for 4 sets of 8–12 reps with 60–90 seconds rest. Use 70–80% of your 1RM.',
          );
          _isListening = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
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
                      child: const Icon(Icons.keyboard_arrow_down_rounded,
                          color: AppColors.textSecondary, size: 22),
                    ),
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      Text('Aura Voice', style: AppTextStyles.h4),
                      Text('AI Mode Active',
                          style: AppTextStyles.caption
                              .copyWith(color: AppColors.primary)),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Icon(Icons.more_horiz_rounded,
                        color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const Spacer(),
            // Pulsing orb
            _buildVoiceOrb(),
            const SizedBox(height: 16),
            Text(
              _isListening ? 'Listening…' : 'Aura is responding…',
              style: AppTextStyles.labelLarge.copyWith(
                color: _isListening ? AppColors.primary : AppColors.secondary,
              ),
            ),
            const Spacer(),
            // Live transcript
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: GlassCard(
                borderColor: AppColors.primary.withOpacity(0.3),
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.05),
                    AppColors.secondary.withOpacity(0.05),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text('Live Transcript',
                            style: AppTextStyles.caption
                                .copyWith(color: AppColors.primary)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ..._transcript
                        .take(3)
                        .map((t) => Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Text(
                                t,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                  height: 1.5,
                                ),
                              ),
                            ))
                        ,
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Controls
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildControlButton(
                    icon: _isMuted
                        ? Icons.mic_off_rounded
                        : Icons.mic_rounded,
                    label: _isMuted ? 'Unmute' : 'Mute',
                    color: _isMuted ? AppColors.accentRed : AppColors.surface,
                    iconColor: _isMuted
                        ? Colors.white
                        : AppColors.textSecondary,
                    onTap: () => setState(() => _isMuted = !_isMuted),
                  ),
                  // End call button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        gradient: AppColors.orangeGradient,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.accentRed.withOpacity(0.4),
                            blurRadius: 20,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.call_end_rounded,
                          color: Colors.white, size: 28),
                    ),
                  ),
                  _buildControlButton(
                    icon: Icons.chat_bubble_outline_rounded,
                    label: 'Chat',
                    color: AppColors.surface,
                    iconColor: AppColors.textSecondary,
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildVoiceOrb() {
    return AnimatedBuilder(
      animation: Listenable.merge([_pulseController, _waveController]),
      builder: (context, _) {
        return SizedBox(
          width: 220,
          height: 220,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer glow rings
              ...List.generate(3, (i) {
                final size = 160.0 + i * 20;
                final opacity = (0.08 - i * 0.025) *
                    (0.7 + _pulseController.value * 0.3);
                return Container(
                  width: size + _pulseController.value * 15,
                  height: size + _pulseController.value * 15,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: (i % 2 == 0 ? AppColors.primary : AppColors.secondary)
                          .withOpacity(opacity),
                      width: 1.5,
                    ),
                  ),
                );
              }),
              // Main orb
              Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primary
                          .withOpacity(0.6 + _pulseController.value * 0.2),
                      AppColors.secondary
                          .withOpacity(0.4 + _pulseController.value * 0.2),
                      AppColors.background.withOpacity(0.8),
                    ],
                    stops: const [0.1, 0.5, 1.0],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(
                          0.3 + _pulseController.value * 0.2),
                      blurRadius: 40 + _pulseController.value * 20,
                      spreadRadius: 5 + _pulseController.value * 8,
                    ),
                    BoxShadow(
                      color: AppColors.secondary.withOpacity(0.2),
                      blurRadius: 30,
                    ),
                  ],
                ),
                child: CustomPaint(
                  painter: _AudioWavePainter(
                    progress: _waveController.value,
                    color: Colors.white,
                    isMuted: _isMuted,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(height: 6),
          Text(label, style: AppTextStyles.caption),
        ],
      ),
    );
  }
}

class _AudioWavePainter extends CustomPainter {
  final double progress;
  final Color color;
  final bool isMuted;

  _AudioWavePainter({
    required this.progress,
    required this.color,
    required this.isMuted,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (isMuted) return;
    final paint = Paint()
      ..color = color.withOpacity(0.6)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final cx = size.width / 2;
    final cy = size.height / 2;
    const bars = 7;
    const barSpacing = 8.0;
    final totalWidth = bars * barSpacing;
    final startX = cx - totalWidth / 2;

    for (int i = 0; i < bars; i++) {
      final x = startX + i * barSpacing;
      final phase = (progress * 2 * pi) + i * 0.6;
      final amplitude = 15.0 * (0.4 + sin(phase) * 0.6);
      canvas.drawLine(
        Offset(x, cy - amplitude),
        Offset(x, cy + amplitude),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_AudioWavePainter old) =>
      old.progress != progress || old.isMuted != isMuted;
}

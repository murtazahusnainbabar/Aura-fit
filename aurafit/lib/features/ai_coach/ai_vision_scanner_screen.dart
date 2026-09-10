import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class AiVisionScannerScreen extends StatefulWidget {
  const AiVisionScannerScreen({super.key});

  @override
  State<AiVisionScannerScreen> createState() => _AiVisionScannerScreenState();
}

class _AiVisionScannerScreenState extends State<AiVisionScannerScreen> {
  String _mode = 'Form';
  bool _scanning = false;
  String? _result;

  Future<void> _capture() async {
    setState(() {
      _scanning = true;
      _result = null;
    });
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() {
      _scanning = false;
      _result = _mode == 'Form'
          ? 'Knees track over toes. Drop 5° deeper on the next squat.'
          : _mode == 'Meal'
              ? 'Grilled salmon bowl · ~640 kcal · 42g protein'
              : 'Front progress photo saved to your weekly check-in.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded, color: Colors.white),
                  ),
                  const Spacer(),
                  ...['Form', 'Meal', 'Progress'].map((mode) {
                    final active = _mode == mode;
                    return Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: ChoiceChip(
                        label: Text(mode),
                        selected: active,
                        onSelected: (_) => setState(() {
                          _mode = mode;
                          _result = null;
                        }),
                      ),
                    );
                  }),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        gradient: LinearGradient(
                          colors: [
                            context.colors.surface,
                            Colors.black,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        border: Border.all(color: context.colors.primary.withOpacity(0.4)),
                      ),
                    ),
                    Center(
                      child: CustomPaint(
                        size: const Size(220, 320),
                        painter: _GridPainter(color: context.colors.primary),
                      ),
                    ),
                    Positioned(
                      left: 24,
                      right: 24,
                      bottom: 24,
                      child: Text(
                        _mode == 'Form'
                            ? 'Align your full body in the grid for a squat form check.'
                            : _mode == 'Meal'
                                ? 'Center the plate. Aura will estimate calories and macros.'
                                : 'Stand in even light. Capture front, side, then back.',
                        textAlign: TextAlign.center,
                        style: context.textStyles.bodySmall
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_result != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: context.colors.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(_result!, style: context.textStyles.bodyMedium),
                ),
              ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _scanning ? null : _capture,
              child: Container(
                width: 74,
                height: 74,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                  color: _scanning
                      ? context.colors.primary
                      : Colors.white.withOpacity(0.2),
                ),
                child: _scanning
                    ? const Padding(
                        padding: EdgeInsets.all(18),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  final Color color;
  _GridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(16)), paint);
    canvas.drawLine(Offset(size.width / 2, 0), Offset(size.width / 2, size.height), paint);
    canvas.drawLine(Offset(0, size.height / 2), Offset(size.width, size.height / 2), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

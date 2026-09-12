import 'package:flutter/material.dart';
import '../../../core/theme/app_text_styles.dart';

class CalorieChart extends StatelessWidget {
  const CalorieChart({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyles = context.textStyles;

    final data = [
      _BarData('Mon', 0.6),
      _BarData('Teus', 0.4),
      _BarData('Wed', 0.7),
      _BarData('Thur', 0.65),
      _BarData('Fri', 0.55),
      _BarData('Sat', 0.9, isActive: true),
      _BarData('Sun', 0.5),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Calories',
                style: textStyles.h3.copyWith(color: Colors.white, fontSize: 20),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '1.8',
                    style: textStyles.h2.copyWith(color: Colors.white, fontSize: 20),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'KCal',
                    style: textStyles.bodySmall.copyWith(color: Colors.white60),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: data.map((d) => _buildBar(context, d)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBar(BuildContext context, _BarData d) {
    return Column(
      children: [
        Container(
          width: 34,
          height: 80 * d.value,
          decoration: BoxDecoration(
            color: d.isActive ? const Color(0xFFC6FF00) : const Color(0xFFD9D9D9).withOpacity(0.8),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          d.day,
          style: context.textStyles.bodySmall.copyWith(
            color: d.isActive ? const Color(0xFFC6FF00) : Colors.white38,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

class _BarData {
  final String day;
  final double value;
  final bool isActive;

  _BarData(this.day, this.value, {this.isActive = false});
}

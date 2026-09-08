import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/glass_card.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen>
    with SingleTickerProviderStateMixin {
  String _period = 'Week';
  late TabController _tabController;

  final List<String> _periods = ['Week', 'Month', 'Year'];

  // Sample data
  final List<FlSpot> _caloriesData = const [
    FlSpot(0, 320),
    FlSpot(1, 450),
    FlSpot(2, 180),
    FlSpot(3, 490),
    FlSpot(4, 370),
    FlSpot(5, 520),
    FlSpot(6, 410),
  ];

  final List<FlSpot> _weightData = const [
    FlSpot(0, 75.8),
    FlSpot(1, 75.5),
    FlSpot(2, 75.2),
    FlSpot(3, 74.9),
    FlSpot(4, 74.5),
    FlSpot(5, 74.2),
    FlSpot(6, 74.0),
  ];

  final List<_PersonalRecord> _records = const [
    _PersonalRecord('Bench Press', '85 kg', Icons.fitness_center_rounded,
        AppColors.secondary),
    _PersonalRecord('Squat', '100 kg', Icons.sports_gymnastics_rounded,
        AppColors.primary),
    _PersonalRecord('Deadlift', '120 kg', Icons.arrow_upward_rounded,
        AppColors.accentOrange),
    _PersonalRecord('Pull-ups', '15 reps', Icons.accessibility_new_rounded,
        AppColors.accentGreen),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Text('Progress', style: AppTextStyles.h1),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            children: _periods
                                .map(
                                  (p) => GestureDetector(
                                    onTap: () => setState(() => _period = p),
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: _period == p
                                            ? AppColors.primary
                                            : Colors.transparent,
                                        borderRadius:
                                            BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        p,
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: _period == p
                                              ? AppColors.background
                                              : AppColors.textMuted,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Summary stats
                    _buildSummaryStrip()
                        .animate()
                        .fadeIn(duration: 400.ms)
                        .slideY(begin: 0.05),
                    const SizedBox(height: 24),
                    // Calories chart
                    Text('Active Calories', style: AppTextStyles.h4),
                    const SizedBox(height: 14),
                    _buildCaloriesChart()
                        .animate()
                        .fadeIn(delay: 200.ms)
                        .slideY(begin: 0.05),
                    const SizedBox(height: 24),
                    // Weight chart
                    Row(
                      children: [
                        Text('Body Weight', style: AppTextStyles.h4),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.accentGreen.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text('↓ 1.8 kg this month',
                              style: AppTextStyles.caption
                                  .copyWith(color: AppColors.accentGreen)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _buildWeightChart()
                        .animate()
                        .fadeIn(delay: 300.ms)
                        .slideY(begin: 0.05),
                    const SizedBox(height: 24),
                    // Measurements
                    _buildMeasurementsCard()
                        .animate()
                        .fadeIn(delay: 400.ms),
                    const SizedBox(height: 24),
                    // PRs
                    Text('Personal Records 🏆', style: AppTextStyles.h4),
                    const SizedBox(height: 14),
                    ..._records.asMap().entries.map(
                          (e) => _buildPRCard(e.value, e.key).animate(
                              delay: (400 + e.key * 60).ms).fadeIn().slideX(begin: 0.05),
                        ),
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

  Widget _buildSummaryStrip() {
    final items = [
      ('78', 'Workouts', AppColors.primary),
      ('84:10', 'Total Hours', AppColors.secondary),
      ('324k', 'kcal Burned', AppColors.accentOrange),
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
                  color: e.value.$3.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: e.value.$3.withOpacity(0.25)),
                ),
                child: Column(
                  children: [
                    Text(e.value.$1,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: e.value.$3,
                        )),
                    const SizedBox(height: 2),
                    Text(e.value.$2, style: AppTextStyles.caption),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildCaloriesChart() {
    return GlassCard(
      child: SizedBox(
        height: 160,
        child: BarChart(
          BarChartData(
            backgroundColor: Colors.transparent,
            borderData: FlBorderData(show: false),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 200,
              getDrawingHorizontalLine: (v) => FlLine(
                color: AppColors.border,
                strokeWidth: 1,
              ),
            ),
            titlesData: FlTitlesData(
              show: true,
              leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (v, _) {
                    const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                    return Text(days[v.toInt()],
                        style: AppTextStyles.caption);
                  },
                  reservedSize: 22,
                ),
              ),
            ),
            barGroups: _caloriesData
                .asMap()
                .entries
                .map(
                  (e) => BarChartGroupData(
                    x: e.key,
                    barRods: [
                      BarChartRodData(
                        toY: e.value.y,
                        gradient: LinearGradient(
                          colors: [AppColors.primary, AppColors.primaryDark],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        width: 22,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6),
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildWeightChart() {
    return GlassCard(
      child: SizedBox(
        height: 140,
        child: LineChart(
          LineChartData(
            backgroundColor: Colors.transparent,
            borderData: FlBorderData(show: false),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 0.5,
              getDrawingHorizontalLine: (v) =>
                  FlLine(color: AppColors.border, strokeWidth: 1),
            ),
            titlesData: FlTitlesData(
              show: true,
              leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (v, _) =>
                      Text('${v.toInt()}',
                          style: AppTextStyles.caption),
                  reservedSize: 32,
                ),
              ),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (v, _) {
                    const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                    return Text(days[v.toInt()],
                        style: AppTextStyles.caption);
                  },
                  reservedSize: 22,
                ),
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: _weightData,
                isCurved: true,
                color: AppColors.accentGreen,
                barWidth: 3,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.accentGreen.withOpacity(0.25),
                      AppColors.accentGreen.withOpacity(0),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMeasurementsCard() {
    final measurements = [
      ('74.2 kg', 'Weight', AppColors.primary),
      ('70.5 kg', 'Lean Mass', AppColors.accentGreen),
      ('73.4 kg', 'Prev Week', AppColors.textMuted),
    ];
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Measurements', style: AppTextStyles.h4),
          const SizedBox(height: 14),
          Row(
            children: measurements
                .map(
                  (m) => Expanded(
                    child: Column(
                      children: [
                        Text(m.$1,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: m.$3,
                            )),
                        const SizedBox(height: 2),
                        Text(m.$2, style: AppTextStyles.caption),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPRCard(_PersonalRecord pr, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: pr.color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(pr.icon, color: pr.color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(pr.name, style: AppTextStyles.labelLarge)),
          Text(
            pr.value,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: pr.color,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.accentGreen.withOpacity(0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text('PR',
                style: AppTextStyles.caption
                    .copyWith(color: AppColors.accentGreen)),
          ),
        ],
      ),
    );
  }
}

class _PersonalRecord {
  final String name;
  final String value;
  final IconData icon;
  final Color color;

  const _PersonalRecord(this.name, this.value, this.icon, this.color);
}

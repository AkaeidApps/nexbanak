import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:nexbanak/app/theme/app_colors.dart';
import 'package:nexbanak/app/theme/app_text_styles.dart';

/// Reusable income/expense and admin analytics chart.
class FinancialChart extends StatelessWidget {
  const FinancialChart({
    super.key,
    required this.primary,
    required this.labels,
    this.secondary,
    this.title,
    this.bar = false,
    this.height = 220,
    this.primaryLabel = 'Income',
    this.secondaryLabel = 'Expense',
  });

  final List<double> primary;
  final List<double>? secondary;
  final List<String> labels;
  final String? title;
  final bool bar;
  final double height;
  final String primaryLabel;
  final String secondaryLabel;

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    final Color grid = dark ? AppColors.darkBorder : AppColors.border;
    final Color muted = dark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    Widget chart = SizedBox(
      height: height,
      child: bar
          ? BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: _maxY(),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (v) => FlLine(color: grid, strokeWidth: 1),
                ),
                borderData: FlBorderData(show: false),
                barTouchData: BarTouchData(enabled: true),
                titlesData: _titles(muted),
                barGroups: List<BarChartGroupData>.generate(primary.length, (i) {
                  final double second =
                      secondary != null && i < secondary!.length ? secondary![i] : 0;
                  return BarChartGroupData(
                    x: i,
                    barRods: <BarChartRodData>[
                      BarChartRodData(
                        toY: primary[i],
                        color: AppColors.secondaryBlue,
                        width: 8,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      if (secondary != null)
                        BarChartRodData(
                          toY: second,
                          color: AppColors.gold,
                          width: 8,
                          borderRadius: BorderRadius.circular(4),
                        ),
                    ],
                  );
                }),
              ),
            )
          : LineChart(
              LineChartData(
                maxY: _maxY(),
                minY: 0,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (v) => FlLine(color: grid, strokeWidth: 1),
                ),
                borderData: FlBorderData(show: false),
                titlesData: _titles(muted),
                lineBarsData: <LineChartBarData>[
                  LineChartBarData(
                    spots: _spots(primary),
                    isCurved: true,
                    color: AppColors.secondaryBlue,
                    barWidth: 3,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: <Color>[
                          AppColors.secondaryBlue.withValues(alpha: 0.22),
                          AppColors.secondaryBlue.withValues(alpha: 0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  if (secondary != null)
                    LineChartBarData(
                      spots: _spots(secondary!),
                      isCurved: true,
                      color: AppColors.gold,
                      barWidth: 3,
                      dotData: FlDotData(show: false),
                    ),
                ],
              ),
            ),
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (title != null) Text(title!, style: AppTextStyles.titleMedium),
            if (title != null) const SizedBox(height: 4),
            Row(
              children: <Widget>[
                _legend(AppColors.secondaryBlue, primaryLabel),
                if (secondary != null) ...<Widget>[
                  const SizedBox(width: 16),
                  _legend(AppColors.gold, secondaryLabel),
                ],
              ],
            ),
            const SizedBox(height: 12),
            chart,
          ],
        ),
      ),
    );
  }

  Widget _legend(Color color, String label) => Row(
        children: <Widget>[
          Container(width: 8, height: 8, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 6),
          Text(label, style: AppTextStyles.bodySmall),
        ],
      );

  List<FlSpot> _spots(List<double> values) => List<FlSpot>.generate(
        values.length,
        (i) => FlSpot(i.toDouble(), values[i]),
      );

  double _maxY() {
    double max = 1;
    for (final double v in primary) {
      if (v > max) max = v;
    }
    if (secondary != null) {
      for (final double v in secondary!) {
        if (v > max) max = v;
      }
    }
    return max * 1.25;
  }

  FlTitlesData _titles(Color muted) => FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 36,
            getTitlesWidget: (v, meta) => Text(
              v >= 1000 ? '${(v / 1000).toStringAsFixed(0)}k' : v.toStringAsFixed(0),
              style: AppTextStyles.bodySmall.copyWith(color: muted, fontSize: 10),
            ),
          ),
        ),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: labels.isNotEmpty,
            interval: labels.length > 8 ? (labels.length / 6).ceil().toDouble() : 1,
            getTitlesWidget: (v, meta) {
              final int i = v.toInt();
              if (i < 0 || i >= labels.length) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(labels[i],
                    style: AppTextStyles.bodySmall.copyWith(color: muted, fontSize: 10)),
              );
            },
          ),
        ),
      );
}

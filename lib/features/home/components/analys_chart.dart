// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:heylex/core/theme/theme_constants.dart';

class AnalysChart extends StatelessWidget {
  final MaterialColor chartColor;

  const AnalysChart({super.key, this.chartColor = Colors.green});

  // Örnek veri
  List<FlSpot> _getChartData() {
    return [
      FlSpot(0, 3),
      FlSpot(1, 2),
      FlSpot(2, 5),
      FlSpot(3, 3.5),
      FlSpot(4, 4),
      FlSpot(5, 3),
      FlSpot(6, 4.5),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final weekDays = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];

    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: ThemeConstants.darkGreyColor,
      ),
      child: Container(
        padding: const EdgeInsets.only(
          left: 12,
          right: 22,
          top: 20,
          bottom: 10,
        ),
        decoration: BoxDecoration(
          color: ThemeConstants.darkGreyColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: LineChart(
          LineChartData(
            maxY: 8.0,
            minY: 0,
            lineBarsData: [
              LineChartBarData(
                spots: _getChartData(),
                gradient: LinearGradient(
                  colors: [
                    chartColor.shade400,
                    chartColor.shade600,
                    chartColor.shade500,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                barWidth: 3,
                isStrokeCapRound: true,
                curveSmoothness: 0.35,
                isCurved: true,
                preventCurveOverShooting: true,
                dotData: FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [
                      chartColor.shade400.withOpacity(0.3),
                      chartColor.shade600.withOpacity(0.1),
                      chartColor.shade500.withOpacity(0.05),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ],
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index >= 0 && index < weekDays.length) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          weekDays[index],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white70,
                          ),
                        ),
                      );
                    }
                    return const Text('');
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  reservedSize: 35,
                  getTitlesWidget: (value, meta) {
                    return Container(
                      padding: const EdgeInsets.only(right: 8),
                      child: Text(
                        '${value.toInt() * 5}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Colors.white70,
                        ),
                      ),
                    );
                  },
                ),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            borderData: FlBorderData(show: false),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: true,
              horizontalInterval: 1,
              getDrawingVerticalLine: (value) {
                return FlLine(
                  color: chartColor.shade700.withOpacity(0.2),
                  strokeWidth: 1,
                  dashArray: [4, 4],
                );
              },
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: chartColor.shade700.withOpacity(0.2),
                  strokeWidth: 1,
                  dashArray: [4, 4],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/color_constants.dart';
import '../../controllers/dashboard_controller.dart';

class SafetyOverviewWidget extends ConsumerWidget {
  const SafetyOverviewWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(dashboardControllerProvider);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Fleet Safety Score',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color:
                        _getSafetyScoreColor(dashboardState.fleetSafetyScore),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${dashboardState.fleetSafetyScore.toStringAsFixed(1)}/5.0',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Safety Score Progress Bar
            LinearProgressIndicator(
              value: dashboardState.fleetSafetyScore / 5.0,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                _getSafetyScoreColor(dashboardState.fleetSafetyScore),
              ),
              minHeight: 8,
            ),
            const SizedBox(height: 16),

            // Safety Metrics Row
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    'Active Buses',
                    '${dashboardState.activeBuses}/${dashboardState.totalBuses}',
                    Icons.directions_bus,
                    AppColors.primaryColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard(
                    'Active Incidents',
                    '${dashboardState.activeIncidents}',
                    Icons.warning,
                    dashboardState.activeIncidents > 0
                        ? Colors.red
                        : Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Safety Chart
            SizedBox(
              height: 120,
              child: LineChart(
                _buildSafetyChart(dashboardState),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getSafetyScoreColor(double score) {
    if (score >= 4.5) return Colors.green;
    if (score >= 3.5) return Colors.orange;
    if (score >= 2.5) return Colors.red;
    return Colors.red[800]!;
  }

  LineChartData _buildSafetyChart(DashboardState state) {
    // Mock data for safety trend over the last 7 days
    final spots = <FlSpot>[
      const FlSpot(0, 4.2),
      const FlSpot(1, 4.3),
      const FlSpot(2, 4.1),
      const FlSpot(3, 4.4),
      const FlSpot(4, 4.2),
      const FlSpot(5, 4.5),
      FlSpot(6, state.fleetSafetyScore),
    ];

    return LineChartData(
      gridData: const FlGridData(show: false),
      titlesData: FlTitlesData(
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
              if (value.toInt() < days.length) {
                return Text(
                  days[value.toInt()],
                  style: const TextStyle(fontSize: 10),
                );
              }
              return const Text('');
            },
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: 6,
      minY: 0,
      maxY: 5,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: AppColors.primaryColor,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 4,
                color: AppColors.primaryColor,
                strokeColor: Colors.white,
                strokeWidth: 2,
              );
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            color: AppColors.primaryColor.withOpacity(0.1),
          ),
        ),
      ],
    );
  }
}

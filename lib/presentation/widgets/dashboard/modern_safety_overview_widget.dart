import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/color_constants.dart';
import '../../controllers/dashboard_controller.dart';

class ModernSafetyOverviewWidget extends ConsumerWidget {
  const ModernSafetyOverviewWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(dashboardControllerProvider);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Safety Score
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
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _getSafetyScoreColor(dashboardState.fleetSafetyScore),
                        _getSafetyScoreColor(dashboardState.fleetSafetyScore)
                            .withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: _getSafetyScoreColor(dashboardState.fleetSafetyScore)
                            .withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    '${dashboardState.fleetSafetyScore.toStringAsFixed(1)}/5.0',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Enhanced Safety Score Progress Bar
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: dashboardState.fleetSafetyScore / 5.0,
                  backgroundColor: AppColors.greyExtraLight,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getSafetyScoreColor(dashboardState.fleetSafetyScore),
                  ),
                  minHeight: 12,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Safety Metrics Grid
            Row(
              children: [
                Expanded(
                  child: _buildEnhancedMetricCard(
                    'Active Buses',
                    '${dashboardState.activeBuses}/${dashboardState.totalBuses}',
                    Icons.directions_bus_rounded,
                    AppColors.primaryColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildEnhancedMetricCard(
                    'Incidents',
                    '${dashboardState.activeIncidents}',
                    Icons.warning_rounded,
                    dashboardState.activeIncidents > 0
                        ? AppColors.warningColor
                        : AppColors.successColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildEnhancedMetricCard(
                    'Avg Speed',
                    '45 km/h',
                    Icons.speed_rounded,
                    const Color(0xFF00BCD4),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildEnhancedMetricCard(
                    'On Time',
                    '94%',
                    Icons.schedule_rounded,
                    AppColors.successColor,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),

            // Safety Trend Chart
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

  Widget _buildEnhancedMetricCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.1),
            color.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _getSafetyScoreColor(double score) {
    if (score >= 4.0) {
      return AppColors.successColor;
    } else if (score >= 3.0) {
      return AppColors.warningColor;
    } else {
      return AppColors.errorColor;
    }
  }

  LineChartData _buildSafetyChart(dynamic dashboardState) {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: AppColors.greyLight,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: const FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: 6,
      minY: 0,
      maxY: 5,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3.5),
            FlSpot(1, 3.8),
            FlSpot(2, 4.2),
            FlSpot(3, 4.0),
            FlSpot(4, 4.3),
            FlSpot(5, 4.1),
            FlSpot(6, 4.5),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: [
              AppColors.primaryColor.withOpacity(0.8),
              AppColors.primaryColor,
            ],
          ),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                AppColors.primaryColor.withOpacity(0.2),
                AppColors.primaryColor.withOpacity(0.05),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
    );
  }
}

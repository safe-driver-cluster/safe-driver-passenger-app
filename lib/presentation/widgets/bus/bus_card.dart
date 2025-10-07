import 'package:flutter/material.dart';

import '../../../core/constants/color_constants.dart';
import '../../../data/models/bus_model.dart';

/// Bus card widget for displaying bus information in lists
class BusCard extends StatelessWidget {
  final BusModel bus;
  final VoidCallback? onTap;
  final VoidCallback? onTrack;
  final VoidCallback? onFavorite;
  final bool showActions;
  final bool isCompact;

  const BusCard({
    super.key,
    required this.bus,
    this.onTap,
    this.onTrack,
    this.onFavorite,
    this.showActions = true,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  // Bus Icon
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _getStatusColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.directions_bus,
                      color: _getStatusColor(),
                      size: 24,
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Bus Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              bus.displayName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            _buildStatusChip(),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          bus.routeDisplay,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Favorite Button
                  if (showActions && onFavorite != null)
                    IconButton(
                      onPressed: onFavorite,
                      icon: const Icon(
                        Icons.favorite_border,
                        color: AppColors.textSecondary,
                      ),
                    ),
                ],
              ),

              if (!isCompact) ...[
                const SizedBox(height: 16),

                // Bus Details
                _buildDetailsRow(),

                const SizedBox(height: 12),

                // Safety Score
                _buildSafetyScore(),

                if (showActions) ...[
                  const SizedBox(height: 16),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onTap,
                          icon: const Icon(Icons.info_outline, size: 18),
                          label: const Text('Details'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primaryColor,
                            side:
                                const BorderSide(color: AppColors.primaryColor),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: bus.isTracking ? onTrack : null,
                          icon: const Icon(Icons.my_location, size: 18),
                          label: const Text('Track'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            foregroundColor: AppColors.white,
                            disabledBackgroundColor:
                                AppColors.textSecondary.withOpacity(0.3),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getStatusColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getStatusColor().withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        bus.statusDisplay,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: _getStatusColor(),
        ),
      ),
    );
  }

  Widget _buildDetailsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildDetailItem(
            icon: Icons.person,
            label: 'Driver',
            value: bus.driverName ?? 'Not assigned',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildDetailItem(
            icon: Icons.people,
            label: 'Capacity',
            value: '${bus.passengerCapacity} seats',
          ),
        ),
      ],
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSafetyScore() {
    final score = bus.safetyScore;
    final color = _getSafetyScoreColor(score);

    return Row(
      children: [
        Icon(
          Icons.security,
          size: 16,
          color: color,
        ),
        const SizedBox(width: 6),
        const Text(
          'Safety Score: ',
          style: TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          '${score.toStringAsFixed(1)}/5.0',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: LinearProgressIndicator(
            value: score / 5.0,
            backgroundColor: AppColors.textSecondary.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor() {
    switch (bus.status) {
      case BusStatus.online:
        return AppColors.successColor;
      case BusStatus.inTransit:
        return AppColors.primaryColor;
      case BusStatus.atStop:
        return AppColors.warningColor;
      case BusStatus.offline:
        return AppColors.textSecondary;
      case BusStatus.maintenance:
        return AppColors.warningColor;
      case BusStatus.emergency:
        return AppColors.errorColor;
      case BusStatus.active:
        return AppColors.successColor;
      case BusStatus.enRoute:
        return AppColors.primaryColor;
    }
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
}

/// Compact bus card for search results
class CompactBusCard extends StatelessWidget {
  final BusModel bus;
  final VoidCallback? onTap;
  final String? estimatedArrival;

  const CompactBusCard({
    super.key,
    required this.bus,
    this.onTap,
    this.estimatedArrival,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: _getStatusColor().withOpacity(0.1),
          child: Icon(
            Icons.directions_bus,
            color: _getStatusColor(),
            size: 20,
          ),
        ),
        title: Text(
          bus.displayName,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(bus.routeDisplay),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (estimatedArrival != null) ...[
              Text(
                estimatedArrival!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              const Text(
                'ETA',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: _getStatusColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  bus.statusDisplay,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: _getStatusColor(),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (bus.status) {
      case BusStatus.online:
        return AppColors.successColor;
      case BusStatus.inTransit:
        return AppColors.primaryColor;
      case BusStatus.atStop:
        return AppColors.warningColor;
      case BusStatus.offline:
        return AppColors.textSecondary;
      case BusStatus.maintenance:
        return AppColors.warningColor;
      case BusStatus.emergency:
        return AppColors.errorColor;
      case BusStatus.active:
        return AppColors.successColor;
      case BusStatus.enRoute:
        return AppColors.primaryColor;
    }
  }
}

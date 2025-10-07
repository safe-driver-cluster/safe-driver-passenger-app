import 'package:flutter/material.dart';

import '../../../core/constants/color_constants.dart';
import '../../../data/models/driver_model.dart';

/// Driver card widget for displaying driver information
class DriverCard extends StatelessWidget {
  final DriverModel driver;
  final VoidCallback? onTap;
  final VoidCallback? onCall;
  final VoidCallback? onMessage;
  final bool showActions;
  final bool isCompact;

  const DriverCard({
    super.key,
    required this.driver,
    this.onTap,
    this.onCall,
    this.onMessage,
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
                  // Driver Avatar
                  CircleAvatar(
                    radius: isCompact ? 20 : 30,
                    backgroundColor: _getStatusColor().withOpacity(0.1),
                    backgroundImage: driver.profileImageUrl != null
                        ? NetworkImage(driver.profileImageUrl!)
                        : null,
                    child: driver.profileImageUrl == null
                        ? Icon(
                            Icons.person,
                            color: _getStatusColor(),
                            size: isCompact ? 20 : 30,
                          )
                        : null,
                  ),

                  const SizedBox(width: 12),

                  // Driver Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                driver.fullName,
                                style: TextStyle(
                                  fontSize: isCompact ? 16 : 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            _buildStatusChip(),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'ID: ${driver.id}',
                          style: TextStyle(
                            fontSize: isCompact ? 12 : 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        if (!isCompact && driver.currentBusId != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            'Bus: ${driver.currentBusId}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Quick Actions
                  if (showActions) ...[
                    if (onCall != null)
                      IconButton(
                        onPressed: onCall,
                        icon: const Icon(
                          Icons.phone,
                          color: AppColors.successColor,
                        ),
                        tooltip: 'Call Driver',
                      ),
                    if (onMessage != null)
                      IconButton(
                        onPressed: onMessage,
                        icon: const Icon(
                          Icons.message,
                          color: AppColors.primaryColor,
                        ),
                        tooltip: 'Message Driver',
                      ),
                  ],
                ],
              ),

              if (!isCompact) ...[
                const SizedBox(height: 16),

                // Driver Details
                _buildDetailsGrid(),

                const SizedBox(height: 12),

                // Safety Score and Experience
                Row(
                  children: [
                    Expanded(child: _buildSafetyScore()),
                    const SizedBox(width: 16),
                    Expanded(child: _buildExperience()),
                  ],
                ),

                if (showActions) ...[
                  const SizedBox(height: 16),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onTap,
                          icon: const Icon(Icons.person, size: 18),
                          label: const Text('View Profile'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primaryColor,
                            side:
                                const BorderSide(color: AppColors.primaryColor),
                          ),
                        ),
                      ),
                      if (driver.isOnDuty) ...[
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: onCall,
                            icon: const Icon(Icons.phone, size: 18),
                            label: const Text('Contact'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.successColor,
                              foregroundColor: AppColors.white,
                            ),
                          ),
                        ),
                      ],
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
        driver.statusDisplay,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: _getStatusColor(),
        ),
      ),
    );
  }

  Widget _buildDetailsGrid() {
    return Row(
      children: [
        Expanded(
          child: _buildDetailItem(
            icon: Icons.schedule,
            label: 'On Duty',
            value: driver.isOnDuty ? 'Yes' : 'No',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildDetailItem(
            icon: Icons.card_membership,
            label: 'License',
            value: driver.licenseNumber,
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
    final score = driver.safetyScore;
    final color = _getSafetyScoreColor(score);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.security,
              size: 16,
              color: color,
            ),
            const SizedBox(width: 6),
            const Text(
              'Safety Score',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              '${score.toStringAsFixed(1)}/5.0',
              style: TextStyle(
                fontSize: 16,
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
        ),
      ],
    );
  }

  Widget _buildExperience() {
    final years = driver.experience.totalYears;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(
              Icons.work,
              size: 16,
              color: AppColors.textSecondary,
            ),
            SizedBox(width: 6),
            Text(
              'Experience',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '$years year${years != 1 ? 's' : ''}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor() {
    switch (driver.status) {
      case DriverStatus.active:
        return AppColors.successColor;
      case DriverStatus.driving:
        return AppColors.primaryColor;
      case DriverStatus.resting:
        return AppColors.warningColor;
      case DriverStatus.offDuty:
        return AppColors.textSecondary;
      case DriverStatus.unavailable:
        return AppColors.textSecondary;
      case DriverStatus.emergency:
        return AppColors.errorColor;
      case DriverStatus.available:
        return AppColors.successColor;
      case DriverStatus.onDuty:
        return AppColors.primaryColor;
      case DriverStatus.onBreak:
        return AppColors.warningColor;
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

/// Compact driver card for lists
class CompactDriverCard extends StatelessWidget {
  final DriverModel driver;
  final VoidCallback? onTap;

  const CompactDriverCard({
    super.key,
    required this.driver,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return DriverCard(
      driver: driver,
      onTap: onTap,
      isCompact: true,
      showActions: false,
    );
  }
}

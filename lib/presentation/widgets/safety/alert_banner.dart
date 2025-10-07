import 'package:flutter/material.dart';

import '../../../data/models/safety_alert_model.dart';

/// Alert banner widget for displaying safety alerts
class AlertBanner extends StatefulWidget {
  final SafetyAlertModel alert;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;
  final bool showActions;
  final bool isCompact;

  const AlertBanner({
    super.key,
    required this.alert,
    this.onTap,
    this.onDismiss,
    this.showActions = true,
    this.isCompact = false,
  });

  @override
  State<AlertBanner> createState() => _AlertBannerState();
}

class _AlertBannerState extends State<AlertBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: -1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value * 100),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: _buildAlertBanner(context),
          ),
        );
      },
    );
  }

  Widget _buildAlertBanner(BuildContext context) {
    final theme = Theme.of(context);
    final colors = _getAlertColors(widget.alert.severity);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: colors.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: colors.shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: widget.isCompact
                ? _buildCompactContent(theme, colors)
                : _buildFullContent(theme, colors),
          ),
        ),
      ),
    );
  }

  Widget _buildCompactContent(ThemeData theme, AlertColors colors) {
    return Row(
      children: [
        _buildAlertIcon(colors),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.alert.title,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: colors.textColor,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                widget.alert.description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.subtitleColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        if (widget.showActions) ...[
          const SizedBox(width: 8),
          _buildActionButtons(theme, colors, isCompact: true),
        ],
      ],
    );
  }

  Widget _buildFullContent(ThemeData theme, AlertColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildAlertIcon(colors),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.alert.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colors.textColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      _buildSeverityChip(theme, colors),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTimestamp(widget.alert.timestamp),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors.subtitleColor,
                    ),
                  ),
                ],
              ),
            ),
            if (widget.onDismiss != null)
              IconButton(
                onPressed: _dismissAlert,
                icon: Icon(
                  Icons.close,
                  color: colors.subtitleColor,
                  size: 20,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 32,
                  minHeight: 32,
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          widget.alert.description,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colors.textColor,
          ),
        ),
        if (widget.alert.location != null) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.location_on,
                size: 16,
                color: colors.subtitleColor,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  widget.alert.location?.address ??
                      'Lat: ${widget.alert.location!.latitude.toStringAsFixed(4)}, '
                          'Lng: ${widget.alert.location!.longitude.toStringAsFixed(4)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.subtitleColor,
                  ),
                ),
              ),
            ],
          ),
        ],
        if (widget.showActions) ...[
          const SizedBox(height: 16),
          _buildActionButtons(theme, colors),
        ],
      ],
    );
  }

  Widget _buildAlertIcon(AlertColors colors) {
    IconData iconData;
    switch (widget.alert.type) {
      case AlertType.emergency:
        iconData = Icons.emergency;
        break;
      case AlertType.accident:
        iconData = Icons.car_crash;
        break;
      case AlertType.breakdown:
        iconData = Icons.build;
        break;
      case AlertType.hazard:
        iconData = Icons.warning;
        break;
      case AlertType.weather:
        iconData = Icons.cloud;
        break;
      case AlertType.traffic:
        iconData = Icons.traffic;
        break;
      case AlertType.security:
        iconData = Icons.security;
        break;
      default:
        iconData = Icons.info;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: colors.iconBackgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        iconData,
        color: colors.iconColor,
        size: widget.isCompact ? 20 : 24,
      ),
    );
  }

  Widget _buildSeverityChip(ThemeData theme, AlertColors colors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colors.chipBackgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        widget.alert.severity.toString().split('.').last.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: colors.chipTextColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildActionButtons(ThemeData theme, AlertColors colors,
      {bool isCompact = false}) {
    if (widget.alert.status == AlertStatus.resolved) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.green, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              size: 16,
              color: Colors.green,
            ),
            const SizedBox(width: 4),
            Text(
              'Resolved',
              style: theme.textTheme.labelSmall?.copyWith(
                color: Colors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    if (isCompact) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: _acknowledgeAlert,
            icon: const Icon(Icons.check, size: 20),
            color: colors.actionColor,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: 32,
              minHeight: 32,
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        if (widget.alert.status == AlertStatus.active) ...[
          OutlinedButton.icon(
            onPressed: _acknowledgeAlert,
            icon: const Icon(Icons.check, size: 16),
            label: const Text('Acknowledge'),
            style: OutlinedButton.styleFrom(
              foregroundColor: colors.actionColor,
              side: BorderSide(color: colors.actionColor),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
          const SizedBox(width: 8),
        ],
        ElevatedButton.icon(
          onPressed: widget.onTap,
          icon: const Icon(Icons.visibility, size: 16),
          label: const Text('View Details'),
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.actionColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ],
    );
  }

  void _acknowledgeAlert() {
    // Handle acknowledge action
    if (widget.onTap != null) {
      widget.onTap!();
    }
  }

  void _dismissAlert() {
    _animationController.reverse().then((_) {
      if (widget.onDismiss != null) {
        widget.onDismiss!();
      }
    });
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  AlertColors _getAlertColors(int severity) {
    if (severity >= AlertSeverity.high) {
      return AlertColors(
        backgroundColor: const Color(0xFFFFEBEE),
        borderColor: const Color(0xFFE57373),
        shadowColor: const Color(0x1AE57373),
        textColor: const Color(0xFFB71C1C),
        subtitleColor: const Color(0xFF8C1A1A),
        iconColor: Colors.white,
        iconBackgroundColor: const Color(0xFFE57373),
        chipBackgroundColor: const Color(0xFFE57373),
        chipTextColor: Colors.white,
        actionColor: const Color(0xFFE57373),
      );
    } else if (severity >= AlertSeverity.medium) {
      return AlertColors(
        backgroundColor: const Color(0xFFFFF3E0),
        borderColor: const Color(0xFFFFB74D),
        shadowColor: const Color(0x1AFFB74D),
        textColor: const Color(0xFFE65100),
        subtitleColor: const Color(0xFFBF4E00),
        iconColor: Colors.white,
        iconBackgroundColor: const Color(0xFFFFB74D),
        chipBackgroundColor: const Color(0xFFFFB74D),
        chipTextColor: Colors.white,
        actionColor: const Color(0xFFFFB74D),
      );
    } else {
      return AlertColors(
        backgroundColor: const Color(0xFFF3E5F5),
        borderColor: const Color(0xFFBA68C8),
        shadowColor: const Color(0x1ABA68C8),
        textColor: const Color(0xFF4A148C),
        subtitleColor: const Color(0xFF6A1B9A),
        iconColor: Colors.white,
        iconBackgroundColor: const Color(0xFFBA68C8),
        chipBackgroundColor: const Color(0xFFBA68C8),
        chipTextColor: Colors.white,
        actionColor: const Color(0xFFBA68C8),
      );
    }
  }
}

/// Colors for alert banner based on severity
class AlertColors {
  final Color backgroundColor;
  final Color borderColor;
  final Color shadowColor;
  final Color textColor;
  final Color subtitleColor;
  final Color iconColor;
  final Color iconBackgroundColor;
  final Color chipBackgroundColor;
  final Color chipTextColor;
  final Color actionColor;

  AlertColors({
    required this.backgroundColor,
    required this.borderColor,
    required this.shadowColor,
    required this.textColor,
    required this.subtitleColor,
    required this.iconColor,
    required this.iconBackgroundColor,
    required this.chipBackgroundColor,
    required this.chipTextColor,
    required this.actionColor,
  });
}

import 'package:flutter/material.dart';

import '../../../core/constants/color_constants.dart';
import '../../../data/models/bus_model.dart';

/// Bus status indicator widget
class BusStatusIndicator extends StatelessWidget {
  final BusStatus status;
  final bool showLabel;
  final double size;
  final bool isAnimated;

  const BusStatusIndicator({
    super.key,
    required this.status,
    this.showLabel = true,
    this.size = 24.0,
    this.isAnimated = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor();
    final icon = _getStatusIcon();
    final label = _getStatusLabel();

    if (showLabel) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildIndicator(color, icon),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: size * 0.6,
            ),
          ),
        ],
      );
    } else {
      return _buildIndicator(color, icon);
    }
  }

  Widget _buildIndicator(Color color, IconData icon) {
    Widget indicator = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Icon(
        icon,
        color: color,
        size: size * 0.6,
      ),
    );

    if (isAnimated &&
        (status == BusStatus.inTransit || status == BusStatus.emergency)) {
      return AnimatedBuilder(
        animation: _getPulseAnimation(),
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 + (_getPulseAnimation().value * 0.1),
            child: indicator,
          );
        },
      );
    }

    return indicator;
  }

  Color _getStatusColor() {
    switch (status) {
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

  IconData _getStatusIcon() {
    switch (status) {
      case BusStatus.online:
        return Icons.check_circle;
      case BusStatus.inTransit:
        return Icons.directions_bus;
      case BusStatus.atStop:
        return Icons.location_on;
      case BusStatus.offline:
        return Icons.power_off;
      case BusStatus.maintenance:
        return Icons.build;
      case BusStatus.emergency:
        return Icons.warning;
      case BusStatus.active:
        return Icons.check_circle;
      case BusStatus.enRoute:
        return Icons.directions_bus;
    }
  }

  String _getStatusLabel() {
    switch (status) {
      case BusStatus.online:
        return 'Online';
      case BusStatus.inTransit:
        return 'In Transit';
      case BusStatus.atStop:
        return 'At Stop';
      case BusStatus.offline:
        return 'Offline';
      case BusStatus.maintenance:
        return 'Maintenance';
      case BusStatus.emergency:
        return 'Emergency';
      case BusStatus.active:
        return 'Active';
      case BusStatus.enRoute:
        return 'En Route';
    }
  }

  Animation<double> _getPulseAnimation() {
    // This would typically be provided by a parent AnimationController
    // For now, returning a dummy animation
    return const AlwaysStoppedAnimation<double>(0.0);
  }
}

/// Animated bus status indicator with pulse effect
class AnimatedBusStatusIndicator extends StatefulWidget {
  final BusStatus status;
  final bool showLabel;
  final double size;

  const AnimatedBusStatusIndicator({
    super.key,
    required this.status,
    this.showLabel = true,
    this.size = 24.0,
  });

  @override
  State<AnimatedBusStatusIndicator> createState() =>
      _AnimatedBusStatusIndicatorState();
}

class _AnimatedBusStatusIndicatorState extends State<AnimatedBusStatusIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    if (widget.status == BusStatus.inTransit ||
        widget.status == BusStatus.emergency) {
      _animationController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(AnimatedBusStatusIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.status != oldWidget.status) {
      if (widget.status == BusStatus.inTransit ||
          widget.status == BusStatus.emergency) {
        _animationController.repeat(reverse: true);
      } else {
        _animationController.stop();
        _animationController.reset();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor();
    final icon = _getStatusIcon();
    final label = _getStatusLabel();

    Widget indicator = AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        final scale = 1.0 + (_pulseAnimation.value * 0.1);
        return Transform.scale(
          scale: scale,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: color.withOpacity(0.3 + (_pulseAnimation.value * 0.3)),
                width: 2,
              ),
              boxShadow: (widget.status == BusStatus.emergency)
                  ? [
                      BoxShadow(
                        color: color.withOpacity(0.4 * _pulseAnimation.value),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: Icon(
              icon,
              color: color,
              size: widget.size * 0.6,
            ),
          ),
        );
      },
    );

    if (widget.showLabel) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          indicator,
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: widget.size * 0.6,
            ),
          ),
        ],
      );
    } else {
      return indicator;
    }
  }

  Color _getStatusColor() {
    switch (widget.status) {
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

  IconData _getStatusIcon() {
    switch (widget.status) {
      case BusStatus.online:
        return Icons.check_circle;
      case BusStatus.inTransit:
        return Icons.directions_bus;
      case BusStatus.atStop:
        return Icons.location_on;
      case BusStatus.offline:
        return Icons.power_off;
      case BusStatus.maintenance:
        return Icons.build;
      case BusStatus.emergency:
        return Icons.warning;
      case BusStatus.active:
        return Icons.check_circle;
      case BusStatus.enRoute:
        return Icons.directions_bus;
    }
  }

  String _getStatusLabel() {
    switch (widget.status) {
      case BusStatus.online:
        return 'Online';
      case BusStatus.inTransit:
        return 'In Transit';
      case BusStatus.atStop:
        return 'At Stop';
      case BusStatus.offline:
        return 'Offline';
      case BusStatus.maintenance:
        return 'Maintenance';
      case BusStatus.emergency:
        return 'Emergency';
      case BusStatus.active:
        return 'Active';
      case BusStatus.enRoute:
        return 'En Route';
    }
  }
}

/// Bus status legend widget
class BusStatusLegend extends StatelessWidget {
  const BusStatusLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bus Status Legend',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            ...BusStatus.values.map((status) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: BusStatusIndicator(
                    status: status,
                    showLabel: true,
                    size: 20,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

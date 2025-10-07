import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Emergency button widget for immediate help
class EmergencyButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final String label;
  final IconData icon;
  final bool isLoading;
  final bool isActive;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double size;
  final bool showPulseAnimation;

  const EmergencyButton({
    super.key,
    this.onPressed,
    this.label = 'EMERGENCY',
    this.icon = Icons.warning,
    this.isLoading = false,
    this.isActive = false,
    this.backgroundColor,
    this.foregroundColor,
    this.size = 120,
    this.showPulseAnimation = true,
  });

  @override
  State<EmergencyButton> createState() => _EmergencyButtonState();
}

class _EmergencyButtonState extends State<EmergencyButton>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _pressController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scaleAnimation;

  bool _isPressed = false;

  @override
  void initState() {
    super.initState();

    // Pulse animation for emergency state
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Press animation
    _pressController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _pressController,
      curve: Curves.easeInOut,
    ));

    // Start pulse animation if needed
    if (widget.showPulseAnimation && widget.isActive) {
      _startPulseAnimation();
    }
  }

  @override
  void didUpdateWidget(EmergencyButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive && widget.showPulseAnimation) {
        _startPulseAnimation();
      } else {
        _stopPulseAnimation();
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _pressController.dispose();
    super.dispose();
  }

  void _startPulseAnimation() {
    _pulseController.repeat(reverse: true);
  }

  void _stopPulseAnimation() {
    _pulseController.stop();
    _pulseController.reset();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
    _pressController.forward();

    // Haptic feedback
    HapticFeedback.heavyImpact();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
    _pressController.reverse();
  }

  void _onTapCancel() {
    setState(() {
      _isPressed = false;
    });
    _pressController.reverse();
  }

  void _onTap() {
    if (widget.onPressed != null && !widget.isLoading) {
      // Strong haptic feedback for emergency
      HapticFeedback.heavyImpact();
      widget.onPressed!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor = widget.backgroundColor ??
        (widget.isActive ? Colors.red : Colors.red.shade600);
    final foregroundColor = widget.foregroundColor ?? Colors.white;

    return AnimatedBuilder(
      animation: Listenable.merge([_pulseAnimation, _scaleAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                if (widget.showPulseAnimation && widget.isActive)
                  BoxShadow(
                    color: backgroundColor.withOpacity(0.4),
                    blurRadius: 20 * _pulseAnimation.value,
                    spreadRadius: 5 * _pulseAnimation.value,
                  ),
                BoxShadow(
                  color: backgroundColor.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: backgroundColor,
              shape: const CircleBorder(),
              elevation: _isPressed ? 2 : 8,
              child: InkWell(
                onTap: _onTap,
                onTapDown: _onTapDown,
                onTapUp: _onTapUp,
                onTapCancel: _onTapCancel,
                customBorder: const CircleBorder(),
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: foregroundColor.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: widget.isLoading
                      ? _buildLoadingState(foregroundColor)
                      : _buildNormalState(theme, foregroundColor),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingState(Color foregroundColor) {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
        strokeWidth: 3,
      ),
    );
  }

  Widget _buildNormalState(ThemeData theme, Color foregroundColor) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          widget.icon,
          color: foregroundColor,
          size: widget.size * 0.35,
        ),
        const SizedBox(height: 8),
        Text(
          widget.label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: foregroundColor,
            fontWeight: FontWeight.bold,
            fontSize: widget.size * 0.1,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// Emergency panel with multiple options
class EmergencyPanel extends StatelessWidget {
  final VoidCallback? onEmergencyPressed;
  final VoidCallback? onPolicePressed;
  final VoidCallback? onMedicalPressed;
  final VoidCallback? onFirePressed;
  final bool isLoading;

  const EmergencyPanel({
    super.key,
    this.onEmergencyPressed,
    this.onPolicePressed,
    this.onMedicalPressed,
    this.onFirePressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Emergency Services',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.error,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose the appropriate emergency service',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // Main emergency button
          Center(
            child: EmergencyButton(
              onPressed: onEmergencyPressed,
              label: 'EMERGENCY',
              icon: Icons.warning_amber_rounded,
              size: 140,
              isLoading: isLoading,
              isActive: true,
            ),
          ),

          const SizedBox(height: 32),

          // Service buttons row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildServiceButton(
                context,
                icon: Icons.local_police,
                label: 'Police',
                color: Colors.blue,
                onPressed: onPolicePressed,
              ),
              _buildServiceButton(
                context,
                icon: Icons.medical_services,
                label: 'Medical',
                color: Colors.green,
                onPressed: onMedicalPressed,
              ),
              _buildServiceButton(
                context,
                icon: Icons.local_fire_department,
                label: 'Fire',
                color: Colors.orange,
                onPressed: onFirePressed,
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Warning text
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.error.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: theme.colorScheme.error,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Only use in genuine emergencies. False alarms may result in penalties.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onErrorContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    VoidCallback? onPressed,
  }) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Material(
          color: color,
          shape: const CircleBorder(),
          elevation: 4,
          child: InkWell(
            onTap: () {
              HapticFeedback.mediumImpact();
              onPressed?.call();
            },
            customBorder: const CircleBorder(),
            child: Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: Icon(
                icon,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

/// Quick emergency action button for app bars
class QuickEmergencyButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isActive;

  const QuickEmergencyButton({
    super.key,
    this.onPressed,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: EmergencyButton(
        onPressed: onPressed,
        label: 'SOS',
        icon: Icons.warning,
        size: 40,
        isActive: isActive,
        showPulseAnimation: isActive,
      ),
    );
  }
}

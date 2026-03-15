// ignore_for_file: deprecated_member_use

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:safedriver_passenger_app/data/models/passenger_model.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/design_constants.dart';

class RewardPointsWidget extends StatefulWidget {
  final int currentPoints;
  final int goalPoints;
  final PassengerModel? userProfile;

  const RewardPointsWidget({
    super.key,
    this.currentPoints = 0,
    this.goalPoints = 100,
    this.userProfile,
  });

  @override
  State<RewardPointsWidget> createState() => _RewardPointsWidgetState();
}

class _RewardPointsWidgetState extends State<RewardPointsWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  late double _previousProgress;

  @override
  void initState() {
    super.initState();
    _previousProgress =
        (widget.currentPoints / widget.goalPoints).clamp(0.0, 1.0);

    // Initialize animation controller for smooth progress transitions
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: _previousProgress,
      end: _previousProgress,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(RewardPointsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check if points have changed
    if (oldWidget.currentPoints != widget.currentPoints ||
        oldWidget.goalPoints != widget.goalPoints) {
      final newProgress =
          (widget.currentPoints / widget.goalPoints).clamp(0.0, 1.0);

      // Only animate if progress actually changed
      if (_previousProgress != newProgress) {
        _progressAnimation = Tween<double>(
          begin: _previousProgress,
          end: newProgress,
        ).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
        );

        _animationController.forward(from: 0.0);
        _previousProgress = newProgress;
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
    final currentProgress =
        (widget.currentPoints / widget.goalPoints).clamp(0.0, 1.0);

    return AnimatedBuilder(
      animation: _progressAnimation,
      builder: (context, child) {
        // Use animated value if available, otherwise use current progress
        final displayProgress =
            _animationController.isAnimating ? _progressAnimation.value : currentProgress;

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppDesign.radiusXL),
            boxShadow: AppDesign.shadowMD,
            border: Border.all(
              color: AppColors.greyLight,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Professional section header
              Container(
                padding: const EdgeInsets.all(AppDesign.spaceMD),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFFF6B6B),
                      Color(0xFFFFD93D),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppDesign.radiusXL),
                    topRight: Radius.circular(AppDesign.radiusXL),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.card_giftcard,
                      color: Colors.white,
                      size: 28,
                    ),
                    const SizedBox(width: AppDesign.spaceMD),
                    Expanded(
                      child: Text(
                        'Reward Points',
                        style: AppTextStyles.headline6.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Points content
              Padding(
                padding: const EdgeInsets.all(AppDesign.spaceMD),
                child: Column(
                  children: [
                    // Main points display with LARGER progress circle
                    Center(
                      child: SizedBox(
                        width: 160,
                        height: 160,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Outer glow effect
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: displayProgress >= 1.0
                                        ? AppColors.successColor.withOpacity(0.3)
                                        : const Color(0xFFFF6B6B).withOpacity(0.25),
                                    blurRadius: 25,
                                    spreadRadius: 8,
                                  ),
                                ],
                              ),
                            ),
                            // Background static circle
                            CustomPaint(
                              size: const Size(160, 160),
                              painter: BackgroundCirclePainter(),
                            ),
                            // Animated progress circle with better visual fill
                            CustomPaint(
                              size: const Size(160, 160),
                              painter: ProgressCirclePainter(
                                progress: displayProgress,
                                isComplete: displayProgress >= 1.0,
                              ),
                            ),
                            // Progress checkpoint dots
                            CustomPaint(
                              size: const Size(160, 160),
                              painter: CheckpointDotsPainter(
                                progress: displayProgress,
                              ),
                            ),
                            // Points text in center
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                ShaderMask(
                                  shaderCallback: (bounds) =>
                                      const LinearGradient(
                                        colors: [
                                          Color(0xFFFF6B6B),
                                          Color(0xFFFFD93D)
                                        ],
                                      ).createShader(bounds),
                                  child: Text(
                                    '${widget.currentPoints}',
                                    style: AppTextStyles.headline4.copyWith(
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                      fontSize: 40,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 2),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    '/${widget.goalPoints}',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDesign.spaceSM),

                    // "How to Earn Points" CLICKABLE BUTTON
                    _buildHowToEarnButton(context),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHowToEarnButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _showHowToEarnDialog(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDesign.spaceMD,
          vertical: AppDesign.spaceMD,
        ),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF6B6B), Color(0xFFFFD93D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppDesign.radiusLG),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF6B6B).withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.lightbulb_outline,
                  color: Colors.white,
                  size: 22,
                ),
                const SizedBox(width: AppDesign.spaceMD),
                Text(
                  'How to Earn Points',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _showHowToEarnDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDesign.radiusXL),
          ),
          insetPadding: const EdgeInsets.symmetric(
            horizontal: AppDesign.spaceMD,
            vertical: AppDesign.spaceMD,
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDesign.radiusXL),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  Colors.grey[50]!,
                ],
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppDesign.spaceLG),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFFF6B6B), Color(0xFFFFD93D)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(AppDesign.radiusXL),
                        topRight: Radius.circular(AppDesign.radiusXL),
                      ),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.card_giftcard,
                          color: Colors.white,
                          size: 32,
                        ),
                        const SizedBox(height: AppDesign.spaceMD),
                        Text(
                          'How to Earn Points',
                          style: AppTextStyles.headline6.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 22,
                          ),
                        ),
                        const SizedBox(height: AppDesign.spaceSM),
                        Text(
                          'Complete these actions to earn rewards',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Content
                  Padding(
                    padding: const EdgeInsets.all(AppDesign.spaceLG),
                    child: Column(
                      children: [
                        // Method 1: Submit Feedback
                        _buildEarnMethod(
                          icon: Icons.edit_outlined,
                          iconColor: const Color(0xFF2563EB),
                          title: 'Submit Feedback',
                          description:
                              'Share your experience with driver or bus service',
                          points: '+1 point',
                          pointsColor: const Color(0xFF2563EB),
                        ),
                        const SizedBox(height: AppDesign.spaceLG),

                        // Method 2: Feedback Approved
                        _buildEarnMethod(
                          icon: Icons.check_circle_outline,
                          iconColor: const Color(0xFF059669),
                          title: 'Feedback Approved',
                          description:
                              'Your feedback helps improve our service quality',
                          points: '+3 points total',
                          pointsColor: const Color(0xFF059669),
                        ),
                        const SizedBox(height: AppDesign.spaceLG),

                        // Method 3: Avoid Fake Feedback
                        _buildEarnMethod(
                          icon: Icons.warning_outlined,
                          iconColor: const Color(0xFFDC2626),
                          title: 'Keep Feedback Genuine',
                          description:
                              'Fake or spam feedback will result in point deduction',
                          points: '-1 point',
                          pointsColor: const Color(0xFFDC2626),
                        ),
                      ],
                    ),
                  ),

                  // Tips Section
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: AppDesign.spaceLG,
                    ),
                    padding: const EdgeInsets.all(AppDesign.spaceMD),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                      border: Border.all(
                        color: const Color(0xFFFCD34D),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.info_outline,
                              color: Color(0xFFB45309),
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Tips for Success',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: const Color(0xFFB45309),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '• Write feedback of at least 5 characters\n• Be specific and helpful in your comments\n• Provide genuine feedback only\n• Reach 100 points to unlock rewards!',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: const Color(0xFFB45309).withOpacity(0.8),
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Close Button
                  Padding(
                    padding: const EdgeInsets.all(AppDesign.spaceLG),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          padding: const EdgeInsets.symmetric(
                            vertical: AppDesign.spaceMD,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppDesign.radiusLG),
                          ),
                        ),
                        child: Text(
                          'Got It!',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEarnMethod({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    required String points,
    required Color pointsColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppDesign.spaceMD),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDesign.radiusLG),
        border: Border.all(
          color: Colors.grey[200]!,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 28,
                ),
              ),
              const SizedBox(width: AppDesign.spaceMD),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppDesign.spaceMD),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: pointsColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: pointsColor.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  points,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: pointsColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Custom Painter for Background Circle
class BackgroundCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 20) / 2;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Custom Painter for Progress Circle with Fill
class ProgressCirclePainter extends CustomPainter {
  final double progress;
  final bool isComplete;

  ProgressCirclePainter({
    required this.progress,
    required this.isComplete,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round
      ..shader = LinearGradient(
        colors: isComplete
            ? [
                const Color(0xFF059669),
                const Color(0xFF10B981),
              ]
            : [
                const Color(0xFFFF6B6B),
                const Color(0xFFFFD93D),
              ],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2),
          radius: (size.width - 20) / 2,
        ),
      );

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 20) / 2;

    // Draw progress arc starting from top (-90 degrees)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159 / 2, // Start from top
      (2 * 3.14159) * progress, // Sweep angle based on progress
      false,
      paint,
    );

    // Draw glow effect at the end of progress
    if (progress > 0 && progress < 1.0) {
      final glowPaint = Paint()
        ..color = const Color(0xFFFF6B6B).withOpacity(0.5)
        ..style = PaintingStyle.fill;

      final angle = -3.14159 / 2 + (2 * 3.14159) * progress;
      final glowX = center.dx + radius * 1.05 * (cos(angle));
      final glowY = center.dy + radius * 1.05 * (sin(angle));

      canvas.drawCircle(Offset(glowX, glowY), 6, glowPaint);
    }
  }

  @override
  bool shouldRepaint(ProgressCirclePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.isComplete != isComplete;
  }
}

// Custom Painter for Checkpoint Dots
class CheckpointDotsPainter extends CustomPainter {
  final double progress;

  CheckpointDotsPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 20) / 2;

    // Draw 10 checkpoint dots (for milestones: 10%, 20%, 30%, etc.)
    for (int i = 1; i <= 10; i++) {
      final dotProgress = i / 10.0;
      final angle = -3.14159 / 2 + (2 * 3.14159) * dotProgress;

      final dotX = center.dx + radius * 1.15 * cos(angle);
      final dotY = center.dy + radius * 1.15 * sin(angle);

      // Only show dots up to current progress
      if (dotProgress <= progress) {
        // Active dot (reached)
        final activePaint = Paint()
          ..color = const Color(0xFFFFD93D)
          ..style = PaintingStyle.fill
          ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 2.0);

        canvas.drawCircle(Offset(dotX, dotY), 4.5, activePaint);

        // Inner white dot
        final innerPaint = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;

        canvas.drawCircle(Offset(dotX, dotY), 2.5, innerPaint);
      } else {
        // Inactive dot (not yet reached)
        final inactivePaint = Paint()
          ..color = Colors.grey.withOpacity(0.3)
          ..style = PaintingStyle.fill;

        canvas.drawCircle(Offset(dotX, dotY), 3, inactivePaint);
      }
    }
  }

  @override
  bool shouldRepaint(CheckpointDotsPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}


import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Shared Flutter Web layout helpers.
///
/// Mobile and tablet-sized web viewports keep the app's existing phone UI.
class WebResponsive {
  static const double wideBreakpoint = 720;
  static const double desktopBreakpoint = 900;

  static bool isWideWeb(BuildContext context,
      {double minWidth = wideBreakpoint}) {
    return kIsWeb && MediaQuery.sizeOf(context).width >= minWidth;
  }
}

class WebPageFrame extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final double minWidth;

  const WebPageFrame({
    super.key,
    required this.child,
    this.maxWidth = 1040,
    this.minWidth = WebResponsive.wideBreakpoint,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

class WebAuthSplitShell extends StatelessWidget {
  final Widget child;
  final String title;
  final String subtitle;
  final IconData icon;
  final double contentWidth;

  const WebAuthSplitShell({
    super.key,
    required this.child,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.contentWidth = 520,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Container(
            height: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 72, vertical: 56),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF2563EB),
                  Color(0xFF1E40AF),
                  Color(0xFF0F172A),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          'assets/images/logo2.png',
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.directions_bus_rounded,
                              color: Color(0xFF2563EB),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'SafeDriver',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.22),
                    ),
                  ),
                  child: Icon(icon, color: Colors.white, size: 42),
                ),
                const SizedBox(height: 28),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.w800,
                    height: 1.08,
                  ),
                ),
                const SizedBox(height: 18),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.78),
                      fontSize: 18,
                      height: 1.55,
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Container(
            height: double.infinity,
            color: const Color(0xFFF6F8FC),
            alignment: Alignment.center,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(48),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: contentWidth),
                child: child,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

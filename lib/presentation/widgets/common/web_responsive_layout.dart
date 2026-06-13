import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/design_constants.dart';
import '../../../core/utils/theme_helper.dart';
import '../../../l10n/arb/app_localizations.dart';

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
  final String? routeName;

  const WebPageFrame({
    super.key,
    required this.child,
    this.maxWidth = 1040,
    this.minWidth = WebResponsive.wideBreakpoint,
    this.routeName,
  });

  @override
  Widget build(BuildContext context) {
    if (!_showsAppSidebar(context)) return child;

    return _WebAppSidebarShell(
      routeName: routeName,
      child: child,
    );
  }

  bool _showsAppSidebar(BuildContext context) {
    if (!WebResponsive.isWideWeb(context, minWidth: minWidth)) return false;

    switch (routeName) {
      case '/dashboard':
      case '/notifications':
      case '/maps':
      case '/buses':
      case '/bus-search':
      case '/drivers':
      case '/safety-alerts':
      case '/safety-hub':
      case '/hazard-zones':
      case '/emergency':
      case '/sos-contacts':
      case '/feedback':
      case '/feedback-form':
      case '/feedback-system':
      case '/feedback-test':
      case '/feedback-history':
      case '/qr-scanner':
      case '/driver-info':
      case '/hazard-zone-intelligence':
      case '/trip-history':
      case '/profile':
      case '/user-profile':
      case '/settings':
        return true;
      default:
        return false;
    }
  }
}

class _WebAppSidebarShell extends StatelessWidget {
  final Widget child;
  final String? routeName;

  const _WebAppSidebarShell({
    required this.child,
    required this.routeName,
  });

  @override
  Widget build(BuildContext context) {
    final th = ThemeHelper.of(context);
    final l10n = AppLocalizations.of(context);
    final items = [
      const _WebSidebarItem(
        label: 'Dashboard',
        icon: Icons.dashboard_outlined,
        selectedIcon: Icons.dashboard_rounded,
        route: '/dashboard',
        selectedRoutes: ['/dashboard'],
      ),
      _WebSidebarItem(
        label: l10n.availableBuses,
        icon: Icons.directions_bus_outlined,
        selectedIcon: Icons.directions_bus_rounded,
        route: '/buses',
        selectedRoutes: const ['/buses', '/bus-search', '/drivers'],
      ),
      const _WebSidebarItem(
        label: 'Maps',
        icon: Icons.map_outlined,
        selectedIcon: Icons.map_rounded,
        route: '/maps',
        selectedRoutes: ['/maps'],
      ),
      const _WebSidebarItem(
        label: 'Profile',
        icon: Icons.person_outline_rounded,
        selectedIcon: Icons.person_rounded,
        route: '/dashboard',
        arguments: {'initialTab': 3},
        selectedRoutes: [
          '/profile',
          '/user-profile',
          '/settings',
          '/notifications',
          '/trip-history',
        ],
      ),
    ];

    return Scaffold(
      backgroundColor: th.background,
      body: Row(
        children: [
          Container(
            width: 264,
            decoration: BoxDecoration(
              color: th.surface,
              border: Border(
                right: BorderSide(color: th.border, width: 1),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppDesign.spaceLG),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(AppDesign.radiusMD),
                            boxShadow: AppDesign.shadowSM,
                          ),
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(AppDesign.radiusMD),
                            child: Image.asset(
                              'assets/images/logo2.png',
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.directions_bus_rounded,
                                  color: AppColors.primaryColor,
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: AppDesign.spaceMD),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'SafeDriver',
                                style: TextStyle(
                                  color: th.textPrimary,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                l10n.appTagline,
                                style: TextStyle(
                                  color: th.textSecondary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDesign.space2XL),
                    for (final item in items)
                      Padding(
                        padding:
                            const EdgeInsets.only(bottom: AppDesign.spaceSM),
                        child: _WebSidebarButton(
                          item: item,
                          selected: item.selectedRoutes.contains(routeName),
                        ),
                      ),
                    const Spacer(),
                    Container(
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                        boxShadow: [
                          BoxShadow(
                            color:
                                AppColors.primaryColor.withValues(alpha: 0.22),
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.pushNamed(
                          context,
                          '/qr-scanner',
                        ),
                        icon: const Icon(Icons.qr_code_scanner_rounded),
                        label: const Text('Scan QR'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppDesign.radiusLG),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ClipRect(child: child),
          ),
        ],
      ),
    );
  }
}

class _WebSidebarButton extends StatelessWidget {
  final _WebSidebarItem item;
  final bool selected;

  const _WebSidebarButton({
    required this.item,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    final th = ThemeHelper.of(context);
    return Material(
      color: selected
          ? AppColors.primaryColor.withValues(alpha: 0.1)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(AppDesign.radiusLG),
      child: InkWell(
        onTap: () {
          Navigator.pushNamedAndRemoveUntil(
            context,
            item.route,
            (route) => false,
            arguments: item.arguments,
          );
        },
        borderRadius: BorderRadius.circular(AppDesign.radiusLG),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDesign.spaceMD,
            vertical: AppDesign.spaceMD,
          ),
          child: Row(
            children: [
              Icon(
                selected ? item.selectedIcon : item.icon,
                color: selected ? AppColors.primaryColor : th.textSecondary,
                size: AppDesign.iconMD,
              ),
              const SizedBox(width: AppDesign.spaceMD),
              Expanded(
                child: Text(
                  item.label,
                  style: TextStyle(
                    color: selected ? AppColors.primaryColor : th.textPrimary,
                    fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WebSidebarItem {
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final String route;
  final Map<String, dynamic>? arguments;
  final List<String> selectedRoutes;

  const _WebSidebarItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.route,
    required this.selectedRoutes,
    this.arguments,
  });
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

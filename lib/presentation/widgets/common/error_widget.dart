import 'package:flutter/material.dart';
import '../../../core/constants/color_constants.dart';

/// Custom error widget for displaying error states
class CustomErrorWidget extends StatelessWidget {
  final String message;
  final String? title;
  final IconData? icon;
  final VoidCallback? onRetry;
  final Widget? action;
  final bool showImage;

  const CustomErrorWidget({
    super.key,
    required this.message,
    this.title,
    this.icon,
    this.onRetry,
    this.action,
    this.showImage = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Error Icon or Image
            if (showImage)
              Image.asset(
                'assets/images/error_state.png',
                width: 120,
                height: 120,
                errorBuilder: (context, error, stackTrace) => Icon(
                  icon ?? Icons.error_outline,
                  size: 80,
                  color: AppColors.errorColor,
                ),
              )
            else
              Icon(
                icon ?? Icons.error_outline,
                size: 80,
                color: AppColors.errorColor,
              ),

            const SizedBox(height: 24),

            // Title
            if (title != null) ...[
              Text(
                title!,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
            ],

            // Error Message
            Text(
              message,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // Action Button
            if (action != null)
              action!
            else if (onRetry != null)
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Network error widget
class NetworkErrorWidget extends StatelessWidget {
  final VoidCallback? onRetry;

  const NetworkErrorWidget({
    super.key,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return CustomErrorWidget(
      title: 'No Internet Connection',
      message: 'Please check your internet connection and try again.',
      icon: Icons.wifi_off,
      onRetry: onRetry,
      showImage: true,
    );
  }
}

/// Server error widget
class ServerErrorWidget extends StatelessWidget {
  final VoidCallback? onRetry;

  const ServerErrorWidget({
    super.key,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return CustomErrorWidget(
      title: 'Server Error',
      message: 'Something went wrong on our end. Please try again later.',
      icon: Icons.cloud_off,
      onRetry: onRetry,
    );
  }
}

/// Not found error widget
class NotFoundErrorWidget extends StatelessWidget {
  final String? message;
  final VoidCallback? onGoBack;

  const NotFoundErrorWidget({
    super.key,
    this.message,
    this.onGoBack,
  });

  @override
  Widget build(BuildContext context) {
    return CustomErrorWidget(
      title: 'Not Found',
      message: message ?? 'The requested content could not be found.',
      icon: Icons.search_off,
      action: onGoBack != null
          ? ElevatedButton.icon(
              onPressed: onGoBack,
              icon: const Icon(Icons.arrow_back),
              label: const Text('Go Back'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: AppColors.white,
              ),
            )
          : null,
    );
  }
}

/// Permission denied error widget
class PermissionErrorWidget extends StatelessWidget {
  final String permission;
  final VoidCallback? onOpenSettings;

  const PermissionErrorWidget({
    super.key,
    required this.permission,
    this.onOpenSettings,
  });

  @override
  Widget build(BuildContext context) {
    return CustomErrorWidget(
      title: 'Permission Required',
      message:
          '$permission permission is required to use this feature. Please grant permission in app settings.',
      icon: Icons.security,
      action: onOpenSettings != null
          ? ElevatedButton.icon(
              onPressed: onOpenSettings,
              icon: const Icon(Icons.settings),
              label: const Text('Open Settings'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: AppColors.white,
              ),
            )
          : null,
    );
  }
}

/// Empty state widget
class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String message;
  final IconData? icon;
  final Widget? action;
  final bool showImage;

  const EmptyStateWidget({
    super.key,
    required this.title,
    required this.message,
    this.icon,
    this.action,
    this.showImage = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Empty State Icon or Image
            if (showImage)
              Image.asset(
                'assets/images/empty_state.png',
                width: 120,
                height: 120,
                errorBuilder: (context, error, stackTrace) => Icon(
                  icon ?? Icons.inbox_outlined,
                  size: 80,
                  color: AppColors.textSecondary,
                ),
              )
            else
              Icon(
                icon ?? Icons.inbox_outlined,
                size: 80,
                color: AppColors.textSecondary,
              ),

            const SizedBox(height: 24),

            // Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            // Message
            Text(
              message,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // Action Button
            if (action != null) action!,
          ],
        ),
      ),
    );
  }
}

/// Generic info widget for various states
class InfoWidget extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final Color? iconColor;
  final Widget? action;

  const InfoWidget({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
    this.iconColor,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: iconColor ?? AppColors.primaryColor,
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            if (action != null) action!,
          ],
        ),
      ),
    );
  }
}

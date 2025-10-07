import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../presentation/controllers/base_controller.dart';

// Create a simple provider for the AuthController
final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
  return AuthController();
});

// Create providers for other controllers
final dashboardControllerProvider =
    StateNotifierProvider<DashboardController, AsyncValue<void>>((ref) {
  return DashboardController();
});

final busControllerProvider =
    StateNotifierProvider<BusController, AsyncValue<void>>((ref) {
  return BusController();
});

final profileControllerProvider =
    StateNotifierProvider<ProfileController, AsyncValue<void>>((ref) {
  return ProfileController();
});

// Auth state model for compatibility
class AuthState {
  final bool isLoading;
  final String? error;
  final dynamic user;

  const AuthState({
    this.isLoading = false,
    this.error,
    this.user,
  });
}

// Extension to make AsyncValue compatible with AuthState
extension AsyncValueAuth on AsyncValue<void> {
  bool get isLoading => this is AsyncLoading;
  String? get error => when(
        data: (_) => null,
        loading: () => null,
        error: (error, _) => error.toString(),
      );
  dynamic get user => null; // Placeholder for user data
}

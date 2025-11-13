import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingState {
  final bool isCompleted;
  final bool isLoading;

  const OnboardingState({
    this.isCompleted = false,
    this.isLoading = false,
  });

  OnboardingState copyWith({
    bool? isCompleted,
    bool? isLoading,
  }) {
    return OnboardingState(
      isCompleted: isCompleted ?? this.isCompleted,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  OnboardingNotifier() : super(const OnboardingState());

  Future<void> checkOnboardingStatus() async {
    state = state.copyWith(isLoading: true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final isCompleted = prefs.getBool('onboarding_completed') ?? false;

      state = state.copyWith(
        isCompleted: isCompleted,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> completeOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboarding_completed', true);

      state = state.copyWith(isCompleted: true);
    } catch (e) {
      // Handle error if needed
    }
  }

  void resetOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboarding_completed', false);

      state = state.copyWith(isCompleted: false);
    } catch (e) {
      // Handle error if needed
    }
  }
}

final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingState>(
  (ref) => OnboardingNotifier(),
);

class OnboardingModel {
  final String title;
  final String description;
  final String imagePath;

  const OnboardingModel({
    required this.title,
    required this.description,
    required this.imagePath,
  });

  static List<OnboardingModel> get onboardingData => [
        const OnboardingModel(
          title: 'Safe & Reliable Transport',
          description:
              'Experience the most secure and dependable transportation service. Your safety is our top priority with professionally trained drivers.',
          imagePath: 'assets/images/onboard-01.png',
        ),
        const OnboardingModel(
          title: 'Real-Time Tracking',
          description:
              'Track your ride in real-time and stay connected with live location updates. Know exactly where your ride is at every moment.',
          imagePath: 'assets/images/onboard-02.png',
        ),
        const OnboardingModel(
          title: 'Smart Feedback System',
          description:
              'Share your experience and help us maintain the highest service standards. Your feedback makes every journey better.',
          imagePath: 'assets/images/onboard-03.png',
        ),
      ];
}
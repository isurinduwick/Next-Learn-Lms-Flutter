class OnboardingModel {
  final String image;
  final String title;
  final String description;

  OnboardingModel({
    required this.image,
    required this.title,
    required this.description,
  });
}

List<OnboardingModel> onboardingData = [
  OnboardingModel(
    image: "assets/onboarding1.jpg",
    title: "Welcome to NextLearn",
    description: "Your journey to knowledge starts here.",
  ),
  OnboardingModel(
    image: "assets/onboarding 2.jpeg",
    title: "Learn Anytime, Anywhere",
    description: "Access lessons on the go.",
  ),
  OnboardingModel(
    image: "assets/onboarding3.jpg",
    title: "Track Your Progress",
    description: "Stay updated with real-time learning progress.",
  ),
  OnboardingModel(
    image: "assets/onboarding4.jpg",
    title: "Connect & Collaborate",
    description: "Engage with peers and mentors.",
  ),
];

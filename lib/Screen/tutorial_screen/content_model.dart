class OnboardingContent {
  late String background;
  late String image;
  late String title;
  late String description;

  OnboardingContent(
      {required this.background,
        required this.image,
        required this.title,
        required this.description});
}

List<OnboardingContent> contents = [
  OnboardingContent(
      background: "assets/Images/backgroundBlur.png",
      title: 'Workouts',
      image: 'assets/Images/onboard1.jpg',
      description:
      "Easy Follow 10 Min Workouts to Maintain and Improve Tone & Strength for Both Upper and Lower Body. "),
  OnboardingContent(
      background: "assets/Images/backgroundBlur2.png",
      title: 'Fertility Concepts Explained',
      image: 'assets/Images/onboard2.jpg',
      description:
      "Lorem ipsum dolor sit amet, consectetur adipiscing Lorem ipsum dolor  "),
  OnboardingContent(
      background: "assets/Images/backgroundBlur3.png",
      title: 'The Holistic Fertility Guidebook',
      image: 'assets/Images/onboard3.jpg',
      description:
      "Lorem ipsum dolor sit amet, consectetur adipiscing Lorem ipsum dolor "),
  OnboardingContent(
      background: "assets/Images/backgroundBlur4.png",
      title: 'EXPERT TALKS',
      image: 'assets/Images/onboard4.jpg',
      description:
      "Lorem ipsum dolor sit amet, consectetur adipiscing Lorem ipsum dolor sit amet, consectetur adipiscing"),
];

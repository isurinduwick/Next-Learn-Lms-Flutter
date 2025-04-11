import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_learn/views/welcome_screen.dart';
import '../models/onboarding_model.dart';
//import '../screens/welcome_screen.dart'; // Import WelcomeScreen

class OnboardingController extends GetxController {
  final PageController pageController = PageController();
  var currentIndex = 0.obs;

  void nextPage() {
    if (currentIndex.value < onboardingData.length - 1) {
      pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      Get.off(() => WelcomeScreen()); // Navigate to WelcomeScreen
    }
  }

  // New method to skip directly to welcome screen
  void skipToWelcomeScreen() {
    Get.off(() => WelcomeScreen()); // Navigate directly to WelcomeScreen
  }

  void updateIndex(int index) {
    currentIndex.value = index;
  }
}

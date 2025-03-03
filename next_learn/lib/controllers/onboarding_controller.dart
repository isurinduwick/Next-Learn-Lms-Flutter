import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/onboarding_model.dart';
import '../views/auth/login_screen.dart';

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
      Get.to(LoginScreen());
    }
  }

  void updateIndex(int index) {
    currentIndex.value = index;
  }
}

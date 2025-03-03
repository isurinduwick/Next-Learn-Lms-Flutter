import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'onboarding/onboarding_screen.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () {
      Get.off(OnboardingScreen());
    });

    return Scaffold(
      body: Center(
        child: Image.asset(
        "assets/splash image.png",
        width: 400,  // Adjust width as needed
        height: 400, // Adjust height as needed
         fit: BoxFit.contain, // Adjust how the image fits in the box
        ),
      ),
    );
  }
}

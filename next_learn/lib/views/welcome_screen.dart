import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/theme_controller.dart';
import 'auth/login_screen.dart';
//import 'auth/signup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDarkMode = themeController.isDarkMode.value;
      return WillPopScope(
        onWillPop: () async => false, // Prevent back navigation
        child: Scaffold(
          backgroundColor: isDarkMode ? Colors.black : Colors.white,
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    Image.asset(
                      "assets/splash image.png",
                      width: 200,
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 30),

                    // Title
                    Text(
                      "Get Started with Next Learn",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Description
                    Text(
                      "Start learning—sign up or log in now!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: isDarkMode ? Colors.white70 : Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Buttons Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Sign In Button
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isDarkMode ? Colors.white : Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () {
                              Get.to(LoginScreen()); // Navigate to Login
                            },
                            child: Text(
                              "Sign In",
                              style: TextStyle(
                                color: isDarkMode ? Colors.black : Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),

                        // Sign Up Button
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: BorderSide(color: isDarkMode ? Colors.white : Colors.black),
                            ),
                            onPressed: () {
                              Get.to(()); // Navigate to Sign Up
                            },
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Dark Mode Toggle (Top-Left)
              Positioned(
                top: 50,  // Distance from top
                left: 20,  // Distance from left
                child: IconButton(
                  icon: Icon(
                    isDarkMode ? Icons.dark_mode : Icons.light_mode,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  onPressed: themeController.toggleTheme,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

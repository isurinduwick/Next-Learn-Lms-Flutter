import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_learn/controllers/onboarding_controller.dart';
import 'package:next_learn/controllers/theme_controller.dart';
import 'package:next_learn/models/onboarding_model.dart';

class OnboardingScreen extends StatelessWidget {
  final OnboardingController controller = Get.put(OnboardingController());
  final ThemeController themeController = Get.find<ThemeController>();

  OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final isDarkMode = themeController.isDarkMode.value;
        return SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: controller.pageController,
                      itemCount: onboardingData.length,
                      onPageChanged: controller.updateIndex,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              // Extra space at top for positioning
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.25),

                              // Circular Image - responsive size
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isDarkMode
                                        ? Colors.white54
                                        : Colors.grey.shade300,
                                    width: 6,
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: MediaQuery.of(context).size.width *
                                      0.25, // Responsive radius
                                  backgroundImage:
                                      AssetImage(onboardingData[index].image),
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.04),

                              // Title & Description - wrapped in Expanded for flexibility
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      onboardingData[index].title,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      onboardingData[index].description,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: isDarkMode
                                            ? Colors.white70
                                            : Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Dots Indicator
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: Obx(
                                  () => Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(
                                      onboardingData.length,
                                      (dotIndex) => AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        height: 8,
                                        width: controller.currentIndex.value ==
                                                dotIndex
                                            ? 12
                                            : 8,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color:
                                              controller.currentIndex.value ==
                                                      dotIndex
                                                  ? (isDarkMode
                                                      ? Colors.white
                                                      : Colors.black)
                                                  : Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  // Continue Button positioned at bottom
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        20, 10, 20, MediaQuery.of(context).padding.bottom + 30),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isDarkMode ? Colors.white : Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: controller.nextPage,
                        child: Text(
                          "CONTINUE",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.black : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Skip Button
              Positioned(
                top: 10,
                right: 20,
                child: TextButton(
                  onPressed: controller.skipToWelcomeScreen,
                  style: TextButton.styleFrom(
                    backgroundColor:
                        isDarkMode ? Colors.white24 : Colors.grey.shade200,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Text(
                      "SKIP",
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),

              // Dark Mode Toggle Button
              Positioned(
                top: 10,
                left: 20,
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
        );
      }),
    );
  }
}

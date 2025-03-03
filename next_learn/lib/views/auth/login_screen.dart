import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50), // Space from top

              // Back Button
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Get.back(),
              ),
              const SizedBox(height: 20),

              // Title
              const Center(
                child: Text(
                  "Sign in",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  "Please Sign in with your account",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ),
              const SizedBox(height: 30),

              // Email Field
              const Text("Email Here"),
              const SizedBox(height: 6),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  hintText: "Enter your email",
                ),
              ),
              const SizedBox(height: 16),

              // Password Field
              const Text("Password"),
              const SizedBox(height: 6),
              TextField(
                controller: passwordController,
                obscureText: !isPasswordVisible,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  hintText: "Enter your password",
                  suffixIcon: IconButton(
                    icon: Icon(
                      isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Forget Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text("Forget Password?", style: TextStyle(color: Colors.black54)),
                ),
              ),
              const SizedBox(height: 20),

              // Sign In Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    // Handle sign-in logic
                  },
                  child: const Text(
                    "SIGN IN",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // OR Divider
              Row(
                children: const [
                  Expanded(child: Divider(thickness: 1)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text("Or Sign in with"),
                  ),
                  Expanded(child: Divider(thickness: 1)),
                ],
              ),
              const SizedBox(height: 20),

              // Facebook Sign In
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  icon: const FaIcon(FontAwesomeIcons.facebook, color: Colors.white),
                  onPressed: () {
                    // Handle Facebook sign-in
                  },
                  label: const Text(
                    "Sign In with Facebook",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Google Sign In
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  icon: const FaIcon(FontAwesomeIcons.google, color: Colors.black),
                  onPressed: () {
                    // Handle Google sign-in
                  },
                  label: const Text(
                    "Sign In with Google",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Sign Up Link
              Center(
                child: GestureDetector(
                  onTap: () => Get.to(() => ()), // Navigate to Sign Up
                  child: const Text.rich(
                    TextSpan(
                      text: "Didn’t have an account? ",
                      children: [
                        TextSpan(
                          text: "Sign up Here",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

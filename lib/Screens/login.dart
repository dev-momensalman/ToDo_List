import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:momensalman/Screens/Todo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:momensalman/Screens/NoteScreen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final mailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isObscure = true;

  Future<void> login() async {
    if (mailController.text == "Admin" && passwordController.text == "Admin") {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      if (mounted) {
        mailController.clear();
        passwordController.clear();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TodoScreen()),
        );
      }
    } else {
      showError("Invalid Username or Password!");
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent.withOpacity(0.8),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // الخلفية (تدرج ألوان جذاب)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1e3799),
                  Color(0xFF000000),
                  Color(0xFF4a69bd),
                ],
              ),
            ),
          ),
          // دوائر مضيئة في الخلفية لتعزيز شكل الـ Glassmorphism
          Positioned(
            top: 100,
            right: -50,
            child: _buildBlurCircle(150, Colors.purple.withOpacity(0.3)),
          ),
          Positioned(
            bottom: 100,
            left: -50,
            child: _buildBlurCircle(200, Colors.blue.withOpacity(0.3)),
          ),
          // واجهة تسجيل الدخول
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(25),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 40,
                      horizontal: 30,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.cloud_done_outlined,
                          size: 70,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "CloudNote",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 40),
                        _buildTextField(
                          controller: mailController,
                          hint: "Username",
                          icon: Icons.person_outline,
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          controller: passwordController,
                          hint: "Password",
                          icon: Icons.lock_outline,
                          obscure: isObscure,
                          isPassword: true,
                        ),
                        const SizedBox(height: 40),
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6C5CE7),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 5,
                            ),
                            child: const Text(
                              "LOGIN",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Or sign in with",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildSocialIcon(Icons.g_mobiledata_rounded),
                            const SizedBox(width: 20),
                            _buildSocialIcon(Icons.apple),
                            const SizedBox(width: 20),
                            _buildSocialIcon(Icons.facebook),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlurCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
        prefixIcon: Icon(icon, color: Colors.white70),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  obscure ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white70,
                ),
                onPressed: () => setState(() => isObscure = !isObscure),
              )
            : null,
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFF6C5CE7)),
        ),
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Icon(icon, color: Colors.white70, size: 25),
    );
  }
}

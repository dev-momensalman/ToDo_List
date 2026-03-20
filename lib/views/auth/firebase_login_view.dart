import 'dart:ui';
import 'package:flutter/material.dart';
import '../../controllers/firebase_auth_controller.dart';
import 'dart:developer';

class FirebaseLoginView extends StatefulWidget {
  const FirebaseLoginView({super.key});

  @override
  State<FirebaseLoginView> createState() => _FirebaseLoginViewState();
}

class _FirebaseLoginViewState extends State<FirebaseLoginView> {
  late final FirebaseAuthController _controller;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = FirebaseAuthController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
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
          // Background circles for glassmorphism effect
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
          // Login form
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
                    child: Form(
                      key: _formKey,
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
                          const SizedBox(height: 20),
                          const Text(
                            "Sign in to your account",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 40),

                          // Email field
                          _buildTextField(
                            controller: _controller.emailController,
                            hint: "Email Address",
                            icon: Icons.email_outlined,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                              ).hasMatch(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          // Password field
                          ValueListenableBuilder<bool>(
                            valueListenable: _controller.isPasswordVisible,
                            builder: (context, isVisible, _) {
                              return _buildTextField(
                                controller: _controller.passwordController,
                                hint: "Password",
                                icon: Icons.lock_outline,
                                obscure: !isVisible,
                                isPassword: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  return null;
                                },
                                onToggleVisibility:
                                    _controller.togglePasswordVisibility,
                              );
                            },
                          ),
                          const SizedBox(height: 10),

                          // Forgot password link
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () => _showForgotPasswordDialog(),
                              child: const Text(
                                "Forgot Password?",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),

                          // Error message
                          ValueListenableBuilder<String?>(
                            valueListenable: _controller.errorMessage,
                            builder: (context, error, _) {
                              if (error != null && error.isNotEmpty) {
                                return Container(
                                  padding: const EdgeInsets.all(12),
                                  margin: const EdgeInsets.only(bottom: 20),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.1),
                                    border: Border.all(
                                      color: Colors.red.withOpacity(0.3),
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.error_outline,
                                        color: Colors.red,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          error,
                                          style: const TextStyle(
                                            color: Colors.red,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () =>
                                            _controller.clearMessages(),
                                        icon: const Icon(
                                          Icons.close,
                                          color: Colors.red,
                                          size: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),

                          // Success message
                          ValueListenableBuilder<String?>(
                            valueListenable: _controller.successMessage,
                            builder: (context, success, _) {
                              if (success != null && success.isNotEmpty) {
                                return Container(
                                  padding: const EdgeInsets.all(12),
                                  margin: const EdgeInsets.only(bottom: 20),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.1),
                                    border: Border.all(
                                      color: Colors.green.withOpacity(0.3),
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.check_circle_outline,
                                        color: Colors.green,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          success,
                                          style: const TextStyle(
                                            color: Colors.green,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () =>
                                            _controller.clearMessages(),
                                        icon: const Icon(
                                          Icons.close,
                                          color: Colors.green,
                                          size: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),

                          // Sign in button
                          ValueListenableBuilder<bool>(
                            valueListenable: _controller.isLoading,
                            builder: (context, isLoading, _) {
                              return SizedBox(
                                width: double.infinity,
                                height: 55,
                                child: ElevatedButton(
                                  onPressed: isLoading ? null : _handleSignIn,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF6C5CE7),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    elevation: 5,
                                  ),
                                  child: isLoading
                                      ? const CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                      : const Text(
                                          "SIGN IN",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 20),

                          // OR divider
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: Colors.white.withOpacity(0.3),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Text(
                                  "OR",
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: Colors.white.withOpacity(0.3),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Google Sign In button
                          ValueListenableBuilder<bool>(
                            valueListenable: _controller.isLoading,
                            builder: (context, isLoading, _) {
                              return SizedBox(
                                width: double.infinity,
                                height: 55,
                                child: OutlinedButton.icon(
                                  onPressed: isLoading
                                      ? null
                                      : _handleGoogleSignIn,
                                  icon: const Icon(
                                    Icons.g_mobiledata,
                                    color: Colors.white,
                                  ),
                                  label: const Text(
                                    "Sign in with Google",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Colors.white),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 20),

                          // Sign up link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account? ",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              TextButton(
                                onPressed: () =>
                                    _controller.navigateToSignUp(context),
                                child: const Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
    String? Function(String?)? validator,
    VoidCallback? onToggleVisibility,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      validator: validator,
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
                onPressed: onToggleVisibility,
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
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }

  void _handleSignIn() async {
    if (_formKey.currentState!.validate()) {
      log('1- Start Email Sign In');
      final success = await _controller.signIn();
      log('2- After Email Sign In - Success: $success');
      if (success && mounted) {
        _controller.showMessage(context, 'Signed in successfully!');
        log('3- Navigating to Home');
        Navigator.of(context).pushReplacementNamed('/home');
        log('4- Navigation completed');
      }
    }
  }

  void _handleGoogleSignIn() async {
    log('1- Start Google Sign In');
    final success = await _controller.signInWithGoogle();
    log('2- After Google Sign In - Success: $success');
    if (success && mounted) {
      _controller.showMessage(context, 'Signed in with Google successfully!');
      log('3- Navigating to Home');
      Navigator.of(context).pushReplacementNamed('/home');
      log('4- Navigation completed');
    }
  }

  void _showForgotPasswordDialog() {
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Reset Password"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Enter your email address to receive a password reset link.",
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email Address",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (emailController.text.isNotEmpty) {
                _controller.emailController.text = emailController.text;
                final success = await _controller.resetPassword();
                if (success && mounted) {
                  Navigator.pop(context);
                }
              }
            },
            child: const Text("Send"),
          ),
        ],
      ),
    );
  }
}

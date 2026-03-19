import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase_auth_service.dart';

class FirebaseAuthController {
  final FirebaseAuthService _authService = FirebaseAuthService();

  // Controllers for form fields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController displayNameController = TextEditingController();

  // State management
  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  final ValueNotifier<bool> isPasswordVisible = ValueNotifier(false);
  final ValueNotifier<bool> isConfirmPasswordVisible = ValueNotifier(false);
  final ValueNotifier<String?> errorMessage = ValueNotifier(null);
  final ValueNotifier<String?> successMessage = ValueNotifier(null);

  // Auth state stream
  Stream<User?> get authStateChanges => _authService.authStateChanges;

  // Get current user info
  User? get currentUser => _authService.currentUser;
  bool get isLoggedIn => _authService.isLoggedIn;
  String? get userId => _authService.userId;
  String? get userEmail => _authService.userEmail;
  String? get userDisplayName => _authService.userDisplayName;
  String? get userPhotoURL => _authService.userPhotoURL;
  bool get isEmailVerified => _authService.isEmailVerified;

  // Sign up with email and password
  Future<bool> signUp() async {
    if (!_validateSignUpForm()) return false;

    _setLoading(true);
    _clearMessages();

    try {
      await _authService.signUpWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
        displayName: displayNameController.text.trim(),
      );

      _clearControllers();
      _setSuccessMessage(
        'Account created successfully! Please check your email for verification.',
      );
      return true;
    } catch (e) {
      _setErrorMessage(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Sign in with email and password
  Future<bool> signIn() async {
    if (!_validateSignInForm()) return false;

    _setLoading(true);
    _clearMessages();

    try {
      await _authService.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      _clearControllers();
      _setSuccessMessage('Signed in successfully!');
      return true;
    } catch (e) {
      _setErrorMessage(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Sign out
  Future<void> signOut() async {
    _setLoading(true);
    _clearMessages();

    try {
      await _authService.signOut();
      _clearControllers();
      _setSuccessMessage('Signed out successfully!');
    } catch (e) {
      _setErrorMessage(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Reset password
  Future<bool> resetPassword() async {
    if (!_validateEmail()) return false;

    _setLoading(true);
    _clearMessages();

    try {
      await _authService.resetPassword(emailController.text.trim());
      _setSuccessMessage('Password reset email sent! Please check your inbox.');
      return true;
    } catch (e) {
      _setErrorMessage(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Update user profile
  Future<bool> updateProfile({String? displayName, String? photoURL}) async {
    _setLoading(true);
    _clearMessages();

    try {
      await _authService.updateUserProfile(
        displayName: displayName,
        photoURL: photoURL,
      );
      _setSuccessMessage('Profile updated successfully!');
      return true;
    } catch (e) {
      _setErrorMessage(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Change password
  Future<bool> changePassword(String newPassword) async {
    _setLoading(true);
    _clearMessages();

    try {
      await _authService.changePassword(newPassword);
      _setSuccessMessage('Password changed successfully!');
      return true;
    } catch (e) {
      _setErrorMessage(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Delete account
  Future<bool> deleteAccount() async {
    _setLoading(true);
    _clearMessages();

    try {
      await _authService.deleteAccount();
      _setSuccessMessage('Account deleted successfully!');
      return true;
    } catch (e) {
      _setErrorMessage(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Send email verification
  Future<bool> sendEmailVerification() async {
    _setLoading(true);
    _clearMessages();

    try {
      await _authService.sendEmailVerification();
      _setSuccessMessage('Verification email sent! Please check your inbox.');
      return true;
    } catch (e) {
      _setErrorMessage(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Reload user data
  Future<bool> reloadUser() async {
    _setLoading(true);
    _clearMessages();

    try {
      await _authService.reloadUser();
      return true;
    } catch (e) {
      _setErrorMessage(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Validation methods
  bool _validateSignUpForm() {
    if (displayNameController.text.trim().isEmpty) {
      _setErrorMessage('Please enter your name');
      return false;
    }

    if (!_validateEmail()) return false;

    if (passwordController.text.length < 6) {
      _setErrorMessage('Password must be at least 6 characters');
      return false;
    }

    if (passwordController.text != confirmPasswordController.text) {
      _setErrorMessage('Passwords do not match');
      return false;
    }

    return true;
  }

  bool _validateSignInForm() {
    if (!_validateEmail()) return false;

    if (passwordController.text.isEmpty) {
      _setErrorMessage('Please enter your password');
      return false;
    }

    return true;
  }

  bool _validateEmail() {
    if (emailController.text.trim().isEmpty) {
      _setErrorMessage('Please enter your email');
      return false;
    }

    if (!RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    ).hasMatch(emailController.text.trim())) {
      _setErrorMessage('Please enter a valid email address');
      return false;
    }

    return true;
  }

  // Helper methods
  void _setLoading(bool value) {
    isLoading.value = value;
  }

  void _setErrorMessage(String message) {
    errorMessage.value = message;
  }

  void _setSuccessMessage(String message) {
    successMessage.value = message;
  }

  void _clearMessages() {
    errorMessage.value = null;
    successMessage.value = null;
  }

  void _clearControllers() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    displayNameController.clear();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  // Dispose resources
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    displayNameController.dispose();
    isLoading.dispose();
    isPasswordVisible.dispose();
    isConfirmPasswordVisible.dispose();
    errorMessage.dispose();
    successMessage.dispose();
  }

  // Show snackbar messages
  void showMessage(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Navigate to different screens
  void navigateToHome(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
  }

  void navigateToLogin(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  void navigateToSignUp(BuildContext context) {
    Navigator.of(context).pushNamed('/signup');
  }

  void navigateToForgotPassword(BuildContext context) {
    Navigator.of(context).pushNamed('/forgot-password');
  }

  void navigateToProfile(BuildContext context) {
    Navigator.of(context).pushNamed('/profile');
  }

  void goBack(BuildContext context) {
    Navigator.of(context).pop();
  }

  void clearMessages() {
    _clearMessages();
  }
}

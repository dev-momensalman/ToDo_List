import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/database_service.dart';
import '../models/user_model.dart';
import 'note_controller.dart';

class AuthController {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  
  final ValueNotifier<bool> isLoggedIn = ValueNotifier(false);
  final ValueNotifier<bool> isCheckingAuth = ValueNotifier(true);

  late final NoteController noteController;

  AuthController() {
    noteController = NoteController();
  }

  Future<void> checkAuthStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final loginStatus = prefs.getBool('isLoggedIn') ?? false;
      isLoggedIn.value = loginStatus;
    } catch (e) {
      debugPrint('Error checking auth status: $e');
      isLoggedIn.value = false;
    } finally {
      isCheckingAuth.value = false;
    }
  }

  Future<void> login(BuildContext context) async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      _showError(context, 'Please fill all fields');
      return;
    }

    try {
      // للتبسيط، نستخدم مصادقة ثابتة. في التطبيق الحقيقي، يجب ربطها بقاعدة البيانات
      if (username == "Admin" && password == "Admin") {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);

        // تنظيف الحقول
        usernameController.clear();
        passwordController.clear();

        isLoggedIn.value = true;
        
        if (context.mounted) {
          _showSuccess(context, 'Login successful!');
        }
      } else {
        _showError(context, 'Invalid username or password');
      }
    } catch (e) {
      _showError(context, 'Login failed: $e');
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);
      
      isLoggedIn.value = false;
      
      if (context.mounted) {
        _showSuccess(context, 'Logged out successfully!');
      }
    } catch (e) {
      debugPrint('Error during logout: $e');
      if (context.mounted) {
        _showError(context, 'Logout failed');
      }
    }
  }

  Future<void> register({
    required String username,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      // في التطبيق الحقيقي، يجب إضافة المستخدم لقاعدة البيانات
      final user = User(
        username: username,
        email: email,
        password: password,
      );
      
      await DatabaseService.instance.createUser(user);
      
      _showSuccess(context, 'Registration successful! Please login.');
    } catch (e) {
      _showError(context, 'Registration failed: $e');
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent.withOpacity(0.8),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green.withOpacity(0.8),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    isLoggedIn.dispose();
    isCheckingAuth.dispose();
    noteController.dispose();
  }
}

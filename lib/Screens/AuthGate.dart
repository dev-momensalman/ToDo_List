import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:momensalman/Screens/Todo.dart';
import 'package:momensalman/Screens/login.dart';

class Authgate extends StatelessWidget {
  const Authgate({super.key});

  Future<bool> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData && snapshot.data == true) {
          return const TodoScreen();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}

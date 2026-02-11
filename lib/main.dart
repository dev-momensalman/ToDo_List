import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Provider/TodoProvider.dart';
import 'Screens/login.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => TodoProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Manager',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.deepPurple,
      ),
      home: const LoginPage(), // تبدأ بصفحة تسجيل الدخول التي أعددتها
    );
  }
}
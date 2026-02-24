import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// تأكد من أن المسار هنا يطابق مكان الملف في مشروعك
import 'Model/BLOC/TodoBloC.dart';
import 'Screens/login.dart';

void main() {
  runApp(
    BlocProvider(
      // تأكد من كتابة الاسم بنفس حالة الأحرف TodoBloC
      create: (context) => TodoBloC(),
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
      theme: ThemeData(useMaterial3: true),
      home: const LoginPage(),
    );
  }
}
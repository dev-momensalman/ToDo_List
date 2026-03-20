import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'views/auth/firebase_auth_gate.dart';
import 'views/auth/firebase_signup_view.dart';
import 'views/notes/notes_list_view.dart';
import 'controllers/note_controller.dart';
import 'controllers/firebase_auth_controller.dart';
import 'services/notification_service.dart';
import 'dart:developer';

void main() async {
  log('1- App starting...');
  WidgetsFlutterBinding.ensureInitialized();
  log('2- Initializing Firebase...');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  log('3- Firebase initialized successfully');

  // Initialize notifications
  log('4- Initializing notifications...');
  await NotificationService().initialize();
  log('5- Notifications initialized successfully');

  log('6- Starting app...');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    log('7- Building MaterialApp...');
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CloudNote - MVC Architecture',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C5CE7),
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Color(0xFF6C5CE7),
        ),
      ),
      home: const FirebaseAuthGate(),
      routes: {
        '/signup': (context) => const FirebaseSignUpView(),
        '/home': (context) => NotesListView(
          controller: NoteController(),
          authController: FirebaseAuthController(),
        ),
      },
    );
  }
}

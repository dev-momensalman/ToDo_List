import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../controllers/firebase_auth_controller.dart';
import '../../controllers/note_controller.dart';
import 'firebase_login_view.dart';
import '../notes/notes_list_view.dart';

class FirebaseAuthGate extends StatefulWidget {
  const FirebaseAuthGate({super.key});

  @override
  State<FirebaseAuthGate> createState() => _FirebaseAuthGateState();
}

class _FirebaseAuthGateState extends State<FirebaseAuthGate> {
  late final FirebaseAuthController _authController;
  late final NoteController _noteController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _authController = FirebaseAuthController();
    _noteController = NoteController();
    _isInitialized = true;
  }

  @override
  void dispose() {
    _authController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return StreamBuilder<User?>(
      stream: _authController.authStateChanges,
      builder: (context, snapshot) {
        // Show loading indicator while checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text("Loading...", style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          );
        }

        // User is authenticated, show home screen
        if (snapshot.hasData && snapshot.data != null) {
          return NotesListView(
            controller: _noteController,
            authController: _authController,
          );
        }

        // User is not authenticated, show login screen
        return const FirebaseLoginView();
      },
    );
  }
}

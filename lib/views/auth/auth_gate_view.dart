import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/note_controller.dart';
import 'login_view.dart';
import '../notes/notes_list_view.dart';

class AuthGateView extends StatefulWidget {
  const AuthGateView({super.key});

  @override
  State<AuthGateView> createState() => _AuthGateViewState();
}

class _AuthGateViewState extends State<AuthGateView> {
  late final AuthController _authController;
  late final NoteController _noteController;

  @override
  void initState() {
    super.initState();
    _authController = AuthController();
    _noteController = NoteController();
    _authController.checkAuthStatus();
  }

  @override
  void dispose() {
    _authController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _authController.isCheckingAuth,
      builder: (context, isChecking, _) {
        if (isChecking) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return ValueListenableBuilder<bool>(
          valueListenable: _authController.isLoggedIn,
          builder: (context, isLoggedIn, _) {
            if (isLoggedIn) {
              return NotesListView(controller: _noteController);
            } else {
              return LoginView(controller: _authController);
            }
          },
        );
      },
    );
  }
}

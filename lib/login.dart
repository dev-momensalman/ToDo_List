import 'package:flutter/material.dart';
import 'package:momensalman/ToDo.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordhidden = true;

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordhidden = !_isPasswordhidden;
    });
  }

  void login(BuildContext context) {
    if (_usernameController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      if (_usernameController.text == "Admin") {
        if (_passwordController.text == "Admin") {
          _usernameController.clear();
          _passwordController.clear();

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ToDo()),
          );
        } else {
          _passwordController.clear();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Wrong Password!")),
          );
        }
      } else {
        _usernameController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Wrong Email!")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        backgroundColor: Colors.blue,
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                  labelText: 'Email',
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: _passwordController,
                obscureText: _isPasswordhidden,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.key),
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    onPressed: _togglePasswordVisibility,
                    icon: _isPasswordhidden
                        ? const Icon(Icons.visibility_off)
                        : const Icon(Icons.visibility),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () => login(context),
                child: const Icon(Icons.login),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

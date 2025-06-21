import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../HomePage.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String errorMessage = '';

 Future<void> login() async {
  try {
    final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );
    navigateToWelcome(userCredential.user!.email ?? '');
  } on FirebaseAuthException catch (e) {
    setState(() {
      errorMessage = e.message ?? 'Login fehlgeschlagen';
    });
  }
}

Future<void> register() async {
  try {
    final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );
    navigateToWelcome(userCredential.user!.email ?? '');
  } on FirebaseAuthException catch (e) {
    setState(() {
      errorMessage = e.message ?? 'Registrierung fehlgeschlagen';
    });
  }
}

void navigateToWelcome(String email) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => WelcomePage(email: email)),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (errorMessage.isNotEmpty)
              Text(errorMessage, style: const TextStyle(color: Colors.red)),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'E-Mail'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Passwort'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: login,
              child: const Text('Login'),
            ),
            TextButton(
              onPressed: register,
              child: const Text('Registrieren'),
            ),
          ],
        ),
      ),
    );
  }
}

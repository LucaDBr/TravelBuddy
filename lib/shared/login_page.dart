import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'HomePage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final confirmEmailController = TextEditingController();
  final passwordController = TextEditingController();

  String errorMessage = '';
  bool isLoading = false;
  bool isRegisterMode = false;

  Future<void> handleSubmit() async {
    setState(() {
      errorMessage = '';
      isLoading = true;
    });

    final email = emailController.text.trim();
    final confirmEmail = confirmEmailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty || (isRegisterMode && confirmEmail.isEmpty)) {
      setState(() {
        errorMessage = 'Bitte alle Felder ausfüllen.';
        isLoading = false;
      });
      return;
    }

    if (isRegisterMode && email != confirmEmail) {
      setState(() {
        errorMessage = 'Die E-Mail-Adressen stimmen nicht überein.';
        isLoading = false;
      });
      return;
    }

    try {
      if (isRegisterMode) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      }

      navigateToWelcome();
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? (isRegisterMode ? 'Registrierung fehlgeschlagen' : 'Login fehlgeschlagen');
        isLoading = false;
      });
    }
  }

  void navigateToWelcome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const WelcomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: Text(isRegisterMode ? 'Registrieren' : 'Login'),
        centerTitle: true,
        backgroundColor: accentColor,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Icon(isRegisterMode ? Icons.person_add : Icons.lock_outline, size: 80, color: accentColor),
              const SizedBox(height: 16),
              Text(
                isRegisterMode ? 'Konto erstellen' : 'Willkommen zurück',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              if (errorMessage.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(child: Text(errorMessage, style: const TextStyle(color: Colors.red))),
                    ],
                  ),
                ),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'E-Mail',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              if (isRegisterMode)
                Column(
                  children: [
                    TextField(
                      controller: confirmEmailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'E-Mail bestätigen',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Passwort',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton.icon(
                      onPressed: handleSubmit,
                      icon: Icon(isRegisterMode ? Icons.person_add : Icons.login),
                      label: Text(isRegisterMode ? 'Registrieren' : 'Login'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                        backgroundColor: accentColor,
                        foregroundColor: Colors.white,
                      ),
                    ),
              TextButton(
                onPressed: () {
                  setState(() {
                    isRegisterMode = !isRegisterMode;
                    errorMessage = '';
                  });
                },
                child: Text(isRegisterMode
                    ? 'Schon registriert? Jetzt einloggen'
                    : 'Noch kein Konto? Jetzt registrieren'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

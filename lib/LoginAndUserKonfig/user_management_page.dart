import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  final passwordController = TextEditingController();
  String message = '';

  Future<void> changePassword() async {
    try {
      await FirebaseAuth.instance.currentUser!.updatePassword(passwordController.text.trim());
      setState(() {
        message = '✅ Passwort erfolgreich geändert.';
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        message = '❌ Fehler: ${e.message}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nutzerverwaltung')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (message.isNotEmpty)
              Text(message, style: TextStyle(color: message.startsWith('✅') ? Colors.green : Colors.red)),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Neues Passwort'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: changePassword,
              child: const Text('Passwort ändern'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'LoginAndUserKonfig/login_page.dart';
import 'LoginAndUserKonfig/user_management_page.dart';
import 'reise_uebersicht_page.dart'; // <- hinzufügen
import 'LoginAndUserKonfig/system_settings_page.dart';

class WelcomePage extends StatelessWidget {
  final String email;

  const WelcomePage({super.key, required this.email});

  void logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  void openUserManagement(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const UserManagementPage()),
    );
  }

  void openReiseUebersicht(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ReiseUebersichtPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Willkommen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => logout(context),
            tooltip: 'Abmelden',
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.blue),
              child: Text(
                'Hallo, $email',
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.travel_explore),
              title: const Text('Meine Reisen'),
              onTap: () {
                Navigator.pop(context); // Drawer schließen
                openReiseUebersicht(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.manage_accounts),
              title: const Text('Nutzerverwaltung'),
              onTap: () {
                Navigator.pop(context);
                openUserManagement(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Abmelden'),
              onTap: () {
                Navigator.pop(context);
                logout(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Systemeinstellungen'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SystemSettingsPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text(
          'Herzlich willkommen, $email!',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

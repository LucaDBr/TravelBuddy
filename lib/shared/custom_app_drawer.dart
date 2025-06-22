// CustomAppDrawer mit Navigation und zugehörigen Dummy-Seiten

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomAppDrawer extends StatelessWidget {
  final String selectedRoute;
  final Function(String route) onNavigate;

  const CustomAppDrawer({
    super.key,
    required this.selectedRoute,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Colors.deepPurple),
            accountName: Text(user?.displayName ?? 'Nutzer'),
            accountEmail: Text(user?.email ?? '-'),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Colors.deepPurple),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildTile(context, Icons.home, 'Dashboard', '/home'),
                _buildTile(context, Icons.travel_explore, 'Meine Reisen', '/reisen'),
                _buildTile(context, Icons.group, 'Nutzerverwaltung', '/nutzer'),
                _buildTile(context, Icons.settings, 'Systemeinstellungen', '/einstellungen'),
                _buildTile(context, Icons.notifications, 'Benachrichtigungen', '/benachrichtigungen'),
                _buildTile(context, Icons.person, 'Mein Profil', '/profil'),
                _buildTile(context, Icons.feedback, 'Feedback geben', '/feedback'),
                _buildTile(context, Icons.info_outline, 'Über TravelBuddy', '/about'),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Abmelden'),
            onTap: () => onNavigate('/logout'),
          )
        ],
      ),
    );
  }

  Widget _buildTile(BuildContext context, IconData icon, String label, String route) {
    final selected = selectedRoute == route;
    return ListTile(
      leading: Icon(icon, color: selected ? Colors.deepPurple : null),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          color: selected ? Colors.deepPurple : null,
        ),
      ),
      selected: selected,
      selectedTileColor: Colors.deepPurple.withOpacity(0.1),
      onTap: () => onNavigate(route),
    );
  }
}

// Dummy-Seiten zum Verlinken im Drawer

class BenachrichtigungenPage extends StatelessWidget {
  const BenachrichtigungenPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Benachrichtigungen')),
      body: const Center(child: Text('Hier erscheinen Reise-Updates & Hinweise.')),
    );
  }
}

class MeinProfilPage extends StatelessWidget {
  const MeinProfilPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mein Profil')),
      body: const Center(child: Text('Profil bearbeiten, Bild & Name aktualisieren.')),
    );
  }
}

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feedback geben')),
      body: const Center(child: Text('Wie gefällt dir TravelBuddy?')),
    );
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Über TravelBuddy')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text('TravelBuddy hilft dir bei der Planung und Durchführung deiner Reisen.\nVersion: 1.0.0'),
      ),
    );
  }
}
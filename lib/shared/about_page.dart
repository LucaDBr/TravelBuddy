import 'package:flutter/material.dart';
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Über TravelBuddy')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'TravelBuddy hilft dir bei der Planung und Durchführung deiner Reisen.\n\nVersion: 1.0.0',
        ),
      ),
    );
  }
}
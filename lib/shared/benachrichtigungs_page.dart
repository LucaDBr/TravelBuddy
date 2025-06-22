import 'package:flutter/material.dart';
class BenachrichtigungenPage extends StatelessWidget {
  const BenachrichtigungenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Benachrichtigungen')),
      body: const Center(child: Text('Reise-Updates & Hinweise.')),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travelbuddy_flutter/LoginAndUserKonfig/system_management.dart';
class SystemSettingsPage extends StatelessWidget {
  const SystemSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final currentMode = themeNotifier.mode;

    return Scaffold(
      appBar: AppBar(title: const Text('Systemeinstellungen')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Darstellung',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            RadioListTile<ThemeMode>(
              title: const Text('Systemstandard'),
              value: ThemeMode.system,
              groupValue: currentMode,
              onChanged: (mode) => themeNotifier.setMode(mode!),
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Hell'),
              value: ThemeMode.light,
              groupValue: currentMode,
              onChanged: (mode) => themeNotifier.setMode(mode!),
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Dunkel'),
              value: ThemeMode.dark,
              groupValue: currentMode,
              onChanged: (mode) => themeNotifier.setMode(mode!),
            ),
          ],
        ),
      ),
    );
  }
}

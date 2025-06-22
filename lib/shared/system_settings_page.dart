import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travelbuddy_flutter/shared/theme_notifier.dart';

class SystemSettingsPage extends StatelessWidget {
  const SystemSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final currentMode = themeNotifier.mode;

    final Color accentColor = const Color(0xFF3B82F6);
    final Color cardColor = Theme.of(context).cardColor;
    final Color dividerColor = Colors.grey.shade300;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Systemeinstellungen'),
        centerTitle: true,
        backgroundColor: accentColor,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: cardColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.color_lens_outlined, size: 24),
                      SizedBox(width: 8),
                      Text(
                        'Design-Modus',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Divider(color: dividerColor),

                  RadioListTile<ThemeMode>(
                    title: const Text('Systemstandard'),
                    value: ThemeMode.system,
                    groupValue: currentMode,
                    onChanged: (mode) {
                      if (mode != null) themeNotifier.setMode(mode);
                    },
                    secondary: const Icon(Icons.settings_suggest_outlined),
                    activeColor: accentColor,
                  ),
                  RadioListTile<ThemeMode>(
                    title: const Text('Hell'),
                    value: ThemeMode.light,
                    groupValue: currentMode,
                    onChanged: (mode) {
                      if (mode != null) themeNotifier.setMode(mode);
                    },
                    secondary: const Icon(Icons.light_mode_outlined),
                    activeColor: accentColor,
                  ),
                  RadioListTile<ThemeMode>(
                    title: const Text('Dunkel'),
                    value: ThemeMode.dark,
                    groupValue: currentMode,
                    onChanged: (mode) {
                      if (mode != null) themeNotifier.setMode(mode);
                    },
                    secondary: const Icon(Icons.dark_mode_outlined),
                    activeColor: accentColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

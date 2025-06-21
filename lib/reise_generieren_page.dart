import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReiseGenerierenPage extends StatefulWidget {
  const ReiseGenerierenPage({super.key});

  @override
  State<ReiseGenerierenPage> createState() => _ReiseGenerierenPageState();
}

class _ReiseGenerierenPageState extends State<ReiseGenerierenPage> {
  final TextEditingController landController = TextEditingController();
  final TextEditingController wuenscheController = TextEditingController();

  DateTimeRange? datumRange;
  bool generating = false;
  String status = '';

  Future<void> pickDateRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
      initialDateRange: datumRange ??
          DateTimeRange(start: now, end: now.add(const Duration(days: 7))),
    );

    if (picked != null) {
      setState(() => datumRange = picked);
    }
  }

  void generiereReise() {
    if (landController.text.isEmpty || datumRange == null) {
      setState(() => status = 'Bitte Land und Zeitraum angeben');
      return;
    }

    setState(() {
      generating = true;
      status = '';
    });

    // Hier später deine KI-Logik einsetzen
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        generating = false;
        status = '✅ Reisevorschlag erfolgreich erstellt (Platzhalter)';
      });

      // Optional: Weiterleitung zur automatisch erstellten Detailseite
    });
  }

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('dd.MM.yyyy');

    return Scaffold(
      appBar: AppBar(title: const Text('Reise generieren')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (status.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: status.startsWith('✅') ? Colors.green : Colors.red,
                    ),
                  ),
                ),
              TextField(
                controller: landController,
                decoration: const InputDecoration(
                  labelText: 'Zielland oder Region',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: wuenscheController,
                decoration: const InputDecoration(
                  labelText: 'Wuensche / Vorstellungen',
                  hintText: 'z. B. Kultur, Natur, Erholung',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  datumRange == null
                      ? 'Zeitraum auswählen'
                      : '${formatter.format(datumRange!.start)} – ${formatter.format(datumRange!.end)}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: pickDateRange,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.auto_awesome),
                label: const Text('Reise generieren'),
                onPressed: generating ? null : generiereReise,
              ),
              if (generating)
                const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

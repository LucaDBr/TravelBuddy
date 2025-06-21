import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'DBModels/trip_model.dart';

class NeueReisePage extends StatefulWidget {
  const NeueReisePage({super.key});

  @override
  State<NeueReisePage> createState() => _NeueReisePageState();
}

class _NeueReisePageState extends State<NeueReisePage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final destinationController = TextEditingController();
  final descriptionController = TextEditingController();

  DateTime? startDate;
  DateTime? endDate;
  String status = '';
  bool saving = false;

  Future<void> _pickDateRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(2100),
      initialDateRange: startDate != null && endDate != null
          ? DateTimeRange(start: startDate!, end: endDate!)
          : null,
    );

    if (picked != null) {
      setState(() {
        startDate = picked.start;
        endDate = picked.end;
      });
    }
  }

  Future<void> reiseErstellen() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() => status = '⚠️ Kein Benutzer angemeldet.');
      return;
    }

    if (!_formKey.currentState!.validate()) return;
    if (startDate == null || endDate == null) {
      setState(() => status = '⚠️ Bitte Start- und Enddatum wählen.');
      return;
    }

    setState(() {
      saving = true;
      status = '';
    });

    try {
      final trip = TripModel(
        title: nameController.text.trim(),
        destination: destinationController.text.trim().isEmpty ? null : destinationController.text.trim(),
        description: descriptionController.text.trim().isEmpty ? null : descriptionController.text.trim(),
        startDate: startDate,
        endDate: endDate,
        ownerUid: user.uid,
        members: [user.uid],
        createdAt: DateTime.now(),
      );

      await FirebaseFirestore.instance.collection('trips').add(trip.toJson());

      if (mounted) Navigator.pop(context);
    } catch (e) {
      setState(() => status = '❌ Fehler beim Speichern: $e');
    } finally {
      setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd.MM.yyyy');

    return Scaffold(
      appBar: AppBar(title: const Text('🧳 Neue Reise')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (status.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      status,
                      style: TextStyle(
                        color: status.startsWith('❌') ? Colors.red : Colors.orange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Reisetitel *',
                    prefixIcon: Icon(Icons.title),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Bitte einen Titel eingeben' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: destinationController,
                  decoration: const InputDecoration(
                    labelText: 'Zielort (optional)',
                    prefixIcon: Icon(Icons.location_on_outlined),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.date_range),
                  title: Text(
                    (startDate != null && endDate != null)
                        ? 'Zeitraum: ${dateFormat.format(startDate!)} → ${dateFormat.format(endDate!)}'
                        : 'Start- und Enddatum wählen',
                  ),
                  trailing: TextButton(
                    onPressed: _pickDateRange,
                    child: const Text('Zeitraum wählen'),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Beschreibung (optional)',
                    alignLabelWithHint: true,
                    prefixIcon: Icon(Icons.notes),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: saving ? null : reiseErstellen,
                    icon: saving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.save),
                    label: const Text('Reise speichern'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

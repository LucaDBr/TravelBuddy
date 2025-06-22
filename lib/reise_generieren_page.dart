import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/ki_reise_service.dart';
import '../DBModels/trip_model.dart';
import '../DBModels/itinerary_item.dart';

class ReiseGenerierenPage extends StatefulWidget {
  const ReiseGenerierenPage({super.key});

  @override
  State<ReiseGenerierenPage> createState() => _ReiseGenerierenPageState();
}

class _ReiseGenerierenPageState extends State<ReiseGenerierenPage> {
  final landCtrl = TextEditingController();
  final wishCtrl = TextEditingController();
  DateTimeRange? range;
  bool generating = false;
  String status = '';

  final List<String> interessen = [
    'Kultur', 'Natur', 'Wandern', 'Strand',
    'Städtereise', 'Essen & Trinken', 'Ruhe', 'Abenteuer'
  ];

  final List<String> transport = ['ÖPNV', 'Mietwagen', 'Fahrrad'];
  final List<String> unterkuenfte = ['Hotel', 'Hostel', 'Airbnb', 'Camping'];

  final selectedTags = <String>{};
  final selectedTransport = <String>{};
  final selectedUnterkunft = <String>{};
  String reisestil = 'ausgewogen';
  String budget = 'mittel';

  Future<void> _pickDates() async {
    final now = DateTime.now();
    final init = range ?? DateTimeRange(start: now, end: now.add(const Duration(days: 7)));
    final picked = await showDateRangePicker(
      context: context,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
      initialDateRange: init,
    );
    if (picked != null) setState(() => range = picked);
  }

  Future<void> _startGeneration() async {
    if (landCtrl.text.isEmpty || range == null) {
      setState(() => status = '⚠️ Bitte Land und Zeitraum angeben');
      return;
    }

    setState(() {
      generating = true;
      status = '';
    });

    try {
      final days = await KIReiseService.generiereReiseAdvanced(
        land: landCtrl.text,
        start: range!.start,
        end: range!.end,
        wuensche: wishCtrl.text,
        interessen: selectedTags.join(', '),
        budget: budget,
        stil: reisestil,
        transport: selectedTransport.join(', '),
        unterkunft: selectedUnterkunft.join(', '),
      );

      debugPrint('⏬ Generierte Tage: ${jsonEncode(days)}', wrapWidth: 1024);

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('Nicht eingeloggt.');

      final tripRef = FirebaseFirestore.instance.collection('trips').doc();
      final trip = TripModel(
        id: tripRef.id,
        title: 'KI-Reise ${landCtrl.text}',
        destination: landCtrl.text,
        description: wishCtrl.text,
        startDate: range!.start,
        endDate: range!.end,
        ownerUid: user.uid,
        members: [user.uid],
        createdAt: DateTime.now(),
      );
      await tripRef.set(trip.toJson());

      int tagCounter = 0;
      for (int i = 0; i < days.length; i++) {
        final d = days[i] as Map<String, dynamic>;
        final startDate = DateTime.parse(d['date']);
        final endDate = d['enddate'] != null ? DateTime.parse(d['enddate']) : startDate;

        final points = (d['points'] as List).map((p) {
          final lat = (p['latitude'] as num?)?.toDouble() ?? 0.0;
          final lon = (p['longitude'] as num?)?.toDouble() ?? 0.0;
          return ItineraryPoint(
            title: p['title'] ?? 'POI',
            notes: p['notes'] ?? '',
            latitude: lat,
            longitude: lon,
          );
        }).toList();

        final dayRef = tripRef.collection('itineraries').doc();
        await dayRef.set({
          'id': dayRef.id,
          'dayIndex': tagCounter++,
          'date': startDate.toIso8601String(),
          'endDate': endDate.toIso8601String(),
          'items': points.map((e) => e.toJson()).toList(),
          'lastModified': DateTime.now().toIso8601String(),
        });
      }

      setState(() => status = '✅ Reise gespeichert!');
    } catch (e) {
      setState(() => status = '❌ Fehler: ${e.toString()}');
    } finally {
      setState(() => generating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('dd.MM.yyyy');
    return Scaffold(
      appBar: AppBar(title: const Text('KI-Reise erstellen')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (status.isNotEmpty)
                Text(status, style: TextStyle(color: status.startsWith('✅') ? Colors.green : Colors.red)),
              const SizedBox(height: 12),
              TextField(
                controller: landCtrl,
                decoration: const InputDecoration(labelText: 'Zielland / Region'),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                children: interessen.map((e) => FilterChip(
                  label: Text(e),
                  selected: selectedTags.contains(e),
                  onSelected: (v) => setState(() => v ? selectedTags.add(e) : selectedTags.remove(e)),
                )).toList(),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: wishCtrl,
                decoration: const InputDecoration(
                  labelText: 'Weitere Wünsche (optional)',
                  hintText: 'z. B. Thermalbäder, lokale Märkte, Weinproben…',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField(
                decoration: const InputDecoration(labelText: 'Reisestil'),
                value: reisestil,
                items: ['ausgewogen', 'entspannt', 'aktiv', 'luxus']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (val) => setState(() => reisestil = val!),
              ),
              DropdownButtonFormField(
                decoration: const InputDecoration(labelText: 'Budget'),
                value: budget,
                items: ['günstig', 'mittel', 'gehoben']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (val) => setState(() => budget = val!),
              ),
              const SizedBox(height: 12),
              Text('Transportmittel:'),
              Wrap(
                spacing: 6,
                children: transport.map((e) => FilterChip(
                  label: Text(e),
                  selected: selectedTransport.contains(e),
                  onSelected: (v) => setState(() => v ? selectedTransport.add(e) : selectedTransport.remove(e)),
                )).toList(),
              ),
              const SizedBox(height: 12),
              Text('Unterkunftsarten:'),
              Wrap(
                spacing: 6,
                children: unterkuenfte.map((e) => FilterChip(
                  label: Text(e),
                  selected: selectedUnterkunft.contains(e),
                  onSelected: (v) => setState(() => v ? selectedUnterkunft.add(e) : selectedUnterkunft.remove(e)),
                )).toList(),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text(
                  range == null ? 'Zeitraum wählen' : '${fmt.format(range!.start)} – ${fmt.format(range!.end)}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: _pickDates,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                tileColor: Colors.grey.shade200,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.auto_awesome),
                label: const Text('Reise generieren'),
                onPressed: generating ? null : _startGeneration,
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

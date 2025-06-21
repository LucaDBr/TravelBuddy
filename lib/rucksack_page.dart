import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

import 'DBModels/trip_model.dart';
import 'DBModels/packing_item.dart';
import 'services/ki_rucksack_service.dart';

class RucksackPage extends StatefulWidget {
  final TripModel trip;
  const RucksackPage({super.key, required this.trip});

  @override
  State<RucksackPage> createState() => _RucksackPageState();
}

class _RucksackPageState extends State<RucksackPage> {
  String? selectedCategory;
  bool generating = false;
  String? status;

  final List<String> categories = ['Kleidung', 'Technik', 'Hygiene', 'Sonstiges'];
  final Set<String> categoryFilter = {};

  Stream<List<PackingItem>> get _items$ {
    final ref = FirebaseFirestore.instance
        .collection('trips')
        .doc(widget.trip.id)
        .collection('packing');

    return ref.snapshots().map((snap) => snap.docs
        .map((doc) => PackingItem.fromJson(doc.data()).copyWith(id: doc.id))
        .where((item) => categoryFilter.isEmpty || categoryFilter.contains(item.category))
        .toList());
  }

  Future<void> _togglePacked(PackingItem item) async {
    final ref = FirebaseFirestore.instance
        .collection('trips')
        .doc(widget.trip.id)
        .collection('packing')
        .doc(item.id);
    await ref.update({'packed': !item.packed});
  }

  Future<void> _deleteItem(PackingItem item) async {
    final ref = FirebaseFirestore.instance
        .collection('trips')
        .doc(widget.trip.id)
        .collection('packing')
        .doc(item.id);
    await ref.delete();
  }

  Future<void> _clearAll() async {
    final ref = FirebaseFirestore.instance
        .collection('trips')
        .doc(widget.trip.id)
        .collection('packing');
    final snap = await ref.get();
    final batch = FirebaseFirestore.instance.batch();
    for (final doc in snap.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
    setState(() => status = '🗑️ Rucksack geleert');
  }

  Future<void> _addItemManually() async {
    final itemCtrl = TextEditingController();
    final catCtrl = TextEditingController();

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Gegenstand hinzufügen'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: itemCtrl, decoration: const InputDecoration(labelText: 'Gegenstand')),
            TextField(controller: catCtrl, decoration: const InputDecoration(labelText: 'Kategorie')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Abbrechen')),
          ElevatedButton(
            onPressed: () async {
              final ref = FirebaseFirestore.instance
                  .collection('trips')
                  .doc(widget.trip.id)
                  .collection('packing')
                  .doc();
              final item = PackingItem(
                id: ref.id,
                item: itemCtrl.text.trim(),
                category: catCtrl.text.trim(),
              );
              await ref.set(item.toJson());
              Navigator.pop(ctx);
            },
            child: const Text('Hinzufügen'),
          ),
        ],
      ),
    );
  }

  Future<void> _generatePackliste() async {
    setState(() {
      generating = true;
      status = null;
    });

    try {
      final zeitraum =
          '${widget.trip.startDate?.toIso8601String().split("T")[0]} bis ${widget.trip.endDate?.toIso8601String().split("T")[0]}';

      final items = await KIService.generatePackliste(
        land: widget.trip.destination ?? 'Unbekannt',
        zeitraum: zeitraum,
        transportmittel: ['Rucksack'],
        unterkuenfte: ['Hotel'],
        reisestil: 'ausgewogen',
        wuensche: widget.trip.description ?? '',
      );

      final batch = FirebaseFirestore.instance.batch();
      final ref = FirebaseFirestore.instance
          .collection('trips')
          .doc(widget.trip.id)
          .collection('packing');

      for (final e in items) {
        final doc = ref.doc();
        final item = PackingItem.fromJson(e).copyWith(id: doc.id);
        batch.set(doc, item.toJson());
      }

      await batch.commit();
      setState(() => status = '✅ Packliste wurde hinzugefügt!');
    } catch (e) {
      setState(() => status = '❌ Fehler: ${e.toString()}');
    } finally {
      setState(() => generating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🎒 Rucksack – ${widget.trip.title}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Gegenstand hinzufügen',
            onPressed: _addItemManually,
          ),
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            tooltip: 'Rucksack leeren',
            onPressed: _clearAll,
          ),
        ],
      ),
      body: Column(
        children: [
          if (status != null)
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                status!,
                style: TextStyle(
                  color: status!.startsWith('✅') ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Kategorie filtern'),
              value: categoryFilter.isEmpty ? null : categoryFilter.first,
              items: [
                const DropdownMenuItem(value: null, child: Text('Alle')),
                ...categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))),
              ],
              onChanged: (val) {
                setState(() {
                  categoryFilter.clear();
                  if (val != null) categoryFilter.add(val);
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<List<PackingItem>>(
              stream: _items$,
              builder: (context, snap) {
                if (!snap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final items = snap.data!;
                if (items.isEmpty) {
                  return const Center(child: Text('Keine Gegenstände gefunden.'));
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const Divider(height: 12),
                  itemBuilder: (_, i) {
                    final item = items[i];
                    return Dismissible(
                      key: ValueKey(item.id),
                      background: Container(color: Colors.red.shade200),
                      onDismissed: (_) => _deleteItem(item),
                      child: CheckboxListTile(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        tileColor: Colors.grey.shade100,
                        title: Text(item.item),
                        subtitle: item.category != null ? Text(item.category!) : null,
                        value: item.packed,
                        onChanged: (_) => _togglePacked(item),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: generating ? null : _generatePackliste,
        icon: const Icon(Icons.auto_awesome),
        label: const Text('KI-Packliste'),
      ),
    );
  }
}

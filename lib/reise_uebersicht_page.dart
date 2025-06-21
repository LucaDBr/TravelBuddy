import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'reise_detail_page.dart';
import 'neue_reise_page.dart';
import 'reise_generieren_page.dart'; // NEU
import 'DBModels/trip_model.dart';

class ReiseUebersichtPage extends StatelessWidget {
  const ReiseUebersichtPage({super.key});

  Stream<List<TripModel>> ladeReisen() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Stream.empty();

    return FirebaseFirestore.instance
        .collection('trips')
        .where('ownerUid', isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              return TripModel.fromJson(data).copyWith(id: doc.id);
            }).toList());
  }

  Future<void> _reiseLoeschenMitBestaetigung(BuildContext context, TripModel trip) async {
    bool bestaetigt = false;

    await showDialog(
      context: context,
      builder: (ctx) {
        int countdown = 3;
        late StateSetter updateState;

        void tick() {
          Future.delayed(const Duration(seconds: 1), () {
            if (countdown > 1) {
              updateState(() {
                countdown--;
                tick();
              });
            }
          });
        }

        return StatefulBuilder(
          builder: (context, setState) {
            updateState = setState;
            tick();
            return AlertDialog(
              title: const Text('Reise löschen'),
              content: Text(
                'Möchtest du die Reise "${trip.title}" wirklich löschen?\n\n'
                'Löschen ist erst nach $countdown Sekunden möglich.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Abbrechen'),
                ),
                TextButton(
                  onPressed: countdown <= 1
                      ? () {
                          bestaetigt = true;
                          Navigator.pop(ctx);
                        }
                      : null,
                  child: const Text('Löschen'),
                ),
              ],
            );
          },
        );
      },
    );

    if (bestaetigt) {
      await FirebaseFirestore.instance.collection('trips').doc(trip.id).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reise "${trip.title}" gelöscht')),
      );
    }
  }

  void _zeigeReiseGenerierenDialog(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ReiseGenerierenPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meine Reisen')),
      body: StreamBuilder<List<TripModel>>(
        stream: ladeReisen(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Fehler beim Laden der Reisen'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final reisen = snapshot.data!;
          if (reisen.isEmpty) {
            return const Center(child: Text('Noch keine Reisen erstellt.'));
          }

          return ListView.builder(
            itemCount: reisen.length,
            itemBuilder: (context, index) {
              final trip = reisen[index];
              return ListTile(
                title: Text(trip.title),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => _reiseLoeschenMitBestaetigung(context, trip),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ReiseDetailPage(trip: trip),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.extended(
            heroTag: 'generate',
            icon: const Icon(Icons.auto_fix_high),
            label: const Text('Reise generieren'),
            onPressed: () => _zeigeReiseGenerierenDialog(context),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'create',
            child: const Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NeueReisePage()),
            ),
          ),
        ],
      ),
    );
  }
}

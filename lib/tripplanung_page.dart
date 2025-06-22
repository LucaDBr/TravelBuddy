import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart';

import 'DBModels/trip_model.dart';
import 'DBModels/itinerary_item.dart';
import 'itinerary_day_page.dart';

class TripplanungPage extends StatefulWidget {
  final TripModel trip;
  const TripplanungPage({super.key, required this.trip});

  @override
  State<TripplanungPage> createState() => _TripplanungPageState();
}

class _TripplanungPageState extends State<TripplanungPage> {
  final MapController _mapController = MapController();
  double _zoom = 6;
  late Stream<List<ItineraryItem>> _stages$;
  bool mapReady = false;

  @override
  void initState() {
    super.initState();

    _stages$ = FirebaseFirestore.instance
        .collection('trips')
        .doc(widget.trip.id)
        .collection('itineraries')
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => ItineraryItem.fromJson(d.data()).copyWith(id: d.id))
            .toList()
          ..sort((a, b) => a.date.compareTo(b.date)));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() => mapReady = true);
    });
  }

  Future<void> _createStage() async {
    final now = DateTime.now();
    final doc = FirebaseFirestore.instance
        .collection('trips')
        .doc(widget.trip.id)
        .collection('itineraries')
        .doc();

    final newDay = ItineraryItem(
      id: doc.id,
      dayIndex: now.millisecondsSinceEpoch,
      date: now,
      endDate: now,
      items: [],
      lastModified: now,
    );

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ItineraryDayPage(
          trip: widget.trip,
          day: newDay,
          createNew: true,
        ),
      ),
    );
  }

  Future<void> _deleteStage(ItineraryItem item) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Etappe löschen"),
        content: const Text("Möchtest du diese Etappe wirklich entfernen?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Abbrechen")),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("Löschen")),
        ],
      ),
    );

    if (confirm == true) {
      await FirebaseFirestore.instance
          .collection('trips')
          .doc(widget.trip.id)
          .collection('itineraries')
          .doc(item.id)
          .delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('dd.MM.yyyy');

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.trip.title, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(
              '${formatter.format(widget.trip.startDate!)} → ${formatter.format(widget.trip.endDate!)}',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white70),
            ),
          ],
        ),
      ),
      body: StreamBuilder<List<ItineraryItem>>(
        stream: _stages$,
        builder: (context, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());

          final stages = snap.data!..sort((a, b) => a.date.compareTo(b.date));
          final points = stages.where((s) => s.items.isNotEmpty).map((s) => s.items.last).toList();
          final coords = points.map((p) => LatLng(p.latitude, p.longitude)).toList();

          LatLng center = const LatLng(48.8566, 2.3522);
          if (coords.isNotEmpty && mapReady) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _mapController.moveAndRotate(coords.first, _zoom, 0);
            });
          }

          return Column(
            children: [
              Card(
                margin: const EdgeInsets.all(12),
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: SizedBox(
                  height: 240,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: FlutterMap(
                          mapController: _mapController,
                          options: MapOptions(
                            initialCenter: center,
                            initialZoom: _zoom,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.travelbuddy.app',
                            ),
                            if (coords.length >= 2)
                              PolylineLayer(polylines: [
                                Polyline(points: coords, strokeWidth: 4, color: Colors.blue),
                              ]),
                            MarkerLayer(
                              markers: points
                                  .map((p) => Marker(
                                        point: LatLng(p.latitude, p.longitude),
                                        width: 40,
                                        height: 40,
                                        child: const Icon(Icons.location_pin, color: Colors.red),
                                      ))
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                      _ZoomButtons(
                        onZoomIn: () {
                          if (!mapReady) return;
                          setState(() {
                            _zoom++;
                            _mapController.moveAndRotate(_mapController.camera.center, _zoom, 0);
                          });
                        },
                        onZoomOut: () {
                          if (!mapReady) return;
                          setState(() {
                            _zoom--;
                            _mapController.moveAndRotate(_mapController.camera.center, _zoom, 0);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Reisezeitraum: ${formatter.format(widget.trip.startDate!)} - ${formatter.format(widget.trip.endDate!)}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Expanded(
                child: Scrollbar(
                  thumbVisibility: true,
                  child: ReorderableListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: stages.length,
                    onReorder: (oldIndex, newIndex) async {
                      if (newIndex > oldIndex) newIndex--;
                      final oldItem = stages[oldIndex];
                      final newItem = stages[newIndex];

                      final batch = FirebaseFirestore.instance.batch();
                      final oldRef = FirebaseFirestore.instance
                          .collection('trips')
                          .doc(widget.trip.id)
                          .collection('itineraries')
                          .doc(oldItem.id);
                      final newRef = FirebaseFirestore.instance
                          .collection('trips')
                          .doc(widget.trip.id)
                          .collection('itineraries')
                          .doc(newItem.id);

                      batch.update(oldRef, {
                        'dayIndex': newIndex,
                        'date': newItem.date.toIso8601String(),
                        'endDate': newItem.endDate.toIso8601String(),
                      });

                      batch.update(newRef, {
                        'dayIndex': oldIndex,
                        'date': oldItem.date.toIso8601String(),
                        'endDate': oldItem.endDate.toIso8601String(),
                      });

                      await batch.commit();
                    },
                    itemBuilder: (_, idx) {
                      final s = stages[idx];
                      final start = formatter.format(s.date);
                      final end = formatter.format(s.endDate);
                      final hasItems = s.items.isNotEmpty;
                      final title = hasItems ? s.items.last.title : 'Etappe ${idx + 1}';
                      final latLng = hasItems
                          ? LatLng(s.items.last.latitude, s.items.last.longitude)
                          : null;

                      return Card(
                        key: ValueKey(s.id),
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                          title: Text(title),
                          subtitle: Text('$start → $end'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ItineraryDayPage(trip: widget.trip, day: s),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteStage(s),
                              ),
                              const Icon(Icons.drag_handle),
                            ],
                          ),
                          onTap: () {
                            if (latLng != null && mapReady) {
                              _mapController.moveAndRotate(latLng, _zoom, 0);
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createStage,
        icon: const Icon(Icons.add),
        label: const Text('Neue Etappe'),
      ),
    );
  }
}

class _ZoomButtons extends StatelessWidget {
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  const _ZoomButtons({required this.onZoomIn, required this.onZoomOut});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 12,
      right: 12,
      child: Column(
        children: [
          FloatingActionButton(
            mini: true,
            heroTag: 'zIn',
            onPressed: onZoomIn,
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            mini: true,
            heroTag: 'zOut',
            onPressed: onZoomOut,
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}

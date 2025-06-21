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

  @override
  void initState() {
    super.initState();
    _stages$ = FirebaseFirestore.instance
        .collection('trips')
        .doc(widget.trip.id)
        .collection('itineraries')
        .orderBy('dayIndex')
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => ItineraryItem.fromJson(d.data()).copyWith(id: d.id))
            .toList());
  }

  Future<void> _createStage() async {
    await showDialog(
      context: context,
      builder: (ctx) => _StageDialog(
        tripStart: widget.trip.startDate!,
        tripEnd: widget.trip.endDate!,
        onSave: (s, e) async {
          final doc = FirebaseFirestore.instance
              .collection('trips')
              .doc(widget.trip.id)
              .collection('itineraries')
              .doc();
          await doc.set(
            ItineraryItem(
              id: doc.id,
              dayIndex: s.millisecondsSinceEpoch,
              date: s,
              endDate: e,
              items: [],
              lastModified: DateTime.now(),
            ).toJson(),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('dd.MM.yyyy');

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.trip.title),
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
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final stages = snap.data!;
          final points = stages
              .where((s) => s.items.isNotEmpty)
              .map((s) => s.items.first)
              .toList();
          final coords = points.map((p) => LatLng(p.latitude, p.longitude)).toList();
          LatLng center = const LatLng(48.8566, 2.3522);
          if (coords.isNotEmpty) {
            center = coords.first;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _mapController.move(center, _zoom);
            });
          }

          return Column(
            children: [
              SizedBox(
                height: 260,
                child: Stack(
                  children: [
                    FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(center: center, zoom: _zoom),
                      children: [
                        TileLayer(
                          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.travelbuddy.app',
                        ),
                        if (coords.length >= 2)
                          PolylineLayer(polylines: [
                            Polyline(points: coords, strokeWidth: 4, color: Colors.blue),
                          ]),
                        MarkerLayer(markers: [
                          for (final p in points)
                            Marker(
                              point: LatLng(p.latitude, p.longitude),
                              width: 40,
                              height: 40,
                              child: const Icon(Icons.location_pin, color: Colors.red),
                            ),
                        ]),
                      ],
                    ),
                    _ZoomButtons(
                      onZoomIn: () => setState(() {
                        _zoom++;
                        _mapController.move(_mapController.center, _zoom);
                      }),
                      onZoomOut: () => setState(() {
                        _zoom--;
                        _mapController.move(_mapController.center, _zoom);
                      }),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Reisezeitraum: ${formatter.format(widget.trip.startDate!)} - ${formatter.format(widget.trip.endDate!)}',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              Expanded(
                child: stages.isEmpty
                    ? const Center(child: Text('Noch keine Etappen angelegt.'))
                    : ListView.separated(
                        itemCount: stages.length,
                        separatorBuilder: (_, __) => const Divider(height: 0),
                        itemBuilder: (_, idx) {
                          final s = stages[idx];
                          final start = formatter.format(s.date);
                          final end = formatter.format(s.endDate);
                          return ListTile(
                            title: Text('Etappe ${idx + 1}'),
                            subtitle: Text('$start → $end'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ItineraryDayPage(trip: widget.trip, day: s),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createStage,
        child: const Icon(Icons.add),
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
            child: const Icon(Icons.add),
            onPressed: onZoomIn,
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            mini: true,
            heroTag: 'zOut',
            child: const Icon(Icons.remove),
            onPressed: onZoomOut,
          ),
        ],
      ),
    );
  }
}

class _StageDialog extends StatefulWidget {
  final DateTime tripStart;
  final DateTime tripEnd;
  final void Function(DateTime start, DateTime end) onSave;

  const _StageDialog({
    required this.tripStart,
    required this.tripEnd,
    required this.onSave,
  });

  @override
  State<_StageDialog> createState() => __StageDialogState();
}

class __StageDialogState extends State<_StageDialog> {
  late DateTime startDate;
  late DateTime endDate;

  @override
  void initState() {
    super.initState();
    startDate = widget.tripStart;
    endDate = widget.tripStart;
  }

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('dd.MM.yyyy');
    return AlertDialog(
      title: const Text('Neue Etappe'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text('Start: ${fmt.format(startDate)}'),
            trailing: const Icon(Icons.date_range),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                firstDate: widget.tripStart,
                lastDate: widget.tripEnd,
                initialDate: startDate,
              );
              if (picked != null) {
                setState(() {
                  startDate = picked;
                  if (endDate.isBefore(startDate)) {
                    endDate = picked;
                  }
                });
              }
            },
          ),
          ListTile(
            title: Text('Ende:  ${fmt.format(endDate)}'),
            trailing: const Icon(Icons.date_range),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                firstDate: startDate,
                lastDate: widget.tripEnd,
                initialDate: endDate,
              );
              if (picked != null) {
                setState(() {
                  endDate = picked;
                });
              }
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Abbrechen'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onSave(startDate, endDate);
            Navigator.pop(context);
          },
          child: const Text('Speichern'),
        ),
      ],
    );
  }
}

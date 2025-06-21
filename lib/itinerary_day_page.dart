import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

import 'DBModels/trip_model.dart';
import 'DBModels/itinerary_item.dart';

class ItineraryDayPage extends StatefulWidget {
  final TripModel trip;
  final ItineraryItem day;
  const ItineraryDayPage({super.key, required this.trip, required this.day});

  @override
  State<ItineraryDayPage> createState() => _ItineraryDayPageState();
}

class _ItineraryDayPageState extends State<ItineraryDayPage> {
  static const int maxPoints = 10;

  final notesController = TextEditingController();
  final locationController = TextEditingController();

  final MapController _mapController = MapController();
  double _zoom = 10;

  final List<LatLng> routePoints = [];
  List<ItineraryPoint> items = [];
  List<Map<String, dynamic>> suggestions = [];
  String? selectedLocationName;

  @override
void initState() {
  super.initState();
  items = List.from(widget.day.items);

  if (items.isNotEmpty) {
    final last = items.last;
    selectedLocationName = last.title;
    _zoom = 13;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mapController.move(LatLng(last.latitude, last.longitude), _zoom);
    });
  }

  _refreshRoute();
}
  Future<void> _search(String query) async {
    if (query.length < 3) return;
    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=6');
    final res = await http.get(url, headers: {'User-Agent': 'travelbuddy-app'});
    if (res.statusCode == 200) {
      setState(() => suggestions = List.castFrom(jsonDecode(res.body)));
    }
  }

  Future<void> _add(Map<String, dynamic> loc) async {
    if (items.length >= maxPoints) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Maximal $maxPoints Orte pro Etappe erlaubt.')),
      );
      return;
    }

    final lat = double.tryParse(loc['lat'] ?? '');
    final lon = double.tryParse(loc['lon'] ?? '');
    final name = loc['display_name'] ?? 'Ort';
    if (lat == null || lon == null) return;

    final point = ItineraryPoint(
      title: name,
      notes: notesController.text.trim(),
      latitude: lat,
      longitude: lon,
    );

    items.add(point);
    await FirebaseFirestore.instance
        .collection('trips')
        .doc(widget.trip.id)
        .collection('itineraries')
        .doc(widget.day.id)
        .update({
      'items': items.map((e) => e.toJson()).toList(),
      'lastModified': DateTime.now().toIso8601String(),
    });

    setState(() {
      selectedLocationName = name;
      _zoom = 13;
      _mapController.move(LatLng(lat, lon), _zoom);
      notesController.clear();
      locationController.clear();
      suggestions.clear();
    });

    _refreshRoute();
  }

  Future<void> _refreshRoute() async {
    if (items.length < 2) {
      setState(() => routePoints.clear());
      return;
    }

    final body = {
      'coordinates': items.map((e) => [e.longitude, e.latitude]).toList(),
      'geometry_format': 'geojson',
      'instructions': false,
    };

    final res = await http.post(
      Uri.parse('https://api.openrouteservice.org/v2/directions/driving-car'),
      headers: {
        'Authorization': '5b3ce3597851110001cf6248d830129fc8ca4773a5d42e3eb9020b62',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (res.statusCode == 200) {
      final coords = (jsonDecode(res.body)['features'][0]['geometry']['coordinates'] as List)
          .map((p) => LatLng(p[1], p[0]))
          .toList();
      setState(() {
        routePoints
          ..clear()
          ..addAll(coords);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final startCenter = items.isNotEmpty
        ? LatLng(items.last.latitude, items.last.longitude)
        : const LatLng(51.1657, 10.4515); // Mittelpunkt DE

    final markers = items
        .map((p) => Marker(
              width: 40,
              height: 40,
              point: LatLng(p.latitude, p.longitude),
              child: const Icon(Icons.location_pin, color: Colors.red),
            ))
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text('Etappe – ${widget.day.date.day}.${widget.day.date.month}')),
      body: Column(
        children: [
          SizedBox(
            height: 260,
            child: Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(center: startCenter, zoom: _zoom),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.travelbuddy.app',
                    ),
                    if (routePoints.length >= 2)
                      PolylineLayer(polylines: [
                        Polyline(points: routePoints, strokeWidth: 4, color: Colors.blue),
                      ]),
                    MarkerLayer(markers: markers),
                  ],
                ),
                _ZoomButtons(
                  onZoomIn: () {
                    setState(() {
                      _zoom++;
                      _mapController.move(_mapController.center, _zoom);
                    });
                  },
                  onZoomOut: () {
                    setState(() {
                      _zoom--;
                      _mapController.move(_mapController.center, _zoom);
                    });
                  },
                ),
              ],
            ),
          ),
          if (selectedLocationName != null)
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                '📍 Ausgewählt: $selectedLocationName',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  controller: notesController,
                  decoration: const InputDecoration(labelText: 'Notiz zum Ort'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: locationController,
                  decoration: const InputDecoration(labelText: 'Ort suchen'),
                  onChanged: _search,
                ),
                if (suggestions.isNotEmpty)
                  Card(
                    elevation: 3,
                    margin: const EdgeInsets.only(top: 8),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: suggestions.length,
                      separatorBuilder: (_, __) => const Divider(height: 0),
                      itemBuilder: (_, i) {
                        final s = suggestions[i];
                        return ListTile(
                          title: Text(s['display_name'] ?? ''),
                          onTap: () => _add(s),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
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
          FloatingActionButton(mini: true, heroTag: 'dZIn', child: const Icon(Icons.add), onPressed: onZoomIn),
          const SizedBox(height: 8),
          FloatingActionButton(mini: true, heroTag: 'dZOut', child: const Icon(Icons.remove), onPressed: onZoomOut),
        ],
      ),
    );
  }
}

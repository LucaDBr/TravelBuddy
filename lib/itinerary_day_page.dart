import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'DBModels/trip_model.dart';
import 'DBModels/itinerary_item.dart';

class ItineraryDayPage extends StatefulWidget {
  final TripModel trip;
  final ItineraryItem day;
  final bool createNew;

  const ItineraryDayPage({
    super.key,
    required this.trip,
    required this.day,
    this.createNew = false,
  });

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
  late DateTime startDate;
  late DateTime endDate;

  String? weatherMinMax;
  String? currentTemp;

  @override
  void initState() {
    super.initState();
    items = List.from(widget.day.items);
    startDate = widget.day.date;
    endDate = widget.day.endDate;

    if (items.isNotEmpty) {
      final last = items.last;
      selectedLocationName = last.title;
      notesController.text = last.notes ?? '';
      _zoom = 13;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mapController.move(LatLng(last.latitude, last.longitude), _zoom);
      });
      _fetchWeather(last.latitude, last.longitude);
    }

    _refreshRoute();
  }

  Future<void> _fetchWeather(double lat, double lon) async {
    final date = DateFormat('yyyy-MM-dd').format(startDate);
    final url = Uri.parse(
      'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&daily=temperature_2m_max,temperature_2m_min&current_weather=true&start_date=$date&end_date=$date&timezone=auto',
    );
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      if (data['daily'] != null && data['daily']['temperature_2m_max'] != null) {
        final max = data['daily']['temperature_2m_max'][0];
        final min = data['daily']['temperature_2m_min'][0];
        final current = data['current_weather']?['temperature'];

        setState(() {
          weatherMinMax = '🌤️ $min°C – $max°C';
          currentTemp = current != null ? 'Aktuell: $current°C' : null;
        });
      }
    }
  }

  Future<void> _search(String query) async {
    if (query.length < 3) return;
    final url = Uri.parse(
      'https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=6&addressdetails=1');
    final res = await http.get(url, headers: {'User-Agent': 'travelbuddy-app'});
    if (res.statusCode == 200) {
      setState(() => suggestions = List.castFrom(jsonDecode(res.body)));
    }
  }

  void _add(Map<String, dynamic> loc) {
    if (items.length >= maxPoints) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maximal $maxPoints Orte pro Etappe erlaubt.')),
      );
      return;
    }

    final lat = double.tryParse(loc['lat'] ?? '');
    final lon = double.tryParse(loc['lon'] ?? '');
    final address = loc['address'] as Map<String, dynamic>?;

    final name = address?['city'] ??
        address?['town'] ??
        address?['village'] ??
        address?['state'] ??
        loc['display_name'] ??
        'Ort';

    if (lat == null || lon == null) return;

    final point = ItineraryPoint(
      title: name,
      notes: notesController.text.trim(),
      latitude: lat,
      longitude: lon,
    );

    setState(() {
      items.add(point);
      selectedLocationName = name;
      _zoom = 13;
      _mapController.move(LatLng(lat, lon), _zoom);
      locationController.clear();
      suggestions.clear();
      weatherMinMax = null;
      currentTemp = null;
    });

    _refreshRoute();
    _fetchWeather(lat, lon);
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

  Future<void> _saveToFirestore() async {
    final docRef = FirebaseFirestore.instance
        .collection('trips')
        .doc(widget.trip.id)
        .collection('itineraries')
        .doc(widget.day.id);

    await docRef.set({
      'id': widget.day.id,
      'dayIndex': startDate.millisecondsSinceEpoch,
      'date': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'items': items.map((e) => e.toJson()).toList(),
      'lastModified': DateTime.now().toIso8601String(),
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Etappe wurde gespeichert.')),
      );
      Navigator.pop(context);
    }
  }

  Future<void> _pickDateRange() async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: widget.trip.startDate!,
      lastDate: widget.trip.endDate!,
      initialDateRange: DateTimeRange(start: startDate, end: endDate),
    );
    if (range != null) {
      setState(() {
        startDate = range.start;
        endDate = range.end;
      });
      if (items.isNotEmpty) {
        _fetchWeather(items.last.latitude, items.last.longitude);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('dd.MM.yyyy');
    final startCenter = items.isNotEmpty
        ? LatLng(items.last.latitude, items.last.longitude)
        : const LatLng(51.1657, 10.4515);

    final markers = items
        .map((p) => Marker(
              width: 40,
              height: 40,
              point: LatLng(p.latitude, p.longitude),
              child: const Icon(Icons.location_pin, color: Colors.red),
            ))
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text('Etappe – ${formatter.format(startDate)}')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: ElevatedButton.icon(
              onPressed: _pickDateRange,
              icon: const Icon(Icons.date_range),
              label: Text('Zeitraum wählen: ${formatter.format(startDate)} - ${formatter.format(endDate)}'),
            ),
          ),
          if (weatherMinMax != null || currentTemp != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Text('${currentTemp ?? ''}  ${weatherMinMax ?? ''}',
                  style: const TextStyle(fontSize: 16)),
            ),
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
              child: Text('📍 Ausgewählt: $selectedLocationName',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
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
                        final address = s['address'] as Map<String, dynamic>?;
                        final shortName = address?['city'] ??
                            address?['town'] ??
                            address?['village'] ??
                            address?['state'] ??
                            s['display_name'];
                        return ListTile(
                          title: Text(shortName ?? ''),
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: ElevatedButton.icon(
          onPressed: _saveToFirestore,
          icon: const Icon(Icons.save),
          label: const Text("Etappe speichern"),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontSize: 18),
          ),
        ),
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
            heroTag: 'dZIn',
            child: const Icon(Icons.add),
            onPressed: onZoomIn,
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            mini: true,
            heroTag: 'dZOut',
            child: const Icon(Icons.remove),
            onPressed: onZoomOut,
          ),
        ],
      ),
    );
  }
}

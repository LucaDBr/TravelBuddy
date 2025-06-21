import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'DBModels/trip_model.dart';
import 'reise_konfig_page.dart';

class ReiseDetailPage extends StatefulWidget {
  final TripModel trip;

  const ReiseDetailPage({super.key, required this.trip});

  @override
  State<ReiseDetailPage> createState() => _ReiseDetailPageState();
}

class _ReiseDetailPageState extends State<ReiseDetailPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController startController = TextEditingController();
  final TextEditingController endController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  bool loading = true;
  String statusMessage = '';
  double? latitude;
  double? longitude;

  @override
  void initState() {
    super.initState();
    _ladeBasisdaten();
  }

  Future<void> _ladeBasisdaten() async {
    final doc = await FirebaseFirestore.instance
        .collection('trips')
        .doc(widget.trip.id)
        .get();

    final data = doc.data();
    if (data != null) {
      startController.text = data['startDate'] ?? '';
      endController.text = data['endDate'] ?? '';
      destinationController.text = data['destination'] ?? '';
      descriptionController.text = data['description'] ?? '';

      if (data['destination'] != null && data['destination'].toString().isNotEmpty) {
        await _ladeKoordinaten(data['destination']);
      }
    }

    setState(() {
      loading = false;
    });
  }

  Future<void> _ladeKoordinaten(String ort) async {
    try {
      final placemarks = await locationFromAddress(ort);
      if (placemarks.isNotEmpty) {
        latitude = placemarks.first.latitude;
        longitude = placemarks.first.longitude;
      }
    } catch (e) {
      print('❌ Fehler beim Geocoding: $e');
    }
  }

  Future<void> _speichern() async {
    await FirebaseFirestore.instance
        .collection('trips')
        .doc(widget.trip.id)
        .update({
      'startDate': startController.text.trim(),
      'endDate': endController.text.trim(),
      'destination': destinationController.text.trim(),
      'description': descriptionController.text.trim(),
    });

    setState(() {
      statusMessage = '✅ Änderungen gespeichert';
    });

    await _ladeKoordinaten(destinationController.text.trim());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.trip.title)),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      if (statusMessage.isNotEmpty)
                        Text(
                          statusMessage,
                          style: TextStyle(
                            color: statusMessage.startsWith('✅') ? Colors.green : Colors.red,
                          ),
                        ),
                      const SizedBox(height: 16),

                      if (latitude != null && longitude != null)
                        SizedBox(
                          height: 250,
                          child: FlutterMap(
                            options: MapOptions(
                              center: LatLng(latitude!, longitude!),
                              zoom: 5,
                            ),
                            children: [
                              TileLayer(
                                urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                                subdomains: ['a', 'b', 'c'],
                                userAgentPackageName: 'com.example.travelbuddy_flutter',
                              ),
                              MarkerLayer(
                                markers: [
                                  Marker(
                                    point: LatLng(latitude!, longitude!),
                                    width: 40,
                                    height: 40,
                                    child: const Icon(
                                      Icons.location_on,
                                      color: Colors.red,
                                      size: 36,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      else
                        const Text("🌐 Kein Reiseziel gesetzt oder nicht gefunden."),

                      const SizedBox(height: 16),

                      TextFormField(
                        controller: destinationController,
                        decoration: const InputDecoration(labelText: 'Reiseziel'),
                      ),
                      TextFormField(
                        controller: startController,
                        decoration: const InputDecoration(labelText: 'Startdatum'),
                      ),
                      TextFormField(
                        controller: endController,
                        decoration: const InputDecoration(labelText: 'Enddatum'),
                      ),
                      TextFormField(
                        controller: descriptionController,
                        decoration: const InputDecoration(labelText: 'Beschreibung'),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 20),

                      ElevatedButton(
                        onPressed: _speichern,
                        child: const Text('Änderungen speichern'),
                      ),
                      const SizedBox(height: 10),

                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ReiseKonfigPage(trip: widget.trip),
                            ),
                          );
                        },
                        icon: const Icon(Icons.settings),
                        label: const Text('Reise konfigurieren'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

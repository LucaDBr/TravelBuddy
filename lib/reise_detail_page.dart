import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
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
  bool editMode = false;
  String statusMessage = '';
  String flagCode = 'xx';

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
      startController.text = _formatDate(data['startDate']);
      endController.text = _formatDate(data['endDate']);
      destinationController.text = data['destination'] ?? '';
      descriptionController.text = data['description'] ?? '';
    }

    final resolvedFlag = await _resolveCountryCode(destinationController.text);
    setState(() {
      flagCode = resolvedFlag;
      loading = false;
    });
  }

  Future<String> _resolveCountryCode(String destination) async {
    try {
      final locations = await locationFromAddress(destination);
      if (locations.isEmpty) return 'xx';
      final placemarks = await placemarkFromCoordinates(
        locations.first.latitude,
        locations.first.longitude,
      );
      return placemarks.first.isoCountryCode?.toLowerCase() ?? 'xx';
    } catch (_) {
      return 'xx';
    }
  }

  Future<void> _speichern() async {
    await FirebaseFirestore.instance.collection('trips').doc(widget.trip.id).update({
      'startDate': startController.text.trim(),
      'endDate': endController.text.trim(),
      'destination': destinationController.text.trim(),
      'description': descriptionController.text.trim(),
    });

    final newFlag = await _resolveCountryCode(destinationController.text);

    setState(() {
      flagCode = newFlag;
      statusMessage = '✅ Änderungen gespeichert';
      editMode = false;
    });
  }

  String _formatDate(dynamic raw) {
    if (raw == null) return '';
    try {
      if (raw is String) return DateFormat('dd.MM.yyyy').format(DateTime.parse(raw));
      if (raw is Timestamp) return DateFormat('dd.MM.yyyy').format(raw.toDate());
    } catch (_) {}
    return raw.toString();
  }

  Widget _buildField(String label, TextEditingController ctrl, {int maxLines = 1}) {
    if (editMode) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TextFormField(
          controller: ctrl,
          maxLines: maxLines,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: Text(ctrl.text.isEmpty ? '–' : ctrl.text),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          if (flagCode != 'xx')
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Image.network(
                'https://flagcdn.com/w40/$flagCode.png',
                width: 36,
                height: 24,
                errorBuilder: (_, __, ___) => const SizedBox(),
              ),
            ),
          Expanded(child: Text(widget.trip.title)),
          IconButton(
            icon: Icon(editMode ? Icons.close : Icons.edit),
            onPressed: () => setState(() => editMode = !editMode),
          )
        ]),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  if (statusMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(statusMessage,
                          style: TextStyle(
                              color: statusMessage.startsWith('✅') ? Colors.green : Colors.red)),
                    ),
                  _buildField('Reiseziel', destinationController),
                  _buildField('Startdatum', startController),
                  _buildField('Enddatum', endController),
                  _buildField('Beschreibung', descriptionController, maxLines: 3),

                  if (editMode)
                    Column(
                      children: [
                        const SizedBox(height: 12),
                        ElevatedButton(onPressed: _speichern, child: const Text('Speichern')),
                      ],
                    )
                  else ...[
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.settings),
                      label: const Text('Reise konfigurieren'),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ReiseKonfigPage(trip: widget.trip)),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text('Reiseverlauf', style: textTheme.titleMedium),
                    const SizedBox(height: 8),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('trips')
                          .doc(widget.trip.id)
                          .collection('itineraries')
                          .orderBy('dayIndex')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return const CircularProgressIndicator();
                        final docs = snapshot.data!.docs;
                        if (docs.isEmpty) return const Text("Kein Reiseverlauf vorhanden.");

                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: docs.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final data = docs[index].data() as Map<String, dynamic>;
                            final startDate = _formatDate(data['date']);
                            final endDate = _formatDate(data['endDate']);
                            final items = List<Map<String, dynamic>>.from(data['items'] ?? []);
                            final mainLocation = items.isNotEmpty
                                ? items.first['title'] ?? 'Unbekannt'
                                : 'Unbekannt';

                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(children: [
                                  Container(
                                      width: 12,
                                      height: 12,
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle, color: Colors.blue)),
                                  if (index != docs.length - 1)
                                    Container(width: 2, height: 50, color: Colors.blue.shade200),
                                ]),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Etappe ${index + 1}: $startDate – $endDate',
                                          style: textTheme.bodyMedium
                                              ?.copyWith(fontWeight: FontWeight.w600)),
                                      Text('• $mainLocation', style: textTheme.bodySmall),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    )
                  ],
                ]),
              ),
            ),
    );
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;

class KIReiseService {
  static const _baseUrl = 'http://10.0.2.2:3000/generate-trip';

  static Future<List<Map<String, dynamic>>> generiereReiseAdvanced({
    required String land,
    required DateTime start,
    required DateTime end,
    required String wuensche,
    required String interessen,
    required String transport,
    required String unterkunft,
    required String stil,
    required String budget,
  }) async {
    final res = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'land': land,
        'zeitraum': '${start.toIso8601String().split("T")[0]} bis ${end.toIso8601String().split("T")[0]}',
        'wuensche': wuensche,
        'interessen': interessen,
        'transportmittel': transport,
        'unterkuenfte': unterkunft,
        'reisestil': stil,
        'budget': budget,
      }),
    );

    if (res.statusCode != 200) {
      throw Exception('KI-Service antwortete mit Fehler: ${res.statusCode}');
    }

    final raw = jsonDecode(res.body)['result'] as String;

    // Bereinige mögliche Formatierungen
    var clean = raw
        .replaceAll('```json', '')
        .replaceAll('```', '')
        .trim();

    final startIdx = clean.indexOf('[');
    if (startIdx > 0) clean = clean.substring(startIdx);

    try {
      final decoded = jsonDecode(clean);
      if (decoded is List) {
        return List<Map<String, dynamic>>.from(decoded);
      } else {
        throw Exception('Erwartetes JSON-Array nicht gefunden.');
      }
    } catch (e) {
      throw Exception('Fehler beim Parsen der KI-Antwort: $e');
    }
  }
}

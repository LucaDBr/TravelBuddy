import 'dart:convert';
import 'package:http/http.dart' as http;

class KIService {
  static const String _baseUrl = 'http://10.0.2.2:3000'; // Emulator-URL

  /// KI-Tripvorschlag
  static Future<List<Map<String, dynamic>>> generateTrip({
    required String land,
    required String zeitraum,
    required String wuensche,
    required List<String> interessen,
    required List<String> transportmittel,
    required List<String> unterkuenfte,
    required String reisestil,
    required String budget,
  }) async {
    final res = await http.post(
      Uri.parse('$_baseUrl/generate-trip'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'land': land,
        'zeitraum': zeitraum,
        'wuensche': wuensche,
        'interessen': interessen,
        'transportmittel': transportmittel,
        'unterkuenfte': unterkuenfte,
        'reisestil': reisestil,
        'budget': budget,
      }),
    );

    if (res.statusCode != 200) {
      throw Exception('Fehler bei generate-trip: ${res.body}');
    }

    final raw = jsonDecode(res.body)['result'] as String;
    final cleaned = raw.replaceAll('```json', '').replaceAll('```', '').trim();
    final start = cleaned.indexOf('[');
    final jsonPart = start >= 0 ? cleaned.substring(start) : cleaned;

    final decoded = jsonDecode(jsonPart);
    if (decoded is List) {
      return List<Map<String, dynamic>>.from(decoded);
    } else {
      throw Exception('❌ Kein gültiges JSON-Array erhalten');
    }
  }

  /// KI-Packliste
  static Future<List<Map<String, dynamic>>> generatePackliste({
    required String land,
    required String zeitraum,
    required List<String> transportmittel,
    required List<String> unterkuenfte,
    required String reisestil,
    required String wuensche,
  }) async {
    final res = await http.post(
      Uri.parse('$_baseUrl/generate-packliste'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'land': land,
        'zeitraum': zeitraum,
        'transportmittel': transportmittel,
        'unterkuenfte': unterkuenfte,
        'reisestil': reisestil,
        'wuensche': wuensche,
      }),
    );

    if (res.statusCode != 200) {
      throw Exception('Fehler bei generate-packliste: ${res.body}');
    }

    final raw = jsonDecode(res.body)['result'] as String;
    final cleaned = raw.replaceAll('```json', '').replaceAll('```', '').trim();
    final start = cleaned.indexOf('[');
    final jsonPart = start >= 0 ? cleaned.substring(start) : cleaned;

    final decoded = jsonDecode(jsonPart);
    if (decoded is List) {
      return List<Map<String, dynamic>>.from(decoded);
    } else {
      throw Exception('❌ Kein gültiges JSON-Array erhalten');
    }
  }
}

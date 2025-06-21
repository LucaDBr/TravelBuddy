// services/weather_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/weather.dart';

class WeatherService {
  Future<DayWeather?> fetchWeather({
    required double lat,
    required double lon,
    required DateTime date,
  }) async {
    final isoDate = "${date.toIso8601String().split('T').first}";
    final url = Uri.parse(
      'https://archive-api.open-meteo.com/v1/era5?latitude=$lat&longitude=$lon&start_date=$isoDate&end_date=$isoDate&daily=temperature_2m_max,temperature_2m_min&timezone=auto'
    );
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final data = json.decode(res.body)['daily'];
      if (data['time'].isNotEmpty) {
        return DayWeather(
          date: DateTime.parse(data['time'][0]),
          tempMax: data['temperature_2m_max'][0],
          tempMin: data['temperature_2m_min'][0],
        );
      }
    }
    return null;
  }
}

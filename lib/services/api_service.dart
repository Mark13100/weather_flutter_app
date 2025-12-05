import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class ApiService {
  static const String _base = 'https://api.openweathermap.org/data/2.5/weather';
  static const String _apiKey = '643cbf4102b8cecba3c1f2e2c5fbe213';

  Future<Weather> fetchWeatherByCity(String city, {String units = 'metric', String lang = 'en'}) async {
    if (_apiKey.isEmpty || _apiKey == 'YOUR_API_KEY') {
      throw Exception('API key not set. Put your OpenWeather API key in api_service.dart or use env.');
    }

    final uri = Uri.parse('$_base?q=${Uri.encodeComponent(city)}&appid=$_apiKey&units=$units&lang=$lang');

    try {
      final resp = await http.get(uri).timeout(const Duration(seconds: 15));
      if (resp.statusCode == 200) {
        final body = json.decode(resp.body) as Map<String, dynamic>;
        return Weather.fromJson(body);
      } else if (resp.statusCode == 401) {
        throw Exception('Unauthorized: check API key (401).');
      } else if (resp.statusCode == 404) {
        throw Exception('City not found (404).');
      } else {
        throw Exception('API error: ${resp.statusCode}');
      }
    } on http.ClientException catch (e) {
      throw Exception('Network error: ${e.message}');
    } on Exception {
      rethrow;
    }
  }

  static String iconUrl(String icon) => 'http://openweathermap.org/img/wn/$icon@2x.png';
}

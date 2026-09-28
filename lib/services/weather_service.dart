import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/weather_model.dart';

class WeatherException implements Exception {
  final String message;
  WeatherException(this.message);

  @override
  String toString() => message;
}

class WeatherService {
  // Key code me mat likho. Run karte waqt --dart-define se do.
  static const String _apiKey = String.fromEnvironment('WEATHER_API_KEY');
  static const String _baseUrl = 'https://api.weatherapi.com/v1';

  Future<WeatherModel> getCurrentWeather(double lat, double lon) async {
    if (_apiKey.isEmpty) {
      throw WeatherException('API key missing');
    }

    final uri = Uri.parse('$_baseUrl/current.json').replace(
      queryParameters: {
        'key': _apiKey,
        'q': '$lat,$lon',
        'aqi': 'no',
      },
    );

    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 10));
      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return WeatherModel.fromJson(body);
      }

      final code = body['error']?['code'];
      if (code == 1006) {
        throw WeatherException('Location not found');
      } else if (code == 2007) {
        throw WeatherException('Service busy, try later');
      } else {
        throw WeatherException('Something went wrong, try later');
      }
    } on SocketException {
      throw WeatherException('No internet connection');
    } on TimeoutException {
      throw WeatherException('Request timed out, retry');
    } on FormatException {
      throw WeatherException('Invalid response from server');
    }
  }
}

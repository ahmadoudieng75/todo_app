import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class WeatherData {
  final double temperature;
  final String description;
  final String cityName;
  final int humidity;
  final int pressure;
  final double windSpeed;
  final int windDeg;

  WeatherData({
    required this.temperature,
    required this.description,
    required this.cityName,
    required this.humidity,
    required this.pressure,
    required this.windSpeed,
    required this.windDeg,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      temperature: (json['main']['temp'] as num).toDouble(),
      description: (json['weather'][0]['description'] as String),
      cityName: (json['name'] as String),
      humidity: (json['main']['humidity'] as num).toInt(),
      pressure: (json['main']['pressure'] as num).toInt(),
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      windDeg: (json['wind']['deg'] as num).toInt(),
    );
  }
}

class WeatherService {
  static final WeatherService _instance = WeatherService._internal();
  factory WeatherService() => _instance;
  WeatherService._internal();

  static const String _apiKey = 'b5a4be4ddbf569b21c04c1f37c33a610';
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  bool useMock = false;

  // Récupérer météo par coordonnées
  Future<WeatherData> getWeather(double latitude, double longitude) async {
    if (useMock) {
      await Future.delayed(const Duration(seconds: 1));
      return WeatherData(
        temperature: 22.5,
        description: 'Ensoleillé',
        cityName: 'Dakar',
        humidity: 65,
        pressure: 1015,
        windSpeed: 3.5,
        windDeg: 120,
      );
    }

    final url = Uri.parse(
        '$_baseUrl?lat=$latitude&lon=$longitude&units=metric&lang=fr&appid=$_apiKey');
    return _fetchWeather(url);
  }

  // Récupérer météo par ville
  Future<WeatherData> getWeatherByCity(String city) async {
    if (useMock) {
      await Future.delayed(const Duration(seconds: 1));
      return WeatherData(
        temperature: 28.0,
        description: 'Ensoleillé',
        cityName: city,
        humidity: 60,
        pressure: 1012,
        windSpeed: 2.5,
        windDeg: 90,
      );
    }

    // Encodage pour gérer espaces et accents
    final encodedCity = Uri.encodeComponent(city.trim());

    final url =
    Uri.parse('$_baseUrl?q=$encodedCity&units=metric&lang=fr&appid=$_apiKey');
    return _fetchWeather(url);
  }

  Future<WeatherData> _fetchWeather(Uri url) async {
    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));
      if (response.statusCode != 200) {
        throw HttpException('Erreur API: ${response.statusCode}');
      }
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return WeatherData.fromJson(data);
    } on TimeoutException {
      throw Exception('La récupération des données météo a pris trop de temps');
    } on SocketException {
      throw Exception('Pas de connexion Internet');
    } on HttpException catch (e) {
      throw Exception('Erreur serveur: $e');
    } on FormatException {
      throw Exception('Réponse invalide du serveur');
    } catch (e) {
      throw Exception('Erreur inconnue: $e');
    }
  }
}

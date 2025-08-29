import 'package:flutter/material.dart';

class WeatherWidget extends StatelessWidget {
  final String temperature;
  final String description;
  final String cityName;
  final int humidity;
  final int pressure;
  final double windSpeed;
  final int windDirection;

  const WeatherWidget({
    super.key,
    required this.temperature,
    required this.description,
    required this.cityName,
    required this.humidity,
    required this.pressure,
    required this.windSpeed,
    required this.windDirection,
  });

  String _getWindDirection(int deg) {
    if (deg >= 337 || deg < 23) return "N";
    if (deg >= 23 && deg < 68) return "NE";
    if (deg >= 68 && deg < 113) return "E";
    if (deg >= 113 && deg < 158) return "SE";
    if (deg >= 158 && deg < 203) return "S";
    if (deg >= 203 && deg < 248) return "SO";
    if (deg >= 248 && deg < 293) return "O";
    if (deg >= 293 && deg < 337) return "NO";
    return "N/A";
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ville
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(cityName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Icon(Icons.location_city, color: Colors.blueGrey),
              ],
            ),
            const SizedBox(height: 12),

            // Température + Description
            Row(
              children: [
                Icon(Icons.thermostat, color: Colors.red),
                const SizedBox(width: 8),
                Text(
                  "$temperature°C",
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 12),
                Text(description, style: TextStyle(fontSize: 16, color: Colors.grey[700])),
              ],
            ),
            const Divider(),

            // Détails météo
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(children: [
                  Icon(Icons.water_drop, color: Colors.blue),
                  Text("Humidité"),
                  Text("$humidity %"),
                ]),
                Column(children: [
                  Icon(Icons.speed, color: Colors.green),
                  Text("Pression"),
                  Text("$pressure hPa"),
                ]),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(children: [
                  Icon(Icons.air, color: Colors.lightBlue),
                  Text("Vent"),
                  Text("${windSpeed.toStringAsFixed(1)} m/s"),
                ]),
                Column(children: [
                  Icon(Icons.explore, color: Colors.orange),
                  Text("Direction"),
                  Text(_getWindDirection(windDirection)),
                ]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

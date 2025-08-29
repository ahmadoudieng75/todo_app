import 'dart:async'; // ✅ nécessaire pour TimeoutException
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  /// Vérifie et demande les permissions + active localisation si désactivée
  Future<Position> getCurrentLocation() async {
    try {
      // ✅ Vérifie si la localisation est activée
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Ouvre directement les paramètres Android de localisation
        await Geolocator.openLocationSettings();
        throw Exception('Veuillez activer la localisation pour obtenir la météo');
      }

      // ✅ Vérifie les permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Permissions de localisation refusées');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Ouvre la page des paramètres de l’application
        await Geolocator.openAppSettings();
        throw Exception('Permissions de localisation refusées définitivement.\nActivez-les dans les paramètres.');
      }

      // ✅ Récupère la position
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      ).timeout(const Duration(seconds: 10));

    } on TimeoutException {
      throw Exception("La récupération de la localisation a pris trop de temps");
    }
  }

  /// Récupérer l'adresse depuis les coordonnées
  Future<String> getLocationAddress(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude)
          .timeout(const Duration(seconds: 10));

      if (placemarks.isNotEmpty) {
        final placemark = placemarks[0];
        return '${placemark.locality ?? 'Ville inconnue'}, ${placemark.country ?? 'Pays inconnu'}';
      }
      return 'Position: $latitude, $longitude';
    } on TimeoutException {
      return 'Récupération de l’adresse trop longue';
    } catch (e) {
      return 'Position: $latitude, $longitude';
    }
  }
}

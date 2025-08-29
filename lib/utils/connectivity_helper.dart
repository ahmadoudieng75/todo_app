import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityHelper {
  static final ConnectivityHelper _instance = ConnectivityHelper._internal();
  factory ConnectivityHelper() => _instance;
  ConnectivityHelper._internal();

  final Connectivity _connectivity = Connectivity();

  Future<bool> isConnected() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  // Stream corrigé pour ne pas avoir de conflit de type
  Stream<ConnectivityResult> get connectivityStream {
    return _connectivity.onConnectivityChanged.map((event) {
      // Si event est une liste (anciennes versions), on prend le premier
      if (event is List<ConnectivityResult>) {
        return event.first;
      }
      return event as ConnectivityResult;
    });
  }
}

import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:todo_app/utils/connectivity_helper.dart';

class ConnectionStatus extends StatefulWidget {
  const ConnectionStatus({super.key});

  @override
  _ConnectionStatusState createState() => _ConnectionStatusState();
}

class _ConnectionStatusState extends State<ConnectionStatus> {
  final ConnectivityHelper _connectivityHelper = ConnectivityHelper();
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    _connectivityHelper.connectivityStream.listen(_updateConnectionStatus);
  }

  Future<void> _checkConnectivity() async {
    final isConnected = await _connectivityHelper.isConnected();
    setState(() {
      _isConnected = isConnected;
    });
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    setState(() {
      _isConnected = result != ConnectivityResult.none;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _isConnected ? Colors.green : Colors.red,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _isConnected ? Icons.wifi : Icons.wifi_off,
            color: Colors.white,
            size: 16,
          ),
          SizedBox(width: 4),
          Text(
            _isConnected ? 'En ligne' : 'Hors ligne',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
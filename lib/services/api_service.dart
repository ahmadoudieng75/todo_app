import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:todo_app/utils/constants.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }
}
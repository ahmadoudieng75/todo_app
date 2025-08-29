import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/models/user.dart';
import 'package:todo_app/services/api_service.dart';
import 'dart:convert'; // pour jsonEncode et jsonDecode


class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final ApiService _apiService = ApiService();
  final String _userKey = 'current_user';
  final String _tokenKey = 'auth_token';

  Future<bool> register(String email, String password) async {
    try {
      final response = await _apiService.post('login', {
        'email': email,
        'password': password,
      });

      if (response['success'] == true) {
        await _saveUser(User(accountId: response['account_id'], email: email));
        return true;
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      final response = await _apiService.post('login.php', {
        'email': email,
        'password': password,
      });

      if (response['success'] == true) {
        await _saveUser(User(accountId: response['account_id'], email: email));
        return true;
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.remove(_tokenKey);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_userKey);
  }

  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      return User.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  Future<void> _saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  Future<void> updateProfileImage(String imagePath) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      final user = User.fromJson(jsonDecode(userJson));
      final updatedUser = User(
        accountId: user.accountId,
        email: user.email,
        profileImagePath: imagePath,
      );
      await prefs.setString(_userKey, jsonEncode(updatedUser.toJson()));
    }
  }
}
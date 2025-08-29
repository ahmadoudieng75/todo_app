import 'package:flutter/material.dart';
import 'package:todo_app/models/user.dart';
import 'package:todo_app/screens/auth/login_screen.dart';
import 'package:todo_app/screens/todo_list_screen.dart';
import 'package:todo_app/screens/completed_todos_screen.dart';
import 'package:todo_app/screens/add_edit_todo_screen.dart';
import 'package:todo_app/services/auth_service.dart';
import 'package:todo_app/services/weather_service.dart';
import 'package:todo_app/widgets/profile_avatar.dart';
import 'package:todo_app/widgets/weather_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  final WeatherService _weatherService = WeatherService();

  User? _currentUser;
  WeatherData? _weather;
  int _currentIndex = 0;
  final TextEditingController _cityController =
  TextEditingController(text: "Dakar");

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _getWeatherByCity("Dakar"); // ville par défaut
  }

  Future<void> _loadUserData() async {
    final user = await _authService.getCurrentUser();
    setState(() {
      _currentUser = user;
    });
  }

  Future<void> _getWeatherByCity(String city) async {
    try {
      final weather = await _weatherService.getWeatherByCity(city);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print('Erreur météo pour $city: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Impossible de récupérer la météo pour "$city"')),
      );
    }
  }

  Future<void> _logout() async {
    await _authService.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Déconnexion',
          ),
        ],
      ),
      body: Column(
        children: [
          // Zone profil + recherche + météo
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.blue[50],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ligne profil + recherche
                Row(
                  children: [
                    ProfileAvatar(
                      imagePath: _currentUser?.profileImagePath,
                      onImageSelected: (imagePath) {
                        if (_currentUser != null) {
                          _authService.updateProfileImage(imagePath);
                          setState(() {
                            _currentUser = User(
                              accountId: _currentUser!.accountId,
                              email: _currentUser!.email,
                              profileImagePath: imagePath,
                            );
                          });
                        }
                      },
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: _cityController,
                        decoration: InputDecoration(
                          hintText: "Rechercher une ville",
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () {
                              if (_cityController.text.trim().isNotEmpty) {
                                _getWeatherByCity(_cityController.text.trim());
                              }
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _weather != null
                    ? WeatherWidget(
                  cityName: _weather!.cityName,
                  temperature: _weather!.temperature.toStringAsFixed(1),
                  description: _weather!.description,
                  humidity: _weather!.humidity,
                  pressure: _weather!.pressure,
                  windSpeed: _weather!.windSpeed,
                  windDirection: _weather!.windDeg,
                )
                    : const Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
          // Liste des écrans
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: [
                TodoListScreen(user: _currentUser),
                CompletedTodosScreen(user: _currentUser),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Tâches'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Historique'),
        ],
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    AddEditTodoScreen(user: _currentUser)),
          );
        },
        child: const Icon(Icons.add),
      )
          : null,
    );
  }
}

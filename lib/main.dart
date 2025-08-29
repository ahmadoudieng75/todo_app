import 'package:flutter/material.dart';
import 'package:todo_app/screens/auth/login_screen.dart';
import 'package:todo_app/services/auth_service.dart';
import 'package:todo_app/utils/constants.dart';
import 'package:todo_app/screens/home_screen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthService authService = AuthService();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FutureBuilder(
        future: authService.isLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return snapshot.data == true ? HomeScreen() : LoginScreen();
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
      routes: {
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}
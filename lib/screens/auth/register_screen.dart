import 'package:flutter/material.dart';
import 'package:todo_app/services/auth_service.dart';
import 'package:todo_app/utils/constants.dart';
import 'package:todo_app/screens/auth/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  String _errorMessage = '';

  void _register() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        setState(() {
          _errorMessage = 'Les mots de passe ne correspondent pas';
        });
        return;
      }

      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      try {
        final success = await _authService.register(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );

        if (success) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Inscription réussie! Veuillez vous connecter.')),
          );
        } else {
          setState(() {
            _errorMessage = 'Erreur lors de l\'inscription';
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'Erreur: $e';
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Constants.registerTitle),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: Constants.emailHint,
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre email';
                  }
                  if (!value.contains('@')) {
                    return 'Email invalide';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: Constants.passwordHint,
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre mot de passe';
                  }
                  if (value.length < 6) {
                    return 'Le mot de passe doit contenir au moins 6 caractères';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: Constants.confirmPasswordHint,
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez confirmer votre mot de passe';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              SizedBox(height: 16),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _register,
                child: Text(Constants.registerButton),
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: _navigateToLogin,
                child: Text(Constants.hasAccount),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
class Constants {
  static const String baseUrl = 'http://192.168.1.120/todo_app';

  // Clés de stockage local
  static const String userKey = 'current_user';
  static const String tokenKey = 'auth_token';

  // Messages d'erreur
  static const String networkError = 'Erreur de connexion. Vérifiez votre connexion internet.';
  static const String serverError = 'Erreur du serveur. Veuillez réessayer plus tard.';
  static const String unknownError = 'Une erreur inconnue s\'est produite.';

  // Textes de l'application
  static const String appName = 'Todo App';
  static const String loginTitle = 'Connexion';
  static const String registerTitle = 'Inscription';
  static const String emailHint = 'Email';
  static const String passwordHint = 'Mot de passe';
  static const String confirmPasswordHint = 'Confirmer le mot de passe';
  static const String loginButton = 'Se connecter';
  static const String registerButton = 'S\'inscrire';
  static const String noAccount = 'Pas de compte? Inscrivez-vous';
  static const String hasAccount = 'Déjà un compte? Connectez-vous';
}
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/services/api_service.dart';
import 'package:todo_app/utils/database_helper.dart';
import 'package:todo_app/utils/connectivity_helper.dart';

class TodoService {
  static final TodoService _instance = TodoService._internal();
  factory TodoService() => _instance;
  TodoService._internal();

  final ApiService _apiService = ApiService();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final ConnectivityHelper _connectivityHelper = ConnectivityHelper();

  Future<List<Todo>> getTodos(int accountId) async {
    final isConnected = await _connectivityHelper.isConnected();

    if (isConnected) {
      try {
        final response = await _apiService.post('todos', {
          'account_id': accountId,
        });

        if (response['success'] == true) {
          final List<dynamic> todosJson = response['todos'];
          final List<Todo> todos = todosJson.map((json) => Todo.fromJson(json)).toList();

          // Synchroniser avec la base locale
          await _dbHelper.syncTodos(accountId, todos);

          return todos;
        }
      } catch (e) {
        // En cas d'erreur, utiliser les données locales
        print('Error fetching todos from API: $e');
      }
    }

    // Retourner les données locales si pas de connexion ou erreur
    return await _dbHelper.getTodos(accountId);
  }

  Future<bool> addTodo(Todo todo) async {
    final isConnected = await _connectivityHelper.isConnected();

    // Toujours sauvegarder localement
    final localId = await _dbHelper.insertTodo(todo);

    if (isConnected) {
      try {
        final response = await _apiService.post('inserttodo', todo.toJson());
        if (response['success'] == true) {
          // Mettre à jour l'ID local avec l'ID du serveur
          await _dbHelper.updateTodoId(localId, response['todo_id']);
          return true;
        }
      } catch (e) {
        print('Error adding todo to API: $e');
        // La tâche reste en attente de synchronisation
      }
    }

    return true;
  }

  Future<bool> updateTodo(Todo todo) async {
    final isConnected = await _connectivityHelper.isConnected();

    // Toujours mettre à jour localement
    await _dbHelper.updateTodo(todo);

    if (isConnected && todo.todoId != null && todo.todoId! > 0) {
      try {
        final response = await _apiService.post('updatedo', todo.toJson());
        return response['success'] == true;
      } catch (e) {
        print('Error updating todo in API: $e');
        // La modification reste en attente de synchronisation
      }
    }

    return true;
  }

  Future<bool> deleteTodo(int todoId) async {
    final isConnected = await _connectivityHelper.isConnected();

    // Toujours supprimer localement
    await _dbHelper.deleteTodo(todoId);

    if (isConnected) {
      try {
        final response = await _apiService.post('deletedo', {
          'todo_id': todoId,
        });
        return response['success'] == true;
      } catch (e) {
        print('Error deleting todo from API: $e');
        // La suppression sera synchronisée plus tard
      }
    }

    return true;
  }

  Future<List<Todo>> getCompletedTodos(int accountId) async {
    return await _dbHelper.getCompletedTodos(accountId);
  }

  Future<void> syncPendingOperations(int accountId) async {
    final isConnected = await _connectivityHelper.isConnected();
    if (!isConnected) return;

    // Synchroniser les tâches locales avec le serveur
    final pendingTodos = await _dbHelper.getPendingSyncTodos(accountId);

    for (final todo in pendingTodos) {
      if (todo.todoId == null || todo.todoId! <= 0) {
        // Nouvelle tâche à synchroniser
        await addTodo(todo);
      } else {
        // Mise à jour à synchroniser
        await updateTodo(todo);
      }
    }

    // Synchroniser les suppressions
    final pendingDeletions = await _dbHelper.getPendingDeletions();
    for (final todoId in pendingDeletions) {
      await deleteTodo(todoId);
    }
  }
}
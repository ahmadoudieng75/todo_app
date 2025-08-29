import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo_app/models/todo.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'todo_app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE todos(
        local_id INTEGER PRIMARY KEY AUTOINCREMENT,
        todo_id INTEGER,
        account_id INTEGER NOT NULL,
        date TEXT NOT NULL,
        todo TEXT NOT NULL,
        done INTEGER NOT NULL,
        synced INTEGER DEFAULT 0,
        pending_delete INTEGER DEFAULT 0
      )
    ''');
  }

  Future<int> insertTodo(Todo todo) async {
    final db = await database;
    return await db.insert('todos', {
      'todo_id': todo.todoId,
      'account_id': todo.accountId,
      'date': todo.date.toIso8601String().split('T')[0],
      'todo': todo.todo,
      'done': todo.done ? 1 : 0,
      'synced': 0,
    });
  }

  Future<List<Todo>> getTodos(int accountId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'todos',
      where: 'account_id = ? AND pending_delete = 0',
      whereArgs: [accountId],
    );

    return List.generate(maps.length, (i) {
      return Todo(
        todoId: maps[i]['todo_id'],
        accountId: maps[i]['account_id'],
        date: DateTime.parse(maps[i]['date']),
        todo: maps[i]['todo'],
        done: maps[i]['done'] == 1,
      );
    });
  }

  Future<List<Todo>> getCompletedTodos(int accountId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'todos',
      where: 'account_id = ? AND done = 1 AND pending_delete = 0',
      whereArgs: [accountId],
    );

    return List.generate(maps.length, (i) {
      return Todo(
        todoId: maps[i]['todo_id'],
        accountId: maps[i]['account_id'],
        date: DateTime.parse(maps[i]['date']),
        todo: maps[i]['todo'],
        done: true,
      );
    });
  }

  Future<List<Todo>> getPendingSyncTodos(int accountId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'todos',
      where: 'account_id = ? AND synced = 0 AND pending_delete = 0',
      whereArgs: [accountId],
    );

    return List.generate(maps.length, (i) {
      return Todo(
        todoId: maps[i]['todo_id'],
        accountId: maps[i]['account_id'],
        date: DateTime.parse(maps[i]['date']),
        todo: maps[i]['todo'],
        done: maps[i]['done'] == 1,
      );
    });
  }

  Future<List<int>> getPendingDeletions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'todos',
      where: 'pending_delete = 1 AND todo_id IS NOT NULL',
    );

    return maps.map((map) => map['todo_id'] as int).toList();
  }

  Future<void> updateTodo(Todo todo) async {
    final db = await database;
    await db.update(
      'todos',
      {
        'date': todo.date.toIso8601String().split('T')[0],
        'todo': todo.todo,
        'done': todo.done ? 1 : 0,
        'synced': 0,
      },
      where: 'todo_id = ? OR local_id = ?',
      whereArgs: [todo.todoId, todo.todoId],
    );
  }

  Future<void> updateTodoId(int localId, int serverId) async {
    final db = await database;
    await db.update(
      'todos',
      {
        'todo_id': serverId,
        'synced': 1,
      },
      where: 'local_id = ?',
      whereArgs: [localId],
    );
  }

  Future<void> deleteTodo(int todoId) async {
    final db = await database;
    await db.update(
      'todos',
      {
        'pending_delete': 1,
        'synced': 0,
      },
      where: 'todo_id = ?',
      whereArgs: [todoId],
    );
  }

  Future<void> syncTodos(int accountId, List<Todo> serverTodos) async {
    final db = await database;

    // Supprimer les anciennes tâches synchronisées
    await db.delete(
      'todos',
      where: 'account_id = ? AND synced = 1',
      whereArgs: [accountId],
    );

    // Insérer les nouvelles tâches du serveur
    for (final todo in serverTodos) {
      await db.insert('todos', {
        'todo_id': todo.todoId,
        'account_id': todo.accountId,
        'date': todo.date.toIso8601String().split('T')[0],
        'todo': todo.todo,
        'done': todo.done ? 1 : 0,
        'synced': 1,
      });
    }
  }
}
import 'package:flutter/material.dart';
import 'package:todo_app/models/user.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/services/todo_service.dart';
import 'package:todo_app/widgets/todo_item.dart';
import 'package:intl/intl.dart';

class CompletedTodosScreen extends StatefulWidget {
  final User? user;

  const CompletedTodosScreen({super.key, this.user});

  @override
  _CompletedTodosScreenState createState() => _CompletedTodosScreenState();
}

class _CompletedTodosScreenState extends State<CompletedTodosScreen> {
  final TodoService _todoService = TodoService();

  List<Todo> _completedTodos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCompletedTodos();
  }

  Future<void> _loadCompletedTodos() async {
    if (widget.user == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final todos = await _todoService.getCompletedTodos(widget.user!.accountId);
      setState(() {
        _completedTodos = todos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors du chargement de l\'historique: $e')),
      );
    }
  }

  String _formatGroupHeader(DateTime date) {
    return DateFormat('MMMM yyyy').format(date);
  }

  Map<String, List<Todo>> _groupTodosByMonth() {
    final Map<String, List<Todo>> groupedTodos = {};

    for (final todo in _completedTodos) {
      final header = _formatGroupHeader(todo.date);
      if (!groupedTodos.containsKey(header)) {
        groupedTodos[header] = [];
      }
      groupedTodos[header]!.add(todo);
    }

    return groupedTodos;
  }

  @override
  Widget build(BuildContext context) {
    final groupedTodos = _groupTodosByMonth();
    final headers = groupedTodos.keys.toList()..sort((a, b) => b.compareTo(a));

    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : _completedTodos.isEmpty
        ? Center(
      child: Text(
        'Aucune tâche accomplie',
        style: TextStyle(fontSize: 16),
      ),
    )
        : RefreshIndicator(
      onRefresh: _loadCompletedTodos,
      child: ListView.builder(
        itemCount: headers.length,
        itemBuilder: (context, index) {
          final header = headers[index];
          final todos = groupedTodos[header]!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  header,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ...todos.map((todo) => TodoItem(
                todo: todo,
                onToggle: (t) {}, // Désactivé pour l'historique
                onEdit: (t) {},   // Désactivé pour l'historique
                onDelete: (id) {}, // Désactivé pour l'historique
              )),
            ],
          );
        },
      ),
    );
  }
}
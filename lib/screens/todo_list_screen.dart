import 'package:flutter/material.dart';
import 'package:todo_app/models/user.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/services/todo_service.dart';
import 'package:todo_app/widgets/todo_item.dart';
import 'package:todo_app/widgets/connection_status.dart';
import 'package:todo_app/screens/add_edit_todo_screen.dart';

class TodoListScreen extends StatefulWidget {
  final User? user;

  const TodoListScreen({super.key, this.user});

  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final TodoService _todoService = TodoService();
  final TextEditingController _searchController = TextEditingController();

  List<Todo> _todos = [];
  List<Todo> _filteredTodos = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    if (widget.user == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final todos = await _todoService.getTodos(widget.user!.accountId);
      setState(() {
        _todos = todos;
        _filteredTodos = _filterTodos(todos, _searchQuery);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors du chargement des tâches: $e')),
      );
    }
  }

  List<Todo> _filterTodos(List<Todo> todos, String query) {
    if (query.isEmpty) return todos;
    return todos.where((todo) =>
        todo.todo.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _filteredTodos = _filterTodos(_todos, query);
    });
  }

  Future<void> _toggleTodo(Todo todo) async {
    try {
      await _todoService.updateTodo(todo.copyWith(done: !todo.done));
      await _loadTodos(); // Recharger la liste
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la modification: $e')),
      );
    }
  }

  void _editTodo(Todo todo) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditTodoScreen(
          user: widget.user,
          todo: todo,
        ),
      ),
    ).then((_) => _loadTodos());
  }

  Future<void> _deleteTodo(int todoId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmer la suppression'),
        content: Text('Êtes-vous sûr de vouloir supprimer cette tâche?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _todoService.deleteTodo(todoId);
        await _loadTodos(); // Recharger la liste
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la suppression: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(8),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Rechercher une tâche',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: _onSearchChanged,
          ),
        ),
        ConnectionStatus(),
        Expanded(
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : _filteredTodos.isEmpty
              ? Center(
            child: Text(
              _searchQuery.isEmpty
                  ? 'Aucune tâche à afficher'
                  : 'Aucune tâche trouvée',
              style: TextStyle(fontSize: 16),
            ),
          )
              : RefreshIndicator(
            onRefresh: _loadTodos,
            child: ListView.builder(
              itemCount: _filteredTodos.length,
              itemBuilder: (context, index) {
                final todo = _filteredTodos[index];
                return TodoItem(
                  todo: todo,
                  onToggle: _toggleTodo,
                  onEdit: _editTodo,
                  onDelete: _deleteTodo,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
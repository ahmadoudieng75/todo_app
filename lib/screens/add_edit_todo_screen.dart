import 'package:flutter/material.dart';
import 'package:todo_app/models/user.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/services/todo_service.dart';

class AddEditTodoScreen extends StatefulWidget {
  final User? user;
  final Todo? todo;

  const AddEditTodoScreen({super.key, this.user, this.todo});

  @override
  _AddEditTodoScreenState createState() => _AddEditTodoScreenState();
}

class _AddEditTodoScreenState extends State<AddEditTodoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _todoController = TextEditingController();
  final _dateController = TextEditingController();
  final TodoService _todoService = TodoService();

  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    if (widget.todo != null) {
      _todoController.text = widget.todo!.todo;
      _selectedDate = widget.todo!.date;
      _dateController.text = _formatDate(widget.todo!.date);
    } else {
      _dateController.text = _formatDate(DateTime.now());
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = _formatDate(picked);
      });
    }
  }

  Future<void> _saveTodo() async {
    if (_formKey.currentState!.validate() && widget.user != null) {
      setState(() {
        _isLoading = true;
      });

      try {
        final todo = Todo(
          todoId: widget.todo?.todoId,
          accountId: widget.user!.accountId,
          date: _selectedDate,
          todo: _todoController.text.trim(),
          done: widget.todo?.done ?? false,
        );

        if (widget.todo == null) {
          await _todoService.addTodo(todo);
        } else {
          await _todoService.updateTodo(todo);
        }

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la sauvegarde: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.todo == null ? 'Nouvelle tâche' : 'Modifier la tâche'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _todoController,
                decoration: InputDecoration(
                  labelText: 'Tâche',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une tâche';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: 'Date',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () => _selectDate(context),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez sélectionner une date';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _saveTodo,
                child: Text('Enregistrer'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _todoController.dispose();
    _dateController.dispose();
    super.dispose();
  }
}
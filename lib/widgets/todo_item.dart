import 'package:flutter/material.dart';
import 'package:todo_app/models/todo.dart';
import 'package:intl/intl.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;
  final Function(Todo) onToggle;
  final Function(Todo) onEdit;
  final Function(int) onDelete;

  const TodoItem({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        leading: Checkbox(
          value: todo.done,
          onChanged: (value) => onToggle(todo.copyWith(done: value)),
        ),
        title: Text(
          todo.todo,
          style: TextStyle(
            decoration: todo.done ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(
          DateFormat('dd/MM/yyyy').format(todo.date),
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.blue),
              onPressed: () => onEdit(todo),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => onDelete(todo.todoId!),
            ),
          ],
        ),
      ),
    );
  }
}
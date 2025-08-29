class Todo {
  final int? todoId;
  final int accountId;
  final DateTime date;
  final String todo;
  final bool done;

  Todo({
    this.todoId,
    required this.accountId,
    required this.date,
    required this.todo,
    required this.done,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      todoId: json['todo_id'],
      accountId: json['account_id'],
      date: DateTime.parse(json['date']),
      todo: json['todo'],
      done: json['done'] == 1 || json['done'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'todo_id': todoId,
      'account_id': accountId,
      'date': date.toIso8601String().split('T')[0],
      'todo': todo,
      'done': done,
    };
  }

  Todo copyWith({
    int? todoId,
    int? accountId,
    DateTime? date,
    String? todo,
    bool? done,
  }) {
    return Todo(
      todoId: todoId ?? this.todoId,
      accountId: accountId ?? this.accountId,
      date: date ?? this.date,
      todo: todo ?? this.todo,
      done: done ?? this.done,
    );
  }
}
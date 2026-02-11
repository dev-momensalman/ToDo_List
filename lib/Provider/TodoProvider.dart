import 'package:flutter/material.dart';
import '../Model/TodoModel.dart'; // تأكد من صحة المسار حسب مشروعك

class TodoProvider extends ChangeNotifier {
  final List<Todo> _todos = [];

  List<Todo> get todos => _todos;

  void addTodo(String task) {
    if (task.isNotEmpty) {
      _todos.add(Todo(title: task));
      notifyListeners();
    }
  }

  void deleteTodo(int index) {
    _todos.removeAt(index);
    notifyListeners();
  }

  void toggleTodo(int index) {
    _todos[index].isDone = !_todos[index].isDone;
    notifyListeners();
  }
}
import 'package:cool_note/model/todo.dart';
import 'package:cool_note/repository/repository_service_todo.dart';
import 'package:flutter/material.dart';

class TodoProvider with ChangeNotifier {
  List<Todo> _todos = [];
  bool isEditing = false;
  String? name;
  int? id;

  List<Todo> get todos => _todos;

  // Fetch all todos when the provider is created (app start)
  Future<void> fetchTodos() async {
    _todos = await RepositoryServiceTodo.getAllTodos();
    notifyListeners();
  }

  Future<void> addTodo() async {
    if (name != null) {
      int count = await RepositoryServiceTodo.todosCount();
      final todo = Todo(count, name!, false);
      await RepositoryServiceTodo.addTodo(todo);
      _todos.add(todo);
      notifyListeners();
    }
  }

  Future<void> updateTodo() async {
    if (isEditing && id != null && name != null) {
      final todo = Todo(id!, name!, false);
      await RepositoryServiceTodo.updateTodo(todo);
      _todos = _todos.map((t) => t.id == id ? todo : t).toList();
      notifyListeners();
    }
  }

  Future<void> deleteTodo(int todoId) async {
    await RepositoryServiceTodo.deleteTodo(Todo(todoId, '', false));
    _todos.removeWhere((todo) => todo.id == todoId);
    notifyListeners();
  }

  void startEditing(Todo todo) {
    isEditing = true;
    name = todo.name;
    id = todo.id;
    notifyListeners();
  }

  void cancelEditing() {
    isEditing = false;
    name = null;
    id = null;
    notifyListeners();
  }

  void setName(String newName) {
    name = newName;
    notifyListeners();
  }
}

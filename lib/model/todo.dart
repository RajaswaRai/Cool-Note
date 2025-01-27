import 'package:cool_note/repository/database_creator.dart';

class Todo {
  int? id;
  String? name;
  bool? isDeleted;

  Todo(this.id, this.name, this.isDeleted);

  Todo.fromJson(Map<String, dynamic> json) {
    id = json[DatabaseCreator.id];
    name = json[DatabaseCreator.name];
    isDeleted = json[DatabaseCreator.isDeleted] == 1;
  }
}

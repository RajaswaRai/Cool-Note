import 'package:cool_note/provider/todo_provider.dart';
import 'package:flutter/material.dart';
import 'package:cool_note/model/todo.dart';
import 'package:provider/provider.dart';

class CoolNote extends StatefulWidget {
  const CoolNote({super.key, required this.title});

  final String title;

  @override
  _CoolNoteState createState() => _CoolNoteState();
}

class _CoolNoteState extends State<CoolNote> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode(); // Initialize the focus node here
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose(); // Dispose of the focus node when done
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cool Note'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Reset to "add" mode when clicking the "Add" button
              context
                  .read<TodoProvider>()
                  .cancelEditing(); // Ensure it's in "add" mode
              _controller.clear(); // Clear the controller to start fresh

              // Show modal when app bar button is clicked
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) {
                  // Explicitly request focus to show keyboard when opening the modal for adding a new task
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    FocusScope.of(context)
                        .requestFocus(_focusNode); // Request focus for keyboard
                  });

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Form(
                            key: _formKey,
                            child: TextFormField(
                              controller: _controller,
                              focusNode:
                                  _focusNode, // Attach focus node to text field
                              cursorColor: Colors.red.shade700,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Add your task here',
                                fillColor: Colors.grey[300],
                                focusColor: Colors.red,
                                filled: true,
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                context.read<TodoProvider>().setName(value);
                              },
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.black,
                            ),
                            child: TextButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  if (!context.read<TodoProvider>().isEditing) {
                                    await context
                                        .read<TodoProvider>()
                                        .addTodo();
                                  } else {
                                    await context
                                        .read<TodoProvider>()
                                        .updateTodo();
                                    context
                                        .read<TodoProvider>()
                                        .cancelEditing();
                                  }

                                  _controller.clear();
                                  Navigator.pop(context);
                                  FocusScope.of(context).requestFocus(
                                      _focusNode); // Auto-focus after modal closes
                                }
                              },
                              child: Text(
                                context.read<TodoProvider>().isEditing
                                    ? 'Update'
                                    : 'Create',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Consumer<TodoProvider>(
        builder: (context, todoProvider, _) {
          return ListView(
            padding: EdgeInsets.all(8),
            children: <Widget>[
              if (todoProvider.todos.isEmpty)
                Center(child: Text("No tasks available")),
              ...todoProvider.todos
                  .map((todo) => buildItem(context, todo))
                  .toList(),
            ],
          );
        },
      ),
    );
  }

  Widget buildItem(BuildContext context, Todo todo) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.all(8.0),
            title: Text(
              todo.name!,
              style: TextStyle(fontSize: 18),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(color: Colors.black),
                  child: TextButton(
                    onPressed: () {
                      context.read<TodoProvider>().startEditing(todo);

                      // Show modal with pre-filled data when editing
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) {
                          _controller.text = todo.name!;
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            FocusScope.of(context).requestFocus(
                                _focusNode); // Focus on text field when editing
                          });
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.5,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Form(
                                    key: _formKey,
                                    child: TextFormField(
                                      controller: _controller,
                                      focusNode:
                                          _focusNode, // Attach focus node to text field
                                      cursorColor: Colors.red.shade700,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Edit your task here',
                                        fillColor: Colors.grey[300],
                                        focusColor: Colors.red,
                                        filled: true,
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter some text';
                                        }
                                        return null;
                                      },
                                      onChanged: (value) {
                                        context
                                            .read<TodoProvider>()
                                            .setName(value);
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                    ),
                                    child: TextButton(
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          await context
                                              .read<TodoProvider>()
                                              .updateTodo();
                                          context
                                              .read<TodoProvider>()
                                              .cancelEditing();
                                          _controller.clear();
                                          Navigator.pop(context);
                                          FocusScope.of(context).requestFocus(
                                              _focusNode); // Auto-focus after update
                                        }
                                      },
                                      child: Text(
                                        'Update',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(color: Colors.red.shade700),
                  child: TextButton(
                    onPressed: () {
                      // Show confirmation dialog before deleting the todo
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Confirm Delete'),
                            content: Text(
                                'Are you sure you want to delete this task?'),
                            actions: <Widget>[
                              TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors
                                      .red, // Set red color for "Delete" button
                                ),
                                child: Text('Cancel'),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors
                                      .red, // Set red color for "Delete" button
                                ),
                                child: Text('Delete'),
                                onPressed: () {
                                  context
                                      .read<TodoProvider>()
                                      .deleteTodo(todo.id!);
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                  FocusScope.of(context).requestFocus(
                                      _focusNode); // Auto-focus after delete
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 8),
      ],
    );
  }
}

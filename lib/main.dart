import 'package:cool_note/provider/todo_provider.dart';
import 'package:cool_note/screens/intro_page.dart';
import 'package:flutter/material.dart';
import 'package:cool_note/repository/database_creator.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseCreator().initDatabase(); // Initialize the database
  runApp(MyApp());
}

// Main App widget
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TodoProvider()..fetchTodos(), // Fetch todos on app startup
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.light(),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            centerTitle: true,
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.black,
          ),
          checkboxTheme: CheckboxThemeData(
            fillColor: WidgetStateProperty.resolveWith<Color>(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.disabled)) {
                  return Colors.black.withOpacity(.32);
                }
                return Colors.black;
              },
            ),
          ),
        ),
        home: IntroPage(),
      ),
    );
  }
}

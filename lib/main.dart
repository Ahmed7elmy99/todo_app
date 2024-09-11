import 'package:flutter/material.dart';
import 'package:todo_app/screens/todo_screen.dart';
import 'package:todo_app/services/task_manager.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final taskManager = TaskManager();
  await taskManager.init();

  runApp(MyApp(taskManager: taskManager));
}
class MyApp extends StatelessWidget {
  final TaskManager taskManager;

  const MyApp({Key? key, required this.taskManager}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.teal),
      home: TodoScreen(taskManager: taskManager),
    );
  }
}

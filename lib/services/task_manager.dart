import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class TaskManager {
  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<List<Task>> loadTasks() async {
    final tasksString = _prefs?.getString('tasks') ?? '[]';
    final List<dynamic> tasksJson = jsonDecode(tasksString);
    return tasksJson.map((task) => Task.fromJson(task)).toList();
  }

  Future<void> saveTasks(List<Task> tasks) async {
    final tasksString = jsonEncode(tasks.map((task) => task.toJson()).toList());
    await _prefs?.setString('tasks', tasksString);
  }
}

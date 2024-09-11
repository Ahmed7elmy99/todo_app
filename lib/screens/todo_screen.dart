import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_manager.dart';

class TodoScreen extends StatefulWidget {
  final TaskManager taskManager;

  const TodoScreen({Key? key, required this.taskManager}) : super(key: key);

  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  List<Task> tasks = [];
  String selectedFilter = "All";
  String selectedCategory = "Work";
  final TextEditingController taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    tasks = await widget.taskManager.loadTasks();
    setState(() {});
  }

  Future<void> _saveTasks() async {
    await widget.taskManager.saveTasks(tasks);
  }

  void _addTask(String title, String category) {
    setState(() {
      tasks.add(Task(title: title, category: category));
    });
    _saveTasks();
  }

  void _toggleComplete(Task task) {
    setState(() {
      task.isCompleted = !task.isCompleted;
    });
    _saveTasks();
  }

  void _deleteTask(Task task) {
    setState(() {
      tasks.remove(task);
    });
    _saveTasks();
  }

  List<Task> get filteredTasks {
    if (selectedFilter == 'Completed') {
      return tasks.where((task) => task.isCompleted).toList();
    } else if (selectedFilter == 'Incomplete') {
      return tasks.where((task) => !task.isCompleted).toList();
    } else {
      return tasks;
    }
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String category = selectedCategory;
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text("Add New Task"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: taskController,
                    autofocus: true,
                    decoration: const InputDecoration(hintText: 'Task Title'),
                  ),
                  const SizedBox(height: 10),
                  DropdownButton<String>(
                    value: category,
                    items: ['Work', 'Personal'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setStateDialog(() {
                        category = value!;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: const Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  child: const Text("Add Task"),
                  onPressed: () {
                    if (taskController.text.isNotEmpty) {
                      _addTask(taskController.text, category);
                      taskController.clear();
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do App'),
        backgroundColor: Colors.teal,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: selectedFilter,
              dropdownColor: Colors.teal[200],
              items: ['All', 'Completed', 'Incomplete'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedFilter = value!;
                });
              },
              icon: const Icon(Icons.filter_list, color: Colors.white),
              underline: const SizedBox(),
            ),
          ),
        ],
      ),
      body: filteredTasks.isEmpty
          ? const Center(
              child: Text(
                'No tasks available',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = filteredTasks[index];
                      return Dismissible(
                        key: Key(task.title),
                        background: Container(
                          color: Colors.redAccent,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Text(
                            'Task Deleted',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                        onDismissed: (direction) {
                          _deleteTask(task);
                        },
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Card(
                            key: ValueKey(task.isCompleted),
                            color: task.isCompleted
                                ? Colors.greenAccent[100]
                                : Colors.orangeAccent[100],
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            child: ListTile(
                              title: Text(
                                task.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  decoration: task.isCompleted
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                              subtitle: Text('Category: ${task.category}'),
                              trailing: Checkbox(
                                value: task.isCompleted,
                                onChanged: (value) {
                                  _toggleComplete(task);
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add),
      ),
    );
  }
}

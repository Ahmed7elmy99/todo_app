class Task {
  String title;
  bool isCompleted;
  String category;

  Task({
    required this.title,
    this.isCompleted = false,
    required this.category,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'isCompleted': isCompleted,
        'category': category,
      };

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        title: json['title'],
        isCompleted: json['isCompleted'],
        category: json['category'],
      );
}

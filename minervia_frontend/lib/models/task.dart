class Task {
  final int id;
  final String title;
  final String? description;
  final bool isCompleted;
  final DateTime? dueDate;
  final int owner;

  Task(
      {required this.id,
      required this.title,
      this.description,
      required this.isCompleted,
      this.dueDate,
      required this.owner});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String?,
      isCompleted: json['is_completed'] as bool,
      dueDate: json['due_date'] == null
          ? null
          : DateTime.parse(json['due_date'] as String),
      owner: json['owner'] as int,
    );
  }
}

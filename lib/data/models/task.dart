class Task {
  final int? id;
  final String title;
  final String? content;
  final TaskPriority priority;
  final String color;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime dueDate;
  final int? userId;

  Task({
    this.id,
    required this.title,
    required this.content,
    required this.priority,
    required this.color,
    this.createdAt,
    this.updatedAt,
    required this.dueDate,
    this.userId,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      priority: TaskPriority.values.firstWhere(
      (e) => e.name == json['priority'],
      orElse: () => TaskPriority.low,
    ),
      color: json['color'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      dueDate: DateTime.parse(json['dueDate']),
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'priority': priority.name,
      'color': color,
      'dueDate': dueDate.toIso8601String(),
    };
  }

  Map<String, dynamic> toCreateJson() => {
    'title': title,
    'content': content,
    'priority': priority.name,
    'color': color,
    'dueDate': dueDate.toIso8601String(),
  };

  Map<String, dynamic> toUpdateJson() => {
    'id': id,
    'title': title,
    'content': content,
    'priority': priority.name,
    'color': color,
    'dueDate': dueDate.toIso8601String(),
  };

  Task copyWith({
    String? title,
    String? content,
    TaskPriority? priority,
    String? color,
    DateTime? dueDate,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
      priority: priority ?? this.priority,
      color: color ?? this.color,
      createdAt: createdAt,
      updatedAt: updatedAt,
      dueDate: dueDate ?? this.dueDate,
      userId: userId,
    );
  }
}

enum TaskPriority { low, medium, high }
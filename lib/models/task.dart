class Task {
  String? id;
  String title;
  String? description;
  DateTime? date;
  String userId;
  bool isCompleted;
  String? location;
  int? priority;

  Task({
    this.id,
    required this.userId,
    required this.title,
    this.description,
    this.date,
    this.isCompleted = false,
    this.location,
    this.priority,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'userId': userId,
      'description': description,
      'date': date?.toIso8601String(),
      'isCompleted': isCompleted ? 1 : 0,
      'location': location,
      'priority': priority,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      userId: map['userId'],
      title: map['title'],
      description: map['description'],
      date: map['date'] != null ? DateTime.parse(map['date']) : null,
      isCompleted: map['isCompleted'] == 1,
      location: map['location'],
      priority: map['priority'],
    );
  }
}

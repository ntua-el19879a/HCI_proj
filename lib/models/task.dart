class Task {
  int? id;
  String title;
  String? description;
  DateTime? dueDate;
  bool isCompleted;
  String? location; // Store location as a string or lat/long
  int? priority; // Optional: for task prioritization

  Task({
    this.id,
    required this.title,
    this.description,
    this.dueDate,
    this.isCompleted = false,
    this.location,
    this.priority,
  });

  // Convert a Task object into a Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate?.toIso8601String(),
      'isCompleted': isCompleted ? 1 : 0,
      'location': location,
      'priority': priority,
    };
  }

  // Create a Task object from a database Map
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate']) : null,
      isCompleted: map['isCompleted'] == 1,
      location: map['location'],
      priority: map['priority'],
    );
  }
}
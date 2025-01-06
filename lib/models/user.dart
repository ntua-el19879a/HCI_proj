class User {
  String? id;
  String uid;
  String name; // Optional: You can make the user provide a name
  int currentStreak;
  int longestStreak;
  int points;
  String password;
  String email;
  int completedTasks;
  // You might want to add a history of completed tasks
  // List<DateTime> completedTaskDates;

  User({
    this.id,
    required this.name,
    required this.uid,
    required this.email,
    required this.password,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.points = 0,
    this.completedTasks = 0,
    // this.completedTaskDates = const [],
  });

  // Convert a User object into a Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'uid': uid,
      'password': password,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'points': points,
      'completedTasks': completedTasks,
      // 'completedTaskDates': completedTaskDates.map((date) => date.toIso8601String()).toList(),
    };
  }

  // Create a User object from a database Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      uid: map['uid'],
      name: map['name'],
      password: map['password'],
      email: map['email'],
      currentStreak: map['currentStreak'],
      longestStreak: map['longestStreak'],
      points: map['points'],
      completedTasks: map['completedTasks'],
      // completedTaskDates: (map['completedTaskDates'] as List<dynamic>)
      //     .map((dateString) => DateTime.parse(dateString))
      //     .toList(),
    );
  }

  // Method to increment the streak
  void incrementStreak() {
    currentStreak++;
    if (currentStreak > longestStreak) {
      longestStreak = currentStreak;
    }
  }

  // Method to reset the streak
  void resetStreak() {
    currentStreak = 0;
  }

  // Method to add points
  void addPoints(int amount) {
    points += amount;
  }

  // Method to deduct points
  void deductPoints(int amount) {
    points -= amount;
    if (points < 0) {
      points = 0; // Prevent negative points if needed
    }
  }

  // Method to increment completed tasks count
  void incrementCompletedTasks() {
    completedTasks++;
  }
}

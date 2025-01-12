import 'package:prioritize_it/utils/theme_name.dart';

class User {
  String? id;
  String uid;
  String name;
  int currentStreak;
  int longestStreak;
  int points;
  String password;
  String email;
  int completedTasks;
  List<ThemeName> unlockedThemes; // Changed from ThemeName[] to List<ThemeName>

  User(
      {this.id,
      required this.name,
      required this.uid,
      required this.email,
      required this.password,
      this.currentStreak = 0,
      this.longestStreak = 0,
      this.points = 0,
      this.completedTasks = 0,
      this.unlockedThemes = defualtUnlockedThemes});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'uid': uid,
      'password': password,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'points': points,
      'completedTasks': completedTasks,
      'unlockedThemes':
          unlockedThemes.map((theme) => themeNameStringMap[theme]).toList(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    User u = User(
        id: map['id'],
        uid: map['uid'],
        name: map['name'],
        password: map['password'],
        email: map['email'],
        currentStreak: map['currentStreak'] ?? 0,
        longestStreak: map['longestStreak'] ?? 0,
        points: map['points'] ?? 0,
        completedTasks: map['completedTasks'] ?? 0,
        unlockedThemes: (map['unlockedThemes'] as List<dynamic>?)
                ?.map((themeNameStr) =>
                    stringToThemeNameMap[themeNameStr as String] ??
                    ThemeName.blue)
                .toList() ??
            []);
    return u;
  }

  void incrementStreak() {
    currentStreak++;
    if (currentStreak > longestStreak) {
      longestStreak = currentStreak;
    }
  }

  void resetStreak() {
    currentStreak = 0;
  }

  void addPoints(int amount) {
    points += amount;
  }

  void deductPoints(int amount) {
    points -= amount;
    if (points < 0) {
      points = 0;
    }
  }

  void incrementCompletedTasks() {
    completedTasks++;
  }

  void decrementCompletedTasks() {
    if (completedTasks > 0) {
      completedTasks--;
    }
  }

  void unlockTheme(ThemeName theme) {
    if (!unlockedThemes.contains(theme)) {
      unlockedThemes.add(theme);
    }
  }

  bool isThemeUnlocked(ThemeName theme) {
    return unlockedThemes.contains(theme);
  }
}

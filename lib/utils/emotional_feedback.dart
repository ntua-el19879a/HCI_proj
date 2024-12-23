import 'package:prioritize_it/models/user.dart';

class EmotionalFeedback {
  static String getFeedbackMessage(User user) {
    if (user.completedTasks < 5) {
      return "Let's get started! Completing tasks will boost your score.";
    } else if (user.completedTasks >= 5 && user.completedTasks < 15) {
      return "You're doing great! Keep up the good work.";
    } else {
      return "Wow, you're a task master! Keep crushing it!";
    }
  }
}
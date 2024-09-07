import 'package:flutter/foundation.dart';
import '../models/task_model.dart';
import '../services/task_services.dart'; // Import your TaskModel

class TaskAppProvider extends ChangeNotifier {
  // Lists to hold completed and incomplete tasks
  List<TaskModel> completedTasks = [];
  List<TaskModel> incompleteTasks = [];

  bool isDarkMode = false;

  void setDarkMode(bool val) {
    isDarkMode = val;
    notifyListeners();
  }

  TaskAppProvider() {
    updateCompletedTasks();
    updateIncompleteTasks();
  }

  // Update completed tasks
  Future<void> updateCompletedTasks() async {
    try {
      completedTasks = await TaskService.fetchCompletedTasks();
    } catch (e) {
      // If an error occurs, set the list to an empty array
      completedTasks = [];
      if (kDebugMode) {
        print('Failed to fetch completed tasks: $e');
      }
    }
    notifyListeners(); // Notify listeners to update the UI
  }

  // Update incomplete tasks
  Future<void> updateIncompleteTasks() async {
    try {
      incompleteTasks = await TaskService.fetchIncompleteTasks();
    } catch (e) {
      // If an error occurs, set the list to an empty array
      incompleteTasks = [];
      if (kDebugMode) {
        print('Failed to fetch incomplete tasks: $e');
      }
    }
    notifyListeners(); // Notify listeners to update the UI
  }
}

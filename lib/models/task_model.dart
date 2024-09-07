import 'package:intl/intl.dart';

class TaskModel {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final bool isCompleted;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.isCompleted,
  });

  // Convert TaskModel to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': DateFormat('yyyy-MM-dd HH:mm:ss').format(dueDate), // Save date and time
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  // Create a TaskModel from a Map
  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      dueDate: DateFormat('yyyy-MM-dd HH:mm:ss').parse(map['dueDate']), // Parse date and time
      isCompleted: map['isCompleted'] == 1,
    );
  }
}

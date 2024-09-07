import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../models/task_model.dart';
import '../utils/database_conn.dart'; // Import your task model

class TaskService {
  static final DatabaseHelper _databaseHelper = DatabaseHelper();

  // Fetch all completed tasks
  static Future<List<TaskModel>> fetchCompletedTasks() async {
    final Database db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      where: 'isCompleted = ?',
      whereArgs: [1], // 1 represents completed tasks
    );

    return List.generate(maps.length, (i) {
      return TaskModel.fromMap(maps[i]);
    });
  }

  // Fetch all incomplete tasks
  static Future<List<TaskModel>> fetchIncompleteTasks() async {
    final Database db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      where: 'isCompleted = ?',
      whereArgs: [0], // 0 represents incomplete tasks
    );

    print(maps);

    return List.generate(maps.length, (i) {
      return TaskModel.fromMap(maps[i]);
    });
  }

  // Add a new task
  static Future<void> addTask(TaskModel task) async {
    final Database db = await _databaseHelper.database;
    await db.insert(
      'tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Update an existing task
  static Future<void> updateTask(TaskModel task) async {
    final Database db = await _databaseHelper.database;
    await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  // Remove a task
  static Future<void> removeTask(String id) async {
    final Database db = await _databaseHelper.database;
    await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete all tasks
  static Future<void> deleteAllTasks() async {
    final Database db = await _databaseHelper.database;
    await db.delete('tasks'); // No WHERE clause to delete all rows
  }
}

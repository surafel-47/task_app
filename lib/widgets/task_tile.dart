import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:task_app/services/task_services.dart';

import '../models/task_model.dart';
import '../screens/add_edit_screen.dart';
import '../state_managment/task_app_provider.dart';

class TaskTile extends StatelessWidget {
  final TaskModel task;

  const TaskTile({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    final taskAppProvider = Provider.of<TaskAppProvider>(context, listen: false);

    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    final DateFormat timeFormat = DateFormat('HH:mm');
    final String formattedDate = dateFormat.format(task.dueDate);
    final String formattedTime = timeFormat.format(task.dueDate);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 220, 225, 239), width: 1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            title: Text(
              task.title,
              overflow: TextOverflow.clip,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 23,
                decoration: task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
              ),
            ),
            trailing: task.isCompleted
                ? IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      //Remove task here!
                      TaskService.removeTask(task.id);
                      taskAppProvider.updateCompletedTasks();
                    },
                  )
                : IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
                        ),
                        builder: (context) {
                          return FractionallySizedBox(
                            heightFactor: 0.85,
                            child: TaskFormScreen(task: task),
                          );
                        },
                      );
                    },
                  ),
          ),
          Container(
            width: double.infinity, // Ensures the container takes up full width
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
            child: Text(
              task.description,
              style: const TextStyle(fontSize: 13), // Style for the description
              textAlign: TextAlign.start, // Aligns the text to the start
            ),
          ),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            leading: const Icon(Icons.timelapse_sharp),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Due: $formattedDate',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ), // Display formatted due date
                Text(
                  formattedTime,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ), // Display formatted time
              ],
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(40), color: task.isCompleted ? Color.fromARGB(255, 233, 255, 210) : Color.fromARGB(255, 226, 243, 253)),
              child: Text(
                task.isCompleted ? "Completed" : "Incomplete",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: task.isCompleted ? Colors.green : Color.fromARGB(255, 46, 102, 185)),
              ),
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:task_app/services/task_services.dart';
import 'package:task_app/utils/utils.dart';
import 'package:task_app/widgets/custome_widgets.dart';
import '../models/task_model.dart';
import '../state_managment/task_app_provider.dart';

class TaskFormScreen extends StatelessWidget {
  final TaskModel? task; // Pass the task to edit, or null for adding a new task

  const TaskFormScreen({
    super.key,
    this.task,
  });

  @override
  Widget build(BuildContext context) {
    final taskAppProvider = Provider.of<TaskAppProvider>(context, listen: true);

    final TextEditingController titleController = TextEditingController(text: task?.title ?? '');
    final TextEditingController descriptionController = TextEditingController(text: task?.description ?? '');

    DateTime dueDate = task?.dueDate ?? DateTime.now();

    final ValueNotifier<bool> isCompletedNotifier = ValueNotifier(task?.isCompleted ?? false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Scaffold(
        appBar: AppBar(
          title: Text(task == null ? 'Add Task' : 'Edit Task'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Task Title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22.0),
                      borderSide: const BorderSide(),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22.0),
                      borderSide: const BorderSide(
                        color: Colors.grey, // Customize the border color
                        width: 1.0, // Customize the border width
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22.0),
                      borderSide: const BorderSide(
                        color: Colors.blue, // Customize the border color when focused
                        width: 2.0, // Customize the border width when focused
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22.0),
                      borderSide: const BorderSide(),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22.0),
                      borderSide: const BorderSide(
                        color: Colors.grey, // Customize the border color
                        width: 1.0, // Customize the border width
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22.0),
                      borderSide: const BorderSide(
                        color: Colors.blue, // Customize the border color when focused
                        width: 2.0, // Customize the border width when focused
                      ),
                    ),
                  ),
                  maxLines: 5, // Allows multi-line input
                ),
                const SizedBox(height: 56),
                ListTile(
                  leading: const Icon(Icons.calendar_month),
                  title: Text(
                    'Due Date: ${DateFormat('yyyy-MM-dd').format(dueDate)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.blue,
                    ),
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: dueDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null && pickedDate != dueDate) {
                        dueDate = DateTime(
                          pickedDate.year,
                          pickedDate.month,
                          pickedDate.day,
                          dueDate.hour,
                          dueDate.minute,
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(Icons.timelapse_rounded),
                  title: Text(
                    'Due Time: ${DateFormat('HH:mm').format(dueDate)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.blue,
                    ),
                    onPressed: () async {
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(dueDate),
                      );
                      if (pickedTime != null) {
                        dueDate = DateTime(
                          dueDate.year,
                          dueDate.month,
                          dueDate.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 5),
                task == null
                    ? const SizedBox()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '    Mark as Completed',
                            style: Theme.of(context).textTheme.subtitle1?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          ValueListenableBuilder<bool>(
                            valueListenable: isCompletedNotifier,
                            builder: (context, isCompleted, child) {
                              return Switch(
                                value: isCompleted,
                                onChanged: (value) {
                                  isCompletedNotifier.value = value;
                                },
                                activeColor: Theme.of(context).primaryColor,
                                inactiveTrackColor: Colors.grey.shade300,
                              );
                            },
                          ),
                        ],
                      ),
                const Spacer(),
                MyCustomAsyncButton(
                  backgroundColor: Color.fromARGB(255, 94, 66, 234),
                  btnElevation: 0.4,
                  borderRadius: 100,
                  btnOnTap: () async {
                    try {
                      final newTask = TaskModel(
                        id: task?.id ?? Utils.generateRandomId(5), // New ID if adding
                        title: titleController.text.trim(),
                        description: descriptionController.text.trim(),
                        dueDate: dueDate,
                        isCompleted: isCompletedNotifier.value,
                      );

                      if (newTask.title.isEmpty) {
                        throw 'Title is Empty';
                      }
                      if (newTask.description.isEmpty) {
                        throw 'Description is Empty';
                      }

                      if (task == null) {
                        //if it's an add Operation
                        await TaskService.addTask(newTask);
                      } else {
                        //if it's edit Operation
                        await TaskService.updateTask(newTask);
                      }

                      taskAppProvider.updateIncompleteTasks();
                      taskAppProvider.updateCompletedTasks();

                      // ignore: use_build_context_synchronously
                      Navigator.pop(context); // Close the screen after saving

                      MyCustomSnackBar(
                        bgColor: Colors.green,
                        // ignore: use_build_context_synchronously
                        context: context,
                        message: " Changes Successful!",
                        leadingIcon: Icons.check_box,
                        leadingIconColor: Colors.white,
                      ).show();
                    } catch (e) {
                      MyCustomSnackBar(
                        bgColor: Colors.red,
                        // ignore: use_build_context_synchronously
                        context: context,
                        message: e.toString(),
                        leadingIcon: Icons.error_outline,
                        leadingIconColor: Colors.white,
                      ).show();
                    }
                  },
                  btnText: task == null ? 'Add Task' : 'Save Changes',
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

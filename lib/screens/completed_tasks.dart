import 'package:async_builder/async_builder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state_managment/task_app_provider.dart';
import '../widgets/task_tile.dart';

class CompletedTasksScreen extends StatelessWidget {
  CompletedTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskAppProvider = Provider.of<TaskAppProvider>(context, listen: true);

    final double scrH = MediaQuery.of(context).size.height;
    final double scrW = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Completed Tasks'),
      ),
      body: Container(
        height: scrH,
        width: scrW,
        padding: const EdgeInsets.all(10.0), // Add some padding
        child: RefreshIndicator(
          edgeOffset: 20,
          color: Colors.red,
          onRefresh: () async {
            taskAppProvider.updateCompletedTasks();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                AsyncBuilder<dynamic>(
                  future: Future.value(taskAppProvider.completedTasks),
                  waiting: (context) => const Center(
                    child: SizedBox(
                      width: 250,
                      height: 250,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  builder: (context, result) {
                    if (result == null || result?.length == 0) {
                      return SizedBox(
                        height: scrH * 0.8,
                        child: const Center(
                          child: Text(
                            "No Completed Tasks Yet!",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: result?.length,
                        itemBuilder: (context, index) {
                          return TaskTile(task: result[index]);
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:task_app/screens/completed_tasks.dart';
import 'package:task_app/screens/settings.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            padding: const EdgeInsets.all(0),
            margin: const EdgeInsets.all(0),
            child: Container(
              padding: const EdgeInsets.all(15),
              color: Colors.blue,
              child: const Text(
                'Task Managment \nApp',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 244, 236, 236)),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text(
              'Home',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 10),
          ListTile(
            leading: const Icon(Icons.task),
            title: const Text(
              'Completed Tasks',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
            onTap: () {
              Navigator.pop(context);
              // Navigate to Completed Tasks
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CompletedTasksScreen(),
                  ));
            },
          ),
          const SizedBox(height: 10),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text(
              'Settings',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
            onTap: () {
              Navigator.pop(context);
              // Navigate to Settings
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ));
            },
          ),
        ],
      ),
    );
  }
}

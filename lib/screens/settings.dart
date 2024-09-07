import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state_managment/task_app_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final taskAppProvider = Provider.of<TaskAppProvider>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dark Mode / Light Mode Toggle
            SwitchListTile(
              title: const Text('Dark Mode'),
              value: taskAppProvider.isDarkMode,
              onChanged: (bool value) {
                taskAppProvider.setDarkMode(value);
              },
            ),
            const SizedBox(height: 20),

            // App Version
            const Text(
              'App Version: 1.0.0', // Replace with dynamic version if needed
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 50),
            // About Section
            const Text(
              'About Me',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const ListTile(
              leading: Icon(Icons.person),
              title: Text("Surafel Zewdu | Flutter Dev"),
              subtitle: Text("0965651110"),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore_for_file: prefer_const_constructors

import 'package:async_builder/async_builder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_app/services/quote_api_services.dart';
import 'package:task_app/state_managment/task_app_provider.dart';
import 'package:task_app/widgets/quote_tile.dart';

import '../widgets/app_drawer.dart';
import '../widgets/custome_widgets.dart';
import '../widgets/task_tile.dart';
import 'add_edit_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // await _showQuoteDialog();
  }

  Future<void> _showQuoteDialog() async {
    try {
      // final quote = await QuoteApiService.fetchQuote();
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) {
          // return QuoteTile(quoteText: quote['quoteText'], authorName: quote['quoteAuthor']);
          return QuoteTile(
            quoteText: "quote['quoteText']",
            authorName: "quote['quoteAuthor']",
          );
        },
      );
    } catch (e) {
      MyCustomSnackBar(
              bgColor: Colors.red,
              // ignore: use_build_context_synchronously
              context: context,
              message: 'Unable to fetch quote of the day :(',
              leadingIcon: Icons.error_outline,
              leadingIconColor: Colors.white,
              duration: Durations.long1)
          .show();
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskAppProvider = Provider.of<TaskAppProvider>(context, listen: true);

    final double scrH = MediaQuery.of(context).size.height;
    final double scrW = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Task App',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        // backgroundColor: Colors.white,
      ),
      drawer: const AppDrawer(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(0, 255, 255, 255),
              Color.fromARGB(10, 230, 232, 237),
            ],
          ),
        ),
        height: scrH,
        width: scrW,
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            SizedBox(
              height: scrH * 0.22,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome!",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                    ),
                    Text(
                      "Overall Task Summary",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color.fromARGB(255, 220, 225, 239), width: 1),
                      ),
                      child: ListTile(
                        leading: Text(
                          taskAppProvider.incompleteTasks.length.toString(),
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                        ),
                        title: Text("Assigned tasks"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                edgeOffset: 20,
                color: Colors.red,
                onRefresh: () async {
                  taskAppProvider.updateIncompleteTasks();
                },
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      AsyncBuilder<dynamic>(
                        future: Future.value(taskAppProvider.incompleteTasks),
                        waiting: (context) => const Center(
                          child: SizedBox(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        builder: (context, result) {
                          if (result == null || result?.length == 0) {
                            return SizedBox(
                              height: scrH * 0.8,
                              child: const Center(
                                child: Text(
                                  "No Tasks Yet!",
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
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
                child: TaskFormScreen(),
              );
            },
          );
        },
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ),
    );
  }
}

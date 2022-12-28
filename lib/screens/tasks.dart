import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task_app/constants/constants.dart';

import 'package:task_app/widgets/drawer_widget.dart';
import 'package:task_app/widgets/tasks_widget.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  String? taskCategory;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tasks',
          style: TextStyle(color: Colors.pink),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          IconButton(
            onPressed: () {
              categoryDialog(size, context);
            },
            icon: const Icon(
              Icons.filter_list_outlined,
            ),
          ),
          IconButton(
              onPressed: () {
                Constants.logOut(context);
              },
              icon: const Icon(
                Icons.logout_outlined,
              )),
        ],
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      drawer: const DrawerWidget(),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('tasks')
            .where('taskCategory', isEqualTo: taskCategory)
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data!.docs.isNotEmpty) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return TasksWidget(
                    isDone: snapshot.data!.docs[index]['isDone'],
                    uploadedBy: snapshot.data!.docs[index]['uploadedBy'],
                    taskDescription: snapshot.data!.docs[index]
                        ['taskDescription'],
                    taskTitle: snapshot.data!.docs[index]['taskTitle'],
                    taskId: snapshot.data!.docs[index]['taskID'],
                  );
                },
              );
            } else {
              return const Center(
                child: Text('No tasks has been uploaded'),
              );
            }
          }
          return const Center(
            child: Text('Something went wrong'),
          );
        },
      ),
    );
  }

  Future categoryDialog(Size size, BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Task category',
            style: TextStyle(
              color: Colors.pink.shade300,
              fontSize: 20,
            ),
          ),
          content: SizedBox(
            width: size.width * 0.9,
            child: ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      taskCategory = Constants.taskCategoryList[index];
                      Navigator.canPop(context) ? Navigator.pop(context) : null;
                    });
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        color: Colors.red.shade200,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          Constants.taskCategoryList[index],
                          style: TextStyle(
                            color: Constants.darkBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              itemCount: Constants.taskCategoryList.length,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.canPop(context) ? Navigator.pop(context) : null;
              },
              child: const Text(
                'Close',
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.canPop(context) ? Navigator.pop(context) : null;
                setState(() {
                  taskCategory = null;
                });
              },
              child: const Text(
                'Cancel Filter',
              ),
            ),
          ],
        );
      },
    );
  }
}

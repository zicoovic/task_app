import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_app/inner_screens/task_details.dart';
import 'package:task_app/services/global_method.dart';

class TasksWidget extends StatefulWidget {
  final String taskTitle;
  final String taskDescription;

  final String uploadedBy;
  final String taskId;
  final bool isDone;

  const TasksWidget({
    super.key,
    required this.taskTitle,
    required this.taskDescription,
    required this.uploadedBy,
    required this.isDone,
    required this.taskId,
  });

  @override
  State<TasksWidget> createState() => _TasksWidgetState();
}

class _TasksWidgetState extends State<TasksWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: ListTile(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => TaskDetails(
              taskID: widget.taskId,
              uploadedBy: widget.uploadedBy,
            ),
          ));
        },
        onLongPress: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              actions: [
                TextButton(
                  onPressed: () {
                    User? user = FirebaseAuth.instance.currentUser;
                    String uid = user!.uid;
                    if (uid == widget.uploadedBy) {
                      FirebaseFirestore.instance
                          .collection('tasks')
                          .doc(widget.taskId)
                          .delete();
                      Navigator.pop(context);
                    } else {
                      GlobalMethods.showErrorDialog(
                          error: 'You don\'t have access to delete',
                          context: context);
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Delete',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Container(
          padding: const EdgeInsets.only(right: 12.0),
          decoration: const BoxDecoration(
            border: Border(
              right: BorderSide(width: 1.0),
            ),
          ),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 20, //
            child: Image.network(
              widget.isDone
                  ? 'https://cdn-icons-png.flaticon.com/512/8968/8968523.png'
                  : 'https://cdn-icons-png.flaticon.com/512/850/850960.png',
            ),
          ),
        ),
        title: Text(
          widget.taskTitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.linear_scale,
              color: Colors.pink.shade800,
            ),
            Text(
              widget.taskDescription,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
        trailing: Icon(
          Icons.keyboard_arrow_right,
          size: 30,
          color: Colors.pink.shade800,
        ),
      ),
    );
  }
}

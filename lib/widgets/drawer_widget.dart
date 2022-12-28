import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_app/constants/constants.dart';
import 'package:task_app/inner_screens/add_tasks.dart';
import 'package:task_app/inner_screens/profile.dart';
import 'package:task_app/screens/all_works_screen.dart';
import 'package:task_app/screens/tasks.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(children: [
        DrawerHeader(
          decoration: const BoxDecoration(
            color: Colors.cyan,
          ),
          child: Column(
            children: [
              Flexible(
                child: Image.network(
                  'https://cdn-icons-png.flaticon.com/512/1055/1055672.png',
                  fit: BoxFit.fitWidth,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Flexible(
                child: Text(
                  'Work OS Arabic',
                  style: TextStyle(
                    color: Constants.darkBlue,
                    fontSize: 22,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        listTiles(
            label: 'all tasks',
            fct: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const TasksScreen(),
                ),
              );
            },
            icon: Icons.task),
        listTiles(
          label: 'My account',
          fct: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProfileScreen(
                  userID: FirebaseAuth.instance.currentUser!.uid,
                ),
              ),
            );
          },
          icon: Icons.settings_outlined,
        ),
        listTiles(
            label: 'Registered works',
            fct: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const AllWorkersScreen(),
                ),
              );
            },
            icon: Icons.workspaces_outline),
        listTiles(
            label: 'add task',
            fct: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const AddTasks(),
                ),
              );
            },
            icon: Icons.add_task_outlined),
        const Divider(thickness: 1),
        listTiles(
            label: 'Logout',
            fct: () {
              Constants.logOut(context);
            },
            icon: Icons.logout_outlined),
      ]),
    );
  }

  ListTile listTiles(
      {required String label, required Function fct, required IconData icon}) {
    return ListTile(
      onTap: () {
        fct();
      },
      leading: Icon(
        icon,
        color: Constants.darkBlue,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: Constants.darkBlue,
          fontSize: 20,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}

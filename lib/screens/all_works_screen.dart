import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task_app/constants/constants.dart';
// import 'package:task_app/services/global_method.dart';
import 'package:task_app/widgets/all_workers_widget.dart';
// import 'package:task_app/inner_screens/add_tasks.dart';
import 'package:task_app/widgets/drawer_widget.dart';

class AllWorkersScreen extends StatelessWidget {
  const AllWorkersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    Size size = MediaQuery.of(context).size;
    var _isLoading = false;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'All Workers',
          style: TextStyle(color: Colors.pink),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
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
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
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
                  return AllWorkersWidget(
                    position: snapshot.data!.docs[index]['positionInCompany'],
                    userEmail: snapshot.data!.docs[index]['email'],
                    userID: snapshot.data!.docs[index]['id'],
                    userImageUrl: snapshot.data!.docs[index]['userImageUrl'],
                    userName: snapshot.data!.docs[index]['name'],
                    phoneNumber: snapshot.data!.docs[index]['phoneNumber'],
                  );
                },
              );
            }
          } else {
            return const Center(
              child: Text('No tasks has been uploaded'),
            );
          }
          return const Center(
            child: Text('Something went wrong'),
          );
        },
      ),
    );
  }
}

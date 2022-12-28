import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:task_app/user_state.dart';
// import 'package:task_app/screens/auth/register.dart';

import 'firebase_options.dart';
// import 'package:task_app/inner_screens/task_details.dart';
// import 'package:task_app/screens/tasks.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _appInitialization = Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _appInitialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter work\'s',
          theme: ThemeData(
            scaffoldBackgroundColor: const Color(0xFFEDE7DC),
            primarySwatch: Colors.blue,
          ),
          home: const Scaffold(
            body: Center(
              child: UserState(),
            ),
          ),
        );
      },
    );
  }
}

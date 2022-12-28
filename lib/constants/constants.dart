import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../user_state.dart';

class Constants {
  static Color darkBlue = const Color(0xFF00325A);

  static List<String> taskCategoryList = [
    'Business',
    'Programming',
    'Information Technology',
    'Human resources',
    'Marketing',
    'Design',
    'Accounting',
  ];
  static List<String> jobsList = [
    'Manager',
    'Team Leader',
    'Designer',
    'Web designer',
    'Full stack developer',
    'Mobile developer',
    'Marketing',
    'Digital marketing',
  ];

  static Future<dynamic> logOut(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: const [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.logout),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Sign Out'),
              ),
            ],
          ),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Do you want to Sign Out?',
              style: TextStyle(
                color: Constants.darkBlue,
                fontSize: 20,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.canPop(context) ? Navigator.pop(context) : null;
              },
              child: const Text(
                'Cancel',
              ),
            ),
            TextButton(
              onPressed: ([bool mounted = true]) async {
                await FirebaseAuth.instance.signOut();
                if (!mounted) return;
                Navigator.of(context).canPop()
                    ? Navigator.of(context).pop()
                    : null;
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const UserState(),
                  ),
                );
              },
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

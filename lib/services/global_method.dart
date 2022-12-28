import 'package:flutter/material.dart';
import 'package:task_app/constants/constants.dart';

class GlobalMethods {
  static void showErrorDialog(
      {required String error, required BuildContext context}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              children: const [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.error_outline),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Error occurred'),
                ),
              ],
            ),
            content: Text(
              error,
              style: TextStyle(
                  color: Constants.darkBlue,
                  fontSize: 20,
                  fontStyle: FontStyle.italic),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                  },
                  child: const Text(
                    'OK',
                    style: TextStyle(color: Colors.red),
                  ))
            ],
          );
        });
  }
}

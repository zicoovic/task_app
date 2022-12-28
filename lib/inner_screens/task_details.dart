import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:task_app/constants/constants.dart';
import 'package:task_app/services/global_method.dart';

import 'package:task_app/widgets/comment_widget.dart';
import 'package:uuid/uuid.dart';

class TaskDetails extends StatefulWidget {
  final String taskID;
  final String uploadedBy;

  const TaskDetails({
    super.key,
    required this.taskID,
    required this.uploadedBy,
  });

  @override
  State<TaskDetails> createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {
  bool _isCommenting = false;
  String? _authorName;
  String? _authorPosition;
  String? taskDescription;
  String? taskTitle;
  bool? _isDone;
  Timestamp? postedDateTimeStamp;
  Timestamp? deadLineTimeStamp;
  String? deadLineDate;
  String? postedDate;
  String? userImgUlr;
  bool isDeadlineAvailable = false;
  bool _isLoading = false;
  TextEditingController _commentController = TextEditingController();
  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void getData() async {
    try {
      _isLoading = true;
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uploadedBy)
          .get();
      if (userDoc == null) {
        return;
      } else {
        setState(() {
          _authorName = userDoc.get('name');
          _authorPosition = userDoc.get('positionInCompany');
          userImgUlr = userDoc.get('userImageUrl');
        });
      }
      final DocumentSnapshot taskDatabase = await FirebaseFirestore.instance
          .collection('tasks')
          .doc(widget.taskID)
          .get();

      if (taskDatabase == null) {
        return;
      } else {
        setState(() {
          _isDone = taskDatabase.get('isDone');
          deadLineDate = taskDatabase.get('deadLineDate');
          deadLineTimeStamp = taskDatabase.get('deadLineDateStamp');
          postedDateTimeStamp = taskDatabase.get('createdAt');
          var postDate = postedDateTimeStamp!.toDate();
          postedDate = '${postDate.year}-${postDate.month}-${postDate.day}';
          taskDescription = taskDatabase.get('taskDescription');
        });
        var date = deadLineTimeStamp!.toDate();
        isDeadlineAvailable = date.isAfter(DateTime.now());
      }
    } catch (error) {
      GlobalMethods.showErrorDialog(error: error.toString(), context: context);
    } finally {
      _isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Back',
            style: TextStyle(
              color: Constants.darkBlue,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              fontSize: 20,
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      taskTitle == null ? '' : taskTitle!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Constants.darkBlue,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Uploaded by',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Constants.darkBlue,
                                  ),
                                ),
                                const Spacer(),
                                Row(
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 3,
                                          color: Colors.pink.shade800,
                                        ),
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            userImgUlr == null
                                                ? 'https://cdn-icons-png.flaticon.com/512/1077/1077012.png'
                                                : userImgUlr!,
                                          ),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _authorName == null
                                              ? ''
                                              : _authorName!,
                                          style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 15,
                                            color: Constants.darkBlue,
                                          ),
                                        ),
                                        Text(
                                          _authorPosition == null
                                              ? ''
                                              : _authorPosition!,
                                          style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 15,
                                            color: Constants.darkBlue,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Divider(
                              thickness: 1,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Upload on:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16,
                                        color: Constants.darkBlue,
                                      ),
                                    ),
                                    Text(
                                      'DeadLine Date:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16,
                                        color: Constants.darkBlue,
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      postedDate == null ? '' : postedDate!,
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16,
                                        color: Constants.darkBlue,
                                      ),
                                    ),
                                    Text(
                                      deadLineDate == null ? '' : deadLineDate!,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              isDeadlineAvailable
                                  ? 'Still have Time'
                                  : 'no Time',
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                                color: isDeadlineAvailable
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Divider(
                              thickness: 1,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Done State:',
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                  color: Constants.darkBlue,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                TextButton(
                                  onPressed: () {
                                    User? user =
                                        FirebaseAuth.instance.currentUser;
                                    String _uid = user!.uid;
                                    if (_uid == widget.uploadedBy) {
                                      FirebaseFirestore.instance
                                          .collection('tasks')
                                          .doc(widget.taskID)
                                          .update(
                                        {
                                          'isDone': true,
                                        },
                                      );
                                      getData();
                                    } else {
                                      GlobalMethods.showErrorDialog(
                                          error:
                                              "yo cannot change the state of this tasks",
                                          context: context);
                                    }
                                  },
                                  child: Text(
                                    'Done',
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                      color: Constants.darkBlue,
                                      decoration: _isDone == true
                                          ? TextDecoration.underline
                                          : TextDecoration.none,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Opacity(
                                  opacity: _isDone == true ? 1 : 0,
                                  child: const Icon(
                                    Icons.check_box,
                                    color: Colors.green,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                TextButton(
                                  onPressed: () {
                                    User? user =
                                        FirebaseAuth.instance.currentUser;
                                    String _uid = user!.uid;
                                    if (_uid == widget.uploadedBy) {
                                      FirebaseFirestore.instance
                                          .collection('tasks')
                                          .doc(widget.taskID)
                                          .update(
                                        {
                                          'isDone': false,
                                        },
                                      );
                                      getData();
                                    } else {
                                      GlobalMethods.showErrorDialog(
                                          error:
                                              "yo cannot change the state of this tasks",
                                          context: context);
                                    }
                                  },
                                  child: Text(
                                    'Not Done yet',
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                      color: Constants.darkBlue,
                                      decoration: _isDone == false
                                          ? TextDecoration.underline
                                          : TextDecoration.none,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Opacity(
                                  opacity: _isDone == false ? 1 : 0,
                                  child: const Icon(
                                    Icons.check_box,
                                    color: Colors.red,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Divider(
                              thickness: 1,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Task Description',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Constants.darkBlue,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                taskDescription == null ? '' : taskDescription!,
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                  color: Constants.darkBlue,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 500),
                              child: _isCommenting
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          flex: 3,
                                          child: TextField(
                                            controller: _commentController,
                                            style: TextStyle(
                                                color: Constants.darkBlue),
                                            keyboardType: TextInputType.text,
                                            maxLines: 6,
                                            maxLength: 200,
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                              enabledBorder:
                                                  const UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              errorBorder:
                                                  const UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.red,
                                                ),
                                              ),
                                              focusedBorder:
                                                  const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.pink,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 1,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                MaterialButton(
                                                  color: Colors.pink.shade700,
                                                  elevation: 10,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                    side: BorderSide.none,
                                                  ),
                                                  onPressed: () async {
                                                    if (_commentController
                                                            .text.length <
                                                        7) {
                                                      GlobalMethods.showErrorDialog(
                                                          error:
                                                              'Comment cant be less than 7 characters',
                                                          context: context);
                                                    } else {
                                                      final _generatedId =
                                                          const Uuid().v4();
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection('tasks')
                                                          .doc(widget.taskID)
                                                          .update({
                                                        'taskComment':
                                                            FieldValue
                                                                .arrayUnion([
                                                          {
                                                            'userId': widget
                                                                .uploadedBy,
                                                            'commentId':
                                                                _generatedId,
                                                            'name': _authorName,
                                                            'commentBody':
                                                                _commentController
                                                                    .text,
                                                            'time':
                                                                Timestamp.now(),
                                                            'userImageUrl':
                                                                userImgUlr,
                                                          }
                                                        ]),
                                                      });
                                                      await Fluttertoast
                                                          .showToast(
                                                        msg:
                                                            "Task has been uploaded successfully",
                                                        toastLength:
                                                            Toast.LENGTH_LONG,
                                                        gravity:
                                                            ToastGravity.CENTER,
                                                        timeInSecForIosWeb: 1,
                                                        backgroundColor:
                                                            Colors.red,
                                                        textColor: Colors.white,
                                                        fontSize: 16.0,
                                                      );
                                                      _commentController
                                                          .clear();
                                                    }
                                                  },
                                                  child: const Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 14),
                                                    child: Text(
                                                      'Post',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        // fontSize: 20,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      _isCommenting =
                                                          !_isCommenting;
                                                    });
                                                  },
                                                  child: const Text(
                                                    'Cancel',
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  : Align(
                                      alignment: Alignment.topCenter,
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.pink),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _isCommenting = !_isCommenting;
                                          });
                                        },
                                        child: const Text(
                                          'Add a comment',
                                        ),
                                      ),
                                    ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            ListView.separated(
                              reverse: true,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return CommentWidget();
                              },
                              separatorBuilder: (context, index) {
                                return const Divider(
                                  thickness: 1,
                                );
                              },
                              itemCount: 20,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:task_app/constants/constants.dart';
import 'package:task_app/screens/tasks.dart';
import 'package:task_app/services/global_method.dart';
import 'package:task_app/widgets/drawer_widget.dart';
import 'package:uuid/uuid.dart';

class AddTasks extends StatefulWidget {
  const AddTasks({super.key});

  @override
  State<AddTasks> createState() => _AddTasksState();
}

class _AddTasksState extends State<AddTasks> {
  final TextEditingController _categoryController =
      TextEditingController(text: 'Task category');
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _deadlineController =
      TextEditingController(text: "Pick up a date");
  final _uploadFormKey = GlobalKey<FormState>();
  DateTime? picked;
  bool _isloading = false;
  Timestamp? _deadLineDateStamp;
  @override
  void dispose() {
    _categoryController.dispose();
    _deadlineController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void upload() async {
    User? user = FirebaseAuth.instance.currentUser;
    String uid = user!.uid;
    final isValid = _uploadFormKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      if (_deadlineController.text == 'Pick up a date' ||
          _categoryController.text == 'Task category') {
        GlobalMethods.showErrorDialog(
            error: 'please pick up everything', context: context);
        return;
      }
      setState(() {
        _isloading = true;
      });
      final taskID = Uuid().v4();
      try {
        await FirebaseFirestore.instance.collection('tasks').doc(taskID).set({
          'taskID': taskID,
          'uploadedBy': uid,
          'taskTitle': _titleController.text,
          'taskDescription': _descriptionController.text,
          'deadLineDate': _deadlineController.text,
          'deadLineDateStamp': _deadLineDateStamp,
          'taskCategory': _categoryController.text,
          'taskComment': [],
          'isDone': false,
          'createdAt': Timestamp.now(),
        });
        Fluttertoast.showToast(
          msg: "Task has been uploaded successfully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        _titleController.clear();
        _descriptionController.clear();
        setState(() {
          _categoryController.text = 'Task Category';
          _deadlineController.text = 'Pick up a date';
        });
      } catch (e) {
      } finally {
        setState(() {
          _isloading = false;
        });
      }
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Constants.darkBlue,
        elevation: 0,
      ),
      drawer: const DrawerWidget(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: SingleChildScrollView(
            child: Card(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'All field are required',
                        style: TextStyle(
                            color: Constants.darkBlue,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const Divider(thickness: 1),
                  Form(
                    key: _uploadFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        textsWidgets(textLabel: 'Task Category'),
                        textFormField(
                          valueKey: 'TaskCategory',
                          controller: _categoryController,
                          enabled: false,
                          maxLength: 100,
                          onTap: () {
                            categoryDialog(size, context);
                          },
                        ),
                        textsWidgets(textLabel: 'Task Title'),
                        textFormField(
                          valueKey: 'TaskTitle',
                          controller: _titleController,
                          enabled: true,
                          maxLength: 100,
                          onTap: () {},
                        ),
                        textsWidgets(textLabel: 'Task Description'),
                        textFormField(
                          valueKey: 'TaskDescription',
                          controller: _descriptionController,
                          enabled: true,
                          maxLength: 1000,
                          onTap: () {},
                        ),
                        textsWidgets(textLabel: 'Task Deadline'),
                        textFormField(
                          valueKey: 'DeadlineDate',
                          controller: _deadlineController,
                          enabled: false,
                          maxLength: 100,
                          onTap: () {
                            _pickDate();
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: _isloading
                                ? CircularProgressIndicator()
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      MaterialButton(
                                        color: Colors.pink.shade700,
                                        elevation: 10,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          side: BorderSide.none,
                                        ),
                                        onPressed: upload,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: const [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 14),
                                              child: Text(
                                                'Upload',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Icon(
                                              Icons.upload_file,
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                contentPadding:
                                                    const EdgeInsets.fromLTRB(
                                                        10, 20, 10, 0),
                                                content: Text(
                                                  'Are you sure you want to cancel?',
                                                  style: TextStyle(
                                                    color: Constants.darkBlue,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle: FontStyle.italic,
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.canPop(context)
                                                          ? Navigator.pop(
                                                              context)
                                                          : null;
                                                    },
                                                    child: const Text(
                                                      'Cancel',
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.canPop(context)
                                                          ? Navigator
                                                              .pushReplacement(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const TasksScreen(),
                                                              ),
                                                            )
                                                          : null;
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
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 14),
                                              child: Text(
                                                'Cancel',
                                                style: TextStyle(
                                                  color: Constants.darkBlue,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding textFormField({
    required String valueKey,
    required TextEditingController controller,
    required bool enabled,
    required Function onTap,
    required int maxLength,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () => onTap(),
        child: TextFormField(
          controller: controller,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Filled is missing';
            } else {
              return null;
            }
          },
          enabled: enabled,
          key: ValueKey(valueKey),
          style: TextStyle(
              color: Constants.darkBlue,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              fontStyle: FontStyle.italic),
          maxLines: valueKey == 'TaskDescription' ? 3 : 1,
          maxLength: maxLength,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).scaffoldBackgroundColor,
            errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red)),
            enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.pink.shade800)),
            focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red)),
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 0)),
      lastDate: DateTime(3000),
    );
    if (picked != null) {
      setState(() {
        _deadLineDateStamp = Timestamp.fromMicrosecondsSinceEpoch(
            picked!.microsecondsSinceEpoch);
        _deadlineController.text =
            '${picked!.year}-${picked!.month}-${picked!.day}';
      });
    }
  }

  Padding textsWidgets({required String textLabel}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        textLabel,
        style: TextStyle(
          color: Colors.pink.shade800,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  void submitFormToUpload() {}
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
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _categoryController.text =
                          Constants.taskCategoryList[index];
                    });
                    Navigator.pop(context);
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
          ],
        );
      },
    );
  }
}

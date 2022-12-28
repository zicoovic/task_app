// ignore_for_file: unused_field, prefer_final_fields

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:task_app/constants/constants.dart';
import 'package:task_app/services/global_method.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/drawer_widget.dart';

class ProfileScreen extends StatefulWidget {
  final String userID;

  const ProfileScreen({super.key, required this.userID});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    getUserData();
    super.initState();
  }

  bool _isLoading = false;
  String phoneNumber = "";
  String email = "";
  String name = "";
  String job = "";
  String? imageUrl;
  String joinedAt = "";
  bool _isSameUser = false;

  void getUserData() async {
    _isLoading = true;
    try {
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userID)
          .get();
      // ignore: unnecessary_null_comparison
      if (userDoc == null) {
        return;
      } else {
        setState(() {
          email = userDoc.get('email');
          name = userDoc.get('name');
          phoneNumber = userDoc.get('phoneNumber');
          imageUrl = userDoc.get('userImageUrl');
          job = userDoc.get('positionInCompany');
          Timestamp joinedAtTimeStamp = userDoc.get('createAt');
          var joinedDate = joinedAtTimeStamp.toDate();
          joinedAt = '${joinedDate.year}-${joinedDate.month}-${joinedDate.day}';
          User? user = FirebaseAuth.instance.currentUser;
          String uid = user!.uid;
          setState(() {
            _isSameUser = uid == widget.userID;
          });
        });
      }
    } catch (error) {
      GlobalMethods.showErrorDialog(error: '$error', context: context);
    } finally {
      _isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Align(
        alignment: Alignment.center,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Stack(
                  children: [
                    Center(
                      child: Card(
                        margin: const EdgeInsets.all(30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 80,
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  name,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  '$job Since joined $joinedAt',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Constants.darkBlue,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              const Divider(
                                thickness: 1,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                'Contact Info',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              socialInfo(label: 'Email:', content: email),
                              const SizedBox(
                                height: 10,
                              ),
                              socialInfo(
                                  label: 'Phone number:', content: phoneNumber),
                              const SizedBox(
                                height: 30,
                              ),
                              _isSameUser
                                  ? Container()
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        socialMedia(
                                          color: Colors.green,
                                          icon: FontAwesomeIcons.whatsapp,
                                          fct: () {
                                            _openWhatsAppChat();
                                          },
                                        ),
                                        socialMedia(
                                          color: Colors.red,
                                          icon: Icons.mail_outline,
                                          fct: () {
                                            _mailTo();
                                          },
                                        ),
                                        socialMedia(
                                          color: Colors.purple,
                                          icon: Icons.call_outlined,
                                          fct: () {
                                            _callPhone();
                                          },
                                        ),
                                      ],
                                    ),
                              const SizedBox(
                                height: 20,
                              ),
                              !_isSameUser
                                  ? Container()
                                  : const Divider(
                                      thickness: 1,
                                    ),
                              const SizedBox(
                                height: 20,
                              ),
                              !_isSameUser
                                  ? Container()
                                  : Center(
                                      child: MaterialButton(
                                        color: Colors.pink.shade700,
                                        elevation: 10,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          side: BorderSide.none,
                                        ),
                                        onPressed: () async {
                                          await Constants.logOut(context);
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: const [
                                            Icon(
                                              Icons.logout_outlined,
                                              color: Colors.white,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 14),
                                              child: Text(
                                                'Logout',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: size.width * 0.26,
                          height: size.width * 0.26,
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 5,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor),
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(
                                // ignore: prefer_if_null_operators, unnecessary_null_comparison
                                imageUrl == null
                                    ? 'https://cdn-icons-png.flaticon.com/512/6997/6997674.png'
                                    : imageUrl!,
                              ),
                              fit: BoxFit.fill,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
      ),
    );
  }

  CircleAvatar socialMedia({
    required Color color,
    required Function fct,
    required IconData icon,
  }) {
    return CircleAvatar(
      backgroundColor: color,
      radius: 25,
      child: CircleAvatar(
        backgroundColor: Colors.white,
        radius: 23,
        child: IconButton(
          onPressed: () {
            fct();
          },
          icon: Icon(
            icon,
            color: color,
          ),
        ),
      ),
    );
  }

  Future _openWhatsAppChat() async {
    var whatsAppUrl = Uri.parse('https://wa.me/$phoneNumber?text=fromFlutter');
    if (await canLaunchUrl(whatsAppUrl)) {
      await launchUrl(whatsAppUrl);
    } else {
      throw 'according error';
    }
  }

  Future _mailTo() async {
    var url = Uri.parse('mailto:$email');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'we face an issue';
    }
  }

  Future _callPhone() async {
    var url = Uri.parse('tel://$phoneNumber');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'we face an issue';
    }
  }

  Widget socialInfo({required String label, required String content}) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.normal,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            content,
            style: TextStyle(
              color: Constants.darkBlue,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.normal,
            ),
          ),
        ),
      ],
    );
  }
}

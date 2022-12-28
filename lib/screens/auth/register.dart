import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:task_app/screens/auth/login.dart';
import 'package:task_app/screens/tasks.dart';
import 'package:task_app/services/global_method.dart';
import 'package:task_app/user_state.dart';

import '../../constants/constants.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _positionCPController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final FocusNode _fullNameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _positionFocusNode = FocusNode();
  final FocusNode _phoneNumberNode = FocusNode();
  bool _obscureText = true;
  final _signUpFormKey = GlobalKey<FormState>();
  File? imageFile;
  bool _isLoading = false;
  String? url;
  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _positionCPController.dispose();
    _fullNameController.dispose();
    _phoneNumberController.dispose();
    _fullNameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _positionFocusNode.dispose();
    _phoneNumberNode.dispose();

    super.dispose();
  }

  void submitFormOnSignUp() async {
    final isValid = _signUpFormKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      if (imageFile == null) {
        GlobalMethods.showErrorDialog(
            error: 'Please pick up an image', context: context);
        return;
      }
      setState(() {
        _isLoading = true;
      });
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _emailController.text.toLowerCase().trim(),
            password: _passwordController.text.trim());
        final User? user = FirebaseAuth.instance.currentUser;
        final _uid = user!.uid;
        final ref = FirebaseStorage.instance
            .ref()
            .child('userImages')
            .child(_uid + '.jpg');
        await ref.putFile(imageFile!);
        url = await ref.getDownloadURL();
        await FirebaseFirestore.instance.collection('users').doc(_uid).set({
          'id': _uid,
          'name': _fullNameController.text,
          'email': _emailController.text,
          'userImageUrl': url,
          'phoneNumber': _phoneNumberController.text,
          'positionInCompany': _positionCPController.text,
          'createdAt': Timestamp.now(),
        });
        Navigator.canPop(context) ? Navigator.pop(context) : null;
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const UserState(),
        ));
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
        GlobalMethods.showErrorDialog(
            error: error.toString(), context: context);
        print('erorrrr occured $error');
      }
    } else {
      print('Form not valid');
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 20));
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.linear)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((animationStatus) {
            if (animationStatus == AnimationStatus.completed) {
              _animationController.reset();
              _animationController.forward();
            }
          });
    _animationController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // we will make a calc for the device size to make the image responsive
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          CachedNetworkImage(
            imageUrl:
                "https://media.istockphoto.com/photos/businesswoman-using-computer-in-dark-office-picture-id557608443?k=6&m=557608443&s=612x612&w=0&h=fWWESl6nk7T6ufo4sRjRBSeSiaiVYAzVrY-CLlfMptM=",
            placeholder: (context, url) => Image.asset(
              'assets/images/wallpaper.jpg',
              fit: BoxFit.fill,
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            alignment: FractionalOffset(_animation.value, 0),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              children: [
                SizedBox(
                  height: size.height * 0.1,
                ),
                const Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 9,
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Already have an account?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(
                        text: '  ',
                      ),
                      TextSpan(
                        text: 'Login',
                        style: TextStyle(
                          color: Colors.blue.shade300,
                          decoration: TextDecoration.underline,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                Form(
                  key: _signUpFormKey,
                  child: Column(
                    children: [
                      //FullName field
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 2,
                            child: TextFormField(
                              focusNode: _fullNameFocusNode,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () => FocusScope.of(context)
                                  .requestFocus(_emailFocusNode),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Field Can\'t be missing';
                                }
                                return null;
                              },
                              controller: _fullNameController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'your FullName',
                                hintStyle: const TextStyle(color: Colors.white),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.pink.shade700),
                                ),
                                errorBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: Stack(
                              children: [
                                Container(
                                  width: size.width * 0.24,
                                  height: size.width * 0.24,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: Colors.white),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: imageFile == null
                                        ? Image.network(
                                            'https://cdn-icons-png.flaticon.com/512/1077/1077012.png',
                                            fit: BoxFit.fill,
                                          )
                                        : Image.file(imageFile!),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: InkWell(
                                    onTap: showImagePicker,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 2,
                                          color: Colors.white,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(
                                          imageFile == null
                                              ? Icons.add_a_photo
                                              : Icons.edit,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      //email field
                      TextFormField(
                        focusNode: _emailFocusNode,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () => FocusScope.of(context)
                            .requestFocus(_passwordFocusNode),
                        validator: (value) {
                          if (value!.isEmpty || !value.contains('@')) {
                            return 'Please enter a valid Email address';
                          }
                          return null;
                        },
                        controller: _emailController,
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          hintStyle: const TextStyle(color: Colors.white),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.pink.shade700),
                          ),
                          errorBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      //password field
                      TextFormField(
                        focusNode: _passwordFocusNode,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () => FocusScope.of(context)
                            .requestFocus(_phoneNumberNode),
                        validator: (value) {
                          if (value!.isEmpty || value.length < 7) {
                            return 'Please enter a valid password';
                          }
                          return null;
                        },
                        controller: _passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: _obscureText,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                            child: Icon(
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.white,
                            ),
                            onTap: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                          hintText: 'password',
                          hintStyle: const TextStyle(color: Colors.white),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.pink.shade700),
                          ),
                          errorBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      //Phone number
                      TextFormField(
                        focusNode: _phoneNumberNode,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () => FocusScope.of(context)
                            .requestFocus(_positionFocusNode),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter your Phone Number';
                          }
                          return null;
                        },
                        controller: _phoneNumberController,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Phone number',
                          hintStyle: const TextStyle(color: Colors.white),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.pink.shade700),
                          ),
                          errorBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      //Position field
                      GestureDetector(
                        onTap: () => showJobsDialog(size),
                        child: TextFormField(
                          enabled: false,
                          focusNode: _positionFocusNode,
                          textInputAction: TextInputAction.done,
                          onEditingComplete: submitFormOnSignUp,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Position is required';
                            }
                            return null;
                          },
                          controller: _positionCPController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Position in the company',
                            disabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            hintStyle: const TextStyle(color: Colors.white),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.pink.shade700),
                            ),
                            errorBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  height: 40,
                ),
                _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : MaterialButton(
                        color: Colors.pink.shade700,
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide.none,
                        ),
                        onPressed: submitFormOnSignUp,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 14),
                              child: Text(
                                'Register',
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
                              Icons.person_add,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future showImagePicker() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Please choose an option'),
          content: Column(
            // we choose MainAxisSize to make the dialog fit the content
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  _pickImageWithCamera();
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.camera,
                        color: Colors.purple,
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      Text(
                        'Camera',
                        style: TextStyle(color: Colors.purple),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _pickImageWithGallery();
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.image,
                        color: Colors.purple,
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      Text(
                        'Gallery',
                        style: TextStyle(color: Colors.purple),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _pickImageWithCamera() async {
    try {
      XFile? pickedFile = await ImagePicker().pickImage(
          source: ImageSource.camera, maxWidth: 1080, maxHeight: 1080);
      imageFile = File(pickedFile!.path);
    } catch (error) {
      // GlobalMethods.showErrorDialog(error: '$error', context: context);
    }

    // setState(() {
    //   imageFile = File(pickedFile!.path);
    // });
    if (!mounted) return;
    Navigator.pop(context);
  }

  void _pickImageWithGallery() async {
    try {
      XFile? pickedFile = await ImagePicker().pickImage(
          source: ImageSource.gallery, maxWidth: 1080, maxHeight: 1080);
      imageFile = File(pickedFile!.path);
    } catch (error) {
      // GlobalMethods.showErrorDialog(error: '$error', context: context);
    }
    // setState(() {
    //   imageFile = File(pickedFile?.path);
    // });
    if (!mounted) return;
    Navigator.pop(context);
  }

  // void _cropImage(filePath) async {
  //   File? cropImage = (await ImageCropper.platform.cropImage(
  //     sourcePath: filePath,
  //     maxWidth: 1080,
  //     maxHeight: 1080,
  //     aspectRatio: null,
  //     aspectRatioPresets: const [
  //       CropAspectRatioPreset.original,
  //       CropAspectRatioPreset.square,
  //       CropAspectRatioPreset.ratio3x2,
  //       CropAspectRatioPreset.ratio4x3,
  //       CropAspectRatioPreset.ratio16x9
  //     ],
  //     cropStyle: CropStyle.rectangle,
  //     compressFormat: ImageCompressFormat.jpg,
  //     compressQuality: 90,
  //     uiSettings: null,
  //   )) as File?;
  //   if (cropImage != null) {
  //     setState(() {
  //       imageFile = cropImage;
  //     });
  //   }
  // }

  Future showJobsDialog(Size size) {
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
                      _positionCPController.text = Constants.jobsList[index];
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
                          Constants.jobsList[index],
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

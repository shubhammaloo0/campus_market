import 'dart:io';
import 'package:campus_market/DialogBox/error_dialog.dart';
import 'package:campus_market/ForgetPassword/forget_password.dart';
import 'package:campus_market/HomeScreen/home_screen.dart';
import 'package:campus_market/LoginScreen/login_screen.dart';
import 'package:campus_market/SignupScreen/background.dart';
import 'package:campus_market/Widgets/already_have_an_account_check.dart';
import 'package:campus_market/Widgets/rounded_button.dart';
import 'package:campus_market/Widgets/rounded_input_field.dart';
import 'package:campus_market/Widgets/rounded_password_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class SignupBody extends StatefulWidget {
  @override
  State<SignupBody> createState() => _SignupBodyState();
}

class _SignupBodyState extends State<SignupBody> {
  String userPhotoUrl = '';
  File? _image;
  bool _isLoading = false;

  final signUpFormKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _getFromCamera() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _cropImage(pickedFile.path);
    }
  }

  Future<void> _getFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _cropImage(pickedFile.path);
    }
  }

  Future<void> _cropImage(String filePath) async {
    final croppedImage = await ImageCropper().cropImage(
      sourcePath: filePath,
      maxHeight: 1080,
      maxWidth: 1080,
    );

    if (croppedImage != null) {
      setState(() {
        _image = File(croppedImage.path);
      });
    }
  }

  void _showImageDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Please choose an option'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: _getFromCamera,
                child: const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Icon(
                        Icons.camera,
                        color: Colors.purple,
                      ),
                    ),
                    Text(
                      'Camera',
                      style: TextStyle(color: Colors.purple),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: _getFromGallery,
                child: const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Icon(
                        Icons.image,
                        color: Colors.purple,
                      ),
                    ),
                    Text(
                      'Gallery',
                      style: TextStyle(color: Colors.purple),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> submitFormOnSignUp() async {
    final isValid = signUpFormKey.currentState!.validate();
    if (isValid) {
      if (_image == null) {
        showDialog(
          context: context,
          builder: (context) {
            return const ErrorAlertDialog(
              message: 'Please pick an image',
            );
          },
        );
        return;
      }
      setState(() {
        _isLoading = true;
      });
      try {
        final userCredential = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim().toLowerCase(),
          password: _passwordController.text.trim(),
        );
        final user = userCredential.user;
        if (user != null) {
          final uid = user.uid;

          final ref = FirebaseStorage.instance
              .ref()
              .child('userImages')
              .child('$uid.jpg');
          await ref.putFile(_image!);
          userPhotoUrl = await ref.getDownloadURL();

          await FirebaseFirestore.instance.collection('users').doc(uid).set({
            'userName': _nameController.text.trim(),
            'id': uid,
            'userNumber': _phoneController.text.trim(),
            'userEmail': _emailController.text.trim(),
            'userImage': userPhotoUrl,
            'time': DateTime.now(),
            'status': 'approved',
          });

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        }
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
        showDialog(
          context: context,
          builder: (context) {
            return ErrorAlertDialog(
              message: error.toString(),
            );
          },
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return SignupBackground(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: signUpFormKey,
              child: InkWell(
                onTap: _showImageDialog,
                child: CircleAvatar(
                  radius: screenWidth * 0.20,
                  backgroundColor: Colors.white24,
                  backgroundImage: _image == null ? null : FileImage(_image!),
                  child: _image == null
                      ? Icon(
                    Icons.camera_enhance,
                    size: screenWidth * 0.18,
                    color: Colors.black54,
                  )
                      : null,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            RoundedInputField(
              hintText: 'Name',
              icon: Icons.person,
              onChanged: (value) => _nameController.text = value,
            ),
            RoundedInputField(
              hintText: 'Email',
              icon: Icons.email,
              onChanged: (value) => _emailController.text = value,
            ),
            RoundedInputField(
              hintText: 'Phone Number',
              icon: Icons.phone,
              onChanged: (value) => _phoneController.text = value,
            ),
            RoundedPasswordField(
              onChanged: (value) => _passwordController.text = value,
            ),
            const SizedBox(height: 5),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ForgetPassword()),
                  );
                },
                child: const Text(
                  'Forget Password?',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
            _isLoading
                ? Center(
              child: Container(
                width: 70,
                height: 70,
                child: const CircularProgressIndicator(),
              ),
            )
                : RoundedButton(
              text: 'SIGNUP',
              press: submitFormOnSignUp,
            ),
            SizedBox(height: screenHeight * 0.03),
            AlreadyHaveAnAccountCheck(
              login: false,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

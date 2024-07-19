import 'package:campus_market/DialogBox/error_dialog.dart';
import 'package:campus_market/LoginScreen/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'background.dart';

class ForgetBody extends StatefulWidget {

  @override
  State<ForgetBody> createState() => _ForgetBodyState();
}

class _ForgetBodyState extends State<ForgetBody> {

  final FirebaseAuth _auth = FirebaseAuth.instance;


  final TextEditingController _forgetPassTextController = TextEditingController(text: '');

  void _forgetPassSubmitForm() async{
    try{
      await _auth.sendPasswordResetEmail(
        email:_forgetPassTextController.text,
      );
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder:(context) => LoginScreen()));
    }catch(error){
      ErrorAlertDialog(message:error.toString(),);
    }
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ForgetBackground(
        child: Stack(
            children: [
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                  child: ListView(
                      children: [
                        SizedBox(height: size.height * 0.2,),
                        const Text(
                            'Forget Password',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 50,
                              fontFamily: 'Bebas',
                            ),
                        ),
                        const SizedBox(height: 10,),
                        const Text(
                          'Email address',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 20,),
                        TextField(
                          controller: _forgetPassTextController,
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.black38,
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(height: 60,),
                        MaterialButton(
                          onPressed:()
                          {
                            _forgetPassSubmitForm();
                          },
                          color:Colors.black54,
                          elevation:20,
                          shape:RoundedRectangleBorder(
                            borderRadius:BorderRadius.circular(20),
                          ),
                          child: const Padding(
                            padding:EdgeInsets.symmetric(vertical:14),
                            child:Text(
                              'Reset now',
                              style:TextStyle(
                                color:Colors.white,
                                fontWeight: FontWeight.bold,
                                fontStyle:FontStyle.italic,
                                fontSize:20,
                              ),
                            ),
                          ),
                        ),

                      ],
                  ),
              ),
            ],
        ),
    );
  }
}
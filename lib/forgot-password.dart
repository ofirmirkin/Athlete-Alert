import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';


class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController =  TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
  Future passwordReset() async{
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('Password reset link sent! Check your email.'),
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(e.message.toString()),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(47, 36, 255, 1),
        title: const Text('Forgotten Password'),
        elevation: 0,
      ),
       
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 100,),
            Icon(
                  Icons.lock_outline_rounded ,
                  size: 120,
                ),
                SizedBox(height: 30),
            Text('Enter your email and we will send you a password reset link:',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize:20)),
            SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric (horizontal: 25.0),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide (color: Colors.white), borderRadius: BorderRadius.circular(12),
                    ), // OutlineInputBorder
                    focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.deepPurple),
                borderRadius: BorderRadius.circular(12),
              ), // OutlineInputBorder
              hintText: 'Email', fillColor: Color.fromARGB(53, 203, 199, 199),
              filled: true,
            ), // InputDecoration
          ), // TextField
          ), // Padding
      
          SizedBox(height: 25),
          
          MaterialButton(
          onPressed: passwordReset,
          padding: const EdgeInsets.symmetric (horizontal: 25.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12.0))),
          
          child: Text('Reset Password', 
          style: TextStyle(color: Colors.white,)
          ),
          color: Color.fromRGBO(47, 36, 255, 1),
          
          ),// MaterialButton
          ],
        ),
      ),
    );
  }
}

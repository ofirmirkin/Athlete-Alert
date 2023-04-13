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
        backgroundColor: Colors.blueGrey,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Enter your email and we will send you a password reset link:',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize:20)),
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
            hintText: 'Email', fillColor: Colors.grey [200],
            filled: true,
          ), // InputDecoration
        ), // TextField
        ), // Padding
        MaterialButton(
        onPressed: passwordReset,
        child: Text('Reset Password'),
        color: Colors.teal,
        ),// MaterialButton
        ],
      ),
    );
  }
}

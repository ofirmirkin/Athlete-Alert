// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'forgot-password.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //Controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future logIn() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey,
        body: SafeArea(
            child: Center(
                child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            // ignore: prefer_const_constructors
            Icon(
              Icons.add_location_alt_sharp,
              size: 90,
            ),
            // ignore: prefer_const_constructors
            SizedBox(height: 100),
            //TODO Touch up spacing and colour theme for phone version
            //Welcome
            Text(
              'Welcome',
              style: GoogleFonts.bebasNeue(
                fontSize: 36,
              ),
            ),

            //login or signup button
            // IN login page will have a button which leads to forgot password @kru3ish
            // ignore: prefer_const_constructors
            SizedBox(height: 15),

            Text(
              'Great to see your alive and well',
              style: TextStyle(fontSize: 20),
            ),
            //Signup Button Goes to @KUNAL
            SizedBox(height: 25),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 158, 233, 233),
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 18.0),
                  child: TextField(
                    controller: _emailController,
                    // at the moment theres no limit to the
                    //character so limit will go off screen
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Email',
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 25),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 158, 233, 233),
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 18.0),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    // at the moment theres no limit to the
                    //character so limit will go off screen
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Password',
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 25),

            //SizedBox(height: 25),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 150.0),
              child: GestureDetector(
                onTap: logIn,
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text('Log In',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ),

            SizedBox(height: 25),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Dont Have an Account?',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                Text(' Signup Now',
                    style: TextStyle(
                        color: Color.fromARGB(255, 2, 128, 232),
                        fontWeight: FontWeight.bold)),
              ],
            ),

            SizedBox(height: 25),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return ForgotPasswordPage();
                        },
                      ),
                    );
                  },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ]),
        ))));
  }
}

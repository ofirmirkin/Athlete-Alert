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
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      print('Failed with error code: ${e.code}');
      print(e.message);
    }
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
        //backgroundColor: Colors.indigoAccent[700],
         backgroundColor: Color.fromRGBO(47, 36, 255, 1),
        body: SafeArea(
            child: Center(
          child: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              // ignore: prefer_const_constructors
              // Icon(
              //   Icons.add_location_alt_outlined,
              //   color: Colors.white,
              //   size: 90,
              // ),
               Image.asset('assets/images/logo.png'),// height: 222 , width: 300),
              // ignore: prefer_const_constructors
              SizedBox(height: 15),
              //TODO Touch up spacing and colour theme for phone version
              //Welcome
              Text(
                'Welcome',
                style: GoogleFonts.bebasNeue(color: Colors.white,
                  fontSize: 36,
                ),
              ),

              //login or signup button
              // IN login page will have a button which leads to forgot password @kru3ish
              // ignore: prefer_const_constructors
              SizedBox(height: 15),

              Text(
                'Great to see youre alive and well',
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
              //Signup Button Goes to @KUNAL
              SizedBox(height: 15),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                    
                     color: Colors.white,
                    border: Border.all(color: Colors.blueAccent),
                    borderRadius: BorderRadius.circular(12),
                    
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 22.0),
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

              SizedBox(height: 15),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                    //color: Color.fromARGB(255, 158, 233, 233),
                    color: Colors.white,
                    border: Border.all(color: Colors.blueAccent),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 22.0),
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

              SizedBox(height: 10),

              Row(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                          return ForgotPasswordPage();
                        },

                ),
                );
            
                }, child: Padding(
                     //alignment: Alignment.centerLeft,
                     padding:const EdgeInsets.only(left: 220.0),
                    child: Text(
                      'Forgot your Password?',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
              ),
                  ),
              ],
              
              ),


              SizedBox(height: 15),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 150.0),
                child: GestureDetector(
                  onTap: logIn,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text('Log In',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 15),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Dont Have an Account?  ',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  Text('Signup Now',
                      style: TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold)),
                ],
              ),

              SizedBox(height: 15),

           
     
          ]),
        ))));
  }
}

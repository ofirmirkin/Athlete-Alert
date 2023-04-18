import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // Controllers for form fields
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _emergencyContactController = TextEditingController();

  // Reference to Firestore collection
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  // Create new user in Firebase auth and Firestore
  Future<void> _createUser() async {
    try {
      // Create user in Firebase auth
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _usernameController.text.trim(),
              password: _passwordController.text.trim());

      print(
          'User created with Email: ${userCredential.user!.email} and Password: ${_passwordController.text.trim()}');

      // Create user document in Firestore
      await _usersCollection.doc(userCredential.user!.uid).set({
        'email': userCredential.user!.email,
        'emergencyContact': _emergencyContactController.text.trim()
      });

      // Navigate to home screen on successful sign-up
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emergencyContactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(47, 36, 255, 1),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App icon
                Icon(
                  Icons.add_location_alt_sharp,
                  color: Colors.white,
                  size: 100,
                ),
                SizedBox(
                  height: 50,
                ),

                // Welcome text
                Text(
                  'Sign Up',
                  style: GoogleFonts.bebasNeue(
                    color: Colors.white,
                    fontSize: 36,
                  ),
                ),
                SizedBox(height: 25),

                // Username field
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
                        controller: _usernameController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Username',
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 25),

                // Password field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.blueAccent),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Password',
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 25),

                // Confirm password field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.blueAccent),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: TextField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Confirm Password',
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 25),

                // Emergency contact number field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.blueAccent),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: TextField(
                        controller: _emergencyContactController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Emergency Contact Number',
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 25),

                // Sign up button
                ElevatedButton(
                  onPressed: () async {
                    // Check if password and confirm password fields match
                    if (_passwordController.text !=
                        _confirmPasswordController.text) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Passwords do not match.'),
                      ));
                      return;
                    }
                    // create user
                    await _createUser();

                    Navigator.pop(context);
                  },
                  child: Text('Sign Up'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

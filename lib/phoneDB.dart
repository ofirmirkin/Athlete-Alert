import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'firebase_options.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'forgot-password.dart';
import 'package:geolocator/geolocator.dart';

final user = FirebaseAuth.instance.currentUser!;

Future<void> sendPhoneNum(String number) async {
  DatabaseReference ref = FirebaseDatabase.instance.ref("phones/${user.uid}");
  await ref.set({
    "number": number,
    "user": user.uid,
  });
}

Future<String> readPhoneNum(String userId) async {
  DatabaseReference ref = FirebaseDatabase.instance.ref("phones/$userId");
  DatabaseEvent event = await ref.once();
  if (event.snapshot.value == null) {
    return "";
  }
  Map data = event.snapshot.value as Map;
  return data['number'];
}

// class LoginPage extends StatefulWidget {
//   const LoginPage({Key? key}) : super(key: key);

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   //Controllers
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();

//   Future logIn() async {
//     try {
//       await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: _emailController.text.trim(),
//         password: _passwordController.text.trim(),
//       );
//     } on FirebaseAuthException catch (e) {
//       print('Failed with error code: ${e.code}');
//       print(e.message);
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     determinePosition();
//   }

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Colors.blueGrey,
//         body: SafeArea(
//             child: Center(
//                 child: SingleChildScrollView(
//           child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//             // ignore: prefer_const_constructors
//             Icon(
//               Icons.add_location_alt_sharp,
//               size: 90,
//             ),
//             // ignore: prefer_const_constructors
//             SizedBox(height: 100),
//             //TODO Touch up spacing and colour theme for phone version
//             //Welcome
//             Text(
//               'Welcome',
//               style: GoogleFonts.bebasNeue(
//                 fontSize: 36,
//               ),
//             ),

//             //login or signup button
//             // IN login page will have a button which leads to forgot password @kru3ish
//             // ignore: prefer_const_constructors
//             SizedBox(height: 15),

//             Text(
//               'Great to see your alive and well',
//               style: TextStyle(fontSize: 20),
//             ),
//             //Signup Button Goes to @KUNAL
//             SizedBox(height: 25),

//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 25.0),
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Color.fromARGB(255, 158, 233, 233),
//                   border: Border.all(color: Colors.white),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 18.0),
//                   child: TextField(
//                     // controller: _emailController,
//                     //@OFIR ADD ONE FIELD HERE
//                     // at the moment theres no limit to the
//                     //character so limit will go off screen
//                     decoration: InputDecoration(
//                       border: InputBorder.none,
//                       hintText: 'Email',
//                     ),
//                   ),
//                 ),
//               ),
//             ),

//             SizedBox(height: 25),

//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 25.0),
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Color.fromARGB(255, 158, 233, 233),
//                   border: Border.all(color: Colors.white),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 18.0),
//                   child: TextField(
//                     // controller: _passwordController,
//                     //@Ofir Add a field here
//                     obscureText: true,
//                     // at the moment theres no limit to the
//                     //character so limit will go off screen
//                     decoration: InputDecoration(
//                       border: InputBorder.none,
//                       hintText: 'Password',
//                     ),
//                   ),
//                 ),
//               ),
//             ),

//             SizedBox(height: 25),

//             //SizedBox(height: 25),

//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 150.0),
//               child: GestureDetector(
//                 onTap: logIn,
//                 child: Container(
//                   padding: EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     color: Colors.grey,
//                     border: Border.all(color: Colors.white),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Center(
//                     child: Text('Log In', //@Confirm
//                         style: TextStyle(
//                             color: Colors.white, fontWeight: FontWeight.bold)),
//                   ),
//                 ),
//               ),
//             ),

//             SizedBox(height: 25),

//             SizedBox(height: 25),

//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) {
//                           return ForgotPasswordPage();
//                         },
//                       ),
//                     );
//                   },
//                   child: Text(
//                     'Forgot Password?', //Might use for text boxes
//                     style: TextStyle(
//                       color: Colors.red,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ]),
//         ))));
//   }
//   // --------------- Ask for location permission -----------------

//   Future<Position> determinePosition() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return Future.error('Location services are disabled.');
//     }

//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error('Location permissions are denied');
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       return Future.error(
//           'Location permissions are permanently denied, we cannot request permissions.');
//     }

//     return await Geolocator.getCurrentPosition();
//   }
// }

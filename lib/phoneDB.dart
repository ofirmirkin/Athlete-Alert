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

class MyButton extends StatefulWidget {
  @override
  _MyButtonState createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  String phoneNumber = '';

  void _storePhoneNumber(String number) {
    setState(() {
      phoneNumber = number;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Button'),
      ),
      body: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Enter phone number',
            ),
            onChanged: (value) {
              _storePhoneNumber(value);
            },
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              print(phoneNumber);
            },
            child: Text('Store Phone Number'),
          ),
        ],
      ),
    );
  }
}

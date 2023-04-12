import 'package:flutter/material.dart';
import 'SendSMS.dart';
import 'phoneDB.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SOS_confirmation extends StatelessWidget {
  SOS_confirmation({super.key});
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.yellowAccent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                '\n Send a SOS message to \nyour emergency contacts?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  String number = '+34618006882';
                  SMS sms = SMS();
                  sms.sendSMS(number);

                  Navigator.pop(context);
                },
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red)),
                child: const Text('Send SOS'),
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
              IconButton(
                  onPressed: () async {
                    String phoneNum = await readPhoneNum(user.uid);
                    SMS sms = SMS();
                    sms.sendSMS(phoneNum);
                  },
                  icon: const Icon(Icons.home)),
            ],
          ),
        ),
      ),
    );
  }
}

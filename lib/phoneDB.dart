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

// void main() => runApp(new MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     Color hexToColor(String code) {
//       return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
//     }

//     return MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: "End User Page",
//         home: new Material(
//             child: new Container(
//                 padding: const EdgeInsets.all(30.0),
//                 color: Colors.white,
//                 child: new Container(
//                   child: new Center(
//                       child: new Column(children: [
//                     new Padding(padding: EdgeInsets.only(top: 140.0)),
//                     new Text(
//                       'Name:',
//                       style: new TextStyle(
//                           color: hexToColor("#F2A03D"), fontSize: 25.0),
//                     ),
//                     new Padding(padding: EdgeInsets.only(top: 50.0)),
//                     new TextFormField(
//                       decoration: new InputDecoration(
//                         labelText: "Enter Name",
//                         fillColor: Colors.white,
//                         border: new OutlineInputBorder(
//                           borderRadius: new BorderRadius.circular(25.0),
//                           borderSide: new BorderSide(),
//                         ),
//                         //fillColor: Colors.green
//                       ),
//                       validator: (val) {
//                         if (val.length == 0) {
//                           return "Name cannot be empty";
//                         } else {
//                           return null;
//                         }
//                       },
//                       keyboardType: TextInputType.text,
//                       style: new TextStyle(
//                         fontFamily: "Poppins",
//                       ),
//                     ),
//                   ])),
//                 ))));
//   }
// }



// void _editUserName(BuildContext context, int index) async {
//     String newUserName = await showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         TextEditingController controller =
//             TextEditingController(text: userData[index]);
//         return AlertDialog(
//           title: Text('Edit ${fieldNames[index]}'),
//           backgroundColor: const Color.fromARGB(255, 198, 248, 244),
//           content: TextField(
//             controller: controller,
//             decoration: InputDecoration(
//               labelText: 'New ${fieldNames[index]}',
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: const Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pop(context, controller.text);
//               },
//               child: const Text('Save'),
//             ),
//           ],
//         );
//       },
//     );
//     if (newUserName != null) {
//       setState(() {
//         userData[index] = newUserName;
//       });
//     }
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:never_surf_alone/LogInWatch.dart';
import 'package:never_surf_alone/watch_map.dart';

class WatchMainPage extends StatelessWidget {
  const WatchMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return WatchMap();
              } else {
                return LogInWatch();
              }
            }));
  }
}
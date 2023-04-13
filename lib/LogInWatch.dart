import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'WatchLocation.dart';

class LogInWatch extends StatefulWidget {
  const LogInWatch({Key? key}) : super(key: key);

  @override
  State<LogInWatch> createState() => _LogInWatch();
}

class _LogInWatch extends State<LogInWatch> {

  //Controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future logIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              duration: const Duration(seconds: 2),
              content: Container(
                alignment: Alignment.center,
                child: const Text("👌"),
              )
          )
      );

    } on FirebaseAuthException catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Container(
                alignment: Alignment.center,
                child: const Text('User not found'),
              )
          )
      );

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
  void initState() {
    WatchLocation loc = WatchLocation();
    loc.askPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 45.0,
        title: const Text('Login'),
      ),
      body: Center(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    decoration: const InputDecoration(
                        labelText: 'Username',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: TextFormField(
                    obscureText: true,
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                  ),
                ),
              ElevatedButton(
                onPressed: () {
                  logIn();
                },
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OK extends StatelessWidget {
  const OK({super.key});

  @override
  Widget build(BuildContext context) {
    return const Positioned(
      top: 10,
      right: 10,
      child: Icon(Icons.check, color: Colors.green),
    );
  }
}
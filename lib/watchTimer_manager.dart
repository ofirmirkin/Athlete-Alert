import 'dart:async';
import 'package:flutter/material.dart';

class CountdownPage extends StatefulWidget {
  @override
  _CountdownPageState createState() => _CountdownPageState();
}

class _CountdownPageState extends State<CountdownPage> {
  int _remainingSeconds = 0;
  Timer _timer = Timer.periodic(Duration.zero, (_) {});
  final _durationController = TextEditingController();

  void _startTimer() {
    int duration = int.tryParse(_durationController.text) ?? 0;
    if (duration > 0) {
      setState(() {
        _remainingSeconds = duration;
      });
      const oneSec = const Duration(seconds: 1);
      _timer = Timer.periodic(
        oneSec,
        (Timer timer) => setState(
          () {
            if (_remainingSeconds < 1) {
              timer.cancel();
            } else {
              _remainingSeconds = _remainingSeconds - 1;
            }
          },
        ),
      );
    }
  }

  void _stopTimer() {
    _timer.cancel();
    setState(() {
      _remainingSeconds = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text('$_remainingSeconds');
  }
}

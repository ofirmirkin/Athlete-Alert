import 'dart:async';
import 'package:flutter/material.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Countdown Timer',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: CountdownPage(),
//     );
//   }
// }

class CountdownPage extends StatefulWidget {
  @override
  _CountdownPageState createState() => _CountdownPageState();
}

class _CountdownPageState extends State<CountdownPage> {
  int _remainingSeconds = 0;
  Timer _timer = Timer.periodic(Duration.zero, (_) {});
  final _durationController = TextEditingController();

  @override
  void dispose() {
    _timer.cancel();
    _durationController.dispose();
    super.dispose();
  }

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Countdown Timer'),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _durationController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Enter Duration (in seconds)',
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _startTimer,
                child: Text('Start Timer'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _stopTimer,
                child: Text('Stop Timer'),
              ),
              SizedBox(height: 32),
              Text(
                '$_remainingSeconds',
                style: TextStyle(fontSize: 72),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

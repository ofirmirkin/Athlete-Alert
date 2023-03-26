import 'dart:async';
import 'package:flutter/material.dart';

class WatchCountdownPage extends StatefulWidget {
  @override
  WatchCountdownPageState createState() => WatchCountdownPageState();
}

class WatchCountdownPageState extends State<WatchCountdownPage> {
  int _remainingSeconds = 0;
  Timer _timer = Timer.periodic(Duration.zero, (_) {});
  final _durationController = TextEditingController();
  int intDuration = 15;
  Duration duration = Duration(minutes: 15);

  void increment() {
    setState(() {
      duration = duration + const Duration(minutes: 15);
    });
  }

  void decrement() {
    setState(() {
      duration = duration - const Duration(minutes: 15);
    });
  }

  formatDuration(Duration d) => d.toString().split('.').first.padLeft(8, "0");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: decrement,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: increment,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                formatDuration(duration),
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.timer),
        onPressed: () {
          Navigator.of(context).pop(duration.inSeconds);
        },
        label: const Text('Start'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

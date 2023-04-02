import 'dart:async';
import 'package:flutter/material.dart';

class WatchSetTimePage extends StatefulWidget {
  @override
  WatchSetTimePageState createState() => WatchSetTimePageState();
}

class WatchSetTimePageState extends State<WatchSetTimePage> {
  Duration duration = const Duration(minutes: 15);

  void increment() {
    setState(() {
      duration = duration + const Duration(minutes: 15);
    });
  }

  void decrement() {
    setState(() {
      if (duration.inMinutes > 15) {
        duration = duration - const Duration(minutes: 15);
      } else {
        duration = Duration.zero;
      }
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
                style: Theme.of(context).textTheme.displaySmall,
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

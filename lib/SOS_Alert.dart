import 'dart:async';
import 'package:flutter/material.dart';
import 'package:twilio_flutter/twilio_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SOS_Alert extends StatelessWidget {
  final twilioFlutter = TwilioFlutter(
    accountSid: 'AC017e75659632309cda5e49192d99e6a4',
    authToken: '5b126bd6cebb44829c7865cf5864eeb6',
    twilioNumber: '+12762779251',
  );

  void sendSMS(int timerDuration, LatLng location) async {
    double _lat = location.latitude;
    double _long = location.longitude;
    await twilioFlutter.sendSMS(
      toNumber: '+353892152983', // emergency phone number
      messageBody: '''Hello, you are listed as an emergency contact for.
       They were let seen at the following location __. 
       This message is automated as they have not been active on their device for $timerDuration seconds. Last seen at coordinates $_lat, $_long ''',
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Twilio Timer',
      home: TimerScreen(sendSMS),
    );
  }
}

class TimerScreen extends StatefulWidget {
  final Function onTimerFinish;

  TimerScreen(this.onTimerFinish);

  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  late Timer _timer = Timer(Duration(seconds: 0), () {});
  int _minutesleft = 0; //[1]
  int _timerDuration = 0;

  @override
  void dispose() {
    _timer.cancel();
    textController.dispose(); //[4]
    super.dispose();
  }

  void startTimer(int secondsRemaining) {
    _timer?.cancel();
    _timer = Timer(Duration(seconds: secondsRemaining), () {
      widget.onTimerFinish();
      setState(() {
        _minutesleft = 0;
      });
    });
    setState(() {
      _minutesleft = secondsRemaining;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SOS Timer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _minutesleft > 0
                ? Text(
                    'timer set for $_minutesleft',
                    style: TextStyle(fontSize: 24),
                  )
                : Text(
                    'SOS alert sent to emergency contacts!',
                    style: TextStyle(fontSize: 24),
                  ),
            SizedBox(height: 12),
            // [3] - user input for timer duration
            TextField(
              controller: textController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter timer duration',
              ),
              onChanged: (value) =>
                  setState(() => _timerDuration = int.tryParse(value) ?? 0),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _minutesleft = int.tryParse(textController.text) ?? 0;
                  startTimer(_minutesleft);
                });
              },
              child: Text('Start timer'),
            )
          ],
        ),
      ),
    );
  }

  // [4] - Text editing controller for user input
  final textController = TextEditingController(text: '');
}

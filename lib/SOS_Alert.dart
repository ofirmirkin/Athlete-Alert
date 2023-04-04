import 'dart:async';
import 'package:flutter/material.dart';
import 'package:twilio_flutter/twilio_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// void main() async {
//   await dotenv.load(fileName: '.env');
//   runApp(MyApp());
// }

class SOS_Alert extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Twilio Timer',
      home: TimerScreen(),
    );
  }
}

class TimerScreen extends StatefulWidget {
  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  late Timer _timer = Timer(Duration(seconds: 0), () {});
  int _minutesLeft = 0;
  int _timerDuration = 0;
  String? _currentAddress;

  final twilioFlutter = TwilioFlutter(
  accountSid: dotenv.env['TWILIO_ACCOUNT_SID']!,
  authToken: dotenv.env['TWILIO_AUTH_TOKEN']!,
  twilioNumber: dotenv.env['TWILIO_PHONE_NUMBER']!,
  );

  Future<void> sendSMS() async {
    await twilioFlutter.sendSMS(
      toNumber: '+918800662702',
      messageBody: '''Hello, you are listed as an emergency contact for. 
          They were last seen at the following location: $_currentAddress. 
          This message is automated as they have not been active on their device for $_timerDuration seconds.''',
    );
  }

  // Location methods and variables
  Position? _currentPosition;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    
    await Geolocator.getCurrentPosition(forceAndroidLocationManager: true,desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
            '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    textController.dispose();
    super.dispose();
  }

  void startTimer(int secondsRemaining) {
    _timer?.cancel();
    _timer = Timer(Duration(seconds: secondsRemaining), () async {
      await _getCurrentPosition();
      sendSMS();
      setState(() {
        _minutesLeft = 0;
      });
    });
    setState(() {
      _minutesLeft = secondsRemaining;
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
            _minutesLeft > 0
                ? Text(
                    'Timer set for $_minutesLeft',
                    style: TextStyle(fontSize: 24),
                  )
                : Text(
                    'SOS alert sent to emergency contacts!',
                    style: TextStyle(fontSize: 24),
                  ),
            SizedBox(height: 12),
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
                  _minutesLeft = int.tryParse(textController.text) ?? 0;
                  startTimer(_minutesLeft);
                });
              },
              child: Text('Start timer'),
            )
          ],
        ),
      ),
    );
  }

  final textController = TextEditingController(text: '');
}

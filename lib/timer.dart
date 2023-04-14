import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class CountDownPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // title: Text('Home'),
          ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 24, horizontal: 64),
                textStyle: TextStyle(fontSize: 24),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Page1()),
                );
              },
              child: Text('Set timer now'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 24, horizontal: 64),
                textStyle: TextStyle(fontSize: 24),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TimerPage()),
                );
              },
              child: Text('Set future time'),
            ),
          ],
        ),
      ),
    );
  }
}

//page 1

class Page1 extends StatefulWidget {
  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  int _remainingSeconds = 0;
  Timer _timer = Timer.periodic(Duration.zero, (_) {});
  final _hoursController = TextEditingController();
  final _minutesController = TextEditingController();
  final _secondsController = TextEditingController();

  @override
  void dispose() {
    _timer.cancel();
    _hoursController.dispose();
    _minutesController.dispose();
    _secondsController.dispose();
    super.dispose();
  }

  void _startTimer() {
    int hours = int.tryParse(_hoursController.text) ?? 0;
    int minutes = int.tryParse(_minutesController.text) ?? 0;
    int seconds = int.tryParse(_secondsController.text) ?? 0;
    int totalSeconds = hours * 3600 + minutes * 60 + seconds;
    if (totalSeconds > 0) {
      setState(() {
        _remainingSeconds = totalSeconds;
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
        backgroundColor: Color.fromRGBO(47, 36, 255, 1),
        title: Text('Set the emergency time'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 60,
                  child: TextField(
                    controller: _hoursController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Hrs',
                    ),
                  ),
                ),
                SizedBox(width: 8),
                SizedBox(
                  width: 60,
                  child: TextField(
                    controller: _minutesController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Min',
                    ),
                  ),
                ),
                SizedBox(width: 8),
                SizedBox(
                  width: 60,
                  child: TextField(
                    controller: _secondsController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Sec',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Color.fromRGBO(47, 36, 255, 1), // Background color
              ),
              onPressed: _startTimer,
              child: Text('Start Timer'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Color.fromRGBO(47, 36, 255, 1), // Background color
              ),
              onPressed: _stopTimer,
              child: Text('Stop Timer'),
            ),
            SizedBox(height: 32),
            Text(
              Duration(seconds: _remainingSeconds).toString().split('.').first,
              style: TextStyle(fontSize: 72),
            ),
          ],
        ),
      ),
    );
  }
}

//page 2
class TimerPage extends StatefulWidget {
  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  late Timer _timer;
  late int _remainingSeconds;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = _calculateRemainingSeconds();
    _timer = Timer.periodic(Duration(seconds: 1), _updateTimer);
  }

  int _calculateRemainingSeconds() {
    DateTime now = DateTime.now();
    DateTime selectedDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );
    Duration duration = selectedDateTime.difference(now);
    return duration.inSeconds;
  }

  void _updateTimer(Timer timer) {
    setState(() {
      _remainingSeconds--;
    });
    if (_remainingSeconds == 0) {
      _timer.cancel();
    }
  }

  String _formatTime(int value) {
    return value.toString().padLeft(2, '0');
  }

  void _cancelTimer() {
    if (_timer.isActive) {
      _timer.cancel();
      setState(() {
        _remainingSeconds = 0;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Timer cancelled.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(47, 36, 255, 1),
        title: Text('Choose date and time'),
      ),
      body: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text('Date'),
            subtitle: Text(DateFormat.yMMMd().format(_selectedDate)),
            onTap: () async {
              DateTime? picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
              );
              if (picked != null && picked != _selectedDate) {
                setState(() {
                  _selectedDate = picked;
                  _remainingSeconds = _calculateRemainingSeconds();
                });
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.access_time),
            title: Text('Time'),
            subtitle: Text(_selectedTime.format(context)),
            onTap: () async {
              TimeOfDay? picked = await showTimePicker(
                context: context,
                initialTime: _selectedTime,
              );
              if (picked != null && picked != _selectedTime) {
                setState(() {
                  _selectedTime = picked;
                  _remainingSeconds = _calculateRemainingSeconds();
                });
              }
            },
          ),
          SizedBox(height: 16),
          Text(
            '${_formatTime((_remainingSeconds ~/ 86400))} d ${_formatTime((_remainingSeconds ~/ 3600) % 24)} h ${_formatTime((_remainingSeconds ~/ 60) % 60)} m',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  Color.fromRGBO(47, 36, 255, 1), // Background color
            ),
            child: Text('Cancel Timer'),
            onPressed: _cancelTimer,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
import 'package:flutter/material.dart';
import 'SendSMS.dart';

class SOS_confirmation extends StatelessWidget {
  const SOS_confirmation( {super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.yellowAccent,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('\n Send a SOS message to \nyour emergency contacts?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                ElevatedButton(
                  onPressed: () {

                    SMS sms = SMS();
                    sms.sendSMS();

                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.red)
                  ),
                  child: const Text('Send SOS'),
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel')
                ),
              ],
            ),
          ),
        ),
    );
  }
}
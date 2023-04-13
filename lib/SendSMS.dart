import 'package:twilio_flutter/twilio_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SMS {
  late TwilioFlutter twilioFlutter;

  SMS() {
    twilioFlutter = TwilioFlutter(
        accountSid: dotenv.env['TWILIO_ACCOUNT_SID']!,
        // replace *** with Account SID
        authToken: dotenv.env['TWILIO_AUTH_TOKEN']!,
        // replace xxx with Auth Token
        twilioNumber: dotenv
            .env['TWILIO_PHONE_NUMBER']! // replace .... with Twilio Number
        );
  }

  void sendSMS(String number) async {
    twilioFlutter.sendSMS(
        toNumber: number,
        messageBody:
            "EMERGENCY - Your friend needs help and he might be in danger. Try to make contact immediately or call the emergency services");
  }
}

// '+34618006882'

    /*WatchLocation loc = WatchLocation();
    print("Hello");
    LocationData ld = await loc.determinePosition();

    Location location = Location();
    location.enableBackgroundMode(enable: true);
    print("Hello!");
    LocationData ld = await location.getLocation();
    print("By!");
    print(ld.latitude);
*/
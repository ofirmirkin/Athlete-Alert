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
        twilioNumber: dotenv.env['TWILIO_PHONE_NUMBER']! // replace .... with Twilio Number
    );
  }

  void sendSMS() async {
    twilioFlutter.sendSMS(toNumber: '+34618006882',
        messageBody: 'EMERGENCY - NAME has send an emergency number to his contacts. He is in this location: LOCATION. Try to make contact immediately or call the emergency services');
  }

}
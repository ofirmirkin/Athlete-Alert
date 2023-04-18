import 'dart:ffi';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:never_surf_alone/phoneDB.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:twilio_flutter/twilio_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

import 'OK.dart';
import 'PhoneLocation.dart';

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

  void sendSMS_phone(BuildContext context) async {
    String phoneNum = await readPhoneNum(user.uid);
    String? email = user.email;

      PhoneLocation pl = PhoneLocation();
      Position position = await pl.getCurrentPosition(context);
      double lat = position.latitude;
      double long = position.longitude;
      int alt = position.altitude.round();
      int acc = position.accuracy.round();

      twilioFlutter.sendSMS(
          toNumber: phoneNum,
          messageBody:
          "\n\n\nEMERGENCY: Your friend ($email) needs help and he might be in danger.\n\nLatitude: $lat\nLongitude: $long\nAltitude: $alt m\nAccuracy: $acc m\nDisplay location in Google Maps: https://www.google.com/maps/place/$lat,$long\n\nTry to make contact immediately or call the emergency services"
      );

    await ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Container(
              alignment: Alignment.center,
              child: const Text('SMS sent!'),
            )
        )
    );
  }
  void sendSMS_watch(BuildContext context, String phoneNum) {
    String? email = user.email;

    twilioFlutter.sendSMS(
        toNumber: phoneNum,
        messageBody:
        "\n\nEMERGENCY: Your friend ($email) needs help and he might be in danger.\n\nTry to make contact immediately or call the emergency services"
    );

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Container(
              alignment: Alignment.center,
              child: const Text('SMS sent!'),
            )
        )
    );

  }
}
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart  ';
import 'package:overlay_support/overlay_support.dart';
import 'package:spaid/service/messaging_native.dart' if (dart.library.html) 'package:spaid/service/messaging.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/support/images.dart';
import 'package:spaid/support/style_sizes.dart';
import 'package:spaid/utils/shared_pref_manager.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm;

  PushNotificationService(this._fcm);
  String? token;
  Future initialise() async {

    /*if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }*/

    // If you want to test the push notification locally,
    // you need to get the token and input to the Firebase console
    // https://console.firebase.google.com/project/YOUR_PROJECT_ID/notification/compose
    if(kIsWeb){
      final _messaging = Messaging.instance;
      _messaging.init();
      _messaging.requestPermission()!.then((_) async {
        token = await _messaging.getToken();
        print('Token: $token');
        SharedPrefManager.instance.setStringAsync(Constants.FCM, token!);

      });
      _messaging.messageListener();
      /* token = await _fcm.getToken(
        vapidKey: "BGpdLRs......",
      );*/
    }else {
       token = await _fcm.getToken();
       SharedPrefManager.instance.setStringAsync(Constants.FCM, token!);

    }
    print("FirebaseMessaging token: $token");

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showSimpleNotification(
          Text(message['notification']['title'],
              style: TextStyle(
                color: MyColors.white,
              )),
          subtitle: Text(message['notification']['body'],
              style: TextStyle(
                color: MyColors.white,
              )),
          background: MyColors.kPrimaryColor,
          autoDismiss: false,
          slideDismiss: true,
          leading: CircleAvatar(
              radius: PaddingSize.circleRadius,
              backgroundColor: MyColors.white,
              child: Image.asset(MyImages.spaid_logo,
                width: MarginSize.headerMarginHorizontal1,
                height: MarginSize.headerMarginHorizontal1,
              )),
          trailing: Builder(builder: (context) {
            return ElevatedButton(
                style: ElevatedButton.styleFrom(foregroundColor: MyColors.white,backgroundColor: MyColors.kPrimaryColor
                ),
                onPressed: () {
                  OverlaySupportEntry.of(context)!.dismiss();
                },
                child: Text('Dismiss'));
          }),
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }

}
import 'dart:convert';

import 'package:http/http.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/utils/shared_pref_manager.dart';

class SendPushNotificationService {
  Future sendPushNotifications(String fcmTokenID, String title, String body) async {
   // String userToken=await SharedPrefManager.instance.getStringAsync(Constants.FCM);
    final postUrl = 'https://fcm.googleapis.com/fcm/send';
    final data = {
      // "registration_ids" : userToken,
      "to" : fcmTokenID,
      "collapse_key" : "type_a",
      "notification" : {
        "title": title,
        "body" : body,
      }
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization':'key='+ Constants.firebaseTokenAPIFCM // 'key=YOUR_SERVER_KEY'
    };

    final response = await post(postUrl,
        body: json.encode(data),
        encoding: Encoding.getByName('utf-8'),
        headers: headers);

    if (response.statusCode == 200) {
      // on success do sth
      print('test ok push CFM');
      return true;
    } else {
      print(' CFM error');
      // on failure do sth
      return false;
    }
  }
}
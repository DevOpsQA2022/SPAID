import 'dart:async';
import 'package:firebase/firebase.dart' as firebase;
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/images.dart';
import 'package:spaid/support/style_sizes.dart';

class Messaging {
  Messaging._();
  static Messaging _instance = Messaging._();
  static Messaging get instance => _instance;
  firebase.Messaging? _mc;
  String? _token;

  final _streamController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get stream => _streamController.stream;

  void close() {
    _streamController.close();
  }

  Future<void> init() async {
    _mc = firebase.messaging();
    _mc!.usePublicVapidKey('BIEQ5u5ORl8V8Yc4mrTU9WwuDJPqEyoTEyQlWU5HxWLqrF2yMKWpEEi5foESEKGlqqlcfqlYj5OQDSdgYQw2QCE');
    _mc!.onMessage.listen((event) {
      _streamController.add(event.data);
    });
  }

  Future<void> messageListener() async {
    _mc!.onMessage.listen((payload) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${payload.data}');

      if (payload.notification != null) {
        print(
            'Message also contained a notification: ${payload.notification.body}');
        showSimpleNotification(
          Text(payload.notification.title,
              style: TextStyle(
                color: MyColors.white,
              )),
          subtitle: Text(payload.notification.body,
              style: TextStyle(
                color: MyColors.white,
              )),
          background: MyColors.kPrimaryColor,
          autoDismiss: false,
          position: NotificationPosition.bottom,
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
                style: ElevatedButton.styleFrom(foregroundColor: MyColors.white,
                ),
                onPressed: () {
                  OverlaySupportEntry.of(context)!.dismiss();
                },
                child: Text('Dismiss'));
          }),
        );
        /*showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => FancyDialog(
              //gifPath: MyImages.team,
              okFun: () => {Navigator.of(context).pop()},
              isCancelShow: false,
             // cancelFun: () => {Navigator.of(context).pop()},
              //cancelColor: MyColors.red,
              title: payload.notification.title,
              child: Text(payload.notification.body),
            ));*/
      }
    });
  }
  Future requestPermission() {
    return _mc!.requestPermission();
  }

  Future<String> getToken([bool force = false]) async {
    if (force || _token == null) {
      await requestPermission();
      _token = await _mc!.getToken();
    }
    return _token!;
  }
}
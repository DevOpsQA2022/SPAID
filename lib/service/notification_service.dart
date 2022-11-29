import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/utils/shared_pref_manager.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../support/colors.dart';
import '../support/images.dart';
import '../support/style_sizes.dart';


class NotificationService {
  static final NotificationService _notificationService = NotificationService.internal();
   FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin ;

  factory NotificationService() {
    return _notificationService;
  }
   inits(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) {
    this.flutterLocalNotificationsPlugin=flutterLocalNotificationsPlugin;
   }


  NotificationService.internal();
   init(int eventID,String status,String name,String location,String date,String time) async{

    String _timeBefore= await SharedPrefManager.instance.getStringAsync(Constants.reminderTime);

     final AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');

    final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    tz.initializeTimeZones();

    await flutterLocalNotificationsPlugin!.initialize(initializationSettings,
        onSelectNotification: selectNotification);

    tz.initializeTimeZones();


  /*  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        12345, 'plain title', 'plain body', platformChannelSpecifics,
        payload: 'item x');*/

    /*await flutterLocalNotificationsPlugin.zonedSchedule(
        12345,
        "A Notification From My App",
        "This notification is brought to you by Local Notifcations Package",
        tz.TZDateTime.now(tz.local).add(const Duration(days: 3)),
        const NotificationDetails(
            android: AndroidNotificationDetails(CHANNEL_ID, CHANNEL_NAME,
                CHANNEL_DESCRIPTION)),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);
   }
*/
   /* var scheduledNotificationDateTime =
    DateTime.now().add(Duration(seconds: 5));*/
    await flutterLocalNotificationsPlugin!.cancelAll();

    String showTime=time=="00:00"?"TBD":DateFormat("h:mma").format(DateFormat("hh:mm").parse(time));
    DateTime scheduledDateTime = DateFormat('dd/MM/yyyy HH:mm').parse(
        date + " " + time);
    if(status == "Upcoming" && scheduledDateTime.compareTo(DateTime.now())>=0) {
     /* print("SH");
      print(name);
      print(eventID);*/
     // DateTime scheduledDate = DateFormat('dd/MM/yyyy HH:mm').parse(date+ " " + "06:00");
      var androidPlatformChannelSpecifics1 =
      AndroidNotificationDetails('SPAID'+eventID.toString(),
          'SPAID', 'SPAID');
      var iOSPlatformChannelSpecifics1 =
      IOSNotificationDetails();
      NotificationDetails platformChannelSpecifics1 = NotificationDetails(
          android: androidPlatformChannelSpecifics1, iOS: iOSPlatformChannelSpecifics1);
      await flutterLocalNotificationsPlugin!.schedule(
          eventID,
          name,
          //"location: " + location + "\nDate: " + date + "\nTime: " + time=="00:00"?"TBD":DateFormat("h:mma").format(DateFormat("hh:mm").parse(time)),
          "location: " + location + "\nDate: " + date + "\nTime: " + showTime,
          scheduledDateTime,
          platformChannelSpecifics1,androidAllowWhileIdle: true);
    }else{
     /* print("CH");
      print(name);
      print(eventID);*/
      await flutterLocalNotificationsPlugin!.cancel(eventID);

    }


    if(status == "Upcoming" && scheduledDateTime.compareTo(DateTime.now())>=0 && _timeBefore!=null) {
     /* print("SH");
      print(name);
      print(eventID);*/
      String lestime=(_timeBefore.split(':').first.toString()+"."+_timeBefore.split(':').last.toString());
      int duration=(double.parse(lestime)*3600).toInt();
      DateTime scheduledDate = DateFormat('dd/MM/yyyy HH:mm').parse(date+ " " + time).subtract( Duration(seconds:duration,));
     // print(scheduledDate);

      var androidPlatformChannelSpecifics1 =
      AndroidNotificationDetails('SPAIDRE'+eventID.toString(),
          'SPAID', 'SPAID');
      var iOSPlatformChannelSpecifics1 =
      IOSNotificationDetails();
      NotificationDetails platformChannelSpecifics1 = NotificationDetails(
          android: androidPlatformChannelSpecifics1, iOS: iOSPlatformChannelSpecifics1);
      await flutterLocalNotificationsPlugin!.schedule(
          int.parse(eventID.toString()+"111"),
          name,
          //"location: " + location + "\nDate: " + date + "\nTime: " + time=="00:00"?"TBD":DateFormat("h:mma").format(DateFormat("hh:mm").parse(time)),
          "location: " + location + "\nDate: " + date + "\nTime: " + showTime,
          scheduledDate,
          platformChannelSpecifics1,androidAllowWhileIdle: true);
    }else{
      /*print("CH");
      print(name);
      print(eventID);*/
      await flutterLocalNotificationsPlugin!.cancel(int.parse(eventID.toString()+"111"));

    }

     // Show a notification every minute with the first appearance happening a minute after invoking the method
   /* var androidPlatformChannelSpecifics2 =
    AndroidNotificationDetails('repeating channel id',
        'repeating channel name', 'repeating description');
    var iOSPlatformChannelSpecifics2 =
    IOSNotificationDetails();
    var platformChannelSpecifics2 = NotificationDetails(
        androidPlatformChannelSpecifics2, iOSPlatformChannelSpecifics2);
    await flutterLocalNotificationsPlugin.periodicallyShow(12, 'repeating title',
        'repeating body', RepeatInterval.EveryMinute, platformChannelSpecifics2);*/

  }


  Future onDidReceiveLocalNotification(
      int? id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showSimpleNotification(
      Text(title!,
          style: TextStyle(
            color: MyColors.white,
          )),
      subtitle: Text(body!,
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
            style: ElevatedButton.styleFrom(foregroundColor: MyColors.white,
            ),
            onPressed: () {
              OverlaySupportEntry.of(context)!.dismiss();
            },
            child: Text('Ok'));
      }),
    );
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) => CupertinoAlertDialog(
    //     title: Text(title),
    //     content: Text(body),
    //     actions: [
    //       CupertinoDialogAction(
    //         isDefaultAction: true,
    //         child: Text('Ok'),
    //         onPressed: () async {
    //           Navigator.of(context, rootNavigator: true).pop();
    //           /*await Navigator.push(
    //             context,
    //             MaterialPageRoute(
    //               builder: (context) => SecondScreen(payload),
    //             ),
    //           );*/
    //         },
    //       )
    //     ],
    //   ),
    // );
  }
  Future selectNotification(String? payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    /* await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SecondScreen(payload)),
    );*/
  }


}
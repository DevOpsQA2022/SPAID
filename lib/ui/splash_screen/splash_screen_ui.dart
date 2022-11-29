import 'dart:async';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:spaid/base/base_state.dart';
import 'package:spaid/service/email_service.dart';
import 'package:spaid/service/firebase_dynamic_link_service.dart';
import 'package:spaid/service/send_push_notification_service.dart';
import 'package:spaid/support/base_class.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/support/email_template.dart';
import 'package:spaid/support/images.dart';
import 'package:spaid/support/routes.dart';
import 'package:spaid/support/strings.dart';
import 'package:spaid/support/style_sizes.dart';
import 'package:spaid/ui/select_team_screen/select_team_screen_ui.dart';
import 'package:spaid/ui/signup_screen/signup_screen_provider.dart';
import 'package:spaid/ui/splash_screen/splash_screen_provider.dart';
import 'package:spaid/utils/navigation.dart';
import 'package:spaid/utils/shared_pref_manager.dart';
import 'package:spaid/widgets/calendar_cubit.dart';
import 'package:spaid/widgets/calendar_event_model.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends BaseState<SplashScreen>
    with WidgetsBindingObserver {
   SplashScreenProvider? _splashScreenProvider;
  final DynamicLinksService _dynamicLinkService = DynamicLinksService();
  Timer? _timerLink;
  bool isFromMail = false;
  SignUpProvider? _signUpProvider;
   CalendarCubit? calendarCubit;

  @override
  void initState() {
    //startKeepAlive();
    if (kIsWeb){
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);
    }
    else if( Device.get().isTablet) {
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);
    }
    else{
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    }

    WidgetsBinding.instance.addObserver(this);
    _splashScreenProvider =
        Provider.of<SplashScreenProvider>(context, listen: false);
    calendarCubit = Provider.of<CalendarCubit>(context, listen: false);
    _splashScreenProvider!.initialiseAsync();
    _splashScreenProvider!.listener = this;
    _signUpProvider = Provider.of<SignUpProvider>(context, listen: false);
    _signUpProvider!.initialProvider();
    loadImages();
    loadVideos();
    loadFiles();

    if (!kIsWeb) {
      _initDynamicLinks();

      //  initDynamicLinksAsync();
    }

    /* _timerLink = new Timer(
      const Duration(milliseconds: 1000),
          () {
        _dynamicLinkService.retrieveDynamicLink(context);

      },
    );*/
    super.initState();
  }

  void _initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData? dynamicLink) async {
      final Uri deepLink = dynamicLink!.link;

      if (deepLink != null) {
        print(deepLink);
        isFromMail = true;
        if (Uri.parse(deepLink.fragment).path == MyRoutes.createPasswordScreen &&
            Uri.parse(deepLink.fragment).queryParameters["userid"] != null) {
          List<String> userDetails = [];
          String? userID = Uri.parse(deepLink.fragment).queryParameters["userid"];
          String? teamID = Uri.parse(deepLink.fragment).queryParameters["teamid"];
          String? emailID = Uri.parse(deepLink.fragment).queryParameters["email"];
          String? fcm = Uri.parse(deepLink.fragment).queryParameters["fcm"];
          String? userRoleId = Uri.parse(deepLink.fragment).queryParameters["userRoleId"];
          String? team = Uri.parse(deepLink.fragment).queryParameters["team"];
          String? player = Uri.parse(deepLink.fragment).queryParameters["player"];
          String? manager = Uri.parse(deepLink.fragment).queryParameters["manager"];
          String? isMemberExist = Uri.parse(deepLink.fragment).queryParameters["isMemberExist"];
          String? toMail = Uri.parse(deepLink.fragment).queryParameters["toMail"];
          String? toID = Uri.parse(deepLink.fragment).queryParameters["toID"];
          userDetails.add(userID!);
          userDetails.add(teamID!);
          userDetails.add(emailID!);
          userDetails.add(userRoleId!);
          userDetails.add(fcm!);
          userDetails.add(team!);
          userDetails.add(player!);
          userDetails.add(manager!);
          userDetails.add(toMail!);
          userDetails.add(toID!);
          if(isMemberExist=="true"){
            _signUpProvider!.createAccountAsync(userID, teamID, emailID, 2,false,int.parse(userRoleId));
            EmailService().inits("Invite Accepted","",Constants.gameEventAccept,int.parse(userDetails[0]),int.parse(userDetails[0]),int.parse(userDetails[1]),"You have accepted the invite to join the team, "+userDetails[5]+".",emailID,userDetails[5],"","",userDetails[6],"");
          EmailService().inits("Invite Accepted","",Constants.gameEventAcceptManager,int.parse(userDetails[0]),int.parse(userDetails[9]),int.parse(userDetails[1]),userDetails[6]+" has accepted your invite to join the team, "+userDetails[5]+".",toMail,"","","",userDetails[6]+" has accepted your invitation to join the team, "+userDetails[5],userDetails[7]);

          SendPushNotificationService().sendPushNotifications(
          await SharedPrefManager.instance.getStringAsync(Constants.FCM),
          "You have accepted the invite to join the team, "+userDetails[5],"");
          SendPushNotificationService().sendPushNotifications(
          userDetails[4],
          userDetails[6]+" has accepted your invite to join the team, "+userDetails[5],"");

            isFromMail = false;
            nextScreen();
          }else {
            Navigator.pop(context);
           // Navigator.pop(context);
            Navigation.navigateWithArgument(
                context, MyRoutes.createPasswordScreen, userDetails);
          }
          /*isFromMail = false;
        nextScreen();*/
        }
        if (Uri.parse(deepLink.fragment).path == MyRoutes.introScreen &&
            Uri.parse(deepLink.fragment).queryParameters["userid"] != null) {
          String? userID = Uri.parse(deepLink.fragment).queryParameters["userid"];
          String? teamID = Uri.parse(deepLink.fragment).queryParameters["teamid"];
          String? emailID = Uri.parse(deepLink.fragment).queryParameters["email"];
          String? fcm = Uri.parse(deepLink.fragment).queryParameters["fcm"];
          String? userRoleId = Uri.parse(deepLink.fragment).queryParameters["userRoleId"];
          String? team = Uri.parse(deepLink.fragment).queryParameters["team"];
          String? player = Uri.parse(deepLink.fragment).queryParameters["player"];
          String? manager = Uri.parse(deepLink.fragment).queryParameters["manager"];
          String? toMail = Uri.parse(deepLink.fragment).queryParameters["toMail"];
          String? toID = Uri.parse(deepLink.fragment).queryParameters["toID"];

          _signUpProvider!.createAccountAsync(userID!, teamID!, emailID!, 3,false,int.parse(userRoleId!));
          EmailService().inits("Invite Declined ","",Constants.gameEventDecline,int.parse(userID),int.parse(userID),int.parse(teamID),"You have declined the invite to join the team, "+team!+".",emailID,team!,"","",player!,"");
          EmailService().inits("Invite Declined ","",Constants.gameEventDeclineManger,int.parse(userID),int.parse(toID!),int.parse(teamID),player+" has declined your invite to join the team, "+team+".",toMail!,"","","",player+" has declined your invitation to join the team, "+team,manager!);


            SendPushNotificationService().sendPushNotifications(
            fcm!,"Invite Declined ",player+" has declined your invite to join the team, "+team);

          isFromMail = false;
          nextScreen();
        }
        if (Uri.parse(deepLink.fragment).path == MyRoutes.splashScreen){
          String? status =
          Uri.parse(deepLink.fragment).queryParameters["status"];
          String? refer =
          Uri.parse(deepLink.fragment).queryParameters["refer"];
          String? userid = Uri.parse(deepLink.fragment).queryParameters["userid"];
          String? eventname = Uri.parse(deepLink.fragment).queryParameters["eventname"];
          String? teamname = Uri.parse(deepLink.fragment).queryParameters["teamname"];
          String? type = Uri.parse(deepLink.fragment).queryParameters["type"];
          String? fcm = Uri.parse(deepLink.fragment).queryParameters["fcm"];
          String? name = Uri.parse(deepLink.fragment).queryParameters["name"];
          String? mail = Uri.parse(deepLink.fragment).queryParameters["mail"];
          String? toMail = Uri.parse(deepLink.fragment).queryParameters["toMail"];
          String? toID = Uri.parse(deepLink.fragment).queryParameters["toID"];
          String? userName = Uri.parse(deepLink.fragment).queryParameters["userName"];
          String? location = Uri.parse(deepLink.fragment).queryParameters["location"];
          String? date = Uri.parse(deepLink.fragment).queryParameters["date"];
            if(status==Constants.accept.toString()){

              String dateformat =
              "${await SharedPrefManager.instance.getStringAsync(Constants.countryCode)}";
              String _addCalendar = await SharedPrefManager.instance.getStringAsync(Constants.addToCalender);
              bool addToCalendar=_addCalendar != null? _addCalendar.toLowerCase()=="true"?true:false:false;
              if(addToCalendar){
                // DateFormat formatter;
                // DateTime scheduledDateTime;
                // if(date.split(" ").last.contains("TBD")){
                //   formatter =  dateformat == "US"
                //       ?DateFormat("MM/dd/yyyy"):dateformat == "CA"?DateFormat("yyyy/MM/dd"): DateFormat("dd/MM/yyyy");
                //   scheduledDateTime = formatter.parse(
                //       date.split(" ").first);
                // }else{
                //   formatter =  dateformat == "US"
                //       ?DateFormat("MM/dd/yyyy h:mma"):dateformat == "CA"?DateFormat("yyyy/MM/dd h:mma"): DateFormat("dd/MM/yyyy h:mma");
                //   scheduledDateTime = formatter.parse(
                //       date);
                // }
                //
                // var _calendarEvent = CalendarEventModel(
                //   eventTitle: eventname,
                //   eventDescription: type,
                //   eventDurationInHours: 3,
                //   statDate: scheduledDateTime,
                //   location: location,
                // );

               // calendarCubit.addToCalendar(_calendarEvent, "1");

                /*Add2Calendar.addEvent2Cal(
                  Event(
                    title: eventname,
                    description: type,
                    location: location,
                    startDate: scheduledDateTime,
                    //endDate: DateTime.now().add(Duration(hours: 3)),
                    endDate: scheduledDateTime.add(Duration(hours:3,)),
                    allDay: false,
                    iosParams: IOSParams(
                      reminder: Duration(minutes: 30),
                    ),
                    androidParams: AndroidParams(
                      //emailInvites: ["master.spaid.app@gmail.com"],
                    ),
                  ),
                );*/
              }

              EmailService().createEventNotification("Response to the Invite","",Constants.gameEventAcceptManager,int.parse(userid!),int.parse(toID!),int.parse(refer!),userName!+" "+ "has accepted your invite of the "+type!+", "+eventname!+" for team "+teamname!+".",toMail!,name!,"","","","","","","","","",userName+" "+ "has accepted your invite of the "+type+", "+eventname+" for team "+teamname,"","",false);
              EmailService().createEventNotification("Response to the Invite","",Constants.gameEventAccept,int.parse(userid),int.parse(userid),int.parse(refer),"You have accepted to join the "+type+", "+eventname+" for team "+teamname+".",mail!,userName,"","","","","","","","","","You have accepted to join the "+type+", "+eventname+" for team "+teamname,"","",false);

              SendPushNotificationService().sendPushNotifications(
                    await SharedPrefManager.instance.getStringAsync(Constants.FCM),
                  "You have accepted to join the "+type+", "+eventname+" for team "+teamname,"");
                SendPushNotificationService().sendPushNotifications(
                    fcm!,
                    userName+" has accepted your invite of the "+type+", "+eventname+" for team "+teamname,"");
            }else if(status==Constants.maybe.toString()){
              EmailService().createEventNotification("Response to the Invite","",Constants.gameEventAcceptManager,int.parse(userid!),int.parse(toID!),int.parse(refer!),userName!+" "+ "has responded to your invite as maybe the "+type!+", "+eventname!+" for team "+teamname!+".",toMail!,name!,"","","","","","","","","",userName+" "+ "has responded to your invite as maybe the "+type+", "+eventname+" for team "+teamname,"","",false);
              EmailService().createEventNotification("Response to the Invite","",Constants.gameEventAccept,int.parse(userid),int.parse(userid),int.parse(refer),"You have responded as maybe to join the "+type+", "+eventname+" for team "+teamname+".",mail!,userName,"","","","","","","","","","You have responded as maybe to join the "+type+", "+eventname+" for team "+teamname,"","",false);

              SendPushNotificationService().sendPushNotifications(
                  await SharedPrefManager.instance.getStringAsync(Constants.FCM),
                  "You have responded as maybe to join the "+type+", "+eventname+" for team "+teamname,"");
              SendPushNotificationService().sendPushNotifications(
                  fcm!,
                  userName+" has responded to your invite as maybe the "+type+", "+eventname+" for team "+teamname,"");
            }else if(status==Constants.reject.toString()){
              EmailService().createEventNotification("Response to the Invite","",Constants.gameEventDeclineManger,int.parse(userid!),int.parse(toID!),int.parse(refer!),userName!+" "+ "has declined your invite of the "+type!+", "+eventname!+" for team "+teamname!+".",toMail!,name!,"","","","","","","","","",userName+" "+ "has declined your invite of the "+type+", "+eventname+" for team "+teamname,"","",false);
              EmailService().createEventNotification("Response to the Invite","",Constants.gameEventDecline,int.parse(userid),int.parse(userid),int.parse(refer),"You have declined to join the "+type+", "+eventname+" for team "+teamname+".",mail!,userName,"","","","","","","","","","You have declined to join the "+type+", "+eventname+" for team "+teamname,"","",false);


              SendPushNotificationService().sendPushNotifications(
                  await SharedPrefManager.instance.getStringAsync(Constants.FCM),
                  "You have declined to join the "+type+", "+eventname+" for team "+teamname,"");
              SendPushNotificationService().sendPushNotifications(
                  fcm!,
                  userName+" has declined your invite of the "+type+", "+eventname+" for team "+teamname,"");
            }

          _splashScreenProvider!.updatePlayerAvalAsync(status!, refer!, userid!,"");
          isFromMail = false;
          nextScreen();
        }
        if (Uri.parse(deepLink.fragment).path ==
            MyRoutes.resetPasswordScreen &&
            Uri.parse(deepLink.fragment).queryParameters["userid"] != null) {
          List<String> userDetails = [];
          String? userID =
          Uri.parse(deepLink.fragment).queryParameters["userid"];
          String? emailID =
          Uri.parse(deepLink.fragment).queryParameters["email"];
          userDetails.add(userID!);
          userDetails.add(emailID!);
          userDetails.add("true");
          Navigator.pop(context);
          Navigation.navigateWithArgument(
              context, MyRoutes.resetPasswordScreen, userDetails);
        }
        if (Uri.parse(deepLink.fragment).path ==
            MyRoutes.signIn ) {

          Navigation.navigateTo(context, MyRoutes.signIn);

        }
        if (Uri.parse(deepLink.fragment).path == MyRoutes.volunteerAvailablityScreen){
          String? status =
          Uri.parse(deepLink.fragment).queryParameters["status"];
          String? refer =
          Uri.parse(deepLink.fragment).queryParameters["refer"];
          String? userid = Uri.parse(deepLink.fragment).queryParameters["userid"];
          String? eventname = Uri.parse(deepLink.fragment).queryParameters["eventname"];
          String? volunteer = Uri.parse(deepLink.fragment).queryParameters["volunteer"];
          String? eventVolunteerTypeId = Uri.parse(deepLink.fragment).queryParameters["eventVolunteerTypeId"];
          String? volunteerTypeId = Uri.parse(deepLink.fragment).queryParameters["volunteerTypeId"];
          String? teamname = Uri.parse(deepLink.fragment).queryParameters["teamname"];
          String? type = Uri.parse(deepLink.fragment).queryParameters["type"];
          String? fcm = Uri.parse(deepLink.fragment).queryParameters["fcm"];
          String? name = Uri.parse(deepLink.fragment).queryParameters["name"];
          String? mail = Uri.parse(deepLink.fragment).queryParameters["mail"];
          String? toMail = Uri.parse(deepLink.fragment).queryParameters["toMail"];
          String? toID = Uri.parse(deepLink.fragment).queryParameters["toID"];
          String? userName = Uri.parse(deepLink.fragment).queryParameters["userName"];
          String? location = Uri.parse(deepLink.fragment).queryParameters["location"];
          String? date = Uri.parse(deepLink.fragment).queryParameters["date"];
          if(status==Constants.accept.toString()){

            EmailService().createEventNotification("Response to the Invite",eventname!,Constants.gameVolunteerAccept,int.parse(userid!),int.parse(toID!),int.parse(refer!),userName!+" has accepted to be a volunteer for the assigned task  that has been Scheduled by "+ name!+ " for the team, "+teamname!,toMail!,name,eventname,"","","",location!,date!,"","","",userName,teamname,volunteer!,false);

            // SendPushNotificationService().sendPushNotifications(
            //     await SharedPrefManager.instance.getStringAsync(Constants.FCM),
            //     "You have accepted to join the "+type+", "+eventname+" for team "+teamname,"");
            SendPushNotificationService().sendPushNotifications(
                fcm!,
                userName+" has accepted to be a volunteer for the assigned task  that has been Scheduled by "+ name+ " for the team, "+teamname,"");
          }else if(status==Constants.maybe.toString()){
            // EmailService().sendSpecificNotificationForMail("Response to the Invite","",AcceptToManager.acceptManager.replaceAll("{{managername}}", name).replaceAll("{{playername}}",userName+" "+ "has responded to your invite as maybe the "+type+", "+eventname+" for team "+teamname),Constants.gameOrEventInfo,int.parse(toID),int.parse(refer),userName+" "+ "has responded to your invite as maybe the "+type+", "+eventname+" for team "+teamname+".",toMail,"");
            //
            // SendPushNotificationService().sendPushNotifications(
            //     await SharedPrefManager.instance.getStringAsync(Constants.FCM),
            //     "You have responded as maybe to join the "+type+", "+eventname+" for team "+teamname,"");
            // SendPushNotificationService().sendPushNotifications(
            //     fcm,
            //     userName+" has responded to your invite as maybe the "+type+", "+eventname+" for team "+teamname,"");
          }else if(status==Constants.reject.toString()){
            EmailService().createEventNotification("Response to the Invite",eventname!,Constants.gameVolunteerDecline,int.parse(userid!),int.parse(toID!),int.parse(refer!),userName!+" has declined to be a volunteer for the assigned task  that has been Scheduled by "+ name!+ " for the team, "+teamname!,toMail!,name,eventname,"","","",location!,date!,"","","",userName,teamname,volunteer!,false);

            // SendPushNotificationService().sendPushNotifications(
            //     await SharedPrefManager.instance.getStringAsync(Constants.FCM),
            //     "You have declined to join the "+type+", "+eventname+" for team "+teamname,"");
            SendPushNotificationService().sendPushNotifications(
                fcm!,
                userName+" has declined to be a volunteer for the assigned task  that has been Scheduled by "+ name+ " for the team, "+teamname,"");
          }

          _splashScreenProvider!.updateVolunteerAvalAsync(eventVolunteerTypeId!,volunteerTypeId!,volunteer!,refer!,userid!,status!);
          isFromMail = false;
          nextScreen();
        }

        /*else if(Uri.parse(deepLink.fragment).path == MyRoutes.createPasswordScreen && Uri.parse(deepLink.fragment).queryParameters["username"] != null){
              String username =
              Uri.parse(deepLink.fragment).queryParameters["username"];
              isFromMail = false;
              Navigation.navigateWithArgument(
                  context, MyRoutes.createPasswordScreen,username);
            }*/
      }
    }, onError: (OnLinkErrorException e) async {
      print(e);
      // Navigator.pushNamed(context, '/error');
    });

    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data.link;

    if (deepLink != null) {
      isFromMail = true;
      if (Uri.parse(deepLink.fragment).path == MyRoutes.createPasswordScreen &&
          Uri.parse(deepLink.fragment).queryParameters["userid"] != null) {
        List<String> userDetails = [];
        String? userID = Uri.parse(deepLink.fragment).queryParameters["userid"];
        String? teamID = Uri.parse(deepLink.fragment).queryParameters["teamid"];
        String? emailID = Uri.parse(deepLink.fragment).queryParameters["email"];
        String? fcm = Uri.parse(deepLink.fragment).queryParameters["fcm"];
        String? userRoleId = Uri.parse(deepLink.fragment).queryParameters["userRoleId"];
        String? team = Uri.parse(deepLink.fragment).queryParameters["team"];
        String? player = Uri.parse(deepLink.fragment).queryParameters["player"];
        String? manager = Uri.parse(deepLink.fragment).queryParameters["manager"];
        String? isMemberExist = Uri.parse(deepLink.fragment).queryParameters["isMemberExist"];
        String? toMail = Uri.parse(deepLink.fragment).queryParameters["toMail"];
        String? toID = Uri.parse(deepLink.fragment).queryParameters["toID"];
        userDetails.add(userID!);
        userDetails.add(teamID!);
        userDetails.add(emailID!);
        userDetails.add(userRoleId!);
        userDetails.add(fcm!);
        userDetails.add(team!);
        userDetails.add(player!);
        userDetails.add(manager!);
        userDetails.add(toMail!);
        userDetails.add(toID!);
        if(isMemberExist=="true"){
          _signUpProvider!.createAccountAsync(userID, teamID, emailID, 2,false,int.parse(userRoleId));
          EmailService().inits("Invite Accepted","",Constants.gameEventAccept,int.parse(userDetails[0]),int.parse(userDetails[0]),int.parse(userDetails[1]),"You have accepted the invite to join the team, "+userDetails[5]+".",emailID,userDetails[5],"","",userDetails[6],"");
          EmailService().inits("Invite Accepted","",Constants.gameEventAcceptManager,int.parse(userDetails[0]),int.parse(userDetails[9]),int.parse(userDetails[1]),userDetails[6]+" has accepted your invite to join the team, "+userDetails[5]+".",toMail,"","","",userDetails[6]+" has accepted your invitation to join the team, "+userDetails[5],userDetails[7]);

          SendPushNotificationService().sendPushNotifications(
              await SharedPrefManager.instance.getStringAsync(Constants.FCM),
              "You have accepted the invite to join the team, "+userDetails[5],"");
          SendPushNotificationService().sendPushNotifications(
              userDetails[4],
              userDetails[6]+" has accepted your invite to join the team, "+userDetails[5],"");

          isFromMail = false;
          nextScreen();
        }else {
          Navigator.pop(context);
          //Navigator.pop(context);
          Navigation.navigateWithArgument(
              context, MyRoutes.createPasswordScreen, userDetails);
        }
        /*isFromMail = false;
        nextScreen();*/
      }
      if (Uri.parse(deepLink.fragment).path == MyRoutes.introScreen &&
          Uri.parse(deepLink.fragment).queryParameters["userid"] != null) {
        String? userID = Uri.parse(deepLink.fragment).queryParameters["userid"];
        String? teamID = Uri.parse(deepLink.fragment).queryParameters["teamid"];
        String? emailID = Uri.parse(deepLink.fragment).queryParameters["email"];
        String? fcm = Uri.parse(deepLink.fragment).queryParameters["fcm"];
        String? userRoleId = Uri.parse(deepLink.fragment).queryParameters["userRoleId"];
        String? team = Uri.parse(deepLink.fragment).queryParameters["team"];
        String? player = Uri.parse(deepLink.fragment).queryParameters["player"];
        String? manager = Uri.parse(deepLink.fragment).queryParameters["manager"];
        String? toMail = Uri.parse(deepLink.fragment).queryParameters["toMail"];
        String? toID = Uri.parse(deepLink.fragment).queryParameters["toID"];

        _signUpProvider!.createAccountAsync(userID!, teamID!, emailID!, 3,false,int.parse(userRoleId!));
        EmailService().inits("Invite Declined ","",Constants.gameEventDecline,int.parse(userID),int.parse(userID),int.parse(teamID),"You have declined the invite to join the team, "+team!+".",emailID,team,"","",player!,"");
        EmailService().inits("Invite Declined ","",Constants.gameEventDeclineManger,int.parse(userID),int.parse(toID!),int.parse(teamID),player+" has declined your invite to join the team, "+team+".",toMail!,"","","",player+" has declined your invitation to join the team, "+team,manager!);


        SendPushNotificationService().sendPushNotifications(
            fcm!,"Invite Declined ",player+" has declined your invite to join the team, "+team);

        isFromMail = false;
        nextScreen();
      }
      if (Uri.parse(deepLink.fragment).path == MyRoutes.splashScreen){
        String? status =
        Uri.parse(deepLink.fragment).queryParameters["status"];
        String? refer =
        Uri.parse(deepLink.fragment).queryParameters["refer"];
        String? userid = Uri.parse(deepLink.fragment).queryParameters["userid"];
        String? eventname = Uri.parse(deepLink.fragment).queryParameters["eventname"];
        String? teamname = Uri.parse(deepLink.fragment).queryParameters["teamname"];
        String? type = Uri.parse(deepLink.fragment).queryParameters["type"];
        String? fcm = Uri.parse(deepLink.fragment).queryParameters["fcm"];
        String? name = Uri.parse(deepLink.fragment).queryParameters["name"];
        String? mail = Uri.parse(deepLink.fragment).queryParameters["mail"];
        String? toMail = Uri.parse(deepLink.fragment).queryParameters["toMail"];
        String? toID = Uri.parse(deepLink.fragment).queryParameters["toID"];
        String? userName = Uri.parse(deepLink.fragment).queryParameters["userName"];
        String? location = Uri.parse(deepLink.fragment).queryParameters["location"];
        String? date = Uri.parse(deepLink.fragment).queryParameters["date"];
        if(status==Constants.accept.toString()){
          String dateformat =
              "${await SharedPrefManager.instance.getStringAsync(Constants.countryCode)}";
          String _addCalendar = await SharedPrefManager.instance.getStringAsync(Constants.addToCalender);
          bool addToCalendar=_addCalendar != null? _addCalendar.toLowerCase()=="true"?true:false:false;
          if(addToCalendar){
            // DateFormat formatter;
            // DateTime scheduledDateTime;
            // if(date.split(" ").last.contains("TBD")){
            //   formatter =  dateformat == "US"
            //       ?DateFormat("MM/dd/yyyy"):dateformat == "CA"?DateFormat("yyyy/MM/dd"): DateFormat("dd/MM/yyyy");
            //   scheduledDateTime = formatter.parse(
            //       date.split(" ").first);
            // }else{
            //   formatter =  dateformat == "US"
            //       ?DateFormat("MM/dd/yyyy h:mma"):dateformat == "CA"?DateFormat("yyyy/MM/dd h:mma"): DateFormat("dd/MM/yyyy h:mma");
            //   scheduledDateTime = formatter.parse(
            //       date);
            // }
            // var _calendarEvent = CalendarEventModel(
            //   eventTitle: eventname,
            //   eventDescription: type,
            //   eventDurationInHours: 3,
            //   statDate: scheduledDateTime,
            //   location: location,
            // );

           // calendarCubit.addToCalendar(_calendarEvent, "1");
           /* Add2Calendar.addEvent2Cal(
              Event(
                title: eventname,
                description: type,
                location: location,
                startDate: scheduledDateTime,
                //endDate: DateTime.now().add(Duration(hours: 3)),
                endDate: scheduledDateTime.add(Duration(hours:3,)),
                allDay: false,
                iosParams: IOSParams(
                  reminder: Duration(minutes: 30),
                ),
                androidParams: AndroidParams(
                  // emailInvites: ["master.spaid.app@gmail.com"],
                ),
              ),
            );*/
          }

          EmailService().createEventNotification("Response to the Invite","",Constants.gameEventAcceptManager,int.parse(userid!),int.parse(toID!),int.parse(refer!),userName!+" "+ "has accepted your invite of the "+type!+", "+eventname!+" for team "+teamname!+".",toMail!,name!,"","","","","","","","","",userName+" "+ "has accepted your invite of the "+type+", "+eventname+" for team "+teamname,"","",false);
          EmailService().createEventNotification("Response to the Invite","",Constants.gameEventAccept,int.parse(userid),int.parse(userid),int.parse(refer),"You have accepted to join the "+type+", "+eventname+" for team "+teamname+".",mail!,userName,"","","","","","","","","","You have accepted to join the "+type+", "+eventname+" for team "+teamname,"","",false);

          SendPushNotificationService().sendPushNotifications(
              await SharedPrefManager.instance.getStringAsync(Constants.FCM),
              "You have accepted to join the "+type+", "+eventname+" for team "+teamname,"");
          SendPushNotificationService().sendPushNotifications(
              fcm!,
              userName+" has accepted your invite of the "+type+", "+eventname+" for team "+teamname,"");
        }else if(status==Constants.maybe.toString()){
          EmailService().createEventNotification("Response to the Invite","",Constants.gameEventAcceptManager,int.parse(userid!),int.parse(toID!),int.parse(refer!),userName!+" "+ "has responded to your invite as maybe the "+type!+", "+eventname!+" for team "+teamname!+".",toMail!,name!,"","","","","","","","","",userName+" "+ "has responded to your invite as maybe the "+type+", "+eventname+" for team "+teamname,"","",false);
          EmailService().createEventNotification("Response to the Invite","",Constants.gameEventAccept,int.parse(userid),int.parse(userid),int.parse(refer),"You have responded as maybe to join the "+type+", "+eventname+" for team "+teamname+".",mail!,userName,"","","","","","","","","","You have responded as maybe to join the "+type+", "+eventname+" for team "+teamname,"","",false);

          SendPushNotificationService().sendPushNotifications(
              await SharedPrefManager.instance.getStringAsync(Constants.FCM),
              "You have responded as maybe to join the "+type+", "+eventname+" for team "+teamname,"");
          SendPushNotificationService().sendPushNotifications(
              fcm!,
              userName+" has responded to your invite as maybe the "+type+", "+eventname+" for team "+teamname,"");
        }else if(status==Constants.reject.toString()){
          EmailService().createEventNotification("Response to the Invite","",Constants.gameEventDeclineManger,int.parse(userid!),int.parse(toID!),int.parse(refer!),userName!+" "+ "has declined your invite of the "+type!+", "+eventname!+" for team "+teamname!+".",toMail!,name!,"","","","","","","","","",userName+" "+ "has declined your invite of the "+type+", "+eventname+" for team "+teamname,"","",false);
          EmailService().createEventNotification("Response to the Invite","",Constants.gameEventDecline,int.parse(userid),int.parse(userid),int.parse(refer),"You have declined to join the "+type+", "+eventname+" for team "+teamname+".",mail!,userName,"","","","","","","","","","You have declined to join the "+type+", "+eventname+" for team "+teamname,"","",false);

          SendPushNotificationService().sendPushNotifications(
              await SharedPrefManager.instance.getStringAsync(Constants.FCM),
              "You have declined to join the "+type+", "+eventname+" for team "+teamname,"");
          SendPushNotificationService().sendPushNotifications(
              fcm!,
              userName+" has declined your invite of the "+type+", "+eventname+" for team "+teamname,"");
        }

        _splashScreenProvider!.updatePlayerAvalAsync(status!, refer!, userid!,"");
        isFromMail = false;
        nextScreen();
      }
      if (Uri.parse(deepLink.fragment).path ==
          MyRoutes.resetPasswordScreen &&
          Uri.parse(deepLink.fragment).queryParameters["userid"] != null) {
        List<String> userDetails = [];
        String? userID =
        Uri.parse(deepLink.fragment).queryParameters["userid"];
        String? emailID =
        Uri.parse(deepLink.fragment).queryParameters["email"];
        userDetails.add(userID!);
        userDetails.add(emailID!);
        userDetails.add("true");
        Navigator.pop(context);
        Navigation.navigateWithArgument(
            context, MyRoutes.resetPasswordScreen, userDetails);
      }
      if (Uri.parse(deepLink.fragment).path ==
          MyRoutes.signIn ) {

        Navigation.navigateTo(context, MyRoutes.signIn);

      }
      if (Uri.parse(deepLink.fragment).path == MyRoutes.volunteerAvailablityScreen){
        String? status =
        Uri.parse(deepLink.fragment).queryParameters["status"];
        String? refer =
        Uri.parse(deepLink.fragment).queryParameters["refer"];
        String? userid = Uri.parse(deepLink.fragment).queryParameters["userid"];
        String? eventname = Uri.parse(deepLink.fragment).queryParameters["eventname"];
        String? volunteer = Uri.parse(deepLink.fragment).queryParameters["volunteer"];
        String? eventVolunteerTypeId = Uri.parse(deepLink.fragment).queryParameters["eventVolunteerTypeId"];
        String? volunteerTypeId = Uri.parse(deepLink.fragment).queryParameters["volunteerTypeId"];
        String? teamname = Uri.parse(deepLink.fragment).queryParameters["teamname"];
        String? type = Uri.parse(deepLink.fragment).queryParameters["type"];
        String? fcm = Uri.parse(deepLink.fragment).queryParameters["fcm"];
        String? name = Uri.parse(deepLink.fragment).queryParameters["name"];
        String? mail = Uri.parse(deepLink.fragment).queryParameters["mail"];
        String? toMail = Uri.parse(deepLink.fragment).queryParameters["toMail"];
        String? toID = Uri.parse(deepLink.fragment).queryParameters["toID"];
        String? userName = Uri.parse(deepLink.fragment).queryParameters["userName"];
        String? location = Uri.parse(deepLink.fragment).queryParameters["location"];
        String? date = Uri.parse(deepLink.fragment).queryParameters["date"];
        if(status==Constants.accept.toString()){

          EmailService().createEventNotification("Response to the Invite",eventname!,Constants.gameVolunteerAccept,int.parse(userid!),int.parse(toID!),int.parse(refer!),userName!+" has accepted to be a volunteer for the assigned task  that has been Scheduled by "+ name!+ " for the team, "+teamname!,toMail!,name,eventname,"","","",location!,date??"","","","",userName,teamname,volunteer!,false);

          // SendPushNotificationService().sendPushNotifications(
          //     await SharedPrefManager.instance.getStringAsync(Constants.FCM),
          //     "You have accepted to join the "+type+", "+eventname+" for team "+teamname,"");
          SendPushNotificationService().sendPushNotifications(
              fcm!,
              userName+" has accepted to be a volunteer for the assigned task  that has been Scheduled by "+ name+ " for the team, "+teamname,"");
        }else if(status==Constants.maybe.toString()){
          // EmailService().sendSpecificNotificationForMail("Response to the Invite","",AcceptToManager.acceptManager.replaceAll("{{managername}}", name).replaceAll("{{playername}}",userName+" "+ "has responded to your invite as maybe the "+type+", "+eventname+" for team "+teamname),Constants.gameOrEventInfo,int.parse(toID),int.parse(refer),userName+" "+ "has responded to your invite as maybe the "+type+", "+eventname+" for team "+teamname+".",toMail,"");
          //
          // SendPushNotificationService().sendPushNotifications(
          //     await SharedPrefManager.instance.getStringAsync(Constants.FCM),
          //     "You have responded as maybe to join the "+type+", "+eventname+" for team "+teamname,"");
          // SendPushNotificationService().sendPushNotifications(
          //     fcm,
          //     userName+" has responded to your invite as maybe the "+type+", "+eventname+" for team "+teamname,"");
        }else if(status==Constants.reject.toString()){
          EmailService().createEventNotification("Response to the Invite",eventname!,Constants.gameVolunteerDecline,int.parse(userid!),int.parse(toID!),int.parse(refer!),userName!+" has declined to be a volunteer for the assigned task  that has been Scheduled by "+ name!+ " for the team, "+teamname!,toMail!,name,eventname,"","","",location!,date!,"","","",userName,teamname,volunteer!,false);

          // SendPushNotificationService().sendPushNotifications(
          //     await SharedPrefManager.instance.getStringAsync(Constants.FCM),
          //     "You have declined to join the "+type+", "+eventname+" for team "+teamname,"");
          SendPushNotificationService().sendPushNotifications(
              fcm!,
              userName+" has declined to be a volunteer for the assigned task  that has been Scheduled by "+ name+ " for the team, "+teamname,"");
        }

        _splashScreenProvider!.updateVolunteerAvalAsync(eventVolunteerTypeId!,volunteerTypeId!,volunteer!,refer!,userid!,status!);
        isFromMail = false;
        nextScreen();
      }

      /*else if(Uri.parse(deepLink.fragment).path == MyRoutes.createPasswordScreen && Uri.parse(deepLink.fragment).queryParameters["username"] != null){
              String username =
              Uri.parse(deepLink.fragment).queryParameters["username"];
              isFromMail = false;
              Navigation.navigateWithArgument(
                  context, MyRoutes.createPasswordScreen,username);
            }*/
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _timerLink = new Timer(
        const Duration(milliseconds: 1000),
        () {
          //_dynamicLinkService.retrieveDynamicLink(context);

          /* WidgetsBinding.instance.addPostFrameCallback((_) {
    });*/
        },
      );
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_timerLink != null) {
      _timerLink!.cancel();
    }
    super.dispose();
  }

  void initDynamicLinksAsync() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink.link;

      if (deepLink != null) {
        if (deepLink.fragment.contains(MyRoutes.selectTeamScreen)) {
          //Navigator.pushNamed(context, MyRoutes.selectTeamScreen);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SelectTeamScreen()));
          /*Navigation.navigateWithArgument(
                context, MyRoutes.selectTeamScreen, Constants.navigateIdZero);*/

        }
      }
    }, onError: (OnLinkErrorException e) async {
      print(e.message);
    });

    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    if (data != null) {
      final Uri deepLink = data.link;

      if (deepLink != null) {
        // Navigator.pushNamed(context, deepLink.path);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: MyColors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            /*Text(
              MyStrings.appName,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),*/
            Image.asset(MyImages.spaid_logo,width:ImageSize.logoSmall ,),
            SizedBox(
              height: 30,
            ),
            SvgPicture.asset(
              MyImages.splash1,
              height: size.height * ImageSize.splashImageSize,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void onSuccess(any, {int? reqId}) async {
    if (isFromMail == false) {
      nextScreen();

    }
    super.onSuccess(any,reqId: 0);
  }

  void nextScreen() async {
    String rememberme= await SharedPrefManager.instance.getStringAsync(Constants.rememberMe);
    String teamName= await SharedPrefManager.instance.getStringAsync(Constants.teamName);
    if (rememberme != null && rememberme.isNotEmpty) {
      if (teamName == null && teamName.isEmpty) {
        Navigation.navigateWithArgument(
            context, MyRoutes.selectTeamScreen, Constants.navigateIdZero);
      } else {
        Navigation.navigateWithArgument(
            context, MyRoutes.homeScreen, Constants.navigateIdZero);
      }
    } else {
      // context.vxNav.push(Uri(path: MyRoutes.introScreen));
      Navigation.navigateTo(context, MyRoutes.introScreen);
    }
  }
   Future<List<Map<String, dynamic>>> loadImages() async {
     List<Map<String, dynamic>> files = [];
     FirebaseStorage storage = FirebaseStorage.instance;

     final ListResult result = await storage.ref().child('image/').listAll();
     final List<Reference> allFiles = result.items;

     await Future.forEach<Reference>(allFiles, (file) async {
       final String fileUrl = await file.getDownloadURL();
       final FullMetadata fileMeta = await file.getMetadata();

       print(fileUrl);
       files.add({
         "url": fileUrl,
         "path": file.fullPath,
         "reference": file,
         "extension": fileMeta.customMetadata['extension'] ?? '',
         "title": fileMeta.customMetadata['title'] ?? '',
         "description":
         fileMeta.customMetadata['description'] ?? ''
       });

     });
     Constants.imagefiles=files;

     return files;
   }
   Future<List<Map<String, dynamic>>> loadVideos() async {
     List<Map<String, dynamic>> files = [];
     FirebaseStorage storage = FirebaseStorage.instance;

     final ListResult result = await storage.ref().child('video/').listAll();
     final List<Reference> allFiles = result.items;

     await Future.forEach<Reference>(allFiles, (file) async {
       final String fileUrl = await file.getDownloadURL();
       final FullMetadata fileMeta = await file.getMetadata();

       print(fileUrl);
       files.add({
         "url": fileUrl,
         "path": file.fullPath,
         "reference": file,
         "extension": fileMeta.customMetadata['extension'] ?? '',
         "title": fileMeta.customMetadata['title'] ?? '',
         "description":
         fileMeta.customMetadata['description'] ?? ''
       });

     });
     Constants.videofiles=files;

     return files;
   }

   Future<List<Map<String, dynamic>>> loadFiles() async {
     List<Map<String, dynamic>> files = [];
     FirebaseStorage storage = FirebaseStorage.instance;

     final ListResult result = await storage.ref().child('file/').listAll();
     final List<Reference> allFiles = result.items;

     await Future.forEach<Reference>(allFiles, (file) async {
       final String fileUrl = await file.getDownloadURL();
       final FullMetadata fileMeta = await file.getMetadata();

       print(fileUrl);
       files.add({
         "url": fileUrl,
         "path": file.fullPath,
         "reference": file,
         "extension": fileMeta.customMetadata['extension'] ?? '',
         "title": fileMeta.customMetadata['title'] ?? '',
         "description":
         fileMeta.customMetadata['description'] ?? ''
       });

     });
     Constants.documentfile=files;

     return files;
   }

}

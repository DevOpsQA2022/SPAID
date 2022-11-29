import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:skeletons/skeletons.dart';
import 'package:spaid/base/base_state.dart';
import 'package:spaid/model/response/base_response.dart';
import 'package:spaid/model/response/notification_response/notification_response.dart';
import 'package:spaid/model/response/signup_response/validate_user_response.dart';
import 'package:spaid/service/email_service.dart';
import 'package:spaid/service/send_push_notification_service.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/support/images.dart';
import 'package:spaid/support/response_ids.dart';
import 'package:spaid/support/responsive.dart';
import 'package:spaid/support/style_sizes.dart';
import 'package:spaid/ui/home_screen/event_listview/event_listview_provider.dart';
import 'package:spaid/ui/splash_screen/splash_screen_provider.dart';
import 'package:spaid/utils/code_snippet.dart';
import 'package:spaid/utils/shared_pref_manager.dart';
import 'package:spaid/widgets/ProgressBar.dart';
import 'package:spaid/widgets/calendar_cubit.dart';
import 'package:spaid/widgets/calendar_event_model.dart';
import 'package:spaid/widgets/custom_background/custom_tab_bar.dart';
import 'package:spaid/widgets/custom_background/custom_web_background_card.dart';
import 'package:spaid/widgets/notification_card.dart';
import 'package:spaid/support/email_template.dart';


import 'notification_screen_provider.dart';

class NotificationListviewScreen extends StatefulWidget {
  @override
  _NotificationListviewScreenState createState() =>
      _NotificationListviewScreenState();
}


class _NotificationListviewScreenState
    extends BaseState<NotificationListviewScreen> {
  //region Private Members
  NotificationProvider? _notificationProvider;
  SplashScreenProvider? _splashScreenProvider;
  NotificationResponse? _notificationResponse ;
  List<UserNotificationList> teamInviteNotificationList=[];
  List<UserNotificationList> gameInviteNotificationList=[];
  List<UserNotificationList> volunteerInviteNotificationList=[];
  List<UserNotificationList> reminderNotificationList=[];
  List<UserNotificationList> notificationList=[];
  String? userID,teamName,userMail,userName,dateformat,_addCalendar,calendarId;
  bool? isLoading,addToCalendar;
  List<TextEditingController> teamInviteNoteControl=[];
  List<TextEditingController> gameInviteNoteControl=[];
  List<TextEditingController> reminderNoteControl=[];
  List<TextEditingController> noteControl=[];
  EventListviewProvider? _eventListviewProvider;
  CalendarCubit? calendarCubit;

//endregion

  @override
  void initState() {
    super.initState();

    _notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
    _splashScreenProvider = Provider.of<SplashScreenProvider>(context, listen: false);
    calendarCubit = Provider.of<CalendarCubit>(context, listen: false);
    _eventListviewProvider =
        Provider.of<EventListviewProvider>(context, listen: false);
    _notificationProvider!.listener = this;
    _splashScreenProvider!.listener = this;
    // _eventListviewProvider.listener = this;
    _getDataAsync();
    isLoading=true;
    _notificationProvider!.init(context);
    _notificationProvider!.getNotificationAsync();
  }
  _getDataAsync() async {
    try {
      userID = await SharedPrefManager.instance.getStringAsync(Constants.userIdNo);
      teamName = await SharedPrefManager.instance.getStringAsync(Constants.teamName);
      userMail = await SharedPrefManager.instance.getStringAsync(Constants.userId);
      userName = await SharedPrefManager.instance.getStringAsync(Constants.userName);
      calendarId = await SharedPrefManager.instance.getStringAsync(Constants.calendarId);
      _addCalendar = await SharedPrefManager.instance.getStringAsync(Constants.addToCalender);
      addToCalendar=_addCalendar != null? _addCalendar!.toLowerCase()=="true"?true:false:false;

      dateformat =
      "${await SharedPrefManager.instance.getStringAsync(Constants.countryCode)}";
      setState(() {

      });
    } catch (e) {
      print(e);
    }
  }
  @override
  void onSuccess(any, {required int reqId}) {
    isLoading=false;
    ProgressBar.instance.stopProgressBar(context);
    super.onSuccess(any,reqId: 0);
    switch (reqId) {
      case ResponseIds.NOTIFICATION_SCREEN:
        NotificationResponse _response = any as NotificationResponse;
        if (_response.result!.userNotificationList!.isNotEmpty) {
          setState(() {
            _notificationResponse=_response;
            teamInviteNotificationList=[];
            gameInviteNotificationList=[];
            volunteerInviteNotificationList=[];
            reminderNotificationList=[];
            notificationList=[];
            for(int i=0;i<_response.result!.userNotificationList!.length;i++){
              if(_response.result!.userNotificationList![i].notificationTypeId==Constants.teamInvite){
                teamInviteNotificationList.add(_response.result!.userNotificationList![i]);
              }if(_response.result!.userNotificationList![i].notificationTypeId==Constants.gameOrEventRequest){
                gameInviteNotificationList.add(_response.result!.userNotificationList![i]);
              }if(_response.result!.userNotificationList![i].notificationTypeId==Constants.createTeam
                  || _response.result!.userNotificationList![i].notificationTypeId==Constants.createGameOrEvent
                  || _response.result!.userNotificationList![i].notificationTypeId==Constants.gameOrEventInfo
                  || _response.result!.userNotificationList![i].notificationTypeId==Constants.cancelGameOrEvent
                  || _response.result!.userNotificationList![i].notificationTypeId==Constants.gameStart
                  || _response.result!.userNotificationList![i].notificationTypeId==Constants.gameEnd
                  || _response.result!.userNotificationList![i].notificationTypeId==Constants.closedGameOrEvent
                  || _response.result!.userNotificationList![i].notificationTypeId==Constants.gameVolunteerAccept
                  || _response.result!.userNotificationList![i].notificationTypeId==Constants.gameEventDecline
                  || _response.result!.userNotificationList![i].notificationTypeId==Constants.gameEventDeclineManger
                  || _response.result!.userNotificationList![i].notificationTypeId==Constants.gameEventAccept
                  || _response.result!.userNotificationList![i].notificationTypeId==Constants.gameEventAcceptManager
                  || _response.result!.userNotificationList![i].notificationTypeId==Constants.gameVolunteerDecline){
                notificationList.add(_response.result!.userNotificationList![i]);
              }if(_response.result!.userNotificationList![i].notificationTypeId==Constants.reminder){
                reminderNotificationList.add(_response.result!.userNotificationList![i]);
              }
              if(_response.result!.userNotificationList![i].notificationTypeId==Constants.gameVolunteerInvite){
                volunteerInviteNotificationList.add(_response.result!.userNotificationList![i]);
              }
            }

          });

//          CodeSnippet.instance.showMsg(MyStrings.signUpSuccess);
        } else{
          setState(() {
            _notificationResponse=null;
          });
        }/*else if (_response.status == Constants.failed) {
          //CodeSnippet.instance.showMsg(_response.errorMessage);
          print("400");
        } else {
          //CodeSnippet.instance.showMsg(_response.errorMessage);
          print("else");
        }*/
        break;
      case ResponseIds.PLAYER_MAIL_RESPONSE:
        ValidateUserResponse _response = any as ValidateUserResponse;
        if (_response.responseResult == Constants.success) {
          setState(() {
            _notificationProvider!.getNotificationAsync();

          });

        } else if (_response.responseResult == Constants.failed) {
          //showError(_response.saveErrors[0].errorMessage);
          CodeSnippet.instance.showMsg(_response.saveErrors![0].errorMessage!);
        } else {
          // CodeSnippet.instance.showMsg(MyStrings.signUpFailed);
        }
        break;
    }
  }

  @override
  void onFailure(BaseResponse error) {
    setState(() {
      isLoading=false;
    });
    ProgressBar.instance.stopProgressBar(context);
    CodeSnippet.instance.showMsg(error.errorMessage!);
  }

  @override
  Widget build(BuildContext context) {
    return  WebCard(
      marginVertical: 20,
      marginhorizontal: 40,
      child: Padding(
        padding: EdgeInsets.all(  getValueForScreenType<bool>(
          context: context,
          mobile: false,
          tablet: true,
          desktop: true,) ?  PaddingSize.headerPadding1 :  PaddingSize.headerPadding2 ),
        child: Scaffold(
          backgroundColor: MyColors.white,
          body: SafeArea(
            child:isLoading!?SkeletonListView():_notificationResponse == null || _notificationResponse!.result!.userNotificationList!.isEmpty  ?
            Container(
              alignment: Alignment.center,
              child: EmptyWidget(
                image: null,
                packageImage: PackageImage.Image_3,
                title: 'No Notification',
                subTitle: null,
                titleTextStyle: TextStyle(
                  fontSize: 22,
                  color: Color(0xff9da9c7),
                  fontWeight: FontWeight.w500,
                ),
                subtitleTextStyle: TextStyle(
                  fontSize: 14,
                  color: Color(0xffabb8d6),
                ),
              ),
            ):
             SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  // mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(height: 10,),
                    if(teamInviteNotificationList.isNotEmpty || gameInviteNotificationList.isNotEmpty || volunteerInviteNotificationList.isNotEmpty)
                    ExpansionTile(
                        title: Text("Invites"),
                        initiallyExpanded: false,
                        textColor: MyColors.kPrimaryColor,
                        iconColor: MyColors.kPrimaryColor,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Column(
                              children: [
                                if(teamInviteNotificationList.isNotEmpty)
                                ExpansionTile(
                                    title: Text("Team invites"),
                                    initiallyExpanded: false,
                                    textColor: MyColors.kPrimaryColor,
                                    iconColor: MyColors.kPrimaryColor,
                                    children: <Widget>[
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: teamInviteNotificationList.isEmpty ? 0 : teamInviteNotificationList.length,
                                        itemBuilder: (context, index) {
                                          teamInviteNoteControl.add(TextEditingController());
                                          return NotificationCard(

                                            noteControler: teamInviteNoteControl[index],
                                            title: teamInviteNotificationList[index].contentText,
                                            body:teamInviteNotificationList[index].contentText,
                                            //noteStatus:true,
                                            noteStatus:teamInviteNotificationList[index].IsNotesRequired,
                                            //buttonstatus:"Active",
                                            buttonstatus: teamInviteNotificationList[index].notificationTypeId==Constants.gameOrEventRequest?"Active":"InActive",
                                            buttonStatusClosed: teamInviteNotificationList[index].notificationTypeId==Constants.closedGameOrEvent?"Active":"InActive",
                                            onClick: (status,note) async {
                                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                                ProgressBar.instance.showProgressbar(context);
                                              });
                                              if(status==Constants.accept){
                                                EmailService().createEventNotification("Response to the Invite","",Constants.gameEventAcceptManager,teamInviteNotificationList[index].userID!,int.parse(userID!),teamInviteNotificationList[index].referenceTableId!,userName!+" "+ "has accepted your invite of the "+(teamInviteNotificationList[index].eventType==Constants.event?"Event":"Game")+", "+teamInviteNotificationList[index].eventName!+" for team "+teamInviteNotificationList[index].teamName!+".",teamInviteNotificationList[index].email!,teamInviteNotificationList[index].name!,"","","","","","","","","",userName!+" "+ "has accepted your invite of the "+(teamInviteNotificationList[index].eventType==Constants.event?"Event":"Game")+", "+teamInviteNotificationList[index].eventName!+" for team "+teamInviteNotificationList[index].teamName!,"","",false);
                                                EmailService().createEventNotification("Response to the Invite","",Constants.gameEventAccept,teamInviteNotificationList[index].userID!,teamInviteNotificationList[index].userID!,teamInviteNotificationList[index].referenceTableId!,"You have accepted to join the "+(teamInviteNotificationList[index].eventType==Constants.event?"Event":"Game")+", "+teamInviteNotificationList[index].eventName!+" for team "+teamInviteNotificationList[index].teamName!+".",userMail!,userName!,"","","","","","","","","","You have accepted to join the "+(teamInviteNotificationList[index].eventType==Constants.event?"Event":"Game")+", "+teamInviteNotificationList[index].eventName!+" for team "+teamInviteNotificationList[index].teamName!,"","",false);

                                                SendPushNotificationService().sendPushNotifications(
                                                    await SharedPrefManager.instance.getStringAsync(Constants.FCM),
                                                    "You have accepted to join the "+(teamInviteNotificationList[index].eventType==Constants.event?"Event":"Game")+", "+teamInviteNotificationList[index].eventName!+" for team "+teamInviteNotificationList[index].teamName!,"");
                                                SendPushNotificationService().sendPushNotifications(
                                                    teamInviteNotificationList[index].fcm!,
                                                    userName!+" has accepted your invite of the "+(teamInviteNotificationList[index].eventType==Constants.event?"Event":"Game")+", "+teamInviteNotificationList[index].eventName!+" for team "+teamInviteNotificationList[index].teamName!,"");
                                              }else if(status==Constants.maybe){
                                                EmailService().createEventNotification("Response to the Invite","",Constants.gameEventAcceptManager,teamInviteNotificationList[index].userID!,int.parse(userID!),teamInviteNotificationList[index].referenceTableId!,userName!+" "+ "has responded to your invite as maybe the "+(teamInviteNotificationList[index].eventType==Constants.event?"Event":"Game")+", "+teamInviteNotificationList[index].eventName!+" for team "+teamInviteNotificationList[index].teamName!+".",teamInviteNotificationList[index].email!,teamInviteNotificationList[index].name!,"","","","","","","","","",userName!+" "+ "has responded to your invite as maybe the "+(teamInviteNotificationList[index].eventType==Constants.event?"Event":"Game")+", "+teamInviteNotificationList[index].eventName!+" for team "+teamInviteNotificationList[index].teamName!,"","",false);
                                                EmailService().createEventNotification("Response to the Invite","",Constants.gameEventAccept,teamInviteNotificationList[index].userID!,teamInviteNotificationList[index].userID!,teamInviteNotificationList[index].referenceTableId!,"You have responded as maybe to join the "+(teamInviteNotificationList[index].eventType==Constants.event?"Event":"Game")+", "+teamInviteNotificationList[index].eventName!+" for team "+teamInviteNotificationList[index].teamName!+".",userMail!,userName!,"","","","","","","","","","You have responded as maybe to join the "+(teamInviteNotificationList[index].eventType==Constants.event?"Event":"Game")+", "+teamInviteNotificationList[index].eventName!+" for team "+teamInviteNotificationList[index].teamName!,"","",false);

                                                SendPushNotificationService().sendPushNotifications(
                                                    await SharedPrefManager.instance.getStringAsync(Constants.FCM),
                                                    "You have responded as maybe to join the "+(teamInviteNotificationList[index].eventType==Constants.event?"Event":"Game")+", "+teamInviteNotificationList[index].eventName!+" for team "+teamInviteNotificationList[index].teamName!,"");
                                                SendPushNotificationService().sendPushNotifications(
                                                    teamInviteNotificationList[index].fcm!,
                                                    userName!+" has responded to your invite as maybe the "+(teamInviteNotificationList[index].eventType==Constants.event?"Event":"Game")+", "+teamInviteNotificationList[index].eventName!+" for team "+teamInviteNotificationList[index].teamName!,"");
                                              }else if(status==Constants.reject){
                                                EmailService().createEventNotification("Response to the Invite","",Constants.gameEventDeclineManger,teamInviteNotificationList[index].userID!,int.parse(userID!),teamInviteNotificationList[index].referenceTableId!,userName!+" "+ "has declined your invite of the "+(teamInviteNotificationList[index].eventType==Constants.event?"Event":"Game")+", "+teamInviteNotificationList[index].eventName!+" for team "+teamInviteNotificationList[index].teamName!+".",teamInviteNotificationList[index].email!,teamInviteNotificationList[index].name!,"","","","","","","","","",userName!+" "+ "has declined your invite of the "+(teamInviteNotificationList[index].eventType==Constants.event?"Event":"Game")+", "+teamInviteNotificationList[index].eventName!+" for team "+teamInviteNotificationList[index].teamName!,"","",false);
                                                EmailService().createEventNotification("Response to the Invite","",Constants.gameEventDecline,teamInviteNotificationList[index].userID!,teamInviteNotificationList[index].userID!,teamInviteNotificationList[index].referenceTableId!,"You have declined to join the "+(teamInviteNotificationList[index].eventType==Constants.event?"Event":"Game")+", "+teamInviteNotificationList[index].eventName!+" for team "+teamInviteNotificationList[index].teamName!+".",userMail!,userName!,"","","","","","","","","","You have declined to join the "+(teamInviteNotificationList[index].eventType==Constants.event?"Event":"Game")+", "+teamInviteNotificationList[index].eventName!+" for team "+teamInviteNotificationList[index].teamName!,"","",false);


                                                SendPushNotificationService().sendPushNotifications(
                                                    await SharedPrefManager.instance.getStringAsync(Constants.FCM),
                                                    "You have declined to join the "+(teamInviteNotificationList[index].eventType==Constants.event?"Event":"Game")+", "+teamInviteNotificationList[index].eventName!+" for team "+teamInviteNotificationList[index].teamName!,"");
                                                SendPushNotificationService().sendPushNotifications(
                                                    teamInviteNotificationList[index].fcm!,
                                                    userName!+" has declined your invite of the "+(teamInviteNotificationList[index].eventType==Constants.event?"Event":"Game")+", "+teamInviteNotificationList[index].eventName!+" for team "+teamInviteNotificationList[index].teamName!,"");
                                              }

                                              teamInviteNoteControl[index].clear();
                                              _splashScreenProvider!.updatePlayerAvalAsync(status.toString(), teamInviteNotificationList[index].referenceTableId.toString(), userID!,note);
                                              teamInviteNotificationList.removeAt(index);

                                            },
                                            onUpdateStatus: (status){
                                              if(status==Constants.accept) {
                                                _eventListviewProvider!.updateGameStatusAsync(
                                                    teamInviteNotificationList[index].referenceTableId!, "",
                                                    Constants.completed);
                                              }
                                              _notificationProvider!.removeNotificationAsync(teamInviteNotificationList[index].notificationId!,false);
                                              teamInviteNotificationList.removeAt(index);

                                            },
                                            onDelete: (){
                                              _notificationProvider!.removeNotificationAsync(teamInviteNotificationList[index].notificationId!,true);
                                              teamInviteNotificationList.removeAt(index);

                                            },
                                          );
                                        },
                                      ),


                                    ]),
                                if(gameInviteNotificationList.isNotEmpty)
                                  ExpansionTile(
                                    title: Text("Game/Event invites"),
                                    initiallyExpanded: false,
                                    textColor: MyColors.kPrimaryColor,
                                    iconColor: MyColors.kPrimaryColor,
                                    children: <Widget>[
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: gameInviteNotificationList.isEmpty ? 0 : gameInviteNotificationList.length,
                                        itemBuilder: (context, index) {
                                          gameInviteNoteControl.add(TextEditingController());
                                          return NotificationCard(

                                            noteControler: gameInviteNoteControl[index],
                                            title: gameInviteNotificationList[index].contentText,
                                            body:gameInviteNotificationList[index].contentText,
                                            //noteStatus:true,
                                            noteStatus:gameInviteNotificationList[index].IsNotesRequired,
                                            //buttonstatus:"Active",
                                            buttonstatus: gameInviteNotificationList[index].notificationTypeId==Constants.gameOrEventRequest?"Active":"InActive",
                                            buttonStatusClosed: gameInviteNotificationList[index].notificationTypeId==Constants.closedGameOrEvent?"Active":"InActive",
                                            onClick: (status,note) async {
                                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                                ProgressBar.instance.showProgressbar(context);
                                              });
                                              if(status==Constants.accept){
                                                if(addToCalendar!){
                                                  var location=gameInviteNotificationList[index].contentText!.split(" at");
                                                  var date=location.first.split("on ");
                                                  print(dateformat);
                                                  print(date.last);
                                                  print(date.last.split(" ").first);
                                                  print(date.last.split(" ").last.contains("TBD"));
                                                  DateFormat formatter;
                                                  DateTime scheduledDateTime;
                                                  if(date.last.split(" ").last.contains("TBD")){
                                                    formatter =  dateformat == "US"
                                                        ?DateFormat("MM/dd/yyyy"):dateformat == "CA"?DateFormat("yyyy/MM/dd"): DateFormat("dd/MM/yyyy");
                                                    scheduledDateTime = formatter.parse(
                                                        date.last.split(" ").first);
                                                  }else{
                                                    formatter =  dateformat == "US"
                                                        ?DateFormat("MM/dd/yyyy h:mma"):dateformat == "CA"?DateFormat("yyyy/MM/dd h:mma"): DateFormat("dd/MM/yyyy h:mma");
                                                    scheduledDateTime = formatter.parse(
                                                        date.last);

                                                  }
                                                  var _calendarEvent = CalendarEventModel(
                                                    eventTitle: gameInviteNotificationList[index].eventName,
                                                    eventDescription: (gameInviteNotificationList[index].eventType==Constants.event?"Event":"Game"),
                                                    eventDurationInHours: 3,
                                                    statDate: scheduledDateTime,
                                                    location: location.last,
                                                  );

                                                  calendarCubit!.addToCalendar(_calendarEvent, calendarId!);
                                                  //calendarCubit.createCalendar();

                                                 /* Add2Calendar.addEvent2Cal(
                                                    Event(
                                                      title: gameInviteNotificationList[index].eventName,
                                                      description: gameInviteNotificationList[index].eventType,
                                                      location: location.last,
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
                                                EmailService().createEventNotification("Response to the Invite","",Constants.gameEventAcceptManager,gameInviteNotificationList[index].userID!,int.parse(userID!),gameInviteNotificationList[index].referenceTableId!,userName!+" "+ "has accepted your invite of the "+(gameInviteNotificationList[index].eventType==Constants.event?"Event":"Game")+", "+gameInviteNotificationList[index].eventName!+" for team "+gameInviteNotificationList[index].teamName!+".",gameInviteNotificationList[index].email!,gameInviteNotificationList[index].name!,"","","","","","","","","",userName!+" "+ "has accepted your invite of the "+(gameInviteNotificationList[index].eventType==Constants.event?"Event":"Game")+", "+gameInviteNotificationList[index].eventName!+" for team "+gameInviteNotificationList[index].teamName!,"","",false);
                                                EmailService().createEventNotification("Response to the Invite","",Constants.gameEventAccept,gameInviteNotificationList[index].userID!,gameInviteNotificationList[index].userID!,gameInviteNotificationList[index].referenceTableId!,"You have accepted to join the "+(gameInviteNotificationList[index].eventType==Constants.event?"Event":"Game")+", "+gameInviteNotificationList[index].eventName!+" for team "+gameInviteNotificationList[index].teamName!+".",userMail!,userName!,"","","","","","","","","","You have accepted to join the "+(gameInviteNotificationList[index].eventType==Constants.event?"Event":"Game")+", "+gameInviteNotificationList[index].eventName!+" for team "+gameInviteNotificationList[index].teamName!,"","",false);


                                                SendPushNotificationService().sendPushNotifications(
                                                    await SharedPrefManager.instance.getStringAsync(Constants.FCM),
                                              "You have accepted to join the "+(gameInviteNotificationList[index].eventType==Constants.event?"Event":"Game")+", "+gameInviteNotificationList[index].eventName!+" for team "+gameInviteNotificationList[index].teamName!,"");
                                              SendPushNotificationService().sendPushNotifications(
                                              gameInviteNotificationList[index].fcm!,
                                              userName!+" has accepted your invite of the "+(gameInviteNotificationList[index].eventType==Constants.event?"Event":"Game")+", "+gameInviteNotificationList[index].eventName!+" for team "+gameInviteNotificationList[index].teamName!,"");
                                              }else if(status==Constants.maybe){
                                                EmailService().createEventNotification("Response to the Invite","",Constants.gameEventAcceptManager,gameInviteNotificationList[index].userID!,int.parse(userID!),gameInviteNotificationList[index].referenceTableId!,userName!+" "+ "has responded to your invite as maybe the "+(gameInviteNotificationList[index].eventType==Constants.event?"Event":"Game")+", "+gameInviteNotificationList[index].eventName!+" for team "+gameInviteNotificationList[index].teamName!+".",gameInviteNotificationList[index].email!,gameInviteNotificationList[index].name!,"","","","","","","","","",userName!+" "+ "has responded to your invite as maybe the "+(gameInviteNotificationList[index].eventType==Constants.event?"Event":"Game")+", "+gameInviteNotificationList[index].eventName!+" for team "+gameInviteNotificationList[index].teamName!,"","",false);
                                                EmailService().createEventNotification("Response to the Invite","",Constants.gameEventAccept,gameInviteNotificationList[index].userID!,gameInviteNotificationList[index].userID!,gameInviteNotificationList[index].referenceTableId!,"You have responded as maybe to join the "+(gameInviteNotificationList[index].eventType==Constants.event?"Event":"Game")+", "+gameInviteNotificationList[index].eventName!+" for team "+gameInviteNotificationList[index].teamName!+".",userMail!,userName!,"","","","","","","","","","You have responded as maybe to join the "+(gameInviteNotificationList[index].eventType==Constants.event?"Event":"Game")+", "+gameInviteNotificationList[index].eventName!+" for team "+gameInviteNotificationList[index].teamName!,"","",false);

                                                SendPushNotificationService().sendPushNotifications(
                                              await SharedPrefManager.instance.getStringAsync(Constants.FCM),
                                              "You have responded as maybe to join the "+(gameInviteNotificationList[index].eventType==Constants.event?"Event":"Game")+", "+gameInviteNotificationList[index].eventName!+" for team "+gameInviteNotificationList[index].teamName!,"");
                                              SendPushNotificationService().sendPushNotifications(
                                              gameInviteNotificationList[index].fcm!,
                                              userName!+" has responded to your invite as maybe the "+(gameInviteNotificationList[index].eventType==Constants.event?"Event":"Game")+", "+gameInviteNotificationList[index].eventName!+" for team "+gameInviteNotificationList[index].teamName!,"");
                                              }else if(status==Constants.reject){
                                                EmailService().createEventNotification("Response to the Invite","",Constants.gameEventDeclineManger,gameInviteNotificationList[index].userID!,int.parse(userID!),gameInviteNotificationList[index].referenceTableId!,userName!+" "+ "has declined your invite of the "+(gameInviteNotificationList[index].eventType==Constants.event?"Event":"Game")+", "+gameInviteNotificationList[index].eventName!+" for team "+gameInviteNotificationList[index].teamName!+".",gameInviteNotificationList[index].email!,gameInviteNotificationList[index].name!,"","","","","","","","","",userName!+" "+ "has declined your invite of the "+(gameInviteNotificationList[index].eventType==Constants.event?"Event":"Game")+", "+gameInviteNotificationList[index].eventName!+" for team "+gameInviteNotificationList[index].teamName!,"","",false);
                                                EmailService().createEventNotification("Response to the Invite","",Constants.gameEventDecline,gameInviteNotificationList[index].userID!,gameInviteNotificationList[index].userID!,gameInviteNotificationList[index].referenceTableId!,"You have declined to join the "+(gameInviteNotificationList[index].eventType==Constants.event?"Event":"Game")+", "+gameInviteNotificationList[index].eventName!+" for team "+gameInviteNotificationList[index].teamName!+".",userMail!,userName!,"","","","","","","","","","You have declined to join the "+(gameInviteNotificationList[index].eventType==Constants.event?"Event":"Game")+", "+gameInviteNotificationList[index].eventName!+" for team "+gameInviteNotificationList[index].teamName!,"","",false);

                                                SendPushNotificationService().sendPushNotifications(
                                              await SharedPrefManager.instance.getStringAsync(Constants.FCM),
                                              "You have declined to join the "+(gameInviteNotificationList[index].eventType==Constants.event?"Event":"Game")+", "+gameInviteNotificationList[index].eventName!+" for team "+gameInviteNotificationList[index].teamName!,"");
                                              SendPushNotificationService().sendPushNotifications(
                                              gameInviteNotificationList[index].fcm!,
                                              userName!+" has declined your invite of the "+(gameInviteNotificationList[index].eventType==Constants.event?"Event":"Game")+", "+gameInviteNotificationList[index].eventName!+" for team "+gameInviteNotificationList[index].teamName!,"");
                                              }

                                              gameInviteNoteControl[index].clear();
                                              _splashScreenProvider!.updatePlayerAvalAsync(status.toString(), gameInviteNotificationList[index].referenceTableId.toString(), userID!,note);
                                              _notificationProvider!.removeNotificationAsync(gameInviteNotificationList[index].notificationId!,false);

                                              gameInviteNotificationList.removeAt(index);

                                            },
                                            onUpdateStatus: (status){
                                              if(status==Constants.accept) {
                                                _eventListviewProvider!.updateGameStatusAsync(
                                                    gameInviteNotificationList[index].referenceTableId!, "",
                                                    Constants.completed);
                                              }
                                              _notificationProvider!.removeNotificationAsync(gameInviteNotificationList[index].notificationId!,false);
                                              gameInviteNotificationList.removeAt(index);

                                            },
                                            onDelete: (){
                                              _notificationProvider!.removeNotificationAsync(gameInviteNotificationList[index].notificationId!,true);
                                              gameInviteNotificationList.removeAt(index);

                                            },
                                          );
                                        },
                                      ),


                                    ]),

                                if(volunteerInviteNotificationList.isNotEmpty)
                                  ExpansionTile(
                                      title: Text("Volunteer invites"),
                                      initiallyExpanded: false,
                                      textColor: MyColors.kPrimaryColor,
                                      iconColor: MyColors.kPrimaryColor,
                                      children: <Widget>[
                                        ListView.builder(
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          itemCount: volunteerInviteNotificationList.isEmpty ? 0 : volunteerInviteNotificationList.length,
                                          itemBuilder: (context, index) {
                                            gameInviteNoteControl.add(TextEditingController());
                                            return NotificationCard(

                                              noteControler: gameInviteNoteControl[index],
                                              title: volunteerInviteNotificationList[index].contentText,
                                              body:volunteerInviteNotificationList[index].contentText,
                                              //noteStatus:true,
                                              noteStatus:volunteerInviteNotificationList[index].IsNotesRequired,
                                              //buttonstatus:"Active",
                                              buttonstatus: volunteerInviteNotificationList[index].notificationTypeId==Constants.gameOrEventRequest?"Active":"InActive",
                                              buttonStatusClosed: volunteerInviteNotificationList[index].notificationTypeId==Constants.closedGameOrEvent?"Active":"InActive",
                                              onClick: (status,note) async {
                                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                                  ProgressBar.instance.showProgressbar(context);
                                                });
                                                // if(status==Constants.accept){
                                                //
                                                //   EmailService().createEventNotification("Response to the Invite",volunteerInviteNotificationList[index].eventName,Constants.gameVolunteerAccept,volunteerInviteNotificationList[index].userID,int.parse(userID),volunteerInviteNotificationList[index].referenceTableId,userName+" has accepted to be a volunteer for the team, "+volunteerInviteNotificationList[index].teamName,volunteerInviteNotificationList[index].email,volunteerInviteNotificationList[index].name,volunteerInviteNotificationList[index].eventName,"","","",location,date,"","","",userName,volunteerInviteNotificationList[index].teamName,volunteer);
                                                //
                                                //   SendPushNotificationService().sendPushNotifications(
                                                //       fcm,
                                                //       userName+" has accepted to be a volunteer for the assigned task  that has been Scheduled by "+ name+ " for the team, "+teamname,"");
                                                // }else if(status==Constants.maybe){
                                                //  }else if(status==Constants.reject){
                                                //   EmailService().createEventNotification("Response to the Invite","",Constants.gameEventDeclineManger,gameInviteNotificationList[index].userID,int.parse(userID),gameInviteNotificationList[index].referenceTableId,userName+" "+ "has declined your invite of the "+(gameInviteNotificationList[index].eventType==Constants.event?"Event":"Game")+", "+gameInviteNotificationList[index].eventName+" for team "+gameInviteNotificationList[index].teamName+".",gameInviteNotificationList[index].email,gameInviteNotificationList[index].name,"","","","","","","","","",userName+" "+ "has declined your invite of the "+(gameInviteNotificationList[index].eventType==Constants.event?"Event":"Game")+", "+gameInviteNotificationList[index].eventName+" for team "+gameInviteNotificationList[index].teamName,"","");
                                                //   EmailService().createEventNotification("Response to the Invite","",Constants.gameEventDecline,gameInviteNotificationList[index].userID,gameInviteNotificationList[index].userID,gameInviteNotificationList[index].referenceTableId,"You have declined to join the "+(gameInviteNotificationList[index].eventType==Constants.event?"Event":"Game")+", "+gameInviteNotificationList[index].eventName+" for team "+gameInviteNotificationList[index].teamName+".",userMail,userName,"","","","","","","","","","You have declined to join the "+(gameInviteNotificationList[index].eventType==Constants.event?"Event":"Game")+", "+gameInviteNotificationList[index].eventName+" for team "+gameInviteNotificationList[index].teamName,"","");
                                                //
                                                //   SendPushNotificationService().sendPushNotifications(
                                                //       await SharedPrefManager.instance.getStringAsync(Constants.FCM),
                                                //       "You have declined to join the "+(gameInviteNotificationList[index].eventType==Constants.event?"Event":"Game")+", "+gameInviteNotificationList[index].eventName+" for team "+gameInviteNotificationList[index].teamName,"");
                                                //   SendPushNotificationService().sendPushNotifications(
                                                //       gameInviteNotificationList[index].fcm,
                                                //       userName+" has declined your invite of the "+(gameInviteNotificationList[index].eventType==Constants.event?"Event":"Game")+", "+gameInviteNotificationList[index].eventName+" for team "+gameInviteNotificationList[index].teamName,"");
                                                // }

                                                gameInviteNoteControl[index].clear();
                                                // EmailService().updateVolunteerAvalAsync(eventVolunteerTypeId,volunteerTypeId,volunteer,refer,userid,status);
                                                volunteerInviteNotificationList.removeAt(index);

                                              },
                                              onUpdateStatus: (status){
                                                if(status==Constants.accept) {
                                                  _eventListviewProvider!.updateGameStatusAsync(
                                                      volunteerInviteNotificationList[index].referenceTableId!, "",
                                                      Constants.completed);
                                                }
                                                _notificationProvider!.removeNotificationAsync(volunteerInviteNotificationList[index].notificationId!,false);
                                                volunteerInviteNotificationList.removeAt(index);

                                              },
                                              onDelete: (){
                                                _notificationProvider!.removeNotificationAsync(volunteerInviteNotificationList[index].notificationId!,true);
                                                volunteerInviteNotificationList.removeAt(index);

                                              },
                                            );
                                          },
                                        ),


                                      ]),
                               /* if(gameInviteNotificationList.isNotEmpty)
                                  ExpansionTile(
                                    title: Text("Event invites"),
                                    initiallyExpanded: false,
                                    textColor: MyColors.kPrimaryColor,
                                    iconColor: MyColors.kPrimaryColor,
                                    children: <Widget>[
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: gameInviteNotificationList.isEmpty ? 0 : gameInviteNotificationList.length,
                                        itemBuilder: (context, index) {
                                          gameInviteNoteControl.add(TextEditingController());
                                          return NotificationCard(

                                            noteControler: gameInviteNoteControl[index],
                                            title: gameInviteNotificationList[index].contentText,
                                            body:gameInviteNotificationList[index].contentText,
                                            //noteStatus:true,
                                            noteStatus:gameInviteNotificationList[index].IsNotesRequired,
                                            //buttonstatus:"Active",
                                            buttonstatus: gameInviteNotificationList[index].notificationTypeId==Constants.gameOrEventRequest?"Active":"InActive",
                                            buttonStatusClosed: gameInviteNotificationList[index].notificationTypeId==Constants.closedGameOrEvent?"Active":"InActive",
                                            onClick: (status,note){
                                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                                ProgressBar.instance.showProgressbar(context);
                                              });
                                              gameInviteNoteControl[index].clear();
                                              _splashScreenProvider.updatePlayerAvalAsync(status.toString(), gameInviteNotificationList[index].referenceTableId.toString(), userID,note);

                                            },
                                            onUpdateStatus: (status){
                                              if(status==Constants.accept) {
                                                _eventListviewProvider.updateGameStatusAsync(
                                                    gameInviteNotificationList[index].referenceTableId, "",
                                                    "Completed");
                                              }
                                              _notificationProvider.removeNotificationAsync(gameInviteNotificationList[index].notificationId,false);

                                            },
                                            onDelete: (){
                                              _notificationProvider.removeNotificationAsync(gameInviteNotificationList[index].notificationId,true);
                                            },
                                          );
                                        },
                                      ),

                                    ]),
                               *//* if(gameInviteNotificationList.isNotEmpty)
                                  ExpansionTile(
                                    title: Text("Volunteer invites"),
                                    initiallyExpanded: false,
                                    textColor: MyColors.kPrimaryColor,
                                    iconColor: MyColors.kPrimaryColor,
                                    children: <Widget>[


                                    ]),
*/
                              ],
                            ),
                          ),

                        ]),
                    SizedBox(height: 10,),
                    if(reminderNotificationList.isNotEmpty)
                    ExpansionTile(
                        title: Text("Reminders"),
                        initiallyExpanded: false,
                        textColor: MyColors.kPrimaryColor,
                        iconColor: MyColors.kPrimaryColor,
                        children: <Widget>[
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: reminderNotificationList.isEmpty ? 0 : reminderNotificationList.length,
                            itemBuilder: (context, index) {
                              reminderNoteControl.add(TextEditingController());
                              return NotificationCard(

                                noteControler: reminderNoteControl[index],
                                title: reminderNotificationList[index].contentText,
                                body:reminderNotificationList[index].contentText,
                                //noteStatus:true,
                                noteStatus:reminderNotificationList[index].IsNotesRequired,
                                //buttonstatus:"Active",
                                buttonstatus: reminderNotificationList[index].notificationTypeId==Constants.gameOrEventRequest?"Active":"InActive",
                                buttonStatusClosed: reminderNotificationList[index].notificationTypeId==Constants.closedGameOrEvent?"Active":"InActive",
                                onClick: (status,note) async {

                                },
                                onUpdateStatus: (status){
                                  if(status==Constants.accept) {
                                    _eventListviewProvider!.updateGameStatusAsync(
                                        reminderNotificationList[index].referenceTableId!, "",
                                        Constants.completed);
                                  }
                                  _notificationProvider!.removeNotificationAsync(reminderNotificationList[index].notificationId!,false);
                                  reminderNotificationList.removeAt(index);

                                },
                                onDelete: (){
                                  _notificationProvider!.removeNotificationAsync(reminderNotificationList[index].notificationId!,true);
                                  reminderNotificationList.removeAt(index);

                                },
                              );
                            },
                          ),
                        ]),
                    SizedBox(height: 10,),
                    if(notificationList.isNotEmpty)
                      ExpansionTile(
                        title: Text("Notification"),
                        initiallyExpanded: false,
                        textColor: MyColors.kPrimaryColor,
                        iconColor: MyColors.kPrimaryColor,
                        children: <Widget>[
                          Column(
                            children: [
                      ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: notificationList.isEmpty ? 0 : notificationList.length,
                      itemBuilder: (context, index) {
                        noteControl.add(TextEditingController());
                        return NotificationCard(

                          noteControler: noteControl[index],
                          title: notificationList[index].contentText,
                          body:notificationList[index].contentText,
                          //noteStatus:true,
                          noteStatus:notificationList[index].IsNotesRequired,
                          //buttonstatus:"Active",
                          buttonstatus: notificationList[index].notificationTypeId==Constants.gameOrEventRequest?"Active":"InActive",
                          buttonStatusClosed: notificationList[index].notificationTypeId==Constants.closedGameOrEvent?"Active":"InActive",
                          onClick: (status,note) async {

                          },
                          onUpdateStatus: (status){
                          if(status==Constants.accept) {
                            _eventListviewProvider!.updateGameStatusAsync(
                                notificationList[index].referenceTableId!, "",
                                Constants.completed);
                          }
                          _notificationProvider!.removeNotificationAsync(notificationList[index].notificationId!,false);
                          notificationList.removeAt(index);

                          },
                          onDelete: (){
                          _notificationProvider!.removeNotificationAsync(notificationList[index].notificationId!,true);
                          notificationList.removeAt(index);

                          },
                        );
                      },
                    ),
                            ],
                          ),

                        ]),
                    /*ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _notificationResponse == null || _notificationResponse.userNotificationList == null ? 0 : _notificationResponse.userNotificationList.length,
                      // itemCount: response.length != null?response.length:0,
                      itemBuilder: (context, index) {
                        noteControl.add(TextEditingController());
                        return Slidable(
                            key: Key(_notificationResponse.userNotificationList[index].contentText),

                            endActionPane:  ActionPane(
                              motion: ScrollMotion(),
                              children: [
                                SlidableAction(
                                  //onPressed:removeNotification(context,_notificationResponse.userNotificationList[index].notificationId),
                                  onPressed:(context){
                                    _notificationProvider.removeNotificationAsync(_notificationResponse.userNotificationList[index].notificationId);
                                  },
                                  backgroundColor: Color(0xFFFE4A49),
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Delete',
                                ),
                              ],
                            ),

                            // The child of the Slidable is what the user sees when the
                            // component is not dragged.
                            child: NotificationCard(
                              *//* title: response[index].notification.sender,
                          body: response[index].notification.notificationMessage,
                          buttonstatus: response[index].notification.button_status,*//*
                              noteControler: noteControl[index],
                              title: _notificationResponse.userNotificationList[index].contentText,
                              body: _notificationResponse.userNotificationList[index].contentText,
                              //noteStatus:true,
                              noteStatus: _notificationResponse.userNotificationList[index].IsNotesRequired,
                              //buttonstatus:"Active",
                              buttonstatus: _notificationResponse.userNotificationList[index].notificationTypeId==Constants.gameOrEventRequest?"Active":"InActive",
                              onClick: (status,note){
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  ProgressBar.instance.showProgressbar(context);
                                });
                                _splashScreenProvider.updatePlayerAvalAsync(status.toString(), _notificationResponse.userNotificationList[index].referenceTableId.toString(), userID,note);

                              },
                            ),
                          );
                      },
                    ),*/
                    /*ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _notificationResponse == null || _notificationResponse.userNotificationList == null ? 0 : _notificationResponse.userNotificationList.length,
                      // itemCount: response.length != null?response.length:0,
                      itemBuilder: (context, index) {
                        noteControl.add(TextEditingController());
                        return NotificationCard(
                          *//* title: response[index].notification.sender,
                        body: response[index].notification.notificationMessage,
                        buttonstatus: response[index].notification.button_status,*//*
                          noteControler: noteControl[index],
                          title: _notificationResponse.userNotificationList[index].contentText,
                          body: _notificationResponse.userNotificationList[index].contentText,
                          //noteStatus:true,
                          noteStatus: _notificationResponse.userNotificationList[index].IsNotesRequired,
                          //buttonstatus:"Active",
                          buttonstatus: _notificationResponse.userNotificationList[index].notificationTypeId==Constants.gameOrEventRequest?"Active":"InActive",
                          buttonStatusClosed: _notificationResponse.userNotificationList[index].notificationTypeId==Constants.closedGameOrEvent?"Active":"InActive",
                          onClick: (status,note){
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              ProgressBar.instance.showProgressbar(context);
                            });
                            noteControl[index].clear();
                            _splashScreenProvider.updatePlayerAvalAsync(status.toString(), _notificationResponse.userNotificationList[index].referenceTableId.toString(), userID,note);

                          },
                          onUpdateStatus: (status){
                            if(status==Constants.accept) {
                              _eventListviewProvider.updateGameStatusAsync(
                                  _notificationResponse.userNotificationList[index].referenceTableId, "",
                                  "Completed");
                            }
                            _notificationProvider.removeNotificationAsync(_notificationResponse.userNotificationList[index].notificationId,false);

                          },
                          onDelete: (){
                            _notificationProvider.removeNotificationAsync(_notificationResponse.userNotificationList[index].notificationId,true);
                          },
                        );
                      },
                    ),*/
                    SizedBox(height: 20,),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

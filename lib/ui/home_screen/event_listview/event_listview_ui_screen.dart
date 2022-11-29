import 'package:device_calendar/device_calendar.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:fancy_dialog/fancy_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:skeletons/skeletons.dart';
import 'package:spaid/base/base_state.dart';
import 'package:spaid/model/response/base_response.dart';
import 'package:spaid/model/response/game_event_response/game_team_response.dart';
import 'package:spaid/model/response/game_event_response/player_email_list_response.dart';
import 'package:spaid/model/response/signup_response/validate_user_response.dart';
import 'package:spaid/service/email_service.dart';
import 'package:spaid/service/firebase_dynamic_link_service.dart';
import 'package:spaid/service/notification_service.dart';
import 'package:spaid/service/send_push_notification_service.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/support/dimens.dart';
import 'package:spaid/support/email_template.dart';
import 'package:spaid/support/icons.dart';
import 'package:spaid/support/images.dart';
import 'package:spaid/support/response_ids.dart';
import 'package:spaid/support/routes.dart';
import 'package:spaid/support/strings.dart';
import 'package:spaid/support/style_sizes.dart';
import 'package:spaid/ui/add_event_screen/add_event_provider.dart';
import 'package:spaid/ui/home_screen/event_listview/event_listview_provider.dart';
import 'package:spaid/utils/code_snippet.dart';
import 'package:spaid/utils/navigation.dart';
import 'package:spaid/utils/shared_pref_manager.dart';
import 'package:spaid/widgets/ProgressBar.dart';
import 'package:spaid/widgets/calendar_cubit.dart';
import 'package:spaid/widgets/calendar_event_model.dart';
import 'package:spaid/widgets/custom_appbar.dart';
import 'package:spaid/widgets/custom_background/custom_tab_bar.dart';
import 'package:spaid/widgets/custom_background/custom_web_background_card.dart';
import 'package:spaid/widgets/event_custom_button.dart';
import 'package:spaid/widgets/home_eventSport_card.dart';

class EventListviewScreen extends StatefulWidget {
  @override
  _EventListviewScreenState createState() => _EventListviewScreenState();
}

//region Private Members
String? _userRole;

//endregion
class _EventListviewScreenState extends BaseState<EventListviewScreen> {
//region Private Members
  EventListviewProvider? _eventListviewProvider;
  List<TextEditingController> _namecontroller = [];
  List<TextEditingController> _deletebuttoncontroller = [];
  List<TextEditingController> _cancelbuttoncontroller = [];
  List<TextEditingController> _statuscontroller = [];
  List<TextEditingController> _locationcontroller = [];
  List<TextEditingController> _datecontroller = [];
  // GetGameEventForTeamResponse _getGameAvailablityResponse;
  AddEventProvider? _addEventProvider;
  GetTeamMembersEmailResponse? _getTeamMembersEmailResponse;
bool? isLoading;
  String? dateformat, first,userName,teamName,userID,teamID,calendarId;
  bool? addToCalendar;
  String? signIn;
  CalendarCubit? calendarCubit;
  List<String> datestrings = [];
  List<GameOrEventList> gameOrEventList=[];
  Offset popupMenu=Offset(296.0, 150.5);
var _calendars;
//endregion
  @override
  void initState() {
    super.initState();
    _eventListviewProvider =
        Provider.of<EventListviewProvider>(context, listen: false);
    _eventListviewProvider!.listener = this;
    _addEventProvider = Provider.of<AddEventProvider>(context, listen: false);
    calendarCubit = Provider.of<CalendarCubit>(context, listen: false);

    _addEventProvider!.listener = this;
    isLoading=true;
    getCountryCodeAsyncs();
    /* WidgetsBinding.instance.addPostFrameCallback((_) {
      ProgressBar.instance.showProgressbar(context);
    });*/

    setState(() {
      _addEventProvider!.getTeamMembersEmailAsync();
      _eventListviewProvider!.getGameAsync();
      _getDataAsync();
    });
  }

  Future<void> getCountryCodeAsyncs() async {
    first =
    "${await SharedPrefManager.instance.getStringAsync(Constants.countryCode)}";
    calendarId = await SharedPrefManager.instance.getStringAsync(Constants.calendarId);
    String _addCalendar = await SharedPrefManager.instance.getStringAsync(Constants.addToCalender);
    addToCalendar=_addCalendar != null? _addCalendar.toLowerCase()=="true"?true:false:false;
    DynamicLinksService().createDynamicLink("signin_screen").then((value) async {
setState(() {
  signIn=value;
});
    });
    setState(() {
      dateformat = first;
      print(dateformat);
    });
  }

  @override
  Future<void> onSuccess(any, {required int reqId}) async {

    ProgressBar.instance.stopProgressBar(context);
    switch (reqId) {
      case ResponseIds.GET_GAME:
        print("Marlen game/event 1");
        GetGameEventForTeamResponse? _getGameAvailablityResponse;
        gameOrEventList=[];
        List<GameOrEventList> upcomingGameOrEventList=[];
        List<GameOrEventList> onGoingGameOrEventList=[];
        List<GameOrEventList> closedGameOrEventList=[];
        List<GameOrEventList> completedGameOrEventList=[];
        List<GameOrEventList> cancelledGameOrEventList=[];
        setState(()  {
           _getGameAvailablityResponse = any as GetGameEventForTeamResponse;
           if(_getGameAvailablityResponse != null && _getGameAvailablityResponse!.result != null &&
               _getGameAvailablityResponse!.result!.gameOrEventList !=
                   null) {
             for (int i = 0; i <
                 _getGameAvailablityResponse!.result!.gameOrEventList!.length; i++) {
               if (_getGameAvailablityResponse!.result!.gameOrEventList![i].status ==
                   Constants.ongoing) {
                 onGoingGameOrEventList.add(
                     _getGameAvailablityResponse!.result!.gameOrEventList![i]);
               } else
               if (_getGameAvailablityResponse!.result!.gameOrEventList![i].status ==
                   Constants.upcoming) {
                 upcomingGameOrEventList.add(
                     _getGameAvailablityResponse!.result!.gameOrEventList![i]);
               } else
               if (_getGameAvailablityResponse!.result!.gameOrEventList![i].status ==
                   Constants.closed) {
                 closedGameOrEventList.add(
                     _getGameAvailablityResponse!.result!.gameOrEventList![i]);
               } else
               if (_getGameAvailablityResponse!.result!.gameOrEventList![i].status ==
                   Constants.cancelled) {
                 cancelledGameOrEventList.add(
                     _getGameAvailablityResponse!.result!.gameOrEventList![i]);
               } else
               if (_getGameAvailablityResponse!.result!.gameOrEventList![i].status ==
                   Constants.completed) {
                 completedGameOrEventList.add(
                     _getGameAvailablityResponse!.result!.gameOrEventList![i]);
               }


             }
             gameOrEventList.addAll(onGoingGameOrEventList);
             gameOrEventList.addAll(upcomingGameOrEventList);
             gameOrEventList.addAll(closedGameOrEventList);
             gameOrEventList.addAll(cancelledGameOrEventList);
             gameOrEventList.addAll(completedGameOrEventList);
           }
        });
        if(_getGameAvailablityResponse != null && _getGameAvailablityResponse!.result != null &&
            _getGameAvailablityResponse!.result!.gameOrEventList !=
                null){
          if(addToCalendar!) {
            DateFormat formatter = dateformat == "US"
                ? DateFormat("MM/dd/yyyy") : dateformat == "CA"
                ? DateFormat("yyyy/MM/dd")
                : DateFormat("dd/MM/yyyy");

            if(datestrings.isEmpty) {
              for (int i = 0; i <
                  _getGameAvailablityResponse!.result!.gameOrEventList!.length; i++) {
                datestrings.add(
                    _getGameAvailablityResponse!.result!.gameOrEventList![i]
                        .scheduleDate!);
              }
            }

            datestrings.sort((a, b) { //sorting in descending order
              return formatter.parse(b).compareTo(formatter.parse(a));
            });
            print(datestrings);
            RetrieveEventsParams retrieveEventsParams = new RetrieveEventsParams(
                endDate: formatter.parse(datestrings[0]).add(Duration(days: 1)),
                startDate: formatter.parse(
                    datestrings[datestrings.length - 1]));
            calendarCubit!.retrieveEvents(calendarId??"", retrieveEventsParams);
            datestrings=[];
            for (int i = 0; i <
                _getGameAvailablityResponse!.result!.gameOrEventList!.length; i++) {
              datestrings.add(
                  _getGameAvailablityResponse!.result!.gameOrEventList![i]
                      .scheduleDate!);
            }

          }
          for(int i=0;i<_getGameAvailablityResponse!.result!.gameOrEventList!.length;i++){
            if(_userRole==Constants.owner.toString()||_userRole==Constants.coachorManager.toString()||_userRole==Constants.nonPlayer.toString()||_userRole==Constants.familyMember.toString()){
              if(addToCalendar!) {
                DateFormat formatter;
                DateTime scheduledDateTime;
                if (_getGameAvailablityResponse!.result!.gameOrEventList![i].scheduleTime!
                    .contains("00:00")) {
                  formatter = dateformat == "US"
                      ? DateFormat("MM/dd/yyyy") : dateformat == "CA"
                      ? DateFormat("yyyy/MM/dd")
                      : DateFormat("dd/MM/yyyy");
                  scheduledDateTime = formatter.parse(
                      _getGameAvailablityResponse!.result!.gameOrEventList![i].scheduleDate!);
                } else {
                  formatter = dateformat == "US"
                      ? DateFormat("MM/dd/yyyy h:mma") : dateformat == "CA"
                      ? DateFormat("yyyy/MM/dd h:mma")
                      : DateFormat("dd/MM/yyyy h:mma");
                  scheduledDateTime = formatter.parse(
                      _getGameAvailablityResponse!.result!.gameOrEventList![i].scheduleDate! +
                          " " + _getGameAvailablityResponse!.result!.gameOrEventList![i]
                          .scheduleTime!);
                }
                var _calendarEvent = CalendarEventModel(
                  eventTitle: _getGameAvailablityResponse!.result!.gameOrEventList![i].name!+"("+(_getGameAvailablityResponse!.result!.gameOrEventList![i].status==Constants.upcoming?"Upcoming":_getGameAvailablityResponse!.result!.gameOrEventList![i].status==Constants.ongoing?"Ongoing":_getGameAvailablityResponse!.result!.gameOrEventList![i].status==Constants.completed?"Completed":_getGameAvailablityResponse!.result!.gameOrEventList![i].status==Constants.cancelled?"Cancelled":_getGameAvailablityResponse!.result!.gameOrEventList![i].status==Constants.closed?"Closed":"Deleted")+")",
                  eventDescription: _getGameAvailablityResponse!.result!.gameOrEventList![i]
                      .type,
                  eventDurationInHours: 3,
                  statDate: scheduledDateTime,
                  location: _getGameAvailablityResponse!.result!.gameOrEventList![i]
                      .locationAddress,
                );

                //calendarCubit.deleteCalendar(calendarId);
                //calendarCubit.deleteEventInstance(calendarId);
                calendarCubit!.addToCalendar(_calendarEvent, calendarId??"");
              }
            }else{
              if(addToCalendar!  && _getGameAvailablityResponse!.result!.gameOrEventList![i].playerAvailabilityStatusId==Constants.accept && _userRole==Constants.teamPlayer.toString()) {
                DateFormat formatter;
                DateTime scheduledDateTime;
                if (_getGameAvailablityResponse!.result!.gameOrEventList![i].scheduleTime!
                    .contains("00:00")) {
                  formatter = dateformat == "US"
                      ? DateFormat("MM/dd/yyyy") : dateformat == "CA"
                      ? DateFormat("yyyy/MM/dd")
                      : DateFormat("dd/MM/yyyy");
                  scheduledDateTime = formatter.parse(
                      _getGameAvailablityResponse!.result!.gameOrEventList![i].scheduleDate!);
                } else {
                  formatter = dateformat == "US"
                      ? DateFormat("MM/dd/yyyy h:mma") : dateformat == "CA"
                      ? DateFormat("yyyy/MM/dd h:mma")
                      : DateFormat("dd/MM/yyyy h:mma");
                  scheduledDateTime = formatter.parse(
                      _getGameAvailablityResponse!.result!.gameOrEventList![i].scheduleDate! +
                          " " + _getGameAvailablityResponse!.result!.gameOrEventList![i]
                          .scheduleTime!);
                }
                var _calendarEvent = CalendarEventModel(
                  eventTitle: _getGameAvailablityResponse!.result!.gameOrEventList![i].name!+"("+(_getGameAvailablityResponse!.result!.gameOrEventList![i].status==Constants.upcoming?"Upcoming":_getGameAvailablityResponse!.result!.gameOrEventList![i].status==Constants.ongoing?"Ongoing":_getGameAvailablityResponse!.result!.gameOrEventList![i].status==Constants.completed?"Completed":_getGameAvailablityResponse!.result!.gameOrEventList![i].status==Constants.cancelled?"Cancelled":_getGameAvailablityResponse!.result!.gameOrEventList![i].status==Constants.closed?"Closed":"Deleted")+")",
                  eventDescription: _getGameAvailablityResponse!.result!.gameOrEventList![i]
                      .type,
                  eventDurationInHours: 3,
                  statDate: scheduledDateTime,
                  location: _getGameAvailablityResponse!.result!.gameOrEventList![i]
                      .locationAddress,
                );

                //calendarCubit.deleteCalendar(calendarId);
                //calendarCubit.deleteEventInstance(calendarId);
                calendarCubit!.addToCalendar(_calendarEvent, calendarId!);
              }
            }

            if (_getGameAvailablityResponse!
                .result!.gameOrEventList![i].isGameorEventClosed!) {
              for (int j = 0; j <
                  _getTeamMembersEmailResponse!.result!.userMailList!.length; j++) {
                if (_getTeamMembersEmailResponse!.result!.userMailList![j].rollId ==
                    Constants.coachorManager ||
                    _getTeamMembersEmailResponse!.result!.userMailList![j].rollId ==
                        Constants.owner) {

                  EmailService().updateStatus(
                      "",
                      "",
                      "",
                      Constants.closedGameOrEvent,
                      _getTeamMembersEmailResponse!.result!.userMailList![j].userIDNo!,
                      _getTeamMembersEmailResponse!.result!.userMailList![j].userIDNo!,
                      _getGameAvailablityResponse!.result!.gameOrEventList![i].eventId!,
                      "The status of the " +
                          _getGameAvailablityResponse!.result!.gameOrEventList![i].name! +
                          " held on " +
                          _getGameAvailablityResponse!.result!.gameOrEventList![i]
                              .scheduleDate! +
                          " has been changed to “Closed” as there is no response from you. Would you like to change the status of the " +
                          _getGameAvailablityResponse!.result!.gameOrEventList![i].name! +
                          " to “Completed”. ");
                    SendPushNotificationService().sendPushNotifications(
                        _getTeamMembersEmailResponse!.result!.userMailList![j].FCMTokenID!,
                        "The status of the " +
                            _getGameAvailablityResponse!.result!.gameOrEventList![i]
                                .name! + " held on " +
                            _getGameAvailablityResponse!.result!.gameOrEventList![i]
                                .scheduleDate! +
                            " has been changed to “Closed” as there is no response from you.",
                        "");

                }
              }
            }
          }

    }else{
          calendarCubit!.deleteCalendar(calendarId!);
          _calendars = await calendarCubit!.loadCalendars();
          //calendarCubit.deleteCalendar(13);
          if(_calendars.length>0){
            bool isCalendarAvailable=false;
            for(int i=0;i<_calendars.length;i++){
              if(_calendars[i].name=="Spaid"){
                isCalendarAvailable=true;
                SharedPrefManager.instance.setStringAsync(Constants.calendarId, _calendars[i].id.toString());

              }
            }
            if(!isCalendarAvailable){
              calendarCubit!.createCalendar();
              _calendars = await calendarCubit!.loadCalendars();
              for(int i=0;i<_calendars.length;i++){
                if(_calendars[i].name=="Spaid"){
                  SharedPrefManager.instance.setStringAsync(Constants.calendarId, _calendars[i].id.toString());
                }
              }
            }
          }

        }
        setState(() {
          isLoading=false;
        });

        break;
      case ResponseIds.GET_GAME_STATUS_UPDATE:
        ValidateUserResponse _response = any as ValidateUserResponse;
        if (_response.responseResult == Constants.success) {
          _eventListviewProvider!.getGameAsync();

          /* WidgetsBinding.instance.addPostFrameCallback((_) {
      ProgressBar.instance.showProgressbar(context);
    });
          _eventListviewProvider.getGameAsync();
*/
        } else if (_response.responseResult == Constants.failed) {
          CodeSnippet.instance.showMsg(_response.saveErrors![0].errorMessage!);
        } else {
          // CodeSnippet.instance.showMsg(MyStrings.signUpFailed);
        }
        setState(() {
          isLoading=false;
        });
        break;
      case ResponseIds.TEAM_EMAIL_LIST:
        GetTeamMembersEmailResponse _response =
            any as GetTeamMembersEmailResponse;
        if (_response.result != null && _response.result!.teamIDNo != Constants.success) {
          if (_response.result!.userMailList!.length > 0) {
            _getTeamMembersEmailResponse = _response;
          }
        }
        setState(() {
          isLoading=false;
        });
        break;
    }
  }
  @override
  void onRefresh(String type) {
    if(type.isNotEmpty){
      cancelGame(type);
    }
    if(mounted) {
      setState(() {
        isLoading = true;
        _eventListviewProvider!.getGameAsync();
      });
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

  showEvent(Size size, int index) {
    showDialog(
        context: context,
        builder: (context) => TopBar(
          child: Row(
            children: [
              if (getValueForScreenType<bool>(
                context: context,
                mobile: false,
                tablet: true,
                desktop: true,
              ))
                Expanded(
                  child: Image.asset(
                    MyImages.signin,
                    height: size.height * ImageSize.signInImageSize,
                  ),
                ),
              Expanded(
                child: WebCard(
                  marginVertical: 20,
                  marginhorizontal: 40,
                  child: Scaffold(
                    backgroundColor: MyColors.white,
                    appBar: CustomAppBar(
                      title: MyStrings.gameandevent,
                      iconLeft: MyIcons.cancel,  tooltipMessageLeft: MyStrings.cancel,
                      iconRight:null,
                      onClickLeftImage: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    body: SizedBox(
                      height: 870,
                      child: Padding(
                        padding: EdgeInsets.all(getValueForScreenType<bool>(
                          context: context,
                          mobile: false,
                          tablet: true,
                          desktop: true,
                        )
                            ? PaddingSize.headerPadding1
                            : PaddingSize.headerPadding2),
                        child: SingleChildScrollView(
                          child: new
                          Column(children: <Widget>[
                            ListTile(
                              title: Text(gameOrEventList[index].type!+" Name"),
                              subtitle: Text(gameOrEventList[index].name!),
                            ),
                            ListTile(
                              title: Text(MyStrings.date),
                              subtitle: Text(dateformat == "US"
                                  ? DateFormat("MM/dd/yyyy").format((DateFormat('dd/MM/yyyy').parse(gameOrEventList[index].scheduleDate!)))
                                  : dateformat == "CA"
                                  ? DateFormat("yyyy/MM/dd").format((DateFormat('dd/MM/yyyy').parse(gameOrEventList[index].scheduleDate!)))
                                  : DateFormat("dd/MM/yyyy").format((DateFormat('dd/MM/yyyy').parse(gameOrEventList[index].scheduleDate!)))),
                            ),
                            ListTile(
                              title: Text(MyStrings.time),
                              subtitle: Text((gameOrEventList[index].scheduleTime=="00:00")?MyStrings.timeTbd:DateFormat("h:mma")
                                  .format(DateFormat("h:mma").parse(gameOrEventList[index].scheduleTime!))),
                            ),
                            ListTile(
                              title: Text(MyStrings.locationDetails),
                              subtitle: Text(gameOrEventList[index].locationAddress!),
                            ),
                            ListTile(
                              title: Text(MyStrings.duration),
                              subtitle: Text( gameOrEventList[index].duration!.isNotEmpty? (gameOrEventList[index].duration)!.split(':').first+" hr "+(gameOrEventList[index].duration)!.split(':').last+" min":"",),
                            ),
                            ListTile(
                              title: Text(MyStrings.arriveEarly),
                              subtitle: Text( gameOrEventList[index].arriveEarly!.isNotEmpty? (gameOrEventList[index].arriveEarly)!.split(':').first+" hr "+(gameOrEventList[index].arriveEarly)!.split(':').last+" min":"",),
                            ),
                            ListTile(
                              title: Text(MyStrings.homeAway),
                              subtitle: Text(gameOrEventList[index].homeOrAway != null?gameOrEventList[index].homeOrAway!:""),
                            ),
                            ListTile(
                              title: Text(MyStrings.flagColor),
                              subtitle: Text(gameOrEventList[index].flagColor != null?gameOrEventList[index].flagColor!:""),
                            ),
                            ListTile(
                              title: Text(MyStrings.notes),
                              subtitle: Text(gameOrEventList[index].notes!),
                            ),
                            if (int.parse(_userRole != null ? _userRole! : "0") == Constants.owner ||
                                int.parse(_userRole != null ? _userRole! : "0") == Constants.coachorManager)
    EventCustomButton(
                  buttonColor: MyColors.kPrimaryColor,
                  buttonHeight: Dimens.standard_35,
                  onPressed: () {
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) =>
                            FancyDialog(
                              gifPath: MyImages.team,
                              cancelColor: MyColors.red,
                              cancelFun: () =>
                                  {Navigator.of(context).pop()},
                              okFun: () => {
                              Future.delayed(Duration.zero, () {
                              setState(() {
                              _eventListviewProvider!.deleteGameAsync(
                                                                gameOrEventList[index].eventId!,"");

                              });
                              }),
                                Navigator.of(context).pop(),
                                Navigator.of(context).pop()
                              },
                              title:
                                  "Are you sure you want to delete?",
                            ));
                  },
                  buttonText: MyStrings.delete),
                            SizedBox(height: 20,)
                       ]
                      ),
                    ),
                  ),
                ),
              ),
    ))
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return WebCard(
      marginVertical: WidgetCustomSize.marginVertical,
      marginhorizontal: WidgetCustomSize.marginhorizontal,
      child: Scaffold(
          backgroundColor: MyColors.white,
          body: Padding(
            padding: EdgeInsets.all(getValueForScreenType<bool>(
              context: context,
              mobile: false,
              tablet: true,
              desktop: true,)
                ? PaddingSize.headerPadding1
                : PaddingSize.headerPadding2),
            child: SafeArea(
              child:isLoading!?SkeletonListView(): gameOrEventList.isEmpty?
              Container(
                alignment: Alignment.center,
                child: EmptyWidget(
                  image: null,
                  packageImage: PackageImage.Image_3,
                  title: 'No Data',
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
              )
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: gameOrEventList ==
                                  null
                          ? 0
                          : gameOrEventList.length,
                      itemBuilder: (context, index) {

                        if(!kIsWeb){
                          NotificationService().init(gameOrEventList[index].eventId!,(gameOrEventList[index].status==Constants.upcoming?"Upcoming":gameOrEventList[index].status==Constants.ongoing?"Ongoing":gameOrEventList[index].status==Constants.completed?"Completed":gameOrEventList[index].status==Constants.cancelled?"Cancelled":gameOrEventList[index].status==Constants.closed?"Closed":"Deleted"),"You have "+
                              gameOrEventList[index].name!+" "+gameOrEventList[index].type!,gameOrEventList[index].locationAddress!,
                                  gameOrEventList[index].scheduleDate!,gameOrEventList[index].scheduleTime!);
                        }
                        return GestureDetector(
                          onTap: () {
// print(popupMenu);
                            //showEvent(size,index);
                            if ((int.parse(
                                        _userRole != null ? _userRole! : "0") ==
                                    Constants.owner ||
                                int.parse(
                                        _userRole != null ? _userRole! : "0") ==
                                    Constants.coachorManager) && (
                                gameOrEventList[index].status==Constants.upcoming||gameOrEventList[index].status==Constants.ongoing) && gameOrEventList[index].eventGroupId == null) {
                              /* Navigation.navigateTo(
                                    context, MyRoutes.editEventScreen);*/
                              Constant.gameIndex=index;
                              Constant.isSeries=false;
                              Navigation.navigateWithArgument(
                                  context,
                                  MyRoutes.editEventScreen,
                                  gameOrEventList[index].eventId!);
                            }else{
                              showEvent(size,index);
                            }
                          },
                          onPanDown: (dragDownDetails){
                            print(dragDownDetails.localPosition);
                            // popupMenu=dragDownDetails.localPosition;
                          },
                          child: PopupMenuButton<int>(
                            offset:popupMenu ,
                            onSelected: (value) {
                              if (value == 1) {
                                Constant.gameIndex=index;
                                Constant.isSeries=true;

                                Navigation.navigateWithArgument(
                                    context,
                                    MyRoutes.editEventScreen,
                                    gameOrEventList[index].eventId!);                              }
                              if (value == 2) {
                                setState(() {
                                  Constant.gameIndex=index;
                                  Constant.isSeries=false;

                                  Navigation.navigateWithArgument(
                                      context,
                                      MyRoutes.editEventScreen,
                                      gameOrEventList[index].eventId!);                                });
                              }
                            },
                            enabled: ((int.parse(
                                _userRole != null ? _userRole! : "0") ==
                                Constants.owner ||
                                int.parse(
                                    _userRole != null ? _userRole! : "0") ==
                                    Constants.coachorManager) && (
                                gameOrEventList[index].status==Constants.upcoming||gameOrEventList[index].status==Constants.ongoing) && gameOrEventList[index].eventGroupId != null)?true:false,
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 1,
                                child: Text("Edit series"),
                              ),
                              PopupMenuItem(
                                value: 2,
                                child: Text("Edit occurrence"),
                              ),
                            ],
                            // onTap: () {
                            //
                            //   //showEvent(size,index);
                            //   if ((int.parse(
                            //               _userRole != null ? _userRole : "0") ==
                            //           Constants.owner ||
                            //       int.parse(
                            //               _userRole != null ? _userRole : "0") ==
                            //           Constants.coachorManager) && (
                            //       gameOrEventList[index].status==Constants.upcoming||gameOrEventList[index].status==Constants.ongoing)) {
                            //     /* Navigation.navigateTo(
                            //           context, MyRoutes.editEventScreen);*/
                            //     Constant.gameIndex=index;
                            //     Navigation.navigateWithArgument(
                            //         context,
                            //         MyRoutes.editEventScreen,
                            //         gameOrEventList[index].eventId);
                            //   }else{
                            //     showEvent(size,index);
                            //   }
                            // },
                            child: HomeEventSportCard(
                              index: index,
                                updateStatus:(position,type){
                                  _eventListviewProvider!.updateGameStatusAsync(gameOrEventList[position].eventId!,"",type);
                                },
                              myDelete: (position,type) {
                                Future.delayed(Duration.zero, () {
                                  setState(() {
                                    _eventListviewProvider!.deleteGameAsync(
                                        gameOrEventList[position].eventId!,type);
                                    /* _namecontroller.removeAt(position);
                                      _deletebuttoncontroller.removeAt(position);
                                      _locationcontroller.removeAt(position);
                                      _datecontroller.removeAt(position);
                                      _cancelbuttoncontroller.removeAt(position);
                                      _statuscontroller.removeAt(position);
                                      if (choices.length > position) {
                                        choices[index].isDelete = true;
                                      }*/
                                  });
                                });
                              },
                              myCancel: (position,type) {
                                Future.delayed(Duration.zero, () async {
                                  _eventListviewProvider!.updateGameStatusAsync(gameOrEventList[position].eventId!,type,Constants.cancelled);
                                  if(gameOrEventList[position].eventGroupId != null && type=="All") {
                                    for (int j = 0; j <
                                        gameOrEventList.length; j++) {
                                      if (gameOrEventList[j].eventGroupId ==
                                          gameOrEventList[position]
                                              .eventGroupId) {
                                        for (int i = 0; i <
                                            _getTeamMembersEmailResponse!
                                                .result!.userMailList!.length; i++) {
                                          await  EmailService()
                                              .createEventNotification(
                                              "Cancel " +
                                                  gameOrEventList[j]
                                                      .type! +
                                                  ", " +
                                                  gameOrEventList[j]
                                                      .name!,
                                              gameOrEventList[j].name!,
                                              Constants.cancelGameOrEvent,
                                              int.parse(userID!),
                                              _getTeamMembersEmailResponse!
                                                  .result!.userMailList![i].userIDNo!,
                                              gameOrEventList[j].eventId!,
                                              "The " + gameOrEventList[j]
                                                  .type! +
                                                  ", " +
                                                  gameOrEventList[j]
                                                      .name! +
                                                  " has been canceled by " +
                                                  userName! + " for the team, " +
                                                  teamName! +
                                                  "  to take place on " +
                                                  (dateformat == "US"
                                                      ? DateFormat("MM/dd/yyyy")
                                                      .format(
                                                      (DateFormat('dd/MM/yyyy')
                                                          .parse(
                                                          gameOrEventList[j]
                                                              .scheduleDate!)))
                                                      : dateformat == "CA"
                                                      ? DateFormat("yyyy/MM/dd")
                                                      .format((DateFormat(
                                                      'dd/MM/yyyy').parse(
                                                      gameOrEventList[j]
                                                          .scheduleDate!)))
                                                      : DateFormat("dd/MM/yyyy")
                                                      .format((DateFormat(
                                                      'dd/MM/yyyy').parse(
                                                      gameOrEventList[j]
                                                          .scheduleDate!)))) +
                                                  " " +
                                                  (DateFormat("h:mma")
                                                      .format((DateFormat(
                                                      "h:mma").parse(
                                                      gameOrEventList[j]
                                                          .scheduleTime!)))) +
                                                  " at " +
                                                  gameOrEventList[j]
                                                      .locationAddress!,
                                              _getTeamMembersEmailResponse!
                                                  .result!.userMailList![i].email!,
                                              "","The " +
                                              gameOrEventList[j]
                                                  .type! + ", " +
                                              gameOrEventList[j]
                                                  .name! +
                                              " has been canceled by " +
                                              userName! +
                                              " for the team, " +
                                              teamName! +
                                              "  to take place on","","","",gameOrEventList[j]
                                              .locationAddress!,(dateformat == "US"
                                              ? DateFormat("MM/dd/yyyy")
                                              .format(
                                              (DateFormat('dd/MM/yyyy')
                                                  .parse(
                                                  gameOrEventList[j]
                                                      .scheduleDate!)))
                                              : dateformat == "CA"
                                              ? DateFormat("yyyy/MM/dd")
                                              .format((DateFormat(
                                              'dd/MM/yyyy').parse(
                                              gameOrEventList[j]
                                                  .scheduleDate!)))
                                              : DateFormat("dd/MM/yyyy")
                                              .format((DateFormat(
                                              'dd/MM/yyyy').parse(
                                              gameOrEventList[j]
                                                  .scheduleDate!)))),gameOrEventList[j]
                                              .scheduleTime=="00:00"?MyStrings.timeTbd:(DateFormat("h:mma")
                                              .format((DateFormat(
                                              "h:mma").parse(
                                              gameOrEventList[j]
                                                  .scheduleTime!)))),signIn!,"","","","",false);
                                        }
                                      }
                                    }
                                  }else{
                                    for (int i = 0; i <
                                        _getTeamMembersEmailResponse!
                                            .result!.userMailList!.length; i++) {
                                      await  EmailService()
                                          .createEventNotification(
                                          "Cancel " +
                                              gameOrEventList[position]
                                                  .type! +
                                              ", " +
                                              gameOrEventList[position]
                                                  .name!,
                                          gameOrEventList[position].name!,
                                          Constants.cancelGameOrEvent,
                                          int.parse(userID!),
                                          _getTeamMembersEmailResponse!
                                              .result!.userMailList![i].userIDNo!,
                                          gameOrEventList[position].eventId!,
                                          "The " + gameOrEventList[position]
                                              .type! +
                                              ", " +
                                              gameOrEventList[position]
                                                  .name! +
                                              " has been canceled by " +
                                              userName! + " for the team, " +
                                              teamName! +
                                              "  to take place on " +
                                              (dateformat == "US"
                                                  ? DateFormat("MM/dd/yyyy")
                                                  .format(
                                                  (DateFormat('dd/MM/yyyy')
                                                      .parse(
                                                      gameOrEventList[position]
                                                          .scheduleDate!)))
                                                  : dateformat == "CA"
                                                  ? DateFormat("yyyy/MM/dd")
                                                  .format((DateFormat(
                                                  'dd/MM/yyyy').parse(
                                                  gameOrEventList[position]
                                                      .scheduleDate!)))
                                                  : DateFormat("dd/MM/yyyy")
                                                  .format((DateFormat(
                                                  'dd/MM/yyyy').parse(
                                                  gameOrEventList[position]
                                                      .scheduleDate!)))) +
                                              " " +
                                              (DateFormat("h:mma")
                                                  .format((DateFormat(
                                                  "h:mma").parse(
                                                  gameOrEventList[position]
                                                      .scheduleTime!)))) +
                                              " at " +
                                              gameOrEventList[position]
                                                  .locationAddress!,
                                          _getTeamMembersEmailResponse!
                                              .result!.userMailList![i].email!,
                                          "","The " +
                                          gameOrEventList[position]
                                              .type! + ", " +
                                          gameOrEventList[position]
                                              .name! +
                                          " has been canceled by " +
                                          userName! +
                                          " for the team, " +
                                          teamName! +
                                          "  to take place on","","","",gameOrEventList[position]
                                          .locationAddress!,(dateformat == "US"
                                          ? DateFormat("MM/dd/yyyy")
                                          .format(
                                          (DateFormat('dd/MM/yyyy')
                                              .parse(
                                              gameOrEventList[position]
                                                  .scheduleDate!)))
                                          : dateformat == "CA"
                                          ? DateFormat("yyyy/MM/dd")
                                          .format((DateFormat(
                                          'dd/MM/yyyy').parse(
                                          gameOrEventList[position]
                                              .scheduleDate!)))
                                          : DateFormat("dd/MM/yyyy")
                                          .format((DateFormat(
                                          'dd/MM/yyyy').parse(
                                          gameOrEventList[position]
                                              .scheduleDate!)))),(gameOrEventList[position]
                                          .scheduleTime=="00:00"?MyStrings.timeTbd:DateFormat("h:mma")
                                          .format((DateFormat(
                                          "h:mma").parse(
                                          gameOrEventList[position]
                                              .scheduleTime!)))),signIn!,"","","","",false);
                                    }
                                  }

                                  /* _statuscontroller[position].text = "Cancelled";
                                      _deletebuttoncontroller[position].text = "true";
                                      _cancelbuttoncontroller[position].text = "false";*/
                                  setState(() {

                                  });
                                });
                              },
                              dateformat:dateformat,
                              typecontroller: gameOrEventList[index].type,
                              timecontroller:gameOrEventList[index].scheduleTime,
                              EventGroupId:gameOrEventList[index].eventGroupId,
                              datecontroller:gameOrEventList[index].scheduleDate,
                              locationcontroller:gameOrEventList[index].locationAddress,
                              gameOrEventList:gameOrEventList[index],
                              statuscontroller:(gameOrEventList[index].status==Constants.upcoming?"Upcoming":gameOrEventList[index].status==Constants.ongoing?"Ongoing":gameOrEventList[index].status==Constants.completed?"Completed":gameOrEventList[index].status==Constants.cancelled?"Cancelled":gameOrEventList[index].status==Constants.closed?"Closed":"Deleted"),
                              namecontroller:gameOrEventList[index].name,
                              cancelbuttoncontroller: (gameOrEventList[index].status ==
                                  Constants.upcoming||gameOrEventList[index].status ==
                                  Constants.ongoing) && (int.parse(_userRole!)==Constants.owner || int.parse(_userRole!)==Constants.coachorManager)
                                  ? true
                                  : false,
                              deletebuttoncontroller: (gameOrEventList[index].status ==
                                  Constants.completed|| gameOrEventList[index].status ==
                                  Constants.cancelled||gameOrEventList[index].status ==
                                  Constants.closed) && (int.parse(_userRole!)==Constants.owner || int.parse(_userRole!)==Constants.coachorManager)
                                  ? true
                                  : false,
                                userRole:_userRole,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: _getFAB()),

    );
  }

/*
Return Type:Widget
Input Parameters:
Use: To create Custom Widget.
 */
  _getFAB() {
    // ignore: unrelated_type_equality_checks
    if (int.parse(_userRole != null ? _userRole! : "0") == Constants.owner ||
        int.parse(_userRole != null ? _userRole! : "0") == Constants.coachorManager) {
      return FloatingActionButton(

        tooltip: MyStrings.addGameEvent,
        onPressed: () => {Navigation.navigateTo(context, MyRoutes.addEventScreen)},
        backgroundColor: MyColors.kPrimaryColor,
        child: MyIcons.add_white,
      );
    } else {
      return Container();
    }
  }

  /*
Return Type:
Input Parameters:
Use: Update static data to UI.
 */
  _getDataAsync() async {
    try {
      _userRole = await SharedPrefManager.instance.getStringAsync(Constants.roleId);
      userName = await SharedPrefManager.instance.getStringAsync(Constants.userName);
      teamName = await SharedPrefManager.instance.getStringAsync(Constants.teamName);
      userID = await SharedPrefManager.instance.getStringAsync(Constants.userIdNo);
      teamID = await SharedPrefManager.instance.getStringAsync(Constants.teamID);

      /* for (int i = 0; i < choices.length; i++) {
        if (choices[i].isDelete == false) {
          _namecontroller.add(TextEditingController());
          _namecontroller[i].text = choices[i].name;
          _deletebuttoncontroller.add(TextEditingController());
          _deletebuttoncontroller[i].text = (int.parse(_userRole) == -10002 &&
              choices[i].status == "Completed" ||
              choices[i].status == "Cancelled"
              ? true
              : false)
              .toString();
          _cancelbuttoncontroller.add(TextEditingController());
          _cancelbuttoncontroller[i].text = (int.parse(_userRole) == -10002 &&
              choices[i].status == "Upcoming" ||
              choices[i].status == "In Progress"
              ? true
              : false)
              .toString();
          _statuscontroller.add(TextEditingController());
          _statuscontroller[i].text = choices[i].status;
          _locationcontroller.add(TextEditingController());
          _locationcontroller[i].text = choices[i].location;
          _datecontroller.add(TextEditingController());
          _datecontroller[i].text = choices[i].date;
        }
      }*/
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  void cancelGame(String type) {
    Future.delayed(Duration.zero, () async {
      _eventListviewProvider!.updateGameStatusAsync(gameOrEventList[Constant.gameIndex].eventId!,type,Constants.cancelled);
      if(gameOrEventList[Constant.gameIndex].eventGroupId != null && type=="All") {
        for (int j = 0; j <
            gameOrEventList.length; j++) {
          if (gameOrEventList[j].eventGroupId ==
              gameOrEventList[Constant.gameIndex]
                  .eventGroupId) {
            for (int i = 0; i <
                _getTeamMembersEmailResponse!
                    .result!.userMailList!.length; i++) {
              await  EmailService()
                  .createEventNotification(
                  "Cancel " +
                      gameOrEventList[j]
                          .type! +
                      ", " +
                      gameOrEventList[j]
                          .name!,
                  gameOrEventList[j].name!,
                  Constants.cancelGameOrEvent,
                  int.parse(userID!),
                  _getTeamMembersEmailResponse!
                      .result!.userMailList![i].userIDNo!,
                  gameOrEventList[j].eventId!,
                  "The " + gameOrEventList[j]
                      .type! +
                      ", " +
                      gameOrEventList[j]
                          .name! +
                      " has been canceled by " +
                      userName! + " for the team, " +
                      teamName! +
                      "  to take place on " +
                      (dateformat == "US"
                          ? DateFormat("MM/dd/yyyy")
                          .format(
                          (DateFormat('dd/MM/yyyy')
                              .parse(
                              gameOrEventList[j]
                                  .scheduleDate!)))
                          : dateformat == "CA"
                          ? DateFormat("yyyy/MM/dd")
                          .format((DateFormat(
                          'dd/MM/yyyy').parse(
                          gameOrEventList[j]
                              .scheduleDate!)))
                          : DateFormat("dd/MM/yyyy")
                          .format((DateFormat(
                          'dd/MM/yyyy').parse(
                          gameOrEventList[j]
                              .scheduleDate!)))) +
                      " " +
                      (DateFormat("h:mma")
                          .format((DateFormat(
                          "h:mma").parse(
                          gameOrEventList[j]
                              .scheduleTime!)))) +
                      " at " +
                      gameOrEventList[j]
                          .locationAddress!,
                  _getTeamMembersEmailResponse!
                      .result!.userMailList![i].email!,
                  "","The " +
                  gameOrEventList[j]
                      .type! + ", " +
                  gameOrEventList[j]
                      .name! +
                  " has been canceled by " +
                  userName! +
                  " for the team, " +
                  teamName! +
                  "  to take place on","","","",gameOrEventList[j]
                  .locationAddress!,(dateformat == "US"
                  ? DateFormat("MM/dd/yyyy")
                  .format(
                  (DateFormat('dd/MM/yyyy')
                      .parse(
                      gameOrEventList[j]
                          .scheduleDate!)))
                  : dateformat == "CA"
                  ? DateFormat("yyyy/MM/dd")
                  .format((DateFormat(
                  'dd/MM/yyyy').parse(
                  gameOrEventList[j]
                      .scheduleDate!)))
                  : DateFormat("dd/MM/yyyy")
                  .format((DateFormat(
                  'dd/MM/yyyy').parse(
                  gameOrEventList[j]
                      .scheduleDate!)))),gameOrEventList[j]
                  .scheduleTime=="00:00"?MyStrings.timeTbd:(DateFormat("h:mma")
                  .format((DateFormat(
                  "h:mma").parse(
                  gameOrEventList[j]
                      .scheduleTime!)))),signIn!,"","","","",false);
            }
          }
        }
      }else{
        for (int i = 0; i <
            _getTeamMembersEmailResponse!
                .result!.userMailList!.length; i++) {
          await  EmailService()
              .createEventNotification(
              "Cancel " +
                  gameOrEventList[Constant.gameIndex]
                      .type! +
                  ", " +
                  gameOrEventList[Constant.gameIndex]
                      .name!,
              gameOrEventList[Constant.gameIndex].name!,
              Constants.cancelGameOrEvent,
              int.parse(userID!),
              _getTeamMembersEmailResponse!
                  .result!.userMailList![i].userIDNo!,
              gameOrEventList[Constant.gameIndex].eventId!,
              "The " + gameOrEventList[Constant.gameIndex]
                  .type! +
                  ", " +
                  gameOrEventList[Constant.gameIndex]
                      .name! +
                  " has been canceled by " +
                  userName! + " for the team, " +
                  teamName! +
                  "  to take place on " +
                  (dateformat == "US"
                      ? DateFormat("MM/dd/yyyy")
                      .format(
                      (DateFormat('dd/MM/yyyy')
                          .parse(
                          gameOrEventList[Constant.gameIndex]
                              .scheduleDate!)))
                      : dateformat == "CA"
                      ? DateFormat("yyyy/MM/dd")
                      .format((DateFormat(
                      'dd/MM/yyyy').parse(
                      gameOrEventList[Constant.gameIndex]
                          .scheduleDate!)))
                      : DateFormat("dd/MM/yyyy")
                      .format((DateFormat(
                      'dd/MM/yyyy').parse(
                      gameOrEventList[Constant.gameIndex]
                          .scheduleDate!)))) +
                  " " +
                  (DateFormat("h:mma")
                      .format((DateFormat(
                      "h:mma").parse(
                      gameOrEventList[Constant.gameIndex]
                          .scheduleTime!)))) +
                  " at " +
                  gameOrEventList[Constant.gameIndex]
                      .locationAddress!,
              _getTeamMembersEmailResponse!
                  .result!.userMailList![i].email!,
              "","The " +
              gameOrEventList[Constant.gameIndex]
                  .type! + ", " +
              gameOrEventList[Constant.gameIndex]
                  .name! +
              " has been canceled by " +
              userName! +
              " for the team, " +
              teamName! +
              "  to take place on","","","",gameOrEventList[Constant.gameIndex]
              .locationAddress!,(dateformat == "US"
              ? DateFormat("MM/dd/yyyy")
              .format(
              (DateFormat('dd/MM/yyyy')
                  .parse(
                  gameOrEventList[Constant.gameIndex]
                      .scheduleDate!)))
              : dateformat == "CA"
              ? DateFormat("yyyy/MM/dd")
              .format((DateFormat(
              'dd/MM/yyyy').parse(
              gameOrEventList[Constant.gameIndex]
                  .scheduleDate!)))
              : DateFormat("dd/MM/yyyy")
              .format((DateFormat(
              'dd/MM/yyyy').parse(
              gameOrEventList[Constant.gameIndex]
                  .scheduleDate!)))),(gameOrEventList[Constant.gameIndex]
              .scheduleTime=="00:00"?MyStrings.timeTbd:DateFormat("h:mma")
              .format((DateFormat(
              "h:mma").parse(
              gameOrEventList[Constant.gameIndex]
                  .scheduleTime!)))),signIn!,"","","","",false);
        }
      }

      /* _statuscontroller[position].text = "Cancelled";
                                    _deletebuttoncontroller[position].text = "true";
                                    _cancelbuttoncontroller[position].text = "false";*/
      setState(() {

      });
    });
  }
}



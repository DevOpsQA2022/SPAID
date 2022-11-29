import 'dart:io';


import 'package:chewie/chewie.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:spaid/base/base_state.dart';
import 'package:spaid/model/response/add_player_response/add_player_response.dart';
import 'package:spaid/model/response/base_response.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/support/icons.dart';
import 'package:spaid/support/images.dart';
import 'package:spaid/support/response_ids.dart';
import 'package:spaid/support/routes.dart';
import 'package:spaid/support/strings.dart';
import 'package:spaid/support/style_sizes.dart';
import 'package:spaid/support/validate_input.dart';
import 'package:spaid/ui/home_screen/notification_screen/notification_screen_provider.dart';
import 'package:spaid/ui/home_screen/sportEvent_listview/add_video_screen_provider.dart';
import 'package:spaid/utils/code_snippet.dart';
import 'package:spaid/utils/navigation.dart';
import 'package:spaid/utils/shared_pref_manager.dart';
import 'package:spaid/widgets/ProgressBar.dart';
import 'package:spaid/widgets/calendar_cubit.dart';
import 'package:spaid/widgets/custom_appbar.dart';
import 'package:spaid/widgets/custom_background/custom_tab_bar.dart';
import 'package:spaid/widgets/custom_background/custom_web_background_card.dart';
import 'package:spaid/widgets/customize_text_field.dart';
import 'package:universal_html/html.dart' as html;
import 'package:video_player/video_player.dart';


class NotificationPreferencesScreen extends StatefulWidget {
  @override
  _NotificationPreferencesScreenState createState() => _NotificationPreferencesScreenState();
}

class _NotificationPreferencesScreenState extends BaseState<NotificationPreferencesScreen> {
  //region Private Members
  bool? _scheduleNotification,addToCalendar;
  String? _timeBreak="",_timeBefore="",_addCalendar;
  double _kPickerSheetHeight = 216.0;
  bool timeBreakBool = false;
  bool timeBeforeBool = false;
  var _calendars;
  NotificationProvider? _notificationProvider;
  Duration initialDuration= Duration.zero;

  //endregion

  @override
  void initState() {
    super.initState();
    _notificationProvider = Provider.of<NotificationProvider>(context, listen: false);

    getSharedDataAsync();
  }
  void getSharedDataAsync() async{
    String sharedscheduleNotification= await SharedPrefManager.instance.getStringAsync(Constants.reminderStatus);
    _timeBefore= await SharedPrefManager.instance.getStringAsync(Constants.reminderTime);
    _addCalendar= await SharedPrefManager.instance.getStringAsync(Constants.addToCalender);
    setState(() {
      print(_timeBefore);
      if(_timeBefore != null && _timeBefore!.isNotEmpty){
        initialDuration=Duration(minutes: (int.parse((_timeBefore!).split(':').first)*60+int.parse((_timeBefore!).split(':').last)));
      }
      _scheduleNotification=sharedscheduleNotification != null? sharedscheduleNotification.toLowerCase()=="true"?true:false:false;
      addToCalendar=_addCalendar != null? _addCalendar!.toLowerCase()=="true"?true:false:false;

    });
  }

  @override
  void onSuccess(any, {required int reqId}) {
    ProgressBar.instance.stopProgressBar(context);
    super.onSuccess(any,reqId: 0);
    switch (reqId) {
      case ResponseIds.ADD_PLAYER_SCREEN:
        AddPlayerResponse _response = any as AddPlayerResponse;
        if (_response.responseResult == Constants.success) {
          Navigation.navigateWithArgument(
              context, MyRoutes.homeScreen, Constants.navigateIdOne);

          // CodeSnippet.instance.showMsg(MyStrings.signUpSuccess);
        } else if (_response.responseResult == Constants.failed) {
          CodeSnippet.instance.showMsg(_response.errorMessage!);
          print("400");
        } else {
          CodeSnippet.instance.showMsg(_response.errorMessage!);
          print("else");
        }
        break;
    }

  }

  @override
  void onFailure(BaseResponse error) {
    ProgressBar.instance.stopProgressBar(context);
    CodeSnippet.instance.showMsg(error.errorMessage!);
  }



  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return TopBar(
      child: Container(
        width: size.width,
        constraints: BoxConstraints(minHeight: size.height -30),
        child: Container(
          /*margin: EdgeInsets.symmetric(
              vertical: MarginSize.headerMarginVertical1,
              horizontal: MarginSize.headerMarginVertical1),*/
          child: Row(
            children: <Widget>[
              if (getValueForScreenType<bool>(
                context: context,
                mobile: false,
                tablet: false,
                desktop: false,
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
                        title: MyStrings.notifiPrefer,
                        iconRight: MyIcons.done,tooltipMessageRight: MyStrings.save,
                        iconLeft: MyIcons.cancel, tooltipMessageLeft: MyStrings.cancel,
                        onClickRightImage: () {
                          SharedPrefManager.instance.setStringAsync(Constants.reminderStatus, _scheduleNotification.toString());
                          SharedPrefManager.instance.setStringAsync(Constants.addToCalender, addToCalendar.toString());
                          _notificationProvider!.updateCalendarAsync(addToCalendar!);
                          if(_scheduleNotification!){
                            SharedPrefManager.instance.setStringAsync(Constants.reminderTime, _timeBefore!);
                          }else{
                            SharedPrefManager.instance.setStringAsync(Constants.reminderTime, "");

                          }
                          Navigator.of(context).pop();
                        },
                        onClickLeftImage: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      body: SingleChildScrollView(
                        child:  SafeArea(
                            child: Container(
                              width: size.width,
                              // constraints:
                              //     BoxConstraints(minHeight: size.height),
                              child: Column(
                                //mainAxisAlignment: MainAxisAlignment.center,
                               // crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                  /*  margin: getValueForScreenType<bool>(
                                      context: context,
                                      mobile: false,
                                      tablet: true,
                                      desktop: true,
                                    )
                                        ? null
                                        : EdgeInsets.symmetric(
                                            vertical: MarginSize
                                                .headerMarginVertical1,
                                            horizontal: MarginSize
                                                .headerMarginHorizontal1),*/
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                            child: Padding(
                                          padding: EdgeInsets.only(
                                              right: getValueForScreenType<
                                                      bool>(
                                            context: context,
                                            mobile: false,
                                            tablet: true,
                                            desktop: true,
                                          )
                                                  ? PaddingSize
                                                      .headerPadding2
                                                  : PaddingSize
                                                      .headerPadding2),
                                          child: Column(
                                            /*mainAxisAlignment: !isMobile(context)
                                            ? MainAxisAlignment.start
                                            : MainAxisAlignment.center,
                                        crossAxisAlignment: !isMobile(context)
                                            ? CrossAxisAlignment.start
                                            : CrossAxisAlignment.center,*/
                                            children: <Widget>[
                                              // if (isMobile(context))
                                              Padding(
                                                padding: EdgeInsets.all(
                                                    getValueForScreenType<
                                                            bool>(
                                                  context: context,
                                                  mobile: false,
                                                  tablet: true,
                                                  desktop: true,
                                                )
                                                        ? PaddingSize
                                                            .headerPadding1
                                                        : PaddingSize
                                                            .headerPadding2),
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height: SizedBoxSize
                                                          .standardSizedBoxHeight,
                                                      width: SizedBoxSize
                                                          .standardSizedBoxWidth,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.all(PaddingSize.boxPaddingAllSide),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.all(
                                                                PaddingSize.boxPaddingAllSide),
                                                            child: Text(
                                                              MyStrings.scheduleNotification,
                                                              style: TextStyle(
                                                                fontSize: FontSize.headerFontSize4,
                                                              ),
                                                            ),
                                                          ),
                                                          _scheduleNotification != null?
                                                          CupertinoSwitch(
                                                            value: _scheduleNotification == null? false:_scheduleNotification!,
                                                            activeColor: MyColors.kPrimaryColor,
                                                            onChanged: (value) {
                                                              setState(() {
                                                                _scheduleNotification = value;
                                                                timeBeforeBool =false;
                                                                print(value);

                                                              });
                                                            },
                                                          ):Container(),
                                                        ],
                                                      ),
                                                    ),
                                                    if(_scheduleNotification != null && _scheduleNotification!)
                                                    Padding(
                                                      padding:
                                                      const EdgeInsets.all(PaddingSize.boxPaddingAllSide),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.all(
                                                                PaddingSize.boxPaddingAllSide),
                                                            child: Text(
                                                              "Remind me before",
                                                              style: TextStyle(
                                                                fontSize: FontSize.headerFontSize4,
                                                              ),
                                                            ),
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                _timeBefore != null && _timeBefore!.isNotEmpty? (_timeBefore!).split(':').first+" hr "+(_timeBefore!).split(':').last+" min":"",
                                                                style: TextStyle(
                                                                  //color: MyColors.colorGray_818181,
                                                                  fontSize: FontSize.headerFontSize4,
                                                                ),
                                                              ),
                                                              IconButton(
                                                                icon: MyIcons.arrowIos,
                                                                onPressed: () {
                                                                  if (getValueForScreenType<bool>(
                                                                    context: context,
                                                                    mobile: true,
                                                                    tablet: false,
                                                                    desktop: false,
                                                                  ))
                                                                    showCupertinoModalPopup<void>(
                                                                      context: context,
                                                                      builder: (BuildContext context) {
                                                                        return _buildBottomPicker(
                                                                          CupertinoTimerPicker(
                                                                            mode: CupertinoTimerPickerMode.hm,
                                                                            initialTimerDuration:initialDuration,
                                                                            onTimerDurationChanged:
                                                                                (duration) {
                                                                              setState(() {
                                                                                this._timeBefore = duration
                                                                                    .toString()
                                                                                    .substring(0, 4);

                                                                                initialDuration=Duration(minutes: (int.parse((_timeBefore!).split(':').first)*60+int.parse((_timeBefore!).split(':').last)));

                                                                              });
                                                                            },
                                                                          ),
                                                                        );
                                                                      },
                                                                    );
                                                                  else
                                                                    setState(() {
                                                                      timeBeforeBool =
                                                                      timeBeforeBool == true ? false : true;
                                                                    });
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    if (timeBeforeBool == true && _scheduleNotification!)
                                                      MediaQuery(data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true), child: TimePickerDialog(
                                                        initialTime: TimeOfDay.fromDateTime(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, _timeBefore != null && _timeBefore!.isNotEmpty?int.parse((_timeBefore!).split(':').first):0, _timeBefore != null && _timeBefore!.isNotEmpty?int.parse((_timeBefore!).split(':').last):0)),
                                                        initialEntryMode: TimePickerEntryMode.input,
                                                        onClick: (value){
                                                          setState(() {
                                                            this._timeBefore=(value.hour.toString()+ ":"+ value.minute.toString());
                                                            timeBeforeBool=false;
                                                          });
                                                        },

                                                      ),
                                                      ),
                                                    SizedBox(
                                                      height: SizedBoxSize
                                                          .standardSizedBoxHeight,
                                                      width: SizedBoxSize
                                                          .standardSizedBoxWidth,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.all(PaddingSize.boxPaddingAllSide),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.all(
                                                                PaddingSize.boxPaddingAllSide),
                                                            child: Text("Add Game/Event to device calendar",
                                                              style: TextStyle(
                                                                fontSize: FontSize.headerFontSize4,
                                                              ),
                                                            ),
                                                          ),
                                                          CupertinoSwitch(
                                                            value: addToCalendar == null? false:addToCalendar!,
                                                            activeColor: MyColors.kPrimaryColor,
                                                            onChanged: (value) async {
                                                              setState(() {

                                                                  addToCalendar =
                                                                      value;
                                                                  print(value);


                                                              });
                                                              final calendarCubit = context.read<CalendarCubit>();
                                                              _calendars = await calendarCubit.loadCalendars();

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
                                                                  calendarCubit.createCalendar();
                                                                  _calendars = await calendarCubit.loadCalendars();
                                                                  for(int i=0;i<_calendars.length;i++){
                                                                    if(_calendars[i].name=="Spaid"){
                                                                      SharedPrefManager.instance.setStringAsync(Constants.calendarId, _calendars[i].id.toString());
                                                                    }
                                                                  }
                                                                }
                                                              }




                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ),

                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        )),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildBottomPicker(Widget picker) {
    return Container(
      height: _kPickerSheetHeight,
      padding: const EdgeInsets.only(top: PaddingSize.boxPaddingAllSide),
      color: CupertinoColors.white,
      child: DefaultTextStyle(
        style: const TextStyle(
          color: CupertinoColors.black,
          fontSize: FontSize.headerFontSize3,
        ),
        child: GestureDetector(
          // Blocks taps from propagating to the modal sheet and popping.
          onTap: () {},
          child: SafeArea(
            top: false,
            child: picker,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

  }
}

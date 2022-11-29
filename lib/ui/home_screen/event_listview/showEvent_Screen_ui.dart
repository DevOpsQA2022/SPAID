// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:responsive_builder/responsive_builder.dart';
// import 'package:spaid/model/response/base_response.dart';
// import 'package:spaid/model/response/game_event_response/game_team_response.dart';
// import 'package:spaid/model/response/game_event_response/player_email_list_response.dart';
// import 'package:spaid/model/response/signup_response/validate_user_response.dart';
// import 'package:spaid/support/colors.dart';
// import 'package:spaid/support/constants.dart';
// import 'package:spaid/support/icons.dart';
// import 'package:spaid/support/images.dart';
// import 'package:spaid/support/response_ids.dart';
// import 'package:spaid/support/responsive.dart';
// import 'package:spaid/support/strings.dart';
// import 'package:spaid/support/style_sizes.dart';
// import 'package:spaid/ui/add_event_screen/add_event_provider.dart';
// import 'package:spaid/ui/home_screen/event_listview/event_listview_provider.dart';
// import 'package:spaid/ui/home_screen/sportEvent_listview/score_listview_ui_screen.dart';
// import 'package:spaid/utils/code_snippet.dart';
// import 'package:spaid/widgets/ProgressBar.dart';
// import 'package:spaid/widgets/custom_appbar.dart';
// import 'package:spaid/widgets/custom_background/custom_tab_bar.dart';
// import 'package:spaid/widgets/custom_background/custom_web_background_card.dart';
// import 'package:spaid/widgets/custom_datepicker.dart';
// import 'package:spaid/widgets/custom_score_tabbar.dart';
// import 'package:spaid/widgets/custom_web_datepicker.dart';
// import 'package:syncfusion_flutter_datepicker/datepicker.dart';
// import 'package:weekday_selector/weekday_selector.dart';
//
// class RepeatScreen extends StatefulWidget {
//   @override
//   _RepeatScreenState createState() => _RepeatScreenState();
// }
//
// class _RepeatScreenState extends State<RepeatScreen>
//     with SingleTickerProviderStateMixin {
//   //region Private Members
//
//
//
//
//   bool showFlagColor = false;
//   bool showHomeAway = false;
//   bool showTimezone = false;
//   bool arriveEarlyColor = false;
//   bool showduration = false;
//   bool showDateTime = false;
//
//   TextEditingController searchController=TextEditingController();
//
//
//
//
//   // Group Value for Radio Button.
//   String id = "";
//
//   DateTime _dateTime = DateTime.now();
//
//   TextEditingController StartDatePickerController;
//   TextEditingController EndDatePickerController;
//   var weekdayvalues = List.filled(7, false);
//   String repeatvalue = MyStrings.doesNotRepeat;
//   bool _webDatePicker=false;
//   bool _webDatePicker1=false;
//
//   DateTime _selectedDate = DateTime.now();
//   AddEventProvider _addEventProvider;
//   String _dateCount = '';
//   String _range = '';
//   String _rangeCount = '';
//   String dateformat, first;
//   EventListviewProvider _eventListviewProvider;
//   List<TextEditingController> _namecontroller = [];
//   List<TextEditingController> _deletebuttoncontroller = [];
//   List<TextEditingController> _cancelbuttoncontroller = [];
//   List<TextEditingController> _statuscontroller = [];
//   List<TextEditingController> _locationcontroller = [];
//   List<TextEditingController> _datecontroller = [];
//   GetGameEventForTeamResponse _getGameAvailablityResponse;
//   GetTeamMembersEmailResponse _getTeamMembersEmailResponse;
//   bool isLoading;
// //endregion
//   @override
//   initState() {
//     super.initState();
//     print(_dateTime.timeZoneName);
//     _addEventProvider =
//         Provider.of<AddEventProvider>(context, listen: false);
//     StartDatePickerController = TextEditingController();
//     EndDatePickerController = TextEditingController();
//     StartDatePickerController=_addEventProvider.StartDatePickerController;
//     EndDatePickerController=_addEventProvider.EndDatePickerController;
//     weekdayvalues=_addEventProvider.weekdayvalues;
//     repeatvalue=_addEventProvider.repeatvalue;
//
//   }
//
//   @override
//   void onSuccess(any, {int reqId}) {
//
//     ProgressBar.instance.stopProgressBar(context);
//     switch (reqId) {
//       case ResponseIds.GET_GAME:
//         print("Marlen game/event 1");
//         setState(() {
//           _getGameAvailablityResponse = any as GetGameEventForTeamResponse;
//           if(_getGameAvailablityResponse != null ||
//               _getGameAvailablityResponse.gameOrEventList !=
//                   null){
//             for(int i=0;i<_getGameAvailablityResponse.gameOrEventList.length;i++){
//               if ((DateFormat('dd/MM/yyyy').parse(_getGameAvailablityResponse.gameOrEventList[i].scheduleDate ).add(Duration(days: 1))).compareTo(DateTime.now()) < 0 && (_getGameAvailablityResponse
//                   .gameOrEventList[i].status=="UpComing" ||_getGameAvailablityResponse
//                   .gameOrEventList[i].status=="OnGoing")){
//                 _eventListviewProvider.updateGameStatusAsync(_getGameAvailablityResponse.gameOrEventList[i].eventId,"","Closed");
//               }
//             }
//
//           }
//
//         });
//         setState(() {
//           isLoading=false;
//         });
//
//         break;
//       case ResponseIds.GET_GAME_STATUS_UPDATE:
//         ValidateUserResponse _response = any as ValidateUserResponse;
//         if (_response.responseResult == Constants.success) {
//           _eventListviewProvider.getGameAsync();
//
//           /* WidgetsBinding.instance.addPostFrameCallback((_) {
//       ProgressBar.instance.showProgressbar(context);
//     });
//           _eventListviewProvider.getGameAsync();
// */
//         } else if (_response.responseResult == Constants.failed) {
//           CodeSnippet.instance.showMsg(_response.saveErrors[0].errorMessage);
//         } else {
//           // CodeSnippet.instance.showMsg(MyStrings.signUpFailed);
//         }
//         setState(() {
//           isLoading=false;
//         });
//         break;
//       case ResponseIds.TEAM_EMAIL_LIST:
//         GetTeamMembersEmailResponse _response =
//         any as GetTeamMembersEmailResponse;
//         if (_response.teamIDNo != Constants.success) {
//           if (_response.userMailList.length > 0) {
//             _getTeamMembersEmailResponse = _response;
//           }
//         }
//         setState(() {
//           isLoading=false;
//         });
//         break;
//     }
//   }
//
//   @override
//   void onFailure(BaseResponse error) {
//     setState(() {
//       isLoading=false;
//     });
//     ProgressBar.instance.stopProgressBar(context);
//     CodeSnippet.instance.showMsg(error.errorMessage);
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return             TopBar(
//       child: Row(
//         children: [
//           if (getValueForScreenType<bool>(
//             context: context,
//             mobile: false,
//             tablet: false,
//             desktop: false,
//           ))
//             Expanded(
//               child: Image.asset(
//                 MyImages.signin,
//                 height: size.height * ImageSize.signInImageSize,
//               ),
//             ),
//           Expanded(
//             child: WebCard(
//               marginVertical: 20,
//               marginhorizontal: 40,
//               child: Scaffold(
//                 backgroundColor: MyColors.white,
//                 appBar: CustomAppBar(
//                   title: MyStrings.repeats,
//                   iconLeft: MyIcons.cancel, tooltipMessageLeft: MyStrings.cancel,
//                   iconRight: MyIcons.done,tooltipMessageRight: MyStrings.save,
//                   onClickRightImage: () {
//                     DateTime startDate=dateformat == "US"?DateFormat("MM/dd/yyyy").parse(StartDatePickerController.text):dateformat == "CA"?DateFormat("yyyy/MM/dd").parse(StartDatePickerController.text):DateFormat("dd/MM/yyyy").parse(StartDatePickerController.text);
//                     DateTime endDate=dateformat == "US"?DateFormat("MM/dd/yyyy").parse(EndDatePickerController.text):dateformat == "CA"?DateFormat("yyyy/MM/dd").parse(EndDatePickerController.text):DateFormat("dd/MM/yyyy").parse(EndDatePickerController.text);
//                     if(startDate.compareTo(DateTime.now())>=0 && endDate.compareTo(DateTime.now())>=0){
//                       if( startDate.compareTo(endDate)<0) {
//                         _addEventProvider.StartDatePickerController =
//                             StartDatePickerController;
//                         _addEventProvider.EndDatePickerController =
//                             EndDatePickerController;
//                         _addEventProvider.weekdayvalues = weekdayvalues;
//                         _addEventProvider.repeatvalue = repeatvalue;
//                         _addEventProvider.setRefreshScreen();
//                         Navigator.of(context).pop();
//                       }else{
//                         CodeSnippet.instance
//                             .showMsg("The end date must be after the start date.");
//                       }
//                     }else{
//                       CodeSnippet.instance
//                           .showMsg("Please select the current or upcoming date.");
//                     }
//                   },
//                   onClickLeftImage: () {
//                     Navigator.of(context).pop();
//                   },
//                 ),
//                 body: SizedBox(
//                   height: 870,
//
//                   child: Padding(
//                     padding: EdgeInsets.all( getValueForScreenType<bool>(
//                       context: context,
//                       mobile: false,
//                       tablet: true,
//                       desktop: true,) ? PaddingSize.headerPadding1 : PaddingSize.headerPadding2),
//                     child: SingleChildScrollView(
//                       child: new Column(children: <Widget>[
//
//                         ListTile(
//                           title: Text(_getGameAvailablityResponse.gameOrEventList[index].type+" Name"),
//                           subtitle: Text(_getGameAvailablityResponse.gameOrEventList[index].name),
//                         ),
//                         ListTile(
//                           title: Text(MyStrings.date),
//                           subtitle: Text(_getGameAvailablityResponse.gameOrEventList[index].scheduleDate),
//                         ),
//                         ListTile(
//                           title: Text(MyStrings.time),
//                           subtitle: Text(_getGameAvailablityResponse.gameOrEventList[index].scheduleTime),
//                         ),
//                         ListTile(
//                           title: Text(MyStrings.locationDetails),
//                           subtitle: Text(_getGameAvailablityResponse.gameOrEventList[index].locationAddress),
//                         ),
//                         ListTile(
//                           title: Text(MyStrings.duration),
//                           subtitle: Text(_getGameAvailablityResponse.gameOrEventList[index].duration),
//                         ),
//                         ListTile(
//                           title: Text(MyStrings.arriveEarly),
//                           subtitle: Text(_getGameAvailablityResponse.gameOrEventList[index].arriveEarly),
//                         ),
//                         ListTile(
//                           title: Text(MyStrings.notes),
//                           subtitle: Text(_getGameAvailablityResponse.gameOrEventList[index].notes),
//                         ),
//
//
//                       ]),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//
//   }
// }

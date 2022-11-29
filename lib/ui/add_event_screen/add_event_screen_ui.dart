import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:intl/intl.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:smart_select/smart_select.dart';
import 'package:spaid/base/base_state.dart';
import 'package:spaid/model/response/base_response.dart';
import 'package:spaid/model/response/game_event_response/add_game_response.dart';
import 'package:spaid/model/response/game_event_response/player_email_list_response.dart';
import 'package:spaid/model/response/signup_response/validate_user_response.dart';
import 'package:spaid/service/email_service.dart';
import 'package:spaid/service/firebase_dynamic_link_service.dart';
import 'package:spaid/service/send_push_notification_service.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/support/dimens.dart';
import 'package:spaid/support/email_template.dart';
import 'package:spaid/support/icons.dart';
import 'package:spaid/support/images.dart';
import 'package:spaid/support/internet_check.dart';
import 'package:spaid/support/response_ids.dart';
import 'package:spaid/support/routes.dart';
import 'package:spaid/support/strings.dart';
import 'package:spaid/support/style_sizes.dart';
import 'package:spaid/support/validate_input.dart';
import 'package:spaid/ui/add_event_screen/add_event_provider.dart';
import 'package:spaid/ui/home_screen/event_listview/event_listview_provider.dart';
import 'package:spaid/utils/code_snippet.dart';
import 'package:spaid/utils/navigation.dart';
import 'package:spaid/utils/shared_pref_manager.dart';
import 'package:spaid/widgets/custom_appbar.dart';
import 'package:spaid/widgets/custom_background/custom_tab_bar.dart';
import 'package:spaid/widgets/custom_background/custom_web_background_card.dart';
import 'package:spaid/widgets/custom_datepicker.dart';
import 'package:spaid/widgets/custom_loader.dart';
import 'package:spaid/widgets/customize_text_field.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:weekday_selector/weekday_selector.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:workmanager/workmanager.dart';

import '../../main_dev.dart';
import 'opponent_screen/opponent_provider.dart';


class AddEventScreen extends StatefulWidget {
  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends BaseState<AddEventScreen> {
  //region Private Members
  PickResult? selectedPlace2;
  AddEventProvider? _addEventProvider;

  String _selectedTimeZone = '';

  bool showFlagColor = false;
  bool showHomeAway = false;
  bool showTimezone = false;
  bool arriveEarlyColor = false;
  bool showduration = false;
  bool showDateTime = false;
  bool showTime = false;

  final _formKey = GlobalKey<FormState>();
  bool? _isShowing;

  DateTime _selectedDate = DateTime.now();
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';
  String? dateformat, first;
  AddGameResponse? _validateUserResponse;
  TextEditingController searchController = TextEditingController();

  List<S2Choice<String>> _timeZone = [];
  List<S2Choice<String>> _volunteer = [];

  // Group Value for Radio Button.
  String id = "";

  String _value = MyStrings.doesNotRepeat;
  TextEditingController? StartDatePickerController;
  TextEditingController? EndDatePickerController;
  final weekdayvalues = List.filled(7, false);
  double _kPickerSheetHeight = 216.0;
  bool _webDatePicker = false;
  bool _webDatePicker1 = false;
  FocusNode _node = new FocusNode();
  FocusNode _addressnode = new FocusNode();
  double? lat, lon;
  String userID = "",
      userName = "",
      teamName = "";
  BuildContext? popupContext;
  String? signIn;
  EventListviewProvider? _eventListviewProvider;
  String? userFcm,userEmail;
  List<DateTime> days = [];
  List<int> repeatDays = [];
  ScrollController _scrollController = ScrollController();
  List<UserMailList> ownerMailList = [];
  List<UserMailList> playerMailList = [];
  List<UserMailList> nonPlayerMailList = [];
  OpponentProvider? _opponentProvider;

  ScrollController _controllerOne = ScrollController();
  bool coachSelectAll=false;
  bool playerSelectAll=false;
  bool nonPlayerSelectAll=false;

//endregion
  @override
  initState() {
    super.initState();
    //print(_dateTime.timeZoneName);
    _addEventProvider = Provider.of<AddEventProvider>(context, listen: false);
    _addEventProvider!.initialProvider();
    _addEventProvider!.listener = this;
    _eventListviewProvider =
        Provider.of<EventListviewProvider>(context, listen: false);
    _opponentProvider =
        Provider.of<OpponentProvider>(context, listen: false);
    // _opponentProvider.getOpponentAsync();

    StartDatePickerController = TextEditingController();
    EndDatePickerController = TextEditingController();
    _addEventProvider!.getTeamMembersEmailAsync();
    // _getJsonVolunteerAsync();
    getCountryCodeAsyncs();
    _getJsonTimeZoneAsync();
  }

  Future<void> getCountryCodeAsyncs() async {
    first =
    "${await SharedPrefManager.instance.getStringAsync(Constants.countryCode)}";
    await DynamicLinksService().createDynamicLink("signin_screen").then((
        value) async {
      setState(() {
        _addEventProvider!.signIn = value;
        signIn = value;
      });
    });
    setState(() {
      dateformat = first;
      print(dateformat);
    });
  }

  void showProgressbar() {
    _isShowing = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        popupContext = context;
        /*if(!_isShowing) {
          Navigator.of(context).pop();
        }*/
        return WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: CustomLoader());
      },
    );
  }

  void stopProgressBar() {
    if(popupContext != null)
    Navigator.of(popupContext!).pop();
  }

  @override
  void onSuccess(any, {required int reqId}) async {
    stopProgressBar();
    switch (reqId) {
      case ResponseIds.SEND_EMAIL:
        ValidateUserResponse _validateResponse = any as ValidateUserResponse;
        if (_validateResponse.responseResult == Constants.success) {
          if (kIsWeb) {
            setState(() {
              print("Marlen 1");
              _eventListviewProvider!.setRefreshScreen("");
              Navigator.pop(context,true);
            });
          } else {
            if (getValueForScreenType<bool>(
              context: context,
              mobile: true,
              tablet: false,
              desktop: false,
            )) {
              Navigation.navigateWithArgument(context, MyRoutes.homeScreen, 2);
            } else {
              _eventListviewProvider!.setRefreshScreen("");
              Navigator.pop(context,true);
            }
          }
          //   Navigation.navigateTo(context, MyRoutes.eventListviewScreen);
        } else if (_validateResponse.responseResult == Constants.failed) {
          // showError(_response.saveErrors[0].errorMessage);
          if (kIsWeb) {
            setState(() {
              print("Marlen 2");
              _eventListviewProvider!.setRefreshScreen("");
              Navigator.pop(context);
            });
          } else {
            if (getValueForScreenType<bool>(
              context: context,
              mobile: true,
              tablet: false,
              desktop: false,
            )) {
              Navigation.navigateWithArgument(context, MyRoutes.homeScreen, 2);
            } else {
              _eventListviewProvider!.setRefreshScreen("");
              Navigator.pop(context,true);
            }
          }
          //   Navigation.navigateTo(context, MyRoutes.eventListviewScreen);
          CodeSnippet.instance
              .showMsg(_validateResponse.saveErrors![0].errorMessage!);
        } else {
          if (kIsWeb) {
            setState(() {
              print("Marlen 3");
              _eventListviewProvider!.setRefreshScreen("");
              Navigator.pop(context);
            });
          } else {
            if (getValueForScreenType<bool>(
              context: context,
              mobile: true,
              tablet: false,
              desktop: false,
            )) {
              Navigation.navigateWithArgument(context, MyRoutes.homeScreen, 2);
            } else {
              _eventListviewProvider!.setRefreshScreen("");
              Navigator.pop(context,true);
            }
          }
          //   Navigation.navigateTo(context, MyRoutes.eventListviewScreen);
          //  CodeSnippet.instance.showMsg(MyStrings.signUpFailed);
        }
        break;
      case ResponseIds.ADD_GAME:
        if(any == ""){
          if (kIsWeb) {
            setState(() {
              _eventListviewProvider!.setRefreshScreen("");
              Navigator.pop(context);
            });
          } else {
            if (getValueForScreenType<bool>(
              context: context,
              mobile: true,
              tablet: false,
              desktop: false,
            )) {
              Navigation.navigateWithArgument(context, MyRoutes.homeScreen, 2);
            } else {
              _eventListviewProvider!.setRefreshScreen("");
              Navigator.pop(context,true);
            }
          }
        }else {
          _validateUserResponse = any as AddGameResponse;
          if (_validateUserResponse!.responseResult == Constants.success) {
            if (kIsWeb) {
              setState(() {
                _eventListviewProvider!.setRefreshScreen("");
                Navigator.pop(context);
              });
            } else {
              if (getValueForScreenType<bool>(
                context: context,
                mobile: true,
                tablet: false,
                desktop: false,
              )) {
                Navigation.navigateWithArgument(
                    context, MyRoutes.homeScreen, 2);
              } else {
                _eventListviewProvider!.setRefreshScreen("");
                Navigator.pop(context, true);
              }
            }
            /* showProgressbar();
          _addEventProvider.getTeamMembersEmailAsync();*/
          } /* else if (_validateUserResponse.responseResult == Constants.failed) {
          // showError(_response.saveErrors[0].errorMessage);
          CodeSnippet.instance
              .showMsg(_validateUserResponse.saveErrors[0].errorMessage);
        } else {
          //  CodeSnippet.instance.showMsg(MyStrings.signUpFailed);
        }*/
        }
        break;
      case ResponseIds.TEAM_EMAIL_LIST:
        GetTeamMembersEmailResponse _response =
        any as GetTeamMembersEmailResponse;
        if (_response.result!.teamIDNo != Constants.success) {


          ownerMailList = [];
          playerMailList = [];
          nonPlayerMailList = [];
          for (int i = 0; i < _response.result!.userMailList!.length; i++) {
            if (_response.result!.userMailList![i].rollId == Constants.owner ||
                _response.result!.userMailList![i].rollId == Constants.coachorManager) {
              ownerMailList.add(_response.result!.userMailList![i]);
            } else if (_response.result!.userMailList![i].rollId ==
                Constants.teamPlayer) {
              playerMailList.add(_response.result!.userMailList![i]);
            } else {
              nonPlayerMailList.add(_response.result!.userMailList![i]);
            }
          }
        }

        break;
    }
  }

  @override
  void onFailure(BaseResponse error) {
    stopProgressBar();

    CodeSnippet.instance.showMsg(error.errorMessage??"");
  }

  @override
  void onRefresh(String type) {
    setState(() {
      // Navigator.pop(context);
    });
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        _range =
            DateFormat('dd/MM/yyyy').format(args.value.startDate).toString() +
                ' - ' +
                DateFormat('dd/MM/yyyy')
                    .format(args.value.endDate ?? args.value.startDate)
                    .toString();
      } else if (args.value is DateTime) {
        _addEventProvider!.dateTime = args.value;
        // DatepickerController.text = _selectedDate.toString();
        StartDatePickerController!
          ..text = dateformat == "US"
              ? DateFormat("MM/dd/yyyy").format(_selectedDate)
              : dateformat == "CA"
              ? DateFormat("yyyy/MM/dd").format(_selectedDate)
              : DateFormat("dd/MM/yyyy").format(_selectedDate)
          ..selection = TextSelection.fromPosition(TextPosition(
              offset: StartDatePickerController!.text.length,
              affinity: TextAffinity.upstream));
setState(() {
  showDateTime = false;

});
        print("ll" + _selectedDate.toString());
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      } else {
        _rangeCount = args.value.length.toString();
      }
    });
  }

  void _onSelectionChange(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        _range =
            DateFormat('dd/MM/yyyy').format(args.value.startDate).toString() +
                ' - ' +
                DateFormat('dd/MM/yyyy')
                    .format(args.value.endDate ?? args.value.startDate)
                    .toString();
      } else if (args.value is DateTime) {
        _selectedDate = args.value;
        // DatepickerController.text = _selectedDate.toString();
        EndDatePickerController!
          ..text = dateformat == "US"
              ? DateFormat("MM/dd/yyyy").format(_selectedDate)
              : dateformat == "CA"
              ? DateFormat("yyyy/MM/dd").format(_selectedDate)
              : DateFormat("dd/MM/yyyy").format(_selectedDate)
          ..selection = TextSelection.fromPosition(TextPosition(
              offset: EndDatePickerController!.text.length,
              affinity: TextAffinity.upstream));

        print("ll" + _selectedDate.toString());
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      } else {
        _rangeCount = args.value.length.toString();
      }
    });
  }

  // Fetch content from the json file
  Future<void> _getJsonTimeZoneAsync() async {
    userID =
    "${await SharedPrefManager.instance.getStringAsync(Constants.userIdNo)}";
    userName =
    "${await SharedPrefManager.instance.getStringAsync(Constants.userName)}";
    teamName = "${await SharedPrefManager.instance.getStringAsync(Constants.teamName)}";
    userFcm = "${await SharedPrefManager.instance.getStringAsync(Constants.FCM)}";
    userEmail = "${await SharedPrefManager.instance.getStringAsync(Constants.userId)}";
    final String response =
    await rootBundle.loadString('assets/json/multi/timezone_picker.json');
    final data = await json.decode(response);
    DateTime dateTime = DateTime.now();
    print(dateTime.timeZoneName);
    for (int i = 0; data["timeZones"].length > i; i++) {
      //_timeZone.add(S2Choice<String>(value: data["timeZones"][i]["index"], title: data["timeZones"][i]["index"]));
      //if (data["timeZones"][i]["id"].toLowerCase().contains(dateTime.timeZoneName.toLowerCase()) || data["timeZones"][i]["value"].toLowerCase().contains(dateTime.timeZoneName.toLowerCase())) {
      if (data["timeZones"][i]["id"].toLowerCase() ==
          dateTime.timeZoneName.toLowerCase() ||
          data["timeZones"][i]["value"].toLowerCase() ==
              dateTime.timeZoneName.toLowerCase()) {
        setState(() {
          if (kIsWeb) {
            _selectedTimeZone = data["timeZones"][i]["name"];
          } else {
            if (getValueForScreenType<bool>(
              context: context,
              mobile: false,
              tablet: true,
              desktop: false,
            )) {
              _selectedTimeZone = data["timeZones"][i]["name"];
            } else {
              _selectedTimeZone = data["timeZones"][i]["index"];
              print("Marlen 1" + data["timeZones"][i]["id"]);
            }
          }
          _addEventProvider!.timezoneController!.text =
          data["timeZones"][i]["name"];
          id = (i + 1).toString();
        });
      }
    }
    setState(() {
      _timeZone = S2Choice.listFrom<String, dynamic>(
        source: data[MyStrings.timeZones],
        group: (index, item) => item["index"].toString(),
        value: (index, item) => item["index"].toString(),
        title: (index, item) => item[MyStrings.name],
        subtitle: (index, item) => item[MyStrings.description],
      );
    });
  }

  // Fetch content from the json file
  Future<void> _getJsonTimeZoneSearchAsync(String value) async {
    final String response =
    await rootBundle.loadString('assets/json/multi/timezone_picker.json');
    final data = await json.decode(response);
    if (value.isNotEmpty) {
      _timeZone.clear();
      List datas = [];
      for (int i = 0; data["timeZones"].length > i; i++) {
        if (data["timeZones"][i]["name"].toLowerCase().contains(value)) {
          datas.add(data["timeZones"][i]);
        } else {
          print(value);
        }
      }
      _timeZone = S2Choice.listFrom<String, dynamic>(
        source: datas,
        group: (index, item) => item["index"].toString(),
        value: (index, item) => item[MyStrings.id],
        title: (index, item) => item[MyStrings.name],
        subtitle: (index, item) => item[MyStrings.description],
      );
    } else {
      _timeZone.clear();
      _timeZone = S2Choice.listFrom<String, dynamic>(
        source: data[MyStrings.timeZones],
        group: (index, item) => item["index"].toString(),
        value: (index, item) => item[MyStrings.id],
        title: (index, item) => item[MyStrings.name],
        subtitle: (index, item) => item[MyStrings.description],
      );
    }
  }
  // Fetch content from the json file
  Future<void> _getJsonVolunteerAsync() async {
    final String response =
    await rootBundle.loadString('assets/json/multi/volunteer_picker.json');
    final data = await json.decode(response);

    _volunteer = S2Choice.listFrom<String, dynamic>(
      source: data[MyStrings.volunteer],
      value: (index, item) => item[MyStrings.id],
      title: (index, item) => item[MyStrings.name],
      subtitle: (index, item) => item[MyStrings.description],
    );
  }

  /*
Return Type:
Input Parameters:
Use: Validate user inputs and Send Team Details to the Server.
 */
  Future<void> addGame() async {
    if(!kIsWeb){
      await Workmanager().cancelAll();
    }
    FocusScope.of(context).requestFocus(FocusNode());
    if (_formKey.currentState!.validate() && _addEventProvider!.gameNameController!.text.trim().isNotEmpty) {
      _formKey.currentState!.save();

      if(_addEventProvider!.mailSwitchValue){
        if(ownerMailList.isNotEmpty){
          for(int i=0;i<ownerMailList.length;i++){
            if(ownerMailList[i].isEnable!){
              _addEventProvider!.ownerMailList.add(ownerMailList[i]);
            }
          }
        }

        if(playerMailList.isNotEmpty){
          for(int i=0;i<playerMailList.length;i++){
            if(playerMailList[i].isEnable!){
              _addEventProvider!.playerMailList.add(playerMailList[i]);
            }
          }
        }

        if(nonPlayerMailList.isNotEmpty){
          for(int i=0;i<nonPlayerMailList.length;i++){
            if(nonPlayerMailList[i].isEnable!){
              _addEventProvider!.nonPlayerMailList.add(nonPlayerMailList[i]);
            }
          }
        }

      }else{
        _addEventProvider!.ownerMailList =ownerMailList;
        _addEventProvider!.playerMailList = playerMailList;
        _addEventProvider!.nonPlayerMailList = nonPlayerMailList;
      }

      if (DateFormat("yMd")
          .parse(DateFormat('yMd').format(_addEventProvider!.dateTime))
          .compareTo(DateFormat("yMd")
          .parse(DateFormat('yMd').format(DateTime.now()))) >=
          0) {
        if (_addEventProvider!.selectSwithValue == false) {
          Internet.checkInternet().then((value) async {
            if (value) {
              /* if(getValueForScreenType<bool>(
                context: context,
                mobile: true,
                tablet: false,
                desktop: false,
              ))*/
              showProgressbar();
              repeatDays=[];
              for (int i = 0; i < _addEventProvider!.weekdayvalues.toList().length; i++) {
                if (_addEventProvider!.weekdayvalues[i] == true) {
                  repeatDays.add(i + 1);
                }
              }
              if (_addEventProvider!.repeatvalue == MyStrings.weekly) {
                DateTime startDate = dateformat == "US"
                    ? DateFormat("MM/dd/yyyy").parse(_addEventProvider!.StartDatePickerController!.text)
                    : dateformat == "CA"
                    ? DateFormat("yyyy/MM/dd").parse(_addEventProvider!.StartDatePickerController!.text)
                    : DateFormat("dd/MM/yyyy")
                    .parse(_addEventProvider!.StartDatePickerController!.text);
                DateTime endDate = dateformat == "US"
                    ? DateFormat("MM/dd/yyyy").parse(_addEventProvider!.EndDatePickerController!.text)
                    : dateformat == "CA"
                    ? DateFormat("yyyy/MM/dd").parse(_addEventProvider!.EndDatePickerController!.text)
                    : DateFormat("dd/MM/yyyy").parse(_addEventProvider!.EndDatePickerController!.text);
                getDaysInBetween(startDate, endDate, repeatDays);
              }
              if (_addEventProvider!.repeatvalue == MyStrings.daily) {
                DateTime startDate = dateformat == "US"
                    ? DateFormat("MM/dd/yyyy").parse(_addEventProvider!.StartDatePickerController!.text)
                    : dateformat == "CA"
                    ? DateFormat("yyyy/MM/dd").parse(_addEventProvider!.StartDatePickerController!.text)
                    : DateFormat("dd/MM/yyyy")
                    .parse(_addEventProvider!.StartDatePickerController!.text);
                DateTime endDate = dateformat == "US"
                    ? DateFormat("MM/dd/yyyy").parse(_addEventProvider!.EndDatePickerController!.text)
                    : dateformat == "CA"
                    ? DateFormat("yyyy/MM/dd").parse(_addEventProvider!.EndDatePickerController!.text)
                    : DateFormat("dd/MM/yyyy").parse(_addEventProvider!.EndDatePickerController!.text);
                getDaysInBetweenDaily(startDate, endDate);
              }
              // if(days.isNotEmpty){
              //   bool isSameDate=false;
              //   for(int i=0;i<days.length;i++){
              //     if(DateFormat("dd/MM/yyyy").parse(DateFormat("dd/MM/yyyy").format(_addEventProvider.dateTime)).isAtSameMomentAs(days[i])){
              //       isSameDate=true;
              //     }
              //   }
              //   if(!isSameDate){
              //     _addEventProvider.addRepeatGameAsync(lat,lon);
              //   }
              //
              // }
              // try {
              //   await Workmanager().cancelAll();
              //  Workmanager().initialize(
              //     callbackDispatcher,
              //     isInDebugMode: true,
              //   );
              //  Workmanager().registerOneOffTask(
              //       fetchBackground,
              //       fetchBackground,
              //       inputData: <String, dynamic>{
              //         'lat': lat,
              //         'lon': lon,
              //
              //       },
              //       constraints: Constraints(
              //         networkType: NetworkType.connected,
              //       )
              //   );
              // } catch (e) {
              //   print(e);
              // }
              _addEventProvider!.addGameAsync(lat??0, lon??0);

            } else {
              CodeSnippet.instance.showMsg(MyStrings.checkNetwork);
            }
          });
        } else if (_addEventProvider!.selectSwithValue &&
            _addEventProvider!.opponentNameController!.text.isNotEmpty) {
          Internet.checkInternet().then((value) async {
            if (value) {
              /* if(getValueForScreenType<bool>(
                context: context,
                mobile: true,
                tablet: false,
                desktop: false,
              ))*/
              showProgressbar();
              repeatDays=[];
              for (int i = 0; i < _addEventProvider!.weekdayvalues.toList().length; i++) {
                if (_addEventProvider!.weekdayvalues[i] == true) {
                  repeatDays.add(i + 1);
                }
              }
              if (_addEventProvider!.repeatvalue == MyStrings.weekly) {
                DateTime startDate = dateformat == "US"
                    ? DateFormat("MM/dd/yyyy").parse(_addEventProvider!.StartDatePickerController!.text)
                    : dateformat == "CA"
                    ? DateFormat("yyyy/MM/dd").parse(_addEventProvider!.StartDatePickerController!.text)
                    : DateFormat("dd/MM/yyyy")
                    .parse(_addEventProvider!.StartDatePickerController!.text);
                DateTime endDate = dateformat == "US"
                    ? DateFormat("MM/dd/yyyy").parse(_addEventProvider!.EndDatePickerController!.text)
                    : dateformat == "CA"
                    ? DateFormat("yyyy/MM/dd").parse(_addEventProvider!.EndDatePickerController!.text)
                    : DateFormat("dd/MM/yyyy").parse(_addEventProvider!.EndDatePickerController!.text);
                getDaysInBetween(startDate, endDate, repeatDays);
              }
              if (_addEventProvider!.repeatvalue == MyStrings.daily) {
                DateTime startDate = dateformat == "US"
                    ? DateFormat("MM/dd/yyyy").parse(_addEventProvider!.StartDatePickerController!.text)
                    : dateformat == "CA"
                    ? DateFormat("yyyy/MM/dd").parse(_addEventProvider!.StartDatePickerController!.text)
                    : DateFormat("dd/MM/yyyy")
                    .parse(_addEventProvider!.StartDatePickerController!.text);
                DateTime endDate = dateformat == "US"
                    ? DateFormat("MM/dd/yyyy").parse(_addEventProvider!.EndDatePickerController!.text)
                    : dateformat == "CA"
                    ? DateFormat("yyyy/MM/dd").parse(_addEventProvider!.EndDatePickerController!.text)
                    : DateFormat("dd/MM/yyyy").parse(_addEventProvider!.EndDatePickerController!.text);
                getDaysInBetweenDaily(startDate, endDate);
              }
              // if(days.isNotEmpty){
              //   bool isSameDate=false;
              //   for(int i=0;i<days.length;i++){
              //     if(DateFormat("dd/MM/yyyy").parse(DateFormat("dd/MM/yyyy").format(_addEventProvider.dateTime)).isAtSameMomentAs(days[i])){
              //       isSameDate=true;
              //     }
              //   }
              //   if(!isSameDate){
              //     _addEventProvider.addRepeatGameAsync(lat,lon);
              //   }
              //
              // }
              // try {
              //   await Workmanager().cancelAll();
              //    Workmanager().initialize(
              //     callbackDispatcher,
              //     isInDebugMode: true,
              //   );
              //    Workmanager().registerOneOffTask(
              //       fetchBackground,
              //       fetchBackground,
              //       inputData: <String, dynamic>{
              //         'lat': lat,
              //         'lon': lon,
              //
              //       },
              //       constraints: Constraints(
              //         networkType: NetworkType.connected,
              //       )
              //   );
              // } catch (e) {
              //   print(e);
              // }
              _addEventProvider!.addGameAsync(lat??0, lon??0);

            } else {
              CodeSnippet.instance.showMsg(MyStrings.checkNetwork);
            }
          });
        } else {
          CodeSnippet.instance.showMsg("Select opponent team");
        }
      } else {
        CodeSnippet.instance
            .showMsg("Select the current or upcoming date");
      }
    }else{
      if(_addEventProvider!.gameNameController!.text.trim().isEmpty){
        _scrollController.jumpTo(0);
      }else if(_addEventProvider!.locationDetailsController!.text.trim().isEmpty){
        _scrollController.jumpTo(100);
      }
    }
  }
  List<DateTime> getDaysInBetweenDaily(DateTime startDate, DateTime endDate) {
    days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(startDate.add(Duration(days: i)));
      print(startDate.add(Duration(days: i)));
      //print(startDate.add(Duration(days: i)).weekday);

    }
    return days;
  }
  List<DateTime> getDaysInBetween(
      DateTime startDate, DateTime endDate, List<int> repeatDays) {
    days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      // days.add(startDate.add(Duration(days: i)));
      /* print(startDate.add(Duration(days: i)));
      print(startDate.add(Duration(days: i)).weekday);*/
      if (startDate.add(Duration(days: i)).weekday == 7 &&
          repeatDays.contains(1)) {
        print(startDate.add(Duration(days: i)));
        days.add(startDate.add(Duration(days: i)));
      } else if (repeatDays
          .contains(startDate.add(Duration(days: i)).weekday + 1)) {
        print(startDate.add(Duration(days: i)));
        days.add(startDate.add(Duration(days: i)));
      }
    }
    return days;
  }
  selectRepeat(Size size) {
    showDialog(
        context: context,
        builder: (context) =>
            TopBar(
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
                          title: MyStrings.repeats,
                          iconLeft: MyIcons.cancel,
                          tooltipMessageLeft: MyStrings.cancel,
                          iconRight: MyIcons.done,
                          tooltipMessageRight: MyStrings.save,

                          onClickRightImage: () {
                            Navigator.of(context).pop();
                          },
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
                              controller: ScrollController(),
                              child: new Column(children: <Widget>[
                                ListTile(
                                  title: Text(MyStrings.doesNotRepeat),
                                  leading: Radio(
                                    value: MyStrings.doesNotRepeat,
                                    groupValue: _value,
                                    activeColor: MyColors.kPrimaryColor,
                                    onChanged: (String? value) {
                                      setState(() {
                                        _value = value!;
                                        Navigator.of(context).pop();
                                        selectRepeat(size);
                                      });
                                    },
                                  ),
                                ),
                                Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      SizedBox(
                                        width: getValueForScreenType<bool>(
                                          context: context,
                                          mobile: false,
                                          tablet: false,
                                          desktop: true,
                                        )
                                            ? MediaQuery
                                            .of(context)
                                            .size
                                            .width /
                                            8
                                            : getValueForScreenType<bool>(
                                          context: context,
                                          mobile: false,
                                          tablet: true,
                                          desktop: false,
                                        )
                                            ? MediaQuery
                                            .of(context)
                                            .size
                                            .width /
                                            5
                                            : MediaQuery
                                            .of(context)
                                            .size
                                            .width /
                                            3,
                                        child: ListTile(
                                          title: Text(MyStrings.weekly),
                                          leading: Radio(
                                            value: MyStrings.weekly,
                                            groupValue: _value,
                                            activeColor: MyColors.kPrimaryColor,
                                            onChanged: (String? value) {
                                              setState(() {
                                                _value = value!;
                                                Navigator.of(context).pop();
                                                selectRepeat(size);
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: getValueForScreenType<bool>(
                                          context: context,
                                          mobile: false,
                                          tablet: false,
                                          desktop: true,
                                        )
                                            ? MediaQuery
                                            .of(context)
                                            .size
                                            .width /
                                            8
                                            : getValueForScreenType<bool>(
                                          context: context,
                                          mobile: false,
                                          tablet: true,
                                          desktop: false,
                                        )
                                            ? MediaQuery
                                            .of(context)
                                            .size
                                            .width /
                                            5
                                            : MediaQuery
                                            .of(context)
                                            .size
                                            .width /
                                            3,
                                        child: ListTile(
                                          title: Text(MyStrings.daily),
                                          leading: Radio(
                                            value: MyStrings.daily,
                                            groupValue: _value,
                                            activeColor: MyColors.kPrimaryColor,
                                            onChanged: (String? value) {
                                              setState(() {
                                                _value = value!;
                                                Navigator.of(context).pop();
                                                selectRepeat(size);
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ]),
                                _value == MyStrings.weekly ||
                                    _value == MyStrings.daily
                                    ? Padding(
                                  padding: const EdgeInsets.all(
                                      PaddingSize.boxPaddingAllSide),
                                  child: Column(
                                    children: [
                                      Focus(
                                        focusNode: _node,
                                        onFocusChange: (bool focus) {
                                          setState(() {
                                            _webDatePicker == true
                                                ? _webDatePicker = false
                                                : _webDatePicker = false;
                                            _webDatePicker1 == true
                                                ? _webDatePicker1 = false
                                                : _webDatePicker1 = false;
                                          });
                                        },
                                        child: Listener(
                                          onPointerDown: (_) {
                                            FocusScope.of(context)
                                                .requestFocus(_node);
                                          },
                                          child:
                                          DatePickerTextfieldWidget(
                                            suffixIcon: MyIcons.calendar,
                                            labelText:
                                            MyStrings.startDate,
                                            controller:
                                            StartDatePickerController,
                                            inputAction:
                                            TextInputAction.done,
                                            //validator: ValidateInput.verifyDOB,
                                            onTab: () {
                                              setState(() {
                                                _webDatePicker == true
                                                    ? _webDatePicker =
                                                false
                                                    : _webDatePicker =
                                                true;

                                                Navigator.of(context)
                                                    .pop();
                                                selectRepeat(size);
                                              });
                                            },

                                            onSave: (value) {
                                              StartDatePickerController!
                                                  .text = value!;
                                              // print(provider.startDateController.text);

                                              print(value);
                                            },
                                          ),
                                        ),
                                      ),
                                      _webDatePicker == true &&
                                          getValueForScreenType<bool>(
                                            context: context,
                                            mobile: false,
                                            tablet: false,
                                            desktop: true,
                                          )
                                          ? Container(
                                        width: 330,
                                        child: Card(
                                          margin:
                                          const EdgeInsets.only(
                                              right: 3.0,
                                              left: 0.0,
                                              top: 0.0,
                                              bottom: 30.0),
                                          elevation: 10,
                                          shadowColor: MyColors
                                              .colorGray_666BC,
                                          child: SfDateRangePicker(
                                            initialDisplayDate:
                                            _selectedDate !=
                                                null
                                                ? _selectedDate
                                                : DateTime
                                                .now(),
                                            view:
                                            DateRangePickerView
                                                .month,
                                            todayHighlightColor:
                                            MyColors.red,
                                            allowViewNavigation:
                                            true,
                                            showNavigationArrow:
                                            true,
                                            navigationMode:
                                            DateRangePickerNavigationMode
                                                .snap,
                                            endRangeSelectionColor:
                                            MyColors
                                                .kPrimaryColor,
                                            rangeSelectionColor:
                                            MyColors
                                                .kPrimaryColor,
                                            selectionColor: MyColors
                                                .kPrimaryColor,
                                            startRangeSelectionColor:
                                            MyColors
                                                .kPrimaryColor,
                                            onSelectionChanged:
                                            _onSelectionChanged,
                                            selectionMode:
                                            DateRangePickerSelectionMode
                                                .single,
                                            onSubmit: (value) {
                                              StartDatePickerController!.text =
                                                  value.toString();
                                            },
                                            initialSelectedRange: PickerDateRange(
                                                DateTime.now()
                                                    .subtract(
                                                    const Duration(
                                                        days:
                                                        4)),
                                                DateTime.now().add(
                                                    const Duration(
                                                        days: 3))),
                                          ),
                                        ),
                                      )
                                          : SizedBox(),
                                      // _webDatePicker == true ?   DayPickerPage(
                                      //   selectedYear: "",
                                      //   controller: StartDatePickerController,
                                      // ) : SizedBox(),
                                    ],
                                  ),
                                  /*DatePickerTextfieldWidget(
                                          suffixIcon: MyIcons.calendar,
                                          labelText: MyStrings.startDate,
                                          controller:
                                              StartDatePickerController,
                                          //validator: ValidateInput.verifyDOB,
                                          onSave: (value) {
                                            StartDatePickerController.text =
                                                value;
                                            // print(provider.startDateController.text);
                                            print(value);
                                          },
                                        ),*/
                                )
                                    : Container(),
                                _value == MyStrings.weekly ||
                                    _value == MyStrings.daily
                                    ? Focus(
                                  focusNode: _node,
                                  onFocusChange: (bool focus) {
                                    setState(() {
                                      _webDatePicker == true
                                          ? _webDatePicker = false
                                          : _webDatePicker = false;
                                      _webDatePicker1 == true
                                          ? _webDatePicker1 = false
                                          : _webDatePicker1 = false;
                                    });
                                  },
                                  child: Listener(
                                    onPointerDown: (_) {
                                      FocusScope.of(context)
                                          .requestFocus(_node);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(
                                          PaddingSize.boxPaddingAllSide),
                                      child: Column(
                                        children: [
                                          Focus(
                                            focusNode: _node,
                                            onFocusChange: (bool focus) {
                                              setState(() {
                                                _webDatePicker == true
                                                    ? _webDatePicker =
                                                false
                                                    : _webDatePicker =
                                                false;
                                                _webDatePicker1 == true
                                                    ? _webDatePicker1 =
                                                false
                                                    : _webDatePicker1 =
                                                false;
                                              });
                                            },
                                            child: Listener(
                                              onPointerDown: (_) {
                                                FocusScope.of(context)
                                                    .requestFocus(_node);
                                              },
                                              child:
                                              DatePickerTextfieldWidget(
                                                suffixIcon:
                                                MyIcons.calendar,
                                                labelText:
                                                MyStrings.endDate,
                                                controller:
                                                EndDatePickerController,
                                                inputAction:
                                                TextInputAction.done,
                                                //validator: ValidateInput.verifyDOB,
                                                onTab: () {
                                                  setState(() {
                                                    // _webDatePicker1 == true
                                                    //     ? _webDatePicker1 = false
                                                    //     : _webDatePicker1 = true;
                                                    // _webDatePicker == true ? _webDatePicker = false : _webDatePicker = false;

                                                    Navigator.of(context)
                                                        .pop();
                                                    selectRepeat(size);
                                                  });
                                                },

                                                onSave: (value) {
                                                  EndDatePickerController!
                                                      .text = value!;
                                                  // print(provider.startDateController.text);

                                                  print(value);
                                                },
                                              ),
                                            ),
                                          ),
                                          _webDatePicker1 == true &&
                                              getValueForScreenType<
                                                  bool>(
                                                context: context,
                                                mobile: false,
                                                tablet: false,
                                                desktop: true,
                                              )
                                              ? Container(
                                            width: 330,
                                            child: Card(
                                              margin:
                                              const EdgeInsets
                                                  .only(
                                                  right: 3.0,
                                                  left: 0.0,
                                                  top: 0.0,
                                                  bottom: 30.0),
                                              elevation: 10,
                                              shadowColor: MyColors
                                                  .colorGray_666BC,
                                              child:
                                              SfDateRangePicker(
                                                initialDisplayDate:
                                                _selectedDate !=
                                                    null
                                                    ? _selectedDate
                                                    : DateTime
                                                    .now(),
                                                view:
                                                DateRangePickerView
                                                    .month,
                                                todayHighlightColor:
                                                MyColors.red,
                                                allowViewNavigation:
                                                true,
                                                showNavigationArrow:
                                                true,
                                                navigationMode:
                                                DateRangePickerNavigationMode
                                                    .snap,
                                                endRangeSelectionColor:
                                                MyColors
                                                    .kPrimaryColor,
                                                rangeSelectionColor:
                                                MyColors
                                                    .kPrimaryColor,
                                                selectionColor:
                                                MyColors
                                                    .kPrimaryColor,
                                                startRangeSelectionColor:
                                                MyColors
                                                    .kPrimaryColor,
                                                onSelectionChanged:
                                                _onSelectionChange,
                                                selectionMode:
                                                DateRangePickerSelectionMode
                                                    .single,
                                                onSubmit: (value) {
                                                  EndDatePickerController!.text =
                                                      value.toString();
                                                },
                                                initialSelectedRange: PickerDateRange(
                                                    DateTime.now().subtract(
                                                        const Duration(
                                                            days:
                                                            4)),
                                                    DateTime.now().add(
                                                        const Duration(
                                                            days:
                                                            3))),
                                              ),
                                            ),
                                          )
                                              : SizedBox(),
                                        ],
                                      ), /*DatePickerTextfieldWidget(
                                              suffixIcon: MyIcons.calendar,
                                              labelText: MyStrings.endDate,
                                              controller:
                                                  EndDatePickerController,
                                              // validator: ValidateInput.verifyDOB,
                                              onSave: (value) {
                                                EndDatePickerController.text =
                                                    value;
                                                // print(provider.startDateController.text);
                                                print(value);
                                              },
                                            ),*/
                                    ),
                                  ),
                                )
                                    : Container(),
                                _value == MyStrings.weekly
                                    ? WeekdaySelector(
                                  elevation: PaddingSize.cardElevation,
                                  /* shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(Dimens.standard_12)),*/
                                  onChanged: (int day) {
                                    setState(() {
                                      // Use module % 7 as Sunday's index in the array is 0 and
                                      // DateTime.sunday constant integer value is 7.
                                      final index = day % 7;
                                      // We "flip" the value in this example, but you may also
                                      // perform validation, a DB write, an HTTP call or anything
                                      // else before you actually flip the value,
                                      // it's up to your app's needs.
                                      weekdayvalues[index] =
                                      !weekdayvalues[index];
                                      Navigator.of(context).pop();
                                      selectRepeat(size);
                                    });
                                  },
                                  values: weekdayvalues,
                                )
                                    : Container(),
                              ]),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ));
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

  showMemberList(Size size) {
    List<UserMailListTemp> localOwnerMailList = [];
    List<UserMailListTemp> localPlayerMailList = [];
    List<UserMailListTemp> localNonPlayerMailList = [];
    for(int i=0;i<ownerMailList.length;i++){
      UserMailListTemp userMailListTemp=UserMailListTemp();
      userMailListTemp.isEnable=ownerMailList[i].isEnable;
      userMailListTemp.name=ownerMailList[i].name;
      userMailListTemp.id=ownerMailList[i].id;
      userMailListTemp.email=ownerMailList[i].email;
      userMailListTemp.userIDNo=ownerMailList[i].userIDNo;
      userMailListTemp.FCMTokenID=ownerMailList[i].FCMTokenID;
      userMailListTemp.rollId=ownerMailList[i].rollId;
      localOwnerMailList.add(userMailListTemp);
    }
    for(int i=0;i<playerMailList.length;i++){
      UserMailListTemp userMailListTemp=UserMailListTemp();
      userMailListTemp.isEnable=playerMailList[i].isEnable;
      userMailListTemp.name=playerMailList[i].name;
      userMailListTemp.id=playerMailList[i].id;
      userMailListTemp.email=playerMailList[i].email;
      userMailListTemp.userIDNo=playerMailList[i].userIDNo;
      userMailListTemp.FCMTokenID=playerMailList[i].FCMTokenID;
      userMailListTemp.rollId=playerMailList[i].rollId;
      localPlayerMailList.add(userMailListTemp);
    }
    for(int i=0;i<nonPlayerMailList.length;i++){
      UserMailListTemp userMailListTemp=UserMailListTemp();
      userMailListTemp.isEnable=nonPlayerMailList[i].isEnable;
      userMailListTemp.name=nonPlayerMailList[i].name;
      userMailListTemp.id=nonPlayerMailList[i].id;
      userMailListTemp.email=nonPlayerMailList[i].email;
      userMailListTemp.userIDNo=nonPlayerMailList[i].userIDNo;
      userMailListTemp.FCMTokenID=nonPlayerMailList[i].FCMTokenID;
      userMailListTemp.rollId=nonPlayerMailList[i].rollId;
      localNonPlayerMailList.add(userMailListTemp);
    }

    /*List<UserMailList> localOwnerMailList = [];
    List<UserMailList> localPlayerMailList = [];
    List<UserMailList> localNonPlayerMailList = [];
    localOwnerMailList.addAll(ownerMailList);
    localPlayerMailList.addAll(playerMailList);
    localNonPlayerMailList.addAll(nonPlayerMailList);*/
    bool coach=coachSelectAll;
    bool player=playerSelectAll;
    bool nonPlayer=nonPlayerSelectAll;
    showDialog(
        context: context,
        builder: (context) =>StatefulBuilder(builder:
            (BuildContext context,
            StateSetter setState) {
              return TopBar(
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
                              title: MyStrings.selectMembers,
                              iconLeft: MyIcons.cancel,
                              tooltipMessageLeft: MyStrings.cancel,
                              iconRight:MyIcons.done,tooltipMessageRight: MyStrings.save,
                              onClickLeftImage: () {
                                Navigator.of(context).pop();
                              },
                               onClickRightImage: (){
                                 ownerMailList=[];
                                 playerMailList=[];
                                 nonPlayerMailList=[];
                                 for(int i=0;i<localOwnerMailList.length;i++){
                                   UserMailList userMailListTemp=UserMailList();
                                   userMailListTemp.isEnable=localOwnerMailList[i].isEnable;
                                   userMailListTemp.name=localOwnerMailList[i].name;
                                   userMailListTemp.id=localOwnerMailList[i].id;
                                   userMailListTemp.email=localOwnerMailList[i].email;
                                   userMailListTemp.userIDNo=localOwnerMailList[i].userIDNo;
                                   userMailListTemp.FCMTokenID=localOwnerMailList[i].FCMTokenID;
                                   userMailListTemp.rollId=localOwnerMailList[i].rollId;
                                   ownerMailList.add(userMailListTemp);
                                 }
                                 for(int i=0;i<localPlayerMailList.length;i++){
                                   UserMailList userMailListTemp=UserMailList();
                                   userMailListTemp.isEnable=localPlayerMailList[i].isEnable;
                                   userMailListTemp.name=localPlayerMailList[i].name;
                                   userMailListTemp.id=localPlayerMailList[i].id;
                                   userMailListTemp.email=localPlayerMailList[i].email;
                                   userMailListTemp.userIDNo=localPlayerMailList[i].userIDNo;
                                   userMailListTemp.FCMTokenID=localPlayerMailList[i].FCMTokenID;
                                   userMailListTemp.rollId=localPlayerMailList[i].rollId;
                                   playerMailList.add(userMailListTemp);
                                 }
                                 for(int i=0;i<localNonPlayerMailList.length;i++){
                                   UserMailList userMailListTemp=UserMailList();
                                   userMailListTemp.isEnable=localNonPlayerMailList[i].isEnable;
                                   userMailListTemp.name=localNonPlayerMailList[i].name;
                                   userMailListTemp.id=localNonPlayerMailList[i].id;
                                   userMailListTemp.email=localNonPlayerMailList[i].email;
                                   userMailListTemp.userIDNo=localNonPlayerMailList[i].userIDNo;
                                   userMailListTemp.FCMTokenID=localNonPlayerMailList[i].FCMTokenID;
                                   userMailListTemp.rollId=localNonPlayerMailList[i].rollId;
                                   nonPlayerMailList.add(userMailListTemp);
                                 }

                                 coachSelectAll=coach;
                                 playerSelectAll=player;
                                 nonPlayerSelectAll=nonPlayer;
                            Navigator.of(context).pop();
                          },
                            ),
                            body: SizedBox(
                              height: 870,
                              child: Padding(
                                padding: EdgeInsets.all(
                                    getValueForScreenType<bool>(
                                      context: context,
                                      mobile: false,
                                      tablet: true,
                                      desktop: true,
                                    )
                                        ? PaddingSize.headerPadding1
                                        : PaddingSize.headerPadding2),
                                child: SingleChildScrollView(
                                  controller: ScrollController(),
                                  child: new
                                  Column(children: <Widget>[
                                    if(localOwnerMailList.length > 0)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Material(
                                        child: SizedBox(
                                          height: SizedBoxSize
                                              .checkSizedBoxHeight,
                                          width:
                                          SizedBoxSize
                                              .checkSizedBoxWidth,
                                          child: Checkbox(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(2.0),
                                              side: BorderSide(
                                                color: Colors.grey,
                                                width: 1.5,
                                              ),

                                            ),

                                            side: BorderSide(

                                              color: Colors.grey,
                                              width: 1.5,
                                            ),
                                            checkColor: MyColors.black,
                                            activeColor: Colors.grey[400],
                                            value: coach,
                                            onChanged: (value) {
                                              setState(() {
                                                coach=value!;
                                                for(int i=0;i<localOwnerMailList.length;i++){
                                                  localOwnerMailList[i].isEnable=value;
                                                }
                                              });
                                            },
                                          ),
                                        ),),
                                      Expanded(
                                        child: Container(
                                          width: 250,
                                          child: ListTile(
                                            title: Text(
                                              MyStrings.ownerRole+"&"+
                                              MyStrings.managerRole,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                ),
                                  ),

                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20.0),
                                      child: ListView.builder(
                                        physics:
                                        NeverScrollableScrollPhysics(),
                                        controller: ScrollController(),
                                        shrinkWrap: true, // new
                                        itemCount: localOwnerMailList == null
                                            ? 0
                                            : localOwnerMailList.length,
                                        itemBuilder:
                                            (BuildContext context,
                                            int index) {
                                          return Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Material(
                                                child: SizedBox(
                                                  height: SizedBoxSize
                                                      .checkSizedBoxHeight,
                                                  width:
                                                  SizedBoxSize
                                                      .checkSizedBoxWidth,
                                                  child: Checkbox(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(2.0),
                                                      side: BorderSide(
                                                        color: Colors.grey,
                                                        width: 1.5,
                                                      ),

                                                    ),

                                                    side: BorderSide(

                                                      color: Colors.grey,
                                                      width: 1.5,
                                                    ),
                                                    checkColor: MyColors.black,
                                                    activeColor: Colors.grey[400],
                                                    value: localOwnerMailList[index]
                                                        .isEnable,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        localOwnerMailList[index]
                                                            .isEnable = value!;

                                                        for(int i=0;i<localOwnerMailList.length;i++){
                                                          if(localOwnerMailList[i].isEnable==false){
                                                            coach = false;
                                                            return;
                                                          }else{
                                                            coach = true;
                                                          }
                                                        }
                                                      });
                                                    },
                                                  ),
                                                ),),
                                              Expanded(
                                                child: Container(
                                                  width: 250,
                                                  child: ListTile(
                                                    title: Text(
                                                      localOwnerMailList[index].name!,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                    Divider(),
                                    if(localPlayerMailList.length > 0)
                                      Padding(
                                        padding: const EdgeInsets.only(left: 10.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Material(
                                              child: SizedBox(
                                                height: SizedBoxSize
                                                    .checkSizedBoxHeight,
                                                width:
                                                SizedBoxSize
                                                    .checkSizedBoxWidth,
                                                child: Checkbox(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(2.0),
                                                    side: BorderSide(
                                                      color: Colors.grey,
                                                      width: 1.5,
                                                    ),

                                                  ),

                                                  side: BorderSide(

                                                    color: Colors.grey,
                                                    width: 1.5,
                                                  ),
                                                  checkColor: MyColors.black,
                                                  activeColor: Colors.grey[400],
                                                  value: player,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      player=value!;
                                                      for(int i=0;i<localPlayerMailList.length;i++){
                                                        localPlayerMailList[i].isEnable=value;
                                                      }
                                                    });
                                                  },
                                                ),
                                              ),),
                                            Expanded(
                                              child: Container(
                                                width: 250,
                                                child: ListTile(
                                                  title: Text(
                                                    MyStrings.playerRole,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20.0),
                                      child: ListView.builder(
                                        physics:
                                        NeverScrollableScrollPhysics(),
                                        controller: ScrollController(),
                                        shrinkWrap: true, // new
                                        itemCount: localPlayerMailList == null
                                            ? 0
                                            : localPlayerMailList.length,
                                        itemBuilder:
                                            (BuildContext context,
                                            int index) {
                                          return Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Material(
                                                child: SizedBox(
                                                  height: SizedBoxSize
                                                      .checkSizedBoxHeight,
                                                  width:
                                                  SizedBoxSize
                                                      .checkSizedBoxWidth,
                                                  child: Checkbox(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(2.0),
                                                      side: BorderSide(
                                                        color: Colors.grey,
                                                        width: 1.5,
                                                      ),

                                                    ),

                                                    side: BorderSide(

                                                      color: Colors.grey,
                                                      width: 1.5,
                                                    ),
                                                    checkColor: MyColors.black,
                                                    activeColor: Colors.grey[400],
                                                    value: localPlayerMailList[index]
                                                        .isEnable,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        localPlayerMailList[index]
                                                            .isEnable = value!;
                                                        for(int i=0;i<localPlayerMailList.length;i++){
                                                          if(localPlayerMailList[i].isEnable==false){
                                                            player = false;
                                                            return;
                                                          }else{
                                                            player = true;
                                                          }
                                                        }
                                                      });
                                                    },
                                                  ),
                                                ),),
                                              Expanded(
                                                child: Container(
                                                  width: 250,
                                                  child: ListTile(
                                                    title: Text(
                                                      localPlayerMailList[index]
                                                          .name!,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                    Divider(),
                                    if(localNonPlayerMailList.length > 0)
                                      Padding(
                                        padding: const EdgeInsets.only(left: 10.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Material(
                                              child: SizedBox(
                                                height: SizedBoxSize
                                                    .checkSizedBoxHeight,
                                                width:
                                                SizedBoxSize
                                                    .checkSizedBoxWidth,
                                                child: Checkbox(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(2.0),
                                                    side: BorderSide(
                                                      color: Colors.grey,
                                                      width: 1.5,
                                                    ),

                                                  ),

                                                  side: BorderSide(

                                                    color: Colors.grey,
                                                    width: 1.5,
                                                  ),
                                                  checkColor: MyColors.black,
                                                  activeColor: Colors.grey[400],
                                                  value: nonPlayer,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      nonPlayer=value!;
                                                      for(int i=0;i<localNonPlayerMailList.length;i++){
                                                        localNonPlayerMailList[i].isEnable=value;
                                                      }
                                                    });
                                                  },
                                                ),
                                              ),),
                                            Expanded(
                                              child: Container(
                                                width: 250,
                                                child: ListTile(
                                                  title: Text(
                                                    MyStrings.nonPlayerRole + "/" +
                                                        MyStrings.familyRole,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20.0),
                                      child: ListView.builder(
                                        physics:
                                        NeverScrollableScrollPhysics(),
                                        shrinkWrap: true, // new
                                        controller: ScrollController(),
                                        itemCount: localNonPlayerMailList == null
                                            ? 0
                                            : localNonPlayerMailList.length,
                                        itemBuilder:
                                            (BuildContext context,
                                            int index) {
                                          return Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Material(
                                                child: SizedBox(
                                                  height: SizedBoxSize
                                                      .checkSizedBoxHeight,
                                                  width:
                                                  SizedBoxSize
                                                      .checkSizedBoxWidth,
                                                  child: Checkbox(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(2.0),
                                                      side: BorderSide(
                                                        color: Colors.grey,
                                                        width: 1.5,
                                                      ),

                                                    ),

                                                    side: BorderSide(

                                                      color: Colors.grey,
                                                      width: 1.5,
                                                    ),
                                                    checkColor: MyColors.black,
                                                    activeColor: Colors.grey[400],
                                                    value: localNonPlayerMailList[index]
                                                        .isEnable,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        localNonPlayerMailList[index]
                                                            .isEnable = value!;
                                                        for(int i=0;i<localNonPlayerMailList.length;i++){
                                                          if(localNonPlayerMailList[i].isEnable==false){
                                                            nonPlayer = false;
                                                            return;
                                                          }else{
                                                            nonPlayer = true;
                                                          }
                                                        }
                                                      });
                                                    },
                                                  ),
                                                ),),
                                              Expanded(
                                                child: Container(
                                                  width: 250,
                                                  child: ListTile(
                                                    title: Text(
                                                      localNonPlayerMailList[index]
                                                          .name!,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),

                                  ]
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ))
                  ],
                ),
              );
            }
        ));
  }



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return TopBar(
      child: WebCard(
        marginVertical: 20,
        marginhorizontal: 40,
        child: Scaffold(
            backgroundColor: MyColors.white,
            appBar: CustomAppBar(
                title: MyStrings.addSportEvent,
                iconRight: MyIcons.done,
                tooltipMessageRight: MyStrings.save,

                iconLeft: MyIcons.backwardArrow,
                tooltipMessageLeft: MyStrings.back,
                onClickRightImage: () {
                  addGame();



                  /*Navigation.navigatePushNamedAndRemoveAll(
                      context, MyRoutes.teamSetupScreen);*/
                }),
            body: Consumer<AddEventProvider>(builder: (context, provider, _) {
              return Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.disabled,
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
                    controller: _scrollController,
                    child: Column(
                      // shrinkWrap: true,
                      // addAutomaticKeepAlives: true,
                      // controller: _scrollController,
                      children: <Widget>[
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
                                  MyStrings.sportEvent,
                                  style: TextStyle(
                                    fontSize: FontSize.headerFontSize5,
                                  ),
                                ),
                              ),
                              Focus(
                                focusNode: _node,
                                onFocusChange: (bool focus) {
                                  setState(() {
                                    showTimezone == true
                                        ? showTimezone = false
                                        : showTimezone = false;
                                    showFlagColor == true
                                        ? showFlagColor = false
                                        : showFlagColor = false;
                                    showHomeAway == true
                                        ? showHomeAway = false
                                        : showHomeAway = false;
                                    arriveEarlyColor == true
                                        ? arriveEarlyColor = false
                                        : arriveEarlyColor = false;
                                    showduration == true
                                        ? showduration = false
                                        : showduration = false;
                                    showDateTime == true
                                        ? showDateTime = false
                                        : showDateTime = false;
                                    showTime == true
                                        ? showTime = false
                                        : showTime = false;
                                    _webDatePicker == true
                                        ? _webDatePicker = false
                                        : _webDatePicker = false;
                                    _webDatePicker1 == true
                                        ? _webDatePicker1 = false
                                        : _webDatePicker1 = false;
                                  });
                                },
                                child: Listener(
                                  onPointerDown: (_) {
                                    FocusScope.of(context).requestFocus(_node);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        0.0, 0.0, 8.0, 0.0),
                                    child:  MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: LiteRollingSwitch(
                                        //initial value
                                        value: provider.selectSwithValue,
                                        textOn: MyStrings.game,
                                        textOff: MyStrings.event,
                                        colorOn: MyColors.kPrimaryColor,
                                        colorOff: MyColors.kPrimaryColor,
                                        iconOn: Icons.sports_hockey,
                                        iconOff: Icons.event,
                                        enable: true,
                                        textSize: FontSize.headerFontSize5,
                                        onChanged: (value) =>
                                        {
                                          provider.selectSwithValue = value,
                                        },
                                        onTap: () {
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Focus(
                          focusNode: _node,
                          onFocusChange: (bool focus) {
                            setState(() {
                              showTimezone == true
                                  ? showTimezone = false
                                  : showTimezone = false;
                              showFlagColor == true
                                  ? showFlagColor = false
                                  : showFlagColor = false;
                              showHomeAway == true
                                  ? showHomeAway = false
                                  : showHomeAway = false;
                              arriveEarlyColor == true
                                  ? arriveEarlyColor = false
                                  : arriveEarlyColor = false;
                              showduration == true
                                  ? showduration = false
                                  : showduration = false;
                              showDateTime == true
                                  ? showDateTime = false
                                  : showDateTime = false;
                              showTime == true
                                  ? showTime = false
                                  : showTime = false;
                              _webDatePicker == true
                                  ? _webDatePicker = false
                                  : _webDatePicker = false;
                              _webDatePicker1 == true
                                  ? _webDatePicker1 = false
                                  : _webDatePicker1 = false;
                            });
                          },
                          child: Listener(
                            onPointerDown: (_) {
                              FocusScope.of(context).requestFocus(_node);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(
                                  PaddingSize.boxPaddingAllSide),
                              child: Padding(
                                padding:
                                const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                                child: CustomizeTextFormField(
                                  labelText: provider.selectSwithValue == false
                                      ? MyStrings.eventName + "*"
                                      : MyStrings.gameName + "*",
                                  prefixIcon: MyIcons.group,
                                  controller: provider.gameNameController,
                                  inputAction:
                                  TextInputAction
                                      .next,
                                  onFieldSubmit: (v){
                                    FocusScope.of(context).requestFocus(_addressnode);
                                  },
                                  inputFormatter: [
                                    new LengthLimitingTextInputFormatter(50),
                                    FilteringTextInputFormatter.deny(RegExp("/")),
                                  ],
                                  // suffixImage: MyImages.dropDown,
                                  isEnabled: true,
                                  validator: provider.selectSwithValue == false
                                      ? ValidateInput.requiredEventFields
                                      : ValidateInput.requiredGameFields,
                                  onSave: (value) {
                                    provider.gameNameController!.text = value!;
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),

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
                                  MyStrings.timeTbds,
                                  style: TextStyle(
                                    fontSize: FontSize.headerFontSize5,
                                  ),
                                ),
                              ),
                              Focus(
                                focusNode: _node,
                                onFocusChange: (bool focus) {
                                  setState(() {
                                    showTimezone == true
                                        ? showTimezone = false
                                        : showTimezone = false;
                                    showFlagColor == true
                                        ? showFlagColor = false
                                        : showFlagColor = false;
                                    showHomeAway == true
                                        ? showHomeAway = false
                                        : showHomeAway = false;
                                    arriveEarlyColor == true
                                        ? arriveEarlyColor = false
                                        : arriveEarlyColor = false;
                                    showduration == true
                                        ? showduration = false
                                        : showduration = false;
                                    showDateTime == true
                                        ? showDateTime = false
                                        : showDateTime = false;
                                    showTime == true
                                        ? showTime = false
                                        : showTime = false;
                                    _webDatePicker == true
                                        ? _webDatePicker = false
                                        : _webDatePicker = false;
                                    _webDatePicker1 == true
                                        ? _webDatePicker1 = false
                                        : _webDatePicker1 = false;
                                  });
                                },
                                child: Listener(
                                  onPointerDown: (_) {
                                    FocusScope.of(context).requestFocus(_node);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        0.0, 0.0, 8.0, 0.0),
                                    child:  MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: CupertinoSwitch(
                                        value: provider.timeSwitchValue,
                                        activeColor: MyColors.kPrimaryColor,
                                        onChanged: (value) {
                                          setState(() {
                                            provider.timeSwitchValue = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.all(PaddingSize.boxPaddingAllSide),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //
                        //     children: [
                        //       Padding(
                        //         padding: const EdgeInsets.all(PaddingSize.boxPaddingAllSide),
                        //         child: Text(
                        //           MyStrings.date,
                        //           style: TextStyle(
                        //             fontSize: FontSize.headerFontSize5,
                        //           ),
                        //         ),
                        //       ),
                        //
                        //       Row(
                        //         children: [
                        //           Text(
                        //             MyStrings.teamName,
                        //             style: TextStyle(
                        //               fontSize: FontSize.headerFontSize5,
                        //             ),
                        //           ),
                        //           IconButton(
                        //             icon: MyIcons.arrowIos,
                        //             onPressed: () {
                        //               showCupertinoModalPopup<void>(
                        //                 context: context,
                        //                 builder: (BuildContext context) {
                        //                   return _buildBottomPicker(
                        //                     CupertinoDatePicker(
                        //                       mode: CupertinoDatePickerMode.date,
                        //                       maximumYear: 2022,
                        //                       minimumYear: 1994,
                        //                       initialDateTime: dateTime,
                        //                       onDateTimeChanged: (DateTime newDateTime) {
                        //                         if (mounted) {
                        //                           print("Your Selected Date: ${newDateTime}");
                        //                           setState(() => dateTime = newDateTime);
                        //                         }
                        //                       },
                        //                     ),
                        //                   );
                        //                 },
                        //               );
                        //             },
                        //           ),
                        //         ],
                        //       ),
                        //
                        //     ],
                        //   ),
                        // ),
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
                                  MyStrings.repeats,
                                  style: TextStyle(
                                    fontSize: FontSize.headerFontSize5,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  // if(_addEventProvider.repeatvalue==MyStrings.daily)
                                  // Text("From "+_addEventProvider.StartDatePickerController.text+" To "+_addEventProvider.EndDatePickerController.text+
                                  //   " – occurs every day",
                                  //   style: TextStyle(
                                  //       fontSize: FontSize.headerFontSize5),
                                  // ),
                                  // if(_addEventProvider.repeatvalue==MyStrings.weekly)
                                  //   Text(
                                  //   _addEventProvider.repeatvalue,
                                  //   style: TextStyle(
                                  //       fontSize: FontSize.headerFontSize5),
                                  // ),
                                  // if(_addEventProvider.repeatvalue==MyStrings.doesNotRepeat)
                                    Text(
                                      _addEventProvider!.repeatvalue,
                                      style: TextStyle(
                                          fontSize: FontSize.headerFontSize5),
                                    ),
                                  Focus(
                                    focusNode: _node,
                                    onFocusChange: (bool focus) {
                                      setState(() {
                                        showTimezone == true
                                            ? showTimezone = false
                                            : showTimezone = false;
                                        showFlagColor == true
                                            ? showFlagColor = false
                                            : showFlagColor = false;
                                        showHomeAway == true
                                            ? showHomeAway = false
                                            : showHomeAway = false;
                                        arriveEarlyColor == true
                                            ? arriveEarlyColor = false
                                            : arriveEarlyColor = false;
                                        showduration == true
                                            ? showduration = false
                                            : showduration = false;
                                        showDateTime == true
                                            ? showDateTime = false
                                            : showDateTime = false;
                                        showTime == true
                                            ? showTime = false
                                            : showTime = false;
                                        _webDatePicker == true
                                            ? _webDatePicker = false
                                            : _webDatePicker = false;
                                        _webDatePicker1 == true
                                            ? _webDatePicker1 = false
                                            : _webDatePicker1 = false;
                                      });
                                    },
                                    child: Listener(
                                      onPointerDown: (_) {
                                        FocusScope.of(context)
                                            .requestFocus(_node);
                                      },
                                      child: IconButton(
                                        icon: MyIcons.arrowIos,
                                        onPressed: () {
                                          Navigation.navigateWithArgument(
                                              context, MyRoutes.repeatScreen,false);
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if(_addEventProvider!.repeatvalue==MyStrings.daily)
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all( 16),
                                child: Text("From "+_addEventProvider!.StartDatePickerController!.text+" To "+_addEventProvider!.EndDatePickerController!.text+
                                    " – occurs every day",
                                  style: TextStyle(
                                      fontSize: FontSize.headerFontSize5),
                                ),
                              ),
                            ],
                          ),
                        if(_addEventProvider!.repeatvalue==MyStrings.weekly)
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all( 16),

                                  child: Text("From "+_addEventProvider!.StartDatePickerController!.text+" To "+_addEventProvider!.EndDatePickerController!.text+
                                      " – occurs every "+_addEventProvider!.selectedDays,
                                    style: TextStyle(
                                        fontSize: FontSize.headerFontSize5),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        //provider.timeSwitchValue == false
                        if(_addEventProvider!.repeatvalue==MyStrings.doesNotRepeat)
                         Padding(
                          padding: const EdgeInsets.all(
                              PaddingSize.boxPaddingAllSide),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(
                                    PaddingSize.boxPaddingAllSide),
                                child: Text(
                                  MyStrings.date,
                                  style: TextStyle(
                                    fontSize: FontSize.headerFontSize5,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    provider.dateTime
                                        .toString()
                                        .substring(0, 10),
                                    style: TextStyle(
                                      fontSize: FontSize.footerFontSize5,
                                    ),
                                  ),
                                  IconButton(
                                    icon: MyIcons.arrowIos,
                                    onPressed: () {
                                      setState(() {
                                        SystemChannels.textInput.invokeMethod('TextInput.hide');

                                        showDateTime == false
                                            ? showDateTime = true
                                            : showDateTime = false;
                                        showTime == true
                                            ? showTime = false
                                            : showTime = false;
                                        showTimezone == true
                                            ? showTimezone = false
                                            : showTimezone = false;
                                        showFlagColor == true
                                            ? showFlagColor = false
                                            : showFlagColor = false;
                                        showHomeAway == true
                                            ? showHomeAway = false
                                            : showHomeAway = false;
                                        arriveEarlyColor == true
                                            ? arriveEarlyColor = false
                                            : arriveEarlyColor = false;
                                        showduration == true
                                            ? showduration = false
                                            : showduration = false;

                                        _webDatePicker == true
                                            ? _webDatePicker = false
                                            : _webDatePicker = false;
                                        _webDatePicker1 == true
                                            ? _webDatePicker1 = false
                                            : _webDatePicker1 = false;
                                      });

                                      if (getValueForScreenType<bool>(
                                        context: context,
                                        mobile: true,
                                        tablet: false,
                                        desktop: false,
                                      ))
                                        showCupertinoModalPopup<void>(
                                          context: context,
                                          builder:
                                              (BuildContext context) {
                                            return _buildBottomPicker(
                                              CupertinoDatePicker(
                                                mode:
                                                CupertinoDatePickerMode
                                                    .date,
                                               /* minimumDate: DateFormat("yMd")
                                                    .parse(
                                                    DateFormat('yMd').format(
                                                        DateTime.now())),*/
                                                minimumDate: DateTime.now().subtract( Duration(minutes:30,)),
                                                maximumYear: 2050,
                                                minimumYear: int.parse(
                                                    DateFormat('y')
                                                        .format(DateTime
                                                        .now())),
                                                initialDateTime:
                                                provider.dateTime,
                                                onDateTimeChanged:
                                                    (DateTime
                                                newDateTime) {
                                                  print(
                                                      "Your Selected Date: ${newDateTime
                                                          .toString().substring(
                                                          0, 20)}");
                                                  setState(() =>
                                                  provider.dateTime =
                                                      newDateTime);
                                                },
                                              ),
                                            );
                                          },
                                        );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if(showDateTime == true  && getValueForScreenType<bool>(
                          context: context,
                          mobile: false,
                          tablet: true,
                          desktop: true,
                        ))
                          Focus(
                            focusNode: _node,
                            onFocusChange: (bool focus) {

                            },
                            child: Listener(
                              onPointerDown: (_) {
                                FocusScope.of(context).requestFocus(FocusNode());
                                },
                              child: Container(
                                width:330,
                                child: Card(
                                  margin: const EdgeInsets.only(
                                      right: 3.0,
                                      left: 3.0,
                                      top : 0.0,
                                      bottom: 30.0),
                                  elevation: 10,
                                  shadowColor: MyColors
                                      .colorGray_666BC,
                                  child: SfDateRangePicker( initialDisplayDate: provider.dateTime,
                                    initialSelectedDate:provider.dateTime ,
                                    view: DateRangePickerView.month,
                                    todayHighlightColor: MyColors
                                        .red,
                                    allowViewNavigation: true,
                                    showNavigationArrow: true,
                                    navigationMode: DateRangePickerNavigationMode
                                        .snap,
                                    endRangeSelectionColor: MyColors
                                        .kPrimaryColor,
                                    rangeSelectionColor: MyColors
                                        .kPrimaryColor,
                                    selectionColor: MyColors
                                        .kPrimaryColor,
                                    startRangeSelectionColor: MyColors
                                        .kPrimaryColor,
                                    onSelectionChanged: _onSelectionChanged,
                                    selectionMode: DateRangePickerSelectionMode
                                        .single,
                                    onSubmit: (value){
                                      provider.dateTime = value as DateTime;
                                    },

                                    initialSelectedRange: PickerDateRange(
                                        DateTime.now().subtract(const Duration(days: 4)),
                                        DateTime.now().add(const Duration(days: 3))),
                                  ),
                                ),
                              ),
                            ),
                          ),

                        if(provider.timeSwitchValue == false)
                        Padding(
                          padding: const EdgeInsets.all(
                              PaddingSize.boxPaddingAllSide),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(
                                    PaddingSize.boxPaddingAllSide),
                                child: Text(
                                  MyStrings.time,
                                  style: TextStyle(
                                    fontSize: FontSize.headerFontSize5,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    DateFormat('h:mma').format(provider.time),
                              // DateFormat.jm().format(provider.time),
                                    style: TextStyle(
                                      fontSize: FontSize.footerFontSize5,
                                    ),
                                  ),
                                  IconButton(
                                    icon: MyIcons.arrowIos,
                                    onPressed: () {
                                      setState(() {
                                        showDateTime == true
                                            ? showDateTime = false
                                            : showDateTime = false;
                                        showTime == false
                                            ? showTime = true
                                            : showTime = false;
                                        showTimezone == true
                                            ? showTimezone = false
                                            : showTimezone = false;
                                        showFlagColor == true
                                            ? showFlagColor = false
                                            : showFlagColor = false;
                                        showHomeAway == true
                                            ? showHomeAway = false
                                            : showHomeAway = false;
                                        arriveEarlyColor == true
                                            ? arriveEarlyColor = false
                                            : arriveEarlyColor = false;
                                        showduration == true
                                            ? showduration = false
                                            : showduration = false;

                                        _webDatePicker == true
                                            ? _webDatePicker = false
                                            : _webDatePicker = false;
                                        _webDatePicker1 == true
                                            ? _webDatePicker1 = false
                                            : _webDatePicker1 = false;
                                      });

                                      if (getValueForScreenType<bool>(
                                        context: context,
                                        mobile: true,
                                        tablet: false,
                                        desktop: false,
                                      ))
                                        showCupertinoModalPopup<void>(
                                          context: context,
                                          builder:
                                              (BuildContext context) {
                                            return _buildBottomPicker(
                                              CupertinoDatePicker(
                                                mode:
                                                CupertinoDatePickerMode
                                                    .time,
                                                /* minimumDate: DateFormat("yMd")
                                                    .parse(
                                                    DateFormat('yMd').format(
                                                        DateTime.now())),*/
                                                minimumDate: DateTime.now().subtract( Duration(minutes:30,)),
                                                maximumYear: 2050,
                                                minimumYear: int.parse(
                                                    DateFormat('y')
                                                        .format(DateTime
                                                        .now())),
                                                initialDateTime:
                                                provider.time,
                                                onDateTimeChanged:
                                                    (DateTime
                                                newDateTime) {
                                                  print(
                                                      "Your Selected Date: ${newDateTime
                                                          .toString().substring(
                                                          0, 20)}");
                                                  setState(() =>
                                                  provider
                                                      .time =
                                                      newDateTime);
                                                },
                                              ),
                                            );
                                          },
                                        );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if(showTime == true && provider.timeSwitchValue == false && getValueForScreenType<bool>(
                          context: context,
                          mobile: false,
                          tablet: true,
                          desktop: true,
                        ))
                          TimePickerDialog(
                            initialTime: TimeOfDay.fromDateTime(provider.time),
                            initialEntryMode: TimePickerEntryMode.input,
                            // onEditingComplete: () => FocusScope.of(context).nextFocus(),
                            onClick: (value){
                              setState(() {
                                provider.time=new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, value.hour, value.minute);
                                showTime=false;
                              });
                              print(value.toString());
                            },
                          ),
                        getValueForScreenType<bool>(
                          context: context,
                          mobile: true,
                          tablet: false,
                          desktop: false,
                        )
                            ? Focus(
                          focusNode: _node,
                          onFocusChange: (bool focus) {
                            setState(() {
                              showTimezone == true
                                  ? showTimezone = false
                                  : showTimezone = false;
                              showFlagColor == true
                                  ? showFlagColor = false
                                  : showFlagColor = false;
                              showHomeAway == true
                                  ? showHomeAway = false
                                  : showHomeAway = false;
                              arriveEarlyColor == true
                                  ? arriveEarlyColor = false
                                  : arriveEarlyColor = false;
                              showduration == true
                                  ? showduration = false
                                  : showduration = false;
                              showDateTime == true
                                  ? showDateTime = false
                                  : showDateTime = false;
                              showTime == true
                                  ? showTime = false
                                  : showTime = false;
                              _webDatePicker == true
                                  ? _webDatePicker = false
                                  : _webDatePicker = false;
                              _webDatePicker1 == true
                                  ? _webDatePicker1 = false
                                  : _webDatePicker1 = false;
                            });
                          },
                          child: Listener(
                            onPointerDown: (_) {
                              FocusScope.of(context).requestFocus(_node);

                            },
                            child: _timeZone.length > 0
                                ? SmartSelect<String>.single(
                              title: MyStrings.timeZone,
                              placeholder: provider.timezoneController!
                                  .text.isNotEmpty
                                  ? provider.timezoneController!.text
                                  : MyStrings.selectOne,
                              value: _selectedTimeZone,
                              modalFilter: true,
                              modalFilterAuto: true,
                              modalType: S2ModalType.fullPage,
                              choiceType: S2ChoiceType.radios,

                              /*onChange: (state) => setState(
                                                                  () => _selectedTimeZone =
                                                                  state.value),*/
                              onChange: (state) {
                                if (state.value.isNotEmpty) {
                                  print("Marlen 12" + state.value);
                                  _selectedTimeZone = state.value;
                                  provider.timezoneController!.text =
                                      state.valueDisplay;
                                }
                              },
                              choiceItems: _timeZone,
                              choiceDivider: true,
                            )
                                : Container(),
                          ),
                        )
                            : SizedBox(),
                        if (getValueForScreenType<bool>(
                          context: context,
                          mobile: false,
                          tablet: false,
                          desktop: true,
                        ) ||
                            getValueForScreenType<bool>(
                              context: context,
                              mobile: false,
                              tablet: true,
                              desktop: false,
                            ))
                          Padding(
                            padding: const EdgeInsets.all(
                                PaddingSize.boxPaddingAllSide),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(
                                      PaddingSize.boxPaddingAllSide),
                                  child: Text(
                                    MyStrings.timeZone,
                                    style: TextStyle(
                                      fontSize: FontSize.headerFontSize5,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      _selectedTimeZone,
                                      style: TextStyle(
                                          fontSize: FontSize.headerFontSize5),
                                    ),
                                    IconButton(
                                      icon: MyIcons.arrowIos,
                                      onPressed: () {
                                        setState(() {

                                          showTimezone == true ?
                                          showTimezone = false :
                                          showTimezone = true;
                                          showFlagColor == true
                                              ? showFlagColor = false
                                              : showFlagColor = false;
                                          showHomeAway == true
                                              ? showHomeAway = false
                                              : showHomeAway = false;
                                          arriveEarlyColor == true
                                              ? arriveEarlyColor = false
                                              : arriveEarlyColor = false;
                                          showduration == true
                                              ? showduration = false
                                              : showduration = false;
                                          showDateTime == true
                                              ? showDateTime = false
                                              : showDateTime = false;
                                          showTime == true
                                              ? showTime = false
                                              : showTime = false;
                                          _webDatePicker == true
                                              ? _webDatePicker = false
                                              : _webDatePicker = false;
                                          _webDatePicker1 == true
                                              ? _webDatePicker1 = false
                                              : _webDatePicker1 = false;
                                        });
                                        //selectRepeat(size);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                        if (showTimezone == true)
                          Card(
                            elevation: 10,
                            shadowColor: MyColors.colorGray_666BC,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(
                                      PaddingSize.boxPaddingAllSide),
                                  child: CustomizeTextFormField(
                                    inputFormatter: [
                                      new LengthLimitingTextInputFormatter(
                                          30),
                                    ],
                                    labelText: MyStrings.search,
                                    //  prefixIcon: MyIcons.group,
                                    controller: searchController,
                                    // suffixImage: MyImages.dropDown,
                                    isEnabled: true,
                                    // validator: ValidateInput.requiredFields,
                                    onChange: (value) {
                                      setState(() {
                                        _getJsonTimeZoneSearchAsync(value);
                                      });
                                    },
                                    onSave: (value) {
                                      searchController.text = value!;
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 180,
                                  child: SingleChildScrollView(
                                    controller: ScrollController(),
                                    child: Container(
                                      child: Column(
                                        children: _timeZone
                                            .map((data) =>
                                            RadioListTile(
                                              title: Text("${data.title}"),
                                              groupValue: id,
                                              value: data.group,
                                              activeColor:
                                              MyColors.kPrimaryColor,
                                              onChanged: (val) {
                                                setState(() {
                                                  _selectedTimeZone =
                                                      data.title;
                                                  provider.timezoneController!.text =data.title;
                                                  id = data.group;
                                                  showTimezone == true ?
                                                  showTimezone = false :
                                                  showTimezone = true;
                                                  showFlagColor == true
                                                      ? showFlagColor = false
                                                      : showFlagColor = false;
                                                  showHomeAway == true
                                                      ? showHomeAway = false
                                                      : showHomeAway = false;
                                                  arriveEarlyColor == true
                                                      ? arriveEarlyColor =
                                                  false
                                                      : arriveEarlyColor =
                                                  false;
                                                  showduration == true
                                                      ? showduration = false
                                                      : showduration = false;
                                                  _webDatePicker == true
                                                      ? _webDatePicker = false
                                                      : _webDatePicker =
                                                  false;
                                                  _webDatePicker1 == true
                                                      ? _webDatePicker1 =
                                                  false
                                                      : _webDatePicker1 =
                                                  false;
                                                });
                                              },
                                            ))
                                            .toList(),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        provider.selectSwithValue == false
                            ? SizedBox()
                            : Padding(
                          padding: const EdgeInsets.all(
                              PaddingSize.boxPaddingAllSide),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(
                                    PaddingSize.boxPaddingAllSide),
                                child: Text(
                                  MyStrings.opponent+"*",
                                  style: TextStyle(
                                    fontSize: FontSize.headerFontSize5,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    _addEventProvider!
                                        .opponentNameController!.text,
                                    style: TextStyle(
                                      fontSize: FontSize.headerFontSize5,
                                    ),
                                  ),
                                  Focus(
                                    focusNode: _node,
                                    onFocusChange: (bool focus) {
                                      setState(() {
                                        showTimezone == true
                                            ? showTimezone = false
                                            : showTimezone = false;
                                        showFlagColor == true
                                            ? showFlagColor = false
                                            : showFlagColor = false;
                                        showHomeAway == true
                                            ? showHomeAway = false
                                            : showHomeAway = false;
                                        arriveEarlyColor == true
                                            ? arriveEarlyColor = false
                                            : arriveEarlyColor = false;
                                        showduration == true
                                            ? showduration = false
                                            : showduration = false;
                                        showDateTime == true
                                            ? showDateTime = false
                                            : showDateTime = false;
                                        showTime == true
                                            ? showTime = false
                                            : showTime = false;
                                        _webDatePicker == true
                                            ? _webDatePicker = false
                                            : _webDatePicker = false;
                                        _webDatePicker1 == true
                                            ? _webDatePicker1 = false
                                            : _webDatePicker1 = false;
                                      });
                                    },
                                    child: Listener(
                                      onPointerDown: (_) {
                                        FocusScope.of(context)
                                            .requestFocus(_node);
                                      },
                                      child: IconButton(
                                          icon: MyIcons.arrowIos,
                                          onPressed: () =>
                                          {
                                            Navigation.navigateTo(
                                                context,
                                                MyRoutes
                                                    .opponentListviewScreen)
                                          }),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        /* SmartSelect<String>.single(
                          title: MyStrings.repeats,
                          placeholder: MyStrings.selectOne,
                          value: _selectedRepeat,
                          modalType: S2ModalType.popupDialog,
                          choiceType: S2ChoiceType.radios,
                          onChange: (state) =>
                              setState(() => _selectedRepeat = state.value),
                          choiceItems: _choiceRepeat,
                          choiceDivider: true,
                        ),
*/


                        Focus(
                          focusNode: _node,
                          onFocusChange: (bool focus) {
                            setState(() {
                              showTimezone == true
                                  ? showTimezone = false
                                  : showTimezone = false;
                              showFlagColor == true
                                  ? showFlagColor = false
                                  : showFlagColor = false;
                              showHomeAway == true
                                  ? showHomeAway = false
                                  : showHomeAway = false;
                              arriveEarlyColor == true
                                  ? arriveEarlyColor = false
                                  : arriveEarlyColor = false;
                              showduration == true
                                  ? showduration = false
                                  : showduration = false;
                              showDateTime == true
                                  ? showDateTime = false
                                  : showDateTime = false;
                              showTime == true
                                  ? showTime = false
                                  : showTime = false;
                              _webDatePicker == true
                                  ? _webDatePicker = false
                                  : _webDatePicker = false;
                              _webDatePicker1 == true
                                  ? _webDatePicker1 = false
                                  : _webDatePicker1 = false;
                            });
                          },
                          child: Listener(
                            onPointerDown: (_) {
                              FocusScope.of(context).requestFocus(_node);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(
                                  PaddingSize.boxPaddingAllSide),
                              child: Padding(
                                padding:
                                const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                                child: CustomizeTextFormField(
                                  //maxLines: FontSize.textMaxLine,
                                  //minLines: FontSize.textMinLine,
                                  keyboardType: TextInputType.multiline,
                                  labelText: getValueForScreenType<bool>(
                                    context: context,
                                    mobile: false,
                                    tablet: true,
                                    desktop: true,
                                  )
                                      ? MyStrings.address + "*"
                                      : MyStrings.address + "*",
                                  // prefixIcon: MyIcons.lo,
                                  inputFormatter: [
                                    new LengthLimitingTextInputFormatter(100),
                                  ],
                                  inputAction:
                                  TextInputAction
                                      .done,
                                  isLast: true,
                                  focusNode: _addressnode,
                                  controller: provider.locationDetailsController,
                                  // suffixImage: MyImages.dropDown,
                                  isEnabled: true,
                                  validator: getValueForScreenType<bool>(
                                    context: context,
                                    mobile: false,
                                    tablet: true,
                                    desktop: true,
                                  )
                                      ? ValidateInput.requiredAddressFields
                                      : ValidateInput.requiredLocationFields,

                                  onSave: (value) {
                                    provider.locationDetailsController!.text =
                                        value!;
                                  },
                                  onChange: (value) {
                                    // From a query
                                    getLocationDetails(value);
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (getValueForScreenType<bool>(
                          context: context,
                          mobile: true,
                          tablet: true,
                          desktop: false,
                        ) &&
                            lat != null &&
                            lon != null)
                          Padding(
                            padding: const EdgeInsets.all(
                                PaddingSize.boxPaddingAllSide),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(
                                      PaddingSize.boxPaddingAllSide),
                                  child: Text(
                                    "Preview " + MyStrings.location,
                                    style: TextStyle(
                                      fontSize: FontSize.headerFontSize5,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      selectedPlace2 == null
                                          ? ""
                                          : selectedPlace2!.formattedAddress,
                                      style: TextStyle(
                                        fontSize: FontSize.headerFontSize5,
                                      ),
                                    ),
                                    Focus(
                                      focusNode: _node,
                                      onFocusChange: (bool focus) {
                                        setState(() {
                                          showTimezone == true
                                              ? showTimezone = false
                                              : showTimezone = false;
                                          showFlagColor == true
                                              ? showFlagColor = false
                                              : showFlagColor = false;
                                          showHomeAway == true
                                              ? showHomeAway = false
                                              : showHomeAway = false;
                                          arriveEarlyColor == true
                                              ? arriveEarlyColor = false
                                              : arriveEarlyColor = false;
                                          showduration == true
                                              ? showduration = false
                                              : showduration = false;
                                          showDateTime == true
                                              ? showDateTime = false
                                              : showDateTime = false;
                                          showTime == true
                                              ? showTime = false
                                              : showTime = false;
                                          _webDatePicker == true
                                              ? _webDatePicker = false
                                              : _webDatePicker = false;
                                          _webDatePicker1 == true
                                              ? _webDatePicker1 = false
                                              : _webDatePicker1 = false;
                                        });
                                      },
                                      child: Listener(
                                        onPointerDown: (_) {
                                          FocusScope.of(context)
                                              .requestFocus(_node);
                                        },
                                        child: IconButton(
                                          icon: MyIcons.arrowIos,
                                          onPressed: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                                      return PlacePicker(
                                                        apiKey:
                                                        "AIzaSyDz8EFbgghWcXJZojgVcIkRCwZS3he1uBU",
                                                        initialPosition: LatLng(
                                                            lat, lon),
                                                        useCurrentLocation: false,
                                                        selectInitialPosition: true,
                                                        //usePlaceDetailSearch: true,
                                                        onPlacePicked: (result) {
                                                          selectedPlace2 = result;
                                                          Navigator.of(context)
                                                              .pop();
                                                          setState(() {
                                                            selectedPlace2 =
                                                                result;
                                                            print(selectedPlace2);
                                                          });
                                                        },
                                                      );
                                                    }));
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        // Padding(
                        //   padding: const EdgeInsets.all(PaddingSize.boxPaddingAllSide),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       Padding(
                        //         padding: const EdgeInsets.all(PaddingSize.boxPaddingAllSide),
                        //         child: Text(
                        //           MyStrings.locationDetails,
                        //           style: TextStyle(
                        //             fontSize: FontSize.headerFontSize5,
                        //           ),
                        //         ),
                        //       ),
                        //       IconButton(icon: MyIcons.arrowIos, onPressed: ()=> {
                        //       Alert(
                        //       context: context,
                        //       title: "Location Detail",
                        //       content: Column(
                        //       children: <Widget>[
                        //       TextField(
                        //       decoration: InputDecoration(
                        //       icon: Icon(Icons.account_circle),
                        //       labelText: 'Fill the Place of Address',
                        //       ),
                        //       ),
                        //         TextField(
                        //           obscureText: true,
                        //           decoration: InputDecoration(
                        //             icon: Icon(Icons.lock),
                        //             labelText: 'Weblink',
                        //           ),
                        //         ),
                        //         TextField(
                        //           obscureText: true,
                        //           decoration: InputDecoration(
                        //             icon: Icon(Icons.lock),
                        //             labelText:"Notes",
                        //           ),
                        //         ),
                        //       ],
                        //       ),
                        //       buttons: [
                        //       DialogButton(
                        //         color: MyColors.kPrimaryColor,
                        //       onPressed: () => Navigator.pop(context),
                        //       child: Text( "Ok",
                        //       style: TextStyle(color: Colors.white, fontSize: 20),
                        //       ),
                        //       )
                        //       ]).show()
                        //       }),
                        //     ],
                        //   ),
                        // ),
                        if (getValueForScreenType<bool>(
                          context: context,
                          mobile: true,
                          tablet: false,
                          desktop: false,
                        ))
                          Focus(
                            focusNode: _node,
                            onFocusChange: (bool focus) {
                              setState(() {
                                showTimezone == true
                                    ? showTimezone = false
                                    : showTimezone = false;
                                showFlagColor == true
                                    ? showFlagColor = false
                                    : showFlagColor = false;
                                showHomeAway == true
                                    ? showHomeAway = false
                                    : showHomeAway = false;
                                arriveEarlyColor == true
                                    ? arriveEarlyColor = false
                                    : arriveEarlyColor = false;
                                showduration == true
                                    ? showduration = false
                                    : showduration = false;
                                showDateTime == true
                                    ? showDateTime = false
                                    : showDateTime = false;
                                showTime == true
                                    ? showTime = false
                                    : showTime = false;
                                _webDatePicker == true
                                    ? _webDatePicker = false
                                    : _webDatePicker = false;
                                _webDatePicker1 == true
                                    ? _webDatePicker1 = false
                                    : _webDatePicker1 = false;
                              });
                            },
                            child: Listener(
                              onPointerDown: (_) {
                                FocusScope.of(context).requestFocus(_node);
                              },
                              child: SmartSelect<String>.single(
                                modalHeaderStyle: S2ModalHeaderStyle(
                                  textStyle: TextStyle(color: Colors.black),
                                ),
                                title: MyStrings.homeAway,
                                placeholder: MyStrings.selectOne,
                                choiceConfig: S2ChoiceConfig(),
                                value: provider.selectedHomeAway,
                                modalType: S2ModalType.bottomSheet,
                                choiceType: S2ChoiceType.radios,
                                onChange: (state) =>
                                    setState(() =>
                                    provider.selectedHomeAway = state.valueDisplay),
                                choiceItems: _choiceHomeAway,
                                choiceDivider: true,
                              ),
                            ),
                          ),
                        if (getValueForScreenType<bool>(
                          context: context,
                          mobile: false,
                          tablet: true,
                          desktop: true,
                        ))
                          Focus(
                            focusNode: _node,
                            onFocusChange: (bool focus) {

                            },
                            child: Listener(
                              onPointerDown: (_) {
                                FocusManager.instance.primaryFocus!.unfocus();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(
                                    PaddingSize.boxPaddingAllSide),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(
                                          PaddingSize.boxPaddingAllSide),
                                      child: Text(
                                        MyStrings.homeAway,
                                        style: TextStyle(
                                          fontSize: FontSize.headerFontSize5,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          provider.selectedHomeAway == null
                                              ? ""
                                              : provider.selectedHomeAway!,
                                          style: TextStyle(
                                            fontSize: FontSize.headerFontSize5,
                                          ),
                                        ),
                                        IconButton(
                                          icon: MyIcons.arrowIos,
                                          onPressed: () {
                                            setState(() {
                                              showHomeAway =
                                              showHomeAway == true ? false : true;
                                              showTimezone == true
                                                  ? showTimezone = false
                                                  : showTimezone = false;
                                              showFlagColor == true
                                                  ? showFlagColor = false
                                                  : showFlagColor = false;
                                              arriveEarlyColor == true
                                                  ? arriveEarlyColor = false
                                                  : arriveEarlyColor = false;
                                              showduration == true
                                                  ? showduration = false
                                                  : showduration = false;
                                              showDateTime == true
                                                  ? showDateTime = false
                                                  : showDateTime = false;
                                              showTime == true
                                                  ? showTime = false
                                                  : showTime = false;
                                              _webDatePicker == true
                                                  ? _webDatePicker = false
                                                  : _webDatePicker = false;
                                              _webDatePicker1 == true
                                                  ? _webDatePicker1 = false
                                                  : _webDatePicker1 = false;
                                            });
                                            //selectRepeat(size);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        if (showHomeAway == true)
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 80),
                            child: Column(children: <Widget>[
                              ListTile(
                                title: Text(MyStrings.home),
                                leading: Radio(
                                  value: MyStrings.home,
                                  groupValue: provider.selectedHomeAway,
                                  activeColor: MyColors.kPrimaryColor,
                                  onChanged: (String? value) {
                                    setState(() {
                                      provider.selectedHomeAway = value;
                                      showHomeAway = false;
                                      showTimezone == true
                                          ? showTimezone = false
                                          : showTimezone = false;
                                      showFlagColor == true
                                          ? showFlagColor = false
                                          : showFlagColor = false;
                                      arriveEarlyColor == true
                                          ? arriveEarlyColor = false
                                          : arriveEarlyColor = false;
                                      showduration == true
                                          ? showduration = false
                                          : showduration = false;
                                      showDateTime == true
                                          ? showDateTime = false
                                          : showDateTime = false;
                                      showTime == true
                                          ? showTime = false
                                          : showTime = false;
                                      _webDatePicker == true
                                          ? _webDatePicker = false
                                          : _webDatePicker = false;
                                      _webDatePicker1 == true
                                          ? _webDatePicker1 = false
                                          : _webDatePicker1 = false;
                                    });
                                  },
                                ),
                              ),
                              ListTile(
                                title: Text(MyStrings.away),
                                leading: Radio(
                                  value: MyStrings.away,
                                  groupValue: provider.selectedHomeAway,
                                  activeColor: MyColors.kPrimaryColor,
                                  onChanged: (String? value) {
                                    setState(() {
                                      provider.selectedHomeAway = value;
                                      showHomeAway = false;
                                      showTimezone == true
                                          ? showTimezone = false
                                          : showTimezone = false;
                                      showFlagColor == true
                                          ? showFlagColor = false
                                          : showFlagColor = false;
                                      arriveEarlyColor == true
                                          ? arriveEarlyColor = false
                                          : arriveEarlyColor = false;
                                      showduration == true
                                          ? showduration = false
                                          : showduration = false;
                                      showDateTime == true
                                          ? showDateTime = false
                                          : showDateTime = false;
                                      showTime == true
                                          ? showTime = false
                                          : showTime = false;
                                      _webDatePicker == true
                                          ? _webDatePicker = false
                                          : _webDatePicker = false;
                                      _webDatePicker1 == true
                                          ? _webDatePicker1 = false
                                          : _webDatePicker1 = false;
                                    });
                                  },
                                ),
                              ),
                              ListTile(
                                title: Text(MyStrings.timeTbd),
                                leading: Radio(
                                  value: MyStrings.timeTbd,
                                  groupValue: provider.selectedHomeAway,
                                  activeColor: MyColors.kPrimaryColor,
                                  onChanged: (String? value) {
                                    setState(() {
                                      provider.selectedHomeAway = value;
                                      showHomeAway = false;
                                      showTimezone == true
                                          ? showTimezone = false
                                          : showTimezone = false;
                                      showFlagColor == true
                                          ? showFlagColor = false
                                          : showFlagColor = false;
                                      arriveEarlyColor == true
                                          ? arriveEarlyColor = false
                                          : arriveEarlyColor = false;
                                      showduration == true
                                          ? showduration = false
                                          : showduration = false;
                                      showDateTime == true
                                          ? showDateTime = false
                                          : showDateTime = false;
                                      showTime == true
                                          ? showTime = false
                                          : showTime = false;
                                      _webDatePicker == true
                                          ? _webDatePicker = false
                                          : _webDatePicker = false;
                                      _webDatePicker1 == true
                                          ? _webDatePicker1 = false
                                          : _webDatePicker1 = false;
                                    });
                                  },
                                ),
                              ),
                            ]),
                          ),

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
                                  MyStrings.duration,
                                  style: TextStyle(
                                    fontSize: FontSize.headerFontSize5,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    provider.duration.isNotEmpty
                                        ? (provider.duration)
                                        .split(':')
                                        .first +
                                        " hr " +
                                        (provider.duration)
                                            .split(':')
                                            .last +
                                        " min"
                                        : "",
                                    style: TextStyle(
                                      fontSize: FontSize.headerFontSize5,
                                    ),
                                  ),
                                  Focus(
                                    // focusNode: _node,
                                    onFocusChange: (bool focus) {
                                      // setState(() {
                                      //
                                      //   showTimezone == true
                                      //       ? showTimezone = false
                                      //       : showTimezone = false;
                                      //   showFlagColor == true
                                      //       ? showFlagColor = false
                                      //       : showFlagColor = false;
                                      //   showHomeAway == true
                                      //       ? showHomeAway = false
                                      //       : showHomeAway = false;
                                      //   arriveEarlyColor == true
                                      //       ? arriveEarlyColor = false
                                      //       : arriveEarlyColor = false;
                                      //   showduration == true
                                      //       ? showduration = false
                                      //       : showduration = false;
                                      //   showDateTime == true
                                      //       ? showDateTime = false
                                      //       : showDateTime = false;
                                      //   showTime == true
                                      //       ? showTime = false
                                      //       : showTime = false;
                                      //   _webDatePicker == true
                                      //       ? _webDatePicker = false
                                      //       : _webDatePicker = false;
                                      //   _webDatePicker1 == true
                                      //       ? _webDatePicker1 = false
                                      //       : _webDatePicker1 = false;
                                      // });
                                    },
                                    child: Listener(
                                      onPointerDown: (_) {
                                        // FocusScope.of(context)
                                        //     .requestFocus(_node);
                                      },
                                      child: IconButton(
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
                                                    mode: CupertinoTimerPickerMode
                                                        .hm,
                                                    initialTimerDuration:provider.initialDuration!,
                                                    onTimerDurationChanged:
                                                        (duration) {
                                                      setState(() {
                                                        provider.initialDuration=duration;
                                                        provider.duration =
                                                            duration
                                                                .toString()
                                                                .substring(0, 4);
                                                      });
                                                    },
                                                  ),
                                                );
                                              },
                                            );
                                          else
                                            setState(() {
                                              showduration = showduration == true
                                                  ? false
                                                  : true;
                                              showTimezone == true
                                                  ? showTimezone = false
                                                  : showTimezone = false;
                                              showFlagColor == true
                                                  ? showFlagColor = false
                                                  : showFlagColor = false;
                                              showHomeAway == true
                                                  ? showHomeAway = false
                                                  : showHomeAway = false;
                                              arriveEarlyColor == true
                                                  ? arriveEarlyColor = false
                                                  : arriveEarlyColor = false;
                                              showDateTime == true
                                                  ? showDateTime = false
                                                  : showDateTime = false;
                                              showTime == true
                                                  ? showTime = false
                                                  : showTime = false;
                                              _webDatePicker == true
                                                  ? _webDatePicker = false
                                                  : _webDatePicker = false;
                                              _webDatePicker1 == true
                                                  ? _webDatePicker1 = false
                                                  : _webDatePicker1 = false;
                                            });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (showduration == true)
                        // ScrollConfiguration(
                        //   behavior: ScrollConfiguration.of(context)
                        //       .copyWith(scrollbars: false),
                        //   child: TimePickerSpinner(
                        //     is24HourMode: false,
                        //     /* normalTextStyle:
                        //     TextStyle(fontSize: 24, color: Colors.deepOrange),
                        // highlightedTextStyle:
                        //     TextStyle(fontSize: 24, color: Colors.yellow), */
                        //     spacing: 20,
                        //     itemHeight: 40,
                        //     isForce2Digits: true,
                        //     onTimeChange: (time) {
                        //       setState(() {
                        //         provider.duration = time.hour.toString() +
                        //             ":" +
                        //             time.minute.toString();
                        //       });
                        //     },
                        //   ),
                        // ),

                          MediaQuery(data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true), child: TimePickerDialog(
                            initialTime: TimeOfDay.fromDateTime(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, provider.duration.isNotEmpty
                                ? int.parse((provider.duration)
                                .split(':')
                                .first):0, provider.duration.isNotEmpty
                                ? int.parse((provider.duration)
                                .split(':')
                                .last):0)),
                            initialEntryMode: TimePickerEntryMode.input,
                            onClick: (value){
                              setState(() {
                                provider.duration=(value.hour.toString()+ ":"+ value.minute.toString());
                                showduration=false;
                              });
                            },

                          ),
                          ),

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
                                  MyStrings.arriveEarly,
                                  style: TextStyle(
                                    fontSize: FontSize.headerFontSize5,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    provider.arriveEarly.isNotEmpty
                                        ? (provider.arriveEarly)
                                        .split(':')
                                        .first +
                                        " hr " +
                                        (provider.arriveEarly)
                                            .split(':')
                                            .last +
                                        " min"
                                        : "",
                                    style: TextStyle(
                                      fontSize: FontSize.headerFontSize5,
                                    ),
                                  ),
                                  Focus(
                                    // focusNode: _node,
                                    onFocusChange: (bool focus) {
                                      // setState(() {
                                      //   showTimezone == true
                                      //       ? showTimezone = false
                                      //       : showTimezone = false;
                                      //   showFlagColor == true
                                      //       ? showFlagColor = false
                                      //       : showFlagColor = false;
                                      //   showHomeAway == true
                                      //       ? showHomeAway = false
                                      //       : showHomeAway = false;
                                      //   arriveEarlyColor == true
                                      //       ? arriveEarlyColor = false
                                      //       : arriveEarlyColor = false;
                                      //   showduration == true
                                      //       ? showduration = false
                                      //       : showduration = false;
                                      //   showDateTime == true
                                      //       ? showDateTime = false
                                      //       : showDateTime = false;
                                      //   showTime == true
                                      //       ? showTime = false
                                      //       : showTime = false;
                                      //   _webDatePicker == true
                                      //       ? _webDatePicker = false
                                      //       : _webDatePicker = false;
                                      //   _webDatePicker1 == true
                                      //       ? _webDatePicker1 = false
                                      //       : _webDatePicker1 = false;
                                      // });
                                    },
                                    child: Listener(
                                      onPointerDown: (_) {
                                        // FocusScope.of(context)
                                        //     .requestFocus(_node);
                                      },
                                      child: IconButton(
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
                                                    mode: CupertinoTimerPickerMode
                                                        .hm,
                                                    initialTimerDuration:provider.initialArriveEarly!,
                                                    onTimerDurationChanged:
                                                        (arriveEarly) {
                                                      setState(() {
                                                        provider.initialArriveEarly=arriveEarly;
                                                        provider.arriveEarly =
                                                            arriveEarly
                                                                .toString()
                                                                .substring(0, 4);
                                                      });
                                                    },
                                                  ),
                                                );
                                              },
                                            );
                                          else
                                            setState(() {
                                              arriveEarlyColor =
                                              arriveEarlyColor == true
                                                  ? false
                                                  : true;
                                              showTimezone == true
                                                  ? showTimezone = false
                                                  : showTimezone = false;
                                              showFlagColor == true
                                                  ? showFlagColor = false
                                                  : showFlagColor = false;
                                              showHomeAway == true
                                                  ? showHomeAway = false
                                                  : showHomeAway = false;
                                              showduration == true
                                                  ? showduration = false
                                                  : showduration = false;
                                              showDateTime == true
                                                  ? showDateTime = false
                                                  : showDateTime = false;
                                              showTime == true
                                                  ? showTime = false
                                                  : showTime = false;
                                              _webDatePicker == true
                                                  ? _webDatePicker = false
                                                  : _webDatePicker = false;
                                              _webDatePicker1 == true
                                                  ? _webDatePicker1 = false
                                                  : _webDatePicker1 = false;
                                            });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (arriveEarlyColor == true)
                        // ScrollConfiguration(
                        //   behavior: ScrollConfiguration.of(context)
                        //       .copyWith(scrollbars: false),
                        //   child: TimePickerSpinner(
                        //     is24HourMode: false,
                        //     /* normalTextStyle:
                        //       TextStyle(fontSize: 24, color: Colors.deepOrange),
                        //   highlightedTextStyle:
                        //       TextStyle(fontSize: 24, color: Colors.yellow), */
                        //     spacing: 20,
                        //     itemHeight: 40,
                        //     isForce2Digits: true,
                        //     onTimeChange: (time) {
                        //       setState(() {
                        //         provider.arriveEarly = time.hour.toString() +
                        //             ":" +
                        //             time.minute.toString();
                        //       });
                        //     },
                        //   ),
                        // ),
                          MediaQuery(data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true), child:new TimePickerDialog(
                            initialTime: TimeOfDay.fromDateTime(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, provider.arriveEarly.isNotEmpty
                                ? int.parse((provider.arriveEarly)
                                .split(':')
                                .first):0, provider.arriveEarly.isNotEmpty
                                ? int.parse((provider.arriveEarly)
                                .split(':')
                                .last):0)),
                            initialEntryMode: TimePickerEntryMode.input,
                            onClick: (value){
                              setState(() {
                                provider.arriveEarly=(value.hour.toString()+ ":"+ value.minute.toString());
                                arriveEarlyColor=false;
                              });
                            },

                          ),
                          ),
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
                                  MyStrings.volunteer,
                                  style: TextStyle(
                                    fontSize: FontSize.headerFontSize5,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Text(provider.volSelected?"Assigned":"",
                                    style: TextStyle(
                                      fontSize: FontSize.headerFontSize5,
                                    ),
                                  ),
                                  Focus(
                                    focusNode: _node,
                                    onFocusChange: (bool focus) {
                                      setState(() {
                                        showTimezone == true
                                            ? showTimezone = false
                                            : showTimezone = false;
                                        showFlagColor == true
                                            ? showFlagColor = false
                                            : showFlagColor = false;
                                        showHomeAway == true
                                            ? showHomeAway = false
                                            : showHomeAway = false;
                                        arriveEarlyColor == true
                                            ? arriveEarlyColor = false
                                            : arriveEarlyColor = false;
                                        showduration == true
                                            ? showduration = false
                                            : showduration = false;
                                        showDateTime == true
                                            ? showDateTime = false
                                            : showDateTime = false;
                                        showTime == true
                                            ? showTime = false
                                            : showTime = false;
                                        _webDatePicker == true
                                            ? _webDatePicker = false
                                            : _webDatePicker = false;
                                        _webDatePicker1 == true
                                            ? _webDatePicker1 = false
                                            : _webDatePicker1 = false;
                                      });
                                    },
                                    child: Listener(
                                      onPointerDown: (_) {
                                        FocusScope.of(context).requestFocus(_node);
                                      },
                                      child: IconButton(
                                          icon: MyIcons.arrowIos,
                                          onPressed: () =>
                                          {
                                            Navigation.navigateTo(context,
                                                MyRoutes.volunteerListviewScreen)
                                          }),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // SmartSelect<String>.multiple(
                        //   title: MyStrings.volunteer,
                        //   choiceItems: _volunteer,
                        //   modalType: S2ModalType.fullPage,
                        //   choiceType: S2ChoiceType.checkboxes,
                        //   onChange: (state) => _selectedVolunteer = state.value,
                        // ),
                        if (getValueForScreenType<bool>(
                          context: context,
                          mobile: true,
                          tablet: false,
                          desktop: false,
                        ))
                          Focus(
                            focusNode: _node,
                            onFocusChange: (bool focus) {
                              setState(() {
                                showTimezone == true
                                    ? showTimezone = false
                                    : showTimezone = false;
                                showFlagColor == true
                                    ? showFlagColor = false
                                    : showFlagColor = false;
                                showHomeAway == true
                                    ? showHomeAway = false
                                    : showHomeAway = false;
                                arriveEarlyColor == true
                                    ? arriveEarlyColor = false
                                    : arriveEarlyColor = false;
                                showduration == true
                                    ? showduration = false
                                    : showduration = false;
                                showDateTime == true
                                    ? showDateTime = false
                                    : showDateTime = false;
                                showTime == true
                                    ? showTime = false
                                    : showTime = false;
                                _webDatePicker == true
                                    ? _webDatePicker = false
                                    : _webDatePicker = false;
                                _webDatePicker1 == true
                                    ? _webDatePicker1 = false
                                    : _webDatePicker1 = false;
                              });
                            },
                            child: Listener(
                              onPointerDown: (_) {
                                FocusScope.of(context).requestFocus(_node);
                              },
                              child: SmartSelect<String>.single(
                                title: MyStrings.flagColor,
                                placeholder: MyStrings.selectOne,
                                value: provider.selectedFlagColor,
                                modalType: S2ModalType.bottomSheet,
                                choiceType: S2ChoiceType.radios,
                                onChange: (state) =>
                                    setState(() =>
                                    provider.selectedFlagColor = state.valueDisplay),
                                choiceItems: _choiceFlagColor,
                                choiceDivider: true,
                              ),
                            ),
                          ),
                        if (getValueForScreenType<bool>(
                          context: context,
                          mobile: false,
                          tablet: true,
                          desktop: true,
                        ))
                          Padding(
                            padding: const EdgeInsets.all(
                                PaddingSize.boxPaddingAllSide),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(
                                      PaddingSize.boxPaddingAllSide),
                                  child: Text(
                                    MyStrings.flagColor,
                                    style: TextStyle(
                                      fontSize: FontSize.headerFontSize5,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      provider.selectedFlagColor == null
                                          ? ""
                                          : provider.selectedFlagColor!,
                                      style: TextStyle(
                                        fontSize: FontSize.headerFontSize5,
                                      ),
                                    ),
                                    IconButton(
                                      icon: MyIcons.arrowIos,
                                      onPressed: () {
                                        setState(() {
                                          showFlagColor = showFlagColor == true
                                              ? false
                                              : true;
                                          showTimezone == true
                                              ? showTimezone = false
                                              : showTimezone = false;
                                          showHomeAway == true
                                              ? showHomeAway = false
                                              : showHomeAway = false;
                                          arriveEarlyColor == true
                                              ? arriveEarlyColor = false
                                              : arriveEarlyColor = false;
                                          showduration == true
                                              ? showduration = false
                                              : showduration = false;
                                          showDateTime == true
                                              ? showDateTime = false
                                              : showDateTime = false;
                                          showTime == true
                                              ? showTime = false
                                              : showTime = false;
                                          _webDatePicker == true
                                              ? _webDatePicker = false
                                              : _webDatePicker = false;
                                          _webDatePicker1 == true
                                              ? _webDatePicker1 = false
                                              : _webDatePicker1 = false;
                                        });
                                        //selectRepeat(size);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        if (showFlagColor == true)
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 80),
                            child: Column(children: <Widget>[
                              ListTile(
                                title: Text(MyStrings.black),
                                leading: Radio(
                                  value: MyStrings.black,
                                  groupValue: provider.selectedFlagColor,
                                  activeColor: MyColors.kPrimaryColor,
                                  onChanged: (String? value) {
                                    setState(() {
                                      provider.selectedFlagColor = value;
                                      showFlagColor = false;
                                      showTimezone == true
                                          ? showTimezone = false
                                          : showTimezone = false;
                                      showHomeAway == true
                                          ? showHomeAway = false
                                          : showHomeAway = false;
                                      arriveEarlyColor == true
                                          ? arriveEarlyColor = false
                                          : arriveEarlyColor = false;
                                      showduration == true
                                          ? showduration = false
                                          : showduration = false;
                                      showDateTime == true
                                          ? showDateTime = false
                                          : showDateTime = false;
                                      showTime == true
                                          ? showTime = false
                                          : showTime = false;
                                      _webDatePicker == true
                                          ? _webDatePicker = false
                                          : _webDatePicker = false;
                                      _webDatePicker1 == true
                                          ? _webDatePicker1 = false
                                          : _webDatePicker1 = false;
                                    });
                                  },
                                ),
                              ),
                              ListTile(
                                title: Text(MyStrings.red),
                                leading: Radio(
                                  value: MyStrings.red,
                                  groupValue: provider.selectedFlagColor,
                                  activeColor: MyColors.kPrimaryColor,
                                  onChanged: (String? value) {
                                    setState(() {
                                      provider.selectedFlagColor = value;
                                      showFlagColor = false;
                                      showTimezone == true
                                          ? showTimezone = false
                                          : showTimezone = false;
                                      showHomeAway == true
                                          ? showHomeAway = false
                                          : showHomeAway = false;
                                      arriveEarlyColor == true
                                          ? arriveEarlyColor = false
                                          : arriveEarlyColor = false;
                                      showduration == true
                                          ? showduration = false
                                          : showduration = false;
                                      showDateTime == true
                                          ? showDateTime = false
                                          : showDateTime = false;
                                      showTime == true
                                          ? showTime = false
                                          : showTime = false;
                                      _webDatePicker == true
                                          ? _webDatePicker = false
                                          : _webDatePicker = false;
                                      _webDatePicker1 == true
                                          ? _webDatePicker1 = false
                                          : _webDatePicker1 = false;
                                    });
                                  },
                                ),
                              ),
                              ListTile(
                                title: Text(MyStrings.green),
                                leading: Radio(
                                  value: MyStrings.green,
                                  groupValue: provider.selectedFlagColor,
                                  activeColor: MyColors.kPrimaryColor,
                                  onChanged: (String? value) {
                                    setState(() {
                                      provider.selectedFlagColor = value;
                                      showFlagColor = false;
                                      showTimezone == true
                                          ? showTimezone = false
                                          : showTimezone = false;
                                      showFlagColor == true
                                          ? showFlagColor = false
                                          : showFlagColor = false;
                                      showHomeAway == true
                                          ? showHomeAway = false
                                          : showHomeAway = false;
                                      arriveEarlyColor == true
                                          ? arriveEarlyColor = false
                                          : arriveEarlyColor = false;
                                      showduration == true
                                          ? showduration = false
                                          : showduration = false;
                                      showDateTime == true
                                          ? showDateTime = false
                                          : showDateTime = false;
                                      showTime == true
                                          ? showTime = false
                                          : showTime = false;
                                      _webDatePicker == true
                                          ? _webDatePicker = false
                                          : _webDatePicker = false;
                                      _webDatePicker1 == true
                                          ? _webDatePicker1 = false
                                          : _webDatePicker1 = false;
                                    });
                                  },
                                ),
                              ),
                            ]),
                          ),

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
                                  MyStrings.sendInvite,
                                  style: TextStyle(
                                    fontSize: FontSize.headerFontSize5,
                                  ),
                                ),
                              ),
                              Focus(
                                focusNode: _node,
                                onFocusChange: (bool focus) {
                                  setState(() {
                                    showTimezone == true
                                        ? showTimezone = false
                                        : showTimezone = false;
                                    showFlagColor == true
                                        ? showFlagColor = false
                                        : showFlagColor = false;
                                    showHomeAway == true
                                        ? showHomeAway = false
                                        : showHomeAway = false;
                                    arriveEarlyColor == true
                                        ? arriveEarlyColor = false
                                        : arriveEarlyColor = false;
                                    showduration == true
                                        ? showduration = false
                                        : showduration = false;
                                    showDateTime == true
                                        ? showDateTime = false
                                        : showDateTime = false;
                                    showTime == true
                                        ? showTime = false
                                        : showTime = false;
                                    _webDatePicker == true
                                        ? _webDatePicker = false
                                        : _webDatePicker = false;
                                    _webDatePicker1 == true
                                        ? _webDatePicker1 = false
                                        : _webDatePicker1 = false;
                                  });
                                },
                                child: Listener(
                                  onPointerDown: (_) {
                                    FocusScope.of(context).requestFocus(_node);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        0.0, 0.0, 8.0, 0.0),
                                    child:  MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: FlutterSwitch(
                                        activeText: "Custom",
                                        inactiveText: "All",
                                        value: provider.mailSwitchValue,
                                        activeColor: MyColors.kPrimaryColor,
                                        inactiveColor: MyColors.kPrimaryColor,
                                        valueFontSize: 14.0,
                                        width: 80,
                                        borderRadius: 30.0,
                                        showOnOff: true,
                                        onToggle: (val) {
                                          setState(() {
                                            if(val){
                                              showMemberList(size);
                                            }
                                            provider.mailSwitchValue = val;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),


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
                                  MyStrings.trackAvail,
                                  style: TextStyle(
                                    fontSize: FontSize.headerFontSize5,
                                  ),
                                ),
                              ),
                              Focus(
                                focusNode: _node,
                                onFocusChange: (bool focus) {
                                  setState(() {
                                    showTimezone == true
                                        ? showTimezone = false
                                        : showTimezone = false;
                                    showFlagColor == true
                                        ? showFlagColor = false
                                        : showFlagColor = false;
                                    showHomeAway == true
                                        ? showHomeAway = false
                                        : showHomeAway = false;
                                    arriveEarlyColor == true
                                        ? arriveEarlyColor = false
                                        : arriveEarlyColor = false;
                                    showduration == true
                                        ? showduration = false
                                        : showduration = false;
                                    showDateTime == true
                                        ? showDateTime = false
                                        : showDateTime = false;
                                    showTime == true
                                        ? showTime = false
                                        : showTime = false;
                                    _webDatePicker == true
                                        ? _webDatePicker = false
                                        : _webDatePicker = false;
                                    _webDatePicker1 == true
                                        ? _webDatePicker1 = false
                                        : _webDatePicker1 = false;
                                  });
                                },
                                child: Listener(
                                  onPointerDown: (_) {
                                    FocusScope.of(context).requestFocus(_node);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        0.0, 0.0, 8.0, 0.0),
                                    child:  MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: CupertinoSwitch(
                                        value: provider.trackSwitchValue,
                                        activeColor: MyColors.kPrimaryColor,
                                        onChanged: (value) {
                                          setState(() {
                                            provider.trackSwitchValue = value;
                                            showTimezone == true
                                                ? showTimezone = false
                                                : showTimezone = false;
                                            showFlagColor == true
                                                ? showFlagColor = false
                                                : showFlagColor = false;
                                            showHomeAway == true
                                                ? showHomeAway = false
                                                : showHomeAway = false;
                                            arriveEarlyColor == true
                                                ? arriveEarlyColor = false
                                                : arriveEarlyColor = false;
                                            showduration == true
                                                ? showduration = false
                                                : showduration = false;
                                            showDateTime == true
                                                ? showDateTime = false
                                                : showDateTime = false;
                                            showTime == true
                                                ? showTime = false
                                                : showTime = false;
                                            _webDatePicker == true
                                                ? _webDatePicker = false
                                                : _webDatePicker = false;
                                            _webDatePicker1 == true
                                                ? _webDatePicker1 = false
                                                : _webDatePicker1 = false;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

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
                                  MyStrings.noteRequire,
                                  style: TextStyle(
                                    fontSize: FontSize.headerFontSize5,
                                  ),
                                ),
                              ),
                              Focus(
                                focusNode: _node,
                                onFocusChange: (bool focus) {
                                  setState(() {
                                    showTimezone == true
                                        ? showTimezone = false
                                        : showTimezone = false;
                                    showFlagColor == true
                                        ? showFlagColor = false
                                        : showFlagColor = false;
                                    showHomeAway == true
                                        ? showHomeAway = false
                                        : showHomeAway = false;
                                    arriveEarlyColor == true
                                        ? arriveEarlyColor = false
                                        : arriveEarlyColor = false;
                                    showduration == true
                                        ? showduration = false
                                        : showduration = false;
                                    showDateTime == true
                                        ? showDateTime = false
                                        : showDateTime = false;
                                    showTime == true
                                        ? showTime = false
                                        : showTime = false;
                                    _webDatePicker == true
                                        ? _webDatePicker = false
                                        : _webDatePicker = false;
                                    _webDatePicker1 == true
                                        ? _webDatePicker1 = false
                                        : _webDatePicker1 = false;
                                  });
                                },
                                child: Listener(
                                  onPointerDown: (_) {
                                    FocusScope.of(context).requestFocus(_node);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        0.0, 0.0, 8.0, 0.0),
                                    child: MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: FlutterSwitch(
                                        activeText: "Required",
                                        inactiveText: "Optional",
                                        value:  provider.noteSwitchValue,
                                        activeColor: MyColors.kPrimaryColor,
                                        inactiveColor: MyColors.kPrimaryColor,
                                        valueFontSize: 14.0,
                                        width: 100,
                                        borderRadius: 30.0,
                                        showOnOff: true,
                                        onToggle: (val) {
                                          setState(() {
                                            provider.noteSwitchValue = val;
                                            showTimezone == true
                                                ? showTimezone = false
                                                : showTimezone = false;
                                            showFlagColor == true
                                                ? showFlagColor = false
                                                : showFlagColor = false;
                                            showHomeAway == true
                                                ? showHomeAway = false
                                                : showHomeAway = false;
                                            arriveEarlyColor == true
                                                ? arriveEarlyColor = false
                                                : arriveEarlyColor = false;
                                            showduration == true
                                                ? showduration = false
                                                : showduration = false;
                                            showDateTime == true
                                                ? showDateTime = false
                                                : showDateTime = false;
                                            showTime == true
                                                ? showTime = false
                                                : showTime = false;
                                            _webDatePicker == true
                                                ? _webDatePicker = false
                                                : _webDatePicker = false;
                                            _webDatePicker1 == true
                                                ? _webDatePicker1 = false
                                                : _webDatePicker1 = false;
                                          });
                                        },
                                      ),
                                    ),/*CupertinoSwitch(
                                      value: provider.noteSwitchValue,
                                      activeColor: MyColors.kPrimaryColor,
                                      onChanged: (value) {
                                        setState(() {
                                          provider.noteSwitchValue = value;
                                          showTimezone == true
                                              ? showTimezone = false
                                              : showTimezone = false;
                                          showFlagColor == true
                                              ? showFlagColor = false
                                              : showFlagColor = false;
                                          showHomeAway == true
                                              ? showHomeAway = false
                                              : showHomeAway = false;
                                          arriveEarlyColor == true
                                              ? arriveEarlyColor = false
                                              : arriveEarlyColor = false;
                                          showduration == true
                                              ? showduration = false
                                              : showduration = false;
                                          showDateTime == true
                                              ? showDateTime = false
                                              : showDateTime = false;
                                          showTime == true
                                              ? showTime = false
                                              : showTime = false;
                                          _webDatePicker == true
                                              ? _webDatePicker = false
                                              : _webDatePicker = false;
                                          _webDatePicker1 == true
                                              ? _webDatePicker1 = false
                                              : _webDatePicker1 = false;
                                        });
                                      },
                                    ),*/
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Focus(
                          focusNode: _node,
                          onFocusChange: (bool focus) {
                            setState(() {
                              showTimezone == true
                                  ? showTimezone = false
                                  : showTimezone = false;
                              showFlagColor == true
                                  ? showFlagColor = false
                                  : showFlagColor = false;
                              showHomeAway == true
                                  ? showHomeAway = false
                                  : showHomeAway = false;
                              arriveEarlyColor == true
                                  ? arriveEarlyColor = false
                                  : arriveEarlyColor = false;
                              showduration == true
                                  ? showduration = false
                                  : showduration = false;
                              showDateTime == true
                                  ? showDateTime = false
                                  : showDateTime = false;
                              showTime == true
                                  ? showTime = false
                                  : showTime = false;
                              _webDatePicker == true
                                  ? _webDatePicker = false
                                  : _webDatePicker = false;
                              _webDatePicker1 == true
                                  ? _webDatePicker1 = false
                                  : _webDatePicker1 = false;
                            });
                          },
                          child: Listener(
                            onPointerDown: (_) {
                              FocusScope.of(context).requestFocus(_node);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(
                                  PaddingSize.boxPaddingAllSide),
                              child: Padding(
                                padding:
                                const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                                child: Scrollbar(
                                  isAlwaysShown: true,
                                  controller: _controllerOne,
                                  child: CustomizeTextFormField(
                                    //maxLines: FontSize.textMaxLine,
                                    labelText: MyStrings.invitationNotes,
                                    prefixIcon: MyIcons.message,
                                    minLines: 3,
                                    maxLines: 3,
                                    inputFormatter: [
                                      new LengthLimitingTextInputFormatter(200),
                                    ],
                                    //minLines: FontSize.textMinLine,
                                    keyboardType: TextInputType.multiline,
                                    inputAction:
                                    TextInputAction.newline,
                                    controller: provider.noteController,
                                    // suffixImage: MyImages.dropDown,
                                    isEnabled: true,
                                    onSave: (value) {
                                      provider.noteController!.text = value!;
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                            height:
                            size.height * SizedBoxSize.footerSizedBoxWidth1),
                        // RaisedButtonCustom(
                        //     buttonColor: MyColors.kPrimaryColor,
                        //     textColor: MyColors.kPrimaryLightColor,
                        //     splashColor: Colors.grey,
                        //     buttonText: MyStrings.save,
                        //     onPressed: () =>
                        //         {Navigation.navigateTo(context, MyRoutes.teamSetupScreen)}),
                      ],
                    ),
                  ),
                ),
              );
            })),
      ),
    );
  }

  void getLocationDetails(String value) async {
    try {
      var addresses = await Geocoder.local.findAddressesFromQuery(value);
      var first = addresses.first;
      print("Marlen Location" + "${first.featureName} : ${first.coordinates}");
      setState(() {
        lat = first.coordinates.latitude;
        lon = first.coordinates.longitude;
      });
    } catch (e) {
      lat = null;
      lon = null;
      print(e);
    }
  }
}

//Static data
List<S2Choice<String>> _choiceTbd = [
  S2Choice<String>(value: '1', title: MyStrings.timeTbd),
];

List<S2Choice<String>> _choiceRepeat = [
  S2Choice<String>(value: '1', title: MyStrings.doesNotRepeat),
  S2Choice<String>(value: '2', title: MyStrings.weekly),
  S2Choice<String>(value: '3', title: MyStrings.daily),
];

List<S2Choice<String>> _choiceHomeAway = [
  S2Choice<String>(value: '1', title: MyStrings.home),
  S2Choice<String>(value: '2', title: MyStrings.away),
  S2Choice<String>(value: '3', title: MyStrings.timeTbd),
];

List<S2Choice<String>> _choiceFlagColor = [
  S2Choice<String>(value: '1', title: MyStrings.black),
  S2Choice<String>(value: '2', title: MyStrings.red),
  S2Choice<String>(value: '3', title: MyStrings.green),
];




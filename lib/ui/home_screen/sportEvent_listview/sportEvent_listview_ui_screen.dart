import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dart_amqp/dart_amqp.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart' as a;
import 'package:responsive_builder/responsive_builder.dart';
import 'package:screenshot/screenshot.dart';
import 'package:skeletons/skeletons.dart';
import 'package:spaid/base/base_state.dart';
import 'package:spaid/custom_widgets/painter.dart';
import 'package:spaid/model/response/add_player_response/add_existing_player_response.dart';
import 'package:spaid/model/response/base_response.dart';
import 'package:spaid/model/response/game_event_response/game_team_response.dart';
import 'package:spaid/model/response/game_event_response/live_game_response.dart';
import 'package:spaid/model/response/game_event_response/player_email_list_response.dart';
import 'package:spaid/model/response/game_event_response/score_details_response.dart';
import 'package:spaid/model/response/signup_response/validate_user_response.dart';
import 'package:spaid/service/email_service.dart';
import 'package:spaid/service/firebase_dynamic_link_service.dart';
import 'package:spaid/service/notification_service.dart';
import 'package:spaid/service/rabbitmq_message_receive.dart';
import 'package:spaid/service/send_push_notification_service.dart';
import 'package:spaid/support/ad_helper.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/support/dimens.dart';
import 'package:spaid/support/images.dart';
import 'package:spaid/support/internet_check.dart';
import 'package:spaid/support/response_ids.dart';
import 'package:spaid/support/routes.dart';
import 'package:spaid/support/style_sizes.dart';
import 'package:spaid/ui/add_event_screen/add_event_provider.dart';
import 'package:spaid/ui/edit_player_screen/edit_players_screen_provider.dart';
import 'package:spaid/ui/home_screen/event_listview/event_listview_provider.dart';
import 'package:spaid/utils/code_snippet.dart';
import 'package:spaid/utils/navigation.dart';
import 'package:spaid/utils/shared_pref_manager.dart';
import 'package:spaid/widgets/ProgressBar.dart';
import 'package:spaid/widgets/calendar_cubit.dart';
import 'package:spaid/widgets/calendar_event_model.dart';
import 'package:spaid/widgets/custom_background/custom_web_background_card.dart';
import 'package:spaid/widgets/home_eventSport_card.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';

class SportEventListviewScreen extends StatefulWidget {
  @override
  _SportEventListviewScreenState createState() =>
      _SportEventListviewScreenState();
}

//region Private Members
String _userRole = "";

//endregion
class _SportEventListviewScreenState
    extends BaseState<SportEventListviewScreen> {
//region Private Members
  ScreenshotController screenshotController = ScreenshotController();
  String team1 = "2", team2 = "1";

  // COMPLETE: Add a BannerAd instance
  // BannerAd _ad;
  var messages;
  String? dateformat,
      first,
      userName,
      teamName,
      userID,
      teamID,
      signIn,
      calendarId;

  // COMPLETE: Add _isAdLoaded
  bool _isAdLoaded = false;

  /* final List<String> imgList = [
    'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
    'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
    'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
    'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
  ];
   List<Widget> imageSliders=[];*/
  List<TextEditingController> _namecontroller = [];
  List<TextEditingController> _deletebuttoncontroller = [];
  List<TextEditingController> _cancelbuttoncontroller = [];
  List<TextEditingController> _statuscontroller = [];
  List<TextEditingController> _locationcontroller = [];
  List<TextEditingController> _datecontroller = [];
  EventListviewProvider? _eventListviewProvider;
  List<GameOrEventList>? gameOrEventList;
  GetTeamMembersEmailResponse? _getTeamMembersEmailResponse;
  LiveGameResponse? _liveGameResponse;
  AddEventProvider? _addEventProvider;
  EditPlayerProvider? _editplayerProvider;
  int teamAScore = 0, teamBScore = 0;
  bool? isLoading;
  CalendarCubit? calendarCubit;
  bool? addToCalendar;
  var _calendars;
  List<String> datestrings = [];

//endregion
  @override
  void initState() {
    super.initState();
    _eventListviewProvider =
        a.Provider.of<EventListviewProvider>(context, listen: false);
    _eventListviewProvider!.listener = this;
    _addEventProvider = a.Provider.of<AddEventProvider>(context, listen: false);
    _addEventProvider!.listener = this;
    _editplayerProvider =
        a.Provider.of<EditPlayerProvider>(context, listen: false);
    _editplayerProvider!.listener = this;
    calendarCubit = a.Provider.of<CalendarCubit>(context, listen: false);

    isLoading = true;
    getCountryCodeAsyncs();
    _addEventProvider!.getTeamMembersEmailAsync();
    _eventListviewProvider!.getGameAsync();
    _eventListviewProvider!.getLiveGameAsync();

    setState(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (kIsWeb) {
        } else if (Platform.isAndroid) {
          // initRabbitMq();
          //_initGoogleMobileAds();
          completeadds();
        }
      });
    });
  }
@override
  void onRefresh(String type) {
  setState(() {
    isLoading=true;
    _eventListviewProvider!.getGameAsync();
  });    super.onRefresh(type);
  }

  @override
  Future<void> onSuccess(any, {int? reqId}) async {
    ProgressBar.instance.stopProgressBar(context);
    switch (reqId) {
      case ResponseIds.GET_GAME:
        gameOrEventList = [];
        GetGameEventForTeamResponse _getGameAvailablity =
            any as GetGameEventForTeamResponse;
        if (_getGameAvailablity.result != null &&
            _getGameAvailablity.result!.gameOrEventList != null &&
            _getGameAvailablity.result!.gameOrEventList!.isNotEmpty) {
          if (addToCalendar!) {
            DateFormat formatter = dateformat == "US"
                ? DateFormat("MM/dd/yyyy")
                : dateformat == "CA"
                    ? DateFormat("yyyy/MM/dd")
                    : DateFormat("dd/MM/yyyy");
            if (datestrings.isEmpty) {
              for (int i = 0;
                  i < _getGameAvailablity.result!.gameOrEventList!.length;
                  i++) {
                datestrings
                    .add(_getGameAvailablity.result!.gameOrEventList![i].scheduleDate!);
              }
            }

            datestrings.sort((a, b) {
              //sorting in descending order
              return formatter.parse(b).compareTo(formatter.parse(a));
            });
            print(datestrings);
            RetrieveEventsParams retrieveEventsParams =
                new RetrieveEventsParams(
                    endDate:
                        formatter.parse(datestrings[0]).add(Duration(days: 1)),
                    startDate:
                        formatter.parse(datestrings[datestrings.length - 1]));
            calendarCubit!.retrieveEvents(calendarId??"", retrieveEventsParams);
            datestrings = [];
            for (int i = 0;
                i < _getGameAvailablity.result!.gameOrEventList!.length;
                i++) {
              datestrings
                  .add(_getGameAvailablity.result!.gameOrEventList![i].scheduleDate!);
            }
          }
          for (int i = 0; i < _getGameAvailablity.result!.gameOrEventList!.length; i++) {
            if (_userRole == Constants.owner.toString() ||
                _userRole == Constants.coachorManager.toString() ||
                _userRole == Constants.nonPlayer.toString() ||
                _userRole == Constants.familyMember.toString()) {
              if (addToCalendar!) {
                DateFormat formatter;
                DateTime scheduledDateTime;
                if (_getGameAvailablity.result!.gameOrEventList![i].scheduleTime!
                    .contains("00:00")) {
                  formatter = dateformat == "US"
                      ? DateFormat("MM/dd/yyyy")
                      : dateformat == "CA"
                          ? DateFormat("yyyy/MM/dd")
                          : DateFormat("dd/MM/yyyy");
                  scheduledDateTime = formatter.parse(
                      _getGameAvailablity.result!.gameOrEventList![i].scheduleDate!);
                } else {
                  formatter = dateformat == "US"
                      ? DateFormat("MM/dd/yyyy h:mma")
                      : dateformat == "CA"
                          ? DateFormat("yyyy/MM/dd h:mma")
                          : DateFormat("dd/MM/yyyy h:mma");
                  scheduledDateTime = formatter.parse(
                      _getGameAvailablity.result!.gameOrEventList![i].scheduleDate! +
                          " " +
                          _getGameAvailablity.result!.gameOrEventList![i].scheduleTime!);
                }
                var _calendarEvent = CalendarEventModel(
                  eventTitle: _getGameAvailablity.result!.gameOrEventList![i].name! +
                      "(" +
                      (_getGameAvailablity.result!.gameOrEventList![i].status ==
                              Constants.upcoming
                          ? "Upcoming"
                          : _getGameAvailablity.result!.gameOrEventList![i].status ==
                                  Constants.ongoing
                              ? "Ongoing"
                              : _getGameAvailablity.result!.gameOrEventList![i].status ==
                                      Constants.completed
                                  ? "Completed"
                                  : _getGameAvailablity
                                              .result!.gameOrEventList![i].status ==
                                          Constants.cancelled
                                      ? "Cancelled"
                                      : _getGameAvailablity
                                                  .result!.gameOrEventList![i].status ==
                                              Constants.closed
                                          ? "Closed"
                                          : "Deleted") +
                      ")",
                  eventDescription: _getGameAvailablity.result!.gameOrEventList![i].type,
                  eventDurationInHours: 3,
                  statDate: scheduledDateTime,
                  location:
                      _getGameAvailablity.result!.gameOrEventList![i].locationAddress,
                );

                //calendarCubit.deleteCalendar(calendarId);
                //calendarCubit.deleteEventInstance(calendarId);
                calendarCubit!.addToCalendar(_calendarEvent, calendarId!);
              }
            } else {
              if (addToCalendar! &&
                  _getGameAvailablity
                          .result!.gameOrEventList![i].playerAvailabilityStatusId ==
                      Constants.accept &&
                  _userRole == Constants.teamPlayer.toString()) {
                DateFormat formatter;
                DateTime scheduledDateTime;
                if (_getGameAvailablity.result!.gameOrEventList![i].scheduleTime!
                    .contains("00:00")) {
                  formatter = dateformat == "US"
                      ? DateFormat("MM/dd/yyyy")
                      : dateformat == "CA"
                          ? DateFormat("yyyy/MM/dd")
                          : DateFormat("dd/MM/yyyy");
                  scheduledDateTime = formatter.parse(
                      _getGameAvailablity.result!.gameOrEventList![i].scheduleDate!);
                } else {
                  formatter = dateformat == "US"
                      ? DateFormat("MM/dd/yyyy h:mma")
                      : dateformat == "CA"
                          ? DateFormat("yyyy/MM/dd h:mma")
                          : DateFormat("dd/MM/yyyy h:mma");
                  scheduledDateTime = formatter.parse(
                      _getGameAvailablity.result!.gameOrEventList![i].scheduleDate! +
                          " " +
                          _getGameAvailablity.result!.gameOrEventList![i].scheduleTime!);
                }
                var _calendarEvent = CalendarEventModel(
                  eventTitle: _getGameAvailablity.result!.gameOrEventList![i].name! +
                      "(" +
                      (_getGameAvailablity.result!.gameOrEventList![i].status ==
                              Constants.upcoming
                          ? "Upcoming"
                          : _getGameAvailablity.result!.gameOrEventList![i].status ==
                                  Constants.ongoing
                              ? "Ongoing"
                              : _getGameAvailablity.result!.gameOrEventList![i].status ==
                                      Constants.completed
                                  ? "Completed"
                                  : _getGameAvailablity
                                              .result!.gameOrEventList![i].status ==
                                          Constants.cancelled
                                      ? "Cancelled"
                                      : _getGameAvailablity
                                                  .result!.gameOrEventList![i].status ==
                                              Constants.closed
                                          ? "Closed"
                                          : "Deleted") +
                      ")",
                  eventDescription: _getGameAvailablity.result!.gameOrEventList![i].type,
                  eventDurationInHours: 3,
                  statDate: scheduledDateTime,
                  location:
                      _getGameAvailablity.result!.gameOrEventList![i].locationAddress,
                );

                //calendarCubit.deleteCalendar(calendarId);
                //calendarCubit.deleteEventInstance(calendarId);
                calendarCubit!.addToCalendar(_calendarEvent, calendarId!);
              }
            }
            if (
                _getGameAvailablity.result!.gameOrEventList![i].isGameorEventClosed!) {
              for (int j = 0;
                  j < _getTeamMembersEmailResponse!.result!.userMailList!.length;
                  j++) {
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
                      _getGameAvailablity.result!.gameOrEventList![i].eventId!,
                      "The status of the " +
                          _getGameAvailablity.result!.gameOrEventList![i].name! +
                          " held on " +
                          _getGameAvailablity.result!.gameOrEventList![i].scheduleDate! +
                          " has been changed to “Closed” as there is no response from you. Would you like to change the status of the " +
                          _getGameAvailablity.result!.gameOrEventList![i].name!
                              .toLowerCase() +
                          " to “Completed”. ");
                  SendPushNotificationService().sendPushNotifications(
                      _getTeamMembersEmailResponse!.result!.userMailList![j].FCMTokenID??"",
                      "The status of the " +
                          _getGameAvailablity.result!.gameOrEventList![i].name! +
                          " held on " +
                          _getGameAvailablity.result!.gameOrEventList![i].scheduleDate! +
                          " has been changed to “Closed” as there is no response from you.",
                      "");
                }
              }
            }
            if (!kIsWeb) {
              NotificationService().init(
                  _getGameAvailablity.result!.gameOrEventList![i].eventId!,
                  (_getGameAvailablity.result!.gameOrEventList![i].status ==
                          Constants.upcoming
                      ? "Upcoming"
                      : _getGameAvailablity.result!.gameOrEventList![i].status ==
                              Constants.ongoing
                          ? "Ongoing"
                          : _getGameAvailablity.result!.gameOrEventList![i].status ==
                                  Constants.completed
                              ? "Completed"
                              : _getGameAvailablity.result!.gameOrEventList![i].status ==
                                      Constants.cancelled
                                  ? "Cancelled"
                                  : _getGameAvailablity
                                              .result!.gameOrEventList![i].status ==
                                          Constants.closed
                                      ? "Closed"
                                      : "Deleted"),
                  "You have " +
                      _getGameAvailablity.result!.gameOrEventList![i].name! +
                      " " +
                      _getGameAvailablity.result!.gameOrEventList![i].type!,
                  _getGameAvailablity.result!.gameOrEventList![i].locationAddress!,
                  _getGameAvailablity.result!.gameOrEventList![i].scheduleDate!,
                  _getGameAvailablity.result!.gameOrEventList![i].scheduleTime!);
            }
            if (_getGameAvailablity.result!.gameOrEventList![i].status !=
                    Constants.completed &&
                _getGameAvailablity.result!.gameOrEventList![i].status !=
                    Constants.cancelled &&
                _getGameAvailablity.result!.gameOrEventList![i].status !=
                    Constants.closed &&
                _getGameAvailablity.result!.gameOrEventList![i].status !=
                    Constants.deleted &&
                _getGameAvailablity.result!.gameOrEventList![i].status !=
                    0) {
              gameOrEventList!.add(_getGameAvailablity.result!.gameOrEventList![i]);
            }
          }
        } else {
          setState(() {
            isLoading = false;
          });
          calendarCubit!.deleteCalendar(calendarId!);
          _calendars = await calendarCubit!.loadCalendars();
          //calendarCubit.deleteCalendar(13);
          if (_calendars.length > 0) {
            bool isCalendarAvailable = false;
            for (int i = 0; i < _calendars.length; i++) {
              if (_calendars[i].name == "Spaid") {
                isCalendarAvailable = true;
                SharedPrefManager.instance.setStringAsync(
                    Constants.calendarId, _calendars[i].id.toString());
              }
            }
            if (!isCalendarAvailable) {
              calendarCubit!.createCalendar();
              _calendars = await calendarCubit!.loadCalendars();
              for (int i = 0; i < _calendars.length; i++) {
                if (_calendars[i].name == "Spaid") {
                  SharedPrefManager.instance.setStringAsync(
                      Constants.calendarId, _calendars[i].id.toString());
                }
              }
            }
          }
        }

        setState(() {
          isLoading = false;
        });
        break;
      case ResponseIds.GET_GAME_STATUS_UPDATE:
        ValidateUserResponse _response = any as ValidateUserResponse;
        if (_response.responseResult == Constants.success) {
          _eventListviewProvider!.getGameAsync();
        } else if (_response.responseResult == Constants.failed) {
          CodeSnippet.instance.showMsg(_response.saveErrors![0].errorMessage!);
        } else {
          // CodeSnippet.instance.showMsg(MyStrings.signUpFailed);
        }

        break;
      case ResponseIds.TEAM_EMAIL_LIST:
        GetTeamMembersEmailResponse _response =
            any as GetTeamMembersEmailResponse;
        if (_response.result!.teamIDNo != Constants.success) {
          if (_response.result!.userMailList!.length > 0) {
            _getTeamMembersEmailResponse = _response;
          }
        }

        break;
      case ResponseIds.LIVE_GAME:
        LiveGameResponse _response = any as LiveGameResponse;
        if (_response.result!.onGoingGameList!.isNotEmpty) {
          _eventListviewProvider!
              .getScoreDetails(_response.result!.onGoingGameList![0].matcheId!);
          // _eventListviewProvider.getScoreDetails(1038);

          setState(() {
            _liveGameResponse = _response;
            initRabbitMq(_response.result!.onGoingGameList![0].matcheId!);
          });

          /* if (_response.userMailList.length > 0) {
            _liveGameResponse = _response;
          }*/
        }

        break;
      case ResponseIds.GET_SCORE_DETAILS_SCREEN:
        ScoreDetailsResponse _response = any as ScoreDetailsResponse;
        if (_response.result!.scoreList!.isNotEmpty) {
          setState(() {
            for (int i = 0; i < _response.result!.scoreList!.length; i++) {
              if (_response.result!.scoreList![i].teamId ==
                  _liveGameResponse!.result!.onGoingGameList![0].teamId) {
                if (_response.result!.scoreList![i].scoreTypeId == Constants.goal) {
                  setState(() {
                    teamAScore++;
                  });
                }
              }
              if (_response.result!.scoreList![i].teamId ==
                  _liveGameResponse!.result!.onGoingGameList![0].opponentTeamId) {
                if (_response.result!.scoreList![i].scoreTypeId == Constants.goal) {
                  setState(() {
                    teamBScore++;
                  });
                }
              }
            }
          });
        }
        break;

      case ResponseIds.ADD_EXISTING_PLAYER:
        AddExistingPlayerResponse _response = any as AddExistingPlayerResponse;
        if (_response.result != null && _response.result!.userIDNo != Constants.success) {
          setState(() {
            SharedPrefManager.instance.setStringAsync(Constants.userName,
                _response.result!.userFirstName! + " " + _response.result!.userLastName!);
          });
        }
        break;
    }
  }

  @override
  void onFailure(BaseResponse error) {
    setState(() {
      isLoading = false;
    });
    ProgressBar.instance.stopProgressBar(context);
    //CodeSnippet.instance.showMsg(error.errorMessage);
  }

  /*
Return Type:
Input Parameters:
Use: To create Google Add Widget.
 */
  void completeadds() {
    // COMPLETE: Create a BannerAd instance
    // _ad = BannerAd(
    //   adUnitId: AdHelper.bannerAdUnitId,
    //   size: AdSize.banner,
    //   request: AdRequest(),
    //   listener: BannerAdListener(
    //     onAdLoaded: (_) {
    //       setState(() {
    //         _isAdLoaded = true;
    //       });
    //     },
    //     onAdFailedToLoad: (ad, error) {
    //       // Releases an ad resource when it fails to load
    //       ad.dispose();
    //
    //       print('Ad load failed (code=${error.code} message=${error.message})');
    //     },
    //   ),
    // );
    //
    // // COMPLETE: Load an ad
    // _ad.load();
  }

  /*Future<InitializationStatus> _initGoogleMobileAds() {
   // RequestConfiguration.Builder().setTestDeviceIds(Arrays.asList("850AD159AA8D057B928719FB07C3BA85"));
    return MobileAds.instance.initialize();
  }*/

  /*
Return Type:
Input Parameters:
Use: To create Image Share Option.
 */
  Future<void> _shareImageAndTextAsync(image) async {
    try {
      //final ByteData bytes = await rootBundle.load('assets/wisecrab.png');
      if (kIsWeb) {
        //Share.share("This is text",subject: "This is subject");
      } else {
        await WcFlutterShare.share(
            sharePopupTitle: 'share',
            subject: '',
            text: '',
            fileName: 'share.png',
            mimeType: 'image/png',
            bytesOfFile: image);
      }
    } catch (e) {
      print('error: $e');
    }
  }

  @override
  void dispose() {
    super.dispose();
    // COMPLETE: Dispose a BannerAd object
    // if (_ad != null) {
    //   _ad.dispose();
    // }
  }

  void initRabbitMq(int matcheId) {
    ConnectionSettings settings = new ConnectionSettings(
        virtualHost: "/",
        port: Constants.port,
        authProvider: new AmqPlainAuthenticator(
            Constants.rabbitMQUsername, Constants.rabbitMQPassword),
        host: Constants.rabbitMQHost);
    Client client = new Client(settings: settings);
    client
        .channel()
        .then((Channel channel) => channel
            .exchange(matcheId.toString(), ExchangeType.FANOUT, durable: true))
        /* .then((Channel channel) =>
        channel.exchange("10", ExchangeType.FANOUT, durable: true))*/
        .then((Exchange exchange) => exchange.bindPrivateQueueConsumer(null))
        .then((Consumer consumer) => consumer.listen((AmqpMessage message) {
              /* // Get the payload as a string
              print("ll");
              // Get the payload as a string
              print(" [x] Received string: ${message.payloadAsString}");*/

              // Or unserialize to json
              print(" [x] Received json: ${message.payloadAsJson}");

              /* // Or just get the raw data as a Uint8List
              print(" [x] Received raw: ${message.payload}");
              // The message object contains helper methods for
              // replying, ack-ing and rejecting
*/
              //Map<String, dynamic> userMap = jsonDecode(message.payloadAsJson);
              setState(() {
                messages = RabbitMQMessage.fromJson(message.payloadAsJson);
                print(messages.team1);
                print(messages.team2);
              });

              //message.reply("world");
            }));
  }

  Future<void> getCountryCodeAsyncs() async {
    userName =
        await SharedPrefManager.instance.getStringAsync(Constants.userName);
    teamName =
        await SharedPrefManager.instance.getStringAsync(Constants.teamName);
    userID =
        await SharedPrefManager.instance.getStringAsync(Constants.userIdNo);
    teamID = await SharedPrefManager.instance.getStringAsync(Constants.teamID);
    calendarId =
        await SharedPrefManager.instance.getStringAsync(Constants.calendarId);
    _userRole = await SharedPrefManager.instance.getStringAsync(Constants.roleId);
    String _addCalendar = await SharedPrefManager.instance
        .getStringAsync(Constants.addToCalender);
    addToCalendar = _addCalendar != null
        ? _addCalendar.toLowerCase() == "true"
            ? true
            : false
        : false;

    _editplayerProvider!.getExistingPlayer(int.parse(userID!));
    DynamicLinksService()
        .createDynamicLink("signin_screen")
        .then((value) async {
      setState(() {
        signIn = value;
      });
    });
    first =
        "${await SharedPrefManager.instance.getStringAsync(Constants.countryCode)}";
    setState(() {
      dateformat = first;
      print(dateformat);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WebCard(
      marginVertical: 20,
      marginhorizontal: 40,
      child: Padding(
        padding: EdgeInsets.all(getValueForScreenType<bool>(
          context: context,
          mobile: false,
          tablet: true,
          desktop: true,
        )
            ? PaddingSize.headerPadding1
            : PaddingSize.headerPadding2),
        child: Scaffold(
          backgroundColor: MyColors.white,
          // bottomNavigationBar: kIsWeb
          //     ? null
          //     : _ad != null
          //         ? Container(
          //             child: AdWidget(ad: _ad),
          //             width: _ad.size.width.toDouble(),
          //             height: _ad.size.height.toDouble(),
          //             alignment: Alignment.center,
          //           )
          //         : null,
          body: SafeArea(
            child: isLoading!
                ? SkeletonListView()
                : _liveGameResponse == null &&
                        (gameOrEventList == null || gameOrEventList!.isEmpty)
                    ? Container(
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
                    : Container(
                        child: Column(
                            /* crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,*/
                            children: <Widget>[
                              SizedBox(
                                height: 1,
                              ),
                              _liveGameResponse != null
                                  ? ExpansionTile(
                                      title: Image.asset(
                                        MyImages.live,
                                        width: 50,
                                        height: 50,
                                      ),
                                      initiallyExpanded: true,
                                      textColor: MyColors.kPrimaryColor,
                                      iconColor: MyColors.black,
                                      collapsedIconColor: MyColors.black,
                                      children: <Widget>[
                                          Card(
                                            elevation:
                                                PaddingSize.cardElevation,
                                            child: Column(
                                              children: <Widget>[
                                                Screenshot(
                                                  controller: screenshotController,
                                                  child: Card(
                                                    elevation:
                                                    0,
                                                    child: Column(
                                                      children: [
                                                        ListTile(
                                                          onTap: () {
                                                            Constants.teamAImage =
                                                                base64Decode(
                                                                    _liveGameResponse!
                                                                        .result!.onGoingGameList![
                                                                            0]
                                                                        .teamImage!);
                                                            Constants.teamBImage =
                                                                base64Decode(
                                                                    _liveGameResponse!
                                                                        .result!.onGoingGameList![
                                                                            0]
                                                                        .opponentTeamImage!);
                                                            Constants.teamAName =
                                                                _liveGameResponse!
                                                                    .result!.onGoingGameList![
                                                                        0]
                                                                    .teamName!;
                                                            Constants.teamBName =
                                                                _liveGameResponse!
                                                                    .result!.onGoingGameList![
                                                                        0]
                                                                    .opponentTeamName!;
                                                            Constants.teamAId =
                                                                _liveGameResponse!
                                                                    .result!.onGoingGameList![
                                                                        0]
                                                                    .teamId!;
                                                            Constants.teamBId =
                                                                _liveGameResponse!
                                                                    .result!.onGoingGameList![
                                                                        0]
                                                                    .opponentTeamId!;
                                                            Navigation.navigateTo(
                                                                context,
                                                                MyRoutes
                                                                    .scoreDetailsScreen);
                                                          },
                                                          leading: Padding(
                                                            padding:
                                                                const EdgeInsets.only(
                                                                    left: 35),
                                                            child: CircleAvatar(
                                                                radius: PaddingSize
                                                                    .circleRadius,
                                                                backgroundColor:
                                                                    MyColors.white,
                                                                child: _liveGameResponse!
                                                                        .result!.onGoingGameList![
                                                                            0]
                                                                        .teamImage!
                                                                        .isNotEmpty
                                                                    ? Image.memory(
                                                                        base64Decode(
                                                                            _liveGameResponse!
                                                                                .result!.onGoingGameList![
                                                                                    0]
                                                                                .teamImage!),
                                                                        width: MarginSize
                                                                            .headerMarginHorizontal1,
                                                                        height: MarginSize
                                                                            .headerMarginHorizontal1,
                                                                      )
                                                                    : Image.asset(
                                                                        MyImages.team,
                                                                        width: MarginSize
                                                                            .headerMarginHorizontal1,
                                                                        height: MarginSize
                                                                            .headerMarginHorizontal1,
                                                                      )),
                                                          ),
                                                          title: CircleAvatar(
                                                              radius: PaddingSize
                                                                  .circleRadius,
                                                              backgroundColor:
                                                                  MyColors.white,
                                                              child: Image.asset(
                                                                MyImages.vsImg,
                                                                width: MarginSize
                                                                    .headerMarginHorizontal1,
                                                                height: MarginSize
                                                                    .headerMarginHorizontal1,
                                                              )),
                                                          trailing: Padding(
                                                            padding:
                                                                const EdgeInsets.only(
                                                                    right: 35),
                                                            child: CircleAvatar(
                                                                radius: PaddingSize
                                                                    .circleRadius,
                                                                backgroundColor:
                                                                    MyColors.white,
                                                                child: _liveGameResponse!
                                                                        .result!.onGoingGameList![
                                                                            0]
                                                                        .opponentTeamImage!
                                                                        .isNotEmpty
                                                                    ? Image.memory(
                                                                        base64Decode(
                                                                            _liveGameResponse!
                                                                                .result!.onGoingGameList![
                                                                                    0]
                                                                                .opponentTeamImage!),
                                                                        width: MarginSize
                                                                            .headerMarginHorizontal1,
                                                                        height: MarginSize
                                                                            .headerMarginHorizontal1,
                                                                      )
                                                                    : Image.asset(
                                                                        MyImages.team,
                                                                        width: MarginSize
                                                                            .headerMarginHorizontal1,
                                                                        height: MarginSize
                                                                            .headerMarginHorizontal1,
                                                                      )),
                                                          ),
                                                        ),
                                                        ListTile(
                                                          onTap: null,
                                                          leading: Padding(
                                                            padding: const EdgeInsets
                                                                .fromLTRB(
                                                                PaddingSize
                                                                    .boxPaddingRight,
                                                                0,
                                                                0,
                                                                0),
                                                            child: SizedBox(
                                                              width: 110,
                                                              child: Text(
                                                                _liveGameResponse!
                                                                    .result!.onGoingGameList![
                                                                0]
                                                                    .teamName!,
                                                                textAlign:
                                                                TextAlign.center,
                                                                style: TextStyle(
                                                                    fontSize: FontSize
                                                                        .headerFontSize4),
                                                              ),
                                                            ),
                                                          ),
                                                          title: messages == null
                                                              ? Center(
                                                              child: Text(
                                                                teamAScore
                                                                    .toString() +
                                                                    " : " +
                                                                    teamBScore
                                                                        .toString(),
                                                                style: TextStyle(
                                                                    fontSize: FontSize
                                                                        .headerFontSize4),
                                                              ))
                                                              : Center(
                                                              child: Text(
                                                                messages.team1 +
                                                                    " : " +
                                                                    messages.team2,
                                                                style: TextStyle(
                                                                    fontSize: FontSize
                                                                        .headerFontSize4),
                                                              )),
                                                          trailing: Padding(
                                                            padding: const EdgeInsets
                                                                .fromLTRB(
                                                                0, 0, 10, 0),
                                                            child: SizedBox(
                                                              width: 110,
                                                              child: Text(
                                                                _liveGameResponse!
                                                                    .result!.onGoingGameList![
                                                                0]
                                                                    .opponentTeamName!,
                                                                textAlign:
                                                                TextAlign.center,
                                                                style: TextStyle(
                                                                    fontSize: FontSize
                                                                        .headerFontSize4),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: SizedBoxSize
                                                              .headerSizedBoxHeight,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),

                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: <Widget>[
                                                      SizedBox(
                                                        width: getValueForScreenType<
                                                                bool>(
                                                          context: context,
                                                          mobile: true,
                                                          tablet: false,
                                                          desktop: false,
                                                        )
                                                            ? MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                3
                                                            : getValueForScreenType<
                                                                    bool>(
                                                                context:
                                                                    context,
                                                                mobile: false,
                                                                tablet: false,
                                                                desktop: true,
                                                              )
                                                                ? null
                                                                : MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width /
                                                                    5,
                                                        height: Dimens
                                                            .standard_35,
                                                        child: ElevatedButton(
                                                          style: ElevatedButton.styleFrom(backgroundColor: MyColors
                                                              .kPrimaryColor,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                    80.0)),padding: EdgeInsets.all(
                                                                0.0),
                                                          ),

                                                          onPressed: () {
                                                            screenshotController
                                                                .capture()
                                                                .then((Uint8List?
                                                                    image) {
                                                              Future.delayed(
                                                                  Duration
                                                                      .zero,
                                                                  () {
                                                                _shareImageAndTextAsync(
                                                                    image);
                                                              });
                                                            });
                                                          },
                                                          child: Ink(
                                                            decoration:
                                                                BoxDecoration(
                                                                    gradient:
                                                                        LinearGradient(
                                                                      colors: [
                                                                        MyColors
                                                                            .kPrimaryColor,
                                                                        MyColors
                                                                            .kPrimaryColor
                                                                      ],
                                                                      begin: Alignment
                                                                          .centerLeft,
                                                                      end: Alignment
                                                                          .centerRight,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            PaddingSize.circleRadius)),
                                                            child: Container(
                                                                constraints: BoxConstraints(
                                                                    maxWidth:
                                                                        250.0,
                                                                    minHeight:
                                                                        50.0),
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child:
                                                                    RichText(
                                                                  text:
                                                                      TextSpan(
                                                                    children: [
                                                                      WidgetSpan(
                                                                        child:
                                                                            Icon(
                                                                          Icons.share,
                                                                          size:
                                                                              20,
                                                                          color:
                                                                              MyColors.white,
                                                                        ),
                                                                      ),
                                                                      TextSpan(
                                                                        text:
                                                                            " Share ",
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: Dimens.standard_16),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ) /*Text(
                                          "Share",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.white, fontSize: 15),
                                        ),*/
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                    ]),
                                                SizedBox(
                                                  height: SizedBoxSize
                                                      .headerSizedBoxHeight,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ])
                                  : Container(),
                              Expanded(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: gameOrEventList == null
                                      ? 0
                                      : gameOrEventList!.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      /* onTap: () {
                                Navigation.navigateTo(
                                    context, MyRoutes.editEventScreen);
                              },*/
                                      child: HomeEventSportCard(
                                        index: index,
                                        updateStatus: (position, type) {
                                          _eventListviewProvider!
                                              .updateGameStatusAsync(
                                                  gameOrEventList![position]
                                                      .eventId!,
                                                  "",
                                                  type);
                                        },
                                        myDelete: (position, type) {
                                          Future.delayed(Duration.zero, () {
                                            setState(() {
                                              _eventListviewProvider!
                                                  .deleteGameAsync(
                                                      gameOrEventList![position]
                                                          .eventId!,
                                                      type);
                                              _namecontroller
                                                  .removeAt(position);
                                              _deletebuttoncontroller
                                                  .removeAt(position);
                                              _locationcontroller
                                                  .removeAt(position);
                                              _datecontroller
                                                  .removeAt(position);
                                              _cancelbuttoncontroller
                                                  .removeAt(position);
                                              _statuscontroller
                                                  .removeAt(position);

                                            });
                                          });
                                        },
                                        myCancel: (position, type) {
                                          Future.delayed(Duration.zero,
                                              () async {
                                            _eventListviewProvider!
                                                .updateGameStatusAsync(
                                                    gameOrEventList![position]
                                                        .eventId!,
                                                    type,
                                                    Constants.cancelled);
                                            if (gameOrEventList![position]
                                                        .eventGroupId !=
                                                    null &&
                                                type == "All") {
                                              for (int j = 0;
                                                  j < gameOrEventList!.length;
                                                  j++) {
                                                if (gameOrEventList![j]
                                                        .eventGroupId ==
                                                    gameOrEventList![position]
                                                        .eventGroupId) {
                                                  for (int i = 0;
                                                      i <
                                                          _getTeamMembersEmailResponse!
                                                              .result!.userMailList!
                                                              .length;
                                                      i++) {
                                                    await EmailService()
                                                        .createEventNotification(
                                                            "Cancel " +
                                                                gameOrEventList![j]
                                                                    .type! +
                                                                ", " +
                                                                gameOrEventList![j]
                                                                    .name!,
                                                            gameOrEventList![j]
                                                                .name!,
                                                            Constants
                                                                .cancelGameOrEvent,
                                                            int.parse(userID!),
                                                            _getTeamMembersEmailResponse!
                                                                .result!.userMailList![i]
                                                                .userIDNo!,
                                                            gameOrEventList![j]
                                                                .eventId!,
                                                            "The " +
                                                                gameOrEventList![j]
                                                                    .type! +
                                                                ", " +
                                                                gameOrEventList![j]
                                                                    .name! +
                                                                " has been canceled by " +
                                                                userName! +
                                                                " for the team, " +
                                                                teamName! +
                                                                "  to take place on " +
                                                                (dateformat ==
                                                                        "US"
                                                                    ? DateFormat("MM/dd/yyyy").format((DateFormat('dd/MM/yyyy').parse(
                                                                        gameOrEventList![j]
                                                                            .scheduleDate!)))
                                                                    : dateformat ==
                                                                            "CA"
                                                                        ? DateFormat("yyyy/MM/dd").format((DateFormat('dd/MM/yyyy').parse(gameOrEventList![j]
                                                                            .scheduleDate!)))
                                                                        : DateFormat("dd/MM/yyyy").format((DateFormat('dd/MM/yyyy').parse(gameOrEventList![j]
                                                                            .scheduleDate!)))) +
                                                                " " +
                                                                (DateFormat("h:mma")
                                                                    .format((DateFormat("h:mma")
                                                                        .parse(
                                                                            gameOrEventList![j].scheduleTime!)))) +
                                                                " at " +
                                                                gameOrEventList![j].locationAddress!,
                                                            _getTeamMembersEmailResponse!.result!.userMailList![i].email!,
                                                            "",
                                                            "The " + gameOrEventList![j].type! + ", " + gameOrEventList![j].name! + " has been canceled by " + userName! + " for the team, " + teamName! + "  to take place on",
                                                            "",
                                                            "",
                                                            "",
                                                            gameOrEventList![j].locationAddress!,
                                                            (dateformat == "US"
                                                                ? DateFormat("MM/dd/yyyy").format((DateFormat('dd/MM/yyyy').parse(gameOrEventList![j].scheduleDate!)))
                                                                : dateformat == "CA"
                                                                    ? DateFormat("yyyy/MM/dd").format((DateFormat('dd/MM/yyyy').parse(gameOrEventList![j].scheduleDate!)))
                                                                    : DateFormat("dd/MM/yyyy").format((DateFormat('dd/MM/yyyy').parse(gameOrEventList![j].scheduleDate!)))),
                                                            (gameOrEventList![j].scheduleTime=="00:00"?MyStrings.timeTbd:DateFormat("h:mma").format((DateFormat("h:mma").parse(gameOrEventList![j].scheduleTime!)))),
                                                            signIn!,
                                                            "",
                                                            "",
                                                            "",
                                                            "",false);
                                                  }
                                                }
                                              }
                                            } else {
                                              for (int i = 0;
                                                  i <
                                                      _getTeamMembersEmailResponse!
                                                          .result!.userMailList!.length;
                                                  i++) {
                                                await EmailService()
                                                    .createEventNotification(
                                                        "Cancel " +
                                                            gameOrEventList![position]
                                                                .type! +
                                                            ", " +
                                                            gameOrEventList![position]
                                                                .name!,
                                                        gameOrEventList![position]
                                                            .name!,
                                                        Constants
                                                            .cancelGameOrEvent,
                                                        int.parse(userID!),
                                                        _getTeamMembersEmailResponse!
                                                            .result!.userMailList![i]
                                                            .userIDNo!,
                                                        gameOrEventList![position]
                                                            .eventId!,
                                                        "The " +
                                                            gameOrEventList![position]
                                                                .type! +
                                                            ", " +
                                                            gameOrEventList![position]
                                                                .name! +
                                                            " has been canceled by " +
                                                            userName! +
                                                            " for the team, " +
                                                            teamName!+
                                                            "  to take place on " +
                                                            (dateformat == "US"
                                                                ? DateFormat("MM/dd/yyyy").format((DateFormat('dd/MM/yyyy').parse(
                                                                    gameOrEventList![position]
                                                                        .scheduleDate!)))
                                                                : dateformat ==
                                                                        "CA"
                                                                    ? DateFormat("yyyy/MM/dd").format((DateFormat('dd/MM/yyyy').parse(
                                                                        gameOrEventList![position]
                                                                            .scheduleDate!)))
                                                                    : DateFormat("dd/MM/yyyy")
                                                                        .format((DateFormat('dd/MM/yyyy').parse(gameOrEventList![position]
                                                                            .scheduleDate!)))) +
                                                            " " +
                                                            (DateFormat("h:mma")
                                                                .format((DateFormat("h:mma")
                                                                    .parse(gameOrEventList![position].scheduleTime!)))) +
                                                            " at " +
                                                            gameOrEventList![position].locationAddress!,
                                                        _getTeamMembersEmailResponse!.result!.userMailList![i].email!,
                                                        "",
                                                        "The " + gameOrEventList![position].type! + ", " + gameOrEventList![position].name! + " has been canceled by " + userName! + " for the team, " + teamName! + "  to take place on",
                                                        "",
                                                        "",
                                                        "",
                                                        gameOrEventList![position].locationAddress!,
                                                        (dateformat == "US"
                                                            ? DateFormat("MM/dd/yyyy").format((DateFormat('dd/MM/yyyy').parse(gameOrEventList![position].scheduleDate!)))
                                                            : dateformat == "CA"
                                                                ? DateFormat("yyyy/MM/dd").format((DateFormat('dd/MM/yyyy').parse(gameOrEventList![position].scheduleDate!)))
                                                                : DateFormat("dd/MM/yyyy").format((DateFormat('dd/MM/yyyy').parse(gameOrEventList![position].scheduleDate!)))),
                                                        (gameOrEventList![position].scheduleTime=="00:00"?MyStrings.timeTbd:DateFormat("h:mma").format((DateFormat("h:mma").parse(gameOrEventList![position].scheduleTime!)))),
                                                        signIn!,
                                                        "",
                                                        "",
                                                        "",
                                                        "",false);
                                              }
                                            }

                                            /* _statuscontroller[position].text = "Cancelled";
                                    _deletebuttoncontroller[position].text = "true";
                                    _cancelbuttoncontroller[position].text = "false";*/
                                            setState(() {});
                                          });
                                        },
                                        typecontroller:
                                            gameOrEventList![index].type,
                                        timecontroller:
                                            gameOrEventList![index].scheduleTime,
                                        EventGroupId:
                                            gameOrEventList![index].eventGroupId,
                                        datecontroller:
                                            gameOrEventList![index].scheduleDate,
                                        locationcontroller:
                                            gameOrEventList![index]
                                                .locationAddress,
                                        statuscontroller: (gameOrEventList![
                                                        index]
                                                    .status ==
                                                Constants.upcoming
                                            ? "Upcoming"
                                            : gameOrEventList![index].status ==
                                                    Constants.ongoing
                                                ? "Ongoing"
                                                : gameOrEventList![index]
                                                            .status ==
                                                        Constants.completed
                                                    ? "Completed"
                                                    : gameOrEventList![index]
                                                                .status ==
                                                            Constants.cancelled
                                                        ? "Cancelled"
                                                        : gameOrEventList![index]
                                                                    .status ==
                                                                Constants.closed
                                                            ? "Closed"
                                                            : "Deleted"),
                                        namecontroller:
                                            gameOrEventList![index].name,
                                        gameOrEventList:gameOrEventList![index],
                                        dateformat: dateformat,
                                        cancelbuttoncontroller:
                                            (gameOrEventList![index].status ==
                                                            Constants
                                                                .upcoming ||
                                                        gameOrEventList![index]
                                                                .status ==
                                                            Constants
                                                                .ongoing) &&
                                                    (int.parse(_userRole) ==
                                                            Constants.owner ||
                                                        int.parse(_userRole) ==
                                                            Constants
                                                                .coachorManager)
                                                ? true
                                                : false,
                                        deletebuttoncontroller:
                                            (gameOrEventList![index].status ==
                                                            Constants
                                                                .completed ||
                                                        gameOrEventList![index]
                                                                .status ==
                                                            Constants
                                                                .cancelled ||
                                                        gameOrEventList![index]
                                                                .status ==
                                                            Constants.closed) &&
                                                    (int.parse(_userRole) ==
                                                            Constants.owner ||
                                                        int.parse(_userRole) ==
                                                            Constants
                                                                .coachorManager)
                                                ? true
                                                : false,
                                        userRole: _userRole,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ]),
                      ),
          ),
        ),
      ),
    );
  }


}

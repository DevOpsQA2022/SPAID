import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spaid/base/base_provider.dart';
import 'package:spaid/model/request/add_player_request/get_existing_player_request.dart';
import 'package:spaid/model/request/game_event_request/add_game_request.dart' as a;
import 'package:spaid/model/request/game_event_request/game_player_notification_request.dart';
import 'package:spaid/model/request/get_drill_request.dart';
import 'package:spaid/model/request/select_team_request/select_team_request.dart';
import 'package:spaid/model/response/add_player_response/add_existing_player_response.dart';
import 'package:spaid/model/response/base_response.dart';
import 'package:spaid/model/response/game_event_response/add_game_response.dart';
import 'package:spaid/model/response/game_event_response/player_email_list_response.dart';
import 'package:spaid/model/response/roaster_listview_response/roaster_listview_response.dart';
import 'package:spaid/model/response/signup_response/validate_user_response.dart';
import 'package:spaid/service/api_manager.dart';
import 'package:spaid/service/dio_error_util.dart';
import 'package:spaid/service/email_service.dart';
import 'package:spaid/service/endpoints.dart';
import 'package:spaid/service/exception_error_util.dart';
import 'package:spaid/service/firebase_dynamic_link_service.dart';
import 'package:spaid/service/send_push_notification_service.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/support/email_template.dart';
import 'package:spaid/support/response_ids.dart';
import 'package:spaid/support/strings.dart';
import 'package:spaid/utils/shared_pref_manager.dart';
import 'package:workmanager/workmanager.dart';

import '../../model/request/search_email_request.dart';
const fetchBackground = "be.tramckrijte.workmanagerExample.simpleTask";

@pragma('vm:entry-point')
void callbackDispatcher() {
  try {
    Workmanager().executeTask((task, inputData) async {
      switch (task) {
        case fetchBackground:
          try {
            print("background task");
            int eventid = 0;
            int count = 0;
            String responseData=inputData!['response'];
            String gameNameController=inputData['gameNameController'];
            String locationDetailsController=inputData['locationDetailsController'];
            String teamName=inputData['teamName'];
            String userFcm=inputData['userFcm'];
            String userName=inputData['userName'];
            String userEmail=inputData['userEmail'];
            String userID=inputData['userID'];
            String repeatvalue=inputData['repeatvalue'];
            String doesNotRepeat=inputData['doesNotRepeat'];
            String dateformat=inputData['dateformat'];
            String signIn=inputData['signIn'];
            String date=inputData['date'];
            String time=inputData['time'];

            List<String> daysList=inputData['daysList'].cast<String>();

            List<int> userIDNo=inputData['userIDNo'].cast<int>();
            List<String> email=inputData['email'].cast<String>();
            List<String> name=inputData['name'].cast<String>();

            List<int> ownerUserIDNo=inputData['ownerUserIDNo'].cast<int>();
            List<String> ownerEmail=inputData['ownerEmail'].cast<String>();
            List<String> ownerName=inputData['ownerName'].cast<String>();
            List<String> ownerFCM=inputData['ownerFCM'].cast<String>();

            List<int> playerUserIDNo=inputData['playerUserIDNo'].cast<int>();
            List<String> playerEmail=inputData['playerEmail'].cast<String>();
            List<String> playerName=inputData['playerName'].cast<String>();
            List<String> playerFCM=inputData['playerFCM'].cast<String>();

            List<int> nonPlayerUserIDNo=inputData['nonPlayerUserIDNo'].cast<int>();
            List<String> nonPlayerEmail=inputData['nonPlayerEmail'].cast<String>();
            List<String> nonPlayerName=inputData['nonPlayerName'].cast<String>();
            List<String> nonPlayerFCM=inputData['nonPlayerFCM'].cast<String>();

            bool selectSwithValue=inputData['selectSwithValue'];
            bool noteSwitchValue=inputData['noteSwitchValue'];
            bool timeSwitchValue=inputData['timeSwitchValue'];

            // DateTime dateTime = DateTime.now();
            // DateTime time = DateTime.now();
            // List<DateTime> days = [];

            var response=jsonDecode(responseData);
            AddGameResponse gameResponse = AddGameResponse.fromJson(response);

            for (int a = 0; a < gameResponse.result!.length; a++) {
              try {
                for (int b = 0; b < gameResponse.result![a].userIDList!.length; b++) {
                  for (int c = 0; c <
                      userIDNo.length; c++) {
                    if (gameResponse.result![a].userIDList![b] ==
                        userIDNo[c]) {
                      await DynamicLinksService()
                          .createDynamicLink("volunteer_availablity_screen?userid=" +
                          userIDNo[c]
                              .toString() +
                          "&refer=" +
                          gameResponse.result![a].eventId.toString() +
                          "&status=2" + "&eventname=" +
                          gameNameController + "&volunteer=" +
                          gameResponse.result![a].volunteerTypeName! + "&eventVolunteerTypeId=" +
                          gameResponse.result![a].eventVoluenteerTypeIDNo.toString() +
                          "&volunteerTypeId=" +
                          gameResponse.result![a].volunteerTypeId.toString() + "&teamname=" +
                          teamName + "&type=" +
                          (selectSwithValue == false
                              ? "event"
                              : "game") + "&fcm=" + (userFcm != null ? userFcm : "") +
                          "&name=" + userName + "&mail=" +
                          email[c] +
                          "&toMail=" + userEmail + "&toID=" + userID + "&userName=" +
                          name[c] +
                          "&location=" +
                          locationDetailsController )
                          .then((acceptvalue) async {
                        await DynamicLinksService()
                            .createDynamicLink("volunteer_availablity_screen?userid=" +
                            userIDNo[c]
                                .toString() +
                            "&refer=" +
                            gameResponse.result![a].eventId.toString() +
                            "&status=3" + "&eventname=" +
                            gameNameController + "&volunteer=" +
                            gameResponse.result![a].volunteerTypeName! + "&eventVolunteerTypeId=" +
                            gameResponse.result![a].eventVoluenteerTypeIDNo.toString() +
                            "&volunteerTypeId=" +
                            gameResponse.result![a].volunteerTypeId.toString() + "&teamname=" +
                            teamName + "&type=" +
                            (selectSwithValue == false
                                ? "event"
                                : "game") + "&fcm=" +
                            (userFcm != null ? userFcm : "") + "&name=" + userName +
                            "&mail=" +
                            email[c] +
                            "&toMail=" +
                            userEmail +
                            "&toID=" + userID + "&userName=" +
                            name[c])
                            .then((declainvalue) async {
                          await DynamicLinksService()
                              .createDynamicLink(
                              "volunteer_availablity_screen?userid=" +
                                  userIDNo[c]
                                      .toString() +
                                  "&refer=" +
                                  gameResponse.result![a].eventId.toString() +
                                  "&status=4" + "&eventname=" +
                                  gameNameController + "&volunteer=" +
                                  gameResponse.result![a].volunteerTypeName! +
                                  "&eventVolunteerTypeId=" +
                                  gameResponse.result![a].eventVoluenteerTypeIDNo.toString() +
                                  "&volunteerTypeId=" +
                                  gameResponse.result![a].volunteerTypeId.toString() +
                                  "&teamname=" +
                                  teamName + "&type=" +
                                  (selectSwithValue == false
                                      ? "event"
                                      : "game") + "&fcm=" +
                                  (userFcm != null ? userFcm : "") + "&name=" +
                                  userName +
                                  "&mail=" +
                                  email[c] +
                                  "&toMail=" +
                                  userEmail +
                                  "&toID=" + userID + "&userName=" +
                                  name[c])
                              .then((maybevalue) {
                            volunteerInviteNotification(
                                " Assigned Volunteer",
                                gameNameController,
                                Constants.gameVolunteerInvite,
                                int.parse(gameResponse.result![a].eventId.toString()),
                                "Volunteer task has been assigned by " +
                                    (userName +
                                        " for the " + (selectSwithValue == false
                                        ? "Event, "
                                        : "Game, ") + gameNameController +
                                        " that is scheduled to commence on " +
                                        (repeatvalue ==
                                            doesNotRepeat
                                            ? date
                                            : daysList.length > count
                                            ? daysList[count]
                                            : daysList[count - 1]) + " " +
                                        (time) +
                                        " at " +
                                        locationDetailsController +
                                        "."),
                                userIDNo[c],
                                email[c],
                                noteSwitchValue,
                                userName,
                                teamName,
                                gameResponse.result![a].volunteerTypeName!,
                                gameResponse.result![a].eventVoluenteerTypeIDNo!,
                                gameResponse.result![a].volunteerTypeId!,
                                gameNameController,
                                acceptvalue,
                                maybevalue,
                                declainvalue,
                                locationDetailsController,
                                (repeatvalue ==
                                    doesNotRepeat
                                    ? date
                                    : daysList.length > count
                                    ? daysList[count]
                                    : daysList[count - 1]),
                                (time),
                                signIn,teamName
                            );
                          });
                        });
                      });
                    }
                  }
                }
              } catch (e) {
                print(e);
              }
              if (eventid != gameResponse.result![a].eventId) {
                try {


                  eventid = gameResponse.result![a].eventId!;

                  if (selectSwithValue == false) {
                    if (playerUserIDNo.isNotEmpty) {
                      for (int i = 0; i < playerUserIDNo.length; i++) {
                        String acceptvalue = "",
                            maybevalue = "",
                            declainvalue = "";
                        SendPushNotificationService().sendPushNotifications(
                            playerFCM[i],
                            (selectSwithValue == false
                                ? "Event"
                                : "Game") +
                                " Notification",
                            "The " +
                                (selectSwithValue == false
                                    ? ("Event " +
                                    gameNameController +
                                    " is scheduled by " +
                                    userName + " for the team " + teamName + ", on " +
                                    (repeatvalue ==
                                        doesNotRepeat
                                        ? date
                                        : daysList[count]) + " " +
                                    (time) +
                                    " at " +
                                    locationDetailsController +
                                    ".")
                                    : ("Game " +
                                    gameNameController +
                                    " is scheduled by " + userName +
                                    " for the team " + teamName +
                                    ", on " + (repeatvalue ==
                                    doesNotRepeat
                                    ? date
                                    : daysList[count]) +
                                    " " +
                                    (time) +
                                    " at " +
                                    locationDetailsController +
                                    ".")
                                ));

                        await DynamicLinksService()
                            .createDynamicLink("splash_Screen?userid=" +
                            playerUserIDNo[i].toString() +
                            "&refer=" +
                            gameResponse.result![a].eventId.toString() +
                            "&status=2" + "&eventname=" +
                            gameNameController + "&teamname=" +
                            teamName + "&type=" +
                            (selectSwithValue == false
                                ? "event"
                                : "game") + "&fcm=" + (userFcm != null ? userFcm : "") +
                            "&name=" + userName + "&mail=" + playerEmail[i] +
                            "&toMail=" + userEmail + "&toID=" + userID + "&userName=" +
                            playerName[i] + "&location=" +
                            locationDetailsController )
                            .then((acceptvalue) async {
                          await DynamicLinksService()
                              .createDynamicLink("splash_Screen?userid=" +
                              playerUserIDNo[i].toString() +
                              "&refer=" +
                              gameResponse.result![a].eventId.toString() +
                              "&status=3" + "&eventname=" +
                              gameNameController + "&teamname=" +
                              teamName + "&type=" +
                              (selectSwithValue == false
                                  ? "event"
                                  : "game") + "&fcm=" +
                              (userFcm != null ? userFcm : "") + "&name=" + userName +
                              "&mail=" + playerEmail[i] + "&toMail=" +
                              userEmail +
                              "&toID=" + userID + "&userName=" + playerName[i])
                              .then((declainvalue) async {
                            await DynamicLinksService()
                                .createDynamicLink("splash_Screen?userid=" +
                                playerUserIDNo[i].toString() +
                                "&refer=" +
                                gameResponse.result![a].eventId.toString() +
                                "&status=4" + "&eventname=" +
                                gameNameController + "&teamname=" +
                                teamName + "&type=" +
                                (selectSwithValue == false
                                    ? "event"
                                    : "game") + "&fcm=" +
                                (userFcm != null ? userFcm : "") + "&name=" + userName +
                                "&mail=" + playerEmail[i] + "&toMail=" +
                                userEmail +
                                "&toID=" + userID + "&userName=" +
                                playerName[i])
                                .then((maybevalue) {
                              EmailService().createEventNotification(
                                  "",
                                  "",
                                  Constants.reminder,
                                  int.parse(userID),
                                  playerUserIDNo[i],
                                  int.parse(gameResponse.result![a].eventId.toString()),
                                  "The " +
                                      (selectSwithValue == false
                                          ? ("Event " +
                                          gameNameController +
                                          " is scheduled by " + userName +
                                          " for the team " + teamName + ", on " +
                                          (repeatvalue ==
                                              doesNotRepeat
                                              ? date
                                              : daysList[count]) + " " +
                                          (time) +
                                          " at " +
                                          locationDetailsController +
                                          ".")
                                          : ("Game " +
                                          gameNameController +
                                          " is scheduled by " + userName +
                                          " for the team " + teamName + ", on " +
                                          (repeatvalue ==
                                              doesNotRepeat
                                              ? date
                                              : daysList[count]) + " " +
                                          (time) +
                                          " at " +
                                          locationDetailsController +
                                          ".")),
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",noteSwitchValue);


                              playerEventNotification(
                                  "" +
                                      (selectSwithValue == false
                                          ? "New Event"
                                          : "New Game") +
                                      " Scheduled - " +
                                      gameNameController,
                                  gameNameController,
                                  Constants.gameOrEventRequest,
                                  int.parse(gameResponse.result![a].eventId.toString()),
                                  "The " +
                                      (selectSwithValue == false
                                          ? ("Event " +
                                          gameNameController +
                                          " is scheduled by " + userName +
                                          " for the team " + teamName + ", on " +
                                          (repeatvalue ==
                                              doesNotRepeat
                                              ? date
                                              : daysList[count]) + " " +
                                          (time) +
                                          " at " +
                                          locationDetailsController +
                                          ".")
                                          : ("Game " +
                                          gameNameController +
                                          " is scheduled by " + userName +
                                          " for the team " + teamName + ", on " +
                                          (repeatvalue ==
                                              doesNotRepeat
                                              ? date
                                              : daysList[count]) + " " +
                                          (time) +
                                          " at " +
                                          locationDetailsController +
                                          "."))
                                  ,
                                  playerUserIDNo[i],
                                  playerEmail[i],
                                  noteSwitchValue,
                                  playerName[i],
                                  (selectSwithValue == false
                                      ? "event, " + gameNameController
                                      + " has been Scheduled by " + userName +
                                      " for the team, " + teamName + "."
                                      : "game, " + gameNameController +
                                      " has been Scheduled by " + userName +
                                      " for the team, " + teamName + "."),
                                  acceptvalue,
                                  maybevalue,
                                  declainvalue,
                                  locationDetailsController,
                                  (repeatvalue == doesNotRepeat
                                      ? date
                                      : daysList[count]),
                                  (time),
                                  signIn
                              );
                            });
                          });
                        });
                      }
                    }
                    if (ownerUserIDNo.isNotEmpty) {
                      List<String> message = [];
                      for (int i = 0; i < ownerUserIDNo.length; i++) {
                        String acceptvalue = "",
                            maybevalue = "",
                            declainvalue = "";
                        SendPushNotificationService().sendPushNotifications(
                            ownerFCM[i],
                            (selectSwithValue == false
                                ? "Event"
                                : "Game") +
                                " Notification",
                            "The " +
                                (selectSwithValue == false
                                    ? ("Event " +
                                    gameNameController +
                                    " is scheduled by " +
                                    userName + " for the team " + teamName + ", on " +
                                    (repeatvalue ==
                                        doesNotRepeat
                                        ? date
                                        : daysList[count]) + " " +
                                    (time) +
                                    " at " +
                                    locationDetailsController +
                                    ".")
                                    : ("Game " +
                                    gameNameController +
                                    " is scheduled by " + userName +
                                    " for the team " + teamName +
                                    ", on " + (repeatvalue ==
                                    doesNotRepeat
                                    ? date
                                    : daysList[count]) +
                                    " " +
                                    (time) +
                                    " at " +
                                    locationDetailsController +
                                    ".")
                                ));

                        await DynamicLinksService()
                            .createDynamicLink("splash_Screen?userid=" +
                            ownerUserIDNo[i].toString() +
                            "&refer=" +
                            gameResponse.result![a].eventId.toString() +
                            "&status=2" + "&eventname=" +
                            gameNameController + "&teamname=" +
                            teamName + "&type=" +
                            (selectSwithValue == false
                                ? "event"
                                : "game") + "&fcm=" + (userFcm != null ? userFcm : "") +
                            "&name=" + userName + "&mail=" + ownerEmail[i] +
                            "&toMail=" + userEmail + "&toID=" + userID + "&userName=" +
                            ownerName[i] + "&location=" +
                            locationDetailsController )
                            .then((acceptvalue) async {
                          await DynamicLinksService()
                              .createDynamicLink("splash_Screen?userid=" +
                              ownerUserIDNo[i].toString() +
                              "&refer=" +
                              gameResponse.result![a].eventId.toString() +
                              "&status=3" + "&eventname=" +
                              gameNameController + "&teamname=" +
                              teamName + "&type=" +
                              (selectSwithValue == false
                                  ? "event"
                                  : "game") + "&fcm=" +
                              (userFcm != null ? userFcm : "") + "&name=" + userName +
                              "&mail=" + ownerEmail[i] + "&toMail=" +
                              userEmail +
                              "&toID=" + userID + "&userName=" + ownerName[i])
                              .then((declainvalue) async {
                            await DynamicLinksService()
                                .createDynamicLink("splash_Screen?userid=" +
                                ownerUserIDNo[i].toString() +
                                "&refer=" +
                                gameResponse.result![a].eventId.toString() +
                                "&status=4" + "&eventname=" +
                                gameNameController + "&teamname=" +
                                teamName + "&type=" +
                                (selectSwithValue == false
                                    ? "event"
                                    : "game") + "&fcm=" +
                                (userFcm != null ? userFcm : "") + "&name=" + userName +
                                "&mail=" + ownerEmail[i] + "&toMail=" +
                                userEmail +
                                "&toID=" + userID + "&userName=" +
                                ownerName[i])
                                .then((maybevalue) async {
                              EmailService().createEventNotification(
                                  "",
                                  "",
                                  Constants.reminder,
                                  int.parse(userID),
                                  ownerUserIDNo[i],
                                  int.parse(gameResponse.result![a].eventId.toString()),
                                  "The " +
                                      (selectSwithValue == false
                                          ? ("Event " +
                                          gameNameController +
                                          " is scheduled by " + userName +
                                          " for the team " + teamName + ", on " +
                                          (repeatvalue ==
                                              doesNotRepeat
                                              ? date
                                              : daysList[count]) + " " +
                                          (time) +
                                          " at " +
                                          locationDetailsController +
                                          ".")
                                          : ("Game " +
                                          gameNameController +
                                          " is scheduled by " + userName +
                                          " for the team " + teamName + ", on " +
                                          (repeatvalue ==
                                              doesNotRepeat
                                              ? date
                                              : daysList[count]) + " " +
                                          (time) +
                                          " at " +
                                          locationDetailsController +
                                          ".")),
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",noteSwitchValue);


                              await EmailService().createEventNotification(
                                  "" +
                                      (selectSwithValue == false
                                          ? "New Event"
                                          : "New Game") +
                                      " Scheduled - " +
                                      gameNameController,
                                  gameNameController,
                                  Constants.gameOrEventRequest,
                                  int.parse(userID),
                                  ownerUserIDNo[i],
                                  int.parse(gameResponse.result![a].eventId.toString()),
                                  "The " +
                                      (selectSwithValue == false
                                          ? ("Event " +
                                          gameNameController +
                                          " is scheduled by " + userName +
                                          " for the team " + teamName + ", on " +
                                          (repeatvalue ==
                                              doesNotRepeat
                                              ? date
                                              : daysList[count]) + " " +
                                          (time) +
                                          " at " +
                                          locationDetailsController +
                                          ".")
                                          : ("Game " +
                                          gameNameController +
                                          " is scheduled by " + userName +
                                          " for the team " + teamName + ", on " +
                                          (repeatvalue ==
                                              doesNotRepeat
                                              ? date
                                              : daysList[count]) + " " +
                                          (time) +
                                          " at " +
                                          locationDetailsController +
                                          "."))
                                  ,
                                  ownerEmail[i],
                                  ownerName[i],
                                  (selectSwithValue == false
                                      ? "event, " + gameNameController
                                      + " has been Scheduled by " + userName +
                                      " for the team, " + teamName + "."
                                      : "game, " + gameNameController +
                                      " has been Scheduled by " + userName +
                                      " for the team, " + teamName + "."),
                                  acceptvalue,
                                  maybevalue,
                                  declainvalue,
                                  locationDetailsController,
                                  (repeatvalue == doesNotRepeat
                                      ? date
                                      : daysList[count]),
                                  (time),
                                  signIn,
                                  "",
                                  "",
                                  "",
                                  "",noteSwitchValue

                              );
                            });
                          });
                        });
                      }
                    }
                    if (nonPlayerUserIDNo.isNotEmpty) {
                      List<String> message = [];
                      for (int i = 0; i < nonPlayerUserIDNo.length; i++) {
                        String acceptvalue = "",
                            maybevalue = "",
                            declainvalue = "";
                        SendPushNotificationService().sendPushNotifications(
                            nonPlayerFCM[i],
                            (selectSwithValue == false
                                ? "Event"
                                : "Game") +
                                " Notification",
                            "The " +
                                (selectSwithValue == false
                                    ? ("Event " +
                                    gameNameController +
                                    " is scheduled by " +
                                    userName + " for the team " + teamName + ", on " +
                                    (repeatvalue ==
                                        doesNotRepeat
                                        ? date
                                        : daysList[count]) + " " +
                                    (time) +
                                    " at " +
                                    locationDetailsController +
                                    ".")
                                    : ("Game " +
                                    gameNameController +
                                    " is scheduled by " + userName +
                                    " for the team " + teamName +
                                    ", on " + (repeatvalue ==
                                    doesNotRepeat
                                    ? date
                                    : daysList[count]) +
                                    " " +
                                    (time) +
                                    " at " +
                                    locationDetailsController +
                                    ".")
                                ));

                        await DynamicLinksService()
                            .createDynamicLink("splash_Screen?userid=" +
                            nonPlayerUserIDNo[i].toString() +
                            "&refer=" +
                            gameResponse.result![a].eventId.toString() +
                            "&status=2" + "&eventname=" +
                            gameNameController + "&teamname=" +
                            teamName + "&type=" +
                            (selectSwithValue == false
                                ? "event"
                                : "game") + "&fcm=" + (userFcm != null ? userFcm : "") +
                            "&name=" + userName + "&mail=" +
                            nonPlayerEmail[i] +
                            "&toMail=" + userEmail + "&toID=" + userID + "&userName=" +
                            nonPlayerName[i] + "&location=" +
                            locationDetailsController /* + "&date=" +
                                (dateformat == "US"
                                    ? DateFormat("MM/dd/yyyy").format(
                                    repeatvalue ==
                                        MyStrings.doesNotRepeat
                                        ? dateTime
                                        : days[count])
                                    : dateformat == "CA"
                                    ? DateFormat("yyyy/MM/dd").format(
                                    repeatvalue ==
                                        MyStrings.doesNotRepeat
                                        ? dateTime
                                        : days[count])
                                    : DateFormat("dd/MM/yyyy").format(
                                    repeatvalue ==
                                        MyStrings.doesNotRepeat
                                        ? dateTime
                                        : days[count])) + " " + (timeSwitchValue
                                ? "TBD"
                                : DateFormat("h:mma")
                                .format(time))*/)
                            .then((acceptvalue) async {
                          await DynamicLinksService()
                              .createDynamicLink("splash_Screen?userid=" +
                              nonPlayerUserIDNo[i].toString() +
                              "&refer=" +
                              gameResponse.result![a].eventId.toString() +
                              "&status=3" + "&eventname=" +
                              gameNameController + "&teamname=" +
                              teamName + "&type=" +
                              (selectSwithValue == false
                                  ? "event"
                                  : "game") + "&fcm=" +
                              (userFcm != null ? userFcm : "") + "&name=" + userName +
                              "&mail=" + nonPlayerEmail[i] + "&toMail=" +
                              userEmail +
                              "&toID=" + userID + "&userName=" +
                              nonPlayerName[i])
                              .then((declainvalue) async {
                            await DynamicLinksService()
                                .createDynamicLink("splash_Screen?userid=" +
                                nonPlayerUserIDNo[i].toString() +
                                "&refer=" +
                                gameResponse.result![a].eventId.toString() +
                                "&status=4" + "&eventname=" +
                                gameNameController + "&teamname=" +
                                teamName + "&type=" +
                                (selectSwithValue == false
                                    ? "event"
                                    : "game") + "&fcm=" +
                                (userFcm != null ? userFcm : "") + "&name=" + userName +
                                "&mail=" + nonPlayerEmail[i] + "&toMail=" +
                                userEmail +
                                "&toID=" + userID + "&userName=" +
                                nonPlayerName[i])
                                .then((maybevalue) async {
                              EmailService().createEventNotification(
                                  "",
                                  "",
                                  Constants.reminder,
                                  int.parse(userID),
                                  nonPlayerUserIDNo[i],
                                  int.parse(gameResponse.result![a].eventId.toString()),
                                  "The " +
                                      (selectSwithValue == false
                                          ? ("Event " +
                                          gameNameController +
                                          " is scheduled by " + userName +
                                          " for the team " + teamName + ", on " +
                                          (repeatvalue ==
                                              doesNotRepeat
                                              ? date
                                              : daysList[count]) + " " +
                                          (time) +
                                          " at " +
                                          locationDetailsController +
                                          ".")
                                          : ("Game " +
                                          gameNameController +
                                          " is scheduled by " + userName +
                                          " for the team " + teamName + ", on " +
                                          (repeatvalue ==
                                              doesNotRepeat
                                              ? date
                                              : daysList[count]) + " " +
                                          (time) +
                                          " at " +
                                          locationDetailsController +
                                          ".")),
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",noteSwitchValue);


                              await EmailService().createEventNotification(
                                  "" +
                                      (selectSwithValue == false
                                          ? "New Event"
                                          : "New Game") +
                                      " Scheduled - " +
                                      gameNameController,
                                  gameNameController,
                                  Constants.gameOrEventRequest,
                                  int.parse(userID),
                                  nonPlayerUserIDNo[i],
                                  int.parse(gameResponse.result![a].eventId.toString()),
                                  "The " +
                                      (selectSwithValue == false
                                          ? ("Event " +
                                          gameNameController +
                                          " is scheduled by " + userName +
                                          " for the team " + teamName + ", on " +
                                          (repeatvalue ==
                                              doesNotRepeat
                                              ? date
                                              : daysList[count]) + " " +
                                          (time) +
                                          " at " +
                                          locationDetailsController +
                                          ".")
                                          : ("Game " +
                                          gameNameController +
                                          " is scheduled by " + userName +
                                          " for the team " + teamName + ", on " +
                                          (repeatvalue ==
                                              doesNotRepeat
                                              ? date
                                              : daysList[count]) + " " +
                                          (time) +
                                          " at " +
                                          locationDetailsController +
                                          "."))
                                  ,
                                  nonPlayerEmail[i],
                                  nonPlayerName[i],
                                  (selectSwithValue == false
                                      ? "event, " + gameNameController
                                      + " has been Scheduled by " + userName +
                                      " for the team, " + teamName + "."
                                      : "game, " + gameNameController +
                                      " has been Scheduled by " + userName +
                                      " for the team, " + teamName + "."),
                                  acceptvalue,
                                  maybevalue,
                                  declainvalue,
                                  locationDetailsController,
                                  (repeatvalue ==
                                      doesNotRepeat
                                      ? date
                                      : daysList[count]),
                                  (time),
                                  signIn,
                                  "",
                                  "",
                                  "",
                                  "",noteSwitchValue

                              );
                            });
                          });
                        });
                      }
                    }
                  } else {
                    if (ownerUserIDNo.isNotEmpty) {
                      for (int j = 0; j < ownerUserIDNo.length; j++) {
                        SendPushNotificationService().sendPushNotifications(
                            ownerFCM[j],
                            (selectSwithValue == false
                                ? "Event"
                                : "Game") +
                                " Notification",
                            "The " +
                                (selectSwithValue == false
                                    ? ("Event " +
                                    gameNameController +
                                    " is scheduled by " + userName +
                                    " for the team " + teamName + ", on " +
                                    (repeatvalue ==
                                        doesNotRepeat
                                        ? date
                                        : daysList[count]) +
                                    " " + (time) + " at " +
                                    locationDetailsController +
                                    ".")
                                    : ("Game " +
                                    gameNameController +
                                    " (Game Number " + gameResponse.result![a].eventId.toString() +
                                    ") is scheduled by " + userName +
                                    " for the team " + teamName + ", on " +
                                    (repeatvalue ==
                                        doesNotRepeat
                                        ? date
                                        : daysList[count]) + " " +
                                    (time) +
                                    " at " +
                                    locationDetailsController +
                                    "."))
                        );
                        await EmailService().createEventNotification(
                            "",
                            "",
                            Constants.reminder,
                            int.parse(userID),
                            ownerUserIDNo[j],
                            int.parse(gameResponse.result![a].eventId.toString()),
                            "The " +
                                (selectSwithValue == false
                                    ? ("Event " +
                                    gameNameController +
                                    " is scheduled by " + userName + " for the team " +
                                    teamName + ", on " + (repeatvalue ==
                                    doesNotRepeat
                                    ? date
                                    : daysList[count]) +
                                    " " +
                                    (time) + " at " +
                                    locationDetailsController +
                                    ".")
                                    : ("Game " +
                                    gameNameController +
                                    " (Game Number " + gameResponse.result![a].eventId.toString() +
                                    ") is scheduled by " + userName +
                                    " for the team " + teamName + ", on " +
                                    (repeatvalue ==
                                        doesNotRepeat
                                        ? date
                                        : daysList[count]) +
                                    " " + (time) + " at " +
                                    locationDetailsController +
                                    ".")),
                            "",
                            "",
                            "",
                            "",
                            "",
                            "",
                            "",
                            "",
                            "",
                            "",
                            "",
                            "",
                            "",
                            "",noteSwitchValue);

                        if (selectSwithValue == true) {
                          await EmailService().createEventNotification(
                              "" +
                                  (selectSwithValue == false
                                      ? "New Event"
                                      : "New Game") +
                                  " Scheduled - " +
                                  gameNameController,
                              gameNameController,
                              Constants.createGameOrEvent,
                              int.parse(userID),
                              ownerUserIDNo[j],
                              int.parse(gameResponse.result![a].eventId.toString()),
                              "The " +
                                  (("Game " +
                                      gameNameController +
                                      " (Game Number " +
                                      gameResponse.result![a].eventId.toString() +
                                      ") is scheduled by " + userName +
                                      " for the team " + teamName + ", on " +
                                      (repeatvalue ==
                                          doesNotRepeat
                                          ? date
                                          : daysList[count]) +
                                      " " + (time) + " at " +
                                      locationDetailsController +
                                      "."))
                              ,
                              ownerEmail[j],
                              ownerName[j],
                              (selectSwithValue == false
                                  ? "event, " +
                                  gameNameController +
                                  " has been Scheduled by " + userName +
                                  " for the team, " + teamName + "."
                                  : "game, " +
                                  gameNameController +
                                  " has been Scheduled by " + userName +
                                  " for the team, " + teamName + "."),
                              "",
                              "",
                              "",
                              locationDetailsController,
                              (repeatvalue ==
                                  doesNotRepeat
                                  ? date
                                  : daysList[count]),
                              time,
                              signIn,
                              gameResponse.result![a].eventId.toString(),
                              "",
                              "",
                              "",noteSwitchValue


                          );
                        } else {
                          await EmailService().createEventNotification(
                              "" +
                                  (selectSwithValue == false
                                      ? "New Event"
                                      : "New Game") +
                                  " Scheduled - " +
                                  gameNameController,
                              gameNameController,
                              Constants.createGameOrEvent,
                              int.parse(userID),
                              ownerUserIDNo[j],
                              int.parse(gameResponse.result![a].eventId.toString()),
                              "The " +
                                  ("Event " +
                                      gameNameController +
                                      " is scheduled by " + userName +
                                      " for the team " +
                                      teamName + ", on " + (repeatvalue ==
                                      doesNotRepeat
                                      ? date
                                      : daysList[count]) + " " +
                                      (time) + " at " +
                                      locationDetailsController +
                                      "."),
                              ownerEmail[j],
                              ownerName[j],
                              (selectSwithValue == false
                                  ? "A new event, " +
                                  gameNameController +
                                  " has been Scheduled by " + userName +
                                  " for the team, " + teamName + "."
                                  : "A new game, " +
                                  gameNameController +
                                  " has been Scheduled by " + userName +
                                  " for the team, " + teamName + "."),
                              "",
                              "",
                              "",
                              locationDetailsController,
                              (repeatvalue ==
                                  doesNotRepeat
                                  ? date
                                  : daysList[count]),
                              (time),
                              signIn,
                              "",
                              "",
                              "",
                              "",noteSwitchValue
                          );
                        }
                      }
                    }
                    if (nonPlayerUserIDNo.isNotEmpty) {
                      for (int j = 0; j < nonPlayerUserIDNo.length; j++) {
                        SendPushNotificationService().sendPushNotifications(
                            nonPlayerFCM[j],
                            (selectSwithValue == false
                                ? "Event"
                                : "Game") +
                                " Notification",
                            "The " +
                                (selectSwithValue == false
                                    ? ("Event " +
                                    gameNameController +
                                    " is scheduled by " + userName +
                                    " for the team " +
                                    teamName + ", on " + (repeatvalue ==
                                    doesNotRepeat
                                    ? date
                                    : daysList[count]) +
                                    " " + (time) + " at " +
                                    locationDetailsController +
                                    ". Join with the team and show your support.")
                                    : ("Game " +
                                    gameNameController +
                                    " is scheduled by " + userName +
                                    " for the team " +
                                    teamName + ", on " + (repeatvalue ==
                                    doesNotRepeat
                                    ? date
                                    : daysList[count]) +
                                    " " + (time) + " at " +
                                    locationDetailsController +
                                    ". Join with the team and show your support.")
                                ));

                        await EmailService().createEventNotification(
                            "",
                            "",
                            Constants.reminder,
                            int.parse(userID),
                            nonPlayerUserIDNo[j],
                            int.parse(gameResponse.result![a].eventId.toString()),
                            "The " +
                                (selectSwithValue == false
                                    ? ("Event " +
                                    gameNameController +
                                    " is scheduled by " + userName +
                                    " for the team " +
                                    teamName + ", on " + (repeatvalue ==
                                    doesNotRepeat
                                    ? date
                                    : daysList[count]) +
                                    " " + (time) + " at " +
                                    locationDetailsController +
                                    ". Join with the team and show your support.")
                                    : ("Game " +
                                    gameNameController +
                                    " is scheduled by " + userName +
                                    " for the team " +
                                    teamName + ", on " + (repeatvalue ==
                                    doesNotRepeat
                                    ? date
                                    : daysList[count]) +
                                    " " + (time) + " at " +
                                    locationDetailsController +
                                    ". Join with the team and show your support.")
                                ),
                            "",
                            "",
                            "",
                            "",
                            "",
                            "",
                            "",
                            "",
                            "",
                            "",
                            "",
                            "",
                            "",
                            "",noteSwitchValue);
                        await EmailService().createEventNotification(
                            "" +
                                (selectSwithValue == false
                                    ? "New Event"
                                    : "New Game") +
                                " Scheduled - " +
                                gameNameController,
                            gameNameController,
                            Constants.gameOrEventInfo,
                            int.parse(userID),
                            nonPlayerUserIDNo[j],
                            int.parse(gameResponse.result![a].eventId.toString()),
                            "The " +
                                (selectSwithValue == false
                                    ? ("Event " +
                                    gameNameController +
                                    " is scheduled by " + userName +
                                    " for the team " +
                                    teamName + ", on " + ( repeatvalue ==
                                    doesNotRepeat
                                    ? date
                                    : daysList[count]) +
                                    " " + (time) + " at " +
                                    locationDetailsController +
                                    ". Join with the team and show your support.")
                                    : ("Game " +
                                    gameNameController +
                                    " is scheduled by " + userName +
                                    " for the team " +
                                    teamName + ", on " + (repeatvalue ==
                                    doesNotRepeat
                                    ? date
                                    : daysList[count]) +
                                    " " + (time) + " at " +
                                    locationDetailsController +
                                    ". Join with the team and show your support.")
                                ),
                            nonPlayerEmail[j],
                            nonPlayerName[j],
                            (selectSwithValue == false
                                ? "A new event, " +
                                gameNameController +
                                " has been Scheduled by " + userName +
                                " for the team, " + teamName + "."
                                : "A new game, " +
                                gameNameController +
                                " has been Scheduled by " + userName +
                                " for the team, " + teamName + "."),
                            "",
                            "",
                            "",
                            locationDetailsController,
                            (repeatvalue ==
                                doesNotRepeat
                                ? date
                                : daysList[count]),
                            (time),
                            signIn,
                            "",
                            "",
                            "",
                            "",noteSwitchValue

                        );
                      }
                    }
                    if (playerUserIDNo.isNotEmpty) {
                      for (int i = 0; i < playerUserIDNo.length; i++) {
                        String acceptvalue = "",
                            maybevalue = "",
                            declainvalue = "";
                        SendPushNotificationService().sendPushNotifications(
                            playerFCM[i],
                            (selectSwithValue == false
                                ? "Event"
                                : "Game") +
                                " Notification",
                            "The " +
                                (selectSwithValue == false
                                    ? ("Event " +
                                    gameNameController +
                                    " is scheduled by " +
                                    userName + " for the team " + teamName + ", on " +
                                    ( repeatvalue ==
                                        doesNotRepeat
                                        ? date
                                        : daysList[count]) + " " +
                                    (time) +
                                    " at " +
                                    locationDetailsController +
                                    ".")
                                    : ("Game " +
                                    gameNameController +
                                    " is scheduled by " + userName +
                                    " for the team " + teamName +
                                    ", on " + (repeatvalue ==
                                    doesNotRepeat
                                    ? date
                                    : daysList[count]) +
                                    " " +
                                    (time) +
                                    " at " +
                                    locationDetailsController +
                                    ".")
                                ));

                        await DynamicLinksService()
                            .createDynamicLink("splash_Screen?userid=" +
                            playerUserIDNo[i].toString() +
                            "&refer=" +
                            gameResponse.result![a].eventId.toString() +
                            "&status=2" + "&eventname=" +
                            gameNameController + "&teamname=" +
                            teamName + "&type=" +
                            (selectSwithValue == false
                                ? "event"
                                : "game") + "&fcm=" + (userFcm != null ? userFcm : "") +
                            "&name=" + userName + "&mail=" + playerEmail[i] +
                            "&toMail=" + userEmail + "&toID=" + userID + "&userName=" +
                            playerName[i] + "&location=" +
                            locationDetailsController /* + "&date=" +
                                (dateformat == "US"
                                    ? DateFormat("MM/dd/yyyy").format(
                                    repeatvalue ==
                                        MyStrings.doesNotRepeat
                                        ? dateTime
                                        : days[count])
                                    : dateformat == "CA"
                                    ? DateFormat("yyyy/MM/dd").format(
                                    repeatvalue ==
                                        MyStrings.doesNotRepeat
                                        ? dateTime
                                        : days[count])
                                    : DateFormat("dd/MM/yyyy").format(
                                    repeatvalue ==
                                        MyStrings.doesNotRepeat
                                        ? dateTime
                                        : days[count])) + " " + (timeSwitchValue
                                ? "TBD"
                                : DateFormat("h:mma")
                                .format(time))*/)
                            .then((acceptvalue) async {
                          await DynamicLinksService()
                              .createDynamicLink("splash_Screen?userid=" +
                              playerUserIDNo[i].toString() +
                              "&refer=" +
                              gameResponse.result![a].eventId.toString() +
                              "&status=3" + "&eventname=" +
                              gameNameController + "&teamname=" +
                              teamName + "&type=" +
                              (selectSwithValue == false
                                  ? "event"
                                  : "game") + "&fcm=" +
                              (userFcm != null ? userFcm : "") + "&name=" + userName +
                              "&mail=" + playerEmail[i] + "&toMail=" +
                              userEmail +
                              "&toID=" + userID + "&userName=" + playerName[i])
                              .then((declainvalue) async {
                            await DynamicLinksService()
                                .createDynamicLink("splash_Screen?userid=" +
                                playerUserIDNo[i].toString() +
                                "&refer=" +
                                gameResponse.result![a].eventId.toString() +
                                "&status=4" + "&eventname=" +
                                gameNameController + "&teamname=" +
                                teamName + "&type=" +
                                (selectSwithValue == false
                                    ? "event"
                                    : "game") + "&fcm=" +
                                (userFcm != null ? userFcm : "") + "&name=" + userName +
                                "&mail=" + playerEmail[i] + "&toMail=" +
                                userEmail +
                                "&toID=" + userID + "&userName=" +
                                playerName[i])
                                .then((maybevalue) {
                              EmailService().createEventNotification(
                                  "",
                                  "",
                                  Constants.reminder,
                                  int.parse(userID),
                                  playerUserIDNo[i],
                                  int.parse(gameResponse.result![a].eventId.toString()),
                                  "The " +
                                      (selectSwithValue == false
                                          ? ("Event " +
                                          gameNameController +
                                          " is scheduled by " + userName +
                                          " for the team " + teamName + ", on " +
                                          ( repeatvalue ==
                                              doesNotRepeat
                                              ? date
                                              : daysList[count]) + " " +
                                          (time) +
                                          " at " +
                                          locationDetailsController +
                                          ".")
                                          : ("Game " +
                                          gameNameController +
                                          " is scheduled by " + userName +
                                          " for the team " + teamName + ", on " +
                                          ( repeatvalue ==
                                              doesNotRepeat
                                              ? date
                                              : daysList[count]) + " " +
                                          (time) +
                                          " at " +
                                          locationDetailsController +
                                          ".")),
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",noteSwitchValue);


                              playerEventNotification(
                                  "" +
                                      (selectSwithValue == false
                                          ? "New Event"
                                          : "New Game") +
                                      " Scheduled - " +
                                      gameNameController,
                                  gameNameController,
                                  Constants.gameOrEventRequest,
                                  int.parse(gameResponse.result![a].eventId.toString()),
                                  "The " +
                                      (selectSwithValue == false
                                          ? ("Event " +
                                          gameNameController +
                                          " is scheduled by " + userName +
                                          " for the team " + teamName + ", on " +
                                          (repeatvalue ==
                                              doesNotRepeat
                                              ? date
                                              : daysList[count]) + " " +
                                          (time) +
                                          " at " +
                                          locationDetailsController +
                                          ".")
                                          : ("Game " +
                                          gameNameController +
                                          " is scheduled by " + userName +
                                          " for the team " + teamName + ", on " +
                                          (repeatvalue ==
                                              doesNotRepeat
                                              ? date
                                              : daysList[count]) + " " +
                                          (time) +
                                          " at " +
                                          locationDetailsController +
                                          "."))
                                  ,
                                  playerUserIDNo[i],
                                  playerEmail[i],
                                  noteSwitchValue,
                                  playerName[i],
                                  (selectSwithValue == false
                                      ? "event, " + gameNameController
                                      + " has been Scheduled by " + userName +
                                      " for the team, " + teamName + "."
                                      : "game, " + gameNameController +
                                      " has been Scheduled by " + userName +
                                      " for the team, " + teamName + "."),
                                  acceptvalue,
                                  maybevalue,
                                  declainvalue,
                                  locationDetailsController,
                                  (repeatvalue ==
                                      doesNotRepeat
                                      ? date
                                      : daysList[count]),
                                  (time),
                                  signIn


                              );
                            });
                          });
                        });
                      }
                    }
                  }

                  /*  if (playerMailList.isEmpty) {
                        if(days.isNotEmpty){
                          bool isSameDate=false;
                          for(int i=0;i<days.length;i++){
                            if(DateFormat("dd/MM/yyyy").parse(DateFormat("dd/MM/yyyy").format(dateTime)).isAtSameMomentAs(days[i])){
                              isSameDate=true;
                            }
                          }
                          if(!isSameDate){
                            days=[];
                            repeatvalue = MyStrings.doesNotRepeat;
                            addGameAsync(lat,long);
                          }

                        }
                      }*/
                  /*if (playerMailList.isEmpty) {
                        stopProgressBar();


                        print("add game 5");
                        if (kIsWeb) {
                          print("add game 6");
                          setState(() {
                            print("Marlen 4");
                            _eventListviewProvider.setRefreshScreen();

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
                            _eventListviewProvider.setRefreshScreen();

                            Navigator.pop(context);
                          }
                        }
                        //   Navigation.navigateTo(context, MyRoutes.eventListviewScreen);
                      }*/

                  count++;
                } catch (e) {
                  print(e);

                }
              }
            }
          } catch (e) {
            print(e);
          }
          break;
      }
      return Future.value(true);
    });
  } catch (e) {
    print(e);
  }
}
Future playerEventNotification(String subject,
    String title,
    int notificationID,
    int referencetableID,
    String content,
    int userId,
    String email,
    bool noteSwitchValue,
    String coachName,
    String gameTitle,
    String acceptLink,
    String maybeLink,
    String declineLink,
    String address,
    String date,
    String time,
    String signin,) async {
  try {
    EventPlayerNotificationRequest _sendEmail =
    EventPlayerNotificationRequest();
    _sendEmail.eventId = referencetableID;
    List<NotificationMailList> notificationMailList = [];
    NotificationMailList _notificationList = NotificationMailList();
    _notificationList.notificationTypeID = notificationID;
    _notificationList.subject = subject;
    _notificationList.title = title;
    _notificationList.referenceTableId = referencetableID;
    _notificationList.contentText = content;
    _notificationList.recipientId = userId;
    _notificationList.senderId = int.parse(
        "${await SharedPrefManager.instance.getStringAsync(
            Constants.userIdNo)}");
    _notificationList.to = email;
    _notificationList.isNotesRequired = noteSwitchValue ? 1 : 0;
    _notificationList.coachName = coachName;
    _notificationList.gameTitle = gameTitle;
    _notificationList.acceptLink = acceptLink;
    _notificationList.maybeLink = maybeLink;
    _notificationList.declineLink = declineLink;
    _notificationList.address = address;
    _notificationList.date = date;
    _notificationList.time = time;
    _notificationList.signin = signin;
    notificationMailList.add(_notificationList);
    _sendEmail.notificationMailList = notificationMailList;


    await ApiManager()
        .getDio()!
        .post(Endpoints.serverGameUrl + Endpoints.sendEventNotificationMail,
        data: _sendEmail)
        .then((response) => print(response))
        .catchError((onError) {
      print(onError);

      //  listener.onFailure(DioErrorUtil.handleErrors(onError));
    });
  } catch (e) {
    print(e);
    //  listener.onFailure(ExceptionErrorUtil.handleErrors(e));
  }
}

Future volunteerInviteNotification(String subject,
    String title,
    int notificationID,
    int referencetableID,
    String content,
    int userId,
    String email,
    bool noteSwitchValue,
    String coachName,
    String teamname,
    String volunteer,
    int eventVoluenteerTypeIDNo,
    int volunteerTypeId,
    String gameTitle,
    String acceptLink,
    String maybeLink,
    String declineLink,
    String address,
    String date,
    String time,
    String signin,
    String teamName,
    ) async {
  try {
    EventPlayerNotificationRequest _sendEmail =
    EventPlayerNotificationRequest();
    _sendEmail.eventId = referencetableID;
    List<NotificationMailList> notificationMailList = [];
    NotificationMailList _notificationList = NotificationMailList();
    _notificationList.notificationTypeID = notificationID;
    _notificationList.subject = subject;
    _notificationList.title = title;
    _notificationList.referenceTableId = referencetableID;
    _notificationList.contentText = content;
    _notificationList.recipientId = userId;
    _notificationList.senderId = int.parse(
        "${await SharedPrefManager.instance.getStringAsync(
            Constants.userIdNo)}");
    _notificationList.to = email;
    _notificationList.isNotesRequired = noteSwitchValue ? 1 : 0;
    _notificationList.coachName = coachName;
    _notificationList.teamName = teamName;
    _notificationList.volunteer = volunteer;
    _notificationList.gameTitle = gameTitle;
    _notificationList.acceptLink = acceptLink;
    _notificationList.maybeLink = maybeLink;
    _notificationList.declineLink = declineLink;
    _notificationList.address = address;
    _notificationList.date = date;
    _notificationList.time = time;
    _notificationList.signin = signin;
    _notificationList.volunteerTypeName = volunteer;
    _notificationList.volunteerTypeId = volunteerTypeId.toString();
    _notificationList.eventVoluenteerTypeIDNo =
        eventVoluenteerTypeIDNo.toString();
    _notificationList.eventId = referencetableID.toString();
    notificationMailList.add(_notificationList);
    _sendEmail.notificationMailList = notificationMailList;


    await ApiManager()
        .getDio()!
        .post(Endpoints.serverGameUrl + Endpoints.volunteerInvite,
        data: _sendEmail)
        .then((response) => print(response))
        .catchError((onError) {
      print(onError);

      //  listener.onFailure(DioErrorUtil.handleErrors(onError));
    });
  } catch (e) {
    print(e);
    //  listener.onFailure(ExceptionErrorUtil.handleErrors(e));
  }
}

class AddEventProvider extends BaseProvider {
  //region Private Members

  a.AddGameRequest? _addGameRequest;
  SelectTeamRequest? _selectTeamRequest;
  TextEditingController? gameNameController;
  TextEditingController? opponentNameController;
  TextEditingController? opponentIDController;
  TextEditingController? StartDatePickerController;
  TextEditingController? EndDatePickerController;
  TextEditingController? locationDetailsController;
  TextEditingController? noteController;
  TextEditingController? timezoneController;
  var weekdayvalues = List.filled(7, false);
  String repeatvalue = MyStrings.doesNotRepeat;
  String selectedDays="";
  DateTime dateTime = DateTime.now();
  DateTime beforeEditDateTime = DateTime.now();
  DateTime time = DateTime.now();
  List<DateTime> days = [];
  bool? _autoValidate;
  bool timeSwitchValue = false;
  bool selectSwithValue = false;
  bool? editselectSwithValue;
  String? selectedHomeAway;
  String duration = '';
  String arriveEarly = '';
  Duration? initialArriveEarly;
  Duration? initialDuration;
  String? selectedFlagColor;

  bool trackSwitchValue = false;
  bool noteSwitchValue = false;
  bool mailSwitchValue = false;
  List<List<TextEditingController>> volunteerPlayernamecontroller = [];
  List<TextEditingController> volunteerNameController = [];
  List<TextEditingController> volunteerIDController = [];
  List<TextEditingController> volunteerCheckBoxController = [];
  List<int> repeatDays = [];
  List<int> userIDList = [];
  List<a.VolunteerTypeList> volunteerTypeList = [];
  int? eventID, eventGroupId;
  RoasterListViewResponse? roasterListViewResponse;
  bool volSelected = false;
  String? dateformat, first;
  String userID = "",
      userName = "",
      teamName = "";
  String? userFcm, userEmail;
  String? signIn;
  double? lat, long;
  List<UserMailList> ownerMailList = [];
  List<UserMailList> playerMailList = [];
  List<UserMailList> nonPlayerMailList = [];
  GetTeamMembersEmailResponse? _getTeamMembersEmailResponse;

//endregion

  /*
Return Type:
Input Parameters:
Use: Initiate value to the variable and create object.
 */
  initialProvider() {
    getCountryCodeAsyncs();
    gameNameController = TextEditingController();
    opponentNameController = TextEditingController();
    opponentIDController = TextEditingController();
    StartDatePickerController = TextEditingController();
    EndDatePickerController = TextEditingController();
    locationDetailsController = TextEditingController();
    timezoneController = TextEditingController();
    noteController = TextEditingController();
    _autoValidate = false;
    weekdayvalues = List.filled(7, false);
    repeatvalue = MyStrings.doesNotRepeat;
    dateTime = DateTime.now();
    beforeEditDateTime = DateTime.now();
    time = DateTime.now();
    initialArriveEarly = Duration.zero;
    initialDuration = Duration.zero;
    timeSwitchValue = false;
    volSelected = false;
    selectSwithValue = false;
    selectedHomeAway = null;
    duration = '';
    arriveEarly = '';
    selectedDays="";
    selectedFlagColor = null;
    trackSwitchValue = false;
    noteSwitchValue = false;
    mailSwitchValue = false;
    editselectSwithValue = null;
    volunteerPlayernamecontroller = [];
    volunteerNameController = [];
    volunteerIDController = [];
    volunteerCheckBoxController = [];
    volunteerTypeList = [];
    ownerMailList = [];
    playerMailList = [];
    nonPlayerMailList = [];
  }

  Future<void> getCountryCodeAsyncs() async {
    first =
    "${await SharedPrefManager.instance.getStringAsync(Constants.countryCode)}";
    userID =
    "${await SharedPrefManager.instance.getStringAsync(Constants.userIdNo)}";
    userName =
    "${await SharedPrefManager.instance.getStringAsync(Constants.userName)}";
    teamName =
    "${await SharedPrefManager.instance.getStringAsync(Constants.teamName)}";
    userFcm =
    "${await SharedPrefManager.instance.getStringAsync(Constants.FCM)}";
    userEmail =
    "${await SharedPrefManager.instance.getStringAsync(Constants.userId)}";
    dateformat = first;
    print(dateformat);
  }

  /*
Return Type:
Input Parameters:
Use: Create API Calls and Handle Exceptions.
 */
  Future addGameAsync(double lat, double lon) async {
    try {
      this.lat = lat;
      this.long = lon;
      List<int> customUserId=[];
      for(int i=0;i<ownerMailList.length;i++){
        customUserId.add(ownerMailList[i].userIDNo!);
      }
      for(int i=0;i<playerMailList.length;i++){
        customUserId.add(playerMailList[i].userIDNo!);

      }
      for(int i=0;i<nonPlayerMailList.length;i++){
        customUserId.add(nonPlayerMailList[i].userIDNo!);

      }
      _addGameRequest = a.AddGameRequest();
      _addGameRequest!.result=a.Result();
      _addGameRequest!.result!.eventId = 0;
      _addGameRequest!.result!.type =
      selectSwithValue == false ? Constants.event : Constants.game;
      _addGameRequest!.result!.name = gameNameController!.text;
      _addGameRequest!.result!.sportIDNo = 1;
      _addGameRequest!.result!.scheduleDate = DateFormat('dd/MM/yyyy').format(dateTime);
      _addGameRequest!.result!.scheduleTime =
      timeSwitchValue ? "00:00" : DateFormat("h:mma").format(time);
      _addGameRequest!.result!.venue = locationDetailsController!.text;
      _addGameRequest!.result!.teamIDNo = int.parse(
          "${await SharedPrefManager.instance.getStringAsync(
              Constants.teamID)}");
      _addGameRequest!.result!.opponentTeamID = opponentIDController!.text.isEmpty
          ? null
          : int.parse(opponentIDController!.text);
      _addGameRequest!.result!.status = Constants.upcoming;
      _addGameRequest!.result!.repeat = repeatvalue == MyStrings.doesNotRepeat ? 0 : 1;
      _addGameRequest!.result!.repeatType = repeatvalue == MyStrings.doesNotRepeat
          ? Constants.doNotRepeat
          : repeatvalue == MyStrings.weekly ? Constants.weekly : Constants
          .daily;
      if (repeatvalue == MyStrings.weekly || repeatvalue == MyStrings.daily) {
        _addGameRequest!.result!.repeatStartDate =
            DateFormat('dd/MM/yyyy').format(dateformat == "US"
                ? DateFormat("MM/dd/yyyy").parse(StartDatePickerController!.text)
                : dateformat == "CA"
                ? DateFormat("yyyy/MM/dd").parse(StartDatePickerController!.text)
                : DateFormat("dd/MM/yyyy")
                .parse(StartDatePickerController!.text));
        _addGameRequest!.result!.repeatEndDate =
            DateFormat('dd/MM/yyyy').format(dateformat == "US"
                ? DateFormat("MM/dd/yyyy").parse(EndDatePickerController!.text)
                : dateformat == "CA"
                ? DateFormat("yyyy/MM/dd").parse(EndDatePickerController!.text)
                : DateFormat("dd/MM/yyyy").parse(EndDatePickerController!.text));
      }else{
        _addGameRequest!.result!.repeatStartDate =StartDatePickerController!.text;
        _addGameRequest!.result!.repeatEndDate =EndDatePickerController!.text;
      }
      _addGameRequest!.result!.locationAddress = locationDetailsController!.text;
      _addGameRequest!.result!.locationDetails = locationDetailsController!.text;
      _addGameRequest!.result!.duration = duration;
      _addGameRequest!.result!.arriveEarly = arriveEarly;
      _addGameRequest!.result!.flagColor = selectedFlagColor??"";
      _addGameRequest!.result!.trackAvail = trackSwitchValue == false ? 0 : 1;
      _addGameRequest!.result!.IsNotesRequired = noteSwitchValue;
      _addGameRequest!.result!.notes = noteController!.text;
      _addGameRequest!.result!.tDB = timeSwitchValue;
      _addGameRequest!.result!.timeZone = timezoneController!.text;
      _addGameRequest!.result!.homeOrAway = selectedHomeAway??"";
      _addGameRequest!.result!.isCustom = mailSwitchValue;
      _addGameRequest!.result!.customMemberList = customUserId;
      _addGameRequest!.result!.latitude = lat.toString();
      _addGameRequest!.result!.longtitude = lon.toString();
      _addGameRequest!.result!.userIDNo = int.parse(
          "${await SharedPrefManager.instance.getStringAsync(
              Constants.userIdNo)}");
      repeatDays = [];
      for (int i = 0; i < weekdayvalues
          .toList()
          .length; i++) {
        if (weekdayvalues[i] == true) {
          repeatDays.add(i + 1);
        }
      }
      if (repeatvalue == MyStrings.weekly) {
        DateTime startDate = dateformat == "US"
            ? DateFormat("MM/dd/yyyy").parse(StartDatePickerController!.text)
            : dateformat == "CA"
            ? DateFormat("yyyy/MM/dd").parse(StartDatePickerController!.text)
            : DateFormat("dd/MM/yyyy")
            .parse(StartDatePickerController!.text);
        DateTime endDate = dateformat == "US"
            ? DateFormat("MM/dd/yyyy").parse(EndDatePickerController!.text)
            : dateformat == "CA"
            ? DateFormat("yyyy/MM/dd").parse(EndDatePickerController!.text)
            : DateFormat("dd/MM/yyyy").parse(EndDatePickerController!.text);
        getDaysInBetween(startDate, endDate, repeatDays);
      }
      if (repeatvalue == MyStrings.daily) {
        DateTime startDate = dateformat == "US"
            ? DateFormat("MM/dd/yyyy").parse(StartDatePickerController!.text)
            : dateformat == "CA"
            ? DateFormat("yyyy/MM/dd").parse(StartDatePickerController!.text)
            : DateFormat("dd/MM/yyyy")
            .parse(StartDatePickerController!.text);
        DateTime endDate = dateformat == "US"
            ? DateFormat("MM/dd/yyyy").parse(EndDatePickerController!.text)
            : dateformat == "CA"
            ? DateFormat("yyyy/MM/dd").parse(EndDatePickerController!.text)
            : DateFormat("dd/MM/yyyy").parse(EndDatePickerController!.text);
        getDaysInBetweenDaily(startDate, endDate);
      }
      _addGameRequest!.result!.repeatDays = repeatDays;
      for (int i = 0; i < volunteerNameController.length; i++) {
        if (volunteerCheckBoxController[i].text == "true") {
          a.VolunteerTypeList volunteerType = new a.VolunteerTypeList();
          userIDList = [];
          volunteerType.eventVoluenteerTypeIDNo = 0;
          volunteerType.eventId = 0;
          volunteerType.isDeleted = 0;
          volunteerType.volunteerTypeId = volunteerIDController[i].text.isEmpty
              ? 250
              : int.parse(volunteerIDController[i].text);
          volunteerType.volunteerTypeName = volunteerNameController[i].text;
          for (int j = 0; j < volunteerPlayernamecontroller[i].length; j++) {
            for (int k = 0;
            k < roasterListViewResponse!.result!.userDetails!.length;
            k++) {
              if ((roasterListViewResponse!.result!.userDetails![k].userFirstName! +
                  " " +
                  roasterListViewResponse!.result!.userDetails![k].userLastName!) ==
                  volunteerPlayernamecontroller[i][j].text) {
                if (userIDList.isEmpty) {
                  userIDList
                      .add(roasterListViewResponse!.result!.userDetails![k].userIdNo!);
                } else {
                  if (userIDList.contains(
                      roasterListViewResponse!.result!.userDetails![k]
                          .userIdNo!)) {} else {
                    userIDList
                        .add(roasterListViewResponse!.result!.userDetails![k].userIdNo!);
                  }
                }
              }
            }
          }
          volunteerType.userIDList = userIDList;
          volunteerTypeList.add(volunteerType);
        }
      }
      _addGameRequest!.result!.volunteerTypeList = volunteerTypeList;

      await ApiManager()
          .getDio()!
          .post(Endpoints.serverGameUrl + Endpoints.addGameorEvent,
          data: _addGameRequest!.result)
          .then((response) => registerResponse(response))
          .catchError((onError) {
        listener.onFailure(DioErrorUtil.handleErrors(onError));
      });
    } catch (e) {
      print(e);
      listener.onFailure(ExceptionErrorUtil.handleErrors(e));
    }
  }

  Future<void> registerResponse(Response response) async {


    if(!kIsWeb){

      List<int> userIDNo=[];
      List<String> email=[];
      List<String> name=[];

      List<int> ownerUserIDNo=[];
      List<String> ownerEmail=[];
      List<String> ownerName=[];
      List<String> ownerFCM=[];

      List<int> playerUserIDNo=[];
      List<String> playerEmail=[];
      List<String> playerName=[];
      List<String> playerFCM=[];

      List<int> nonPlayerUserIDNo=[];
      List<String> nonPlayerEmail=[];
      List<String> nonPlayerName=[];
      List<String> nonPlayerFCM=[];

      List<String> daysList=[];

      for(int i=0;i<_getTeamMembersEmailResponse!.result!.userMailList!.length;i++){
        userIDNo.add(_getTeamMembersEmailResponse!.result!.userMailList![i].userIDNo!);
        email.add(_getTeamMembersEmailResponse!.result!.userMailList![i].email!);
        name.add(_getTeamMembersEmailResponse!.result!.userMailList![i].name!);
      }
      for(int i=0;i<ownerMailList.length;i++){
        ownerUserIDNo.add(ownerMailList[i].userIDNo!);
        ownerEmail.add(ownerMailList[i].email!);
        ownerName.add(ownerMailList[i].name!);
        ownerFCM.add(ownerMailList[i].FCMTokenID ?? "");
      }
      for(int i=0;i<playerMailList.length;i++){
        playerUserIDNo.add(playerMailList[i].userIDNo!);
        playerEmail.add(playerMailList[i].email!);
        playerName.add(playerMailList[i].name!);
        playerFCM.add(playerMailList[i].FCMTokenID??"");
      }
      for(int i=0;i<nonPlayerMailList.length;i++){
        nonPlayerUserIDNo.add(nonPlayerMailList[i].userIDNo!);
        nonPlayerEmail.add(nonPlayerMailList[i].email!);
        nonPlayerName.add(nonPlayerMailList[i].name!);
        nonPlayerFCM.add(nonPlayerMailList[i].FCMTokenID??"");
      }
      String date=(dateformat == "US"
          ? DateFormat("MM/dd/yyyy").format(
          dateTime
      )
          : dateformat == "CA"
          ? DateFormat("yyyy/MM/dd").format(
          dateTime
      )
          : DateFormat("dd/MM/yyyy").format(
          dateTime
      ));

      for(int i=0;i<days.length;i++){
        daysList.add((dateformat == "US"
            ? DateFormat("MM/dd/yyyy").format(
            days[i]
        )
            : dateformat == "CA"
            ? DateFormat("yyyy/MM/dd").format(
            days[i]
        )
            : DateFormat("dd/MM/yyyy").format(
            days[i]
        )));
      }
      String time=(timeSwitchValue
          ? "TBD"
          : DateFormat("h:mma")
          .format(this.time));
      try {
        // await Workmanager().cancelAll();
        Workmanager().initialize(
          callbackDispatcher,
          isInDebugMode: false,
        );
        Workmanager().registerOneOffTask(
            fetchBackground,
            fetchBackground,
            existingWorkPolicy: ExistingWorkPolicy.append,
            inputData: <String, dynamic>{
              'response': jsonEncode(response.data),
              'userIDNo':userIDNo,
              'email':email,
              'name':name,
              'ownerUserIDNo':ownerUserIDNo,
              'ownerEmail':ownerEmail,
              'ownerName':ownerName,
              'ownerFCM':ownerFCM,
              'playerUserIDNo':playerUserIDNo,
              'playerEmail':playerEmail,
              'playerName':playerName,
              'playerFCM':playerFCM,
              'doesNotRepeat':MyStrings.doesNotRepeat,
              'nonPlayerUserIDNo':nonPlayerUserIDNo,
              'nonPlayerEmail':nonPlayerEmail,
              'nonPlayerName':nonPlayerName,
              'nonPlayerFCM':nonPlayerFCM,
              'gameNameController':gameNameController!.text,
              'locationDetailsController':locationDetailsController!.text,
              'teamName':teamName,
              'selectSwithValue':selectSwithValue,
              'userFcm':userFcm,
              'userName':userName,
              'userEmail':userEmail,
              'userID':userID,
              'noteSwitchValue':noteSwitchValue,
              'timeSwitchValue':timeSwitchValue,
              'repeatvalue':repeatvalue,
              'dateformat':dateformat,
              'signIn':signIn,
              'date':date,
              'daysList':daysList,
              'time':time,

            },
            constraints: Constraints(
              networkType: NetworkType.connected,
            )
        );
      } catch (e) {
        print(e);
      }
      if(response.data['Result'].length==0){
        listener.onSuccess("", reqId: ResponseIds.ADD_GAME);

      }else{
        listener.onSuccess(AddGameResponse.fromJson(response.data), reqId: ResponseIds.ADD_GAME);
      }

    }else {
      int eventid = 0;
      int count = 0;
      if(response.data['Result'].length==0){
        listener.onSuccess("", reqId: ResponseIds.ADD_GAME);

      }
      AddGameResponse gameResponse = AddGameResponse.fromJson(response.data);

      for (int a = 0; a < gameResponse.result!.length; a++) {
        try {
          for (int b = 0; b < gameResponse.result![a].userIDList!.length; b++) {
            for (int c = 0; c <
                _getTeamMembersEmailResponse!.result!.userMailList!.length; c++) {
              if (gameResponse.result![a].userIDList![b] ==
                  _getTeamMembersEmailResponse!.result!.userMailList![c].userIDNo) {
                await DynamicLinksService()
                    .createDynamicLink("volunteer_availablity_screen?userid=" +
                    _getTeamMembersEmailResponse!.result!.userMailList![c].userIDNo
                        .toString() +
                    "&refer=" +
                    gameResponse.result![a].eventId.toString() +
                    "&status=2" + "&eventname=" +
                    gameNameController!.text + "&volunteer=" +
                    gameResponse.result![a].volunteerTypeName! + "&eventVolunteerTypeId=" +
                    gameResponse.result![a].eventVoluenteerTypeIDNo.toString() +
                    "&volunteerTypeId=" +
                    gameResponse.result![a].volunteerTypeId.toString() + "&teamname=" +
                    teamName + "&type=" +
                    (selectSwithValue == false
                        ? "event"
                        : "game") + "&fcm=" + (userFcm != null ? userFcm! : "") +
                    "&name=" + userName + "&mail=" +
                    _getTeamMembersEmailResponse!.result!.userMailList![c].email! +
                    "&toMail=" + userEmail! + "&toID=" + userID + "&userName=" +
                    _getTeamMembersEmailResponse!.result!.userMailList![c].name! +
                    "&location=" +
                    locationDetailsController!.text )
                    .then((acceptvalue) async {
                  await DynamicLinksService()
                      .createDynamicLink("volunteer_availablity_screen?userid=" +
                      _getTeamMembersEmailResponse!.result!.userMailList![c].userIDNo
                          .toString() +
                      "&refer=" +
                      gameResponse.result![a].eventId.toString() +
                      "&status=3" + "&eventname=" +
                      gameNameController!.text + "&volunteer=" +
                      gameResponse.result![a].volunteerTypeName! + "&eventVolunteerTypeId=" +
                      gameResponse.result![a].eventVoluenteerTypeIDNo.toString() +
                      "&volunteerTypeId=" +
                      gameResponse.result![a].volunteerTypeId.toString() + "&teamname=" +
                      teamName + "&type=" +
                      (selectSwithValue == false
                          ? "event"
                          : "game") + "&fcm=" +
                      (userFcm != null ? userFcm! : "") + "&name=" + userName +
                      "&mail=" +
                      _getTeamMembersEmailResponse!.result!.userMailList![c].email! +
                      "&toMail=" +
                      userEmail! +
                      "&toID=" + userID + "&userName=" +
                      _getTeamMembersEmailResponse!.result!.userMailList![c].name!)
                      .then((declainvalue) async {
                    await DynamicLinksService()
                        .createDynamicLink(
                        "volunteer_availablity_screen?userid=" +
                            _getTeamMembersEmailResponse!.result!.userMailList![c].userIDNo
                                .toString() +
                            "&refer=" +
                            gameResponse.result![a].eventId.toString() +
                            "&status=4" + "&eventname=" +
                            gameNameController!.text + "&volunteer=" +
                            gameResponse.result![a].volunteerTypeName! +
                            "&eventVolunteerTypeId=" +
                            gameResponse.result![a].eventVoluenteerTypeIDNo.toString() +
                            "&volunteerTypeId=" +
                            gameResponse.result![a].volunteerTypeId.toString() +
                            "&teamname=" +
                            teamName + "&type=" +
                            (selectSwithValue == false
                                ? "event"
                                : "game") + "&fcm=" +
                            (userFcm != null ? userFcm! : "") + "&name=" +
                            userName +
                            "&mail=" +
                            _getTeamMembersEmailResponse!.result!.userMailList![c].email! +
                            "&toMail=" +
                            userEmail! +
                            "&toID=" + userID + "&userName=" +
                            _getTeamMembersEmailResponse!.result!.userMailList![c].name!)
                        .then((maybevalue) {
                      volunteerInviteNotification(
                          " Assigned Volunteer",
                          gameNameController!.text,
                          Constants.gameVolunteerInvite,
                          int.parse(gameResponse.result![a].eventId.toString()),
                          "Volunteer task has been assigned by " +
                              (userName +
                                  " for the " + (selectSwithValue == false
                                  ? "Event, "
                                  : "Game, ") + gameNameController!.text +
                                  " that is scheduled to commence on " +
                                  (dateformat == "US"
                                      ? DateFormat("MM/dd/yyyy").format(
                                      repeatvalue ==
                                          MyStrings.doesNotRepeat
                                          ? dateTime
                                          : days.length > count
                                          ? days[count]
                                          : days[count - 1])
                                      : dateformat == "CA"
                                      ? DateFormat("yyyy/MM/dd").format(
                                      repeatvalue ==
                                          MyStrings.doesNotRepeat
                                          ? dateTime
                                          : days.length > count
                                          ? days[count]
                                          : days[count - 1])
                                      : DateFormat("dd/MM/yyyy").format(
                                      repeatvalue ==
                                          MyStrings.doesNotRepeat
                                          ? dateTime
                                          : days.length > count
                                          ? days[count]
                                          : days[count - 1])) + " " +
                                  (timeSwitchValue
                                      ? "TBD"
                                      : DateFormat("h:mma")
                                      .format(time)) +
                                  " at " +
                                  locationDetailsController!.text +
                                  "."),
                          _getTeamMembersEmailResponse!.result!.userMailList![c].userIDNo!,
                          _getTeamMembersEmailResponse!.result!.userMailList![c].email!,
                          noteSwitchValue,
                          userName,
                          teamName,
                          gameResponse.result![a].volunteerTypeName!,
                          gameResponse.result![a].eventVoluenteerTypeIDNo!,
                          gameResponse.result![a].volunteerTypeId!,
                          gameNameController!.text,
                          acceptvalue,
                          maybevalue,
                          declainvalue,
                          locationDetailsController!.text,
                          (dateformat == "US"
                              ? DateFormat("MM/dd/yyyy").format(
                              repeatvalue == MyStrings.doesNotRepeat
                                  ? dateTime
                                  : days.length > count
                                  ? days[count]
                                  : days[count - 1])
                              : dateformat == "CA"
                              ? DateFormat("yyyy/MM/dd").format(
                              repeatvalue == MyStrings.doesNotRepeat
                                  ? dateTime
                                  : days.length > count
                                  ? days[count]
                                  : days[count - 1])
                              : DateFormat("dd/MM/yyyy").format(
                              repeatvalue == MyStrings.doesNotRepeat
                                  ? dateTime
                                  : days.length > count
                                  ? days[count]
                                  : days[count - 1])),
                          (timeSwitchValue
                              ? "TBD"
                              : DateFormat("h:mma")
                              .format(time)),
                          signIn!
                      );
                    });
                  });
                });
              }
            }
          }
        } catch (e) {
          print(e);
        }
        if (eventid != gameResponse.result![a].eventId) {
          try {
            _selectTeamRequest = SelectTeamRequest();
            _selectTeamRequest!.userIdNo = int.parse(
                "${await SharedPrefManager.instance.getStringAsync(
                    Constants.teamID)}");
            if (eventid == 0) {
              listener.onSuccess(gameResponse, reqId: ResponseIds.ADD_GAME);
            }
            eventid = gameResponse.result![a].eventId!;

            if (selectSwithValue == false) {
              if (playerMailList.isNotEmpty) {
                for (int i = 0; i < playerMailList.length; i++) {
                  String acceptvalue = "",
                      maybevalue = "",
                      declainvalue = "";
                  SendPushNotificationService().sendPushNotifications(
                      playerMailList![i].FCMTokenID ?? "",
                      (selectSwithValue == false
                          ? "Event"
                          : "Game") +
                          " Notification",
                      "The " +
                          (selectSwithValue == false
                              ? ("Event " +
                              gameNameController!.text +
                              " is scheduled by " +
                              userName + " for the team " + teamName + ", on " +
                              (dateformat == "US"
                                  ? DateFormat("MM/dd/yyyy").format(
                                  repeatvalue ==
                                      MyStrings.doesNotRepeat
                                      ? dateTime
                                      : days[count])
                                  : dateformat == "CA"
                                  ? DateFormat("yyyy/MM/dd").format(
                                  repeatvalue ==
                                      MyStrings.doesNotRepeat
                                      ? dateTime
                                      : days[count])
                                  : DateFormat("dd/MM/yyyy").format(
                                  repeatvalue ==
                                      MyStrings.doesNotRepeat
                                      ? dateTime
                                      : days[count])) + " " +
                              (timeSwitchValue
                                  ? "TBD"
                                  : DateFormat("h:mma")
                                  .format(time)) +
                              " at " +
                              locationDetailsController!.text +
                              ".")
                              : ("Game " +
                              gameNameController!.text +
                              " is scheduled by " + userName +
                              " for the team " + teamName +
                              ", on " + (dateformat == "US"
                              ? DateFormat("MM/dd/yyyy").format(
                              repeatvalue ==
                                  MyStrings.doesNotRepeat
                                  ? dateTime
                                  : days[count])
                              : dateformat == "CA"
                              ? DateFormat("yyyy/MM/dd").format(
                              repeatvalue ==
                                  MyStrings.doesNotRepeat
                                  ? dateTime
                                  : days[count])
                              : DateFormat("dd/MM/yyyy").format(
                              repeatvalue ==
                                  MyStrings.doesNotRepeat
                                  ? dateTime
                                  : days[count])) +
                              " " +
                              (timeSwitchValue
                                  ? "TBD"
                                  : DateFormat("h:mma")
                                  .format(time)) +
                              " at " +
                              locationDetailsController!.text +
                              ".")
                          ));

                  await DynamicLinksService()
                      .createDynamicLink("splash_Screen?userid=" +
                      playerMailList[i].userIDNo.toString() +
                      "&refer=" +
                      gameResponse.result![a].eventId.toString() +
                      "&status=2" + "&eventname=" +
                      gameNameController!.text + "&teamname=" +
                      teamName + "&type=" +
                      (selectSwithValue == false
                          ? "event"
                          : "game") + "&fcm=" + (userFcm != null ? userFcm! : "") +
                      "&name=" + userName + "&mail=" + playerMailList[i].email! +
                      "&toMail=" + userEmail! + "&toID=" + userID + "&userName=" +
                      playerMailList[i].name! + "&location=" +
                      locationDetailsController!.text )
                      .then((acceptvalue) async {
                    await DynamicLinksService()
                        .createDynamicLink("splash_Screen?userid=" +
                        playerMailList[i].userIDNo.toString() +
                        "&refer=" +
                        gameResponse.result![a].eventId.toString() +
                        "&status=3" + "&eventname=" +
                        gameNameController!.text + "&teamname=" +
                        teamName + "&type=" +
                        (selectSwithValue == false
                            ? "event"
                            : "game") + "&fcm=" +
                        (userFcm != null ? userFcm! : "") + "&name=" + userName +
                        "&mail=" + playerMailList[i].email! + "&toMail=" +
                        userEmail! +
                        "&toID=" + userID + "&userName=" + playerMailList[i].name!)
                        .then((declainvalue) async {
                      await DynamicLinksService()
                          .createDynamicLink("splash_Screen?userid=" +
                          playerMailList[i].userIDNo.toString() +
                          "&refer=" +
                          gameResponse.result![a].eventId.toString() +
                          "&status=4" + "&eventname=" +
                          gameNameController!.text + "&teamname=" +
                          teamName + "&type=" +
                          (selectSwithValue == false
                              ? "event"
                              : "game") + "&fcm=" +
                          (userFcm != null ? userFcm! : "") + "&name=" + userName +
                          "&mail=" + playerMailList[i].email! + "&toMail=" +
                          userEmail! +
                          "&toID=" + userID + "&userName=" +
                          playerMailList[i].name!)
                          .then((maybevalue) {
                        EmailService().createEventNotification(
                            "",
                            "",
                            Constants.reminder,
                            int.parse(userID),
                            playerMailList[i].userIDNo!,
                            int.parse(gameResponse.result![a].eventId.toString()),
                            "The " +
                                (selectSwithValue == false
                                    ? ("Event " +
                                    gameNameController!.text +
                                    " is scheduled by " + userName +
                                    " for the team " + teamName + ", on " +
                                    (dateformat == "US"
                                        ? DateFormat("MM/dd/yyyy").format(
                                        repeatvalue ==
                                            MyStrings.doesNotRepeat
                                            ? dateTime
                                            : days[count])
                                        : dateformat == "CA"
                                        ? DateFormat("yyyy/MM/dd").format(
                                        repeatvalue ==
                                            MyStrings.doesNotRepeat
                                            ? dateTime
                                            : days[count])
                                        : DateFormat("dd/MM/yyyy").format(
                                        repeatvalue ==
                                            MyStrings.doesNotRepeat
                                            ? dateTime
                                            : days[count])) + " " +
                                    (timeSwitchValue
                                        ? "TBD"
                                        : DateFormat("h:mma")
                                        .format(time)) +
                                    " at " +
                                    locationDetailsController!.text +
                                    ".")
                                    : ("Game " +
                                    gameNameController!.text +
                                    " is scheduled by " + userName +
                                    " for the team " + teamName + ", on " +
                                    (dateformat == "US"
                                        ? DateFormat("MM/dd/yyyy").format(
                                        repeatvalue ==
                                            MyStrings.doesNotRepeat
                                            ? dateTime
                                            : days[count])
                                        : dateformat == "CA"
                                        ? DateFormat("yyyy/MM/dd").format(
                                        repeatvalue ==
                                            MyStrings.doesNotRepeat
                                            ? dateTime
                                            : days[count])
                                        : DateFormat("dd/MM/yyyy").format(
                                        repeatvalue ==
                                            MyStrings.doesNotRepeat
                                            ? dateTime
                                            : days[count])) + " " +
                                    (timeSwitchValue
                                        ? "TBD"
                                        : DateFormat("h:mma")
                                        .format(time)) +
                                    " at " +
                                    locationDetailsController!.text +
                                    ".")),
                            "",
                            "",
                            "",
                            "",
                            "",
                            "",
                            "",
                            "",
                            "",
                            "",
                            "",
                            "",
                            "",
                            "",noteSwitchValue);


                        playerEventNotification(
                            "" +
                                (selectSwithValue == false
                                    ? "New Event"
                                    : "New Game") +
                                " Scheduled - " +
                                gameNameController!.text,
                            gameNameController!.text,
                            Constants.gameOrEventRequest,
                            int.parse(gameResponse.result![a].eventId.toString()),
                            "The " +
                                (selectSwithValue == false
                                    ? ("Event " +
                                    gameNameController!.text +
                                    " is scheduled by " + userName +
                                    " for the team " + teamName + ", on " +
                                    (dateformat == "US"
                                        ? DateFormat("MM/dd/yyyy").format(
                                        repeatvalue ==
                                            MyStrings.doesNotRepeat
                                            ? dateTime
                                            : days[count])
                                        : dateformat == "CA"
                                        ? DateFormat("yyyy/MM/dd").format(
                                        repeatvalue ==
                                            MyStrings.doesNotRepeat
                                            ? dateTime
                                            : days[count])
                                        : DateFormat("dd/MM/yyyy").format(
                                        repeatvalue ==
                                            MyStrings.doesNotRepeat
                                            ? dateTime
                                            : days[count])) + " " +
                                    (timeSwitchValue
                                        ? "TBD"
                                        : DateFormat("h:mma")
                                        .format(time)) +
                                    " at " +
                                    locationDetailsController!.text +
                                    ".")
                                    : ("Game " +
                                    gameNameController!.text +
                                    " is scheduled by " + userName +
                                    " for the team " + teamName + ", on " +
                                    (dateformat == "US"
                                        ? DateFormat("MM/dd/yyyy").format(
                                        repeatvalue ==
                                            MyStrings.doesNotRepeat
                                            ? dateTime
                                            : days[count])
                                        : dateformat == "CA"
                                        ? DateFormat("yyyy/MM/dd").format(
                                        repeatvalue ==
                                            MyStrings.doesNotRepeat
                                            ? dateTime
                                            : days[count])
                                        : DateFormat("dd/MM/yyyy").format(
                                        repeatvalue ==
                                            MyStrings.doesNotRepeat
                                            ? dateTime
                                            : days[count])) + " " +
                                    (timeSwitchValue
                                        ? "TBD"
                                        : DateFormat("h:mma")
                                        .format(time)) +
                                    " at " +
                                    locationDetailsController!.text +
                                    "."))
                            ,
                            playerMailList[i].userIDNo!,
                            playerMailList[i].email!,
                            noteSwitchValue,
                            playerMailList[i].name!,
                            (selectSwithValue == false
                                ? "event, " + gameNameController!
                                .text + " has been Scheduled by " + userName +
                                " for the team, " + teamName + "."
                                : "game, " + gameNameController!.text +
                                " has been Scheduled by " + userName +
                                " for the team, " + teamName + "."),
                            acceptvalue,
                            maybevalue,
                            declainvalue,
                            locationDetailsController!.text,
                            (dateformat == "US"
                                ? DateFormat("MM/dd/yyyy").format(
                                repeatvalue == MyStrings.doesNotRepeat
                                    ? dateTime
                                    : days[count])
                                : dateformat == "CA"
                                ? DateFormat("yyyy/MM/dd").format(
                                repeatvalue == MyStrings.doesNotRepeat
                                    ? dateTime
                                    : days[count])
                                : DateFormat("dd/MM/yyyy").format(
                                repeatvalue == MyStrings.doesNotRepeat
                                    ? dateTime
                                    : days[count])),
                            (timeSwitchValue
                                ? "TBD"
                                : DateFormat("h:mma")
                                .format(time)),
                            signIn!
                        );
                      });
                    });
                  });
                }
              }
              if (ownerMailList.isNotEmpty) {
                List<String> message = [];
                for (int i = 0; i < ownerMailList.length; i++) {
                  String acceptvalue = "",
                      maybevalue = "",
                      declainvalue = "";
                  SendPushNotificationService().sendPushNotifications(
                      ownerMailList[i].FCMTokenID ?? "",
                      (selectSwithValue == false
                          ? "Event"
                          : "Game") +
                          " Notification",
                      "The " +
                          (selectSwithValue == false
                              ? ("Event " +
                              gameNameController!.text +
                              " is scheduled by " +
                              userName + " for the team " + teamName + ", on " +
                              (dateformat == "US"
                                  ? DateFormat("MM/dd/yyyy").format(
                                  repeatvalue ==
                                      MyStrings.doesNotRepeat
                                      ? dateTime
                                      : days[count])
                                  : dateformat == "CA"
                                  ? DateFormat("yyyy/MM/dd").format(
                                  repeatvalue ==
                                      MyStrings.doesNotRepeat
                                      ? dateTime
                                      : days[count])
                                  : DateFormat("dd/MM/yyyy").format(
                                  repeatvalue ==
                                      MyStrings.doesNotRepeat
                                      ? dateTime
                                      : days[count])) + " " +
                              (timeSwitchValue
                                  ? "TBD"
                                  : DateFormat("h:mma")
                                  .format(time)) +
                              " at " +
                              locationDetailsController!.text +
                              ".")
                              : ("Game " +
                              gameNameController!.text +
                              " is scheduled by " + userName +
                              " for the team " + teamName +
                              ", on " + (dateformat == "US"
                              ? DateFormat("MM/dd/yyyy").format(
                              repeatvalue ==
                                  MyStrings.doesNotRepeat
                                  ? dateTime
                                  : days[count])
                              : dateformat == "CA"
                              ? DateFormat("yyyy/MM/dd").format(
                              repeatvalue ==
                                  MyStrings.doesNotRepeat
                                  ? dateTime
                                  : days[count])
                              : DateFormat("dd/MM/yyyy").format(
                              repeatvalue ==
                                  MyStrings.doesNotRepeat
                                  ? dateTime
                                  : days[count])) +
                              " " +
                              (timeSwitchValue
                                  ? "TBD"
                                  : DateFormat("h:mma")
                                  .format(time)) +
                              " at " +
                              locationDetailsController!.text +
                              ".")
                          ));

                  await DynamicLinksService()
                      .createDynamicLink("splash_Screen?userid=" +
                      ownerMailList[i].userIDNo.toString() +
                      "&refer=" +
                      gameResponse.result![a].eventId.toString() +
                      "&status=2" + "&eventname=" +
                      gameNameController!.text + "&teamname=" +
                      teamName + "&type=" +
                      (selectSwithValue == false
                          ? "event"
                          : "game") + "&fcm=" + (userFcm != null ? userFcm! : "") +
                      "&name=" + userName + "&mail=" + ownerMailList[i].email! +
                      "&toMail=" + userEmail! + "&toID=" + userID + "&userName=" +
                      ownerMailList[i].name! + "&location=" +
                      locationDetailsController!.text )
                      .then((acceptvalue) async {
                    await DynamicLinksService()
                        .createDynamicLink("splash_Screen?userid=" +
                        ownerMailList[i].userIDNo.toString() +
                        "&refer=" +
                        gameResponse.result![a].eventId.toString() +
                        "&status=3" + "&eventname=" +
                        gameNameController!.text + "&teamname=" +
                        teamName + "&type=" +
                        (selectSwithValue == false
                            ? "event"
                            : "game") + "&fcm=" +
                        (userFcm != null ? userFcm! : "") + "&name=" + userName +
                        "&mail=" + ownerMailList[i].email! + "&toMail=" +
                        userEmail! +
                        "&toID=" + userID + "&userName=" + ownerMailList[i].name!)
                        .then((declainvalue) async {
                      await DynamicLinksService()
                          .createDynamicLink("splash_Screen?userid=" +
                          ownerMailList[i].userIDNo.toString() +
                          "&refer=" +
                          gameResponse.result![a].eventId.toString() +
                          "&status=4" + "&eventname=" +
                          gameNameController!.text + "&teamname=" +
                          teamName + "&type=" +
                          (selectSwithValue == false
                              ? "event"
                              : "game") + "&fcm=" +
                          (userFcm != null ? userFcm! : "") + "&name=" + userName +
                          "&mail=" + ownerMailList[i].email! + "&toMail=" +
                          userEmail! +
                          "&toID=" + userID + "&userName=" +
                          ownerMailList[i].name!)
                          .then((maybevalue) async {
                        EmailService().createEventNotification(
                            "",
                            "",
                            Constants.reminder,
                            int.parse(userID),
                            ownerMailList[i].userIDNo!,
                            int.parse(gameResponse.result![a].eventId.toString()),
                            "The " +
                                (selectSwithValue == false
                                    ? ("Event " +
                                    gameNameController!.text +
                                    " is scheduled by " + userName +
                                    " for the team " + teamName + ", on " +
                                    (dateformat == "US"
                                        ? DateFormat("MM/dd/yyyy").format(
                                        repeatvalue ==
                                            MyStrings.doesNotRepeat
                                            ? dateTime
                                            : days[count])
                                        : dateformat == "CA"
                                        ? DateFormat("yyyy/MM/dd").format(
                                        repeatvalue ==
                                            MyStrings.doesNotRepeat
                                            ? dateTime
                                            : days[count])
                                        : DateFormat("dd/MM/yyyy").format(
                                        repeatvalue ==
                                            MyStrings.doesNotRepeat
                                            ? dateTime
                                            : days[count])) + " " +
                                    (timeSwitchValue
                                        ? "TBD"
                                        : DateFormat("h:mma")
                                        .format(time)) +
                                    " at " +
                                    locationDetailsController!.text +
                                    ".")
                                    : ("Game " +
                                    gameNameController!.text +
                                    " is scheduled by " + userName +
                                    " for the team " + teamName + ", on " +
                                    (dateformat == "US"
                                        ? DateFormat("MM/dd/yyyy").format(
                                        repeatvalue ==
                                            MyStrings.doesNotRepeat
                                            ? dateTime
                                            : days[count])
                                        : dateformat == "CA"
                                        ? DateFormat("yyyy/MM/dd").format(
                                        repeatvalue ==
                                            MyStrings.doesNotRepeat
                                            ? dateTime
                                            : days[count])
                                        : DateFormat("dd/MM/yyyy").format(
                                        repeatvalue ==
                                            MyStrings.doesNotRepeat
                                            ? dateTime
                                            : days[count])) + " " +
                                    (timeSwitchValue
                                        ? "TBD"
                                        : DateFormat("h:mma")
                                        .format(time)) +
                                    " at " +
                                    locationDetailsController!.text +
                                    ".")),
                            "",
                            "",
                            "",
                            "",
                            "",
                            "",
                            "",
                            "",
                            "",
                            "",
                            "",
                            "",
                            "",
                            "",noteSwitchValue);


                        await EmailService().createEventNotification(
                            "" +
                                (selectSwithValue == false
                                    ? "New Event"
                                    : "New Game") +
                                " Scheduled - " +
                                gameNameController!.text,
                            gameNameController!.text,
                            Constants.gameOrEventRequest,
                            int.parse(userID),
                            ownerMailList[i].userIDNo!,
                            int.parse(gameResponse.result![a].eventId.toString()),
                            "The " +
                                (selectSwithValue == false
                                    ? ("Event " +
                                    gameNameController!.text +
                                    " is scheduled by " + userName +
                                    " for the team " + teamName + ", on " +
                                    (dateformat == "US"
                                        ? DateFormat("MM/dd/yyyy").format(
                                        repeatvalue ==
                                            MyStrings.doesNotRepeat
                                            ? dateTime
                                            : days[count])
                                        : dateformat == "CA"
                                        ? DateFormat("yyyy/MM/dd").format(
                                        repeatvalue ==
                                            MyStrings.doesNotRepeat
                                            ? dateTime
                                            : days[count])
                                        : DateFormat("dd/MM/yyyy").format(
                                        repeatvalue ==
                                            MyStrings.doesNotRepeat
                                            ? dateTime
                                            : days[count])) + " " +
                                    (timeSwitchValue
                                        ? "TBD"
                                        : DateFormat("h:mma")
                                        .format(time)) +
                                    " at " +
                                    locationDetailsController!.text +
                                    ".")
                                    : ("Game " +
                                    gameNameController!.text +
                                    " is scheduled by " + userName +
                                    " for the team " + teamName + ", on " +
                                    (dateformat == "US"
                                        ? DateFormat("MM/dd/yyyy").format(
                                        repeatvalue ==
                                            MyStrings.doesNotRepeat
                                            ? dateTime
                                            : days[count])
                                        : dateformat == "CA"
                                        ? DateFormat("yyyy/MM/dd").format(
                                        repeatvalue ==
                                            MyStrings.doesNotRepeat
                                            ? dateTime
                                            : days[count])
                                        : DateFormat("dd/MM/yyyy").format(
                                        repeatvalue ==
                                            MyStrings.doesNotRepeat
                                            ? dateTime
                                            : days[count])) + " " +
                                    (timeSwitchValue
                                        ? "TBD"
                                        : DateFormat("h:mma")
                                        .format(time)) +
                                    " at " +
                                    locationDetailsController!.text +
                                    "."))
                            ,
                            ownerMailList[i].email!,
                            ownerMailList[i].name!,
                            (selectSwithValue == false
                                ? "event, " + gameNameController!
                                .text + " has been Scheduled by " + userName +
                                " for the team, " + teamName + "."
                                : "game, " + gameNameController!.text +
                                " has been Scheduled by " + userName +
                                " for the team, " + teamName + "."),
                            acceptvalue,
                            maybevalue,
                            declainvalue,
                            locationDetailsController!.text,
                            (dateformat == "US"
                                ? DateFormat("MM/dd/yyyy").format(
                                repeatvalue == MyStrings.doesNotRepeat
                                    ? dateTime
                                    : days[count])
                                : dateformat == "CA"
                                ? DateFormat("yyyy/MM/dd").format(
                                repeatvalue == MyStrings.doesNotRepeat
                                    ? dateTime
                                    : days[count])
                                : DateFormat("dd/MM/yyyy").format(
                                repeatvalue == MyStrings.doesNotRepeat
                                    ? dateTime
                                    : days[count])),
                            (timeSwitchValue
                                ? "TBD"
                                : DateFormat("h:mma")
                                .format(time)),
                            signIn!,
                            "",
                            "",
                            "",
                            "",noteSwitchValue

                        );
                      });
                    });
                  });
                }
              }
              if (nonPlayerMailList.isNotEmpty) {
                List<String> message = [];
                for (int i = 0; i < nonPlayerMailList.length; i++) {
                  String acceptvalue = "",
                      maybevalue = "",
                      declainvalue = "";
                  SendPushNotificationService().sendPushNotifications(
                      nonPlayerMailList[i].FCMTokenID ?? "",
                      (selectSwithValue == false
                          ? "Event"
                          : "Game") +
                          " Notification",
                      "The " +
                          (selectSwithValue == false
                              ? ("Event " +
                              gameNameController!.text +
                              " is scheduled by " +
                              userName + " for the team " + teamName + ", on " +
                              (dateformat == "US"
                                  ? DateFormat("MM/dd/yyyy").format(
                                  repeatvalue ==
                                      MyStrings.doesNotRepeat
                                      ? dateTime
                                      : days[count])
                                  : dateformat == "CA"
                                  ? DateFormat("yyyy/MM/dd").format(
                                  repeatvalue ==
                                      MyStrings.doesNotRepeat
                                      ? dateTime
                                      : days[count])
                                  : DateFormat("dd/MM/yyyy").format(
                                  repeatvalue ==
                                      MyStrings.doesNotRepeat
                                      ? dateTime
                                      : days[count])) + " " +
                              (timeSwitchValue
                                  ? "TBD"
                                  : DateFormat("h:mma")
                                  .format(time)) +
                              " at " +
                              locationDetailsController!.text +
                              ".")
                              : ("Game " +
                              gameNameController!.text +
                              " is scheduled by " + userName +
                              " for the team " + teamName +
                              ", on " + (dateformat == "US"
                              ? DateFormat("MM/dd/yyyy").format(
                              repeatvalue ==
                                  MyStrings.doesNotRepeat
                                  ? dateTime
                                  : days[count])
                              : dateformat == "CA"
                              ? DateFormat("yyyy/MM/dd").format(
                              repeatvalue ==
                                  MyStrings.doesNotRepeat
                                  ? dateTime
                                  : days[count])
                              : DateFormat("dd/MM/yyyy").format(
                              repeatvalue ==
                                  MyStrings.doesNotRepeat
                                  ? dateTime
                                  : days[count])) +
                              " " +
                              (timeSwitchValue
                                  ? "TBD"
                                  : DateFormat("h:mma")
                                  .format(time)) +
                              " at " +
                              locationDetailsController!.text +
                              ".")
                          ));

                  await DynamicLinksService()
                      .createDynamicLink("splash_Screen?userid=" +
                      nonPlayerMailList[i].userIDNo.toString() +
                      "&refer=" +
                      gameResponse.result![a].eventId.toString() +
                      "&status=2" + "&eventname=" +
                      gameNameController!.text + "&teamname=" +
                      teamName + "&type=" +
                      (selectSwithValue == false
                          ? "event"
                          : "game") + "&fcm=" + (userFcm != null ? userFcm! : "") +
                      "&name=" + userName + "&mail=" +
                      nonPlayerMailList[i].email! +
                      "&toMail=" + userEmail! + "&toID=" + userID + "&userName=" +
                      nonPlayerMailList[i].name! + "&location=" +
                      locationDetailsController!.text )
                      .then((acceptvalue) async {
                    await DynamicLinksService()
                        .createDynamicLink("splash_Screen?userid=" +
                        nonPlayerMailList[i].userIDNo.toString() +
                        "&refer=" +
                        gameResponse.result![a].eventId.toString() +
                        "&status=3" + "&eventname=" +
                        gameNameController!.text + "&teamname=" +
                        teamName + "&type=" +
                        (selectSwithValue == false
                            ? "event"
                            : "game") + "&fcm=" +
                        (userFcm != null ? userFcm! : "") + "&name=" + userName +
                        "&mail=" + nonPlayerMailList[i].email! + "&toMail=" +
                        userEmail! +
                        "&toID=" + userID + "&userName=" +
                        nonPlayerMailList[i].name!)
                        .then((declainvalue) async {
                      await DynamicLinksService()
                          .createDynamicLink("splash_Screen?userid=" +
                          nonPlayerMailList[i].userIDNo.toString() +
                          "&refer=" +
                          gameResponse.result![a].eventId.toString() +
                          "&status=4" + "&eventname=" +
                          gameNameController!.text + "&teamname=" +
                          teamName + "&type=" +
                          (selectSwithValue == false
                              ? "event"
                              : "game") + "&fcm=" +
                          (userFcm != null ? userFcm! : "") + "&name=" + userName +
                          "&mail=" + nonPlayerMailList[i].email! + "&toMail=" +
                          userEmail! +
                          "&toID=" + userID + "&userName=" +
                          nonPlayerMailList[i].name!)
                          .then((maybevalue) async {
                        EmailService().createEventNotification(
                            "",
                            "",
                            Constants.reminder,
                            int.parse(userID),
                            nonPlayerMailList[i].userIDNo!,
                            int.parse(gameResponse.result![a].eventId.toString()),
                            "The " +
                                (selectSwithValue == false
                                    ? ("Event " +
                                    gameNameController!.text +
                                    " is scheduled by " + userName +
                                    " for the team " + teamName + ", on " +
                                    (dateformat == "US"
                                        ? DateFormat("MM/dd/yyyy").format(
                                        repeatvalue ==
                                            MyStrings.doesNotRepeat
                                            ? dateTime
                                            : days[count])
                                        : dateformat == "CA"
                                        ? DateFormat("yyyy/MM/dd").format(
                                        repeatvalue ==
                                            MyStrings.doesNotRepeat
                                            ? dateTime
                                            : days[count])
                                        : DateFormat("dd/MM/yyyy").format(
                                        repeatvalue ==
                                            MyStrings.doesNotRepeat
                                            ? dateTime
                                            : days[count])) + " " +
                                    (timeSwitchValue
                                        ? "TBD"
                                        : DateFormat("h:mma")
                                        .format(time)) +
                                    " at " +
                                    locationDetailsController!.text +
                                    ".")
                                    : ("Game " +
                                    gameNameController!.text +
                                    " is scheduled by " + userName +
                                    " for the team " + teamName + ", on " +
                                    (dateformat == "US"
                                        ? DateFormat("MM/dd/yyyy").format(
                                        repeatvalue ==
                                            MyStrings.doesNotRepeat
                                            ? dateTime
                                            : days[count])
                                        : dateformat == "CA"
                                        ? DateFormat("yyyy/MM/dd").format(
                                        repeatvalue ==
                                            MyStrings.doesNotRepeat
                                            ? dateTime
                                            : days[count])
                                        : DateFormat("dd/MM/yyyy").format(
                                        repeatvalue ==
                                            MyStrings.doesNotRepeat
                                            ? dateTime
                                            : days[count])) + " " +
                                    (timeSwitchValue
                                        ? "TBD"
                                        : DateFormat("h:mma")
                                        .format(time)) +
                                    " at " +
                                    locationDetailsController!.text +
                                    ".")),
                            "",
                            "",
                            "",
                            "",
                            "",
                            "",
                            "",
                            "",
                            "",
                            "",
                            "",
                            "",
                            "",
                            "",noteSwitchValue);


                        await EmailService().createEventNotification(
                            "" +
                                (selectSwithValue == false
                                    ? "New Event"
                                    : "New Game") +
                                " Scheduled - " +
                                gameNameController!.text,
                            gameNameController!.text,
                            Constants.gameOrEventRequest,
                            int.parse(userID),
                            nonPlayerMailList[i].userIDNo!,
                            int.parse(gameResponse.result![a].eventId.toString()),
                            "The " +
                                (selectSwithValue == false
                                    ? ("Event " +
                                    gameNameController!.text +
                                    " is scheduled by " + userName +
                                    " for the team " + teamName + ", on " +
                                    (dateformat == "US"
                                        ? DateFormat("MM/dd/yyyy").format(
                                        repeatvalue ==
                                            MyStrings.doesNotRepeat
                                            ? dateTime
                                            : days[count])
                                        : dateformat == "CA"
                                        ? DateFormat("yyyy/MM/dd").format(
                                        repeatvalue ==
                                            MyStrings.doesNotRepeat
                                            ? dateTime
                                            : days[count])
                                        : DateFormat("dd/MM/yyyy").format(
                                        repeatvalue ==
                                            MyStrings.doesNotRepeat
                                            ? dateTime
                                            : days[count])) + " " +
                                    (timeSwitchValue
                                        ? "TBD"
                                        : DateFormat("h:mma")
                                        .format(time)) +
                                    " at " +
                                    locationDetailsController!.text +
                                    ".")
                                    : ("Game " +
                                    gameNameController!.text +
                                    " is scheduled by " + userName +
                                    " for the team " + teamName + ", on " +
                                    (dateformat == "US"
                                        ? DateFormat("MM/dd/yyyy").format(
                                        repeatvalue ==
                                            MyStrings.doesNotRepeat
                                            ? dateTime
                                            : days[count])
                                        : dateformat == "CA"
                                        ? DateFormat("yyyy/MM/dd").format(
                                        repeatvalue ==
                                            MyStrings.doesNotRepeat
                                            ? dateTime
                                            : days[count])
                                        : DateFormat("dd/MM/yyyy").format(
                                        repeatvalue ==
                                            MyStrings.doesNotRepeat
                                            ? dateTime
                                            : days[count])) + " " +
                                    (timeSwitchValue
                                        ? "TBD"
                                        : DateFormat("h:mma")
                                        .format(time)) +
                                    " at " +
                                    locationDetailsController!.text +
                                    "."))
                            ,
                            nonPlayerMailList[i].email!,
                            nonPlayerMailList[i].name!,
                            (selectSwithValue == false
                                ? "event, " + gameNameController!
                                .text + " has been Scheduled by " + userName +
                                " for the team, " + teamName + "."
                                : "game, " + gameNameController!.text +
                                " has been Scheduled by " + userName +
                                " for the team, " + teamName + "."),
                            acceptvalue,
                            maybevalue,
                            declainvalue,
                            locationDetailsController!.text,
                            (dateformat == "US"
                                ? DateFormat("MM/dd/yyyy").format(
                                repeatvalue == MyStrings.doesNotRepeat
                                    ? dateTime
                                    : days[count])
                                : dateformat == "CA"
                                ? DateFormat("yyyy/MM/dd").format(
                                repeatvalue == MyStrings.doesNotRepeat
                                    ? dateTime
                                    : days[count])
                                : DateFormat("dd/MM/yyyy").format(
                                repeatvalue == MyStrings.doesNotRepeat
                                    ? dateTime
                                    : days[count])),
                            (timeSwitchValue
                                ? "TBD"
                                : DateFormat("h:mma")
                                .format(time)),
                            signIn!,
                            "",
                            "",
                            "",
                            "",noteSwitchValue

                        );
                      });
                    });
                  });
                }
              }
            } else {
              if (ownerMailList.isNotEmpty) {
                for (int j = 0; j < ownerMailList.length; j++) {
                  SendPushNotificationService().sendPushNotifications(
                      ownerMailList[j].FCMTokenID ?? "",
                      (selectSwithValue == false
                          ? "Event"
                          : "Game") +
                          " Notification",
                      "The " +
                          (selectSwithValue == false
                              ? ("Event " +
                              gameNameController!.text +
                              " is scheduled by " + userName +
                              " for the team " + teamName + ", on " +
                              (dateformat == "US"
                                  ? DateFormat("MM/dd/yyyy").format(
                                  repeatvalue ==
                                      MyStrings.doesNotRepeat
                                      ? dateTime
                                      : days[count])
                                  : dateformat == "CA"
                                  ? DateFormat("yyyy/MM/dd").format(
                                  repeatvalue ==
                                      MyStrings.doesNotRepeat
                                      ? dateTime
                                      : days[count])
                                  : DateFormat("dd/MM/yyyy").format(
                                  repeatvalue ==
                                      MyStrings.doesNotRepeat
                                      ? dateTime
                                      : days[count])) +
                              " " + (timeSwitchValue
                              ? "TBD"
                              : DateFormat("h:mma")
                              .format(time)) + " at " +
                              locationDetailsController!.text +
                              ".")
                              : ("Game " +
                              gameNameController!.text +
                              " (Game Number " + gameResponse.result![a].eventId.toString() +
                              ") is scheduled by " + userName +
                              " for the team " + teamName + ", on " +
                              (dateformat == "US"
                                  ? DateFormat("MM/dd/yyyy").format(
                                  repeatvalue ==
                                      MyStrings.doesNotRepeat
                                      ? dateTime
                                      : days[count])
                                  : dateformat == "CA"
                                  ? DateFormat("yyyy/MM/dd").format(
                                  repeatvalue ==
                                      MyStrings.doesNotRepeat
                                      ? dateTime
                                      : days[count])
                                  : DateFormat("dd/MM/yyyy").format(
                                  repeatvalue ==
                                      MyStrings.doesNotRepeat
                                      ? dateTime
                                      : days[count])) + " " +
                              (timeSwitchValue
                                  ? "TBD"
                                  : DateFormat("h:mma")
                                  .format(time)) +
                              " at " +
                              locationDetailsController!.text +
                              "."))
                  );
                  await EmailService().createEventNotification(
                      "",
                      "",
                      Constants.reminder,
                      int.parse(userID),
                      ownerMailList[j].userIDNo!,
                      int.parse(gameResponse.result![a].eventId.toString()),
                      "The " +
                          (selectSwithValue == false
                              ? ("Event " +
                              gameNameController!.text +
                              " is scheduled by " + userName + " for the team " +
                              teamName + ", on " + (dateformat == "US"
                              ? DateFormat("MM/dd/yyyy").format(
                              repeatvalue ==
                                  MyStrings.doesNotRepeat
                                  ? dateTime
                                  : days[count])
                              : dateformat == "CA"
                              ? DateFormat("yyyy/MM/dd").format(
                              repeatvalue ==
                                  MyStrings.doesNotRepeat
                                  ? dateTime
                                  : days[count])
                              : DateFormat("dd/MM/yyyy").format(
                              repeatvalue ==
                                  MyStrings.doesNotRepeat
                                  ? dateTime
                                  : days[count])) +
                              " " +
                              (timeSwitchValue
                                  ? "TBD"
                                  : DateFormat("h:mma")
                                  .format(time)) + " at " +
                              locationDetailsController!.text +
                              ".")
                              : ("Game " +
                              gameNameController!.text +
                              " (Game Number " + gameResponse.result![a].eventId.toString() +
                              ") is scheduled by " + userName +
                              " for the team " + teamName + ", on " +
                              (dateformat == "US"
                                  ? DateFormat("MM/dd/yyyy").format(
                                  repeatvalue ==
                                      MyStrings.doesNotRepeat
                                      ? dateTime
                                      : days[count])
                                  : dateformat == "CA"
                                  ? DateFormat("yyyy/MM/dd").format(
                                  repeatvalue ==
                                      MyStrings.doesNotRepeat
                                      ? dateTime
                                      : days[count])
                                  : DateFormat("dd/MM/yyyy").format(
                                  repeatvalue ==
                                      MyStrings.doesNotRepeat
                                      ? dateTime
                                      : days[count])) +
                              " " + (timeSwitchValue
                              ? "TBD"
                              : DateFormat("h:mma")
                              .format(time)) + " at " +
                              locationDetailsController!.text +
                              ".")),
                      "",
                      "",
                      "",
                      "",
                      "",
                      "",
                      "",
                      "",
                      "",
                      "",
                      "",
                      "",
                      "",
                      "",noteSwitchValue);

                  if (selectSwithValue == true) {
                    await EmailService().createEventNotification(
                        "" +
                            (selectSwithValue == false
                                ? "New Event"
                                : "New Game") +
                            " Scheduled - " +
                            gameNameController!.text,
                        gameNameController!.text,
                        Constants.createGameOrEvent,
                        int.parse(userID),
                        ownerMailList[j].userIDNo!,
                        int.parse(gameResponse.result![a].eventId.toString()),
                        "The " +
                            (("Game " +
                                gameNameController!.text +
                                " (Game Number " +
                                gameResponse.result![a].eventId.toString() +
                                ") is scheduled by " + userName +
                                " for the team " + teamName + ", on " +
                                (dateformat == "US"
                                    ? DateFormat("MM/dd/yyyy").format(
                                    repeatvalue ==
                                        MyStrings.doesNotRepeat
                                        ? dateTime
                                        : days[count])
                                    : dateformat == "CA"
                                    ? DateFormat("yyyy/MM/dd").format(
                                    repeatvalue ==
                                        MyStrings.doesNotRepeat
                                        ? dateTime
                                        : days[count])
                                    : DateFormat("dd/MM/yyyy").format(
                                    repeatvalue ==
                                        MyStrings.doesNotRepeat
                                        ? dateTime
                                        : days[count])) +
                                " " + (timeSwitchValue
                                ? "TBD"
                                : DateFormat("h:mma")
                                .format(time)) + " at " +
                                locationDetailsController!.text +
                                "."))
                        ,
                        ownerMailList[j].email!,
                        ownerMailList[j].name!,
                        (selectSwithValue == false
                            ? "event, " +
                            gameNameController!.text +
                            " has been Scheduled by " + userName +
                            " for the team, " + teamName + "."
                            : "game, " +
                            gameNameController!.text +
                            " has been Scheduled by " + userName +
                            " for the team, " + teamName + "."),
                        "",
                        "",
                        "",
                        locationDetailsController!.text,
                        (dateformat == "US"
                            ? DateFormat("MM/dd/yyyy").format(
                            repeatvalue ==
                                MyStrings.doesNotRepeat ? dateTime : days[count])
                            : dateformat == "CA"
                            ? DateFormat("yyyy/MM/dd").format(
                            repeatvalue ==
                                MyStrings.doesNotRepeat ? dateTime : days[count])
                            : DateFormat("dd/MM/yyyy").format(
                            repeatvalue ==
                                MyStrings.doesNotRepeat
                                ? dateTime
                                : days[count])),
                        timeSwitchValue
                            ? "TBD"
                            : DateFormat("h:mma")
                            .format(time),
                        signIn!,
                        gameResponse.result![a].eventId.toString(),
                        "",
                        "",
                        "",noteSwitchValue


                    );
                  } else {
                    await EmailService().createEventNotification(
                        "" +
                            (selectSwithValue == false
                                ? "New Event"
                                : "New Game") +
                            " Scheduled - " +
                            gameNameController!.text,
                        gameNameController!.text,
                        Constants.createGameOrEvent,
                        int.parse(userID),
                        ownerMailList[j].userIDNo!,
                        int.parse(gameResponse.result![a].eventId.toString()),
                        "The " +
                            ("Event " +
                                gameNameController!.text +
                                " is scheduled by " + userName +
                                " for the team " +
                                teamName + ", on " + (dateformat == "US"
                                ? DateFormat("MM/dd/yyyy").format(
                                repeatvalue ==
                                    MyStrings.doesNotRepeat
                                    ? dateTime
                                    : days[count])
                                : dateformat == "CA"
                                ? DateFormat("yyyy/MM/dd").format(
                                repeatvalue ==
                                    MyStrings.doesNotRepeat
                                    ? dateTime
                                    : days[count])
                                : DateFormat("dd/MM/yyyy").format(
                                repeatvalue ==
                                    MyStrings.doesNotRepeat
                                    ? dateTime
                                    : days[count])) + " " +
                                (timeSwitchValue
                                    ? "TBD"
                                    : DateFormat("h:mma")
                                    .format(time)) + " at " +
                                locationDetailsController!.text +
                                "."),
                        ownerMailList[j].email!,
                        ownerMailList[j].name!,
                        (selectSwithValue == false
                            ? "A new event, " +
                            gameNameController!.text +
                            " has been Scheduled by " + userName +
                            " for the team, " + teamName + "."
                            : "A new game, " +
                            gameNameController!.text +
                            " has been Scheduled by " + userName +
                            " for the team, " + teamName + "."),
                        "",
                        "",
                        "",
                        locationDetailsController!.text,
                        (dateformat == "US"
                            ? DateFormat("MM/dd/yyyy").format(
                            repeatvalue ==
                                MyStrings.doesNotRepeat ? dateTime : days[count])
                            : dateformat == "CA"
                            ? DateFormat("yyyy/MM/dd").format(
                            repeatvalue ==
                                MyStrings.doesNotRepeat ? dateTime : days[count])
                            : DateFormat("dd/MM/yyyy").format(
                            repeatvalue ==
                                MyStrings.doesNotRepeat
                                ? dateTime
                                : days[count])),
                        (timeSwitchValue
                            ? "TBD"
                            : DateFormat("h:mma")
                            .format(time)),
                        signIn!,
                        "",
                        "",
                        "",
                        "",noteSwitchValue
                    );
                  }
                }
              }
              if (nonPlayerMailList.isNotEmpty) {
                for (int j = 0; j < nonPlayerMailList.length; j++) {
                  SendPushNotificationService().sendPushNotifications(
                      nonPlayerMailList[j].FCMTokenID ?? "",
                      (selectSwithValue == false
                          ? "Event"
                          : "Game") +
                          " Notification",
                      "The " +
                          (selectSwithValue == false
                              ? ("Event " +
                              gameNameController!.text +
                              " is scheduled by " + userName +
                              " for the team " +
                              teamName + ", on " + (dateformat == "US"
                              ? DateFormat("MM/dd/yyyy").format(
                              repeatvalue ==
                                  MyStrings.doesNotRepeat
                                  ? dateTime
                                  : days[count])
                              : dateformat == "CA"
                              ? DateFormat("yyyy/MM/dd").format(
                              repeatvalue ==
                                  MyStrings.doesNotRepeat
                                  ? dateTime
                                  : days[count])
                              : DateFormat("dd/MM/yyyy").format(
                              repeatvalue ==
                                  MyStrings.doesNotRepeat
                                  ? dateTime
                                  : days[count])) +
                              " " + (timeSwitchValue
                              ? "TBD"
                              : DateFormat("h:mma")
                              .format(time)) + " at " +
                              locationDetailsController!.text +
                              ". Join with the team and show your support.")
                              : ("Game " +
                              gameNameController!.text +
                              " is scheduled by " + userName +
                              " for the team " +
                              teamName + ", on " + (dateformat == "US"
                              ? DateFormat("MM/dd/yyyy").format(
                              repeatvalue ==
                                  MyStrings.doesNotRepeat
                                  ? dateTime
                                  : days[count])
                              : dateformat == "CA"
                              ? DateFormat("yyyy/MM/dd").format(
                              repeatvalue ==
                                  MyStrings.doesNotRepeat
                                  ? dateTime
                                  : days[count])
                              : DateFormat("dd/MM/yyyy").format(
                              repeatvalue ==
                                  MyStrings.doesNotRepeat
                                  ? dateTime
                                  : days[count])) +
                              " " + (timeSwitchValue
                              ? "TBD"
                              : DateFormat("h:mma")
                              .format(time)) + " at " +
                              locationDetailsController!.text +
                              ". Join with the team and show your support.")
                          ));

                  await EmailService().createEventNotification(
                      "",
                      "",
                      Constants.reminder,
                      int.parse(userID),
                      nonPlayerMailList[j].userIDNo!,
                      int.parse(gameResponse.result![a].eventId.toString()),
                      "The " +
                          (selectSwithValue == false
                              ? ("Event " +
                              gameNameController!.text +
                              " is scheduled by " + userName +
                              " for the team " +
                              teamName + ", on " + (dateformat == "US"
                              ? DateFormat("MM/dd/yyyy").format(
                              repeatvalue ==
                                  MyStrings.doesNotRepeat
                                  ? dateTime
                                  : days[count])
                              : dateformat == "CA"
                              ? DateFormat("yyyy/MM/dd").format(
                              repeatvalue ==
                                  MyStrings.doesNotRepeat
                                  ? dateTime
                                  : days[count])
                              : DateFormat("dd/MM/yyyy").format(
                              repeatvalue ==
                                  MyStrings.doesNotRepeat
                                  ? dateTime
                                  : days[count])) +
                              " " + (timeSwitchValue
                              ? "TBD"
                              : DateFormat("h:mma")
                              .format(time)) + " at " +
                              locationDetailsController!.text +
                              ". Join with the team and show your support.")
                              : ("Game " +
                              gameNameController!.text +
                              " is scheduled by " + userName +
                              " for the team " +
                              teamName + ", on " + (dateformat == "US"
                              ? DateFormat("MM/dd/yyyy").format(
                              repeatvalue ==
                                  MyStrings.doesNotRepeat
                                  ? dateTime
                                  : days[count])
                              : dateformat == "CA"
                              ? DateFormat("yyyy/MM/dd").format(
                              repeatvalue ==
                                  MyStrings.doesNotRepeat
                                  ? dateTime
                                  : days[count])
                              : DateFormat("dd/MM/yyyy").format(
                              repeatvalue ==
                                  MyStrings.doesNotRepeat
                                  ? dateTime
                                  : days[count])) +
                              " " + (timeSwitchValue
                              ? "TBD"
                              : DateFormat("h:mma")
                              .format(time)) + " at " +
                              locationDetailsController!.text +
                              ". Join with the team and show your support.")
                          ),
                      "",
                      "",
                      "",
                      "",
                      "",
                      "",
                      "",
                      "",
                      "",
                      "",
                      "",
                      "",
                      "",
                      "",noteSwitchValue);
                  await EmailService().createEventNotification(
                      "" +
                          (selectSwithValue == false
                              ? "New Event"
                              : "New Game") +
                          " Scheduled - " +
                          gameNameController!.text,
                      gameNameController!.text,
                      Constants.gameOrEventInfo,
                      int.parse(userID),
                      nonPlayerMailList[j].userIDNo!,
                      int.parse(gameResponse.result![a].eventId.toString()),
                      "The " +
                          (selectSwithValue == false
                              ? ("Event " +
                              gameNameController!.text +
                              " is scheduled by " + userName +
                              " for the team " +
                              teamName + ", on " + (dateformat == "US"
                              ? DateFormat("MM/dd/yyyy").format(
                              repeatvalue ==
                                  MyStrings.doesNotRepeat
                                  ? dateTime
                                  : days[count])
                              : dateformat == "CA"
                              ? DateFormat("yyyy/MM/dd").format(
                              repeatvalue ==
                                  MyStrings.doesNotRepeat
                                  ? dateTime
                                  : days[count])
                              : DateFormat("dd/MM/yyyy").format(
                              repeatvalue ==
                                  MyStrings.doesNotRepeat
                                  ? dateTime
                                  : days[count])) +
                              " " + (timeSwitchValue
                              ? "TBD"
                              : DateFormat("h:mma")
                              .format(time)) + " at " +
                              locationDetailsController!.text +
                              ". Join with the team and show your support.")
                              : ("Game " +
                              gameNameController!.text +
                              " is scheduled by " + userName +
                              " for the team " +
                              teamName + ", on " + (dateformat == "US"
                              ? DateFormat("MM/dd/yyyy").format(
                              repeatvalue ==
                                  MyStrings.doesNotRepeat
                                  ? dateTime
                                  : days[count])
                              : dateformat == "CA"
                              ? DateFormat("yyyy/MM/dd").format(
                              repeatvalue ==
                                  MyStrings.doesNotRepeat
                                  ? dateTime
                                  : days[count])
                              : DateFormat("dd/MM/yyyy").format(
                              repeatvalue ==
                                  MyStrings.doesNotRepeat
                                  ? dateTime
                                  : days[count])) +
                              " " + (timeSwitchValue
                              ? "TBD"
                              : DateFormat("h:mma")
                              .format(time)) + " at " +
                              locationDetailsController!.text +
                              ". Join with the team and show your support.")
                          ),
                      nonPlayerMailList[j].email!,
                      nonPlayerMailList[j].name!,
                      (selectSwithValue == false
                          ? "A new event, " +
                          gameNameController!.text +
                          " has been Scheduled by " + userName +
                          " for the team, " + teamName + "."
                          : "A new game, " +
                          gameNameController!.text +
                          " has been Scheduled by " + userName +
                          " for the team, " + teamName + "."),
                      "",
                      "",
                      "",
                      locationDetailsController!.text,
                      (dateformat == "US"
                          ? DateFormat("MM/dd/yyyy").format(
                          repeatvalue == MyStrings.doesNotRepeat
                              ? dateTime
                              : days[count])
                          : dateformat == "CA"
                          ? DateFormat("yyyy/MM/dd").format(
                          repeatvalue == MyStrings.doesNotRepeat
                              ? dateTime
                              : days[count])
                          : DateFormat("dd/MM/yyyy").format(
                          repeatvalue == MyStrings.doesNotRepeat
                              ? dateTime
                              : days[count])),
                      (timeSwitchValue
                          ? "TBD"
                          : DateFormat("h:mma")
                          .format(time)),
                      signIn!,
                      "",
                      "",
                      "",
                      "",noteSwitchValue

                  );
                }
              }
              if (playerMailList.isNotEmpty) {
                for (int i = 0; i < playerMailList.length; i++) {
                  String acceptvalue = "",
                      maybevalue = "",
                      declainvalue = "";
                  SendPushNotificationService().sendPushNotifications(
                      playerMailList[i].FCMTokenID ?? "",
                      (selectSwithValue == false
                          ? "Event"
                          : "Game") +
                          " Notification",
                      "The " +
                          (selectSwithValue == false
                              ? ("Event " +
                              gameNameController!.text +
                              " is scheduled by " +
                              userName + " for the team " + teamName + ", on " +
                              (dateformat == "US"
                                  ? DateFormat("MM/dd/yyyy").format(
                                  repeatvalue ==
                                      MyStrings.doesNotRepeat
                                      ? dateTime
                                      : days[count])
                                  : dateformat == "CA"
                                  ? DateFormat("yyyy/MM/dd").format(
                                  repeatvalue ==
                                      MyStrings.doesNotRepeat
                                      ? dateTime
                                      : days[count])
                                  : DateFormat("dd/MM/yyyy").format(
                                  repeatvalue ==
                                      MyStrings.doesNotRepeat
                                      ? dateTime
                                      : days[count])) + " " +
                              (timeSwitchValue
                                  ? "TBD"
                                  : DateFormat("h:mma")
                                  .format(time)) +
                              " at " +
                              locationDetailsController!.text +
                              ".")
                              : ("Game " +
                              gameNameController!.text +
                              " is scheduled by " + userName +
                              " for the team " + teamName +
                              ", on " + (dateformat == "US"
                              ? DateFormat("MM/dd/yyyy").format(
                              repeatvalue ==
                                  MyStrings.doesNotRepeat
                                  ? dateTime
                                  : days[count])
                              : dateformat == "CA"
                              ? DateFormat("yyyy/MM/dd").format(
                              repeatvalue ==
                                  MyStrings.doesNotRepeat
                                  ? dateTime
                                  : days[count])
                              : DateFormat("dd/MM/yyyy").format(
                              repeatvalue ==
                                  MyStrings.doesNotRepeat
                                  ? dateTime
                                  : days[count])) +
                              " " +
                              (timeSwitchValue
                                  ? "TBD"
                                  : DateFormat("h:mma")
                                  .format(time)) +
                              " at " +
                              locationDetailsController!.text +
                              ".")
                          ));

                  await DynamicLinksService()
                      .createDynamicLink("splash_Screen?userid=" +
                      playerMailList[i].userIDNo.toString() +
                      "&refer=" +
                      gameResponse.result![a].eventId.toString() +
                      "&status=2" + "&eventname=" +
                      gameNameController!.text + "&teamname=" +
                      teamName + "&type=" +
                      (selectSwithValue == false
                          ? "event"
                          : "game") + "&fcm=" + (userFcm != null ? userFcm! : "") +
                      "&name=" + userName + "&mail=" + playerMailList[i].email! +
                      "&toMail=" + userEmail! + "&toID=" + userID + "&userName=" +
                      playerMailList[i].name! + "&location=" +
                      locationDetailsController!.text )
                      .then((acceptvalue) async {
                    await DynamicLinksService()
                        .createDynamicLink("splash_Screen?userid=" +
                        playerMailList[i].userIDNo.toString() +
                        "&refer=" +
                        gameResponse.result![a].eventId.toString() +
                        "&status=3" + "&eventname=" +
                        gameNameController!.text + "&teamname=" +
                        teamName + "&type=" +
                        (selectSwithValue == false
                            ? "event"
                            : "game") + "&fcm=" +
                        (userFcm != null ? userFcm! : "") + "&name=" + userName +
                        "&mail=" + playerMailList[i].email! + "&toMail=" +
                        userEmail! +
                        "&toID=" + userID + "&userName=" + playerMailList[i].name!)
                        .then((declainvalue) async {
                      await DynamicLinksService()
                          .createDynamicLink("splash_Screen?userid=" +
                          playerMailList[i].userIDNo.toString() +
                          "&refer=" +
                          gameResponse.result![a].eventId.toString() +
                          "&status=4" + "&eventname=" +
                          gameNameController!.text + "&teamname=" +
                          teamName + "&type=" +
                          (selectSwithValue == false
                              ? "event"
                              : "game") + "&fcm=" +
                          (userFcm != null ? userFcm! : "") + "&name=" + userName +
                          "&mail=" + playerMailList[i].email! + "&toMail=" +
                          userEmail! +
                          "&toID=" + userID + "&userName=" +
                          playerMailList[i].name!)
                          .then((maybevalue) {
                        EmailService().createEventNotification(
                            "",
                            "",
                            Constants.reminder,
                            int.parse(userID),
                            playerMailList[i].userIDNo!,
                            int.parse(gameResponse.result![a].eventId.toString()),
                            "The " +
                                (selectSwithValue == false
                                    ? ("Event " +
                                    gameNameController!.text +
                                    " is scheduled by " + userName +
                                    " for the team " + teamName + ", on " +
                                    (dateformat == "US"
                                        ? DateFormat("MM/dd/yyyy").format(
                                        repeatvalue ==
                                            MyStrings.doesNotRepeat
                                            ? dateTime
                                            : days[count])
                                        : dateformat == "CA"
                                        ? DateFormat("yyyy/MM/dd").format(
                                        repeatvalue ==
                                            MyStrings.doesNotRepeat
                                            ? dateTime
                                            : days[count])
                                        : DateFormat("dd/MM/yyyy").format(
                                        repeatvalue ==
                                            MyStrings.doesNotRepeat
                                            ? dateTime
                                            : days[count])) + " " +
                                    (timeSwitchValue
                                        ? "TBD"
                                        : DateFormat("h:mma")
                                        .format(time)) +
                                    " at " +
                                    locationDetailsController!.text +
                                    ".")
                                    : ("Game " +
                                    gameNameController!.text +
                                    " is scheduled by " + userName +
                                    " for the team " + teamName + ", on " +
                                    (dateformat == "US"
                                        ? DateFormat("MM/dd/yyyy").format(
                                        repeatvalue ==
                                            MyStrings.doesNotRepeat
                                            ? dateTime
                                            : days[count])
                                        : dateformat == "CA"
                                        ? DateFormat("yyyy/MM/dd").format(
                                        repeatvalue ==
                                            MyStrings.doesNotRepeat
                                            ? dateTime
                                            : days[count])
                                        : DateFormat("dd/MM/yyyy").format(
                                        repeatvalue ==
                                            MyStrings.doesNotRepeat
                                            ? dateTime
                                            : days[count])) + " " +
                                    (timeSwitchValue
                                        ? "TBD"
                                        : DateFormat("h:mma")
                                        .format(time)) +
                                    " at " +
                                    locationDetailsController!.text +
                                    ".")),
                            "",
                            "",
                            "",
                            "",
                            "",
                            "",
                            "",
                            "",
                            "",
                            "",
                            "",
                            "",
                            "",
                            "",noteSwitchValue);


                        playerEventNotification(
                            "" +
                                (selectSwithValue == false
                                    ? "New Event"
                                    : "New Game") +
                                " Scheduled - " +
                                gameNameController!.text,
                            gameNameController!.text,
                            Constants.gameOrEventRequest,
                            int.parse(gameResponse.result![a].eventId.toString()),
                            "The " +
                                (selectSwithValue == false
                                    ? ("Event " +
                                    gameNameController!.text +
                                    " is scheduled by " + userName +
                                    " for the team " + teamName + ", on " +
                                    (dateformat == "US"
                                        ? DateFormat("MM/dd/yyyy").format(
                                        repeatvalue ==
                                            MyStrings.doesNotRepeat
                                            ? dateTime
                                            : days[count])
                                        : dateformat == "CA"
                                        ? DateFormat("yyyy/MM/dd").format(
                                        repeatvalue ==
                                            MyStrings.doesNotRepeat
                                            ? dateTime
                                            : days[count])
                                        : DateFormat("dd/MM/yyyy").format(
                                        repeatvalue ==
                                            MyStrings.doesNotRepeat
                                            ? dateTime
                                            : days[count])) + " " +
                                    (timeSwitchValue
                                        ? "TBD"
                                        : DateFormat("h:mma")
                                        .format(time)) +
                                    " at " +
                                    locationDetailsController!.text +
                                    ".")
                                    : ("Game " +
                                    gameNameController!.text +
                                    " is scheduled by " + userName +
                                    " for the team " + teamName + ", on " +
                                    (dateformat == "US"
                                        ? DateFormat("MM/dd/yyyy").format(
                                        repeatvalue ==
                                            MyStrings.doesNotRepeat
                                            ? dateTime
                                            : days[count])
                                        : dateformat == "CA"
                                        ? DateFormat("yyyy/MM/dd").format(
                                        repeatvalue ==
                                            MyStrings.doesNotRepeat
                                            ? dateTime
                                            : days[count])
                                        : DateFormat("dd/MM/yyyy").format(
                                        repeatvalue ==
                                            MyStrings.doesNotRepeat
                                            ? dateTime
                                            : days[count])) + " " +
                                    (timeSwitchValue
                                        ? "TBD"
                                        : DateFormat("h:mma")
                                        .format(time)) +
                                    " at " +
                                    locationDetailsController!.text +
                                    "."))
                            ,
                            playerMailList[i].userIDNo!,
                            playerMailList[i].email!,
                            noteSwitchValue,
                            playerMailList[i].name!,
                            (selectSwithValue == false
                                ? "event, " + gameNameController!
                                .text + " has been Scheduled by " + userName +
                                " for the team, " + teamName + "."
                                : "game, " + gameNameController!.text +
                                " has been Scheduled by " + userName +
                                " for the team, " + teamName + "."),
                            acceptvalue,
                            maybevalue,
                            declainvalue,
                            locationDetailsController!.text,
                            (dateformat == "US"
                                ? DateFormat("MM/dd/yyyy").format(
                                repeatvalue == MyStrings.doesNotRepeat
                                    ? dateTime
                                    : days[count])
                                : dateformat == "CA"
                                ? DateFormat("yyyy/MM/dd").format(
                                repeatvalue == MyStrings.doesNotRepeat
                                    ? dateTime
                                    : days[count])
                                : DateFormat("dd/MM/yyyy").format(
                                repeatvalue == MyStrings.doesNotRepeat
                                    ? dateTime
                                    : days[count])),
                            (timeSwitchValue
                                ? "TBD"
                                : DateFormat("h:mma")
                                .format(time)),
                            signIn!


                        );
                      });
                    });
                  });
                }
              }
            }

            count++;
          } catch (e) {
            listener.onSuccess(gameResponse, reqId: ResponseIds.ADD_GAME);

          }
        }
      }
    }

  }

  List<DateTime> getDaysInBetween(DateTime startDate, DateTime endDate,
      List<int> repeatDays) {
    days = [];
    for (int i = 0; i <= endDate
        .difference(startDate)
        .inDays; i++) {
      if (startDate
          .add(Duration(days: i))
          .weekday == 7 &&
          repeatDays.contains(1)) {
        print(startDate.add(Duration(days: i)));
        days.add(startDate.add(Duration(days: i)));
      } else if (repeatDays
          .contains(startDate
          .add(Duration(days: i))
          .weekday + 1)) {
        print(startDate.add(Duration(days: i)));
        days.add(startDate.add(Duration(days: i)));
      }
    }
    return days;
  }

  List<DateTime> getDaysInBetweenDaily(DateTime startDate, DateTime endDate) {
    days = [];
    for (int i = 0; i <= endDate
        .difference(startDate)
        .inDays; i++) {
      days.add(startDate.add(Duration(days: i)));
      print(startDate.add(Duration(days: i)));

    }
    return days;
  }

  /*
Return Type:
Input Parameters:
Use: Create API Calls and Handle Exceptions.
 */
  void getTeamMembersEmailAsync() async {
    try {


      await ApiManager()
          .getDio()!
          .post(Endpoints.serverGameUrl + Endpoints.getTeamMembersEmail,
          data: int.parse( "${await SharedPrefManager.instance.getStringAsync(Constants.teamID)}"))
          .then((response) => registerTeamEmailListResponse(response))
          .catchError((onError) {
        listener.onFailure(DioErrorUtil.handleErrors(onError));
      });
    } catch (e) {
      listener.onFailure(ExceptionErrorUtil.handleErrors(e));
    }
  }

  void registerTeamEmailListResponse(Response response) {
    _getTeamMembersEmailResponse =
        GetTeamMembersEmailResponse.fromJson(response.data);
    listener.onSuccess(
        _getTeamMembersEmailResponse, reqId: ResponseIds.TEAM_EMAIL_LIST);
  }
  /*
Return Type:
Input Parameters:
Use: Create API Calls and Handle Exceptions.
 */
  getExistingPlayer(String email) async {
    try {
      SearchUserRequest _searchUserRequest= SearchUserRequest();
      _searchUserRequest.email=email;
      await ApiManager()
          .getDio()!
          .post(Endpoints.serverGameUrl+Endpoints.searchUserUsingMail, data: _searchUserRequest)
          .then((response) => getExistingPlayerResponse(response))
          .catchError((onError) {
        listener.onFailure(DioErrorUtil.handleErrors(onError));
      });
    } catch (e) {
      listener.onFailure(ExceptionErrorUtil.handleErrors(e));
    }
  }
  void getExistingPlayerResponse(Response response) {
    try {
      AddExistingPlayerResponse _response = AddExistingPlayerResponse.fromJson(response.data);
      listener.onSuccess(_response, reqId: ResponseIds.ADD_EXISTING_PLAYER);
    } catch (e) {

      print(e);
    }
  }

  /*
Return Type:
Input Parameters:
Use: Create API Calls and Handle Exceptions.
 */
  void getGameOrEventAsync(int gameID) async {
    try {

      await ApiManager()
          .getDio()!
          .post(Endpoints.serverGameUrl + Endpoints.getGameorEvent,
          data: gameID)
          .then((response) => registerGameResponse(response))
          .catchError((onError) {
        listener.onFailure(DioErrorUtil.handleErrors(onError));
      });
    } catch (e) {
      listener.onFailure(ExceptionErrorUtil.handleErrors(e));
    }
  }

  void registerGameResponse(Response response) {
    a.AddGameRequest _response = a.AddGameRequest.fromJson(response.data);
    listener.onSuccess(_response, reqId: ResponseIds.UPDATE_GAME);
  }

/*
Return Type:
Input Parameters:
Use: Create API Calls and Handle Exceptions.
 */
  void updateGameAsync(double lat, double lon, bool isAllOccurence) async {
    try {
      List<int> customUserId=[];
      for(int i=0;i<ownerMailList.length;i++){
        customUserId.add(ownerMailList[i].userIDNo!);
      }
      for(int i=0;i<playerMailList.length;i++){
        customUserId.add(playerMailList[i].userIDNo!);

      }
      for(int i=0;i<nonPlayerMailList.length;i++){
        customUserId.add(nonPlayerMailList[i].userIDNo!);

      }
      _addGameRequest = a.AddGameRequest();
      _addGameRequest!.result=a.Result();
      _addGameRequest!.result!.eventId = eventID!;
      _addGameRequest!.result!.type =
      editselectSwithValue == false ? Constants.event : Constants.game;
      _addGameRequest!.result!.name = gameNameController!.text;
      _addGameRequest!.result!.sportIDNo = 10001;
      _addGameRequest!.result!.scheduleDate = DateFormat('dd/MM/yyyy').format(dateTime);
      _addGameRequest!.result!.scheduleTime =
      timeSwitchValue ? "00:00" : DateFormat("h:mma").format(time);
      _addGameRequest!.result!.venue = locationDetailsController!.text;
      _addGameRequest!.result!.teamIDNo = int.parse(
          "${await SharedPrefManager.instance.getStringAsync(
              Constants.teamID)}");
      _addGameRequest!.result!.opponentTeamID = opponentIDController!.text.isEmpty ||
          opponentIDController!.text == "null"
          ? null
          : int.parse(opponentIDController!.text);
      _addGameRequest!.result!.status = Constants.upcoming;
      _addGameRequest!.result!.repeat = repeatvalue == MyStrings.doesNotRepeat ? 0 : 1;
      _addGameRequest!.result!.repeatType = repeatvalue == MyStrings.doesNotRepeat
          ? Constants.doNotRepeat
          : repeatvalue == MyStrings.weekly ? Constants.weekly : Constants
          .daily;
      if(repeatvalue == MyStrings.weekly ||  repeatvalue == MyStrings.daily) {
        _addGameRequest!.result!.repeatStartDate =
            DateFormat('dd/MM/yyyy').format(dateformat == "US"
                ? DateFormat("MM/dd/yyyy").parse(StartDatePickerController!.text)
                : dateformat == "CA"
                ? DateFormat("yyyy/MM/dd").parse(StartDatePickerController!.text)
                : DateFormat("dd/MM/yyyy")
                .parse(StartDatePickerController!.text));
        _addGameRequest!.result!.repeatEndDate =
            DateFormat('dd/MM/yyyy').format(dateformat == "US"
                ? DateFormat("MM/dd/yyyy").parse(EndDatePickerController!.text)
                : dateformat == "CA"
                ? DateFormat("yyyy/MM/dd").parse(EndDatePickerController!.text)
                : DateFormat("dd/MM/yyyy").parse(EndDatePickerController!.text));
      }else{
        _addGameRequest!.result!.repeatStartDate =StartDatePickerController!.text;
        _addGameRequest!.result!.repeatEndDate =EndDatePickerController!.text;
      }
      _addGameRequest!.result!.locationAddress = locationDetailsController!.text;
      _addGameRequest!.result!.locationDetails = locationDetailsController!.text;
      _addGameRequest!.result!.duration = duration;
      _addGameRequest!.result!.isAllOccurence = isAllOccurence;
      _addGameRequest!.result!.arriveEarly = arriveEarly;
      _addGameRequest!.result!.flagColor = selectedFlagColor??"";
      _addGameRequest!.result!.trackAvail = trackSwitchValue == false ? 0 : 1;
      _addGameRequest!.result!.IsNotesRequired = noteSwitchValue;
      _addGameRequest!.result!.notes = noteController!.text;
      _addGameRequest!.result!.tDB = timeSwitchValue;
      _addGameRequest!.result!.timeZone = timezoneController!.text;
      _addGameRequest!.result!.homeOrAway = selectedHomeAway!;
      _addGameRequest!.result!.isCustom = mailSwitchValue;
      _addGameRequest!.result!.customMemberList = customUserId;
      _addGameRequest!.result!.EventGroupId = eventGroupId??0;
      _addGameRequest!.result!.latitude = lat.toString();
      _addGameRequest!.result!.longtitude = lon.toString();
      _addGameRequest!.result!.userIDNo = int.parse(
          "${await SharedPrefManager.instance.getStringAsync(
              Constants.userIdNo)}");
      repeatDays = [];
      for (int i = 0; i < weekdayvalues
          .toList()
          .length; i++) {
        if (weekdayvalues[i] == true) {
          repeatDays.add(i + 1);
        }
      }
      if (repeatvalue == MyStrings.weekly) {
        DateTime startDate = dateformat == "US"
            ? DateFormat("MM/dd/yyyy").parse(StartDatePickerController!.text)
            : dateformat == "CA"
            ? DateFormat("yyyy/MM/dd").parse(StartDatePickerController!.text)
            : DateFormat("dd/MM/yyyy")
            .parse(StartDatePickerController!.text);
        DateTime endDate = dateformat == "US"
            ? DateFormat("MM/dd/yyyy").parse(EndDatePickerController!.text)
            : dateformat == "CA"
            ? DateFormat("yyyy/MM/dd").parse(EndDatePickerController!.text)
            : DateFormat("dd/MM/yyyy").parse(EndDatePickerController!.text);
        getDaysInBetween(startDate, endDate, repeatDays);
      }
      if (repeatvalue == MyStrings.daily) {
        DateTime startDate = dateformat == "US"
            ? DateFormat("MM/dd/yyyy").parse(StartDatePickerController!.text)
            : dateformat == "CA"
            ? DateFormat("yyyy/MM/dd").parse(StartDatePickerController!.text)
            : DateFormat("dd/MM/yyyy")
            .parse(StartDatePickerController!.text);
        DateTime endDate = dateformat == "US"
            ? DateFormat("MM/dd/yyyy").parse(EndDatePickerController!.text)
            : dateformat == "CA"
            ? DateFormat("yyyy/MM/dd").parse(EndDatePickerController!.text)
            : DateFormat("dd/MM/yyyy").parse(EndDatePickerController!.text);
        getDaysInBetweenDaily(startDate, endDate);
      }
      _addGameRequest!.result!.repeatDays = repeatDays;
      for (int i = 0; i < volunteerNameController.length; i++) {
        if (volunteerCheckBoxController[i].text == "true") {
          a.VolunteerTypeList volunteerType = new a.VolunteerTypeList();
          userIDList = [];
          volunteerType.eventVoluenteerTypeIDNo = 0;
          volunteerType.eventId = 0;
          volunteerType.isDeleted = 0;
          volunteerType.volunteerTypeId = volunteerIDController[i].text.isEmpty
              ? 250
              : int.parse(volunteerIDController[i].text);
          volunteerType.volunteerTypeName = volunteerNameController[i].text;
          for (int j = 0; j < volunteerPlayernamecontroller[i].length; j++) {
            for (int k = 0;
            k < roasterListViewResponse!.result!.userDetails!.length;
            k++) {
              if ((roasterListViewResponse!.result!.userDetails![k].userFirstName! +
                  " " +
                  roasterListViewResponse!.result!.userDetails![k].userLastName!) ==
                  volunteerPlayernamecontroller[i][j].text) {
                if (userIDList.isEmpty) {
                  userIDList
                      .add(roasterListViewResponse!.result!.userDetails![k].userIdNo!);
                } else {
                  if (userIDList.contains(
                      roasterListViewResponse!.result!.userDetails![k]
                          .userIdNo)) {} else {
                    userIDList
                        .add(roasterListViewResponse!.result!.userDetails![k].userIdNo!);
                  }
                }
              }
            }
          }
          volunteerType.userIDList = userIDList;
          volunteerTypeList.add(volunteerType);
        }
      }
      _addGameRequest!.result!.volunteerTypeList = volunteerTypeList;

      await ApiManager()
          .getDio()!
          .post(Endpoints.serverGameUrl + Endpoints.addGameorEvent,
          data: _addGameRequest!.result)
          .then((response) => updateGameResponse(response,isAllOccurence))
          .catchError((onError) {
        listener.onFailure(DioErrorUtil.handleErrors(onError));
      });
    } catch (e) {
      listener.onFailure(ExceptionErrorUtil.handleErrors(e));
    }
  }

  Future<void> updateGameResponse(Response response, bool isAllOccurence) async {
    int eventid = 0;
    int count = 0;
    if(response.data['Result'].length==0){
      listener.onSuccess("", reqId: ResponseIds.ADD_GAME);

    }
    AddGameResponse gameResponse = AddGameResponse.fromJson(response.data);

    for (int a = 0; a < gameResponse.result!.length; a++) {
      try {
        for (int b = 0; b < gameResponse.result![a].userIDList!.length; b++) {
          for (int c = 0; c <
              _getTeamMembersEmailResponse!.result!.userMailList!.length; c++) {
            if (gameResponse.result![a].userIDList![b] ==
                _getTeamMembersEmailResponse!.result!.userMailList![c].userIDNo) {
              await DynamicLinksService()
                  .createDynamicLink("volunteer_availablity_screen?userid=" +
                  _getTeamMembersEmailResponse!.result!.userMailList![c].userIDNo
                      .toString() +
                  "&refer=" +
                  gameResponse.result![a].eventId.toString() +
                  "&status=2" + "&eventname=" +
                  gameNameController!.text + "&volunteer=" +
                  gameResponse.result![a].volunteerTypeName! + "&eventVolunteerTypeId=" +
                  gameResponse.result![a].eventVoluenteerTypeIDNo.toString() +
                  "&volunteerTypeId=" +
                  gameResponse.result![a].volunteerTypeId.toString() + "&teamname=" +
                  teamName + "&type=" +
                  (editselectSwithValue == false
                      ? "event"
                      : "game") + "&fcm=" + (userFcm != null ? userFcm! : "") +
                  "&name=" + userName + "&mail=" +
                  _getTeamMembersEmailResponse!.result!.userMailList![c].email! +
                  "&toMail=" + userEmail! + "&toID=" + userID + "&userName=" +
                  _getTeamMembersEmailResponse!.result!.userMailList![c].name! +
                  "&location=" +
                  locationDetailsController!.text )
                  .then((acceptvalue) async {
                await DynamicLinksService()
                    .createDynamicLink("volunteer_availablity_screen?userid=" +
                    _getTeamMembersEmailResponse!.result!.userMailList![c].userIDNo
                        .toString() +
                    "&refer=" +
                    gameResponse.result![a].eventId.toString() +
                    "&status=3" + "&eventname=" +
                    gameNameController!.text + "&volunteer=" +
                    gameResponse.result![a].volunteerTypeName! + "&eventVolunteerTypeId=" +
                    gameResponse.result![a].eventVoluenteerTypeIDNo.toString() +
                    "&volunteerTypeId=" +
                    gameResponse.result![a].volunteerTypeId.toString() + "&teamname=" +
                    teamName + "&type=" +
                    (editselectSwithValue == false
                        ? "event"
                        : "game") + "&fcm=" +
                    (userFcm != null ? userFcm! : "") + "&name=" + userName +
                    "&mail=" +
                    _getTeamMembersEmailResponse!.result!.userMailList![c].email! +
                    "&toMail=" +
                    userEmail! +
                    "&toID=" + userID + "&userName=" +
                    _getTeamMembersEmailResponse!.result!.userMailList![c].name!)
                    .then((declainvalue) async {
                  await DynamicLinksService()
                      .createDynamicLink(
                      "volunteer_availablity_screen?userid=" +
                          _getTeamMembersEmailResponse!.result!.userMailList![c].userIDNo
                              .toString() +
                          "&refer=" +
                          gameResponse.result![a].eventId.toString() +
                          "&status=4" + "&eventname=" +
                          gameNameController!.text + "&volunteer=" +
                          gameResponse.result![a].volunteerTypeName! +
                          "&eventVolunteerTypeId=" +
                          gameResponse.result![a].eventVoluenteerTypeIDNo.toString() +
                          "&volunteerTypeId=" +
                          gameResponse.result![a].volunteerTypeId.toString() +
                          "&teamname=" +
                          teamName + "&type=" +
                          (editselectSwithValue == false
                              ? "event"
                              : "game") + "&fcm=" +
                          (userFcm != null ? userFcm! : "") + "&name=" +
                          userName +
                          "&mail=" +
                          _getTeamMembersEmailResponse!.result!.userMailList![c].email! +
                          "&toMail=" +
                          userEmail! +
                          "&toID=" + userID + "&userName=" +
                          _getTeamMembersEmailResponse!.result!.userMailList![c].name!)
                      .then((maybevalue) {
                    volunteerInviteNotification(
                        " Assigned Volunteer",
                        gameNameController!.text,
                        Constants.gameVolunteerInvite,
                        int.parse(gameResponse.result![a].eventId.toString()),
                        "Volunteer task has been assigned by " +
                            (userName +
                                " for the " + (editselectSwithValue == false
                                ? "Event, "
                                : "Game, ") + gameNameController!.text +
                                " that is updated to commence on " +
                                (dateformat == "US"
                                    ? DateFormat("MM/dd/yyyy").format(
                                    isAllOccurence?(repeatvalue ==
                                        MyStrings.doesNotRepeat
                                        ? dateTime
                                        : days.length > count
                                        ? days[count]
                                        : days[count - 1]):dateTime)
                                    : dateformat == "CA"
                                    ? DateFormat("yyyy/MM/dd").format(
                                    isAllOccurence?(repeatvalue ==
                                        MyStrings.doesNotRepeat
                                        ? dateTime
                                        : days.length > count
                                        ? days[count]
                                        : days[count - 1]):dateTime)
                                    : DateFormat("dd/MM/yyyy").format(
                                    isAllOccurence?(repeatvalue ==
                                        MyStrings.doesNotRepeat
                                        ? dateTime
                                        : days.length > count
                                        ? days[count]
                                        : days[count - 1]):dateTime)) + " " +
                                (timeSwitchValue
                                    ? "TBD"
                                    : DateFormat("h:mma")
                                    .format(time)) +
                                " at " +
                                locationDetailsController!.text +
                                "."),
                        _getTeamMembersEmailResponse!.result!.userMailList![c].userIDNo!,
                        _getTeamMembersEmailResponse!.result!.userMailList![c].email!,
                        noteSwitchValue,
                        userName,
                        teamName,
                        gameResponse.result![a].volunteerTypeName!,
                        gameResponse.result![a].eventVoluenteerTypeIDNo!,
                        gameResponse.result![a].volunteerTypeId!,
                        gameNameController!.text,
                        acceptvalue,
                        maybevalue,
                        declainvalue,
                        locationDetailsController!.text,
                        (dateformat == "US"
                            ? DateFormat("MM/dd/yyyy").format(
                            isAllOccurence?(repeatvalue == MyStrings.doesNotRepeat
                                ? dateTime
                                : days.length > count
                                ? days[count]
                                : days[count - 1]):dateTime)
                            : dateformat == "CA"
                            ? DateFormat("yyyy/MM/dd").format(
                            isAllOccurence?(repeatvalue == MyStrings.doesNotRepeat
                                ? dateTime
                                : days.length > count
                                ? days[count]
                                : days[count - 1]):dateTime)
                            : DateFormat("dd/MM/yyyy").format(
                            isAllOccurence?(repeatvalue == MyStrings.doesNotRepeat
                                ? dateTime
                                : days.length > count
                                ? days[count]
                                : days[count - 1]):dateTime)),
                        (timeSwitchValue
                            ? "TBD"
                            : DateFormat("h:mma")
                            .format(time)),
                        signIn!
                    );
                  });
                });
              });
            }
          }
        }
      } catch (e) {
        print(e);
      }
      if (eventid != gameResponse.result![a].eventId) {
        try {
          _selectTeamRequest = SelectTeamRequest();
          _selectTeamRequest!.userIdNo = int.parse(
              "${await SharedPrefManager.instance.getStringAsync(
                  Constants.teamID)}");
          if (eventid == 0) {
            listener.onSuccess(gameResponse, reqId: ResponseIds.ADD_GAME);
          }
          eventid = gameResponse.result![a].eventId!;

          if (editselectSwithValue == false) {
            if (playerMailList.isNotEmpty) {
              for (int i = 0; i < playerMailList.length; i++) {
                String acceptvalue = "",
                    maybevalue = "",
                    declainvalue = "";
                SendPushNotificationService().sendPushNotifications(
                    playerMailList[i].FCMTokenID ?? "",
                    (editselectSwithValue == false
                        ? "Event"
                        : "Game") +
                        " Notification",
                    "The " +
                        (editselectSwithValue == false
                            ? ("Event " +
                            gameNameController!.text +
                            " is updated by " +
                            userName + " for the team " + teamName + ", on " +
                            (dateformat == "US"
                                ? DateFormat("MM/dd/yyyy").format(
                                isAllOccurence?(repeatvalue ==
                                    MyStrings.doesNotRepeat
                                    ? dateTime
                                    : days[count]):dateTime)
                                : dateformat == "CA"
                                ? DateFormat("yyyy/MM/dd").format(
                                isAllOccurence?(repeatvalue ==
                                    MyStrings.doesNotRepeat
                                    ? dateTime
                                    : days[count]):dateTime)
                                : DateFormat("dd/MM/yyyy").format(
                                isAllOccurence?(repeatvalue ==
                                    MyStrings.doesNotRepeat
                                    ? dateTime
                                    : days[count]):dateTime)) + " " +
                            (timeSwitchValue
                                ? "TBD"
                                : DateFormat("h:mma")
                                .format(time)) +
                            " at " +
                            locationDetailsController!.text +
                            ".")
                            : ("Game " +
                            gameNameController!.text +
                            " is updated by " + userName +
                            " for the team " + teamName +
                            ", on " + (dateformat == "US"
                            ? DateFormat("MM/dd/yyyy").format(
                            isAllOccurence?(repeatvalue ==
                                MyStrings.doesNotRepeat
                                ? dateTime
                                : days[count]):dateTime)
                            : dateformat == "CA"
                            ? DateFormat("yyyy/MM/dd").format(
                            isAllOccurence?(repeatvalue ==
                                MyStrings.doesNotRepeat
                                ? dateTime
                                : days[count]):dateTime)
                            : DateFormat("dd/MM/yyyy").format(
                            isAllOccurence?(repeatvalue ==
                                MyStrings.doesNotRepeat
                                ? dateTime
                                : days[count]):dateTime)) +
                            " " +
                            (timeSwitchValue
                                ? "TBD"
                                : DateFormat("h:mma")
                                .format(time)) +
                            " at " +
                            locationDetailsController!.text +
                            ".")
                        ));

                await DynamicLinksService()
                    .createDynamicLink("splash_Screen?userid=" +
                    playerMailList[i].userIDNo.toString() +
                    "&refer=" +
                    gameResponse.result![a].eventId.toString() +
                    "&status=2" + "&eventname=" +
                    gameNameController!.text + "&teamname=" +
                    teamName + "&type=" +
                    (editselectSwithValue == false
                        ? "event"
                        : "game") + "&fcm=" + (userFcm != null ? userFcm! : "") +
                    "&name=" + userName + "&mail=" + playerMailList[i].email! +
                    "&toMail=" + userEmail! + "&toID=" + userID + "&userName=" +
                    playerMailList[i].name! + "&location=" +
                    locationDetailsController!.text )
                    .then((acceptvalue) async {
                  await DynamicLinksService()
                      .createDynamicLink("splash_Screen?userid=" +
                      playerMailList[i].userIDNo.toString() +
                      "&refer=" +
                      gameResponse.result![a].eventId.toString() +
                      "&status=3" + "&eventname=" +
                      gameNameController!.text + "&teamname=" +
                      teamName + "&type=" +
                      (editselectSwithValue == false
                          ? "event"
                          : "game") + "&fcm=" +
                      (userFcm != null ? userFcm! : "") + "&name=" + userName +
                      "&mail=" + playerMailList[i].email !+ "&toMail=" +
                      userEmail! +
                      "&toID=" + userID + "&userName=" + playerMailList[i].name!)
                      .then((declainvalue) async {
                    await DynamicLinksService()
                        .createDynamicLink("splash_Screen?userid=" +
                        playerMailList[i].userIDNo.toString() +
                        "&refer=" +
                        gameResponse.result![a].eventId.toString() +
                        "&status=4" + "&eventname=" +
                        gameNameController!.text + "&teamname=" +
                        teamName + "&type=" +
                        (editselectSwithValue == false
                            ? "event"
                            : "game") + "&fcm=" +
                        (userFcm != null ? userFcm! : "") + "&name=" + userName +
                        "&mail=" + playerMailList[i].email! + "&toMail=" +
                        userEmail! +
                        "&toID=" + userID + "&userName=" +
                        playerMailList[i].name!)
                        .then((maybevalue) {
                      EmailService().createEventNotification(
                          "",
                          "",
                          Constants.reminder,
                          int.parse(userID),
                          playerMailList[i].userIDNo!,
                          int.parse(gameResponse.result![a].eventId.toString()),
                          "The " +
                              (editselectSwithValue == false
                                  ? ("Event " +
                                  gameNameController!.text +
                                  " is updated by " + userName +
                                  " for the team " + teamName + ", on " +
                                  (dateformat == "US"
                                      ? DateFormat("MM/dd/yyyy").format(
                                      isAllOccurence?(repeatvalue ==
                                          MyStrings.doesNotRepeat
                                          ? dateTime
                                          : days[count]):dateTime)
                                      : dateformat == "CA"
                                      ? DateFormat("yyyy/MM/dd").format(
                                      isAllOccurence?(repeatvalue ==
                                          MyStrings.doesNotRepeat
                                          ? dateTime
                                          : days[count]):dateTime)
                                      : DateFormat("dd/MM/yyyy").format(
                                      isAllOccurence?(repeatvalue ==
                                          MyStrings.doesNotRepeat
                                          ? dateTime
                                          : days[count]):dateTime)) + " " +
                                  (timeSwitchValue
                                      ? "TBD"
                                      : DateFormat("h:mma")
                                      .format(time)) +
                                  " at " +
                                  locationDetailsController!.text +
                                  ".")
                                  : ("Game " +
                                  gameNameController!.text +
                                  " is updated by " + userName +
                                  " for the team " + teamName + ", on " +
                                  (dateformat == "US"
                                      ? DateFormat("MM/dd/yyyy").format(
                                      isAllOccurence?(repeatvalue ==
                                          MyStrings.doesNotRepeat
                                          ? dateTime
                                          : days[count]):dateTime)
                                      : dateformat == "CA"
                                      ? DateFormat("yyyy/MM/dd").format(
                                      isAllOccurence?(repeatvalue ==
                                          MyStrings.doesNotRepeat
                                          ? dateTime
                                          : days[count]):dateTime)
                                      : DateFormat("dd/MM/yyyy").format(
                                      isAllOccurence?(repeatvalue ==
                                          MyStrings.doesNotRepeat
                                          ? dateTime
                                          : days[count]):dateTime)) + " " +
                                  (timeSwitchValue
                                      ? "TBD"
                                      : DateFormat("h:mma")
                                      .format(time)) +
                                  " at " +
                                  locationDetailsController!.text +
                                  ".")),
                          "",
                          "",
                          "",
                          "",
                          "",
                          "",
                          "",
                          "",
                          "",
                          "",
                          "",
                          "",
                          "",
                          "",noteSwitchValue);


                      playerEventNotification(
                          "" +
                              (editselectSwithValue == false
                                  ? "Updated Event - "
                                  : "Updated Game - ")  +
                              gameNameController!.text,
                          gameNameController!.text,
                          Constants.gameOrEventRequest,
                          int.parse(gameResponse.result![a].eventId.toString()),
                          "The " +
                              (editselectSwithValue == false
                                  ? ("Event " +
                                  gameNameController!.text +
                                  " is updated by " + userName +
                                  " for the team " + teamName + ", on " +
                                  (dateformat == "US"
                                      ? DateFormat("MM/dd/yyyy").format(
                                      isAllOccurence?(repeatvalue ==
                                          MyStrings.doesNotRepeat
                                          ? dateTime
                                          : days[count]):dateTime)
                                      : dateformat == "CA"
                                      ? DateFormat("yyyy/MM/dd").format(
                                      isAllOccurence?(repeatvalue ==
                                          MyStrings.doesNotRepeat
                                          ? dateTime
                                          : days[count]):dateTime)
                                      : DateFormat("dd/MM/yyyy").format(
                                      isAllOccurence?(repeatvalue ==
                                          MyStrings.doesNotRepeat
                                          ? dateTime
                                          : days[count]):dateTime)) + " " +
                                  (timeSwitchValue
                                      ? "TBD"
                                      : DateFormat("h:mma")
                                      .format(time)) +
                                  " at " +
                                  locationDetailsController!.text +
                                  ".")
                                  : ("Game " +
                                  gameNameController!.text +
                                  " is updated by " + userName +
                                  " for the team " + teamName + ", on " +
                                  (dateformat == "US"
                                      ? DateFormat("MM/dd/yyyy").format(
                                      isAllOccurence?(repeatvalue ==
                                          MyStrings.doesNotRepeat
                                          ? dateTime
                                          : days[count]):dateTime)
                                      : dateformat == "CA"
                                      ? DateFormat("yyyy/MM/dd").format(
                                      isAllOccurence?(repeatvalue ==
                                          MyStrings.doesNotRepeat
                                          ? dateTime
                                          : days[count]):dateTime)
                                      : DateFormat("dd/MM/yyyy").format(
                                      isAllOccurence?(repeatvalue ==
                                          MyStrings.doesNotRepeat
                                          ? dateTime
                                          : days[count]):dateTime)) + " " +
                                  (timeSwitchValue
                                      ? "TBD"
                                      : DateFormat("h:mma")
                                      .format(time)) +
                                  " at " +
                                  locationDetailsController!.text +
                                  "."))
                          ,
                          playerMailList[i].userIDNo!,
                          playerMailList[i].email!,
                          noteSwitchValue,
                          playerMailList[i].name!,
                          (editselectSwithValue == false
                              ? "event, " + gameNameController!
                              .text + " has been updated by " + userName +
                              " for the team, " + teamName + "."
                              : "game, " + gameNameController!.text +
                              " has been updated by " + userName +
                              " for the team, " + teamName + "."),
                          acceptvalue,
                          maybevalue,
                          declainvalue,
                          locationDetailsController!.text,
                          (dateformat == "US"
                              ? DateFormat("MM/dd/yyyy").format(
                              isAllOccurence?(repeatvalue == MyStrings.doesNotRepeat
                                  ? dateTime
                                  : days[count]):dateTime)
                              : dateformat == "CA"
                              ? DateFormat("yyyy/MM/dd").format(
                              isAllOccurence?(repeatvalue == MyStrings.doesNotRepeat
                                  ? dateTime
                                  : days[count]):dateTime)
                              : DateFormat("dd/MM/yyyy").format(
                              isAllOccurence?(repeatvalue == MyStrings.doesNotRepeat
                                  ? dateTime
                                  : days[count]):dateTime)),
                          (timeSwitchValue
                              ? "TBD"
                              : DateFormat("h:mma")
                              .format(time)),
                          signIn!
                      );
                    });
                  });
                });
              }
            }
            if (ownerMailList.isNotEmpty) {
              List<String> message = [];
              for (int i = 0; i < ownerMailList.length; i++) {
                String acceptvalue = "",
                    maybevalue = "",
                    declainvalue = "";
                SendPushNotificationService().sendPushNotifications(
                    ownerMailList[i].FCMTokenID ?? "",
                    (editselectSwithValue == false
                        ? "Event"
                        : "Game") +
                        " Notification",
                    "The " +
                        (editselectSwithValue == false
                            ? ("Event " +
                            gameNameController!.text +
                            " is updated by " +
                            userName + " for the team " + teamName + ", on " +
                            (dateformat == "US"
                                ? DateFormat("MM/dd/yyyy").format(
                                isAllOccurence?(repeatvalue ==
                                    MyStrings.doesNotRepeat
                                    ? dateTime
                                    : days[count]):dateTime)
                                : dateformat == "CA"
                                ? DateFormat("yyyy/MM/dd").format(
                                isAllOccurence?(repeatvalue ==
                                    MyStrings.doesNotRepeat
                                    ? dateTime
                                    : days[count]):dateTime)
                                : DateFormat("dd/MM/yyyy").format(
                                isAllOccurence?(repeatvalue ==
                                    MyStrings.doesNotRepeat
                                    ? dateTime
                                    : days[count]):dateTime)) + " " +
                            (timeSwitchValue
                                ? "TBD"
                                : DateFormat("h:mma")
                                .format(time)) +
                            " at " +
                            locationDetailsController!.text +
                            ".")
                            : ("Game " +
                            gameNameController!.text +
                            " is updated by " + userName +
                            " for the team " + teamName +
                            ", on " + (dateformat == "US"
                            ? DateFormat("MM/dd/yyyy").format(
                            isAllOccurence?(repeatvalue ==
                                MyStrings.doesNotRepeat
                                ? dateTime
                                : days[count]):dateTime)
                            : dateformat == "CA"
                            ? DateFormat("yyyy/MM/dd").format(
                            isAllOccurence?(repeatvalue ==
                                MyStrings.doesNotRepeat
                                ? dateTime
                                : days[count]):dateTime)
                            : DateFormat("dd/MM/yyyy").format(
                            isAllOccurence?(repeatvalue ==
                                MyStrings.doesNotRepeat
                                ? dateTime
                                : days[count]):dateTime)) +
                            " " +
                            (timeSwitchValue
                                ? "TBD"
                                : DateFormat("h:mma")
                                .format(time)) +
                            " at " +
                            locationDetailsController!.text +
                            ".")
                        ));

                await DynamicLinksService()
                    .createDynamicLink("splash_Screen?userid=" +
                    ownerMailList[i].userIDNo.toString() +
                    "&refer=" +
                    gameResponse.result![a].eventId.toString() +
                    "&status=2" + "&eventname=" +
                    gameNameController!.text + "&teamname=" +
                    teamName + "&type=" +
                    (editselectSwithValue == false
                        ? "event"
                        : "game") + "&fcm=" + (userFcm != null ? userFcm! : "") +
                    "&name=" + userName + "&mail=" + ownerMailList[i].email! +
                    "&toMail=" + userEmail! + "&toID=" + userID + "&userName=" +
                    ownerMailList[i].name! + "&location=" +
                    locationDetailsController!.text )
                    .then((acceptvalue) async {
                  await DynamicLinksService()
                      .createDynamicLink("splash_Screen?userid=" +
                      ownerMailList[i].userIDNo.toString() +
                      "&refer=" +
                      gameResponse.result![a].eventId.toString() +
                      "&status=3" + "&eventname=" +
                      gameNameController!.text + "&teamname=" +
                      teamName + "&type=" +
                      (editselectSwithValue == false
                          ? "event"
                          : "game") + "&fcm=" +
                      (userFcm != null ? userFcm! : "") + "&name=" + userName +
                      "&mail=" + ownerMailList[i].email! + "&toMail=" +
                      userEmail! +
                      "&toID=" + userID + "&userName=" + ownerMailList[i].name!)
                      .then((declainvalue) async {
                    await DynamicLinksService()
                        .createDynamicLink("splash_Screen?userid=" +
                        ownerMailList[i].userIDNo.toString() +
                        "&refer=" +
                        gameResponse.result![a].eventId.toString() +
                        "&status=4" + "&eventname=" +
                        gameNameController!.text + "&teamname=" +
                        teamName + "&type=" +
                        (editselectSwithValue == false
                            ? "event"
                            : "game") + "&fcm=" +
                        (userFcm != null ? userFcm! : "") + "&name=" + userName +
                        "&mail=" + ownerMailList[i].email! + "&toMail=" +
                        userEmail! +
                        "&toID=" + userID + "&userName=" +
                        ownerMailList[i].name!)
                        .then((maybevalue) async {
                      EmailService().createEventNotification(
                          "",
                          "",
                          Constants.reminder,
                          int.parse(userID),
                          ownerMailList[i].userIDNo!,
                          int.parse(gameResponse.result![a].eventId.toString()),
                          "The " +
                              (editselectSwithValue == false
                                  ? ("Event " +
                                  gameNameController!.text +
                                  " is updated by " + userName +
                                  " for the team " + teamName + ", on " +
                                  (dateformat == "US"
                                      ? DateFormat("MM/dd/yyyy").format(
                                      isAllOccurence?(repeatvalue ==
                                          MyStrings.doesNotRepeat
                                          ? dateTime
                                          : days[count]):dateTime)
                                      : dateformat == "CA"
                                      ? DateFormat("yyyy/MM/dd").format(
                                      isAllOccurence?(repeatvalue ==
                                          MyStrings.doesNotRepeat
                                          ? dateTime
                                          : days[count]):dateTime)
                                      : DateFormat("dd/MM/yyyy").format(
                                      isAllOccurence?(repeatvalue ==
                                          MyStrings.doesNotRepeat
                                          ? dateTime
                                          : days[count]):dateTime)) + " " +
                                  (timeSwitchValue
                                      ? "TBD"
                                      : DateFormat("h:mma")
                                      .format(time)) +
                                  " at " +
                                  locationDetailsController!.text +
                                  ".")
                                  : ("Game " +
                                  gameNameController!.text +
                                  " is updated by " + userName +
                                  " for the team " + teamName + ", on " +
                                  (dateformat == "US"
                                      ? DateFormat("MM/dd/yyyy").format(
                                      isAllOccurence?(repeatvalue ==
                                          MyStrings.doesNotRepeat
                                          ? dateTime
                                          : days[count]):dateTime)
                                      : dateformat == "CA"
                                      ? DateFormat("yyyy/MM/dd").format(
                                      isAllOccurence?(repeatvalue ==
                                          MyStrings.doesNotRepeat
                                          ? dateTime
                                          : days[count]):dateTime)
                                      : DateFormat("dd/MM/yyyy").format(
                                      isAllOccurence?(repeatvalue ==
                                          MyStrings.doesNotRepeat
                                          ? dateTime
                                          : days[count]):dateTime)) + " " +
                                  (timeSwitchValue
                                      ? "TBD"
                                      : DateFormat("h:mma")
                                      .format(time)) +
                                  " at " +
                                  locationDetailsController!.text +
                                  ".")),
                          "",
                          "",
                          "",
                          "",
                          "",
                          "",
                          "",
                          "",
                          "",
                          "",
                          "",
                          "",
                          "",
                          "",noteSwitchValue);


                      await EmailService().createEventNotification(
                          "" +
                              (editselectSwithValue == false
                                  ? "Updated Event - "
                                  : "Updated Game - ")+
                              gameNameController!.text,
                          gameNameController!.text,
                          Constants.gameOrEventRequest,
                          int.parse(userID),
                          ownerMailList[i].userIDNo!,
                          int.parse(gameResponse.result![a].eventId.toString()),
                          "The " +
                              (editselectSwithValue == false
                                  ? ("Event " +
                                  gameNameController!.text +
                                  " is updated by " + userName +
                                  " for the team " + teamName + ", on " +
                                  (dateformat == "US"
                                      ? DateFormat("MM/dd/yyyy").format(
                                      isAllOccurence?(repeatvalue ==
                                          MyStrings.doesNotRepeat
                                          ? dateTime
                                          : days[count]):dateTime)
                                      : dateformat == "CA"
                                      ? DateFormat("yyyy/MM/dd").format(
                                      isAllOccurence?(repeatvalue ==
                                          MyStrings.doesNotRepeat
                                          ? dateTime
                                          : days[count]):dateTime)
                                      : DateFormat("dd/MM/yyyy").format(
                                      isAllOccurence?(repeatvalue ==
                                          MyStrings.doesNotRepeat
                                          ? dateTime
                                          : days[count]):dateTime)) + " " +
                                  (timeSwitchValue
                                      ? "TBD"
                                      : DateFormat("h:mma")
                                      .format(time)) +
                                  " at " +
                                  locationDetailsController!.text +
                                  ".")
                                  : ("Game " +
                                  gameNameController!.text +
                                  " is updated by " + userName +
                                  " for the team " + teamName + ", on " +
                                  (dateformat == "US"
                                      ? DateFormat("MM/dd/yyyy").format(
                                      isAllOccurence?(repeatvalue ==
                                          MyStrings.doesNotRepeat
                                          ? dateTime
                                          : days[count]):dateTime)
                                      : dateformat == "CA"
                                      ? DateFormat("yyyy/MM/dd").format(
                                      isAllOccurence?(repeatvalue ==
                                          MyStrings.doesNotRepeat
                                          ? dateTime
                                          : days[count]):dateTime)
                                      : DateFormat("dd/MM/yyyy").format(
                                      isAllOccurence?(repeatvalue ==
                                          MyStrings.doesNotRepeat
                                          ? dateTime
                                          : days[count]):dateTime)) + " " +
                                  (timeSwitchValue
                                      ? "TBD"
                                      : DateFormat("h:mma")
                                      .format(time)) +
                                  " at " +
                                  locationDetailsController!.text +
                                  "."))
                          ,
                          ownerMailList[i].email!,
                          ownerMailList[i].name!,
                          (editselectSwithValue == false
                              ? "event, " + gameNameController!
                              .text + " has been updated by " + userName +
                              " for the team, " + teamName + "."
                              : "game, " + gameNameController!.text +
                              " has been updated by " + userName +
                              " for the team, " + teamName + "."),
                          acceptvalue,
                          maybevalue,
                          declainvalue,
                          locationDetailsController!.text,
                          (dateformat == "US"
                              ? DateFormat("MM/dd/yyyy").format(
                              isAllOccurence?(repeatvalue == MyStrings.doesNotRepeat
                                  ? dateTime
                                  : days[count]):dateTime)
                              : dateformat == "CA"
                              ? DateFormat("yyyy/MM/dd").format(
                              isAllOccurence?(repeatvalue == MyStrings.doesNotRepeat
                                  ? dateTime
                                  : days[count]):dateTime)
                              : DateFormat("dd/MM/yyyy").format(
                              isAllOccurence?(repeatvalue == MyStrings.doesNotRepeat
                                  ? dateTime
                                  : days[count]):dateTime)),
                          (timeSwitchValue
                              ? "TBD"
                              : DateFormat("h:mma")
                              .format(time)),
                          signIn!,
                          "",
                          "",
                          "",
                          "",noteSwitchValue

                      );
                    });
                  });
                });
              }
            }
            if (nonPlayerMailList.isNotEmpty) {
              List<String> message = [];
              for (int i = 0; i < nonPlayerMailList.length; i++) {
                String acceptvalue = "",
                    maybevalue = "",
                    declainvalue = "";
                SendPushNotificationService().sendPushNotifications(
                    nonPlayerMailList[i].FCMTokenID ?? "",
                    (editselectSwithValue == false
                        ? "Event"
                        : "Game") +
                        " Notification",
                    "The " +
                        (editselectSwithValue == false
                            ? ("Event " +
                            gameNameController!.text +
                            " is updated by " +
                            userName + " for the team " + teamName + ", on " +
                            (dateformat == "US"
                                ? DateFormat("MM/dd/yyyy").format(
                                isAllOccurence?(repeatvalue ==
                                    MyStrings.doesNotRepeat
                                    ? dateTime
                                    : days[count]):dateTime)
                                : dateformat == "CA"
                                ? DateFormat("yyyy/MM/dd").format(
                                isAllOccurence?(repeatvalue ==
                                    MyStrings.doesNotRepeat
                                    ? dateTime
                                    : days[count]):dateTime)
                                : DateFormat("dd/MM/yyyy").format(
                                isAllOccurence?(repeatvalue ==
                                    MyStrings.doesNotRepeat
                                    ? dateTime
                                    : days[count]):dateTime)) + " " +
                            (timeSwitchValue
                                ? "TBD"
                                : DateFormat("h:mma")
                                .format(time)) +
                            " at " +
                            locationDetailsController!.text +
                            ".")
                            : ("Game " +
                            gameNameController!.text +
                            " is updated by " + userName +
                            " for the team " + teamName +
                            ", on " + (dateformat == "US"
                            ? DateFormat("MM/dd/yyyy").format(
                            isAllOccurence?(repeatvalue ==
                                MyStrings.doesNotRepeat
                                ? dateTime
                                : days[count]):dateTime)
                            : dateformat == "CA"
                            ? DateFormat("yyyy/MM/dd").format(
                            isAllOccurence?(repeatvalue ==
                                MyStrings.doesNotRepeat
                                ? dateTime
                                : days[count]):dateTime)
                            : DateFormat("dd/MM/yyyy").format(
                            isAllOccurence?(repeatvalue ==
                                MyStrings.doesNotRepeat
                                ? dateTime
                                : days[count]):dateTime)) +
                            " " +
                            (timeSwitchValue
                                ? "TBD"
                                : DateFormat("h:mma")
                                .format(time)) +
                            " at " +
                            locationDetailsController!.text +
                            ".")
                        ));

                await DynamicLinksService()
                    .createDynamicLink("splash_Screen?userid=" +
                    nonPlayerMailList[i].userIDNo.toString() +
                    "&refer=" +
                    gameResponse.result![a].eventId.toString() +
                    "&status=2" + "&eventname=" +
                    gameNameController!.text + "&teamname=" +
                    teamName + "&type=" +
                    (editselectSwithValue == false
                        ? "event"
                        : "game") + "&fcm=" + (userFcm != null ? userFcm! : "") +
                    "&name=" + userName + "&mail=" +
                    nonPlayerMailList[i].email! +
                    "&toMail=" + userEmail! + "&toID=" + userID + "&userName=" +
                    nonPlayerMailList[i].name! + "&location=" +
                    locationDetailsController!.text )
                    .then((acceptvalue) async {
                  await DynamicLinksService()
                      .createDynamicLink("splash_Screen?userid=" +
                      nonPlayerMailList[i].userIDNo.toString() +
                      "&refer=" +
                      gameResponse.result![a].eventId.toString() +
                      "&status=3" + "&eventname=" +
                      gameNameController!.text + "&teamname=" +
                      teamName + "&type=" +
                      (editselectSwithValue == false
                          ? "event"
                          : "game") + "&fcm=" +
                      (userFcm != null ? userFcm! : "") + "&name=" + userName +
                      "&mail=" + nonPlayerMailList[i].email! + "&toMail=" +
                      userEmail! +
                      "&toID=" + userID + "&userName=" +
                      nonPlayerMailList[i].name!)
                      .then((declainvalue) async {
                    await DynamicLinksService()
                        .createDynamicLink("splash_Screen?userid=" +
                        nonPlayerMailList[i].userIDNo.toString() +
                        "&refer=" +
                        gameResponse.result![a].eventId.toString() +
                        "&status=4" + "&eventname=" +
                        gameNameController!.text + "&teamname=" +
                        teamName + "&type=" +
                        (editselectSwithValue == false
                            ? "event"
                            : "game") + "&fcm=" +
                        (userFcm != null ? userFcm! : "") + "&name=" + userName +
                        "&mail=" + nonPlayerMailList[i].email! + "&toMail=" +
                        userEmail! +
                        "&toID=" + userID + "&userName=" +
                        nonPlayerMailList[i].name!)
                        .then((maybevalue) async {
                      EmailService().createEventNotification(
                          "",
                          "",
                          Constants.reminder,
                          int.parse(userID),
                          nonPlayerMailList[i].userIDNo!,
                          int.parse(gameResponse.result![a].eventId.toString()),
                          "The " +
                              (editselectSwithValue == false
                                  ? ("Event " +
                                  gameNameController!.text +
                                  " is updated by " + userName +
                                  " for the team " + teamName + ", on " +
                                  (dateformat == "US"
                                      ? DateFormat("MM/dd/yyyy").format(
                                      isAllOccurence?(repeatvalue ==
                                          MyStrings.doesNotRepeat
                                          ? dateTime
                                          : days[count]):dateTime)
                                      : dateformat == "CA"
                                      ? DateFormat("yyyy/MM/dd").format(
                                      isAllOccurence?(repeatvalue ==
                                          MyStrings.doesNotRepeat
                                          ? dateTime
                                          : days[count]):dateTime)
                                      : DateFormat("dd/MM/yyyy").format(
                                      isAllOccurence?(repeatvalue ==
                                          MyStrings.doesNotRepeat
                                          ? dateTime
                                          : days[count]):dateTime)) + " " +
                                  (timeSwitchValue
                                      ? "TBD"
                                      : DateFormat("h:mma")
                                      .format(time)) +
                                  " at " +
                                  locationDetailsController!.text +
                                  ".")
                                  : ("Game " +
                                  gameNameController!.text +
                                  " is updated by " + userName +
                                  " for the team " + teamName + ", on " +
                                  (dateformat == "US"
                                      ? DateFormat("MM/dd/yyyy").format(
                                      isAllOccurence?(repeatvalue ==
                                          MyStrings.doesNotRepeat
                                          ? dateTime
                                          : days[count]):dateTime)
                                      : dateformat == "CA"
                                      ? DateFormat("yyyy/MM/dd").format(
                                      isAllOccurence?(repeatvalue ==
                                          MyStrings.doesNotRepeat
                                          ? dateTime
                                          : days[count]):dateTime)
                                      : DateFormat("dd/MM/yyyy").format(
                                      isAllOccurence?(repeatvalue ==
                                          MyStrings.doesNotRepeat
                                          ? dateTime
                                          : days[count]):dateTime)) + " " +
                                  (timeSwitchValue
                                      ? "TBD"
                                      : DateFormat("h:mma")
                                      .format(time)) +
                                  " at " +
                                  locationDetailsController!.text +
                                  ".")),
                          "",
                          "",
                          "",
                          "",
                          "",
                          "",
                          "",
                          "",
                          "",
                          "",
                          "",
                          "",
                          "",
                          "",noteSwitchValue);


                      await EmailService().createEventNotification(
                          "" +
                              (editselectSwithValue == false
                                  ? "Updated Event - "
                                  : "Updated Game - ") +
                              gameNameController!.text,
                          gameNameController!.text,
                          Constants.gameOrEventRequest,
                          int.parse(userID),
                          nonPlayerMailList[i].userIDNo!,
                          int.parse(gameResponse.result![a].eventId.toString()),
                          "The " +
                              (editselectSwithValue == false
                                  ? ("Event " +
                                  gameNameController!.text +
                                  " is updated by " + userName +
                                  " for the team " + teamName + ", on " +
                                  (dateformat == "US"
                                      ? DateFormat("MM/dd/yyyy").format(
                                      isAllOccurence?(repeatvalue ==
                                          MyStrings.doesNotRepeat
                                          ? dateTime
                                          : days[count]):dateTime)
                                      : dateformat == "CA"
                                      ? DateFormat("yyyy/MM/dd").format(
                                      isAllOccurence?(repeatvalue ==
                                          MyStrings.doesNotRepeat
                                          ? dateTime
                                          : days[count]):dateTime)
                                      : DateFormat("dd/MM/yyyy").format(
                                      isAllOccurence?(repeatvalue ==
                                          MyStrings.doesNotRepeat
                                          ? dateTime
                                          : days[count]):dateTime)) + " " +
                                  (timeSwitchValue
                                      ? "TBD"
                                      : DateFormat("h:mma")
                                      .format(time)) +
                                  " at " +
                                  locationDetailsController!.text +
                                  ".")
                                  : ("Game " +
                                  gameNameController!.text +
                                  " is updated by " + userName +
                                  " for the team " + teamName + ", on " +
                                  (dateformat == "US"
                                      ? DateFormat("MM/dd/yyyy").format(
                                      isAllOccurence?(repeatvalue ==
                                          MyStrings.doesNotRepeat
                                          ? dateTime
                                          : days[count]):dateTime)
                                      : dateformat == "CA"
                                      ? DateFormat("yyyy/MM/dd").format(
                                      isAllOccurence?(repeatvalue ==
                                          MyStrings.doesNotRepeat
                                          ? dateTime
                                          : days[count]):dateTime)
                                      : DateFormat("dd/MM/yyyy").format(
                                      isAllOccurence?(repeatvalue ==
                                          MyStrings.doesNotRepeat
                                          ? dateTime
                                          : days[count]):dateTime)) + " " +
                                  (timeSwitchValue
                                      ? "TBD"
                                      : DateFormat("h:mma")
                                      .format(time)) +
                                  " at " +
                                  locationDetailsController!.text +
                                  "."))
                          ,
                          nonPlayerMailList[i].email!,
                          nonPlayerMailList[i].name!,
                          (editselectSwithValue == false
                              ? "event, " + gameNameController!
                              .text + " has been updated by " + userName +
                              " for the team, " + teamName + "."
                              : "game, " + gameNameController!.text +
                              " has been updated by " + userName +
                              " for the team, " + teamName + "."),
                          acceptvalue,
                          maybevalue,
                          declainvalue,
                          locationDetailsController!.text,
                          (dateformat == "US"
                              ? DateFormat("MM/dd/yyyy").format(
                              isAllOccurence?(repeatvalue == MyStrings.doesNotRepeat
                                  ? dateTime
                                  : days[count]):dateTime)
                              : dateformat == "CA"
                              ? DateFormat("yyyy/MM/dd").format(
                              isAllOccurence?(repeatvalue == MyStrings.doesNotRepeat
                                  ? dateTime
                                  : days[count]):dateTime)
                              : DateFormat("dd/MM/yyyy").format(
                              isAllOccurence?(repeatvalue == MyStrings.doesNotRepeat
                                  ? dateTime
                                  : days[count]):dateTime)),
                          (timeSwitchValue
                              ? "TBD"
                              : DateFormat("h:mma")
                              .format(time)),
                          signIn!,
                          "",
                          "",
                          "",
                          "",noteSwitchValue

                      );
                    });
                  });
                });
              }
            }
          } else {
            if (ownerMailList.isNotEmpty) {
              for (int j = 0; j < ownerMailList.length; j++) {
                SendPushNotificationService().sendPushNotifications(
                    ownerMailList[j].FCMTokenID ?? "",
                    (editselectSwithValue == false
                        ? "Event"
                        : "Game") +
                        " Notification",
                    "The " +
                        (editselectSwithValue == false
                            ? ("Event " +
                            gameNameController!.text +
                            " is updated by " + userName +
                            " for the team " + teamName + ", on " +
                            (dateformat == "US"
                                ? DateFormat("MM/dd/yyyy").format(
                                isAllOccurence?(repeatvalue ==
                                    MyStrings.doesNotRepeat
                                    ? dateTime
                                    : days[count]):dateTime)
                                : dateformat == "CA"
                                ? DateFormat("yyyy/MM/dd").format(
                                isAllOccurence?(repeatvalue ==
                                    MyStrings.doesNotRepeat
                                    ? dateTime
                                    : days[count]):dateTime)
                                : DateFormat("dd/MM/yyyy").format(
                                isAllOccurence?(repeatvalue ==
                                    MyStrings.doesNotRepeat
                                    ? dateTime
                                    : days[count]):dateTime)) +
                            " " + (timeSwitchValue
                            ? "TBD"
                            : DateFormat("h:mma")
                            .format(time)) + " at " +
                            locationDetailsController!.text +
                            ".")
                            : ("Game " +
                            gameNameController!.text +
                            " (Game Number " + gameResponse.result![a].eventId.toString() +
                            ") is updated by " + userName +
                            " for the team " + teamName + ", on " +
                            (dateformat == "US"
                                ? DateFormat("MM/dd/yyyy").format(
                                isAllOccurence?(repeatvalue ==
                                    MyStrings.doesNotRepeat
                                    ? dateTime
                                    : days[count]):dateTime)
                                : dateformat == "CA"
                                ? DateFormat("yyyy/MM/dd").format(
                                isAllOccurence?(repeatvalue ==
                                    MyStrings.doesNotRepeat
                                    ? dateTime
                                    : days[count]):dateTime)
                                : DateFormat("dd/MM/yyyy").format(
                                isAllOccurence?(repeatvalue ==
                                    MyStrings.doesNotRepeat
                                    ? dateTime
                                    : days[count]):dateTime)) + " " +
                            (timeSwitchValue
                                ? "TBD"
                                : DateFormat("h:mma")
                                .format(time)) +
                            " at " +
                            locationDetailsController!.text +
                            "."))
                );
                await EmailService().createEventNotification(
                    "",
                    "",
                    Constants.reminder,
                    int.parse(userID),
                    ownerMailList[j].userIDNo!,
                    int.parse(gameResponse.result![a].eventId.toString()),
                    "The " +
                        (editselectSwithValue == false
                            ? ("Event " +
                            gameNameController!.text +
                            " is updated by " + userName + " for the team " +
                            teamName + ", on " + (dateformat == "US"
                            ? DateFormat("MM/dd/yyyy").format(
                            isAllOccurence?(repeatvalue ==
                                MyStrings.doesNotRepeat
                                ? dateTime
                                : days[count]):dateTime)
                            : dateformat == "CA"
                            ? DateFormat("yyyy/MM/dd").format(
                            isAllOccurence?(repeatvalue ==
                                MyStrings.doesNotRepeat
                                ? dateTime
                                : days[count]):dateTime)
                            : DateFormat("dd/MM/yyyy").format(
                            isAllOccurence?(repeatvalue ==
                                MyStrings.doesNotRepeat
                                ? dateTime
                                : days[count]):dateTime)) +
                            " " +
                            (timeSwitchValue
                                ? "TBD"
                                : DateFormat("h:mma")
                                .format(time)) + " at " +
                            locationDetailsController!.text +
                            ".")
                            : ("Game " +
                            gameNameController!.text +
                            " (Game Number " + gameResponse.result![a].eventId.toString() +
                            ") is updated by " + userName +
                            " for the team " + teamName + ", on " +
                            (dateformat == "US"
                                ? DateFormat("MM/dd/yyyy").format(
                                isAllOccurence?(repeatvalue ==
                                    MyStrings.doesNotRepeat
                                    ? dateTime
                                    : days[count]):dateTime)
                                : dateformat == "CA"
                                ? DateFormat("yyyy/MM/dd").format(
                                isAllOccurence?(repeatvalue ==
                                    MyStrings.doesNotRepeat
                                    ? dateTime
                                    : days[count]):dateTime)
                                : DateFormat("dd/MM/yyyy").format(
                                isAllOccurence?(repeatvalue ==
                                    MyStrings.doesNotRepeat
                                    ? dateTime
                                    : days[count]):dateTime)) +
                            " " + (timeSwitchValue
                            ? "TBD"
                            : DateFormat("h:mma")
                            .format(time)) + " at " +
                            locationDetailsController!.text +
                            ".")),
                    "",
                    "",
                    "",
                    "",
                    "",
                    "",
                    "",
                    "",
                    "",
                    "",
                    "",
                    "",
                    "",
                    "",noteSwitchValue);

                if (editselectSwithValue == true) {
                  await EmailService().createEventNotification(
                      "" +
                          (editselectSwithValue == false
                              ? "Updated Event - "
                              : "Updated Game - ") +
                          gameNameController!.text,
                      gameNameController!.text,
                      Constants.createGameOrEvent,
                      int.parse(userID),
                      ownerMailList[j].userIDNo!,
                      int.parse(gameResponse.result![a].eventId.toString()),
                      "The " +
                          (("Game " +
                              gameNameController!.text +
                              " (Game Number " +
                              gameResponse.result![a].eventId.toString() +
                              ") is updated by " + userName +
                              " for the team " + teamName + ", on " +
                              (dateformat == "US"
                                  ? DateFormat("MM/dd/yyyy").format(
                                  isAllOccurence?(repeatvalue ==
                                      MyStrings.doesNotRepeat
                                      ? dateTime
                                      : days[count]):dateTime)
                                  : dateformat == "CA"
                                  ? DateFormat("yyyy/MM/dd").format(
                                  isAllOccurence?(repeatvalue ==
                                      MyStrings.doesNotRepeat
                                      ? dateTime
                                      : days[count]):dateTime)
                                  : DateFormat("dd/MM/yyyy").format(
                                  isAllOccurence?(repeatvalue ==
                                      MyStrings.doesNotRepeat
                                      ? dateTime
                                      : days[count]):dateTime)) +
                              " " + (timeSwitchValue
                              ? "TBD"
                              : DateFormat("h:mma")
                              .format(time)) + " at " +
                              locationDetailsController!.text +
                              "."))
                      ,
                      ownerMailList[j].email!,
                      ownerMailList[j].name!,
                      (editselectSwithValue == false
                          ? "event, " +
                          gameNameController!.text +
                          " has been updated by " + userName +
                          " for the team, " + teamName + "."
                          : "game, " +
                          gameNameController!.text +
                          " has been updated by " + userName +
                          " for the team, " + teamName + "."),
                      "",
                      "",
                      "",
                      locationDetailsController!.text,
                      (dateformat == "US"
                          ? DateFormat("MM/dd/yyyy").format(
                          isAllOccurence?( repeatvalue ==
                              MyStrings.doesNotRepeat ? dateTime : days[count]):dateTime)
                          : dateformat == "CA"
                          ? DateFormat("yyyy/MM/dd").format(
                          isAllOccurence?(repeatvalue ==
                              MyStrings.doesNotRepeat ? dateTime : days[count]):dateTime)
                          : DateFormat("dd/MM/yyyy").format(
                          isAllOccurence?(repeatvalue ==
                              MyStrings.doesNotRepeat
                              ? dateTime
                              : days[count]):dateTime)),
                      timeSwitchValue
                          ? "TBD"
                          : DateFormat("h:mma")
                          .format(time),
                      signIn!,
                      gameResponse.result![a].eventId.toString(),
                      "",
                      "",
                      "",noteSwitchValue


                  );
                } else {
                  await EmailService().createEventNotification(
                      "" +
                          (editselectSwithValue == false
                              ? "Updated Event - "
                              : "Updated Game - ") +
                          gameNameController!.text,
                      gameNameController!.text,
                      Constants.createGameOrEvent,
                      int.parse(userID),
                      ownerMailList[j].userIDNo!,
                      int.parse(gameResponse.result![a].eventId.toString()),
                      "The " +
                          ("Event " +
                              gameNameController!.text +
                              " is updated by " + userName +
                              " for the team " +
                              teamName + ", on " + (dateformat == "US"
                              ? DateFormat("MM/dd/yyyy").format(
                              isAllOccurence?(repeatvalue ==
                                  MyStrings.doesNotRepeat
                                  ? dateTime
                                  : days[count]):dateTime)
                              : dateformat == "CA"
                              ? DateFormat("yyyy/MM/dd").format(
                              isAllOccurence?(repeatvalue ==
                                  MyStrings.doesNotRepeat
                                  ? dateTime
                                  : days[count]):dateTime)
                              : DateFormat("dd/MM/yyyy").format(
                              isAllOccurence?(repeatvalue ==
                                  MyStrings.doesNotRepeat
                                  ? dateTime
                                  : days[count]):dateTime)) + " " +
                              (timeSwitchValue
                                  ? "TBD"
                                  : DateFormat("h:mma")
                                  .format(time)) + " at " +
                              locationDetailsController!.text +
                              "."),
                      ownerMailList[j].email!,
                      ownerMailList[j].name!,
                      (editselectSwithValue == false
                          ? "A new event, " +
                          gameNameController!.text +
                          " has been updated by " + userName +
                          " for the team, " + teamName + "."
                          : "A new game, " +
                          gameNameController!.text +
                          " has been updated by " + userName +
                          " for the team, " + teamName + "."),
                      "",
                      "",
                      "",
                      locationDetailsController!.text,
                      (dateformat == "US"
                          ? DateFormat("MM/dd/yyyy").format(
                          isAllOccurence?(repeatvalue ==
                              MyStrings.doesNotRepeat ? dateTime : days[count]):dateTime)
                          : dateformat == "CA"
                          ? DateFormat("yyyy/MM/dd").format(
                          isAllOccurence?(repeatvalue ==
                              MyStrings.doesNotRepeat ? dateTime : days[count]):dateTime)
                          : DateFormat("dd/MM/yyyy").format(
                          isAllOccurence?(repeatvalue ==
                              MyStrings.doesNotRepeat
                              ? dateTime
                              : days[count]):dateTime)),
                      (timeSwitchValue
                          ? "TBD"
                          : DateFormat("h:mma")
                          .format(time)),
                      signIn!,
                      "",
                      "",
                      "",
                      "",noteSwitchValue
                  );
                }
              }
            }
            if (nonPlayerMailList.isNotEmpty) {
              for (int j = 0; j < nonPlayerMailList.length; j++) {
                SendPushNotificationService().sendPushNotifications(
                    nonPlayerMailList[j].FCMTokenID ?? "",
                    (editselectSwithValue == false
                        ? "Event"
                        : "Game") +
                        " Notification",
                    "The " +
                        (editselectSwithValue == false
                            ? ("Event " +
                            gameNameController!.text +
                            " is updated by " + userName +
                            " for the team " +
                            teamName + ", on " + (dateformat == "US"
                            ? DateFormat("MM/dd/yyyy").format(
                            isAllOccurence?(repeatvalue ==
                                MyStrings.doesNotRepeat
                                ? dateTime
                                : days[count]):dateTime)
                            : dateformat == "CA"
                            ? DateFormat("yyyy/MM/dd").format(
                            isAllOccurence?(repeatvalue ==
                                MyStrings.doesNotRepeat
                                ? dateTime
                                : days[count]):dateTime)
                            : DateFormat("dd/MM/yyyy").format(
                            isAllOccurence?(repeatvalue ==
                                MyStrings.doesNotRepeat
                                ? dateTime
                                : days[count]):dateTime)) +
                            " " + (timeSwitchValue
                            ? "TBD"
                            : DateFormat("h:mma")
                            .format(time)) + " at " +
                            locationDetailsController!.text +
                            ". Join with the team and show your support.")
                            : ("Game " +
                            gameNameController!.text +
                            " is updated by " + userName +
                            " for the team " +
                            teamName + ", on " + (dateformat == "US"
                            ? DateFormat("MM/dd/yyyy").format(
                            isAllOccurence?(repeatvalue ==
                                MyStrings.doesNotRepeat
                                ? dateTime
                                : days[count]):dateTime)
                            : dateformat == "CA"
                            ? DateFormat("yyyy/MM/dd").format(
                            isAllOccurence?(repeatvalue ==
                                MyStrings.doesNotRepeat
                                ? dateTime
                                : days[count]):dateTime)
                            : DateFormat("dd/MM/yyyy").format(
                            isAllOccurence?(repeatvalue ==
                                MyStrings.doesNotRepeat
                                ? dateTime
                                : days[count]):dateTime)) +
                            " " + (timeSwitchValue
                            ? "TBD"
                            : DateFormat("h:mma")
                            .format(time)) + " at " +
                            locationDetailsController!.text +
                            ". Join with the team and show your support.")
                        ));

                await EmailService().createEventNotification(
                    "",
                    "",
                    Constants.reminder,
                    int.parse(userID),
                    nonPlayerMailList[j].userIDNo!,
                    int.parse(gameResponse.result![a].eventId.toString()),
                    "The " +
                        (editselectSwithValue == false
                            ? ("Event " +
                            gameNameController!.text +
                            " is updated by " + userName +
                            " for the team " +
                            teamName + ", on " + (dateformat == "US"
                            ? DateFormat("MM/dd/yyyy").format(
                            isAllOccurence?(repeatvalue ==
                                MyStrings.doesNotRepeat
                                ? dateTime
                                : days[count]):dateTime)
                            : dateformat == "CA"
                            ? DateFormat("yyyy/MM/dd").format(
                            isAllOccurence?(repeatvalue ==
                                MyStrings.doesNotRepeat
                                ? dateTime
                                : days[count]):dateTime)
                            : DateFormat("dd/MM/yyyy").format(
                            isAllOccurence?(repeatvalue ==
                                MyStrings.doesNotRepeat
                                ? dateTime
                                : days[count]):dateTime)) +
                            " " + (timeSwitchValue
                            ? "TBD"
                            : DateFormat("h:mma")
                            .format(time)) + " at " +
                            locationDetailsController!.text +
                            ". Join with the team and show your support.")
                            : ("Game " +
                            gameNameController!.text +
                            " is updated by " + userName +
                            " for the team " +
                            teamName + ", on " + (dateformat == "US"
                            ? DateFormat("MM/dd/yyyy").format(
                            isAllOccurence?(repeatvalue ==
                                MyStrings.doesNotRepeat
                                ? dateTime
                                : days[count]):dateTime)
                            : dateformat == "CA"
                            ? DateFormat("yyyy/MM/dd").format(
                            isAllOccurence?(repeatvalue ==
                                MyStrings.doesNotRepeat
                                ? dateTime
                                : days[count]):dateTime)
                            : DateFormat("dd/MM/yyyy").format(
                            isAllOccurence?(repeatvalue ==
                                MyStrings.doesNotRepeat
                                ? dateTime
                                : days[count]):dateTime)) +
                            " " + (timeSwitchValue
                            ? "TBD"
                            : DateFormat("h:mma")
                            .format(time)) + " at " +
                            locationDetailsController!.text +
                            ". Join with the team and show your support.")
                        ),
                    "",
                    "",
                    "",
                    "",
                    "",
                    "",
                    "",
                    "",
                    "",
                    "",
                    "",
                    "",
                    "",
                    "",noteSwitchValue);
                await EmailService().createEventNotification(
                    "" +
                        (editselectSwithValue == false
                            ? "Updated Event - "
                            : "Updated Game - ") +
                        gameNameController!.text,
                    gameNameController!.text,
                    Constants.gameOrEventInfo,
                    int.parse(userID),
                    nonPlayerMailList[j].userIDNo!,
                    int.parse(gameResponse.result![a].eventId.toString()),
                    "The " +
                        (editselectSwithValue == false
                            ? ("Event " +
                            gameNameController!.text +
                            " is updated by " + userName +
                            " for the team " +
                            teamName + ", on " + (dateformat == "US"
                            ? DateFormat("MM/dd/yyyy").format(
                            isAllOccurence?(repeatvalue ==
                                MyStrings.doesNotRepeat
                                ? dateTime
                                : days[count]):dateTime)
                            : dateformat == "CA"
                            ? DateFormat("yyyy/MM/dd").format(
                            isAllOccurence?(repeatvalue ==
                                MyStrings.doesNotRepeat
                                ? dateTime
                                : days[count]):dateTime)
                            : DateFormat("dd/MM/yyyy").format(
                            isAllOccurence?(repeatvalue ==
                                MyStrings.doesNotRepeat
                                ? dateTime
                                : days[count]):dateTime)) +
                            " " + (timeSwitchValue
                            ? "TBD"
                            : DateFormat("h:mma")
                            .format(time)) + " at " +
                            locationDetailsController!.text +
                            ". Join with the team and show your support.")
                            : ("Game " +
                            gameNameController!.text +
                            " is updated by " + userName +
                            " for the team " +
                            teamName + ", on " + (dateformat == "US"
                            ? DateFormat("MM/dd/yyyy").format(
                            isAllOccurence?(repeatvalue ==
                                MyStrings.doesNotRepeat
                                ? dateTime
                                : days[count]):dateTime)
                            : dateformat == "CA"
                            ? DateFormat("yyyy/MM/dd").format(
                            isAllOccurence?(repeatvalue ==
                                MyStrings.doesNotRepeat
                                ? dateTime
                                : days[count]):dateTime)
                            : DateFormat("dd/MM/yyyy").format(
                            isAllOccurence?(repeatvalue ==
                                MyStrings.doesNotRepeat
                                ? dateTime
                                : days[count]):dateTime)) +
                            " " + (timeSwitchValue
                            ? "TBD"
                            : DateFormat("h:mma")
                            .format(time)) + " at " +
                            locationDetailsController!.text +
                            ". Join with the team and show your support.")
                        ),
                    nonPlayerMailList[j].email!,
                    nonPlayerMailList[j].name!,
                    (editselectSwithValue == false
                        ? "A new event, " +
                        gameNameController!.text +
                        " has been updated by " + userName +
                        " for the team, " + teamName + "."
                        : "A new game, " +
                        gameNameController!.text +
                        " has been updated by " + userName +
                        " for the team, " + teamName + "."),
                    "",
                    "",
                    "",
                    locationDetailsController!.text,
                    (dateformat == "US"
                        ? DateFormat("MM/dd/yyyy").format(
                        isAllOccurence?(repeatvalue == MyStrings.doesNotRepeat
                            ? dateTime
                            : days[count]):dateTime)
                        : dateformat == "CA"
                        ? DateFormat("yyyy/MM/dd").format(
                        isAllOccurence?(repeatvalue == MyStrings.doesNotRepeat
                            ? dateTime
                            : days[count]):dateTime)
                        : DateFormat("dd/MM/yyyy").format(
                        isAllOccurence?( repeatvalue == MyStrings.doesNotRepeat
                            ? dateTime
                            : days[count]):dateTime)),
                    (timeSwitchValue
                        ? "TBD"
                        : DateFormat("h:mma")
                        .format(time)),
                    signIn!,
                    "",
                    "",
                    "",
                    "",noteSwitchValue

                );
              }
            }
            if (playerMailList.isNotEmpty) {
              for (int i = 0; i < playerMailList.length; i++) {
                String acceptvalue = "",
                    maybevalue = "",
                    declainvalue = "";
                SendPushNotificationService().sendPushNotifications(
                    playerMailList[i].FCMTokenID ?? "",
                    (editselectSwithValue == false
                        ? "Event"
                        : "Game") +
                        " Notification",
                    "The " +
                        (editselectSwithValue == false
                            ? ("Event " +
                            gameNameController!.text +
                            " is updated by " +
                            userName + " for the team " + teamName + ", on " +
                            (dateformat == "US"
                                ? DateFormat("MM/dd/yyyy").format(
                                isAllOccurence?(repeatvalue ==
                                    MyStrings.doesNotRepeat
                                    ? dateTime
                                    : days[count]):dateTime)
                                : dateformat == "CA"
                                ? DateFormat("yyyy/MM/dd").format(
                                isAllOccurence?(repeatvalue ==
                                    MyStrings.doesNotRepeat
                                    ? dateTime
                                    : days[count]):dateTime)
                                : DateFormat("dd/MM/yyyy").format(
                                isAllOccurence?(repeatvalue ==
                                    MyStrings.doesNotRepeat
                                    ? dateTime
                                    : days[count]):dateTime)) + " " +
                            (timeSwitchValue
                                ? "TBD"
                                : DateFormat("h:mma")
                                .format(time)) +
                            " at " +
                            locationDetailsController!.text +
                            ".")
                            : ("Game " +
                            gameNameController!.text +
                            " is updated by " + userName +
                            " for the team " + teamName +
                            ", on " + (dateformat == "US"
                            ? DateFormat("MM/dd/yyyy").format(
                            isAllOccurence?(repeatvalue ==
                                MyStrings.doesNotRepeat
                                ? dateTime
                                : days[count]):dateTime)
                            : dateformat == "CA"
                            ? DateFormat("yyyy/MM/dd").format(
                            isAllOccurence?(repeatvalue ==
                                MyStrings.doesNotRepeat
                                ? dateTime
                                : days[count]):dateTime)
                            : DateFormat("dd/MM/yyyy").format(
                            isAllOccurence?(repeatvalue ==
                                MyStrings.doesNotRepeat
                                ? dateTime
                                : days[count]):dateTime)) +
                            " " +
                            (timeSwitchValue
                                ? "TBD"
                                : DateFormat("h:mma")
                                .format(time)) +
                            " at " +
                            locationDetailsController!.text +
                            ".")
                        ));

                await DynamicLinksService()
                    .createDynamicLink("splash_Screen?userid=" +
                    playerMailList[i].userIDNo.toString() +
                    "&refer=" +
                    gameResponse.result![a].eventId.toString() +
                    "&status=2" + "&eventname=" +
                    gameNameController!.text + "&teamname=" +
                    teamName + "&type=" +
                    (editselectSwithValue == false
                        ? "event"
                        : "game") + "&fcm=" + (userFcm != null ? userFcm! : "") +
                    "&name=" + userName + "&mail=" + playerMailList[i].email! +
                    "&toMail=" + userEmail! + "&toID=" + userID + "&userName=" +
                    playerMailList[i].name! + "&location=" +
                    locationDetailsController!.text )
                    .then((acceptvalue) async {
                  await DynamicLinksService()
                      .createDynamicLink("splash_Screen?userid=" +
                      playerMailList[i].userIDNo.toString() +
                      "&refer=" +
                      gameResponse.result![a].eventId.toString() +
                      "&status=3" + "&eventname=" +
                      gameNameController!.text + "&teamname=" +
                      teamName + "&type=" +
                      (editselectSwithValue == false
                          ? "event"
                          : "game") + "&fcm=" +
                      (userFcm != null ? userFcm! : "") + "&name=" + userName +
                      "&mail=" + playerMailList[i].email! + "&toMail=" +
                      userEmail! +
                      "&toID=" + userID + "&userName=" + playerMailList[i].name!)
                      .then((declainvalue) async {
                    await DynamicLinksService()
                        .createDynamicLink("splash_Screen?userid=" +
                        playerMailList[i].userIDNo.toString() +
                        "&refer=" +
                        gameResponse.result![a].eventId.toString() +
                        "&status=4" + "&eventname=" +
                        gameNameController!.text + "&teamname=" +
                        teamName + "&type=" +
                        (editselectSwithValue == false
                            ? "event"
                            : "game") + "&fcm=" +
                        (userFcm != null ? userFcm! : "") + "&name=" + userName +
                        "&mail=" + playerMailList[i].email! + "&toMail=" +
                        userEmail! +
                        "&toID=" + userID + "&userName=" +
                        playerMailList[i].name!)
                        .then((maybevalue) {
                      EmailService().createEventNotification(
                          "",
                          "",
                          Constants.reminder,
                          int.parse(userID),
                          playerMailList[i].userIDNo!,
                          int.parse(gameResponse.result![a].eventId.toString()),
                          "The " +
                              (editselectSwithValue == false
                                  ? ("Event " +
                                  gameNameController!.text +
                                  " is updated by " + userName +
                                  " for the team " + teamName + ", on " +
                                  (dateformat == "US"
                                      ? DateFormat("MM/dd/yyyy").format(
                                      isAllOccurence?(repeatvalue ==
                                          MyStrings.doesNotRepeat
                                          ? dateTime
                                          : days[count]):dateTime)
                                      : dateformat == "CA"
                                      ? DateFormat("yyyy/MM/dd").format(
                                      isAllOccurence?( repeatvalue ==
                                          MyStrings.doesNotRepeat
                                          ? dateTime
                                          : days[count]):dateTime)
                                      : DateFormat("dd/MM/yyyy").format(
                                      isAllOccurence?(repeatvalue ==
                                          MyStrings.doesNotRepeat
                                          ? dateTime
                                          : days[count]):dateTime)) + " " +
                                  (timeSwitchValue
                                      ? "TBD"
                                      : DateFormat("h:mma")
                                      .format(time)) +
                                  " at " +
                                  locationDetailsController!.text +
                                  ".")
                                  : ("Game " +
                                  gameNameController!.text +
                                  " is updated by " + userName +
                                  " for the team " + teamName + ", on " +
                                  (dateformat == "US"
                                      ? DateFormat("MM/dd/yyyy").format(
                                      isAllOccurence?(repeatvalue ==
                                          MyStrings.doesNotRepeat
                                          ? dateTime
                                          : days[count]):dateTime)
                                      : dateformat == "CA"
                                      ? DateFormat("yyyy/MM/dd").format(
                                      isAllOccurence?(repeatvalue ==
                                          MyStrings.doesNotRepeat
                                          ? dateTime
                                          : days[count]):dateTime)
                                      : DateFormat("dd/MM/yyyy").format(
                                      isAllOccurence?(repeatvalue ==
                                          MyStrings.doesNotRepeat
                                          ? dateTime
                                          : days[count]):dateTime)) + " " +
                                  (timeSwitchValue
                                      ? "TBD"
                                      : DateFormat("h:mma")
                                      .format(time)) +
                                  " at " +
                                  locationDetailsController!.text +
                                  ".")),
                          "",
                          "",
                          "",
                          "",
                          "",
                          "",
                          "",
                          "",
                          "",
                          "",
                          "",
                          "",
                          "",
                          "",noteSwitchValue);


                      playerEventNotification(
                          "" +
                              (editselectSwithValue == false
                                  ? "Updated Event - "
                                  : "Updated Game - ")+
                              gameNameController!.text,
                          gameNameController!.text,
                          Constants.gameOrEventRequest,
                          int.parse(gameResponse.result![a].eventId.toString()),
                          "The " +
                              (editselectSwithValue == false
                                  ? ("Event " +
                                  gameNameController!.text +
                                  " is updated by " + userName +
                                  " for the team " + teamName + ", on " +
                                  (dateformat == "US"
                                      ? DateFormat("MM/dd/yyyy").format(
                                      isAllOccurence?(repeatvalue ==
                                          MyStrings.doesNotRepeat
                                          ? dateTime
                                          : days[count]):dateTime)
                                      : dateformat == "CA"
                                      ? DateFormat("yyyy/MM/dd").format(
                                      isAllOccurence?(repeatvalue ==
                                          MyStrings.doesNotRepeat
                                          ? dateTime
                                          : days[count]):dateTime)
                                      : DateFormat("dd/MM/yyyy").format(
                                      isAllOccurence?(repeatvalue ==
                                          MyStrings.doesNotRepeat
                                          ? dateTime
                                          : days[count]):dateTime)) + " " +
                                  (timeSwitchValue
                                      ? "TBD"
                                      : DateFormat("h:mma")
                                      .format(time)) +
                                  " at " +
                                  locationDetailsController!.text +
                                  ".")
                                  : ("Game " +
                                  gameNameController!.text +
                                  " is updated by " + userName +
                                  " for the team " + teamName + ", on " +
                                  (dateformat == "US"
                                      ? DateFormat("MM/dd/yyyy").format(
                                      isAllOccurence?(repeatvalue ==
                                          MyStrings.doesNotRepeat
                                          ? dateTime
                                          : days[count]):dateTime)
                                      : dateformat == "CA"
                                      ? DateFormat("yyyy/MM/dd").format(
                                      isAllOccurence?(repeatvalue ==
                                          MyStrings.doesNotRepeat
                                          ? dateTime
                                          : days[count]):dateTime)
                                      : DateFormat("dd/MM/yyyy").format(
                                      isAllOccurence?(repeatvalue ==
                                          MyStrings.doesNotRepeat
                                          ? dateTime
                                          : days[count]):dateTime)) + " " +
                                  (timeSwitchValue
                                      ? "TBD"
                                      : DateFormat("h:mma")
                                      .format(time)) +
                                  " at " +
                                  locationDetailsController!.text +
                                  "."))
                          ,
                          playerMailList[i].userIDNo!,
                          playerMailList[i].email!,
                          noteSwitchValue,
                          playerMailList[i].name!,
                          (editselectSwithValue == false
                              ? "event, " + gameNameController!
                              .text + " has been updated by " + userName +
                              " for the team, " + teamName + "."
                              : "game, " + gameNameController!.text +
                              " has been updated by " + userName +
                              " for the team, " + teamName + "."),
                          acceptvalue,
                          maybevalue,
                          declainvalue,
                          locationDetailsController!.text,
                          (dateformat == "US"
                              ? DateFormat("MM/dd/yyyy").format(
                              isAllOccurence?(repeatvalue == MyStrings.doesNotRepeat
                                  ? dateTime
                                  : days[count]):dateTime)
                              : dateformat == "CA"
                              ? DateFormat("yyyy/MM/dd").format(
                              isAllOccurence?(repeatvalue == MyStrings.doesNotRepeat
                                  ? dateTime
                                  : days[count]):dateTime)
                              : DateFormat("dd/MM/yyyy").format(
                              isAllOccurence?(repeatvalue == MyStrings.doesNotRepeat
                                  ? dateTime
                                  : days[count]):dateTime)),
                          (timeSwitchValue
                              ? "TBD"
                              : DateFormat("h:mma")
                              .format(time)),
                          signIn!


                      );
                    });
                  });
                });
              }
            }
          }


          count++;
        } catch (e) {
          listener.onSuccess(gameResponse, reqId: ResponseIds.ADD_GAME);

          // listener.onFailure(ExceptionErrorUtil.handleErrors(e));
        }
      }
    }
    // ValidateUserResponse _response =
    // ValidateUserResponse.fromJson(response.data);
    // listener.onSuccess(_response, reqId: ResponseIds.ADD_GAME);
  }

  Future playerEventNotification(String subject,
      String title,
      int notificationID,
      int referencetableID,
      String content,
      int userId,
      String email,
      bool noteSwitchValue,
      String coachName,
      String gameTitle,
      String acceptLink,
      String maybeLink,
      String declineLink,
      String address,
      String date,
      String time,
      String signin,) async {
    try {
      EventPlayerNotificationRequest _sendEmail =
      EventPlayerNotificationRequest();
      _sendEmail.eventId = referencetableID;
      List<NotificationMailList> notificationMailList = [];
      NotificationMailList _notificationList = NotificationMailList();
      _notificationList.notificationTypeID = notificationID;
      _notificationList.subject = subject;
      _notificationList.title = title;
      _notificationList.referenceTableId = referencetableID;
      _notificationList.contentText = content;
      _notificationList.recipientId = userId;
      _notificationList.senderId = int.parse(
          "${await SharedPrefManager.instance.getStringAsync(
              Constants.userIdNo)}");
      _notificationList.to = email;
      _notificationList.isNotesRequired = noteSwitchValue ? 1 : 0;
      _notificationList.coachName = coachName;
      _notificationList.gameTitle = gameTitle;
      _notificationList.acceptLink = acceptLink;
      _notificationList.maybeLink = maybeLink;
      _notificationList.declineLink = declineLink;
      _notificationList.address = address;
      _notificationList.date = date;
      _notificationList.time = time;
      _notificationList.signin = signin;
      notificationMailList.add(_notificationList);
      _sendEmail.notificationMailList = notificationMailList;


      await ApiManager()
          .getDio()!
          .post(Endpoints.serverGameUrl + Endpoints.sendEventNotificationMail,
          data: _sendEmail)
          .then((response) => registerEmailResponse(response))
          .catchError((onError) {
        print(onError);

        //  listener.onFailure(DioErrorUtil.handleErrors(onError));
      });
    } catch (e) {
      print(e);
      //  listener.onFailure(ExceptionErrorUtil.handleErrors(e));
    }
  }

  void registerEmailResponse(Response response) {
    ValidateUserResponse _response =
    ValidateUserResponse.fromJson(response.data);
    //  listener.onSuccess(_response, reqId: ResponseIds.SEND_EMAIL);
  }


  Future volunteerInviteNotification(String subject,
      String title,
      int notificationID,
      int referencetableID,
      String content,
      int userId,
      String email,
      bool noteSwitchValue,
      String coachName,
      String teamname,
      String volunteer,
      int eventVoluenteerTypeIDNo,
      int volunteerTypeId,
      String gameTitle,
      String acceptLink,
      String maybeLink,
      String declineLink,
      String address,
      String date,
      String time,
      String signin,) async {
    try {
      EventPlayerNotificationRequest _sendEmail =
      EventPlayerNotificationRequest();
      _sendEmail.eventId = referencetableID;
      List<NotificationMailList> notificationMailList = [];
      NotificationMailList _notificationList = NotificationMailList();
      _notificationList.notificationTypeID = notificationID;
      _notificationList.subject = subject;
      _notificationList.title = title;
      _notificationList.referenceTableId = referencetableID;
      _notificationList.contentText = content;
      _notificationList.recipientId = userId;
      _notificationList.senderId = int.parse(
          "${await SharedPrefManager.instance.getStringAsync(
              Constants.userIdNo)}");
      _notificationList.to = email;
      _notificationList.isNotesRequired = noteSwitchValue ? 1 : 0;
      _notificationList.coachName = coachName;
      _notificationList.teamName = teamName;
      _notificationList.volunteer = volunteer;
      _notificationList.gameTitle = gameTitle;
      _notificationList.acceptLink = acceptLink;
      _notificationList.maybeLink = maybeLink;
      _notificationList.declineLink = declineLink;
      _notificationList.address = address;
      _notificationList.date = date;
      _notificationList.time = time;
      _notificationList.signin = signin;
      _notificationList.volunteerTypeName = volunteer;
      _notificationList.volunteerTypeId = volunteerTypeId.toString();
      _notificationList.eventVoluenteerTypeIDNo =
          eventVoluenteerTypeIDNo.toString();
      _notificationList.eventId = referencetableID.toString();
      notificationMailList.add(_notificationList);
      _sendEmail.notificationMailList = notificationMailList;


      await ApiManager()
          .getDio()!
          .post(Endpoints.serverGameUrl + Endpoints.volunteerInvite,
          data: _sendEmail)
          .then((response) => registerEmailResponse(response))
          .catchError((onError) {
        print(onError);

        //  listener.onFailure(DioErrorUtil.handleErrors(onError));
      });
    } catch (e) {
      print(e);
      //  listener.onFailure(ExceptionErrorUtil.handleErrors(e));
    }
  }


  void setRefreshScreen() {
    listener.onRefresh("");
  }

  bool? get getAutoValidate => _autoValidate;



}

import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spaid/base/base_provider.dart';
import 'package:spaid/model/request/create_team_request/create_team_request.dart';
import 'package:spaid/model/request/game_event_request/add_opponent_request.dart';
import 'package:spaid/model/request/game_event_request/game_player_notification_request.dart';
import 'package:spaid/model/request/game_event_request/opponent_request.dart';
import 'package:spaid/model/request/game_event_request/update_volunteer_job.dart';
import 'package:spaid/model/request/select_team_request/select_team_request.dart';
import 'package:spaid/model/response/create_team_response/create_team_response.dart';
import 'package:spaid/model/response/game_event_response/add_game_response.dart';
import 'package:spaid/model/response/game_event_response/game_availablity_response.dart';
import 'package:spaid/model/response/game_event_response/game_team_response.dart';
import 'package:spaid/model/response/game_event_response/game_volunteers_response.dart' as g;
import 'package:spaid/model/response/game_event_response/opponent_response.dart';
import 'package:spaid/model/response/game_event_response/player_email_list_response.dart';
import 'package:spaid/model/response/game_event_response/volunteer_response.dart';
import 'package:spaid/model/response/roaster_listview_response/roaster_listview_response.dart';
import 'package:spaid/model/response/signup_response/validate_user_response.dart';
import 'package:spaid/service/api_manager.dart';
import 'package:spaid/service/dio_error_util.dart';
import 'package:spaid/service/endpoints.dart';
import 'package:spaid/service/exception_error_util.dart';
import 'package:spaid/service/firebase_dynamic_link_service.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/support/response_ids.dart';
import 'package:spaid/support/strings.dart';
import 'package:spaid/utils/shared_pref_manager.dart';
import 'package:spaid/widgets/ProgressBar.dart';

class VolunteerProvider extends BaseProvider {
  SelectTeamRequest? _selectTeamRequest;
  List<List<TextEditingController>> volunteerPlayernamecontroller = [];
  List<TextEditingController> volunteerNameController = [];
  List<TextEditingController> eventVoluenteerTypeIDNo = [];
  List<TextEditingController> volunteerIDController = [];
  List<TextEditingController> volunteerCheckBoxController = [];
  g.GetEventVoluenteers? _getEventVoluenteers;
  g.GetEventVoluenteers? _putEventVoluenteers;
  List<g.VolunteerList> volunteerList=[];
  List<int> userIDList=[];
  RoasterListViewResponse? roasterListViewResponse;
  bool? _autoValidate;
  GetTeamMembersEmailResponse? _getTeamMembersEmailResponse;
  String? userID,userName,teamName,userFcm,userEmail;




  Future<void> getSharedDataAsyncs() async {

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
  }

  /*
Return Type:
Input Parameters:
Use: Create API Calls and Handle Exceptions.
 */
  void getVolunteerAsync() async{
    try {


    await ApiManager()
        .getDio()!
        .post(Endpoints.serverGameUrl+Endpoints.getVoluenteerType)
        .then((response) => registerResponse(response))
        .catchError((onError) {
    listener.onFailure(DioErrorUtil.handleErrors(onError));
    });
    } catch (e) {
    listener.onFailure(ExceptionErrorUtil.handleErrors(e));
    }
  }

  void registerResponse(Response response) {
    VolunteerResponse _response = VolunteerResponse.fromJson(response.data);
    listener.onSuccess(_response, reqId: ResponseIds.GET_VOLUNTEER);
  }

/*
Return Type:
Input Parameters:
Use: Create API Calls and Handle Exceptions.
 */
  void getEventVoluenteersAsync(int gameID) async{
    try {

      await ApiManager()
          .getDio()!
          .post(Endpoints.serverGameUrl+Endpoints.getVolunteers,data: gameID)
          .then((response) => registerVolunteersResponse(response))
          .catchError((onError) {
        listener.onFailure(DioErrorUtil.handleErrors(onError));
      });
    } catch (e) {
      listener.onFailure(ExceptionErrorUtil.handleErrors(e));
    }
  }

  void registerVolunteersResponse(Response response) {
    _getEventVoluenteers = g.GetEventVoluenteers.fromJson(response.data);
    listener.onSuccess(_getEventVoluenteers, reqId: ResponseIds.UPDATE_VOLUNTEER);
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
  void updateVolunteerList(GameOrEventList eventList, BuildContext context) async{
    try {
      _putEventVoluenteers= g.GetEventVoluenteers();
      volunteerList=[];
      _putEventVoluenteers!.result= g.Result();
      _putEventVoluenteers!.result!.eventId=eventList.eventId;
      _putEventVoluenteers!.result!.userId=int.parse("${await SharedPrefManager.instance.getStringAsync(Constants.userIdNo)}");
      for(int i=0;i<volunteerNameController.length;i++){
        if(volunteerCheckBoxController[i].text=="true") {
          userIDList=[];
          g.VolunteerList volunteerType = new g.VolunteerList();
          volunteerType.eventVoluenteerTypeIDNo = eventVoluenteerTypeIDNo[i].text.isEmpty?0:int.parse(eventVoluenteerTypeIDNo[i].text);
          volunteerType.eventId = eventList.eventId;
          volunteerType.isDeleted = false;
          volunteerType.volunteerTypeId=volunteerIDController[i].text.isEmpty? 250:int.parse(volunteerIDController[i].text);
          volunteerType.volunteerTypeName=volunteerNameController[i].text;
          for(int j=0;j<volunteerPlayernamecontroller[i].length;j++){
            for(int k=0;k<roasterListViewResponse!.result!.userDetails!.length;k++){
              if((roasterListViewResponse!.result!.userDetails![k].userFirstName! +" "+roasterListViewResponse!.result!.userDetails![k].userLastName!)==volunteerPlayernamecontroller[i][j].text) {
                if (userIDList.isEmpty) {
                  userIDList.add(
                      roasterListViewResponse!.result!.userDetails![k].userIdNo!);
                } else {
                  if(userIDList.contains(roasterListViewResponse!.result!.userDetails![k].userIdNo)){
                  }else{
                    userIDList.add(roasterListViewResponse!.result!.userDetails![k].userIdNo!);
                  }

                }
              }
            }
          }
          volunteerType.userIDList=userIDList;
          volunteerList.add(volunteerType);
        }
      }
      for(int i=0;i<volunteerNameController.length;i++) {
        if (volunteerCheckBoxController[i].text=="false" && eventVoluenteerTypeIDNo[i].text.isNotEmpty){
          g.VolunteerList volunteerType = new g.VolunteerList();
          userIDList=[];
          volunteerType.eventVoluenteerTypeIDNo = eventVoluenteerTypeIDNo[i].text.isEmpty?0:int.parse(eventVoluenteerTypeIDNo[i].text);
          volunteerType.eventId = eventList.eventId;
          volunteerType.isDeleted = true;
          volunteerType.volunteerTypeId=volunteerIDController[i].text.isEmpty?250:int.parse(volunteerIDController[i].text);
          volunteerType.volunteerTypeName=volunteerNameController[i].text;
          for(int j=0;j<volunteerPlayernamecontroller[i].length;j++){
            for(int k=0;k<roasterListViewResponse!.result!.userDetails!.length;k++){
              if((roasterListViewResponse!.result!.userDetails![k].userFirstName! +" "+roasterListViewResponse!.result!.userDetails![k].userLastName!)==volunteerPlayernamecontroller[i][j].text){
                if (userIDList.isEmpty) {
                  userIDList.add(
                      roasterListViewResponse!.result!.userDetails![k].userIdNo!);
                } else {
                  if(userIDList.contains(roasterListViewResponse!.result!.userDetails![k].userIdNo)){
                  }else{
                    userIDList.add(roasterListViewResponse!.result!.userDetails![k].userIdNo!);

                  }
                 /* bool isValid=true;
                  for (int l = 0; l < userIDList.length; l++) {
                    if (userIDList[l] == roasterListViewResponse.userDetails[k].userIdNo) {
                      isValid=false;
                      break;
                    }
                  }
                  if(isValid){
                    userIDList.add(roasterListViewResponse.userDetails[k].userIdNo);

                  }*/
                }

              }
            }
          }
          volunteerType.userIDList=userIDList;
          volunteerList.add(volunteerType);
        }

      }
      _putEventVoluenteers!.result!.volunteerList=volunteerList;


      await ApiManager()
          .getDio()!
          .post(Endpoints.serverGameUrl+Endpoints.updateVolunteers,data: _putEventVoluenteers!.result)
          .then((response) => updateVolunteersResponse(response,eventList))
          .catchError((onError) {
        Navigator.of(context).pop();

        // listener.onFailure(DioErrorUtil.handleErrors(onError));
      });
    } catch (e) {
      listener.onFailure(ExceptionErrorUtil.handleErrors(e));
    }
  }

  Future<void> updateVolunteersResponse(Response response, GameOrEventList eventList) async {
    // ValidateUserResponse _response = ValidateUserResponse.fromJson(response.data);
    AddGameResponse gameResponse = AddGameResponse.fromJson(
        response.data);
    listener.onSuccess(gameResponse, reqId: ResponseIds.UPDATE_VOLUNTEER_STATUS);


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
                    eventList.name! + "&volunteer=" +
                    gameResponse.result![a].volunteerTypeName! + "&eventVolunteerTypeId=" +
                    gameResponse.result![a].eventVoluenteerTypeIDNo.toString() +
                    "&volunteerTypeId=" +
                    gameResponse.result![a].volunteerTypeId.toString() + "&teamname=" +
                    teamName! + "&type=" +
                    (eventList.type == Constants.event.toString()
                        ? "event"
                        : "game") + "&fcm=" + (userFcm != null ? userFcm! : "") +
                    "&name=" + userName! + "&mail=" +
                    _getTeamMembersEmailResponse!.result!.userMailList![c].email! +
                    "&toMail=" + userEmail! + "&toID=" + userID! + "&userName=" +
                    _getTeamMembersEmailResponse!.result!.userMailList![c].name! +
                    "&location=" +
                    eventList.locationAddress!)
                    .then((acceptvalue) async {
                  await DynamicLinksService()
                      .createDynamicLink(
                      "volunteer_availablity_screen?userid=" +
                          _getTeamMembersEmailResponse!.result!.userMailList![c].userIDNo
                              .toString() +
                          "&refer=" +
                          gameResponse.result![a].eventId.toString() +
                          "&status=3" + "&eventname=" +
                          eventList.name! + "&volunteer=" +
                          gameResponse.result![a].volunteerTypeName! +
                          "&eventVolunteerTypeId=" +
                          gameResponse.result![a].eventVoluenteerTypeIDNo.toString() +
                          "&volunteerTypeId=" +
                          gameResponse.result![a].volunteerTypeId.toString() +
                          "&teamname=" +
                          teamName! + "&type=" +
                          (eventList.type == Constants.event.toString()
                              ? "event"
                              : "game") + "&fcm=" +
                          (userFcm != null ? userFcm! : "") + "&name=" +
                          userName! +
                          "&mail=" +
                          _getTeamMembersEmailResponse!.result!.userMailList![c].email! +
                          "&toMail=" +
                          userEmail! +
                          "&toID=" + userID! + "&userName=" +
                          _getTeamMembersEmailResponse!.result!.userMailList![c].name!)
                      .then((declainvalue) async {
                    await DynamicLinksService()
                        .createDynamicLink(
                        "volunteer_availablity_screen?userid=" +
                            _getTeamMembersEmailResponse!.result!.userMailList![c]
                                .userIDNo
                                .toString() +
                            "&refer=" +
                            gameResponse.result![a].eventId.toString() +
                            "&status=4" + "&eventname=" +
                            eventList.name! + "&volunteer=" +
                            gameResponse.result![a].volunteerTypeName! +
                            "&eventVolunteerTypeId=" +
                            gameResponse.result![a].eventVoluenteerTypeIDNo.toString() +
                            "&volunteerTypeId=" +
                            gameResponse.result![a].volunteerTypeId.toString() +
                            "&teamname=" +
                            teamName! + "&type=" +
                            (eventList.type == Constants.event.toString()
                                ? "event"
                                : "game") + "&fcm=" +
                            (userFcm != null ? userFcm! : "") + "&name=" +
                            userName! +
                            "&mail=" +
                            _getTeamMembersEmailResponse!.result!.userMailList![c].email! +
                            "&toMail=" +
                            userEmail! +
                            "&toID=" + userID! + "&userName=" +
                            _getTeamMembersEmailResponse!.result!.userMailList![c].name!)
                        .then((maybevalue) {
                      volunteerInviteNotification(
                          " Assigned Volunteer",
                          eventList.name!,
                          Constants.gameVolunteerInvite,
                          int.parse(gameResponse.result![a].eventId.toString()),
                          "Volunteer task has been assigned by " +
                              (userName! +
                                  " for the " + eventList.type! +" "+ eventList.name! +
                                  " that is scheduled to commence on " +
                                  eventList.scheduleDate! + " " +
                                  (eventList.scheduleTime=="00:00"?"TBD":DateFormat("h:mma").format(DateFormat("h:mma")
                                      .parse(eventList.scheduleTime!)))
                                   +
                                  " at " +
                                  eventList.locationAddress!  +
                                  "."),
                          _getTeamMembersEmailResponse!.result!.userMailList![c].userIDNo!,
                          _getTeamMembersEmailResponse!.result!.userMailList![c].email!,
                          false,
                          userName!,
                          teamName!,
                          gameResponse.result![a].volunteerTypeName!,
                          gameResponse.result![a].eventVoluenteerTypeIDNo!,
                          gameResponse.result![a].volunteerTypeId!,
                          eventList.name!,
                          acceptvalue,
                          maybevalue,
                          declainvalue,
                          eventList.locationAddress! ,
                          eventList.scheduleDate!,
                          eventList.scheduleTime=="00:00"?"TBD":DateFormat("h:mma").format(DateFormat("h:mma")
                              .parse(eventList.scheduleTime!)),
                          ""
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
      }
      // listener.onSuccess(gameResponse, reqId: ResponseIds.UPDATE_VOLUNTEER_STATUS);

  }
  bool? get getAutoValidate => _autoValidate;


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
      _notificationList.teamName = teamName!;
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


  void registerEmailResponse(Response response) {
    ValidateUserResponse _response =
    ValidateUserResponse.fromJson(response.data);
    //  listener.onSuccess(_response, reqId: ResponseIds.SEND_EMAIL);
  }


  void deleteVolunteerAsync(String volunteerId) async{
    try {
      UpdateVolunteerRequest _updateVolunteer=UpdateVolunteerRequest();
      _updateVolunteer.volunteerTypeId=int.parse(volunteerId);

      await ApiManager()
          .getDio()!
          .post(Endpoints.serverGameUrl+Endpoints.removeVolunteerType,data: _updateVolunteer)
          .then((response) => removeResponse(response))
          .catchError((onError) {
        listener.onFailure(DioErrorUtil.handleErrors(onError));
      });
    } catch (e) {
      listener.onFailure(ExceptionErrorUtil.handleErrors(e));
    }
  }

  void removeResponse(Response response) {
  }

  void addVolunteerAsync(String job) async{
    try {
      UpdateVolunteerRequest _updateVolunteer=UpdateVolunteerRequest();
      _updateVolunteer.volunteerTypeName=job;

      await ApiManager()
          .getDio()!
          .post(Endpoints.serverGameUrl+Endpoints.addVolunteerType,data: _updateVolunteer)
          .then((response) => addResponse(response))
          .catchError((onError) {
        listener.onFailure(DioErrorUtil.handleErrors(onError));
      });
    } catch (e) {
      listener.onFailure(ExceptionErrorUtil.handleErrors(e));
    }
  }

  void addResponse(Response response) {
  }
}

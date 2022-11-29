import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:spaid/base/base_provider.dart';
import 'package:spaid/model/request/create_team_request/create_team_request.dart';
import 'package:spaid/model/request/game_event_request/opponent_request.dart';
import 'package:spaid/model/request/game_event_request/score_request.dart';
import 'package:spaid/model/request/game_event_request/update_game_status_request.dart';
import 'package:spaid/model/request/roaster_listview_request/team_members_details_request.dart';
import 'package:spaid/model/request/select_team_request/select_team_request.dart';
import 'package:spaid/model/response/create_team_response/create_team_response.dart';
import 'package:spaid/model/response/game_event_response/game_availablity_response.dart';
import 'package:spaid/model/response/game_event_response/game_team_response.dart';
import 'package:spaid/model/response/game_event_response/live_game_response.dart';
import 'package:spaid/model/response/game_event_response/opponent_response.dart';
import 'package:spaid/model/response/game_event_response/score_details_response.dart';
import 'package:spaid/model/response/signup_response/validate_user_response.dart';
import 'package:spaid/service/api_manager.dart';
import 'package:spaid/service/dio_error_util.dart';
import 'package:spaid/service/endpoints.dart';
import 'package:spaid/service/exception_error_util.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/support/response_ids.dart';
import 'package:spaid/support/strings.dart';
import 'package:spaid/utils/shared_pref_manager.dart';
import 'package:spaid/widgets/ProgressBar.dart';

class EventListviewProvider extends BaseProvider {
  //region Private Members

  GetTeamMemberDetailsRequest? _selectTeamRequest;
  UpdateGameStatusRequest? _updateGameStatusRequest;
  ScoreDetailsResponse? scoreResponse;
//endregion


  /*
Return Type:
Input Parameters:
Use: Create API Calls and Handle Exceptions.
 */
  void getGameAsync() async{
    try {
      _selectTeamRequest = GetTeamMemberDetailsRequest();
      _selectTeamRequest!.teamIDNo = int.parse( "${await SharedPrefManager.instance.getStringAsync(Constants.teamID)}");
      _selectTeamRequest!.userIDNo = int.parse( "${await SharedPrefManager.instance.getStringAsync(Constants.userIdNo)}");

    await ApiManager()
        .getDio()!
        .post(Endpoints.serverGameUrl+Endpoints.getGameOrEventForTeam, data: _selectTeamRequest)
        .then((response) => registerResponse(response))
        .catchError((onError) {
    listener.onFailure(DioErrorUtil.handleErrors(onError));
    });
    } catch (e) {
    listener.onFailure(ExceptionErrorUtil.handleErrors(e));
    }
  }

  void registerResponse(Response response) {
    GetGameEventForTeamResponse _response = GetGameEventForTeamResponse.fromJson(response.data);
    listener.onSuccess(_response, reqId: ResponseIds.GET_GAME);
  }
  void setRefreshScreen(String type){
    listener.onRefresh(type);

  }
  /*
Return Type:
Input Parameters:
Use: Create API Calls and Handle Exceptions.
 */
  void updateGameStatusAsync(int eventId, String type,int status) async{
    try {
      _updateGameStatusRequest = UpdateGameStatusRequest();
      _updateGameStatusRequest!.status=status;
      _updateGameStatusRequest!.eventId=eventId;
      _updateGameStatusRequest!.IsAllOccurence=type=="All"?true:false;
      _updateGameStatusRequest!.userId = int.parse( "${await SharedPrefManager.instance.getStringAsync(Constants.userIdNo)}");

      await ApiManager()
          .getDio()!
          .post(Endpoints.serverGameUrl+Endpoints.updateGameStatus, data: _updateGameStatusRequest)
          .then((response) => updateGameStatusResponse(response))
          .catchError((onError) {
        listener.onFailure(DioErrorUtil.handleErrors(onError));
      });
    } catch (e) {
      listener.onFailure(ExceptionErrorUtil.handleErrors(e));
    }
  }

  void updateGameStatusResponse(Response response) {
    ValidateUserResponse _response = ValidateUserResponse.fromJson(response.data);
    listener.onSuccess(_response, reqId: ResponseIds.GET_GAME_STATUS_UPDATE);
  }

  /*
Return Type:
Input Parameters:
Use: Create API Calls and Handle Exceptions.
 */
  void deleteGameAsync(int eventId, String type) async{
    try {
      _updateGameStatusRequest = UpdateGameStatusRequest();
      _updateGameStatusRequest!.status=Constants.deleted;
      _updateGameStatusRequest!.eventId=eventId;
      _updateGameStatusRequest!.IsAllOccurence=type=="All"?true:false;
      _updateGameStatusRequest!.userId = int.parse( "${await SharedPrefManager.instance.getStringAsync(Constants.userIdNo)}");

      await ApiManager()
          .getDio()!
          .post(Endpoints.serverGameUrl+Endpoints.removeGameorEvent, data: _updateGameStatusRequest)
          .then((response) => statusregisterResponse(response))
          .catchError((onError) {
        listener.onFailure(DioErrorUtil.handleErrors(onError));
      });
    } catch (e) {
      listener.onFailure(ExceptionErrorUtil.handleErrors(e));
    }
  }

  void statusregisterResponse(Response response) {
    ValidateUserResponse _response = ValidateUserResponse.fromJson(response.data);
    listener.onSuccess(_response, reqId: ResponseIds.GET_GAME_STATUS_UPDATE);
  }
  /*
Return Type:
Input Parameters:
Use: Create API Calls and Handle Exceptions.
 */
  void getLiveGameAsync() async{
    try {
      OpponentRequest _opponentRequest = OpponentRequest();
      _opponentRequest.userIDNo=int.parse( await SharedPrefManager.instance.getStringAsync(Constants.userIdNo));
      _opponentRequest.teamIDNo=int.parse( await SharedPrefManager.instance.getStringAsync(Constants.teamID));
      await ApiManager()
          .getDio()!
          .post(Endpoints.serverTimeKeeperConsoleUrl+Endpoints.getOnGoingGameOrEvent, data: _opponentRequest)
          .then((response) => registerLiveGameResponse(response))
          .catchError((onError) {
        listener.onFailure(DioErrorUtil.handleErrors(onError));
      });
    } catch (e) {
      listener.onFailure(ExceptionErrorUtil.handleErrors(e));
    }
  }

  void registerLiveGameResponse(Response response) {
    try {
      LiveGameResponse _response = LiveGameResponse.fromJson(response.data);
      listener.onSuccess(_response, reqId: ResponseIds.LIVE_GAME);
    } catch (e) {
      print(e);
    }
  }
  getScoreDetails(int matcheId) async {
    ScoreRequest _scoreRequest = ScoreRequest();
    //_scoreRequest.iDNo = 11;
    _scoreRequest.iDNo=matcheId;
    _scoreRequest.isGuestUser=false;
    try {
      await ApiManager()
          .getDio()!
          .post(Endpoints.serverTimeKeeperConsoleUrl + Endpoints.getScore, data:_scoreRequest )
          .then((response) => registerScoreResponse(response))
          .catchError((onError) {
        listener.onFailure(DioErrorUtil.handleErrors(onError));
      });
    } catch (e) {
      print(e);
    }
  }

  void registerScoreResponse(Response response) {
    scoreResponse =
    ScoreDetailsResponse.fromJson(response.data);
    listener.onSuccess(scoreResponse,
        reqId: ResponseIds.GET_SCORE_DETAILS_SCREEN);
  }
}
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:spaid/base/base_provider.dart';
import 'package:spaid/model/request/create_team_request/create_team_request.dart';
import 'package:spaid/model/request/game_event_request/opponent_request.dart';
import 'package:spaid/model/request/game_event_request/update_game_status_request.dart';
import 'package:spaid/model/request/select_team_request/select_team_request.dart';
import 'package:spaid/model/response/create_team_response/create_team_response.dart';
import 'package:spaid/model/response/game_event_response/game_availablity_response.dart';
import 'package:spaid/model/response/game_event_response/opponent_response.dart';
import 'package:spaid/model/response/game_event_response/player_availability_response.dart';
import 'package:spaid/model/response/game_event_response/volunteer_availability_response.dart';
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

class AvailabilityListviewProvider extends BaseProvider {
  //region Private Members

  SelectTeamRequest? _selectTeamRequest;
  UpdateGameStatusRequest? _updateGameStatusRequest;
  String selectedValue=MyStrings.available;
  String selectedVolunteerValue=MyStrings.available;
//endregion


  /*
Return Type:
Input Parameters:
Use: Create API Calls and Handle Exceptions.
 */
  void getAvailabilityGameAsync() async{
    try {

    await ApiManager()
        .getDio()!
        .post(Endpoints.serverGameUrl+Endpoints.getGameAvailability, data: int.parse( "${await SharedPrefManager.instance.getStringAsync(Constants.teamID)}"))
        .then((response) => registerResponse(response))
        .catchError((onError) {
    listener.onFailure(DioErrorUtil.handleErrors(onError));
    });
    } catch (e) {
    listener.onFailure(ExceptionErrorUtil.handleErrors(e));
    }
  }

  void registerResponse(Response response) {
    GetGameAvailablityResponse _response = GetGameAvailablityResponse.fromJson(response.data);
    listener.onSuccess(_response, reqId: ResponseIds.GET_AVAILABILITY_GAME);
  }

  /*
Return Type:
Input Parameters:
Use: Create API Calls and Handle Exceptions.
 */
  void getPlayerAvailabilityAsync(int eventId) async{
    try {

      await ApiManager()
          .getDio()!
          .post(Endpoints.serverGameUrl+Endpoints.getPlayerAvailability, data: eventId)
          .then((response) => statusregisterResponse(response))
          .catchError((onError) {
        listener.onFailure(DioErrorUtil.handleErrors(onError));
      });
    } catch (e) {
      listener.onFailure(ExceptionErrorUtil.handleErrors(e));
    }
  }

  void statusregisterResponse(Response response) {
    GetPlayerAvailabilityResponse _response = GetPlayerAvailabilityResponse.fromJson(response.data);
    listener.onSuccess(_response, reqId: ResponseIds.GET_PLAYER_AVAILABILITY);
  }
  void setRefreshScreen(){
    listener.onRefresh("");

  }
  /*
Return Type:
Input Parameters:
Use: Create API Calls and Handle Exceptions.
 */
  void getVolunteerAvailabilityAsync(int eventId) async{
    try {

      await ApiManager()
          .getDio()!
          .post(Endpoints.serverGameUrl+Endpoints.volunteerAvailabilityStatus, data: eventId)
          .then((response) => volunteerStatusRegisterResponse(response))
          .catchError((onError) {
        listener.onFailure(DioErrorUtil.handleErrors(onError));
      });
    } catch (e) {
      listener.onFailure(ExceptionErrorUtil.handleErrors(e));
    }
  }

  void volunteerStatusRegisterResponse(Response response) {
    VolunteerAvailabilityResponse _response = VolunteerAvailabilityResponse.fromJson(response.data);
    listener.onSuccess(_response, reqId: ResponseIds.VOLUNTEER_AVAILABILITY_SCREEN);
  }

}

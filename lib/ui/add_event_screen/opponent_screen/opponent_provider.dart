import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:spaid/base/base_provider.dart';
import 'package:spaid/model/request/create_team_request/create_team_request.dart';
import 'package:spaid/model/request/game_event_request/opponent_request.dart';
import 'package:spaid/model/response/create_team_response/create_team_response.dart';
import 'package:spaid/model/response/game_event_response/opponent_response.dart';
import 'package:spaid/service/api_manager.dart';
import 'package:spaid/service/dio_error_util.dart';
import 'package:spaid/service/endpoints.dart';
import 'package:spaid/service/exception_error_util.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/support/response_ids.dart';
import 'package:spaid/support/strings.dart';
import 'package:spaid/utils/shared_pref_manager.dart';
import 'package:spaid/widgets/ProgressBar.dart';

class OpponentProvider extends BaseProvider {
  //region Private Members

  OpponentRequest? _opponentRequest;
  OpponentResponse? opponentResponse;
//endregion


  /*
Return Type:
Input Parameters:
Use: Create API Calls and Handle Exceptions.
 */
  void getOpponentAsync() async{
    try {
      _opponentRequest = OpponentRequest();
      _opponentRequest!.userIDNo=int.parse( await SharedPrefManager.instance.getStringAsync(Constants.userIdNo));
      _opponentRequest!.teamIDNo=int.parse( await SharedPrefManager.instance.getStringAsync(Constants.teamID));
      print(_opponentRequest!.userIDNo);
      print(_opponentRequest!.teamIDNo);
      // await compute(getOpponents,_opponentRequest );
      await ApiManager()
          .getDio()!
          .post(Endpoints.serverGameUrl+Endpoints.getOpponentTeam, data: _opponentRequest)
          .then((response) => registerResponse(response))
          .catchError((onError) {
        listener.onFailure(DioErrorUtil.handleErrors(onError));
      });

    } catch (e) {
    listener.onFailure(ExceptionErrorUtil.handleErrors(e));
    }
  }

  void registerResponse(Response response) {
    opponentResponse = OpponentResponse.fromJson(response.data);
    listener.onSuccess(opponentResponse, reqId: ResponseIds.GET_OPPONENT);
  }
  getOpponents(OpponentRequest opponentRequest) {
    // JSON decoding is a costly thing its preferable
    // if we did this off the main thread
    ApiManager()
        .getDio()!
        .post(Endpoints.serverGameUrl+Endpoints.getOpponentTeam, data: opponentRequest)
        .then((response) => registerResponse(response))
        .catchError((onError) {
      listener.onFailure(DioErrorUtil.handleErrors(onError));
    });

  }

}

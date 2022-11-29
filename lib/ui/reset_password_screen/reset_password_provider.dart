import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:spaid/base/base_provider.dart';
import 'package:spaid/model/request/create_team_request/create_team_request.dart';
import 'package:spaid/model/request/game_event_request/opponent_request.dart';
import 'package:spaid/model/request/game_event_request/update_game_status_request.dart';
import 'package:spaid/model/request/select_team_request/select_team_request.dart';
import 'package:spaid/model/request/signin_request/change_password_request.dart';
import 'package:spaid/model/response/create_team_response/create_team_response.dart';
import 'package:spaid/model/response/game_event_response/game_availablity_response.dart';
import 'package:spaid/model/response/game_event_response/opponent_response.dart';
import 'package:spaid/model/response/game_event_response/player_availability_response.dart';
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

class ResetPasswordProvider extends BaseProvider {
  //region Private Members

  ChangePasswordRequest? _changePasswordRequest;
  TextEditingController? passwordController;
  TextEditingController? conformpasswordController;
//endregion

  void initialProvider() {
    passwordController=new TextEditingController();
    conformpasswordController=new TextEditingController();
  }
  /*
Return Type:
Input Parameters:
Use: Create API Calls and Handle Exceptions.
 */
  void changePassword(String userID) async{
    try {
      _changePasswordRequest = ChangePasswordRequest();
      _changePasswordRequest!.userId = userID.isNotEmpty?int.parse(userID):int.parse( "${await SharedPrefManager.instance.getStringAsync(Constants.userIdNo)}");
      _changePasswordRequest!.password=passwordController!.text;

    await ApiManager()
        .getDio()!
        .post(Endpoints.serverValidateUrl+Endpoints.changeUserLoginPassword, data: _changePasswordRequest)
        .then((response) => registerResponse(response))
        .catchError((onError) {
    listener.onFailure(DioErrorUtil.handleErrors(onError));
    });
    } catch (e) {
    listener.onFailure(ExceptionErrorUtil.handleErrors(e));
    }
  }

  void registerResponse(Response response) {
    ValidateUserResponse _response = ValidateUserResponse.fromJson(response.data);
    listener.onSuccess(_response, reqId: ResponseIds.CHANGE_PASSWORD);
  }



}

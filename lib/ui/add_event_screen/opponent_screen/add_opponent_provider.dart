import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:spaid/base/base_provider.dart';
import 'package:spaid/model/request/create_team_request/create_team_request.dart';
import 'package:spaid/model/request/game_event_request/add_opponent_request.dart';
import 'package:spaid/model/request/game_event_request/opponent_request.dart';
import 'package:spaid/model/response/create_team_response/create_team_response.dart';
import 'package:spaid/model/response/game_event_response/opponent_response.dart';
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

class AddOpponentProvider extends BaseProvider {
  //region Private Members

  AddOpponentRequest? _addOpponentRequest;
  TextEditingController? opponentNameController;
  TextEditingController? contactNameController;
  TextEditingController? phoneNameController;
  TextEditingController? contactEmailController;
  TextEditingController? noteController;

//endregion

  /*
Return Type:
Input Parameters:
Use: Initiate value to the variable and create object.
 */
  initialProvider() {
    opponentNameController = TextEditingController();
    contactNameController = TextEditingController();
    phoneNameController = TextEditingController();
    contactEmailController = TextEditingController();
    noteController = TextEditingController();

  }
  /*
Return Type:
Input Parameters:
Use: Create API Calls and Handle Exceptions.
 */
  void addOpponentAsync(List<int> imageBytes) async{
    try {
      _addOpponentRequest = AddOpponentRequest();
      _addOpponentRequest!.duplicateTeamId=0;
      _addOpponentRequest!.sportIDNo=1;
      _addOpponentRequest!.teamIDNo=int.parse( await SharedPrefManager.instance.getStringAsync(Constants.teamID));
      _addOpponentRequest!.userIDNo=int.parse( await SharedPrefManager.instance.getStringAsync(Constants.userIdNo));
      _addOpponentRequest!.managerIdNo=int.parse( await SharedPrefManager.instance.getStringAsync(Constants.userIdNo));
      _addOpponentRequest!.teamName=opponentNameController!.text;
      _addOpponentRequest!.contactPersion=contactNameController!.text;
      _addOpponentRequest!.contactEmail=contactEmailController!.text;
      _addOpponentRequest!.contactMobile=phoneNameController!.text;
      _addOpponentRequest!.notes=noteController!.text;
      _addOpponentRequest!.teamProfileImage=imageBytes;


    await ApiManager()
        .getDio()!
        .post(Endpoints.serverGameUrl+Endpoints.addOpponentTeam, data: _addOpponentRequest)
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
    listener.onSuccess(_response, reqId: ResponseIds.ADD_OPPONENT);
  }




}

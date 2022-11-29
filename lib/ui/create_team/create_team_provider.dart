import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:spaid/base/base_provider.dart';
import 'package:spaid/model/request/create_team_request/create_team_request.dart';
import 'package:spaid/model/response/create_team_response/create_team_response.dart';
import 'package:spaid/service/api_manager.dart';
import 'package:spaid/service/dio_error_util.dart';
import 'package:spaid/service/endpoints.dart';
import 'package:spaid/service/exception_error_util.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/support/response_ids.dart';
import 'package:spaid/support/strings.dart';
import 'package:spaid/utils/shared_pref_manager.dart';
import 'package:spaid/widgets/ProgressBar.dart';

class CreateTeamProvider extends BaseProvider {
  //region Private Members
  bool _isagree = false;
  TextEditingController? teamNameController;
  TextEditingController? timezoneController;
  TextEditingController? countryController;
  TextEditingController? sportNameController;

  bool? _autoValidate;
  CreateTeamRequest? _createTeamRequest;

//endregion
  /*
Return Type:
Input Parameters:
Use: Initiate value to the variable and create object.
 */
  initialProvider() {
    teamNameController = TextEditingController();
    timezoneController = TextEditingController();
    countryController = TextEditingController();
    sportNameController = TextEditingController();

    _autoValidate = false;
  }

  /*
Return Type:
Input Parameters:Bool
Use: Initiate value to the variable and create object.
 */
  void setAutoValidate(bool value) {
    //_autoValidate = value;
    _autoValidate = true;
    notifyListeners();
  }

  bool? get getAutoValidate => _autoValidate;

  /*
Return Type:
Input Parameters:
Use: Create API Calls and Handle Exceptions.
 */
  createTeamAsync(List<int> imageBytes) async {
    try {
      _createTeamRequest = CreateTeamRequest();
      /*_createTeamRequest.userEmailID =
          "${await SharedPrefManager.instance.getStringAsync(Constants.userId)}";*/
      _createTeamRequest!.teamName = teamNameController!.text;
      _createTeamRequest!.teamCountry = countryController!.text;
      _createTeamRequest!.UserIDNo = "${await SharedPrefManager.instance.getStringAsync(Constants.userIdNo)}";
       _createTeamRequest!.RoleIdNo =  -10001 ;
      // _createTeamRequest.RoleIdNo = "${await SharedPrefManager.instance.getStringAsync(Constants.roleId)}" ==  MyStrings.managerRole ? -10002 : "${ await SharedPrefManager.instance.getStringAsync(Constants.roleId)}" == MyStrings.playerRole  ? "-10003" : "-10005";
      _createTeamRequest!.teamTimeZone = timezoneController!.text;
      _createTeamRequest!.sportIdNo = "10001";
      _createTeamRequest!.image =imageBytes??[];
      print(imageBytes);

      await ApiManager()
          .getDio()!
          .post(Endpoints.addTeamUrl, data: _createTeamRequest)
          .then((response) => registerResponse(response))
          .catchError((onError) {
        listener.onFailure(DioErrorUtil.handleErrors(onError));
      });
    } catch (e) {
      listener.onFailure(ExceptionErrorUtil.handleErrors(e));
    }
  }

  void registerResponse(Response response) {
    CreateTeamResponse _response = CreateTeamResponse.fromJson(response.data);
    listener.onSuccess(_response, reqId: ResponseIds.TEAM_CREATE_SCREEN);
  }

  clearProvider() {
    teamNameController!.clear();
    timezoneController!.clear();
    countryController!.clear();
    sportNameController!.clear();
  }

  bool get getIsagree => _isagree;

  /*
Return Type:
Input Parameters:Bool
Use: Initiate value to the variable and create object.
 */
  void setIsagree(bool value) {
    _isagree = value;
    notifyListeners();
  }
}

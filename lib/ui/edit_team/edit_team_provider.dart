import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:spaid/base/base_provider.dart';
import 'package:spaid/model/request/create_team_request/create_team_request.dart';
import 'package:spaid/model/request/select_team_request/select_team_request.dart';
import 'package:spaid/model/response/create_team_response/create_team_response.dart';
import 'package:spaid/model/response/create_team_response/team_details_response.dart' as t;
import 'package:spaid/service/api_manager.dart';
import 'package:spaid/service/dio_error_util.dart';
import 'package:spaid/service/endpoints.dart';
import 'package:spaid/service/exception_error_util.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/support/response_ids.dart';
import 'package:spaid/support/strings.dart';
import 'package:spaid/utils/shared_pref_manager.dart';
import 'package:spaid/widgets/ProgressBar.dart';

class EditTeamProvider extends BaseProvider {
  //region Private Members
  bool _isagree = false;
  TextEditingController? teamNameController;
  TextEditingController? timezoneController;
  TextEditingController? countryController;
  TextEditingController? sportNameController;
  SelectTeamRequest? _selectTeamRequest;
  bool? _autoValidate;
  t.TeamDetailsResponse? _teamDetailsResponse;

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
  getTeamDetails(String teamID) async {
    try {


      await ApiManager()
          .getDio()!
          .post(Endpoints.getTeamDetails, data: int.parse( "${await SharedPrefManager.instance.getStringAsync(Constants.teamID)}"))
          .then((response) => getTeamDetailsResponse(response))
          .catchError((onError) {
        listener.onFailure(DioErrorUtil.handleErrors(onError));
      });
    } catch (e) {
      listener.onFailure(ExceptionErrorUtil.handleErrors(e));
    }
  }

  void getTeamDetailsResponse(Response response) {
    t.TeamDetailsResponse _response = t.TeamDetailsResponse.fromJson(response.data);
    listener.onSuccess(_response, reqId: ResponseIds.GET_TEAM_DETAILS);
  }


  /*
Return Type:
Input Parameters:
Use: Create API Calls and Handle Exceptions.
 */
  updateTeamAsync(List<int> imageBytes) async {
    try {
      _teamDetailsResponse = t.TeamDetailsResponse();
      _teamDetailsResponse!.result=t.Result();
      /*_createTeamRequest.userEmailID =
          "${await SharedPrefManager.instance.getStringAsync(Constants.userId)}";*/
      _teamDetailsResponse!.result!.teamName = teamNameController!.text;
      _teamDetailsResponse!.result!.teamCountry = countryController!.text;
      _teamDetailsResponse!.result!.managerIdNo = int.parse("${await SharedPrefManager.instance.getStringAsync(Constants.userIdNo)}");
      _teamDetailsResponse!.result!.teamIDNo = int.parse("${await SharedPrefManager.instance.getStringAsync(Constants.teamID)}");
      _teamDetailsResponse!.result!.teamTimeZone = timezoneController!.text;
      _teamDetailsResponse!.result!.sportIDNo = 10001;
      _teamDetailsResponse!.result!.updateProfileImage =imageBytes??[];
      print(imageBytes);

      await ApiManager()
          .getDio()!
          .post(Endpoints.editTeam, data: _teamDetailsResponse!.result)
          .then((response) => registerResponse(response))
          .catchError((onError) {
        listener.onFailure(DioErrorUtil.handleErrors(onError));
      });
    } catch (e) {
      listener.onFailure(ExceptionErrorUtil.handleErrors(e));
    }
  }

  void registerResponse(Response response) {
    t.TeamDetailsResponse _response = t.TeamDetailsResponse.fromJson(response.data);
    listener.onSuccess(_response, reqId: ResponseIds.EDIT_TEAM);
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

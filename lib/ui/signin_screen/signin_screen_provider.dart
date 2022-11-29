import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:spaid/base/base_provider.dart';
import 'package:spaid/model/request/add_player_request/get_existing_player_request.dart';
import 'package:spaid/model/request/get_drill_request.dart';
import 'package:spaid/model/request/signin_request/signin_request.dart';
import 'package:spaid/model/response/add_player_response/add_existing_player_response.dart';
import 'package:spaid/model/response/signin_response/signin_response.dart';
import 'package:spaid/model/response/signup_response/validate_user_response.dart';
import 'package:spaid/service/api_manager.dart';
import 'package:spaid/service/dio_error_util.dart';
import 'package:spaid/service/endpoints.dart';
import 'package:spaid/service/exception_error_util.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/support/response_ids.dart';
import 'package:spaid/utils/shared_pref_manager.dart';

import '../../model/request/search_email_request.dart';

class SignInProvider extends BaseProvider {
  //region Private Members

  TextEditingController? emailController;
  TextEditingController? passwordController;
  bool? _autoValidate;
  SignInRequest? _signinRequest;
  String? countryCode;
  //endregion

  /*
Return Type:
Input Parameters:
Use: Initiate value to the variable and create object.
 */
  initialProvider() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    _autoValidate = false;
    getCountryCodeAsync();
    /*if (kIsWeb) {
      getCountryCodeAsync();}*/
  }

  /*
Return Type:
Input Parameters:bool
Use: Initiate value to the variable and create object.
 */
  void setAutoValidate(bool value) {
    _autoValidate = true;
    notifyListeners();
  }

  bool? get getAutoValidate => _autoValidate;

  /*
Return Type:
Input Parameters:
Use: Create API Calls and Handle Exceptions.
 */
  putSigninAsync() async {
    try {
      _signinRequest = SignInRequest();
      _signinRequest!.userEmailID = emailController!.text;
      // _signinRequest.userPrimaryPhone = int.parse(emailController.text);
      _signinRequest!.userPassword = passwordController!.text;
        _signinRequest!.FCMTokenID =
        "${await SharedPrefManager.instance.getStringAsync(Constants.FCM)}";

      await ApiManager()
          .getDio()!
          .post(Endpoints.serverValidateUrl+Endpoints.userLogin, data: _signinRequest)
          .then((response) => registerResponse(response))
          .catchError((onError) {
        listener.onFailure(DioErrorUtil.handleErrors(onError));
      });
    } catch (e) {
      listener.onFailure(ExceptionErrorUtil.handleErrors(e));
    }
  }

  /*
Return Type:
Input Parameters:Json Data
Use: Update API Response to the UI.
 */
  void registerResponse(Response response) {
    ValidateUserResponse _response = ValidateUserResponse.fromJson(response.data);
    getExistingPlayer();
    listener.onSuccess(_response, reqId: ResponseIds.SIGNIN_SCREEN);
  }

  /*
Return Type:
Input Parameters:
Use: Create API Calls and Handle Exceptions.
 */
  getExistingPlayer() async {
    try {
      SearchUserRequest _searchUserRequest= SearchUserRequest();
      _searchUserRequest.email=emailController!.text;
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
      if (_response.result != null && _response.result!.userIDNo != Constants.success) {
        SharedPrefManager.instance.setStringAsync(Constants.addToCalender, _response.result!.addToCalendar.toString());
        SharedPrefManager.instance.setStringAsync(
            Constants.userName, _response.result!.userFirstName!+" "+_response.result!.userLastName!);
      }
     // listener.onSuccess(_response, reqId: ResponseIds.ADD_EXISTING_PLAYER);
    } catch (e) {
      /*ValidateUserResponse _response= ValidateUserResponse.fromJson(response.data);
      listener.onFailure(ExceptionErrorUtil.handleErrors(_response.saveErrors[0].errorMessage));*/

      print(e);
    }
  }

//Future Purpose

/*void setTotEvent(int totEvents) {
    _totEvents = totEvents;
    notifyListeners();
  }

  int get getTotalEvents => _totEvents;

  clearProvider() {
    emailController.clear();
    passwordController.clear();
  }

  bool get getIsagree => _isagree;

  void setIsagree(bool value) {
    _isagree = value;
    notifyListeners();
  }*/

  getCountryCodeAsync() async {
    await ApiManager()
        .getDio()!
        .post('https://geolocation-db.com/json/')
        .then((response) {
       Map data = jsonDecode(response.data);
      print(data);
      if(data["country_code"] != null && data["country_code"] != "") {
        countryCode = data["country_code"];
        SharedPrefManager.instance.setStringAsync(Constants.countryCode, countryCode!);
        SharedPrefManager.instance.setStringAsync(Constants.countryName, data["country_name"]);

      }else{
        countryCode='US';
        SharedPrefManager.instance
            .setStringAsync(Constants.countryCode, countryCode!);
        SharedPrefManager.instance.setStringAsync(Constants.countryName, "US");

      }
    })
        .catchError((onError) {
          print(onError);
     // listener.onFailure(DioErrorUtil.handleErrors(onError));
    });
  }
}

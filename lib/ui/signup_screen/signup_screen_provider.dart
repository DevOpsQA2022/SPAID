import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spaid/base/base_provider.dart';
import 'package:spaid/model/request/add_player_request/get_existing_player_request.dart';
import 'package:spaid/model/request/get_drill_request.dart';
import 'package:spaid/model/request/signup_request/signup_request.dart';
import 'package:spaid/model/request/signup_request/validate_user_request.dart';
import 'package:spaid/model/response/add_player_response/add_existing_player_response.dart';
import 'package:spaid/model/response/player_profile_response/player_profile_response.dart';
import 'package:spaid/model/response/signup_response/player_mail_response.dart';
import 'package:spaid/model/response/signup_response/signup_response.dart';
import 'package:spaid/model/response/signup_response/validate_user_response.dart';
import 'package:spaid/service/api_manager.dart';
import 'package:spaid/service/dio_error_util.dart';
import 'package:spaid/service/endpoints.dart';
import 'package:spaid/service/exception_error_util.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/support/response_ids.dart';
import 'package:spaid/support/strings.dart';
import 'package:spaid/utils/shared_pref_manager.dart';

import '../../model/request/search_email_request.dart';

class SignUpProvider extends BaseProvider {
  bool _isagree = false;

  TextEditingController? firstNameController;
  TextEditingController? emailController;
  TextEditingController? coachemailController;
  TextEditingController? passwordController;
  TextEditingController? RolechosenController;
  TextEditingController? confirmPasswordController;
  TextEditingController? lastNameController;
  TextEditingController? middleNameController;
  TextEditingController? DatePickerController;
  TextEditingController? countryCodeController;
  TextEditingController? mobileNumberController;
  TextEditingController? address2Controller;
  TextEditingController? cityController;
  TextEditingController? stateController;
  TextEditingController? zipController;
  TextEditingController? altEmailController;
  TextEditingController? altContactController;
  TextEditingController? familyController;
  TextEditingController? gender;
  TextEditingController? address;
  TextEditingController? ssoLoginId;
  String? countryCode;
  String selectedYear = "2021";
  bool? _autoValidate;
  SignUpRequest? _signupRequest;
  ValidateUserRequest? _validateUserRequest;
  String? dateformat, first;
  List<int>? imageBytes;


  initialProvider() {
    countryCodeController = TextEditingController();
    mobileNumberController = TextEditingController();
    firstNameController = TextEditingController();
    middleNameController = TextEditingController();
    emailController = TextEditingController();
    coachemailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    lastNameController = TextEditingController();
    DatePickerController = TextEditingController();
    RolechosenController = TextEditingController();
    gender = TextEditingController();
    address = TextEditingController();
    address2Controller = TextEditingController();
    cityController = TextEditingController();
    stateController = TextEditingController();
    zipController = TextEditingController();
    altEmailController = TextEditingController();
    altContactController = TextEditingController();
    familyController = TextEditingController();
    ssoLoginId = TextEditingController();
    _autoValidate = false;
    getCountryCodeAsync();
    getCountryCodeAsyncs();
    /*if (kIsWeb) {
      getCountryCodeAsync();}*/
  }


  Future<void> getCountryCodeAsyncs() async {
    first =
    "${await SharedPrefManager.instance.getStringAsync(Constants.countryCode)}";
      dateformat = first;
      print(dateformat);
  }

  void setAutoValidate(bool value) {
    //_autoValidate = value;
    _autoValidate = true;
    notifyListeners();
  }

  bool? get getAutoValidate => _autoValidate;

  createAccountAsync(String userID,String teamID,String emailID,int status,bool updatePassword, int userRoleID) async {
    PlayerMailResponse _playerMailRequest = PlayerMailResponse();
    _playerMailRequest.teamId=int.parse(teamID);
    _playerMailRequest.userId=userID.isNotEmpty?int.parse(userID):int.parse( "${await SharedPrefManager.instance.getStringAsync(Constants.userIdNo)}");
    _playerMailRequest.userEmailId=emailID.isNotEmpty?emailID:"${await SharedPrefManager.instance.getStringAsync(Constants.userEmail)}";
    _playerMailRequest.playerAvailabilityStatusId=status;
    _playerMailRequest.password=passwordController!.text;
    _playerMailRequest.isUpdatePassword=updatePassword;
    _playerMailRequest.UserRoleID=userRoleID;



    try {
      await ApiManager()
          .getDio()!
          .post(Endpoints.playerRespondRequest, data: _playerMailRequest)
          .then((response) => playermailResponse(response))
          .catchError((onError) {
        listener.onFailure(DioErrorUtil.handleErrors(onError));
      });
    } catch (e) {
      listener.onFailure(ExceptionErrorUtil.handleErrors(e));
    }
  }

  void playermailResponse(Response response) {
    ValidateUserResponse _response = ValidateUserResponse.fromJson(response.data);
    listener.onSuccess(_response, reqId: ResponseIds.PLAYER_MAIL_RESPONSE);
  }

  putValidateUserAsync() async {
    _validateUserRequest = ValidateUserRequest();
    _validateUserRequest!.userInput =emailController!.text.isEmpty?ssoLoginId!.text:emailController!.text;
    _validateUserRequest!.userPassword =passwordController!.text;
    _validateUserRequest!.isRequestFromMail =false;

    try {
      await ApiManager()
          .getDio()!
          .post(Endpoints.serverValidateUrl+Endpoints.signupValidate, data: _validateUserRequest)
          .then((response) => registerValidateUserResponse(response))
          .catchError((onError) {
        listener.onFailure(DioErrorUtil.handleErrors(onError));
      });
    } catch (e) {
      listener.onFailure(ExceptionErrorUtil.handleErrors(e));
    }
  }

  void registerValidateUserResponse(Response response) {
    ValidateUserResponse _response = ValidateUserResponse.fromJson(response.data);
    listener.onSuccess(_response, reqId: ResponseIds.SIGNUP_SCREEN_VALIDATE);
  }

  putValidateForgetUserAsync(bool isMail) async {
    _validateUserRequest = ValidateUserRequest();
    _validateUserRequest!.userInput =emailController!.text;
    // _validateUserRequest.userPassword =passwordController.text;
    _validateUserRequest!.isRequestFromMail =isMail;

    try {
      await ApiManager()
          .getDio()!
          .post(Endpoints.serverValidateUrl+Endpoints.signupValidate, data: _validateUserRequest)
          .then((response) => registerValidateForgetPasswordResponse(response))
          .catchError((onError) {
        listener.onFailure(DioErrorUtil.handleErrors(onError));
      });
    } catch (e) {
      listener.onFailure(ExceptionErrorUtil.handleErrors(e));
    }
  }

  void registerValidateForgetPasswordResponse(Response response) {
    PlayerProfileResponse _response = PlayerProfileResponse.fromJson(response.data);
    listener.onSuccess(_response, reqId: ResponseIds.SIGNUP_SCREEN_VALIDATE);
  }

  putSignupAsync(String userID) async {
    _signupRequest = SignUpRequest();
    _signupRequest!.userEmailID =emailController!.text;
    _signupRequest!.userFirstName = firstNameController!.text;
    _signupRequest!.userPassword =passwordController!.text;
    _signupRequest!.userMiddleName = middleNameController!.text;
    _signupRequest!.userLastName = lastNameController!.text;
    if(DatePickerController!.text.isNotEmpty){
      DateFormat formatter =  dateformat == "US"
          ?DateFormat("MM/dd/yyyy"):dateformat == "CA"?DateFormat("yyyy/MM/dd"): DateFormat("dd/MM/yyyy");
      DateTime dateTime = formatter.parse(DatePickerController!.text);
      _signupRequest!.userDOB = DateFormat('yyyy-MM-dd').format(dateTime);
    }
   // _signupRequest.userDOB = DatePickerController.text;
    //_signupRequest.roleIDNo = "${await SharedPrefManager.instance.getStringAsync(Constants.roleId)}";
    _signupRequest!.userCountry = countryCodeController!.text;
    _signupRequest!.userGender = (gender!.text==MyStrings.male?"M":gender!.text==MyStrings.female?"F":gender!.text==MyStrings.others?"O":"");
    _signupRequest!.userAddress1 = address!.text;
    _signupRequest!.userAddress2 = address2Controller!.text;
    _signupRequest!.userCity = cityController!.text;
    _signupRequest!.userState = stateController!.text;
    _signupRequest!.userZip = zipController!.text;
    _signupRequest!.image = imageBytes??[];
    _signupRequest!.userAlternateEmailID = altEmailController!.text;
    _signupRequest!.userAlternatePhone = int.parse(altContactController!.text.isNotEmpty?altContactController!.text:"0");
    _signupRequest!.userPrimaryPhone = int.parse(mobileNumberController!.text.isNotEmpty?mobileNumberController!.text:"0");
    _signupRequest!.UserIDNo = userID != ""?int.parse(userID):-1;
    _signupRequest!.googleLoginId = ssoLoginId!.text;
    _signupRequest!.facebookLoginId = ssoLoginId!.text;
      _signupRequest!.FCMTokenID =
      "${await SharedPrefManager.instance.getStringAsync(Constants.FCM)}";

    try {
      await ApiManager()
              .getDio()!
              .post(Endpoints.addUpdateUserUrl, data: _signupRequest)
              .then((response) => registerResponse(response))
              .catchError((onError) {
            listener.onFailure(DioErrorUtil.handleErrors(onError));
          });
    } catch (e) {
      listener.onFailure(ExceptionErrorUtil.handleErrors(e));
    }
  }

  void registerResponse(Response response) {
    SignUpResponse _response = SignUpResponse.fromJson(response.data);
    getExistingPlayer();
    listener.onSuccess(_response, reqId: ResponseIds.SIGNUP_SCREEN);
  }
  /*
Return Type:
Input Parameters:
Use: Create API Calls and Handle Exceptions.
 */
  getExistingPlayer() async {
    try {
      // GetDrillCategoryRequest getDrillCategoryRequest=GetDrillCategoryRequest();
      // getDrillCategoryRequest.email=emailController!.text;
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

  clearProvider() {
    firstNameController!.clear();
    emailController!.clear();
    passwordController!.clear();
    confirmPasswordController!.clear();
    lastNameController!.clear();
    DatePickerController!.clear();
    RolechosenController!.clear();
  }

  bool get getIsagree => _isagree;

  void setIsagree(bool value) {
    _isagree = value;
    notifyListeners();
  }

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
        SharedPrefManager.instance.setStringAsync(Constants.countryName, "US");
        SharedPrefManager.instance
            .setStringAsync(Constants.countryCode, countryCode!);
      }
    })
        .catchError((onError) {
      print(onError);
      //listener.onFailure(DioErrorUtil.handleErrors(onError));
    });
  }
}




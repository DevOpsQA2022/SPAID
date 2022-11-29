import 'package:chewie/chewie.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spaid/base/base_provider.dart';
import 'package:spaid/model/request/add_player_request/add_player_request.dart';
import 'package:spaid/model/response/add_player_response/add_player_response.dart';
import 'package:spaid/service/api_manager.dart';
import 'package:spaid/service/dio_error_util.dart';
import 'package:spaid/service/endpoints.dart';
import 'package:spaid/service/exception_error_util.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/support/response_ids.dart';
import 'package:spaid/support/strings.dart';
import 'package:spaid/utils/shared_pref_manager.dart';
import 'package:video_player/video_player.dart';

class AddVideoProvider extends BaseProvider {
  //region Private Members

  TextEditingController? title;
  TextEditingController? description;
  TextEditingController? videoPath;
bool isEnable=true;
  bool? _autoValidate;


//endregion

  /*
Return Type:
Input Parameters:
Use: Initiate value to the variable and create object.
 */
  initialProvider() {
    title = TextEditingController();
    description = TextEditingController();
    videoPath = TextEditingController();
    _autoValidate = false;

  }


  /*
Return Type:
Input Parameters:
Use: Create API Calls and Handle Exceptions.
 */
  AddPlayerAsync() async {
/*
    try {
      _addPlayerRequest = AddPlayerRequest();
      _addPlayerRequest.firstName = firstNameController.text;
      _addPlayerRequest.lastName = lastNameController.text;
      DateFormat formatter = new DateFormat('dd/mm/yyyy');
      DateTime dateTime = formatter.parse(DatePickerController.text);
      _addPlayerRequest.dateOfBirth = DateFormat('yyyy-mm-dd').format(dateTime);
      _addPlayerRequest.jerseyNo = jersetNumberController.text;
      _addPlayerRequest.position = positionController.text;
      _addPlayerRequest.emailId = emailController.text;
      _addPlayerRequest.altEmailId = altemailController.text;
      _addPlayerRequest.contactNo = int.parse(contactPhoneController.text != ""
          ? contactPhoneController.text
          : "0");
      _addPlayerRequest.altContactNo = int.parse(
          altcontactPhoneController.text != ""
              ? altcontactPhoneController.text
              : "0");
      _addPlayerRequest.address = addressController.text;
      _addPlayerRequest.altAddress = altaddressController.text;
      _addPlayerRequest.city = cityController.text;
      _addPlayerRequest.state = stateController.text;
      _addPlayerRequest.zipCode = zipcodeController.text;
      _addPlayerRequest.gender = genderController.text == MyStrings.male
          ? "M"
          : genderController.text == MyStrings.female
              ? "F"
              : "N";
      _addPlayerRequest.isManager = _isManager ? -10001 : 0;
      _addPlayerRequest.isNonPlayer = _isNonPlayer ? 0 : 1;
      _addPlayerRequest.UserIDNo = int.parse(
          "${await SharedPrefManager.instance.getStringAsync(Constants.userIdNo)}");
      _addPlayerRequest.teamName =
          "${await SharedPrefManager.instance.getStringAsync(Constants.teamName)}";

      await ApiManager()
          .getDio()
          .post(Endpoints.addPlayer, data: _addPlayerRequest)
          .then((response) => registerResponse(response))
          .catchError((onError) {
        listener.onFailure(DioErrorUtil.handleErrors(onError));
      });
    } catch (e) {
      listener.onFailure(ExceptionErrorUtil.handleErrors(e));
    }
*/
  }

  void registerResponse(Response response) {
    print(response);
    AddPlayerResponse _response = AddPlayerResponse.fromJson(response.data);
    // Navigation.navigateTo(context, MyRoutes.homeScreen);
    listener.onSuccess(_response, reqId: ResponseIds.ADD_PLAYER_SCREEN);
  }
  bool? get getAutoValidate => _autoValidate;


}

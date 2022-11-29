import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spaid/base/base_provider.dart';
import 'package:spaid/model/request/add_player_request/add_player_request.dart';
import 'package:spaid/model/response/add_player_response/add_player_response.dart';
import 'package:spaid/model/response/signup_response/validate_user_response.dart';
import 'package:spaid/service/api_manager.dart';
import 'package:spaid/service/dio_error_util.dart';
import 'package:spaid/service/endpoints.dart';
import 'package:spaid/service/exception_error_util.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/support/response_ids.dart';
import 'package:spaid/support/strings.dart';
import 'package:spaid/utils/shared_pref_manager.dart';

class AddPlayerProvider extends BaseProvider {
  //region Private Members
  bool? isManager;
  bool? isNonPlayer;
  TextEditingController? firstNameController;
  TextEditingController? lastNameController;
  TextEditingController? DatePickerController;
  TextEditingController? jersetNumberController;
  TextEditingController? positionController;
  TextEditingController? emailController;
  TextEditingController? altemailController;
  TextEditingController? contactPhoneController;
  TextEditingController? altcontactPhoneController;
  TextEditingController? addressController;
  TextEditingController? altaddressController;
  TextEditingController? cityController;
  TextEditingController? stateController;
  TextEditingController? zipcodeController;
  TextEditingController? genderController;
  TextEditingController? noteController;
  TextEditingController? medicalNoteController;
  TextEditingController? shootController;
  String selectedYear="";
  String? dateformat, first;

  bool? _autoValidate;
  AddPlayerRequest? _addPlayerRequest;

//endregion

  /*
Return Type:
Input Parameters:
Use: Initiate value to the variable and create object.
 */
  initialProvider() {
    jersetNumberController = TextEditingController();
    positionController = TextEditingController();
    firstNameController = TextEditingController();
    contactPhoneController = TextEditingController();
    altcontactPhoneController = TextEditingController();
    emailController = TextEditingController();
    altemailController = TextEditingController();
    addressController = TextEditingController();
    altaddressController = TextEditingController();
    cityController = TextEditingController();
    lastNameController = TextEditingController();
    DatePickerController = TextEditingController();
    stateController = TextEditingController();
    zipcodeController = TextEditingController();
    genderController = TextEditingController();
    noteController = TextEditingController();
    medicalNoteController = TextEditingController();
    shootController = TextEditingController();
    isManager = false;
    isNonPlayer = false;
    _autoValidate = false;
    getCountryCodeAsyncs();
  }
  Future<void> getCountryCodeAsyncs() async {
    first =
    "${await SharedPrefManager.instance.getStringAsync(Constants.countryCode)}";

      dateformat = first;
      print(dateformat);

  }
  /*
Return Type:
Input Parameters:Bool
Use: Initiate value to the variable and create object.
 */
  void setAutoValidate(bool value) {
    _autoValidate = true;
    notifyListeners();
  }

  /*
Return Type:
Input Parameters:Bool
Use: Initiate value to the variable and create object.
 */
  void setManager(bool value) {
    isManager = value;
    notifyListeners();
  }

  /*
Return Type:
Input Parameters:Bool
Use: Initiate value to the variable and create object.
 */
  void setNonPlayer(bool value) {
    isNonPlayer = value;
    notifyListeners();
  }

  bool? get getAutoValidate => _autoValidate;

  bool? get getManager => isManager;

  bool? get getNonPlayer => isNonPlayer;

  /*
Return Type:
Input Parameters:
Use: Create API Calls and Handle Exceptions.
 */
  AddPlayerAsync(List<int> imageBytes, int roleID,) async {
    try {
      _addPlayerRequest = AddPlayerRequest();
      _addPlayerRequest!.firstName = firstNameController!.text;
      _addPlayerRequest!.lastName = lastNameController!.text;
      DateFormat formatter =  dateformat == "US"
          ?DateFormat("MM/dd/yyyy"):dateformat == "CA"?DateFormat("yyyy/MM/dd"): DateFormat("dd/MM/yyyy");
      DateTime dateTime = formatter.parse(DatePickerController!.text);
      _addPlayerRequest!.dateOfBirth = DateFormat('yyyy-MM-dd').format(dateTime);
      _addPlayerRequest!.jerseyNo = jersetNumberController!.text;
      _addPlayerRequest!.position = positionController!.text;
      _addPlayerRequest!.emailId = emailController!.text;
      _addPlayerRequest!.altEmailId = altemailController!.text;
      _addPlayerRequest!.contactNo = int.parse(contactPhoneController!.text != ""
          ? contactPhoneController!.text.replaceAll(new RegExp(r"[^\s\w]"), "").replaceAll(" ", "")
          : "0");
      _addPlayerRequest!.altContactNo = int.parse(
          altcontactPhoneController!.text != ""
              ? altcontactPhoneController!.text.replaceAll(new RegExp(r"[^\s\w]"), "").replaceAll(" ", "")
              : "0");
      _addPlayerRequest!.address = addressController!.text;
      _addPlayerRequest!.altAddress = altaddressController!.text;
      _addPlayerRequest!.city = cityController!.text;
      _addPlayerRequest!.state = stateController!.text;
      _addPlayerRequest!.zipCode = zipcodeController!.text;
      _addPlayerRequest!.shoot = shootController!.text;
      _addPlayerRequest!.medicalNote = medicalNoteController!.text;
      _addPlayerRequest!.note = noteController!.text;
      _addPlayerRequest!.gender = genderController!.text == MyStrings.male
          ? "M"
          : genderController!.text == MyStrings.female
              ? "F":genderController!.text == MyStrings.others?"O"
              : "";
      _addPlayerRequest!.isManager = roleID;
      _addPlayerRequest!.isNonPlayer = isNonPlayer! ? 1 : 0;
      _addPlayerRequest!.UserIDNo = -1;
      _addPlayerRequest!.TeamIDNo =
         int.parse( "${await SharedPrefManager.instance.getStringAsync(Constants.teamID)}");
      _addPlayerRequest!.image=imageBytes;
      _addPlayerRequest!.managerIdNo=int.parse( "${await SharedPrefManager.instance.getStringAsync(Constants.userIdNo)}");

      await ApiManager()
          .getDio()!
          .post(Endpoints.addPlayer, data: _addPlayerRequest)
          .then((response) => registerResponse(response))
          .catchError((onError) {
        listener.onFailure(DioErrorUtil.handleErrors(onError));
      });
    } catch (e) {
      listener.onFailure(ExceptionErrorUtil.handleErrors(e));
    }
  }

  void registerResponse(Response response) {
    print(response);
    ValidateUserResponse _response = ValidateUserResponse.fromJson(response.data);
    // Navigation.navigateTo(context, MyRoutes.homeScreen);
    listener.onSuccess(_response, reqId: ResponseIds.ADD_PLAYER_SCREEN);
  }

  clearProvider() {
    firstNameController!.clear();
    emailController!.clear();
    jersetNumberController!.clear();
    positionController!.clear();
    lastNameController!.clear();
    DatePickerController!.clear();
    contactPhoneController!.clear();
    addressController!.clear();
    cityController!.clear();
    stateController!.clear();
    zipcodeController!.clear();
    genderController!.clear();
    isManager = false;
    isNonPlayer = false;
  }
}

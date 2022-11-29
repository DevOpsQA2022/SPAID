import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spaid/base/base_provider.dart';
import 'package:spaid/model/request/add_player_request/add_player_request.dart';
import 'package:spaid/model/request/add_player_request/get_existing_player_request.dart';
import 'package:spaid/model/request/edit_player_request/edit_players_details_request.dart';
import 'package:spaid/model/request/get_drill_request.dart';
import 'package:spaid/model/request/roaster_listview_request/team_members_details_request.dart';
import 'package:spaid/model/request/select_team_request/select_team_request.dart';
import 'package:spaid/model/response/add_player_response/add_existing_player_response.dart';
import 'package:spaid/model/response/add_player_response/add_player_response.dart';
import 'package:spaid/model/response/edit_players_details_response/edit_players_details_response.dart';
import 'package:spaid/model/response/player_profile_response/player_profile_response.dart';
import 'package:spaid/model/response/roaster_listview_response/team_members_details_response.dart';
import 'package:spaid/model/response/signup_response/validate_user_response.dart';
import 'package:spaid/service/api_manager.dart';
import 'package:spaid/service/dio_error_util.dart';
import 'package:spaid/service/email_service.dart';
import 'package:spaid/service/endpoints.dart';
import 'package:spaid/service/exception_error_util.dart';
import 'package:spaid/service/firebase_dynamic_link_service.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/support/email_template.dart';
import 'package:spaid/support/response_ids.dart';
import 'package:spaid/support/strings.dart';
import 'package:spaid/utils/shared_pref_manager.dart';

import '../../model/request/search_email_request.dart';

class EditPlayerProvider extends BaseProvider {
  //region Private Members
  bool? isManager;
  bool? isNonPlayer;
  String? roleID;
  int? userRoleId;
  int? UserIDNo,playerAvailabilityStatusId;
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
  List<TextEditingController> familyFirstnamecontroller = [];
  List<TextEditingController> familyLastnamecontroller = [];
  List<TextEditingController> familyEmailcontroller = [];
  List<TextEditingController> familyContactcontroller = [];
  List<TextEditingController> familyAddresscontroller = [];
  List<TextEditingController> familyCitycontroller = [];
  List<TextEditingController> familyStatecontroller = [];
  List<TextEditingController> familyZipcodecontroller = [];
  List<TextEditingController> familyuserIDcodecontroller = [];
  List<TextEditingController> familyMiddleNamecontroller = [];
  List<TextEditingController> familyDOBcontroller = [];
  List<TextEditingController> familyGendercontroller = [];
  List<TextEditingController> familyCountrycontroller = [];
  List<TextEditingController> familyAddress2controller = [];
  List<TextEditingController> familyAltEmailcontroller = [];
  List<TextEditingController> familyAltContactcontroller = [];
  List<TextEditingController> familyFCMcontroller = [];
  List<TextEditingController> familyPlayerAvailabilitycontroller = [];
  String selectedYear = "";
  SelectTeamRequest? _selectTeamRequest;
  bool? _autoValidate;
  AddPlayerRequest? _addPlayerRequest;
  AddPlayerRequest? _addFamilyRequest;
  GetTeamMemberDetailsRequest? _getTeamMemberDetailsRequest;
  int? userid,teamId;
  String? dateformat, first;
bool isMemberExist=false;
  //endregion

  /*
Return Type:
Input Parameters:
Use: Initiate value to the variable and create object.
 */
  initialProvider(int userId, String playerRoleId) async{
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
    familyFirstnamecontroller = [];
    familyLastnamecontroller = [];
    familyEmailcontroller = [];
    familyContactcontroller = [];
    familyAddresscontroller = [];
    familyCitycontroller = [];
    familyStatecontroller = [];
    familyZipcodecontroller = [];
    familyuserIDcodecontroller = [];
    familyMiddleNamecontroller = [];
    familyDOBcontroller = [];
    familyGendercontroller = [];
    familyCountrycontroller = [];
    familyAddress2controller = [];
    familyAltEmailcontroller = [];
    familyAltContactcontroller = [];
    familyFCMcontroller = [];
    familyPlayerAvailabilitycontroller = [];
    userid=userId;
    getCountryCodeAsyncs();
    teamId=int.parse("${await SharedPrefManager.instance.getStringAsync(
        Constants.teamID)}");
    if(userId!=0) {
      getPlayersDetailsAsync(userId,playerRoleId);
    }
  }

  Future<void> getCountryCodeAsyncs() async {
    first =
    "${await SharedPrefManager.instance.getStringAsync(Constants.countryCode)}";
    dateformat = first;
    print(dateformat);
  }

  /*
Return Type:
Input Parameters:
Use: Create API Calls and Handle Exceptions.
 */
  getPlayersDetailsAsync(int userId, String playerRoleId) async {
    try {
      _getTeamMemberDetailsRequest = GetTeamMemberDetailsRequest();
      //_selectTeamRequest.userIdNo = 1;
      _getTeamMemberDetailsRequest!.userIDNo =userId != null?userId:int.parse( "${await SharedPrefManager.instance.getStringAsync(Constants.userIdNo)}");
      _getTeamMemberDetailsRequest!.teamIDNo =int.parse( "${await SharedPrefManager.instance.getStringAsync(Constants.teamID)}");
      _getTeamMemberDetailsRequest!.UserRoleId =int.parse( await SharedPrefManager.instance.getStringAsync(Constants.playerRoleId));

      await ApiManager()
          .getDio()!
          .post(Endpoints.getTeamMember, data: _getTeamMemberDetailsRequest)
          .then((response) => registerEditPlayerResponse(response))
          .catchError((onError) {
        listener.onFailure(DioErrorUtil.handleErrors(onError));
      });

    } catch (e) {
      listener.onFailure(ExceptionErrorUtil.handleErrors(e));
    }
  }

  void registerEditPlayerResponse(Response response) {
    TeamMembersDetailsResponse _response = TeamMembersDetailsResponse.fromJson(response.data);
    listener.onSuccess(_response, reqId: ResponseIds.EDIT_PLAYER_SCREEN);
  }
/*
Return Type:
Input Parameters:
Use: Create API Calls and Handle Exceptions.
 */
  getExistingPlayer(int userID) async {
    try {


      await ApiManager()
          .getDio()!
          .post(Endpoints.getUserDetailsUrl, data: userID)
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
      listener.onSuccess(_response, reqId: ResponseIds.ADD_EXISTING_PLAYER);
    } catch (e) {

      print(e);
    }
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
  void setUserID(int value) {
    UserIDNo = value;
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
  updatePlayerAsync(List<int> imageBytes, int roleID) async {
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
          ? contactPhoneController!.text
          : "0");
      _addPlayerRequest!.altContactNo = int.parse(
          altcontactPhoneController!.text != ""
              ? altcontactPhoneController!.text
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
          :"";

      _addPlayerRequest!.isManager = roleID;
if(roleID== Constants.owner){
  if(isManager! && !isNonPlayer!){
    _addPlayerRequest!.isNonPlayer = 3;

  }else{
    _addPlayerRequest!.isNonPlayer = isNonPlayer! && isManager! ? 2 :isNonPlayer!?1: 0;

  }
}else{
  _addPlayerRequest!.isNonPlayer = isNonPlayer! ? 1 : 0;
}
      _addPlayerRequest!.UserIDNo = UserIDNo!;
      _addPlayerRequest!.UserRoleId = userRoleId!;
      _addPlayerRequest!.PlayerAvailabilityStatusId = playerAvailabilityStatusId!;
      _addPlayerRequest!.image = imageBytes;
      _addPlayerRequest!.TeamIDNo =
      int.parse("${await SharedPrefManager.instance.getStringAsync(Constants.teamID)}");
    /* Map arg ={
        ' data ' : _addPlayerRequest,
        ' UserRoleId ' : userRoleId,
      };*/
      await ApiManager()
          .getDio()!
          .post(Endpoints.setEditPlayer, data: _addPlayerRequest)
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
    AddPlayerResponse _response = AddPlayerResponse.fromJson(response.data);

    // Navigation.navigateTo(context, MyRoutes.homeScreen);
    listener.onSuccess(_response, reqId: ResponseIds.EDIT_PLAYER_SCREENS);
  }

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
          .then((response) => registerAddPlayerResponse(response))
          .catchError((onError) {
        listener.onFailure(DioErrorUtil.handleErrors(onError));
      });
    } catch (e) {
      listener.onFailure(ExceptionErrorUtil.handleErrors(e));
    }
  }

  void registerAddPlayerResponse(Response response) {
    print(response);
    ValidateUserResponse _response = ValidateUserResponse.fromJson(response.data);
    // Navigation.navigateTo(context, MyRoutes.homeScreen);
    listener.onSuccess(_response, reqId: ResponseIds.ADD_PLAYER_SCREEN);
  }

  /*
Return Type:
Input Parameters:
Use: Create API Calls and Handle Exceptions.
 */
  addExistingPlayerAsync(List<int> imageBytes, int roleID) async {
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
      _addPlayerRequest!.gender = genderController!.text == MyStrings.male
          ? "M"
          : genderController!.text == MyStrings.female
          ? "F":genderController!.text == MyStrings.others?"O"
          : "";
      _addPlayerRequest!.isManager = roleID;
      _addPlayerRequest!.isNonPlayer = isNonPlayer! ? 1 : 0;
      _addPlayerRequest!.UserIDNo = UserIDNo!;
     // _addPlayerRequest.PlayerAvailabilityStatusId = playerAvailabilityStatusId;
      _addPlayerRequest!.image = imageBytes;
      _addPlayerRequest!.TeamIDNo =
          int.parse("${await SharedPrefManager.instance.getStringAsync(Constants.teamID)}");
      _addPlayerRequest!.managerIdNo=int.parse( "${await SharedPrefManager.instance.getStringAsync(Constants.userIdNo)}");


      await ApiManager()
          .getDio()!
          .post(Endpoints.addPlayer, data: _addPlayerRequest)
          .then((response) => addExistingPlayerResponse(response))
          .catchError((onError) {
        listener.onFailure(DioErrorUtil.handleErrors(onError));
      });
    } catch (e) {
      listener.onFailure(ExceptionErrorUtil.handleErrors(e));
    }
  }

  void addExistingPlayerResponse(Response response) {
    print(response);
    ValidateUserResponse _response = ValidateUserResponse.fromJson(response.data);

    // Navigation.navigateTo(context, MyRoutes.homeScreen);
    listener.onSuccess(_response, reqId: ResponseIds.EDIT_PLAYER_SCREENS);
  }


  /*
Return Type:
Input Parameters:
Use: Create API Calls and Handle Exceptions.
 */
  UpdateFamilyAsync(int index, int userId) async {
    try {
          _addPlayerRequest = AddPlayerRequest();
          _addPlayerRequest!.firstName = familyFirstnamecontroller[index].text;
          _addPlayerRequest!.lastName = familyLastnamecontroller[index].text;
          _addPlayerRequest!.dateOfBirth =familyDOBcontroller[index].text;
          _addPlayerRequest!.emailId = familyEmailcontroller[index].text;
          _addPlayerRequest!.altEmailId = familyAltEmailcontroller[index].text;
          _addPlayerRequest!.contactNo =int.parse(familyContactcontroller[index].text != null && familyContactcontroller[index].text.isNotEmpty?familyContactcontroller[index].text:"0");
          _addPlayerRequest!.altContactNo = int.parse(familyAltContactcontroller[index].text !=null && familyAltContactcontroller[index].text.isNotEmpty?familyAltContactcontroller[index].text:"0");
          _addPlayerRequest!.address = familyAddresscontroller[index].text;
          _addPlayerRequest!.altAddress = familyAddress2controller[index].text;
          _addPlayerRequest!.city = familyCitycontroller[index].text;
          _addPlayerRequest!.state = familyStatecontroller[index].text;
          _addPlayerRequest!.zipCode = familyZipcodecontroller[index].text;
          _addPlayerRequest!.gender = familyGendercontroller[index].text;
          _addPlayerRequest!.isManager = Constants.familyMember;
          _addPlayerRequest!.UserIDNo = int.parse(familyuserIDcodecontroller[index].text);
          _addPlayerRequest!.PlayerAvailabilityStatusId =
              playerAvailabilityStatusId!;
          _addPlayerRequest!.TeamIDNo =teamId!;
          _addPlayerRequest!.createdby =userId;

          await ApiManager()
              .getDio()!
              .post(Endpoints.setEditPlayer, data: _addPlayerRequest)
              .then((response) => updateFamilyResponse(response))
              .catchError((onError) {
            listener.onFailure(DioErrorUtil.handleErrors(onError));
          });

    } catch (e) {
      listener.onFailure(ExceptionErrorUtil.handleErrors(e));
    }
  }

  void updateFamilyResponse(Response response) {
    print(response);
    AddPlayerResponse _response = AddPlayerResponse.fromJson(response.data);

    // Navigation.navigateTo(context, MyRoutes.homeScreen);
  //  listener.onSuccess(_response, reqId: ResponseIds.EDIT_PLAYER_SCREENS);
  }


  /*
Return Type:
Input Parameters:
Use: Create API Calls and Handle Exceptions.
 */
  AddFamilyAsync(int index) async {
    try {
      checkExistingMember(index);
        _addFamilyRequest = AddPlayerRequest();
        _addFamilyRequest!.firstName = familyFirstnamecontroller[index].text;
        _addFamilyRequest!.lastName = familyLastnamecontroller[index].text;
        _addFamilyRequest!.emailId = familyEmailcontroller[index].text;
        _addFamilyRequest!.contactNo =
            int.parse(familyContactcontroller[index].text != ""
                ? familyContactcontroller[index].text.replaceAll(
                new RegExp(r"[^\s\w]"), "").replaceAll(" ", "")
                : "0");
        _addFamilyRequest!.address = familyAddresscontroller[index].text;
        _addFamilyRequest!.city = familyCitycontroller[index].text;
        _addFamilyRequest!.state = familyStatecontroller[index].text;
        _addFamilyRequest!.zipCode = familyZipcodecontroller[index].text;
        _addFamilyRequest!.isManager = Constants.familyMember;
        _addFamilyRequest!.isNonPlayer = isNonPlayer! ? 1 : 0;
        _addFamilyRequest!.UserIDNo = -1;
        _addFamilyRequest!.createdby = int.parse( await SharedPrefManager.instance.getStringAsync(Constants.playerRoleId));
        _addFamilyRequest!.TeamIDNo =teamId!;
      _addPlayerRequest!.managerIdNo=int.parse( "${await SharedPrefManager.instance.getStringAsync(Constants.userIdNo)}");



      await ApiManager()
            .getDio()!
            .post(Endpoints.addPlayer, data: _addFamilyRequest)
            .then((response) => addFamilyMemberResponse(response,index))
            .catchError((onError) {
          listener.onFailure(DioErrorUtil.handleErrors(onError));
        });
    } catch (e) {
      listener.onFailure(ExceptionErrorUtil.handleErrors(e));
    }
  }

  void addFamilyMemberResponse(Response response, int index) async{
    print(response);
    ValidateUserResponse _response = ValidateUserResponse.fromJson(response.data);
    if (_response.responseResult == Constants.success) {
      var response=_response.responseMessage!.split(",");

      DynamicLinksService().createDynamicLink("create_Password_Screen?userid="+response.first+"&teamid="+"${await SharedPrefManager.instance.getStringAsync(Constants.teamID)}"+"&team="+await SharedPrefManager.instance.getStringAsync(Constants.teamName)+"&player="+familyFirstnamecontroller[index].text+"&manager="+await SharedPrefManager.instance.getStringAsync(Constants.userName)+"&email="+familyEmailcontroller[index].text+"&userRoleId="+response.last+"&fcm="+(await SharedPrefManager.instance.getStringAsync(Constants.FCM)).toString()+"&isMemberExist="+isMemberExist.toString()+"&toMail="+(await SharedPrefManager.instance.getStringAsync(Constants.userId)).toString()+"&toID="+(await SharedPrefManager.instance.getStringAsync(Constants.userIdNo)).toString()).then((acceptvalue) async {
        print(acceptvalue);
        DynamicLinksService().createDynamicLink("intro_Screen?userid="+response.first+"&teamid="+"${await SharedPrefManager.instance.getStringAsync(Constants.teamID)}"+"&email="+familyEmailcontroller[index].text+"&userRoleId="+response.last+"&team="+await SharedPrefManager.instance.getStringAsync(Constants.teamName)+"&player="+familyFirstnamecontroller[index].text+"&manager="+await SharedPrefManager.instance.getStringAsync(Constants.userName)+"&fcm="+(await SharedPrefManager.instance.getStringAsync(Constants.FCM)).toString()+"&toMail="+(await SharedPrefManager.instance.getStringAsync(Constants.userId)).toString()+"&toID="+(await SharedPrefManager.instance.getStringAsync(Constants.userIdNo)).toString()).then((declainvalue) async {
          print(declainvalue);
          EmailService().invitePlayer("Invitation mail","Invitation",Constants.teamInvite,userid!,int.parse(response.first),int.parse( "${await SharedPrefManager.instance.getStringAsync(Constants.teamID)}"),"You have been invited to join "+"${await SharedPrefManager.instance.getStringAsync(Constants.teamName)}", familyEmailcontroller[index].text,familyFirstnamecontroller[index].text+" "+familyLastnamecontroller[index].text,acceptvalue,declainvalue,"${await SharedPrefManager.instance.getStringAsync(Constants.teamName)}","${await SharedPrefManager.instance.getStringAsync(Constants.userName)}");

        });
      });

     /* DynamicLinksService().createDynamicLink("intro_Screen?username="+Constants.accept.toString()).then((acceptvalue){
        print(acceptvalue);
        DynamicLinksService().createDynamicLink("intro_Screen?username="+Constants.reject.toString()).then((declainvalue) async {
          print(declainvalue);
          EmailService().invitePlayer("Invitation mail","Invitation",InviteMember.inviteMember.replaceAll("{{playername}}", familyFirstnamecontroller[index].text).replaceAll("{{acceptlink}}}", acceptvalue).replaceAll("{{declainlink}}}", declainvalue).replaceAll("{{teamname}}", "${await SharedPrefManager.instance.getStringAsync(Constants.teamName)}").replaceAll("{{managername}}", "${await SharedPrefManager.instance.getStringAsync(Constants.userName)}"),Constants.teamInvite,userid,int.parse(_response.responseMessage),int.parse( "${await SharedPrefManager.instance.getStringAsync(Constants.teamID)}"),"You have been invited to join "+"${await SharedPrefManager.instance.getStringAsync(Constants.teamName)}",familyEmailcontroller[index].text);

        });
      });*/

    }
    // Navigation.navigateTo(context, MyRoutes.homeScreen);
   // listener.onSuccess(_response, reqId: ResponseIds.ADD_FAMILY);
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
  checkExistingMember(int index) async {
    try {
      // GetDrillCategoryRequest getDrillCategoryRequest=GetDrillCategoryRequest();
      // getDrillCategoryRequest.email=familyEmailcontroller[index].text;
      SearchUserRequest _searchUserRequest= SearchUserRequest();
      _searchUserRequest.email=familyEmailcontroller[index].text;
      await ApiManager()
          .getDio()!
          .post(Endpoints.serverGameUrl+Endpoints.searchUserUsingMail, data:_searchUserRequest)
          .then((response) {
        AddExistingPlayerResponse _response = AddExistingPlayerResponse.fromJson(response.data);
        if ( _response.result != null && _response.result!.userIDNo != null &&_response.result!.userIDNo != Constants.success) {
          isMemberExist=true;

        }else if( _response.result == null && _response.result!.userIDNo==null){
          isMemberExist=false;
        }
      })
          .catchError((onError) {
        listener.onFailure(DioErrorUtil.handleErrors(onError));
      });
    } catch (e) {
      listener.onFailure(ExceptionErrorUtil.handleErrors(e));
    }
  }

  /*
Return Type:
Input Parameters:
Use: Create API Calls and Handle Exceptions.
 */
  getExistingPlayerByEmail(String email) async {
    try {
      SearchUserRequest _searchUserRequest= SearchUserRequest();
      _searchUserRequest.email=emailController!.text;

      await ApiManager()
          .getDio()!
          .post(Endpoints.serverGameUrl+Endpoints.searchUserUsingMail, data: _searchUserRequest)
          .then((response) => getExistingPlayerByEmailResponse(response))
          .catchError((onError) {
        listener.onFailure(DioErrorUtil.handleErrors(onError));
      });
    } catch (e) {
      listener.onFailure(ExceptionErrorUtil.handleErrors(e));
    }
  }
  void getExistingPlayerByEmailResponse(Response response) {
    try {
      AddExistingPlayerResponse _response = AddExistingPlayerResponse.fromJson(response.data);
      listener.onSuccess(_response, reqId: ResponseIds.ADD_EXISTING_PLAYER);
    } catch (e) {
      /*ValidateUserResponse _response= ValidateUserResponse.fromJson(response.data);
      listener.onFailure(ExceptionErrorUtil.handleErrors(_response.saveErrors[0].errorMessage));*/

      print(e);
    }
  }
}

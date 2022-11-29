import 'package:dio/dio.dart';
import 'package:spaid/base/base_provider.dart';
import 'package:spaid/model/request/add_player_request/get_existing_player_request.dart';
import 'package:spaid/model/request/get_drill_request.dart';

import 'package:spaid/model/request/roaster_listview_request/roaster_listview_request.dart';
import 'package:spaid/model/request/select_team_request/select_team_request.dart';
import 'package:spaid/model/response/add_player_response/add_existing_player_response.dart';
import 'package:spaid/model/response/roaster_listview_response/roaster_listview_response.dart';
import 'package:spaid/model/response/roaster_listview_response/user_roles_response.dart' as a;
import 'package:spaid/model/response/select_team_response/select_team_response.dart';
import 'package:spaid/model/response/signup_response/validate_user_response.dart';
import 'package:spaid/service/api_manager.dart';
import 'package:spaid/service/dio_error_util.dart';
import 'package:spaid/service/endpoints.dart';
import 'package:spaid/service/exception_error_util.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/support/response_ids.dart';
import 'package:spaid/utils/shared_pref_manager.dart';
import 'package:spaid/widgets/ProgressBar.dart';

import '../../../model/request/search_email_request.dart';

class RoasterListViewProvider extends BaseProvider {
  //region Private Members
  bool _isagree = false;
  List<Members>? _members;
  List<Team>? _teams;
  int? _totEvents;
  bool? _autoValidate;
  //RoasterListViewRequest _roasterListViewRequest;
  SelectTeamRequest? _selectTeamRequest;

//endregion

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
  void setRefreshScreen(){
    listener.onRefresh("");

  }

  /*
Return Type:
Input Parameters:
Use: Create API Calls and Handle Exceptions.
 */
  getSelectTeamAsync() async {
    try {


      await ApiManager()
          .getDio()!
          .post(Endpoints.getTeamMembersUrl, data: int.parse( "${await SharedPrefManager.instance.getStringAsync(Constants.teamID)}"))
          .then((response) => registerResponse(response))
          .catchError((onError) {
        listener.onFailure(DioErrorUtil.handleErrors(onError));
      });
    } catch (e) {
      listener.onFailure(ExceptionErrorUtil.handleErrors(e));
    }
  }
  void registerResponse(Response response) {
    RoasterListViewResponse _response = RoasterListViewResponse.fromJson(response.data);
    listener.onSuccess(_response, reqId: ResponseIds.GET_TEAM_MEMBER_SCREEN);
  }

    /*
Return Type:
Input Parameters:
Use: Create API Calls and Handle Exceptions.
 */
  getRolesAsync() async {
    try {

      await ApiManager()
          .getDio()!
          .get(Endpoints.getRoles)
          .then((response) => registerRolesResponse(response))
          .catchError((onError) {
        listener.onFailure(DioErrorUtil.handleErrors(onError));
      });
    } catch (e) {
      listener.onFailure(ExceptionErrorUtil.handleErrors(e));
    }
  }
  void registerRolesResponse(Response response) {
    a.UserRolesResponse _response = a.UserRolesResponse.fromJson(response.data);
    listener.onSuccess(_response, reqId: ResponseIds.GET_USER_ROLES);
  }
  /*
Return Type:
Input Parameters:
Use: Create API Calls and Handle Exceptions.
 */
  getExistingPlayer(String email) async {
    try {
      SearchUserRequest searchUserRequest= SearchUserRequest();
      searchUserRequest.email=email;
      print("$email");
      await ApiManager()
          .getDio()!
          .post(Endpoints.serverGameUrl+Endpoints.searchUserUsingMail, data: searchUserRequest)
          .then((response) => getExistingPlayerResponse(response))
          .catchError((onError) {
        listener.onFailure(DioErrorUtil.handleErrors(onError));
      });
    } catch (e) {
      listener.onFailure(ExceptionErrorUtil.handleErrors(e));
      print(e);
    }
  }
  void getExistingPlayerResponse(Response response) {
    try {
      AddExistingPlayerResponse _response = AddExistingPlayerResponse.fromJson(response.data);
      listener.onSuccess(_response, reqId: ResponseIds.ADD_EXISTING_PLAYER);
    } catch (e) {
      /*ValidateUserResponse _response= ValidateUserResponse.fromJson(response.data);
      listener.onFailure(ExceptionErrorUtil.handleErrors(_response.saveErrors[0].errorMessage));*/

      print(e);
    }
  }





  /*
Return Type:
Input Parameters:List
Use: Initiate value to the variable and create object.
 */
  void setTeamList(List<Team> teamList) {
    _teams = teamList;
    notifyListeners();
  }

  List<Team>? get getTeamList => _teams??[];

  /*
Return Type:
Input Parameters:List
Use: Initiate value to the variable and create object.
 */
  void setMemberList(List<Members> memberList) {
    _members = memberList;
    // memberList.sort((a, b) => ["roleIdNo"].compareTo(b["roleIdNo"]));
    notifyListeners();
  }

  List<Members>? get getMemberList => _members??[];

  /*
Return Type:
Input Parameters:int
Use: Initiate value to the variable and create object.
 */
  void setTotTeam(int totEvents) {
    _totEvents = totEvents;
    notifyListeners();
  }

  int? get getTotalEvents => _totEvents;

  bool get getIsagree => _isagree;

  /*
Return Type:
Input Parameters:bool
Use: Initiate value to the variable and create object.
 */
  void setIsagree(bool value) {
    _isagree = value;
    notifyListeners();
  }
}

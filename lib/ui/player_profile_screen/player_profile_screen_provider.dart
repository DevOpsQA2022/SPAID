import 'package:dio/dio.dart';
import 'package:spaid/base/base_provider.dart';
import 'package:spaid/model/request/roaster_listview_request/roaster_listview_request.dart';
import 'package:spaid/model/request/roaster_listview_request/team_members_details_request.dart';
import 'package:spaid/model/request/select_team_request/select_team_request.dart';
import 'package:spaid/model/response/edit_players_details_response/family_members_response.dart';
import 'package:spaid/model/response/player_profile_response/player_profile_response.dart';
import 'package:spaid/model/response/roaster_listview_response/team_members_details_response.dart';
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

class PlayerProfileProvider extends BaseProvider {

  //region Private Members

  bool _isagree = false;
  List<Members>? _members;
  List<Team>? _teams;
  int? _totEvents;
  bool? _autoValidate;
  GetTeamMemberDetailsRequest? _getTeamMemberDetailsRequest;
  RoasterListViewRequest? _roasterListViewRequest;

  //endregion


  /*
Return Type:
Input Parameters:
Use: setAutoValidate.
 */
  void setAutoValidate(bool value) {
    _autoValidate = true;
    notifyListeners();
  }

  bool? get getAutoValidate => _autoValidate;


  /*
Return Type:
Input Parameters:getUserDetailsUrl used
Use: getSelectTeamAsync inputs and make profile  server call.
 */

  getSelectTeamAsync(int userId, String playerRoleId) async {
  try {
    _getTeamMemberDetailsRequest = GetTeamMemberDetailsRequest();
    //_selectTeamRequest.userIdNo = 1;
    _getTeamMemberDetailsRequest!.userIDNo =userId != null?userId:int.parse( "${await SharedPrefManager.instance.getStringAsync(Constants.userIdNo)}");
    _getTeamMemberDetailsRequest!.teamIDNo =int.parse( "${await SharedPrefManager.instance.getStringAsync(Constants.teamID)}");
    _getTeamMemberDetailsRequest!.UserRoleId =playerRoleId=="player"?int.parse( "${await SharedPrefManager.instance.getStringAsync(Constants.playerRoleId)}"):int.parse( "${await SharedPrefManager.instance.getStringAsync(Constants.userRoleId)}");

    await ApiManager()
        .getDio()!
        .post(Endpoints.getTeamMember, data: _getTeamMemberDetailsRequest)
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
Input Parameters:
Use: registerResponse.
 */
  void registerResponse(Response response) {
    TeamMembersDetailsResponse _response = TeamMembersDetailsResponse.fromJson(response.data);
    listener.onSuccess(_response, reqId: ResponseIds.GET_USER_PROFILE);
  }



  /*
Return Type:
Input Parameters:getUserDetailsUrl used
Use: getSelectTeamAsync inputs and make profile  server call.
 */

  getFamilyMembers(int userId, String playerRoleId) async {
    try {
      _getTeamMemberDetailsRequest = GetTeamMemberDetailsRequest();
      //_selectTeamRequest.userIdNo = 1;
      _getTeamMemberDetailsRequest!.userIDNo =userId ;
      _getTeamMemberDetailsRequest!.teamIDNo =int.parse( "${await SharedPrefManager.instance.getStringAsync(Constants.teamID)}");
      _getTeamMemberDetailsRequest!.UserRoleId =int.parse( playerRoleId);

      await ApiManager()
          .getDio()!
          .post(Endpoints.getFamilyMembers, data: _getTeamMemberDetailsRequest)
          .then((response) => familyMembersResponse(response))
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
Use: registerResponse.
 */
  void familyMembersResponse(Response response) {
    FamilyMembersResponse _response = FamilyMembersResponse.fromJson(response.data);
    listener.onSuccess(_response, reqId: ResponseIds.GET_FAMILY_MEMBERS);
  }



  /*
Return Type:
Input Parameters:getUserDetailsUrl used
Use: getSelectTeamAsync inputs and make profile  server call.
 */

  deleteMemberAsync(int userId, int roleIdNo, int toRedirect) async {
    try {
      _getTeamMemberDetailsRequest = GetTeamMemberDetailsRequest();
      _getTeamMemberDetailsRequest!.userIDNo =userId ;
      _getTeamMemberDetailsRequest!.UserRoleId =roleIdNo ;
      _getTeamMemberDetailsRequest!.teamIDNo =int.parse( "${await SharedPrefManager.instance.getStringAsync(Constants.teamID)}");

      await ApiManager()
          .getDio()!
          .post(Endpoints.removeTeamMember, data: _getTeamMemberDetailsRequest)
          .then((response) => removeMemberResponse(response,toRedirect))
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
Use: registerResponse.
 */
  void removeMemberResponse(Response response, int toRedirect) {
    ValidateUserResponse _response = ValidateUserResponse.fromJson(response.data);
    if(toRedirect==1) {
      listener.onSuccess(_response, reqId: ResponseIds.REMOVE_PLAYER);
    }
  }


  /*
Return Type:
Input Parameters:
Use: setTeamList.
 */
  void setTeamList(List<Team> teamList) {
    _teams = teamList;
    notifyListeners();
  }

  List<Team>? get getTeamList => _teams;

  /*
Return Type:
Input Parameters:
Use: setMemberList.
 */
  void setMemberList(List<Members> memberList) {
    _members = memberList;
    // memberList.sort((a, b) => ["roleIdNo"].compareTo(b["roleIdNo"]));
    notifyListeners();
  }

  List<Members>? get getMemberList => _members;

  /*
Return Type:
Input Parameters:
Use: setTotTeam.
 */
  void setTotTeam(int totEvents) {
    _totEvents = totEvents;
    notifyListeners();
  }

  int? get getTotalEvents => _totEvents;
  bool get getIsagree => _isagree;

  /*
Return Type:
Input Parameters:
Use: setIsagree with bool value.
 */
  void setIsagree(bool value) {
    _isagree = value;
    notifyListeners();
  }
}



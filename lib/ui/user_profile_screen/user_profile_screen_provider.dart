import 'package:dio/dio.dart';
import 'package:spaid/base/base_provider.dart';
import 'package:spaid/model/request/roaster_listview_request/roaster_listview_request.dart';
import 'package:spaid/model/request/select_team_request/select_team_request.dart';
import 'package:spaid/model/response/select_team_response/select_team_response.dart';
import 'package:spaid/service/api_manager.dart';
import 'package:spaid/service/dio_error_util.dart';
import 'package:spaid/service/endpoints.dart';
import 'package:spaid/service/exception_error_util.dart';
import 'package:spaid/support/response_ids.dart';
import 'package:spaid/widgets/ProgressBar.dart';

class UserProfileProvider extends BaseProvider {

  //region Private Members

  bool _isagree = false;
  List<Members>? _members;
  List<Team>? _teams;
  int? _totEvents;
  bool? _autoValidate;
  SelectTeamRequest? _selectTeamRequest;
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

  getSelectTeamAsync(int userId) async {
    try {
      _selectTeamRequest = SelectTeamRequest();
      //_selectTeamRequest.userIdNo = userId.toString();

      await ApiManager()
          .getDio()!
          .post(Endpoints.getUserDetailsUrl, data: _selectTeamRequest)
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
    SelectTeamResponse _response = SelectTeamResponse.fromJson(response.data);
    listener.onSuccess(_response, reqId: ResponseIds.GET_USER_TEAM);
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

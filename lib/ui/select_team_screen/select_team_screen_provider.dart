import 'package:dio/dio.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:spaid/base/base_provider.dart';
import 'package:spaid/model/request/select_drill_request/share_drill_request.dart';
import 'package:spaid/model/request/select_team_request/select_team_request.dart';
import 'package:spaid/model/response/select_team_response/new_select_team_response.dart';
import 'package:spaid/model/response/select_team_response/select_team_response.dart';
import 'package:spaid/model/response/signin_response/signin_response.dart';
import 'package:spaid/service/api_manager.dart';
import 'package:spaid/service/dio_error_util.dart';
import 'package:spaid/service/endpoints.dart';
import 'package:spaid/service/exception_error_util.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/support/response_ids.dart';
import 'package:spaid/utils/code_snippet.dart';
import 'package:spaid/utils/shared_pref_manager.dart';
import 'package:spaid/widgets/ProgressBar.dart';

class SelectTeamProvider extends BaseProvider {

  //region Private Members

  bool _isagree = false;
  List<Teams>? _teams;
  int? _totEvents;
  bool? _autoValidate;
  SelectTeamRequest? _selectTeamRequest;
  BuildContext? context;
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
  getSelectTeamAsync(BuildContext context) async {
    try {
      this.context=context;


      await ApiManager()
          .getDio()!
          .post(Endpoints.getUserTeamUrl, data: int.parse( "${await SharedPrefManager.instance.getStringAsync(Constants.userIdNo)}"))
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
    if (response.data.length > 0) {
      NewSelectTeamResponse _response = NewSelectTeamResponse.fromJson(response.data);
      listener.onSuccess(_response, reqId: ResponseIds.GET_USER_TEAM);
    }else{
      ProgressBar.instance.stopProgressBar(context!);
    }
  }


  /*
Return Type:
Input Parameters:
Use: setTeamList.
 */
  void setTeamList(List<Teams> teamList) {
    _teams = teamList;
    Future.delayed(Duration.zero, () async {
      notifyListeners();
    });
  }
  void setTeamListData(Teams team) {
    if(_teams != null){
    _teams!.add(team);
    listener.onSuccess(null, reqId: ResponseIds.GET_USER_TEAM);
    Future.delayed(Duration.zero, () async {
      notifyListeners();
    });  }else{
      _teams=[];
      _teams!.add(team);
      listener.onSuccess(null, reqId: ResponseIds.GET_USER_TEAM);
      Future.delayed(Duration.zero, () async {
        notifyListeners();
      });
    }}

  List<Teams>? get getTeamList => _teams;


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
  Future<void> shareDrillToTeams(ShareDrillRequest drill, List<UserTeamList> userTeamList,) async {
    try {
      for(int i=0;i<userTeamList.length;i++){
        if(userTeamList[i].isSelect!){
          drill.sharedTeamIdNo=userTeamList[i].teamId.toString();

          await ApiManager()
              .getDio()!
              .post(Endpoints.copyDrillPlanToOtherTeam, data: drill)
              .then((response) =>     print(response)
          )
              .catchError((onError) {
            listener.onFailure(DioErrorUtil.handleErrors(onError));
          });
        }

      }


    } catch (e) {
      listener.onFailure(ExceptionErrorUtil.handleErrors(e));
    }
  }
}



